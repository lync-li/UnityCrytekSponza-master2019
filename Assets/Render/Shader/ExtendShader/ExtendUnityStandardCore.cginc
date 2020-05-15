// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)

#ifndef EXTEND_UNITY_STANDARD_CORE_INCLUDED
#define EXTEND_UNITY_STANDARD_CORE_INCLUDED

#include "ExtendUnityCG.cginc"
#include "UnityShaderVariables.cginc"
#include "ExtendUnityStandardConfig.cginc"
#include "ExtendUnityStandardInput.cginc"
#include "ExtendUnityGlobalIllumination.cginc"
#include "ExtendUnityStandardUtils.cginc"
#include "UnityGBuffer.cginc"
#include "ExtendUnityStandardBRDF.cginc"

#include "ExtendUnityImageBasedLighting.cginc"
#include "UnityShadowLibrary.cginc"

#include "AutoLight.cginc"
//-------------------------------------------------------------------------------------
// counterpart for NormalizePerPixelNormal
// skips normalization per-vertex and expects normalization to happen per-pixel
half3 NormalizePerVertexNormal (float3 n) // takes float to avoid overflow
{
    #if (SHADER_TARGET < 30) || UNITY_STANDARD_SIMPLE
        return normalize(n);
    #else
        return n; // will normalize per-pixel instead
    #endif
}

float3 NormalizePerPixelNormal (float3 n)
{
    #if (SHADER_TARGET < 30) || UNITY_STANDARD_SIMPLE
        return n;
    #else
        return normalize((float3)n); // takes float to avoid overflow
    #endif
}

//-------------------------------------------------------------------------------------
UnityLight MainLight ()
{
    UnityLight l;

    l.color = _LightColor0.rgb;
    l.dir = _WorldSpaceLightPos0.xyz;
    return l;
}

UnityLight AdditiveLight (half3 lightDir, half atten)
{
    UnityLight l;

    l.color = _LightColor0.rgb;
    l.dir = lightDir;
    #ifndef USING_DIRECTIONAL_LIGHT
        l.dir = NormalizePerPixelNormal(l.dir);
    #endif

    // shadow the light
    l.color *= atten;
    return l;
}

UnityLight DummyLight ()
{
    UnityLight l;
    l.color = 0;
    l.dir = half3 (0,1,0);
    return l;
}

UnityIndirect ZeroIndirect ()
{
    UnityIndirect ind;
    ind.diffuse = 0;
    ind.specular = 0;
    return ind;
}

//-------------------------------------------------------------------------------------
// Common fragment setup

// deprecated
half3 WorldNormal(half4 tan2world[3])
{
    return normalize(tan2world[2].xyz);
}

// deprecated
#ifdef _TANGENT_TO_WORLD
    half3x3 ExtractTangentToWorldPerPixel(half4 tan2world[3])
    {
        half3 t = tan2world[0].xyz;
        half3 b = tan2world[1].xyz;
        half3 n = tan2world[2].xyz;

    #if UNITY_TANGENT_ORTHONORMALIZE
        n = NormalizePerPixelNormal(n);

        // ortho-normalize Tangent
        t = normalize (t - n * dot(t, n));

        // recalculate Binormal
        half3 newB = cross(n, t);
        b = newB * sign (dot (newB, b));
    #endif

        return half3x3(t, b, n);
    }
#else
    half3x3 ExtractTangentToWorldPerPixel(half4 tan2world[3])
    {
        return half3x3(0,0,0,0,0,0,0,0,0);
    }
#endif

float3 PerPixelWorldNormal(float4 i_tex, float4 tangentToWorld[3], out float3 normalWorld_clearcoat)
{
#ifdef _NORMALMAP
    half3 tangent = tangentToWorld[0].xyz;
    half3 binormal = tangentToWorld[1].xyz;
    half3 normal = tangentToWorld[2].xyz;

    #if UNITY_TANGENT_ORTHONORMALIZE
        normal = NormalizePerPixelNormal(normal);

        // ortho-normalize Tangent
        tangent = normalize (tangent - normal * dot(tangent, normal));

        // recalculate Binormal
        half3 newB = cross(normal, tangent);
        binormal = newB * sign (dot (newB, binormal));
    #endif

    half3 normalTangent_flake;

    half3 normalTangent = NormalInTangentSpace(i_tex, /*out*/ normalTangent_flake);
    float3 normalWorld = NormalizePerPixelNormal(tangent * normalTangent.x + binormal * normalTangent.y + normal * normalTangent.z); // @TODO: see if we can squeeze this normalize on SM2.0 as well

    normalWorld_clearcoat = normalWorld;
    #if _FLAKENORMAL
        normalWorld_clearcoat = NormalizePerPixelNormal(tangent * normalTangent_flake.x + binormal * normalTangent_flake.y + normal * normalTangent_flake.z); // @TODO: see if we can squeeze this normalize on SM2.0 as well
    #endif
    
#else
    float3 normalWorld = normalize(tangentToWorld[2].xyz);
    normalWorld_clearcoat = normalWorld;
#endif

    return normalWorld;
}

