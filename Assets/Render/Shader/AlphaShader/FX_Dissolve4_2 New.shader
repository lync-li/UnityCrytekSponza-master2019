// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "FX_Dissolve4_2 New"
{
	Properties
	{
		_mainTexture("mainTexture", 2D) = "white" {}
		_mainTexture_TO("mainTexture_TO", Vector) = (0,0,0,0)
		_mask_power("mask_power", Range( 1 , 5)) = 0
		_disslution("disslution", Range( 0 , 1)) = 0
		_width("width", Range( 0 , 1)) = 0
		[HDR]_Color_outside("Color_outside", Color) = (0,0,0,0)
		[HDR]_Color_inside("Color_inside", Color) = (0,0,0,0)
		_UV_speed("UV_speed", Vector) = (0,0,0,0)
		[Toggle(_SHAPEONOFF_ON)] _shapeonoff("shape on/off", Float) = 0
		[Toggle(_MASKONOFF_ON)] _maskonoff("mask on/off", Float) = 0
		_centerTex("centerTex", 2D) = "white" {}
		_centerTex_power("centerTex_power", Float) = 0
		_centerTex_speed("centerTex_speed", Vector) = (0,0,0,0)
		_centerTex_TO("centerTex_TO", Vector) = (0,0,0,0)
		[Toggle(_CENTERTEXONOFF_ON)] _centerTexONOFF("centerTex ON/OFF", Float) = 0
		[Toggle(_INPUTONOFF_ON)] _inputonoff("input on/off", Float) = 0
		_centerTex_trub("centerTex_trub", 2D) = "white" {}
		_Vector0("Vector 0", Vector) = (0,0,0,0)
		[Toggle(_MESHVERTEXCOL_ON)] _meshVertexCol("meshVertexCol", Float) = 0
		_VertexOffestStrength("VertexOffestStrength", Vector) = (0,0,0,0)
		_VertexOffestTex("VertexOffestTex", 2D) = "white" {}
		_VertexOffestSpeed("VertexOffestSpeed", Vector) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha , Zero OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma shader_feature _SHAPEONOFF_ON
		#pragma shader_feature _MASKONOFF_ON
		#pragma shader_feature _INPUTONOFF_ON
		#pragma shader_feature _CENTERTEXONOFF_ON
		#pragma shader_feature _MESHVERTEXCOL_ON
		#pragma surface surf Unlit keepalpha noshadow exclude_path:deferred vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform float3 _VertexOffestStrength;
		uniform sampler2D _VertexOffestTex;
		uniform float2 _VertexOffestSpeed;
		uniform float4 _Color_outside;
		uniform float4 _Color_inside;
		uniform sampler2D _mainTexture;
		uniform float2 _UV_speed;
		uniform float4 _mainTexture_TO;
		uniform float _mask_power;
		uniform float _disslution;
		uniform float _width;
		uniform sampler2D _centerTex;
		uniform float2 _centerTex_speed;
		uniform float4 _centerTex_TO;
		uniform sampler2D _centerTex_trub;
		uniform float2 _Vector0;
		uniform float _centerTex_power;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 panner69 = ( 1.0 * _Time.y * _VertexOffestSpeed + v.texcoord.xy);
			float temp_output_37_0 = ( 1.0 - length( ( ( v.texcoord.xy + -0.5 ) * 2.0 ) ) );
			v.vertex.xyz += ( float4( _VertexOffestStrength , 0.0 ) * tex2Dlod( _VertexOffestTex, float4( panner69, 0, 0.0) ) * temp_output_37_0 ).rgb;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 appendResult46 = (float4(_mainTexture_TO.x , _mainTexture_TO.y , 0.0 , 0.0));
			float4 appendResult47 = (float4(0.0 , 0.0 , _mainTexture_TO.z , _mainTexture_TO.w));
			float2 uv_TexCoord15 = i.uv_texcoord * appendResult46.xy + appendResult47.xy;
			float2 panner13 = ( 1.0 * _Time.y * _UV_speed + uv_TexCoord15);
			float4 tex2DNode4 = tex2D( _mainTexture, panner13 );
			#ifdef _MASKONOFF_ON
				float staticSwitch16 = i.uv_texcoord.y;
			#else
				float staticSwitch16 = i.uv_texcoord.x;
			#endif
			float temp_output_37_0 = ( 1.0 - length( ( ( i.uv_texcoord + -0.5 ) * 2.0 ) ) );
			#ifdef _SHAPEONOFF_ON
				float staticSwitch41 = temp_output_37_0;
			#else
				float staticSwitch41 = staticSwitch16;
			#endif
			float temp_output_17_0 = ( tex2DNode4.r * ( staticSwitch41 * _mask_power ) );
			#ifdef _INPUTONOFF_ON
				float staticSwitch43 = i.vertexColor.a;
			#else
				float staticSwitch43 = _disslution;
			#endif
			float ifLocalVar7 = 0;
			if( temp_output_17_0 <= ( staticSwitch43 + _width ) )
				ifLocalVar7 = 0.0;
			else
				ifLocalVar7 = 1.0;
			float4 appendResult49 = (float4(_centerTex_TO.x , _centerTex_TO.y , 0.0 , 0.0));
			float4 appendResult50 = (float4(0.0 , 0.0 , _centerTex_TO.z , _centerTex_TO.w));
			float2 uv_TexCoord31 = i.uv_texcoord * appendResult49.xy + appendResult50.xy;
			float2 panner57 = ( 1.0 * _Time.y * _Vector0 + i.uv_texcoord);
			float2 panner30 = ( 1.0 * _Time.y * _centerTex_speed + ( uv_TexCoord31 + ( ( uv_TexCoord31 + tex2D( _centerTex_trub, panner57 ).r ) * 1.0 ) ));
			#ifdef _CENTERTEXONOFF_ON
				float staticSwitch73 = 1.0;
			#else
				float staticSwitch73 = ( tex2D( _centerTex, panner30 ).r * _centerTex_power );
			#endif
			float4 lerpResult10 = lerp( _Color_outside , _Color_inside , ( ifLocalVar7 * staticSwitch73 ));
			o.Emission = lerpResult10.rgb;
			float ifLocalVar1 = 0;
			if( temp_output_17_0 <= staticSwitch43 )
				ifLocalVar1 = 0.0;
			else
				ifLocalVar1 = 1.0;
			#ifdef _MESHVERTEXCOL_ON
				float staticSwitch64 = ifLocalVar1;
			#else
				float staticSwitch64 = ( i.vertexColor.a * ifLocalVar1 );
			#endif
			o.Alpha = staticSwitch64;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16201
7;7;1906;1004;4062.496;2400.412;6.413655;True;False
Node;AmplifyShaderEditor.Vector4Node;48;-1901.604,1132.823;Float;False;Property;_centerTex_TO;centerTex_TO;14;0;Create;True;0;0;False;0;0,0,0,0;11.65,3.91,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;58;-2045.179,1700.861;Float;False;Property;_Vector0;Vector 0;18;0;Create;True;0;0;False;0;0,0;0,-0.65;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;56;-2107.58,1569.561;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;34;-2322.891,724.7502;Float;False;Constant;_Float4;Float 4;11;0;Create;True;0;0;False;0;-0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;49;-1615.778,1082.068;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.PannerNode;57;-1815.079,1578.66;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;50;-1612.016,1281.49;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;38;-2482.891,570.7502;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;31;-1443.091,1170.85;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;3,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;52;-1601.879,1538.361;Float;True;Property;_centerTex_trub;centerTex_trub;17;0;Create;True;0;0;False;0;None;28c7aad1372ff114b90d330f8a2dd938;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;40;-2135.891,804.7502;Float;False;Constant;_Float5;Float 5;11;0;Create;True;0;0;False;0;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;33;-2116.891,689.7502;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector4Node;44;-2694.544,227.6374;Float;False;Property;_mainTexture_TO;mainTexture_TO;2;0;Create;True;0;0;False;0;0,0,0,0;4.77,2.72,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-1937.891,683.7502;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;54;-1278.179,1617.661;Float;False;Constant;_Float2;Float 2;16;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;51;-1332.779,1405.761;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;-1134.779,1418.46;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LengthOpNode;35;-1741.891,677.7502;Float;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;46;-2410.958,153.9401;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;47;-2413.466,338.3114;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector2Node;32;-984.3911,1349.35;Float;False;Property;_centerTex_speed;centerTex_speed;13;0;Create;True;0;0;False;0;0,0;0,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;14;-1607.96,261.5548;Float;False;Property;_UV_speed;UV_speed;8;0;Create;True;0;0;False;0;0,0;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;55;-1054.579,1166.561;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;15;-2122.96,185.5548;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;2,2;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;37;-1559.891,684.7502;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;16;-1752.96,539.5548;Float;False;Property;_maskonoff;mask on/off;10;0;Create;True;0;0;False;0;0;0;0;True;;Toggle;2;Key0;Key1;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;30;-895.8914,1171.75;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.VertexColorNode;42;-1515.253,391.2207;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;5;-1336.9,336.2001;Float;False;Property;_disslution;disslution;4;0;Create;True;0;0;False;0;0;0.033;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;41;-1374.891,568.7502;Float;False;Property;_shapeonoff;shape on/off;9;0;Create;True;0;0;False;0;0;0;0;True;;Toggle;2;Key0;Key1;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;13;-1369.96,200.5548;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-1389.891,807.7502;Float;False;Property;_mask_power;mask_power;3;0;Create;True;0;0;False;0;0;1.46;1;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-974.9597,770.5548;Float;False;Property;_width;width;5;0;Create;True;0;0;False;0;0;0.059;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-587.8914,1395.75;Float;False;Property;_centerTex_power;centerTex_power;12;0;Create;True;0;0;False;0;0;1.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;18;-685.0947,1138.292;Float;True;Property;_centerTex;centerTex;11;0;Create;True;0;0;False;0;None;160fbb935e734cf4db19875f25aea96b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;4;-1065.6,169.7;Float;True;Property;_mainTexture;mainTexture;1;0;Create;True;0;0;False;0;None;585d2b2458276424fbaa8fc666a8f44c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-1129.891,604.7502;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;43;-1061.153,430.4207;Float;False;Property;_inputonoff;input on/off;16;0;Create;True;0;0;False;0;0;0;0;True;;Toggle;2;Key0;Key1;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-365.8914,1166.75;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;74;-203.9852,1219.743;Float;False;Constant;_Float3;Float 3;22;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-884.5,87.5;Float;False;Constant;_Float1;Float 1;0;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-759.9948,409.5923;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;71;-106.2566,1334.782;Float;False;Property;_VertexOffestSpeed;VertexOffestSpeed;22;0;Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;70;-87.25659,1498.782;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;2;-880.5,-5.5;Float;False;Constant;_Float0;Float 0;0;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;8;-725.0598,613.4548;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;73;-155.8853,1019.542;Float;False;Property;_centerTexONOFF;centerTex ON/OFF;15;0;Create;True;0;0;False;0;0;0;1;True;;Toggle;2;Key0;Key1;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;1;-525.5,55.5;Float;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;7;-517.9597,429.5548;Float;True;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;60;-396.4411,-111.2804;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;69;105.7434,1314.782;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-193.3914,858.2502;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;12;-564.7598,808.5549;Float;False;Property;_Color_inside;Color_inside;7;1;[HDR];Create;True;0;0;False;0;0,0,0,0;0.03185304,0.4459425,1.216786,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;66;173.7434,1010.782;Float;True;Property;_VertexOffestTex;VertexOffestTex;21;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;-179.8411,74.01967;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;65;184.7434,723.7822;Float;False;Property;_VertexOffestStrength;VertexOffestStrength;20;0;Create;True;0;0;False;0;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ColorNode;11;-561.0598,621.9548;Float;False;Property;_Color_outside;Color_outside;6;1;[HDR];Create;True;0;0;False;0;0,0,0,0;0,0.1337828,1.216786,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;72;265.3132,382.5432;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;22;-387.8914,276.7502;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;486.0101,782.002;Float;False;3;3;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;64;-53.48378,267.9561;Float;False;Property;_meshVertexCol;meshVertexCol;19;0;Create;True;0;0;False;0;0;0;0;True;;Toggle;2;Key0;Key1;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;10;308.9403,493.0549;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;62;809,208;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;FX_Dissolve4_2 New;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Off;1;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;False;Transparent;;Transparent;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;8;5;False;-1;1;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;49;0;48;1
WireConnection;49;1;48;2
WireConnection;57;0;56;0
WireConnection;57;2;58;0
WireConnection;50;2;48;3
WireConnection;50;3;48;4
WireConnection;31;0;49;0
WireConnection;31;1;50;0
WireConnection;52;1;57;0
WireConnection;33;0;38;0
WireConnection;33;1;34;0
WireConnection;39;0;33;0
WireConnection;39;1;40;0
WireConnection;51;0;31;0
WireConnection;51;1;52;1
WireConnection;53;0;51;0
WireConnection;53;1;54;0
WireConnection;35;0;39;0
WireConnection;46;0;44;1
WireConnection;46;1;44;2
WireConnection;47;2;44;3
WireConnection;47;3;44;4
WireConnection;55;0;31;0
WireConnection;55;1;53;0
WireConnection;15;0;46;0
WireConnection;15;1;47;0
WireConnection;37;0;35;0
WireConnection;16;1;38;1
WireConnection;16;0;38;2
WireConnection;30;0;55;0
WireConnection;30;2;32;0
WireConnection;41;1;16;0
WireConnection;41;0;37;0
WireConnection;13;0;15;0
WireConnection;13;2;14;0
WireConnection;18;1;30;0
WireConnection;4;1;13;0
WireConnection;25;0;41;0
WireConnection;25;1;26;0
WireConnection;43;1;5;0
WireConnection;43;0;42;4
WireConnection;23;0;18;1
WireConnection;23;1;24;0
WireConnection;17;0;4;1
WireConnection;17;1;25;0
WireConnection;8;0;43;0
WireConnection;8;1;9;0
WireConnection;73;1;23;0
WireConnection;73;0;74;0
WireConnection;1;0;17;0
WireConnection;1;1;43;0
WireConnection;1;2;2;0
WireConnection;1;3;3;0
WireConnection;1;4;3;0
WireConnection;7;0;17;0
WireConnection;7;1;8;0
WireConnection;7;2;2;0
WireConnection;7;3;3;0
WireConnection;7;4;3;0
WireConnection;69;0;70;0
WireConnection;69;2;71;0
WireConnection;19;0;7;0
WireConnection;19;1;73;0
WireConnection;66;1;69;0
WireConnection;59;0;60;4
WireConnection;59;1;1;0
WireConnection;72;0;64;0
WireConnection;72;1;11;4
WireConnection;22;0;2;0
WireConnection;22;1;3;0
WireConnection;22;2;4;1
WireConnection;67;0;65;0
WireConnection;67;1;66;0
WireConnection;67;2;37;0
WireConnection;64;1;59;0
WireConnection;64;0;1;0
WireConnection;10;0;11;0
WireConnection;10;1;12;0
WireConnection;10;2;19;0
WireConnection;62;2;10;0
WireConnection;62;9;64;0
WireConnection;62;11;67;0
ASEEND*/
//CHKSM=ED8042986BBA5B31DA9224BE095476DF0B3C7CB1