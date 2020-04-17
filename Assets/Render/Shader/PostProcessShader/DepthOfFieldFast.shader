Shader "Hidden/DragonDepthOfFieldFast"
{
    Properties
    {
        _MainTex("Source", 2D) = "white" {}
    }

    SubShader
    {       
        ZTest Always ZWrite Off Cull Off
		
        Pass
        {
            Name "Depth Of Field CoC"

            CGPROGRAM
			    #pragma target 3.0
                #pragma vertex vert
                #pragma fragment FragCoC
				
				#include "DepthOfFieldFast.cginc"
            ENDCG
        }

        Pass
        {
            Name "Depth Of Field Prefilter"

            CGPROGRAM
				#pragma target 3.0
                #pragma vertex vert
                #pragma fragment FragPrefilter
				
				#include "DepthOfFieldFast.cginc"
            ENDCG
        }

        Pass
        {
            Name "Depth Of Field Blur Horizontal"

            CGPROGRAM
				#pragma target 3.0
                #pragma vertex vert
                #pragma fragment FragBlurH
				
				#include "DepthOfFieldFast.cginc"
            ENDCG
        }
		
        Pass
        {
            Name "Depth Of Field Blur Vertical"

            CGPROGRAM
				#pragma target 3.0
                #pragma vertex vert
                #pragma fragment FragBlurV
				
				#include "DepthOfFieldFast.cginc"
            ENDCG
        }

    }
}
