#include "PostProcessCommon.cginc"
#include "StochasticSSRFun.cginc"
#include "UnityCG.cginc"
     
#define HiZ_Start_Level 2
#define HiZ_Stop_Level  0

int _HiZbufferLevel;
int _NumRay;
int _RayCastStepNum;
int _HiZMaxLevel;
int _NumResolver;

half4 _Jitter;
half _BRDFBias;
half _RayCastThickness;
half _ScreenFade;
half _TemporalScale;
half _TemporalWeight;

float4x4 _PrevViewProjectionMatrix;

Texture2D _HiZbufferTex;
SamplerState sampler_HiZbufferTex;

sampler2D _SSRNoiseTex;
float2    _SSRNoiseTexSize;

sampler2D _SceneTex;
float2    _SceneTexSize;

sampler2D _RayCastTex0;
sampler2D _RayCastTex1;
sampler2D _CameraMotionVectorsTexture;

sampler2D _SpatialTex;
sampler2D _PrevTemporalTex;

float HierarchicalZBuffer(v2f i) : SV_Target {
	float2 uv = i.texcoord0.xy;	
	
    half4 minDepth;
	//minDepth.x = tex2Dlod(_CameraDepthTexture,float4(uv + _CameraDepthTexture_TexelSize.xy * float2(-1,-1),0,hiZbufferLevel)).r;
	//minDepth.y = tex2Dlod(_CameraDepthTexture,float4(uv + _CameraDepthTexture_TexelSize.xy * float2(-1,1),0,hiZbufferLevel)).r;
	//minDepth.z = tex2Dlod(_CameraDepthTexture,float4(uv + _CameraDepthTexture_TexelSize.xy * float2(1,-1),0,hiZbufferLevel)).r;
	//minDepth.w = tex2Dlod(_CameraDepthTexture,float4(uv + _CameraDepthTexture_TexelSize.xy * float2(1,-1),0,hiZbufferLevel)).r;
	
	minDepth.x = _HiZbufferTex.SampleLevel(sampler_HiZbufferTex,uv, _HiZbufferLevel,int2(-1,-1)).r;
	minDepth.y = _HiZbufferTex.SampleLevel(sampler_HiZbufferTex,uv, _HiZbufferLevel,int2(-1,1)).r;
	minDepth.z = _HiZbufferTex.SampleLevel(sampler_HiZbufferTex,uv, _HiZbufferLevel,int2(1,-1)).r;
	minDepth.w = _HiZbufferTex.SampleLevel(sampler_HiZbufferTex,uv, _HiZbufferLevel,int2(1,-1)).r;

	return max( max(minDepth.x, minDepth.y), max(minDepth.z, minDepth.w) );
}

