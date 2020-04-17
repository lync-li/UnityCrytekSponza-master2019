// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Shader created with Shader Forge v1.38 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:3,bdst:7,dpts:2,wrdp:True,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:False,aust:False,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:3138,x:32955,y:32704,varname:node_3138,prsc:2|emission-4074-OUT,alpha-6251-OUT,voffset-749-OUT;n:type:ShaderForge.SFN_Tex2d,id:199,x:30665,y:33625,ptovrint:False,ptlb:mainTexture,ptin:_mainTexture,varname:_mainTexture,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:161e37723c84fc54084bca3c6451ad57,ntxv:0,isnm:False|UVIN-232-OUT;n:type:ShaderForge.SFN_Slider,id:8584,x:30474,y:34210,ptovrint:False,ptlb:disslution,ptin:_disslution,varname:_disslution,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.08854266,max:1;n:type:ShaderForge.SFN_If,id:4182,x:31200,y:33435,varname:node_4182,prsc:2|A-7774-OUT,B-3215-OUT,GT-1186-OUT,EQ-8433-OUT,LT-8433-OUT;n:type:ShaderForge.SFN_Vector1,id:1186,x:30773,y:33256,varname:node_1186,prsc:2,v1:1;n:type:ShaderForge.SFN_Vector1,id:8433,x:30727,y:33406,varname:node_8433,prsc:2,v1:0;n:type:ShaderForge.SFN_If,id:4556,x:31182,y:33706,varname:node_4556,prsc:2|A-7774-OUT,B-2395-OUT,GT-1186-OUT,EQ-8433-OUT,LT-8433-OUT;n:type:ShaderForge.SFN_Add,id:2395,x:31143,y:34384,varname:node_2395,prsc:2|A-3215-OUT,B-6175-OUT;n:type:ShaderForge.SFN_TexCoord,id:7999,x:28806,y:33633,varname:node_7999,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Multiply,id:8640,x:29746,y:33568,varname:node_8640,prsc:2|A-5743-OUT,B-9798-OUT;n:type:ShaderForge.SFN_Tex2d,id:3498,x:29348,y:33866,ptovrint:False,ptlb:truble,ptin:_truble,varname:_truble,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:10763837c64d7b5448236c0a93cd6ea1,ntxv:0,isnm:False|UVIN-378-UVOUT;n:type:ShaderForge.SFN_Add,id:9798,x:29529,y:33763,varname:node_9798,prsc:2|A-7999-UVOUT,B-3498-R;n:type:ShaderForge.SFN_Add,id:232,x:30412,y:33625,varname:node_232,prsc:2|A-8640-OUT,B-2323-OUT;n:type:ShaderForge.SFN_Panner,id:378,x:29133,y:33866,varname:node_378,prsc:2,spu:0,spv:-0.5|UVIN-7999-UVOUT;n:type:ShaderForge.SFN_Multiply,id:7774,x:30875,y:33714,varname:node_7774,prsc:2|A-199-R,B-3628-OUT;n:type:ShaderForge.SFN_Lerp,id:3717,x:32337,y:32821,varname:node_3717,prsc:2|A-1004-RGB,B-680-RGB,T-1728-OUT;n:type:ShaderForge.SFN_Color,id:1004,x:31868,y:32822,ptovrint:False,ptlb:Color_outside,ptin:_Color_outside,varname:_Color_outside,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Color,id:680,x:31714,y:32988,ptovrint:False,ptlb:Color_inside,ptin:_Color_inside,varname:_Color_inside,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0,c2:0.7517242,c3:1,c4:1;n:type:ShaderForge.SFN_Slider,id:6175,x:30693,y:34516,ptovrint:False,ptlb:width,ptin:_width,varname:_width,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.0533202,max:1;n:type:ShaderForge.SFN_SwitchProperty,id:3215,x:30857,y:34225,ptovrint:False,ptlb:input on/off,ptin:_inputonoff,varname:_inputonoff,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,on:False|A-8584-OUT,B-6179-A;n:type:ShaderForge.SFN_VertexColor,id:6179,x:30644,y:34325,varname:node_6179,prsc:2;n:type:ShaderForge.SFN_Slider,id:5743,x:29401,y:33567,ptovrint:False,ptlb:trubleStr,ptin:_trubleStr,varname:_trubleStr,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Time,id:8390,x:28554,y:32409,varname:node_8390,prsc:2;n:type:ShaderForge.SFN_Add,id:9081,x:29527,y:32454,varname:node_9081,prsc:2|A-3383-OUT,B-5040-OUT;n:type:ShaderForge.SFN_ValueProperty,id:2552,x:28531,y:32630,ptovrint:False,ptlb:U_Speed,ptin:_U_Speed,varname:_U_Speed,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Add,id:2439,x:29577,y:32665,varname:node_2439,prsc:2|A-3271-OUT,B-2247-OUT;n:type:ShaderForge.SFN_ValueProperty,id:7145,x:28551,y:32861,ptovrint:False,ptlb:V_Speed,ptin:_V_Speed,varname:_V_Speed,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_Append,id:2323,x:29934,y:32683,varname:node_2323,prsc:2|A-9081-OUT,B-2439-OUT;n:type:ShaderForge.SFN_Multiply,id:3383,x:28932,y:32451,varname:node_3383,prsc:2|A-8390-T,B-2552-OUT;n:type:ShaderForge.SFN_Multiply,id:3271,x:28932,y:32691,varname:node_3271,prsc:2|A-8390-T,B-7145-OUT;n:type:ShaderForge.SFN_Multiply,id:2247,x:29362,y:32758,varname:node_2247,prsc:2|A-7999-V,B-802-OUT;n:type:ShaderForge.SFN_ValueProperty,id:802,x:29376,y:32943,ptovrint:False,ptlb:V_Tiling,ptin:_V_Tiling,varname:_V_Tiling,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_Multiply,id:5040,x:29343,y:32491,varname:node_5040,prsc:2|A-995-OUT,B-7999-U;n:type:ShaderForge.SFN_ValueProperty,id:995,x:29077,y:32518,ptovrint:False,ptlb:U_tiling,ptin:_U_tiling,varname:_U_tiling,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_SwitchProperty,id:3699,x:29865,y:33723,ptovrint:False,ptlb:mask on/off,ptin:_maskonoff,varname:_maskonoff,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,on:False|A-7999-V,B-7999-U;n:type:ShaderForge.SFN_Add,id:3762,x:29239,y:34721,varname:node_3762,prsc:2|A-7999-UVOUT,B-8054-OUT;n:type:ShaderForge.SFN_Vector1,id:8054,x:28941,y:34826,varname:node_8054,prsc:2,v1:-0.5;n:type:ShaderForge.SFN_Length,id:2181,x:29643,y:34721,varname:node_2181,prsc:2|IN-7812-OUT;n:type:ShaderForge.SFN_Multiply,id:7812,x:29417,y:34721,varname:node_7812,prsc:2|A-3762-OUT,B-3744-OUT;n:type:ShaderForge.SFN_Vector1,id:3744,x:29195,y:34920,varname:node_3744,prsc:2,v1:2;n:type:ShaderForge.SFN_OneMinus,id:4637,x:29826,y:34721,varname:node_4637,prsc:2|IN-2181-OUT;n:type:ShaderForge.SFN_SwitchProperty,id:3628,x:30150,y:33752,ptovrint:False,ptlb:mask shape,ptin:_maskshape,varname:_maskshape,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,on:True|A-3699-OUT,B-4637-OUT;n:type:ShaderForge.SFN_NormalVector,id:2821,x:30354,y:32062,prsc:2,pt:False;n:type:ShaderForge.SFN_ViewVector,id:9882,x:30432,y:32204,varname:node_9882,prsc:2;n:type:ShaderForge.SFN_Dot,id:7239,x:30616,y:32115,varname:node_7239,prsc:2,dt:0|A-2821-OUT,B-9882-OUT;n:type:ShaderForge.SFN_Round,id:9180,x:30979,y:32196,varname:node_9180,prsc:2|IN-5688-OUT;n:type:ShaderForge.SFN_OneMinus,id:1327,x:31160,y:32151,varname:node_1327,prsc:2|IN-9180-OUT;n:type:ShaderForge.SFN_Add,id:4074,x:32540,y:32712,varname:node_4074,prsc:2|A-7585-OUT,B-3717-OUT;n:type:ShaderForge.SFN_Add,id:1521,x:32337,y:33050,varname:node_1521,prsc:2|A-1327-OUT,B-4182-OUT;n:type:ShaderForge.SFN_Clamp01,id:6251,x:32523,y:33050,varname:node_6251,prsc:2|IN-1521-OUT;n:type:ShaderForge.SFN_Multiply,id:96,x:30683,y:32300,varname:node_96,prsc:2|A-7239-OUT,B-7026-OUT;n:type:ShaderForge.SFN_Slider,id:7026,x:30148,y:32394,ptovrint:False,ptlb:outLineStr,ptin:_outLineStr,varname:node_7026,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:2,max:2;n:type:ShaderForge.SFN_Multiply,id:7585,x:31313,y:32002,varname:node_7585,prsc:2|A-4359-RGB,B-1327-OUT;n:type:ShaderForge.SFN_Color,id:4359,x:30989,y:31909,ptovrint:False,ptlb:ouLineCol,ptin:_ouLineCol,varname:node_4359,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0,c2:0.7976673,c3:0.9558824,c4:1;n:type:ShaderForge.SFN_Add,id:6402,x:31524,y:33672,varname:node_6402,prsc:2|A-1327-OUT,B-4556-OUT;n:type:ShaderForge.SFN_Clamp01,id:1728,x:31723,y:33672,varname:node_1728,prsc:2|IN-6402-OUT;n:type:ShaderForge.SFN_FragmentPosition,id:8479,x:32301,y:33369,varname:node_8479,prsc:2;n:type:ShaderForge.SFN_Transform,id:1986,x:32495,y:33369,varname:node_1986,prsc:2,tffrom:0,tfto:1|IN-8479-XYZ;n:type:ShaderForge.SFN_Multiply,id:749,x:32788,y:33381,varname:node_749,prsc:2|A-1986-XYZ,B-4454-OUT,C-3193-RGB;n:type:ShaderForge.SFN_Tex2d,id:3193,x:32333,y:33558,ptovrint:False,ptlb:trubTex,ptin:_trubTex,varname:node_3193,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False|UVIN-6700-UVOUT;n:type:ShaderForge.SFN_Slider,id:4454,x:32593,y:33665,ptovrint:False,ptlb:trubStr,ptin:_trubStr,varname:node_4454,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Clamp01,id:5688,x:30833,y:32423,varname:node_5688,prsc:2|IN-96-OUT;n:type:ShaderForge.SFN_Panner,id:6700,x:32168,y:33558,varname:node_6700,prsc:2,spu:0,spv:0.5|UVIN-4939-UVOUT;n:type:ShaderForge.SFN_TexCoord,id:4939,x:31982,y:33624,varname:node_4939,prsc:2,uv:0,uaff:False;proporder:1004-680-199-995-802-2552-7145-3498-6175-3215-8584-5743-3628-3699-7026-4359-3193-4454;pass:END;sub:END;*/

