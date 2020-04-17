Shader "Hidden/DragonOpaquePostProcess" {
	Properties {
		_MainTex ("mainTex", 2D) = "white" {}
	}
	
	SubShader
	{
		//0 main
		Pass
		{
			ZTest Always Cull Off ZWrite Off
			Blend DstColor Zero  
CGPROGRAM
#pragma target 3.0

#pragma vertex VertDefault
#pragma fragment frag_main

#pragma multi_compile __ LUMAOCCLUSION LUMAOCCLUSION_DEBUG
#pragma multi_compile __ HBAO HBAO_DEBUG
#pragma multi_compile __ CLOUDSHADOW 

#include "DragonOpaquePostProcess.cginc"

ENDCG
		}			

		//1 debug
		Pass
		{
			ZTest Always Cull Off ZWrite Off
CGPROGRAM
#pragma target 3.0

#pragma vertex VertDefault
#pragma fragment frag_main

#pragma multi_compile __ LUMAOCCLUSION LUMAOCCLUSION_DEBUG
#pragma multi_compile __ HBAO HBAO_DEBUG
#pragma multi_compile __ CLOUDSHADOW 

#include "DragonOpaquePostProcess.cginc"

ENDCG
		}					
					
	}
}








 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 










