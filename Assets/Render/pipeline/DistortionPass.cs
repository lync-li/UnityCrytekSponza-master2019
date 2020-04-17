using UnityEngine;
using UnityEngine.Rendering;
using System.Collections;
using System.Collections.Generic;
using System;
using System.IO;
using UnityEngine.Events;

#if UNITY_EDITOR
using UnityEditor;
#endif 
#if UNITY_2018_3_OR_NEWER
[ExecuteAlways]
#else
    [ExecuteInEditMode]
#endif
[RequireComponent(typeof(Camera)),DisallowMultipleComponent]
[ExecuteAfter(typeof(AlphaPass))]
public class DistortionPass: MonoBehaviour {

    public RenderTexture distortionRT;
    private CommandBuffer distortionCB;
    private bool initDistortionCB = false;
    private Camera cam;

    private void Awake()
    {
        cam = GetComponent<Camera>();
        InitDistortionBuffer();    
    }

    void OnDisable()
    {
        ClearCommandBuffer(ref distortionCB, CameraEvent.BeforeForwardOpaque);
    }

    public void CleanRT()
    {
        CommonSet.DeleteRenderTexture(ref distortionRT);
    }

    private void OnDestroy()
    {
       // CommonSet.DeleteRenderTexture(ref alphaRT);
    }

    public void InitDistortionBuffer()
    {
        initDistortionCB = true;

        if (distortionCB == null)
        {
            distortionCB = new CommandBuffer();
            distortionCB.name = "DistortionPass";
        }
        //else
        //{
        //    ClearCommandBuffer(ref alphaCB, CameraEvent.AfterImageEffects);
        //}
    }

    void ClearCommandBuffer(ref CommandBuffer buffer, CameraEvent camEvent)
    {
        if (buffer != null)
        {
            cam.RemoveCommandBuffer(camEvent, buffer);
            buffer.Clear();
        }
    }

    public void UpdateDistortion(bool enable)
    {
        cam = GetComponent<Camera>();

        if(enable)
        {
            InitDistortionBuffer();
            cam.enabled = true;
            RefreshDistortionRT();
        }
        else
        {
            ClearCommandBuffer(ref distortionCB, CameraEvent.BeforeForwardOpaque);
            cam.targetTexture = null;
            cam.enabled = false;
            CommonSet.DeleteRenderTexture(ref distortionRT);
        }      
    }

    void UpdateDistortionCommandBuffer()
    {
        if (cam == null || distortionCB == null)
        {
            return;
        }
        else if (initDistortionCB)
        {
            ClearCommandBuffer(ref distortionCB, CameraEvent.BeforeForwardOpaque);
            cam.AddCommandBuffer(CameraEvent.BeforeForwardOpaque, distortionCB);
            PrepareDistortionCB(distortionCB);

            initDistortionCB = false;
        }
    }

    void RefreshDistortionRT()
    {
        int width = EnvironmentManager.Instance.GetDistortionRTWidth();
        int height = EnvironmentManager.Instance.GetDistortionRTHeight();
        if (distortionRT)
        {
            if (width != distortionRT.width || height != distortionRT.height)
            {
                cam.targetTexture = null;
                CommonSet.DeleteRenderTexture(ref distortionRT);
            }
        }
        if (!distortionRT && EnvironmentManager.Instance.isSupportDepthTex)
        {
            distortionRT = new RenderTexture(width, height, 24, RenderTextureFormat.ARGB32, RenderTextureReadWrite.Linear);
            distortionRT.autoGenerateMips = false;
        }
    }

    void PrepareDistortionCB(CommandBuffer cb)
    {
        cb.BeginSample("Distortion");
        if (distortionRT)
        {
            cb.ClearRenderTarget(true, true, new Color(0, 0, 0, 0));
            cb.SetGlobalTexture(CommonSet.ShaderProperties.cameraDepthTex, EnvironmentManager.Instance.pp.depthCopy.colorBuffer);        
        }
        cb.EndSample("Distortion");
    }

    public void OnPreRender()
    {
        RefreshDistortionRT();
        if (distortionRT)
        {
            cam.SetTargetBuffers(distortionRT.colorBuffer, distortionRT.depthBuffer);            
        }

#if UNITY_EDITOR
        InitDistortionBuffer();
#endif
        UpdateDistortionCommandBuffer();
    }
}
