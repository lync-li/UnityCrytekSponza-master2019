using UnityEngine;
using UnityEngine.Rendering;
using System;
using System.IO;
using System.Collections;
using System.Collections.Generic;

#if UNITY_EDITOR
using UnityEditor;
#endif 

#if UNITY_2018_3_OR_NEWER
[ExecuteAlways]
#else
    [ExecuteInEditMode]
#endif
public class EnvironmentManager : MonoBehaviour {

    public EnvironmentObject curEnv;  //当前环境

    public GameObject alphaCameraPrefab;
    public GameObject distortionCameraPrefab;
    public GameObject uberCameraPrefab;
    //环境列表
    public EnvironmentObject[] envObjects;
    //横屏还是竖屏
    public bool isLandscaped = true;
    //fps
    private float updateInterval = 0.5f;
    private float lastInterval;
    private float nextCheckTime;
    private int frames = 0;
    private float fps;
    private const int fpsArrayLen = 15;
    private float[] fpsArray = new float[fpsArrayLen];
    private int fpsIndex = 0;
    private const int standardFPS = 22;
    //private const int standardFPS = 600;
    private float averageFPS = 30;

    private int Width_1080p = 1920;
    private int Height_1080p = 1080;
    private int Width_750p = 1334;
    private int Height_750p = 750;
    private int Width_576p = 1024;
    private int Height_576p = 576;

    private int currentRTWidth;
    private int currentRTHeight;
    private int currentResolutionWidth;
    private int currentResolutionHeight;

    private bool initAspectRatio = true;
    private bool initResolution = true;
    private bool initEnv = true;

	private bool loadDone = false;
    private bool dynamicResStart = false;

    public DragonPostProcess pp;
    public AlphaPass alphaPass;
    public UberPass uberPass;
    public DistortionPass distortionPass;

    public bool isSupportHalf = true;
    public bool isSupportDepthTex = true;
    public bool isSupportMRT = true;
    public RenderTextureFormat halfFormat;

    private Camera mainCam;
    private ResolutionLevel currentLevel = ResolutionLevel.NORMAL;

    private PlayerGraphicsSetting graphicsSetting = null;
    //单件实例化
    private static EnvironmentManager _Instance;
    public static EnvironmentManager Instance
    {
        get
        {
            if (_Instance == null)
            {
                _Instance = FindObjectOfType(typeof(EnvironmentManager)) as EnvironmentManager;
            }

            if (_Instance == null)
            {
                var obj = new GameObject("EnvironmentManager");
                _Instance = obj.AddComponent<EnvironmentManager>();
                Debug.Log("Could not locate an DamageNumManager object. DamageNumManager was Generated Automaticly.");
            }

            return _Instance;
        }
    }

    protected void OnApplicationQuit()
    {
        _Instance = null;
    }

    void Awake()
    {       
        nextCheckTime = Time.realtimeSinceStartup + fpsArrayLen * updateInterval;

        for (int i = 0; i < fpsArray.Length; i++)
            fpsArray[i] = 35;      
    }
    void OnEnable()
    {
        GameObject setting = GameObject.Find("PlayerGraphicsSetting");
        if (setting)
            graphicsSetting = setting.GetComponent<PlayerGraphicsSetting>();

        UpdateComponent();

        UpdateAspectRatio();

        SetGraphics();
        currentLevel = graphicsSetting ? graphicsSetting.resolutionLevel : ResolutionLevel.HIGH;
    }

	public void OnSceneLoadDone()
	{
		loadDone = true;
	}

    public void SetGraphics()
    {
        Application.targetFrameRate = graphicsSetting ? graphicsSetting.frameRate : 60;

        if(graphicsSetting)
        {
            if (!graphicsSetting.dynamicQuality)
                currentLevel = graphicsSetting.resolutionLevel;
        }
        else
            currentLevel = ResolutionLevel.HIGH;

        isSupportHalf = SystemInfo.SupportsRenderTextureFormat(RenderTextureFormat.ARGBHalf);
        isSupportDepthTex = SystemInfo.SupportsRenderTextureFormat(RenderTextureFormat.Depth);
        isSupportMRT = SystemInfo.supportedRenderTargetCount > 1;

        if (!isSupportHalf || (graphicsSetting && !graphicsSetting.hdr))
            halfFormat = RenderTextureFormat.ARGB32;
        else
            halfFormat = RenderTextureFormat.ARGBHalf;

        ShaderLod();
    }
	
