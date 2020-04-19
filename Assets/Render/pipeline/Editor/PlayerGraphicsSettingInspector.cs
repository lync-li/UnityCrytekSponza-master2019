using UnityEngine;
using UnityEngine.Rendering;
using UnityEditor;
using System.Collections;
using System.Collections.Generic;

[ExecuteInEditMode]
[CustomEditor(typeof(PlayerGraphicsSetting),true)]
public class PlayerGraphicsSettingInspector : Editor
{
    public override void OnInspectorGUI()
    {
        PlayerGraphicsSetting setting = serializedObject.targetObject as PlayerGraphicsSetting;

        EditorGUILayout.Space();
        EditorGUILayout.Space();


        EditorGUILayout.LabelField("---------------------------");
        EditorGUILayout.LabelField("材质Lod目前只有龙有变化");
        EditorGUILayout.LabelField("500为有描边，400以下无描边");
        EditorGUILayout.LabelField("角色bloom，角色颜色校正需要启用角色分层");
        EditorGUILayout.LabelField("特效bloom，特效颜色校正需要启用特效分层");
        EditorGUILayout.LabelField("角色分层需要HDR的支持");
        EditorGUILayout.LabelField("SSR和AO需要MRT支持");

        EditorGUILayout.LabelField("---------------------------");

        SerializedProperty field = serializedObject.FindProperty("frameRate");
        EditorGUILayout.PropertyField(field, new GUIContent("锁定上限帧率"));

        EditorGUILayout.Space();
        field = serializedObject.FindProperty("shaderLod");
        EditorGUILayout.PropertyField(field, new GUIContent("材质Lod(默认500,400)"));

        EditorGUILayout.Space();
        field = serializedObject.FindProperty("resolutionLevel");
        EditorGUILayout.PropertyField(field, new GUIContent("分辨率级别"));

        EditorGUILayout.Space();
        field = serializedObject.FindProperty("displayFPS");
        EditorGUILayout.PropertyField(field, new GUIContent("显示帧率"));

        EditorGUILayout.Space();
        field = serializedObject.FindProperty("dynamicQuality");
        EditorGUILayout.PropertyField(field, new GUIContent("动态画质"));

        EditorGUILayout.Space();
        field = serializedObject.FindProperty("hdr");
        EditorGUILayout.PropertyField(field, new GUIContent("HDR"));

        EditorGUILayout.Space();
        field = serializedObject.FindProperty("shadow");
        EditorGUILayout.PropertyField(field, new GUIContent("阴影"));

        EditorGUILayout.Space();
        field = serializedObject.FindProperty("playerLayer");
        EditorGUILayout.PropertyField(field, new GUIContent("角色分层"));

        EditorGUILayout.Space();
        field = serializedObject.FindProperty("alphaBuffer");
        EditorGUILayout.PropertyField(field, new GUIContent("透明分层"));

        EditorGUILayout.Space();
        field = serializedObject.FindProperty("distortion");
        EditorGUILayout.PropertyField(field, new GUIContent("空气扭曲"));

        EditorGUILayout.Space();
        field = serializedObject.FindProperty("sceneBloom");
        EditorGUILayout.PropertyField(field, new GUIContent("场景bloom"));

        EditorGUILayout.Space();
        field = serializedObject.FindProperty("alphaBloom");
        EditorGUILayout.PropertyField(field, new GUIContent("特效bloom"));

        EditorGUILayout.Space();
        field = serializedObject.FindProperty("playerBloom");
        EditorGUILayout.PropertyField(field, new GUIContent("角色bloom"));

        EditorGUILayout.Space();
        field = serializedObject.FindProperty("sceneColorLookup");
        EditorGUILayout.PropertyField(field, new GUIContent("场景颜色校正"));

        EditorGUILayout.Space();
        field = serializedObject.FindProperty("alphaColorLookup");
        EditorGUILayout.PropertyField(field, new GUIContent("特效颜色校正"));

        EditorGUILayout.Space();
        field = serializedObject.FindProperty("playerColorLookup");
        EditorGUILayout.PropertyField(field, new GUIContent("角色颜色校正"));

        EditorGUILayout.Space();
        field = serializedObject.FindProperty("mask");
        EditorGUILayout.PropertyField(field, new GUIContent("遮罩"));

        EditorGUILayout.Space();
        field = serializedObject.FindProperty("antialiasing");
        EditorGUILayout.PropertyField(field, new GUIContent("抗锯齿"));

        EditorGUILayout.Space();
        field = serializedObject.FindProperty("depthOfField");
        EditorGUILayout.PropertyField(field, new GUIContent("景深"));

        EditorGUILayout.Space();
        field = serializedObject.FindProperty("ambientOcclusion");
        EditorGUILayout.PropertyField(field, new GUIContent("环境光遮蔽"));

        EditorGUILayout.Space();
        field = serializedObject.FindProperty("lumaOcclusion");
        EditorGUILayout.PropertyField(field, new GUIContent("明度遮蔽"));

        EditorGUILayout.Space();
        field = serializedObject.FindProperty("heightFog");
        EditorGUILayout.PropertyField(field, new GUIContent("高度雾"));

        EditorGUILayout.Space();
        field = serializedObject.FindProperty("volumetricFog");
        EditorGUILayout.PropertyField(field, new GUIContent("体积雾"));

        EditorGUILayout.Space();
        field = serializedObject.FindProperty("vignette");
        EditorGUILayout.PropertyField(field, new GUIContent("晕映"));

        EditorGUILayout.Space();
        field = serializedObject.FindProperty("border");
        EditorGUILayout.PropertyField(field, new GUIContent("边缘效果"));

        EditorGUILayout.Space();
        field = serializedObject.FindProperty("radialBlur");
        EditorGUILayout.PropertyField(field, new GUIContent("径向模糊"));

        EditorGUILayout.Space();
        field = serializedObject.FindProperty("cloudShadow");
        EditorGUILayout.PropertyField(field, new GUIContent("云投影"));    


        EditorGUILayout.Space();
        field = serializedObject.FindProperty("chromaticAberration");
        EditorGUILayout.PropertyField(field, new GUIContent("色彩偏移"));


        if (Application.isPlaying)
        {
            EnvironmentManager envManager = GameObject.FindObjectOfType<EnvironmentManager>();
            if (envManager)
            {
                envManager.EnvironmentObjectToUnity(envManager.curEnv);
            }
        }
       

        serializedObject.ApplyModifiedProperties();
    }
}


