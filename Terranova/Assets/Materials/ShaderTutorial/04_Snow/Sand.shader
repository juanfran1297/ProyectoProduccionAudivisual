// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyShaders/Sand"
{
	Properties
	{
		_RockNormal("RockNormal", 2D) = "bump" {}
		_SnowNormal("SnowNormal", 2D) = "bump" {}
		_Metallic("Metallic", Range( 0 , 1)) = 0
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		_SnowControl("SnowControl", Range( 0 , 3)) = 0
		_SnowAlbedo("SnowAlbedo", 2D) = "white" {}
		_SnowHeight("SnowHeight", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform float _SnowHeight;
		uniform sampler2D _RockNormal;
		uniform float4 _RockNormal_ST;
		uniform sampler2D _SnowNormal;
		uniform float4 _SnowNormal_ST;
		uniform float _SnowControl;
		uniform sampler2D _SnowAlbedo;
		uniform float4 _SnowAlbedo_ST;
		uniform float _Metallic;
		uniform float _Smoothness;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertexNormal = v.normal.xyz;
			float2 uv_RockNormal = v.texcoord * _RockNormal_ST.xy + _RockNormal_ST.zw;
			float2 uv_SnowNormal = v.texcoord * _SnowNormal_ST.xy + _SnowNormal_ST.zw;
			float3 ase_worldNormal = UnityObjectToWorldNormal( v.normal );
			float3 lerpResult9 = lerp( UnpackNormal( tex2Dlod( _RockNormal, float4( uv_RockNormal, 0, 0.0) ) ) , UnpackNormal( tex2Dlod( _SnowNormal, float4( uv_SnowNormal, 0, 0.0) ) ) , saturate( ( ase_worldNormal.y * _SnowControl ) ));
			float3 ase_worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
			float3x3 tangentToWorld = CreateTangentToWorldPerVertex( ase_worldNormal, ase_worldTangent, v.tangent.w );
			float3 tangentNormal12 = lerpResult9;
			float3 modWorldNormal12 = (tangentToWorld[0] * tangentNormal12.x + tangentToWorld[1] * tangentNormal12.y + tangentToWorld[2] * tangentNormal12.z);
			float temp_output_14_0 = ( modWorldNormal12.y * _SnowControl );
			float3 lerpResult20 = lerp( float3( 0,0,0 ) , ( ase_vertexNormal * _SnowHeight ) , saturate( (0.0 + (temp_output_14_0 - 0.0) * (1.0 - 0.0) / (3.0 - 0.0)) ));
			v.vertex.xyz += lerpResult20;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_RockNormal = i.uv_texcoord * _RockNormal_ST.xy + _RockNormal_ST.zw;
			float2 uv_SnowNormal = i.uv_texcoord * _SnowNormal_ST.xy + _SnowNormal_ST.zw;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 lerpResult9 = lerp( UnpackNormal( tex2D( _RockNormal, uv_RockNormal ) ) , UnpackNormal( tex2D( _SnowNormal, uv_SnowNormal ) ) , saturate( ( ase_worldNormal.y * _SnowControl ) ));
			o.Normal = lerpResult9;
			float2 uv_SnowAlbedo = i.uv_texcoord * _SnowAlbedo_ST.xy + _SnowAlbedo_ST.zw;
			float4 tex2DNode10 = tex2D( _SnowAlbedo, uv_SnowAlbedo );
			float temp_output_14_0 = ( (WorldNormalVector( i , lerpResult9 )).y * _SnowControl );
			float4 lerpResult13 = lerp( tex2DNode10 , tex2DNode10 , saturate( temp_output_14_0 ));
			o.Albedo = lerpResult13.rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Smoothness;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17500
1054.4;73.6;480;722;725.6571;188.7383;2.126778;False;False
Node;AmplifyShaderEditor.WorldNormalVector;5;-1469.673,-154.8308;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;7;-1594.308,55.47369;Inherit;False;Property;_SnowControl;SnowControl;4;0;Create;True;0;0;False;0;0;0.34;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-1237.542,-58.47426;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;8;-1064.346,-8.033919;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;11;-1316.187,464.9886;Inherit;True;Property;_SnowNormal;SnowNormal;1;0;Create;True;0;0;False;0;-1;None;24e31ecbf813d9e49bf7a1e0d4034916;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-1317.661,222.7343;Inherit;True;Property;_RockNormal;RockNormal;0;0;Create;True;0;0;False;0;-1;None;0bebe40e9ebbecc48b8e9cfea982da7e;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;9;-808.1255,197.8185;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldNormalVector;12;-537.8087,11.62694;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-254.3206,106.123;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-575.3074,579.4723;Inherit;False;Property;_SnowHeight;SnowHeight;6;0;Create;True;0;0;False;0;0;1.66;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;18;-616.7855,415.9987;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;21;-174.5051,229.8448;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;3;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-277.6396,496.5159;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;15;-50.20938,106.123;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;22;14.66382,271.882;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;10;-179.2753,-444.655;Inherit;True;Property;_SnowAlbedo;SnowAlbedo;5;0;Create;True;0;0;False;0;-1;None;9cbffff42bb662f4d8e99cf0788e0c36;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;20;200.5805,364.7608;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;13;204.9298,-457.073;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;3;223.5831,-45.54794;Inherit;False;Property;_Metallic;Metallic;2;0;Create;True;0;0;False;0;0;0.544;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;220.8368,46.30437;Inherit;False;Property;_Smoothness;Smoothness;3;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;623.6733,-266.4786;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;MyShaders/Sand;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;6;0;5;2
WireConnection;6;1;7;0
WireConnection;8;0;6;0
WireConnection;9;0;2;0
WireConnection;9;1;11;0
WireConnection;9;2;8;0
WireConnection;12;0;9;0
WireConnection;14;0;12;2
WireConnection;14;1;7;0
WireConnection;21;0;14;0
WireConnection;16;0;18;0
WireConnection;16;1;17;0
WireConnection;15;0;14;0
WireConnection;22;0;21;0
WireConnection;20;1;16;0
WireConnection;20;2;22;0
WireConnection;13;0;10;0
WireConnection;13;1;10;0
WireConnection;13;2;15;0
WireConnection;0;0;13;0
WireConnection;0;1;9;0
WireConnection;0;3;3;0
WireConnection;0;4;4;0
WireConnection;0;11;20;0
ASEEND*/
//CHKSM=2825FCBAFFC595B1FE96DDD8C9D139F19CD5E7C4