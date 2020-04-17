#ifndef __DEPTH_OF_FIELD_BOKEH__
#define __DEPTH_OF_FIELD_BOKEH__

#if SHADER_TARGET >= 50
    // Use separate texture/sampler objects on Shader Model 5.0
    #define SEPARATE_TEXTURE_SAMPLER
    #define DOF_DECL_TEX2D(tex) Texture2D tex; SamplerState sampler##tex
    #define DOF_TEX2D(tex, coord) tex.Sample(sampler##tex, coord)
#else
    #define DOF_DECL_TEX2D(tex) sampler2D tex
    #define DOF_TEX2D(tex, coord) tex2D(tex, coord)
#endif

#include "UnityCG.cginc"
#include "DiskKernels.cginc"

DOF_DECL_TEX2D(_CameraDepthTexture);
DOF_DECL_TEX2D(_CoCTex);

float4 _DepthOfFieldParams;
float4		_MainTex_ST;
float4 		_MainTex_TexelSize;

#if defined(SEPARATE_TEXTURE_SAMPLER)
Texture2D _MainTex;
SamplerState sampler_MainTex;
Texture2D _SceneTex;
SamplerState sampler_SceneTex;
#else
sampler2D _MainTex;
sampler2D _SceneTex;
#endif

struct AttributesDefault
{
    float4 vertex : POSITION;
    float4 texcoord : TEXCOORD0;
};

struct VaryingsDOF
{
    float4 pos : SV_POSITION;
    half2 uv : TEXCOORD0;
    half2 uvAlt : TEXCOORD1;
};

inline half Min3(half3 x) { return min(x.x, min(x.y, x.z)); }
inline half Min3(half x, half y, half z) { return min(x, min(y, z)); }

inline half Max3(half3 x) { return max(x.x, max(x.y, x.z)); }
inline half Max3(half x, half y, half z) { return max(x, max(y, z)); }

inline half Min4(half4 x) { return min(x.x, min(x.y, min(x.z, x.w))); }
inline half Min4(half x, half y, half z, half w) { return min(x, min(y, min(z, w))); }

inline half Max4(half4 x) { return max(x.x, max(x.y, max(x.z, x.w))); }
inline half Max4(half x, half y, half z, half w) { return max(x, max(y, min(z, w))); }

// Common vertex shader with single pass stereo rendering support
VaryingsDOF VertDOF(AttributesDefault v)
{
    half2 uvAlt = v.texcoord;
#if UNITY_UV_STARTS_AT_TOP
    if (_MainTex_TexelSize.y < 0.0) uvAlt.y = 1.0 - uvAlt.y;
#endif

    VaryingsDOF o;
    o.pos = UnityObjectToClipPos(v.vertex);

    o.uv = v.texcoord;
    o.uvAlt = uvAlt;

    return o;
}

// CoC calculation
half4 FragCoC(VaryingsDOF i) : SV_Target
{
    float depth = LinearEyeDepth(DOF_TEX2D(_CameraDepthTexture, i.uv));
    half coc = (depth - _DepthOfFieldParams.x) * _DepthOfFieldParams.y / max(depth, 1e-5);
    return saturate(coc * 0.5 / _DepthOfFieldParams.z + 0.5);
}