#ifdef _PARALLAXMAP
    #define IN_VIEWDIR4PARALLAX(i) NormalizePerPixelNormal(half3(i.tangentToWorldAndPackedData[0].w,i.tangentToWorldAndPackedData[1].w,i.tangentToWorldAndPackedData[2].w))
    #define IN_VIEWDIR4PARALLAX_FWDADD(i) NormalizePerPixelNormal(i.viewDirForParallax.xyz)
#else
    #define IN_VIEWDIR4PARALLAX(i) half3(0,0,0)
    #define IN_VIEWDIR4PARALLAX_FWDADD(i) half3(0,0,0)
#endif

#if UNITY_REQUIRE_FRAG_WORLDPOS
    //#if UNITY_PACK_WORLDPOS_WITH_TANGENT
    //    #define IN_WORLDPOS(i) half3(i.tangentToWorldAndPackedData[0].w,i.tangentToWorldAndPackedData[1].w,i.tangentToWorldAndPackedData[2].w)
    //#else
        #define IN_WORLDPOS(i) i.worldPos.xyz
    //#endif
    #define IN_WORLDPOS_FWDADD(i) i.worldPos.xyz
#else
    #define IN_WORLDPOS(i) half3(0,0,0)
    #define IN_WORLDPOS_FWDADD(i) half3(0,0,0)
#endif

#define IN_LIGHTDIR_FWDADD(i) half3(i.tangentToWorldAndLightDir[0].w, i.tangentToWorldAndLightDir[1].w, i.tangentToWorldAndLightDir[2].w)

#define FRAGMENT_SETUP(x) FragmentCommonData x = \
    FragmentSetup(i.tex, eyeVec.xyz, IN_VIEWDIR4PARALLAX(i), i.tangentToWorldAndPackedData, IN_WORLDPOS(i), facing);

#define FRAGMENT_SETUP_FWDADD(x) FragmentCommonData x = \
    FragmentSetup(i.tex, eyeVec.xyz, IN_VIEWDIR4PARALLAX_FWDADD(i), i.tangentToWorldAndLightDir, IN_WORLDPOS_FWDADD(i));

struct FragmentCommonData
{
    half3 diffColor, specColor;
    // Note: smoothness & oneMinusReflectivity for optimization purposes, mostly for DX9 SM2.0 level.
    // Most of the math is being done on these (1-x) values, and that saves a few precious ALU slots.
    half oneMinusReflectivity, smoothness;
    float3 normalWorld, normalWorld_clearcoat;
    float3 tangentWorld;
    float3 eyeVec;
    half alpha;
    float3 posWorld;



#if UNITY_STANDARD_SIMPLE
    half3 reflUVW;
#endif

#if UNITY_STANDARD_SIMPLE
    half3 tangentSpaceNormal;
#endif
};

#ifndef UNITY_SETUP_BRDF_INPUT
    #define UNITY_SETUP_BRDF_INPUT SpecularSetup
#endif

inline FragmentCommonData SpecularSetup (float4 i_tex)
{
    half4 specGloss = SpecularGloss(i_tex.xy);
    half3 specColor = specGloss.rgb;
    half smoothness = specGloss.a;

    half oneMinusReflectivity;
    half3 diffColor = EnergyConservationBetweenDiffuseAndSpecular (Albedo(i_tex), specColor, /*out*/ oneMinusReflectivity);

    FragmentCommonData o = (FragmentCommonData)0;
    o.diffColor = diffColor;
    o.specColor = specColor;
    o.oneMinusReflectivity = oneMinusReflectivity;
    o.smoothness = smoothness;
    return o;
}

inline FragmentCommonData RoughnessSetup(float4 i_tex)
{
    half2 metallicGloss = MetallicRough(i_tex.xy);
    half metallic = metallicGloss.x;
    half smoothness = metallicGloss.y; // this is 1 minus the square root of real roughness m.

    half oneMinusReflectivity;
    half3 specColor;
    half3 diffColor = DiffuseAndSpecularFromMetallic(Albedo(i_tex), metallic, /*out*/ specColor, /*out*/ oneMinusReflectivity);

    FragmentCommonData o = (FragmentCommonData)0;
    o.diffColor = diffColor;
    o.specColor = specColor;
    o.oneMinusReflectivity = oneMinusReflectivity;
    o.smoothness = smoothness;
    return o;
}

inline FragmentCommonData MetallicSetup (float4 i_tex)
{
    half2 metallicGloss = MetallicGloss(i_tex.xy);
    half metallic = metallicGloss.x;
    half smoothness = metallicGloss.y; // this is 1 minus the square root of real roughness m.

    half oneMinusReflectivity;
    half3 specColor;
    half3 diffColor = DiffuseAndSpecularFromMetallic (Albedo(i_tex), metallic, /*out*/ specColor, /*out*/ oneMinusReflectivity);

    FragmentCommonData o = (FragmentCommonData)0;
    o.diffColor = diffColor;
    o.specColor = specColor;
    o.oneMinusReflectivity = oneMinusReflectivity;
    o.smoothness = smoothness;
    return o;
}

