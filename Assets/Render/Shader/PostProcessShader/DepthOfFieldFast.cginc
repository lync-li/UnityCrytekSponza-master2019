#include "PostProcessCommon.cginc"
#include "FunLib.cginc"

#define BLUR_KERNEL 1

#if BLUR_KERNEL == 0

// Offsets & coeffs for optimized separable bilinear 3-tap gaussian (5-tap equivalent)
const static int kTapCount = 3;
const static float kOffsets[] = {
    -1.33333333,
        0.00000000,
        1.33333333
};
const static half kCoeffs[] = {
        0.35294118,
        0.29411765,
        0.35294118
};

#elif BLUR_KERNEL == 1

// Offsets & coeffs for optimized separable bilinear 5-tap gaussian (9-tap equivalent)
const static int kTapCount = 5;
const static float kOffsets[] = {
    -3.23076923,
    -1.38461538,
        0.00000000,
        1.38461538,
        3.23076923
};
const static half kCoeffs[] = {
        0.07027027,
        0.31621622,
        0.22702703,
        0.31621622,
        0.07027027
};

#endif

half FragCoC(v2f input) : SV_Target
{	    
    float depth = tex2D(_CameraDepthTexture, input.texcoord0).r;
    depth = LinearEyeDepth(depth);
    half coc = (depth - _DepthOfFieldParams.x) / _DepthOfFieldParams.y;
    return saturate(coc);
}

half4 FragPrefilter(v2f input): SV_Target
{  
    // Bilinear sampling the coc is technically incorrect but we're aiming for speed here
    half farCoC = tex2D(_CoCTex, input.texcoord0).x;

    // Fast bilinear downscale of the source target and pre-multiply the CoC to reduce
    // bleeding of background blur on focused areas
    half4 color = tex2D(_MainTex, input.texcoord0);
    color *= farCoC;  

    color.a = farCoC;
    return color;
}

half4 Blur(v2f input, float2 dir, float premultiply)
{
    // Use the center CoC as radius
    half samp0CoC = tex2D(_MainTex, input.texcoord0).a;

    float2 offset = _MainTex_TexelSize.xy * dir * samp0CoC * _DepthOfFieldParams.z;
    half4 acc = 0.0;

    UNITY_UNROLL
    for (int i = 0; i < kTapCount; i++)
    {
        float2 sampCoord = input.texcoord0 + kOffsets[i] * offset;		
        half4 samp = tex2D(_MainTex, sampCoord);

        // Weight & pre-multiply to limit bleeding on the focused area
        half weight = saturate(1.0 - (samp0CoC - samp.a));
        acc += half4(samp.rgb, premultiply ? samp.a : 1.0) * kCoeffs[i] * weight;
    }

    acc.xyz /= acc.w + 1e-4; // Zero-div guard
    return half4(acc.xyz, samp0CoC);
}

half4 FragBlurH(v2f input) : SV_Target
{
    return Blur(input, float2(1.0, 0.0), 1.0);
}

half4 FragBlurV(v2f input) : SV_Target
{
    return Blur(input, float2(0.0, 1.0), 0.0);
}



