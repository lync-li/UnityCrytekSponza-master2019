using UnityEngine;
using UnityEngine.Rendering;
using UnityEditor;
using System.Collections;
using UnityEngine.Rendering.PostProcessing;

[ExecuteInEditMode]
[CustomEditor(typeof(EnvironmentObject),true)]
public class EnvironmentObjectInspector : Editor
{
    static bool showSceneEnvironment;
    static bool showPlayerEnvironment;
    static bool showEffect;
    static bool showGlobal;

    static bool showSceneAmbient;
    static bool showSceneReflection;
    static bool showSceneSunLight;
    static bool showSceneShadow;
    static bool showSceneNormalFog;
    static bool showSceneHeightFog;
    static bool showSceneVolumetricFog;
    static bool showSceneBloom;
    static bool showSceneTonemapping;
    static bool showSceneColorGrading;
    static bool showSceneUserLut;
    static bool showSceneHBAO;
    static bool showSceneLBAO;
    static bool showSceneCloudShadow;

    static bool showEffectBloom;
    static bool showEffectTonemapping;
    static bool showEffectColorGrading;
    static bool showEffectUserLut;
    static bool showEffectDistortion;

    static bool showPlayerBloom;
    static bool showPlayerTonemapping;
    static bool showPlayerColorGrading;
    static bool showPlayerUserLut;

    static bool showGlobalDOF;
    static bool showGlobalFastDOF;
    static bool showGlobalMask;
    static bool showGlobalVignette;
    static bool showGlobalFXAA;
    static bool showGlobalRadial;
    static bool showGlobalBorder;
    static bool showGlobalChromaticAberration;

    // Custom tone curve drawing
    const int k_CustomToneCurveResolution = 48;
    const float k_CustomToneCurveRangeY = 1.025f;
   
   // readonly HableCurve m_HableCurve = new HableCurve();

    EnvironmentObject env;

    private void OnEnable()
    {
        env = serializedObject.targetObject as EnvironmentObject;

        if (env.data == null)
            env.data = new EnvironmentObject.EnvironmentData();

    }
    public override void OnInspectorGUI()
    {
        GUIStyle topStyle = new GUIStyle(EditorStyles.foldout);  // 这里我用EditorStyles的centeredGreyMiniLabel来初始化我的新风格
        topStyle.fontStyle = FontStyle.Bold;                       // 新Style的字体为粗体
        topStyle.fontSize = 16;
        topStyle.richText = true;
        // topStyle.normal.textColor = Color.blue;
        GUIStyle checkStyle = new GUIStyle(EditorStyles.largeLabel);  // 这里我用EditorStyles的centeredGreyMiniLabel来初始化我的新风格
        checkStyle.fontStyle = FontStyle.Bold;                       // 新Style的字体为粗体
        checkStyle.fontSize = 20;
       // checkStyle.richText = true;
        checkStyle.fixedWidth = 150;
        checkStyle.fixedHeight = 120;

        EditorGUILayout.Space();
        EditorGUILayout.Space();

        EditorGUILayout.BeginHorizontal();
        EditorGUILayout.LabelField("特效分层", checkStyle);      
        SerializedProperty field = serializedObject.FindProperty("data.property.alphaBuffer");
        EditorGUILayout.PropertyField(field, new GUIContent(""), new GUILayoutOption[] { GUILayout.Width(10), GUILayout.Height(30) });
        EditorGUILayout.Space();
        EditorGUILayout.Space();
        EditorGUILayout.EndHorizontal();       

        EditorGUILayout.BeginHorizontal();
        EditorGUILayout.LabelField("角色分层", checkStyle);      
        field = serializedObject.FindProperty("data.property.playerLayer");
        EditorGUILayout.PropertyField(field, new GUIContent(""), new GUILayoutOption[] { GUILayout.Width(10), GUILayout.Height(30) });
        EditorGUILayout.Space();
        EditorGUILayout.Space();
        EditorGUILayout.EndHorizontal();

        field = serializedObject.FindProperty("data.uberMaterial");
        EditorGUILayout.PropertyField(field, new GUIContent("材质           uberMaterial"));

        EditorGUILayout.Space();
        EditorGUILayout.LabelField("________________________________________________");
        EditorGUILayout.BeginHorizontal();

        showSceneEnvironment = EditorGUILayout.Foldout(showSceneEnvironment, " 场景环境设置   Scene",topStyle);
        EditorGUILayout.EndHorizontal();


        


        if (showSceneEnvironment)
              OnSceneGUI();

        EditorGUILayout.LabelField("________________________________________________");

        if(env.data.property.playerLayer)
        {
            EditorGUILayout.BeginHorizontal();

            showPlayerEnvironment = EditorGUILayout.Foldout(showPlayerEnvironment, " 角色环境设置   Player", topStyle);
            EditorGUILayout.EndHorizontal();
            if (showPlayerEnvironment)
                OnPlayerGUI();

            EditorGUILayout.LabelField("________________________________________________");
        }       

        if(env.data.property.alphaBuffer)
        {
            EditorGUILayout.BeginHorizontal();

            showEffect = EditorGUILayout.Foldout(showEffect, " 特效设置         Effect", topStyle);
            EditorGUILayout.EndHorizontal();
            if (showEffect)
                OnEffectGUI();

            EditorGUILayout.LabelField("________________________________________________");
        }       

        EditorGUILayout.BeginHorizontal();

        showGlobal = EditorGUILayout.Foldout(showGlobal, " 全局设置         Global", topStyle);
        EditorGUILayout.EndHorizontal();
        if (showGlobal)
            OnGlobalGUI();

        EditorGUILayout.LabelField("________________________________________________");

        if(env.transform.localPosition.x > 0 )
            env.transform.localPosition -= new Vector3(0.1f, 0, 0);
        else
            env.transform.localPosition += new Vector3(0.1f, 0, 0);
        //env.data.property.alphaColorGrading.colorWheels.shadows = Color.white;

        if (EnvironmentManager.Instance.GetCurEnv() == env)
            EnvironmentManager.Instance.EnvironmentObjectToUnity(env);

        if (EnvironmentManager.Instance.GetCurEnv() == null)
            EnvironmentManager.Instance.ChooseEnviornment(env,false);

        serializedObject.ApplyModifiedProperties();
    }

    void DrawLine(float x1, float y1, float x2, float y2, float grayscale, float rangeX, Rect m_CustomToneCurveRect, Vector3[] m_LineVertices)
    {
        m_LineVertices[0] = PointInRect(x1, y1, rangeX, m_CustomToneCurveRect);
        m_LineVertices[1] = PointInRect(x2, y2, rangeX, m_CustomToneCurveRect);
        Handles.color = Color.white * grayscale;
        Handles.DrawAAPolyLine(2f, m_LineVertices);
    }

    Vector3 PointInRect(float x, float y, float rangeX,Rect m_CustomToneCurveRect)
    {
        x = Mathf.Lerp(m_CustomToneCurveRect.x, m_CustomToneCurveRect.xMax, x / rangeX);
        y = Mathf.Lerp(m_CustomToneCurveRect.yMax, m_CustomToneCurveRect.y, y / k_CustomToneCurveRangeY);
        return new Vector3(x, y, 0);
    }

