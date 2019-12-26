// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyShaders/Grass"
{
	Properties
	{
		_GrassColor("GrassColor", Color) = (0,0,0,0)
		_Metallic("Metallic", Range( 0 , 1)) = 0
		_Soothness("Soothness", Range( 0 , 1)) = 0
		_WindSpeed("WindSpeed", Float) = 0
		_WindStrength("WindStrength", Float) = 0
		_HeightMask("HeightMask", Float) = 0
		_WindWaveScale("WindWaveScale", Float) = 0
		_DissolveTexture("DissolveTexture", 2D) = "white" {}
		_MaskScrollSpeed("MaskScrollSpeed", Float) = 0
		_NoiseUVScale("NoiseUVScale", Float) = 0
		_PlayerPosition("PlayerPosition", Vector) = (0,0,0,0)
		_PlayerRadius("PlayerRadius", Float) = 0
		_PlayerPushStrength("PlayerPushStrength", Float) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
		};

		uniform float _WindSpeed;
		uniform float _WindWaveScale;
		uniform float _WindStrength;
		uniform float _HeightMask;
		uniform sampler2D _DissolveTexture;
		uniform float _MaskScrollSpeed;
		uniform float _NoiseUVScale;
		uniform float _PlayerPushStrength;
		uniform float3 _PlayerPosition;
		uniform float _PlayerRadius;
		uniform float4 _GrassColor;
		uniform float _Metallic;
		uniform float _Soothness;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float mulTime5 = _Time.y * _WindSpeed;
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float temp_output_15_0 = saturate( ( ase_worldPos.y * _HeightMask ) );
			float temp_output_16_0 = ( temp_output_15_0 * temp_output_15_0 );
			float2 appendResult26 = (float2(_MaskScrollSpeed , 0.0));
			float2 appendResult22 = (float2(ase_worldPos.x , ase_worldPos.z));
			float2 panner24 = ( _Time.y * appendResult26 + ( appendResult22 * _NoiseUVScale ));
			float3 appendResult9 = (float3(( sin( ( mulTime5 + ( _WindWaveScale * ase_worldPos.x ) ) ) * _WindStrength * temp_output_16_0 * (0.0 + (tex2Dlod( _DissolveTexture, float4( panner24, 0, 0.0) ).r - 0.0) * (1.0 - 0.0) / (1.0 - 0.0)) ) , 0.0 , 0.0));
			float temp_output_38_0 = ( 1.0 - saturate( ( distance( ase_worldPos , _PlayerPosition ) / _PlayerRadius ) ) );
			float3 lerpResult44 = lerp( appendResult9 , ( ( _PlayerPushStrength * ( ase_worldPos - _PlayerPosition ) ) * temp_output_38_0 * float3(1,0,1) * temp_output_16_0 ) , temp_output_38_0);
			v.vertex.xyz += lerpResult44;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Albedo = _GrassColor.rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Soothness;
			float3 ase_worldPos = i.worldPos;
			float temp_output_15_0 = saturate( ( ase_worldPos.y * _HeightMask ) );
			float temp_output_16_0 = ( temp_output_15_0 * temp_output_15_0 );
			o.Occlusion = temp_output_16_0;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17400
2683;27;878;938;1542.121;5.790855;2.023079;True;False
Node;AmplifyShaderEditor.WorldPosInputsNode;21;-1843.104,1036.516;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;22;-1581.361,1021.729;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-1576.038,1308.591;Inherit;False;Property;_MaskScrollSpeed;MaskScrollSpeed;8;0;Create;True;0;0;False;0;0;0.16;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-1582.145,1192.329;Inherit;False;Property;_NoiseUVScale;NoiseUVScale;9;0;Create;True;0;0;False;0;0;0.19;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;31;-1309.077,1514.373;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;6;-1238.022,435.7718;Inherit;False;Property;_WindSpeed;WindSpeed;3;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-1278.932,576.9121;Inherit;False;Property;_WindWaveScale;WindWaveScale;6;0;Create;True;0;0;False;0;0;0.02;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-1205.348,909.1066;Inherit;False;Property;_HeightMask;HeightMask;5;0;Create;True;0;0;False;0;0;0.61;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;27;-1354.481,1402.036;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;7;-1208.829,740.1776;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;32;-1293.839,1693.33;Inherit;False;Property;_PlayerPosition;PlayerPosition;10;0;Create;True;0;0;False;0;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;26;-1322.83,1285.983;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-1372.512,1141.728;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-1056.362,1777.97;Inherit;False;Property;_PlayerRadius;PlayerRadius;11;0;Create;True;0;0;False;0;0;1.04;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;34;-1048.126,1656.75;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-942.3469,833.1066;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;24;-1061.459,1220.114;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-996.8312,591.2125;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;5;-1031.114,441.1938;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;17;-795.6298,570.4058;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;35;-817.3644,1618.97;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;15;-764.2488,835.9081;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;20;-682.8768,1068.765;Inherit;True;Property;_DissolveTexture;DissolveTexture;7;0;Create;True;0;0;False;0;-1;None;e28dc97a9541e3642a48c0e3886688c5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-593.8594,823.7869;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;33;-1049.058,1557.004;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SinOpNode;4;-525.3646,485.2482;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-1130.073,1446.98;Inherit;False;Property;_PlayerPushStrength;PlayerPushStrength;12;0;Create;True;0;0;False;0;0;4.51;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;37;-644.7091,1618.902;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;23;-358.4768,1075.556;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-592.2932,603.5111;Inherit;False;Property;_WindStrength;WindStrength;4;0;Create;True;0;0;False;0;0;0.07;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;38;-507.015,1619.648;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-856.4951,1493.742;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-380.3945,539.8116;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;41;-513.0551,1703.581;Inherit;False;Constant;_Vector0;Vector 0;12;0;Create;True;0;0;False;0;1,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-300.6263,1550.256;Inherit;False;4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;9;-198.4631,520.269;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;1;101.5781,599.607;Inherit;False;Property;_GrassColor;GrassColor;0;0;Create;True;0;0;False;0;0,0,0,0;0.3231558,0.8301887,0.2545387,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;2;85.92322,778.366;Inherit;False;Property;_Metallic;Metallic;1;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;44;32.40779,1012.018;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;3;83.01395,855.4638;Inherit;False;Property;_Soothness;Soothness;2;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;417.5703,740.7731;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;MyShaders/Grass;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;22;0;21;1
WireConnection;22;1;21;3
WireConnection;26;0;25;0
WireConnection;29;0;22;0
WireConnection;29;1;30;0
WireConnection;34;0;31;0
WireConnection;34;1;32;0
WireConnection;13;0;7;2
WireConnection;13;1;14;0
WireConnection;24;0;29;0
WireConnection;24;2;26;0
WireConnection;24;1;27;0
WireConnection;18;0;19;0
WireConnection;18;1;7;1
WireConnection;5;0;6;0
WireConnection;17;0;5;0
WireConnection;17;1;18;0
WireConnection;35;0;34;0
WireConnection;35;1;36;0
WireConnection;15;0;13;0
WireConnection;20;1;24;0
WireConnection;16;0;15;0
WireConnection;16;1;15;0
WireConnection;33;0;31;0
WireConnection;33;1;32;0
WireConnection;4;0;17;0
WireConnection;37;0;35;0
WireConnection;23;0;20;1
WireConnection;38;0;37;0
WireConnection;43;0;42;0
WireConnection;43;1;33;0
WireConnection;11;0;4;0
WireConnection;11;1;10;0
WireConnection;11;2;16;0
WireConnection;11;3;23;0
WireConnection;39;0;43;0
WireConnection;39;1;38;0
WireConnection;39;2;41;0
WireConnection;39;3;16;0
WireConnection;9;0;11;0
WireConnection;44;0;9;0
WireConnection;44;1;39;0
WireConnection;44;2;38;0
WireConnection;0;0;1;0
WireConnection;0;3;2;0
WireConnection;0;4;3;0
WireConnection;0;5;16;0
WireConnection;0;11;44;0
ASEEND*/
//CHKSM=82E6F24304794A06D8E4FE6E1E4A41BAFF0635B3