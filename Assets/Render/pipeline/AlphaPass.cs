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
[ExecuteAfter(typeof(DragonPostProcess))]
public class AlphaPass: MonoBehaviour {

    public RenderTexture alphaRT;
    public Shader nullShader;

    private Material nullMaterial;
    private CommandBuffer alphaCB;
    private bool initAlphaCB = false;
    private Camera cam;
    private Camera mainCam;

    private void Awake()
    {
        cam = GetComponent<Camera>();
        mainCam = Camera.main;
        InitAlphaBuffer();
        nullMaterial = new Material(nullShader);
    }

    void OnDisable()
    {
        ClearCommandBuffer(ref alphaCB, CameraEvent.BeforeForwardOpaque);
    }

    public void CleanRT()
    {
        CommonSet.DeleteRenderTexture(ref alphaRT);
    }

    private void OnDestroy()
    {
       // CommonSet.DeleteRenderTexture(ref alphaRT);
    }

    public void InitAlphaBuffer()
    {
        initAlphaCB = true;

        if (alphaCB == null)
        {
            alphaCB = new CommandBuffer();
            alphaCB.name = "AlphaPass";
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

    public void UpdateAlpha(bool enable)
    {
        cam = GetComponent<Camera>();

        if(enable)
        {
            InitAlphaBuffer();
            cam.enabled = true;
            RefreshAlphaRT();
        }
        else
        {
            ClearCommandBuffer(ref alphaCB, CameraEvent.BeforeForwardOpaque);
            cam.targetTexture = null;
            cam.enabled = false;
            CommonSet.DeleteRenderTexture(ref alphaRT);
        }      
    }

    void UpdateAlphaCommandBuffer()
    {
        if (cam == null || alphaCB == null)
        {
            return;
        }
        else if (initAlphaCB)
        {
            ClearCommandBuffer(ref alphaCB, CameraEvent.BeforeForwardOpaque);
            cam.AddCommandBuffer(CameraEvent.BeforeForwardOpaque, alphaCB);
            PrepareAlphaCB(alphaCB);

            initAlphaCB = false;
        }
    }

    void RefreshAlphaRT()
    {
        int width = EnvironmentManager.Instance.GetCurrentRTWidth();
        int height = EnvironmentManager.Instance.GetCurrentRTHeight();
        if (alphaRT)
        {
            if (width != alphaRT.width || height != alphaRT.height || alphaRT.format != EnvironmentManager.Instance.halfFormat)
            {
                cam.targetTexture = null;
                CommonSet.DeleteRenderTexture(ref alphaRT);
            }
        }
        if (!alphaRT && EnvironmentManager.Instance.isSupportDepthTex)
        {
            alphaRT = new RenderTexture(width, height, 24, EnvironmentManager.Instance.halfFormat, RenderTextureReadWrite.Linear);
            alphaRT.autoGenerateMips = false;
        }
    }

    void PrepareAlphaCB(CommandBuffer cb)
    {
        cb.BeginSample("AlphaBuffer");
        if (alphaRT)
        {
            if (alphaRT.width == EnvironmentManager.Instance.pp.colorRT.width && alphaRT.height == EnvironmentManager.Instance.pp.colorRT.height)
                cb.ClearRenderTarget(false, true, new Color(0, 0, 0, 1));
            else
                cb.ClearRenderTarget(true, true, new Color(0, 0, 0, 1));
            cb.SetGlobalTexture(CommonSet.ShaderProperties.cameraDepthTex, EnvironmentManager.Instance.pp.depthCopy.colorBuffer);
            if (nullMaterial == null)
                nullMaterial = new Material(nullShader);
            cb.DrawMesh(CommonSet.smallscreenTriangle, Matrix4x4.identity, nullMaterial, 0);
        }
        cb.EndSample("AlphaBuffer");
    }

    public void OnPreRender()
    {
        if(cam.nearClipPlane != mainCam.nearClipPlane || cam.farClipPlane != mainCam.farClipPlane || cam.fieldOfView != mainCam.fieldOfView)
        {
            cam.nearClipPlane = mainCam.nearClipPlane;
            cam.farClipPlane = mainCam.farClipPlane;
            cam.fieldOfView = mainCam.fieldOfView;
        }
        RefreshAlphaRT();
        if (alphaRT)
        {
            if (alphaRT.width == EnvironmentManager.Instance.pp.colorRT.width && alphaRT.height == EnvironmentManager.Instance.pp.colorRT.height)
                cam.SetTargetBuffers(alphaRT.colorBuffer, EnvironmentManager.Instance.pp.depthRT.depthBuffer);
            else
                cam.SetTargetBuffers(alphaRT.colorBuffer, alphaRT.depthBuffer);            
        }
        
#if UNITY_EDITOR
        InitAlphaBuffer();        
#endif
        UpdateAlphaCommandBuffer();
    }
}
