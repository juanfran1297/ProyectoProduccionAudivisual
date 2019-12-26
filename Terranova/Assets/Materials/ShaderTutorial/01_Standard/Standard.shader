// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyShaders/Standard"
{
	Properties
	{
		_Albedo("Albedo", 2D) = "white" {}
		_Normal("Normal", 2D) = "bump" {}
		_RockMetallic("RockMetallic", Range( 0 , 1)) = 0
		_MetalMetallic("MetalMetallic", Range( 0 , 1)) = 0
		_RockSmoothness("RockSmoothness", Range( 0 , 1)) = 0
		_MetalSmoothness("MetalSmoothness", Range( 0 , 1)) = 0
		_MetalAlbedo("MetalAlbedo", 2D) = "white" {}
		_AlbedoLerp("AlbedoLerp", Range( 0 , 1)) = 0
		_MetalNormal("MetalNormal", 2D) = "bump" {}
		_MetalLerp("MetalLerp", Range( 0 , 1)) = 0
		_Emission("Emission", 2D) = "white" {}
		_EmissionIntensity("EmissionIntensity", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform sampler2D _MetalNormal;
		uniform float4 _MetalNormal_ST;
		uniform float _MetalLerp;
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform sampler2D _MetalAlbedo;
		uniform float4 _MetalAlbedo_ST;
		uniform float _AlbedoLerp;
		uniform sampler2D _Emission;
		uniform float4 _Emission_ST;
		uniform float _EmissionIntensity;
		uniform float _RockMetallic;
		uniform float _MetalMetallic;
		uniform float _RockSmoothness;
		uniform float _MetalSmoothness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			float3 tex2DNode2 = UnpackNormal( tex2D( _Normal, uv_Normal ) );
			float2 uv_MetalNormal = i.uv_texcoord * _MetalNormal_ST.xy + _MetalNormal_ST.zw;
			float3 lerpResult12 = lerp( tex2DNode2 , UnpackNormal( tex2D( _MetalNormal, uv_MetalNormal ) ) , _MetalLerp);
			o.Normal = lerpResult12;
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			float2 uv_MetalAlbedo = i.uv_texcoord * _MetalAlbedo_ST.xy + _MetalAlbedo_ST.zw;
			float4 lerpResult9 = lerp( tex2D( _Albedo, uv_Albedo ) , tex2D( _MetalAlbedo, uv_MetalAlbedo ) , _AlbedoLerp);
			o.Albedo = lerpResult9.rgb;
			float2 uv_Emission = i.uv_texcoord * _Emission_ST.xy + _Emission_ST.zw;
			float4 lerpResult25 = lerp( float4( 0,0,0,0 ) , ( tex2D( _Emission, uv_Emission ) * _EmissionIntensity ) , ( 1.0 - tex2DNode2.b ));
			o.Emission = lerpResult25.rgb;
			float lerpResult18 = lerp( _RockMetallic , _MetalMetallic , 0.0);
			o.Metallic = lerpResult18;
			float lerpResult19 = lerp( _RockSmoothness , _MetalSmoothness , 0.0);
			o.Smoothness = lerpResult19;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17400
2602;27;959;938;1685.259;477.7809;2.579488;True;False
Node;AmplifyShaderEditor.SamplerNode;23;-873.3221,1326.597;Inherit;True;Property;_Emission;Emission;10;0;Create;True;0;0;False;0;-1;None;f7e96904e8667e1439548f0f86389447;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;30;-842.808,1550.034;Inherit;False;Property;_EmissionIntensity;EmissionIntensity;11;0;Create;True;0;0;False;0;0;7.88;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-875.9667,314.2939;Inherit;True;Property;_Normal;Normal;1;0;Create;True;0;0;False;0;-1;None;0bebe40e9ebbecc48b8e9cfea982da7e;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-523.9662,1485.031;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;33;-216.6199,1197.733;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-865.1095,1152.327;Inherit;False;Property;_MetalSmoothness;MetalSmoothness;5;0;Create;True;0;0;False;0;0;0.4498445;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-863.1707,1068.969;Inherit;False;Property;_RockSmoothness;RockSmoothness;4;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-872.6208,921.2025;Inherit;False;Property;_MetalMetallic;MetalMetallic;3;0;Create;True;0;0;False;0;0;0.2970188;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-874.9391,844.2286;Inherit;False;Property;_RockMetallic;RockMetallic;2;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-875.9854,75.11344;Inherit;False;Property;_AlbedoLerp;AlbedoLerp;7;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;11;-870.4143,534.7878;Inherit;True;Property;_MetalNormal;MetalNormal;8;0;Create;True;0;0;False;0;-1;None;bd734c29baceb63499732f24fbaea45f;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-879.9348,-377.5966;Inherit;True;Property;_Albedo;Albedo;0;0;Create;True;0;0;False;0;-1;b297077dae62c1944ba14cad801cddf5;b297077dae62c1944ba14cad801cddf5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;13;-865.8138,730.7241;Inherit;False;Property;_MetalLerp;MetalLerp;9;0;Create;True;0;0;False;0;0;0.2152811;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;26;-462.2451,221.4294;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;8;-879.259,-137.0566;Inherit;True;Property;_MetalAlbedo;MetalAlbedo;6;0;Create;True;0;0;False;0;-1;None;bea7fa376f932ba419f3d1fc95bd1a2b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;12;-455.1707,453.6862;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;19;-509.0318,1094.449;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;25;-134.2757,780.1918;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;9;-472.5285,-152.6463;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;18;-470.6223,881.6378;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;232.4142,569.3597;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;MyShaders/Standard;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;31;0;23;0
WireConnection;31;1;30;0
WireConnection;33;0;31;0
WireConnection;26;0;2;3
WireConnection;12;0;2;0
WireConnection;12;1;11;0
WireConnection;12;2;13;0
WireConnection;19;0;7;0
WireConnection;19;1;21;0
WireConnection;25;1;33;0
WireConnection;25;2;26;0
WireConnection;9;0;1;0
WireConnection;9;1;8;0
WireConnection;9;2;10;0
WireConnection;18;0;6;0
WireConnection;18;1;20;0
WireConnection;0;0;9;0
WireConnection;0;1;12;0
WireConnection;0;2;25;0
WireConnection;0;3;18;0
WireConnection;0;4;19;0
ASEEND*/
//CHKSM=9E20F77014BEADB9F5C558228961FDD63248FCBC