// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)

using System;
using UnityEngine;

namespace UnityEditor
{
    internal class ExtendBodyChangeColorShaderGUI : ShaderGUI
    {
        public enum BlendMode
        {
            Opaque,
            Cutout,           
            OpaqueDoubleSide,
            CutoutDoubleSide,
        }

        public enum SmoothnessMapChannel
        {
            SpecularMetallicAlpha,
            AlbedoAlpha,
        }

        private static class Styles
        {
            public static GUIContent uvSetLabel = EditorGUIUtility.TrTextContent("UV Set");

            public static GUIContent albedoText = EditorGUIUtility.TrTextContent("Albedo", "Albedo (RGB) and Transparency (A)");
			public static GUIContent alphaCutoffText = EditorGUIUtility.TrTextContent("Alpha Cutoff", "Threshold for alpha cutoff");
			
			public static GUIContent metallicMapText = EditorGUIUtility.TrTextContent("Metallic", "Metallic (R) and Smoothness (A)");			
		
        	public static GUIContent unmetalSmoothnessText = EditorGUIUtility.TrTextContent("unmetalSmoothness", "");
			public static GUIContent metalSmoothnessText = EditorGUIUtility.TrTextContent("metalSmoothness", "");
			public static GUIContent skinColorText = EditorGUIUtility.TrTextContent("skinColor", "");
			public static GUIContent capSheildColorText = EditorGUIUtility.TrTextContent("capSheildColor", "");
			public static GUIContent rimPowerText = EditorGUIUtility.TrTextContent("rimPower", "");
			public static GUIContent rimRangeText = EditorGUIUtility.TrTextContent("rimRange", "");
			public static GUIContent rimColorText = EditorGUIUtility.TrTextContent("rimColor", "");
			
			
			
			
            public static GUIContent normalMapText = EditorGUIUtility.TrTextContent("Normal Map", "Normal Map");
            public static GUIContent heightMapText = EditorGUIUtility.TrTextContent("Height Map", "Height Map (G)");
            public static GUIContent occlusionText = EditorGUIUtility.TrTextContent("Occlusion", "Occlusion (G)");
			public static GUIContent emissionText = EditorGUIUtility.TrTextContent("Color", "Emission (RGB)");
			public static GUIContent gpuAnimText = EditorGUIUtility.TrTextContent("gpuAnim", "");			
            public static GUIContent animPosTexText = EditorGUIUtility.TrTextContent("Pos Tex", "Pos Tex");
            public static GUIContent animNormalTexText = EditorGUIUtility.TrTextContent("Normal Tex", "Normal Tex");
            public static GUIContent animTangentTexText = EditorGUIUtility.TrTextContent("Tangent Tex", "Tangent Tex");
            public static GUIContent startEndFrameText = EditorGUIUtility.TrTextContent("Start End Frame", "Start End Frame");
            public static GUIContent animParam0Text = EditorGUIUtility.TrTextContent("AnimParam0", "AnimParam0");
            public static GUIContent animParam1Text = EditorGUIUtility.TrTextContent("AnimParam1", "AnimParam1");

            public static string primaryMapsText = "Main Maps";
            public static string renderingMode = "Rendering Mode";
            public static string advancedText = "Advanced Options";
            public static readonly string[] blendNames = Enum.GetNames(typeof(BlendMode));
        }

        MaterialProperty blendMode = null;
        MaterialProperty albedoMap = null;
        MaterialProperty albedoColor = null;
        MaterialProperty alphaCutoff = null;
        MaterialProperty metallicMap = null;
     
	 	
	 	MaterialProperty unmetalSmoothness = null;
		MaterialProperty metalSmoothness = null;
		MaterialProperty skinColor = null;
		MaterialProperty capSheildColor = null;
		MaterialProperty rimPower = null;
		MaterialProperty rimRange = null;
		MaterialProperty rimColor = null;	 
	 
        MaterialProperty bumpScale = null;
        MaterialProperty bumpMap = null;
        MaterialProperty occlusionStrength = null;
        MaterialProperty occlusionMap = null;
        MaterialProperty heigtMapScale = null;
        MaterialProperty heightMap = null;
        MaterialProperty emissionColorForRendering = null;
        MaterialProperty emissionMap = null;
		
    
		MaterialProperty gpuAnim = null;	
        MaterialProperty animPosTex = null;
        MaterialProperty animNormalTex = null;
        MaterialProperty animTangentTex = null;
        MaterialProperty startEndFrame = null;
        MaterialProperty animParam0 = null;
        MaterialProperty animParam1 = null;

        MaterialEditor m_MaterialEditor;

        bool m_FirstTimeApply = true;


