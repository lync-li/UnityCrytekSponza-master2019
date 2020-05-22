// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)

using System;
using UnityEngine;

namespace UnityEditor
{
    internal class ExtendStandardShaderGUI : ShaderGUI
    {
        public enum BlendMode
        {
            Opaque,
            Cutout,
            Fade,   // Old school alpha-blending mode, fresnel does not affect amount of transparency
            Transparent,// Physically plausible transparency mode, implemented as alpha pre-multiply
        }

        public enum SmoothnessMapChannel
        {
            SpecularMetallicAlpha,
            //AlbedoAlpha,
            MetallicG,
        }

        public enum DetailBlendMode
        {
            Mulx2,
            Mul,    
            Add,
            Lerp
        }

        public enum EmissionMode
        {
            None = 0,
            Unity,
            Type0
        }

        private static class Styles
        {
            public static GUIContent uvSetLabel = EditorGUIUtility.TrTextContent("UV Set");

            public static GUIContent albedoText = EditorGUIUtility.TrTextContent("Albedo", "Albedo (RGB) and Transparency (A)");
            public static GUIContent alphaCutoffText = EditorGUIUtility.TrTextContent("Alpha Cutoff", "Threshold for alpha cutoff");
            public static GUIContent metallicMapText = EditorGUIUtility.TrTextContent("Metallic", "Metallic (R) and Smoothness (A)");
            public static GUIContent smoothnessText = EditorGUIUtility.TrTextContent("Smoothness", "Smoothness value");
            public static GUIContent smoothnessScaleText = EditorGUIUtility.TrTextContent("Smoothness", "Smoothness scale factor");
            public static GUIContent smoothnessMapChannelText = EditorGUIUtility.TrTextContent("Source", "Smoothness texture and channel");
            public static GUIContent normalMapText = EditorGUIUtility.TrTextContent("Normal Map", "Normal Map");
            public static GUIContent heightMapText = EditorGUIUtility.TrTextContent("Height Map", "Height Map (G)");
            public static GUIContent occlusionText = EditorGUIUtility.TrTextContent("Occlusion", "Occlusion (G)");          
            public static GUIContent detailMaskText = EditorGUIUtility.TrTextContent("Detail Mask", "Mask for Secondary Maps (A)");
            public static GUIContent detailAlbedoText = EditorGUIUtility.TrTextContent("Detail Albedo x2", "Albedo (RGB) multiplied by 2");
            public static GUIContent detailNormalMapText = EditorGUIUtility.TrTextContent("Normal Map", "Normal Map");
            public static GUIContent vertexAlphaText = EditorGUIUtility.TrTextContent("顶点色影响Alpha", "Vertex Alpha");
            public static GUIContent vertexAlphaValueText = EditorGUIUtility.TrTextContent("Vertex Alpha Value", "Vertex Alpha Value");
            public static GUIContent extendAlphaText = EditorGUIUtility.TrTextContent("扩展用于特效层", "Extend Alpha");
			public static GUIContent playerText = EditorGUIUtility.TrTextContent("角色层", "Player");
            public static GUIContent doubleSideText = EditorGUIUtility.TrTextContent("双面", "DoubleSide");
            public static GUIContent zWriteText = EditorGUIUtility.TrTextContent("深度写入", "ZWrite");
            public static GUIContent receiveFogText = EditorGUIUtility.TrTextContent("雾效影响", "ReceiveFog");
            public static GUIContent rimEnableText = EditorGUIUtility.TrTextContent("Rim开启", "Rim开启");
            public static GUIContent rimColorText = EditorGUIUtility.TrTextContent("RimColor", "RimColor");
            public static GUIContent rimPowerText = EditorGUIUtility.TrTextContent("RimPower", "RimPower");
            public static GUIContent vertexColorEnableText = EditorGUIUtility.TrTextContent("顶点色开启", "VertexColorEnable");
            public static GUIContent vertexColorText = EditorGUIUtility.TrTextContent("Color", "VertexColor");
            public static GUIContent detailBlendModeText = EditorGUIUtility.TrTextContent("DetailBlendMode", "DetailBlendMode");

            public static GUIContent emissionModeText = EditorGUIUtility.TrTextContent("EmissionMode", "EmissionMode");
            public static GUIContent emissionText = EditorGUIUtility.TrTextContent("Color", "Emission (RGB)");           
            public static GUIContent emission1Text = EditorGUIUtility.TrTextContent("Color1", "Emission1 (RGB)");           
            public static GUIContent emissionAlphaAndBaseColorText = EditorGUIUtility.TrTextContent("EmissionAlphaAndBaseColor", "EmissionAlphaAndBaseColor");

