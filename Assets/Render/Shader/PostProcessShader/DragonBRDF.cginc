#ifndef BRDF_HAPPYELEMENTS_INCLUDED
#define BRDF_HAPPYELEMENTS_INCLUDED

inline half3  ObjectBRDF(half3 diffColor,half3 normal,half3 viewDir,half oneMinusRoughness,half shadowAtten,half3 specColor)
{
	half roughness	= 1 - oneMinusRoughness;
	half a = roughness * roughness;
	
	half3 halfDir = normalize(_WorldSpaceLightPos0.xyz + viewDir);
	
	half NdotV = saturate(dot(normal, viewDir));
	half NdotL = saturate(dot(normal, _WorldSpaceLightPos0.xyz));
	half diffuseTerm =  NdotL;
	
	half3 sunDiffuseColor = _LightColor0.rgb  * shadowAtten;			

	half3 ambient = SHEvalLinearL2 (half4(normal, 1.0)) + SHEvalLinearL0L1(half4(normal,1));
	
	half3 outColor = (sunDiffuseColor.rgb * diffuseTerm + ambient) * diffColor;
	
	half NdotH = saturate(dot(normal, halfDir));	
	half VdotH = lerp(0.3f,1,saturate(dot(viewDir, halfDir)));
	
	half lambdaV = NdotL * (NdotV * (1 - a) + a);
	half lambdaL = NdotV * (NdotL * (1 - a) + a);
	half V = 2.0f / (lambdaV + lambdaL);
	
	half a2 = a * a;
	half d = NdotH * NdotH * (a2 - 1.f) + 1.f;
	half D = a2 / (UNITY_PI * d * d);	
	
	half specularTerm = (V * D) * (UNITY_PI/4); 
	
	specularTerm = clamp(specularTerm * NdotL,0,10) * shadowAtten * shadowAtten;
	outColor += specularTerm * sunDiffuseColor.rgb * F_Schlick2 (specColor, VdotH);
	return outColor;
}


#endif


