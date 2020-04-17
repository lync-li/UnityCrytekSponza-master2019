Shader "FX/UVOffset New" {
	Properties{
		_MainTex("Base (RGB)", 2D) = "white" {}
	_USpeed("USpeed ", float) = 1.0
		_UCount("UCount", float) = 1.0
		_VSpeed("VSpeed", float) = 1.0
		_VCount("VCount", float) = 1.0
		_TintColor("Tint Color", Color) = (0.5,0.5,0.5,0.5)
	}
		SubShader{
		Tags{ "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }
		Blend SrcAlpha One , Zero One
	    LOD 200

		CGPROGRAM

#pragma surface surf Lambert alpha
#pragma vertex vert
#include "UnityCG.cginc"
		sampler2D _MainTex;
	float _USpeed;
	float _UCount;
	float _VSpeed;
    float _VCount;
	float4 _TintColor;

	struct Input {
		float2 uv_MainTex;
	};



	void vert(inout appdata_full v) {
#if !defined(SHADER_API_OPENGL)
		float4 tex = tex2Dlod(_MainTex, float4(v.texcoord.xy, 0, 0));
		v.vertex.z += tex.r * 0.2;
#endif
	} 



	void surf(Input IN, inout SurfaceOutput o) {
		float2 uv = IN.uv_MainTex;
		float detalTime = _Time.x;

		uv.x += detalTime * _USpeed;
		uv.x *= _UCount;

		uv.y += detalTime * _VSpeed;
		uv.y *= _VCount;

		half4 c = tex2D(_MainTex, uv);
		o.Albedo = c.rgb;
		o.Alpha = c.a;
	}
	ENDCG
	}
		FallBack "Diffuse"
}