	public ResolutionLevel GetCurResolutionLevel()
    {
        return currentLevel;
    }     
	
	public void SwitchNextEnv()
    {
        int index = 0;
        for(int i = 0;i < envObjects.Length;i++)
        {
            if (curEnv == envObjects[i])
            {
                index = i;
                break;
            }                
        }

        index++;

        if (index >= envObjects.Length )
            index = 0;

        ChooseEnviornment(envObjects[index], true);
    }

    #region Environment
    //创建环境管理器
#if UNITY_EDITOR
    [MenuItem("GameObject/Create EnvironmentManager")]
    static void CreateEnvironmentManager()
    {
        GameObject envManager = new GameObject();
        envManager.name = "EnvironmentManager";
        envManager.AddComponent<EnvironmentManager>();
    }
#endif

    //创建环境 readUnity为真时读取当前Unity中数值
    public void CreateEnviornment(bool readUnity)
    {
        GameObject envObj = new GameObject("EnvObject" + envObjects.Length);
        EnvironmentObject env = envObj.AddComponent<EnvironmentObject>();
        envObj.transform.parent = this.transform;

        GameObject lightObj = new GameObject("SceneDirLight" + envObjects.Length);
        lightObj.transform.parent = envObj.transform;
        Light scenelight = lightObj.AddComponent<Light>();
        scenelight.shadows = LightShadows.Soft;
        scenelight.transform.eulerAngles = new Vector3(130, 33, 10);
        scenelight.type = LightType.Directional;

        env.data.sceneSunLight = scenelight;

        envObj.SetActive(false);

        if (readUnity)
            UnityToEnvironmentObject(env);

        if (curEnv == null)
        {
            curEnv = env;
        }

        UpdateActiveEnviornment();
    }

    public EnvironmentObject GetCurEnv()
    {
        return curEnv;
    }

    //选择环境，forceToUnity为真时将数值设置入Unity中
    public void ChooseEnviornment(EnvironmentObject env, bool forceToUnity)
    {
        if (forceToUnity || curEnv != env)
        {
            curEnv = env;
            EnvironmentObjectToUnity(env);
        }
        UpdateActiveEnviornment();
    }

    //选择环境，forceToUnity为真时将数值设置入Unity中
    public void ChooseEnviornment(string envName, bool forceToUnity)
    {
        foreach (var env in envObjects)
        {
            if (env.name == envName)
            {
                ChooseEnviornment(env, forceToUnity);
                break;
            }
        }
    }

    //刷新环境列表
    public void UpdateEnviornmentObjects()
    {
        envObjects = GetComponentsInChildren<EnvironmentObject>(true);
    }

    //刷新当前激活的环境
    public void UpdateActiveEnviornment()
    {
        UpdateEnviornmentObjects();
        foreach (EnvironmentObject env in envObjects)
        {
            if (env == curEnv)
                env.gameObject.SetActive(true);
            else
                env.gameObject.SetActive(false);
        }
    }

