// Shader created with Shader Forge v1.37 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.37;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:1,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:0,bdst:0,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.653505,fgcg:0.6125649,fgcb:0.7573529,fgca:1,fgde:0.01,fgrn:11.8,fgrf:35.7,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:4013,x:35063,y:32725,varname:node_4013,prsc:2|emission-3073-OUT,voffset-1733-OUT;n:type:ShaderForge.SFN_Color,id:9005,x:34179,y:32340,ptovrint:False,ptlb:Color,ptin:_Color,varname:node_1304,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_TexCoord,id:7826,x:31714,y:32958,varname:node_7826,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Add,id:2583,x:32570,y:33027,varname:node_2583,prsc:2|A-1209-UVOUT,B-2388-OUT;n:type:ShaderForge.SFN_Tex2d,id:6617,x:32172,y:33159,ptovrint:False,ptlb:node_3623,ptin:_node_3623,varname:node_3623,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False|UVIN-5238-UVOUT;n:type:ShaderForge.SFN_Panner,id:5238,x:31907,y:33005,varname:node_5238,prsc:2,spu:0,spv:-0.4|UVIN-7826-UVOUT;n:type:ShaderForge.SFN_Tex2d,id:4276,x:33147,y:32616,ptovrint:False,ptlb:node_6960,ptin:_node_6960,varname:node_6960,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False|UVIN-1321-OUT;n:type:ShaderForge.SFN_ComponentMask,id:1321,x:32733,y:33065,varname:node_1321,prsc:2,cc1:0,cc2:1,cc3:-1,cc4:-1|IN-2583-OUT;n:type:ShaderForge.SFN_TexCoord,id:1209,x:32039,y:32659,varname:node_1209,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Lerp,id:2388,x:32383,y:33353,varname:node_2388,prsc:2|A-6617-RGB,B-6043-OUT,T-7108-OUT;n:type:ShaderForge.SFN_Slider,id:7108,x:32067,y:33613,ptovrint:False,ptlb:node_1414,ptin:_node_1414,varname:node_1414,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Vector3,id:6043,x:31768,y:33307,varname:node_6043,prsc:2,v1:0,v2:0,v3:0;n:type:ShaderForge.SFN_Tex2d,id:7905,x:33003,y:33368,ptovrint:False,ptlb:node_8348,ptin:_node_8348,varname:node_8348,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False|UVIN-5238-UVOUT;n:type:ShaderForge.SFN_Lerp,id:1733,x:33977,y:33690,varname:node_1733,prsc:2|A-7905-RGB,B-3925-OUT,T-8084-OUT;n:type:ShaderForge.SFN_Slider,id:8084,x:33032,y:33906,ptovrint:False,ptlb:node_1414_copy,ptin:_node_1414_copy,varname:_node_1414_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Vector3,id:3925,x:32666,y:33456,varname:node_3925,prsc:2,v1:0,v2:0,v3:0;n:type:ShaderForge.SFN_VertexColor,id:5424,x:33945,y:33374,varname:node_5424,prsc:2;n:type:ShaderForge.SFN_Tex2d,id:8583,x:33142,y:32911,ptovrint:False,ptlb:node_3756,ptin:_node_3756,varname:node_3756,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False|UVIN-5238-UVOUT;n:type:ShaderForge.SFN_Multiply,id:1678,x:33591,y:33037,varname:node_1678,prsc:2|A-8583-RGB,B-3856-OUT,C-8887-RGB;n:type:ShaderForge.SFN_Slider,id:3856,x:33035,y:33147,ptovrint:False,ptlb:node_5082,ptin:_node_5082,varname:node_5082,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:10;n:type:ShaderForge.SFN_Add,id:5981,x:33920,y:32515,varname:node_5981,prsc:2|A-4541-OUT,B-4276-RGB;n:type:ShaderForge.SFN_Multiply,id:4541,x:33612,y:32440,varname:node_4541,prsc:2|A-4276-RGB,B-3787-OUT;n:type:ShaderForge.SFN_Slider,id:3787,x:32965,y:32410,ptovrint:False,ptlb:node_1598,ptin:_node_1598,varname:node_1598,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:10;n:type:ShaderForge.SFN_Multiply,id:4594,x:34464,y:32489,varname:node_4594,prsc:2|A-5981-OUT,B-9005-RGB,C-1842-OUT;n:type:ShaderForge.SFN_Multiply,id:1842,x:34346,y:32741,varname:node_1842,prsc:2|A-4276-A,B-2147-RGB;n:type:ShaderForge.SFN_Tex2d,id:2147,x:34326,y:33124,ptovrint:False,ptlb:node_2147,ptin:_node_2147,varname:node_2147,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Multiply,id:8639,x:34566,y:32928,varname:node_8639,prsc:2|A-1678-OUT,B-2147-RGB;n:type:ShaderForge.SFN_Add,id:3073,x:34816,y:32682,varname:node_3073,prsc:2|A-4594-OUT,B-8639-OUT;n:type:ShaderForge.SFN_Color,id:8887,x:33427,y:33308,ptovrint:False,ptlb:node_8887,ptin:_node_8887,varname:node_8887,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;proporder:4276-8583-3856-3787-7905-8084-9005-6617-7108-2147-8887;pass:END;sub:END;*/

