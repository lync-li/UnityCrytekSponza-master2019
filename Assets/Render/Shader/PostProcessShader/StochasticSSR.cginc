#include "PostProcessCommon.cginc"
#include "StochasticSSRFun.cginc"
#include "UnityCG.cginc"
#include "UnityStandardUtils.cginc"
#include "UnityStandardBRDF.cginc"
#include "UnityPBSLighting.cginc"
     
#define HiZ_Start_Level 2
#define HiZ_Stop_Level  0

int _HiZbufferLevel;
int _RayNum;
int _RayCastStepNum;
int _HiZMaxLevel;
int _ResolverNum;

half4 _Jitter;
half  _BRDFBias;
half  _RayCastThickness;
half  _ScreenFade;
half  _SSRMaxDistance;
half  _TemporalScale;
half  _TemporalWeight;
half4 _RayCastSize;
half4 _SSRReflectionSize;

float4x4 _PrevViewProjectionMatrix;
float4x4 _CurrViewProjectionMatrix;
float4x4 _SSRProjectionMatrix;
float4x4 _SSRProjectionMatrixInverse;

Texture2D _HiZbufferTex;
SamplerState sampler_HiZbufferTex;

sampler2D _SSRNoiseTex;
half4     _NoiseSizeJitter;

sampler2D _SceneTex;
float2    _SceneTexSize;

sampler2D _RayCastTex0;
sampler2D _RayCastTex1;
sampler2D _CameraMotionVectorsTexture;

sampler2D _SpatialTex;
sampler2D _TemporalTex;
sampler2D _PrevTemporalTex;
sampler2D _AoTex;


float HierarchicalZBuffer(v2f i) : SV_Target {
	float2 uv = i.texcoord0.xy;	
	
    half4 minDepth;
	//minDepth.x = tex2Dlod(_CameraDepthTexture,float4(uv + _CameraDepthTexture_TexelSize.xy * float2(-1,-1),0,_HiZbufferLevel)).r;
	//minDepth.y = tex2Dlod(_CameraDepthTexture,float4(uv + _CameraDepthTexture_TexelSize.xy * float2(-1,1),0,_HiZbufferLevel)).r;
	//minDepth.z = tex2Dlod(_CameraDepthTexture,float4(uv + _CameraDepthTexture_TexelSize.xy * float2(1,-1),0,_HiZbufferLevel)).r;
	//minDepth.w = tex2Dlod(_CameraDepthTexture,float4(uv + _CameraDepthTexture_TexelSize.xy * float2(1,1),0,_HiZbufferLevel)).r;
	
	minDepth.x = _HiZbufferTex.SampleLevel(sampler_HiZbufferTex,uv, _HiZbufferLevel,int2(-1,-1)).r;
	minDepth.y = _HiZbufferTex.SampleLevel(sampler_HiZbufferTex,uv, _HiZbufferLevel,int2(-1,1)).r;
	minDepth.z = _HiZbufferTex.SampleLevel(sampler_HiZbufferTex,uv, _HiZbufferLevel,int2(1,-1)).r;
	minDepth.w = _HiZbufferTex.SampleLevel(sampler_HiZbufferTex,uv, _HiZbufferLevel,int2(1,1)).r;

	return max( max(minDepth.x, minDepth.y), max(minDepth.z, minDepth.w) );
}