    //将环境数值导入到unity中
    public void EnvironmentObjectToUnity(EnvironmentObject env)
    {
        SetGraphics();
        UpdateComponent();

        //if(pp)
        //    pp.CleanRT();
        //if (alphaPass)
        //    alphaPass.CleanRT();

        if (pp)
        {            
            pp.SetProperty(env.data.property);
#if UNITY_EDITOR
            pp.OnPreRender();
            alphaPass.OnPreRender();
            distortionPass.OnPreRender();
            uberPass.OnPreRender();
            pp.forceUpdate = true;
#endif
        }

        RenderSettings.skybox = env.data.sceneSkybox;

        RenderSettings.sun = env.data.sceneSunLight;

        if (env.data.sceneAmbientMode == EnvironmentObject.EnvironmentData.CustomAmbientMode.Color)
            RenderSettings.ambientMode = AmbientMode.Flat;
        else if (env.data.sceneAmbientMode == EnvironmentObject.EnvironmentData.CustomAmbientMode.Gradient)
            RenderSettings.ambientMode = AmbientMode.Trilight;
        else if (env.data.sceneAmbientMode == EnvironmentObject.EnvironmentData.CustomAmbientMode.Skybox)
            RenderSettings.ambientMode = AmbientMode.Skybox;

        RenderSettings.ambientSkyColor = env.data.sceneAmbient ? env.data.sceneAmbientSkyColor : Color.black;
        RenderSettings.ambientEquatorColor = env.data.sceneAmbient ? env.data.sceneAmbientEquatorColor : Color.black;
        RenderSettings.ambientGroundColor = env.data.sceneAmbient ? env.data.sceneAmbientGroundColor : Color.black;
        RenderSettings.ambientIntensity = env.data.sceneAmbient ? env.data.sceneAmbientIntensity : 0;

        RenderSettings.defaultReflectionMode = env.data.sceneDefaultReflectionMode;
        RenderSettings.defaultReflectionResolution = env.data.sceneDefaultReflectionResolution;
        RenderSettings.reflectionIntensity = env.data.sceneReflection ? env.data.sceneReflectionIntensity : 0;
        RenderSettings.reflectionBounces = env.data.sceneReflectionBounces;
        RenderSettings.customReflection = env.data.sceneCustomReflection;

        if (env.data.sceneSunLight)
        {
            env.data.sceneSunLight.color = env.data.sceneDirectionalLightColor;
            env.data.sceneSunLight.intensity = env.data.sceneDirectionalLight ? env.data.sceneDirectionalLightIntensity : 0;
            env.data.sceneSunLight.shadowStrength = env.data.sceneShadowStrength;
        }
        QualitySettings.shadowDistance = env.data.sceneShadowDistance;
        QualitySettings.shadowResolution = env.data.sceneShadowResolution;
        QualitySettings.shadows = ShadowEnable() ? ShadowQuality.All : ShadowQuality.Disable;

        RenderSettings.fog = env.data.sceneNormalfog;
        RenderSettings.fogColor = env.data.sceneNormalfogColor;
        RenderSettings.fogMode = env.data.sceneNormalfogMode;
        RenderSettings.fogDensity = env.data.sceneNormalfogDensity;
        RenderSettings.fogStartDistance = env.data.sceneNormalfogStartDistance;
        RenderSettings.fogEndDistance = env.data.sceneNormalfogEndDistance;

        Shader.SetGlobalColor("_ShadowColor", env.data.sceneShadowColor);
    }

