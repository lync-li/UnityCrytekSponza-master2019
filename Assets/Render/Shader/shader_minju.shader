// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "shader_minju"
{
	Properties
	{
		_minju01_D("minju01_D", 2D) = "white" {}
		_minju01_N("minju01_N", 2D) = "bump" {}
		_shadow_power("shadow_power", Range( 0 , 3)) = 0
		_shadowcolor("shadow color", Color) = (0,0,0,0)
		_basecolor_contrast("basecolor_contrast", Range( 0.5 , 3)) = 0
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_T_minju01_M("T_minju01_M", 2D) = "white" {}
		_wood_Smoothness("wood_Smoothness", Float) = 0
		_Metal_Smoothness("Metal_Smoothness", Float) = 0
		_rim_power("rim_power", Range( 0 , 5)) = 0
		_rim_range("rim_range", Range( 0 , 5)) = 0
		_rim_color("rim_color", Color) = (0,0,0,0)
		_normal("normal", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
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
			float2 uv2_texcoord2;
			float3 worldPos;
			INTERNAL_DATA
			float3 worldNormal;
		};

		uniform sampler2D _minju01_N;
		uniform float4 _minju01_N_ST;
		uniform float _normal;
		uniform sampler2D _minju01_D;
		uniform float4 _minju01_D_ST;
		uniform float _basecolor_contrast;
		uniform float4 _shadowcolor;
		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform float _shadow_power;
		uniform float _rim_range;
		uniform float _rim_power;
		uniform float4 _rim_color;
		uniform sampler2D _T_minju01_M;
		uniform float4 _T_minju01_M_ST;
		uniform float _wood_Smoothness;
		uniform float _Metal_Smoothness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_minju01_N = i.uv_texcoord * _minju01_N_ST.xy + _minju01_N_ST.zw;
			float3 tex2DNode2 = UnpackNormal( tex2D( _minju01_N, uv_minju01_N ) );
			float4 appendResult70 = (float4(( tex2DNode2.r * _normal ) , ( tex2DNode2.g * _normal ) , tex2DNode2.b , 0.0));
			float4 normalizeResult60 = normalize( appendResult70 );
			o.Normal = normalizeResult60.xyz;
			float2 uv_minju01_D = i.uv_texcoord * _minju01_D_ST.xy + _minju01_D_ST.zw;
			float2 uv2_TextureSample0 = i.uv2_texcoord2 * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float4 temp_cast_1 = (_shadow_power).xxxx;
			float4 temp_output_28_0 = ( 1.0 - pow( tex2D( _TextureSample0, uv2_TextureSample0 ) , temp_cast_1 ) );
			float4 lerpResult23 = lerp( float4( 0,0,0,0 ) , _shadowcolor , temp_output_28_0);
			float4 lerpResult27 = lerp( ( tex2D( _minju01_D, uv_minju01_D ) * _basecolor_contrast ) , lerpResult23 , temp_output_28_0);
			o.Albedo = saturate( lerpResult27 ).rgb;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_worldTangent = WorldNormalVector( i, float3( 1, 0, 0 ) );
			float3 ase_worldBitangent = WorldNormalVector( i, float3( 0, 1, 0 ) );
			float3x3 ase_tangentToWorldFast = float3x3(ase_worldTangent.x,ase_worldBitangent.x,ase_worldNormal.x,ase_worldTangent.y,ase_worldBitangent.y,ase_worldNormal.y,ase_worldTangent.z,ase_worldBitangent.z,ase_worldNormal.z);
			float fresnelNdotV41 = dot( mul(ase_tangentToWorldFast,tex2DNode2), ase_worldViewDir );
			float fresnelNode41 = ( 0.0 + _rim_range * pow( 1.0 - fresnelNdotV41, _rim_power ) );
			o.Emission = saturate( ( fresnelNode41 * _rim_color ) ).rgb;
			float2 uv_T_minju01_M = i.uv_texcoord * _T_minju01_M_ST.xy + _T_minju01_M_ST.zw;
			float4 tex2DNode32 = tex2D( _T_minju01_M, uv_T_minju01_M );
			o.Metallic = tex2DNode32.r;
			float lerpResult35 = lerp( ( _wood_Smoothness * tex2DNode32.g ) , ( _Metal_Smoothness * tex2DNode32.g ) , tex2DNode32.r);
			o.Smoothness = lerpResult35;
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
				float4 customPack1 : TEXCOORD1;
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
				o.customPack1.zw = customInputData.uv2_texcoord2;
				o.customPack1.zw = v.texcoord1;
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
				surfIN.uv2_texcoord2 = IN.customPack1.zw;
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
1087;409;1906;1004;669.7854;584.1525;1;False;True
Node;AmplifyShaderEditor.SamplerNode;31;-1496.504,-347.4437;Float;True;Property;_TextureSample0;Texture Sample 0;5;0;Create;True;0;0;False;0;None;9d6798d2f0ec9654bbeadbe276c587c1;True;1;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;17;-1378.743,-150.8575;Float;False;Property;_shadow_power;shadow_power;2;0;Create;True;0;0;False;0;0;0.54;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;25;-1140.65,-279.067;Float;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;2;-936.0295,424.8442;Float;True;Property;_minju01_N;minju01_N;1;0;Create;True;0;0;False;0;None;13719c93da1876049acaadea97e4e5a9;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;28;-894.8419,-292.6093;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-629.1115,663.3038;Float;False;Property;_normal;normal;12;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-589.1282,-563.5415;Float;False;Property;_rim_range;rim_range;10;0;Create;True;0;0;False;0;0;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-584.295,-482.8665;Float;False;Property;_rim_power;rim_power;9;0;Create;True;0;0;False;0;0;1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;26;-971.7475,-138.667;Float;False;Property;_shadowcolor;shadow color;3;0;Create;True;0;0;False;0;0,0,0,0;0.2922235,0.1557093,0.3308823,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;30;-961.4093,-563.4771;Float;False;Property;_basecolor_contrast;basecolor_contrast;4;0;Create;True;0;0;False;0;0;1.04;0.5;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;56;-502.8286,-773.4236;Float;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;1;-1035.651,-770.6296;Float;True;Property;_minju01_D;minju01_D;0;0;Create;True;0;0;False;0;None;ef13eb2b555df2b4fa337fabd80d91ad;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;34;-610.2095,230.8174;Float;False;Property;_Metal_Smoothness;Metal_Smoothness;8;0;Create;True;0;0;False;0;0;0.48;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-550.2095,-116.1826;Float;False;Property;_wood_Smoothness;wood_Smoothness;7;0;Create;True;0;0;False;0;0;0.13;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;32;-764.522,-1.12561;Float;True;Property;_T_minju01_M;T_minju01_M;6;0;Create;True;0;0;False;0;None;1fa0f13d7329f4e4abc702a5e6e7a5e6;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;72;-372.0415,366.299;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;73;-292.0415,497.299;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;41;-133.9557,-716.9592;Float;False;Standard;TangentNormal;ViewDir;False;5;0;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;42;-172.1289,-400.5416;Float;False;Property;_rim_color;rim_color;11;0;Create;True;0;0;False;0;0,0,0,0;0.5019608,0.5019608,0.5019608,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-673.4093,-667.4771;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;23;-693.6498,-218.29;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;70;-13.47039,627.6179;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;-334.947,157.0248;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-289.947,-92.97522;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;27;-367.6168,-299.9889;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;64.01674,-465.1356;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.NormalizeNode;60;187.9045,549.9574;Float;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;35;-114.2095,-7.182621;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;74;60.74232,-229.4233;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;75;365.7935,-441.4167;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;649.4288,-179.7104;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;shader_minju;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;25;0;31;0
WireConnection;25;1;17;0
WireConnection;28;0;25;0
WireConnection;72;0;2;1
WireConnection;72;1;49;0
WireConnection;73;0;2;2
WireConnection;73;1;49;0
WireConnection;41;0;2;0
WireConnection;41;4;56;0
WireConnection;41;2;39;0
WireConnection;41;3;40;0
WireConnection;29;0;1;0
WireConnection;29;1;30;0
WireConnection;23;1;26;0
WireConnection;23;2;28;0
WireConnection;70;0;72;0
WireConnection;70;1;73;0
WireConnection;70;2;2;3
WireConnection;46;0;34;0
WireConnection;46;1;32;2
WireConnection;44;0;38;0
WireConnection;44;1;32;2
WireConnection;27;0;29;0
WireConnection;27;1;23;0
WireConnection;27;2;28;0
WireConnection;43;0;41;0
WireConnection;43;1;42;0
WireConnection;60;0;70;0
WireConnection;35;0;44;0
WireConnection;35;1;46;0
WireConnection;35;2;32;1
WireConnection;74;0;27;0
WireConnection;75;0;43;0
WireConnection;0;0;74;0
WireConnection;0;1;60;0
WireConnection;0;2;75;0
WireConnection;0;3;32;1
WireConnection;0;4;35;0
ASEEND*/
//CHKSM=D5721D7AC94E268D3C6D1C1C98562CD87786715A