#ifndef FUNLIB_HAPPYELEMENTS_INCLUDED
#define FUNLIB_HAPPYELEMENTS_INCLUDED

#include "UnityCG.cginc"
#include "AutoLight.cginc"
#include "UnityStandardConfig.cginc"
#include "UnityStandardBRDF.cginc" 
#include "UnityStandardUtils.cginc"

// Compute normal from normal map
inline half3 GetNormalFromMap( half2 normalMap,half3 tangent,half3 binormal,half3 normal)
{
	half3 normalVec;
	normalVec.xy = normalMap.xy;
	normalVec.z = sqrt(1 - saturate(dot(normalMap.xy, normalMap.xy)));
	
	half3x3 localToWorldTranspose = half3x3(
		tangent,
		binormal,
		normal
	);

	normal.rgb = normalize( mul( normalVec, localToWorldTranspose ) );
	return normal;
}

inline half4 SampleTex(sampler2D tex,float4 uv)
{
	return tex2Dbias( tex, uv );	
}

inline half getLuma(half3 rgb) {
	const half3 lum = half3(0.2126729, 0.7151522, 0.0721750);
	return dot(rgb, lum);
}

inline half3 F_Schlick2(half3 F0, half cosA)
{
	half t = Pow5 (1 - cosA);	// ala Schlick interpoliation
	return saturate( 50.0 * F0.g ) * t + (1-t) * F0;
}

inline half2 ParallaxOffsetCal (half h, half height, half3 viewDir)
{
    h = h * height - height/2.0;
    half3 v = normalize(viewDir);
    v.z += 0.42;
    return h * (v.xy / v.z);
}

//half3 tonemapACES(half3 color,float adapted_lum)
//{
 //   const half a = 2.51;
 //   const half b = 0.03;
 //   const half c = 2.43;
  //  const half d = 0.59;
 //   const half e = 0.14;
//	color *= adapted_lum;
  //  return saturate((color * (a * color + b)) / (color * (c * color + d) + e));
//}


inline float SmoothCurve(float x)
{
	return x * x * (3.0 - 2.0 * x);
}

inline float TriangleWave(float x)
{
	return abs(frac(x + 0.5) * 2.0 - 1.0);
}

inline float SmoothTriangleWave(float x)
{
	return SmoothCurve(TriangleWave(x));
}

half3 SafeHDR(half3 c) { return min(c, 65000); }
half4 SafeHDR(half4 c) { return min(c, 65000); }

half Brightness(half3 c)
{
    return max(max(c.r, c.g), c.b);
}

half SafeBrightness(half3 c)
{
	c = SafeHDR(c);
    return max(max(c.r, c.g), c.b);
}

half3 Median(half3 a, half3 b, half3 c)
{
    return a + b + c - min(min(a, b), c) - max(max(a, b), c);
}

half4 RGBMEncodeFast( half3 Color )
{
	// 0/0 result written to fixed point buffer goes to zero
	half4 rgbm;
	rgbm.a = dot( Color, 255.0 / 16.0 );
	rgbm.a = ceil( rgbm.a );
	rgbm.rgb = Color / rgbm.a;
	rgbm *= half4( 255.0 / 16.0, 255.0 / 16.0, 255.0 / 16.0, 1.0 / 255.0 );
	return rgbm;
}

half3 RGBMDecode( half4 rgbm )
{
	return rgbm.rgb * (rgbm.a * 16.0f);	
}

half3 LinearToSrgbBranchless(half3 lin) 
{
	lin = max(6.10352e-5, lin); // minimum positive non-denormal (fixes black problem on DX11 AMD and NV)
	return min(lin * 12.92, pow(max(lin, 0.00313067), 1.0/2.4) * 1.055 - 0.055);
	// Possible that mobile GPUs might have native pow() function?
	//return min(lin * 12.92, exp2(log2(max(lin, 0.00313067)) * (1.0/2.4) + log2(1.055)) - 0.055);
}

#endif