    //将Unity中数值导入到环境
    public void UnityToEnvironmentObject(EnvironmentObject env)
    {
        DragonPostProcess postProcess = Camera.main.GetComponent<DragonPostProcess>();
        if (postProcess)
            env.data.property = postProcess.mProperty;
        else
            env.data.property = new DragonPostProcess.Property();

#if UNITY_EDITOR
        env.data.sceneSkybox = RenderSettings.skybox;

        if (RenderSettings.ambientMode == AmbientMode.Flat)
        {
            env.data.sceneAmbientMode = EnvironmentObject.EnvironmentData.CustomAmbientMode.Color;
            if (RenderSettings.ambientSkyColor == Color.black)
            {
                env.data.sceneAmbient = false;
            }
            else
                env.data.sceneAmbient = true;
        }
        else if (RenderSettings.ambientMode == AmbientMode.Trilight)
        {
            env.data.sceneAmbientMode = EnvironmentObject.EnvironmentData.CustomAmbientMode.Gradient;
            if (RenderSettings.ambientSkyColor == Color.black && RenderSettings.ambientSkyColor == Color.black && RenderSettings.ambientSkyColor == Color.black)
            {
                env.data.sceneAmbient = false;
            }
            else
                env.data.sceneAmbient = true;
        }
        else if (RenderSettings.ambientMode == AmbientMode.Skybox)
        {
            env.data.sceneAmbientMode = EnvironmentObject.EnvironmentData.CustomAmbientMode.Skybox;
            if (RenderSettings.ambientIntensity == 0)
            {
                env.data.sceneAmbient = false;
            }
            else
                env.data.sceneAmbient = true;
        }

        if (env.data.sceneAmbient)
        {
            env.data.sceneAmbientSkyColor = RenderSettings.ambientSkyColor;
            env.data.sceneAmbientGroundColor = RenderSettings.ambientEquatorColor;
            env.data.sceneAmbientEquatorColor = RenderSettings.ambientGroundColor;
            env.data.sceneAmbientIntensity = RenderSettings.ambientIntensity;
        }

        if (RenderSettings.reflectionIntensity == 0)
            env.data.sceneReflection = false;
        else
        {
            env.data.sceneDefaultReflectionMode = RenderSettings.defaultReflectionMode;
            env.data.sceneDefaultReflectionResolution = RenderSettings.defaultReflectionResolution;
            env.data.sceneReflectionIntensity = RenderSettings.reflectionIntensity;
            env.data.sceneReflectionBounces = RenderSettings.reflectionBounces;
            env.data.sceneCustomReflection = RenderSettings.customReflection;
        }

        if (env.data.sceneSunLight && RenderSettings.sun)
        {
            if (RenderSettings.sun.intensity == 0)
                env.data.sceneDirectionalLight = false;
            else
            {
                env.data.sceneDirectionalLightColor = env.data.sceneSunLight.color = RenderSettings.sun.color;
                env.data.sceneDirectionalLightIntensity = env.data.sceneSunLight.intensity = RenderSettings.sun.intensity;
                env.data.sceneShadowStrength = env.data.sceneSunLight.shadowStrength = RenderSettings.sun.shadowStrength;
                env.data.sceneSunLight.transform.position = RenderSettings.sun.transform.position;
                env.data.sceneSunLight.transform.rotation = RenderSettings.sun.transform.rotation;
                env.data.sceneSunLight.shadows = RenderSettings.sun.shadows;
                env.data.sceneSunLight.shadowRadius = RenderSettings.sun.shadowRadius;
                env.data.sceneSunLight.shadowAngle = RenderSettings.sun.shadowAngle;
                env.data.sceneSunLight.lightmapBakeType = RenderSettings.sun.lightmapBakeType;
                env.data.sceneSunLight.shadowBias = RenderSettings.sun.shadowBias;
                env.data.sceneSunLight.shadowNormalBias = RenderSettings.sun.shadowNormalBias;
                env.data.sceneSunLight.shadowNearPlane = RenderSettings.sun.shadowNearPlane;
            }
            if (RenderSettings.sun.transform.parent.GetComponent<EnvironmentObject>())
            {

            }
            else
                RenderSettings.sun.gameObject.SetActive(false);
        }

        env.data.sceneShadowDistance = QualitySettings.shadowDistance;
        env.data.sceneShadowResolution = QualitySettings.shadowResolution;

        env.data.sceneNormalfog = RenderSettings.fog;
        env.data.sceneNormalfogColor = RenderSettings.fogColor;
        env.data.sceneNormalfogMode = RenderSettings.fogMode;
        env.data.sceneNormalfogDensity = RenderSettings.fogDensity;
        env.data.sceneNormalfogStartDistance = RenderSettings.fogStartDistance;
        env.data.sceneNormalfogEndDistance = RenderSettings.fogEndDistance;
#endif
    }
    #endregion