///////////////////////////////-----Hierarchical_ZTrace Sampler-----------------------------------------------------------------------------
void HierarchicalZTrace(VaryingsDefault i, out half4 output0 : SV_Target0, out half4 output1 : SV_Target1)
{
	float2 uv = i.texcoord.xy;

	float depth = tex2D(_CameraDepthTexture, uv).r;
	
	clip(_SSRMaxDistance - LinearEyeDepth(depth.r));
	
	half4 normalSmoothness = tex2D(_NormalBufferTex, uv);
	half  roughness = clamp(1 - normalSmoothness.a, 0.02, 1);
	float3 worldNormal = normalSmoothness.xyz * 2 - 1;
		
	float3 viewNormal = mul((float3x3)(UNITY_MATRIX_V), worldNormal);
	float3 screenPos = half3(uv.xy * 2 - 1, depth.r);	
	
	float4 viewPos = mul(_SSRProjectionMatrixInverse, float4(screenPos,1.0));
	viewPos.xyz /= viewPos.w;
	
	half3 outColor = 0;
	half3 outHitViewPos = 0;
	half  outMask = 0;
	half  outPDF = 0;	
	
#if MULTI	
	for (int i = 0; i < _RayNum; i++)
	{
		half2 jitter = sin( i + _NoiseSizeJitter.zw );
#else
	    half2 jitter = _NoiseSizeJitter.zw;
#endif
		half2 hash = tex2D(_SSRNoiseTex, (uv + jitter) * _RayCastSize.xy / _NoiseSizeJitter.xy).xy;
		hash.y = lerp(hash.y, 0.0, _BRDFBias);
	
		half4 H = 0.0;
		if (roughness > 0.1) {
			H = TangentToWorld(viewNormal,ImportanceSampleGGX(hash, roughness));
		} else {
			H = half4(viewNormal, 1.0);
		}
		float3 reflectionDir = reflect(normalize(viewPos.xyz), H.xyz);

		float3 rayStart = float3(uv, depth);
		float4 rayProj = mul ( _SSRProjectionMatrix, float4(viewPos.xyz + reflectionDir, 1.0) );
		float3 rayDir = normalize( (rayProj.xyz / rayProj.w) - screenPos);
		rayDir.xy *= 0.5;		
		
		
		/*
		float samplerSize = GetMarchSize(rayStart.xy, rayStart.xy + rayDir.xy, _RayCastSize.zw);
		float3 samplePos = rayStart + rayDir * (samplerSize);
		int level = HiZ_Start_Level; float mask = 0.0;

		UNITY_LOOP
		for (int j = 0; j < _RayCastStepNum; j++)
		{
			float2 cellCount = _RayCastSize.zw * exp2(level + 1.0);
			float newSamplerSize = GetMarchSize(samplePos.xy, samplePos.xy + rayDir.xy, cellCount);
			float3 newSamplePos = samplePos + rayDir * newSamplerSize;
			float sampleMinDepth = _HiZbufferTex.SampleLevel(sampler_HiZbufferTex, newSamplePos.xy, level); 

			UNITY_FLATTEN
			if (sampleMinDepth < newSamplePos.z) {
				level = min(_HiZMaxLevel, level + 1.0);
				samplePos = newSamplePos;
			} else {
				level--;
			}

			UNITY_BRANCH
			if (level < HiZ_Stop_Level) {
				float delta = (-LinearEyeDepth(sampleMinDepth)) - (-LinearEyeDepth(samplePos.z));
				mask = delta <= _RayCastThickness && j > 0.0;
				break;
			}
		}		
		
	    */
		
		float4 RayHitData = Hierarchical_Z_Trace(_HiZMaxLevel, HiZ_Start_Level, HiZ_Stop_Level, _RayCastStepNum, _RayCastThickness, _RayCastSize.zw, rayStart, rayDir, _HiZbufferTex, sampler_HiZbufferTex);

		float3 sampleColor = tex2D(_SceneTex, RayHitData.xy);		
		sampleColor.rgb /= 1 + Luminance(sampleColor.rgb);		
		//mask *= GetScreenFadeBord(RayHitData.xy, _ScreenFade);
	
		//float4 hitViewPos = mul(_SSRProjectionMatrixInverse, half4(RayHitData.xyz, 1));
		//hitViewPos.xyz /= hitViewPos.w;
#if MULTI
		outColor += sampleColor;	
		outMask += RayHitData.w * GetScreenFadeBord(RayHitData.xy, _ScreenFade);	
		outHitViewPos += RayHitData.xyz;
		outPDF += H.a;
	}

	//-----Output-----------------------------------------------------------------------------
	outColor /= _RayNum;
	outColor.rgb /= 1 - Luminance(outColor.rgb);
	outMask /= _RayNum;
	outHitViewPos /= _RayNum;
	outPDF /= _RayNum;
#else	
	outColor = sampleColor;
	outColor.rgb /= 1 - Luminance(outColor.rgb);
	outMask = RayHitData.w * GetScreenFadeBord(RayHitData.xy, _ScreenFade);
	outHitViewPos = RayHitData.xyz;
	outPDF = H.a;
#endif
	output0 = half4(outColor ,outMask * outMask);
	output1 = half4(outHitViewPos, outPDF);
}


