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
[RequireComponent(typeof(Camera)), DisallowMultipleComponent]
public class SimplePostProcess: DragonPostProcessBase {
    //opaque
    private CommandBuffer simpleCB;
    private bool initSimpleCB = false;

    public bool forceUpdate = true;
    public bool initLut = true;

    private RenderTexture rt;

    void OnDisable()
    {
        CommonSet.ClearCommandBuffer(cam,ref simpleCB, CameraEvent.BeforeImageEffects);
    }

    void InitSimpleBuffer()
    {
        initSimpleCB = true;

        if (simpleCB == null)
        {
            simpleCB = new CommandBuffer();
            simpleCB.name = "Simple";
        }
        //else
        //{
        //    CommonSet.ClearCommandBuffer(cam,ref opaqueCB, CameraEvent.AfterForwardOpaque);
        //}
    }

    public override void UpdatePostProcess()
    {
        if(GetDirty() || forceUpdate)
        {
            cam.depthTextureMode = DepthTextureMode.None;
            if (mProperty.ambientOcclusion)
                cam.depthTextureMode = DepthTextureMode.DepthNormals;

            mProperty.alphaBuffer = false;
            mProperty.playerLayer = false;
            mProperty.volumetricFog = false;
            mProperty.lumaOcclusion = false;
            mProperty.ambientOcclusion = false;
            mProperty.border = false;
            mProperty.radialBlur = false;
            mProperty.cloudShadow = false;
            mProperty.depthOfField = false;
            mProperty.dofFast = false;

            rt = cam.targetTexture;

            base.UpdatePostProcess();
            InitSimpleBuffer();

            SetNoDirty();
            forceUpdate = false;
        }           
    }

    public void OnPreRender()
    {
#if UNITY_EDITOR
        initLut = true;
#endif
        UpdateSimpleCommandBuffer();

#if UNITY_EDITOR    
        //为了解决editor刷新问题
        if (!mMaterialBloom.HasProperty(CommonSet.ShaderProperties.bloomIntensity))
        {
            forceUpdate = true;
        }            
#endif
        UpdatePostProcess();
    }

    void UpdateSimpleCommandBuffer()
    {
        if (cam == null || simpleCB == null)
            return;
        else if (initSimpleCB)
        {
            CommonSet.ClearCommandBuffer(cam,ref simpleCB, CameraEvent.BeforeImageEffects);
            cam.AddCommandBuffer(CameraEvent.BeforeImageEffects, simpleCB);
            PrepareSimpleCB(simpleCB);

            initSimpleCB = false;
        }
    }

    void PrepareSimpleCB(CommandBuffer cb)
    {
        if (initLut)
        {
            GetLutTex(cb);
            forceUpdate = true;
            initLut = false;
        }

        RenderTextureFormat copyFormat = CommonSet.SelectFormat(RenderTextureFormat.ARGBHalf, RenderTextureFormat.ARGB32);
        RenderTargetIdentifier _SimpleCopyId = new RenderTargetIdentifier(CommonSet.ShaderProperties.simpleCopyTex); 
        if (rt)
        {           
            cb.GetTemporaryRT(CommonSet.ShaderProperties.simpleCopyTex, rt.width, rt.height, 0, FilterMode.Bilinear, copyFormat, RenderTextureReadWrite.Linear);
            RenderTargetIdentifier _RenderTexId = new RenderTargetIdentifier(rt);
            cb.Blit(_RenderTexId, _SimpleCopyId);
            if (SceneBloomEnable())
            {
                PrepareBloom(cb, _SimpleCopyId, rt.width,rt.height);
            }
            cb.Blit(_SimpleCopyId, BuiltinRenderTextureType.CameraTarget, uberMaterial, (int)DragonPostProcess.MainPass.Simple);
        }
        else
        {
            cb.GetTemporaryRT(CommonSet.ShaderProperties.simpleCopyTex, cam.pixelWidth, cam.pixelHeight, 0, FilterMode.Bilinear, copyFormat, RenderTextureReadWrite.Linear);
            cb.Blit(BuiltinRenderTextureType.CameraTarget, _SimpleCopyId);
            if (SceneBloomEnable())
            {
                PrepareBloom(cb, _SimpleCopyId, cam.pixelWidth, cam.pixelHeight);
            }
            cb.Blit(_SimpleCopyId, BuiltinRenderTextureType.CameraTarget, uberMaterial, (int)DragonPostProcess.MainPass.Simple);
        }                    
        
        cb.ReleaseTemporaryRT(CommonSet.ShaderProperties.simpleCopyTex);

        if (SceneBloomEnable())
            FinishBloom(cb, CommonSet.ShaderProperties.bloomTex);      
    }

