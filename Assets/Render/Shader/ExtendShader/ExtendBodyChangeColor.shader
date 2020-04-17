// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)

Shader "Extend/BodyChangeColor"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("Albedo", 2D) = "white" {}

		_Cutoff("Alpha Cutoff", Range(0.0, 1.0)) = 0.5
		
		_unmetal_smoothness("unmetal_smoothness", Float) = 0
		_metal_smoothness("metal_smoothness", Float) = 0
		_skin_color("skin_color", Color) = (1,1,1,0)
		_cap_sheild_color("cap_sheild_color", Color) = (1,1,1,0)
		_rim_power("rim_power", Range( 0 , 5)) = 0
		_rim_range("rim_range", Range( 0 , 5)) = 0
		_rim_color("rim_color", Color) = (0,0,0,0)	

		_MetallicGlossMap("Metallic", 2D) = "white" {}

		_BumpScale("Scale", Float) = 1.0
		_BumpMap("Normal Map", 2D) = "bump" {}

		_Parallax("Height Scale", Range(0.005, 0.08)) = 0.02
		_ParallaxMap("Height Map", 2D) = "black" {}

		_OcclusionStrength("Strength", Range(0.0, 1.0)) = 1.0
		_OcclusionMap("Occlusion", 2D) = "white" {}

		_EmissionColor("Color", Color) = (0,0,0)
		_EmissionMap("Emission", 2D) = "white" {}
	
		[Toggle(_GPUANIM)] _GpuAnim("GpuAnim", Float) = 0	
		_AnimPosTex("Pos Tex",2D) = ""{}
		_AnimNormalTex("Normal Tex",2D) = ""{}
		_AnimTangentTex("Tangent Tex",2D) = ""{}
		_StartEndFrame("Start End Frame",Vector) = (0,1,0,1) // startTime,oldStartTime,framerate,loop
		_AnimParam0("AnimParam0",Vector) = (0,0,0,0)
		_AnimParam1("AnimParam1",Vector) = (0,0,0,0)

		// Blending state
		[HideInInspector] _Mode("__mode", Float) = 0.0
		[HideInInspector] _SrcBlend("__src", Float) = 1.0
		[HideInInspector] _DstBlend("__dst", Float) = 0.0		
		[HideInInspector] _SrcAlpha("__src", Float) = 1.0
		[HideInInspector] _DstAlpha("__dst", Float) = 0.0
		[HideInInspector] _ZWrite("__zw", Float) = 1.0
		[HideInInspector] _Cull("__cull", Float) = 1.0
	}

	CGINCLUDE
		#define UNITY_SETUP_BRDF_INPUT BodyChangeSetup
		#define _BODYCHANGECOLOR 1
		#define _GPURIM 1	
		sampler2D _AnimPosTex;
		float4 _AnimPosTex_TexelSize;
		sampler2D _AnimNormalTex;
		float4 _AnimNormalTex_TexelSize;
		sampler2D _AnimTangentTex;
		float4 _AnimTangentTex_TexelSize;

		inline float GetY(float startFrame, float endFrame, float4 animParam) {
			float totalLen = _AnimPosTex_TexelSize.w * animParam.w;
			float start = startFrame / _AnimPosTex_TexelSize.w;
			float end = (endFrame - 1) / _AnimPosTex_TexelSize.w;
			float len = end - start;
			float time = (_Time.y - animParam.x) *  animParam.z / totalLen;
			float y = start + time % len;

			float loopOnce = saturate(sign(time - len));
			y = lerp(y, end, animParam.y * loopOnce);

			return y;
		}
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
			#pragma shader_feature _EMISSION
			#pragma shader_feature _METALLICGLOSSMAP
			#pragma shader_feature ___ _DETAIL_MULX2
			#pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
			#pragma shader_feature _ _SPECULARHIGHLIGHTS_OFF
			#pragma shader_feature _ _GLOSSYREFLECTIONS_OFF
			#pragma shader_feature _PARALLAXMAP		
			#pragma multi_compile __ _GPUANIM			

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

            #pragma shader_feature _EMISSION
            #pragma shader_feature _METALLICGLOSSMAP
            #pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
            #pragma shader_feature ___ _DETAIL_MULX2
            #pragma shader_feature EDITOR_VISUALIZATION

            #include "ExtendUnityStandardMeta.cginc"
            ENDCG
        }
	}
	FallBack "VertexLit"
	CustomEditor "ExtendBodyChangeColorShaderGUI"
}