////////////////////////////////-----Spatio Sampler-----------------------------------------------------------------------------
//static const int2 offset[4] = { int2(0, 0), int2(0, 2), int2(2, 0), int2(2, 2) };
//static const int2 offset[9] ={int2(-1.0, -1.0), int2(0.0, -1.0), int2(1.0, -1.0), int2(-1.0, 0.0), int2(0.0, 0.0), int2(1.0, 0.0), int2(-1.0, 1.0), int2(0.0, 1.0), int2(1.0, 1.0)};
static const int2 offset[9] ={int2(-2.0, -2.0), int2(0.0, -2.0), int2(2.0, -2.0), int2(-2.0, 0.0), int2(0.0, 0.0), int2(2.0, 0.0), int2(-2.0, 2.0), int2(0.0, 2.0), int2(2.0, 2.0)};
//static const int2 offset[9] ={int2(-2.0, -2.0), int2(0.0, -2.0), int2(2.0, -2.0), int2(-2.0, 0.0), int2(0.0, 0.0), int2(2.0, 0.0), int2(-2.0, 2.0), int2(0.0, 2.0), int2(2.0, 2.0)};

float4 Spatiofilter(VaryingsDefault i) : SV_Target
{
	float2 uv = i.texcoord.xy;

	float depth = tex2D(_CameraDepthTexture, uv).r;
	clip(_SSRMaxDistance - LinearEyeDepth(depth.r));
	
	half4 normalSmoothness = tex2D(_NormalBufferTex, uv);
	half  roughness = clamp(1 - normalSmoothness.a, 0.02, 1);
	float3 worldNormal = normalSmoothness.xyz * 2 - 1;
		
	float3 viewNormal = mul((float3x3)(UNITY_MATRIX_V), worldNormal);
	float3 screenPos = half3(uv.xy * 2 - 1, depth.r);	
	
	float4 viewPos = mul(_SSRProjectionMatrixInverse, float4(screenPos,1.0));
	viewPos.xyz /= viewPos.w;

	half2 blueNoise = tex2D(_SSRNoiseTex, (uv + _NoiseSizeJitter.zw) * _SSRReflectionSize.xy / _NoiseSizeJitter.xy) * 2 - 1;
	half2x2 offsetRotationMatrix = half2x2(blueNoise.x, blueNoise.y, -blueNoise.y, -blueNoise.x);

	half numWeight = 0;
	half weight = 0;
	half2 offsetUV;
	half2 neighborUV;
	half4 sampleColor;
	half4 reflecttionColor;
	
	for (int i = 0; i < _ResolverNum; i++) {
		offsetUV = mul(offsetRotationMatrix, offset[i] * _SSRReflectionSize.zw);
		neighborUV = uv + offsetUV;
		
		half4 rayCast0 = tex2D(_RayCastTex0, neighborUV);
		half4 rayCast1 = tex2D(_RayCastTex1, neighborUV);
		rayCast1.xy = rayCast1.xy * 2 - 1;
		half3 Hit_ViewPos = mul(_SSRProjectionMatrixInverse, float4(rayCast1.xyz,1.0));
		///SpatioSampler
		weight = SSR_BRDF(normalize(-viewPos.xyz), normalize(Hit_ViewPos.xyz - viewPos.xyz), viewNormal, roughness) / max(1e-5, rayCast1.w);

		reflecttionColor += rayCast0 * weight;
		numWeight += weight;
	}

	reflecttionColor /= numWeight;
	reflecttionColor = max(1e-5, reflecttionColor);

	return reflecttionColor;
}