///////////////////////////////-----Hierarchical_ZTrace Sampler-----------------------------------------------------------------------------
void HierarchicalZTrace(VaryingsDefault i, out half4 output0 : SV_Target0, out half4 output1 : SV_Target1)
{
	float2 uv = i.texcoord.xy;

	float depth = tex2D(_CameraDepthTexture, uv).r;
	half4 normalSmoothness = tex2D(_NormalBufferTex, uv);
	half  roughness = clamp(1 - normalSmoothness.a, 0.02, 1);
	float3 worldNormal = normalSmoothness.rgb * 2 - 1;
		
	float3 viewNormal = mul((float3x3)(unity_WorldToCamera), worldNormal);
	float3 screenPos = half3(uv.xy * 2 - 1, depth.r);	
	float3 worldPos = GetWorldPos(i, Linear01Depth(depth));	
	
	float4 viewPos = mul(unity_WorldToCamera, float4(worldPos,1.0));
	viewPos.xyz /= viewPos.z;
	//float3 viewDir = normalize(worldPos - _WorldSpaceCameraPos);
	
	float2 _RayCastSize = _ScreenParams.zw - 1.0;
	
	half3 outColor = 0;
	half3 outHitViewPos = 0;
	half  outMask = 0;
	half  outPDF = 0;
#if MULTI	
	for (int i = 0; i < _NumRay; i++)
	{
		_Jitter.zw = sin( i + _Jitter.zw );
#endif
		half2 hash = tex2D(_SSRNoiseTex, (uv + _Jitter.zw) * _RayCastSize / _SSRNoiseTexSize).xy;
		hash.y = lerp(hash.y, 0.0, _BRDFBias);
	
		half4 H = 0.0;
		if (roughness > 0.1) {
			H = TangentToWorld(viewNormal,ImportanceSampleGGX(hash, roughness));
		} else {
			H = half4(viewNormal, 1.0);
		}
		float3 reflectionDir = reflect(normalize(viewPos), H.xyz);

		float3 rayStart = float3(uv, depth);
		float4 rayProj = mul ( unity_CameraProjection, float4(viewPos + reflectionDir, 1.0) );
		float3 rayDir = normalize( (rayProj.xyz / rayProj.w) - screenPos);
		rayDir.xy *= 0.5;		
		
		float samplerSize = GetMarchSize(rayStart.xy, rayStart.xy + rayDir.xy, _RayCastSize);
		float3 samplePos = rayStart + rayDir * (samplerSize);
		int level = HiZ_Start_Level; float mask = 0.0;

		UNITY_LOOP
		for (int j = 0; j < _RayCastStepNum; j++)
		{
			float2 cellCount = _RayCastSize * exp2(level + 1.0);
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

		float3 sampleColor = tex2D(_SceneTex, samplePos.xy);		
		sampleColor.rgb /= 1 + Luminance(sampleColor.rgb);		
		mask *= GetScreenFadeBord(samplePos.xy, _ScreenFade);
	
		float4 hitViewPos = mul(unity_CameraInvProjection, half4(samplePos, 1));
		hitViewPos.xyz /= hitViewPos.w;
#if MULTI
		outColor += sampleColor;	
		outMask += mask;	
		outHitViewPos += hitViewPos.xyz;
		outPDF += H.a;
	}

	//-----Output-----------------------------------------------------------------------------
	outColor /= _NumRay;
	outColor.rgb /= 1 - Luminance(outColor.rgb);
	outMask /= _NumRay;
	outHitViewPos /= _NumRay;
	outPDF /= _NumRay;
#else	
	outColor = sampleColor;
	outColor.rgb /= 1 - Luminance(outColor.rgb);
	outMask = mask;
	outHitViewPos = hitViewPos.xyz;
	outPDF = H.a;
#endif
	output0 = half4(outColor,outMask);
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
	half4 normalSmoothness = tex2D(_NormalBufferTex, uv);
	half  roughness = clamp(1 - normalSmoothness.a, 0.02, 1);
	float3 worldNormal = normalSmoothness.rgb * 2 - 1;
		
	float3 viewNormal = mul((float3x3)(unity_WorldToCamera), worldNormal);
	float3 screenPos = half3(uv.xy * 2 - 1, depth.r);	
	float3 worldPos = GetWorldPos(i, Linear01Depth(depth));	
	
	float4 viewPos = mul(unity_WorldToCamera, float4(worldPos,1.0));
	viewPos.xyz /= viewPos.z;
	//float3 viewDir = normalize(worldPos - _WorldSpaceCameraPos);	

	float2 _ScreenSize = _ScreenParams.zw - 1.0;
	half2 blueNoise = tex2D(_SSRNoiseTex, (uv + _Jitter.zw) * _ScreenSize / _SSRNoiseTexSize.xy) * 2 - 1;
	half2x2 offsetRotationMatrix = half2x2(blueNoise.x, blueNoise.y, -blueNoise.y, -blueNoise.x);

	half numWeight = 0;
	half weight = 0;
	half2 offsetUV;
	half2 neighborUV;
	half4 sampleColor;
	half4 reflecttionColor;
	
	for (int i = 0; i < _NumResolver; i++) {
		offsetUV = mul(offsetRotationMatrix, offset[i] * (1 / _ScreenSize));
		neighborUV = uv + offsetUV;
		
		half4 rayCast0 = tex2D(_RayCastTex0, neighborUV);
		half4 rayCast1 = tex2D(_RayCastTex1, neighborUV);
		
		///SpatioSampler
		weight = SSR_BRDF(normalize(-viewPos), normalize(rayCast1.xyz - viewPos), viewNormal, roughness) / max(1e-5, rayCast1.w);

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
	half4 normalSmoothness = tex2D(_NormalBufferTex, uv);
	float3 worldNormal = normalSmoothness.rgb * 2 - 1;		
	float3 worldPos = GetWorldPos(i, Linear01Depth(depth));		
	/////Get Reprojection Velocity
	half2 depthVelocity = tex2D(_CameraMotionVectorsTexture, uv);

    half4 prevClipPos = mul(_PrevViewProjectionMatrix, worldPos);
    half4 curClipPos = mul(UNITY_MATRIX_VP, worldPos);

    half2 prevHPos = prevClipPos.xy / prevClipPos.w;
    half2 curHPos = curClipPos.xy / curClipPos.w;

    half2 vPosPrev = (prevHPos.xy + 1) / 2;
    half2 vPosCur = (curHPos.xy + 1) / 2;	
	
	half2 rayVelocity = vPosCur - vPosPrev;
	half  velocityWeight = saturate(dot(worldNormal, half3(0, 1, 0)));
	half2 velocity = lerp(depthVelocity, rayVelocity, velocityWeight);
	float2 _ScreenSize = _ScreenParams.zw - 1.0;

	const int2 sampleOffset[9] = {int2(-1.0, -1.0), int2(0.0, -1.0), int2(1.0, -1.0), int2(-1.0, 0.0), int2(0.0, 0.0), int2(1.0, 0.0), int2(-1.0, 1.0), int2(0.0, 1.0), int2(1.0, 1.0)};
    half4 sampleColors[9];

    for(uint i = 0; i < 9; i++) {
        sampleColors[i] = tex2D(_SpatialTex, uv + ( sampleOffset[i] / _ScreenSize) );
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

/*
////////////////////////////////-----CombinePass-----------------------------------------------------------------------------
half4 CombineReflectionColor(PixelInput i) : SV_Target {
	half2 uv = i.uv.xy;

	half4 WorldNormal = tex2D(_CameraGBufferTexture2, uv) * 2 - 1;
	half4 SpecularColor = tex2D(_CameraGBufferTexture1, uv);
	half Roughness = clamp(1 - SpecularColor.a, 0.02, 1);

	half SceneDepth = tex2D(_CameraDepthTexture, uv);
	half3 ScreenPos = GetScreenSpacePos(uv, SceneDepth);
	half3 WorldPos = GetWorldSpacePos(ScreenPos, _SSR_InverseViewProjectionMatrix);
	half3 ViewDir = GetViewDir(WorldPos, _WorldSpaceCameraPos);

	half NoV = saturate(dot(WorldNormal, -ViewDir));
	half3 EnergyCompensation;
	half4 PreintegratedGF = half4(PreintegratedDGF_LUT(_SSR_PreintegratedGF_LUT, EnergyCompensation, SpecularColor.rgb, Roughness, NoV).rgb, 1);

	half ReflectionOcclusion = saturate( tex2D(_SSAO_GTOTexture2SSR_RT, uv).g );
	//ReflectionOcclusion = ReflectionOcclusion == 0.5 ? 1 : ReflectionOcclusion;
	//half ReflectionOcclusion = 1;

	half4 SceneColor = tex2Dlod(_SSR_SceneColor_RT, half4(uv, 0, 0));
	half4 CubemapColor = tex2D(_CameraReflectionsTexture, uv) * ReflectionOcclusion;
	SceneColor.rgb = max(1e-5, SceneColor.rgb - CubemapColor.rgb);

	half4 SSRColor = tex2D(_SSR_TemporalCurr_RT, uv);
	half SSRMask = Square(SSRColor.a);
	half4 ReflectionColor = (CubemapColor * (1 - SSRMask)) + (SSRColor * PreintegratedGF * SSRMask * ReflectionOcclusion);

	return SceneColor + ReflectionColor;
}

////////////////////////////////-----DeBug_SSRColor Sampler-----------------------------------------------------------------------------
half3 DeBug_SSRColor(PixelInput i) : SV_Target
{
	half2 UV = i.uv.xy;
	half4 SSRColor = tex2D(_SSR_TemporalCurr_RT, UV); 
	//half4 SSRColor = Bilateralfilter(_SSR_TemporalCurr_RT, UV, _SSR_ScreenSize.xy);
	return SSRColor.rgb * Square(SSRColor.a);

	//float2 SSData = tex2D(_SSR_RayCastRT, UV).xy;
	//float3 RayHit_Normal = tex2D(_CameraGBufferTexture2, SSData) * 2 - 1;
	//float RayHit_Depth = tex2D(_CameraDepthTexture, SSData);
	//float RayHit_LinearDepth = Linear01Depth(RayHit_Depth);
	//float RayHit_EyeDepth = LinearEyeDepth(RayHit_Depth);

	//return RayHit_Normal;
}


*/