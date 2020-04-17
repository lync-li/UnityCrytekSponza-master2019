// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "monster_firebaall_shader"
{
	Properties
	{
		_T_fireballmonster_D("T_fireballmonster_D", 2D) = "white" {}
		_T_fireballmonster_M("T_fireballmonster_M", 2D) = "white" {}
		_T_fireballmonster_N("T_fireballmonster_N", 2D) = "bump" {}
		_metal("metal", Float) = 0
		_TextureSample2("Texture Sample 2", 2D) = "white" {}
		_smoothness("smoothness", Float) = 0
		_color_01("color_01", Float) = 1
		_TXlight_power("TXlight_power", Range( 0 , 2)) = 0
		_T_fireballmonster_EM("T_fireballmonster_EM", 2D) = "white" {}
		_TX_speed("TX_speed", Vector) = (0,0,0,0)
		_texiao_uv("texiao_uv", Float) = 1
		_em_color("em_color", Float) = 1
		_fre_normal("fre_normal", Float) = 0
		_fre_color("fre_color", Color) = (0,0,0,0)
		_em_eye("em_eye", Float) = 0
		_color_02("color_02", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) fixed3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			INTERNAL_DATA
			float3 worldNormal;
		};

		uniform sampler2D _T_fireballmonster_N;
		uniform float4 _T_fireballmonster_N_ST;
		uniform sampler2D _T_fireballmonster_D;
		uniform float4 _T_fireballmonster_D_ST;
		uniform float _color_01;
		uniform float _color_02;
		uniform sampler2D _T_fireballmonster_M;
		uniform float4 _T_fireballmonster_M_ST;
		uniform float _fre_normal;
		uniform float4 _fre_color;
		uniform sampler2D _TextureSample2;
		uniform float2 _TX_speed;
		uniform float _texiao_uv;
		uniform float _TXlight_power;
		uniform sampler2D _T_fireballmonster_EM;
		uniform float4 _T_fireballmonster_EM_ST;
		uniform float _em_color;
		uniform float _em_eye;
		uniform float _metal;
		uniform float _smoothness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_T_fireballmonster_N = i.uv_texcoord * _T_fireballmonster_N_ST.xy + _T_fireballmonster_N_ST.zw;
			float3 tex2DNode3 = UnpackNormal( tex2D( _T_fireballmonster_N, uv_T_fireballmonster_N ) );
			o.Normal = tex2DNode3;
			float2 uv_T_fireballmonster_D = i.uv_texcoord * _T_fireballmonster_D_ST.xy + _T_fireballmonster_D_ST.zw;
			float4 tex2DNode1 = tex2D( _T_fireballmonster_D, uv_T_fireballmonster_D );
			float2 uv_T_fireballmonster_M = i.uv_texcoord * _T_fireballmonster_M_ST.xy + _T_fireballmonster_M_ST.zw;
			float4 tex2DNode2 = tex2D( _T_fireballmonster_M, uv_T_fireballmonster_M );
			float4 lerpResult97 = lerp( ( tex2DNode1 * _color_01 ) , ( tex2DNode1 * _color_02 ) , tex2DNode2.b);
			o.Albedo = lerpResult97.rgb;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float fresnelNDotV77 = dot( WorldNormalVector( i , tex2DNode3 ), ase_worldViewDir );
			float fresnelNode77 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNDotV77, _fre_normal ) );
			float2 temp_cast_1 = (_texiao_uv).xx;
			float2 uv_TexCoord63 = i.uv_texcoord * temp_cast_1 + float2( 0,0 );
			float2 panner67 = ( uv_TexCoord63 + _Time.x * _TX_speed);
			float2 uv_T_fireballmonster_EM = i.uv_texcoord * _T_fireballmonster_EM_ST.xy + _T_fireballmonster_EM_ST.zw;
			float4 tex2DNode44 = tex2D( _T_fireballmonster_EM, uv_T_fireballmonster_EM );
			float4 lerpResult90 = lerp( ( ( fresnelNode77 * _fre_color ) + ( tex2D( _TextureSample2, panner67 ) * ( _TXlight_power * ( _SinTime.w + 1.5 ) ) * fresnelNode77 ) + ( tex2DNode44 * _em_color ) ) , ( tex2DNode44 * _em_eye ) , tex2DNode2.b);
			o.Emission = lerpResult90.rgb;
			float lerpResult6 = lerp( 0.0 , _metal , tex2DNode2.r);
			o.Metallic = lerpResult6;
			float lerpResult8 = lerp( 0.0 , _smoothness , tex2DNode2.g);
			o.Smoothness = lerpResult8;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

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
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
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
				fixed3 worldNormal = UnityObjectToWorldNormal( v.normal );
				fixed3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				fixed tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				fixed3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			fixed4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				fixed3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=13901
