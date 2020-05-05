#include "PostProcessCommon.cginc"

#ifndef HiZ_Method_Advanced
    #define HiZ_Method_Advanced 0
#endif

#ifndef AA_Filter
    #define AA_Filter 1
#endif

#ifndef AA_BicubicFilter
    #define AA_BicubicFilter 0
#endif

	      

Texture2D _SSR_HierarchicalDepth_RT; SamplerState sampler_SSR_HierarchicalDepth_RT;

int _SSR_NumSteps_Linear, _SSR_NumSteps_HiZ, _SSR_NumRays, _SSR_NumResolver, _SSR_CullBack, _SSR_BackwardsRay, _SSR_TraceBehind, _SSR_RayStepSize, _SSR_TraceDistance, _SSR_HiZ_MaxLevel, _SSR_HiZ_StartLevel, _SSR_HiZ_StopLevel, _SSR_HiZ_PrevDepthLevel;

half _SSR_BRDFBias, _SSR_ScreenFade, _SSR_TemporalScale, _SSR_TemporalWeight, _SSR_Thickness;

half3 _SSR_CameraClipInfo;

half4 _SSR_ScreenSize, _SSR_RayCastSize, _SSR_NoiseSize, _SSR_Jitter, _SSR_RandomSeed, _SSR_ProjInfo;

half4x4 _SSR_ProjectionMatrix, _SSR_InverseProjectionMatrix, _SSR_ViewProjectionMatrix, _SSR_InverseViewProjectionMatrix, _SSR_LastFrameViewProjectionMatrix, _SSR_WorldToCameraMatrix, _SSR_CameraToWorldMatrix, _SSR_ProjectToPixelMatrix;



int _HiZbufferLevel;
Texture2D _HiZbufferTex;
SamplerState sampler_HiZbufferTex;




float Hierarchical_ZBuffer(v2f i) : SV_Target {
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
	
	//_SSR_HierarchicalDepth_RT.SampleLevel( sampler_SSR_HierarchicalDepth_RT, uv, _SSR_HiZ_PrevDepthLevel, int2(-1.0,-1.0) ).r,
     //   _SSR_HierarchicalDepth_RT.SampleLevel( sampler_SSR_HierarchicalDepth_RT, uv, _SSR_HiZ_PrevDepthLevel, int2(-1.0, 1.0) ).r,
     //   _SSR_HierarchicalDepth_RT.SampleLevel( sampler_SSR_HierarchicalDepth_RT, uv, _SSR_HiZ_PrevDepthLevel, int2(1.0, -1.0) ).r,
     //   _SSR_HierarchicalDepth_RT.SampleLevel( sampler_SSR_HierarchicalDepth_RT, uv, _SSR_HiZ_PrevDepthLevel, int2(1.0, 1.0) ).r

	return max( max(minDepth.x, minDepth.y), max(minDepth.z, minDepth.w) );
}

