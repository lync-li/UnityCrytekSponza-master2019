using UnityEngine;
using UnityEngine.Rendering;
using System;
using System.IO;
using System.Collections;

#if UNITY_EDITOR
using UnityEditor;
#endif 

[ExecuteInEditMode]
public class EnvironmentObject : MonoBehaviour {

    [Serializable]
    public class EnvironmentData
    {
        public enum CustomAmbientMode
        {
            Skybox = 0,
            Gradient = 1,
            Color = 2,
        }

        //scene skybox
        public Material sceneSkybox = null;

        //Sun light
        public Light sceneSunLight = null;

        //scene ambient
        public bool sceneAmbient = true;
        public CustomAmbientMode sceneAmbientMode = CustomAmbientMode.Skybox;
        [ColorUsageAttribute(true, true)]
        public Color    sceneAmbientLight = Color.white;
        [ColorUsageAttribute(true, true)]
        public Color    sceneAmbientSkyColor = Color.white;
        [ColorUsageAttribute(true, true)]
        public Color    sceneAmbientEquatorColor = Color.white;
        [ColorUsageAttribute(true, true)]
        public Color    sceneAmbientGroundColor = Color.white;
        [Range(0f, 8f)]
        public float    sceneAmbientIntensity = 1.0f;

        //scene reflection
        public bool sceneReflection = true;
        public DefaultReflectionMode sceneDefaultReflectionMode = DefaultReflectionMode.Skybox;
        public int      sceneDefaultReflectionResolution = 128;
        [Range(0f, 1f)]
        public float    sceneReflectionIntensity = 1.0f;
        [Range(1f, 5f)]
        public int      sceneReflectionBounces = 1;
        public Cubemap  sceneCustomReflection = null;

        //scene DirectionalLight
        public bool sceneDirectionalLight = true;
        public Color sceneDirectionalLightColor = Color.white;
        [Range(0f, 5f)]
        public float sceneDirectionalLightIntensity = 1.0f;

        //scene shadow
        public bool sceneShadow = true;
        public Color sceneShadowColor = Color.black;
        [Range(0f, 1f)]
        public float sceneShadowStrength = 1.0f;
        [Range(0f, 500f)]
        public float sceneShadowDistance = 50.0f;
        public ShadowResolution sceneShadowResolution = ShadowResolution.Medium;

        //scene normal fog
        public bool sceneNormalfog = false;
        public Color sceneNormalfogColor = Color.white;
        public Color sceneNormalLinearFogColor = Color.white;
        public FogMode sceneNormalfogMode = FogMode.Linear;
        public float sceneNormalfogDensity = 0.01f;
        public float sceneNormalfogStartDistance = 0f;
        public float sceneNormalfogEndDistance = 300f; 

        //scene PostProcess
        public DragonPostProcess.Property property;
        //为了减少变体 使用shader feature
        public Material uberMaterial;
    }

    [SerializeField]
    public EnvironmentData data = null;

    void Awake()
    {
        if (data == null)
        {
            data = new EnvironmentData();              
        }        
    } 
}
