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
[ExecuteAfter(typeof(EnvironmentManager))]
public class DragonPostProcess : DragonPostProcessBase {
    //opaque
    private CommandBuffer opaqueCB;
    private bool initOpaqueCB = false;

    private int lumaTexNameId;

    public bool forceUpdate = true;

    public RenderTexture colorRT;
    public RenderTexture normalRT;
    public RenderTexture depthRT;
    public RenderTexture depthCopy;
    public RenderTexture depthBackUp;

    private RenderBuffer[] bufs = new RenderBuffer[2];

    void OnDisable()
    {
        CommonSet.ClearCommandBuffer(cam,ref opaqueCB, CameraEvent.BeforeForwardAlpha);
    }

    void OnDestroy()
    {
        Shader.DisableKeyword("_ALPHABUFFER");
    }

    public void CleanRT()
    {
        CommonSet.DeleteRenderTexture(ref colorRT);
        CommonSet.DeleteRenderTexture(ref normalRT);
        CommonSet.DeleteRenderTexture(ref depthRT);
        CommonSet.DeleteRenderTexture(ref depthCopy);
        CommonSet.DeleteRenderTexture(ref depthBackUp);
    }


#if UNITY_EDITOR
    [MenuItem("Tools/Disable AlphaBuffer")]
    static void CreateEnvironmentManager()
    {
        Shader.DisableKeyword("_ALPHABUFFER");
    }
#endif

    void InitOpaqueBuffer()
    {
        initOpaqueCB = true;

        if (opaqueCB == null)
        {
            opaqueCB = new CommandBuffer();
            opaqueCB.name = "Opaque";
        }
        //else
        //{
        //    CommonSet.ClearCommandBuffer(cam,ref opaqueCB, CameraEvent.BeforeForwardAlpha);
        //}
    }

    void RefreshRT()
    {
        int width = EnvironmentManager.Instance.GetCurrentRTWidth();
        int height = EnvironmentManager.Instance.GetCurrentRTHeight();

        if (colorRT)
        {
            if (width != colorRT.width || height != colorRT.height || colorRT.format != EnvironmentManager.Instance.halfFormat)
            {
                cam.targetTexture = null;
                CommonSet.DeleteRenderTexture(ref colorRT);
            }
        }
        if (!colorRT)
        {
            colorRT = new RenderTexture(width, height, EnvironmentManager.Instance.isSupportDepthTex ? 0 : 24, EnvironmentManager.Instance.halfFormat, RenderTextureReadWrite.Linear);
            colorRT.autoGenerateMips = false;
            forceUpdate = true;
        }

        if(NormalBufferEnable())
        {
            if (normalRT)
            {
                if (width != normalRT.width || height != normalRT.height)
                {
                    CommonSet.DeleteRenderTexture(ref normalRT);
                }
            }
            if (!normalRT)
            {
                normalRT = new RenderTexture(width, height,0, RenderTextureFormat.ARGB32, RenderTextureReadWrite.Linear);
                normalRT.autoGenerateMips = false;
            }

            bufs[0] = colorRT.colorBuffer;
            bufs[1] = normalRT.colorBuffer;
        }
        else
        {
            CommonSet.DeleteRenderTexture(ref normalRT);
        }

        if (!EnvironmentManager.Instance.isSupportDepthTex)
        {
            CommonSet.DeleteRenderTexture(ref depthRT);
            CommonSet.DeleteRenderTexture(ref depthCopy);
        }
        else
        {
            if (depthRT)
            {
                if (width != depthRT.width || height != depthRT.height)
                {
                    CommonSet.DeleteRenderTexture(ref depthRT);
                }
            }
            if (!depthRT)
            {
                depthRT = new RenderTexture(width, height, 24, RenderTextureFormat.Depth, RenderTextureReadWrite.Linear);
                depthRT.autoGenerateMips = false;
                forceUpdate = true;
            }
            if (depthCopy)
            {
                if (width != depthCopy.width || height != depthCopy.height)
                {
                    CommonSet.DeleteRenderTexture(ref depthCopy);
                }
            }
            if (!depthCopy)
            {
                RenderTextureFormat depthRawFormat = SystemInfo.SupportsRenderTextureFormat(RenderTextureFormat.RFloat) ? RenderTextureFormat.RFloat : RenderTextureFormat.RHalf;
                depthCopy = new RenderTexture(width, height, 0, depthRawFormat, RenderTextureReadWrite.Linear);
                depthCopy.filterMode = FilterMode.Point;
                depthCopy.useMipMap = true;
                depthCopy.autoGenerateMips = true;
                forceUpdate = true;
            }            
        }

        if (StochasticSSREnable())
        {
            if (depthBackUp)
            {
                if (width != depthBackUp.width || height != depthBackUp.height)
                {
                    CommonSet.DeleteRenderTexture(ref depthBackUp);
                }
            }
            if (!depthBackUp)
            {
                RenderTextureFormat depthRawFormat = SystemInfo.SupportsRenderTextureFormat(RenderTextureFormat.RFloat) ? RenderTextureFormat.RFloat : RenderTextureFormat.RHalf;
                depthBackUp = new RenderTexture(width, height, 0, depthRawFormat, RenderTextureReadWrite.Linear);
                depthBackUp.filterMode = FilterMode.Point;
                depthBackUp.useMipMap = true;
                depthBackUp.autoGenerateMips = false;
                forceUpdate = true;
            }
        }
        else
        {
            CommonSet.DeleteRenderTexture(ref depthBackUp);
        }
    }

