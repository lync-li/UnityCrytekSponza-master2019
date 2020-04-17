// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)

#ifndef EXTEND_STANDARD_DISTORTION_INCLUDED
#define EXTEND_STANDARD_DISTORTION_INCLUDED

#include "UnityPBSLighting.cginc"

// Vertex shader input
struct appdata_particles
{
    float4 vertex : POSITION;
    float3 normal : NORMAL;
    fixed4 color : COLOR;
    float2 texcoords : TEXCOORD0;
    #if defined(_NORMALMAP)
    float4 tangent : TANGENT;
    #endif
};

// Non-surface shader v2f structure
struct VertexOutput
{
    float4 vertex : SV_POSITION;
    float4 color : COLOR;
    float2 texcoord : TEXCOORD1;  
    float4 projectedPosition : TEXCOORD2;  
};

fixed4 readTexture(sampler2D tex, VertexOutput IN)
{
    fixed4 color = tex2D (tex, IN.texcoord);
    return color;
}

sampler2D _MainTex;
float4 _MainTex_ST;
half4 _Color;
sampler2D _BumpMap;
half _BumpScale;
UNITY_DECLARE_DEPTH_TEXTURE(_CameraDepthTexture);
half _Cutoff;

half _DistortionStrengthScaled;

void vertParticleUnlit (appdata_particles v, out VertexOutput o)
{
    float4 clipPosition = UnityObjectToClipPos(v.vertex);
    o.vertex = clipPosition;
    o.color = v.color; 
	o.texcoord = TRANSFORM_TEX(v.texcoords.xy, _MainTex);
    o.projectedPosition = ComputeScreenPos (clipPosition); 
    COMPUTE_EYEDEPTH(o.projectedPosition.z);

}

half4 fragParticleUnlit (VertexOutput IN) : SV_Target
{
    half4 albedo = readTexture (_MainTex, IN);
    albedo *= _Color;
    albedo *= IN.color;
	
	float sceneZ = LinearEyeDepth (SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(IN.projectedPosition))); 
	clip(sceneZ - IN.projectedPosition.z);   

    #if defined(_NORMALMAP)
    float3 normal = normalize (UnpackScaleNormal (readTexture (_BumpMap, IN), _BumpScale));
    #else
    float3 normal = float3(0,0,1);
    #endif
    
	normal = normal * 0.5 + 0.5;
	normal.z = _DistortionStrengthScaled * 0.1;
    half4 result = half4(normal,albedo.a); 

    return result;
}

#endif // UNITY_STANDARD_PARTICLES_INCLUDED
