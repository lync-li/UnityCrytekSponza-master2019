// Shader created with Shader Forge v1.37 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.37;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:1,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:4013,x:34528,y:32596,varname:node_4013,prsc:2|diff-5823-OUT,spec-8196-OUT,gloss-252-OUT,normal-2640-RGB,emission-7959-OUT,transm-3851-RGB,lwrap-6720-RGB,amspl-9188-OUT;n:type:ShaderForge.SFN_Tex2d,id:2640,x:33500,y:32677,ptovrint:False,ptlb:node_2640,ptin:_node_2640,varname:node_2640,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:3,isnm:True;n:type:ShaderForge.SFN_Fresnel,id:100,x:31719,y:32938,varname:node_100,prsc:2|NRM-1773-OUT;n:type:ShaderForge.SFN_Slider,id:2524,x:31415,y:33620,ptovrint:False,ptlb:node_2524,ptin:_node_2524,varname:node_2524,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:10;n:type:ShaderForge.SFN_Power,id:8095,x:32054,y:33043,varname:node_8095,prsc:2|VAL-100-OUT,EXP-2524-OUT;n:type:ShaderForge.SFN_Multiply,id:1829,x:32616,y:33058,varname:node_1829,prsc:2|A-3014-OUT,B-5723-RGB;n:type:ShaderForge.SFN_Color,id:5723,x:32023,y:33479,ptovrint:False,ptlb:node_5723,ptin:_node_5723,varname:node_5723,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Slider,id:2830,x:33662,y:32360,ptovrint:False,ptlb:node_2830,ptin:_node_2830,varname:node_2830,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Slider,id:252,x:33241,y:33167,ptovrint:False,ptlb:node_252,ptin:_node_252,varname:node_252,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Color,id:3851,x:34238,y:33066,ptovrint:False,ptlb:node_3851,ptin:_node_3851,varname:node_3851,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Color,id:6720,x:34100,y:32850,ptovrint:False,ptlb:node_6720,ptin:_node_6720,varname:node_6720,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Cubemap,id:9872,x:32993,y:33414,ptovrint:False,ptlb:node_9872,ptin:_node_9872,varname:node_9872,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,pvfc:0|MIP-3714-OUT;n:type:ShaderForge.SFN_Slider,id:3714,x:32812,y:33819,ptovrint:False,ptlb:node_3714,ptin:_node_3714,varname:node_3714,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:10;n:type:ShaderForge.SFN_Multiply,id:9188,x:33540,y:33396,varname:node_9188,prsc:2|A-9872-RGB,B-7962-OUT,C-41-RGB;n:type:ShaderForge.SFN_Slider,id:7962,x:32903,y:33662,ptovrint:False,ptlb:node_7962,ptin:_node_7962,varname:node_7962,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:10;n:type:ShaderForge.SFN_Tex2d,id:6192,x:32381,y:33299,ptovrint:False,ptlb:node_6192,ptin:_node_6192,varname:node_6192,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Add,id:7959,x:32967,y:32984,varname:node_7959,prsc:2|A-1829-OUT,B-2019-OUT;n:type:ShaderForge.SFN_Multiply,id:2019,x:32858,y:33222,varname:node_2019,prsc:2|A-6192-RGB,B-4621-RGB,C-6087-OUT;n:type:ShaderForge.SFN_Color,id:4621,x:32450,y:33533,ptovrint:False,ptlb:node_4621,ptin:_node_4621,varname:node_4621,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Color,id:41,x:33326,y:33649,ptovrint:False,ptlb:node_41,ptin:_node_41,varname:node_41,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Slider,id:6087,x:32312,y:33831,ptovrint:False,ptlb:node_6087,ptin:_node_6087,varname:node_6087,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:20;n:type:ShaderForge.SFN_NormalVector,id:1773,x:31382,y:33231,prsc:2,pt:True;n:type:ShaderForge.SFN_Tex2d,id:5263,x:33603,y:33212,ptovrint:False,ptlb:node_5263,ptin:_node_5263,varname:node_5263,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:3,isnm:True;n:type:ShaderForge.SFN_ComponentMask,id:896,x:34361,y:33268,varname:node_896,prsc:2,cc1:0,cc2:1,cc3:-1,cc4:-1|IN-1719-OUT;n:type:ShaderForge.SFN_Lerp,id:1719,x:33956,y:33439,varname:node_1719,prsc:2|A-5263-RGB,B-1630-OUT,T-4612-OUT;n:type:ShaderForge.SFN_Slider,id:4612,x:33720,y:33690,ptovrint:False,ptlb:node_4612,ptin:_node_4612,varname:node_4612,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Vector3,id:1630,x:33640,y:33568,varname:node_1630,prsc:2,v1:0,v2:0.1115619,v3:0.2941176;n:type:ShaderForge.SFN_Tex2d,id:180,x:33429,y:31977,ptovrint:False,ptlb:node_180,ptin:_node_180,varname:node_180,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Multiply,id:2119,x:34118,y:32238,varname:node_2119,prsc:2|A-180-RGB,B-5011-RGB;n:type:ShaderForge.SFN_Color,id:5011,x:33562,y:32200,ptovrint:False,ptlb:node_5011,ptin:_node_5011,varname:node_5011,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Slider,id:8771,x:34680,y:33558,ptovrint:False,ptlb:node_8771,ptin:_node_8771,varname:node_8771,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Fresnel,id:5889,x:35169,y:33465,varname:node_5889,prsc:2|NRM-6004-OUT,EXP-8771-OUT;n:type:ShaderForge.SFN_NormalVector,id:6004,x:34988,y:33349,prsc:2,pt:False;n:type:ShaderForge.SFN_Color,id:628,x:33741,y:32500,ptovrint:False,ptlb:node_628,ptin:_node_628,varname:node_628,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Multiply,id:8196,x:34097,y:32485,varname:node_8196,prsc:2|A-2830-OUT,B-628-RGB;n:type:ShaderForge.SFN_Multiply,id:3014,x:32344,y:32999,varname:node_3014,prsc:2|A-8095-OUT,B-8792-OUT;n:type:ShaderForge.SFN_Slider,id:8792,x:32083,y:33169,ptovrint:False,ptlb:node_8792,ptin:_node_8792,varname:node_8792,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:10;n:type:ShaderForge.SFN_Fresnel,id:1973,x:34030,y:31592,varname:node_1973,prsc:2|NRM-1773-OUT,EXP-8565-OUT;n:type:ShaderForge.SFN_Slider,id:8565,x:33664,y:31715,ptovrint:False,ptlb:rim_power,ptin:_rim_power,varname:node_9826,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:2.925201,max:10;n:type:ShaderForge.SFN_Color,id:1309,x:33836,y:31843,ptovrint:False,ptlb:rim_color,ptin:_rim_color,varname:node_4281,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Multiply,id:526,x:34242,y:31748,varname:node_526,prsc:2|A-1973-OUT,B-1309-RGB,C-808-OUT;n:type:ShaderForge.SFN_Vector1,id:808,x:34004,y:31887,varname:node_808,prsc:2,v1:3;n:type:ShaderForge.SFN_Add,id:7234,x:34479,y:31952,varname:node_7234,prsc:2|A-526-OUT,B-2119-OUT;n:type:ShaderForge.SFN_Lerp,id:5823,x:34713,y:32154,varname:node_5823,prsc:2|A-2119-OUT,B-7234-OUT,T-5916-OUT;n:type:ShaderForge.SFN_Slider,id:5916,x:34261,y:32301,ptovrint:False,ptlb:rim_range,ptin:_rim_range,varname:node_5916,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:5;proporder:2640-2524-5723-2830-252-3851-6720-9872-3714-7962-6192-4621-41-6087-5263-4612-180-5011-8771-628-8792-8565-1309-5916;pass:END;sub:END;*/