    public void PrepareBloom(CommandBuffer cb, RenderTargetIdentifier rt,int width,int height)
    {
        int dw = width / 2;
        int dh = height / 2;

        RenderTargetIdentifier _BloomThresholdTexId = new RenderTargetIdentifier(CommonSet.ShaderProperties.bloomThresholdTex);
        cb.GetTemporaryRT(CommonSet.ShaderProperties.bloomThresholdTex, dw, dh, 0, FilterMode.Bilinear, hdrFormat, RenderTextureReadWrite.Linear);

        cb.Blit(rt, _BloomThresholdTexId, mMaterialBloom, (int)bloomPass.BloomThreshold);

        float ratio = Mathf.Clamp(mProperty.bloom.bloomAnamorphicRatio, -1, 1);
        float rw = ratio < 0 ? -ratio : 0f;
        float rh = ratio > 0 ? ratio : 0f;
        int rtWidth = Mathf.FloorToInt(width / (2f - rw)) / 2;
        int rtHeight = Mathf.FloorToInt(height / (2f - rh)) / 2;

        //int rtWidth = source.width / 4;
        //int rtHeight = source.height / 4;

        RenderTargetIdentifier _BloomDownSampleTexId = new RenderTargetIdentifier(CommonSet.ShaderProperties.bloomDownSampleTex);
        cb.GetTemporaryRT(CommonSet.ShaderProperties.bloomDownSampleTex, rtWidth, rtHeight, 0, FilterMode.Bilinear, hdrFormat, RenderTextureReadWrite.Linear);
        cb.Blit(_BloomThresholdTexId, _BloomDownSampleTexId, mMaterialDownSample, (int)DownSample.DownSample);
        cb.ReleaseTemporaryRT(CommonSet.ShaderProperties.bloomThresholdTex);

        int s = Mathf.Max(rtWidth, rtHeight);
        float h = Mathf.Log(s, 2) - 8;
        float iteration = h + mProperty.bloom.bloomRadius;
        float fBloomIteration = Math.Max(iteration, 0);

        RenderTargetIdentifier lastTex = _BloomDownSampleTexId;

        int bloomIteration = (int)fBloomIteration;
        bloomIteration = Mathf.Max(1, bloomIteration);

        for (int i = 0; i < bloomIteration; i++)
        {
            rtWidth = rtWidth / 2;
            rtHeight = rtHeight / 2;

            RenderTargetIdentifier identifier = new RenderTargetIdentifier(CommonSet.ShaderProperties.blurTexArray1[i]);
            cb.GetTemporaryRT(CommonSet.ShaderProperties.blurTexArray1[i], rtWidth, rtHeight, 0, FilterMode.Bilinear, hdrFormat, RenderTextureReadWrite.Linear);
            cb.Blit(lastTex, identifier, mMaterialDownSample, (int)DownSample.DownSample);
            bloomParam.blurBuffer1[i] = CommonSet.ShaderProperties.blurTexArray1[i];
            lastTex = identifier;
        }

        mMaterialBloom.SetFloat(CommonSet.ShaderProperties.bloomScale, 0.5f + fBloomIteration - bloomIteration);

        for (int i = bloomIteration - 2; i >= 0; i--)
        {
            rtWidth = rtWidth * 2;
            rtHeight = rtHeight * 2;

            RenderTargetIdentifier identifier = new RenderTargetIdentifier(CommonSet.ShaderProperties.blurTexArray2[i]);
            cb.GetTemporaryRT(CommonSet.ShaderProperties.blurTexArray2[i], rtWidth, rtHeight, 0, FilterMode.Bilinear, hdrFormat, RenderTextureReadWrite.Linear);
            cb.SetGlobalTexture(CommonSet.ShaderProperties.bloomBlurTex, lastTex);
            cb.Blit(bloomParam.blurBuffer1[i], identifier, mMaterialBloom, (int)bloomPass.BloomUpSample);
            bloomParam.blurBuffer2[i] = CommonSet.ShaderProperties.blurTexArray2[i];
            lastTex = identifier;
        }

        RenderTargetIdentifier _BloomTexId = new RenderTargetIdentifier(CommonSet.ShaderProperties.bloomTex);

        if (lastTex != _BloomDownSampleTexId)
        {
            rtWidth = rtWidth * 2;
            rtHeight = rtHeight * 2;

            cb.GetTemporaryRT(CommonSet.ShaderProperties.bloomTex, rtWidth, rtHeight, 0, FilterMode.Bilinear, hdrFormat, RenderTextureReadWrite.Linear);
            cb.SetGlobalTexture(CommonSet.ShaderProperties.bloomBlurTex, lastTex);            
            cb.Blit(_BloomDownSampleTexId, _BloomTexId, mMaterialBloom, (int)bloomPass.BloomUpSample);
            cb.ReleaseTemporaryRT(CommonSet.ShaderProperties.bloomDownSampleTex);
        }

        for (int i = 0; i < BloomParam.maxIterations; i++)
        {
            if (bloomParam.blurBuffer1[i] != 0) cb.ReleaseTemporaryRT(CommonSet.ShaderProperties.blurTexArray1[i]);
            if (bloomParam.blurBuffer2[i] != 0) cb.ReleaseTemporaryRT(CommonSet.ShaderProperties.blurTexArray2[i]);
            bloomParam.blurBuffer1[i] = 0;
            bloomParam.blurBuffer2[i] = 0;
        }

        cb.SetGlobalTexture(CommonSet.ShaderProperties.bloomTex, _BloomTexId);
    }  

    public void FinishBloom(CommandBuffer cb,int bloomTexID)
    {
        cb.ReleaseTemporaryRT(bloomTexID);
    }   
}
