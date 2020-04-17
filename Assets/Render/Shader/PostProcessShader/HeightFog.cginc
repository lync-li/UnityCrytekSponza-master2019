#include "PostProcessCommon.cginc"
#include "FunLib.cginc"

half4  _HeightFogColor;	
half4  _HeightFogEmissionColor;	
half4  _HeightFogParam;
half4  _HeightFogWave0;
half4  _HeightFogWave1;	

inline float3 getWorldPos(VaryingsDefault i, float depth01) {	
    float3 worldPos = (i.cameraToFarPlane * depth01) + _WorldSpaceCameraPos.xyz; 
    return worldPos;
}

inline float getDepth(VaryingsDefault i) {
	float depth01 = Linear01Depth(tex2D(_CameraDepthTexture, i.texcoord).r);
	return depth01;
}

inline float3 waveCalc(float3 worldPos)
{	
#ifdef  ANIMATION
        float timeX = _Time.x * 20 * -_HeightFogWave0.x;
        float timeZ = _Time.x * 20 * -_HeightFogWave0.y;
        float waveValueX = sin(timeX + worldPos.x * _HeightFogWave0.z) * _HeightFogWave1.x;
        float waveValueZ = sin(timeZ + worldPos.z * _HeightFogWave0.w) * _HeightFogWave1.y;
        float waveValue = (waveValueX + waveValueZ) / 2;
		worldPos.y += waveValue;     
#endif
    return worldPos;
}
	
half4 fragApplyFog (VaryingsDefault i) : SV_Target {	
	float3 worldPos = getWorldPos(i, getDepth(i));	
    half3 wPos = waveCalc(worldPos);
	float lerpValue = saturate((wPos.y  - _HeightFogParam.x) / _HeightFogParam.y);
	lerpValue = 1 - pow(lerpValue, _HeightFogParam.z);
    float3 emission = _HeightFogColor.rgb + _HeightFogEmissionColor.rgb * 2;
    float3 fogEmissionColor = lerp(_HeightFogColor, emission, pow(lerpValue, _HeightFogParam.w));
	
    //float lerpValue = clamp((wPos.y  - _FogMin) / (_FogMax - _FogMin), 0, 1);
	//lerpValue = 1 - pow(lerpValue, _FogFalloff);
    //float3 emission = _FogColor + _FogEmissionColor * _FogEmissionPower;
    //float3 fogEmissionColor = lerp(_FogColor, emission, pow(lerpValue, _FogEmissionFalloff));
	
	half4 sum = half4(fogEmissionColor,lerpValue); // was tex2Dlod

	return sum;
}


