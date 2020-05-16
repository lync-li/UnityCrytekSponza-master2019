#ifndef POSTPROCESS_COMMON_HAPPYELEMENTS_INCLUDED
#define POSTPROCESS_COMMON_HAPPYELEMENTS_INCLUDED

#define PLAYERVALUE 200
#define PLAYERTHRESHOLD 20

sampler2D	_MainTex;
float4		_MainTex_ST;
float4 		_MainTex_TexelSize;

sampler2D 	_AlphaTex;
float4 		_AlphaTex_TexelSize;

sampler2D 	_DistortionTex;
half4 		_DistortionFactor;

sampler2D 	_CameraDepthNormalsTexture; 
sampler2D_float _CameraDepthTexture;
float4 		_CameraDepthTexture_TexelSize;

sampler2D 	_NormalBufferTex; 
sampler2D 	_SpecBufferTex; 

half4 		_BloomCurve;
half 		_BloomIntensity;
half 		_AlphaBloomIntensity;
half4 		_PlayerBloomCurve;
half 		_PlayerBloomIntensity;

sampler2D 	_BloomBlurTex;
half4 		_BloomBlurTex_TexelSize;
sampler2D 	_BloomTex;
sampler2D 	_PlayerBloomTex;
sampler2D 	_AlphaBloomTex;
half 		_BloomScale;

sampler2D 	_DepthOfFieldTex;
sampler2D 	_CoCTex;
float4 		_DepthOfFieldParams;

sampler2D 	_HBAOTex;
half 		_AOIntensity;
half4 		_AOColor;

sampler2D   _CloudShadowTex;
half4       _CloudShadowParams;
float4      _UVToView;
half4       _CloudShadowColor;

sampler2D 	_LumaTex;

half 		_ChromaAmount;
half4 		_ColorOffset;

sampler2D 	_OverlayTex;
half4 		_OverlayColor;

half4  		_VignetteColor;
half4 		_VignetteParam;

half4  		_BorderColor;
half4 		_BorderParam;
half4 		_BorderTile;
sampler2D 	_BorderTex;
sampler2D 	_BorderMask;

sampler2D 	_AirDistortionTex;
half4 		_AirDistortionParam;

sampler2D 	_SceneLutTex;
sampler2D 	_PlayerLutTex;
sampler2D 	_AlphaLutTex;
half4 		_LutParams;
half 		_AdaptedLum;
half 		_AlphaAdaptedLum;
half 		_PlayerAdaptedLum;

float4x4 _ClipToWorld;

struct appdata_t
{
	float4 vertex : POSITION;		
	float2 texcoord : TEXCOORD0;
};

struct v2f
{
	float4 pos : SV_POSITION;		
	half2 texcoord0 : TEXCOORD0;	
	half2 texcoord1	: TEXCOORD1;		
};
			
v2f vert (appdata_t v)
{
	v2f o = (v2f)0;	
	o.pos = UnityObjectToClipPos(v.vertex);		
	o.texcoord0 = v.texcoord;	
#if UNITY_UV_STARTS_AT_TOP
	if (_MainTex_TexelSize.y < 0)
        v.texcoord.y = 1 - v.texcoord.y;
#endif	
	o.texcoord1 = v.texcoord;			
	return o;
}

// Vertex manipulation
float2 TransformTriangleVertexToUV(float2 vertex)
{
	float2 uv = (vertex + 1.0) * 0.5;
	return uv;
}

struct AttributesDefault
{
	float3 vertex : POSITION;
};

struct VaryingsDefault
{
    float4 vertex : SV_POSITION;
    float2 texcoord : TEXCOORD0;
#if WORLDPOS
	float3 cameraToFarPlane : TEXCOORD1;
#endif 
};


VaryingsDefault VertDefault(AttributesDefault v)
{
    VaryingsDefault o = (VaryingsDefault)0;
    o.vertex = float4(v.vertex.xy, 0.0, 1.0);
    o.texcoord = TransformTriangleVertexToUV(v.vertex.xy);

#if UNITY_UV_STARTS_AT_TOP
    o.texcoord = o.texcoord * float2(1.0, -1.0) + float2(0.0, 1.0);
#endif

#if WORLDPOS	
	// Clip space X and Y coords
    float2 clipXY = o.vertex.xy / o.vertex.w;
               
    // Position of the far plane in clip space
    float4 farPlaneClip = float4(clipXY, 1.0, 1.0);
               
    // Homogeneous world position on the far plane
    farPlaneClip.y *= _ProjectionParams.x;	

    float4 farPlaneWorld4 = mul(_ClipToWorld, farPlaneClip);
               
    // World position on the far plane
    float3 farPlaneWorld = farPlaneWorld4.xyz / farPlaneWorld4.w;
               
    // Vector from the camera to the far plane
    o.cameraToFarPlane = farPlaneWorld - _WorldSpaceCameraPos;	
#endif
	
    return o;
}

half3 DecodeNormal (half2 enc)
{
    half2 fenc = enc*4-2;
    half f = dot(fenc,fenc);
    half g = sqrt(1-f/4);
    half3 n;
    n.xy = fenc*g;
    n.z = 1-f/2;
    return n;
}

#endif


