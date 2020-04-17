Shader "Hidden/DragonLumaOcclusion" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}

Subshader {	

  Pass { // 0
	  ZTest Always Cull Off ZWrite Off
	  Fog { Mode Off }
	  
      CGPROGRAM
      #pragma vertex vert
      #pragma fragment frag
      #pragma target 3.0
      #pragma multi_compile __ DIRECTIONAL 
	  #define SAMPLE 2
      #include "LumaOcclusion.cginc"
      ENDCG
  }
  
  Pass { // 1
	  ZTest Always Cull Off ZWrite Off
	  Fog { Mode Off }
	  
      CGPROGRAM
      #pragma vertex vert
      #pragma fragment frag
      #pragma target 3.0
     // #pragma multi_compile
      #pragma multi_compile __ DIRECTIONAL 
	  #define SAMPLE 3
      #include "LumaOcclusion.cginc"
      ENDCG
  }
  
  Pass { // 2
	  ZTest Always Cull Off ZWrite Off
	  Fog { Mode Off }
	  
      CGPROGRAM
      #pragma vertex vert
      #pragma fragment frag
      #pragma target 3.0
     // #pragma multi_compile
      #pragma multi_compile __ DIRECTIONAL 
	  #define SAMPLE 4
      #include "LumaOcclusion.cginc"
      ENDCG
  }

   Pass { // 3
	  ZTest Always Cull Off ZWrite Off
	  Fog { Mode Off }
	  
      CGPROGRAM
      #pragma vertex vertBlurH
      #pragma fragment fragBlur
      #pragma fragmentoption ARB_precision_hint_fastest
	  #define SAMPLE 0
      #include "LumaOcclusion.cginc"
      ENDCG
  }    
  
      
  Pass { // 4
	  ZTest Always Cull Off ZWrite Off
	  Fog { Mode Off }
	  
      CGPROGRAM
      #pragma vertex vertBlurV
      #pragma fragment fragBlur
      #pragma fragmentoption ARB_precision_hint_fastest
	  #define SAMPLE 0
      #include "LumaOcclusion.cginc"
      ENDCG
  }    
}
FallBack Off
}