    public override void UpdatePostProcess()
    {
        if (GetDirty() || forceUpdate)
        {
            uberMaterial = EnvironmentManager.Instance.curEnv.data.uberMaterial;

            base.InitLowwwer();

            cam.depthTextureMode = DepthTextureMode.None;

            if(NormalBufferEnable())
                Shader.EnableKeyword("_MRT");
            else
                Shader.DisableKeyword("_MRT");

            if (StochasticSSREnable())
                cam.depthTextureMode |= DepthTextureMode.MotionVectors;
            else
                cam.depthTextureMode = DepthTextureMode.None;

            int effectLayer = LayerMask.NameToLayer("EffectLayer");
            int distortionLayer = LayerMask.NameToLayer("AirDistortion");
			bool alphaBufferEnable = AlphaBufferEnable();
            EnvironmentManager.Instance.alphaPass.UpdateAlpha(alphaBufferEnable);
            EnvironmentManager.Instance.distortionPass.UpdateDistortion(DistortionEnable());

            effectLayer = (1 << effectLayer);
            distortionLayer = (1 << distortionLayer);
            if (alphaBufferEnable)
            {
                Shader.EnableKeyword("_ALPHABUFFER");
                cam.cullingMask &= ~effectLayer;                
            }
            else
            {
                cam.cullingMask |= effectLayer;               
                Shader.DisableKeyword("_ALPHABUFFER");
            }

            cam.cullingMask &= ~distortionLayer;
            EnvironmentManager.Instance.alphaPass.GetComponent<Camera>().cullingMask |= effectLayer;
            EnvironmentManager.Instance.alphaPass.GetComponent<Camera>().cullingMask &= ~distortionLayer;
            EnvironmentManager.Instance.distortionPass.GetComponent<Camera>().cullingMask |= distortionLayer;

            base.UpdatePostProcess();
            InitOpaqueBuffer();
            EnvironmentManager.Instance.alphaPass.InitAlphaBuffer();
            EnvironmentManager.Instance.distortionPass.InitDistortionBuffer();
            EnvironmentManager.Instance.uberPass.InitUberBuffer();

            SetNoDirty();
            forceUpdate = false;

        }
    }

    void Update()
    {       
        if (Application.isPlaying)
        {
            UpdateRadialBlur();
            UpdateChromaticAberration();
            UpdateBorder();
        }
    }