    void DrawCustomToneCurve(DragonPostProcess.Property.ToneMapProperty property)
    {
        EditorGUILayout.Space();

        Vector3[] m_RectVertices = new Vector3[4];
        Vector3[] m_LineVertices = new Vector3[2];
        Vector3[] m_CurveVertices = new Vector3[k_CustomToneCurveResolution];
        Rect m_CustomToneCurveRect;

        // Reserve GUI space
        using (new GUILayout.HorizontalScope())
        {
            GUILayout.Space(EditorGUI.indentLevel * 15f);
            m_CustomToneCurveRect = GUILayoutUtility.GetRect(128, 80);
        }

        if (Event.current.type != EventType.Repaint)
            return;

        // Prepare curve data
        float toeStrength = property.toneCurveToeStrength;
        float toeLength = property.toneCurveToeLength;
        float shoulderStrength = property.toneCurveShoulderStrength;
        float shoulderLength = property.toneCurveShoulderLength;
        float shoulderAngle = property.toneCurveShoulderAngle;
        float gamma = property.toneCurveGamma;
        HableCurve m_HableCurve = new HableCurve();
        m_HableCurve.Init(
            toeStrength,
            toeLength,
            shoulderStrength,
            shoulderLength,
            shoulderAngle,
            gamma
        );

        float endPoint = m_HableCurve.whitePoint;

        // Background
        m_RectVertices[0] = PointInRect(0f, 0f, endPoint, m_CustomToneCurveRect);
        m_RectVertices[1] = PointInRect(endPoint, 0f, endPoint, m_CustomToneCurveRect);
        m_RectVertices[2] = PointInRect(endPoint, k_CustomToneCurveRangeY, endPoint, m_CustomToneCurveRect);
        m_RectVertices[3] = PointInRect(0f, k_CustomToneCurveRangeY, endPoint, m_CustomToneCurveRect);
        Handles.DrawSolidRectangleWithOutline(m_RectVertices, Color.white * 0.1f, Color.white * 0.4f);

        // Vertical guides
        if (endPoint < m_CustomToneCurveRect.width / 3)
        {
            int steps = Mathf.CeilToInt(endPoint);
            for (var i = 1; i < steps; i++)
                DrawLine(i, 0, i, k_CustomToneCurveRangeY, 0.4f, endPoint, m_CustomToneCurveRect, m_LineVertices);
        }

        // Label
        Handles.Label(m_CustomToneCurveRect.position + Vector2.right, "Custom Tone Curve", EditorStyles.miniLabel);

        // Draw the acual curve
        var vcount = 0;
        while (vcount < k_CustomToneCurveResolution)
        {
            float x = endPoint * vcount / (k_CustomToneCurveResolution - 1);
            float y = m_HableCurve.Eval(x);

            if (y < k_CustomToneCurveRangeY)
            {
                m_CurveVertices[vcount++] = PointInRect(x, y, endPoint, m_CustomToneCurveRect);
            }
            else
            {
                if (vcount > 1)
                {
                    // Extend the last segment to the top edge of the rect.
                    var v1 = m_CurveVertices[vcount - 2];
                    var v2 = m_CurveVertices[vcount - 1];
                    var clip = (m_CustomToneCurveRect.y - v1.y) / (v2.y - v1.y);
                    m_CurveVertices[vcount - 1] = v1 + (v2 - v1) * clip;
                }
                break;
            }
        }

        if (vcount > 1)
        {
            Handles.color = Color.white * 0.9f;
            Handles.DrawAAPolyLine(2f, vcount, m_CurveVertices);
        }
    }
    public void OnSceneGUI()
    {
        //设置整个界面是以垂直方向来布局
        EditorGUILayout.BeginVertical();

        if (DragonPostProcesBaseEditor.s_Styles == null)
            DragonPostProcesBaseEditor.s_Styles = new DragonPostProcesBaseEditor.Styles();      

        GUIStyle helpStyle = new GUIStyle(EditorStyles.helpBox);  // 这里我用EditorStyles的centeredGreyMiniLabel来初始化我的新风格
        helpStyle.fontStyle = FontStyle.Bold;                       // 新Style的字体为粗体
        helpStyle.fontSize = 13;
        helpStyle.normal.textColor = Color.red;

        GUIStyle foldStyle = new GUIStyle(EditorStyles.foldoutPreDrop);  // 这里我用EditorStyles的centeredGreyMiniLabel来初始化我的新风格
        foldStyle.fontStyle = FontStyle.Bold;                       // 新Style的字体为粗体
        foldStyle.fontSize = 12;
        foldStyle.normal.textColor = Color.black;
        foldStyle.onNormal.textColor = Color.black;
        foldStyle.fixedWidth = 270;

        int foldSpace = 10;

        float space = 210.0f;
        float wrongHeight = 40.0f;

        if (env.data != null)
        {
            EditorGUILayout.Space();
            SerializedProperty field = serializedObject.FindProperty("data.sceneSkybox");
            EditorGUILayout.PropertyField(field, new GUIContent("天空盒        SkyboxMaterial"));
            EditorGUILayout.Space();
            field = serializedObject.FindProperty("data.sceneSunLight");
            EditorGUILayout.PropertyField(field, new GUIContent("太阳           SunSource"));
            #region sceneAmbient
            EditorGUILayout.Space();
            EditorGUILayout.Space();

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField(" ", new GUILayoutOption[] { GUILayout.Width(foldSpace) });
            showSceneAmbient = EditorGUILayout.Foldout(showSceneAmbient, "场景环境光 SceneEnviromentLight", foldStyle);

            EditorGUILayout.LabelField(" ", new GUILayoutOption[] { GUILayout.Width(space) });
            env.data.sceneAmbient = EditorGUILayout.Toggle(env.data.sceneAmbient, new GUILayoutOption[] { });
            EditorGUILayout.EndHorizontal();

            if (showSceneAmbient)
            {
                EditorGUILayout.Space();
                field = serializedObject.FindProperty("data.sceneAmbientMode");
                EditorGUILayout.PropertyField(field, new GUIContent("来源           Source"));

                if (env.data.sceneAmbientMode == EnvironmentObject.EnvironmentData.CustomAmbientMode.Skybox)
                {
                    if (env.data.sceneSkybox == null)
                    {
                        EditorGUILayout.LabelField("Wrong！！   Skybox为空", helpStyle, new GUILayoutOption[] { GUILayout.Height(wrongHeight) });
                    }
                    field = serializedObject.FindProperty("data.sceneAmbientIntensity");
                    EditorGUILayout.PropertyField(field, new GUIContent("强度           Intensity"));
                }
                else if (env.data.sceneAmbientMode == EnvironmentObject.EnvironmentData.CustomAmbientMode.Gradient)
                {
                    field = serializedObject.FindProperty("data.sceneAmbientSkyColor");
                    EditorGUILayout.PropertyField(field, new GUIContent("天光           SkyColor "));
                    field = serializedObject.FindProperty("data.sceneAmbientEquatorColor");
                    EditorGUILayout.PropertyField(field, new GUIContent("赤道光        EquatorColor "));
                    field = serializedObject.FindProperty("data.sceneAmbientGroundColor");
                    EditorGUILayout.PropertyField(field, new GUIContent("地光           GroundColor "));
                }
                else if (env.data.sceneAmbientMode == EnvironmentObject.EnvironmentData.CustomAmbientMode.Color)
                {
                    field = serializedObject.FindProperty("data.sceneAmbientSkyColor");
                    EditorGUILayout.PropertyField(field, new GUIContent("环境光      AmbientColor"));
                }
            }
            #endregion

            #region sceneReflection
            EditorGUILayout.Space();
            EditorGUILayout.Space();
            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField(" ", new GUILayoutOption[] { GUILayout.Width(foldSpace) });
            showSceneReflection = EditorGUILayout.Foldout(showSceneReflection, "场景反射    SceneEnviromentReflection ", foldStyle);
            EditorGUILayout.LabelField(" ", new GUILayoutOption[] { GUILayout.Width(space) });
            env.data.sceneReflection = EditorGUILayout.Toggle(env.data.sceneReflection, new GUILayoutOption[] { });
            EditorGUILayout.EndHorizontal();

            if (showSceneReflection)
            {
                EditorGUILayout.Space();
                field = serializedObject.FindProperty("data.sceneDefaultReflectionMode");
                EditorGUILayout.PropertyField(field, new GUIContent("来源           Source"));

                if (env.data.sceneDefaultReflectionMode == DefaultReflectionMode.Skybox)
                {
                    if (env.data.sceneSkybox == null)
                    {
                        EditorGUILayout.LabelField("Wrong！！   Skybox为空", helpStyle, new GUILayoutOption[] { GUILayout.Height(wrongHeight) });
                    }
                    field = serializedObject.FindProperty("data.sceneDefaultReflectionResolution");
                    env.data.sceneDefaultReflectionResolution = EditorGUILayout.IntPopup("分辨率        Resoultion", env.data.sceneDefaultReflectionResolution, new string[] { "16", "32", "64", "128", "256", "512", "1024", "2048" }, new int[] { 16, 32, 64, 128, 256, 512, 1024, 2048 });

                    //EditorGUILayout.PropertyField(field, new GUIContent("Resoultion 分辨率"));
                }
                else if (env.data.sceneDefaultReflectionMode == DefaultReflectionMode.Custom)
                {
                    field = serializedObject.FindProperty("data.sceneCustomReflection");
                    EditorGUILayout.PropertyField(field, new GUIContent("反射图        Cubemap"));
                }
                field = serializedObject.FindProperty("data.sceneReflectionIntensity");
                EditorGUILayout.PropertyField(field, new GUIContent("强度           Intensity"));
                field = serializedObject.FindProperty("data.sceneReflectionBounces");
                EditorGUILayout.PropertyField(field, new GUIContent("弹射次数      Bounces"));

            }
            #endregion

            #region sceneSunlight

            EditorGUILayout.Space();
            EditorGUILayout.Space();
            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField(" ", new GUILayoutOption[] { GUILayout.Width(foldSpace) });
            showSceneSunLight = EditorGUILayout.Foldout(showSceneSunLight, "太阳光       SceneSunLight", foldStyle);
            EditorGUILayout.LabelField(" ", new GUILayoutOption[] { GUILayout.Width(space) });
            env.data.sceneDirectionalLight = EditorGUILayout.Toggle(env.data.sceneDirectionalLight, new GUILayoutOption[] { });
            EditorGUILayout.EndHorizontal();

            if (showSceneSunLight)
            {
                EditorGUILayout.Space();
                if (env.data.sceneSunLight == null)
                {
                    EditorGUILayout.LabelField("Wrong！！   sunLight为空", helpStyle, new GUILayoutOption[] { GUILayout.Height(wrongHeight) });
                }

                if (env.data.sceneSunLight && env.data.sceneSunLight.type != LightType.Directional)
                {
                    EditorGUILayout.LabelField("Wrong！！   sunLight不是方向光", helpStyle, new GUILayoutOption[] { GUILayout.Height(wrongHeight) });
                }

                field = serializedObject.FindProperty("data.sceneDirectionalLightColor");
                EditorGUILayout.PropertyField(field, new GUIContent("颜色           Color"));
                field = serializedObject.FindProperty("data.sceneDirectionalLightIntensity");
                EditorGUILayout.PropertyField(field, new GUIContent("强度           Intensity"));
            }
            #endregion

            #region sceneShadow

            EditorGUILayout.Space();
            EditorGUILayout.Space();

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField(" ", new GUILayoutOption[] { GUILayout.Width(foldSpace) });
            showSceneShadow = EditorGUILayout.Foldout(showSceneShadow, "阴影          Shadow", foldStyle);
            EditorGUILayout.LabelField(" ", new GUILayoutOption[] { GUILayout.Width(space) });
            env.data.sceneShadow = EditorGUILayout.Toggle(env.data.sceneShadow, new GUILayoutOption[] { });

            EditorGUILayout.EndHorizontal();
            if (showSceneShadow)
            {
                EditorGUILayout.Space();
                if (env.data.sceneSunLight == null)
                {
                    EditorGUILayout.LabelField("Wrong！！   sunLight为空", helpStyle, new GUILayoutOption[] { GUILayout.Height(wrongHeight) });
                }

                if (env.data.sceneSunLight && env.data.sceneSunLight.type != LightType.Directional)
                {
                    EditorGUILayout.LabelField("Wrong！！   sunLight不是方向光", helpStyle, new GUILayoutOption[] { GUILayout.Height(wrongHeight) });
                }

                field = serializedObject.FindProperty("data.sceneShadowColor");
                EditorGUILayout.PropertyField(field, new GUIContent("颜色           Color"));
                field = serializedObject.FindProperty("data.sceneShadowStrength");
                EditorGUILayout.PropertyField(field, new GUIContent("强度           Strength"));
                field = serializedObject.FindProperty("data.sceneShadowDistance");
                EditorGUILayout.PropertyField(field, new GUIContent("距离           Distance"));
                field = serializedObject.FindProperty("data.sceneShadowResolution");
                EditorGUILayout.PropertyField(field, new GUIContent("分辨率        Resolution"));
            }
            #endregion

            #region sceneNormalFog

            EditorGUILayout.Space();
            EditorGUILayout.Space();

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField(" ", new GUILayoutOption[] { GUILayout.Width(foldSpace) });
            showSceneNormalFog = EditorGUILayout.Foldout(showSceneNormalFog, "普通雾效    fog", foldStyle);
            EditorGUILayout.LabelField(" ", new GUILayoutOption[] { GUILayout.Width(space) });
            env.data.sceneNormalfog = EditorGUILayout.Toggle(env.data.sceneNormalfog, new GUILayoutOption[] { });

            EditorGUILayout.EndHorizontal();
            if (showSceneNormalFog)
            {
                EditorGUILayout.Space();

                field = serializedObject.FindProperty("data.sceneNormalfogColor");
                EditorGUILayout.PropertyField(field, new GUIContent("颜色           Color"));
                field = serializedObject.FindProperty("data.sceneNormalfogMode");
                EditorGUILayout.PropertyField(field, new GUIContent("类型           Mode"));

                if (env.data.sceneNormalfogMode == FogMode.Linear)
                {
                    field = serializedObject.FindProperty("data.sceneNormalfogStartDistance");
                    EditorGUILayout.PropertyField(field, new GUIContent("起始距离      StartDistance"));
                    field = serializedObject.FindProperty("data.sceneNormalfogEndDistance");
                    EditorGUILayout.PropertyField(field, new GUIContent("结束距离      EndDistance"));
                }
                else
                {
                    field = serializedObject.FindProperty("data.sceneNormalfogDensity");
                    EditorGUILayout.PropertyField(field, new GUIContent("浓度           Density"));
                }
            }
            #endregion

            #region sceneHeightFog

            EditorGUILayout.Space();
            EditorGUILayout.Space();

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField(" ", new GUILayoutOption[] { GUILayout.Width(foldSpace) });
            showSceneHeightFog = EditorGUILayout.Foldout(showSceneHeightFog, "高度雾       Heightfog", foldStyle);
            EditorGUILayout.LabelField(" ", new GUILayoutOption[] { GUILayout.Width(space) });
            env.data.property.heightFog = EditorGUILayout.Toggle(env.data.property.heightFog, new GUILayoutOption[] { });

            EditorGUILayout.EndHorizontal();
            if (showSceneHeightFog)
            {
                EditorGUILayout.Space();

                field = serializedObject.FindProperty("data.property.heightFogType");
                EditorGUILayout.PropertyField(field, new GUIContent("类型           Type"));

                field = serializedObject.FindProperty("data.property.heightFogColor");
                EditorGUILayout.PropertyField(field, new GUIContent("颜色           Color"));

                field = serializedObject.FindProperty("data.property.heightFogHeight");
                EditorGUILayout.PropertyField(field, new GUIContent("高度           Height"));

                field = serializedObject.FindProperty("data.property.heightFogBaseHeight");
                EditorGUILayout.PropertyField(field, new GUIContent("基准高度   BaseHeight"));

                field = serializedObject.FindProperty("data.property.heightFogFalloff");
                EditorGUILayout.PropertyField(field, new GUIContent("衰减           Falloff"));

                field = serializedObject.FindProperty("data.property.heightfogEmissionColor");
                EditorGUILayout.PropertyField(field, new GUIContent("自发光色   EmissionColor"));

                field = serializedObject.FindProperty("data.property.heightFogEmissionFalloff");
                EditorGUILayout.PropertyField(field, new GUIContent("自发光衰减 EmissionFalloff"));

                field = serializedObject.FindProperty("data.property.heightFogAnimation");
                EditorGUILayout.PropertyField(field, new GUIContent("动画           Animation"));

                if(env.data.property.heightFogAnimation)
                {
                    field = serializedObject.FindProperty("data.property.heightFogSpeed");
                    EditorGUILayout.PropertyField(field, new GUIContent("速度           Speed"));

                    field = serializedObject.FindProperty("data.property.heightFogFrequency");
                    EditorGUILayout.PropertyField(field, new GUIContent("频率           Frequency"));

                    field = serializedObject.FindProperty("data.property.heightFogAmplitude");
                    EditorGUILayout.PropertyField(field, new GUIContent("振幅           Amplitude"));
                }
            }
            #endregion

            #region sceneVolumetricFog
            EditorGUILayout.Space();
            EditorGUILayout.Space();

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField(" ", new GUILayoutOption[] { GUILayout.Width(foldSpace) });
            showSceneVolumetricFog = EditorGUILayout.Foldout(showSceneVolumetricFog, "体积雾       Volumetricfog", foldStyle);
            EditorGUILayout.LabelField(" ", new GUILayoutOption[] { GUILayout.Width(space) });
            env.data.property.volumetricFog = EditorGUILayout.Toggle(env.data.property.volumetricFog, new GUILayoutOption[] { });

            EditorGUILayout.EndHorizontal();
            if (showSceneVolumetricFog)
            {
                EditorGUILayout.Space();

                field = serializedObject.FindProperty("data.property.fogDensity");
                EditorGUILayout.PropertyField(field, new GUIContent("浓度           Density"));

                field = serializedObject.FindProperty("data.property.fogHeight");
                EditorGUILayout.PropertyField(field, new GUIContent("高度           Height"));

                field = serializedObject.FindProperty("data.property.fogBaseHeight");
                EditorGUILayout.PropertyField(field, new GUIContent("基准高度      BaseHeight"));


                field = serializedObject.FindProperty("data.property.fogColor");
                EditorGUILayout.PropertyField(field, new GUIContent("颜色           FogColor"));

                field = serializedObject.FindProperty("data.property.fogSpec");
                EditorGUILayout.PropertyField(field, new GUIContent("高光色        Specular"));

                field = serializedObject.FindProperty("data.property.fogSpecThreshold");
                EditorGUILayout.PropertyField(field, new GUIContent("高光阈值      SpecThreshold"));

                field = serializedObject.FindProperty("data.property.fogLightColor");
                EditorGUILayout.PropertyField(field, new GUIContent("光照色        LightColor"));

                bool bValue = EditorGUILayout.Toggle("自定义光照方向开关    CustomSunDirection", env.data.property.fogCustomDirection);
                if (bValue != env.data.property.fogCustomDirection)
                    env.data.property.fogCustomDirection = bValue;

                if (env.data.property.fogCustomDirection)
                {
                    field = serializedObject.FindProperty("data.property.fogSunDirection");
                    EditorGUILayout.PropertyField(field, new GUIContent("光照方向      SunDirection"));
                }

                field = serializedObject.FindProperty("data.property.fogNoiseStrength");
                EditorGUILayout.PropertyField(field, new GUIContent("扰动力度      NoiseStrength"));

                field = serializedObject.FindProperty("data.property.fogNoiseScale");
                EditorGUILayout.PropertyField(field, new GUIContent("扰动大小      NoiseScale"));

                // field = serializedObject.FindProperty("mProperty.fogNoiseSparse");
                //  EditorGUILayout.PropertyField(field, new GUIContent("扰动稀疏"));

                // field = serializedObject.FindProperty("mProperty.fogNoiseFinalMult");
                //EditorGUILayout.PropertyField(field, new GUIContent("扰动乘"));

                field = serializedObject.FindProperty("data.property.fogWindSpeed");
                EditorGUILayout.PropertyField(field, new GUIContent("风速           WindSpeed"));

                field = serializedObject.FindProperty("data.property.fogWindDirection");
                EditorGUILayout.PropertyField(field, new GUIContent("风方向        WindDirection"));

                field = serializedObject.FindProperty("data.property.fogDownSampling");
                EditorGUILayout.PropertyField(field, new GUIContent("降低分辨率   DownSampling"));

                field = serializedObject.FindProperty("data.property.fogEdgeImprove");
                EditorGUILayout.PropertyField(field, new GUIContent("边缘提升      EdgeImprove"));

                field = serializedObject.FindProperty("data.property.fogStepping");
                EditorGUILayout.PropertyField(field, new GUIContent("步进           Stepping"));

                // field = serializedObject.FindProperty("mProperty.fogSteppingNear");
                // EditorGUILayout.PropertyField(field, new GUIContent("步进近处"));

                field = serializedObject.FindProperty("data.property.fogTex");
                EditorGUILayout.PropertyField(field, new GUIContent("扰动贴图      NoiseTex"));
            }
            #endregion

            #region sceneHBAO
            EditorGUILayout.Space();
            EditorGUILayout.Space();

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField(" ", new GUILayoutOption[] { GUILayout.Width(foldSpace) });
            showSceneHBAO = EditorGUILayout.Foldout(showSceneHBAO, "环境遮蔽    HBAO", foldStyle);
            EditorGUILayout.LabelField(" ", new GUILayoutOption[] { GUILayout.Width(space) });
            env.data.property.ambientOcclusion = EditorGUILayout.Toggle(env.data.property.ambientOcclusion, new GUILayoutOption[] { });

            EditorGUILayout.EndHorizontal();
            if (showSceneHBAO)
            {
                EditorGUILayout.Space();

                field = serializedObject.FindProperty("data.property.aoRadius");
                EditorGUILayout.PropertyField(field, new GUIContent("半径           Radius"));

                field = serializedObject.FindProperty("data.property.bias");
                EditorGUILayout.PropertyField(field, new GUIContent("偏移           Bias"));

                field = serializedObject.FindProperty("data.property.aoIntensity");
                EditorGUILayout.PropertyField(field, new GUIContent("强度           Intensity"));

                field = serializedObject.FindProperty("data.property.maxDistance");
                EditorGUILayout.PropertyField(field, new GUIContent("最大显示距离 MaxDistance"));

                field = serializedObject.FindProperty("data.property.maxDistance");
                EditorGUILayout.PropertyField(field, new GUIContent("最大显示距离 MaxDistance"));

                field = serializedObject.FindProperty("data.property.aoColor");
                EditorGUILayout.PropertyField(field, new GUIContent("颜色           Color"));

                field = serializedObject.FindProperty("data.property.aoBlur");
                EditorGUILayout.PropertyField(field, new GUIContent("模糊           Blur"));

                field = serializedObject.FindProperty("data.property.debugAO");
                EditorGUILayout.PropertyField(field, new GUIContent("调试           Debug"));
            }
            #endregion

            #region sceneCloudShadow
            EditorGUILayout.Space();
            EditorGUILayout.Space();

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField(" ", new GUILayoutOption[] { GUILayout.Width(foldSpace) });
            showSceneCloudShadow = EditorGUILayout.Foldout(showSceneCloudShadow, "云层投影    CloudShadow", foldStyle);
            EditorGUILayout.LabelField(" ", new GUILayoutOption[] { GUILayout.Width(space) });
            env.data.property.cloudShadow = EditorGUILayout.Toggle(env.data.property.cloudShadow, new GUILayoutOption[] { });

            EditorGUILayout.EndHorizontal();
            if (showSceneCloudShadow)
            {
                EditorGUILayout.Space();

                field = serializedObject.FindProperty("data.property.cloudTexture");
                EditorGUILayout.PropertyField(field, new GUIContent("贴图           Texture"));

                field = serializedObject.FindProperty("data.property.cloudShadowColor");
                EditorGUILayout.PropertyField(field, new GUIContent("颜色           Color"));

                field = serializedObject.FindProperty("data.property.cloudSize");
                EditorGUILayout.PropertyField(field, new GUIContent("大小           Size"));

                field = serializedObject.FindProperty("data.property.cloudDensity");
                EditorGUILayout.PropertyField(field, new GUIContent("强度           Density"));

                field = serializedObject.FindProperty("data.property.cloudSpeed");
                EditorGUILayout.PropertyField(field, new GUIContent("速度           Speed"));

                field = serializedObject.FindProperty("data.property.cloudDirection");
                EditorGUILayout.PropertyField(field, new GUIContent("方向           Direction"));
            }
            #endregion

            #region scenebloom
            EditorGUILayout.Space();
            EditorGUILayout.Space();

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField(" ", new GUILayoutOption[] { GUILayout.Width(foldSpace) });
            showSceneBloom = EditorGUILayout.Foldout(showSceneBloom, "泛光          Bloom", foldStyle);
            EditorGUILayout.LabelField(" ", new GUILayoutOption[] { GUILayout.Width(space) });
            env.data.property.bloom.bloom = EditorGUILayout.Toggle(env.data.property.bloom.bloom, new GUILayoutOption[] { });

            EditorGUILayout.EndHorizontal();
            if (showSceneBloom)
            {
                EditorGUILayout.Space();

                field = serializedObject.FindProperty("data.property.bloom.bloomThreshold");
                EditorGUILayout.PropertyField(field, new GUIContent("阀值           Threshold"));

                field = serializedObject.FindProperty("data.property.bloom.bloomRadius");
                EditorGUILayout.PropertyField(field, new GUIContent("范围           Radius"));

                field = serializedObject.FindProperty("data.property.bloom.bloomAnamorphicRatio");
                EditorGUILayout.PropertyField(field, new GUIContent("变形           Ratio"));

                field = serializedObject.FindProperty("data.property.bloom.bloomIntensity");
                EditorGUILayout.PropertyField(field, new GUIContent("强度           Intensity"));
            }
            #endregion

            #region sceneTonemapping
            EditorGUILayout.Space();
            EditorGUILayout.Space();

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField(" ", new GUILayoutOption[] { GUILayout.Width(foldSpace) });
            showSceneTonemapping = EditorGUILayout.Foldout(showSceneTonemapping, "色调映射    Tonemapping", foldStyle);
            EditorGUILayout.LabelField(" ", new GUILayoutOption[] { GUILayout.Width(space) });
            env.data.property.sceneToneMap.toneMapping = EditorGUILayout.Toggle(env.data.property.sceneToneMap.toneMapping, new GUILayoutOption[] { });
            EditorGUILayout.EndHorizontal();            

            if (showSceneTonemapping)
            {
                EditorGUILayout.Space();

                field = serializedObject.FindProperty("data.property.sceneToneMap.toneMappingType");
                EditorGUILayout.PropertyField(field, new GUIContent("类型           Type"));

                if (env.data.property.sceneToneMap.toneMappingType == DragonPostProcess.Property.ToneMappingType.ACES)
                {
                    field = serializedObject.FindProperty("data.property.sceneToneMap.acesExposure");
                    EditorGUILayout.PropertyField(field, new GUIContent("亮度调节      Exposure"));
                }

                if (env.data.property.sceneToneMap.toneMapping && env.data.property.sceneToneMap.toneMappingType == DragonPostProcessBase.Property.ToneMappingType.CUSTOM)
                {
                    field = serializedObject.FindProperty("data.property.sceneToneMap.customExposure");
                    EditorGUILayout.PropertyField(field, new GUIContent("亮度调节      Exposure"));  
                    DrawCustomToneCurve(env.data.property.sceneToneMap);
                    field = serializedObject.FindProperty("data.property.sceneToneMap.toneCurveToeStrength");
                    EditorGUILayout.PropertyField(field, new GUIContent("暗色区域强弱       ToeStrength"));
                    field = serializedObject.FindProperty("data.property.sceneToneMap.toneCurveToeLength");
                    EditorGUILayout.PropertyField(field, new GUIContent("暗色区域强弱范围 ToeLength"));
                    field = serializedObject.FindProperty("data.property.sceneToneMap.toneCurveShoulderStrength");
                    EditorGUILayout.PropertyField(field, new GUIContent("亮部强弱            ShoulderStrength"));
                    field = serializedObject.FindProperty("data.property.sceneToneMap.toneCurveShoulderLength");
                    EditorGUILayout.PropertyField(field, new GUIContent("高亮的映射范围    ShoulderLength"));
                    field = serializedObject.FindProperty("data.property.sceneToneMap.toneCurveShoulderAngle");
                    EditorGUILayout.PropertyField(field, new GUIContent("右侧曲线弯曲强度 ShoulderAngle"));
                    field = serializedObject.FindProperty("data.property.sceneToneMap.toneCurveGamma");
                    EditorGUILayout.PropertyField(field, new GUIContent("gamma矫正      CurveGamma"));
                }

            }
            #endregion

            #region sceneColorGrading
            EditorGUILayout.Space();
            EditorGUILayout.Space();

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField(" ", new GUILayoutOption[] { GUILayout.Width(foldSpace) });
            showSceneColorGrading = EditorGUILayout.Foldout(showSceneColorGrading, "色彩校正    ColorGrading", foldStyle);
            EditorGUILayout.LabelField(" ", new GUILayoutOption[] { GUILayout.Width(space) });
            env.data.property.sceneColorGrading.colorGrading = EditorGUILayout.Toggle(env.data.property.sceneColorGrading.colorGrading, new GUILayoutOption[] { });

            EditorGUILayout.EndHorizontal();
            if (showSceneColorGrading)
            {
                EditorGUILayout.Space();

                field = serializedObject.FindProperty("data.property.sceneColorGrading.colorWheels");
                EditorGUILayout.PropertyField(field);

                field = serializedObject.FindProperty("data.property.sceneColorGrading.colorFilter");
                EditorGUILayout.PropertyField(field);

                field = serializedObject.FindProperty("data.property.sceneColorGrading.temperatureShift");
                EditorGUILayout.PropertyField(field, new GUIContent("色温          TemperatureShift"));

                field = serializedObject.FindProperty("data.property.sceneColorGrading.tint");
                EditorGUILayout.PropertyField(field, new GUIContent("色温矫正      Tint"));

                GUILayout.Label("                   ");
                field = serializedObject.FindProperty("data.property.sceneColorGrading.hue");
                EditorGUILayout.PropertyField(field, new GUIContent("色度          Hue"));

                field = serializedObject.FindProperty("data.property.sceneColorGrading.saturation");
                EditorGUILayout.PropertyField(field, new GUIContent("饱和度        saturation"));                   

                GUILayout.Label("                  ");
                field = serializedObject.FindProperty("data.property.sceneColorGrading.contrast");
                EditorGUILayout.PropertyField(field, new GUIContent("对比度        Contrast"));     

                field = serializedObject.FindProperty("data.property.sceneColorGrading.channelMixer");
                EditorGUILayout.PropertyField(field);

               // field = serializedObject.FindProperty("data.property.sceneColorGrading.curves");
                //EditorGUILayout.PropertyField(field);
            }
            #endregion

            #region sceneUserLut
            EditorGUILayout.Space();
            EditorGUILayout.Space();

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField(" ", new GUILayoutOption[] { GUILayout.Width(foldSpace) });
            showSceneUserLut = EditorGUILayout.Foldout(showSceneUserLut, "颜色校正贴图 UserLut", foldStyle);
            EditorGUILayout.LabelField(" ", new GUILayoutOption[] { GUILayout.Width(space) });
            env.data.property.sceneUserLut.userLut = EditorGUILayout.Toggle(env.data.property.sceneUserLut.userLut, new GUILayoutOption[] { });

            EditorGUILayout.EndHorizontal();
            if (showSceneUserLut)
            {
                EditorGUILayout.Space();

                field = serializedObject.FindProperty("data.property.sceneUserLut.lutTex");
                EditorGUILayout.PropertyField(field, new GUIContent("贴图           Texture"));

                field = serializedObject.FindProperty("data.property.sceneUserLut.contribution");
                EditorGUILayout.PropertyField(field, new GUIContent("权重           Contribution"));
            }
            #endregion

            #region sceneLumaOcclusion
            EditorGUILayout.Space();
            EditorGUILayout.Space();

            EditorGUILayout.BeginHorizontal();

            EditorGUILayout.LabelField(" ", new GUILayoutOption[] { GUILayout.Width(foldSpace) });

            showSceneLBAO = EditorGUILayout.Foldout(showSceneLBAO, "明度遮蔽    LBAO", foldStyle);
            EditorGUILayout.LabelField(" ", new GUILayoutOption[] { GUILayout.Width(space) });
            env.data.property.lumaOcclusion = EditorGUILayout.Toggle(env.data.property.lumaOcclusion, new GUILayoutOption[] { });

            EditorGUILayout.EndHorizontal();
            if (showSceneLBAO)
            {
                EditorGUILayout.Space();

                field = serializedObject.FindProperty("data.property.loThreshold");
                EditorGUILayout.PropertyField(field, new GUIContent("阈值           Threshold"));

                field = serializedObject.FindProperty("data.property.loRadius");
                EditorGUILayout.PropertyField(field, new GUIContent("范围           Radius"));

                field = serializedObject.FindProperty("data.property.loIntensity");
                EditorGUILayout.PropertyField(field, new GUIContent("强度           Intensity"));

                field = serializedObject.FindProperty("data.property.loBlur");
                EditorGUILayout.PropertyField(field, new GUIContent("模糊           Blur"));

                field = serializedObject.FindProperty("data.property.directional");
                EditorGUILayout.PropertyField(field, new GUIContent("方向           Directional"));

                field = serializedObject.FindProperty("data.property.radian");
                EditorGUILayout.PropertyField(field, new GUIContent("方向角度     Radian"));

                field = serializedObject.FindProperty("data.property.showLO");
                EditorGUILayout.PropertyField(field, new GUIContent("调试           Debug"));
            }
            #endregion
        }


        EditorGUILayout.EndVertical();
    }

