// Shader created with Shader Forge v1.37 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.37;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:0,lgpr:1,limd:1,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:True,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:3,bdst:7,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.3843137,fgcg:0.6901961,fgcb:0.8901961,fgca:1,fgde:0.01,fgrn:413.7,fgrf:955.2,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:4013,x:34468,y:32763,varname:node_4013,prsc:2|diff-453-OUT,spec-3083-OUT,gloss-3324-OUT,normal-1117-OUT,emission-843-OUT,amspl-8951-OUT,alpha-2078-OUT,refract-5209-OUT,voffset-2601-OUT;n:type:ShaderForge.SFN_Color,id:1304,x:32648,y:32235,ptovrint:False,ptlb:Color,ptin:_Color,varname:node_1304,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Tex2d,id:9839,x:31640,y:32863,varname:node_9839,prsc:2,ntxv:0,isnm:False|UVIN-4473-UVOUT,TEX-2925-TEX;n:type:ShaderForge.SFN_Panner,id:4473,x:31251,y:33149,varname:node_4473,prsc:2,spu:0,spv:0.001|UVIN-442-UVOUT;n:type:ShaderForge.SFN_TexCoord,id:442,x:30317,y:32631,varname:node_442,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_VertexColor,id:3747,x:32081,y:33062,varname:node_3747,prsc:2;n:type:ShaderForge.SFN_ComponentMask,id:2078,x:33384,y:32984,varname:node_2078,prsc:2,cc1:0,cc2:-1,cc3:-1,cc4:-1|IN-7527-OUT;n:type:ShaderForge.SFN_Tex2d,id:1460,x:32248,y:33257,ptovrint:False,ptlb:node_1460,ptin:_node_1460,varname:node_1460,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False|UVIN-4473-UVOUT;n:type:ShaderForge.SFN_Tex2d,id:4315,x:32038,y:32200,varname:node_4315,prsc:2,ntxv:3,isnm:True|UVIN-9526-UVOUT,TEX-2968-TEX;n:type:ShaderForge.SFN_Slider,id:3083,x:33111,y:32727,ptovrint:False,ptlb:node_3083,ptin:_node_3083,varname:node_3083,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.6410257,max:10;n:type:ShaderForge.SFN_Slider,id:3324,x:33131,y:32852,ptovrint:False,ptlb:node_3324,ptin:_node_3324,varname:node_3324,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Lerp,id:2601,x:33004,y:33362,varname:node_2601,prsc:2|A-397-OUT,B-1174-OUT,T-8926-OUT;n:type:ShaderForge.SFN_Slider,id:8926,x:32525,y:33773,ptovrint:False,ptlb:node_8926,ptin:_node_8926,varname:node_8926,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Vector3,id:1174,x:32624,y:33538,varname:node_1174,prsc:2,v1:0,v2:0,v3:0;n:type:ShaderForge.SFN_Add,id:453,x:34012,y:32216,varname:node_453,prsc:2|A-8205-OUT,B-776-OUT,C-1304-RGB;n:type:ShaderForge.SFN_Lerp,id:776,x:32802,y:32424,varname:node_776,prsc:2|A-1006-OUT,B-4305-OUT,T-7084-OUT;n:type:ShaderForge.SFN_Slider,id:7084,x:32467,y:32785,ptovrint:False,ptlb:node_8926_copy,ptin:_node_8926_copy,varname:_node_8926_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Vector3,id:4305,x:32532,y:32629,varname:node_4305,prsc:2,v1:0,v2:0,v3:0;n:type:ShaderForge.SFN_Panner,id:9526,x:31418,y:32578,varname:node_9526,prsc:2,spu:0,spv:0.0003|UVIN-442-UVOUT;n:type:ShaderForge.SFN_Multiply,id:397,x:32584,y:33377,varname:node_397,prsc:2|A-1460-RGB,B-9010-OUT,C-5016-OUT;n:type:ShaderForge.SFN_NormalVector,id:5016,x:32002,y:33863,prsc:2,pt:False;n:type:ShaderForge.SFN_ValueProperty,id:9010,x:31684,y:33600,ptovrint:False,ptlb:node_9010,ptin:_node_9010,varname:node_9010,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:5;n:type:ShaderForge.SFN_Lerp,id:7527,x:33079,y:33071,varname:node_7527,prsc:2|A-3747-RGB,B-6510-OUT,T-4161-OUT;n:type:ShaderForge.SFN_Vector3,id:6510,x:32502,y:33126,varname:node_6510,prsc:2,v1:0,v2:0,v3:0;n:type:ShaderForge.SFN_Slider,id:4161,x:32660,y:33252,ptovrint:False,ptlb:node_4161,ptin:_node_4161,varname:node_4161,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_ComponentMask,id:5209,x:33575,y:33208,varname:node_5209,prsc:2,cc1:0,cc2:-1,cc3:-1,cc4:-1|IN-7304-OUT;n:type:ShaderForge.SFN_Tex2d,id:4330,x:32056,y:32485,varname:_node_4315_copy,prsc:2,ntxv:3,isnm:True|UVIN-9526-UVOUT,TEX-2968-TEX;n:type:ShaderForge.SFN_Tex2dAsset,id:2968,x:30900,y:32081,ptovrint:False,ptlb:node_2968,ptin:_node_2968,varname:node_2968,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:3,isnm:True;n:type:ShaderForge.SFN_Lerp,id:7304,x:33419,y:33450,varname:node_7304,prsc:2|A-4330-RGB,B-6952-OUT,T-3137-OUT;n:type:ShaderForge.SFN_Vector3,id:6952,x:33064,y:33548,varname:node_6952,prsc:2,v1:0,v2:0,v3:0;n:type:ShaderForge.SFN_Slider,id:3137,x:32897,y:33944,ptovrint:False,ptlb:node_3137,ptin:_node_3137,varname:node_3137,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Add,id:1117,x:32458,y:32108,varname:node_1117,prsc:2|A-3910-RGB,B-4315-RGB;n:type:ShaderForge.SFN_Tex2d,id:3910,x:32038,y:31957,varname:node_3910,prsc:2,ntxv:0,isnm:False|UVIN-5440-UVOUT,TEX-2968-TEX;n:type:ShaderForge.SFN_Panner,id:5440,x:31403,y:32398,varname:node_5440,prsc:2,spu:-0.0001,spv:0|UVIN-442-UVOUT;n:type:ShaderForge.SFN_Power,id:1006,x:32067,y:32876,varname:node_1006,prsc:2|VAL-9839-RGB,EXP-5716-OUT;n:type:ShaderForge.SFN_Slider,id:5716,x:31562,y:33099,ptovrint:False,ptlb:node_5716,ptin:_node_5716,varname:node_5716,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:10;n:type:ShaderForge.SFN_DepthBlend,id:7390,x:32655,y:31573,varname:node_7390,prsc:2|DIST-6176-OUT;n:type:ShaderForge.SFN_Slider,id:6176,x:32224,y:31622,ptovrint:False,ptlb:node_6176,ptin:_node_6176,varname:node_6176,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:10;n:type:ShaderForge.SFN_OneMinus,id:2310,x:32900,y:31689,varname:node_2310,prsc:2|IN-7390-OUT;n:type:ShaderForge.SFN_Power,id:4836,x:33336,y:31850,varname:node_4836,prsc:2|VAL-2310-OUT,EXP-2803-OUT;n:type:ShaderForge.SFN_Slider,id:2803,x:32597,y:32019,ptovrint:False,ptlb:node_2803,ptin:_node_2803,varname:node_2803,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:10;n:type:ShaderForge.SFN_Cubemap,id:2675,x:33787,y:33326,ptovrint:False,ptlb:node_2675,ptin:_node_2675,varname:node_2675,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,pvfc:0;n:type:ShaderForge.SFN_Tex2d,id:4180,x:31579,y:31133,varname:node_4180,prsc:2,ntxv:0,isnm:False|UVIN-3868-UVOUT,TEX-2925-TEX;n:type:ShaderForge.SFN_Multiply,id:8205,x:33512,y:32071,varname:node_8205,prsc:2|A-4180-RGB,B-4836-OUT,C-7945-OUT;n:type:ShaderForge.SFN_Tex2dAsset,id:2925,x:30196,y:31339,ptovrint:False,ptlb:node_2925,ptin:_node_2925,varname:node_2925,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Panner,id:3868,x:30600,y:31895,varname:node_3868,prsc:2,spu:0.001,spv:0|UVIN-988-OUT;n:type:ShaderForge.SFN_Multiply,id:988,x:30448,y:31947,varname:node_988,prsc:2|A-442-UVOUT,B-7670-OUT;n:type:ShaderForge.SFN_Slider,id:7670,x:29783,y:32015,ptovrint:False,ptlb:node_7670,ptin:_node_7670,varname:node_7670,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:5;n:type:ShaderForge.SFN_Fresnel,id:9863,x:33863,y:32470,varname:node_9863,prsc:2|NRM-5016-OUT,EXP-2357-OUT;n:type:ShaderForge.SFN_Multiply,id:8951,x:34145,y:32625,varname:node_8951,prsc:2|A-9863-OUT,B-2675-RGB;n:type:ShaderForge.SFN_Slider,id:2357,x:33361,y:32447,ptovrint:False,ptlb:node_2357,ptin:_node_2357,varname:node_2357,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:10;n:type:ShaderForge.SFN_Slider,id:7945,x:33170,y:32185,ptovrint:False,ptlb:node_7945,ptin:_node_7945,varname:node_7945,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:10;n:type:ShaderForge.SFN_Tex2d,id:5524,x:33641,y:33617,ptovrint:False,ptlb:node_5524,ptin:_node_5524,varname:node_5524,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:59390c694d03c174ca6185d665d72de7,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Multiply,id:3470,x:34209,y:33634,varname:node_3470,prsc:2|A-5524-R,B-9499-RGB;n:type:ShaderForge.SFN_Multiply,id:3189,x:34223,y:33861,varname:node_3189,prsc:2|A-5524-G,B-1716-RGB;n:type:ShaderForge.SFN_Color,id:9499,x:33752,y:33852,ptovrint:False,ptlb:node_9499,ptin:_node_9499,varname:node_9499,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Color,id:1716,x:33926,y:34011,ptovrint:False,ptlb:node_1716,ptin:_node_1716,varname:node_1716,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Add,id:843,x:34519,y:33597,varname:node_843,prsc:2|A-3470-OUT,B-3189-OUT;proporder:1304-1460-3083-3324-8926-7084-9010-4161-2968-3137-5716-6176-2803-2675-2925-7670-2357-7945-5524-9499-1716;pass:END;sub:END;*/

