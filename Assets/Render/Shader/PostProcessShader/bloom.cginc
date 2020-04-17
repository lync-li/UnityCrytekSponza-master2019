#include "Colors.cginc"
#include "PostProcessCommon.cginc"
#include "FunLib.cginc"

struct v2f_bloomThreshold
{
	float4 pos : POSITION;		
	half2 texcoord0 : TEXCOORD0;	
	half2 texcoord1 : TEXCOORD1;	
	half2 texcoord2	: TEXCOORD2;	
	half2 texcoord3	: TEXCOORD3;
	half2 texcoord4	: TEXCOORD4;
};

v2f_bloomThreshold vert_bloomThreshold (appdata_t v)
{
	v2f_bloomThreshold o = (v2f_bloomThreshold)0;	
	o.pos = UnityObjectToClipPos(v.vertex);		
	o.texcoord0 = v.texcoord + _MainTex_TexelSize.xy * half2(1,0);
	o.texcoord1 = v.texcoord + _MainTex_TexelSize.xy * half2(-1,0);
	o.texcoord2 = v.texcoord + _MainTex_TexelSize.xy * half2(0,1);
	o.texcoord3 = v.texcoord + _MainTex_TexelSize.xy * half2(0,-1);
	o.texcoord4 = v.texcoord;
	return o;
}

half4 frag_bloomThreshold (v2f_bloomThreshold IN) : COLOR
{	 				
	//half4 color0 = tex2D(_MainTex,IN.texcoord0);	
	//half4 color1 = tex2D(_MainTex,IN.texcoord1);
	//half4 color2 = tex2D(_MainTex,IN.texcoord2);
	//half4 color3 = tex2D(_MainTex,IN.texcoord3);
	half4 color4 = tex2D(_MainTex,IN.texcoord4);

	//half3 color = Median(Median(color0.rgb, color1.rgb, color2.rgb), color3.rgb, color4.rgb);
	
	half3 color = color4.rgb;
			
	half4 bloomCurve = half4(10,0,0,100);
	float intensity = 0;

	bloomCurve = _BloomCurve;

#ifdef SCENE
	color.rgb *= sign(PLAYERTHRESHOLD - color4.a) * 0.5 + 0.5;
#endif 

#ifdef PLAYER
	color.rgb *= sign(color4.a - PLAYERTHRESHOLD) * 0.5 + 0.5;	
#endif   
	
	float br = SafeBrightness(color.rgb);
   	 // Under-threshold part: quadratic curve
	float rq = clamp(br - bloomCurve.x, 0, bloomCurve.y);
    rq = bloomCurve.z * rq * rq;

   	// Combine and apply the brightness response curve.
  	float a = max(rq, br - bloomCurve.w) / max(br, 1e-5);		

	a = max(a,0.0000001);
	a = min(a,65000);

	color.rgb = clamp(color.rgb,0,100);
	
	return half4(color.rgb * a ,1);
}

half4 frag_bloomUpSample (v2f IN) : COLOR
{	
	half4 color = tex2D(_MainTex, IN.texcoord0);
	
    float4 d = _BloomBlurTex_TexelSize.xyxy * float4(1, 1, -1, 0) * _BloomScale;

    half4 s;
    s  = tex2D(_BloomBlurTex, IN.texcoord1 - d.xy);
    s += tex2D(_BloomBlurTex, IN.texcoord1 - d.wy) * 2;
    s += tex2D(_BloomBlurTex, IN.texcoord1 - d.zy);

    s += tex2D(_BloomBlurTex, IN.texcoord1 + d.zw) * 2;
    s += tex2D(_BloomBlurTex, IN.texcoord1       ) * 4;
    s += tex2D(_BloomBlurTex, IN.texcoord1 + d.xw) * 2;

    s += tex2D(_BloomBlurTex, IN.texcoord1 + d.zy);
    s += tex2D(_BloomBlurTex, IN.texcoord1 + d.wy) * 2;
    s += tex2D(_BloomBlurTex, IN.texcoord1 + d.xy);

	color.rgb += s.rgb * (1.0 / 16);
	return color;
}	

half4 frag_bloomWithColorGrading (v2f IN) : COLOR
{	
	half4 color = tex2D(_MainTex, IN.texcoord0);	
	
	half num = dot(color.rgb,half3(1,1,1));
	
	UNITY_BRANCH
	if(num > 0.01)
	{
		color.rgb *= _PlayerAdaptedLum;
		color.rgb *= _PlayerBloomIntensity;
		float3 playerLutSpace = saturate(LUT_SPACE_ENCODE(color.rgb));
		color.rgb = ApplyLut2D(_PlayerLutTex, playerLutSpace,_LutParams.xyz);
	}
	
	return color;
}	