    public void OnPlayerGUI()
    {
        //设置整个界面是以垂直方向来布局
        EditorGUILayout.BeginVertical();

        if (DragonPostProcesBaseEditor.s_Styles == null)
            DragonPostProcesBaseEditor.s_Styles = new DragonPostProcesBaseEditor.Styles();

        GUIStyle helpStyle = new GUIStyle(EditorStyles.helpBox);  // 这里我用EditorStyles的centeredGreyMiniLabel来初始化我的新风格
        helpStyle.fontStyle = FontStyle.Bold;                       // 新Style的字体为粗体
        helpStyle.fontSize = 13;
        helpStyle.normal.textColor = Color.red;

        GUIStyle foldStyle = new GUIStyle(EditorStyles.foldoutPreDrop);  // 这里我用EditorStyles的centeredGreyMiniLabel来初始化我的新风格
        foldStyle.fontStyle = FontStyle.Bold;                       // 新Style的字体为粗体
        foldStyle.fontSize = 12;
        foldStyle.normal.textColor = Color.black;
        foldStyle.onNormal.textColor = Color.black;
        foldStyle.fixedWidth = 270;

        int foldSpace = 10;

        float space = 210.0f;

        if (env.data != null)
        {
            EditorGUILayout.Space();

            SerializedProperty field;

            #region playerBloom
            EditorGUILayout.Space();
            EditorGUILayout.Space();

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField(" ", new GUILayoutOption[] { GUILayout.Width(foldSpace) });
            showPlayerBloom = EditorGUILayout.Foldout(showPlayerBloom, "泛光          Bloom", foldStyle);
            EditorGUILayout.LabelField(" ", new GUILayoutOption[] { GUILayout.Width(space) });
            env.data.property.playerBloom.bloom = EditorGUILayout.Toggle(env.data.property.playerBloom.bloom, new GUILayoutOption[] { });

            EditorGUILayout.EndHorizontal();
            if (showPlayerBloom)
            {
                EditorGUILayout.Space();

                field = serializedObject.FindProperty("data.property.playerBloom.bloomThreshold");
                EditorGUILayout.PropertyField(field, new GUIContent("阀值           Threshold"));

                field = serializedObject.FindProperty("data.property.playerBloom.bloomRadius");
                EditorGUILayout.PropertyField(field, new GUIContent("范围           Radius"));

                field = serializedObject.FindProperty("data.property.playerBloom.bloomAnamorphicRatio");
                EditorGUILayout.PropertyField(field, new GUIContent("变形           Ratio"));

                field = serializedObject.FindProperty("data.property.playerBloom.bloomIntensity");
                EditorGUILayout.PropertyField(field, new GUIContent("强度           Intensity"));
            }
            #endregion

            #region playerTonemapping
            EditorGUILayout.Space();
            EditorGUILayout.Space();

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField(" ", new GUILayoutOption[] { GUILayout.Width(foldSpace) });
            showPlayerTonemapping = EditorGUILayout.Foldout(showPlayerTonemapping, "色调映射    Tonemapping", foldStyle);
            EditorGUILayout.LabelField(" ", new GUILayoutOption[] { GUILayout.Width(space) });
            env.data.property.playerToneMap.toneMapping = EditorGUILayout.Toggle(env.data.property.playerToneMap.toneMapping, new GUILayoutOption[] { });

            EditorGUILayout.EndHorizontal();
            if (showPlayerTonemapping)
            {
                EditorGUILayout.Space();

                field = serializedObject.FindProperty("data.property.playerToneMap.toneMappingType");
                EditorGUILayout.PropertyField(field, new GUIContent("类型           Type"));

                if (env.data.property.playerToneMap.toneMappingType == DragonPostProcess.Property.ToneMappingType.ACES)
                {
                    field = serializedObject.FindProperty("data.property.playerToneMap.acesExposure");
                    EditorGUILayout.PropertyField(field, new GUIContent("亮度调节      Exposure"));
                }

                if (env.data.property.playerToneMap.toneMapping && env.data.property.playerToneMap.toneMappingType == DragonPostProcessBase.Property.ToneMappingType.CUSTOM)
                {
                    field = serializedObject.FindProperty("data.property.playerToneMap.customExposure");
                    EditorGUILayout.PropertyField(field, new GUIContent("亮度调节      Exposure"));
                    DrawCustomToneCurve(env.data.property.playerToneMap);
                    field = serializedObject.FindProperty("data.property.playerToneMap.toneCurveToeStrength");
                    EditorGUILayout.PropertyField(field, new GUIContent("暗色区域强弱       ToeStrength"));
                    field = serializedObject.FindProperty("data.property.playerToneMap.toneCurveToeLength");
                    EditorGUILayout.PropertyField(field, new GUIContent("暗色区域强弱范围 ToeLength"));
                    field = serializedObject.FindProperty("data.property.playerToneMap.toneCurveShoulderStrength");
                    EditorGUILayout.PropertyField(field, new GUIContent("亮部强弱            ShoulderStrength"));
                    field = serializedObject.FindProperty("data.property.playerToneMap.toneCurveShoulderLength");
                    EditorGUILayout.PropertyField(field, new GUIContent("高亮的映射范围    ShoulderLength"));
                    field = serializedObject.FindProperty("data.property.playerToneMap.toneCurveShoulderAngle");
                    EditorGUILayout.PropertyField(field, new GUIContent("右侧曲线弯曲强度 ShoulderAngle"));
                    field = serializedObject.FindProperty("data.property.playerToneMap.toneCurveGamma");
                    EditorGUILayout.PropertyField(field, new GUIContent("gamma矫正      CurveGamma"));
                }

            }
            #endregion

            #region playerColorGrading
            EditorGUILayout.Space();
            EditorGUILayout.Space();

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField(" ", new GUILayoutOption[] { GUILayout.Width(foldSpace) });
            showPlayerColorGrading = EditorGUILayout.Foldout(showPlayerColorGrading, "色彩校正    ColorGrading", foldStyle);
            EditorGUILayout.LabelField(" ", new GUILayoutOption[] { GUILayout.Width(space) });
            env.data.property.playerColorGrading.colorGrading = EditorGUILayout.Toggle(env.data.property.playerColorGrading.colorGrading, new GUILayoutOption[] { });

            EditorGUILayout.EndHorizontal();
            if (showPlayerColorGrading)
            {
                EditorGUILayout.Space();

                field = serializedObject.FindProperty("data.property.playerColorGrading.colorWheels");
                EditorGUILayout.PropertyField(field);

                field = serializedObject.FindProperty("data.property.playerColorGrading.colorFilter");
                EditorGUILayout.PropertyField(field);

                field = serializedObject.FindProperty("data.property.playerColorGrading.temperatureShift");
                EditorGUILayout.PropertyField(field, new GUIContent("色温          TemperatureShift"));

                field = serializedObject.FindProperty("data.property.playerColorGrading.tint");
                EditorGUILayout.PropertyField(field, new GUIContent("色温矫正      Tint"));

                GUILayout.Label("                   ");
                field = serializedObject.FindProperty("data.property.playerColorGrading.hue");
                EditorGUILayout.PropertyField(field, new GUIContent("色度          Hue"));

                field = serializedObject.FindProperty("data.property.playerColorGrading.saturation");
                EditorGUILayout.PropertyField(field, new GUIContent("饱和度        saturation"));

                GUILayout.Label("                  ");
                field = serializedObject.FindProperty("data.property.playerColorGrading.contrast");
                EditorGUILayout.PropertyField(field, new GUIContent("对比度        Contrast"));

                field = serializedObject.FindProperty("data.property.playerColorGrading.channelMixer");
                EditorGUILayout.PropertyField(field);

                //  field = serializedObject.FindProperty("data.property.playerColorGrading.curves");
                //  EditorGUILayout.PropertyField(field);
            }
            #endregion

            #region playerUserLut
            EditorGUILayout.Space();
            EditorGUILayout.Space();

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField(" ", new GUILayoutOption[] { GUILayout.Width(foldSpace) });
            showPlayerUserLut = EditorGUILayout.Foldout(showPlayerUserLut, "颜色校正贴图 UserLut", foldStyle);
            EditorGUILayout.LabelField(" ", new GUILayoutOption[] { GUILayout.Width(space) });
            env.data.property.playerUserLut.userLut = EditorGUILayout.Toggle(env.data.property.playerUserLut.userLut, new GUILayoutOption[] { });

            EditorGUILayout.EndHorizontal();
            if (showPlayerUserLut)
            {
                EditorGUILayout.Space();

                field = serializedObject.FindProperty("data.property.playerUserLut.lutTex");
                EditorGUILayout.PropertyField(field, new GUIContent("贴图           Texture"));

                field = serializedObject.FindProperty("data.property.playerUserLut.contribution");
                EditorGUILayout.PropertyField(field, new GUIContent("权重           Contribution"));
            }
            #endregion
        }


        EditorGUILayout.EndVertical();
    }

