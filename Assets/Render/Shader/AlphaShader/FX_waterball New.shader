// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Shader created with Shader Forge v1.38 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:3,bdst:7,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:False,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:3138,x:33492,y:32751,varname:node_3138,prsc:2|emission-6894-OUT,alpha-9989-OUT,voffset-1026-OUT;n:type:ShaderForge.SFN_Multiply,id:1026,x:33009,y:33247,varname:node_1026,prsc:2|A-8599-XYZ,B-6409-RGB,C-5774-OUT;n:type:ShaderForge.SFN_Transform,id:8599,x:32369,y:33892,varname:node_8599,prsc:2,tffrom:0,tfto:1|IN-2241-XYZ;n:type:ShaderForge.SFN_Tex2d,id:6409,x:32749,y:34159,ptovrint:False,ptlb:trub_Tex,ptin:_trub_Tex,varname:_trub_Tex,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:efe45b72b3e75a14fa63d97696bdeb9f,ntxv:0,isnm:False|UVIN-2720-UVOUT;n:type:ShaderForge.SFN_FragmentPosition,id:2241,x:31565,y:33874,varname:node_2241,prsc:2;n:type:ShaderForge.SFN_Slider,id:5774,x:32232,y:34100,ptovrint:False,ptlb:trub_power,ptin:_trub_power,varname:_trub_power,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.2649573,max:1;n:type:ShaderForge.SFN_TexCoord,id:7574,x:32180,y:34215,varname:node_7574,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Panner,id:2720,x:32436,y:34218,varname:node_2720,prsc:2,spu:0.5,spv:0.5|UVIN-7574-UVOUT;n:type:ShaderForge.SFN_Fresnel,id:4040,x:32723,y:32927,varname:node_4040,prsc:2|EXP-3614-OUT;n:type:ShaderForge.SFN_Multiply,id:5333,x:32921,y:32818,varname:node_5333,prsc:2|A-3414-RGB,B-4040-OUT;n:type:ShaderForge.SFN_Color,id:3414,x:32237,y:32868,ptovrint:False,ptlb:Col,ptin:_Col,varname:_Col,prsc:2,glob:False,taghide:False,taghdr:True,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Slider,id:3614,x:32252,y:33169,ptovrint:False,ptlb:fre_power,ptin:_fre_power,varname:_fre_power,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:1,max:10;n:type:ShaderForge.SFN_FragmentPosition,id:232,x:30890,y:32092,varname:node_232,prsc:2;n:type:ShaderForge.SFN_Vector4Property,id:7875,x:31238,y:32515,ptovrint:False,ptlb:light_dir,ptin:_light_dir,varname:_light_dir,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1,v2:1,v3:1,v4:1;n:type:ShaderForge.SFN_Subtract,id:2864,x:31620,y:32261,varname:node_2864,prsc:2|A-232-XYZ,B-4852-OUT;n:type:ShaderForge.SFN_Dot,id:9436,x:31993,y:32396,varname:node_9436,prsc:2,dt:0|A-5187-OUT,B-4840-OUT;n:type:ShaderForge.SFN_NormalVector,id:4840,x:31781,y:32465,prsc:2,pt:False;n:type:ShaderForge.SFN_Append,id:9390,x:32192,y:32396,varname:node_9390,prsc:2|A-9436-OUT,B-2172-V;n:type:ShaderForge.SFN_Tex2d,id:5091,x:32573,y:32362,ptovrint:False,ptlb:yun_Tex,ptin:_yun_Tex,varname:_yun_Tex,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:5630494bb0d5b18488781c8e5d884d9e,ntxv:0,isnm:False|UVIN-9863-OUT;n:type:ShaderForge.SFN_Add,id:6894,x:33246,y:32798,varname:node_6894,prsc:2|A-5919-OUT,B-5333-OUT,C-2645-RGB;n:type:ShaderForge.SFN_Add,id:1500,x:33047,y:32991,varname:node_1500,prsc:2|A-5091-R,B-4040-OUT,C-2645-R;n:type:ShaderForge.SFN_Normalize,id:5187,x:31803,y:32274,varname:node_5187,prsc:2|IN-2864-OUT;n:type:ShaderForge.SFN_Clamp01,id:9989,x:33246,y:33004,varname:node_9989,prsc:2|IN-1500-OUT;n:type:ShaderForge.SFN_ViewPosition,id:2374,x:31238,y:32320,varname:node_2374,prsc:2;n:type:ShaderForge.SFN_Multiply,id:4852,x:31439,y:32352,varname:node_4852,prsc:2|A-2374-XYZ,B-7875-XYZ;n:type:ShaderForge.SFN_TexCoord,id:2172,x:31892,y:32661,varname:node_2172,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Tex2d,id:2645,x:32463,y:32603,ptovrint:False,ptlb:spec_Tex,ptin:_spec_Tex,varname:_spec_Tex,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False|UVIN-9390-OUT;n:type:ShaderForge.SFN_Multiply,id:5919,x:32841,y:32223,varname:node_5919,prsc:2|A-971-RGB,B-5091-RGB;n:type:ShaderForge.SFN_Color,id:971,x:32573,y:32131,ptovrint:False,ptlb:yun_Col,ptin:_yun_Col,varname:_yun_Col,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Time,id:1733,x:31441,y:31407,varname:node_1733,prsc:2;n:type:ShaderForge.SFN_Multiply,id:8058,x:31797,y:31418,varname:node_8058,prsc:2|A-1733-T,B-56-OUT;n:type:ShaderForge.SFN_Multiply,id:2490,x:31790,y:31701,varname:node_2490,prsc:2|A-1733-T,B-1522-OUT;n:type:ShaderForge.SFN_ValueProperty,id:56,x:31413,y:31604,ptovrint:False,ptlb:U_speed,ptin:_U_speed,varname:_U_speed,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_ValueProperty,id:1522,x:31403,y:31785,ptovrint:False,ptlb:V_speed,ptin:_V_speed,varname:_V_speed,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_Add,id:1304,x:32013,y:31597,varname:node_1304,prsc:2|A-8058-OUT,B-2490-OUT;n:type:ShaderForge.SFN_Set,id:6882,x:32244,y:31633,varname:node_6882,prsc:2|IN-1304-OUT;n:type:ShaderForge.SFN_Get,id:8488,x:32171,y:32209,varname:node_8488,prsc:2|IN-6882-OUT;n:type:ShaderForge.SFN_Add,id:9863,x:32362,y:32243,varname:node_9863,prsc:2|A-8488-OUT,B-9390-OUT;proporder:6409-5774-3414-3614-7875-5091-971-2645-56-1522;pass:END;sub:END;*/