    #region Component
    //刷新组件
    public void UpdateComponent()
    {
        mainCam = Camera.main;
        if (mainCam == null || uberCameraPrefab == null || alphaCameraPrefab == null)
            return;

        pp = mainCam.GetComponent<DragonPostProcess>();
        if (pp == null)
            pp = mainCam.gameObject.AddComponent<DragonPostProcess>();

        Transform alphaCamTran = mainCam.transform.Find("AlphaCamera");
        if (alphaCamTran == null)
        {
            GameObject obj = Instantiate(alphaCameraPrefab) as GameObject;
            obj.name = "AlphaCamera";
            alphaCamTran = obj.transform;
            alphaCamTran.parent = mainCam.transform;
        }
        alphaPass = alphaCamTran.GetComponent<AlphaPass>();
        Camera alphaCamera = alphaCamTran.GetComponent<Camera>();
        alphaCamera.depth = mainCam.depth + 1;

        Transform distortionCamTran = mainCam.transform.Find("DistortionCamera");
        if (distortionCamTran == null)
        {
            GameObject obj = Instantiate(distortionCameraPrefab) as GameObject;
            obj.name = "DistortionCamera";
            distortionCamTran = obj.transform;
            distortionCamTran.parent = mainCam.transform;
        }
        distortionPass = distortionCamTran.GetComponent<DistortionPass>();
        Camera distortionCamera = distortionCamTran.GetComponent<Camera>();
        distortionCamera.depth = mainCam.depth + 2;

        Transform uberCamTran = mainCam.transform.Find("UberCamera");
        if (uberCamTran == null)
        {
            GameObject obj = Instantiate(uberCameraPrefab) as GameObject;
            obj.name = "UberCamera";
            uberCamTran = obj.transform;
            uberCamTran.parent = mainCam.transform;
        }
        uberPass = uberCamTran.GetComponent<UberPass>();
        Camera uberCamera = uberCamTran.GetComponent<Camera>();
        uberCamera.depth = mainCam.depth + 3;

        alphaCamera.transform.localPosition = distortionCamera.transform.localPosition = uberCamera.transform.localPosition = Vector3.zero;
        alphaCamera.transform.localEulerAngles = distortionCamera.transform.localEulerAngles = uberCamera.transform.localEulerAngles = Vector3.zero;
        alphaCamera.nearClipPlane = distortionCamera.nearClipPlane = uberCamera.nearClipPlane = mainCam.nearClipPlane;
        alphaCamera.farClipPlane = distortionCamera.farClipPlane = uberCamera.farClipPlane = mainCam.farClipPlane;
        alphaCamera.fieldOfView = distortionCamera.fieldOfView = uberCamera.fieldOfView = mainCam.fieldOfView;
        alphaCamera.allowMSAA = distortionCamera.allowMSAA = uberCamera.allowMSAA = false;
        //alphaCamera.allowHDR = uberCamera.allowHDR = false;
    }

    public int GetCurrentRTWidth()
    {
        UpdateCurrentRT();
        return currentRTWidth;
    }
    public int GetCurrentRTHeight()
    {
        UpdateCurrentRT();
        return currentRTHeight;
    }

    public int GetDistortionRTWidth()
    {
        UpdateCurrentRT();
        return Width_576p / 2;
    }
    public int GetDistortionRTHeight()
    {
        UpdateCurrentRT();
        return Height_576p / 2;
    }

    #endregion

    public void UpdateCurrentRT()
    {
        switch (currentLevel)
        {
            case ResolutionLevel.HIGH:
                currentRTWidth = Width_1080p;
                currentRTHeight = Height_1080p;
                currentResolutionWidth = Width_1080p;
                currentResolutionHeight = Height_1080p;
                break;
            case ResolutionLevel.NORMAL:
                currentRTWidth = Width_750p;
                currentRTHeight = Height_750p;
                currentResolutionWidth = Width_1080p;
                currentResolutionHeight = Height_1080p;
                break;
            case ResolutionLevel.LOW:
                currentRTWidth = Width_750p;
                currentRTHeight = Height_750p;
                currentResolutionWidth = Width_750p;
                currentResolutionHeight = Height_750p;
                break;
            case ResolutionLevel.VERYLOW:
                currentRTWidth = Width_576p;
                currentRTHeight = Height_576p;
                currentResolutionWidth = Width_750p;
                currentResolutionHeight = Height_750p;
                break;
            case ResolutionLevel.VERYVERYLOW:
                currentRTWidth = Width_576p;
                currentRTHeight = Height_576p;
                currentResolutionWidth = Width_576p;
                currentResolutionHeight = Height_576p;
                break;
        }
    }

    #region Update
    //刷新横宽
    void UpdateAspectRatio()
    {
        if (Screen.width == 0 || Screen.height == 0)
            return;

#if UNITY_EDITOR
       // isLandscaped = (Screen.height > Screen.width) ? false : true;
#endif    
        if (isLandscaped)
        {            
            Width_1080p = 1920;
            Width_750p = 1334;
            Width_576p = 1024;

            Height_1080p = Width_1080p * Screen.height / Screen.width;
            Height_750p = Width_750p * Screen.height / Screen.width;
            Height_576p = Width_576p * Screen.height / Screen.width;
        }
        else
        {
            Height_1080p = 1920;
            Height_750p = 1334;
            Height_576p = 1024;

            Width_1080p = Height_1080p * Screen.width / Screen.height;
            Width_750p = Height_750p * Screen.width / Screen.height;
            Width_576p = Height_576p * Screen.width / Screen.height;
        }
        initAspectRatio = false;  
    }
    
