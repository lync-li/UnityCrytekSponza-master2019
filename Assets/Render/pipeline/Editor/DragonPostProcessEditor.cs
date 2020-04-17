using UnityEngine;
using System.Collections.Generic;
using UnityEditor;
using System.Reflection;
using System.Linq;
using System.IO;

[CustomEditor(typeof(DragonPostProcess))]
class DragonPostProcesEditor : Editor
{    
    public override void OnInspectorGUI () 
    {       
        serializedObject.Update();

        SerializedProperty field = serializedObject.FindProperty("radialAmount");
        EditorGUILayout.PropertyField(field, new GUIContent("径向模糊范围"));

        field = serializedObject.FindProperty("radialStrength");
        EditorGUILayout.PropertyField(field, new GUIContent("径向模糊强度"));

        EditorGUILayout.Space();
        EditorGUILayout.Space();

        field = serializedObject.FindProperty("chromaAmount");
        EditorGUILayout.PropertyField(field, new GUIContent("径向颜色偏移"));

        EditorGUILayout.Space();
        EditorGUILayout.Space();

        field = serializedObject.FindProperty("colorOffset");
        EditorGUILayout.PropertyField(field, new GUIContent("全屏颜色偏移"));
          
        serializedObject.ApplyModifiedProperties();
    }
}