half4 Temporalfilter(VaryingsDefault i) : SV_Target
{
	float2 uv = i.texcoord.xy;

	float depth = tex2D(_CameraDepthTexture, uv).r;
	//clip(_SSRMaxDistance - LinearEyeDepth(depth.r));
	
	half4 normalSmoothness = tex2D(_NormalBufferTex, uv);
	float3 worldNormal = normalSmoothness.xyz * 2 - 1;		
	float3 worldPos = GetWorldPos(i, Linear01Depth(depth));		
	/////Get Reprojection Velocity
	half2 depthVelocity = tex2D(_CameraMotionVectorsTexture, uv);

    half4 prevClipPos = mul(_PrevViewProjectionMatrix, worldPos);
    half4 curClipPos = mul(_CurrViewProjectionMatrix, worldPos);

    half2 prevHPos = prevClipPos.xy / prevClipPos.w;
    half2 curHPos = curClipPos.xy / curClipPos.w;

    half2 vPosPrev = (prevHPos.xy + 1) / 2;
    half2 vPosCur = (curHPos.xy + 1) / 2;	
	
	half2 rayVelocity = vPosCur - vPosPrev;
	half  velocityWeight = saturate(dot(worldNormal, half3(0, 1, 0)));
	half2 velocity = lerp(depthVelocity, rayVelocity, velocityWeight);

	const int2 sampleOffset[9] = {int2(-1.0, -1.0), int2(0.0, -1.0), int2(1.0, -1.0), int2(-1.0, 0.0), int2(0.0, 0.0), int2(1.0, 0.0), int2(-1.0, 1.0), int2(0.0, 1.0), int2(1.0, 1.0)};
    half4 sampleColors[9];

    for(uint i = 0; i < 9; i++) {
        sampleColors[i] = tex2D(_SpatialTex, uv + ( sampleOffset[i] * _SSRReflectionSize.zw) );
    }

    half4 m1 = 0.0; half4 m2 = 0.0;
    for(uint x = 0; x < 9; x++) {
        m1 += sampleColors[x];
        m2 += sampleColors[x] * sampleColors[x];
    }

    half4 mean = m1 / 9.0;
    half4 stddev = sqrt( (m2 / 9.0) - pow2(mean) );
        
    half4 minColor = mean - _TemporalScale * stddev;
    half4 maxColor = mean + _TemporalScale * stddev;

    minColor = min(minColor, sampleColors[4]);
    maxColor = max(maxColor, sampleColors[4]);	
	
	/////Clamp TemporalColor
	half4 prevColor = tex2D(_PrevTemporalTex, uv - velocity);
	prevColor = clamp(prevColor, minColor, maxColor);

	/////Combine TemporalColor
	half temporalBlendWeight = saturate(_TemporalWeight * (1 - length(velocity) * 8));
	half4 reflectionColor = lerp(sampleColors[4], prevColor, temporalBlendWeight);
	
	return reflectionColor;
}


half3 decode (half2 enc)
{
    half2 fenc = enc*4-2;
    half f = dot(fenc,fenc);
    half g = sqrt(1-f/4);
    half3 n;
    n.xy = fenc*g;
    n.z = 1-f/2;
    return n;
}



