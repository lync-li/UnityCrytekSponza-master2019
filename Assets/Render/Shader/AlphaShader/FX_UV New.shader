// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "FX/FX_UV New"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_dissTex("dissTex", 2D) = "white" {}
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		[HDR]_Color0("Color 0", Color) = (0,0,0,0)
		_maskTex("maskTex", 2D) = "white" {}
		_colorPower("colorPower", Float) = 0
		_speed("speed", Float) = 0
		_speed2("speed2", Float) = 0
		_power("power", Float) = 4.18
		_scale("scale", Float) = 1.21
		_Lose("Lose", Float) = 0.74
		[HDR]_EdgeCol("EdgeCol", Color) = (1,1,1,1)
		_LoseEdge("LoseEdge", Float) = 0.1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha , Zero OneMinusSrcAlpha
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit  keepalpha noshadow 
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform float4 _Color0;
		uniform float _scale;
		uniform float _power;
		uniform sampler2D _MainTex;
		uniform float _speed2;
		uniform sampler2D _dissTex;
		uniform float _speed;
		uniform float _colorPower;
		uniform float4 _EdgeCol;
		uniform float _Lose;
		uniform float _LoseEdge;
		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform sampler2D _maskTex;
		uniform float4 _maskTex_ST;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV54 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode54 = ( 0.0 + _scale * pow( 1.0 - fresnelNdotV54, _power ) );
			float2 temp_cast_0 = (_speed2).xx;
			float2 temp_cast_1 = (_speed).xx;
			float2 panner30 = ( 1.0 * _Time.y * temp_cast_1 + float2( 2,2 ));
			float2 uv_TexCoord34 = i.uv_texcoord + panner30;
			float2 temp_output_29_0 = ( i.uv_texcoord + ( i.uv_texcoord * tex2D( _dissTex, uv_TexCoord34 ).r * 0.5 ) );
			float2 panner32 = ( 1.0 * _Time.y * temp_cast_0 + temp_output_29_0);
			float4 tex2DNode21 = tex2D( _MainTex, panner32 );
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float4 tex2DNode65 = tex2D( _TextureSample0, uv_TextureSample0 );
			float ifLocalVar75 = 0;
			if( ( _Lose + _LoseEdge ) >= tex2DNode65.r )
				ifLocalVar75 = 1.0;
			else
				ifLocalVar75 = 0.0;
			float ifLocalVar69 = 0;
			if( _Lose >= tex2DNode65.r )
				ifLocalVar69 = 1.0;
			else
				ifLocalVar69 = 0.0;
			o.Emission = ( ( ( ( _Color0 * fresnelNode54 ) * ( _Color0 * tex2DNode21 * _colorPower ) ) + ( _EdgeCol * ( ifLocalVar75 - ifLocalVar69 ) * -1.0 ) ) * i.vertexColor ).rgb;
			float2 uv_maskTex = i.uv_texcoord * _maskTex_ST.xy + _maskTex_ST.zw;
			float4 tex2DNode43 = tex2D( _maskTex, uv_maskTex );
			float clampResult41 = clamp( ( tex2DNode21.r * tex2DNode43.r * _Color0.a ) , 0.0 , 1.0 );
			o.Alpha = ( i.vertexColor.a * ( clampResult41 * ifLocalVar69 ) );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16201