inline FragmentCommonData BodyChangeSetup (float4 i_tex)
{	
	half3 diffuse =  tex2D (_MainTex, i_tex.xy).rgb;
	half4 mg = tex2D(_MetallicGlossMap, i_tex.xy);
	
	half3 sheildColor = _cap_sheild_color.rgb * diffuse;
	sheildColor = lerp(diffuse,sheildColor,mg.w);	
	half3 skinColor = _skin_color.rgb * diffuse;	
	half3 albedo = lerp(sheildColor,skinColor,mg.z);	
	
    half metallic = mg.x ;	
	half smoothness = lerp(mg.y * _metal_smoothness,mg.y * _unmetal_smoothness, 1 - mg.x);
	
    half oneMinusReflectivity;
    half3 specColor;
    half3 diffColor = DiffuseAndSpecularFromMetallic (albedo, metallic, /*out*/ specColor, /*out*/ oneMinusReflectivity);

    FragmentCommonData o = (FragmentCommonData)0;
    o.diffColor = diffColor;
    o.specColor = specColor;
    o.oneMinusReflectivity = oneMinusReflectivity;
    o.smoothness = smoothness;
    return o;
}

// parallax transformed texcoord is used to sample occlusion
inline FragmentCommonData FragmentSetup (inout float4 i_tex, float3 eyeVec, half3 i_viewDirForParallax, float4 tangentToWorld[3], float3 i_posWorld, half facing = 1)
{
    i_tex = Parallax(i_tex, i_viewDirForParallax);

    half alpha = Alpha(i_tex.xy);
    #if defined(_ALPHATEST_ON)
        clip (alpha - _Cutoff);
    #endif

    FragmentCommonData o = UNITY_SETUP_BRDF_INPUT (i_tex);
    o.normalWorld = PerPixelWorldNormal(i_tex, tangentToWorld, /*out*/ o.normalWorld_clearcoat);
    o.eyeVec = eyeVec;
    o.posWorld = i_posWorld;

#if _HAIR
    half3 TangentDir = half3(sqrt(1 - _TangentDir * _TangentDir) ,_TangentDir, 0);
    o.tangentWorld = NormalizePerPixelNormal(normalize(tangentToWorld[0].xyz) * TangentDir.x + normalize(tangentToWorld[1].xyz) * TangentDir.y) * facing;
#else
    o.tangentWorld = tangentToWorld[0].xyz;
#endif

    // NOTE: shader relies on pre-multiply alpha-blend (_SrcBlend = One, _DstBlend = OneMinusSrcAlpha)
    o.diffColor = PreMultiplyAlpha (o.diffColor, alpha, o.oneMinusReflectivity, /*out*/ o.alpha);
    return o;
}

inline UnityGI FragmentGI (FragmentCommonData s, half occlusion, half4 i_ambientOrLightmapUV, half atten, UnityLight light, bool reflections)
{
    UnityGIInput d;
    d.light = light;
    d.worldPos = s.posWorld;
    d.worldViewDir = -s.eyeVec;
    d.atten = atten;
    #if defined(LIGHTMAP_ON) || defined(DYNAMICLIGHTMAP_ON)
        d.ambient = 0;
        d.lightmapUV = i_ambientOrLightmapUV;
    #else
        d.ambient = i_ambientOrLightmapUV.rgb;
        d.lightmapUV = 0;
    #endif

    d.probeHDR[0] = unity_SpecCube0_HDR;
    d.probeHDR[1] = unity_SpecCube1_HDR;
    #if defined(UNITY_SPECCUBE_BLENDING) || defined(UNITY_SPECCUBE_BOX_PROJECTION)
      d.boxMin[0] = unity_SpecCube0_BoxMin; // .w holds lerp value for blending
    #endif
    #ifdef UNITY_SPECCUBE_BOX_PROJECTION
      d.boxMax[0] = unity_SpecCube0_BoxMax;
      d.probePosition[0] = unity_SpecCube0_ProbePosition;
      d.boxMax[1] = unity_SpecCube1_BoxMax;
      d.boxMin[1] = unity_SpecCube1_BoxMin;
      d.probePosition[1] = unity_SpecCube1_ProbePosition;
    #endif

    if(reflections)
    {
        Unity_GlossyEnvironmentData g = UnityGlossyEnvironmentSetup(s.smoothness, -s.eyeVec, s.normalWorld, s.specColor);
        // Replace the reflUVW if it has been compute in Vertex shader. Note: the compiler will optimize the calcul in UnityGlossyEnvironmentSetup itself
        #if UNITY_STANDARD_SIMPLE
            g.reflUVW = s.reflUVW;
        #endif

        return UnityGlobalIllumination (d, occlusion, s.normalWorld, g);
    }
    else
    {
        return UnityGlobalIllumination (d, occlusion, s.normalWorld);
    }
}

inline UnityGI FragmentGI (FragmentCommonData s, half occlusion, half4 i_ambientOrLightmapUV, half atten, UnityLight light)
{
    return FragmentGI(s, occlusion, i_ambientOrLightmapUV, atten, light, true);
}


//-------------------------------------------------------------------------------------
half4 OutputForward (half4 output, half alphaFromSurface)
{
    #if defined(_ALPHABLEND_ON) || defined(_ALPHAPREMULTIPLY_ON)
        output.a = alphaFromSurface;
    #else
        UNITY_OPAQUE_ALPHA(output.a);
    #endif
    return output;
}

