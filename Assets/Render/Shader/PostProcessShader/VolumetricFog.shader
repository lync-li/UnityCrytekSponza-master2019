Shader "Hidden/DragonVolumetricFog" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	
	SubShader {
       	ZTest Always Cull Off ZWrite Off
       	Fog { Mode Off }
       	
		Pass { // 0 general fog render
			Blend One OneMinusSrcAlpha  
			//Blend One Zero  
	        CGPROGRAM

			#pragma vertex VertDefault
			#pragma fragment fragBackFog
			//#pragma multi_compile __ FOG_DISTANCE
			#define WORLDPOS 1
			
			#pragma target 3.0
			#include "VolumetricFog.cginc"
			ENDCG
        }
		Pass { // 1 downsampled, with render targets
	        CGPROGRAM
			#pragma vertex VertDefault
			#pragma fragment fragGetFog
			//#pragma multi_compile __ FOG_DISTANCE
			//#define FOG_DIFFUSION 1
			#define WORLDPOS 1
			
			#pragma target 3.0
			#include "VolumetricFog.cginc"
			ENDCG
        }        
		Pass { // 2 compose, upsample fog buffer
			Blend One OneMinusSrcAlpha  
	        CGPROGRAM
			#pragma vertex VertDefault
			#pragma fragment fragApplyFog

			#pragma target 3.0
			#include "VolumetricFog.cginc"
			ENDCG
        }  
		Pass { // 3 compose edge improve, upsample fog buffer
			Blend One OneMinusSrcAlpha  
			//Blend One Zero  
	        CGPROGRAM
			#pragma vertex VertDefault
			#pragma fragment fragApplyFog
			
			#pragma target 3.0
			#define FOGEDGEIMPROVE 1	
			#include "VolumetricFog.cginc"
			ENDCG
        }   

	}
	FallBack Off
}	
