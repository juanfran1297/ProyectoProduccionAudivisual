// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyShaders/Dissolve"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Albedo("Albedo", 2D) = "white" {}
		_Normal("Normal", 2D) = "bump" {}
		_Ramp("Ramp", 2D) = "white" {}
		_Metallic("Metallic", Range( 0 , 1)) = 0
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		_EmmisionIntensity("EmmisionIntensity", Float) = 0
		_RampUVScale("RampUVScale", Float) = 0
		_Mask("Mask", 2D) = "white" {}
		_UVLerp("UVLerp", Range( 0 , 1)) = 0
		_PannerSpeed("PannerSpeed", Vector) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform sampler2D _Ramp;
		uniform sampler2D _Mask;
		uniform float2 _PannerSpeed;
		uniform float _UVLerp;
		uniform float _RampUVScale;
		uniform float _EmmisionIntensity;
		uniform float _Metallic;
		uniform float _Smoothness;
		uniform float _Cutoff = 0.5;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			o.Normal = UnpackNormal( tex2D( _Normal, uv_Normal ) );
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			o.Albedo = tex2D( _Albedo, uv_Albedo ).rgb;
			float2 panner27 = ( _Time.y * _PannerSpeed + i.uv_texcoord);
			float2 temp_cast_1 = (tex2D( _Mask, panner27 ).r).xx;
			float2 lerpResult25 = lerp( temp_cast_1 , i.uv_texcoord , _UVLerp);
			float4 temp_cast_2 = ((-0.7 + (_SinTime.z - -1.0) * (0.7 - -0.7) / (1.0 - -1.0))).xxxx;
			float4 temp_output_9_0 = ( tex2D( _Mask, lerpResult25 ) - temp_cast_2 );
			float4 temp_cast_3 = (( _RampUVScale * -1.0 )).xxxx;
			float4 temp_cast_4 = (_RampUVScale).xxxx;
			o.Emission = ( tex2D( _Ramp, ( 1.0 - saturate( (temp_cast_3 + (temp_output_9_0 - float4( 0,0,0,0 )) * (temp_cast_4 - temp_cast_3) / (float4( 1,0,0,0 ) - float4( 0,0,0,0 ))) ) ).rg ) * _EmmisionIntensity ).rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Smoothness;
			o.Alpha = 1;
			clip( temp_output_9_0.r - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17400
612;73;959;938;4380.502;824.4032;5.106019;True;False
Node;AmplifyShaderEditor.SimpleTimeNode;28;-3020.617,1615.878;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;21;-2973.652,1158.468;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;30;-2995.281,1449.33;Inherit;False;Property;_PannerSpeed;PannerSpeed;11;0;Create;True;0;0;False;0;0,0;0.1,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;27;-2705.853,1431.43;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;23;-2581.149,921.4138;Inherit;True;Property;_Mask;Mask;9;0;Create;True;0;0;False;0;None;e28dc97a9541e3642a48c0e3886688c5;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-2417.046,1633.032;Inherit;False;Property;_UVLerp;UVLerp;10;0;Create;True;0;0;False;0;0;0.9472361;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;24;-2406.476,1386.485;Inherit;True;Property;_TextureSample1;Texture Sample 1;11;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SinTimeNode;32;-1975.837,1542.263;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;25;-1956.311,1222.628;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-1660.082,906.3327;Inherit;False;Property;_RampUVScale;RampUVScale;8;0;Create;True;0;0;False;0;0;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;33;-1752.836,1529.263;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;-0.7;False;4;FLOAT;0.7;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;31;-1702.35,1062.092;Inherit;True;Property;_TextureSample0;Texture Sample 0;13;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;9;-1330.175,1171.161;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-1448.867,789.6528;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;16;-1242.688,800.8719;Inherit;False;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;19;-1038.943,813.3292;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;20;-813.4584,798.648;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;12;-522.0809,678.1281;Inherit;True;Property;_Ramp;Ramp;3;0;Create;True;0;0;False;0;-1;None;64e7766099ad46747a07014e44d0aea1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;14;-520.6501,941.0653;Inherit;False;Property;_EmmisionIntensity;EmmisionIntensity;7;0;Create;True;0;0;False;0;0;2.25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-189.8633,796.4667;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1;-545.5247,-50.08075;Inherit;True;Property;_Albedo;Albedo;1;0;Create;True;0;0;False;0;-1;b297077dae62c1944ba14cad801cddf5;b297077dae62c1944ba14cad801cddf5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-552.472,187.8551;Inherit;True;Property;_Normal;Normal;2;0;Create;True;0;0;False;0;-1;0bebe40e9ebbecc48b8e9cfea982da7e;0bebe40e9ebbecc48b8e9cfea982da7e;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;4;-540.3146,514.366;Inherit;False;Property;_Smoothness;Smoothness;5;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-548.9984,406.6868;Inherit;False;Property;_Metallic;Metallic;4;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-1775.002,1370.339;Inherit;False;Property;_OpacityMask;OpacityMask;6;0;Create;True;0;0;False;0;0;-0.32;-0.7;0.7;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;MyShaders/Dissolve;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;TransparentCutout;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;27;0;21;0
WireConnection;27;2;30;0
WireConnection;27;1;28;0
WireConnection;24;0;23;0
WireConnection;24;1;27;0
WireConnection;25;0;24;1
WireConnection;25;1;21;0
WireConnection;25;2;26;0
WireConnection;33;0;32;3
WireConnection;31;0;23;0
WireConnection;31;1;25;0
WireConnection;9;0;31;0
WireConnection;9;1;33;0
WireConnection;18;0;17;0
WireConnection;16;0;9;0
WireConnection;16;3;18;0
WireConnection;16;4;17;0
WireConnection;19;0;16;0
WireConnection;20;0;19;0
WireConnection;12;1;20;0
WireConnection;15;0;12;0
WireConnection;15;1;14;0
WireConnection;0;0;1;0
WireConnection;0;1;2;0
WireConnection;0;2;15;0
WireConnection;0;3;3;0
WireConnection;0;4;4;0
WireConnection;0;10;9;0
ASEEND*/
//CHKSM=741ACFD106AA5C8B2BC7062FAE7E5527D028247E