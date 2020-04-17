// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "body_shader/Shader_BodyChageColor"
{
	Properties
	{
		_T_AxeSoldier_Basecolor("T_AxeSoldier_Basecolor", 2D) = "white" {}
		_T_AxeSoldier_MetallicSmoothness("T_AxeSoldier_MetallicSmoothness", 2D) = "white" {}
		_T_AxeSoldier_Normal("T_AxeSoldier_Normal", 2D) = "bump" {}
		_unmetal_smoothness("unmetal_smoothness", Float) = 0
		_metal_smoothness("metal_smoothness", Float) = 0
		_skin_color("skin_color", Color) = (1,1,1,0)
		_cap_sheild_color("cap_sheild_color", Color) = (1,1,1,0)
		_rim_power("rim_power", Range( 0 , 5)) = 0
		_rim_range("rim_range", Range( 0 , 5)) = 0
		_rim_color("rim_color", Color) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
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

		uniform sampler2D _T_AxeSoldier_Normal;
		uniform float4 _T_AxeSoldier_Normal_ST;
		uniform sampler2D _T_AxeSoldier_Basecolor;
		uniform float4 _T_AxeSoldier_Basecolor_ST;
		uniform float4 _cap_sheild_color;
		uniform sampler2D _T_AxeSoldier_MetallicSmoothness;
		uniform float4 _T_AxeSoldier_MetallicSmoothness_ST;
		uniform float4 _skin_color;
		uniform float _rim_range;
		uniform float _rim_power;
		uniform float4 _rim_color;
		uniform float _metal_smoothness;
		uniform float _unmetal_smoothness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_T_AxeSoldier_Normal = i.uv_texcoord * _T_AxeSoldier_Normal_ST.xy + _T_AxeSoldier_Normal_ST.zw;
			float3 tex2DNode4 = UnpackNormal( tex2D( _T_AxeSoldier_Normal, uv_T_AxeSoldier_Normal ) );
			o.Normal = tex2DNode4;
			float2 uv_T_AxeSoldier_Basecolor = i.uv_texcoord * _T_AxeSoldier_Basecolor_ST.xy + _T_AxeSoldier_Basecolor_ST.zw;
			float4 tex2DNode1 = tex2D( _T_AxeSoldier_Basecolor, uv_T_AxeSoldier_Basecolor );
			float2 uv_T_AxeSoldier_MetallicSmoothness = i.uv_texcoord * _T_AxeSoldier_MetallicSmoothness_ST.xy + _T_AxeSoldier_MetallicSmoothness_ST.zw;
			float4 tex2DNode2 = tex2D( _T_AxeSoldier_MetallicSmoothness, uv_T_AxeSoldier_MetallicSmoothness );
			float4 lerpResult19 = lerp( tex2DNode1 , ( tex2DNode1 * _cap_sheild_color ) , tex2DNode2.a);
			float4 lerpResult13 = lerp( lerpResult19 , ( tex2DNode1 * _skin_color ) , tex2DNode2.b);
			o.Albedo = lerpResult13.rgb;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_worldTangent = WorldNormalVector( i, float3( 1, 0, 0 ) );
			float3 ase_worldBitangent = WorldNormalVector( i, float3( 0, 1, 0 ) );
			float3x3 ase_tangentToWorldFast = float3x3(ase_worldTangent.x,ase_worldBitangent.x,ase_worldNormal.x,ase_worldTangent.y,ase_worldBitangent.y,ase_worldNormal.y,ase_worldTangent.z,ase_worldBitangent.z,ase_worldNormal.z);
			float fresnelNdotV25 = dot( mul(ase_tangentToWorldFast,tex2DNode4), ase_worldViewDir );
			float fresnelNode25 = ( 0.0 + _rim_range * pow( 1.0 - fresnelNdotV25, _rim_power ) );
			o.Emission = saturate( ( fresnelNode25 * _rim_color ) ).rgb;
			o.Metallic = tex2DNode2.r;
			float lerpResult5 = lerp( ( tex2DNode2.g * _metal_smoothness ) , ( tex2DNode2.g * _unmetal_smoothness ) , ( 1.0 - tex2DNode2.r ));
			o.Smoothness = lerpResult5;
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
1927;7;1906;1004;497.2518;343.7366;1.066859;True;False
Node;AmplifyShaderEditor.SamplerNode;1;-935,-305.5;Float;True;Property;_T_AxeSoldier_Basecolor;T_AxeSoldier_Basecolor;0;0;Create;True;0;0;False;0;f733c049562afcf488c91f9a2b81f19e;f733c049562afcf488c91f9a2b81f19e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;17;-959.413,-603.6198;Float;False;Property;_cap_sheild_color;cap_sheild_color;6;0;Create;True;0;0;False;0;1,1,1,0;0.3803921,0.2509804,0.6705883,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;24;-80.70203,466.3312;Float;False;Property;_rim_range;rim_range;8;0;Create;True;0;0;False;0;0;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-64.70236,546.3306;Float;False;Property;_rim_power;rim_power;7;0;Create;True;0;0;False;0;0;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;4;-545,389.5;Float;True;Property;_T_AxeSoldier_Normal;T_AxeSoldier_Normal;2;0;Create;True;0;0;False;0;1dd165aed35cc0d4ab0720359c33cc5e;1dd165aed35cc0d4ab0720359c33cc5e;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;26;-47.48886,232.3969;Float;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.FresnelNode;25;383.2974,306.3308;Float;False;Standard;TangentNormal;ViewDir;False;5;0;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-617.4129,-543.6198;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;16;-800.413,-114.6198;Float;False;Property;_skin_color;skin_color;5;0;Create;True;0;0;False;0;1,1,1,0;0.517647,0.427451,0.9058824,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;20;374.8806,553.9895;Float;False;Property;_rim_color;rim_color;9;0;Create;True;0;0;False;0;0,0,0,0;0.4339623,0.4339623,0.4339623,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;10;-618,108.5;Float;False;Property;_metal_smoothness;metal_smoothness;4;0;Create;True;0;0;False;0;0;4.92;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-951,41.5;Float;True;Property;_T_AxeSoldier_MetallicSmoothness;T_AxeSoldier_MetallicSmoothness;1;0;Create;True;0;0;False;0;7fe808c43b6e3ac47bc63b6338d750f6;7fe808c43b6e3ac47bc63b6338d750f6;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;8;-689,243.5;Float;False;Property;_unmetal_smoothness;unmetal_smoothness;3;0;Create;True;0;0;False;0;0;0.46;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;614.8973,488.854;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-417,68.5;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;6;-605,318.5;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-502,216.5;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;19;-407.413,-436.6198;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-458.413,-76.61975;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;22;916.6744,512.5728;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;5;-281,141.5;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;13;-170.413,-223.6198;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1105.213,-67.43595;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;body_shader/Shader_BodyChageColor;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;25;0;4;0
WireConnection;25;4;26;0
WireConnection;25;2;24;0
WireConnection;25;3;23;0
WireConnection;18;0;1;0
WireConnection;18;1;17;0
WireConnection;21;0;25;0
WireConnection;21;1;20;0
WireConnection;9;0;2;2
WireConnection;9;1;10;0
WireConnection;6;0;2;1
WireConnection;7;0;2;2
WireConnection;7;1;8;0
WireConnection;19;0;1;0
WireConnection;19;1;18;0
WireConnection;19;2;2;4
WireConnection;14;0;1;0
WireConnection;14;1;16;0
WireConnection;22;0;21;0
WireConnection;5;0;9;0
WireConnection;5;1;7;0
WireConnection;5;2;6;0
WireConnection;13;0;19;0
WireConnection;13;1;14;0
WireConnection;13;2;2;3
WireConnection;0;0;13;0
WireConnection;0;1;4;0
WireConnection;0;2;22;0
WireConnection;0;3;2;1
WireConnection;0;4;5;0
ASEEND*/
//CHKSM=D8C78B3F611E8784661ED4AB4A2FC1321E4949D1