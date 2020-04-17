// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "scene_shader/shader_Magicpot"
{
	Properties
	{
		_Color0("Color 0", Color) = (1,1,1,0)
		_speed("speed", Range( 0 , 1)) = 0
		_warp_power("warp_power", Range( 0 , 2)) = 0.34
		_Texture0("Texture 0", 2D) = "white" {}
		_em_power("em_power", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _em_power;
		uniform float4 _Color0;
		uniform sampler2D _Texture0;
		uniform float4 _Texture0_ST;
		uniform float _warp_power;
		uniform float _speed;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_Texture0 = i.uv_texcoord * _Texture0_ST.xy + _Texture0_ST.zw;
			float2 temp_cast_0 = (_speed).xx;
			float2 panner17 = ( _Time.y * temp_cast_0 + float2( 0,0 ));
			float2 uv_TexCoord18 = i.uv_texcoord + panner17;
			float4 lerpResult38 = lerp( float4( 0,0,0,0 ) , ( _em_power * _Color0 ) , tex2D( _Texture0, ( ( (tex2D( _Texture0, uv_Texture0 )).rg * _warp_power ) + uv_TexCoord18 ) ));
			o.Emission = lerpResult38.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16201
1927;1;1906;1010;1257.89;425.3248;1.058996;True;False
Node;AmplifyShaderEditor.TexturePropertyNode;32;-2527.719,-440.9875;Float;True;Property;_Texture0;Texture 0;3;0;Create;True;0;0;False;0;553857c21dbfe2e46a76b1fe03ff12f1;553857c21dbfe2e46a76b1fe03ff12f1;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleTimeNode;14;-2112.156,388.7015;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-2199.156,224.7015;Float;False;Property;_speed;speed;1;0;Create;True;0;0;False;0;0;0.16;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;29;-2144.145,-172.3927;Float;True;Property;_TextureSample0;Texture Sample 0;4;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;19;-1804.872,-181.1039;Float;False;True;True;False;False;1;0;COLOR;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-1834.489,-36.87682;Float;False;Property;_warp_power;warp_power;2;0;Create;True;0;0;False;0;0.34;1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;17;-1748.952,171.0092;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2;-1547.295,-158.1351;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;18;-1481.157,171.7015;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;3;-984.6974,372.9737;Float;False;Property;_Color0;Color 0;0;0;Create;True;0;0;False;0;1,1,1,0;0.248675,0.04058374,0.45283,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;37;-921.6628,247.2031;Float;False;Property;_em_power;em_power;4;0;Create;True;0;0;False;0;0;27;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;21;-1197.156,-83.2984;Float;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-634.6992,291.8466;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;30;-847.9825,-221.5198;Float;True;Property;_TextureSample1;Texture Sample 1;4;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;38;-46.17833,198.5121;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;12;630.5479,-65.26778;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;scene_shader/shader_Magicpot;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;29;0;32;0
WireConnection;19;0;29;0
WireConnection;17;2;15;0
WireConnection;17;1;14;0
WireConnection;2;0;19;0
WireConnection;2;1;20;0
WireConnection;18;1;17;0
WireConnection;21;0;2;0
WireConnection;21;1;18;0
WireConnection;39;0;37;0
WireConnection;39;1;3;0
WireConnection;30;0;32;0
WireConnection;30;1;21;0
WireConnection;38;1;39;0
WireConnection;38;2;30;0
WireConnection;12;2;38;0
ASEEND*/
//CHKSM=A7609F46B26372FAFB225E0D2DB3C65621ADEEF5