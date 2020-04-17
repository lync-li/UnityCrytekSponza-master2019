#ifndef LUMAOCCLUSION_INCLUDED
#define LUMAOCCLUSION_INCLUDED
		
#include "UnityCG.cginc"

sampler2D _MainTex;
sampler2D _BlurTex;
float4    _MainTex_TexelSize;
float4    _MainTex_ST;

float 	_LoRadius;
float 	_LoThreshold;
float 	_LoIntensity;
float4 	_LumaParams;

struct appdata {
    float4 vertex : POSITION;
	float2 texcoord : TEXCOORD0;
};
    
struct v2f {
	float4 pos : SV_POSITION;
	float2 uv: TEXCOORD0;
};


v2f vert(appdata v) {
    v2f o;
    o.pos = UnityObjectToClipPos(v.vertex);
   	o.uv = v.texcoord.xy;
    return o;
}
		
		
static const float2 Random[20] = {
	float2(0.07779833, 0.2529951),
    float2(-0.1778869f, -0.05900348),
    float2(0.8558092, 0.2799575),
	float2(0.4166129, 0.8863604f),
	float2(0.3985788, -0.03791248),
	float2(-0.44102, 0.2654153),
	float2(-0.4586931, 0.7403293),
	float2(0.1117442, -0.5198008),
	float2(-0.8176585, 0.1296148),
	float2(-0.7903557, -0.2716176),
	float2(-0.4248519, -0.4493517),
	float2(0.8380554, -0.3609802),
	float2(0.4613214, 0.409142),
	float2(0.553355, -0.7046115),
	float2(-0.1786912f, -0.8461482),	
	float2(0.07779833, 0.2529951),
	float2(-0.1778869f, -0.05900348),
	float2(0.8558092, 0.2799575),
	float2(0.4166129, 0.8863604f),
	float2(0.3985788, -0.03791248),	
};

inline float getSaturation(float3 rgb) {
	//float ma = max(rgb.r, max(rgb.g, rgb.b)); // ignoring green channel produces similar results
	//float mi = min(rgb.r, min(rgb.g, rgb.b));
	float ma = max(rgb.r, rgb.b);
	float mi = min(rgb.r, rgb.b);
	return ma - mi;
}

inline half getLuma(half3 rgb) {
	const half3 lum = half3(0.2126729, 0.7151522, 0.0721750);
	return dot(rgb, lum);
}	

half4 frag (v2f i) : SV_Target {

   	half4 color  = tex2D(_MainTex, i.uv);
   	float  satM  = getSaturation(color.rgb);
   	float4 occlusion  = 0.0;
	float2 amp          = _LoRadius.xx * _MainTex_TexelSize.xy;
	int rindex        = floor(frac(sin(dot(i.uv, float2(12.9898, 78.233))) * 43758.5453) * (16.0 - SAMPLE));

	UNITY_UNROLL
	for(int k=0; k<SAMPLE; k++) {
	    float2 offset   = Random[rindex++];
	    #ifdef DIRECTIONAL
	  	offset.xy       = abs(offset.xy) * _LumaParams.xy;
	  	#endif
		float4 occUV    = float4(i.uv + offset * amp, 0, 0);
  	    half3 occRGB   = tex2Dlod(_MainTex, occUV).rgb;
        float  occSat   = getSaturation(occRGB);
		float  occ      = saturate( (occSat - satM - _LoThreshold) / _LoThreshold );
      	occlusion.rgb  += occRGB;
       	occlusion.a    += occ;
	}
    occlusion    = occlusion / float(SAMPLE);
    occlusion.a *= _LoIntensity;

    color = occlusion;

	return color;
}

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

#endif