Shader "Shader Forge/ice" {
    Properties {
        _node_2640 ("node_2640", 2D) = "bump" {}
        _node_2524 ("node_2524", Range(0, 10)) = 0
        _node_5723 ("node_5723", Color) = (0.5,0.5,0.5,1)
        _node_2830 ("node_2830", Range(0, 1)) = 0
        _node_252 ("node_252", Range(0, 1)) = 0
        _node_3851 ("node_3851", Color) = (0.5,0.5,0.5,1)
        _node_6720 ("node_6720", Color) = (0.5,0.5,0.5,1)
        _node_9872 ("node_9872", Cube) = "_Skybox" {}
        _node_3714 ("node_3714", Range(0, 10)) = 0
        _node_7962 ("node_7962", Range(0, 10)) = 0
        _node_6192 ("node_6192", 2D) = "white" {}
        _node_4621 ("node_4621", Color) = (0.5,0.5,0.5,1)
        _node_41 ("node_41", Color) = (0.5,0.5,0.5,1)
        _node_6087 ("node_6087", Range(0, 20)) = 0
        _node_5263 ("node_5263", 2D) = "bump" {}
        _node_4612 ("node_4612", Range(0, 1)) = 0
        _node_180 ("node_180", 2D) = "white" {}
        _node_5011 ("node_5011", Color) = (0.5,0.5,0.5,1)
        _node_8771 ("node_8771", Range(0, 1)) = 0
        _node_628 ("node_628", Color) = (0.5,0.5,0.5,1)
        _node_8792 ("node_8792", Range(0, 10)) = 0
        _rim_power ("rim_power", Range(0, 10)) = 2.925201
        _rim_color ("rim_color", Color) = (0.5,0.5,0.5,1)
        _rim_range ("rim_range", Range(0, 5)) = 0
    }
    SubShader {
        Tags {
            "RenderType"="Opaque"
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma multi_compile_fog
           // #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            uniform float4 _LightColor0;
            uniform sampler2D _node_2640; uniform float4 _node_2640_ST;
            uniform float _node_2524;
            uniform float4 _node_5723;
            uniform float _node_2830;
            uniform float _node_252;
            uniform float4 _node_3851;
            uniform float4 _node_6720;
            uniform samplerCUBE _node_9872;
            uniform float _node_3714;
            uniform float _node_7962;
            uniform sampler2D _node_6192; uniform float4 _node_6192_ST;
            uniform float4 _node_4621;
            uniform float4 _node_41;
            uniform float _node_6087;
            uniform sampler2D _node_180; uniform float4 _node_180_ST;
            uniform float4 _node_5011;
            uniform float4 _node_628;
            uniform float _node_8792;
            uniform float _rim_power;
            uniform float4 _rim_color;
            uniform float _rim_range;
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
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3x3 tangentTransform = float3x3( i.tangentDir, i.bitangentDir, i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 _node_2640_var = UnpackNormal(tex2D(_node_2640,TRANSFORM_TEX(i.uv0, _node_2640)));
                float3 normalLocal = _node_2640_var.rgb;
                float3 normalDirection = normalize(mul( normalLocal, tangentTransform )); // Perturbed normals
                float3 viewReflectDirection = reflect( -viewDirection, normalDirection );
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float3 lightColor = _LightColor0.rgb;
                float3 halfDirection = normalize(viewDirection+lightDirection);
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float3 attenColor = attenuation * _LightColor0.xyz;
///////// Gloss:
                float gloss = _node_252;
                float specPow = exp2( gloss * 10.0 + 1.0 );
////// Specular:
                float NdotL = saturate(dot( normalDirection, lightDirection ));
                float3 specularColor = (_node_2830*_node_628.rgb);
                float3 directSpecular = attenColor * pow(max(0,dot(halfDirection,normalDirection)),specPow)*specularColor;
                float3 indirectSpecular = (0 + (texCUBElod(_node_9872,float4(viewReflectDirection,_node_3714)).rgb*_node_7962*_node_41.rgb))*specularColor;
                float3 specular = (directSpecular + indirectSpecular);
/////// Diffuse:
                NdotL = dot( normalDirection, lightDirection );
                float3 w = _node_6720.rgb*0.5; // Light wrapping
                float3 NdotLWrap = NdotL * ( 1.0 - w );
                float3 forwardLight = max(float3(0.0,0.0,0.0), NdotLWrap + w );
                float3 backLight = max(float3(0.0,0.0,0.0), -NdotLWrap + w ) * _node_3851.rgb;
                NdotL = max(0.0,dot( normalDirection, lightDirection ));
                float3 directDiffuse = (forwardLight+backLight) * attenColor;
                float3 indirectDiffuse = float3(0,0,0);
                indirectDiffuse += UNITY_LIGHTMODEL_AMBIENT.rgb; // Ambient Light
                float4 _node_180_var = tex2D(_node_180,TRANSFORM_TEX(i.uv0, _node_180));
                float3 node_2119 = (_node_180_var.rgb*_node_5011.rgb);
                float3 diffuseColor = lerp(node_2119,((pow(1.0-max(0,dot(normalDirection, viewDirection)),_rim_power)*_rim_color.rgb*3.0)+node_2119),_rim_range);
                float3 diffuse = (directDiffuse + indirectDiffuse) * diffuseColor;
////// Emissive:
                float4 _node_6192_var = tex2D(_node_6192,TRANSFORM_TEX(i.uv0, _node_6192));
                float3 emissive = (((pow((1.0-max(0,dot(normalDirection, viewDirection))),_node_2524)*_node_8792)*_node_5723.rgb)+(_node_6192_var.rgb*_node_4621.rgb*_node_6087));
/// Final Color:
                float3 finalColor = diffuse + specular + emissive;
                fixed4 finalRGBA = fixed4(finalColor,1);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
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
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDADD
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdadd_fullshadows
            #pragma multi_compile_fog
           // #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            uniform float4 _LightColor0;
            uniform sampler2D _node_2640; uniform float4 _node_2640_ST;
            uniform float _node_2524;
            uniform float4 _node_5723;
            uniform float _node_2830;
            uniform float _node_252;
            uniform float4 _node_3851;
            uniform float4 _node_6720;
            uniform sampler2D _node_6192; uniform float4 _node_6192_ST;
            uniform float4 _node_4621;
            uniform float _node_6087;
            uniform sampler2D _node_180; uniform float4 _node_180_ST;
            uniform float4 _node_5011;
            uniform float4 _node_628;
            uniform float _node_8792;
            uniform float _rim_power;
            uniform float4 _rim_color;
            uniform float _rim_range;
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
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3x3 tangentTransform = float3x3( i.tangentDir, i.bitangentDir, i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 _node_2640_var = UnpackNormal(tex2D(_node_2640,TRANSFORM_TEX(i.uv0, _node_2640)));
                float3 normalLocal = _node_2640_var.rgb;
                float3 normalDirection = normalize(mul( normalLocal, tangentTransform )); // Perturbed normals
                float3 lightDirection = normalize(lerp(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz - i.posWorld.xyz,_WorldSpaceLightPos0.w));
                float3 lightColor = _LightColor0.rgb;
                float3 halfDirection = normalize(viewDirection+lightDirection);
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float3 attenColor = attenuation * _LightColor0.xyz;
///////// Gloss:
                float gloss = _node_252;
                float specPow = exp2( gloss * 10.0 + 1.0 );
////// Specular:
                float NdotL = saturate(dot( normalDirection, lightDirection ));
                float3 specularColor = (_node_2830*_node_628.rgb);
                float3 directSpecular = attenColor * pow(max(0,dot(halfDirection,normalDirection)),specPow)*specularColor;
                float3 specular = directSpecular;
/////// Diffuse:
                NdotL = dot( normalDirection, lightDirection );
                float3 w = _node_6720.rgb*0.5; // Light wrapping
                float3 NdotLWrap = NdotL * ( 1.0 - w );
                float3 forwardLight = max(float3(0.0,0.0,0.0), NdotLWrap + w );
                float3 backLight = max(float3(0.0,0.0,0.0), -NdotLWrap + w ) * _node_3851.rgb;
                NdotL = max(0.0,dot( normalDirection, lightDirection ));
                float3 directDiffuse = (forwardLight+backLight) * attenColor;
                float4 _node_180_var = tex2D(_node_180,TRANSFORM_TEX(i.uv0, _node_180));
                float3 node_2119 = (_node_180_var.rgb*_node_5011.rgb);
                float3 diffuseColor = lerp(node_2119,((pow(1.0-max(0,dot(normalDirection, viewDirection)),_rim_power)*_rim_color.rgb*3.0)+node_2119),_rim_range);
                float3 diffuse = directDiffuse * diffuseColor;
/// Final Color:
                float3 finalColor = diffuse + specular;
                fixed4 finalRGBA = fixed4(finalColor * 1,0);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
