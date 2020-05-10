Shader "Hidden/DragonStochasticSSR" {

	CGINCLUDE
		#define WORLDPOS 1
	ENDCG
	
	SubShader {
		ZTest Always 
		ZWrite Off
		Cull Front

		Pass 
		{
			Name"HierarchicalZBuffer"
			CGPROGRAM
				#pragma vertex VertDefault
				#pragma fragment HierarchicalZBuffer
				#include "StochasticSSR.cginc"
			ENDCG
		}	

		Pass 
		{
			Name"HierarchicalZTraceSingleSampler"
			CGPROGRAM
				#pragma vertex VertDefault
				#pragma fragment HierarchicalZTrace					
				#include "StochasticSSR.cginc"				
			ENDCG
		} 	

		Pass 
		{
			Name"HierarchicalZTraceMultiSampler"
			CGPROGRAM
				#pragma vertex VertDefault
				#pragma fragment HierarchicalZTrace
				#define MULTI 1
				#include "StochasticSSR.cginc"			
			ENDCG
		} 

		Pass 
		{
			Name"Spatiofilter"
			CGPROGRAM
				#pragma vertex VertDefault
				#pragma fragment Spatiofilter
				#include "StochasticSSR.cginc"			
			ENDCG
		} 		
	
		Pass 
		{
			Name"Temporalfilter"
			CGPROGRAM
				#pragma vertex VertDefault
				#pragma fragment Temporalfilter
				#include "StochasticSSR.cginc"			
			ENDCG
		} 
/*	
		Pass 
		{
			Name"Pass_CombineReflection"
			CGPROGRAM
				#pragma vertex vert
				#pragma fragment CombineReflectionColor
			ENDCG
		}

		Pass 
		{
			Name"Pass_DeBug_SSRColor"
			CGPROGRAM
				#pragma vertex vert
				#pragma fragment DeBug_SSRColor
			ENDCG
		}		
		
		*/
		
		
	}
}