            public static GUIContent vertexAnimationText = EditorGUIUtility.TrTextContent("顶点动画", "");
            public static GUIContent moveRangeText = EditorGUIUtility.TrTextContent("移动范围", "");
            public static GUIContent moveRandomText = EditorGUIUtility.TrTextContent("移动随机", "");
            public static GUIContent moveRateText = EditorGUIUtility.TrTextContent("移动速度", "");

            public static GUIContent uvAnimationText = EditorGUIUtility.TrTextContent("UV动画", "");

            public static string primaryMapsText = "Main Maps";
            public static string secondaryMapsText = "Secondary Maps";
            public static string renderingMode = "Rendering Mode";
            public static string advancedText = "Advanced Options";
            public static readonly string[] blendNames = Enum.GetNames(typeof(BlendMode));
        }

        MaterialProperty blendMode = null;
        MaterialProperty albedoMap = null;
        MaterialProperty albedoColor = null;
        MaterialProperty alphaCutoff = null;
        MaterialProperty metallicMap = null;
        MaterialProperty metallic = null;
        MaterialProperty smoothness = null;
        MaterialProperty smoothnessScale = null;
        MaterialProperty smoothnessMapChannel = null;
        MaterialProperty bumpScale = null;
        MaterialProperty bumpMap = null;
        MaterialProperty occlusionStrength = null;
        MaterialProperty occlusionMap = null;
        MaterialProperty heigtMapScale = null;
        MaterialProperty heightMap = null;
      
        MaterialProperty detailMask = null;
        MaterialProperty detailBlendMode = null;
        MaterialProperty detailAlbedoMap = null;
        MaterialProperty detailNormalMapScale = null;
        MaterialProperty detailNormalMap = null;
        MaterialProperty vertexAlpha = null;
        MaterialProperty vertexAlphaValue = null;
        MaterialProperty extendAlpha = null;
		MaterialProperty player = null;
        MaterialProperty doubleSide = null;
        MaterialProperty zWrite = null;
        MaterialProperty receiveFog = null;
        MaterialProperty rimEnable = null;
        MaterialProperty rimColor = null;
        MaterialProperty rimPower = null;
        MaterialProperty vertexColorEnable = null;
        MaterialProperty vertexColor = null;

        MaterialProperty emissionMode = null;
        MaterialProperty emissionColorForRendering = null;
        MaterialProperty emissionMap = null;
        MaterialProperty emissionColorForRendering1 = null;
        MaterialProperty emissionMap1 = null;
        MaterialProperty emissionBaseColor = null;
        MaterialProperty emissionAlpha = null;

        MaterialProperty vertexAnimation = null;
        MaterialProperty moveRange = null;
        MaterialProperty moveRandom = null;
        MaterialProperty moveRate = null;

        MaterialProperty uvAnimation = null;

        MaterialProperty uvSetSecondary = null;

        MaterialEditor m_MaterialEditor;

        bool m_FirstTimeApply = true;

