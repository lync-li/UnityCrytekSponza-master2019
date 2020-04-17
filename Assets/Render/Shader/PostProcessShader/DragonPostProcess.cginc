#include "PostProcessCommon.cginc"
#include "FunLib.cginc"
#include "Colors.cginc"

half4 frag_main (v2f i) : COLOR
{		
#ifdef DISTORTION
	half4 distortion = tex2D(_DistortionTex, i.texcoord0);	
	
	half2 uv0 = (distortion.xy * 2 - 1) * distortion.z * 10  * half2(1,_MainTex_TexelSize.z/_MainTex_TexelSize.w);
	i.texcoord0 += saturate(uv0);
#endif
#ifdef CHROMATICABERRATION_RADIAL
	float2 coords = 2.0 * i.texcoord0 - 1.0;
    float2 end = i.texcoord0 - coords * dot(coords, coords) * _ChromaAmount;
    float2 delta = (end - i.texcoord0) / 3.0;

    half4 color = tex2D(_MainTex, i.texcoord0);
    color.g = tex2D(_MainTex, delta + i.texcoord0).g;
    color.b = tex2D(_MainTex, delta * 2.0 + i.texcoord0).b;    
#elif CHROMATICABERRATION_FULLSCREEN
	half4 color = tex2D(_MainTex, i.texcoord0);
	//#ifdef PLAYER
	//if(color.a  < PLAYERTHRESHOLD)
	//{
		half2 offset = half2(1,_MainTex_TexelSize.z/_MainTex_TexelSize.w);
		half4 colorR = tex2D(_MainTex, i.texcoord0 + _ColorOffset.xy * offset);  
		half4 colorB = tex2D(_MainTex, i.texcoord0 + _ColorOffset.zw * offset);   
		//color.r = lerp(colorR.r,color.r,sign(colorR.a - PLAYERTHRESHOLD) * 0.5 + 0.5);
		//color.b = lerp(colorB.b,color.b,sign(colorB.a - PLAYERTHRESHOLD) * 0.5 + 0.5);	
		color.r = colorR.r;
		color.b = colorB.b;
	//}	
	//#endif
#else
	half4 color = tex2D( _MainTex, i.texcoord0 );	
#endif

#ifdef PLAYER
	if(color.a  < PLAYERTHRESHOLD)
	{	
	#ifdef BLOOM
		half4 bloomColor = tex2D(_BloomTex,i.texcoord1);	
		color.rgb += bloomColor.rgb * _BloomIntensity;
	#endif 
	#ifdef COLORLOOKUP
		color.rgb *= _AdaptedLum;
		float3 sceneLutSpace = saturate(LUT_SPACE_ENCODE(color.rgb));
		color.rgb = ApplyLut2D(_SceneLutTex, sceneLutSpace,_LutParams.xyz);
	#endif
	}
	else
	{
	#ifdef PLAYERCOLORLOOKUP
		color.rgb *= _PlayerAdaptedLum;
		float3 playerLutSpace = saturate(LUT_SPACE_ENCODE(color.rgb));
		color.rgb = ApplyLut2D(_PlayerLutTex, playerLutSpace,_LutParams.xyz);
	#endif	
	}	
	
	#ifdef PLAYERBLOOM //角色默认上层，因为bloom扩散所以无视标记
		half4 playerBloomColor = tex2D(_PlayerBloomTex,i.texcoord1);	
		half playerIntensity = _PlayerBloomIntensity * _PlayerAdaptedLum;
		#ifdef PLAYERCOLORLOOKUP
			playerIntensity = 1;
		#endif
		color.rgb += playerBloomColor.rgb * playerIntensity;
	#endif
#else
	#ifdef BLOOM
		half4 bloomColor = tex2D(_BloomTex,i.texcoord1);	
		color.rgb += bloomColor.rgb * _BloomIntensity;
	#endif 
	#ifdef COLORLOOKUP
		color.rgb *= _AdaptedLum;
		float3 sceneLutSpace = saturate(LUT_SPACE_ENCODE(color.rgb));
		color.rgb = ApplyLut2D(_SceneLutTex, sceneLutSpace,_LutParams.xyz);
	#endif
#endif

#ifdef DEPTHOFFIELD	
    half coc = tex2D(_CoCTex, i.texcoord0);
	half3 dstColor = 0.0;
    half dstAlpha = 1.0;
	
	UNITY_BRANCH
    if (coc > 0.0)
    {
		half4 dof = tex2D(_DepthOfFieldTex, i.texcoord0);
        // Non-linear blend
        // "CryEngine 3 Graphics Gems" [Sousa13]
        half blend = sqrt(coc * TWO_PI);
        dstColor = dof * saturate(blend);
        dstAlpha = saturate(1.0 - blend);
    }
    		
    color.rgb = half3(color.rgb * dstAlpha + dstColor);
#endif 

#ifdef VIGNETTESCENE
	 half2 d = abs(i.texcoord0 - half2(0.5,0.5)) * _VignetteParam.x;
     d = pow(saturate(d), _VignetteParam.z); // Roundness
     half vfactor = pow(saturate(1.0 - dot(d, d)), _VignetteParam.y);
     color.rgb *= lerp(_VignetteColor, (1.0).xxx, vfactor);
#endif

#ifdef ALPHABUFFER
	//#ifdef CHROMATICABERRATION_RADIAL
	//	half4 alphaColor = tex2D(_AlphaTex, i.texcoord0);
	//	alphaColor.g = tex2D(_AlphaTex, delta + i.texcoord0).g;
	//	alphaColor.b = tex2D(_AlphaTex, delta * 2.0 + i.texcoord0).b; 
	//#elif CHROMATICABERRATION_FULLSCREEN
	//	half4 alphaColor = tex2D(_AlphaTex, i.texcoord0);
	//	alphaColor.r = tex2D(_AlphaTex, i.texcoord0 + _ColorOffset.xy * _AlphaTex_TexelSize.xy).r;		
	//	alphaColor.b = tex2D(_AlphaTex, i.texcoord0 + _ColorOffset.zw * _AlphaTex_TexelSize.xy).b; 
	//#else	
		half4 alphaColor = tex2D(_AlphaTex, i.texcoord0 );
	//#endif
	
	#ifdef ALPHABLOOM
		half4 alphaBloomColor = tex2D(_AlphaBloomTex,i.texcoord1);	
		alphaColor.rgb += alphaBloomColor.rgb * _AlphaBloomIntensity;
	#endif 
	#ifdef ALPHACOLORLOOKUP
		alphaColor.rgb *= _AlphaAdaptedLum;
		half num = dot(alphaColor.rgb,half3(1,1,1));
		
		UNITY_BRANCH
		if(num > 0.01)
		{
			float3 alphaLutSpace = saturate(LUT_SPACE_ENCODE(alphaColor.rgb));
			alphaColor.rgb = ApplyLut2D(_AlphaLutTex, alphaLutSpace, _LutParams.xyz);
		}	
	#endif
	color.rgb = alphaColor.rgb  + color.rgb * alphaColor.a; 
#endif

//bokeh dof
//#ifdef DEPTHOFFIELD
//	half4 dof = tex2D(_DepthOfFieldTex, i.texcoord0);
 //   half coc = tex2D(_CoCTex, i.texcoord0);
//    coc = (coc - 0.5) * 2 * _DepthOfFieldParams.z;
 //   // Convert CoC to far field alpha value.
 //   float ffa = smoothstep(_MainTex_TexelSize.y * 2, _MainTex_TexelSize.y * 4, abs(coc));				
 //   color.rgb = lerp(color.rgb, dof.rgb, ffa + dof.a - ffa * dof.a);
//#endif 

#ifdef OVERLAY
	half4 mask = tex2D(_OverlayTex,i.texcoord0);
	color.rgb = LinearToGammaSpace(color);
	color.rgb *= _OverlayColor.rgb;
	color.rgb = color.rgb < 0.5 ? (2.0*color.rgb*mask.rgb) : (1.0 - 2.0*(1.0 - color.rgb)*(1.0 - mask.rgb));
	color.rgb = GammaToLinearSpace(color);
#endif

#ifdef VIGNETTEALL
	 half2 d = abs(i.texcoord0 - half2(0.5,0.5)) * _VignetteParam.x;
     d = pow(saturate(d), _VignetteParam.z); // Roundness
     half vfactor = pow(saturate(1.0 - dot(d, d)), _VignetteParam.y);
     color.rgb *= lerp(_VignetteColor, (1.0).xxx, vfactor);
#endif

#ifdef BORDER
	 half4 boraderMask = tex2D(_BorderMask,i.texcoord1) * _BorderParam.z;	 
	 half4 border = tex2D(_BorderTex,i.texcoord1 * _BorderParam.xy * half2(1,_MainTex_TexelSize.w/_MainTex_TexelSize.z));
	 color.rgb = lerp(color.rgb,border.rgb * _BorderColor.rgb,  saturate(sqrt(boraderMask.r)* border.a *_BorderColor.a )); 	
#endif

	//half3 magic = float3(0.06711056, 0.00583715, 52.9829189);
    //half gradient = frac(magic.z * frac(dot(i.texcoord0 / _MainTex_TexelSize, magic.xy))) / 255.0;
    //color.rgb -= gradient.xxx;

	color.rgb = saturate(color.rgb);
    color.a = dot(color.rgb, half3(0.2126729, 0.7151522, 0.0721750));
	
	return color;
}

half4 frag_simple (v2f i) : COLOR
{	
	half4 color = tex2D( _MainTex, i.texcoord0 );		

	#ifdef BLOOM
		half4 bloomColor = tex2D(_BloomTex,i.texcoord1);	
		color.rgb += bloomColor.rgb * _BloomIntensity;
	#endif 
	#ifdef COLORLOOKUP
		color.rgb *= _AdaptedLum;
		float3 sceneLutSpace = saturate(LUT_SPACE_ENCODE(color.rgb));
		color.rgb = ApplyLut2D(_SceneLutTex, sceneLutSpace,_LutParams.xyz);
	#endif
	
	return color;
}