1927;29;1906;1004;1309.68;577.7415;1;True;True
Node;AmplifyShaderEditor.RangedFloatNode;76;-1968.294,1494.872;Float;False;Property;_texiao_uv;texiao_uv;10;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.TimeNode;69;-1913.368,1761.41;Float;False;0;5;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.TextureCoordinatesNode;63;-1799.847,1435.191;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.Vector2Node;68;-1806.571,1622.693;Float;False;Property;_TX_speed;TX_speed;9;0;0,0;0;3;FLOAT2;FLOAT;FLOAT
Node;AmplifyShaderEditor.SinTimeNode;75;-1488.296,1981.519;Float;False;0;5;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.PannerNode;67;-1588.872,1623.693;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-1,0;False;1;FLOAT;1.0;False;1;FLOAT2
Node;AmplifyShaderEditor.RangedFloatNode;78;-1277.085,1134.364;Float;False;Property;_fre_normal;fre_normal;12;0;0;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleAddOpNode;74;-1286.297,1997.519;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;1.5;False;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;72;-1433.297,1851.519;Float;False;Property;_TXlight_power;TXlight_power;7;0;0;0;2;0;1;FLOAT
Node;AmplifyShaderEditor.SamplerNode;3;-2410.117,547.9106;Float;True;Property;_T_fireballmonster_N;T_fireballmonster_N;2;0;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;73;-1118.298,1890.519;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.FresnelNode;77;-1072.299,1034.495;Float;True;Tangent;4;0;FLOAT3;0,0,0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;3;FLOAT;5.0;False;1;FLOAT
Node;AmplifyShaderEditor.SamplerNode;66;-1341.639,1545.876;Float;True;Property;_TextureSample2;Texture Sample 2;4;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.ColorNode;89;-1045.849,1272.423;Float;False;Property;_fre_color;fre_color;13;0;0,0,0,0;0;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;44;-1948.158,799.2875;Float;True;Property;_T_fireballmonster_EM;T_fireballmonster_EM;8;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;46;-1856.929,1035.208;Float;False;Property;_em_color;em_color;11;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;71;-721.7932,1568.006;Float;False;3;3;0;COLOR;0.0,0,0,0;False;1;FLOAT;0.0,0,0,0;False;2;FLOAT;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.RangedFloatNode;92;-1273.128,683.1306;Float;False;Property;_em_eye;em_eye;14;0;0;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;98;-985.531,-172.7756;Float;False;Property;_color_02;color_02;15;0;0;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;-1533.744,859.0528;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.SamplerNode;1;-1245.605,-513.4037;Float;True;Property;_T_fireballmonster_D;T_fireballmonster_D;0;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;12;-834.3647,-342.0924;Float;False;Property;_color_01;color_01;6;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;87;-740.7485,1147.738;Float;False;2;2;0;FLOAT;0.0;False;1;COLOR;0;False;1;COLOR
Node;AmplifyShaderEditor.RangedFloatNode;9;-762.3652,126.4073;Float;False;Property;_smoothness;smoothness;5;0;0;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleAddOpNode;83;-334.5636,832.7012;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;99;-770.531,-197.7756;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-623.3649,-378.0924;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;91;-1007.376,518.9463;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.SamplerNode;2;-1283.995,-10.46317;Float;True;Property;_T_fireballmonster_M;T_fireballmonster_M;1;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;7;-601.3652,15.40726;Float;False;Property;_metal;metal;3;0;0;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.LerpOp;90;-187.6496,567.5095;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.LerpOp;8;-547.3652,164.4073;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.LerpOp;97;-398.531,-237.7756;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.LerpOp;6;-438.3652,20.40726;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;279.2247,28.10987;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;monster_firebaall_shader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;Opaque;0.5;True;True;0;False;Opaque;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;63;0;76;0
WireConnection;67;0;63;0
WireConnection;67;2;68;0
WireConnection;67;1;69;1
WireConnection;74;0;75;4
WireConnection;73;0;72;0
WireConnection;73;1;74;0
WireConnection;77;0;3;0
WireConnection;77;3;78;0
WireConnection;66;1;67;0
WireConnection;71;0;66;0
WireConnection;71;1;73;0
WireConnection;71;2;77;0
WireConnection;51;0;44;0
WireConnection;51;1;46;0
WireConnection;87;0;77;0
WireConnection;87;1;89;0
WireConnection;83;0;87;0
WireConnection;83;1;71;0
WireConnection;83;2;51;0
WireConnection;99;0;1;0
WireConnection;99;1;98;0
WireConnection;11;0;1;0
WireConnection;11;1;12;0
WireConnection;91;0;44;0
WireConnection;91;1;92;0
WireConnection;90;0;83;0
WireConnection;90;1;91;0
WireConnection;90;2;2;3
WireConnection;8;1;9;0
WireConnection;8;2;2;2
WireConnection;97;0;11;0
WireConnection;97;1;99;0
WireConnection;97;2;2;3
WireConnection;6;1;7;0
WireConnection;6;2;2;1
WireConnection;0;0;97;0
WireConnection;0;1;3;0
WireConnection;0;2;90;0
WireConnection;0;3;6;0
WireConnection;0;4;8;0
ASEEND*/
//CHKSM=8A48234A633400D9117060F4429815D43E733871