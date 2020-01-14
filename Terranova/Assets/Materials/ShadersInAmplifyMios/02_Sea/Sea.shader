// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyShaders/Sea"
{
	Properties
	{
		_WaveDirection("Wave Direction", Vector) = (0,0,0,0)
		_WaveSpeed("Wave Speed", Float) = 0
		_WaveTile("Wave Tile", Float) = 0
		_WaveStretch("Wave Stretch", Vector) = (0.07,1,0,0)
		_Tesselation("Tesselation", Float) = 0
		_Smoothness("Smoothness", Float) = 0
		_WaveUp("Wave Up", Vector) = (0,0,0,0)
		_WaveHeight("Wave Height", Float) = 1
		_WaterColor("Water Color", Color) = (0,0,0,0)
		_TopColor("Top Color", Color) = (0,0,0,0)
		_EdgeDistance("Edge Distance", Float) = 0
		_EdgePower("Edge Power", Float) = 1
		_NormalMap("Normal Map", 2D) = "bump" {}
		_NormalTile("Normal Tile", Float) = 1
		_PanDirection("Pan Direction", Vector) = (0,0,0,0)
		_PanDirection2("Pan Direction2", Vector) = (0,0,0,0)
		_NormalSpeed("Normal Speed", Float) = 0
		_NormalStrength("Normal Strength", Range( 0 , 1)) = 0
		_SeaForm("Sea Form", 2D) = "white" {}
		_EdgeFoamTile("Edge Foam Tile", Float) = 0
		_SeaFoamTile("Sea Foam Tile", Float) = 0
		_RefractAmount("Refract Amount", Float) = 0
		_Depth("Depth", Float) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Off
		GrabPass{ }
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#include "UnityCG.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
		#pragma surface surf Standard keepalpha noshadow vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float3 worldPos;
			float4 screenPos;
		};

		uniform float3 _WaveUp;
		uniform float _WaveHeight;
		uniform float _WaveSpeed;
		uniform float2 _WaveDirection;
		uniform float2 _WaveStretch;
		uniform float _WaveTile;
		uniform sampler2D _NormalMap;
		uniform float _NormalStrength;
		uniform float2 _PanDirection;
		uniform float _NormalSpeed;
		uniform float _NormalTile;
		uniform float2 _PanDirection2;
		uniform float4 _WaterColor;
		uniform float4 _TopColor;
		uniform sampler2D _SeaForm;
		uniform float _SeaFoamTile;
		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform float _RefractAmount;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _Depth;
		uniform float _EdgeDistance;
		uniform float _EdgeFoamTile;
		uniform float _EdgePower;
		uniform float _Smoothness;
		uniform float _Tesselation;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		inline float4 ASE_ComputeGrabScreenPos( float4 pos )
		{
			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif
			float4 o = pos;
			o.y = pos.w * 0.5f;
			o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
			return o;
		}


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			float4 Tesselation139 = UnityDistanceBasedTess( v0.vertex, v1.vertex, v2.vertex, 0.0,80.0,( _WaveHeight * _Tesselation ));
			return Tesselation139;
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float temp_output_9_0 = ( _Time.y * _WaveSpeed );
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float4 appendResult11 = (float4(ase_worldPos.x , ase_worldPos.z , 0.0 , 0.0));
			float4 WorldSpace12 = appendResult11;
			float4 WaveTileUv22 = ( ( WorldSpace12 * float4( _WaveStretch, 0.0 , 0.0 ) ) * _WaveTile );
			float2 panner4 = ( temp_output_9_0 * _WaveDirection + WaveTileUv22.xy);
			float simplePerlin2D1 = snoise( panner4 );
			simplePerlin2D1 = simplePerlin2D1*0.5 + 0.5;
			float2 panner24 = ( temp_output_9_0 * _WaveDirection + ( WaveTileUv22 * float4( 0.1,0.1,0,0 ) ).xy);
			float simplePerlin2D25 = snoise( panner24 );
			simplePerlin2D25 = simplePerlin2D25*0.5 + 0.5;
			float temp_output_29_0 = ( simplePerlin2D1 + simplePerlin2D25 );
			half3 WaveHeight34 = ( ( _WaveUp * _WaveHeight ) * temp_output_29_0 );
			v.vertex.xyz += WaveHeight34;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float4 appendResult11 = (float4(ase_worldPos.x , ase_worldPos.z , 0.0 , 0.0));
			float4 WorldSpace12 = appendResult11;
			float4 temp_output_81_0 = ( WorldSpace12 / 10.0 );
			float2 panner67 = ( 1.0 * _Time.y * ( _PanDirection * _NormalSpeed ) + ( temp_output_81_0 * _NormalTile ).xy);
			float2 panner68 = ( 1.0 * _Time.y * ( ( _NormalSpeed * 3.0 ) * _PanDirection2 ) + ( temp_output_81_0 * ( _NormalTile * 5.0 ) ).xy);
			float3 Normals77 = BlendNormals( UnpackScaleNormal( tex2D( _NormalMap, panner67 ), _NormalStrength ) , UnpackScaleNormal( tex2D( _NormalMap, panner68 ), _NormalStrength ) );
			o.Normal = Normals77;
			float2 panner105 = ( 1.0 * _Time.y * float2( 0.05,0.05 ) + ( WorldSpace12 * 0.05 ).xy);
			float simplePerlin2D104 = snoise( panner105 );
			simplePerlin2D104 = simplePerlin2D104*0.5 + 0.5;
			float clampResult112 = clamp( ( tex2D( _SeaForm, ( ( WorldSpace12 / 10.0 ) * _SeaFoamTile ).xy ).r * simplePerlin2D104 ) , 0.0 , 1.0 );
			float SeaFoam101 = clampResult112;
			float temp_output_9_0 = ( _Time.y * _WaveSpeed );
			float4 WaveTileUv22 = ( ( WorldSpace12 * float4( _WaveStretch, 0.0 , 0.0 ) ) * _WaveTile );
			float2 panner4 = ( temp_output_9_0 * _WaveDirection + WaveTileUv22.xy);
			float simplePerlin2D1 = snoise( panner4 );
			simplePerlin2D1 = simplePerlin2D1*0.5 + 0.5;
			float2 panner24 = ( temp_output_9_0 * _WaveDirection + ( WaveTileUv22 * float4( 0.1,0.1,0,0 ) ).xy);
			float simplePerlin2D25 = snoise( panner24 );
			simplePerlin2D25 = simplePerlin2D25*0.5 + 0.5;
			float temp_output_29_0 = ( simplePerlin2D1 + simplePerlin2D25 );
			float WavePattern31 = temp_output_29_0;
			float clampResult44 = clamp( WavePattern31 , 0.0 , 1.0 );
			float4 lerpResult42 = lerp( _WaterColor , ( _TopColor + SeaFoam101 ) , clampResult44);
			float4 Albedo45 = lerpResult42;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float4 screenColor120 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( float3( (ase_grabScreenPosNorm).xy ,  0.0 ) + ( _RefractAmount * Normals77 ) ).xy);
			float4 clampResult121 = clamp( screenColor120 , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			float4 Refraction122 = clampResult121;
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth125 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth125 = abs( ( screenDepth125 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _Depth ) );
			float clampResult128 = clamp( ( 1.0 - distanceDepth125 ) , 0.0 , 1.0 );
			float Depth129 = clampResult128;
			float4 lerpResult131 = lerp( Albedo45 , Refraction122 , Depth129);
			o.Albedo = lerpResult131.rgb;
			float screenDepth48 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth48 = abs( ( screenDepth48 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _EdgeDistance ) );
			float4 clampResult55 = clamp( ( ( ( 1.0 - distanceDepth48 ) + tex2D( _SeaForm, ( ( WorldSpace12 / 10.0 ) * _EdgeFoamTile ).xy ) ) * _EdgePower ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			float4 Edge53 = clampResult55;
			o.Emission = Edge53.rgb;
			o.Smoothness = _Smoothness;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17500
624;73;1294;938;1455.705;2021.985;2.796805;True;False
Node;AmplifyShaderEditor.CommentaryNode;13;-1528.055,-1090.833;Inherit;False;713.0408;270.6566;Comment;3;10;12;11;World Space UVs;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;10;-1478.054,-1040.834;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;11;-1243.734,-999.1771;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;36;-1526.15,-688.5521;Inherit;False;2079.539;494.7237;Comment;11;14;16;18;15;17;22;20;32;21;33;34;Wave UVs and Height;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;12;-1058.01,-993.97;Float;False;WorldSpace;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;14;-1476.15,-607.9005;Inherit;False;12;WorldSpace;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;83;-1660.11,-3726.419;Inherit;False;2174.954;918.1588;Comment;21;77;72;73;70;69;66;71;74;76;68;67;61;60;75;59;64;65;63;81;82;62;Normal Map;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;16;-1473.955,-496.6465;Inherit;False;Property;_WaveStretch;Wave Stretch;3;0;Create;True;0;0;False;0;0.07,1;0.07,0.23;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;18;-1209.429,-439.5501;Inherit;False;Property;_WaveTile;Wave Tile;2;0;Create;True;0;0;False;0;0;0.52;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-1209.807,-576.4135;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;62;-1561.517,-3657.648;Inherit;False;12;WorldSpace;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;72;-1202.067,-3515.086;Inherit;False;Property;_NormalSpeed;Normal Speed;16;0;Create;True;0;0;False;0;0;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;64;-1520.137,-3013.462;Inherit;False;Property;_NormalTile;Normal Tile;13;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;82;-1610.11,-3102.156;Inherit;False;Constant;_Float0;Float 0;18;0;Create;True;0;0;False;0;10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;113;-1188.591,-2022.667;Inherit;False;1735.422;485.769;Comment;14;101;112;108;96;99;98;97;100;94;111;107;106;105;104;Sea Foam;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;70;-1026.919,-2975.202;Inherit;False;Property;_PanDirection2;Pan Direction2;15;0;Create;True;0;0;False;0;0,0;0,1.86;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;69;-1201.115,-3654.607;Inherit;False;Property;_PanDirection;Pan Direction;14;0;Create;True;0;0;False;0;0,0;0,-0.55;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;73;-904.6171,-3269.096;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-964.7057,-523.4666;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;-1222.089,-2941.26;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;81;-1450.714,-3120.056;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;-1008.74,-3109.863;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;56;-1469.384,-2688.975;Inherit;False;2018.611;605.0614;Comment;9;50;48;49;53;55;52;51;91;93;Edge;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;71;-977.4705,-3583.067;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;74;-801.6207,-3033.882;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;37;-1302.446,-113.4747;Inherit;False;1867.719;627.2169;Comment;13;30;7;8;23;28;9;6;4;24;25;1;29;31;Wave Pattern;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;-1226.158,-3072.643;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;96;-1091.074,-1880.428;Inherit;False;Constant;_Float2;Float 2;20;0;Create;True;0;0;False;0;10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;99;-1137.367,-1972.668;Inherit;False;12;WorldSpace;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;22;-718.4249,-526.1138;Float;False;WaveTileUv;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;108;-1103.43,-1651.899;Inherit;False;Constant;_FoamMask;Foam Mask;21;0;Create;True;0;0;False;0;0.05;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;107;-1138.591,-1753.511;Inherit;False;12;WorldSpace;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;106;-872.407,-1724.254;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleTimeNode;7;-1252.446,102.2594;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;59;-1264.03,-3416.066;Inherit;True;Property;_NormalMap;Normal Map;12;0;Create;True;0;0;False;0;None;a53cf5449d11a15d1100a04b44295342;True;bump;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;98;-881.2682,-1946.667;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-1249.084,196.909;Inherit;False;Property;_WaveSpeed;Wave Speed;1;0;Create;True;0;0;False;0;0;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;67;-634.8208,-3676.419;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;30;-993.4024,290.5687;Inherit;False;22;WaveTileUv;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;93;-1465.595,-2455.432;Inherit;False;1097.502;368.8865;Comment;7;85;87;89;84;86;90;88;Edge Foam;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;76;-706.4695,-3293.223;Inherit;False;Property;_NormalStrength;Normal Strength;17;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;97;-900.0673,-1851.57;Inherit;False;Property;_SeaFoamTile;Sea Foam Tile;20;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;68;-619.5715,-3111.421;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;84;-1023.237,-2395.84;Inherit;True;Property;_SeaForm;Sea Form;18;0;Create;True;0;0;False;0;None;None;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.GetLocalVarNode;23;-823.2545,-63.47473;Inherit;False;22;WaveTileUv;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;61;-385.2067,-3428.38;Inherit;True;Property;_TextureSample4;Texture Sample 4;8;0;Create;True;0;0;False;0;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-722.5032,313.3505;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0.1,0.1,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector2Node;6;-1069.218,-0.6585875;Inherit;False;Property;_WaveDirection;Wave Direction;0;0;Create;True;0;0;False;0;0,0;0,0.4;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;105;-653.2481,-1736.118;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.05,0.05;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;100;-636.8672,-1906.367;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;60;-388.7831,-3225.907;Inherit;True;Property;_TextureSample1;Texture Sample 1;8;0;Create;True;0;0;False;0;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-1011.744,142.2449;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;4;-506.9725,-15.51633;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;24;-480.5637,259.6682;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;104;-354.4224,-1739.832;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;94;-451.9954,-1965.409;Inherit;True;Property;_TextureSample6;Texture Sample 6;20;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendNormalsNode;75;9.108215,-3309.068;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;124;-902.761,-4198.786;Inherit;False;1402.937;431.4409;Comment;9;117;122;121;120;119;115;116;114;118;Refraction;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;86;-1436.189,-2264.852;Inherit;False;12;WorldSpace;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;90;-1389.897,-2172.611;Inherit;False;Constant;_Float1;Float 1;20;0;Create;True;0;0;False;0;10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;25;-237.4828,255.7422;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;1;-246.6915,-19.11116;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;77;271.8432,-3314.347;Float;False;Normals;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;111;-66.1946,-1820.399;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-1084.434,-2551.353;Inherit;False;Property;_EdgeDistance;Edge Distance;10;0;Create;True;0;0;False;0;0;1.92;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;88;-1197.289,-2182.155;Inherit;False;Property;_EdgeFoamTile;Edge Foam Tile;19;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;29;93.73832,150.9216;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;135;-652.176,-4440.174;Inherit;False;1147.966;212.021;Comment;5;126;125;134;128;129;Depth;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;89;-1194.49,-2282.052;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;118;-744.5373,-3882.345;Inherit;False;77;Normals;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ClampOpNode;112;117.0447,-1820.32;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;116;-757.5373,-3964.345;Inherit;False;Property;_RefractAmount;Refract Amount;21;0;Create;True;0;0;False;0;0;0.03;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GrabScreenPosition;114;-852.761,-4148.786;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;117;-497.5373,-3937.345;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;101;303.8311,-1825.565;Float;False;SeaFoam;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;126;-602.176,-4367.226;Inherit;False;Property;_Depth;Depth;22;0;Create;True;0;0;False;0;0;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;48;-809.1252,-2568.917;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;115;-565.5372,-4059.344;Inherit;False;True;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;87;-935.6882,-2198.551;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;47;-662.2184,-1458.955;Inherit;False;1207.514;637.0034;Comment;8;45;44;43;42;103;41;40;102;Water Albedo;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;31;322.271,137.284;Float;False;WavePattern;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;50;-543.2859,-2569.018;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;85;-673.0863,-2314.25;Inherit;True;Property;_TextureSample5;Texture Sample 5;19;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;119;-304.5375,-4005.345;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;142;697.2344,-422.738;Inherit;False;1030.623;355.5336;Comment;6;136;138;137;139;19;141;Tesselation;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;102;-564.9669,-1044.879;Inherit;False;101;SeaFoam;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;125;-396.4065,-4384.584;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;40;-612.2184,-1235.753;Inherit;False;Property;_TopColor;Top Color;9;0;Create;True;0;0;False;0;0,0,0,0;0.282353,0.682353,0.8039216,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;43;-600.4456,-938.0765;Inherit;False;31;WavePattern;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;41;-611.0386,-1408.955;Inherit;False;Property;_WaterColor;Water Color;8;0;Create;True;0;0;False;0;0,0,0,0;0.2431373,0.5333334,0.6941177,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;134;-129.7187,-4384.051;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;52;-288.0927,-2404.135;Inherit;False;Property;_EdgePower;Edge Power;11;0;Create;True;0;0;False;0;1;0.27;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;20;-480.7969,-638.5521;Inherit;False;Property;_WaveUp;Wave Up;6;0;Create;True;0;0;False;0;0,0,0;0,0.77,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;91;-275.2038,-2515.892;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-469.5886,-474.0048;Inherit;False;Property;_WaveHeight;Wave Height;7;0;Create;True;0;0;False;0;1;0.42;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;103;-314.8972,-1125.982;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScreenColorNode;120;-145.9238,-4009.869;Inherit;False;Global;_GrabScreen0;Grab Screen 0;22;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;19;747.2344,-274.7692;Inherit;False;Property;_Tesselation;Tesselation;4;0;Create;True;0;0;False;0;0;8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;44;-310.0753,-968.3403;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;137;998.1998,-262.2044;Inherit;False;Constant;_Float3;Float 3;24;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;138;994.2,-182.2045;Inherit;False;Constant;_Float4;Float 4;24;0;Create;True;0;0;False;0;80;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;121;71.97604,-4002.571;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;141;996.0807,-372.738;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;128;53.46551,-4384.153;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-197.8276,-574.6794;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;42;-43.06366,-1223.143;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;-82.11197,-2472.399;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;129.7092,-326.8283;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;129;252.7902,-4390.174;Float;False;Depth;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;122;257.176,-4005.773;Float;False;Refraction;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DistanceBasedTessNode;136;1178.364,-298.3625;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ClampOpNode;55;128.7425,-2471.327;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;45;315.9337,-1229.188;Float;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;34;310.3893,-335.1382;Half;False;WaveHeight;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;46;924.549,-1460.182;Inherit;False;45;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;132;912.5026,-1374.353;Inherit;False;122;Refraction;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;133;926.7887,-1294.139;Inherit;False;129;Depth;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;139;1484.858,-300.9889;Inherit;False;Tesselation;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;53;316.3643,-2476.682;Inherit;False;Edge;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;54;1115.638,-1174.476;Inherit;False;53;Edge;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;35;1097.825,-979.6694;Inherit;False;34;WaveHeight;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;140;1100.611,-896.6076;Inherit;False;139;Tesselation;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;38;1125.377,-1080.771;Inherit;False;Property;_Smoothness;Smoothness;5;0;Create;True;0;0;False;0;0;0.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;79;1118.661,-1260.469;Inherit;False;77;Normals;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;131;1139.163,-1392.365;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1377.949,-1262.081;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;MyShaders/Sea;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;False;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;False;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;11;0;10;1
WireConnection;11;1;10;3
WireConnection;12;0;11;0
WireConnection;15;0;14;0
WireConnection;15;1;16;0
WireConnection;73;0;72;0
WireConnection;17;0;15;0
WireConnection;17;1;18;0
WireConnection;65;0;64;0
WireConnection;81;0;62;0
WireConnection;81;1;82;0
WireConnection;66;0;81;0
WireConnection;66;1;65;0
WireConnection;71;0;69;0
WireConnection;71;1;72;0
WireConnection;74;0;73;0
WireConnection;74;1;70;0
WireConnection;63;0;81;0
WireConnection;63;1;64;0
WireConnection;22;0;17;0
WireConnection;106;0;107;0
WireConnection;106;1;108;0
WireConnection;98;0;99;0
WireConnection;98;1;96;0
WireConnection;67;0;63;0
WireConnection;67;2;71;0
WireConnection;68;0;66;0
WireConnection;68;2;74;0
WireConnection;61;0;59;0
WireConnection;61;1;67;0
WireConnection;61;5;76;0
WireConnection;28;0;30;0
WireConnection;105;0;106;0
WireConnection;100;0;98;0
WireConnection;100;1;97;0
WireConnection;60;0;59;0
WireConnection;60;1;68;0
WireConnection;60;5;76;0
WireConnection;9;0;7;0
WireConnection;9;1;8;0
WireConnection;4;0;23;0
WireConnection;4;2;6;0
WireConnection;4;1;9;0
WireConnection;24;0;28;0
WireConnection;24;2;6;0
WireConnection;24;1;9;0
WireConnection;104;0;105;0
WireConnection;94;0;84;0
WireConnection;94;1;100;0
WireConnection;75;0;61;0
WireConnection;75;1;60;0
WireConnection;25;0;24;0
WireConnection;1;0;4;0
WireConnection;77;0;75;0
WireConnection;111;0;94;1
WireConnection;111;1;104;0
WireConnection;29;0;1;0
WireConnection;29;1;25;0
WireConnection;89;0;86;0
WireConnection;89;1;90;0
WireConnection;112;0;111;0
WireConnection;117;0;116;0
WireConnection;117;1;118;0
WireConnection;101;0;112;0
WireConnection;48;0;49;0
WireConnection;115;0;114;0
WireConnection;87;0;89;0
WireConnection;87;1;88;0
WireConnection;31;0;29;0
WireConnection;50;0;48;0
WireConnection;85;0;84;0
WireConnection;85;1;87;0
WireConnection;119;0;115;0
WireConnection;119;1;117;0
WireConnection;125;0;126;0
WireConnection;134;0;125;0
WireConnection;91;0;50;0
WireConnection;91;1;85;0
WireConnection;103;0;40;0
WireConnection;103;1;102;0
WireConnection;120;0;119;0
WireConnection;44;0;43;0
WireConnection;121;0;120;0
WireConnection;141;0;32;0
WireConnection;141;1;19;0
WireConnection;128;0;134;0
WireConnection;21;0;20;0
WireConnection;21;1;32;0
WireConnection;42;0;41;0
WireConnection;42;1;103;0
WireConnection;42;2;44;0
WireConnection;51;0;91;0
WireConnection;51;1;52;0
WireConnection;33;0;21;0
WireConnection;33;1;29;0
WireConnection;129;0;128;0
WireConnection;122;0;121;0
WireConnection;136;0;141;0
WireConnection;136;1;137;0
WireConnection;136;2;138;0
WireConnection;55;0;51;0
WireConnection;45;0;42;0
WireConnection;34;0;33;0
WireConnection;139;0;136;0
WireConnection;53;0;55;0
WireConnection;131;0;46;0
WireConnection;131;1;132;0
WireConnection;131;2;133;0
WireConnection;0;0;131;0
WireConnection;0;1;79;0
WireConnection;0;2;54;0
WireConnection;0;4;38;0
WireConnection;0;11;35;0
WireConnection;0;14;140;0
ASEEND*/
//CHKSM=159DF9EC1943447B49481EE26B28D6C0E31D1E70