    public void OnEffectGUI()
    {
        //设置整个界面是以垂直方向来布局
        EditorGUILayout.BeginVertical();

        if (DragonPostProcesBaseEditor.s_Styles == null)
            DragonPostProcesBaseEditor.s_Styles = new DragonPostProcesBaseEditor.Styles();

        GUIStyle helpStyle = new GUIStyle(EditorStyles.helpBox);  // 这里我用EditorStyles的centeredGreyMiniLabel来初始化我的新风格
        helpStyle.fontStyle = FontStyle.Bold;                       // 新Style的字体为粗体
        helpStyle.fontSize = 13;
        helpStyle.normal.textColor = Color.red;

        GUIStyle foldStyle = new GUIStyle(EditorStyles.foldoutPreDrop);  // 这里我用EditorStyles的centeredGreyMiniLabel来初始化我的新风格
        foldStyle.fontStyle = FontStyle.Bold;                       // 新Style的字体为粗体
        foldStyle.fontSize = 12;
        foldStyle.normal.textColor = Color.black;
        foldStyle.onNormal.textColor = Color.black;
        foldStyle.fixedWidth = 270;

        int foldSpace = 10;

        float space = 210.0f;

        if (env.data != null)
        {
            EditorGUILayout.Space();

            SerializedProperty field;


            #region alphabloom
            EditorGUILayout.Space();
            EditorGUILayout.Space();

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField(" ", new GUILayoutOption[] { GUILayout.Width(foldSpace) });
            showEffectBloom = EditorGUILayout.Foldout(showEffectBloom, "泛光          Bloom", foldStyle);
            EditorGUILayout.LabelField(" ", new GUILayoutOption[] { GUILayout.Width(space) });
            env.data.property.alphaBloom.bloom = EditorGUILayout.Toggle(env.data.property.alphaBloom.bloom, new GUILayoutOption[] { });

            EditorGUILayout.EndHorizontal();
            if (showEffectBloom)
            {
                EditorGUILayout.Space();

                field = serializedObject.FindProperty("data.property.alphaBloom.bloomThreshold");
                EditorGUILayout.PropertyField(field, new GUIContent("阀值           Threshold"));

                field = serializedObject.FindProperty("data.property.alphaBloom.bloomRadius");
                EditorGUILayout.PropertyField(field, new GUIContent("范围           Radius"));

                field = serializedObject.FindProperty("data.property.alphaBloom.bloomAnamorphicRatio");
                EditorGUILayout.PropertyField(field, new GUIContent("变形           Ratio"));

                field = serializedObject.FindProperty("data.property.alphaBloom.bloomIntensity");
                EditorGUILayout.PropertyField(field, new GUIContent("强度           Intensity"));
            }
            #endregion

            #region alphaTonemapping
            EditorGUILayout.Space();
            EditorGUILayout.Space();

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField(" ", new GUILayoutOption[] { GUILayout.Width(foldSpace) });
            showEffectTonemapping = EditorGUILayout.Foldout(showEffectTonemapping, "色调映射    Tonemapping", foldStyle);
            EditorGUILayout.LabelField(" ", new GUILayoutOption[] { GUILayout.Width(space) });
            env.data.property.alphaToneMap.toneMapping = EditorGUILayout.Toggle(env.data.property.alphaToneMap.toneMapping, new GUILayoutOption[] { });

            EditorGUILayout.EndHorizontal();
            if (showEffectTonemapping)
            {
                EditorGUILayout.Space();

                field = serializedObject.FindProperty("data.property.alphaToneMap.toneMappingType");
                EditorGUILayout.PropertyField(field, new GUIContent("类型           Type"));

                if (env.data.property.alphaToneMap.toneMappingType == DragonPostProcess.Property.ToneMappingType.ACES)
                {
                    field = serializedObject.FindProperty("data.property.alphaToneMap.acesExposure");
                    EditorGUILayout.PropertyField(field, new GUIContent("亮度调节      Exposure"));
                }

                if (env.data.property.alphaToneMap.toneMapping && env.data.property.alphaToneMap.toneMappingType == DragonPostProcessBase.Property.ToneMappingType.CUSTOM)
                {
                    field = serializedObject.FindProperty("data.property.alphaToneMap.customExposure");
                    EditorGUILayout.PropertyField(field, new GUIContent("亮度调节      Exposure"));
                    DrawCustomToneCurve(env.data.property.alphaToneMap);
                    field = serializedObject.FindProperty("data.property.alphaToneMap.toneCurveToeStrength");
                    EditorGUILayout.PropertyField(field, new GUIContent("暗色区域强弱       ToeStrength"));
                    field = serializedObject.FindProperty("data.property.alphaToneMap.toneCurveToeLength");
                    EditorGUILayout.PropertyField(field, new GUIContent("暗色区域强弱范围 ToeLength"));
                    field = serializedObject.FindProperty("data.property.alphaToneMap.toneCurveShoulderStrength");
                    EditorGUILayout.PropertyField(field, new GUIContent("亮部强弱            ShoulderStrength"));
                    field = serializedObject.FindProperty("data.property.alphaToneMap.toneCurveShoulderLength");
                    EditorGUILayout.PropertyField(field, new GUIContent("高亮的映射范围    ShoulderLength"));
                    field = serializedObject.FindProperty("data.property.alphaToneMap.toneCurveShoulderAngle");
                    EditorGUILayout.PropertyField(field, new GUIContent("右侧曲线弯曲强度 ShoulderAngle"));
                    field = serializedObject.FindProperty("data.property.alphaToneMap.toneCurveGamma");
                    EditorGUILayout.PropertyField(field, new GUIContent("gamma矫正      CurveGamma"));
                }

            }
            #endregion

            #region alphaColorGrading
            EditorGUILayout.Space();
            EditorGUILayout.Space();

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField(" ", new GUILayoutOption[] { GUILayout.Width(foldSpace) });
            showEffectColorGrading = EditorGUILayout.Foldout(showEffectColorGrading, "色彩校正    ColorGrading", foldStyle);
            EditorGUILayout.LabelField(" ", new GUILayoutOption[] { GUILayout.Width(space) });
            env.data.property.alphaColorGrading.colorGrading = EditorGUILayout.Toggle(env.data.property.alphaColorGrading.colorGrading, new GUILayoutOption[] { });

            EditorGUILayout.EndHorizontal();
            if (showEffectColorGrading)
            {
                EditorGUILayout.Space();

                field = serializedObject.FindProperty("data.property.alphaColorGrading.colorWheels");
                EditorGUILayout.PropertyField(field);

                field = serializedObject.FindProperty("data.property.alphaColorGrading.colorFilter");
                EditorGUILayout.PropertyField(field);

                field = serializedObject.FindProperty("data.property.alphaColorGrading.temperatureShift");
                EditorGUILayout.PropertyField(field, new GUIContent("色温          TemperatureShift"));

                field = serializedObject.FindProperty("data.property.alphaColorGrading.tint");
                EditorGUILayout.PropertyField(field, new GUIContent("色温矫正      Tint"));

                GUILayout.Label("                   ");
                field = serializedObject.FindProperty("data.property.alphaColorGrading.hue");
                EditorGUILayout.PropertyField(field, new GUIContent("色度          Hue"));

                field = serializedObject.FindProperty("data.property.alphaColorGrading.saturation");
                EditorGUILayout.PropertyField(field, new GUIContent("饱和度        saturation"));


                GUILayout.Label("                  ");
                field = serializedObject.FindProperty("data.property.alphaColorGrading.contrast");
                EditorGUILayout.PropertyField(field, new GUIContent("对比度        Contrast"));

                field = serializedObject.FindProperty("data.property.alphaColorGrading.channelMixer");
                EditorGUILayout.PropertyField(field);

               // field = serializedObject.FindProperty("data.property.alphaColorGrading.curves");
              //  EditorGUILayout.PropertyField(field);
            }
            #endregion

            #region alphaUserLut
            EditorGUILayout.Space();
            EditorGUILayout.Space();

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField(" ", new GUILayoutOption[] { GUILayout.Width(foldSpace) });
            showEffectUserLut = EditorGUILayout.Foldout(showEffectUserLut, "颜色校正贴图 UserLut", foldStyle);
            EditorGUILayout.LabelField(" ", new GUILayoutOption[] { GUILayout.Width(space) });
            env.data.property.alphaUserLut.userLut = EditorGUILayout.Toggle(env.data.property.alphaUserLut.userLut, new GUILayoutOption[] { });

            EditorGUILayout.EndHorizontal();
            if (showEffectUserLut)
            {
                EditorGUILayout.Space();

                field = serializedObject.FindProperty("data.property.alphaUserLut.lutTex");
                EditorGUILayout.PropertyField(field, new GUIContent("贴图           Texture"));

                field = serializedObject.FindProperty("data.property.alphaUserLut.contribution");
                EditorGUILayout.PropertyField(field, new GUIContent("权重           Contribution"));
            }
            #endregion


            #region distortion
            EditorGUILayout.Space();
            EditorGUILayout.Space();

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField(" ", new GUILayoutOption[] { GUILayout.Width(foldSpace) });
            showEffectDistortion = EditorGUILayout.Foldout(showEffectDistortion, "空气扭曲    Distortion", foldStyle);
            EditorGUILayout.LabelField(" ", new GUILayoutOption[] { GUILayout.Width(space) });
            env.data.property.distortion = EditorGUILayout.Toggle(env.data.property.distortion, new GUILayoutOption[] { });

            EditorGUILayout.EndHorizontal();
            if (showEffectDistortion)
            {
                EditorGUILayout.Space();

                //field = serializedObject.FindProperty("data.property.alphaUserLut.lutTex");
                //EditorGUILayout.PropertyField(field, new GUIContent("贴图           Texture"));
            }
            #endregion        
        }


        EditorGUILayout.EndVertical();
    }

