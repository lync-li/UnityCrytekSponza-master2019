// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "shader_shuibo"
{
	Properties
	{
		_T_shuibo_N("T_shuibo_N", 2D) = "bump" {}
		_Normal_UV("Normal_UV", Float) = 1
		_speed("speed", Float) = 0.2
		_smoothness("smoothness", Float) = 0
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows exclude_path:deferred 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _T_shuibo_N;
		uniform float _speed;
		uniform float _Normal_UV;
		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform float _smoothness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 temp_cast_0 = (_speed).xx;
			float2 temp_cast_1 = (_Normal_UV).xx;
			float2 uv_TexCoord4 = i.uv_texcoord * temp_cast_1 + float2( 0,0 );
			float2 panner3 = ( uv_TexCoord4 + 1.0 * _Time.y * temp_cast_0);
			o.Normal = UnpackNormal( tex2D( _T_shuibo_N, panner3 ) );
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float4 temp_cast_2 = (2.86).xxxx;
			o.Albedo = pow( tex2D( _TextureSample0, uv_TextureSample0 ) , temp_cast_2 ).rgb;
			o.Metallic = 0.4;
			o.Smoothness = _smoothness;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=13901
1927;29;1906;1004;1096.585;362.4273;1;True;True
Node;AmplifyShaderEditor.RangedFloatNode;5;-2032.288,322.4292;Float;False;Property;_Normal_UV;Normal_UV;1;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-1751.288,204.4293;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;8;-1774.288,405.4292;Float;False;Property;_speed;speed;2;0;0.2;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;10;-800.0765,-131.6281;Float;False;Constant;_color_power;color_power;3;0;2.86;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SamplerNode;16;-1340.373,-514.8764;Float;True;Property;_TextureSample0;Texture Sample 0;5;0;Assets/Z_zichan/SM_LightTa/T_shuibo_D.tga;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.PannerNode;3;-1411.288,334.4292;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2
Node;AmplifyShaderEditor.PowerNode;9;-541.7628,-291.3187;Float;False;2;0;COLOR;0.0;False;1;FLOAT;0.0;False;1;COLOR
Node;AmplifyShaderEditor.RangedFloatNode;12;-492.6357,15.42615;Float;False;Constant;_metal;metal;4;0;0.4;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;11;-318.6357,277.4261;Float;False;Property;_smoothness;smoothness;3;0;0;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SamplerNode;2;-1030.288,278.4292;Float;True;Property;_T_shuibo_N;T_shuibo_N;0;0;Assets/Z_zichan/SM_LightTa/T_shuibo_N.tga;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;135,-59;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;shader_shuibo;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;Opaque;0.5;True;True;0;False;Opaque;Geometry;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;4;0;5;0
WireConnection;3;0;4;0
WireConnection;3;2;8;0
WireConnection;9;0;16;0
WireConnection;9;1;10;0
WireConnection;2;1;3;0
WireConnection;0;0;9;0
WireConnection;0;1;2;0
WireConnection;0;3;12;0
WireConnection;0;4;11;0
ASEEND*/
//CHKSM=79064B974BDDA1DDCD9B3D66A09363BAA7AECB70