    void UpdateVolumetricFog()
    {
        if (VolumetricFogEnable())
        {
            mMaterialVolumetricFog.SetMatrix(CommonSet.ShaderProperties.fogClipToWorld, cam.cameraToWorldMatrix * cam.projectionMatrix.inverse);
            if (mProperty.fogWindSpeed > 0)
            {
                if (Application.isPlaying && Time.frameCount == lastFrameCount)
                    return;
                lastFrameCount = Time.frameCount;

                fogWindDir += Time.deltaTime * mProperty.fogWindDirection * mProperty.fogWindSpeed * mProperty.fogNoiseScale;
                mMaterialVolumetricFog.SetVector(CommonSet.ShaderProperties.fogWindDir, fogWindDir);
            }
        }
    }

    void UpdateHeightFog()
    {
        if (HeightFogEnable() && mProperty.heightFogType == Property.HeightFogType.POSTPROCESS)
        {
            mMaterialHeightFog.SetMatrix(CommonSet.ShaderProperties.fogClipToWorld, cam.cameraToWorldMatrix * cam.projectionMatrix.inverse);           
        }
    }

    public void OnPreRender()
    {
        RefreshRT();
        if (depthCopy)
            depthCopy.DiscardContents();

        if (depthRT)
        {
            if (NormalBufferEnable() && normalRT)
                cam.SetTargetBuffers(bufs, depthRT.depthBuffer);
            else
                cam.SetTargetBuffers(colorRT.colorBuffer, depthRT.depthBuffer);
        }            
        else
        {
            if (NormalBufferEnable() && normalRT)
                cam.SetTargetBuffers(bufs, colorRT.depthBuffer);
            else
                cam.targetTexture = colorRT;
        }            

        UpdateOpaqueCommandBuffer();

#if UNITY_EDITOR    
        //为了解决editor刷新问题
        if (!mMaterialBloom.HasProperty(CommonSet.ShaderProperties.bloomIntensity))
        {
            forceUpdate = true;
        }
#endif
 		UpdateVolumetricFog();
        UpdateHeightFog();
        UpdatePostProcess();
    }

    void UpdateOpaqueCommandBuffer()
    {
        if (cam == null || opaqueCB == null)
            return;
        else if (initOpaqueCB)
        {
            CommonSet.ClearCommandBuffer(cam,ref opaqueCB, CameraEvent.BeforeForwardAlpha);
            cam.AddCommandBuffer(CameraEvent.BeforeForwardAlpha, opaqueCB);
            PrepareOpaqueCB(opaqueCB);

            initOpaqueCB = false;
        }
    }

    void PrepareOpaqueCB(CommandBuffer cb)
    {
        cb.BeginSample("OpaquePostProcess");
        if (depthCopy && depthRT)
        {
            cb.Blit(depthRT.depthBuffer, depthCopy.colorBuffer);
            cb.SetGlobalTexture(CommonSet.ShaderProperties.cameraDepthTex, depthCopy.colorBuffer);
        }

        var colorTexID = new RenderTargetIdentifier(colorRT);

        if (HasOpaqueEffect())
        {
            bool debug = false;
            if (AmbientOcclusionEnable())
            {
                cb.SetGlobalTexture(CommonSet.ShaderProperties.normalBufferTex, normalRT.colorBuffer);
                PrepareHBAO(cb, colorRT);
                if (mProperty.debugAO) debug = true;
            }
            if (CloudShadowEnable())
                PrepareCloudShadow(cb);
            if (LumaOcclusionEnable())
            {
                PrepareLumaOcclusion(cb, colorRT);
                if (mProperty.showLO) debug = true;
            }
            if(StochasticSSREnable())
                PrepareStochasticSSR(cb);

            cb.SetRenderTarget(colorTexID);
            if (debug)
                cb.DrawMesh(CommonSet.fullscreenTriangle, Matrix4x4.identity, mMaterialOpaque, 0, 1);
            //cb.Blit(colorTexID, colorTexID, mMaterialOpaque, 1);
            else
                cb.DrawMesh(CommonSet.fullscreenTriangle, Matrix4x4.identity, mMaterialOpaque, 0, 0);
            //cb.Blit(null, colorTexID, mMaterialOpaque, 0);            

            if (AmbientOcclusionEnable())
                FinishHBAO(cb);
            if (CloudShadowEnable())
                FinishCloudShadow(cb);
            if (LumaOcclusionEnable())
                FinishLumaOcclusion(cb);
            if (StochasticSSREnable())
                FinishStochasticSSR(cb);
        }

        if (VolumetricFogEnable())
            PrepareVolumetricFog(cb, colorTexID);
        if (VolumetricFogEnable())
            FinishVolumetricFog(cb);
        if (HeightFogEnable() && mProperty.heightFogType == Property.HeightFogType.POSTPROCESS)
            PrepareHeightFog(cb, colorTexID);
        if (HeightFogEnable() && mProperty.heightFogType == Property.HeightFogType.POSTPROCESS)
            FinishHeightFog(cb);

        cb.EndSample("OpaquePostProcess");
    }

