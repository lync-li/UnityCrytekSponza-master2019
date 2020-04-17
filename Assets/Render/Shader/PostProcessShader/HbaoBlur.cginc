#ifndef HBAO_BLUR_INCLUDED
#define HBAO_BLUR_INCLUDED

static const half4 GaussWeight[7] =
	{
		half4(0.0205,0.0205,0.0205,0),
		half4(0.0855,0.0855,0.0855,0),
		half4(0.232,0.232,0.232,0),
		half4(0.324,0.324,0.324,1),
		half4(0.232,0.232,0.232,0),
		half4(0.0855,0.0855,0.0855,0),
		half4(0.0205,0.0205,0.0205,0)
	};
	
float2 _AoBlurOffset;


half4 frag_blurX (v2f i) : SV_Target {
		
		half2 uv = i.uv.xy;
 
		half2 OffsetWidth = float2(_AoBlurOffset.x  ,0);
		half2 uv_withOffset = uv - OffsetWidth * 3 ;
 
		half4 color = 0;
		for (int j = 0; j< 7; j++)
		{
			half4 texCol = tex2D(_MainTex, uv_withOffset);
			color += texCol * GaussWeight[j];
			uv_withOffset += OffsetWidth;
		}
 
		return color;
	}

half4 frag_blurY (v2f i) : SV_Target {
	
		half2 uv = i.uv.xy; 
		half2 OffsetWidth = float2(0,_AoBlurOffset.y );
		half2 uv_withOffset = uv - OffsetWidth * 3  ;
 
		half4 color = 0;
		for (int j = 0; j< 7; j++)
		{
			half4 texCol = tex2D(_MainTex, uv_withOffset);
			color += texCol * GaussWeight[j];
			uv_withOffset += OffsetWidth;
		}
 
		return color;
	}
	
	
struct appdata {
    float4 vertex : POSITION;
	float2 texcoord : TEXCOORD0;
};

struct v2fCross {
	float4 pos : SV_POSITION;
	float2 uv: TEXCOORD0;
	float2 uv1: TEXCOORD1;
	float2 uv2: TEXCOORD2;
	float2 uv3: TEXCOORD3;
	float2 uv4: TEXCOORD4;
};

v2fCross vertBlurH(appdata v) {
    v2fCross o;
    o.pos = UnityObjectToClipPos(v.vertex);
    o.uv = v.texcoord.xy;
		
	float2 inc = half2(_MainTex_TexelSize.x * 1.3846153846, 0);			
    o.uv1 = v.texcoord.xy - inc;	
    o.uv2 = v.texcoord.xy + inc;
		
	float2 inc2 = half2(_MainTex_TexelSize.x * 3.2307692308, 0);	
	o.uv3 = v.texcoord.xy - inc2;
    o.uv4 = v.texcoord.xy + inc2;
	return o;
}	
	
v2fCross vertBlurV(appdata v) {
    v2fCross o;
    o.pos = UnityObjectToClipPos(v.vertex);
    o.uv  = v.texcoord.xy;
	float2 inc = half2(0, _MainTex_TexelSize.y * 1.3846153846);	
    o.uv1 = v.texcoord.xy - inc;	
    o.uv2 = v.texcoord.xy + inc;	
    float2 inc2 = half2(0, _MainTex_TexelSize.y * 3.2307692308);	
    o.uv3 = v.texcoord.xy - inc2;
    o.uv4 = v.texcoord.xy + inc2;
    return o;
}

half4 fragBlur (v2fCross i): SV_Target {
	half4 color = tex2D(_MainTex, i.uv) * 0.2270270270;
	color += tex2D(_MainTex, i.uv1) * 0.3162162162;
	color += tex2D(_MainTex, i.uv2) * 0.3162162162;
	color += tex2D(_MainTex, i.uv3) * 0.0702702703;
	color += tex2D(_MainTex, i.uv4) * 0.0702702703;
	return  color;
}
	

#endif // HBAO_INCLUDED
