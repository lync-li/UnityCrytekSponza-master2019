Shader "Hidden/DragonGenLut" {
	Properties {
		_MainTex ("mainTex", 2D) = "white" {}
	}
	
	SubShader
	{			
		//0 genLut
		Pass 
		{
		    ZTest Always Cull Off ZWrite Off	

HLSLPROGRAM
#pragma target 3.0

#pragma vertex VertDefault
#pragma fragment frag_genLut
#pragma multi_compile __ LUT2D
#pragma multi_compile __ TONEMAPPING_ACES TONEMAPPING_FILMIC TONEMAPPING_CUSTOM

#include "GenLut.hlsl"
	
ENDHLSL
		}		
				
	}
}








 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 










