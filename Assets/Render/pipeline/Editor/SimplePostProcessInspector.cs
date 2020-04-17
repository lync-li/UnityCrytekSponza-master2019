using UnityEngine;
using UnityEngine.Rendering;
using UnityEditor;
using System.Collections;
using UnityEngine.Rendering.PostProcessing;

[ExecuteInEditMode]
[CustomEditor(typeof(SimplePostProcess),true)]
public class SimplePostProcessInspector : Editor
{
    // Custom tone curve drawing
    const int k_CustomToneCurveResolution = 48;
    const float k_CustomToneCurveRangeY = 1.025f;

    // readonly HableCurve m_HableCurve = new HableCurve();

    SimplePostProcess simplePP;

    bool showSceneBloom;
    bool showSceneTonemapping;
    bool showSceneColorGrading;
    bool showSceneUserLut;

    private void OnEnable()
    {
        simplePP = serializedObject.targetObject as SimplePostProcess;

        DragonPostProcessBase.Property property = simplePP.mProperty;
        if (property == null)
        {
            property = new DragonPostProcessBase.Property();
            simplePP.SetProperty(property);
        }
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

        OnSceneGUI();

        EditorGUILayout.LabelField("________________________________________________");  

        if(simplePP.transform.localScale.x > 1 )
            simplePP.transform.localScale -= new Vector3(0.01f, 0, 0);
        else
            simplePP.transform.localScale += new Vector3(0.01f, 0, 0);
        //env.data.property.alphaColorGrading.colorWheels.shadows = Color.white;

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

        if (simplePP.mProperty != null)
        {          
            #region scenebloom
            EditorGUILayout.Space();
            EditorGUILayout.Space();

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField(" ", new GUILayoutOption[] { GUILayout.Width(foldSpace) });
            showSceneBloom = EditorGUILayout.Foldout(showSceneBloom, "泛光          Bloom", foldStyle);
            EditorGUILayout.LabelField(" ", new GUILayoutOption[] { GUILayout.Width(space) });
            simplePP.mProperty.bloom.bloom = EditorGUILayout.Toggle(simplePP.mProperty.bloom.bloom, new GUILayoutOption[] { });

            SerializedProperty field;
            EditorGUILayout.EndHorizontal();
            if (showSceneBloom)
            {
                EditorGUILayout.Space();

                field = serializedObject.FindProperty("mProperty.bloom.bloomThreshold");
                EditorGUILayout.PropertyField(field, new GUIContent("阀值           Threshold"));

                field = serializedObject.FindProperty("mProperty.bloom.bloomRadius");
                EditorGUILayout.PropertyField(field, new GUIContent("范围           Radius"));

                field = serializedObject.FindProperty("mProperty.bloom.bloomAnamorphicRatio");
                EditorGUILayout.PropertyField(field, new GUIContent("变形           Ratio"));

                field = serializedObject.FindProperty("mProperty.bloom.bloomIntensity");
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
            simplePP.mProperty.sceneToneMap.toneMapping = EditorGUILayout.Toggle(simplePP.mProperty.sceneToneMap.toneMapping, new GUILayoutOption[] { });
            EditorGUILayout.EndHorizontal();            

            if (showSceneTonemapping)
            {
                EditorGUILayout.Space();

                field = serializedObject.FindProperty("mProperty.sceneToneMap.toneMappingType");
                EditorGUILayout.PropertyField(field, new GUIContent("类型           Type"));

                if (simplePP.mProperty.sceneToneMap.toneMappingType == DragonPostProcess.Property.ToneMappingType.ACES)
                {
                    field = serializedObject.FindProperty("mProperty.sceneToneMap.acesExposure");
                    EditorGUILayout.PropertyField(field, new GUIContent("亮度调节      Exposure"));
                }

                if (simplePP.mProperty.sceneToneMap.toneMapping && simplePP.mProperty.sceneToneMap.toneMappingType == DragonPostProcessBase.Property.ToneMappingType.CUSTOM)
                {
                    field = serializedObject.FindProperty("mProperty.sceneToneMap.customExposure");
                    EditorGUILayout.PropertyField(field, new GUIContent("亮度调节      Exposure"));  
                    DrawCustomToneCurve(simplePP.mProperty.sceneToneMap);
                    field = serializedObject.FindProperty("mProperty.sceneToneMap.toneCurveToeStrength");
                    EditorGUILayout.PropertyField(field, new GUIContent("暗色区域强弱       ToeStrength"));
                    field = serializedObject.FindProperty("mProperty.sceneToneMap.toneCurveToeLength");
                    EditorGUILayout.PropertyField(field, new GUIContent("暗色区域强弱范围 ToeLength"));
                    field = serializedObject.FindProperty("mProperty.sceneToneMap.toneCurveShoulderStrength");
                    EditorGUILayout.PropertyField(field, new GUIContent("亮部强弱            ShoulderStrength"));
                    field = serializedObject.FindProperty("mProperty.sceneToneMap.toneCurveShoulderLength");
                    EditorGUILayout.PropertyField(field, new GUIContent("高亮的映射范围    ShoulderLength"));
                    field = serializedObject.FindProperty("mProperty.sceneToneMap.toneCurveShoulderAngle");
                    EditorGUILayout.PropertyField(field, new GUIContent("右侧曲线弯曲强度 ShoulderAngle"));
                    field = serializedObject.FindProperty("mProperty.sceneToneMap.toneCurveGamma");
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
            simplePP.mProperty.sceneColorGrading.colorGrading = EditorGUILayout.Toggle(simplePP.mProperty.sceneColorGrading.colorGrading, new GUILayoutOption[] { });

            EditorGUILayout.EndHorizontal();
            if (showSceneColorGrading)
            {
                EditorGUILayout.Space();

                field = serializedObject.FindProperty("mProperty.sceneColorGrading.colorWheels");
                EditorGUILayout.PropertyField(field);

                field = serializedObject.FindProperty("mProperty.sceneColorGrading.colorFilter");
                EditorGUILayout.PropertyField(field);

                field = serializedObject.FindProperty("mProperty.sceneColorGrading.temperatureShift");
                EditorGUILayout.PropertyField(field, new GUIContent("色温          TemperatureShift"));

                field = serializedObject.FindProperty("mProperty.sceneColorGrading.tint");
                EditorGUILayout.PropertyField(field, new GUIContent("色温矫正      Tint"));

                GUILayout.Label("                   ");
                field = serializedObject.FindProperty("mProperty.sceneColorGrading.hue");
                EditorGUILayout.PropertyField(field, new GUIContent("色度          Hue"));

                field = serializedObject.FindProperty("mProperty.sceneColorGrading.saturation");
                EditorGUILayout.PropertyField(field, new GUIContent("饱和度        saturation"));                   

                GUILayout.Label("                  ");
                field = serializedObject.FindProperty("mProperty.sceneColorGrading.contrast");
                EditorGUILayout.PropertyField(field, new GUIContent("对比度        Contrast"));     

                field = serializedObject.FindProperty("mProperty.sceneColorGrading.channelMixer");
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
            simplePP.mProperty.sceneUserLut.userLut = EditorGUILayout.Toggle(simplePP.mProperty.sceneUserLut.userLut, new GUILayoutOption[] { });

            EditorGUILayout.EndHorizontal();
            if (showSceneUserLut)
            {
                EditorGUILayout.Space();

                field = serializedObject.FindProperty("mProperty.sceneUserLut.lutTex");
                EditorGUILayout.PropertyField(field, new GUIContent("贴图           Texture"));

                field = serializedObject.FindProperty("mProperty.sceneUserLut.contribution");
                EditorGUILayout.PropertyField(field, new GUIContent("权重           Contribution"));
            }
            #endregion
        }


        EditorGUILayout.EndVertical();
    }
}


