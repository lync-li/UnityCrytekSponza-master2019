// Shader created with Shader Forge v1.37 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.37;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:3,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:True,hqlp:False,rprd:True,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:False,qofs:0,qpre:2,rntp:3,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.653505,fgcg:0.6125649,fgcb:0.7573529,fgca:1,fgde:0.01,fgrn:13.95,fgrf:32.5,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:2865,x:34537,y:32459,varname:node_2865,prsc:2|diff-2361-OUT,spec-59-OUT,gloss-210-OUT,normal-4623-OUT,emission-9114-OUT,transm-1301-RGB,lwrap-4676-OUT,amspl-9710-OUT,clip-3310-OUT,olwid-2601-OUT;n:type:ShaderForge.SFN_Multiply,id:6343,x:32041,y:32231,varname:node_6343,prsc:2|A-7736-RGB,B-6665-RGB;n:type:ShaderForge.SFN_Color,id:6665,x:31225,y:32447,ptovrint:False,ptlb:Color,ptin:_Color,varname:_Color,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5019608,c2:0.5019608,c3:0.5019608,c4:1;n:type:ShaderForge.SFN_Tex2d,id:7736,x:31435,y:32186,ptovrint:True,ptlb:Base Color,ptin:_MainTex,varname:_MainTex,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Tex2d,id:5964,x:32049,y:32937,ptovrint:True,ptlb:Normal Map,ptin:_BumpMap,varname:_BumpMap,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:3,isnm:True;n:type:ShaderForge.SFN_Slider,id:358,x:31910,y:33431,ptovrint:False,ptlb:Metallic,ptin:_Metallic,varname:node_358,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:1,max:1;n:type:ShaderForge.SFN_Slider,id:1813,x:31678,y:33182,ptovrint:False,ptlb:Gloss,ptin:_Gloss,varname:_Metallic_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Tex2d,id:6731,x:31122,y:33014,ptovrint:False,ptlb:node_6731,ptin:_node_6731,varname:node_6731,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Blend,id:8301,x:32471,y:32353,varname:node_8301,prsc:2,blmd:1,clmp:True|SRC-6343-OUT,DST-1715-OUT;n:type:ShaderForge.SFN_Multiply,id:210,x:32530,y:32673,varname:node_210,prsc:2|A-1813-OUT,B-6731-G;n:type:ShaderForge.SFN_Power,id:8342,x:31888,y:32586,varname:node_8342,prsc:2|VAL-6731-R,EXP-3245-OUT;n:type:ShaderForge.SFN_Slider,id:3245,x:31024,y:32751,ptovrint:False,ptlb:node_3245,ptin:_node_3245,varname:node_3245,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Blend,id:1715,x:32199,y:32607,varname:node_1715,prsc:2,blmd:8,clmp:True|SRC-8342-OUT,DST-2689-RGB;n:type:ShaderForge.SFN_Color,id:2689,x:31618,y:32822,ptovrint:False,ptlb:node_2689,ptin:_node_2689,varname:node_2689,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Color,id:6104,x:33242,y:33176,ptovrint:False,ptlb:sss,ptin:_sss,varname:node_6104,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Color,id:1301,x:33440,y:32372,ptovrint:False,ptlb:tr,ptin:_tr,varname:node_1301,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Lerp,id:4623,x:32752,y:32952,varname:node_4623,prsc:2|A-5964-RGB,B-2560-OUT,T-3487-OUT;n:type:ShaderForge.SFN_Slider,id:3487,x:32024,y:33257,ptovrint:False,ptlb:node_3487,ptin:_node_3487,varname:node_3487,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Tex2d,id:6945,x:32471,y:33424,ptovrint:False,ptlb:node_6945,ptin:_node_6945,varname:node_6945,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:c1cc9133aa06f434fb882bc16cf197dc,ntxv:3,isnm:True;n:type:ShaderForge.SFN_Blend,id:2560,x:32748,y:33285,varname:node_2560,prsc:2,blmd:5,clmp:True|SRC-5964-RGB,DST-6945-RGB;n:type:ShaderForge.SFN_Dot,id:3031,x:32638,y:31579,cmnt:Lambert,varname:node_3031,prsc:2,dt:1|A-245-OUT,B-8821-OUT;n:type:ShaderForge.SFN_Dot,id:3841,x:32638,y:31738,cmnt:Blinn-Phong,varname:node_3841,prsc:2,dt:1|A-8821-OUT,B-4839-OUT;n:type:ShaderForge.SFN_NormalVector,id:8821,x:32426,y:31664,prsc:2,pt:True;n:type:ShaderForge.SFN_LightVector,id:245,x:32426,y:31536,varname:node_245,prsc:2;n:type:ShaderForge.SFN_HalfVector,id:4839,x:32426,y:31815,varname:node_4839,prsc:2;n:type:ShaderForge.SFN_Power,id:9867,x:32833,y:31805,varname:node_9867,prsc:2|VAL-3841-OUT,EXP-1098-OUT;n:type:ShaderForge.SFN_Slider,id:1098,x:32338,y:32115,ptovrint:False,ptlb:Gloss2,ptin:_Gloss2,varname:_Gloss_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:10,cur:10,max:200;n:type:ShaderForge.SFN_Multiply,id:8034,x:33111,y:31752,cmnt:Specular Contribution,varname:node_8034,prsc:2|A-3031-OUT,B-9867-OUT;n:type:ShaderForge.SFN_Add,id:1633,x:33404,y:32162,varname:node_1633,prsc:2|A-6105-OUT,B-8301-OUT;n:type:ShaderForge.SFN_Multiply,id:6105,x:33143,y:31897,varname:node_6105,prsc:2|A-8034-OUT,B-1515-RGB;n:type:ShaderForge.SFN_Color,id:1515,x:33005,y:32056,ptovrint:False,ptlb:node_1515,ptin:_node_1515,varname:node_1515,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Tex2d,id:2233,x:32712,y:33506,ptovrint:False,ptlb:node_2233,ptin:_node_2233,varname:node_2233,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Multiply,id:9114,x:34270,y:33686,varname:node_9114,prsc:2|A-5513-OUT,B-4730-RGB;n:type:ShaderForge.SFN_Color,id:4730,x:33543,y:34093,ptovrint:False,ptlb:node_4730,ptin:_node_4730,varname:node_4730,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_TexCoord,id:219,x:32967,y:34154,varname:node_219,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Panner,id:7625,x:33244,y:34222,varname:node_7625,prsc:2,spu:0,spv:0.01|UVIN-219-UVOUT;n:type:ShaderForge.SFN_Tex2d,id:6730,x:33374,y:33907,ptovrint:False,ptlb:node_6730,ptin:_node_6730,varname:node_6730,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False|UVIN-7625-UVOUT;n:type:ShaderForge.SFN_Slider,id:8048,x:32349,y:33794,ptovrint:False,ptlb:node_8048,ptin:_node_8048,varname:node_8048,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:100;n:type:ShaderForge.SFN_Multiply,id:5513,x:33529,y:33539,varname:node_5513,prsc:2|A-2233-RGB,B-2351-OUT,C-6730-RGB;n:type:ShaderForge.SFN_Cubemap,id:1303,x:33936,y:33376,ptovrint:False,ptlb:node_1303,ptin:_node_1303,varname:node_1303,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,pvfc:0|MIP-345-OUT;n:type:ShaderForge.SFN_Slider,id:345,x:33564,y:33367,ptovrint:False,ptlb:node_345,ptin:_node_345,varname:node_345,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:10;n:type:ShaderForge.SFN_Multiply,id:9710,x:34195,y:33071,varname:node_9710,prsc:2|A-1303-RGB,B-6746-OUT,C-6731-B;n:type:ShaderForge.SFN_Slider,id:6746,x:33640,y:33180,ptovrint:False,ptlb:node_6746,ptin:_node_6746,varname:node_6746,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:10;n:type:ShaderForge.SFN_Multiply,id:59,x:33087,y:33107,varname:node_59,prsc:2|A-358-OUT,B-6731-B;n:type:ShaderForge.SFN_Multiply,id:4676,x:33548,y:32955,varname:node_4676,prsc:2|A-6104-RGB,B-194-OUT,C-7736-A;n:type:ShaderForge.SFN_Slider,id:194,x:32994,y:33399,ptovrint:False,ptlb:node_194,ptin:_node_194,varname:node_194,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:10;n:type:ShaderForge.SFN_Tex2d,id:5518,x:33228,y:32636,ptovrint:False,ptlb:node_5518,ptin:_node_5518,varname:node_5518,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:3,isnm:False;n:type:ShaderForge.SFN_Multiply,id:2428,x:33715,y:32828,varname:node_2428,prsc:2|A-5518-B,B-1155-OUT;n:type:ShaderForge.SFN_Slider,id:1155,x:33262,y:32852,ptovrint:False,ptlb:node_1155,ptin:_node_1155,varname:node_1155,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:10;n:type:ShaderForge.SFN_Power,id:3310,x:33782,y:32650,varname:node_3310,prsc:2|VAL-5518-R,EXP-1155-OUT;n:type:ShaderForge.SFN_Slider,id:2601,x:33868,y:32992,ptovrint:False,ptlb:node_2601,ptin:_node_2601,varname:node_2601,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Lerp,id:5588,x:32946,y:33478,varname:node_5588,prsc:2|A-2233-RGB,B-7591-OUT,T-6226-OUT;n:type:ShaderForge.SFN_Vector3,id:7591,x:32712,y:33722,varname:node_7591,prsc:2,v1:1,v2:1,v3:1;n:type:ShaderForge.SFN_Slider,id:6226,x:32300,y:33646,ptovrint:False,ptlb:node_6226,ptin:_node_6226,varname:node_6226,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Add,id:2401,x:34030,y:32010,varname:node_2401,prsc:2|A-1633-OUT,B-8120-OUT;n:type:ShaderForge.SFN_Fresnel,id:6838,x:33686,y:31703,varname:node_6838,prsc:2|NRM-8821-OUT,EXP-9826-OUT;n:type:ShaderForge.SFN_Slider,id:9826,x:33320,y:31826,ptovrint:False,ptlb:rim_power,ptin:_rim_power,varname:node_9826,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:2.925201,max:10;n:type:ShaderForge.SFN_Color,id:4281,x:33492,y:31954,ptovrint:False,ptlb:rim_color,ptin:_rim_color,varname:node_4281,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Multiply,id:8120,x:33898,y:31859,varname:node_8120,prsc:2|A-6838-OUT,B-4281-RGB,C-2684-OUT;n:type:ShaderForge.SFN_Lerp,id:2361,x:34232,y:32163,varname:node_2361,prsc:2|A-1633-OUT,B-2401-OUT,T-5673-OUT;n:type:ShaderForge.SFN_Vector1,id:2684,x:33660,y:31998,varname:node_2684,prsc:2,v1:3;n:type:ShaderForge.SFN_Slider,id:5673,x:33741,y:32313,ptovrint:False,ptlb:rim_range,ptin:_rim_range,varname:node_5673,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:5;n:type:ShaderForge.SFN_SwitchProperty,id:2351,x:33270,y:33630,ptovrint:False,ptlb:BodyFlash,ptin:_BodyFlash,varname:node_2351,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,on:False|A-8048-OUT,B-6978-OUT;n:type:ShaderForge.SFN_Sin,id:1842,x:32803,y:34021,varname:node_1842,prsc:2|IN-4189-TDB;n:type:ShaderForge.SFN_Time,id:4189,x:32427,y:34117,varname:node_4189,prsc:2;n:type:ShaderForge.SFN_Slider,id:2939,x:32594,y:33897,ptovrint:False,ptlb:node_2939,ptin:_node_2939,varname:node_2939,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:20;n:type:ShaderForge.SFN_Multiply,id:4684,x:32977,y:33838,varname:node_4684,prsc:2|A-2939-OUT,B-1842-OUT;n:type:ShaderForge.SFN_ConstantClamp,id:6978,x:33186,y:33838,varname:node_6978,prsc:2,min:0,max:50|IN-4684-OUT;proporder:5964-6665-7736-358-1813-6731-3245-2689-6104-1301-3487-6945-1098-1515-2233-4730-6730-8048-1303-345-6746-194-5518-1155-2601-6226-9826-4281-5673-2351-2939;pass:END;sub:END;*/

