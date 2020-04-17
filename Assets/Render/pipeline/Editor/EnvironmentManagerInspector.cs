using UnityEngine;
using UnityEngine.Rendering;
using UnityEditor;
using System.Collections;
using System.Collections.Generic;

[ExecuteInEditMode]
[CustomEditor(typeof(EnvironmentManager),true)]
public class EnvironmentManagerInspector : Editor
{
    public override void OnInspectorGUI()
    {
        EnvironmentManager manager = serializedObject.targetObject as EnvironmentManager;
        manager.UpdateEnviornmentObjects();

        int count = manager.envObjects.Length;

        if (count > 0)
        {
            EditorGUILayout.Space();
            EditorGUILayout.Space();

            EditorGUILayout.BeginHorizontal();      

            EnvironmentObject[] envObjects = new EnvironmentObject[count];
            string[] names = new string[count];

            int curIndex = 0;

            for ( int i = 0;i<count;i++) 
            {
                envObjects[i] = manager.envObjects[i];
                names[i] = envObjects[i].gameObject.name;

                if (manager.GetCurEnv() == manager.envObjects[i])
                    curIndex = i;
            }

            curIndex = EditorGUILayout.Popup("选择环境    Choose", curIndex, names);

            manager.ChooseEnviornment(manager.envObjects[curIndex],false);

            EditorGUILayout.EndVertical();

            EditorGUILayout.Space();
            EditorGUILayout.Space();

        }
        else
        {
            GUIStyle helpStyle = new GUIStyle(EditorStyles.helpBox);  // 这里我用EditorStyles的centeredGreyMiniLabel来初始化我的新风格
            helpStyle.fontStyle = FontStyle.Bold;                       // 新Style的字体为粗体
            helpStyle.fontSize = 13;
            helpStyle.normal.textColor = Color.red;

            EditorGUILayout.LabelField("\n\n      环境管理器的子节点不包含环境节点", helpStyle, new GUILayoutOption[] { GUILayout.Height(80) });
        }

        EditorGUILayout.Space();
        EditorGUILayout.Space();

        EditorGUILayout.BeginHorizontal();

        if (GUILayout.Button("添加默认环境", GUILayout.Width(100), GUILayout.Height(30)))
        {
            manager.CreateEnviornment(false);
        }

        if (GUILayout.Button("添加环境并读取当前Unity参数", GUILayout.Width(200), GUILayout.Height(30)))
        {
            manager.CreateEnviornment(true);
        }

        EditorGUILayout.EndHorizontal();

        EditorGUILayout.Space();
        EditorGUILayout.Space();       

        EditorGUILayout.Space();
        SerializedProperty field = serializedObject.FindProperty("isLandscaped");
        EditorGUILayout.PropertyField(field, new GUIContent("横屏"));

        //bool bValue = EditorGUILayout.Toggle("动态分辨率", manager.dynamicResolution, GUILayout.Height(30));
        //if(bValue != manager.dynamicResolution)
        //{
        //    manager.dynamicResolution = bValue;
        //    manager.UpdateComponent();
        //}

        //bValue = EditorGUILayout.Toggle("横屏", manager.isLandscaped, GUILayout.Height(30));
        //if (bValue != manager.isLandscaped)
        //{
        //    manager.isLandscaped = bValue;
        //    manager.UpdateComponent();
        //}      

        // manager.displayFPS = EditorGUILayout.Toggle("显示帧率", manager.displayFPS, GUILayout.Height(30));
      //  manager.UpdateComponent();
      //  manager.UpdateResolution(manager.defaultLevel);
       // manager.UpdateResolution(manager.defaultLevel);
        
        serializedObject.ApplyModifiedProperties();
    }
}