inline half4 VertexGIForward(VertexInput v, float3 posWorld, half3 normalWorld)
{
    half4 ambientOrLightmapUV = 0;
    // Static lightmaps
    #ifdef LIGHTMAP_ON
        ambientOrLightmapUV.xy = v.uv1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
        ambientOrLightmapUV.zw = 0;
    // Sample light probe for Dynamic objects only (no static or dynamic lightmaps)
    #elif UNITY_SHOULD_SAMPLE_SH
        #ifdef VERTEXLIGHT_ON
            // Approximated illumination from non-important point lights
            ambientOrLightmapUV.rgb = Shade4PointLights (
                unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
                unity_LightColor[0].rgb, unity_LightColor[1].rgb, unity_LightColor[2].rgb, unity_LightColor[3].rgb,
                unity_4LightAtten0, posWorld, normalWorld);
        #endif

        ambientOrLightmapUV.rgb = ShadeSHPerVertex (normalWorld, ambientOrLightmapUV.rgb);
    #endif

    #ifdef DYNAMICLIGHTMAP_ON
        ambientOrLightmapUV.zw = v.uv2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
    #endif

    return ambientOrLightmapUV;
}

// ------------------------------------------------------------------
//  Base forward pass (directional light, emission, lightmaps, ...)

struct VertexOutputForwardBase
{
    UNITY_POSITION(pos);
    float4 tex                            : TEXCOORD0;
    float4 worldPos                       : TEXCOORD1;    // worldPos.xyz | fogCoord
    float4 tangentToWorldAndPackedData[3] : TEXCOORD2;    // [3x3:tangentToWorld | 1x3:viewDirForParallax or worldPos]
    half4 ambientOrLightmapUV             : TEXCOORD5;    // SH or Lightmap UV ,w = vertexAlpha 
    UNITY_LIGHTING_COORDS(6,7)
    // next ones would not fit into SM2.0 limits, but they are always for SM3.0+
#if _ALPHABUFFER && _EXTENDALPHA
	float4 projPos 						  : TEXCOORD8;
#endif

#if _HEIGHTFOG
	half4 heightFog 	                  : TEXCOORD9;
#endif	

    UNITY_VERTEX_INPUT_INSTANCE_ID
    UNITY_VERTEX_OUTPUT_STEREO
};


UNITY_INSTANCING_BUFFER_START(Props)
	#if _GPUANIM
	UNITY_DEFINE_INSTANCED_PROP(float4, _StartEndFrame)
	UNITY_DEFINE_INSTANCED_PROP(float4, _AnimParam0)
	UNITY_DEFINE_INSTANCED_PROP(float4, _AnimParam1)
	#endif
	#if _GPURIM
	UNITY_DEFINE_INSTANCED_PROP(float4, _rim_color)
	UNITY_DEFINE_INSTANCED_PROP(float, _rim_range)
	UNITY_DEFINE_INSTANCED_PROP(float, _rim_power)
	#endif
UNITY_INSTANCING_BUFFER_END(Props)

#if _GPUANIM
struct animData
{
	half4 vertex;
	half4 normal;
#ifdef _TANGENT_TO_WORLD
	half4 tangent;
#endif
};
animData GetBlendAnimPos(VertexInput v) {
	animData data = (animData)0;
	float4 startEndFrame = UNITY_ACCESS_INSTANCED_PROP(Props, _StartEndFrame);
	float4 animParam0 = UNITY_ACCESS_INSTANCED_PROP(Props, _AnimParam0);
	float4 animParam1 = UNITY_ACCESS_INSTANCED_PROP(Props, _AnimParam1);

	float y = GetY(startEndFrame.x, startEndFrame.y, animParam0);

	float x = (v.vertexId + 0.5) * _AnimPosTex_TexelSize.x;

	half4 nextPos = tex2Dlod(_AnimPosTex, half4(x, y, 0, 0));
	half4 nextNormal = tex2Dlod(_AnimNormalTex, half4(x, y, 0, 0));
#ifdef _TANGENT_TO_WORLD
	half4 nextTangent = tex2Dlod(_AnimTangentTex, half4(x, y, 0, 0));
	half4 curTangent = 0;
#endif
	float crossLerp = saturate((_Time.y - animParam0.x) * animParam1.w);

	half4 curPos = 0;
	half4 curNormal = 0;
	if (crossLerp < 0.99)
	{
		animParam1.w = animParam0.w;
		y = GetY(startEndFrame.z, startEndFrame.w, animParam1);
		curPos = tex2Dlod(_AnimPosTex, half4(x, y, 0, 0));
		curNormal = tex2Dlod(_AnimNormalTex, half4(x, y, 0, 0));
#ifdef _TANGENT_TO_WORLD
		curTangent = tex2Dlod(_AnimTangentTex, half4(x, y, 0, 0));
#endif
	}
	data.vertex = lerp(curPos, nextPos, crossLerp);
	data.normal = lerp(curNormal, nextNormal, crossLerp)* 2 - 1;	
#ifdef _TANGENT_TO_WORLD
	data.tangent = lerp(curTangent, nextTangent, crossLerp)* 2 - 1;
#endif	
	return data;
}
#endif

struct FragmentOutput
{
    half4 dest0 : SV_Target0;
    half4 dest1 : SV_Target1;
	half4 dest2 : SV_Target2;
};