Shader "Shader Forge/fire" {
    Properties {
        _node_6960 ("node_6960", 2D) = "white" {}
        _node_3756 ("node_3756", 2D) = "white" {}
        _node_5082 ("node_5082", Range(0, 10)) = 0
        _node_1598 ("node_1598", Range(0, 10)) = 0
        _node_8348 ("node_8348", 2D) = "white" {}
        _node_1414_copy ("node_1414_copy", Range(0, 1)) = 0
        _Color ("Color", Color) = (1,1,1,1)
        _node_3623 ("node_3623", 2D) = "white" {}
        _node_1414 ("node_1414", Range(0, 1)) = 0
        _node_2147 ("node_2147", 2D) = "white" {}
        _node_8887 ("node_8887", Color) = (0.5,0.5,0.5,1)
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
            Blend One One
            Cull Off
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            #pragma multi_compile_fog
         //   #pragma only_renderers d3d9 d3d11 glcore gles gles3 metal 
            #pragma target 3.0
            uniform float4 _TimeEditor;
            uniform float4 _Color;
            uniform sampler2D _node_3623; uniform float4 _node_3623_ST;
            uniform sampler2D _node_6960; uniform float4 _node_6960_ST;
            uniform float _node_1414;
            uniform sampler2D _node_8348; uniform float4 _node_8348_ST;
            uniform float _node_1414_copy;
            uniform sampler2D _node_3756; uniform float4 _node_3756_ST;
            uniform float _node_5082;
            uniform float _node_1598;
            uniform sampler2D _node_2147; uniform float4 _node_2147_ST;
            uniform float4 _node_8887;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                UNITY_FOG_COORDS(1)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                float4 node_8599 = _Time + _TimeEditor;
                float2 node_5238 = (o.uv0+node_8599.g*float2(0,-0.4));
                float4 _node_8348_var = tex2Dlod(_node_8348,float4(TRANSFORM_TEX(node_5238, _node_8348),0.0,0));
                v.vertex.xyz += lerp(_node_8348_var.rgb,float3(0,0,0),_node_1414_copy);
                o.pos = UnityObjectToClipPos( v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
////// Lighting:
////// Emissive:
                float4 node_8599 = _Time + _TimeEditor;
                float2 node_5238 = (i.uv0+node_8599.g*float2(0,-0.4));
                float4 _node_3623_var = tex2D(_node_3623,TRANSFORM_TEX(node_5238, _node_3623));
                float2 node_1321 = (float3(i.uv0,0.0)+lerp(_node_3623_var.rgb,float3(0,0,0),_node_1414)).rg;
                float4 _node_6960_var = tex2D(_node_6960,TRANSFORM_TEX(node_1321, _node_6960));
                float4 _node_2147_var = tex2D(_node_2147,TRANSFORM_TEX(i.uv0, _node_2147));
                float4 _node_3756_var = tex2D(_node_3756,TRANSFORM_TEX(node_5238, _node_3756));
                float3 emissive = ((((_node_6960_var.rgb*_node_1598)+_node_6960_var.rgb)*_Color.rgb*(_node_6960_var.a*_node_2147_var.rgb))+((_node_3756_var.rgb*_node_5082*_node_8887.rgb)*_node_2147_var.rgb));
                float3 finalColor = emissive;
                fixed4 finalRGBA = fixed4(finalColor,1);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
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
            #pragma multi_compile_fog
           // #pragma only_renderers d3d9 d3d11 glcore gles gles3 metal 
            #pragma target 3.0
            uniform float4 _TimeEditor;
            uniform sampler2D _node_8348; uniform float4 _node_8348_ST;
            uniform float _node_1414_copy;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                V2F_SHADOW_CASTER;
                float2 uv0 : TEXCOORD1;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                float4 node_1027 = _Time + _TimeEditor;
                float2 node_5238 = (o.uv0+node_1027.g*float2(0,-0.4));
                float4 _node_8348_var = tex2Dlod(_node_8348,float4(TRANSFORM_TEX(node_5238, _node_8348),0.0,0));
                v.vertex.xyz += lerp(_node_8348_var.rgb,float3(0,0,0),_node_1414_copy);
                o.pos = UnityObjectToClipPos( v.vertex );
                TRANSFER_SHADOW_CASTER(o)
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