    public void OnGlobalGUI()
    {
        //设置整个界面是以垂直方向来布局
        EditorGUILayout.BeginVertical();

        if (DragonPostProcesBaseEditor.s_Styles == null)
            DragonPostProcesBaseEditor.s_Styles = new DragonPostProcesBaseEditor.Styles();

        GUIStyle helpStyle = new GUIStyle(EditorStyles.helpBox);  // 这里我用EditorStyles的centeredGreyMiniLabel来初始化我的新风格
        helpStyle.fontStyle = FontStyle.Bold;                       // 新Style的字体为粗体
        helpStyle.fontSize = 13;
        helpStyle.normal.textColor = Color.red;

        GUIStyle foldStyle = new GUIStyle(EditorStyles.foldoutPreDrop);  // 这里我用EditorStyles的centeredGreyMiniLabel来初始化我的新风格
        foldStyle.fontStyle = FontStyle.Bold;                       // 新Style的字体为粗体
        foldStyle.fontSize = 12;
        foldStyle.normal.textColor = Color.black;
        foldStyle.onNormal.textColor = Color.black;
        foldStyle.fixedWidth = 270;

        int foldSpace = 10;

        float space = 210.0f;

        if (env.data != null)
        {
            EditorGUILayout.Space();

            SerializedProperty field;
            

            #region globalDof
            EditorGUILayout.Space();
            EditorGUILayout.Space();

            /*
            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField(" ", new GUILayoutOption[] { GUILayout.Width(foldSpace) });
            showGlobalDOF= EditorGUILayout.Foldout(showGlobalDOF, "景深          DepthOfField", foldStyle);
            EditorGUILayout.LabelField(" ", new GUILayoutOption[] { GUILayout.Width(space) });
            env.data.property.depthOfField = EditorGUILayout.Toggle(env.data.property.depthOfField, new GUILayoutOption[] { });

            EditorGUILayout.EndHorizontal();
            if (showGlobalDOF)
            {
                EditorGUILayout.Space();

                field = serializedObject.FindProperty("data.property.focusDistance");
                EditorGUILayout.PropertyField(field, new GUIContent("焦距           focusDistance"));

                field = serializedObject.FindProperty("data.property.focalLength");
                EditorGUILayout.PropertyField(field, new GUIContent("镜头和胶卷之间的距离  focalLength"));

                field = serializedObject.FindProperty("data.property.aperture");
                EditorGUILayout.PropertyField(field, new GUIContent("孔径比(f-stop)        focalLength"));

                field = serializedObject.FindProperty("data.property.kernelSize");
                EditorGUILayout.PropertyField(field, new GUIContent("模糊大小     kernelSize"));
            }
            #endregion
            */

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField(" ", new GUILayoutOption[] { GUILayout.Width(foldSpace) });
            showGlobalFastDOF = EditorGUILayout.Foldout(showGlobalFastDOF, "景深          DepthOfField", foldStyle);
            EditorGUILayout.LabelField(" ", new GUILayoutOption[] { GUILayout.Width(space) });
            env.data.property.dofFast = EditorGUILayout.Toggle(env.data.property.dofFast, new GUILayoutOption[] { });

            EditorGUILayout.EndHorizontal();
            if (showGlobalFastDOF)
            {
                EditorGUILayout.Space();

                field = serializedObject.FindProperty("data.property.dofStart");
                EditorGUILayout.PropertyField(field, new GUIContent("开始位置     Start"));

                field = serializedObject.FindProperty("data.property.dofDistance");
                EditorGUILayout.PropertyField(field, new GUIContent("过渡距离     Distance"));

                field = serializedObject.FindProperty("data.property.dofRadius");
                EditorGUILayout.PropertyField(field, new GUIContent("模糊          Radius"));
            }
            #endregion

            #region globalMask
            EditorGUILayout.Space();
            EditorGUILayout.Space();

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField(" ", new GUILayoutOption[] { GUILayout.Width(foldSpace) });
            showGlobalMask = EditorGUILayout.Foldout(showGlobalMask, "滤镜贴图    Mask", foldStyle);
            EditorGUILayout.LabelField(" ", new GUILayoutOption[] { GUILayout.Width(space) });
            env.data.property.mask = EditorGUILayout.Toggle(env.data.property.mask, new GUILayoutOption[] { });

            EditorGUILayout.EndHorizontal();
            if (showGlobalMask)
            {
                EditorGUILayout.Space();

                field = serializedObject.FindProperty("data.property.overlayTex");
                EditorGUILayout.PropertyField(field, new GUIContent("叠加贴图     overlayTex"));

                field = serializedObject.FindProperty("data.property.overlayColor");
                EditorGUILayout.PropertyField(field, new GUIContent("颜色偏移     Color"));
            }
            #endregion

            #region globalVignette
            EditorGUILayout.Space();
            EditorGUILayout.Space();

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField(" ", new GUILayoutOption[] { GUILayout.Width(foldSpace) });
            showGlobalVignette = EditorGUILayout.Foldout(showGlobalVignette, "晕映          Vignette", foldStyle);
            EditorGUILayout.LabelField(" ", new GUILayoutOption[] { GUILayout.Width(space) });
            env.data.property.vignette = EditorGUILayout.Toggle(env.data.property.vignette, new GUILayoutOption[] { });

            EditorGUILayout.EndHorizontal();
            if (showGlobalVignette)
            {
                EditorGUILayout.Space();

                field = serializedObject.FindProperty("data.property.ignoreAlphaBuffer");
                EditorGUILayout.PropertyField(field, new GUIContent("忽略透明层   IgnoreAlphaBuffer"));

                field = serializedObject.FindProperty("data.property.vignetteIntensity");
                EditorGUILayout.PropertyField(field, new GUIContent("强度           Intensity"));

                field = serializedObject.FindProperty("data.property.vignetteSmoothness");
                EditorGUILayout.PropertyField(field, new GUIContent("平滑           Smoothness"));

                field = serializedObject.FindProperty("data.property.vignetteRoundness");
                EditorGUILayout.PropertyField(field, new GUIContent("圆行度        Roundness"));

                field = serializedObject.FindProperty("data.property.vignetteColor");
                EditorGUILayout.PropertyField(field, new GUIContent("颜色           Color"));
            }
            #endregion

            #region globalFXAA
            EditorGUILayout.Space();
            EditorGUILayout.Space();

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField(" ", new GUILayoutOption[] { GUILayout.Width(foldSpace) });
            showGlobalFXAA = EditorGUILayout.Foldout(showGlobalFXAA, "抗锯齿       FXAA", foldStyle);
            EditorGUILayout.LabelField(" ", new GUILayoutOption[] { GUILayout.Width(space) });
            env.data.property.antialiasing = EditorGUILayout.Toggle(env.data.property.antialiasing, new GUILayoutOption[] { });

            EditorGUILayout.EndHorizontal();
            if (showGlobalFXAA)
            {
                EditorGUILayout.Space();

                field = serializedObject.FindProperty("data.property.fxaaQuality");
                EditorGUILayout.PropertyField(field, new GUIContent("质量           Quality"));

            }
            #endregion

            #region radial
            EditorGUILayout.Space();
            EditorGUILayout.Space();

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField(" ", new GUILayoutOption[] { GUILayout.Width(foldSpace) });
            showGlobalRadial = EditorGUILayout.Foldout(showGlobalRadial, "径向模糊     RADIAL", foldStyle);
            EditorGUILayout.LabelField(" ", new GUILayoutOption[] { GUILayout.Width(space) });
            env.data.property.radialBlur = EditorGUILayout.Toggle(env.data.property.radialBlur, new GUILayoutOption[] { });

            EditorGUILayout.EndHorizontal();
            if (showGlobalRadial)
            {
                EditorGUILayout.Space();

                field = serializedObject.FindProperty("data.property.radialAmount");
                EditorGUILayout.PropertyField(field, new GUIContent("Amount           Amount"));

                field = serializedObject.FindProperty("data.property.radialStrength");
                EditorGUILayout.PropertyField(field, new GUIContent("强度           Strength"));

            }
            #endregion

            #region globalBorder
            EditorGUILayout.Space();
            EditorGUILayout.Space();

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField(" ", new GUILayoutOption[] { GUILayout.Width(foldSpace) });
            showGlobalBorder = EditorGUILayout.Foldout(showGlobalBorder, "边缘          Border", foldStyle);
            EditorGUILayout.LabelField(" ", new GUILayoutOption[] { GUILayout.Width(space) });
            env.data.property.border = EditorGUILayout.Toggle(env.data.property.border, new GUILayoutOption[] { });

            EditorGUILayout.EndHorizontal();
            if (showGlobalBorder)
            {
                EditorGUILayout.Space();           ;

                field = serializedObject.FindProperty("data.property.borderColor");
                EditorGUILayout.PropertyField(field, new GUIContent("颜色           Color"));

                field = serializedObject.FindProperty("data.property.borderIntensity");
                EditorGUILayout.PropertyField(field, new GUIContent("强度           Intensity"));

                //field = serializedObject.FindProperty("data.property.borderMaxAlpha");
                //EditorGUILayout.PropertyField(field, new GUIContent("透明度      Alpha"));

                field = serializedObject.FindProperty("data.property.borderMask");
                EditorGUILayout.PropertyField(field, new GUIContent("遮罩           MaskTex"));

                field = serializedObject.FindProperty("data.property.borderTile");
                EditorGUILayout.PropertyField(field, new GUIContent("平铺           Tile"));

                field = serializedObject.FindProperty("data.property.borderTex");
                EditorGUILayout.PropertyField(field, new GUIContent("贴图           Texture"));
            }
            #endregion

            #region chromaticAberration
            EditorGUILayout.Space();
            EditorGUILayout.Space();

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField(" ", new GUILayoutOption[] { GUILayout.Width(foldSpace) });
            showGlobalChromaticAberration = EditorGUILayout.Foldout(showGlobalChromaticAberration, "色彩偏移   ChromaticAberration", foldStyle);
            EditorGUILayout.LabelField(" ", new GUILayoutOption[] { GUILayout.Width(space) });
            env.data.property.chromaticAberration = EditorGUILayout.Toggle(env.data.property.chromaticAberration, new GUILayoutOption[] { });

            EditorGUILayout.EndHorizontal();
            if (showGlobalChromaticAberration)
            {
                EditorGUILayout.Space(); ;

                field = serializedObject.FindProperty("data.property.chromaticAberrationType");
                EditorGUILayout.PropertyField(field, new GUIContent("类型           type"));

                if(env.data.property.chromaticAberrationType == DragonPostProcessBase.Property.ChromaticAberrationType.Radial)
                {
                    field = serializedObject.FindProperty("data.property.chromaAmount");
                    EditorGUILayout.PropertyField(field, new GUIContent("权重           chromaAmount"));
                }

                if (env.data.property.chromaticAberrationType == DragonPostProcessBase.Property.ChromaticAberrationType.FullScreen)
                {
                    field = serializedObject.FindProperty("data.property.redOffset");
                    EditorGUILayout.PropertyField(field, new GUIContent("红移           redOffset"));

                    field = serializedObject.FindProperty("data.property.blueOffset");
                    EditorGUILayout.PropertyField(field, new GUIContent("蓝移           blueOffset"));
                }
            }
            #endregion
        }
        EditorGUILayout.EndVertical();

    }
}