float3 waveCalc(float3 worldPos)
{	
	UNITY_BRANCH
	if(_HeightFogWave1.w >0)
	{

        float timeX = _Time.x * 20 * -_HeightFogWave0.x;
        float timeZ = _Time.x * 20 * -_HeightFogWave0.y;
        float waveValueX = sin(timeX + worldPos.x * _HeightFogWave0.z) * _HeightFogWave1.x;
        float waveValueZ = sin(timeZ + worldPos.z * _HeightFogWave0.w) * _HeightFogWave1.y;
        float waveValue = (waveValueX + waveValueZ) / 2;
		worldPos.y += waveValue;     
	}
    return worldPos;
}

half4 HeightFogTransfer(float3 worldPos)
{
	half3 wPos = waveCalc(worldPos);
	float lerpValue = saturate((wPos.y  - _HeightFogParam.x) / _HeightFogParam.y);
	lerpValue = 1 - pow(lerpValue, _HeightFogParam.z);
    float3 emission = _HeightFogColor.rgb + _HeightFogEmissionColor.rgb * 2;
    float3 fogEmissionColor = lerp(_HeightFogColor, emission, pow(lerpValue, _HeightFogParam.w));
	
	return half4(fogEmissionColor,lerpValue);
}

VertexOutputForwardBase vertForwardBase(VertexInput v)
{
    UNITY_SETUP_INSTANCE_ID(v);
    VertexOutputForwardBase o;
    UNITY_INITIALIZE_OUTPUT(VertexOutputForwardBase, o);

    UNITY_TRANSFER_INSTANCE_ID(v, o);
    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
#if _GPUANIM
	animData data = GetBlendAnimPos(v);
	v.vertex.xyz = data.vertex.xyz;
	v.normal = data.normal.xyz;
	
	#ifdef _TANGENT_TO_WORLD
	v.tangent.xyz = data.tangent.xyz;	
	#endif
#endif
#if _FUR
    half3 direction = lerp(v.normal, _Gravity * _GravityStrength + v.normal * (1 - _GravityStrength), FUR_OFFSET);
	v.vertex.xyz += direction * _FurLength * FUR_OFFSET;
#endif 

    float4 posWorld = mul(unity_ObjectToWorld, v.vertex);
	
#if _Grass
	float angle = frac(_Time.y * _MoveRate) + posWorld.x * posWorld.y * _MoveRandom;
	float move = SmoothTriangleWave(angle) * _MoveRange * v.vertex.y * 0.1;
	v.vertex.xz += move;
	posWorld = mul(unity_ObjectToWorld, v.vertex);
#endif

    o.worldPos.xyz = posWorld.xyz;
	
    o.pos = UnityObjectToClipPos(v.vertex);

    o.tex = TexCoords(v);
   // o.eyeVec.xyz = NormalizePerVertexNormal(posWorld.xyz - _WorldSpaceCameraPos);
    float3 normalWorld = UnityObjectToWorldNormal(v.normal);
    #ifdef _TANGENT_TO_WORLD
        float4 tangentWorld = float4(UnityObjectToWorldDir(v.tangent.xyz), v.tangent.w);

        float3x3 tangentToWorld = CreateTangentToWorldPerVertex(normalWorld, tangentWorld.xyz, tangentWorld.w);
        o.tangentToWorldAndPackedData[0].xyz = tangentToWorld[0];
        o.tangentToWorldAndPackedData[1].xyz = tangentToWorld[1];
        o.tangentToWorldAndPackedData[2].xyz = tangentToWorld[2];
    #else
        o.tangentToWorldAndPackedData[0].xyz = 0;
        o.tangentToWorldAndPackedData[1].xyz = 0;
        o.tangentToWorldAndPackedData[2].xyz = normalWorld;
    #endif
	
    //We need this for shadow receving
    UNITY_TRANSFER_LIGHTING(o, v.uv1);

    o.ambientOrLightmapUV = VertexGIForward(v, posWorld, normalWorld);

    #ifdef _PARALLAXMAP
        TANGENT_SPACE_ROTATION;
        half3 viewDirForParallax = mul (rotation, ObjSpaceViewDir(v.vertex));
        o.tangentToWorldAndPackedData[0].w = viewDirForParallax.x;
        o.tangentToWorldAndPackedData[1].w = viewDirForParallax.y;
        o.tangentToWorldAndPackedData[2].w = viewDirForParallax.z;
    #endif
	
#if _VERTEXALPHA
	if(v.color.r < 0.9)
		o.ambientOrLightmapUV.a = v.color.r * _VertexColorAlpha;
	else
		o.ambientOrLightmapUV.a = 1;
#endif

#if _ALPHABUFFER && _EXTENDALPHA
    o.projPos = ComputeScreenPos (o.pos);
    COMPUTE_EYEDEPTH(o.projPos.z);
#endif

#ifdef _RECEIVEFOG
    UNITY_TRANSFER_FOG_COMBINED_WITH_WORLD_POS(o,o.pos);
#endif 

#if _HEIGHTFOG
	//o.heightFog = HeightFogTransfer(posWorld.xyz);
#endif
    return o;
}

#if _MRT
FragmentOutput fragForwardBaseInternal (VertexOutputForwardBase i)
#else
half4 fragForwardBaseInternal (VertexOutputForwardBase i)
#endif
{
    UNITY_APPLY_DITHER_CROSSFADE(i.pos.xy);

#if _ALPHABUFFER && _EXTENDALPHA   
	float sceneZ = LinearEyeDepth (SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture,UNITY_PROJ_COORD(i.projPos)));
	clip(sceneZ - i.projPos.z);	
