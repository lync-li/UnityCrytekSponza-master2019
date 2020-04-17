#include "PostProcessCommon.cginc"

struct v2f_downSample
{
	float4 pos : POSITION;		
	half2 texcoord0 : TEXCOORD0;	
	half2 texcoord1 : TEXCOORD1;	
	half2 texcoord2	: TEXCOORD2;	
	half2 texcoord3	: TEXCOORD3;
	half2 texcoord4	: TEXCOORD4;		
};

v2f_downSample vert_downSample (appdata_t v)
{
	v2f_downSample o = (v2f_downSample)0;	
	o.pos = UnityObjectToClipPos(v.vertex);		
	o.texcoord0 = v.texcoord + _MainTex_TexelSize.xy * half2(1,1);
	o.texcoord1 = v.texcoord + _MainTex_TexelSize.xy * half2(1,-1);
	o.texcoord2 = v.texcoord + _MainTex_TexelSize.xy * half2(-1,1);
	o.texcoord3 = v.texcoord + _MainTex_TexelSize.xy * half2(-1,-1);	
#ifdef HASBLOOM
	o.texcoord4 = v.texcoord;
	#if UNITY_UV_STARTS_AT_TOP
	if (_MainTex_TexelSize.y < 0)
        o.texcoord4.y = 1 - o.texcoord4.y;
	#endif	
#endif
	return o;
}

half4 frag_downSample (v2f_downSample IN) : COLOR
{	 				
	half4 color = tex2D(_MainTex,IN.texcoord0);
	color += tex2D(_MainTex,IN.texcoord1);
	color += tex2D(_MainTex,IN.texcoord2);
	color += tex2D(_MainTex,IN.texcoord3);
	color *= 1.0 / 4;
#ifdef HASBLOOM
	half3 bloomColor = tex2D(_BloomTex,IN.texcoord4);	
	color.rgb += bloomColor.rgb;// * _BloomIntensity;
#endif

	return color;
}