    void PrepareHBAO(CommandBuffer cb, RenderTexture colorRT)
    {
        if (aoNoiseTex == null)
            CreateHBAONoiseTex();

        float tanHalfFovY = Mathf.Tan(0.5f * cam.fieldOfView * Mathf.Deg2Rad);
        float invFocalLenX = 1.0f / (1.0f / tanHalfFovY * (cam.pixelHeight / (float)cam.pixelWidth));
        float invFocalLenY = 1.0f / (1.0f / tanHalfFovY);
        mMaterialAmbientOcclusion.SetVector(CommonSet.ShaderProperties.uvToView, new Vector4(2.0f * invFocalLenX, -2.0f * invFocalLenY, -1.0f * invFocalLenX, 1.0f * invFocalLenY));
        mMaterialAmbientOcclusion.SetTexture(CommonSet.ShaderProperties.noiseTex, aoNoiseTex);
        mMaterialAmbientOcclusion.SetFloat(CommonSet.ShaderProperties.aoRadius, mProperty.aoRadius * 0.5f * (cam.pixelWidth / (tanHalfFovY * 2.0f)));

        var blurXTexId = new RenderTargetIdentifier(CommonSet.ShaderProperties.aoBlurXTex);
        var blurYTexId = new RenderTargetIdentifier(CommonSet.ShaderProperties.aoBlurYTex);
        var hbaoTexId = new RenderTargetIdentifier(CommonSet.ShaderProperties.hbaoTex);

        cb.GetTemporaryRT(CommonSet.ShaderProperties.hbaoTex, cam.pixelWidth, cam.pixelHeight, 0, FilterMode.Bilinear, singleChannelFormat, RenderTextureReadWrite.Linear);

        cb.SetRenderTarget(hbaoTexId);
        cb.ClearRenderTarget(false, true, Color.white);

        var colorTexId = new RenderTargetIdentifier(colorRT);
        cb.Blit(colorTexId, hbaoTexId, mMaterialAmbientOcclusion, (int)HBAOPass.OcclusionLowest + mProperty.aoQuality); // hbao      

        if (mProperty.aoBlur)
        {
            cb.GetTemporaryRT(CommonSet.ShaderProperties.aoBlurXTex, cam.pixelWidth / 2, cam.pixelHeight / 2, 0, FilterMode.Bilinear, singleChannelFormat, RenderTextureReadWrite.Linear);
            cb.GetTemporaryRT(CommonSet.ShaderProperties.aoBlurYTex, cam.pixelWidth / 2, cam.pixelHeight / 2, 0, FilterMode.Bilinear, singleChannelFormat, RenderTextureReadWrite.Linear);
            cb.Blit(hbaoTexId, blurXTexId, mMaterialAmbientOcclusion, (int)HBAOPass.BlurX); // blur X
            cb.Blit(blurXTexId, blurYTexId, mMaterialAmbientOcclusion, (int)HBAOPass.BlurY); // blur Y

            cb.SetGlobalTexture(CommonSet.ShaderProperties.hbaoTex, blurYTexId);
            cb.ReleaseTemporaryRT(CommonSet.ShaderProperties.aoBlurXTex);
        }
        else
            cb.SetGlobalTexture(CommonSet.ShaderProperties.hbaoTex, hbaoTexId);

        //if (mProperty.debugAO)
        //    sceneCommandBuffer.Blit(BuiltinRenderTextureType.CameraTarget, BuiltinRenderTextureType.CameraTarget, mMaterialAmbientOcclusion, (int)HBAOPass.Debug);
        //else
        //    sceneCommandBuffer.Blit(BuiltinRenderTextureType.CameraTarget, BuiltinRenderTextureType.CameraTarget, mMaterialAmbientOcclusion, (int)HBAOPass.Final);

    }