-1913;1;1906;1010;1384.538;432.1882;1.738237;True;False
Node;AmplifyShaderEditor.RangedFloatNode;52;-2168.17,337.5977;Float;False;Property;_speed;speed;6;0;Create;True;0;0;False;0;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;30;-1892.832,333.5099;Float;False;3;0;FLOAT2;2,2;False;2;FLOAT2;0,-1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;34;-1617.637,98.72083;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;24;-1330.518,40.06876;Float;True;Property;_dissTex;dissTex;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;26;-1029.518,101.0688;Float;False;Constant;_strage;strage;3;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;22;-1351.518,-254.9312;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-993.5182,-142.9313;Float;False;3;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;67;-944.3064,885.6085;Float;False;Property;_Lose;Lose;10;0;Create;True;0;0;False;0;0.74;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;77;-572.4418,1298.883;Float;False;Property;_LoseEdge;LoseEdge;12;0;Create;True;0;0;False;0;0.1;-0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;29;-756.5182,-191.9313;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-732.6375,112.7208;Float;False;Property;_speed2;speed2;7;0;Create;True;0;0;False;0;0;-0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;32;-488.6375,-58.27917;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;65;-709.8294,610.3157;Float;True;Property;_TextureSample0;Texture Sample 0;2;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;76;-261.0106,1293.541;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;70;-621.2447,942.933;Float;False;Constant;_Float1;Float 1;10;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;71;-711.8335,1156.179;Float;False;Constant;_Float2;Float 2;10;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;58;-774.7662,-936.3542;Float;False;Property;_power;power;8;0;Create;True;0;0;False;0;4.18;3.61;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;57;-586.2663,-987.0544;Float;False;Property;_scale;scale;9;0;Create;True;0;0;False;0;1.21;7.44;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-468.6394,-342.263;Float;False;Property;_colorPower;colorPower;5;0;Create;True;0;0;False;0;0;8.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;54;-408.1663,-703.654;Float;False;Standard;TangentNormal;ViewDir;False;5;0;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;69;-133.9151,785.0466;Float;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;43;-679.6375,358.7208;Float;True;Property;_maskTex;maskTex;4;0;Create;True;0;0;False;0;None;a41a0d26d108d6e43be62325dae089d4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ConditionalIfNode;75;-14.22442,1144.372;Float;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;21;-218.5182,-198.9312;Float;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;False;0;59f654c034abb334a8ba4591c79f4464;181c35e53e793f84a85303a2e4707eec;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;49;-313.2766,-446.9708;Float;False;Property;_Color0;Color 0;3;1;[HDR];Create;True;0;0;False;0;0,0,0,0;0.5277842,0.6748238,2.111137,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;83.13744,49.97135;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;86;-106.7058,592.5485;Float;False;Constant;_Float0;Float 0;13;0;Create;True;0;0;False;0;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;81;-130.5538,322.8803;Float;False;Property;_EdgeCol;EdgeCol;11;1;[HDR];Create;True;0;0;False;0;1,1,1,1;1.084551,1.377387,2.783001,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;78;156.9789,925.3925;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;94.36255,-344.2792;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;84.53369,-626.9545;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;41;297.6942,91.17996;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;87;439.7767,-276.8737;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;80;133.6116,524.6735;Float;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;553.7083,451.294;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;56;623.834,-89.86562;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;88;539.027,161.4295;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;89;747.5713,69.38233;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;90;818.0447,418.8738;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;91;-301.8031,149.0765;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;51;-801.6375,-523.2792;Float;False;True;True;True;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;942.4929,-60.64718;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;FX/FX_UV New;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;2;5;False;-1;10;False;-1;1;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;30;2;52;0
WireConnection;34;1;30;0
WireConnection;24;1;34;0
WireConnection;28;0;22;0
WireConnection;28;1;24;1
WireConnection;28;2;26;0
WireConnection;29;0;22;0
WireConnection;29;1;28;0
WireConnection;32;0;29;0
WireConnection;32;2;53;0
WireConnection;76;0;67;0
WireConnection;76;1;77;0
WireConnection;54;2;57;0
WireConnection;54;3;58;0
WireConnection;69;0;67;0
WireConnection;69;1;65;1
WireConnection;69;2;70;0
WireConnection;69;3;70;0
WireConnection;69;4;71;0
WireConnection;75;0;76;0
WireConnection;75;1;65;1
WireConnection;75;2;70;0
WireConnection;75;3;70;0
WireConnection;75;4;71;0
WireConnection;21;1;32;0
WireConnection;36;0;21;1
WireConnection;36;1;43;1
WireConnection;36;2;49;4
WireConnection;78;0;75;0
WireConnection;78;1;69;0
WireConnection;47;0;49;0
WireConnection;47;1;21;0
WireConnection;47;2;50;0
WireConnection;59;0;49;0
WireConnection;59;1;54;0
WireConnection;41;0;36;0
WireConnection;87;0;59;0
WireConnection;87;1;47;0
WireConnection;80;0;81;0
WireConnection;80;1;78;0
WireConnection;80;2;86;0
WireConnection;83;0;41;0
WireConnection;83;1;69;0
WireConnection;56;0;87;0
WireConnection;56;1;80;0
WireConnection;89;0;56;0
WireConnection;89;1;88;0
WireConnection;90;0;88;4
WireConnection;90;1;83;0
WireConnection;91;0;88;4
WireConnection;91;1;43;1
WireConnection;51;0;29;0
WireConnection;0;2;89;0
WireConnection;0;9;90;0
ASEEND*/
//CHKSM=225EB16CBD0E525E17A03A1C5A4B29BD35BBC532