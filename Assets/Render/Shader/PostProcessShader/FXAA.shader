Shader "Hidden/DragonFXAA"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }

    CGINCLUDE
        #pragma fragmentoption ARB_precision_hint_fastest

        #define FXAA_PC 1

        #define FXAA_HLSL_3 1
		
		//#if FXAA_KEEP_ALPHA
            // Luma hasn't been encoded in alpha
        //    #define FXAA_GREEN_AS_LUMA 1
        //#else
            // Luma is encoded in alpha after the first Uber pass
            #define FXAA_GREEN_AS_LUMA 0
       // #endif
		
        #if FXAA_LOW
            #define FXAA_QUALITY__PRESET 12
            #define FXAA_QUALITY_SUBPIX 0.25
            #define FXAA_QUALITY_EDGE_THRESHOLD 0.25
            #define FXAA_QUALITY_EDGE_THRESHOLD_MIN 0.083
        #else
            #define FXAA_QUALITY__PRESET 12
            #define FXAA_QUALITY_SUBPIX 1.0
            #define FXAA_QUALITY_EDGE_THRESHOLD 0.166
            #define FXAA_QUALITY_EDGE_THRESHOLD_MIN 0.0625
        #endif

        #pragma target 3.0
        #include "FXAA3.cginc"

        float4 _MainTex_TexelSize;

        struct Input
        {
            float4 position : POSITION;
            float2 uv : TEXCOORD0;
        };

        struct Varying
        {
            float4 position : SV_POSITION;
            float2 uv : TEXCOORD0;
        };

        Varying vertex(Input input)
        {
            Varying output;

            output.position = UnityObjectToClipPos(input.position);
            output.uv = input.uv;

            return output;
        }

        sampler2D _MainTex;

        half4 fragment(Varying input) : SV_Target
        {
			half4 color = 0.0;
			
			color = FxaaPixelShader(
				input.uv, 
				0, 
				_MainTex,
				_MainTex, 
				_MainTex,
				_MainTex_TexelSize.xy,
                0,
				0, 
				0,
                FXAA_QUALITY_SUBPIX,
				FXAA_QUALITY_EDGE_THRESHOLD,
				FXAA_QUALITY_EDGE_THRESHOLD_MIN,
				0, 
				0,
                0, 
				0);
			 return color;	
        }
    ENDCG

    SubShader
    {
        ZTest Always Cull Off ZWrite Off
        Fog { Mode off }

        Pass
        {
            CGPROGRAM
                #pragma vertex vertex
                #pragma fragment fragment
				#pragma multi_compile FXAA_LOW FXAA_NORMAL

                #include "UnityCG.cginc"
            ENDCG
        }
    }
}