    void FinishHBAO(CommandBuffer cb)
    {
        if (mProperty.aoBlur)
            cb.ReleaseTemporaryRT(CommonSet.ShaderProperties.aoBlurYTex);

        cb.ReleaseTemporaryRT(CommonSet.ShaderProperties.hbaoTex);
    }

    void PrepareVolumetricFog(CommandBuffer cb, RenderTargetIdentifier colorTexID)
    {
        if (mProperty.fogDownSampling > 1 && SystemInfo.supportedRenderTargetCount > 2 && SystemInfo.SupportsRenderTextureFormat(RenderTextureFormat.Depth))
        {
            int scaledWidth = GetScaledSize(colorRT.width, mProperty.fogDownSampling);
            int scaledHeight = GetScaledSize(colorRT.height, mProperty.fogDownSampling);

            var color = new RenderTargetIdentifier(CommonSet.ShaderProperties.downSampleFogTex);
            var rawDepth = new RenderTargetIdentifier(CommonSet.ShaderProperties.downSampleRawDepthTex);
            var depth = new RenderTargetIdentifier(CommonSet.ShaderProperties.downSampleDepth);
            RenderTextureFormat colorFormat = SystemInfo.SupportsRenderTextureFormat(RenderTextureFormat.ARGBHalf) ? RenderTextureFormat.ARGBHalf : RenderTextureFormat.ARGB32;
            cb.GetTemporaryRT(CommonSet.ShaderProperties.downSampleFogTex, scaledWidth, scaledHeight, 0, FilterMode.Bilinear, colorFormat, RenderTextureReadWrite.Linear);
            RenderTextureFormat depthRawFormat = SystemInfo.SupportsRenderTextureFormat(RenderTextureFormat.RFloat) ? RenderTextureFormat.RFloat : RenderTextureFormat.RHalf;
            cb.GetTemporaryRT(CommonSet.ShaderProperties.downSampleRawDepthTex, scaledWidth, scaledHeight, 0, FilterMode.Bilinear, depthRawFormat, RenderTextureReadWrite.Linear);
            cb.GetTemporaryRT(CommonSet.ShaderProperties.downSampleDepth, scaledWidth, scaledHeight, 24, FilterMode.Bilinear, RenderTextureFormat.Depth);

            if (mrt == null)
                mrt = new RenderTargetIdentifier[2];
            mrt[0] = color;
            mrt[1] = rawDepth;
            cb.SetRenderTarget(mrt, depth);
            cb.DrawMesh(CommonSet.fullscreenTriangle, Matrix4x4.identity, mMaterialVolumetricFog, 0, (int)VolumetricFogPass.DownSample);
            cb.SetGlobalTexture(CommonSet.ShaderProperties.downSampleFogTex, color);
            cb.SetGlobalTexture(CommonSet.ShaderProperties.downSampleRawDepthTex, rawDepth);
            cb.SetRenderTarget(colorTexID);
            if (mProperty.fogEdgeImprove)
                cb.DrawMesh(CommonSet.fullscreenTriangle, Matrix4x4.identity, mMaterialVolumetricFog, 0, (int)VolumetricFogPass.ComposeEdgeImprove);
            //cb.Blit(null, colorTexID, mMaterialVolumetricFog, (int)VolumetricFogPass.ComposeEdgeImprove);
            else
                //cb.Blit(null, colorTexID, mMaterialVolumetricFog, (int)VolumetricFogPass.Compose);
                cb.DrawMesh(CommonSet.fullscreenTriangle, Matrix4x4.identity, mMaterialVolumetricFog, 0, (int)VolumetricFogPass.Compose);
        }
        // else
        //     sceneCommandBuffer.Blit(BuiltinRenderTextureType.CameraTarget, BuiltinRenderTextureType.CameraTarget, mMaterialVolumetricFog, (int)VolumetricFogPass.All);
    }
    void FinishVolumetricFog(CommandBuffer cb)
    {
        if (mProperty.fogDownSampling > 1 && SystemInfo.supportedRenderTargetCount > 2 && SystemInfo.SupportsRenderTextureFormat(RenderTextureFormat.Depth))
        {
            cb.ReleaseTemporaryRT(CommonSet.ShaderProperties.downSampleFogTex);
            cb.ReleaseTemporaryRT(CommonSet.ShaderProperties.downSampleRawDepthTex);
            cb.ReleaseTemporaryRT(CommonSet.ShaderProperties.downSampleDepth);
        }
    }
    void PrepareHeightFog(CommandBuffer cb, RenderTargetIdentifier colorTexID)
    {
        cb.SetRenderTarget(colorTexID);
        cb.DrawMesh(CommonSet.fullscreenTriangle, Matrix4x4.identity, mMaterialHeightFog, 0, 0);
    }
    void FinishHeightFog(CommandBuffer cb)
    {

    }
    void PrepareCloudShadow(CommandBuffer cb)
    {
        float tanHalfFovY = Mathf.Tan(0.5f * cam.fieldOfView * Mathf.Deg2Rad);
        float invFocalLenX = 1.0f / (1.0f / tanHalfFovY * (cam.pixelHeight / (float)cam.pixelWidth));
        float invFocalLenY = 1.0f / (1.0f / tanHalfFovY);
        mMaterialOpaque.SetVector(CommonSet.ShaderProperties.uvToView, new Vector4(2.0f * invFocalLenX, -2.0f * invFocalLenY, -1.0f * invFocalLenX, 1.0f * invFocalLenY));
        //sceneCommandBuffer.Blit(BuiltinRenderTextureType.CameraTarget, BuiltinRenderTextureType.CameraTarget, mMaterialCloudShadow, 0);
    }
    void FinishCloudShadow(CommandBuffer cb)
    {

    }
    void PrepareStochasticSSR(CommandBuffer cb)
    {
        for (int i = 1; i < mProperty.hierarchicalZLevel; ++i)
        {
            cb.SetGlobalTexture(CommonSet.ShaderProperties.hiZbufferTex, depthCopy);
            cb.SetGlobalInt(CommonSet.ShaderProperties.hiZbufferLevel, i - 1);
            cb.SetRenderTarget(depthBackUp, i);
            cb.DrawMesh(GraphicsUtility.mesh, Matrix4x4.identity, mMaterialStochasticSSR, 0, (int)StochasticSSRPass.HiZBuffer);
            cb.CopyTexture(depthBackUp, 0, i, depthCopy, 0, i);
        }
    }
    void FinishStochasticSSR(CommandBuffer cb)
    {

    }
    public void PrepareBloom(CommandBuffer cb, RenderTexture source, Material bloomMaterial, float maxRadius, int bloomTexID, bool colorGrading, float ratio)
    {
        int dw = source.width / 2;
        int dh = source.height / 2;

        RenderTargetIdentifier _BloomThresholdTexId = new RenderTargetIdentifier(CommonSet.ShaderProperties.bloomThresholdTex);
        cb.GetTemporaryRT(CommonSet.ShaderProperties.bloomThresholdTex, dw, dh, 0, FilterMode.Bilinear, hdrFormat, RenderTextureReadWrite.Linear);

        var sourceId = new RenderTargetIdentifier(source);
        cb.Blit(sourceId, _BloomThresholdTexId, bloomMaterial, (int)bloomPass.BloomThreshold);


        ratio = Mathf.Clamp(ratio, -1, 1);
        float rw = ratio < 0 ? -ratio : 0f;
        float rh = ratio > 0 ? ratio : 0f;
        int rtWidth = Mathf.FloorToInt(source.width / (2f - rw)) / 2;
        int rtHeight = Mathf.FloorToInt(source.height / (2f - rh)) / 2;

        //int rtWidth = source.width / 4;
        //int rtHeight = source.height / 4;

        RenderTargetIdentifier _BloomDownSampleTexId = new RenderTargetIdentifier(CommonSet.ShaderProperties.bloomDownSampleTex);
        cb.GetTemporaryRT(CommonSet.ShaderProperties.bloomDownSampleTex, rtWidth, rtHeight, 0, FilterMode.Bilinear, hdrFormat, RenderTextureReadWrite.Linear);
        cb.Blit(_BloomThresholdTexId, _BloomDownSampleTexId, mMaterialDownSample, (int)DownSample.DownSample);
        cb.ReleaseTemporaryRT(CommonSet.ShaderProperties.bloomThresholdTex);

        int s = Mathf.Max(rtWidth, rtHeight);
        float h = Mathf.Log(s, 2) - 8;
        float iteration = h + maxRadius;
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

        bloomMaterial.SetFloat(CommonSet.ShaderProperties.bloomScale, 0.5f + fBloomIteration - bloomIteration);

        for (int i = bloomIteration - 2; i >= 0; i--)
        {
            rtWidth = rtWidth * 2;
            rtHeight = rtHeight * 2;

            RenderTargetIdentifier identifier = new RenderTargetIdentifier(CommonSet.ShaderProperties.blurTexArray2[i]);
            cb.GetTemporaryRT(CommonSet.ShaderProperties.blurTexArray2[i], rtWidth, rtHeight, 0, FilterMode.Bilinear, hdrFormat, RenderTextureReadWrite.Linear);
            cb.SetGlobalTexture(CommonSet.ShaderProperties.bloomBlurTex, lastTex);
            cb.Blit(bloomParam.blurBuffer1[i], identifier, bloomMaterial, (int)bloomPass.BloomUpSample);
            bloomParam.blurBuffer2[i] = CommonSet.ShaderProperties.blurTexArray2[i];
            lastTex = identifier;
        }

        RenderTargetIdentifier _BloomTexId = new RenderTargetIdentifier(bloomTexID);

        if (lastTex != _BloomDownSampleTexId)
        {
            rtWidth = rtWidth * 2;
            rtHeight = rtHeight * 2;

            cb.GetTemporaryRT(bloomTexID, rtWidth, rtHeight, 0, FilterMode.Bilinear, hdrFormat, RenderTextureReadWrite.Linear);
            cb.SetGlobalTexture(CommonSet.ShaderProperties.bloomBlurTex, lastTex);
            if (colorGrading)
            {
                RenderTargetIdentifier _BloomTempId = new RenderTargetIdentifier(CommonSet.ShaderProperties.bloomTempTex);
                cb.GetTemporaryRT(CommonSet.ShaderProperties.bloomTempTex, rtWidth, rtHeight, 0, FilterMode.Bilinear, hdrFormat, RenderTextureReadWrite.Linear);
                cb.Blit(_BloomDownSampleTexId, _BloomTempId, bloomMaterial, (int)bloomPass.BloomUpSample);
                cb.Blit(_BloomTempId, _BloomTexId, bloomMaterial, (int)bloomPass.BloomWithColorGrading);
                cb.ReleaseTemporaryRT(CommonSet.ShaderProperties.bloomTempTex);
            }
            else
            {
                cb.Blit(_BloomDownSampleTexId, _BloomTexId, bloomMaterial, (int)bloomPass.BloomUpSample);
            }

            cb.ReleaseTemporaryRT(CommonSet.ShaderProperties.bloomDownSampleTex);
        }

        for (int i = 0; i < BloomParam.maxIterations; i++)
        {
            if (bloomParam.blurBuffer1[i] != 0) cb.ReleaseTemporaryRT(CommonSet.ShaderProperties.blurTexArray1[i]);
            if (bloomParam.blurBuffer2[i] != 0) cb.ReleaseTemporaryRT(CommonSet.ShaderProperties.blurTexArray2[i]);
            bloomParam.blurBuffer1[i] = 0;
            bloomParam.blurBuffer2[i] = 0;
        }

        cb.SetGlobalTexture(bloomTexID, _BloomTexId);
    }
    public void FinishBloom(CommandBuffer cb, int bloomTexID)
    {
        cb.ReleaseTemporaryRT(bloomTexID);
    }
    void PrepareLumaOcclusion(CommandBuffer cb, RenderTexture colorRT)
    {
        int dw = cam.pixelWidth / 2;
        int dh = cam.pixelHeight / 2;

        RenderTargetIdentifier _LumaTexId = new RenderTargetIdentifier(CommonSet.ShaderProperties.lumaTex);
        cb.GetTemporaryRT(CommonSet.ShaderProperties.lumaTex, dw, dh, 0, FilterMode.Bilinear, RenderTextureFormat.ARGB32, RenderTextureReadWrite.Linear);

        var colorTexId = new RenderTargetIdentifier(colorRT);
        cb.Blit(colorTexId, _LumaTexId, mMaterialLumaOcclusion, (int)LumaOcclusionPass.LumaLow + mProperty.loSamples - 2);

        if (mProperty.loBlur)
        {
            RenderTargetIdentifier _LumaBlurX = new RenderTargetIdentifier(CommonSet.ShaderProperties.lumaBlurX);
            cb.GetTemporaryRT(CommonSet.ShaderProperties.lumaBlurX, dw, dh, 0, FilterMode.Bilinear, RenderTextureFormat.ARGB32, RenderTextureReadWrite.Linear);
            cb.Blit(_LumaTexId, _LumaBlurX, mMaterialLumaOcclusion, (int)LumaOcclusionPass.LumaBlurX);
            RenderTargetIdentifier _LumaBlurY = new RenderTargetIdentifier(CommonSet.ShaderProperties.lumaBlurY);
            cb.GetTemporaryRT(CommonSet.ShaderProperties.lumaBlurY, dw, dh, 0, FilterMode.Bilinear, RenderTextureFormat.ARGB32, RenderTextureReadWrite.Linear);
            cb.Blit(_LumaBlurX, _LumaBlurY, mMaterialLumaOcclusion, (int)LumaOcclusionPass.LumaBlurY);
            cb.ReleaseTemporaryRT(CommonSet.ShaderProperties.lumaBlurX);
            cb.ReleaseTemporaryRT(CommonSet.ShaderProperties.lumaTex);
            cb.SetGlobalTexture(CommonSet.ShaderProperties.lumaTex, _LumaBlurY);
            lumaTexNameId = CommonSet.ShaderProperties.lumaBlurY;
        }
        else
        {
            cb.SetGlobalTexture(CommonSet.ShaderProperties.lumaTex, _LumaTexId);
            lumaTexNameId = CommonSet.ShaderProperties.lumaTex;
        }
    }
    void FinishLumaOcclusion(CommandBuffer cb)
    {
        cb.ReleaseTemporaryRT(lumaTexNameId);
    }
    void UpdateRadialBlur()
    {
        if (mProperty.radialAmount != radialAmount || mProperty.radialStrength != radialStrength)
        {
            mProperty.radialAmount = radialAmount;
            mProperty.radialStrength = radialStrength;
            if (mProperty.radialAmount > 0.02f)
                mProperty.radialBlur = true;
            else
                mProperty.radialBlur = false;
            InitRadialBlur();
        }
    }
    void UpdateChromaticAberration()
    {
        if (mProperty.chromaAmount != chromaAmount || colorOffset !=  oldColorOffset)
        {
            if(mProperty.chromaAmount != chromaAmount)
            {
                mProperty.chromaAmount = chromaAmount;

                if (mProperty.chromaAmount > 0.02f)
                    mProperty.chromaticAberration = true;
                else
                    mProperty.chromaticAberration = false;
                InitChromaticAberration();
            }

            if(colorOffset != oldColorOffset)
            {
                oldColorOffset = colorOffset;
                if (colorOffset > 0.02f)
                    mProperty.chromaticAberration = true;
                else
                    mProperty.chromaticAberration = false;
                InitChromaticAberration();
            }

        }
    }
    void UpdateBorder()
    {
        if (mProperty.borderColor.a != borderFactor)
        {
            mProperty.borderColor.a = borderFactor;

            if (mProperty.borderColor.a > 0.02f)
                mProperty.border = true;
            else
                mProperty.border = false;
            InitBorder();
        }
    }
}
