// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "scene_shader/shader_Magicpot_base"
{
	Properties
	{
		_em_DY_warp_speed("em_DY_warp_speed", Float) = 0
		_em_DY_warp_Z("em_DY_warp_Z", Float) = 0
		_normal("normal", 2D) = "bump" {}
		_Texture0("Texture 0", 2D) = "white" {}
		_SM_MagicPot_M_MagicPot_AlbedoTransparency("SM_MagicPot_M_MagicPot_AlbedoTransparency", 2D) = "white" {}
		_rim_power("rim_power", Range( 0 , 5)) = 0
		_SM_MagicPot_M_MagicPot_Normal("SM_MagicPot_M_MagicPot_Normal", 2D) = "bump" {}
		_rim_range("rim_range", Range( 0 , 5)) = 0
		_SM_MagicPot_M_MagicPot_MetallicSmoothness("SM_MagicPot_M_MagicPot_MetallicSmoothness", 2D) = "white" {}
		_rim_color("rim_color", Color) = (0,0,0,0)
		_em_DY_pwoer("em_DY_pwoer", Float) = 1
		_em_DY_color("em_DY_color", Color) = (0,0,0,0)
		_Color1("Color 1", Color) = (1,1,1,0)
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
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			INTERNAL_DATA
			float3 worldNormal;
		};

		uniform sampler2D _SM_MagicPot_M_MagicPot_Normal;
		uniform float4 _SM_MagicPot_M_MagicPot_Normal_ST;
		uniform sampler2D _SM_MagicPot_M_MagicPot_AlbedoTransparency;
		uniform float4 _SM_MagicPot_M_MagicPot_AlbedoTransparency_ST;
		uniform float4 _Color1;
		uniform sampler2D _SM_MagicPot_M_MagicPot_MetallicSmoothness;
		uniform float4 _SM_MagicPot_M_MagicPot_MetallicSmoothness_ST;
		uniform float _rim_range;
		uniform float _rim_power;
		uniform float4 _rim_color;
		uniform sampler2D _Texture0;
		uniform sampler2D _normal;
		uniform float4 _normal_ST;
		uniform float _em_DY_warp_Z;
		uniform float _em_DY_warp_speed;
		uniform float _em_DY_pwoer;
		uniform float4 _em_DY_color;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_SM_MagicPot_M_MagicPot_Normal = i.uv_texcoord * _SM_MagicPot_M_MagicPot_Normal_ST.xy + _SM_MagicPot_M_MagicPot_Normal_ST.zw;
			float3 tex2DNode41 = UnpackNormal( tex2D( _SM_MagicPot_M_MagicPot_Normal, uv_SM_MagicPot_M_MagicPot_Normal ) );
			o.Normal = tex2DNode41;
			float2 uv_SM_MagicPot_M_MagicPot_AlbedoTransparency = i.uv_texcoord * _SM_MagicPot_M_MagicPot_AlbedoTransparency_ST.xy + _SM_MagicPot_M_MagicPot_AlbedoTransparency_ST.zw;
			float2 uv_SM_MagicPot_M_MagicPot_MetallicSmoothness = i.uv_texcoord * _SM_MagicPot_M_MagicPot_MetallicSmoothness_ST.xy + _SM_MagicPot_M_MagicPot_MetallicSmoothness_ST.zw;
			float4 tex2DNode42 = tex2D( _SM_MagicPot_M_MagicPot_MetallicSmoothness, uv_SM_MagicPot_M_MagicPot_MetallicSmoothness );
			float4 lerpResult48 = lerp( tex2D( _SM_MagicPot_M_MagicPot_AlbedoTransparency, uv_SM_MagicPot_M_MagicPot_AlbedoTransparency ) , _Color1 , tex2DNode42.b);
			o.Albedo = lerpResult48.rgb;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_worldTangent = WorldNormalVector( i, float3( 1, 0, 0 ) );
			float3 ase_worldBitangent = WorldNormalVector( i, float3( 0, 1, 0 ) );
			float3x3 ase_tangentToWorldFast = float3x3(ase_worldTangent.x,ase_worldBitangent.x,ase_worldNormal.x,ase_worldTangent.y,ase_worldBitangent.y,ase_worldNormal.y,ase_worldTangent.z,ase_worldBitangent.z,ase_worldNormal.z);
			float fresnelNdotV54 = dot( mul(ase_tangentToWorldFast,tex2DNode41), ase_worldViewDir );
			float fresnelNode54 = ( 0.0 + _rim_range * pow( 1.0 - fresnelNdotV54, _rim_power ) );
			float2 uv_normal = i.uv_texcoord * _normal_ST.xy + _normal_ST.zw;
			float2 temp_cast_1 = (_em_DY_warp_speed).xx;
			float2 panner17 = ( _Time.y * temp_cast_1 + float2( 0,0 ));
			float2 uv_TexCoord18 = i.uv_texcoord + panner17;
			float4 lerpResult43 = lerp( saturate( ( fresnelNode54 * _rim_color ) ) , ( tex2D( _Texture0, ( ( (UnpackNormal( tex2D( _normal, uv_normal ) )).xy * _em_DY_warp_Z ) + uv_TexCoord18 ) ) * _em_DY_pwoer * _em_DY_color ) , tex2DNode42.b);
			o.Emission = lerpResult43.rgb;
			o.Metallic = tex2DNode42.r;
			o.Smoothness = tex2DNode42.g;
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
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
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
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
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
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
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
Version=16201
1921;3;1918;1014;2582.07;288.9767;1.686082;True;False
Node;AmplifyShaderEditor.TexturePropertyNode;27;-3941.672,421.3389;Float;True;Property;_normal;normal;2;0;Create;True;0;0;False;0;f769dd2442456724bae8cfc0a494f0a1;f769dd2442456724bae8cfc0a494f0a1;True;bump;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SamplerNode;29;-3603.987,433.7667;Float;True;Property;_TextureSample0;Texture Sample 0;4;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;15;-3633.998,794.8608;Float;False;Property;_em_DY_warp_speed;em_DY_warp_speed;0;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;14;-3412.998,959.8608;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;19;-3264.714,425.0555;Float;False;True;True;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-3294.331,569.2823;Float;False;Property;_em_DY_warp_Z;em_DY_warp_Z;1;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;17;-3208.794,777.1685;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-1405.12,860.5663;Float;False;Property;_rim_power;rim_power;5;0;Create;True;0;0;False;0;0;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;52;-1421.119,780.5667;Float;False;Property;_rim_range;rim_range;7;0;Create;True;0;0;False;0;0;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;41;-1963.365,-30.17281;Float;True;Property;_SM_MagicPot_M_MagicPot_Normal;SM_MagicPot_M_MagicPot_Normal;6;0;Create;True;0;0;False;0;52fd4d971dd2f734589c78032370f7a1;52fd4d971dd2f734589c78032370f7a1;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;50;-1325.12,572.566;Float;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TextureCoordinatesNode;18;-2940.997,777.8608;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2;-3007.135,448.0241;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;32;-3099.903,177.7782;Float;True;Property;_Texture0;Texture 0;3;0;Create;True;0;0;False;0;553857c21dbfe2e46a76b1fe03ff12f1;553857c21dbfe2e46a76b1fe03ff12f1;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleAddOpNode;21;-2656.996,522.861;Float;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;53;-1005.12,940.5665;Float;False;Property;_rim_color;rim_color;9;0;Create;True;0;0;False;0;0,0,0,0;0,0.3296814,1,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;54;-957.1203,620.5662;Float;False;Standard;TangentNormal;ViewDir;False;5;0;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;46;-1989.825,554.4221;Float;False;Property;_em_DY_color;em_DY_color;11;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;30;-2307.822,384.6396;Float;True;Property;_TextureSample1;Texture Sample 1;4;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;45;-1986.825,281.4221;Float;False;Property;_em_DY_pwoer;em_DY_pwoer;10;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-765.1035,875.4308;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;42;-2007.855,-238.8938;Float;True;Property;_SM_MagicPot_M_MagicPot_MetallicSmoothness;SM_MagicPot_M_MagicPot_MetallicSmoothness;8;0;Create;True;0;0;False;0;7527e8c99d64b154a9f7b4f0c40510bc;7527e8c99d64b154a9f7b4f0c40510bc;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;49;-1039.878,-385.1643;Float;False;Property;_Color1;Color 1;12;0;Create;True;0;0;False;0;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;40;-2005.971,-536.7972;Float;True;Property;_SM_MagicPot_M_MagicPot_AlbedoTransparency;SM_MagicPot_M_MagicPot_AlbedoTransparency;4;0;Create;True;0;0;False;0;b2e02db2387419b498aecf926e865611;b2e02db2387419b498aecf926e865611;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-1709.239,313.7573;Float;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;56;-517.2812,641.179;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;48;-587.1741,-437.9356;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;43;-527.8254,271.2953;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;12;218.3256,19.9596;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;scene_shader/shader_Magicpot_base;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;29;0;27;0
WireConnection;19;0;29;0
WireConnection;17;2;15;0
WireConnection;17;1;14;0
WireConnection;18;1;17;0
WireConnection;2;0;19;0
WireConnection;2;1;20;0
WireConnection;21;0;2;0
WireConnection;21;1;18;0
WireConnection;54;0;41;0
WireConnection;54;4;50;0
WireConnection;54;2;52;0
WireConnection;54;3;51;0
WireConnection;30;0;32;0
WireConnection;30;1;21;0
WireConnection;55;0;54;0
WireConnection;55;1;53;0
WireConnection;44;0;30;0
WireConnection;44;1;45;0
WireConnection;44;2;46;0
WireConnection;56;0;55;0
WireConnection;48;0;40;0
WireConnection;48;1;49;0
WireConnection;48;2;42;3
WireConnection;43;0;56;0
WireConnection;43;1;44;0
WireConnection;43;2;42;3
WireConnection;12;0;48;0
WireConnection;12;1;41;0
WireConnection;12;2;43;0
WireConnection;12;3;42;1
WireConnection;12;4;42;2
ASEEND*/
//CHKSM=8A50EE9A68BEE9CC8ACBF20C197030F9EBB12E7D