Shader "Shader Forge/FX_waterball New" {
    Properties {
        _trub_Tex ("trub_Tex", 2D) = "white" {}
        _trub_power ("trub_power", Range(0, 1)) = 0.2649573
        [HDR]_Col ("Col", Color) = (0.5,0.5,0.5,1)
        _fre_power ("fre_power", Range(0, 10)) = 1
        _light_dir ("light_dir", Vector) = (1,1,1,1)
        _yun_Tex ("yun_Tex", 2D) = "white" {}
        _yun_Col ("yun_Col", Color) = (0.5,0.5,0.5,1)
        _spec_Tex ("spec_Tex", 2D) = "white" {}
        _U_speed ("U_speed", Float ) = 1
        _V_speed ("V_speed", Float ) = 1
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
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            uniform sampler2D _trub_Tex; uniform float4 _trub_Tex_ST;
            uniform float _trub_power;
            uniform float4 _Col;
            uniform float _fre_power;
            uniform float4 _light_dir;
            uniform sampler2D _yun_Tex; uniform float4 _yun_Tex_ST;
            uniform sampler2D _spec_Tex; uniform float4 _spec_Tex_ST;
            uniform float4 _yun_Col;
            uniform float _U_speed;
            uniform float _V_speed;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                float4 node_4089 = _Time;
                float2 node_2720 = (o.uv0+node_4089.g*float2(0.5,0.5));
                float4 _trub_Tex_var = tex2Dlod(_trub_Tex,float4(TRANSFORM_TEX(node_2720, _trub_Tex),0.0,0));
                v.vertex.xyz += (mul( unity_WorldToObject, float4(mul(unity_ObjectToWorld, v.vertex).rgb,1) ).xyz.rgb*_trub_Tex_var.rgb*_trub_power);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos( v.vertex );
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
////// Lighting:
////// Emissive:
                float4 node_1733 = _Time;
                float node_6882 = ((node_1733.g*_U_speed)+(node_1733.g*_V_speed));
                float node_9436 = dot(normalize((i.posWorld.rgb-(_WorldSpaceCameraPos*_light_dir.rgb))),i.normalDir);
                float2 node_9390 = float2(node_9436,i.uv0.g);
                float2 node_9863 = (node_6882+node_9390);
                float4 _yun_Tex_var = tex2D(_yun_Tex,TRANSFORM_TEX(node_9863, _yun_Tex));
                float node_4040 = pow(1.0-max(0,dot(normalDirection, viewDirection)),_fre_power);
                float4 _spec_Tex_var = tex2D(_spec_Tex,TRANSFORM_TEX(node_9390, _spec_Tex));
                float3 emissive = ((_yun_Col.rgb*_yun_Tex_var.rgb)+(_Col.rgb*node_4040)+_spec_Tex_var.rgb);
                float3 finalColor = emissive;
                return fixed4(finalColor,saturate((_yun_Tex_var.r+node_4040+_spec_Tex_var.r)));
            }
            ENDCG
        }
        Pass {
            Name "ShadowCaster"
            Tags {
                "LightMode"="ShadowCaster"
            }
            Offset 1, 1
            Cull Back
            
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
            uniform sampler2D _trub_Tex; uniform float4 _trub_Tex_ST;
            uniform float _trub_power;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                V2F_SHADOW_CASTER;
                float2 uv0 : TEXCOORD1;
                float4 posWorld : TEXCOORD2;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                float4 node_9376 = _Time;
                float2 node_2720 = (o.uv0+node_9376.g*float2(0.5,0.5));
                float4 _trub_Tex_var = tex2Dlod(_trub_Tex,float4(TRANSFORM_TEX(node_2720, _trub_Tex),0.0,0));
                v.vertex.xyz += (mul( unity_WorldToObject, float4(mul(unity_ObjectToWorld, v.vertex).rgb,1) ).xyz.rgb*_trub_Tex_var.rgb*_trub_power);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos( v.vertex );
                TRANSFER_SHADOW_CASTER(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
