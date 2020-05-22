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
[ExecuteAfter(typeof(DistortionPass))]
public class UberPass: MonoBehaviour {
    private CommandBuffer uberCB;
    private bool initUberCB = false;
    private Camera cam;
    private Camera mainCam;

    private bool initLut = true;
    private void Awake()
    {
        cam = GetComponent<Camera>();
        mainCam = Camera.main;
        InitUberBuffer();
    }

    void OnDisable()
    {
        ClearCommandBuffer(ref uberCB, CameraEvent.BeforeImageEffects);
    }

    public void InitUberBuffer()
    {
        initLut = true;

        initUberCB = true;

        if (uberCB == null)
        {
            uberCB = new CommandBuffer();
            uberCB.name = "blit_uber";
        }
        //else
        //{
        //    ClearCommandBuffer(ref uberCB, CameraEvent.BeforeImageEffects);
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

    public void UpdateUber()
    {
        cam = GetComponent<Camera>();
        InitUberBuffer();
    }

    void UpdateUberCommandBuffer()
    {
        if (cam == null || uberCB == null)
        {
            return;
        }
        else if (initUberCB)
        {
            ClearCommandBuffer(ref uberCB, CameraEvent.BeforeImageEffects);
            cam.AddCommandBuffer(CameraEvent.BeforeImageEffects, uberCB);
            PrepareUberCB(uberCB,EnvironmentManager.Instance.pp);

            initUberCB = false;
        }
    }

    void PrepareBokehDOF(CommandBuffer cb, DragonPostProcess pp,RenderTexture colorRT,RenderTexture alphaRT)
    { 
        int width = colorRT.width;
        int height = colorRT.height;
        float aspect = (float)width / height;
        float radiusInPixels = (float)pp.mProperty.kernelSize * 8f + 6f;
        float maxCoC = Mathf.Min(0.05f, radiusInPixels / colorRT.height);
        pp.depthOfFieldParams.z = maxCoC;
        pp.depthOfFieldParams.w = 1.0f / aspect;

        pp.mMaterialDOF.SetVector(CommonSet.ShaderProperties.depthOfFieldParams, pp.depthOfFieldParams);

        // CoC calculation pass
        cb.GetTemporaryRT(CommonSet.ShaderProperties.cocTex, width, height, 0, FilterMode.Bilinear, pp.cocFormat, RenderTextureReadWrite.Linear);
        var cocTexID = new RenderTargetIdentifier(CommonSet.ShaderProperties.cocTex);
        cb.Blit(null, cocTexID, pp.mMaterialDOF, (int)DragonPostProcess.FastDOFPass.COC);
        cb.SetGlobalTexture(CommonSet.ShaderProperties.cocTex, cocTexID);

        int dw = width / 2;
        int dh = height / 2;
        // Downsampling and prefiltering pass
        cb.GetTemporaryRT(CommonSet.ShaderProperties.depthOfFieldTex, dw, dh, 0, FilterMode.Bilinear, RenderTextureFormat.ARGBHalf, RenderTextureReadWrite.Linear);
        var depthOfFieldTexID = new RenderTargetIdentifier(CommonSet.ShaderProperties.depthOfFieldTex);
        cb.GetTemporaryRT(CommonSet.ShaderProperties.sceneWithAlphaTex, dw / 2, dh / 2, 0, FilterMode.Bilinear, RenderTextureFormat.ARGBHalf, RenderTextureReadWrite.Linear);
        var sceneWithAlphaTexID = new RenderTargetIdentifier(CommonSet.ShaderProperties.sceneWithAlphaTex);

        int dofMainPass = (int)DragonPostProcess.MainPass.ForDOF;
            if (alphaRT && pp.AlphaBufferEnable())
        {
                if (pp.PlayerLayerEnable())
                dofMainPass = (int)DragonPostProcess.MainPass.ForDOFWithAlphaPlayer;
            else
                dofMainPass = (int)DragonPostProcess.MainPass.ForDOFWithAlphaBuffer;
        }
        else
        {
                if (pp.PlayerLayerEnable())
                dofMainPass = (int)DragonPostProcess.MainPass.ForDOFWithPlayer;
            else
                dofMainPass = (int)DragonPostProcess.MainPass.ForDOF;
        }
        cb.Blit(colorRT, sceneWithAlphaTexID, pp.uberMaterial, dofMainPass);

        cb.Blit(sceneWithAlphaTexID, depthOfFieldTexID, pp.mMaterialDOF, (int)DragonPostProcess.BokehDOFPass.DownSampleAndFilter);
        cb.ReleaseTemporaryRT(CommonSet.ShaderProperties.sceneWithAlphaTex);

        // Bokeh simulation pass
        cb.GetTemporaryRT(CommonSet.ShaderProperties.dofTempTex, dw, dh, 0, FilterMode.Bilinear, RenderTextureFormat.ARGBHalf, RenderTextureReadWrite.Linear);
        var dofTempTexID = new RenderTargetIdentifier(CommonSet.ShaderProperties.dofTempTex);
        cb.Blit(depthOfFieldTexID, dofTempTexID, pp.mMaterialDOF, (int)DragonPostProcess.BokehDOFPass.FilterSmall + pp.mProperty.kernelSize);
        cb.ReleaseTemporaryRT(CommonSet.ShaderProperties.depthOfFieldTex);
        cb.GetTemporaryRT(CommonSet.ShaderProperties.depthOfFieldTex, dw, dh, 0, FilterMode.Bilinear, RenderTextureFormat.ARGBHalf, RenderTextureReadWrite.Linear);
        depthOfFieldTexID = new RenderTargetIdentifier(CommonSet.ShaderProperties.depthOfFieldTex);
        cb.Blit(dofTempTexID, depthOfFieldTexID, pp.mMaterialDOF, (int)DragonPostProcess.BokehDOFPass.PostFilter);

        // Give the results to the uber shader.
        pp.uberMaterial.SetVector(CommonSet.ShaderProperties.depthOfFieldParams, pp.depthOfFieldParams);
        cb.SetGlobalTexture(CommonSet.ShaderProperties.depthOfFieldTex, depthOfFieldTexID);
    }

    void FinishBokehDOF(CommandBuffer cb)
    {
        cb.ReleaseTemporaryRT(CommonSet.ShaderProperties.depthOfFieldTex);
        cb.ReleaseTemporaryRT(CommonSet.ShaderProperties.cocTex);
    }

    void PrepareFastDOF(CommandBuffer cb, DragonPostProcess pp, RenderTexture colorRT, RenderTexture alphaRT)
    {
        int width = colorRT.width;
        int height = colorRT.height;

        float aspect = Mathf.Min(width, height) / 1080f;

        pp.depthOfFieldParams.z = Mathf.Min(pp.mProperty.dofRadius * aspect, 2.5f);

        pp.mMaterialDOF.SetVector(CommonSet.ShaderProperties.depthOfFieldParams, pp.depthOfFieldParams);

        // CoC calculation pass
        cb.GetTemporaryRT(CommonSet.ShaderProperties.cocTex, width, height, 0, FilterMode.Bilinear, pp.cocFormat, RenderTextureReadWrite.Linear);
        var cocTexID = new RenderTargetIdentifier(CommonSet.ShaderProperties.cocTex);
        cb.Blit(null, cocTexID, pp.mMaterialDOF, (int)DragonPostProcess.FastDOFPass.COC);
        cb.SetGlobalTexture(CommonSet.ShaderProperties.cocTex, cocTexID);

        int dw = width / 2;
        int dh = height / 2;
        // Downsampling and prefiltering pass
        cb.GetTemporaryRT(CommonSet.ShaderProperties.depthOfFieldTex, dw, dh, 0, FilterMode.Bilinear, RenderTextureFormat.ARGBHalf, RenderTextureReadWrite.Linear);
        var depthOfFieldTexID = new RenderTargetIdentifier(CommonSet.ShaderProperties.depthOfFieldTex);
        cb.GetTemporaryRT(CommonSet.ShaderProperties.sceneWithAlphaTex, dw / 2, dh / 2, 0, FilterMode.Bilinear, RenderTextureFormat.ARGBHalf, RenderTextureReadWrite.Linear);
        var sceneWithAlphaTexID = new RenderTargetIdentifier(CommonSet.ShaderProperties.sceneWithAlphaTex);

        int dofMainPass = (int)DragonPostProcess.MainPass.ForDOF;
        if (alphaRT && pp.mProperty.alphaBuffer)
        {
            if (pp.mProperty.playerLayer)
                dofMainPass = (int)DragonPostProcess.MainPass.ForDOFWithAlphaPlayer;
            else
                dofMainPass = (int)DragonPostProcess.MainPass.ForDOFWithAlphaBuffer;
        }
        else
        {
            if (pp.mProperty.playerLayer)
                dofMainPass = (int)DragonPostProcess.MainPass.ForDOFWithPlayer;
            else
                dofMainPass = (int)DragonPostProcess.MainPass.ForDOF;
        }
        cb.Blit(colorRT, sceneWithAlphaTexID, pp.uberMaterial, dofMainPass);

        cb.Blit(sceneWithAlphaTexID, depthOfFieldTexID, pp.mMaterialDOF, (int)DragonPostProcess.FastDOFPass.PreFilter);
        cb.ReleaseTemporaryRT(CommonSet.ShaderProperties.sceneWithAlphaTex);

        //blur pass
        cb.GetTemporaryRT(CommonSet.ShaderProperties.dofTempTex, dw, dh, 0, FilterMode.Bilinear, RenderTextureFormat.ARGB32, RenderTextureReadWrite.Linear);
        var dofTempTexID = new RenderTargetIdentifier(CommonSet.ShaderProperties.dofTempTex);
        cb.Blit(depthOfFieldTexID, dofTempTexID, pp.mMaterialDOF, (int)DragonPostProcess.FastDOFPass.FragBlurH);
        cb.ReleaseTemporaryRT(CommonSet.ShaderProperties.depthOfFieldTex);
        cb.GetTemporaryRT(CommonSet.ShaderProperties.depthOfFieldTex, dw, dh, 0, FilterMode.Bilinear, RenderTextureFormat.ARGB32, RenderTextureReadWrite.Linear);
        depthOfFieldTexID = new RenderTargetIdentifier(CommonSet.ShaderProperties.depthOfFieldTex);
        cb.Blit(dofTempTexID, depthOfFieldTexID, pp.mMaterialDOF, (int)DragonPostProcess.FastDOFPass.FragBlurV);

        // Give the results to the uber shader.
        pp.uberMaterial.SetVector(CommonSet.ShaderProperties.depthOfFieldParams, pp.depthOfFieldParams);
        cb.SetGlobalTexture(CommonSet.ShaderProperties.depthOfFieldTex, depthOfFieldTexID);
    }

    void FinishFastDOF(CommandBuffer cb)
    {
        cb.ReleaseTemporaryRT(CommonSet.ShaderProperties.depthOfFieldTex);
        cb.ReleaseTemporaryRT(CommonSet.ShaderProperties.cocTex);
    }

    void PrepareUberCB(CommandBuffer cb,DragonPostProcess pp)
    {
        cb.BeginSample("UberPostProcess");
        RenderTexture colorRT = EnvironmentManager.Instance.pp.colorRT;
        RenderTexture alphaRT = EnvironmentManager.Instance.alphaPass.alphaRT;
        RenderTexture distortionRT = EnvironmentManager.Instance.distortionPass.distortionRT;

        if (alphaRT)
            cb.SetGlobalTexture(CommonSet.ShaderProperties.alphaTex, alphaRT);

        if (distortionRT)
            cb.SetGlobalTexture(CommonSet.ShaderProperties.distortionTex, distortionRT);

        if (initLut)
        {
            pp.GetLutTex(cb);
            pp.forceUpdate = true;
            initLut = false;
        }            
                      
        if(pp.SceneBloomEnable())
        {              
            pp.PrepareBloom(cb, colorRT, pp.mMaterialBloom, pp.mProperty.bloom.bloomRadius,CommonSet.ShaderProperties.bloomTex,false,pp.mProperty.bloom.bloomAnamorphicRatio);
        }           
        if(pp.PlayerBloomEnable())
        {            
            pp.PrepareBloom(cb, colorRT, pp.mMaterialPlayerBloom, pp.mProperty.playerBloom.bloomRadius,CommonSet.ShaderProperties.playerBloomTex,pp.PlayerColorLookupEnable(), pp.mProperty.playerBloom.bloomAnamorphicRatio);           
        }
        if (pp.AlphaBloomEnable() && alphaRT)
        {           
            pp.PrepareBloom(cb, alphaRT, pp.mMaterialAlphaBloom, pp.mProperty.alphaBloom.bloomRadius ,CommonSet.ShaderProperties.alphaBloomTex,false, pp.mProperty.alphaBloom.bloomAnamorphicRatio);
        }

        if (pp.DofFastEnable())
            PrepareFastDOF(cb,pp, colorRT,alphaRT);

        bool radial = pp.RadialBlurEnable() && pp.mProperty.radialAmount > 0;

        int mainPass = (int)DragonPostProcess.MainPass.Main;
        if(alphaRT && pp.AlphaBufferEnable())
        {
            if (pp.PlayerLayerEnable())
                mainPass = (int)DragonPostProcess.MainPass.WithAlphaPlayer;
            else
                mainPass = (int)DragonPostProcess.MainPass.WithAlphaBuffer;
        }
        else
        {
            if (pp.PlayerLayerEnable())
                mainPass = (int)DragonPostProcess.MainPass.WithPlayer;
            else
                mainPass = (int)DragonPostProcess.MainPass.Main;
        }

        bool aaEnable = pp.AntialiasingEnable();
        //FXAA radial
        if (radial || aaEnable)
        {
            cb.GetTemporaryRT(CommonSet.ShaderProperties.uberTex, colorRT.width, colorRT.height, 0, FilterMode.Bilinear, RenderTextureFormat.ARGB32, RenderTextureReadWrite.Linear);
            var uberTexId = new RenderTargetIdentifier(CommonSet.ShaderProperties.uberTex);

            cb.Blit(colorRT, uberTexId, pp.uberMaterial, mainPass);         
 
            if (radial)
            {
                if (aaEnable)
                {
                    cb.GetTemporaryRT(CommonSet.ShaderProperties.rBlurTex, colorRT.width, colorRT.height, 0, FilterMode.Bilinear, RenderTextureFormat.ARGB32, RenderTextureReadWrite.Linear);
                    var rBlurTexID = new RenderTargetIdentifier(CommonSet.ShaderProperties.rBlurTex);

                    cb.Blit(uberTexId, rBlurTexID, pp.mMaterialRadialBlur, 0);

                    uberTexId = rBlurTexID;
                }
                else
                    cb.Blit(uberTexId, BuiltinRenderTextureType.CameraTarget, pp.mMaterialRadialBlur, 0);
            }

            if (aaEnable)
                cb.Blit(uberTexId, BuiltinRenderTextureType.CameraTarget, pp.mMaterialFXAA, (int)DragonPostProcess.FinalPass.AA);
                       
            if(radial && aaEnable)
                cb.ReleaseTemporaryRT(CommonSet.ShaderProperties.rBlurTex);

            cb.ReleaseTemporaryRT(CommonSet.ShaderProperties.uberTex);
        }
        else
        {
            cb.Blit(colorRT, BuiltinRenderTextureType.CameraTarget, pp.uberMaterial, mainPass);           
        }

        if (pp.SceneBloomEnable())            
            pp.FinishBloom(cb, CommonSet.ShaderProperties.bloomTex);
        if (pp.PlayerBloomEnable())
            pp.FinishBloom(cb, CommonSet.ShaderProperties.playerBloomTex);        
        if (pp.AlphaBloomEnable() && alphaRT)
        {
            pp.FinishBloom(cb, CommonSet.ShaderProperties.alphaBloomTex);
        }

        if (pp.DofFastEnable())
            FinishFastDOF(cb);

        cb.EndSample("UberPostProcess");
    }

    public void OnPreRender()
    {
        if (cam.nearClipPlane != mainCam.nearClipPlane || cam.farClipPlane != mainCam.farClipPlane || cam.fieldOfView != mainCam.fieldOfView)
        {
            cam.nearClipPlane = mainCam.nearClipPlane;
            cam.farClipPlane = mainCam.farClipPlane;
            cam.fieldOfView = mainCam.fieldOfView;
        }
#if UNITY_EDITOR
        if(!EnvironmentManager.Instance.editorDebug)
            InitUberBuffer();
#endif
        UpdateUberCommandBuffer();
    }
}
