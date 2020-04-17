Shader "Hidden/DragonBloom" {
	Properties {
		_MainTex ("mainTex", 2D) = "white" {}
	}
	
	SubShader
	{		
		//0 SceneBloomThreshold
		Pass 
		{
			ZTest Always Cull Off ZWrite Off			

CGPROGRAM
#pragma target 3.0

#pragma vertex vert_bloomThreshold
#pragma fragment frag_bloomThreshold

#pragma multi_compile __ PLAYER SCENE
#include "bloom.cginc"
	
ENDCG
		}	

		//1 AlphaBloomUpSample
		Pass 
		{
			ZTest Always Cull Off ZWrite Off			

CGPROGRAM
#pragma target 3.0

#pragma vertex vert
#pragma fragment frag_bloomUpSample

#include "bloom.cginc"
	
ENDCG
		}	
		
		//2 player bloom 
		Pass 
		{
			ZTest Always Cull Off ZWrite Off			

CGPROGRAM
#pragma target 3.0

#pragma vertex vert
#pragma fragment frag_bloomWithColorGrading

#pragma multi_compile __ PLAYERCOLORLOOKUP
#include "bloom.cginc"
	
ENDCG
		}	
				
	}
}








 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 










