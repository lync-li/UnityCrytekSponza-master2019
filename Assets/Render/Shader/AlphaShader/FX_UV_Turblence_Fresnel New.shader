// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "FX_UV_Turblence_Fresnel New"
{
	Properties
	{
		_turbleTex("turbleTex", 2D) = "white" {}
		_mainTexSpeed("mainTexSpeed", Vector) = (0,0,0,0)
		_turbleStrange("turbleStrange", Float) = 0.2
		_mainTex("mainTex", 2D) = "white" {}
		_turbleSpeed("turbleSpeed", Vector) = (0,0,0,0)
		[HDR]_mainColor("mainColor", Color) = (0,0,0,0)
		_turbleTiling("turbleTiling", Float) = 3
		_mainTexOffest("mainTexOffest", Vector) = (-0.62,-0.18,0,0)
		_TextureSample2("Texture Sample 2", 2D) = "white" {}
		[Toggle(_MASKONOFF_ON)] _maskONOFF("mask ON/OFF", Float) = 0
		_maskStrange("maskStrange", Float) = 0
		_FresnelStrange("FresnelStrange", Float) = 0.06
		_FresnelPower("FresnelPower", Float) = 2.88
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull off
		Blend SrcAlpha OneMinusSrcAlpha , Zero OneMinusSrcAlpha
        ZWrite off
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma shader_feature _MASKONOFF_ON
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform float4 _mainColor;
		uniform float _FresnelStrange;
		uniform float _FresnelPower;
		uniform sampler2D _mainTex;
		uniform float2 _mainTexSpeed;
		uniform float2 _mainTexOffest;
		uniform sampler2D _turbleTex;
		uniform float2 _turbleSpeed;
		uniform float _turbleTiling;
		uniform float _turbleStrange;
		uniform float _maskStrange;
		uniform sampler2D _TextureSample2;
		uniform float4 _TextureSample2_ST;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV36 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode36 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV36, _FresnelPower ) );
			float2 uv_TexCoord13 = i.uv_texcoord + _mainTexOffest;
			float2 temp_cast_0 = (_turbleTiling).xx;
			float2 uv_TexCoord6 = i.uv_texcoord * temp_cast_0;
			float2 panner7 = ( 1.0 * _Time.y * _turbleSpeed + uv_TexCoord6);
			float2 panner17 = ( 1.0 * _Time.y * _mainTexSpeed + ( uv_TexCoord13 * ( i.uv_texcoord + ( tex2D( _turbleTex, panner7 ).r * _turbleStrange ) ) ));
			float4 tex2DNode19 = tex2D( _mainTex, panner17 );
			float clampResult35 = clamp( ( 1.0 - ( _maskStrange + uv_TexCoord6.y ) ) , 0.0 , 1.0 );
			#ifdef _MASKONOFF_ON
				float4 staticSwitch29 = ( clampResult35 + tex2DNode19 );
			#else
				float4 staticSwitch29 = tex2DNode19;
			#endif
			o.Emission = ( ( _mainColor * ( ( _FresnelStrange * fresnelNode36 ) + staticSwitch29 ) ) * i.vertexColor ).rgb;
			float2 uv_TextureSample2 = i.uv_texcoord * _TextureSample2_ST.xy + _TextureSample2_ST.zw;
			o.Alpha = ( i.vertexColor.a * ( staticSwitch29 * tex2D( _TextureSample2, uv_TextureSample2 ).r ) ).r;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit keepalpha fullforwardshadows 

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
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float3 worldNormal : TEXCOORD3;
				half4 color : COLOR0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.color = v.color;
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
				surfIN.vertexColor = IN.color;
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16201
-1582;24;1355;952;879.0267;634.5469;1.3;True;True
Node;AmplifyShaderEditor.RangedFloatNode;4;-2746.405,482.8815;Float;False;Property;_turbleTiling;turbleTiling;6;0;Create;True;0;0;False;0;3;4.49;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;6;-2576.405,464.8814;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;5;-2431.405,647.9905;Float;False;Property;_turbleSpeed;turbleSpeed;4;0;Create;True;0;0;False;0;0,0;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;7;-2201.404,601.9902;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;9;-1958.405,372.99;Float;True;Property;_turbleTex;turbleTex;0;0;Create;True;0;0;False;0;ca531cf84d9ac6545b4380d1aaf4d6d2;ca531cf84d9ac6545b4380d1aaf4d6d2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;8;-1852.405,627.9904;Float;False;Property;_turbleStrange;turbleStrange;2;0;Create;True;0;0;False;0;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;12;-1606.8,117.8312;Float;False;Property;_mainTexOffest;mainTexOffest;7;0;Create;True;0;0;False;0;-0.62,-0.18;1.74,0.09;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;10;-1626.251,325.9278;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-1592.405,496.9901;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;14;-1359.404,325.99;Float;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;13;-1381.799,76.83121;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;32;-1400.782,-363.6133;Float;False;Property;_maskStrange;maskStrange;10;0;Create;True;0;0;False;0;0;-0.21;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-1098.405,76.9901;Float;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;16;-1112.404,496.9903;Float;False;Property;_mainTexSpeed;mainTexSpeed;1;0;Create;True;0;0;False;0;0,0;0,-1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;30;-1178.994,-339.7428;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;17;-876.8044,320.2902;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;33;-943.8009,-266.6682;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-262.2351,-367.5552;Float;False;Property;_FresnelPower;FresnelPower;12;0;Create;True;0;0;False;0;2.88;4.27;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;19;-866.1244,311.7604;Float;True;Property;_mainTex;mainTex;3;0;Create;True;0;0;False;0;7b4365152d8be90429146e19575c638e;45c0a250d67c2ca41a9ff6da338b59fa;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;35;-1002.066,-139.671;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;40;20.76489,-492.5552;Float;False;Property;_FresnelStrange;FresnelStrange;11;0;Create;True;0;0;False;0;0.06;7.02;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;36;-41.23511,-312.5552;Float;True;Standard;WorldNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;26;-756.7476,28.5042;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;29;-465.9963,122.1151;Float;True;Property;_maskONOFF;mask ON/OFF;9;0;Create;True;0;0;False;0;0;0;1;True;;Toggle;2;Key0;Key1;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;290.7649,-365.5552;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;22;-956.7048,571.5443;Float;True;Property;_TextureSample2;Texture Sample 2;8;0;Create;True;0;0;False;0;649a02a865211cb468df1db061c164f0;649a02a865211cb468df1db061c164f0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;37;-402.2351,-59.55521;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;18;-577.7522,-312.0459;Float;False;Property;_mainColor;mainColor;5;1;[HDR];Create;True;0;0;False;0;0,0,0,0;2.367875,0.7783487,0.301569,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-197.7523,63.8541;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;23;-239.5961,241.415;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-255.5054,469.8445;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-41.59607,192.415;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-17.59607,444.415;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;224,36.8;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;FX_UV_Turblence;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;2;5;False;-1;10;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;6;0;4;0
WireConnection;7;0;6;0
WireConnection;7;2;5;0
WireConnection;9;1;7;0
WireConnection;11;0;9;1
WireConnection;11;1;8;0
WireConnection;14;0;10;0
WireConnection;14;1;11;0
WireConnection;13;1;12;0
WireConnection;15;0;13;0
WireConnection;15;1;14;0
WireConnection;30;0;32;0
WireConnection;30;1;6;2
WireConnection;17;0;15;0
WireConnection;17;2;16;0
WireConnection;33;0;30;0
WireConnection;19;1;17;0
WireConnection;35;0;33;0
WireConnection;36;3;38;0
WireConnection;26;0;35;0
WireConnection;26;1;19;0
WireConnection;29;1;19;0
WireConnection;29;0;26;0
WireConnection;41;0;40;0
WireConnection;41;1;36;0
WireConnection;37;0;41;0
WireConnection;37;1;29;0
WireConnection;20;0;18;0
WireConnection;20;1;37;0
WireConnection;21;0;29;0
WireConnection;21;1;22;1
WireConnection;24;0;20;0
WireConnection;24;1;23;0
WireConnection;25;0;23;4
WireConnection;25;1;21;0
WireConnection;0;2;24;0
WireConnection;0;9;25;0
ASEEND*/
//CHKSM=806EFF8F7999D92CE9DC5240DF75D128962100BA