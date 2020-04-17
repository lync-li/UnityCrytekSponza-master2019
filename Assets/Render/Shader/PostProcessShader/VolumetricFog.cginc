#include "PostProcessCommon.cginc"
#include "FunLib.cginc"

#define WEBGL_ITERATIONS 100
#define ZEROS 0.0.xxxx

sampler2D   _FogNoiseTex;	
sampler2D   _DownSampleFogTex;
sampler2D   _DownSampleRawDepthTex; // was sampler2D
float4      _DownSampleRawDepthTex_TexelSize;

half4  _FogColor;
float4 _FogDistance;	
float4 _FogData; // x = _FogBaseHeight, y = _FogHeight, z = density, w = scale;
float3 _FogWindDir;
float4 _FogStep; // x = stepping, y = stepping near, z = edge improvement threshold, w = dithering on (>0 = dithering intensity)	

// Computed internally
float3 wsCameraPos;
float dither;
float4 adir;   

#if WORLDPOS
struct FragmentOutput
{
    half4 dest0 : SV_Target0;
    float4 dest1 : SV_Target1;
};


inline float3 getWorldPos(VaryingsDefault i, float depth01) {
    // Reconstruct the world position of the pixel 		
	    wsCameraPos = float3(_WorldSpaceCameraPos.x, _WorldSpaceCameraPos.y - _FogData.x, _WorldSpaceCameraPos.z);
    	float3 worldPos = (i.cameraToFarPlane * depth01) + wsCameraPos;
    	worldPos.y += 0.00001; // fixes artifacts when worldPos.y = _WorldSpaceCameraPos.y which is really rare but occurs at y = 0
    return worldPos;
}

inline float getDepth(VaryingsDefault i) {
	float depth01 = Linear01Depth(tex2D(_CameraDepthTexture, i.texcoord).r);
	return depth01;
}

half4 getFogColor(float3 worldPos, float depth01) {

	// early exit if fog is not crossed

	if ( (wsCameraPos.y>_FogData.y && worldPos.y>_FogData.y) ||
		    (wsCameraPos.y<-_FogData.y && worldPos.y<-_FogData.y) ) {
		return ZEROS;		
	}
	
	// Determine "fog length" and initial ray position between object and camera, cutting by fog distance params
	adir = float4(worldPos - wsCameraPos, 0);
	adir.w = length(adir.xyz);

	float delta = length(adir.xz);
	float2 ndirxz = adir.xz / delta;
	delta /= adir.y;
		
	float h = clamp(wsCameraPos.y, -_FogData.y, _FogData.y);
	float xh = delta * (wsCameraPos.y - h);
	float2 xz = wsCameraPos.xz - ndirxz * xh;
	float3 fogCeilingCut = float3(xz.x, h, xz.y);

		// does fog starts after pixel? If it does, exit now
	float dist  = adir.w;
	float distanceToFog = distance(fogCeilingCut, wsCameraPos);
		
	clip(dist - distanceToFog);
			
	// floor cut
	float hf = 0;
	// edge cases
	if (delta>0 && worldPos.y > -0.5) {
		hf = _FogData.y;
	} else if (delta<0 && worldPos.y < 0.5) {
		hf = - _FogData.y;
	}
	float xf = delta * ( hf - wsCameraPos.y ); 
 		
	float2 xzb = wsCameraPos.xz - ndirxz * xf;
	float3 fogFloorCut = float3(xzb.x, hf, xzb.y);

	// fog length is...
	float fogLength = distance(fogCeilingCut, fogFloorCut);
	fogLength = min(fogLength, dist - distanceToFog);
		
	clip (fogLength - 0.0001);

	// Calc Ray-march params
	float rs = 0.1 + max( log(fogLength), 0 ) * _FogStep.x;		// stepping ratio with atten detail with distance
	rs *= _FogData.z;	// prevents lag when density is too low
	rs = max(rs, 0.05);
	dist -= distanceToFog;
	float4 dir = float4( adir.xyz * rs / adir.w, fogLength / rs);       // ray direction & length

	// Extracted operations from ray-march loop for additional optimizations
	dir.xz  *= _FogData.w;
	_FogData.y *= _FogData.z;	// extracted from loop, dragged here.
	dir.y   /= _FogData.y;
	float4 ft4 = float4(fogCeilingCut.xyz, 0); 
	ft4.xz  += _FogWindDir.xz;  // apply wind speed and direction; already defined above if the condition is true
	ft4.xz  *= _FogData.w;
	ft4.y   /= _FogData.y;	
	
	#if FOG_DISTANCE 
		float2 camCenter = wsCameraPos.xz + _FogWindDir.xz;
		camCenter *= _FogData.w;
	#endif

	// Ray-march
	half4 sum   = ZEROS;
	half4 fgCol = ZEROS;

	//return dir;
	for (;dir.w>1;dir.w--,ft4.xyz+=dir.xyz) {
		
		half4 ng = tex2Dlod(_FogNoiseTex, ft4.xzww);
		ng.a -= abs(ft4.y);	
        //#if FOG_DISTANCE			
		//	float2 fd = camCenter - ft4.xz;
		//	float fdm = max(_FogDistance.x - dot(fd, fd), 0) * _FogDistance.y;
		//	ng.a -= fdm;
		//#endif
		
		if (ng.a > 0) {
			fgCol   = half4(_FogColor.rgb * (1.0-ng.a), ng.a * 0.8);	

			fgCol.rgb *= ng.rgb * fgCol.a * 8;
			sum += fgCol * (1.0-sum.a);
			if (sum.a>0.9) break;
		}
	}

	// adds fog fraction to prevent banding due stepping on low densities
//		sum += (fogLength >= dist) * (sum.a<0.99) * fgCol * (1.0-sum.a) * dir.w; // if fog hits geometry and accumulation is less than 0.99 add remaining fraction to reduce banding
	half f1 = (sum.a<0.9);
	half oneMinusSumAmount = 1.0-sum.a;
	half fogLengthExceedsDist = (fogLength >= dist);
	half f3 = (half)(fogLengthExceedsDist * dir.w);
	sum += fgCol * (f1 * oneMinusSumAmount * f3);
	
	// max distance falloff
	//float farBlend = saturate( (_FogDistance.z - distanceToFog)  / _FogDistance.w); 
	//sum *= farBlend * farBlend;
		
	return sum;
}