Shader "Shader Forge/skin_long" {
    Properties {
        _BumpMap ("Normal Map", 2D) = "bump" {}
        _Color ("Color", Color) = (0.5019608,0.5019608,0.5019608,1)
        _MainTex ("Base Color", 2D) = "white" {}
        _Metallic ("Metallic", Range(0, 1)) = 1
        _Gloss ("Gloss", Range(0, 1)) = 0
        _node_6731 ("node_6731", 2D) = "white" {}
        _node_3245 ("node_3245", Range(0, 1)) = 0
        _node_2689 ("node_2689", Color) = (0.5,0.5,0.5,1)
        _sss ("sss", Color) = (0.5,0.5,0.5,1)
        _tr ("tr", Color) = (0.5,0.5,0.5,1)
        _node_3487 ("node_3487", Range(0, 1)) = 0
        _node_6945 ("node_6945", 2D) = "bump" {}
        _Gloss2 ("Gloss2", Range(10, 200)) = 10
        _node_1515 ("node_1515", Color) = (0.5,0.5,0.5,1)
        _node_2233 ("node_2233", 2D) = "white" {}
        _node_4730 ("node_4730", Color) = (0.5,0.5,0.5,1)
        _node_6730 ("node_6730", 2D) = "white" {}
        _node_8048 ("node_8048", Range(0, 100)) = 0
        _node_1303 ("node_1303", Cube) = "_Skybox" {}
        _node_345 ("node_345", Range(0, 10)) = 0
        _node_6746 ("node_6746", Range(0, 10)) = 0
        _node_194 ("node_194", Range(0, 10)) = 0
        _node_5518 ("node_5518", 2D) = "bump" {}
        _node_1155 ("node_1155", Range(0, 10)) = 0
        _node_2601 ("node_2601", Range(0, 1)) = 0
        _node_6226 ("node_6226", Range(0, 1)) = 0
        _rim_power ("rim_power", Range(0, 10)) = 2.925201
        _rim_color ("rim_color", Color) = (0.5,0.5,0.5,1)
        _rim_range ("rim_range", Range(0, 5)) = 0
        [MaterialToggle] _BodyFlash ("BodyFlash", Float ) = 0
        _node_2939 ("node_2939", Range(0, 20)) = 0
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "Queue"="AlphaTest"
            "RenderType"="TransparentCutout"
        }
		LOD 500
        Pass {
            Name "Outline"
            Tags {
            }
			
			
            Cull Front
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag		
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "UnityPBSLighting.cginc"
            #include "UnityStandardBRDF.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_fog
            //#pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            uniform sampler2D _node_5518; uniform float4 _node_5518_ST;
            uniform float _node_1155;
            uniform float _node_2601;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float2 uv1 : TEXCOORD1;
                float2 uv2 : TEXCOORD2;
                float4 posWorld : TEXCOORD3;
                UNITY_FOG_COORDS(4)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.uv1 = v.texcoord1;
                o.uv2 = v.texcoord2;
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos( float4(v.vertex.xyz + v.normal*_node_2601,1) );
                UNITY_TRANSFER_FOG(o,o.pos);
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float4 _node_5518_var = tex2D(_node_5518,TRANSFORM_TEX(i.uv0, _node_5518));
                clip(pow(_node_5518_var.r,_node_1155) - 0.5);
                return fixed4(float3(0,0,0),0);
            }
            ENDCG
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Cull Off
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define SHOULD_SAMPLE_SH 1
			#define LIGHTMAP_OFF 1
            #define _GLOSSYENV 1
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #include "Lighting.cginc"
            #include "UnityPBSLighting.cginc"
            #include "UnityStandardBRDF.cginc"    
		 #pragma multi_compile_fwdbase_fullshadows
            #pragma multi_compile DIRLIGHTMAP_OFF DIRLIGHTMAP_COMBINED DIRLIGHTMAP_SEPARATE
            #pragma multi_compile DYNAMICLIGHTMAP_OFF DYNAMICLIGHTMAP_ON
            #pragma multi_compile_fog
            //#pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            uniform float4 _TimeEditor;
            uniform float4 _Color;
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform sampler2D _BumpMap; uniform float4 _BumpMap_ST;
            uniform float _Metallic;
            uniform float _Gloss;
            uniform sampler2D _node_6731; uniform float4 _node_6731_ST;
            uniform float _node_3245;
            uniform float4 _node_2689;
            uniform float4 _sss;
            uniform float4 _tr;
            uniform float _node_3487;
            uniform sampler2D _node_6945; uniform float4 _node_6945_ST;
            uniform float _Gloss2;
            uniform float4 _node_1515;
            uniform sampler2D _node_2233; uniform float4 _node_2233_ST;
            uniform float4 _node_4730;
            uniform sampler2D _node_6730; uniform float4 _node_6730_ST;
            uniform float _node_8048;
            uniform samplerCUBE _node_1303;
            uniform float _node_345;
            uniform float _node_6746;
            uniform float _node_194;
            uniform sampler2D _node_5518; uniform float4 _node_5518_ST;
            uniform float _node_1155;
            uniform float _rim_power;
            uniform float4 _rim_color;
            uniform float _rim_range;
            uniform fixed _BodyFlash;
            uniform float _node_2939;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                float3 tangentDir : TEXCOORD3;
                float3 bitangentDir : TEXCOORD4;
                LIGHTING_COORDS(5,6)
                UNITY_FOG_COORDS(7)
                #if defined(UNITY_SHOULD_SAMPLE_SH)
                    float4 ambientOrLightmapUV : TEXCOORD8;
                #endif
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                #ifdef LIGHTMAP_ON
                    o.ambientOrLightmapUV.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
                    o.ambientOrLightmapUV.zw = 0;
                #elif UNITY_SHOULD_SAMPLE_SH
                #endif
                #ifdef DYNAMICLIGHTMAP_ON
                    o.ambientOrLightmapUV.zw = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
                #endif
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.tangentDir = normalize( mul( unity_ObjectToWorld, float4( v.tangent.xyz, 0.0 ) ).xyz );
                o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos( v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                i.normalDir = normalize(i.normalDir);
                i.normalDir *= faceSign;
                float3x3 tangentTransform = float3x3( i.tangentDir, i.bitangentDir, i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 _BumpMap_var = UnpackNormal(tex2D(_BumpMap,TRANSFORM_TEX(i.uv0, _BumpMap)));
                float3 _node_6945_var = UnpackNormal(tex2D(_node_6945,TRANSFORM_TEX(i.uv0, _node_6945)));
                float3 normalLocal = lerp(_BumpMap_var.rgb,saturate(max(_BumpMap_var.rgb,_node_6945_var.rgb)),_node_3487);
                float3 normalDirection = normalize(mul( normalLocal, tangentTransform )); // Perturbed normals
                float3 viewReflectDirection = reflect( -viewDirection, normalDirection );
                float4 _node_5518_var = tex2D(_node_5518,TRANSFORM_TEX(i.uv0, _node_5518));
                clip(pow(_node_5518_var.r,_node_1155) - 0.5);
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float3 lightColor = _LightColor0.rgb;
                float3 halfDirection = normalize(viewDirection+lightDirection);
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float3 attenColor = attenuation * _LightColor0.xyz;
                float Pi = 3.141592654;
                float InvPi = 0.31830988618;
///////// Gloss:
                float4 _node_6731_var = tex2D(_node_6731,TRANSFORM_TEX(i.uv0, _node_6731));
                float gloss = (_Gloss*_node_6731_var.g);
                float perceptualRoughness = 1.0 - (_Gloss*_node_6731_var.g);
                float roughness = perceptualRoughness * perceptualRoughness;
                float specPow = exp2( gloss * 10.0 + 1.0 );
/////// GI Data:
                UnityLight light;
				
                    light.color = lightColor;
                    light.dir = lightDirection;
                    light.ndotl = LambertTerm (normalDirection, light.dir);
  
                UnityGIInput d = (UnityGIInput)0;
                d.light = light;
                d.worldPos = i.posWorld.xyz;
                d.worldViewDir = viewDirection;
                d.atten = attenuation;
                #if defined(LIGHTMAP_ON) || defined(DYNAMICLIGHTMAP_ON)
                    d.ambient = 0;
                    d.lightmapUV = i.ambientOrLightmapUV;
                #else
                    d.ambient = i.ambientOrLightmapUV;
                #endif
              
                d.probeHDR[0] = unity_SpecCube0_HDR;
                d.probeHDR[1] = unity_SpecCube1_HDR;
                Unity_GlossyEnvironmentData ugls_en_data;
                ugls_en_data.roughness = 1.0 - gloss;
                ugls_en_data.reflUVW = viewReflectDirection;
                UnityGI gi = UnityGlobalIllumination(d, 1, normalDirection, ugls_en_data );
                lightDirection = gi.light.dir;
                lightColor = gi.light.color;
////// Specular:
                float NdotL = saturate(dot( normalDirection, lightDirection ));
                float LdotH = saturate(dot(lightDirection, halfDirection));
                float3 specularColor = (_Metallic*_node_6731_var.b);
                float specularMonochrome;
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(i.uv0, _MainTex));
                float3 node_1633 = (((max(0,dot(lightDirection,normalDirection))*pow(max(0,dot(normalDirection,halfDirection)),_Gloss2))*_node_1515.rgb)+saturate(((_MainTex_var.rgb*_Color.rgb)*saturate((pow(_node_6731_var.r,_node_3245)+_node_2689.rgb)))));
                float3 diffuseColor = lerp(node_1633,(node_1633+(pow(1.0-max(0,dot(normalDirection, viewDirection)),_rim_power)*_rim_color.rgb*3.0)),_rim_range); // Need this for specular when using metallic
                diffuseColor = DiffuseAndSpecularFromMetallic( diffuseColor, specularColor, specularColor, specularMonochrome );
                specularMonochrome = 1.0-specularMonochrome;
                float NdotV = abs(dot( normalDirection, viewDirection ));
                float NdotH = saturate(dot( normalDirection, halfDirection ));
                float VdotH = saturate(dot( viewDirection, halfDirection ));
                float visTerm = SmithJointGGXVisibilityTerm( NdotL, NdotV, roughness );
                float normTerm = GGXTerm(NdotH, roughness);
                float specularPBL = (visTerm*normTerm) * UNITY_PI;
                #ifdef UNITY_COLORSPACE_GAMMA
                    specularPBL = sqrt(max(1e-4h, specularPBL));
                #endif
                specularPBL = max(0, specularPBL * NdotL);
                #if defined(_SPECULARHIGHLIGHTS_OFF)
                    specularPBL = 0.0;
                #endif
                half surfaceReduction;
                #ifdef UNITY_COLORSPACE_GAMMA
                    surfaceReduction = 1.0-0.28*roughness*perceptualRoughness;
                #else
                    surfaceReduction = 1.0/(roughness*roughness + 1.0);
                #endif
                specularPBL *= any(specularColor) ? 1.0 : 0.0;
                float3 directSpecular = attenColor*specularPBL*FresnelTerm(specularColor, LdotH);
                half grazingTerm = saturate( gloss + specularMonochrome );
                float3 indirectSpecular = (gi.indirect.specular + (texCUBElod(_node_1303,float4(viewReflectDirection,_node_345)).rgb*_node_6746*_node_6731_var.b));
                indirectSpecular *= FresnelLerp (specularColor, grazingTerm, NdotV);
                indirectSpecular *= surfaceReduction;
                float3 specular = (directSpecular + indirectSpecular);
/////// Diffuse:
                NdotL = dot( normalDirection, lightDirection );
                float3 w = (_sss.rgb*_node_194*_MainTex_var.a)*0.5; // Light wrapping
                float3 NdotLWrap = NdotL * ( 1.0 - w );
                float3 forwardLight = max(float3(0.0,0.0,0.0), NdotLWrap + w );
                float3 backLight = max(float3(0.0,0.0,0.0), -NdotLWrap + w ) * _tr.rgb;
                NdotL = max(0.0,dot( normalDirection, lightDirection ));
                half fd90 = 0.5 + 2 * LdotH * LdotH * (1-gloss);
                float nlPow5 = Pow5(1-NdotLWrap);
                float nvPow5 = Pow5(1-NdotV);
                float3 directDiffuse = ((forwardLight+backLight) + ((1 +(fd90 - 1)*nlPow5) * (1 + (fd90 - 1)*nvPow5) * NdotL)) * attenColor;
                float3 indirectDiffuse = float3(0,0,0);
                indirectDiffuse += gi.indirect.diffuse;
                float3 diffuse = (directDiffuse + indirectDiffuse) * diffuseColor;
////// Emissive:
                float4 _node_2233_var = tex2D(_node_2233,TRANSFORM_TEX(i.uv0, _node_2233));
                float4 node_4189 = _Time + _TimeEditor;
                float4 node_3274 = _Time + _TimeEditor;
                float2 node_7625 = (i.uv0+node_3274.g*float2(0,0.01));
                float4 _node_6730_var = tex2D(_node_6730,TRANSFORM_TEX(node_7625, _node_6730));
                float3 emissive = ((_node_2233_var.rgb*lerp( _node_8048, clamp((_node_2939*sin(node_4189.b)),0,50), _BodyFlash )*_node_6730_var.rgb)*_node_4730.rgb);
/// Final Color:
                float3 finalColor = diffuse + specular + emissive;
                fixed4 finalRGBA = fixed4(finalColor,1);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
				finalRGBA.a = 200;
                return finalRGBA;
            }
            ENDCG
        }
        Pass {
            Name "FORWARD_DELTA"
            Tags {
                "LightMode"="ForwardAdd"
            }
            Blend One One
            Cull Off
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDADD
            #define SHOULD_SAMPLE_SH 1
			#define LIGHTMAP_OFF 1
            #define _GLOSSYENV 1
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #include "Lighting.cginc"
            #include "UnityPBSLighting.cginc"
            #include "UnityStandardBRDF.cginc"
 #pragma multi_compile_fwdadd_fullshadows
            #pragma multi_compile DIRLIGHTMAP_OFF DIRLIGHTMAP_COMBINED DIRLIGHTMAP_SEPARATE
            #pragma multi_compile DYNAMICLIGHTMAP_OFF DYNAMICLIGHTMAP_ON
            #pragma multi_compile_fog
            //#pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            uniform float4 _TimeEditor;
            uniform float4 _Color;
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform sampler2D _BumpMap; uniform float4 _BumpMap_ST;
            uniform float _Metallic;
            uniform float _Gloss;
            uniform sampler2D _node_6731; uniform float4 _node_6731_ST;
            uniform float _node_3245;
            uniform float4 _node_2689;
            uniform float4 _sss;
            uniform float4 _tr;
            uniform float _node_3487;
            uniform sampler2D _node_6945; uniform float4 _node_6945_ST;
            uniform float _Gloss2;
            uniform float4 _node_1515;
            uniform sampler2D _node_2233; uniform float4 _node_2233_ST;
            uniform float4 _node_4730;
            uniform sampler2D _node_6730; uniform float4 _node_6730_ST;
            uniform float _node_8048;
            uniform float _node_194;
            uniform sampler2D _node_5518; uniform float4 _node_5518_ST;
            uniform float _node_1155;
            uniform float _rim_power;
            uniform float4 _rim_color;
            uniform float _rim_range;
            uniform fixed _BodyFlash;
            uniform float _node_2939;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 texcoord0 : TEXCOORD0;      
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                float3 tangentDir : TEXCOORD3;
                float3 bitangentDir : TEXCOORD4;
                LIGHTING_COORDS(5,6)
                UNITY_FOG_COORDS(7)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.tangentDir = normalize( mul( unity_ObjectToWorld, float4( v.tangent.xyz, 0.0 ) ).xyz );
                o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos( v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                i.normalDir = normalize(i.normalDir);
                i.normalDir *= faceSign;
                float3x3 tangentTransform = float3x3( i.tangentDir, i.bitangentDir, i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 _BumpMap_var = UnpackNormal(tex2D(_BumpMap,TRANSFORM_TEX(i.uv0, _BumpMap)));
                float3 _node_6945_var = UnpackNormal(tex2D(_node_6945,TRANSFORM_TEX(i.uv0, _node_6945)));
                float3 normalLocal = lerp(_BumpMap_var.rgb,saturate(max(_BumpMap_var.rgb,_node_6945_var.rgb)),_node_3487);
                float3 normalDirection = normalize(mul( normalLocal, tangentTransform )); // Perturbed normals
                float4 _node_5518_var = tex2D(_node_5518,TRANSFORM_TEX(i.uv0, _node_5518));
                clip(pow(_node_5518_var.r,_node_1155) - 0.5);
                float3 lightDirection = normalize(lerp(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz - i.posWorld.xyz,_WorldSpaceLightPos0.w));
                float3 lightColor = _LightColor0.rgb;
                float3 halfDirection = normalize(viewDirection+lightDirection);
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float3 attenColor = attenuation * _LightColor0.xyz;
                float Pi = 3.141592654;
                float InvPi = 0.31830988618;
///////// Gloss:
                float4 _node_6731_var = tex2D(_node_6731,TRANSFORM_TEX(i.uv0, _node_6731));
                float gloss = (_Gloss*_node_6731_var.g);
                float perceptualRoughness = 1.0 - (_Gloss*_node_6731_var.g);
                float roughness = perceptualRoughness * perceptualRoughness;
                float specPow = exp2( gloss * 10.0 + 1.0 );
////// Specular:
                float NdotL = saturate(dot( normalDirection, lightDirection ));
                float LdotH = saturate(dot(lightDirection, halfDirection));
                float3 specularColor = (_Metallic*_node_6731_var.b);
                float specularMonochrome;
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(i.uv0, _MainTex));
                float3 node_1633 = (((max(0,dot(lightDirection,normalDirection))*pow(max(0,dot(normalDirection,halfDirection)),_Gloss2))*_node_1515.rgb)+saturate(((_MainTex_var.rgb*_Color.rgb)*saturate((pow(_node_6731_var.r,_node_3245)+_node_2689.rgb)))));
                float3 diffuseColor = lerp(node_1633,(node_1633+(pow(1.0-max(0,dot(normalDirection, viewDirection)),_rim_power)*_rim_color.rgb*3.0)),_rim_range); // Need this for specular when using metallic
                diffuseColor = DiffuseAndSpecularFromMetallic( diffuseColor, specularColor, specularColor, specularMonochrome );
                specularMonochrome = 1.0-specularMonochrome;
                float NdotV = abs(dot( normalDirection, viewDirection ));
                float NdotH = saturate(dot( normalDirection, halfDirection ));
                float VdotH = saturate(dot( viewDirection, halfDirection ));
                float visTerm = SmithJointGGXVisibilityTerm( NdotL, NdotV, roughness );
                float normTerm = GGXTerm(NdotH, roughness);
                float specularPBL = (visTerm*normTerm) * UNITY_PI;
                #ifdef UNITY_COLORSPACE_GAMMA
                    specularPBL = sqrt(max(1e-4h, specularPBL));
                #endif
                specularPBL = max(0, specularPBL * NdotL);
                #if defined(_SPECULARHIGHLIGHTS_OFF)
                    specularPBL = 0.0;
                #endif
                specularPBL *= any(specularColor) ? 1.0 : 0.0;
                float3 directSpecular = attenColor*specularPBL*FresnelTerm(specularColor, LdotH);
                float3 specular = directSpecular;
/////// Diffuse:
                NdotL = dot( normalDirection, lightDirection );
                float3 w = (_sss.rgb*_node_194*_MainTex_var.a)*0.5; // Light wrapping
                float3 NdotLWrap = NdotL * ( 1.0 - w );
                float3 forwardLight = max(float3(0.0,0.0,0.0), NdotLWrap + w );
                float3 backLight = max(float3(0.0,0.0,0.0), -NdotLWrap + w ) * _tr.rgb;
                NdotL = max(0.0,dot( normalDirection, lightDirection ));
                half fd90 = 0.5 + 2 * LdotH * LdotH * (1-gloss);
                float nlPow5 = Pow5(1-NdotLWrap);
                float nvPow5 = Pow5(1-NdotV);
                float3 directDiffuse = ((forwardLight+backLight) + ((1 +(fd90 - 1)*nlPow5) * (1 + (fd90 - 1)*nvPow5) * NdotL)) * attenColor;
                float3 diffuse = directDiffuse * diffuseColor;
/// Final Color:
                float3 finalColor = diffuse + specular;
                fixed4 finalRGBA = fixed4(finalColor * 1,0);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
				finalRGBA.a = 200;
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
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "UnityPBSLighting.cginc"
            #include "UnityStandardBRDF.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest

            //#pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            uniform sampler2D _node_5518; uniform float4 _node_5518_ST;
            uniform float _node_1155;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };
            struct VertexOutput {
                V2F_SHADOW_CASTER;
                float2 uv0 : TEXCOORD1;
                float2 uv1 : TEXCOORD2;
                float2 uv2 : TEXCOORD3;
                float4 posWorld : TEXCOORD4;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.uv1 = v.texcoord1;
                o.uv2 = v.texcoord2;
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos( v.vertex );
                TRANSFER_SHADOW_CASTER(o)
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float4 _node_5518_var = tex2D(_node_5518,TRANSFORM_TEX(i.uv0, _node_5518));
                clip(pow(_node_5518_var.r,_node_1155) - 0.5);
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }       
    }
	
	 SubShader {
        Tags {
            "Queue"="AlphaTest"
            "RenderType"="TransparentCutout"
        }
        
		LOD 400
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Cull Off
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define SHOULD_SAMPLE_SH 1
			#define LIGHTMAP_OFF 1
            #define _GLOSSYENV 1
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #include "Lighting.cginc"
            #include "UnityPBSLighting.cginc"
            #include "UnityStandardBRDF.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma multi_compile DIRLIGHTMAP_OFF DIRLIGHTMAP_COMBINED DIRLIGHTMAP_SEPARATE
            #pragma multi_compile DYNAMICLIGHTMAP_OFF DYNAMICLIGHTMAP_ON
            #pragma multi_compile_fog
            //#pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            uniform float4 _TimeEditor;
            uniform float4 _Color;
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform sampler2D _BumpMap; uniform float4 _BumpMap_ST;
            uniform float _Metallic;
            uniform float _Gloss;
            uniform sampler2D _node_6731; uniform float4 _node_6731_ST;
            uniform float _node_3245;
            uniform float4 _node_2689;
            uniform float4 _sss;
            uniform float4 _tr;
            uniform float _node_3487;
            uniform sampler2D _node_6945; uniform float4 _node_6945_ST;
            uniform float _Gloss2;
            uniform float4 _node_1515;
            uniform sampler2D _node_2233; uniform float4 _node_2233_ST;
            uniform float4 _node_4730;
            uniform sampler2D _node_6730; uniform float4 _node_6730_ST;
            uniform float _node_8048;
            uniform samplerCUBE _node_1303;
            uniform float _node_345;
            uniform float _node_6746;
            uniform float _node_194;
            uniform sampler2D _node_5518; uniform float4 _node_5518_ST;
            uniform float _node_1155;
            uniform float _rim_power;
            uniform float4 _rim_color;
            uniform float _rim_range;
            uniform fixed _BodyFlash;
            uniform float _node_2939;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                float3 tangentDir : TEXCOORD3;
                float3 bitangentDir : TEXCOORD4;
                LIGHTING_COORDS(5,6)
                UNITY_FOG_COORDS(7)
                #if defined(LIGHTMAP_ON) || defined(UNITY_SHOULD_SAMPLE_SH)
                    float4 ambientOrLightmapUV : TEXCOORD8;
                #endif
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                #ifdef LIGHTMAP_ON
                    o.ambientOrLightmapUV.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
                    o.ambientOrLightmapUV.zw = 0;
                #elif UNITY_SHOULD_SAMPLE_SH
                #endif
                #ifdef DYNAMICLIGHTMAP_ON
                    o.ambientOrLightmapUV.zw = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
                #endif
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.tangentDir = normalize( mul( unity_ObjectToWorld, float4( v.tangent.xyz, 0.0 ) ).xyz );
                o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos( v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                i.normalDir = normalize(i.normalDir);
                i.normalDir *= faceSign;
                float3x3 tangentTransform = float3x3( i.tangentDir, i.bitangentDir, i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 _BumpMap_var = UnpackNormal(tex2D(_BumpMap,TRANSFORM_TEX(i.uv0, _BumpMap)));
                float3 _node_6945_var = UnpackNormal(tex2D(_node_6945,TRANSFORM_TEX(i.uv0, _node_6945)));
                float3 normalLocal = lerp(_BumpMap_var.rgb,saturate(max(_BumpMap_var.rgb,_node_6945_var.rgb)),_node_3487);
                float3 normalDirection = normalize(mul( normalLocal, tangentTransform )); // Perturbed normals
                float3 viewReflectDirection = reflect( -viewDirection, normalDirection );
                float4 _node_5518_var = tex2D(_node_5518,TRANSFORM_TEX(i.uv0, _node_5518));
                clip(pow(_node_5518_var.r,_node_1155) - 0.5);
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float3 lightColor = _LightColor0.rgb;
                float3 halfDirection = normalize(viewDirection+lightDirection);
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float3 attenColor = attenuation * _LightColor0.xyz;
                float Pi = 3.141592654;
                float InvPi = 0.31830988618;
///////// Gloss:
                float4 _node_6731_var = tex2D(_node_6731,TRANSFORM_TEX(i.uv0, _node_6731));
                float gloss = (_Gloss*_node_6731_var.g);
                float perceptualRoughness = 1.0 - (_Gloss*_node_6731_var.g);
                float roughness = perceptualRoughness * perceptualRoughness;
                float specPow = exp2( gloss * 10.0 + 1.0 );
/////// GI Data:
                UnityLight light;

                    light.color = lightColor;
                    light.dir = lightDirection;
                    light.ndotl = LambertTerm (normalDirection, light.dir);
  
                UnityGIInput d = (UnityGIInput)0;
                d.light = light;
                d.worldPos = i.posWorld.xyz;
                d.worldViewDir = viewDirection;
                d.atten = attenuation;
                #if defined(LIGHTMAP_ON) || defined(DYNAMICLIGHTMAP_ON)
                    d.ambient = 0;
                    d.lightmapUV = i.ambientOrLightmapUV;
                #else
                    d.ambient = i.ambientOrLightmapUV;
                #endif
              
                d.probeHDR[0] = unity_SpecCube0_HDR;
                d.probeHDR[1] = unity_SpecCube1_HDR;
                Unity_GlossyEnvironmentData ugls_en_data;
                ugls_en_data.roughness = 1.0 - gloss;
                ugls_en_data.reflUVW = viewReflectDirection;
                UnityGI gi = UnityGlobalIllumination(d, 1, normalDirection, ugls_en_data );
                lightDirection = gi.light.dir;
                lightColor = gi.light.color;
////// Specular:
                float NdotL = saturate(dot( normalDirection, lightDirection ));
                float LdotH = saturate(dot(lightDirection, halfDirection));
                float3 specularColor = (_Metallic*_node_6731_var.b);
                float specularMonochrome;
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(i.uv0, _MainTex));
                float3 node_1633 = (((max(0,dot(lightDirection,normalDirection))*pow(max(0,dot(normalDirection,halfDirection)),_Gloss2))*_node_1515.rgb)+saturate(((_MainTex_var.rgb*_Color.rgb)*saturate((pow(_node_6731_var.r,_node_3245)+_node_2689.rgb)))));
                float3 diffuseColor = lerp(node_1633,(node_1633+(pow(1.0-max(0,dot(normalDirection, viewDirection)),_rim_power)*_rim_color.rgb*3.0)),_rim_range); // Need this for specular when using metallic
                diffuseColor = DiffuseAndSpecularFromMetallic( diffuseColor, specularColor, specularColor, specularMonochrome );
                specularMonochrome = 1.0-specularMonochrome;
                float NdotV = abs(dot( normalDirection, viewDirection ));
                float NdotH = saturate(dot( normalDirection, halfDirection ));
                float VdotH = saturate(dot( viewDirection, halfDirection ));
                float visTerm = SmithJointGGXVisibilityTerm( NdotL, NdotV, roughness );
                float normTerm = GGXTerm(NdotH, roughness);
                float specularPBL = (visTerm*normTerm) * UNITY_PI;
                #ifdef UNITY_COLORSPACE_GAMMA
                    specularPBL = sqrt(max(1e-4h, specularPBL));
                #endif
                specularPBL = max(0, specularPBL * NdotL);
                #if defined(_SPECULARHIGHLIGHTS_OFF)
                    specularPBL = 0.0;
                #endif
                half surfaceReduction;
                #ifdef UNITY_COLORSPACE_GAMMA
                    surfaceReduction = 1.0-0.28*roughness*perceptualRoughness;
                #else
                    surfaceReduction = 1.0/(roughness*roughness + 1.0);
                #endif
                specularPBL *= any(specularColor) ? 1.0 : 0.0;
                float3 directSpecular = attenColor*specularPBL*FresnelTerm(specularColor, LdotH);
                half grazingTerm = saturate( gloss + specularMonochrome );
                float3 indirectSpecular = (gi.indirect.specular + (texCUBElod(_node_1303,float4(viewReflectDirection,_node_345)).rgb*_node_6746*_node_6731_var.b));
                indirectSpecular *= FresnelLerp (specularColor, grazingTerm, NdotV);
                indirectSpecular *= surfaceReduction;
                float3 specular = (directSpecular + indirectSpecular);
/////// Diffuse:
                NdotL = dot( normalDirection, lightDirection );
                float3 w = (_sss.rgb*_node_194*_MainTex_var.a)*0.5; // Light wrapping
                float3 NdotLWrap = NdotL * ( 1.0 - w );
                float3 forwardLight = max(float3(0.0,0.0,0.0), NdotLWrap + w );
                float3 backLight = max(float3(0.0,0.0,0.0), -NdotLWrap + w ) * _tr.rgb;
                NdotL = max(0.0,dot( normalDirection, lightDirection ));
                half fd90 = 0.5 + 2 * LdotH * LdotH * (1-gloss);
                float nlPow5 = Pow5(1-NdotLWrap);
                float nvPow5 = Pow5(1-NdotV);
                float3 directDiffuse = ((forwardLight+backLight) + ((1 +(fd90 - 1)*nlPow5) * (1 + (fd90 - 1)*nvPow5) * NdotL)) * attenColor;
                float3 indirectDiffuse = float3(0,0,0);
                indirectDiffuse += gi.indirect.diffuse;
                float3 diffuse = (directDiffuse + indirectDiffuse) * diffuseColor;
////// Emissive:
                float4 _node_2233_var = tex2D(_node_2233,TRANSFORM_TEX(i.uv0, _node_2233));
                float4 node_4189 = _Time + _TimeEditor;
                float4 node_3274 = _Time + _TimeEditor;
                float2 node_7625 = (i.uv0+node_3274.g*float2(0,0.01));
                float4 _node_6730_var = tex2D(_node_6730,TRANSFORM_TEX(node_7625, _node_6730));
                float3 emissive = ((_node_2233_var.rgb*lerp( _node_8048, clamp((_node_2939*sin(node_4189.b)),0,50), _BodyFlash )*_node_6730_var.rgb)*_node_4730.rgb);
/// Final Color:
                float3 finalColor = diffuse + specular + emissive;
                fixed4 finalRGBA = fixed4(finalColor,1);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
				finalRGBA.a = 200;
                return finalRGBA;
            }
            ENDCG
        }
        Pass {
            Name "FORWARD_DELTA"
            Tags {
                "LightMode"="ForwardAdd"
            }
            Blend One One
            Cull Off
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define SHOULD_SAMPLE_SH 1
			#define LIGHTMAP_OFF 1			
            #define _GLOSSYENV 1
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #include "Lighting.cginc"
            #include "UnityPBSLighting.cginc"
            #include "UnityStandardBRDF.cginc"
            #pragma multi_compile_fwdadd_fullshadows
            #pragma multi_compile DIRLIGHTMAP_OFF DIRLIGHTMAP_COMBINED DIRLIGHTMAP_SEPARATE
            #pragma multi_compile DYNAMICLIGHTMAP_OFF DYNAMICLIGHTMAP_ON
            #pragma multi_compile_fog
            //#pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            uniform float4 _TimeEditor;
            uniform float4 _Color;
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform sampler2D _BumpMap; uniform float4 _BumpMap_ST;
            uniform float _Metallic;
            uniform float _Gloss;
            uniform sampler2D _node_6731; uniform float4 _node_6731_ST;
            uniform float _node_3245;
            uniform float4 _node_2689;
            uniform float4 _sss;
            uniform float4 _tr;
            uniform float _node_3487;
            uniform sampler2D _node_6945; uniform float4 _node_6945_ST;
            uniform float _Gloss2;
            uniform float4 _node_1515;
            uniform sampler2D _node_2233; uniform float4 _node_2233_ST;
            uniform float4 _node_4730;
            uniform sampler2D _node_6730; uniform float4 _node_6730_ST;
            uniform float _node_8048;
            uniform float _node_194;
            uniform sampler2D _node_5518; uniform float4 _node_5518_ST;
            uniform float _node_1155;
            uniform float _rim_power;
            uniform float4 _rim_color;
            uniform float _rim_range;
            uniform fixed _BodyFlash;
            uniform float _node_2939;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 texcoord0 : TEXCOORD0;      
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                float3 tangentDir : TEXCOORD3;
                float3 bitangentDir : TEXCOORD4;
                LIGHTING_COORDS(5,6)
                UNITY_FOG_COORDS(7)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.tangentDir = normalize( mul( unity_ObjectToWorld, float4( v.tangent.xyz, 0.0 ) ).xyz );
                o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos( v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                i.normalDir = normalize(i.normalDir);
                i.normalDir *= faceSign;
                float3x3 tangentTransform = float3x3( i.tangentDir, i.bitangentDir, i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 _BumpMap_var = UnpackNormal(tex2D(_BumpMap,TRANSFORM_TEX(i.uv0, _BumpMap)));
                float3 _node_6945_var = UnpackNormal(tex2D(_node_6945,TRANSFORM_TEX(i.uv0, _node_6945)));
                float3 normalLocal = lerp(_BumpMap_var.rgb,saturate(max(_BumpMap_var.rgb,_node_6945_var.rgb)),_node_3487);
                float3 normalDirection = normalize(mul( normalLocal, tangentTransform )); // Perturbed normals
                float4 _node_5518_var = tex2D(_node_5518,TRANSFORM_TEX(i.uv0, _node_5518));
                clip(pow(_node_5518_var.r,_node_1155) - 0.5);
                float3 lightDirection = normalize(lerp(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz - i.posWorld.xyz,_WorldSpaceLightPos0.w));
                float3 lightColor = _LightColor0.rgb;
                float3 halfDirection = normalize(viewDirection+lightDirection);
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float3 attenColor = attenuation * _LightColor0.xyz;
                float Pi = 3.141592654;
                float InvPi = 0.31830988618;
///////// Gloss:
                float4 _node_6731_var = tex2D(_node_6731,TRANSFORM_TEX(i.uv0, _node_6731));
                float gloss = (_Gloss*_node_6731_var.g);
                float perceptualRoughness = 1.0 - (_Gloss*_node_6731_var.g);
                float roughness = perceptualRoughness * perceptualRoughness;
                float specPow = exp2( gloss * 10.0 + 1.0 );
////// Specular:
                float NdotL = saturate(dot( normalDirection, lightDirection ));
                float LdotH = saturate(dot(lightDirection, halfDirection));
                float3 specularColor = (_Metallic*_node_6731_var.b);
                float specularMonochrome;
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(i.uv0, _MainTex));
                float3 node_1633 = (((max(0,dot(lightDirection,normalDirection))*pow(max(0,dot(normalDirection,halfDirection)),_Gloss2))*_node_1515.rgb)+saturate(((_MainTex_var.rgb*_Color.rgb)*saturate((pow(_node_6731_var.r,_node_3245)+_node_2689.rgb)))));
                float3 diffuseColor = lerp(node_1633,(node_1633+(pow(1.0-max(0,dot(normalDirection, viewDirection)),_rim_power)*_rim_color.rgb*3.0)),_rim_range); // Need this for specular when using metallic
                diffuseColor = DiffuseAndSpecularFromMetallic( diffuseColor, specularColor, specularColor, specularMonochrome );
                specularMonochrome = 1.0-specularMonochrome;
                float NdotV = abs(dot( normalDirection, viewDirection ));
                float NdotH = saturate(dot( normalDirection, halfDirection ));
                float VdotH = saturate(dot( viewDirection, halfDirection ));
                float visTerm = SmithJointGGXVisibilityTerm( NdotL, NdotV, roughness );
                float normTerm = GGXTerm(NdotH, roughness);
                float specularPBL = (visTerm*normTerm) * UNITY_PI;
                #ifdef UNITY_COLORSPACE_GAMMA
                    specularPBL = sqrt(max(1e-4h, specularPBL));
                #endif
                specularPBL = max(0, specularPBL * NdotL);
                #if defined(_SPECULARHIGHLIGHTS_OFF)
                    specularPBL = 0.0;
                #endif
                specularPBL *= any(specularColor) ? 1.0 : 0.0;
                float3 directSpecular = attenColor*specularPBL*FresnelTerm(specularColor, LdotH);
                float3 specular = directSpecular;
/////// Diffuse:
                NdotL = dot( normalDirection, lightDirection );
                float3 w = (_sss.rgb*_node_194*_MainTex_var.a)*0.5; // Light wrapping
                float3 NdotLWrap = NdotL * ( 1.0 - w );
                float3 forwardLight = max(float3(0.0,0.0,0.0), NdotLWrap + w );
                float3 backLight = max(float3(0.0,0.0,0.0), -NdotLWrap + w ) * _tr.rgb;
                NdotL = max(0.0,dot( normalDirection, lightDirection ));
                half fd90 = 0.5 + 2 * LdotH * LdotH * (1-gloss);
                float nlPow5 = Pow5(1-NdotLWrap);
                float nvPow5 = Pow5(1-NdotV);
                float3 directDiffuse = ((forwardLight+backLight) + ((1 +(fd90 - 1)*nlPow5) * (1 + (fd90 - 1)*nvPow5) * NdotL)) * attenColor;
                float3 diffuse = directDiffuse * diffuseColor;
/// Final Color:
                float3 finalColor = diffuse + specular;
                fixed4 finalRGBA = fixed4(finalColor * 1,0);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
				finalRGBA.a = 200;
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
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "UnityPBSLighting.cginc"
            #include "UnityStandardBRDF.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest

            //#pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            uniform sampler2D _node_5518; uniform float4 _node_5518_ST;
            uniform float _node_1155;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };
            struct VertexOutput {
                V2F_SHADOW_CASTER;
                float2 uv0 : TEXCOORD1;
                float2 uv1 : TEXCOORD2;
                float2 uv2 : TEXCOORD3;
                float4 posWorld : TEXCOORD4;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.uv1 = v.texcoord1;
                o.uv2 = v.texcoord2;
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos( v.vertex );
                TRANSFER_SHADOW_CASTER(o)
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float4 _node_5518_var = tex2D(_node_5518,TRANSFORM_TEX(i.uv0, _node_5518));
                clip(pow(_node_5518_var.r,_node_1155) - 0.5);
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }      
    }
    FallBack "Diffuse"
    //CustomEditor "ShaderForgeMaterialInspector"
}