        public void FindProperties(MaterialProperty[] props)
        {
            blendMode = FindProperty("_Mode", props);
            albedoMap = FindProperty("_MainTex", props);
            albedoColor = FindProperty("_Color", props);
            alphaCutoff = FindProperty("_Cutoff", props);
      
            metallicMap = FindProperty("_MetallicGlossMap", props, false);
            metallic = FindProperty("_Metallic", props, false);         
            smoothness = FindProperty("_Glossiness", props);
            smoothnessScale = FindProperty("_GlossMapScale", props, false);
            smoothnessMapChannel = FindProperty("_SmoothnessTextureChannel", props, false);
            bumpScale = FindProperty("_BumpScale", props);
            bumpMap = FindProperty("_BumpMap", props);
            heigtMapScale = FindProperty("_Parallax", props);
            heightMap = FindProperty("_ParallaxMap", props);
            occlusionStrength = FindProperty("_OcclusionStrength", props);
            occlusionMap = FindProperty("_OcclusionMap", props);           

            detailMask = FindProperty("_DetailMask", props);
            detailBlendMode = FindProperty("_DetailBlendMode", props);
            detailAlbedoMap = FindProperty("_DetailAlbedoMap", props);
            detailNormalMapScale = FindProperty("_DetailNormalMapScale", props);
            detailNormalMap = FindProperty("_DetailNormalMap", props);

            vertexAlpha = FindProperty("_VertexAlpha", props);
            vertexAlphaValue = FindProperty("_VertexColorAlpha", props);

            extendAlpha = FindProperty("_ExtendAlpha", props);
			player = FindProperty("_Player", props);
            doubleSide = FindProperty("_Cull", props);
            zWrite = FindProperty("_ZWrite", props);
            receiveFog = FindProperty("_ReceiveFog", props);

            rimEnable = FindProperty("_RimEnable", props);
            rimColor = FindProperty("_RimColor", props);
            rimPower = FindProperty("_RimPower", props);

            vertexColorEnable = FindProperty("_VertexColorEnable", props);
            vertexColor = FindProperty("_VertexColor", props);

            emissionMode = FindProperty("_EmissionMode", props);
            emissionColorForRendering = FindProperty("_EmissionColor", props);
            emissionMap = FindProperty("_EmissionMap", props);          
            emissionColorForRendering1 = FindProperty("_EmissionColor1", props);
            emissionMap1 = FindProperty("_EmissionMap1", props);           
            emissionBaseColor = FindProperty("_EmissionBaseColor", props);
            emissionAlpha = FindProperty("_EmissionAlpha", props);

            vertexAnimation = FindProperty("_VertexAnimation", props);
            moveRange = FindProperty("_MoveRange", props);
            moveRandom = FindProperty("_MoveRandom", props);
            moveRate = FindProperty("_MoveRate", props);

            uvAnimation = FindProperty("_UVAnimation", props);

            uvSetSecondary = FindProperty("_UVSec", props);
        }