/*

half SSR_BRDF(half3 V, half3 L, half3 N, half Roughness)
{
	half3 H = normalize(L + V);

	half NoH = max(dot(N, H), 0);
	half NoL = max(dot(N, L), 0);
	half NoV = max(dot(N, V), 0);

	half D = D_GGX(NoH, Roughness);
	half G = Vis_SmithGGXCorrelated(NoL, NoV, Roughness);

	return max(0, D * G);
}
////////////////////////////////-----Hierarchical_ZTrace Sampler-----------------------------------------------------------------------------
void Hierarchical_ZTrace_SingleSPP(PixelInput i, out half4 RayHit_PDF : SV_Target0, out half4 Mask : SV_Target1)
{
	float2 UV = i.uv.xy;

	float SceneDepth = tex2Dlod(_CameraDepthTexture, float4(UV, 0, 0)).r;
	half Roughness = clamp(1 - tex2D(_CameraGBufferTexture1, UV).a, 0.02, 1);
	float3 WorldNormal = tex2D(_CameraGBufferTexture2, UV) * 2 - 1;
	float3 ViewNormal = mul((float3x3)(_SSR_WorldToCameraMatrix), WorldNormal);

	float3 ScreenPos = GetScreenSpacePos(UV, SceneDepth);
	float3 WorldPos = GetWorldSpacePos(ScreenPos, _SSR_InverseViewProjectionMatrix);
	float3 ViewPos = GetViewSpacePos(ScreenPos, _SSR_InverseProjectionMatrix);
	float3 ViewDir = GetViewDir(WorldPos, ViewPos);

	half2 Hash = tex2Dlod(_SSR_Noise, half4((UV + _SSR_Jitter.zw) * _SSR_RayCastSize.xy / _SSR_NoiseSize.xy, 0, 0)).xy;
	Hash.y = lerp(Hash.y, 0.0, _SSR_BRDFBias);
	
	half4 H = 0.0;
	if (Roughness > 0.1) {
		H = TangentToWorld(ImportanceSampleGGX(Hash, Roughness), half4(ViewNormal, 1.0));
	} else {
		H = half4(ViewNormal, 1.0);
	}
	float3 ReflectionDir = reflect(normalize(ViewPos), H.xyz);

	float3 rayStart = float3(UV, ScreenPos.z);
	float4 rayProj = mul ( _SSR_ProjectionMatrix, float4(ViewPos + ReflectionDir, 1.0) );
	float3 rayDir = normalize( (rayProj.xyz / rayProj.w) - ScreenPos);
	rayDir.xy *= 0.5;

	#if HiZ_Method_Advanced
  		float4 RayHitData = Hierarchical_Z_Trace(_SSR_HiZ_MaxLevel, _SSR_HiZ_StartLevel, _SSR_HiZ_StopLevel, _SSR_NumSteps_HiZ, _SSR_Thickness, _SSR_RayCastSize.xy, rayStart, rayDir, _SSR_HierarchicalDepth_RT);
	#else
		float4 RayHitData = Hierarchical_Z_Trace(_SSR_HiZ_MaxLevel, _SSR_HiZ_StartLevel, _SSR_HiZ_StopLevel, _SSR_NumSteps_HiZ, _SSR_Thickness, 1 / _SSR_RayCastSize.xy, rayStart, rayDir, _SSR_HierarchicalDepth_RT, sampler_SSR_HierarchicalDepth_RT);
	#endif

	RayHit_PDF = half4(RayHitData.xyz, H.a);
	Mask = Square( RayHitData.a * GetScreenFadeBord(RayHitData.xy, _SSR_ScreenFade) );
}


void Hierarchical_ZTrace_MultiSPP(PixelInput i, out half4 SSRColor_PDF : SV_Target0, out half4 Mask_Depth_HitUV : SV_Target1)
{
	float2 UV = i.uv.xy;

	float SceneDepth = tex2Dlod(_CameraDepthTexture, float4(UV, 0, 0)).r;
	half Roughness = clamp(1 - tex2D(_CameraGBufferTexture1, UV).a, 0.02, 1);
	float3 WorldNormal = tex2D(_CameraGBufferTexture2, UV) * 2 - 1;
	float3 ViewNormal = mul((float3x3)(_SSR_WorldToCameraMatrix), WorldNormal);

	float3 ScreenPos = GetScreenSpacePos(UV, SceneDepth);
	float3 WorldPos = GetWorldSpacePos(ScreenPos, _SSR_InverseViewProjectionMatrix);
	float3 ViewPos = GetViewSpacePos(ScreenPos, _SSR_InverseProjectionMatrix);
	float3 ViewDir = GetViewDir(WorldPos, ViewPos);

	//-----Consten Property-------------------------------------------------------------------------
	half Ray_HitMask = 0, Out_Fade = 0, Out_Mask= 0, Out_PDF = 0, Out_RayDepth = 0;
	half2 Out_UV = 0;
	half4 Out_Color = 0;

	for (uint i = 0; i < (uint)_SSR_NumRays; i++)
	{
		//-----Trace Dir-----------------------------------------------------------------------------
		half2 Hash = tex2Dlod(_SSR_Noise, half4((UV + sin( i + _SSR_Jitter.zw )) * _SSR_RayCastSize.xy / _SSR_NoiseSize.xy, 0, 0)).xy;
		Hash.y = lerp(Hash.y, 0.0, _SSR_BRDFBias);

		half4 H = 0.0;
		if (Roughness > 0.1) {
			H = TangentToWorld(ImportanceSampleGGX(Hash, Roughness), half4(ViewNormal, 1.0));
		} else {
			H = half4(ViewNormal, 1.0);
		}
		half3 ReflectionDir = reflect(normalize(ViewPos), H.xyz);

		float3 rayStart = float3(UV, ScreenPos.z);
		float4 rayProj = mul ( _SSR_ProjectionMatrix, float4(ViewPos + ReflectionDir, 1.0) );
		float3 rayDir = normalize( (rayProj.xyz / rayProj.w) - ScreenPos);
		rayDir.xy *= 0.5;

		#if HiZ_Method_Advanced
			float4 RayHitData = Hierarchical_Z_Trace(_SSR_HiZ_MaxLevel, _SSR_HiZ_StartLevel, _SSR_HiZ_StopLevel, _SSR_NumSteps_HiZ, _SSR_Thickness, _SSR_RayCastSize.xy, rayStart, rayDir, _SSR_HierarchicalDepth_RT);
		#else
			float4 RayHitData = Hierarchical_Z_Trace(_SSR_HiZ_MaxLevel, _SSR_HiZ_StartLevel, _SSR_HiZ_StopLevel, _SSR_NumSteps_HiZ, _SSR_Thickness, 1 / _SSR_RayCastSize.xy, rayStart, rayDir, _SSR_HierarchicalDepth_RT, sampler_SSR_HierarchicalDepth_RT);
		#endif

		float4 SampleColor = tex2Dlod(_SSR_SceneColor_RT, half4(RayHitData.xy, 0, 0));
		SampleColor.rgb /= 1 + Luminance(SampleColor.rgb);

		Out_Color += SampleColor;
		Out_Mask += RayHitData.a * GetScreenFadeBord(RayHitData.xy, _SSR_ScreenFade);
		Out_RayDepth += RayHitData.z;
		Out_UV += RayHitData.xy;
		Out_PDF += H.a;
	}

	//-----Output-----------------------------------------------------------------------------
	Out_Color /= _SSR_NumRays;
	Out_Color.rgb /= 1 - Luminance(Out_Color.rgb);
	Out_Mask /= _SSR_NumRays;
	Out_RayDepth /= _SSR_NumRays;
	Out_UV /= _SSR_NumRays;
	Out_PDF /= _SSR_NumRays;

	SSRColor_PDF = half4(Out_Color.rgb, Out_PDF);
	Mask_Depth_HitUV = half4(Square(Out_Mask), Out_RayDepth, Out_UV);
}

////////////////////////////////-----Spatio Sampler-----------------------------------------------------------------------------
//static const int2 offset[4] = { int2(0, 0), int2(0, 2), int2(2, 0), int2(2, 2) };
//static const int2 offset[9] ={int2(-1.0, -1.0), int2(0.0, -1.0), int2(1.0, -1.0), int2(-1.0, 0.0), int2(0.0, 0.0), int2(1.0, 0.0), int2(-1.0, 1.0), int2(0.0, 1.0), int2(1.0, 1.0)};
static const int2 offset[9] ={int2(-2.0, -2.0), int2(0.0, -2.0), int2(2.0, -2.0), int2(-2.0, 0.0), int2(0.0, 0.0), int2(2.0, 0.0), int2(-2.0, 2.0), int2(0.0, 2.0), int2(2.0, 2.0)};
float4 Spatiofilter_SingleSPP(PixelInput i) : SV_Target
{
	half2 UV = i.uv.xy;
	half Roughness = clamp(1 - tex2D(_CameraGBufferTexture1, UV).a, 0.02, 1);
	half SceneDepth = tex2D(_CameraDepthTexture, UV);
	half4 WorldNormal = tex2D(_CameraGBufferTexture2, UV) * 2 - 1;
	half3 ViewNormal = GetViewSpaceNormal(WorldNormal, _SSR_WorldToCameraMatrix);
	half3 ScreenPos = GetScreenSpacePos(UV, SceneDepth);
	half3 WorldPos = GetWorldSpacePos(ScreenPos, _SSR_InverseViewProjectionMatrix);
	half3 ViewPos = GetViewSpacePos(ScreenPos, _SSR_InverseProjectionMatrix);

	half2 BlueNoise = tex2D(_SSR_Noise, (UV + _SSR_Jitter.zw) * _SSR_ScreenSize.xy / _SSR_NoiseSize.xy) * 2 - 1;
	half2x2 OffsetRotationMatrix = half2x2(BlueNoise.x, BlueNoise.y, -BlueNoise.y, -BlueNoise.x);

	half NumWeight, Weight;
	half2 Offset_UV, Neighbor_UV;
	half4 SampleColor, ReflecttionColor;

	for (int i = 0; i < _SSR_NumResolver; i++)
	{
		Offset_UV = mul(OffsetRotationMatrix, offset[i] * (1 / _SSR_ScreenSize.xy));
		Neighbor_UV = UV + Offset_UV;

		half4 HitUV_PDF = tex2Dlod(_SSR_RayCastRT, half4(Neighbor_UV, 0, 0));
		half3 Hit_ViewPos = GetViewSpacePos(GetScreenSpacePos(HitUV_PDF.rg, HitUV_PDF.b), _SSR_InverseProjectionMatrix);

		///SpatioSampler
		Weight = SSR_BRDF(normalize(-ViewPos), normalize(Hit_ViewPos - ViewPos), ViewNormal, Roughness) / max(1e-5, HitUV_PDF.a);
		SampleColor.rgb = tex2Dlod(_SSR_SceneColor_RT, half4(HitUV_PDF.rg, 0, 0)).rgb;
		SampleColor.rgb /= 1 + Luminance(SampleColor.rgb);
		SampleColor.a = tex2Dlod(_SSR_RayMask_RT, half4(Neighbor_UV, 0, 0)).r;

		ReflecttionColor += SampleColor * Weight;
		NumWeight += Weight;
	}

	ReflecttionColor /= NumWeight;
	ReflecttionColor.rgb /= 1 - Luminance(ReflecttionColor.rgb);
	ReflecttionColor = max(1e-5, ReflecttionColor);
	//ReflecttionColor.a = tex2D(_SSR_RayMask_RT, UV).r;

	return ReflecttionColor;
}

float4 Spatiofilter_MultiSPP(PixelInput i) : SV_Target
{
	half2 UV = i.uv.xy;
	half Roughness = clamp(1 - tex2D(_CameraGBufferTexture1, UV).a, 0.02, 1);
	half SceneDepth = tex2D(_CameraDepthTexture, UV);
	half4 WorldNormal = tex2D(_CameraGBufferTexture2, UV) * 2 - 1;
	half3 ViewNormal = GetViewSpaceNormal(WorldNormal, _SSR_WorldToCameraMatrix);
	half3 ScreenPos = GetScreenSpacePos(UV, SceneDepth);
	half3 WorldPos = GetWorldSpacePos(ScreenPos, _SSR_InverseViewProjectionMatrix);
	half3 ViewPos = GetViewSpacePos(ScreenPos, _SSR_InverseProjectionMatrix);

	half2 BlueNoise = tex2D(_SSR_Noise, (UV + _SSR_Jitter.zw) * _SSR_ScreenSize.xy / _SSR_NoiseSize.xy) * 2 - 1;
	half2x2 OffsetRotationMatrix = half2x2(BlueNoise.x, BlueNoise.y, -BlueNoise.y, -BlueNoise.x);

	half NumWeight, Weight;
	half2 Offset_UV, Neighbor_UV;
	half3 Hit_ViewPos;
	half4 SampleColor, ReflecttionColor;
	
	for (int i = 0; i < _SSR_NumResolver; i++) {
		Offset_UV = mul( OffsetRotationMatrix, offset[i] * (1 / _SSR_ScreenSize.xy) );
		Neighbor_UV = UV + Offset_UV;

		half PDF = tex2Dlod(_SSR_RayCastRT, half4(Neighbor_UV, 0, 0)).a;
		half4 Hit_Mask_Depth_UV = tex2Dlod(_SSR_RayMask_RT, half4(Neighbor_UV, 0, 0));
		half3 Hit_ViewPos = GetViewSpacePos(GetScreenSpacePos(Hit_Mask_Depth_UV.ba, Hit_Mask_Depth_UV.g), _SSR_InverseProjectionMatrix);

		///SpatioSampler
		Weight = SSR_BRDF(normalize(-ViewPos), normalize(Hit_ViewPos - ViewPos), ViewNormal, Roughness) / max(1e-5, PDF);
		SampleColor.rgb = tex2Dlod(_SSR_RayCastRT, half4(Neighbor_UV, 0, 0)).rgb;
		SampleColor.a = tex2Dlod(_SSR_RayMask_RT, half4(Neighbor_UV, 0, 0)).r;

		ReflecttionColor += SampleColor * Weight;
		NumWeight += Weight;
	}

	ReflecttionColor /= NumWeight;
	ReflecttionColor = max(1e-5, ReflecttionColor);
	//ReflecttionColor.a = tex2D(_SSR_RayMask_RT, UV).r;

	return ReflecttionColor;
}

////////////////////////////////-----Temporal Sampler-----------------------------------------------------------------------------
half4 Temporalfilter_SingleSPP(PixelInput i) : SV_Target
{
	half2 UV = i.uv.xy;
	half HitDepth = tex2D(_SSR_RayCastRT, UV).b;
	half3 WorldNormal = tex2D(_CameraGBufferTexture2, UV).rgb * 2 - 1;

	/////Get Reprojection Velocity
	half2 Depth_Velocity = tex2D(_CameraMotionVectorsTexture, UV);
	half2 Ray_Velocity = GetMotionVector(HitDepth, UV, _SSR_InverseViewProjectionMatrix, _SSR_LastFrameViewProjectionMatrix, _SSR_ViewProjectionMatrix);
	half Velocity_Weight = saturate(dot(WorldNormal, half3(0, 1, 0)));
	half2 Velocity = lerp(Depth_Velocity, Ray_Velocity, Velocity_Weight);

	/////Get AABB ClipBox
	half SSR_Variance = 0;
	half4 SSR_CurrColor = 0;
	half4 SSR_MinColor, SSR_MaxColor;
	ResolverAABB(_SSR_Spatial_RT, 0, 10, _SSR_TemporalScale, UV, _SSR_ScreenSize.xy, SSR_Variance, SSR_MinColor, SSR_MaxColor, SSR_CurrColor);

	/////Clamp TemporalColor
	half4 SSR_PrevColor = tex2D(_SSR_TemporalPrev_RT, UV - Velocity);
	//half4 SSR_PrevColor = Bilateralfilter(_SSR_TemporalPrev_RT, UV - Velocity, _SSR_ScreenSize.xy);
	SSR_PrevColor = clamp(SSR_PrevColor, SSR_MinColor, SSR_MaxColor);

	/////Combine TemporalColor
	half Temporal_BlendWeight = saturate(_SSR_TemporalWeight * (1 - length(Velocity) * 8));
	half4 ReflectionColor = lerp(SSR_CurrColor, SSR_PrevColor, Temporal_BlendWeight);

	return ReflectionColor;
}

half4 Temporalfilter_MultiSPP(PixelInput i) : SV_Target
{
	half2 UV = i.uv.xy;
	half HitDepth = tex2D(_SSR_RayMask_RT, UV).g;
	half3 WorldNormal = tex2D(_CameraGBufferTexture2, UV).rgb * 2 - 1;

	/////Get Reprojection Velocity
	half2 Depth_Velocity = tex2D(_CameraMotionVectorsTexture, UV);
	half2 Ray_Velocity = GetMotionVector(HitDepth, UV, _SSR_InverseViewProjectionMatrix, _SSR_LastFrameViewProjectionMatrix, _SSR_ViewProjectionMatrix);
	half Velocity_Weight = saturate(dot(WorldNormal, half3(0, 1, 0)));
	half2 Velocity = lerp(Depth_Velocity, Ray_Velocity, Velocity_Weight);
	
	/////Get AABB ClipBox
	half SSR_Variance = 0;
	half4 SSR_CurrColor = 0;
	half4 SSR_MinColor, SSR_MaxColor;
	ResolverAABB(_SSR_Spatial_RT, 0, 10, _SSR_TemporalScale, UV, _SSR_ScreenSize.xy, SSR_Variance, SSR_MinColor, SSR_MaxColor, SSR_CurrColor);

	/////Clamp TemporalColor
	half4 SSR_PrevColor = tex2D(_SSR_TemporalPrev_RT, UV - Velocity);
	//half4 SSR_PrevColor = Bilateralfilter(_SSR_TemporalPrev_RT, UV - Velocity, _SSR_ScreenSize.xy);
	SSR_PrevColor = clamp(SSR_PrevColor, SSR_MinColor, SSR_MaxColor);

	/////Combine TemporalColor
	half Temporal_BlendWeight = saturate(_SSR_TemporalWeight * (1 - length(Velocity) * 8));
	half4 ReflectionColor = lerp(SSR_CurrColor, SSR_PrevColor, Temporal_BlendWeight);

	return ReflectionColor;
}

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

float4 TestSSGi_SingleSPP(PixelInput i) : SV_Target
{
	float2 UV = i.uv.xy;

	float SceneDepth = tex2Dlod(_CameraDepthTexture, float4(UV, 0, 0)).r;
	half Roughness = clamp(1 - tex2D(_CameraGBufferTexture1, UV).a, 0.02, 1);
	float3 WorldNormal = tex2D(_CameraGBufferTexture2, UV) * 2 - 1;
	float3 ViewNormal = mul((float3x3)(_SSR_WorldToCameraMatrix), WorldNormal);

	float3 ScreenPos = GetScreenSpacePos(UV, SceneDepth);
	float3 WorldPos = GetWorldSpacePos(ScreenPos, _SSR_InverseViewProjectionMatrix);
	float3 ViewPos = GetViewSpacePos(ScreenPos, _SSR_InverseProjectionMatrix);
	float3 ViewDir = GetViewDir(WorldPos, ViewPos);

	float3x3 TangentBasis = GetTangentBasis( WorldNormal );
	uint3 p1 = Rand3DPCG16( uint3( (float)0xffba * abs(WorldPos) ) );
	uint2 p = (uint2(UV * 3) ^ 0xa3c75a5cu) ^ (p1.xy);
	uint3 Random = Rand3DPCG16( int3( p, ReverseBits32(_SSR_Jitter.x) ) );

	//float2 Hash = float2(Random.xy ^ Random.z) / 0xffffu;
	half2 Hash = tex2Dlod(_SSR_Noise, half4((UV + _SSR_Jitter.zw) * _SSR_RayCastSize.xy / _SSR_NoiseSize.xy, 0, 0)).xy;

	float3 L;
	L.xy = UniformSampleDiskConcentric( Hash );
	L.z = sqrt( 1 - dot( L.xy, L.xy ) );
	float3 World_L = mul( L, TangentBasis );
	float3 View_L = mul((float3x3)(_SSR_WorldToCameraMatrix),  World_L);

	float3 rayStart = float3(UV, ScreenPos.z);
	float4 rayProj = mul ( _SSR_ProjectionMatrix, float4(ViewPos + View_L, 1.0) );
	float3 rayDir = normalize( (rayProj.xyz / rayProj.w) - ScreenPos);
	rayDir.xy *= 0.5;

	float4 RayHitData = Hierarchical_Z_Trace(_SSR_HiZ_MaxLevel, _SSR_HiZ_StartLevel, _SSR_HiZ_StopLevel, _SSR_NumSteps_HiZ, _SSR_Thickness, 1 / _SSR_RayCastSize.xy, rayStart, rayDir, _SSR_HierarchicalDepth_RT, sampler_SSR_HierarchicalDepth_RT);

	float SSMask = Square( RayHitData.a * GetScreenFadeBord(RayHitData.xy, _SSR_ScreenFade) );
	float3 SampleColor = tex2D(_SSR_SceneColor_RT, RayHitData.xy);
	float3 SampleNormal = tex2D(_CameraGBufferTexture2, RayHitData.xy) * 2 - 1;

	SampleColor *= 1 - saturate( dot(World_L, SampleNormal) );
	SampleColor *= rcp( 1 + Luminance(SampleColor) );
	SampleColor *= rcp( 1 - Luminance(SampleColor) );

	//-----Output-----------------------------------------------------------------------------
	float3 SceneColor = tex2D(_SSR_SceneColor_RT, UV);
	float3 BaseColor = tex2D(_CameraGBufferTexture0, UV);

	float3 SSGi = (SampleColor * 2);
	//SSGi *= BaseColor;

	return float4(SSGi , SSMask);

}

float4 TestSSGi_MultiSPP(PixelInput i) : SV_Target
{
	float2 UV = i.uv.xy;

	float SceneDepth = tex2Dlod(_CameraDepthTexture, float4(UV, 0, 0)).r;
	half Roughness = clamp(1 - tex2D(_CameraGBufferTexture1, UV).a, 0.02, 1);
	float3 WorldNormal = tex2D(_CameraGBufferTexture2, UV) * 2 - 1;
	float3 ViewNormal = mul((float3x3)(_SSR_WorldToCameraMatrix), WorldNormal);

	float3 ScreenPos = GetScreenSpacePos(UV, SceneDepth);
	float3 WorldPos = GetWorldSpacePos(ScreenPos, _SSR_InverseViewProjectionMatrix);
	float3 ViewPos = GetViewSpacePos(ScreenPos, _SSR_InverseProjectionMatrix);
	float3 ViewDir = GetViewDir(WorldPos, ViewPos);

	//-----Consten Property-------------------------------------------------------------------------
	half Out_Mask = 0;
	half3 Out_Color = 0;

	float3x3 TangentBasis = GetTangentBasis( WorldNormal );
	uint3 p1 = Rand3DPCG16( uint3( (float)0xffba * abs(WorldPos) ) );
	uint2 p = (uint2(UV * 3) ^ 0xa3c75a5cu) ^ (p1.xy);

	for (uint i = 0; i < (uint)_SSR_NumRays; i++)
	{
		//-----Trace Dir-----------------------------------------------------------------------------
		uint3 Random = Rand3DPCG16( int3( p, ReverseBits32(i) ) );
		float2 Hash = float2(Random.xy ^ Random.z) / 0xffffu;

		float3 L;
		L.xy = UniformSampleDiskConcentric( Hash );
		L.z = sqrt( 1 - dot( L.xy, L.xy ) );
		float3 World_L = mul( L, TangentBasis );
		float3 View_L = mul((float3x3)(_SSR_WorldToCameraMatrix),  World_L);

		float3 rayStart = float3(UV, ScreenPos.z);
		float4 rayProj = mul ( _SSR_ProjectionMatrix, float4(ViewPos + View_L, 1.0) );
		float3 rayDir = normalize( (rayProj.xyz / rayProj.w) - ScreenPos);
		rayDir.xy *= 0.5;

		float4 RayHitData = Hierarchical_Z_Trace(_SSR_HiZ_MaxLevel, _SSR_HiZ_StartLevel, _SSR_HiZ_StopLevel, _SSR_NumSteps_HiZ, _SSR_Thickness, 1 / _SSR_RayCastSize.xy, rayStart, rayDir, _SSR_HierarchicalDepth_RT, sampler_SSR_HierarchicalDepth_RT);

		float3 SampleColor = tex2Dlod(_SSR_SceneColor_RT, half4(RayHitData.xy, 0, 0));
		float4 SampleNormal = tex2Dlod(_CameraGBufferTexture2, half4(RayHitData.xy, 0, 0)) * 2 - 1;
		float Occlusion = 1 - saturate( dot(World_L, SampleNormal) );

		SampleColor *= Occlusion;
		SampleColor *= rcp( 1 + Luminance(SampleColor) );

		Out_Color += SampleColor;
		Out_Mask += Square( RayHitData.a * GetScreenFadeBord(RayHitData.xy, _SSR_ScreenFade) );
	}
	Out_Color /= _SSR_NumRays;
	Out_Color *= rcp( 1 - Luminance(Out_Color) );
	Out_Mask /= _SSR_NumRays;

	//-----Output-----------------------------------------------------------------------------
	float3 SceneColor = tex2D(_SSR_SceneColor_RT, UV);
	float3 BaseColor = tex2D(_CameraGBufferTexture0, UV);

	float3 SSGi = (Out_Color * 2);
	//SSGi *= BaseColor;

	return half4(SSGi, Out_Mask);
}
*/