        public void FindProperties(MaterialProperty[] props)
        {
            blendMode = FindProperty("_Mode", props);
            albedoMap = FindProperty("_MainTex", props);
            alphaCutoff = FindProperty("_Cutoff", props);      
            metallicMap = FindProperty("_MetallicGlossMap", props);
 
       		
			unmetalSmoothness = FindProperty("_unmetal_smoothness", props);
			metalSmoothness = FindProperty("_metal_smoothness", props);
			skinColor = FindProperty("_skin_color", props);
			capSheildColor = FindProperty("_cap_sheild_color", props);
			rimPower = FindProperty("_rim_power", props);
			rimRange = FindProperty("_rim_range", props);
			rimColor = FindProperty("_rim_color", props);
			
            bumpScale = FindProperty("_BumpScale", props);
            bumpMap = FindProperty("_BumpMap", props);
            heigtMapScale = FindProperty("_Parallax", props);
            heightMap = FindProperty("_ParallaxMap", props);
            occlusionStrength = FindProperty("_OcclusionStrength", props);
            occlusionMap = FindProperty("_OcclusionMap", props);
            emissionColorForRendering = FindProperty("_EmissionColor", props);
            emissionMap = FindProperty("_EmissionMap", props);


			gpuAnim = FindProperty("_GpuAnim", props);
            animPosTex = FindProperty("_AnimPosTex", props);
            animNormalTex = FindProperty("_AnimNormalTex", props);
            animTangentTex = FindProperty("_AnimTangentTex", props);
            startEndFrame = FindProperty("_StartEndFrame", props);
            animParam0 = FindProperty("_AnimParam0", props);
            animParam1 = FindProperty("_AnimParam1", props);

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
			
				m_MaterialEditor.ShaderProperty(gpuAnim, Styles.gpuAnimText);
				
				if((int)gpuAnim.floatValue == 1)
				{
					m_MaterialEditor.TexturePropertySingleLine(Styles.animPosTexText, animPosTex);
                	m_MaterialEditor.TexturePropertySingleLine(Styles.animNormalTexText, animNormalTex);
                	m_MaterialEditor.TexturePropertySingleLine(Styles.animTangentTexText, animTangentTex);
				}
				
                // Primary properties
                GUILayout.Label(Styles.primaryMapsText, EditorStyles.boldLabel);
                DoAlbedoArea(material);
                m_MaterialEditor.TexturePropertySingleLine(Styles.metallicMapText, metallicMap);
				m_MaterialEditor.ShaderProperty(unmetalSmoothness, Styles.unmetalSmoothnessText);
				m_MaterialEditor.ShaderProperty(metalSmoothness, Styles.metalSmoothnessText);
				m_MaterialEditor.ShaderProperty(skinColor, Styles.skinColorText);
				m_MaterialEditor.ShaderProperty(capSheildColor, Styles.capSheildColorText);
				m_MaterialEditor.ShaderProperty(rimPower, Styles.rimPowerText);
				m_MaterialEditor.ShaderProperty(rimRange, Styles.rimRangeText);
				m_MaterialEditor.ShaderProperty(rimColor, Styles.rimColorText);
				
                DoNormalArea();
                m_MaterialEditor.TexturePropertySingleLine(Styles.heightMapText, heightMap, heightMap.textureValue != null ? heigtMapScale : null);
                m_MaterialEditor.TexturePropertySingleLine(Styles.occlusionText, occlusionMap, occlusionMap.textureValue != null ? occlusionStrength : null);
  
                DoEmissionArea(material);
                EditorGUI.BeginChangeCheck();
                m_MaterialEditor.TextureScaleOffsetProperty(albedoMap);
                if (EditorGUI.EndChangeCheck())
                    emissionMap.textureScaleAndOffset = albedoMap.textureScaleAndOffset; // Apply the main texture scale and offset to the emission texture as well, for Enlighten's sake

                EditorGUILayout.Space();
				
			
				
                
				
				
               // m_MaterialEditor.ShaderProperty(startEndFrame, Styles.startEndFrameText);
               // m_MaterialEditor.ShaderProperty(animParam0, Styles.animParam0Text);
                //m_MaterialEditor.ShaderProperty(animParam1, Styles.animParam1Text);

                EditorGUILayout.Space();
                // Secondary properties
                
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
            m_MaterialEditor.DoubleSidedGIField();
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

        void DoNormalArea()
        {
            m_MaterialEditor.TexturePropertySingleLine(Styles.normalMapText, bumpMap, bumpMap.textureValue != null ? bumpScale : null);
            if (bumpScale.floatValue != 1 && UnityEditorInternal.InternalEditorUtility.IsMobilePlatform(EditorUserBuildSettings.activeBuildTarget))
                if (m_MaterialEditor.HelpBoxWithButton(
                    EditorGUIUtility.TrTextContent("Bump scale is not supported on mobile platforms"),
                    EditorGUIUtility.TrTextContent("Fix Now")))
                {
                    bumpScale.floatValue = 1;
                }
        }

        void DoAlbedoArea(Material material)
        {
            m_MaterialEditor.TexturePropertySingleLine(Styles.albedoText, albedoMap);
            //m_MaterialEditor.TexturePropertyWithHDRColor(Styles.albedoText, albedoMap, albedoColor,true);
            if (((BlendMode)material.GetFloat("_Mode") == BlendMode.Cutout))
            {
                m_MaterialEditor.ShaderProperty(alphaCutoff, Styles.alphaCutoffText.text, MaterialEditor.kMiniTextureFieldLabelIndentLevel + 1);
            }
        }

        void DoEmissionArea(Material material)
        {
            // Emission for GI?
            if (m_MaterialEditor.EmissionEnabledProperty())
            {
                bool hadEmissionTexture = emissionMap.textureValue != null;

                // Texture and HDR color controls
                m_MaterialEditor.TexturePropertyWithHDRColor(Styles.emissionText, emissionMap, emissionColorForRendering, false);

                // If texture was assigned and color was black set color to white
                float brightness = emissionColorForRendering.colorValue.maxColorComponent;
                if (emissionMap.textureValue != null && !hadEmissionTexture && brightness <= 0f)
                    emissionColorForRendering.colorValue = Color.white;

                // change the GI flag and fix it up with emissive as black if necessary
                m_MaterialEditor.LightmapEmissionFlagsProperty(MaterialEditor.kMiniTextureFieldLabelIndentLevel, true);
            }
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
					material.SetInt("_Cull", (int)UnityEngine.Rendering.CullMode.Back);
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
					material.SetInt("_Cull", (int)UnityEngine.Rendering.CullMode.Back);
                    material.renderQueue = (int)UnityEngine.Rendering.RenderQueue.AlphaTest;
                    break;
                case BlendMode.OpaqueDoubleSide:
                    material.SetOverrideTag("RenderType", "");
                    material.SetInt("_SrcBlend", (int)UnityEngine.Rendering.BlendMode.One);
                    material.SetInt("_DstBlend", (int)UnityEngine.Rendering.BlendMode.Zero);
                    material.SetInt("_SrcAlpha", (int)UnityEngine.Rendering.BlendMode.One);
                    material.SetInt("_DstAlpha", (int)UnityEngine.Rendering.BlendMode.Zero);
                    material.SetInt("_ZWrite", 1);
                    material.DisableKeyword("_ALPHATEST_ON");
                    material.DisableKeyword("_ALPHABLEND_ON");
                    material.DisableKeyword("_ALPHAPREMULTIPLY_ON");
                    material.SetInt("_Cull", (int)UnityEngine.Rendering.CullMode.Off);
                    material.renderQueue = -1;
                    break;
                case BlendMode.CutoutDoubleSide:
                    material.SetOverrideTag("RenderType", "TransparentCutout");
                    material.SetInt("_SrcBlend", (int)UnityEngine.Rendering.BlendMode.One);
                    material.SetInt("_DstBlend", (int)UnityEngine.Rendering.BlendMode.Zero);
                    material.SetInt("_SrcAlpha", (int)UnityEngine.Rendering.BlendMode.One);
                    material.SetInt("_DstAlpha", (int)UnityEngine.Rendering.BlendMode.Zero);
                    material.SetInt("_ZWrite", 1);
                    material.EnableKeyword("_ALPHATEST_ON");
                    material.DisableKeyword("_ALPHABLEND_ON");
                    material.DisableKeyword("_ALPHAPREMULTIPLY_ON");
                    material.SetInt("_Cull", (int)UnityEngine.Rendering.CullMode.Off);
                    material.renderQueue = (int)UnityEngine.Rendering.RenderQueue.AlphaTest;
                    break;               
            }
        }

