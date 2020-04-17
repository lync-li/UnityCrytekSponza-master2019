Shader "Hidden/DragonDownSample" {
	Properties {
		_MainTex ("mainTex", 2D) = "white" {}
	}
	
	SubShader
	{
		//0 downSample
		Pass 
		{
			ZTest Always Cull Off ZWrite Off			

CGPROGRAM
#pragma target 3.0

#pragma vertex vert_downSample
#pragma fragment frag_downSample

#pragma fragmentoption ARB_precision_hint_fastest
#include "DownSample.cginc"
	
ENDCG
		}
		
		//1 HasBloomDownSample
		Pass 
		{
			ZTest Always Cull Off ZWrite Off			

CGPROGRAM
#pragma target 3.0

#pragma vertex vert_downSample
#pragma fragment frag_downSample

#pragma fragmentoption ARB_precision_hint_fastest
#define HASBLOOM
#include "DownSample.cginc"
	
ENDCG
		}
				
	}
}








 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 










