// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyShaders/Neon"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_EmissionIntensity("EmissionIntensity", Float) = 0
		_Color0("Color 0", Color) = (1,0.1028366,0,0)
		_Metallic("Metallic", Range( 0 , 1)) = 0
		_Soothness("Soothness", Range( 0 , 1)) = 0
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

		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform float4 _Color0;
		uniform float _EmissionIntensity;
		uniform float _Metallic;
		uniform float _Soothness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float4 tex2DNode1 = tex2D( _TextureSample0, uv_TextureSample0 );
			o.Albedo = tex2DNode1.rgb;
			float4 lerpResult6 = lerp( float4( 0,0,0,0 ) , ( _Color0 * _EmissionIntensity ) , tex2DNode1.r);
			o.Emission = lerpResult6.rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Soothness;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17400
2432;27;1060;938;1298.836;435.7234;1.413471;True;False
Node;AmplifyShaderEditor.RangedFloatNode;4;-967.6017,192.5434;Inherit;False;Property;_EmissionIntensity;EmissionIntensity;2;0;Create;True;0;0;False;0;0;9.14;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;3;-967.6017,-15.45673;Inherit;False;Property;_Color0;Color 0;3;0;Create;True;0;0;False;0;1,0.1028366,0,0;0,1,0.9052942,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-737.6578,-160.7542;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;-1;None;58313a0528969f749b70a6d455d8c113;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-663.6019,64.54343;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;6;-305.6579,-32.7542;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-414.0003,133.9052;Inherit;False;Property;_Metallic;Metallic;4;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-415.4137,232.8482;Inherit;False;Property;_Soothness;Soothness;5;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-414.6721,-247.7326;Inherit;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;False;0;-1;None;58313a0528969f749b70a6d455d8c113;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;MyShaders/Neon;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;5;0;3;0
WireConnection;5;1;4;0
WireConnection;6;1;5;0
WireConnection;6;2;1;1
WireConnection;0;0;1;0
WireConnection;0;2;6;0
WireConnection;0;3;9;0
WireConnection;0;4;10;0
ASEEND*/
//CHKSM=C9F96B70A034418502D2D0B59A64A2FDC1B29EA6