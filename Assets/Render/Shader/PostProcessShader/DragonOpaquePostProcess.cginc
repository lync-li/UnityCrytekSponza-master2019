#include "PostProcessCommon.cginc"
#include "FunLib.cginc"

half4 frag_main (VaryingsDefault i) : COLOR
{		
	half4 color = 1;
#if (defined (LUMAOCCLUSION)) || (defined (LUMAOCCLUSION_DEBUG))
	float lumaM = getLuma(color.rgb);
	half4 occlusion = tex2D(_LumaTex, i.texcoord);	
	#if LUMAOCCLUSION_DEBUG
	color.rgb = 1.0.xxx;
	#endif
   	color.rgb *= lerp(1.0.xxx, occlusion.rgb, occlusion.a);
#endif

#if defined(HBAO) || defined(HBAO_DEBUG) 
	half4 occ = tex2D(_HBAOTex, i.texcoord);
	occ.r = saturate(pow(occ.r, _AOIntensity));
	half3 aoColor = lerp(_AOColor.rgb, half3(1.0, 1.0, 1.0), occ.r);
	#ifdef HBAO_DEBUG	
	color.rgb = aoColor;
	#else
	color.rgb *= aoColor;
	#endif
#endif
	
#if defined(CLOUDSHADOW) 
	float depthFull = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, i.texcoord);

	float z = DECODE_EYEDEPTH(depthFull);
	float3 P = float3((i.texcoord * _UVToView.xy + _UVToView.zw) * z, z);;					
	float2 uv = P.xz * _CloudShadowParams.x + (_Time.y * float2(_CloudShadowParams.z, _CloudShadowParams.w));
	float2 uv2 = P.xz * _CloudShadowParams.x * 0.8  + (_Time.y * float2(_CloudShadowParams.z *4 , _CloudShadowParams.w *4));
	
	//float angle = frac(_Time.y * 2) + P.x * P.y * 10;
	//float move = SmoothTriangleWave(angle)  * 0.1;
	
	float cloud = 1 - tex2D(_CloudShadowTex, uv ).r;		
	float cloud2 = 1 - tex2D(_CloudShadowTex, uv2).r;	
	
	cloud = min(cloud, cloud2) ;
	
	cloud = 0.5 + (cloud - 0.5)*_CloudShadowParams.y *2;
	cloud = clamp(0.1,1.3,cloud);
	float b = max(max(_CloudShadowColor.r,_CloudShadowColor.g),_CloudShadowColor.b);	
	half3 cloudColor = lerp(_CloudShadowColor.rgb,1.3,cloud);			
	color.rgb *= cloudColor;
#endif
		
	return color;
}