        static SmoothnessMapChannel GetSmoothnessMapChannel(Material material)
        {
            int ch = (int)material.GetFloat("_SmoothnessTextureChannel");
            if (ch == (int)SmoothnessMapChannel.AlbedoAlpha)
                return SmoothnessMapChannel.AlbedoAlpha;
            else
                return SmoothnessMapChannel.SpecularMetallicAlpha;
        }

        static void SetMaterialKeywords(Material material)
        {
            // Note: keywords must be based on Material value not on MaterialProperty due to multi-edit & material animation
            // (MaterialProperty value might come from renderer material property block)
            SetKeyword(material, "_NORMALMAP", material.GetTexture("_BumpMap"));
            SetKeyword(material, "_METALLICGLOSSMAP", material.GetTexture("_MetallicGlossMap"));
            SetKeyword(material, "_PARALLAXMAP", material.GetTexture("_ParallaxMap"));
           

            // A material's GI flag internally keeps track of whether emission is enabled at all, it's enabled but has no effect
            // or is enabled and may be modified at runtime. This state depends on the values of the current flag and emissive color.
            // The fixup routine makes sure that the material is in the correct state if/when changes are made to the mode or color.
            MaterialEditor.FixupEmissiveFlag(material);
            bool shouldEmissionBeEnabled = (material.globalIlluminationFlags & MaterialGlobalIlluminationFlags.EmissiveIsBlack) == 0;
            SetKeyword(material, "_EMISSION", shouldEmissionBeEnabled);

          
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
