// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Shader created with Shader Forge v1.38 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:3,bdst:7,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:False,aust:False,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:3138,x:32719,y:32712,varname:node_3138,prsc:2|emission-2692-OUT,alpha-5186-OUT,voffset-1650-OUT;n:type:ShaderForge.SFN_FragmentPosition,id:3801,x:31771,y:33005,varname:node_3801,prsc:2;n:type:ShaderForge.SFN_Transform,id:9569,x:32003,y:33005,varname:node_9569,prsc:2,tffrom:0,tfto:1|IN-3801-XYZ;n:type:ShaderForge.SFN_Multiply,id:1650,x:32220,y:33047,varname:node_1650,prsc:2|A-9569-XYZ,B-6605-OUT,C-3980-RGB;n:type:ShaderForge.SFN_ValueProperty,id:6605,x:31904,y:33190,ptovrint:False,ptlb:Strange,ptin:_Strange,varname:_Strange,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_Tex2d,id:3980,x:31975,y:33314,ptovrint:False,ptlb:MainTex,ptin:_MainTex,varname:_MainTex,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:97dcc147e2d725247b9272d83e9e9da9,ntxv:0,isnm:False|UVIN-1917-UVOUT;n:type:ShaderForge.SFN_ComponentMask,id:8658,x:31414,y:33273,varname:node_8658,prsc:2,cc1:0,cc2:1,cc3:-1,cc4:-1|IN-7192-OUT;n:type:ShaderForge.SFN_NormalVector,id:7192,x:31241,y:33255,prsc:2,pt:False;n:type:ShaderForge.SFN_RemapRange,id:8149,x:31599,y:33273,varname:node_8149,prsc:2,frmn:-1,frmx:1,tomn:0,tomx:1|IN-8658-OUT;n:type:ShaderForge.SFN_Panner,id:1917,x:31784,y:33280,varname:node_1917,prsc:2,spu:1,spv:1|UVIN-8149-OUT;n:type:ShaderForge.SFN_Multiply,id:2692,x:32545,y:32731,varname:node_2692,prsc:2|A-6204-OUT,B-5186-OUT,C-3980-R;n:type:ShaderForge.SFN_Fresnel,id:5186,x:32203,y:32770,varname:node_5186,prsc:2|EXP-8578-OUT;n:type:ShaderForge.SFN_ValueProperty,id:8578,x:32001,y:32784,ptovrint:False,ptlb:FreStrange,ptin:_FreStrange,varname:_FreStrange,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_ValueProperty,id:6204,x:32259,y:32629,ptovrint:False,ptlb:ColStrange,ptin:_ColStrange,varname:_ColStrange,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;proporder:3980-6605-8578-6204;pass:END;sub:END;*/

Shader "Shader Forge/FX_VertexOffset02 New" {
    Properties {
        _MainTex ("MainTex", 2D) = "white" {}
        _Strange ("Strange", Float ) = 1
        _FreStrange ("FreStrange", Float ) = 1
        _ColStrange ("ColStrange", Float ) = 1
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend SrcAlpha OneMinusSrcAlpha , Zero OneMinusSrcAlpha
            Cull Off
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            uniform float _Strange;
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform float _FreStrange;
            uniform float _ColStrange;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float4 posWorld : TEXCOORD0;
                float3 normalDir : TEXCOORD1;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                float4 node_8612 = _Time;
                float2 node_1917 = ((v.normal.rg*0.5+0.5)+node_8612.g*float2(1,1));
                float4 _MainTex_var = tex2Dlod(_MainTex,float4(TRANSFORM_TEX(node_1917, _MainTex),0.0,0));
                v.vertex.xyz += (mul( unity_WorldToObject, float4(mul(unity_ObjectToWorld, v.vertex).rgb,0) ).xyz.rgb*_Strange*_MainTex_var.rgb);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos( v.vertex );
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                i.normalDir = normalize(i.normalDir);
                i.normalDir *= faceSign;
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
////// Lighting:
////// Emissive:
                float node_5186 = pow(1.0-max(0,dot(normalDirection, viewDirection)),_FreStrange);
                float4 node_8612 = _Time;
                float2 node_1917 = ((i.normalDir.rg*0.5+0.5)+node_8612.g*float2(1,1));
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(node_1917, _MainTex));
                float node_2692 = (_ColStrange*node_5186*_MainTex_var.r);
                float3 emissive = float3(node_2692,node_2692,node_2692);
                float3 finalColor = emissive;
                return fixed4(finalColor,node_5186);
            }
            ENDCG
        }
        Pass {
            Name "ShadowCaster"
            Tags {
                "LightMode"="ShadowCaster"
            }
            Offset 1, 1
            Cull Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_SHADOWCASTER
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_shadowcaster
            #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            uniform float _Strange;
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };
            struct VertexOutput {
                V2F_SHADOW_CASTER;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                float4 node_9083 = _Time;
                float2 node_1917 = ((v.normal.rg*0.5+0.5)+node_9083.g*float2(1,1));
                float4 _MainTex_var = tex2Dlod(_MainTex,float4(TRANSFORM_TEX(node_1917, _MainTex),0.0,0));
                v.vertex.xyz += (mul( unity_WorldToObject, float4(mul(unity_ObjectToWorld, v.vertex).rgb,0) ).xyz.rgb*_Strange*_MainTex_var.rgb);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos( v.vertex );
                TRANSFER_SHADOW_CASTER(o)
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                i.normalDir = normalize(i.normalDir);
                i.normalDir *= faceSign;
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