Shader "NextIsland/waterfall1" {
    Properties {
        _Color ("Color", Color) = (1,1,1,1)
        _node_1460 ("node_1460", 2D) = "white" {}
        _node_3083 ("node_3083", Range(0, 10)) = 0.6410257
        _node_3324 ("node_3324", Range(0, 1)) = 0
        _node_8926 ("node_8926", Range(0, 1)) = 0
        _node_8926_copy ("node_8926_copy", Range(0, 1)) = 0
        _node_9010 ("node_9010", Float ) = 5
        _node_4161 ("node_4161", Range(0, 1)) = 0
        _node_2968 ("node_2968", 2D) = "bump" {}
        _node_3137 ("node_3137", Range(0, 1)) = 0
        _node_5716 ("node_5716", Range(0, 10)) = 0
        _node_6176 ("node_6176", Range(0, 10)) = 0
        _node_2803 ("node_2803", Range(0, 10)) = 0
        _node_2675 ("node_2675", Cube) = "_Skybox" {}
        _node_2925 ("node_2925", 2D) = "white" {}
        _node_7670 ("node_7670", Range(0, 5)) = 0
        _node_2357 ("node_2357", Range(0, 10)) = 0
        _node_7945 ("node_7945", Range(0, 10)) = 0
        _node_5524 ("node_5524", 2D) = "white" {}
        _node_9499 ("node_9499", Color) = (0.5,0.5,0.5,1)
        _node_1716 ("node_1716", Color) = (0.5,0.5,0.5,1)
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        GrabPass{ }
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
           // #pragma only_renderers d3d9 d3d11 glcore gles gles3 metal 
            #pragma target 3.0
            uniform float4 _LightColor0;
            uniform sampler2D _GrabTexture;
            uniform sampler2D _CameraDepthTexture;
            uniform float4 _TimeEditor;
            uniform float4 _Color;
            uniform sampler2D _node_1460; uniform float4 _node_1460_ST;
            uniform float _node_3083;
            uniform float _node_3324;
            uniform float _node_8926;
            uniform float _node_8926_copy;
            uniform float _node_9010;
            uniform float _node_4161;
            uniform sampler2D _node_2968; uniform float4 _node_2968_ST;
            uniform float _node_3137;
            uniform float _node_5716;
            uniform float _node_6176;
            uniform float _node_2803;
            uniform samplerCUBE _node_2675;
            uniform sampler2D _node_2925; uniform float4 _node_2925_ST;
            uniform float _node_7670;
            uniform float _node_2357;
            uniform float _node_7945;
            uniform sampler2D _node_5524; uniform float4 _node_5524_ST;
            uniform float4 _node_9499;
            uniform float4 _node_1716;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 texcoord0 : TEXCOORD0;
                float4 vertexColor : COLOR;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                float3 tangentDir : TEXCOORD3;
                float3 bitangentDir : TEXCOORD4;
                float4 screenPos : TEXCOORD5;
                float4 vertexColor : COLOR;
                float4 projPos : TEXCOORD6;
                UNITY_FOG_COORDS(7)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.vertexColor = v.vertexColor;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.tangentDir = normalize( mul( unity_ObjectToWorld, float4( v.tangent.xyz, 0.0 ) ).xyz );
                o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
                float4 node_7118 = _Time + _TimeEditor;
                float2 node_4473 = (o.uv0+node_7118.g*float2(0,0.001));
                float4 _node_1460_var = tex2Dlod(_node_1460,float4(TRANSFORM_TEX(node_4473, _node_1460),0.0,0));
                v.vertex.xyz += lerp((_node_1460_var.rgb*_node_9010*v.normal),float3(0,0,0),_node_8926);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos( v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                o.projPos = ComputeScreenPos (o.pos);
                COMPUTE_EYEDEPTH(o.projPos.z);
                o.screenPos = o.pos;
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                #if UNITY_UV_STARTS_AT_TOP
                    float grabSign = -_ProjectionParams.x;
                #else
                    float grabSign = _ProjectionParams.x;
                #endif
                i.normalDir = normalize(i.normalDir);
                i.screenPos = float4( i.screenPos.xy / i.screenPos.w, 0, 0 );
                i.screenPos.y *= _ProjectionParams.x;
                float3x3 tangentTransform = float3x3( i.tangentDir, i.bitangentDir, i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float4 node_7118 = _Time + _TimeEditor;
                float2 node_5440 = (i.uv0+node_7118.g*float2(-0.0001,0));
                float3 node_3910 = UnpackNormal(tex2D(_node_2968,TRANSFORM_TEX(node_5440, _node_2968)));
                float2 node_9526 = (i.uv0+node_7118.g*float2(0,0.0003));
                float3 node_4315 = UnpackNormal(tex2D(_node_2968,TRANSFORM_TEX(node_9526, _node_2968)));
                float3 normalLocal = (node_3910.rgb+node_4315.rgb);
                float3 normalDirection = normalize(mul( normalLocal, tangentTransform )); // Perturbed normals
                float3 viewReflectDirection = reflect( -viewDirection, normalDirection );
                float sceneZ = max(0,LinearEyeDepth (UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos)))) - _ProjectionParams.g);
                float partZ = max(0,i.projPos.z - _ProjectionParams.g);
                float3 _node_4315_copy = UnpackNormal(tex2D(_node_2968,TRANSFORM_TEX(node_9526, _node_2968)));
                float node_5209 = lerp(_node_4315_copy.rgb,float3(0,0,0),_node_3137).r;
                float2 sceneUVs = float2(1,grabSign)*i.screenPos.xy*0.5+0.5 + float2(node_5209,node_5209);
                float4 sceneColor = tex2D(_GrabTexture, sceneUVs);
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float3 lightColor = _LightColor0.rgb;
                float3 halfDirection = normalize(viewDirection+lightDirection);
////// Lighting:
                float attenuation = 1;
                float3 attenColor = attenuation * _LightColor0.xyz;
///////// Gloss:
                float gloss = _node_3324;
                float specPow = exp2( gloss * 10.0 + 1.0 );
////// Specular:
                float NdotL = saturate(dot( normalDirection, lightDirection ));
                float3 specularColor = float3(_node_3083,_node_3083,_node_3083);
                float3 directSpecular = attenColor * pow(max(0,dot(halfDirection,normalDirection)),specPow)*specularColor;
                float3 indirectSpecular = (0 + (pow(1.0-max(0,dot(i.normalDir, viewDirection)),_node_2357)*texCUBE(_node_2675,viewReflectDirection).rgb))*specularColor;
                float3 specular = (directSpecular + indirectSpecular);
/////// Diffuse:
                NdotL = max(0.0,dot( normalDirection, lightDirection ));
                float3 directDiffuse = max( 0.0, NdotL) * attenColor;
                float3 indirectDiffuse = float3(0,0,0);
                indirectDiffuse += UNITY_LIGHTMODEL_AMBIENT.rgb; // Ambient Light
                float2 node_3868 = ((i.uv0*_node_7670)+node_7118.g*float2(0.001,0));
                float4 node_4180 = tex2D(_node_2925,TRANSFORM_TEX(node_3868, _node_2925));
                float2 node_4473 = (i.uv0+node_7118.g*float2(0,0.001));
                float4 node_9839 = tex2D(_node_2925,TRANSFORM_TEX(node_4473, _node_2925));
                float3 diffuseColor = ((node_4180.rgb*pow((1.0 - saturate((sceneZ-partZ)/_node_6176)),_node_2803)*_node_7945)+lerp(pow(node_9839.rgb,_node_5716),float3(0,0,0),_node_8926_copy)+_Color.rgb);
                float3 diffuse = (directDiffuse + indirectDiffuse) * diffuseColor;
////// Emissive:
                float4 _node_5524_var = tex2D(_node_5524,TRANSFORM_TEX(i.uv0, _node_5524));
                float3 emissive = ((_node_5524_var.r*_node_9499.rgb)+(_node_5524_var.g*_node_1716.rgb));
/// Final Color:
                float3 finalColor = diffuse + specular + emissive;
                fixed4 finalRGBA = fixed4(lerp(sceneColor.rgb, finalColor,lerp(i.vertexColor.rgb,float3(0,0,0),_node_4161).r),1);
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
            Cull Back
            
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
            uniform sampler2D _node_1460; uniform float4 _node_1460_ST;
            uniform float _node_8926;
            uniform float _node_9010;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                V2F_SHADOW_CASTER;
                float2 uv0 : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                float4 node_9348 = _Time + _TimeEditor;
                float2 node_4473 = (o.uv0+node_9348.g*float2(0,0.001));
                float4 _node_1460_var = tex2Dlod(_node_1460,float4(TRANSFORM_TEX(node_4473, _node_1460),0.0,0));
                v.vertex.xyz += lerp((_node_1460_var.rgb*_node_9010*v.normal),float3(0,0,0),_node_8926);
                o.pos = UnityObjectToClipPos( v.vertex );
                TRANSFER_SHADOW_CASTER(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3 normalDirection = i.normalDir;
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