Shader "Shader Forge/FX_Dissolve5 New" {
    Properties {
        _Color_outside ("Color_outside", Color) = (1,1,1,1)
        _Color_inside ("Color_inside", Color) = (0,0.7517242,1,1)
        _mainTexture ("mainTexture", 2D) = "white" {}
        _U_tiling ("U_tiling", Float ) = 1
        _V_Tiling ("V_Tiling", Float ) = 1
        _U_Speed ("U_Speed", Float ) = 0
        _V_Speed ("V_Speed", Float ) = 1
        _truble ("truble", 2D) = "white" {}
        _width ("width", Range(0, 1)) = 0.0533202
        [MaterialToggle] _inputonoff ("input on/off", Float ) = 0.08854266
        _disslution ("disslution", Range(0, 1)) = 0.08854266
        _trubleStr ("trubleStr", Range(0, 1)) = 0
        [MaterialToggle] _maskshape ("mask shape", Float ) = -0.4142135
        [MaterialToggle] _maskonoff ("mask on/off", Float ) = 0
        _outLineStr ("outLineStr", Range(0, 2)) = 2
        _ouLineCol ("ouLineCol", Color) = (0,0.7976673,0.9558824,1)
        _trubTex ("trubTex", 2D) = "white" {}
        _trubStr ("trubStr", Range(0, 1)) = 0
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
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            uniform sampler2D _mainTexture; uniform float4 _mainTexture_ST;
            uniform float _disslution;
            uniform sampler2D _truble; uniform float4 _truble_ST;
            uniform float4 _Color_outside;
            uniform float4 _Color_inside;
            uniform float _width;
            uniform fixed _inputonoff;
            uniform float _trubleStr;
            uniform float _U_Speed;
            uniform float _V_Speed;
            uniform float _V_Tiling;
            uniform float _U_tiling;
            uniform fixed _maskonoff;
            uniform fixed _maskshape;
            uniform float _outLineStr;
            uniform float4 _ouLineCol;
            uniform sampler2D _trubTex; uniform float4 _trubTex_ST;
            uniform float _trubStr;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
                float4 vertexColor : COLOR;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                float4 vertexColor : COLOR;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.vertexColor = v.vertexColor;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                float4 node_1981 = _Time;
                float2 node_6700 = (o.uv0+node_1981.g*float2(0,0.5));
                float4 _trubTex_var = tex2Dlod(_trubTex,float4(TRANSFORM_TEX(node_6700, _trubTex),0.0,0));
                v.vertex.xyz += (mul( unity_WorldToObject, float4(mul(unity_ObjectToWorld, v.vertex).rgb,1) ).xyz.rgb*_trubStr*_trubTex_var.rgb);
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
                float node_1327 = (1.0 - round(saturate((dot(i.normalDir,viewDirection)*_outLineStr))));
                float4 node_1981 = _Time;
                float2 node_378 = (i.uv0+node_1981.g*float2(0,-0.5));
                float4 _truble_var = tex2D(_truble,TRANSFORM_TEX(node_378, _truble));
                float4 node_8390 = _Time;
                float2 node_232 = ((_trubleStr*(i.uv0+_truble_var.r))+float2(((node_8390.g*_U_Speed)+(_U_tiling*i.uv0.r)),((node_8390.g*_V_Speed)+(i.uv0.g*_V_Tiling))));
                float4 _mainTexture_var = tex2D(_mainTexture,TRANSFORM_TEX(node_232, _mainTexture));
                float node_7774 = (_mainTexture_var.r*lerp( lerp( i.uv0.g, i.uv0.r, _maskonoff ), (1.0 - length(((i.uv0+(-0.5))*2.0))), _maskshape ));
                float _inputonoff_var = lerp( _disslution, i.vertexColor.a, _inputonoff );
                float node_4556_if_leA = step(node_7774,(_inputonoff_var+_width));
                float node_4556_if_leB = step((_inputonoff_var+_width),node_7774);
                float node_8433 = 0.0;
                float node_1186 = 1.0;
                float3 emissive = ((_ouLineCol.rgb*node_1327)+lerp(_Color_outside.rgb,_Color_inside.rgb,saturate((node_1327+lerp((node_4556_if_leA*node_8433)+(node_4556_if_leB*node_1186),node_8433,node_4556_if_leA*node_4556_if_leB)))));
                float3 finalColor = emissive;
                float node_4182_if_leA = step(node_7774,_inputonoff_var);
                float node_4182_if_leB = step(_inputonoff_var,node_7774);
                return fixed4(finalColor,saturate((node_1327+lerp((node_4182_if_leA*node_8433)+(node_4182_if_leB*node_1186),node_8433,node_4182_if_leA*node_4182_if_leB))));
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
            uniform sampler2D _trubTex; uniform float4 _trubTex_ST;
            uniform float _trubStr;
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
                float4 node_1675 = _Time;
                float2 node_6700 = (o.uv0+node_1675.g*float2(0,0.5));
                float4 _trubTex_var = tex2Dlod(_trubTex,float4(TRANSFORM_TEX(node_6700, _trubTex),0.0,0));
                v.vertex.xyz += (mul( unity_WorldToObject, float4(mul(unity_ObjectToWorld, v.vertex).rgb,0) ).xyz.rgb*_trubStr*_trubTex_var.rgb);
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
