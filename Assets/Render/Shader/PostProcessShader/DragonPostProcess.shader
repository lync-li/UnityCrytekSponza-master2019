Shader "DragonPostProcess" {
	Properties {
		_MainTex ("mainTex", 2D) = "white" {}
	}
	
	SubShader
	{
		//0 main
		Pass
		{
			ZTest Always Cull Off ZWrite Off			
CGPROGRAM
#pragma target 3.0

#pragma vertex vert
#pragma fragment frag_main

#pragma multi_compile __ DEPTHOFFIELD
#pragma multi_compile __ BORDER
#pragma multi_compile __ BLOOM
#pragma multi_compile __ CHROMATICABERRATION_RADIAL CHROMATICABERRATION_FULLSCREEN

#pragma shader_feature _ COLORLOOKUP
#pragma shader_feature _ OVERLAY
#pragma shader_feature _ VIGNETTESCENE VIGNETTEALL

#include "DragonPostProcess.cginc"

ENDCG
		}			
		
		//1 with alpha buffer
		Pass
		{
			ZTest Always Cull Off ZWrite Off			
CGPROGRAM
#pragma target 3.0

#pragma vertex vert
#pragma fragment frag_main

#pragma multi_compile __ BORDER
#pragma multi_compile __ DISTORTION
#pragma multi_compile __ DEPTHOFFIELD
#pragma multi_compile __ BLOOM
#pragma multi_compile __ CHROMATICABERRATION_RADIAL CHROMATICABERRATION_FULLSCREEN

#pragma shader_feature _ ALPHABLOOM
#pragma shader_feature _ COLORLOOKUP
#pragma shader_feature _ ALPHACOLORLOOKUP
#pragma shader_feature _ OVERLAY
#pragma shader_feature _ VIGNETTESCENE VIGNETTEALL

#define ALPHABUFFER
#include "DragonPostProcess.cginc"
ENDCG
		}		
		//2 with PLAYER
		Pass
		{
			ZTest Always Cull Off ZWrite Off			
CGPROGRAM
#pragma target 3.0

#pragma vertex vert
#pragma fragment frag_main

#pragma multi_compile __ DEPTHOFFIELD
#pragma multi_compile __ BORDER
#pragma multi_compile __ BLOOM
#pragma multi_compile __ CHROMATICABERRATION_RADIAL CHROMATICABERRATION_FULLSCREEN

#pragma shader_feature _ PLAYERBLOOM
#pragma shader_feature _ COLORLOOKUP
#pragma shader_feature _ PLAYERCOLORLOOKUP
#pragma shader_feature _ OVERLAY
#pragma shader_feature _ VIGNETTESCENE VIGNETTEALL

#define PLAYER
#include "DragonPostProcess.cginc"
ENDCG
		}	

		//3 with alpha buffer player
		Pass
		{
			ZTest Always Cull Off ZWrite Off			
CGPROGRAM
#pragma target 3.0

#pragma vertex vert
#pragma fragment frag_main

#pragma multi_compile __ DEPTHOFFIELD
#pragma multi_compile __ BORDER
#pragma multi_compile __ DISTORTION
#pragma multi_compile __ BLOOM
#pragma multi_compile __ CHROMATICABERRATION_RADIAL CHROMATICABERRATION_FULLSCREEN

#pragma shader_feature _ PLAYERBLOOM
#pragma shader_feature _ ALPHABLOOM
#pragma shader_feature _ COLORLOOKUP
#pragma shader_feature _ PLAYERCOLORLOOKUP
#pragma shader_feature _ ALPHACOLORLOOKUP
#pragma shader_feature _ OVERLAY
#pragma shader_feature _ VIGNETTESCENE VIGNETTEALL

#define ALPHABUFFER
#define PLAYER
#include "DragonPostProcess.cginc"
ENDCG
		}				
		//4 for DOF 
		Pass
		{
			ZTest Always Cull Off ZWrite Off			
CGPROGRAM
#pragma target 3.0

#pragma vertex vert
#pragma fragment frag_main

#pragma multi_compile __ BLOOM
#pragma multi_compile __ CHROMATICABERRATION_RADIAL CHROMATICABERRATION_FULLSCREEN

#pragma shader_feature _ COLORLOOKUP

#include "DragonPostProcess.cginc"
ENDCG
		}		
		//5 dof with alpha buffer
		Pass
		{
			ZTest Always Cull Off ZWrite Off			
CGPROGRAM
#pragma target 3.0

#pragma vertex vert
#pragma fragment frag_main

#pragma multi_compile __ BLOOM
#pragma multi_compile __ CHROMATICABERRATION_RADIAL CHROMATICABERRATION_FULLSCREEN

#pragma shader_feature _ ALPHABLOOM
#pragma shader_feature _ COLORLOOKUP
#pragma shader_feature _ ALPHACOLORLOOKUP

#define ALPHABUFFER
#include "DragonPostProcess.cginc"
ENDCG
		}		
		//6 with PLAYER
		Pass
		{
			ZTest Always Cull Off ZWrite Off			
CGPROGRAM
#pragma target 3.0

#pragma vertex vert
#pragma fragment frag_main

#pragma multi_compile __ BLOOM
#pragma multi_compile __ CHROMATICABERRATION_RADIAL CHROMATICABERRATION_FULLSCREEN

#pragma shader_feature _ PLAYERBLOOM
#pragma shader_feature _ COLORLOOKUP
#pragma shader_feature _ PLAYERCOLORLOOKUP

#define PLAYER
#include "DragonPostProcess.cginc"
ENDCG
		}	

		//7 with alpha buffer player
		Pass
		{
			ZTest Always Cull Off ZWrite Off			
CGPROGRAM
#pragma target 3.0

#pragma vertex vert
#pragma fragment frag_main

#pragma multi_compile __ BLOOM
#pragma multi_compile __ CHROMATICABERRATION_RADIAL CHROMATICABERRATION_FULLSCREEN

#pragma shader_feature _ PLAYERBLOOM
#pragma shader_feature _ ALPHABLOOM
#pragma shader_feature _ COLORLOOKUP
#pragma shader_feature _ PLAYERCOLORLOOKUP
#pragma shader_feature _ ALPHACOLORLOOKUP

#define ALPHABUFFER
#define PLAYER
#include "DragonPostProcess.cginc"
ENDCG
		}
		
		//8 simple
		Pass
		{
			ZTest Always Cull Off ZWrite Off			
CGPROGRAM
#pragma target 3.0

#pragma vertex vert
#pragma fragment frag_simple

#pragma multi_compile __ BLOOM

#pragma shader_feature _ COLORLOOKUP
#include "DragonPostProcess.cginc"
ENDCG
		}
	}
}








 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 