        public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] props)
        {
            FindProperties(props); // MaterialProperties can be animated so we do not cache them but fetch them every event to ensure animated values are updated correctly
            m_MaterialEditor = materialEditor;
            Material material = materialEditor.target as Material;

            // Make sure that needed setup (ie keywords/renderqueue) are set up if we're switching some existing
            // material to a standard shader.
            // Do this before any GUI code has been issued to prevent layout issues in subsequent GUILayout statements (case 780071)
            if (m_FirstTimeApply)
            {
                // Save old render queue...
                int renderQueue = material.renderQueue;
                MaterialChanged(material);
                material.renderQueue = renderQueue;
                m_FirstTimeApply = false;
            }

            ShaderPropertiesGUI(material);
        }

        public void ShaderPropertiesGUI(Material material)
        {
            // Use default labelWidth
            EditorGUIUtility.labelWidth = 0f;				

            // Detect any changes to the material
            EditorGUI.BeginChangeCheck();
            {
                BlendModePopup();
			}

			if (EditorGUI.EndChangeCheck())
            {
                foreach (var obj in blendMode.targets)
                    MaterialChanged((Material)obj);
            }

            EditorGUI.BeginChangeCheck();
            {
                EditorGUILayout.Space();

                if ((BlendMode)material.GetFloat("_Mode") == BlendMode.Opaque || (BlendMode)material.GetFloat("_Mode") == BlendMode.Cutout)
                {
                    m_MaterialEditor.ShaderProperty(player, Styles.playerText.text);
                }

                TwoSidedPopup(material);

                if((BlendMode)material.GetFloat("_Mode") == BlendMode.Opaque || (BlendMode)material.GetFloat("_Mode") == BlendMode.Cutout)
                {
                    m_MaterialEditor.ShaderProperty(vertexColorEnable, Styles.vertexColorEnableText.text);
                    if (vertexColorEnable.floatValue == 1)
                    {
                        m_MaterialEditor.ShaderProperty(vertexColor, Styles.vertexColorText.text, MaterialEditor.kMiniTextureFieldLabelIndentLevel);
                    }
                }

                if ((BlendMode)material.GetFloat("_Mode") == BlendMode.Fade || (BlendMode)material.GetFloat("_Mode") == BlendMode.Transparent)
                {
                    m_MaterialEditor.ShaderProperty(vertexAlpha, Styles.vertexAlphaText.text);
                    if (vertexAlpha.floatValue == 1)
                    {
                        m_MaterialEditor.ShaderProperty(vertexAlphaValue, Styles.vertexAlphaValueText.text, MaterialEditor.kMiniTextureFieldLabelIndentLevel);
                    }

                    m_MaterialEditor.ShaderProperty(extendAlpha, Styles.extendAlphaText.text);

                    ZWritePopup(material);
                }

                m_MaterialEditor.ShaderProperty(receiveFog, Styles.receiveFogText.text);

                DoVertexAnimation();


                DoRimArea(material);
                EditorGUILayout.Space();

                EditorGUILayout.Space();

                // Primary properties
                GUILayout.Label(Styles.primaryMapsText, EditorStyles.boldLabel);
                DoAlbedoArea(material);
                m_MaterialEditor.TextureScaleOffsetProperty(albedoMap);
                m_MaterialEditor.ShaderProperty(uvAnimation, Styles.uvAnimationText.text);
                EditorGUILayout.Space();

                DoSpecularMetallicArea();
                EditorGUILayout.Space();

                DoNormalArea();

                EditorGUILayout.Space();

                m_MaterialEditor.TexturePropertySingleLine(Styles.heightMapText, heightMap, heightMap.textureValue != null ? heigtMapScale : null);
                EditorGUILayout.Space();

                m_MaterialEditor.TexturePropertySingleLine(Styles.occlusionText, occlusionMap, occlusionMap.textureValue != null ? occlusionStrength : null);
                EditorGUILayout.Space();

                DoEmissionArea(material);
                EditorGUILayout.Space();

                EditorGUI.BeginChangeCheck();
                
                if (EditorGUI.EndChangeCheck())
                    emissionMap.textureScaleAndOffset = albedoMap.textureScaleAndOffset; // Apply the main texture scale and offset to the emission texture as well, for Enlighten's sake

                EditorGUILayout.Space();

                // Secondary properties
                GUILayout.Label(Styles.secondaryMapsText, EditorStyles.boldLabel);
                m_MaterialEditor.ShaderProperty(detailBlendMode, Styles.detailBlendModeText.text);
                m_MaterialEditor.TexturePropertySingleLine(Styles.detailMaskText, detailMask);              
                m_MaterialEditor.TextureScaleOffsetProperty(detailMask);

                EditorGUILayout.Space();

                m_MaterialEditor.TexturePropertySingleLine(Styles.detailAlbedoText, detailAlbedoMap);
                m_MaterialEditor.TextureScaleOffsetProperty(detailAlbedoMap);

                EditorGUILayout.Space();

                m_MaterialEditor.TexturePropertySingleLine(Styles.detailNormalMapText, detailNormalMap, detailNormalMapScale);                

                m_MaterialEditor.ShaderProperty(uvSetSecondary, Styles.uvSetLabel.text);
				m_MaterialEditor.RenderQueueField();				
            }
            if (EditorGUI.EndChangeCheck())
            {
                foreach (var obj in blendMode.targets)
                    // MaterialChanged((Material)obj, m_WorkflowMode);
                    SetMaterialKeywords((Material)obj);
            }

            EditorGUILayout.Space();
            

            // NB renderqueue editor is not shown on purpose: we want to override it based on blend mode
            GUILayout.Label(Styles.advancedText, EditorStyles.boldLabel);
            m_MaterialEditor.EnableInstancingField();
            //m_MaterialEditor.DoubleSidedGIField();
        }

        public override void AssignNewShaderToMaterial(Material material, Shader oldShader, Shader newShader)
        {
            // _Emission property is lost after assigning Standard shader to the material
            // thus transfer it before assigning the new shader
            if (material.HasProperty("_Emission"))
            {
                material.SetColor("_EmissionColor", material.GetColor("_Emission"));
            }

            base.AssignNewShaderToMaterial(material, oldShader, newShader);

            if (oldShader == null || !oldShader.name.Contains("Legacy Shaders/"))
            {
                SetupMaterialWithBlendMode(material, (BlendMode)material.GetFloat("_Mode"));
                return;
            }

            BlendMode blendMode = BlendMode.Opaque;
            if (oldShader.name.Contains("/Transparent/Cutout/"))
            {
                blendMode = BlendMode.Cutout;
            }
            else if (oldShader.name.Contains("/Transparent/"))
            {
                // NOTE: legacy shaders did not provide physically based transparency
                // therefore Fade mode
                blendMode = BlendMode.Fade;
            }
            material.SetFloat("_Mode", (float)blendMode);

            MaterialChanged(material);
        }

        void BlendModePopup()
        {
            EditorGUI.showMixedValue = blendMode.hasMixedValue;
            var mode = (BlendMode)blendMode.floatValue;

            EditorGUI.BeginChangeCheck();
            mode = (BlendMode)EditorGUILayout.Popup(Styles.renderingMode, (int)mode, Styles.blendNames);
            if (EditorGUI.EndChangeCheck())
            {
                m_MaterialEditor.RegisterPropertyChangeUndo("Rendering Mode");
                blendMode.floatValue = (float)mode;
            }

            EditorGUI.showMixedValue = false;
        }

        void TwoSidedPopup(Material material)
        {
            EditorGUI.showMixedValue = doubleSide.hasMixedValue;
            var enabled = (doubleSide.floatValue == (float)UnityEngine.Rendering.CullMode.Off);

            EditorGUI.BeginChangeCheck();
            enabled = EditorGUILayout.Toggle(Styles.doubleSideText, enabled);
            if (EditorGUI.EndChangeCheck())
            {
                m_MaterialEditor.RegisterPropertyChangeUndo("Two Sided Enabled");
                doubleSide.floatValue = enabled ? (float)UnityEngine.Rendering.CullMode.Off : (float)UnityEngine.Rendering.CullMode.Back;
            }

            EditorGUI.showMixedValue = false;
        }

        void ZWritePopup(Material material)
        {
            EditorGUI.showMixedValue = zWrite.hasMixedValue;
            var enabled = (zWrite.floatValue == 1);

            EditorGUI.BeginChangeCheck();
            enabled = EditorGUILayout.Toggle(Styles.zWriteText, enabled);
            if (EditorGUI.EndChangeCheck())
            {
                m_MaterialEditor.RegisterPropertyChangeUndo("ZWrite Enabled");
                zWrite.floatValue = enabled ? 1 : 0;
            }

            EditorGUI.showMixedValue = false;
        }
        void DoVertexAnimation()
        {
            m_MaterialEditor.ShaderProperty(vertexAnimation, Styles.vertexAnimationText.text);
            if (vertexAnimation.floatValue == 1)
            {
                m_MaterialEditor.ShaderProperty(moveRange, Styles.moveRangeText.text, MaterialEditor.kMiniTextureFieldLabelIndentLevel);
                m_MaterialEditor.ShaderProperty(moveRandom, Styles.moveRandomText.text, MaterialEditor.kMiniTextureFieldLabelIndentLevel);
                m_MaterialEditor.ShaderProperty(moveRate, Styles.moveRateText.text, MaterialEditor.kMiniTextureFieldLabelIndentLevel);
            }
        }
        void DoNormalArea()
        {
            m_MaterialEditor.TexturePropertySingleLine(Styles.normalMapText, bumpMap, bumpMap.textureValue != null ? bumpScale : null);
            m_MaterialEditor.TextureScaleOffsetProperty(bumpMap);
            // if (bumpScale.floatValue != 1 && UnityEditorInternal.InternalEditorUtility.IsMobilePlatform(EditorUserBuildSettings.activeBuildTarget))
            //  if (m_MaterialEditor.HelpBoxWithButton(
            //     EditorGUIUtility.TrTextContent("Bump scale is not supported on mobile platforms"),
            //     EditorGUIUtility.TrTextContent("Fix Now")))
            // {
            //      bumpScale.floatValue = 1;
            // }
        }

        void DoAlbedoArea(Material material)
        {
            m_MaterialEditor.TexturePropertyWithHDRColor(Styles.albedoText, albedoMap, albedoColor,true);
            if (((BlendMode)material.GetFloat("_Mode") == BlendMode.Cutout))
            {
                m_MaterialEditor.ShaderProperty(alphaCutoff, Styles.alphaCutoffText.text, MaterialEditor.kMiniTextureFieldLabelIndentLevel + 1);
            }
        }

        void DoEmissionArea(Material material)
        {
            // Emission for GI?
            m_MaterialEditor.ShaderProperty(emissionMode, Styles.emissionModeText.text);
            if ((EmissionMode)material.GetFloat("_EmissionMode") == EmissionMode.Unity)
            {
                bool hadEmissionTexture = emissionMap.textureValue != null;

                // Texture and HDR color controls
                m_MaterialEditor.TexturePropertyWithHDRColor(Styles.emissionText, emissionMap, emissionColorForRendering, false);
                m_MaterialEditor.TextureScaleOffsetProperty(emissionMap);

                // If texture was assigned and color was black set color to white
                float brightness = emissionColorForRendering.colorValue.maxColorComponent;
                if (emissionMap.textureValue != null && !hadEmissionTexture && brightness <= 0f)
                    emissionColorForRendering.colorValue = Color.white;
                // change the GI flag and fix it up with emissive as black if necessary
                //m_MaterialEditor.LightmapEmissionFlagsProperty(MaterialEditor.kMiniTextureFieldLabelIndentLevel, true);
            }
            else if((EmissionMode)material.GetFloat("_EmissionMode") == EmissionMode.Type0)
            {
                //bool hadEmissionTexture = emissionMap.textureValue != null;

                // Texture and HDR color controls
                m_MaterialEditor.TexturePropertyWithHDRColor(Styles.emissionText, emissionMap, emissionColorForRendering, false);
                m_MaterialEditor.TextureScaleOffsetProperty(emissionMap);
                EditorGUILayout.Space();

                m_MaterialEditor.TexturePropertyWithHDRColor(Styles.emission1Text, emissionMap1, emissionColorForRendering1, false);
                m_MaterialEditor.TextureScaleOffsetProperty(emissionMap1);

                EditorGUILayout.Space();
                m_MaterialEditor.TexturePropertyWithHDRColor(Styles.emissionAlphaAndBaseColorText, emissionAlpha, emissionBaseColor, false);
                m_MaterialEditor.TextureScaleOffsetProperty(emissionAlpha);

                //m_MaterialEditor.ShaderProperty(emissionBaseColor, Styles.emissionBaseColorText.text);
                // m_MaterialEditor.TextureProperty(emissionAlpha, Styles.emissionAlphaText.text);
                // If texture was assigned and color was black set color to white
                //float brightness = emissionColorForRendering.colorValue.maxColorComponent;
                //if (emissionMap.textureValue != null && !hadEmissionTexture && brightness <= 0f)
                //    emissionColorForRendering.colorValue = Color.white;
            }
        }

        void DoRimArea(Material material)
        {
            m_MaterialEditor.ShaderProperty(rimEnable, Styles.rimEnableText.text);
            if (rimEnable.floatValue == 1)
            {
                m_MaterialEditor.ShaderProperty(rimColor, Styles.rimColorText.text, MaterialEditor.kMiniTextureFieldLabelIndentLevel);
                m_MaterialEditor.ShaderProperty(rimPower, Styles.rimPowerText.text, MaterialEditor.kMiniTextureFieldLabelIndentLevel);
            }           
        }

        void DoSpecularMetallicArea()
        {
            bool hasGlossMap = false;   

            hasGlossMap = metallicMap.textureValue != null;
            m_MaterialEditor.TexturePropertySingleLine(Styles.metallicMapText, metallicMap, hasGlossMap ? null : metallic);

            bool showSmoothnessScale = hasGlossMap;
            if (smoothnessMapChannel != null)
            {
                int smoothnessChannel = (int)smoothnessMapChannel.floatValue;
                //if (smoothnessChannel == (int)SmoothnessMapChannel.AlbedoAlpha)
                //    showSmoothnessScale = true;
            }

            int indentation = 2; // align with labels of texture properties
            m_MaterialEditor.ShaderProperty(showSmoothnessScale ? smoothnessScale : smoothness, showSmoothnessScale ? Styles.smoothnessScaleText : Styles.smoothnessText, indentation);

            ++indentation;
            if (smoothnessMapChannel != null)
                m_MaterialEditor.ShaderProperty(smoothnessMapChannel, Styles.smoothnessMapChannelText, indentation);
        }

        public static void SetupMaterialWithBlendMode(Material material, BlendMode blendMode)
        {
            switch (blendMode)
            {
                case BlendMode.Opaque:
                    material.SetOverrideTag("RenderType", "");
                    material.SetInt("_SrcBlend", (int)UnityEngine.Rendering.BlendMode.One);
                    material.SetInt("_DstBlend", (int)UnityEngine.Rendering.BlendMode.Zero);
                    material.SetInt("_SrcAlpha", (int)UnityEngine.Rendering.BlendMode.One);
                    material.SetInt("_DstAlpha", (int)UnityEngine.Rendering.BlendMode.Zero);
                    material.SetInt("_ZWrite", 1);
                    material.DisableKeyword("_ALPHATEST_ON");
                    material.DisableKeyword("_ALPHABLEND_ON");
                    material.DisableKeyword("_ALPHAPREMULTIPLY_ON");					
                    material.renderQueue = -1;
                    break;
                case BlendMode.Cutout:
                    material.SetOverrideTag("RenderType", "TransparentCutout");
                    material.SetInt("_SrcBlend", (int)UnityEngine.Rendering.BlendMode.One);
                    material.SetInt("_DstBlend", (int)UnityEngine.Rendering.BlendMode.Zero);
                    material.SetInt("_SrcAlpha", (int)UnityEngine.Rendering.BlendMode.One);
                    material.SetInt("_DstAlpha", (int)UnityEngine.Rendering.BlendMode.Zero);
                    material.SetInt("_ZWrite", 1);
                    material.EnableKeyword("_ALPHATEST_ON");
                    material.DisableKeyword("_ALPHABLEND_ON");
                    material.DisableKeyword("_ALPHAPREMULTIPLY_ON");					
                    material.renderQueue = (int)UnityEngine.Rendering.RenderQueue.AlphaTest;
                    break;
                case BlendMode.Fade:
                    material.SetOverrideTag("RenderType", "Transparent");
                    material.SetInt("_SrcBlend", (int)UnityEngine.Rendering.BlendMode.SrcAlpha);
                    material.SetInt("_DstBlend", (int)UnityEngine.Rendering.BlendMode.OneMinusSrcAlpha);
                    material.SetInt("_SrcAlpha", (int)UnityEngine.Rendering.BlendMode.Zero);
                    material.SetInt("_DstAlpha", (int)UnityEngine.Rendering.BlendMode.OneMinusSrcAlpha);
                   // material.SetInt("_ZWrite", 0);
                    material.DisableKeyword("_ALPHATEST_ON");
                    material.EnableKeyword("_ALPHABLEND_ON");
                    material.DisableKeyword("_ALPHAPREMULTIPLY_ON");					
                    material.renderQueue = (int)UnityEngine.Rendering.RenderQueue.Transparent;
                    break;
                case BlendMode.Transparent:
                    material.SetOverrideTag("RenderType", "Transparent");
                    material.SetInt("_SrcBlend", (int)UnityEngine.Rendering.BlendMode.One);
                    material.SetInt("_DstBlend", (int)UnityEngine.Rendering.BlendMode.OneMinusSrcAlpha);
                    material.SetInt("_SrcAlpha", (int)UnityEngine.Rendering.BlendMode.Zero);
                    material.SetInt("_DstAlpha", (int)UnityEngine.Rendering.BlendMode.OneMinusSrcAlpha);
                   // material.SetInt("_ZWrite", 0);
                    material.DisableKeyword("_ALPHATEST_ON");
                    material.DisableKeyword("_ALPHABLEND_ON");
                    material.EnableKeyword("_ALPHAPREMULTIPLY_ON");                   
                    material.renderQueue = (int)UnityEngine.Rendering.RenderQueue.Transparent;
                    break;       
            }
        }

        static SmoothnessMapChannel GetSmoothnessMapChannel(Material material)
        {
            int ch = (int)material.GetFloat("_SmoothnessTextureChannel");
            //if (ch == (int)SmoothnessMapChannel.AlbedoAlpha)
            //    return SmoothnessMapChannel.AlbedoAlpha;
            if(ch == (int)SmoothnessMapChannel.SpecularMetallicAlpha)
                return SmoothnessMapChannel.SpecularMetallicAlpha;
            else 
                return SmoothnessMapChannel.MetallicG;
        }

        static void SetMaterialKeywords(Material material)
        {
            // Note: keywords must be based on Material value not on MaterialProperty due to multi-edit & material animation
            // (MaterialProperty value might come from renderer material property block)
            SetKeyword(material, "_NORMALMAP", material.GetTexture("_BumpMap") || material.GetTexture("_DetailNormalMap"));
            SetKeyword(material, "_METALLICGLOSSMAP", material.GetTexture("_MetallicGlossMap"));
            SetKeyword(material, "_PARALLAXMAP", material.GetTexture("_ParallaxMap"));

            if(material.GetTexture("_DetailAlbedoMap") || material.GetTexture("_DetailNormalMap"))
            {
                switch (material.GetFloat("_DetailBlendMode"))
                {
                    case 0:
                        SetKeyword(material, "_DETAIL_MULX2", true);
                        SetKeyword(material, "_DETAIL_MUL", false);
                        SetKeyword(material, "_DETAIL_ADD", false);
                        SetKeyword(material, "_DETAIL_LERP", false);
                        break;
                    case 1:
                        SetKeyword(material, "_DETAIL_MULX2", false);
                        SetKeyword(material, "_DETAIL_MUL", true);
                        SetKeyword(material, "_DETAIL_ADD", false);
                        SetKeyword(material, "_DETAIL_LERP", false);
                        break;
                    case 2:
                        SetKeyword(material, "_DETAIL_MULX2", false);
                        SetKeyword(material, "_DETAIL_MUL", false);
                        SetKeyword(material, "_DETAIL_ADD", true);
                        SetKeyword(material, "_DETAIL_LERP", false);
                        break;
                    case 3:
                        SetKeyword(material, "_DETAIL_MULX2", false);
                        SetKeyword(material, "_DETAIL_MUL", false);
                        SetKeyword(material, "_DETAIL_ADD", false);
                        SetKeyword(material, "_DETAIL_LERP", true);
                        break;
                }
            }
            else
            {
                SetKeyword(material, "_DETAIL_MULX2", false);
                SetKeyword(material, "_DETAIL_MUL", false);
                SetKeyword(material, "_DETAIL_ADD", false);
                SetKeyword(material, "_DETAIL_LERP", false);
            }
           

            if((EmissionMode)material.GetFloat("_EmissionMode") == EmissionMode.None)
            {
                SetKeyword(material, "_EMISSION_UNITY", false);
                SetKeyword(material, "_EMISSION_TYPE0", false);
            }
            else if((EmissionMode)material.GetFloat("_EmissionMode") == EmissionMode.Unity)
            {
                SetKeyword(material, "_EMISSION_UNITY", true);
                SetKeyword(material, "_EMISSION_TYPE0", false);
            }
            else if ((EmissionMode)material.GetFloat("_EmissionMode") == EmissionMode.Type0)
            {
                SetKeyword(material, "_EMISSION_UNITY", false);
                SetKeyword(material, "_EMISSION_TYPE0", true);
            }
            // A material's GI flag internally keeps track of whether emission is enabled at all, it's enabled but has no effect
            // or is enabled and may be modified at runtime. This state depends on the values of the current flag and emissive color.
            // The fixup routine makes sure that the material is in the correct state if/when changes are made to the mode or color.
           // MaterialEditor.FixupEmissiveFlag(material);

            if (material.HasProperty("_SmoothnessTextureChannel"))
            {
                //SetKeyword(material, "_SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A", GetSmoothnessMapChannel(material) == SmoothnessMapChannel.AlbedoAlpha);
                SetKeyword(material, "_SMOOTHNESS_TEXTURE_METAL_G", GetSmoothnessMapChannel(material) == SmoothnessMapChannel.MetallicG);
            }           

            SetKeyword(material, "_EXTENDALPHA", (BlendMode)material.GetFloat("_Mode") == BlendMode.Transparent && material.GetFloat("_ExtendAlpha") == 1);
			
			SetKeyword(material, "_PLAYER", ((BlendMode)material.GetFloat("_Mode") == BlendMode.Opaque || (BlendMode)material.GetFloat("_Mode") == BlendMode.Cutout) && material.GetFloat("_Player") == 1);

            SetKeyword(material, "_VERTEXALPHA", ((BlendMode)material.GetFloat("_Mode") == BlendMode.Transparent || (BlendMode)material.GetFloat("_Mode") == BlendMode.Fade) && material.GetFloat("_VertexAlpha") == 1);

            SetKeyword(material, "_VERTEXCOLOR", ((BlendMode)material.GetFloat("_Mode") == BlendMode.Opaque || (BlendMode)material.GetFloat("_Mode") == BlendMode.Cutout) && material.GetFloat("_VertexColorEnable") == 1);
        }

        static void MaterialChanged(Material material)
        {
            SetupMaterialWithBlendMode(material, (BlendMode)material.GetFloat("_Mode"));

            SetMaterialKeywords(material);
        }

        static void SetKeyword(Material m, string keyword, bool state)
        {
            if (state)
                m.EnableKeyword(keyword);
            else
                m.DisableKeyword(keyword);
        }
    }
} // namespace UnityEditor