#endif	

	float3 eyeVec = normalize(i.worldPos.xyz - _WorldSpaceCameraPos.xyz); 
	
    half facing = dot(-eyeVec, i.tangentToWorldAndPackedData[2].xyz);
    facing = saturate(ceil(facing)) * 2 - 1;

    FRAGMENT_SETUP(s)

    UNITY_SETUP_INSTANCE_ID(i);
    UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);

    UnityLight mainLight = MainLight ();
    UNITY_LIGHT_ATTENUATION(atten, i, s.posWorld);

    half occlusion = Occlusion(i.tex.xy);

    UnityGI gi = FragmentGI (s, occlusion, i.ambientOrLightmapUV, atten, mainLight);

#if _FUR
    half alpha = tex2D(_LayerTex, TRANSFORM_TEX(i.tex.xy, _LayerTex)).r;
    alpha = step(lerp(_CutoffStart, _CutoffEnd, FUR_OFFSET), alpha);

    half a2 = 1 - FUR_OFFSET*FUR_OFFSET;
    a2 += dot(-s.eyeVec, s.normalWorld) - _EdgeFade;
    a2 = max(0, a2);
    a2 *= alpha;

#endif

#if _SKIN
    half4 sssTex =  tex2D(_SSSTex, TRANSFORM_TEX(i.tex.xy, _SSSTex));
    half4 c = SKIN_BRDF_PBS(s.diffColor, s.specColor, s.oneMinusReflectivity, s.smoothness, s.normalWorld, -s.eyeVec, gi.light, gi.indirect, sssTex);
#elif _HAIR
    half4 anisoMap = tex2D(_AnisoMap, TRANSFORM_TEX(i.tex.xy, _AnisoMap));
    anisoMap.r *= _Adjust.r * 2;
    anisoMap.g = _Adjust.a;
    half4 c = HAIR_BRDF_PBS(s.diffColor, s.specColor, s.oneMinusReflectivity, s.smoothness, s.normalWorld, -s.eyeVec, gi.light, gi.indirect, s.tangentWorld, anisoMap.rg);
#elif _CLEARCOAT
    FragmentCommonData s_clearcoat = (FragmentCommonData) 0;
    s_clearcoat.specColor = _ReflectionSpecular.rgb;
    s_clearcoat.smoothness = _ReflectionGlossiness;
    s_clearcoat.normalWorld = s.normalWorld_clearcoat;
    s_clearcoat.eyeVec = s.eyeVec;
    s_clearcoat.posWorld = s.posWorld;
    UnityGI gi_clearcoat = FragmentGI(s_clearcoat, occlusion, i.ambientOrLightmapUV, atten, mainLight);

    half4 c = CLEARCOAT_BRDF_PBS(s.diffColor, s.specColor, s.oneMinusReflectivity, s.smoothness, s.normalWorld, -s.eyeVec, gi.light, gi.indirect, s.normalWorld_clearcoat, gi_clearcoat.indirect);
#elif _FABRIC
    half4 c = FABRIC_BRDF_PBS(s.diffColor, s.specColor, s.oneMinusReflectivity, s.smoothness, s.normalWorld, -s.eyeVec, gi.light, gi.indirect);
#else
    half4 c = BRDF1_Unity_PBS(s.diffColor, s.specColor, s.oneMinusReflectivity, s.smoothness, s.normalWorld, -s.eyeVec, gi.light, gi.indirect);
#endif    

#if _MRT
	//c.rgb = s.eyeVec;
#else	
	
	UnityGIInput dd;
    dd.worldPos = i.worldPos.xyz;
    dd.worldViewDir = eyeVec;
    dd.probeHDR[0] = unity_SpecCube0_HDR;
    dd.boxMin[0].w = 1; // 1 in .w allow to disable blending in UnityGI_IndirectSpecular call since it doesn't work in Deferred

    //float blendDistance = unity_SpecCube1_ProbePosition.w; // will be set to blend distance for this probe
    #ifdef UNITY_SPECCUBE_BOX_PROJECTION
   // d.probePosition[0]  = unity_SpecCube0_ProbePosition;
    //d.boxMin[0].xyz     = unity_SpecCube0_BoxMin - float4(blendDistance,blendDistance,blendDistance,0);
    //d.boxMax[0].xyz     = unity_SpecCube0_BoxMax + float4(blendDistance,blendDistance,blendDistance,0);
    #endif


    //g.roughness /* perceptualRoughness */   = SmoothnessToPerceptualRoughness(Smoothness);
    float3 reflUVW   = reflect(eyeVec, s.normalWorld);
	
	//Unity_GlossyEnvironment (UNITY_PASS_TEXCUBE(unity_SpecCube0), data.probeHDR[0], glossIn);
	half roughness = 1 - s.smoothness;
	half perceptualRoughness = roughness*(1.7 - 0.7*roughness);
	half4 rgbm = UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, s.normalWorld, perceptualRoughness * 6);
	half3 cubemap = DecodeHDR(rgbm, dd.probeHDR[0]) * occlusion;

	return half4(cubemap,1 );