// Fragment Shaders
half4 fragBackFog(VaryingsDefault i) : SV_Target{
	float depthOpaque = getDepth(i);		
	float3 worldPos = getWorldPos(i, depthOpaque);	
	half4 sum = getFogColor(worldPos, depthOpaque);
	return sum;
}

FragmentOutput fragGetFog (VaryingsDefault i) {

	float depthFull = tex2D(_CameraDepthTexture, i.texcoord + float2(0,-0.75) * _CameraDepthTexture_TexelSize.xy).r;
	float depthFull2 = tex2D(_CameraDepthTexture, i.texcoord + float2(0,0.75) * _CameraDepthTexture_TexelSize.xy).r; // prevents artifacts on terrain under some perspective and high downsampling factor
	
	depthFull = min(depthFull, depthFull2);
		
	float depth01  = Linear01Depth(depthFull);

	float3 worldPos = getWorldPos(i, depth01);		

	half4 fogColor = getFogColor(worldPos, depth01);
	FragmentOutput o;
	o.dest0 = fogColor;
	o.dest1 = depthFull.xxxx;
	return o;
}

#endif 
 	

half4 fragApplyFog (VaryingsDefault i) : SV_Target {

    float depthFull = tex2D(_CameraDepthTexture, i.texcoord).r;
	float2 minUV = i.texcoord;
	
#if FOGEDGEIMPROVE  
		float2 uv00 = i.texcoord - 0.5 * _DownSampleRawDepthTex_TexelSize.xy;
		float2 uv10 = uv00 + float2(_DownSampleRawDepthTex_TexelSize.x, 0);
		float2 uv01 = uv00 + float2(0, _DownSampleRawDepthTex_TexelSize.y);
		float2 uv11 = uv00 + _DownSampleRawDepthTex_TexelSize.xy;
    	float4 depths;
    	depths.x = tex2D(_DownSampleRawDepthTex, float4(uv00, 0, 0)).r; // was tex2Dlod
    	depths.y = tex2D(_DownSampleRawDepthTex, float4(uv10, 0, 0)).r; // was tex2Dlod
    	depths.z = tex2D(_DownSampleRawDepthTex, float4(uv01, 0, 0)).r; // was tex2Dlod
    	depths.w = tex2D(_DownSampleRawDepthTex, float4(uv11, 0, 0)).r; // was tex2Dlod
	  	float4 diffs = abs(depthFull.xxxx - depths);
		if (any(diffs > 0.00001)) {
	  		// Check 10 vs 00
	  		float minDiff  = lerp(diffs.x, diffs.y, diffs.y < diffs.x);
	  		minUV    = lerp(uv00, uv10, diffs.y < diffs.x);
	  		// Check against 01
	  		minUV    = lerp(minUV, uv01, diffs.z < minDiff);
	  		minDiff  = lerp(minDiff, diffs.z, diffs.z < minDiff);
	  		// Check against 11
	  		minUV    = lerp(minUV, uv11, diffs.w < minDiff);
		}	
#endif

	half4 sum = tex2D(_DownSampleFogTex, float4(minUV, 0, 0)); // was tex2Dlod

	return sum;
}


