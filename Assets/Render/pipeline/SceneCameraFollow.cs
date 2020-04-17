using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

#if UNITY_2018_3_OR_NEWER
[ExecuteAlways]
#else
    [ExecuteInEditMode]
#endif
public class SceneCameraFollow : MonoBehaviour
{
    public GameObject followObject;

    public bool defaultPosition;
    public Vector3 position;
    public Vector3 rotation;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
#if UNITY_EDITOR
        if (!Application.isPlaying && followObject)
        {
            if(defaultPosition)
            {
                followObject.transform.position = position;
                followObject.transform.eulerAngles = rotation;
            }
            else
            {
                if(SceneView.lastActiveSceneView && SceneView.lastActiveSceneView.camera)
                {
                    followObject.transform.position = SceneView.lastActiveSceneView.camera.transform.position;
                    followObject.transform.rotation = SceneView.lastActiveSceneView.camera.transform.rotation;
                }               
            }            
        }
#endif
    }
}
