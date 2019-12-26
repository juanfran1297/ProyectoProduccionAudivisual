// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyShaders/Toon"
{
	Properties
	{
		_ShadowSoftness("ShadowSoftness", Range( 0 , 1)) = 0
		_MainColor("MainColor", Color) = (0,0,0,0)
		_ShadowTint("ShadowTint", Color) = (0,0,0,0)
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_ShadowOffset("ShadowOffset", Range( -1 , 1)) = 0
		_HighlightOffset("HighlightOffset", Range( -1 , 1)) = 0
		_HighlightTint("HighlightTint", Color) = (0,0,0,0)
		_LineColor("LineColor", Color) = (0,0,0,0)
		_FarLineWidth("FarLineWidth", Float) = 0
		_NearLineWidth("NearLineWidth", Float) = 0
		_LineWidth("LineWidth", Float) = 0.3
		_LineLerp("LineLerp", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ }
		Cull Front
		CGPROGRAM
		#pragma target 3.0
		#pragma surface outlineSurf Outline nofog  keepalpha noshadow noambient novertexlights nolightmap nodynlightmap nodirlightmap nometa noforwardadd vertex:outlineVertexDataFunc 
		void outlineVertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float cameraDepthFade34 = (( -UnityObjectToViewPos( v.vertex.xyz ).z -_ProjectionParams.y - 0.0 ) / 1.0);
			float lerpResult37 = lerp( _NearLineWidth , _FarLineWidth , saturate( ( cameraDepthFade34 / 20.0 ) ));
			float lerpResult42 = lerp( lerpResult37 , _LineWidth , _LineLerp);
			float outlineVar = lerpResult42;
			v.vertex.xyz += ( v.normal * outlineVar );
		}
		inline half4 LightingOutline( SurfaceOutput s, half3 lightDir, half atten ) { return half4 ( 0,0,0, s.Alpha); }
		void outlineSurf( Input i, inout SurfaceOutput o )
		{
			o.Emission = _LineColor.rgb;
		}
		ENDCG
		

		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform float4 _ShadowTint;
		uniform float4 _MainColor;
		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform float4 _HighlightTint;
		uniform float _HighlightOffset;
		uniform float _ShadowSoftness;
		uniform float _ShadowOffset;
		uniform float _NearLineWidth;
		uniform float _FarLineWidth;
		uniform float _LineWidth;
		uniform float _LineLerp;
		uniform float4 _LineColor;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			v.vertex.xyz += 0;
		}

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			#ifdef UNITY_PASS_FORWARDBASE
			float ase_lightAtten = data.atten;
			if( _LightColor0.a == 0)
			ase_lightAtten = 0;
			#else
			float3 ase_lightAttenRGB = gi.light.color / ( ( _LightColor0.rgb ) + 0.000001 );
			float ase_lightAtten = max( max( ase_lightAttenRGB.r, ase_lightAttenRGB.g ), ase_lightAttenRGB.b );
			#endif
			#if defined(HANDLE_SHADOWS_BLENDING_IN_GI)
			half bakedAtten = UnitySampleBakedOcclusion(data.lightmapUV.xy, data.worldPos);
			float zDist = dot(_WorldSpaceCameraPos - data.worldPos, UNITY_MATRIX_V[2].xyz);
			float fadeDist = UnityComputeShadowFadeDistance(data.worldPos, zDist);
			ase_lightAtten = UnityMixRealtimeAndBakedShadows(data.atten, bakedAtten, UnityComputeShadowFade(fadeDist));
			#endif
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float4 temp_output_18_0 = ( _MainColor * tex2D( _TextureSample0, uv_TextureSample0 ) * float4( ase_lightColor.rgb , 0.0 ) );
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float3 ase_worldNormal = i.worldNormal;
			float dotResult3 = dot( ase_worldlightDir , ase_worldNormal );
			float temp_output_30_0 = ( dotResult3 * ase_lightAtten );
			float4 lerpResult27 = lerp( float4( 0,0,0,0 ) , _HighlightTint , saturate( ( ( _HighlightOffset + temp_output_30_0 ) / _ShadowSoftness ) ));
			float4 lerpResult13 = lerp( ( _ShadowTint * temp_output_18_0 ) , ( temp_output_18_0 + lerpResult27 ) , saturate( ( ( _ShadowOffset + temp_output_30_0 ) / _ShadowSoftness ) ));
			c.rgb = lerpResult13.rgb;
			c.a = 1;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows exclude_path:deferred vertex:vertexDataFunc 

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
				float3 worldPos : TEXCOORD2;
				float3 worldNormal : TEXCOORD3;
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
				o.worldNormal = worldNormal;
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
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
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
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
Version=17400
2524;27;966;938;1420.36;749.9585;2.821321;False;False
Node;AmplifyShaderEditor.WorldNormalVector;2;-1422.503,812.5576;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;1;-1474.602,673.7578;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;3;-1052.14,741.0815;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightAttenuation;29;-1116.094,858.7075;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-942.7383,517.3709;Inherit;False;Property;_HighlightOffset;HighlightOffset;5;0;Create;True;0;0;False;0;0;-1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-886.4639,777.499;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CameraDepthFade;34;54.21581,616.7908;Inherit;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;110.1933,766.8483;Inherit;False;Constant;_Float0;Float 0;9;0;Create;True;0;0;False;0;20;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;22;-624.4411,529.8825;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-866.8566,981.0554;Inherit;False;Property;_ShadowSoftness;ShadowSoftness;0;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-945.2156,619.9935;Inherit;False;Property;_ShadowOffset;ShadowOffset;4;0;Create;True;0;0;False;0;0;-0.03667854;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;23;-424.3091,583.8539;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;35;336.176,675.9885;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;20;-626.7957,670.4525;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;25;-255.5136,159.5221;Inherit;False;Property;_HighlightTint;HighlightTint;6;0;Create;True;0;0;False;0;0,0,0,0;0,0.8831952,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;14;-613.9183,-173.4967;Inherit;False;Property;_MainColor;MainColor;1;0;Create;True;0;0;False;0;0,0,0,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;17;-663.3188,50.70329;Inherit;True;Property;_TextureSample0;Texture Sample 0;3;0;Create;True;0;0;False;0;-1;None;0000000000000000f000000000000000;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;38;484.4559,592.9938;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;355.0434,505.1155;Inherit;False;Property;_FarLineWidth;FarLineWidth;8;0;Create;True;0;0;False;0;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;39;354.3067,426.9075;Inherit;False;Property;_NearLineWidth;NearLineWidth;9;0;Create;True;0;0;False;0;0;0.005;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;28;-622.6938,250.924;Inherit;True;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SaturateNode;24;-261.0304,582.3828;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;43;603.33,687.9325;Inherit;False;Property;_LineLerp;LineLerp;11;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;37;699.8247,454.608;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;41;690.0685,585.1462;Inherit;False;Property;_LineWidth;LineWidth;10;0;Create;True;0;0;False;0;0.3;0.02;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;27;20.69088,151.5085;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;4;-411.5574,818.7316;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-320.016,-65.7634;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;16;-612.0189,-435.6961;Inherit;False;Property;_ShadowTint;ShadowTint;2;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;26;235.1529,7.917682;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-117.6944,-188.6266;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;42;891.8303,482.7326;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;6;-259.0569,818.4236;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;32;453.6297,237.586;Inherit;False;Property;_LineColor;LineColor;7;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;13;618.7043,-101.8037;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OutlineNode;31;952.7079,284.2195;Inherit;False;0;True;None;0;0;Front;3;0;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1142.968,-331.5594;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;MyShaders/Toon;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0.04;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;3;0;1;0
WireConnection;3;1;2;0
WireConnection;30;0;3;0
WireConnection;30;1;29;0
WireConnection;22;0;21;0
WireConnection;22;1;30;0
WireConnection;23;0;22;0
WireConnection;23;1;5;0
WireConnection;35;0;34;0
WireConnection;35;1;36;0
WireConnection;20;0;19;0
WireConnection;20;1;30;0
WireConnection;38;0;35;0
WireConnection;24;0;23;0
WireConnection;37;0;39;0
WireConnection;37;1;33;0
WireConnection;37;2;38;0
WireConnection;27;1;25;0
WireConnection;27;2;24;0
WireConnection;4;0;20;0
WireConnection;4;1;5;0
WireConnection;18;0;14;0
WireConnection;18;1;17;0
WireConnection;18;2;28;1
WireConnection;26;0;18;0
WireConnection;26;1;27;0
WireConnection;15;0;16;0
WireConnection;15;1;18;0
WireConnection;42;0;37;0
WireConnection;42;1;41;0
WireConnection;42;2;43;0
WireConnection;6;0;4;0
WireConnection;13;0;15;0
WireConnection;13;1;26;0
WireConnection;13;2;6;0
WireConnection;31;0;32;0
WireConnection;31;1;42;0
WireConnection;0;13;13;0
WireConnection;0;11;31;0
ASEEND*/
//CHKSM=C5F36F84170E2B9F512B967AE05C06A5072C1647