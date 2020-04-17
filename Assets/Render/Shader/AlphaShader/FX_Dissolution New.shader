// Shader created with Shader Forge v1.38 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:3,bdst:7,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:False,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:3138,x:32827,y:32687,varname:node_3138,prsc:2|emission-9660-OUT,alpha-4447-OUT;n:type:ShaderForge.SFN_Color,id:7241,x:32343,y:32670,ptovrint:False,ptlb:Color,ptin:_Color,varname:_Color,prsc:2,glob:False,taghide:False,taghdr:True,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_If,id:4960,x:32281,y:32905,varname:node_4960,prsc:2|A-3880-R,B-545-OUT,GT-916-OUT,EQ-916-OUT,LT-5786-OUT;n:type:ShaderForge.SFN_Tex2d,id:3880,x:31949,y:32709,ptovrint:False,ptlb:dissolution,ptin:_dissolution,varname:_dissolution,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:3dce377c7ee86104cb449af8a986ddc3,ntxv:0,isnm:False|UVIN-7079-OUT;n:type:ShaderForge.SFN_Vector1,id:5786,x:32067,y:33125,varname:node_5786,prsc:2,v1:0;n:type:ShaderForge.SFN_Vector1,id:916,x:32051,y:32990,varname:node_916,prsc:2,v1:1;n:type:ShaderForge.SFN_Tex2d,id:1624,x:32313,y:32400,ptovrint:False,ptlb:mainTexture,ptin:_mainTexture,varname:_mainTexture,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:6ffa47c5bc9359042922240310afa0cf,ntxv:0,isnm:False|UVIN-7079-OUT;n:type:ShaderForge.SFN_Multiply,id:9660,x:32615,y:32510,varname:node_9660,prsc:2|A-1624-RGB,B-434-RGB,C-7241-RGB;n:type:ShaderForge.SFN_Slider,id:5351,x:31760,y:32941,ptovrint:False,ptlb:dissolution_strange,ptin:_dissolution_strange,varname:_dissolution_strange,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.710444,max:1;n:type:ShaderForge.SFN_Multiply,id:4447,x:32607,y:32907,varname:node_4447,prsc:2|A-4960-OUT,B-1624-A,C-6073-OUT;n:type:ShaderForge.SFN_VertexColor,id:434,x:31838,y:32493,varname:node_434,prsc:2;n:type:ShaderForge.SFN_SwitchProperty,id:545,x:32166,y:32650,ptovrint:False,ptlb:test_off/on,ptin:_test_offon,varname:_test_offon,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,on:False|A-434-A,B-5351-OUT;n:type:ShaderForge.SFN_TexCoord,id:2985,x:30925,y:32707,varname:node_2985,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Time,id:8445,x:31079,y:32381,varname:node_8445,prsc:2;n:type:ShaderForge.SFN_ValueProperty,id:6715,x:31053,y:32584,ptovrint:False,ptlb:U,ptin:_U,varname:_U,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Multiply,id:6661,x:31268,y:32472,varname:node_6661,prsc:2|A-8445-T,B-6715-OUT;n:type:ShaderForge.SFN_Multiply,id:7593,x:31224,y:32920,varname:node_7593,prsc:2|A-8445-T,B-5872-OUT;n:type:ShaderForge.SFN_ValueProperty,id:5872,x:31007,y:32987,ptovrint:False,ptlb:V,ptin:_V,varname:_V,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_Append,id:7079,x:31604,y:32679,varname:node_7079,prsc:2|A-5045-OUT,B-7717-OUT;n:type:ShaderForge.SFN_Add,id:5045,x:31451,y:32558,varname:node_5045,prsc:2|A-6661-OUT,B-2985-U;n:type:ShaderForge.SFN_Add,id:7717,x:31421,y:32761,varname:node_7717,prsc:2|A-2985-V,B-7593-OUT;n:type:ShaderForge.SFN_SwitchProperty,id:6073,x:32391,y:33157,ptovrint:False,ptlb:fangxiang_UV,ptin:_fangxiang_UV,varname:_fangxiang_UV,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,on:False|A-2985-U,B-2985-V;proporder:7241-3880-1624-545-5351-6715-5872-6073;pass:END;sub:END;*/

Shader "Joesph/FX_Dissolution New" {
    Properties {
        [HDR]_Color ("Color", Color) = (1,1,1,1)
        _dissolution ("dissolution", 2D) = "white" {}
        _mainTexture ("mainTexture", 2D) = "white" {}
        [MaterialToggle] _test_offon ("test_off/on", Float ) = 0
        _dissolution_strange ("dissolution_strange", Range(0, 1)) = 0.710444
        _U ("U", Float ) = 0
        _V ("V", Float ) = 1
        [MaterialToggle] _fangxiang_UV ("fangxiang_UV", Float ) = 0
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
            uniform float4 _Color;
            uniform sampler2D _dissolution; uniform float4 _dissolution_ST;
            uniform sampler2D _mainTexture; uniform float4 _mainTexture_ST;
            uniform float _dissolution_strange;
            uniform fixed _test_offon;
            uniform float _U;
            uniform float _V;
            uniform fixed _fangxiang_UV;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
                float4 vertexColor : COLOR;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 vertexColor : COLOR;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.vertexColor = v.vertexColor;
                o.pos = UnityObjectToClipPos( v.vertex );
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
////// Lighting:
////// Emissive:
                float4 node_8445 = _Time;
                float node_6661 = (node_8445.g*_U);
                float node_7593 = (node_8445.g*_V);
                float2 node_7079 = float2((node_6661+i.uv0.r),(i.uv0.g+node_7593));
                float4 _mainTexture_var = tex2D(_mainTexture,TRANSFORM_TEX(node_7079, _mainTexture));
                float3 emissive = (_mainTexture_var.rgb*i.vertexColor.rgb*_Color.rgb);
                float3 finalColor = emissive;
                float4 _dissolution_var = tex2D(_dissolution,TRANSFORM_TEX(node_7079, _dissolution));
                float node_4960_if_leA = step(_dissolution_var.r,lerp( i.vertexColor.a, _dissolution_strange, _test_offon ));
                float node_4960_if_leB = step(lerp( i.vertexColor.a, _dissolution_strange, _test_offon ),_dissolution_var.r);
                float node_916 = 1.0;
                return fixed4(finalColor,(lerp((node_4960_if_leA*0.0)+(node_4960_if_leB*node_916),node_916,node_4960_if_leA*node_4960_if_leB)*_mainTexture_var.a*lerp( i.uv0.r, i.uv0.g, _fangxiang_UV )));
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