// Prefilter: downsampling and premultiplying.
half4 FragPrefilter(VaryingsDOF i) : SV_Target
{
#if defined(SEPARATE_TEXTURE_SAMPLER)

    // Sample source colors.
    half4 c_r = _MainTex.GatherRed  (sampler_MainTex, i.uv);
    half4 c_g = _MainTex.GatherGreen(sampler_MainTex, i.uv);
    half4 c_b = _MainTex.GatherBlue (sampler_MainTex, i.uv);

    half3 c0 = half3(c_r.x, c_g.x, c_b.x);
    half3 c1 = half3(c_r.y, c_g.y, c_b.y);
    half3 c2 = half3(c_r.z, c_g.z, c_b.z);
    half3 c3 = half3(c_r.w, c_g.w, c_b.w);

    // Sample CoCs.
    half4 cocs = _CoCTex.Gather(sampler_CoCTex, i.uvAlt) * 2.0 - 1.0;
    half coc0 = cocs.x;
    half coc1 = cocs.y;
    half coc2 = cocs.z;
    half coc3 = cocs.w;

#else

    float3 duv = _MainTex_TexelSize.xyx * float3(0.5, 0.5, -0.5);

    // Sample source colors.
    half3 c0 = DOF_TEX2D(_MainTex, i.uv - duv.xy).rgb;
    half3 c1 = DOF_TEX2D(_MainTex, i.uv - duv.zy).rgb;
    half3 c2 = DOF_TEX2D(_MainTex, i.uv + duv.zy).rgb;
    half3 c3 = DOF_TEX2D(_MainTex, i.uv + duv.xy).rgb;
	
    // Sample CoCs.
    half coc0 = DOF_TEX2D(_CoCTex, i.uvAlt - duv.xy).r * 2.0 - 1.0;
    half coc1 = DOF_TEX2D(_CoCTex, i.uvAlt - duv.zy).r * 2.0 - 1.0;
    half coc2 = DOF_TEX2D(_CoCTex, i.uvAlt + duv.zy).r * 2.0 - 1.0;
    half coc3 = DOF_TEX2D(_CoCTex, i.uvAlt + duv.xy).r * 2.0 - 1.0;

#endif

    // Apply CoC and luma weights to reduce bleeding and flickering.
    float w0 = abs(coc0) / (Max3(c0) + 1.0);
    float w1 = abs(coc1) / (Max3(c1) + 1.0);
    float w2 = abs(coc2) / (Max3(c2) + 1.0);
    float w3 = abs(coc3) / (Max3(c3) + 1.0);

    // Weighted average of the color samples
    half3 avg = c0 * w0 + c1 * w1 + c2 * w2 + c3 * w3;
    avg /= max(w0 + w1 + w2 + w3, 1e-5);

    // Select the largest CoC value.
    half coc_min = Min4(coc0, coc1, coc2, coc3);
    half coc_max = Max4(coc0, coc1, coc2, coc3);
    half coc = (-coc_min > coc_max ? coc_min : coc_max) * _DepthOfFieldParams.z;

    // Premultiply CoC again.
    avg *= smoothstep(0, _MainTex_TexelSize.y * 2, abs(coc));

    return half4(avg, coc);
}

// Bokeh filter with disk-shaped kernels
half4 FragBlur(VaryingsDOF i) : SV_Target
{
    half4 samp0 = DOF_TEX2D(_MainTex, i.uv);

    half4 bgAcc = 0.0; // Background: far field bokeh
    half4 fgAcc = 0.0; // Foreground: near field bokeh

    UNITY_LOOP for (int si = 0; si < kSampleCount; si++)
    {
        float2 disp = kDiskKernel[si] * _DepthOfFieldParams.z;
        float dist = length(disp);

        float2 duv = float2(disp.x * _DepthOfFieldParams.w, disp.y);
        half4 samp = DOF_TEX2D(_MainTex, i.uv + duv);

        // BG: Compare CoC of the current sample and the center sample
        // and select smaller one.
        half bgCoC = max(min(samp0.a, samp.a), 0.0);

        // Compare the CoC to the sample distance.
        // Add a small margin to smooth out.
        const half margin = _MainTex_TexelSize.y * 2;
        half bgWeight = saturate((bgCoC   - dist + margin) / margin);
        half fgWeight = saturate((-samp.a - dist + margin) / margin);

        // Cut influence from focused areas because they're darkened by CoC
        // premultiplying. This is only needed for near field.
        fgWeight *= step(_MainTex_TexelSize.y, -samp.a);

        // Accumulation
        bgAcc += half4(samp.rgb, 1.0) * bgWeight;
        fgAcc += half4(samp.rgb, 1.0) * fgWeight;
    }

    // Get the weighted average.
    bgAcc.rgb /= bgAcc.a + (bgAcc.a == 0.0); // zero-div guard
    fgAcc.rgb /= fgAcc.a + (fgAcc.a == 0.0);

    // BG: Calculate the alpha value only based on the center CoC.
    // This is a rather aggressive approximation but provides stable results.
  //  bgAcc.a = smoothstep(_MainTex_TexelSize.y, _MainTex_TexelSize.y * 2.0, samp0.a);

    // FG: Normalize the total of the weights.
    fgAcc.a *= UNITY_PI / kSampleCount;

    // Alpha premultiplying
    half alpha = saturate(fgAcc.a);
    half3 rgb = lerp(bgAcc.rgb, fgAcc.rgb, alpha);

    return half4(rgb, alpha);
}

// Postfilter blur
half4 FragPostBlur(VaryingsDOF i) : SV_Target
{
    // 9 tap tent filter with 4 bilinear samples
    const float4 duv = _MainTex_TexelSize.xyxy * float4(0.5, 0.5, -0.5, 0);
    half4 acc;
    acc  = DOF_TEX2D(_MainTex, i.uv - duv.xy);
    acc += DOF_TEX2D(_MainTex, i.uv - duv.zy);
    acc += DOF_TEX2D(_MainTex, i.uv + duv.zy);
    acc += DOF_TEX2D(_MainTex, i.uv + duv.xy);
    return acc / 4.0;
}

#endif // __DEPTH_OF_FIELD__
