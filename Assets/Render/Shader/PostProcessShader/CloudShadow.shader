Shader "Hidden/DragonCloudShadow"
 {

	Properties {
		_MainTex ("Base Texture", 2D) = "white" {}
	}

	Category {
		ZTest Always Cull off ZWrite Off 

		CGINCLUDE
				
				#include "UnityCG.cginc"

				sampler2D _CloudShadowTex;
				float4 _MainTex_TexelSize;
				half4  _CloudShadowParams;
				float4 _UVToView;
				half4  _CloudShadowColor;
				
				sampler2D_float _CameraDepthTexture;
				float4 _CameraDepthTexture_ST;
				
				inline float3 FetchViewPos(float2 uv) {	
					float z = DECODE_EYEDEPTH(SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, uv));
					return float3((uv * _UVToView.xy + _UVToView.zw) * z, z);
				}
				
				struct v2f
				{
					float4 pos : SV_POSITION;
					half2 uv : TEXCOORD0;
				};	
				
				v2f vert (appdata_img v)
				{
					v2f o;
					o.uv = v.texcoord.xy;
					#if UNITY_UV_STARTS_AT_TOP
					if (_MainTex_TexelSize.y < 0)
						o.uv.y = 1 - o.uv.y;
					#endif
					o.pos = UnityObjectToClipPos(v.vertex);
					return o; 
				}
				
				half4 frag ( v2f i ) : SV_Target
				{					
					float3 P = FetchViewPos(i.uv);
					
					float2 uv = P.xz * _CloudShadowParams.x + (_Time.y * float2(_CloudShadowParams.z, _CloudShadowParams.w));
					
					float cloud = tex2D(_CloudShadowTex, uv).r;
		  							
					cloud = lerp(1, cloud, _CloudShadowParams.y);
					
					return half4(_CloudShadowColor.rgb, 1- cloud ) ;
				}
		ENDCG
				
		Subshader {
		
			Pass {
			Blend DstColor OneMinusSrcAlpha  
				CGPROGRAM
					#pragma vertex vert
					#pragma fragment frag
					#pragma fragmentoption ARB_precision_hint_fastest
					#pragma target 3.0
				ENDCG
			}	
		}
	}
	Fallback off
}