#endif
	
    c.rgb += Emission(i.tex.xy);

#if _RIMENABLE
    float rim = 1 - max(0, dot(-s.eyeVec, s.normalWorld));
    c.rgb +=  _RimColor * pow(rim, _RimPower);
#endif

#if _BODYCHANGECOLOR
	#if _GPURIM
		float rimRange = UNITY_ACCESS_INSTANCED_PROP(Props, _rim_range);
		half4 rimColor = UNITY_ACCESS_INSTANCED_PROP(Props, _rim_color);
		float rimPower = UNITY_ACCESS_INSTANCED_PROP(Props, _rim_power);
	#else
		float rimRange = _rim_range;
		half4 rimColor = _rim_color;
		float rimPower = _rim_power;
	#endif 
	half dotNV2 = max(0, dot(s.normalWorld, -s.eyeVec));	
	c.rgb += rimRange * pow(1 - dotNV2,rimPower) * rimColor.rgb;
#endif

#ifdef _RECEIVEFOG
     UNITY_EXTRACT_FOG_FROM_WORLD_POS(i); 	 
     UNITY_APPLY_FOG(_unity_fogCoord, c.rgb);
#endif

#if _HEIGHTFOG
	i.heightFog = HeightFogTransfer(i.worldPos.xyz);
	c.rgb = lerp(c.rgb,i.heightFog.rgb, saturate(i.heightFog.a));
#endif

#if _FUR
  	 c.a = a2;
	return c;
#endif

#if _VERTEXALPHA
	s.alpha *= saturate(i.ambientOrLightmapUV.a);
#endif
	
	half4 color = OutputForward(c, s.alpha);
	
#if _PLAYER
	color.a = 200;
#endif
		
	//color.rgb = s.normalWorld;
	
#if _MRT
	FragmentOutput o;
	o.dest0 = color;
	o.dest1 = half4(s.normalWorld * 0.5 + 0.5,s.smoothness);
	o.dest2 = half4(s.specColor,occlusion);
	return o;
#else
	return color;
#endif
	
    
	//return i.tangentToWorldAndPackedData[1] * 2 - 1;
}

// ------------------------------------------------------------------
//  Additive forward pass (one light per pass)

struct VertexOutputForwardAdd
{
    UNITY_POSITION(pos);
    float4 tex                          : TEXCOORD0;
    float4 worldPos                     : TEXCOORD1;    // worldPos.xyz | fogCoord
    float4 tangentToWorldAndLightDir[3] : TEXCOORD2;    // [3x3:tangentToWorld | 1x3:lightDir]
    //float3 posWorld                     : TEXCOORD5;
    UNITY_LIGHTING_COORDS(6, 7)

    // next ones would not fit into SM2.0 limits, but they are always for SM3.0+
#if defined(_PARALLAXMAP)
    half3 viewDirForParallax            : TEXCOORD8;
#endif
#if _ALPHABUFFER && _EXTENDALPHA
	float4 projPos 						: TEXCOORD8;
#endif

#if _HEIGHTFOG
	half4 heightFog 	                : TEXCOORD9;
#endif

    UNITY_VERTEX_OUTPUT_STEREO
};

VertexOutputForwardAdd vertForwardAdd (VertexInput v)
{
    UNITY_SETUP_INSTANCE_ID(v);
    VertexOutputForwardAdd o;
    UNITY_INITIALIZE_OUTPUT(VertexOutputForwardAdd, o);
    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

    float4 posWorld = mul(unity_ObjectToWorld, v.vertex);
	
#if _Grass
	float angle = frac(_Time.y * _MoveRate) + posWorld.x * posWorld.y * _MoveRandom;
	float move = SmoothTriangleWave(angle) * _MoveRange * v.vertex.y * 0.1;
	v.vertex.xz += move;
	posWorld = mul(unity_ObjectToWorld, v.vertex);
#endif

    o.pos = UnityObjectToClipPos(v.vertex);

    o.tex = TexCoords(v);
    //o.eyeVec.xyz = NormalizePerVertexNormal(posWorld.xyz - _WorldSpaceCameraPos);
    o.worldPos.xyz = posWorld.xyz;
    float3 normalWorld = UnityObjectToWorldNormal(v.normal);
    #ifdef _TANGENT_TO_WORLD
        float4 tangentWorld = float4(UnityObjectToWorldDir(v.tangent.xyz), v.tangent.w);

        float3x3 tangentToWorld = CreateTangentToWorldPerVertex(normalWorld, tangentWorld.xyz, tangentWorld.w);
        o.tangentToWorldAndLightDir[0].xyz = tangentToWorld[0];
        o.tangentToWorldAndLightDir[1].xyz = tangentToWorld[1];
        o.tangentToWorldAndLightDir[2].xyz = tangentToWorld[2];
    #else
        o.tangentToWorldAndLightDir[0].xyz = 0;
        o.tangentToWorldAndLightDir[1].xyz = 0;
        o.tangentToWorldAndLightDir[2].xyz = normalWorld;
    #endif
    //We need this for shadow receiving and lighting
    UNITY_TRANSFER_LIGHTING(o, v.uv1);

    float3 lightDir = _WorldSpaceLightPos0.xyz - posWorld.xyz * _WorldSpaceLightPos0.w;
    #ifndef USING_DIRECTIONAL_LIGHT
        lightDir = NormalizePerVertexNormal(lightDir);
    #endif
    o.tangentToWorldAndLightDir[0].w = lightDir.x;
    o.tangentToWorldAndLightDir[1].w = lightDir.y;
    o.tangentToWorldAndLightDir[2].w = lightDir.z;

    #ifdef _PARALLAXMAP
        TANGENT_SPACE_ROTATION;
        o.viewDirForParallax = mul (rotation, ObjSpaceViewDir(v.vertex));
    #endif
	
#if _ALPHABUFFER && _EXTENDALPHA
    o.projPos = ComputeScreenPos (o.pos);
    COMPUTE_EYEDEPTH(o.projPos.z);
#endif

#ifdef _RECEIVEFOG
    UNITY_TRANSFER_FOG_COMBINED_WITH_WORLD_POS(o, o.pos);
#endif

#if _HEIGHTFOG
	//o.heightFog = HeightFogTransfer(posWorld.xyz);
#endif
    return o;
}