    public bool ShadowEnable()
    {
        if (graphicsSetting && graphicsSetting.dynamicQuality)
        {
            return (int)currentLevel <= (int)ResolutionLevel.LOW && curEnv.data.sceneShadow;
        }
        else
        {
            return graphicsSetting ? graphicsSetting.shadow && curEnv.data.sceneShadow: curEnv.data.sceneShadow;
        }
    }
    public void ShaderLod()
    {
        if (graphicsSetting && graphicsSetting.dynamicQuality)
        {
            if (currentLevel <= ResolutionLevel.NORMAL)
                Shader.globalMaximumLOD = Math.Min(500, graphicsSetting.shaderLod);
            else
                Shader.globalMaximumLOD = Math.Min(400, graphicsSetting.shaderLod);
        }
        else
        {
            Shader.globalMaximumLOD = graphicsSetting? graphicsSetting.shaderLod : 500;
        }    
    }

    //刷新分辨率设置
    public void UpdateResolution(ResolutionLevel level)
    {
        mainCam = Camera.main;
        if (mainCam == null || uberCameraPrefab == null || alphaCameraPrefab == null || initAspectRatio)
            return ;

        Debug.Log(currentLevel + "            " + level);
        currentLevel = level;       

        UpdateCurrentRT();
        Screen.SetResolution(currentResolutionWidth,currentResolutionHeight, true);
        ChooseEnviornment(curEnv, true);     
        initResolution = false;
    }
    public void Update()
    {
        if(initAspectRatio)
        {
            UpdateAspectRatio();
        }
        if(initResolution)
        {
            UpdateResolution(currentLevel);
        }
        if (loadDone)
        {
            initEnv = true;
            loadDone = false;
            dynamicResStart = true;
        }
        if (initEnv)
        {
            ChooseEnviornment(curEnv, true);            
            initEnv = false;
        }
        
       // if(RenderSettings.skybox != curEnv.data.sceneSkybox)
        //    initEnv = true;

        if (graphicsSetting &&  (graphicsSetting.dynamicQuality || graphicsSetting.displayFPS) && dynamicResStart)
        {
            ++frames;
            if (Time.realtimeSinceStartup > lastInterval + updateInterval)
            {
                fps = frames / (Time.realtimeSinceStartup - lastInterval);
                frames = 0;
                lastInterval = Time.realtimeSinceStartup;

                fpsArray[fpsIndex] = fps;
                fpsIndex = (++fpsIndex) % fpsArrayLen;

                float totalFPS = 0;
                for (int i = 0; i < fpsArray.Length; ++i)
                {
                    totalFPS += fpsArray[i];
                }
                averageFPS = totalFPS / fpsArray.Length;
            }
        }
        if(Application.isPlaying && graphicsSetting && graphicsSetting.dynamicQuality && dynamicResStart && nextCheckTime < Time.realtimeSinceStartup && averageFPS < standardFPS)
        {   
            if(currentLevel < ResolutionLevel.VERYVERYLOW)
            {
                UpdateResolution(currentLevel + 1);
                nextCheckTime = Time.realtimeSinceStartup + fpsArrayLen * updateInterval;
                Debug.Log("UpdateResolution" + currentLevel);
            }          
        }

#if UNITY_EDITOR
        initAspectRatio = true;
#endif

    }
    void OnGUI()
    {
        if(graphicsSetting && graphicsSetting.displayFPS)
        {
            GUIStyle style = new GUIStyle();
            style.fontStyle = FontStyle.Bold;
            style.fontSize = 30;
            GUI.Label(new Rect(0, 0, 100, 100), "FPS:" + ((int)fps).ToString(), style);
            GUI.Label(new Rect(0, 20, 100, 100), "AverageFPS:" + ((int)averageFPS).ToString(), style);
            GUI.Label(new Rect(0, 45, 100, 100),  ((int)currentRTWidth).ToString() + " " + ((int)currentRTHeight).ToString(), style);
            GUI.Label(new Rect(0, 70, 100, 100), ((int)Screen.width).ToString() + " " + ((int)Screen.height).ToString(), style);
        }       
    }
    #endregion
}
