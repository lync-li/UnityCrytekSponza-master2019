Shader "Unlit/AnimTexture"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_AnimPosTex("Pos Tex",2D) = ""{}
		_AnimNormalTex("Normal Tex",2D) = ""{}
		_StartEndFrame("Start End Frame",Vector) = (0,1,0,1) // startTime,oldStartTime,framerate,loop
		_AnimParam0("AnimParam0",Vector) = (0,0,0,0)
		_AnimParam1("AnimParam1",Vector) = (0,0,0,0)
    }

CGINCLUDE
		sampler2D _AnimPosTex;
		float4 _AnimPosTex_TexelSize;
		sampler2D _AnimNormalTex;
		float4 _AnimNormalTex_TexelSize;

		inline float GetY(float startFrame, float endFrame, float4 animParam) {
			float totalLen = _AnimPosTex_TexelSize.w * animParam.w;
			float start = startFrame / _AnimPosTex_TexelSize.w;
			float end = (endFrame - 1)/ _AnimPosTex_TexelSize.w;
			float len = end - start;
			float time = (_Time.y - animParam.x) *  animParam.z / totalLen;
			float y = start + time % len;

			float loopOnce = saturate(sign(time - len));
			y = lerp(y, end, animParam.y * loopOnce);

			return y;
		}
ENDCG
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
			#pragma multi_compile_instancing

            #include "UnityCG.cginc"

            struct appdata
            {
                half2 uv : TEXCOORD0;
				uint vertexId:SV_VertexID;
				UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                half4 vertex : SV_POSITION;
                half2 uv : TEXCOORD0;
            };

			struct animData
			{
				half4 vertex;
				half4 normal ;
			};

            sampler2D _MainTex;
            half4 _MainTex_ST;

			UNITY_INSTANCING_BUFFER_START(Props)
				UNITY_DEFINE_INSTANCED_PROP(float4, _StartEndFrame)
				UNITY_DEFINE_INSTANCED_PROP(float4, _AnimParam0)
				UNITY_DEFINE_INSTANCED_PROP(float4, _AnimParam1)
			UNITY_INSTANCING_BUFFER_END(Props)

			animData GetBlendAnimPos(appdata v) {
				animData data = (animData)0;
				float4 startEndFrame = UNITY_ACCESS_INSTANCED_PROP(Props, _StartEndFrame);
				float4 animParam0 = UNITY_ACCESS_INSTANCED_PROP(Props, _AnimParam0);
				float4 animParam1 = UNITY_ACCESS_INSTANCED_PROP(Props, _AnimParam1);

				float y = GetY(startEndFrame.x, startEndFrame.y, animParam0);

				float x = (v.vertexId + 0.5) * _AnimPosTex_TexelSize.x;

				half4 nextPos = tex2Dlod(_AnimPosTex, half4(x, y, 0, 0));
				half4 nextNormal = tex2Dlod(_AnimNormalTex, half4(x, y, 0, 0));

				float crossLerp = saturate((_Time.y - animParam0.x) * animParam1.w);

				half4 curPos = 0;
				half4 curNormal = 0;
				if (crossLerp < 0.99)
				{		
					animParam1.w = animParam0.w;
					y = GetY(startEndFrame.z, startEndFrame.w, animParam1);
					curPos = tex2Dlod(_AnimPosTex, half4(x, y, 0, 0));
					curNormal = tex2Dlod(_AnimNormalTex, half4(x, y, 0, 0));
				}			
				data.vertex = lerp(curPos, nextPos, crossLerp);
				data.normal = lerp(curNormal, nextNormal, crossLerp);
				return data;
			}			

            v2f vert (appdata v)
            {
                v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				
				animData data = GetBlendAnimPos(v);

				o.vertex = UnityObjectToClipPos(data.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
		
                return o;
            }

            half4 frag (v2f i) : SV_Target
            {
                // sample the texture
				half4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}