#if _MRT
FragmentOutput fragForwardAddInternal (VertexOutputForwardAdd i)
#else
half4 fragForwardAddInternal (VertexOutputForwardAdd i)
#endif
{
    UNITY_APPLY_DITHER_CROSSFADE(i.pos.xy);
	
#if _ALPHABUFFER && _EXTENDALPHA   
	float sceneZ = LinearEyeDepth (SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture,UNITY_PROJ_COORD(i.projPos)));
	clip(sceneZ - i.projPos.z);	
#endif

	float3 eyeVec = normalize(i.worldPos.xyz - _WorldSpaceCameraPos.xyz); 

    UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);

    FRAGMENT_SETUP_FWDADD(s)

    UNITY_LIGHT_ATTENUATION(atten, i, s.posWorld)
    UnityLight light = AdditiveLight (IN_LIGHTDIR_FWDADD(i), atten);
    UnityIndirect noIndirect = ZeroIndirect ();

#if _SKIN
    half4 sssTex =  tex2D(_SSSTex, TRANSFORM_TEX(i.tex.xy, _SSSTex));
    half4 c = SKIN_BRDF_PBS (s.diffColor, s.specColor, s.oneMinusReflectivity, s.smoothness, s.normalWorld, -s.eyeVec, light, noIndirect, sssTex);
#elif _HAIR
    half4 c = HAIR_BRDF_PBS(s.diffColor, s.specColor, s.oneMinusReflectivity, s.smoothness, s.normalWorld, -s.eyeVec, light, noIndirect);
#elif _CLEARCOAT
    half4 c = CLEARCOAT_BRDF_PBS(s.diffColor, s.specColor, s.oneMinusReflectivity, s.smoothness, s.normalWorld, -s.eyeVec, light, noIndirect, s.normalWorld_clearcoat, noIndirect);
#elif _FABRIC
    half4 c = FABRIC_BRDF_PBS (s.diffColor, s.specColor, s.oneMinusReflectivity, s.smoothness, s.normalWorld, -s.eyeVec, light, noIndirect);
#else
    half4 c = BRDF1_Unity_PBS (s.diffColor, s.specColor, s.oneMinusReflectivity, s.smoothness, s.normalWorld, -s.eyeVec, light, noIndirect);
#endif

#ifdef _RECEIVEFOG
    UNITY_EXTRACT_FOG_FROM_WORLD_POS(i);
    UNITY_APPLY_FOG_COLOR(_unity_fogCoord, c.rgb, half4(0,0,0,0)); // fog towards black in additive pass
#endif

#if _HEIGHTFOG
	i.heightFog = HeightFogTransfer(i.worldPos.xyz);
	c.rgb = lerp(c.rgb,half4(0,0,0,0), saturate(i.heightFog.a));
#endif

	half4 color = OutputForward(c, s.alpha);

#if _MRT
	FragmentOutput o;
	o.dest0 = color;
	o.dest1 = half4(s.normalWorld * 0.5 + 0.5,s.smoothness);
	o.dest2 = half4(s.specColor,1);
	return o;
#else
	return color;
#endif
}
//
// Old FragmentGI signature. Kept only for backward compatibility and will be removed soon
//

inline UnityGI FragmentGI(
    float3 posWorld,
    half occlusion, half4 i_ambientOrLightmapUV, half atten, half smoothness, half3 normalWorld, half3 eyeVec,
    UnityLight light,
    bool reflections)
{
    // we init only fields actually used
    FragmentCommonData s = (FragmentCommonData)0;
    s.smoothness = smoothness;
    s.normalWorld = normalWorld;
    s.eyeVec = eyeVec;
    s.posWorld = posWorld;
    return FragmentGI(s, occlusion, i_ambientOrLightmapUV, atten, light, reflections);
}
inline UnityGI FragmentGI (
    float3 posWorld,
    half occlusion, half4 i_ambientOrLightmapUV, half atten, half smoothness, half3 normalWorld, half3 eyeVec,
    UnityLight light)
{
    return FragmentGI (posWorld, occlusion, i_ambientOrLightmapUV, atten, smoothness, normalWorld, eyeVec, light, true);
}

#endif // UNITY_STANDARD_CORE_INCLUDED