////////////////////////////////-----CombinePass-----------------------------------------------------------------------------
half4 CombineReflectionColor(VaryingsDefault i) : SV_Target {
	half2 uv = i.texcoord.xy;

	float depth = tex2D(_CameraDepthTexture, uv).r;
	float4 normalSmoothness = tex2D(_NormalBufferTex, uv);
	half4 specular = tex2D(_SpecBufferTex, uv);
	half  roughness = clamp(1 - normalSmoothness.a, 0.02, 1);
	float3 worldNormal = normalSmoothness.xyz * 2 - 1;
	float3 worldPos = GetWorldPos(i, Linear01Depth(depth));	
	
	//float3 viewNormal = decode(normalSmoothness.xy);
	//float3 viewNormal = DecodeViewNormalStereo(half4(normalSmoothness.xy,0,0));
	//float3 worldNormal = mul((float3x3)(UNITY_MATRIX_I_V),viewNormal);
	
	half3 viewDir = normalize(worldPos - _WorldSpaceCameraPos);
	float3 reflUVW   = reflect(viewDir, worldNormal);
	half  nv = abs(dot(worldNormal, -viewDir));     
	
	UnityGIInput d;
    d.worldPos = worldPos;
    d.worldViewDir = -viewDir;
    d.probeHDR[0] = unity_SpecCube0_HDR;
    d.boxMin[0].w = 1; // 1 in .w allow to disable blending in UnityGI_IndirectSpecular call since it doesn't work in Deferred

    //float blendDistance = unity_SpecCube1_ProbePosition.w; // will be set to blend distance for this probe
    #ifdef UNITY_SPECCUBE_BOX_PROJECTION
   // d.probePosition[0]  = unity_SpecCube0_ProbePosition;
    //d.boxMin[0].xyz     = unity_SpecCube0_BoxMin - float4(blendDistance,blendDistance,blendDistance,0);
    //d.boxMax[0].xyz     = unity_SpecCube0_BoxMax + float4(blendDistance,blendDistance,blendDistance,0);
    #endif


    //g.roughness /* perceptualRoughness */   = SmoothnessToPerceptualRoughness(Smoothness);
   //g.reflUVW   = reflect(-worldViewDir, Normal);
	
	//Unity_GlossyEnvironment (UNITY_PASS_TEXCUBE(unity_SpecCube0), data.probeHDR[0], glossIn);
	
	half perceptualRoughness = roughness*(1.7 - 0.7*roughness);
	//half4 rgbm = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, reflUVW, perceptualRoughness * 6);
	
	half4 rgbm = UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, reflUVW, perceptualRoughness * 6);
	half3 cubemap = DecodeHDR(rgbm, d.probeHDR[0]) * specular.a;
    //Unity_GlossyEnvironmentData g = UnityGlossyEnvironmentSetup(1- roughness, d.worldViewDir, worldNormal, specular.rgb);	

    //half3 cubemap = UnityGI_IndirectSpecular(d, specular.a, g);		

	float roughnessPow2 = roughness * roughness;
    half surfaceReduction;
#ifdef UNITY_COLORSPACE_GAMMA
    surfaceReduction = 1.0-0.28*roughnessPow2*roughness;      // 1-0.28*x^3 as approximation for (1/(x^4+1))^(1/2.2) on the domain [0;1]
#else
    surfaceReduction = 1.0 / (roughnessPow2*roughnessPow2 + 1.0);           // fade \in [0.5;1]
#endif

	half oneMinusReflectivity = 1 - SpecularStrength(specular.rgb);
	half grazingTerm = saturate(1 - roughness + 1 - oneMinusReflectivity);
	half fresnel = FresnelLerp (specular.rgb, grazingTerm, nv);
	half3 cubemapColor = surfaceReduction * cubemap * fresnel;

	half4 sceneColor = tex2D(_SceneTex, uv);
	sceneColor.rgb = max(1e-5, sceneColor.rgb - cubemapColor.rgb);

	half4 ssrColor = tex2D(_TemporalTex, uv);
	half ssrMask = Square(ssrColor.a);
	
	ssrColor *= surfaceReduction * fresnel * tex2D(_AoTex, uv).r ;
	
	half3 reflectionColor = lerp(cubemapColor,ssrColor.rgb,ssrMask);//(cubemapColor * (1 - ssrMask)) + (ssrColor.rgb * ssrMask);
	sceneColor.rgb += reflectionColor;
	return half4(cubemap,1);
	//return sceneColor;
}

////////////////////////////////-----DeBug_SSRColor Sampler-----------------------------------------------------------------------------
half3 DeBugSSRColor(VaryingsDefault i) : SV_Target
{
	half2 uv = i.texcoord.xy;
	half4 color = tex2D(_TemporalTex, uv); 
	return color.rgb * Square(color.a);
}

