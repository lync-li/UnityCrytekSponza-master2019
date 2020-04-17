// Shader created with Shader Forge v1.37 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.37;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:1,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:3,bdst:7,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:4013,x:33256,y:32680,varname:node_4013,prsc:2|emission-548-OUT,alpha-8940-OUT;n:type:ShaderForge.SFN_Tex2d,id:2274,x:32398,y:32985,varname:node_2274,prsc:2,ntxv:0,isnm:False|UVIN-6250-UVOUT,TEX-363-TEX;n:type:ShaderForge.SFN_Panner,id:6250,x:32077,y:33028,varname:node_6250,prsc:2,spu:0,spv:0.1|UVIN-6923-UVOUT;n:type:ShaderForge.SFN_TexCoord,id:6923,x:31672,y:33074,varname:node_6923,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Color,id:7320,x:32494,y:32607,ptovrint:False,ptlb:node_7320,ptin:_node_7320,varname:node_7320,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Multiply,id:548,x:32967,y:32625,varname:node_548,prsc:2|A-7320-RGB,B-4171-OUT,C-7349-OUT;n:type:ShaderForge.SFN_Slider,id:7349,x:32415,y:32801,ptovrint:False,ptlb:node_7349,ptin:_node_7349,varname:node_7349,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:1,max:10;n:type:ShaderForge.SFN_Multiply,id:9041,x:32858,y:33180,varname:node_9041,prsc:2|A-2274-R,B-2230-RGB;n:type:ShaderForge.SFN_Tex2d,id:2230,x:32611,y:33271,ptovrint:False,ptlb:node_2230,ptin:_node_2230,varname:node_2230,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_ComponentMask,id:8940,x:33109,y:33093,varname:node_8940,prsc:2,cc1:0,cc2:-1,cc3:-1,cc4:-1|IN-6849-OUT;n:type:ShaderForge.SFN_Tex2dAsset,id:363,x:31980,y:32898,ptovrint:False,ptlb:node_363,ptin:_node_363,varname:node_363,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Tex2d,id:2405,x:32379,y:33185,varname:node_2405,prsc:2,ntxv:0,isnm:False|UVIN-763-UVOUT,TEX-363-TEX;n:type:ShaderForge.SFN_Panner,id:763,x:32077,y:33247,varname:node_763,prsc:2,spu:0,spv:0.2|UVIN-6923-UVOUT;n:type:ShaderForge.SFN_Add,id:4171,x:32902,y:32819,varname:node_4171,prsc:2|A-2274-RGB,B-2405-RGB;n:type:ShaderForge.SFN_Lerp,id:6849,x:33088,y:33310,varname:node_6849,prsc:2|A-9041-OUT,B-799-OUT,T-313-OUT;n:type:ShaderForge.SFN_Vector3,id:799,x:32858,y:33352,varname:node_799,prsc:2,v1:0,v2:0,v3:0;n:type:ShaderForge.SFN_Slider,id:313,x:32904,y:33510,ptovrint:False,ptlb:node_313,ptin:_node_313,varname:node_313,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;proporder:7320-7349-2230-363-313;pass:END;sub:END;*/

Shader "Shader Forge/wave2" {
    Properties {
        _node_7320 ("node_7320", Color) = (0.5,0.5,0.5,1)
        _node_7349 ("node_7349", Range(0, 10)) = 1
        _node_2230 ("node_2230", 2D) = "white" {}
        _node_363 ("node_363", 2D) = "white" {}
        _node_313 ("node_313", Range(0, 1)) = 0
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
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            #pragma multi_compile_fog
             //#pragma only_renderers d3d9 d3d11 glcore gles gles3 metal d3d11_9x 
            #pragma target 3.0
            uniform float4 _TimeEditor;
            uniform float4 _node_7320;
            uniform float _node_7349;
            uniform sampler2D _node_2230; uniform float4 _node_2230_ST;
            uniform sampler2D _node_363; uniform float4 _node_363_ST;
            uniform float _node_313;
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
                o.pos = UnityObjectToClipPos( v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
////// Lighting:
////// Emissive:
                float4 node_2449 = _Time + _TimeEditor;
                float2 node_6250 = (i.uv0+node_2449.g*float2(0,0.1));
                float4 node_2274 = tex2D(_node_363,TRANSFORM_TEX(node_6250, _node_363));
                float2 node_763 = (i.uv0+node_2449.g*float2(0,0.2));
                float4 node_2405 = tex2D(_node_363,TRANSFORM_TEX(node_763, _node_363));
                float3 emissive = (_node_7320.rgb*(node_2274.rgb+node_2405.rgb)*_node_7349);
                float3 finalColor = emissive;
                float4 _node_2230_var = tex2D(_node_2230,TRANSFORM_TEX(i.uv0, _node_2230));
                fixed4 finalRGBA = fixed4(finalColor,lerp((node_2274.r*_node_2230_var.rgb),float3(0,0,0),_node_313).r);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
