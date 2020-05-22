// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)

Shader "Extend/Standard"
{
	Properties
	{
		[HDR]_Color("Color", Color) = (1,1,1,1)
		_MainTex("Albedo", 2D) = "white" {}

		_Cutoff("Alpha Cutoff", Range(0.0, 1.0)) = 0.5

		_Glossiness("Smoothness", Range(0.0, 1.0)) = 0.5
		_GlossMapScale("Smoothness Scale", Range(0.0, 1.0)) = 1.0
		[Enum(MetallicR SmoothnessAlpha,0,MetallicR SmoothnessG,1)] _SmoothnessTextureChannel("Smoothness texture channel", Float) = 0

		[Gamma] _Metallic("Metallic", Range(0.0, 1.0)) = 0.0
		_MetallicGlossMap("Metallic", 2D) = "white" {}

		_BumpScale("Scale", Float) = 1.0
		_BumpMap("Normal Map", 2D) = "bump" {}

		_Parallax("Height Scale", Range(0.005, 0.08)) = 0.02
		_ParallaxMap("Height Map", 2D) = "black" {}

		_OcclusionStrength("Strength", Range(0.0, 1.0)) = 1.0
		_OcclusionMap("Occlusion", 2D) = "white" {}

		[Enum(_NONE,0,_EMISSION_UNITY,1,_EMISSION_TYPE0,2)] _EmissionMode("EmissionMode", Float) = 0	
		_EmissionColor("Color", Color) = (0,0,0)
		_EmissionMap("Emission", 2D) = "white" {}

		
		_EmissionColor1("Color", Color) = (0,0,0)
		_EmissionMap1("Emission", 2D) = "white" {}

		_EmissionAlpha("EmissionAlpha", 2D) = "white" {}
		_EmissionBaseColor("EmissionBaseColor", Color) = (0,0,0)

		_DetailMask("Detail Mask", 2D) = "white" {}
		[Enum(_DETAIL_MULX2,0,_DETAIL_MUL,1,_DETAIL_ADD,2,_DETAIL_LERP,3)] _DetailBlendMode("DetailBlendMode", Float) = 0	

		_DetailAlbedoMap("Detail Albedo x2", 2D) = "grey" {}
		_DetailNormalMapScale("Scale", Float) = 1.0
		_DetailNormalMap("Normal Map", 2D) = "bump" {}

		[Enum(UV0,0,UV1,1)] _UVSec("UV Set for secondary textures", Float) = 0
		
		[Toggle(_VERTEXALPHA)] _VertexAlpha("VertexAlpha", Float) = 0
		_VertexColorAlpha("VertexColor Alpha", Range(0.0, 2.0)) = 1.0
		
		[Toggle(_VERTEXCOLOR)] _VertexColorEnable("VertexColorEnable", Float) = 0
		[HDR]_VertexColor("VertexColor", Color) = (1,1,1,1)

		[Toggle(_EXTENDALPHA)] _ExtendAlpha("Extend Alpha", Float) = 0	
		[Toggle(_PLAYER)] _Player("Player", Float) = 0	
		
		[Toggle(_RECEIVEFOG)] _ReceiveFog("receiveFog", Float) = 1	

		[Toggle(_RIMENABLE)] _RimEnable("rimEnable", Float) = 0
		[HDR]_RimColor("rimColor", Color) = (1,1,1,1)
		_RimPower("rimPower", Range(1, 30)) = 5
		
		[Toggle(_VERTEXANIMATION)] _VertexAnimation("vertexAnimation", Float) = 0
		_MoveRange("moveRange", Range(0,5)) = 0.2
		_MoveRate("moveRate", Range(0,5)) = 1
		_MoveRandom("moveRandom", Range(0,10)) = 5
		
		[Toggle(_UVANIMATION)] _UVAnimation("UVAnimation", Float) = 0

		// Blending state
		[HideInInspector] _Mode("__mode", Float) = 0.0
		[HideInInspector] _SrcBlend("__src", Float) = 1.0
		[HideInInspector] _DstBlend("__dst", Float) = 0.0		
		[HideInInspector] _SrcAlpha("__src", Float) = 1.0
		[HideInInspector] _DstAlpha("__dst", Float) = 0.0
		[HideInInspector] _ZWrite("__zw", Float) = 0
		[HideInInspector] _Cull("__cull", Float) = 2.0
	}

	CGINCLUDE
		#define UNITY_SETUP_BRDF_INPUT MetallicSetup

	ENDCG
	SubShader
	{
		Tags{ "RenderType" = "Opaque" "PerformanceChecks" = "False" }
		LOD 300

	
		// ------------------------------------------------------------------
		//  Base forward pass (directional light, emission, lightmaps, ...)
		Pass
		{
			Name "FORWARD"
			Tags{ "LightMode" = "ForwardBase" }

			Blend[_SrcBlend][_DstBlend],[_SrcAlpha][_DstAlpha]
			ZWrite[_ZWrite]
			Cull[_Cull]

           		CGPROGRAM
           		#pragma target 3.0

			// -------------------------------------

			#pragma shader_feature _NORMALMAP
			#pragma shader_feature _ _ALPHATEST_ON _ALPHABLEND_ON _ALPHAPREMULTIPLY_ON
			#pragma shader_feature _ _EMISSION_UNITY _EMISSION_TYPE0 
			#pragma shader_feature _METALLICGLOSSMAP
			#pragma shader_feature ___ _DETAIL_MULX2 _DETAIL_MUL _DETAIL_ADD _DETAIL_LERP
			#pragma shader_feature _  _SMOOTHNESS_TEXTURE_METAL_G
			//#pragma shader_feature _ _SPECULARHIGHLIGHTS_OFF
			//#pragma shader_feature _ _GLOSSYREFLECTIONS_OFF
			#pragma shader_feature _PARALLAXMAP
			#pragma shader_feature _VERTEXALPHA
			#pragma shader_feature _EXTENDALPHA
			#pragma shader_feature _PLAYER
			#pragma shader_feature _RECEIVEFOG
			#pragma shader_feature _RIMENABLE
			#pragma shader_feature _VERTEXCOLOR
			#pragma shader_feature _UVANIMATION
			#pragma shader_feature _VERTEXANIMATION
			
			//#pragma multi_compile __ _ALPHABUFFER
			#pragma multi_compile __ _MRT
			//#pragma multi_compile __ _HEIGHTFOG

			#pragma multi_compile_fwdbase
			#pragma multi_compile_fog
			#pragma multi_compile_instancing
			
			#pragma skip_variants VERTEXLIGHT_ON			

			#pragma vertex vertBase
			#pragma fragment fragBase
			#include "ExtendUnityStandardCoreForward.cginc"

			ENDCG
		}
		// ------------------------------------------------------------------
		//  Additive forward pass (one light per pass)
		Pass
		{
			Name "FORWARD_DELTA"
			Tags{ "LightMode" = "ForwardAdd" }
			Blend[_SrcBlend] One,Zero One
			Fog{ Color(0,0,0,0) } // in additive pass fog should be black
			ZWrite Off
			ZTest LEqual
			Cull[_Cull]

           		CGPROGRAM
            		#pragma target 3.0

			// -------------------------------------


			#pragma shader_feature _NORMALMAP
			#pragma shader_feature _ _ALPHATEST_ON _ALPHABLEND_ON _ALPHAPREMULTIPLY_ON
			#pragma shader_feature _METALLICGLOSSMAP
			#pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A _SMOOTHNESS_TEXTURE_METAL_G
			//#pragma shader_feature _ _SPECULARHIGHLIGHTS_OFF
			#pragma shader_feature ___ _DETAIL_MULX2 _DETAIL_MUL _DETAIL_ADD _DETAIL_LERP
			#pragma shader_feature _PARALLAXMAP
			#pragma shader_feature _EXTENDALPHA
			#pragma shader_feature _RECEIVEFOG
			#pragma shader_feature _UVANIMATION
			#pragma shader_feature _VERTEXANIMATION
			
			//#pragma shader_feature _PLAYER
			//#pragma multi_compile __ _ALPHABUFFER
			//#pragma multi_compile __ _HEIGHTFOG
			//#pragma multi_compile __ _MRT

			#pragma multi_compile_fwdadd_fullshadows
			#pragma multi_compile_fog

			#pragma vertex vertAdd
			#pragma fragment fragAdd
			#include "ExtendUnityStandardCoreForward.cginc"

			ENDCG
		}
		// ------------------------------------------------------------------
		//  Shadow rendering pass
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }

			ZWrite On ZTest LEqual
			Cull[_Cull]

           	CGPROGRAM
            #pragma target 3.0

			// -------------------------------------

			#pragma shader_feature _ _ALPHATEST_ON _ALPHABLEND_ON _ALPHAPREMULTIPLY_ON
			#pragma shader_feature _METALLICGLOSSMAP
			#pragma shader_feature _PARALLAXMAP
			#pragma shader_feature _VERTEXANIMATION
			
			#pragma multi_compile_shadowcaster
			#pragma multi_compile_instancing

			#pragma vertex vertShadowCaster
			#pragma fragment fragShadowCaster

			#include "ExtendUnityStandardShadow.cginc"

			ENDCG
		}
	

        // ------------------------------------------------------------------
        // Extracts information for lightmapping, GI (emission, albedo, ...)
        // This pass it not used during regular rendering.
        Pass
        {
            Name "META"
            Tags { "LightMode"="Meta" }

            Cull Off

            CGPROGRAM
            #pragma vertex vert_meta
            #pragma fragment frag_meta

            #pragma shader_feature _EMISSION_UNITY
            #pragma shader_feature _METALLICGLOSSMAP
            #pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A _SMOOTHNESS_TEXTURE_METAL_G
            #pragma shader_feature ___ _DETAIL_MULX2
            #pragma shader_feature EDITOR_VISUALIZATION

            #include "ExtendUnityStandardMeta.cginc"
            ENDCG
        }
	}
	FallBack "VertexLit"
	CustomEditor "ExtendStandardShaderGUI"
}
