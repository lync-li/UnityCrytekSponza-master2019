Shader "Hidden/DragonRadialBlur"
 {

	Properties {
		_MainTex ("Base Texture", 2D) = "white" {}
		_RadialAmount ("Dist", Range(0,1)) = 0.3
		_RadialStrength ("Strength", Range(0.02,1)) = 0.5
	}

	Category {
		ZTest Always Cull off ZWrite Off 

		CGINCLUDE
				
				#include "UnityCG.cginc"

				sampler2D _MainTex;
				sampler2D _BlurTex;
				half  _RadialAmount;
				half  _RadialStrength; 
			
				static const half samples[10] = { -0.08, -0.05, -0.03, -0.02, -0.01, 0.01, 0.02, 0.03 , 0.05 , 0.08 };  // 
			//	static const half samples[3] = { -0.08, -0.05, -0.03 }; 
				struct v2f
				{
					float4 pos : SV_POSITION;
					half2 uv : TEXCOORD0;
				};	
				
				v2f vert (appdata_img v)
				{
					v2f o;
					o.pos = UnityObjectToClipPos (v.vertex);
					o.uv = v.texcoord.xy;
					return o; 
				}
				
				half4 frag ( v2f i ) : SV_Target
				{
					half2 dir = half2(0.5,0.5) - i.uv;
					half dist = dot(dir , dir);
					
					half4 c = tex2D(_MainTex, i.uv);
					half4 additive = tex2D(_MainTex, i.uv); 
		  			//for( int l = 0; l < 3; l++ )  
		  			{   
		  				additive += tex2D(_MainTex, i.uv - dir * samples[0] * _RadialAmount * 4);
						additive += tex2D(_MainTex, i.uv - dir * samples[1] * _RadialAmount * 4);
						additive += tex2D(_MainTex, i.uv - dir * samples[2] * _RadialAmount * 4);
						additive += tex2D(_MainTex, i.uv - dir * samples[3] * _RadialAmount * 4);
		  			}
		  			
		  			additive = additive / 4;
		  			half t = clamp( dist / _RadialStrength , 0 ,1);
		  			
					return lerp( c ,additive, t) ;
				}
		ENDCG
				
		Subshader {
		
			Pass {
				CGPROGRAM
					#pragma vertex vert
					#pragma fragment frag
					#pragma fragmentoption ARB_precision_hint_fastest
				ENDCG
			}	
		}
	}
	Fallback off
}

