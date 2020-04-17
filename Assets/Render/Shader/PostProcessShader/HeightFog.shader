Shader "Hidden/DragonHeightFog" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	
	SubShader {
       	ZTest Always Cull Off ZWrite Off
       	Fog { Mode Off }       	

		Pass { 
			Blend SrcAlpha OneMinusSrcAlpha  
			//Blend One Zero  
	        CGPROGRAM
			#pragma vertex VertDefault
			#pragma fragment fragApplyFog
			#pragma target 3.0
			#pragma multi_compile __ ANIMATION
			
			#define WORLDPOS 1
			#include "HeightFog.cginc"
			ENDCG
        }   

	}
	FallBack Off
}	
