using UnityEngine;
using UnityEngine.Rendering;
using System.Collections;
using System.Collections.Generic;
using System;
using System.IO;
using UnityEngine.Events;
using UnityEngine.Rendering.PostProcessing;

public class DragonPostProcessBase : MonoBehaviour {
    #region pass
    public enum MainPass
    {
        Main = 0,
        WithAlphaBuffer,
        WithPlayer,
        WithAlphaPlayer,
        ForDOF,
        ForDOFWithAlphaBuffer,
        ForDOFWithPlayer,
        ForDOFWithAlphaPlayer,
        Simple
    }
    public enum DownSample
    {
        DownSample = 0,
        HasBloomDownSample,
    }
    public enum HBAOPass
    {
        OcclusionLowest = 0,
        OcclusionLow,
        OcclusionMedium,
        OcclusionHigh,
        BlurX,
        BlurY,
        Final,
        Debug,
    }
    public enum VolumetricFogPass
    {
        All = 0,
        DownSample,
        Compose,
        ComposeEdgeImprove,
    }
    public enum LumaOcclusionPass
    {
        LumaLow = 0,
        LumaMedium,
        LumaHigh,
        LumaBlurX,
        LumaBlurY,
    }
    public enum BokehDOFPass
    {
        COC = 0,
        DownSampleAndFilter,
        FilterSmall,
        FilterMedium,
        FilterLarge,
        FilterVeryLarge,
        PostFilter,
    }
    public enum FastDOFPass
    {
        COC = 0,
        PreFilter,
        FragBlurH,
        FragBlurV
    }
    public enum bloomPass
    {
        BloomThreshold = 0,
        BloomUpSample,
        BloomWithColorGrading
    }
    public enum GenLutPass
    {
        GenLut = 0,
    }
    public enum FinalPass
    {
        AA = 0,
    }
    public enum StochasticSSRPass
    {
        HiZBuffer = 0,
        HierarchicalZTraceSingleSampler,
        HierarchicalZTraceMultiSampler,
        Spatiofilter,
        Temporalfilter,
        Combine
    }

    public enum RenderResolution
    {
        Full = 1,
        Half = 2
    }
    #endregion

    #region ColorGradingAttributes
    [AttributeUsage(AttributeTargets.Field)]
    public class SettingsGroup : Attribute
    { }
    public class IndentedGroup : PropertyAttribute
    { }
    public class ChannelMixer : PropertyAttribute
    { }
    public class ColorWheelGroup : PropertyAttribute
    {
        public int minSizePerWheel = 60;
        public int maxSizePerWheel = 150;

        public ColorWheelGroup()
        { }

        public ColorWheelGroup(int minSizePerWheel, int maxSizePerWheel)
        {
            this.minSizePerWheel = minSizePerWheel;
            this.maxSizePerWheel = maxSizePerWheel;
        }
    }

    public class Curve : PropertyAttribute
    {
        public Color color = Color.white;

        public Curve()
        { }

        public Curve(float r, float g, float b, float a) // Can't pass a struct in an attribute
        {
            color = new Color(r, g, b, a);
        }
    }

    [Serializable]
    public struct ColorWheelsSettings
    {
        [ColorUsage(false)]
        public Color shadows;

        [ColorUsage(false)]
        public Color midtones;

        [ColorUsage(false)]
        public Color highlights;

        public static ColorWheelsSettings defaultSettings
        {
            get
            {
                return new ColorWheelsSettings
                {
                    shadows = new Color(1,1,1,0),
                    midtones = new Color(1, 1, 1, 0),
                    highlights = new Color(1,1,1,0)
                };
            }
        }
    }

    [Serializable]
    public struct ChannelMixerSettings
    {
        public int currentChannel;
        public Vector3[] channels;

        public static ChannelMixerSettings defaultSettings
        {
            get
            {
                return new ChannelMixerSettings
                {
                    currentChannel = 0,
                    channels = new[]
                    {
                            new Vector3(1f, 0f, 0f),
                            new Vector3(0f, 1f, 0f),
                            new Vector3(0f, 0f, 1f)
                        }
                };
            }
        }
    }

    [Serializable]
    public struct CurvesSettings
    {
        public Spline hueVsHueCurve; 
        public Spline hueVsSatCurve; 
        public Spline satVsSatCurve; 
        public Spline lumVsSatCurve; 

        public static CurvesSettings defaultCurves
        {
            get
            {
                return new CurvesSettings
                {
                    hueVsHueCurve = new Spline(new AnimationCurve(), 0.5f, true, new Vector2(0f, 1f)),
                    hueVsSatCurve = new Spline(new AnimationCurve(), 0.5f, true, new Vector2(0f, 1f)),
                    satVsSatCurve = new Spline(new AnimationCurve(), 0.5f, true, new Vector2(0f, 1f)),
                    lumVsSatCurve = new Spline(new AnimationCurve(), 0.5f, true, new Vector2(0f, 1f)),
                };
            }
        }
    }
    #endregion

    #region property
    [Serializable]
    public class Property
    {
        public enum ToneMappingType
        {
            ACES,
            FILMIC,
            CUSTOM
        }
        public enum ChromaticAberrationType
        {
            Radial,
            FullScreen
        }

        public enum FXAAQuality
        {
            LOW,
            NORMAL,
        }

        public enum HeightFogType
        {
            VERTEX,
            POSTPROCESS,
        }

        [Serializable]
        public struct BloomProperty
        {
            public bool bloom;
            [Range(0f, 5f)]
            public float bloomThreshold;
            [Range(1f, 7f)]
            public float bloomRadius;
            [Range(0f, 1f)]
            public float bloomSoftKnee;
            [Range(-1f, 1f)]
            public float bloomAnamorphicRatio;
            [Range(0f, 4f)]
            public float bloomIntensity;

            public BloomProperty(bool enable)
            {
                this.bloom = enable;
                this.bloomThreshold = 0.9f;
                this.bloomRadius = 2.0f;
                this.bloomSoftKnee = 0.5f;
                this.bloomAnamorphicRatio = 0;
                this.bloomIntensity = 1.0f;
            }

            public bool Diff(BloomProperty other)
            {
                if (this.bloom != other.bloom || this.bloomThreshold != other.bloomThreshold || this.bloomRadius != other.bloomRadius 
                    || this.bloomSoftKnee != other.bloomSoftKnee || this.bloomAnamorphicRatio != other.bloomAnamorphicRatio || this.bloomIntensity != other.bloomIntensity)
                    return true;

                return false;
            }
            public void Assign(BloomProperty other)
            {
                this.bloom = other.bloom;
                this.bloomThreshold = other.bloomThreshold;
                this.bloomRadius = other.bloomRadius;
                this.bloomSoftKnee = other.bloomSoftKnee;
                this.bloomAnamorphicRatio = other.bloomAnamorphicRatio;
                this.bloomIntensity = other.bloomIntensity;
            }
        }

        [Serializable]
        public struct ToneMapProperty
        {
            public bool toneMapping;
            public ToneMappingType toneMappingType;

            public float acesExposure;
            public float customExposure;
            [Range(0f, 1f)]
            public float toneCurveToeStrength;
            [Range(0f, 1f)]
            public float toneCurveToeLength;
            [Range(0f, 1f)]
            public float toneCurveShoulderStrength;
            [UnityEngine.Rendering.PostProcessing.Min(0f)]
            public float toneCurveShoulderLength;
            [Range(0f, 1f)]
            public float toneCurveShoulderAngle;
            [UnityEngine.Rendering.PostProcessing.Min(0.001f)]
            public float toneCurveGamma;

            public ToneMapProperty(bool enable)
            {
                this.toneMapping = enable;
                this.toneMappingType = ToneMappingType.ACES;
                this.acesExposure = 1f;
                this.customExposure = 1.0f;
                this.toneCurveToeStrength = 0;
                this.toneCurveToeLength = 0.5f;
                this.toneCurveShoulderStrength = 0;
                this.toneCurveShoulderLength = 0.5f;
                this.toneCurveShoulderAngle = 0;
                this.toneCurveGamma = 1;
            }

            public bool Diff(ToneMapProperty other)
            {
                if (this.toneMapping != other.toneMapping || this.toneMappingType != other.toneMappingType || this.acesExposure != other.acesExposure
                    || this.customExposure != other.customExposure || this.toneCurveToeStrength != other.toneCurveToeStrength || this.toneCurveToeLength != other.toneCurveToeLength
                    || this.toneCurveShoulderStrength != other.toneCurveShoulderStrength || this.toneCurveShoulderLength != other.toneCurveShoulderLength || this.toneCurveShoulderAngle != other.toneCurveShoulderAngle
                    || this.toneCurveGamma != other.toneCurveGamma)
                    return true;

                return false;
            }
            public void Assign(ToneMapProperty other)
            {
                this.toneMapping = other.toneMapping;
                this.toneMappingType = other.toneMappingType;
                this.acesExposure = other.acesExposure;
                this.customExposure = other.customExposure;
                this.toneCurveToeStrength = other.toneCurveToeStrength;
                this.toneCurveToeLength = other.toneCurveToeLength;
                this.toneCurveShoulderStrength = other.toneCurveShoulderStrength;
                this.toneCurveShoulderLength = other.toneCurveShoulderLength;
                this.toneCurveShoulderAngle = other.toneCurveShoulderAngle;
                this.toneCurveGamma = other.toneCurveGamma;
            }
        }

        [Serializable]
        public struct ColorGradingProperty
        {
            //color grading
            public bool colorGrading;
            [ColorUsage(false, true)]
            public Color colorFilter;
            [Space, ColorWheelGroup]
            public ColorWheelsSettings colorWheels;
            [Range(-2f, 2f)] 
            public float temperatureShift;
            [Range(-2f, 2f)] 
            public float tint;
            [Range(-0.5f, 0.5f)] 
            public float hue;
            [Range(0f, 2f)] 
            public float saturation;
            [Range(0f, 2f)]  
            public float contrast;
            [Space, ChannelMixer]
            public ChannelMixerSettings channelMixer;
            [Space, IndentedGroup]
            public CurvesSettings curves;

            public ColorGradingProperty(bool enable)
            {
                this.colorGrading = enable;
                this.colorFilter = Color.white;
                this.colorWheels = ColorWheelsSettings.defaultSettings;
                this.temperatureShift = 0;
                this.tint = 0;
                this.hue = 0;
                this.saturation = 1;   
                this.contrast = 1;   
                this.channelMixer = ChannelMixerSettings.defaultSettings;
                this.curves = CurvesSettings.defaultCurves;
            }

            public bool Diff(ColorGradingProperty other)
            {
                if (this.colorGrading != other.colorGrading || this.colorFilter != other.colorFilter || this.colorWheels.highlights != other.colorWheels.highlights || this.colorWheels.midtones != other.colorWheels.midtones
                    || this.colorWheels.shadows != other.colorWheels.shadows || this.temperatureShift != other.temperatureShift || this.tint != other.tint || this.hue != other.hue
                    || this.saturation != other.saturation || this.contrast != other.contrast
                    || this.channelMixer.currentChannel != other.channelMixer.currentChannel || this.channelMixer.channels[0] != other.channelMixer.channels[0]
                    || this.channelMixer.channels[1] != other.channelMixer.channels[1] || this.channelMixer.channels[2] != other.channelMixer.channels[2] )
                    return true;

                return false;
            }
            public void Assign(ColorGradingProperty other)
            {
                this.colorGrading = other.colorGrading;
                this.colorFilter = other.colorFilter;
                this.colorWheels.highlights = other.colorWheels.highlights;
                this.colorWheels.midtones = other.colorWheels.midtones;
                this.colorWheels.shadows = other.colorWheels.shadows;
                this.temperatureShift = other.temperatureShift;
                this.tint = other.tint;
                this.hue = other.hue;
                this.saturation = other.saturation;
                this.contrast = other.contrast;
                this.channelMixer.currentChannel = other.channelMixer.currentChannel;
                this.channelMixer.channels[0] = other.channelMixer.channels[0];
                this.channelMixer.channels[1] = other.channelMixer.channels[1];
                this.channelMixer.channels[2] = other.channelMixer.channels[2];
            }
        }

        [Serializable]
        public struct UserLutProperty
        {
            public bool userLut;
            public Texture lutTex;
            [Range(0.0f, 1.0f)]
            public float contribution;

            public UserLutProperty(bool enable)
            {
                this.userLut = enable;
                this.lutTex = null;
                this.contribution = 1.0f;
            }

            public bool Diff(UserLutProperty other)
            {
                if (this.userLut != other.userLut || this.lutTex != other.lutTex
                    || this.contribution != other.contribution)
                    return true;

                return false;
            }
            public void Assign(UserLutProperty other)
            {
                this.userLut = other.userLut;
                this.lutTex = other.lutTex;
                this.contribution = other.contribution;
            }
        }

        //light
        public Light sunLight = null;

        //alpha buffer
        public bool alphaBuffer = false;

        //playerLayer
        public bool playerLayer = false;

        //distortion
        public bool distortion = false;

        //bloom
        public BloomProperty bloom = new BloomProperty(false);
        public BloomProperty alphaBloom = new BloomProperty(false);
        public BloomProperty playerBloom = new BloomProperty(false);

        //tonemapping
        public ToneMapProperty sceneToneMap = new ToneMapProperty(false);
        public ToneMapProperty alphaToneMap = new ToneMapProperty(false);
        public ToneMapProperty playerToneMap = new ToneMapProperty(false);

        //color grading
        public ColorGradingProperty sceneColorGrading = new ColorGradingProperty(false);
        public ColorGradingProperty alphaColorGrading = new ColorGradingProperty(false);
        public ColorGradingProperty playerColorGrading = new ColorGradingProperty(false);

        //user lut
        public UserLutProperty sceneUserLut = new UserLutProperty(false);
        public UserLutProperty alphaUserLut = new UserLutProperty(false);
        public UserLutProperty playerUserLut = new UserLutProperty(false);

        //遮罩
        public bool mask = false;
        public Texture2D overlayTex;
        public Color overlayColor = Color.white;

        //AA
        public bool antialiasing = false;
        public FXAAQuality fxaaQuality = FXAAQuality.LOW;

        //BokehDOF
        public bool depthOfField = false;
        public float focusDistance = 10f;
        [Range(0.1f, 32.0f)]
        public float aperture = 5.6f;
        [Range(1f, 1000.0f)]
        public float focalLength = 50f;
        [Range(0, 3.0f)]
        public int kernelSize = 1;

        //FastDOF
        public bool  dofFast = false;
        [Range(0f, 100.0f)]
        public float dofStart = 5f;
        [Range(0f, 50.0f)]
        public float dofDistance = 20f;
        [Range(0.5f, 2.5f)]
        public float dofRadius = 1f;

        //AmbientOcclusion
        public bool ambientOcclusion = false;
        [Range(0, 3)]
        public int aoQuality = 0;
        [Range(0, 5)]
        public float aoRadius = 0.8f;
        [Range(64, 512)]
        public float maxRadiusPixels = 128f;
        [Range(0, 0.5f)]
        public float bias = 0.0f;
        [Range(0, 10)]
        public float aoIntensity = 1f;
        [Range(0, 1000)]
        public float maxDistance = 500f;
        [Range(0, 1000)]
        public float distanceFalloff = 50f;
        [ColorUsage(false, true)]
        public Color aoColor = Color.black;
        public bool random = false;
        public bool aoBlur = true;
        public bool debugAO = false;

        //LumaOcclusion
        public bool lumaOcclusion = false;
        [Range(0.01f, 0.5f)]
        public float loThreshold = 0.1f;
        [Range(2f, 10f)]
        public float loRadius = 6.0f;
        [Range(2, 4)]
        public int loSamples = 4;
        [Range(0, 1.5f)]
        public float loIntensity = 0.5f;
        [Range(0f, 1f)]
        public float lumaProtect = 0.1f;
        public bool loBlur = true;
        public bool showLO;
        public bool directional = false;
        [Range(0f, 6.2832f)]
        public float radian = 0;

        //volumetricFog
        public bool volumetricFog = false;
        [Range(0, 1.25f)]
        public float fogDensity = 0.5f;
        [Range(0, 500f)]
        public float fogHeight = 0.5f;
        public float fogBaseHeight = 0f;
        [Range(0, 1f)]
        public float fogNoiseStrength = 0.5f;
        [Range(-0.3f, 2f)]
        public float fogNoiseSparse = 0.5f;
        [Range(0f, 2f)]
        public float fogNoiseFinalMult = 1;
        [Range(0.2f, 10f)]
        public float fogNoiseScale = 2;
        [ColorUsage(false, true)]
        public Color fogColor = Color.white;
        [ColorUsage(false, true)]
        public Color fogSpec = Color.red;
        [Range(0, 1f)]
        public float fogSpecThreshold = 0.5f;
        [ColorUsage(false, true)]
        public Color fogLightColor = Color.white;
        public bool fogCustomDirection = false;
        public Vector3 fogSunDirection;
        [Range(0, 100f)]
        public float fogWindSpeed = 5f;
        public Vector3 fogWindDirection = new Vector3(0.5f, 0, -0.5f);
        [Range(2, 5)]
        public int fogDownSampling = 2;
        public bool fogEdgeImprove = true;
        [Range(1f, 20f)]
        public float fogStepping = 10;
        public Texture2D fogTex = null;

        //heightFog
        public bool heightFog = false;
        public HeightFogType heightFogType;
        [ColorUsage(false,true)]
        public Color heightFogColor = Color.white;
        [ColorUsage(false, true)]
        public Color heightfogEmissionColor = Color.white;
        [Range(0, 500f)]
        public float heightFogHeight = 0.5f;
        public float heightFogBaseHeight;
        [Range(0.01f, 20f)]
        public float heightFogFalloff = 1;
        [Range(0.0f, 100f)]
        public float heightFogEmissionFalloff = 1;
        public bool heightFogAnimation = false;
        public Vector2 heightFogSpeed;
        public Vector2 heightFogFrequency;
        public Vector2 heightFogAmplitude;

        //vignette
        public bool vignette = false;
        public bool ignoreAlphaBuffer = true;
        [Range(0f, 1f)]
        public float vignetteIntensity = 0.6f;
        [Range(0.01f, 1f)]
        public float vignetteSmoothness = 0.6f;
        [Range(0f, 1f)]
        public float vignetteRoundness = 0.6f;
        [ColorUsage(true, true)]
        public Color vignetteColor;

        //border
        public bool border = false;
        [Range(0f, 0.7f)]
        public float borderMaxAlpha = 0.5f;
        public float borderIntensity = 0.5f;
        [ColorUsage(true, true)]
        public Color borderColor;       
        public Texture2D borderMask;
        public Vector2 borderTile = new Vector2(10, 10);
        public Texture2D borderTex;

        //radial blur
        public bool radialBlur = false;
        [Range(0f, 1f)]
        public float radialAmount = 0f;
        [Range(0.02f, 1f)]
        public float radialStrength = 0.5f;

        //chromaticAberration
        public bool chromaticAberration = false;
        public ChromaticAberrationType chromaticAberrationType;
        [Range(0f, 1f)]
        public float chromaAmount = 0;
        public Vector2 redOffset = new Vector2(5, 0);
        public Vector2 blueOffset = new Vector2(-5, 0);

        //flare
        public bool flare;

        //cloud shadow
        public bool cloudShadow = false;
        public Texture cloudTexture;
        public Color cloudShadowColor = Color.gray;
        [Range(0.2f, 8f)]
        public float cloudSize = 0.5f;
        [Range(0.00f, 1f)]
        public float cloudDensity = 0.5f;
        public float cloudSpeed = 0.5f;
        public Vector2 cloudDirection;

        //SSRR
        public bool stochasticScreenSpaceReflection = false;
        [Range(4, 10)]
        public int hierarchicalZLevel = 10;
        public RenderResolution rayCastingResolution = RenderResolution.Full;
        //public RenderResolution rayCastingResolution = RenderResolution.Full;
        [Range(1, 4)]
        public int rayNum = 1;


        public bool Diff(Property other)
        {
            if (this.alphaBuffer != other.alphaBuffer)
                return true;

            if (this.distortion != other.distortion)
                return true;

            if (this.playerLayer != other.playerLayer)
                return true;

            if (this.bloom.Diff(other.bloom))
                return true;
            if (this.alphaBloom.Diff(other.alphaBloom))
                return true;
            if (this.playerBloom.Diff(other.playerBloom))
                return true;
            if (this.sceneToneMap.Diff(other.sceneToneMap))
                return true;
            if (this.alphaToneMap.Diff(other.alphaToneMap))
                return true;
            if (this.playerToneMap.Diff(other.playerToneMap))
                return true;
            if (this.sceneColorGrading.Diff(other.sceneColorGrading))
                return true;
            if (this.alphaColorGrading.Diff(other.alphaColorGrading))
                return true;
            if (this.playerColorGrading.Diff(other.playerColorGrading))
                return true;
            if (this.sceneUserLut.Diff(other.sceneUserLut))
                return true;
            if (this.alphaUserLut.Diff(other.alphaUserLut))
                return true;
            if (this.playerUserLut.Diff(other.playerUserLut))
                return true;

            if (this.sunLight != other.sunLight)
                return true;

            if (this.mask != other.mask || this.overlayColor != other.overlayColor || this.overlayTex != other.overlayTex)
                return true;

            if (this.depthOfField != other.depthOfField || this.focusDistance != other.focusDistance || this.aperture != other.aperture
                || this.focalLength != other.focalLength || this.kernelSize != other.kernelSize )
                return true;

            if (this.dofFast != other.dofFast || this.dofStart != other.dofStart || this.dofDistance != other.dofDistance
               || this.dofRadius != other.dofRadius )
                return true;

            if (this.ambientOcclusion != other.ambientOcclusion || this.aoQuality != other.aoQuality || this.aoRadius != other.aoRadius
               || this.maxRadiusPixels != other.maxRadiusPixels || this.bias != other.bias || this.aoIntensity != other.aoIntensity
               || this.maxDistance != other.maxDistance || this.distanceFalloff != other.distanceFalloff || this.aoColor != other.aoColor
               || this.random != other.random || this.aoBlur != other.aoBlur || this.debugAO != other.debugAO)
                return true;

            if (this.lumaOcclusion != other.lumaOcclusion || this.loThreshold != other.loThreshold || this.loRadius != other.loRadius
              || this.loSamples != other.loSamples || this.loIntensity != other.loIntensity || this.lumaProtect != other.lumaProtect
              || this.loBlur != other.loBlur || this.showLO != other.showLO || this.directional != other.directional
              || this.radian != other.radian )
                return true;

            if (this.volumetricFog != other.volumetricFog || this.fogDensity != other.fogDensity || this.fogHeight != other.fogHeight
              || this.fogBaseHeight != other.fogBaseHeight || this.fogNoiseStrength != other.fogNoiseStrength || this.fogNoiseSparse != other.fogNoiseSparse
              || this.fogNoiseFinalMult != other.fogNoiseFinalMult || this.fogNoiseScale != other.fogNoiseScale || this.fogColor != other.fogColor
              || this.fogSpec != other.fogSpec || this.fogSpecThreshold != other.fogSpecThreshold || this.fogLightColor != other.fogLightColor
              || this.fogCustomDirection != other.fogCustomDirection || this.fogSunDirection != other.fogSunDirection || this.fogWindSpeed != other.fogWindSpeed
              || this.fogWindDirection != other.fogWindDirection || this.fogDownSampling != other.fogDownSampling || this.fogEdgeImprove != other.fogEdgeImprove
              || this.fogStepping != other.fogStepping || this.fogTex != other.fogTex )
                return true;

            if (this.heightFog != other.heightFog || this.heightFogType != other.heightFogType || this.heightFogColor != other.heightFogColor
            || this.heightfogEmissionColor != other.heightfogEmissionColor || this.heightFogHeight != other.heightFogHeight || this.heightFogBaseHeight != other.heightFogBaseHeight
            || this.heightFogFalloff != other.heightFogFalloff || this.heightFogEmissionFalloff != other.heightFogEmissionFalloff
            || this.heightFogAnimation != other.heightFogAnimation || this.heightFogSpeed != other.heightFogSpeed
            || this.heightFogFrequency != other.heightFogFrequency || this.heightFogAmplitude != other.heightFogAmplitude)
                return true;

            if (this.vignette != other.vignette || this.ignoreAlphaBuffer != other.ignoreAlphaBuffer || this.vignetteIntensity != other.vignetteIntensity 
                || this.vignetteSmoothness != other.vignetteSmoothness || this.vignetteRoundness != other.vignetteRoundness || this.vignetteColor != other.vignetteColor)
                return true;

            if (this.border != other.border || this.borderIntensity != other.borderIntensity 
             || this.borderMask != other.borderMask || this.borderColor != other.borderColor || this.borderMaxAlpha != other.borderMaxAlpha
             || this.borderTile != other.borderTile || this.borderTex != other.borderTex)
                return true;

            if (this.radialBlur != other.radialBlur || this.radialAmount != other.radialAmount || this.radialStrength != other.radialStrength)
                return true;

            if (this.cloudShadow != other.cloudShadow || this.cloudTexture != other.cloudTexture || this.cloudShadowColor != other.cloudShadowColor
              || this.cloudSize != other.cloudSize || this.cloudDensity != other.cloudDensity || this.cloudSpeed != other.cloudSpeed || this.cloudDirection != other.cloudDirection)
                return true;

            if (this.chromaticAberration != other.chromaticAberration || this.chromaticAberrationType != other.chromaticAberrationType || this.chromaAmount != other.chromaAmount
                || this.redOffset != other.redOffset || this.blueOffset != other.blueOffset)
                return true;

            if (this.stochasticScreenSpaceReflection != other.stochasticScreenSpaceReflection)
                return true;

            return false;
        }

        public void Assign(Property other)
        {
            this.alphaBuffer = other.alphaBuffer;

            this.distortion = other.distortion;

            this.playerLayer = other.playerLayer;

            this.bloom.Assign(other.bloom);
            this.alphaBloom.Assign(other.alphaBloom);
            this.playerBloom.Assign(other.playerBloom);
            this.sceneToneMap.Assign(other.sceneToneMap);
            this.alphaToneMap.Assign(other.alphaToneMap);
            this.playerToneMap.Assign(other.playerToneMap);
            this.sceneColorGrading.Assign(other.sceneColorGrading);
            this.alphaColorGrading.Assign(other.alphaColorGrading);
            this.playerColorGrading.Assign(other.playerColorGrading);
            this.sceneUserLut.Assign(other.sceneUserLut);
            this.alphaUserLut.Assign(other.alphaUserLut);
            this.playerUserLut.Assign(other.playerUserLut);
            this.sunLight = other.sunLight;

            this.mask = other.mask;
            this.overlayTex = other.overlayTex;
            this.overlayColor = other.overlayColor;

            this.depthOfField = other.depthOfField;
            this.focusDistance = other.focusDistance;
            this.aperture = other.aperture;
            this.focalLength = other.focalLength;
            this.kernelSize = other.kernelSize;

            this.dofFast = other.dofFast;
            this.dofStart = other.dofStart;
            this.dofDistance = other.dofDistance;
            this.dofRadius = other.dofRadius;

            this.ambientOcclusion = other.ambientOcclusion;
            this.aoQuality = other.aoQuality;
            this.aoRadius = other.aoRadius;
            this.maxRadiusPixels = other.maxRadiusPixels;
            this.bias = other.bias;
            this.aoIntensity = other.aoIntensity;
            this.maxDistance = other.maxDistance;
            this.distanceFalloff = other.distanceFalloff;
            this.aoColor = other.aoColor;
            this.random = other.random;
            this.aoBlur = other.aoBlur;
            this.debugAO = other.debugAO;

            this.lumaOcclusion = other.lumaOcclusion;
            this.loThreshold = other.loThreshold;
            this.loRadius = other.loRadius;
            this.loSamples = other.loSamples;
            this.loIntensity = other.loIntensity;
            this.lumaProtect = other.lumaProtect;
            this.loBlur = other.loBlur;
            this.showLO = other.showLO;
            this.directional = other.directional;
            this.radian = other.radian;

            this.volumetricFog = other.volumetricFog;
            this.fogDensity = other.fogDensity;
            this.fogHeight = other.fogHeight;
            this.fogBaseHeight = other.fogBaseHeight;
            this.fogNoiseStrength = other.fogNoiseStrength;
            this.fogNoiseSparse = other.fogNoiseSparse;
            this.fogNoiseFinalMult = other.fogNoiseFinalMult;
            this.fogNoiseScale = other.fogNoiseScale;
            this.fogColor = other.fogColor;
            this.fogSpec = other.fogSpec;
            this.fogSpecThreshold = other.fogSpecThreshold;
            this.fogLightColor = other.fogLightColor;
            this.fogCustomDirection = other.fogCustomDirection;
            this.fogSunDirection = other.fogSunDirection;
            this.fogWindSpeed = other.fogWindSpeed;
            this.fogWindDirection = other.fogWindDirection;
            this.fogDownSampling = other.fogDownSampling;
            this.fogEdgeImprove = other.fogEdgeImprove;
            this.fogStepping = other.fogStepping;
            this.fogTex = other.fogTex;

            this.heightFog = other.heightFog;
            this.heightFogType = other.heightFogType;
            this.heightFogColor = other.heightFogColor;
            this.heightfogEmissionColor = other.heightfogEmissionColor;
            this.heightFogHeight = other.heightFogHeight;
            this.heightFogBaseHeight = other.heightFogBaseHeight;
            this.heightFogFalloff = other.heightFogFalloff;
            this.heightFogEmissionFalloff = other.heightFogEmissionFalloff;
            this.heightFogAnimation = other.heightFogAnimation;
            this.heightFogSpeed = other.heightFogSpeed;
            this.heightFogFrequency = other.heightFogFrequency;
            this.heightFogAmplitude = other.heightFogAmplitude;

            this.vignette = other.vignette;
            this.ignoreAlphaBuffer = other.ignoreAlphaBuffer;
            this.vignetteIntensity = other.vignetteIntensity;
            this.vignetteSmoothness = other.vignetteSmoothness;
            this.vignetteRoundness = other.vignetteRoundness;
            this.vignetteColor = other.vignetteColor;

            this.border = other.border;
            this.borderMask = other.borderMask;
            this.borderColor = other.borderColor;
            this.borderIntensity = other.borderIntensity;
            this.borderMaxAlpha = other.borderMaxAlpha;
            this.borderTile = other.borderTile;
            this.borderTex = other.borderTex;

            this.radialBlur = other.radialBlur;
            this.radialAmount = other.radialAmount;
            this.radialStrength = other.radialStrength;

            this.cloudShadow = other.cloudShadow;
            this.cloudTexture = other.cloudTexture;
            this.cloudShadowColor = other.cloudShadowColor;
            this.cloudSize = other.cloudSize;
            this.cloudDensity = other.cloudDensity;
            this.cloudSpeed = other.cloudSpeed;
            this.cloudDirection = other.cloudDirection;

            this.chromaticAberration = other.chromaticAberration;
            this.chromaticAberrationType = other.chromaticAberrationType;
            this.chromaAmount = other.chromaAmount;
            this.redOffset = other.redOffset;
            this.blueOffset = other.blueOffset;

            this.stochasticScreenSpaceReflection = other.stochasticScreenSpaceReflection;
        }
    };
    #endregion

    #region insideProperty

    public class BloomParam
    {       
        public Vector4 blackBloomCurve;

        public const int maxIterations = 8;
        public int[] blurBuffer1;
        public int[] blurBuffer2;
        public RenderTexture[] blurTex1;
        public RenderTexture[] blurTex2;

        public BloomParam()
        {
            this.blackBloomCurve = new Vector4(10, 0, 0, 10);
            this.blurBuffer1 = new int[maxIterations] { 0, 0, 0, 0, 0, 0, 0, 0 };
            this.blurBuffer2 = new int[maxIterations] { 0, 0, 0, 0, 0, 0, 0, 0 };
            this.blurTex1 = new RenderTexture[maxIterations] ;
            this.blurTex2 = new RenderTexture[maxIterations] ;
        }
    }

    public class ColorGradingParam
    {
        //color grading
        public static int lutSize = 32;
        public RenderTexture internalLutTex = null;
        public int adaptLumID;
        public Texture2D curveTexture = null;
        public HableCurve hableCurve = new HableCurve();
    }


    //[SerializeField]
    //[NonSerialized]
    public Property mProperty;

    private Property oldProperty = new Property();

    //bloom
    [NonSerialized]
    public BloomParam bloomParam = new BloomParam();

    //color grading
    [NonSerialized]
    public ColorGradingParam sceneColorGradingParam = new ColorGradingParam();
    [NonSerialized]
    public ColorGradingParam alphaColorGradingParam = new ColorGradingParam();
    [NonSerialized]
    public ColorGradingParam playerColorGradingParam = new ColorGradingParam();

    [NonSerialized] public Material mMaterialOpaque = null;
    [NonSerialized] public Material mMaterialBloom = null;
    [NonSerialized] public Material mMaterialPlayerBloom = null;
    [NonSerialized] public Material mMaterialAlphaBloom = null;
    [NonSerialized] public Material mMaterialDownSample = null;
    [NonSerialized] public Material mMaterialDOF = null;
    [NonSerialized] public Material mMaterialSceneGenLut = null;
    [NonSerialized] public Material mMaterialAlphaGenLut = null;
    [NonSerialized] public Material mMaterialPlayerGenLut = null;
    [NonSerialized] public Material mMaterialRadialBlur = null;
    [NonSerialized] public Material mMaterialAmbientOcclusion = null;
    [NonSerialized] public Material mMaterialVolumetricFog = null;
    [NonSerialized] public Material mMaterialHeightFog = null;
    [NonSerialized] public Material mMaterialLumaOcclusion = null;
    [NonSerialized] public Material mMaterialCloudShadow = null;
    [NonSerialized] public Material mMaterialStochasticSSR = null;
    [NonSerialized] public Material mMaterialFXAA = null;

    public Material uberMaterial = null;

    //depth of field
    [NonSerialized] public RenderTextureFormat cocFormat = RenderTextureFormat.Default;
    [NonSerialized] public Vector4 depthOfFieldParams = new Vector4();

    //radial
    [Range(0f, 1f)]
    public float radialAmount = 0f;
    [Range(0.02f, 1f)]
    public float radialStrength = 0.5f;

    [Range(0f, 1f)]
    public float chromaAmount = 0f;

    [Range(0f, 1f)]
    public float colorOffset = 0f;
    public float oldColorOffset = 0f;

    //border
    [Range(0f, 1f)]
    public float borderFactor = 0f;

    //hbao
    protected Texture2D aoNoiseTex;

    //fog
    protected Texture2D fogNoiseTex;
    protected int lastFrameCount;
    protected Vector3 fogWindDir;
    protected RenderTargetIdentifier[] mrt;
    protected Vector3 fogSunDirection;
    protected Color[] noiseColors;
    protected Color[] adjustedColors;
    protected Texture2D oldFogTex;

    //SSSR
    protected RenderTargetIdentifier[] sssrMrt;

    //luma
    private Vector4 lumaFarams = new Vector4();

    public Camera cam = null;
    private PlayerGraphicsSetting graphicsSetting = null;

    public RenderTextureFormat hdrFormat;
    public RenderTextureFormat singleChannelFormat;

    #endregion

    void OnEnable()
    {
        GameObject setting = GameObject.Find("PlayerGraphicsSetting");
        if (setting)
            graphicsSetting = setting.GetComponent<PlayerGraphicsSetting>();

        cam = GetComponent<Camera>();      

        hdrFormat = CommonSet.SelectFormat(RenderTextureFormat.RGB111110Float, RenderTextureFormat.ARGBHalf);
        singleChannelFormat = CommonSet.SelectFormat(RenderTextureFormat.R8, RenderTextureFormat.RHalf);     

        if (mProperty == null)
            mProperty = new Property();

        oldProperty = new Property();

        CreateMaterial();
        UpdatePostProcess();
    }

    void OnDestroy()
    {
        DeleteColorGradingResource();
        DeleteMaterial();
        DeleteHBAOResources();
        DeleteVolumetricFogResources();
    }

    void CreateMaterial()
    {  
        CommonSet.CreateMaterial("Hidden/DragonBloom", ref mMaterialBloom);
        CommonSet.CreateMaterial("Hidden/DragonBloom", ref mMaterialPlayerBloom);
        CommonSet.CreateMaterial("Hidden/DragonBloom", ref mMaterialAlphaBloom);
        CommonSet.CreateMaterial("Hidden/DragonDownSample", ref mMaterialDownSample);
        CommonSet.CreateMaterial("Hidden/DragonDepthOfFieldFast", ref mMaterialDOF); 
        CommonSet.CreateMaterial("Hidden/DragonRadialBlur", ref mMaterialRadialBlur);
        CommonSet.CreateMaterial("Hidden/DragonFXAA", ref mMaterialFXAA);
        CommonSet.CreateMaterial("Hidden/DragonOpaquePostProcess", ref mMaterialOpaque);
        CommonSet.CreateMaterial("Hidden/DragonHBAO", ref mMaterialAmbientOcclusion);
        CommonSet.CreateMaterial("Hidden/DragonHeightFog", ref mMaterialHeightFog);
        CommonSet.CreateMaterial("Hidden/DragonVolumetricFog", ref mMaterialVolumetricFog);
        CommonSet.CreateMaterial("Hidden/DragonLumaOcclusion", ref mMaterialLumaOcclusion);
        CommonSet.CreateMaterial("Hidden/DragonCloudShadow", ref mMaterialCloudShadow);
        CommonSet.CreateMaterial("Hidden/DragonGenLut", ref mMaterialSceneGenLut);
        CommonSet.CreateMaterial("Hidden/DragonGenLut", ref mMaterialAlphaGenLut);
        CommonSet.CreateMaterial("Hidden/DragonGenLut", ref mMaterialPlayerGenLut);
        CommonSet.CreateMaterial("Hidden/DragonStochasticSSR", ref mMaterialStochasticSSR);
    }

    void DeleteMaterial()
    {
        CommonSet.DeleteMaterial(ref mMaterialOpaque);
        CommonSet.DeleteMaterial(ref mMaterialBloom);
        CommonSet.DeleteMaterial(ref mMaterialPlayerBloom);
        CommonSet.DeleteMaterial(ref mMaterialAlphaBloom);
        CommonSet.DeleteMaterial(ref mMaterialDownSample);
        CommonSet.DeleteMaterial(ref mMaterialAmbientOcclusion);
        CommonSet.DeleteMaterial(ref mMaterialVolumetricFog);
        CommonSet.DeleteMaterial(ref mMaterialHeightFog);
        CommonSet.DeleteMaterial(ref mMaterialLumaOcclusion);
        CommonSet.DeleteMaterial(ref mMaterialSceneGenLut);
        CommonSet.DeleteMaterial(ref mMaterialAlphaGenLut);
        CommonSet.DeleteMaterial(ref mMaterialPlayerGenLut);
        CommonSet.DeleteMaterial(ref mMaterialCloudShadow);
        CommonSet.DeleteMaterial(ref mMaterialDOF);
        CommonSet.DeleteMaterial(ref mMaterialRadialBlur);
        CommonSet.DeleteMaterial(ref mMaterialStochasticSSR);
        CommonSet.DeleteMaterial(ref mMaterialFXAA);
    }

    public void SetProperty(Property property)
    {
        mProperty = property;
        DeleteColorGradingResource();
        if (enabled)
            UpdatePostProcess();
    }

    public virtual void UpdatePostProcess()
    {
        cam = GetComponent<Camera>();

        cam.allowMSAA = false;

        InitBloom();
        InitAmbientOcclusion();
        InitCloudShadow();
        InitVolumetricFog();
        InitHeightFog();
        InitDepthOfFiled();
        InitColorGrading();
        InitMask();
        InitVignette();
        InitRadialBlur();
        InitBorder();
        InitLumaOcclusion();
        InitChromaticAberration();
        InitAntiAliasing();
        InitDistortion();
    }

    #region colorGradingFunc
    private float StandardIlluminantY(float x)
    {
        return 2.87f * x - 3f * x * x - 0.27509507f;
    }
    // CIE xy chromaticity to CAT02 LMS.
    // http://en.wikipedia.org/wiki/LMS_color_space#CAT02
    private Vector3 CIExyToLMS(float x, float y)
    {
        float Y = 1f;
        float X = Y * x / y;
        float Z = Y * (1f - x - y) / y;

        float L = 0.7328f * X + 0.4296f * Y - 0.1624f * Z;
        float M = -0.7036f * X + 1.6975f * Y + 0.0061f * Z;
        float S = 0.0030f * X + 0.0136f * Y + 0.9834f * Z;

        return new Vector3(L, M, S);
    }
    private Vector3 GetWhiteBalance(ref Property.ColorGradingProperty mProperty)
    {
        float t1 = mProperty.temperatureShift;
        float t2 = mProperty.tint;

        // Get the CIE xy chromaticity of the reference white point.
        // Note: 0.31271 = x value on the D65 white point
        float x = 0.31271f - t1 * (t1 < 0f ? 0.1f : 0.05f);
        float y = StandardIlluminantY(x) + t2 * 0.05f;

        // Calculate the coefficients in the LMS space.
        Vector3 w1 = new Vector3(0.949237f, 1.03542f, 1.08728f); // D65 white point
        Vector3 w2 = CIExyToLMS(x, y);
        return new Vector3(w1.x / w2.x, w1.y / w2.y, w1.z / w2.z);
    }

    public static Vector3 ColorToLift(Vector4 color)
    {
        // Shadows
        var S = new Vector3(color.x, color.y, color.z);
        float lumLift = S.x * 0.2126f + S.y * 0.7152f + S.z * 0.0722f;
        S = new Vector3(S.x - lumLift, S.y - lumLift, S.z - lumLift);

        float liftOffset = color.w;
        return new Vector3(S.x + liftOffset, S.y + liftOffset, S.z + liftOffset);
    }

    public static Vector3 ColorToInverseGamma(Vector4 color)
    {
        // Midtones
        var M = new Vector3(color.x, color.y, color.z);
        float lumGamma = M.x * 0.2126f + M.y * 0.7152f + M.z * 0.0722f;
        M = new Vector3(M.x - lumGamma, M.y - lumGamma, M.z - lumGamma);

        float gammaOffset = color.w + 1f;
        return new Vector3(
            1f / Mathf.Max(M.x + gammaOffset, 1e-03f),
            1f / Mathf.Max(M.y + gammaOffset, 1e-03f),
            1f / Mathf.Max(M.z + gammaOffset, 1e-03f)
        );
    }

    public static Vector3 ColorToGain(Vector4 color)
    {
        // Highlights
        var H = new Vector3(color.x, color.y, color.z);
        float lumGain = H.x * 0.2126f + H.y * 0.7152f + H.z * 0.0722f;
        H = new Vector3(H.x - lumGain, H.y - lumGain, H.z - lumGain);

        float gainOffset = color.w + 1f;
        return new Vector3(H.x + gainOffset, H.y + gainOffset, H.z + gainOffset);
    }

    private void GenCurveTexture(ref Property.ColorGradingProperty mProperty,ref ColorGradingParam param)
    {
        if (param.curveTexture == null)
        {
            param.curveTexture = new Texture2D(Spline.k_Precision, 2, TextureFormat.RGBAHalf, false, true)
            {
                name = "Curve texture",
                wrapMode = TextureWrapMode.Clamp,
                filterMode = FilterMode.Bilinear,
                anisoLevel = 0,
                hideFlags = HideFlags.DontSave
            };
        }

        var hueVsHueCurve = mProperty.curves.hueVsHueCurve;
        var hueVsSatCurve = mProperty.curves.hueVsSatCurve;
        var satVsSatCurve = mProperty.curves.satVsSatCurve;
        var lumVsSatCurve = mProperty.curves.lumVsSatCurve;

        Color[] pixels = new Color[Spline.k_Precision * 2];

        for (int i = 0; i < Spline.k_Precision; i++)
        {
            float x = hueVsHueCurve.cachedData[i];
            float y = hueVsSatCurve.cachedData[i];
            float z = satVsSatCurve.cachedData[i];
            float w = lumVsSatCurve.cachedData[i];
            pixels[i] = new Color(0.5f, 0.5f, 0.5f, 0.5f);
        }

        param.curveTexture.SetPixels(pixels);
        param.curveTexture.Apply(false,false);
    }
    void DeleteColorGradingResource()
    {
        CommonSet.DeleteTexture(ref sceneColorGradingParam.curveTexture);
        CommonSet.DeleteRenderTexture(ref sceneColorGradingParam.internalLutTex);

        CommonSet.DeleteTexture(ref alphaColorGradingParam.curveTexture);
        CommonSet.DeleteRenderTexture(ref alphaColorGradingParam.internalLutTex);

        CommonSet.DeleteTexture(ref playerColorGradingParam.curveTexture);
        CommonSet.DeleteRenderTexture(ref playerColorGradingParam.internalLutTex);
    }
    public void CreateLut(CommandBuffer cb,Material material, Property.ToneMapProperty toneMapProperty,Property.ColorGradingProperty colorGradingProperty, Property.UserLutProperty userLutProperty, ref ColorGradingParam param,bool enable)
    {              
        if(!enable)
        {
            CommonSet.DeleteTexture(ref param.curveTexture);
            //CommonSet.DeleteTexture(ref lut);
            CommonSet.DeleteRenderTexture(ref param.internalLutTex);
            return;
        }
        //if (UnityEngine.Profiling.Profiler.enabled)
         //   return;

        if (Application.isEditor || param.internalLutTex == null)
        {
            InitInternalLut(ref param);

            if (userLutProperty.userLut && userLutProperty.contribution > 0)
            {
                material.SetTexture(CommonSet.ShaderProperties.userLutTex, userLutProperty.lutTex);
                material.SetVector(CommonSet.ShaderProperties.lutParams, new Vector4(1.0f / (ColorGradingParam.lutSize * ColorGradingParam.lutSize), 1.0f / ColorGradingParam.lutSize, ColorGradingParam.lutSize - 1.0f, userLutProperty.contribution));
                material.EnableKeyword("LUT2D");
            }
            else
            {
                material.DisableKeyword("LUT2D");
            }

            material.SetVector(CommonSet.ShaderProperties.userLutParams, new Vector4(ColorGradingParam.lutSize, 0.5f / (ColorGradingParam.lutSize * ColorGradingParam.lutSize), 0.5f / ColorGradingParam.lutSize, ColorGradingParam.lutSize / (ColorGradingParam.lutSize - 1f)));                

            if(colorGradingProperty.colorGrading)
            {
                material.SetVector(CommonSet.ShaderProperties.whiteBalance, GetWhiteBalance(ref colorGradingProperty));
                material.SetVector(CommonSet.ShaderProperties.colorFilter, colorGradingProperty.colorFilter);
                material.SetVector(CommonSet.ShaderProperties.hsc, new Vector4(colorGradingProperty.hue, colorGradingProperty.saturation, colorGradingProperty.contrast));
                material.SetVector(CommonSet.ShaderProperties.channelMixerRed, colorGradingProperty.channelMixer.channels[0]);
                material.SetVector(CommonSet.ShaderProperties.channelMixerGreen, colorGradingProperty.channelMixer.channels[1]);
                material.SetVector(CommonSet.ShaderProperties.channelMixerBlue, colorGradingProperty.channelMixer.channels[2]);

                material.SetVector(CommonSet.ShaderProperties.lift, ColorToLift(colorGradingProperty.colorWheels.shadows * 0.2f));
                material.SetVector(CommonSet.ShaderProperties.invGamma, ColorToInverseGamma(colorGradingProperty.colorWheels.midtones * 0.8f));
                material.SetVector(CommonSet.ShaderProperties.gain, ColorToGain(colorGradingProperty.colorWheels.highlights * 0.8f));
            }
            else
            {
                material.SetVector(CommonSet.ShaderProperties.whiteBalance, new Vector4(1, 1, 1, 0));
                material.SetVector(CommonSet.ShaderProperties.colorFilter, Color.white);
                material.SetVector(CommonSet.ShaderProperties.hsc, new Vector4(0, 1, 1, 0));
                material.SetVector(CommonSet.ShaderProperties.channelMixerRed, new Vector4(1, 0, 0, 0));
                material.SetVector(CommonSet.ShaderProperties.channelMixerGreen, new Vector4(0, 1, 0, 0));
                material.SetVector(CommonSet.ShaderProperties.channelMixerBlue, new Vector4(0, 0, 1, 0));

                material.SetVector(CommonSet.ShaderProperties.lift, new Vector4(0, 0, 0, 0));
                material.SetVector(CommonSet.ShaderProperties.invGamma, new Vector4(1, 1, 1, 0));
                material.SetVector(CommonSet.ShaderProperties.gain, new Vector4(1, 1, 1, 0));               
            }           

            GenCurveTexture(ref colorGradingProperty, ref param);
            material.SetTexture(CommonSet.ShaderProperties.curveTex, param.curveTexture);

            material.DisableKeyword("TONEMAPPING_ACES");
            material.DisableKeyword("TONEMAPPING_FILMIC");
            material.DisableKeyword("TONEMAPPING_CUSTOM");

            if (toneMapProperty.toneMapping)
            {
                if (toneMapProperty.toneMappingType == Property.ToneMappingType.ACES)
                {
                    material.EnableKeyword("TONEMAPPING_ACES");
                    material.DisableKeyword("TONEMAPPING_FILMIC");
                    material.DisableKeyword("TONEMAPPING_CUSTOM");
                }
                else if (toneMapProperty.toneMappingType == Property.ToneMappingType.FILMIC)
                {
                    material.DisableKeyword("TONEMAPPING_ACES");
                    material.EnableKeyword("TONEMAPPING_FILMIC");
                    material.DisableKeyword("TONEMAPPING_CUSTOM");
                }
                else if (toneMapProperty.toneMappingType == Property.ToneMappingType.CUSTOM)
                {
                    material.DisableKeyword("TONEMAPPING_ACES");
                    material.DisableKeyword("TONEMAPPING_FILMIC");
                    material.EnableKeyword("TONEMAPPING_CUSTOM");

                    param.hableCurve.Init(toneMapProperty.toneCurveToeStrength, toneMapProperty.toneCurveToeLength, toneMapProperty.toneCurveShoulderStrength,
                        toneMapProperty.toneCurveShoulderLength, toneMapProperty.toneCurveShoulderAngle, toneMapProperty.toneCurveGamma);

                    material.SetVector(CommonSet.ShaderProperties.customToneCurve, param.hableCurve.uniforms.curve);
                    material.SetVector(CommonSet.ShaderProperties.toeSegmentA, param.hableCurve.uniforms.toeSegmentA);
                    material.SetVector(CommonSet.ShaderProperties.toeSegmentB, param.hableCurve.uniforms.toeSegmentB);
                    material.SetVector(CommonSet.ShaderProperties.midSegmentA, param.hableCurve.uniforms.midSegmentA);
                    material.SetVector(CommonSet.ShaderProperties.midSegmentB, param.hableCurve.uniforms.midSegmentB);
                    material.SetVector(CommonSet.ShaderProperties.shoSegmentA, param.hableCurve.uniforms.shoSegmentA);
                    material.SetVector(CommonSet.ShaderProperties.shoSegmentB, param.hableCurve.uniforms.shoSegmentB);
                }
            }

            param.internalLutTex.MarkRestoreExpected();
            cb.SetRenderTarget(param.internalLutTex);
            cb.DrawMesh(CommonSet.fullscreenTriangle, Matrix4x4.identity, material,0, (int)GenLutPass.GenLut);
             
          //  RenderTexture old = RenderTexture.active;
         //   RenderTexture.active = param.internalLutTex;
         //   lut.ReadPixels(new Rect(0f, 0f, param.internalLutTex.width, param.internalLutTex.height), 0, 0);
          //  lut.Apply();
          //  RenderTexture.active = old;
        }       
    }

    public void InitInternalLut(ref ColorGradingParam param)
    {
        int lutSize = ColorGradingParam.lutSize;            

        if (param.internalLutTex == null)
        {
            RenderTextureFormat format = EnvironmentManager.Instance.halfFormat;
            param.internalLutTex = new RenderTexture(lutSize * lutSize, lutSize, 0, format, RenderTextureReadWrite.Linear)
            {
                name = "Internal LUT",
                filterMode = FilterMode.Bilinear,
                wrapMode = TextureWrapMode.Clamp,
                anisoLevel = 0,
                hideFlags = HideFlags.DontSave,
                autoGenerateMips = false,
                useMipMap = false
            };
        } 
    }

    public void GetLutTex(CommandBuffer cb)
    {
        CreateLut(cb, mMaterialSceneGenLut, mProperty.sceneToneMap, mProperty.sceneColorGrading, mProperty.sceneUserLut, ref sceneColorGradingParam, SceneColorLookupEnable());
        CreateLut(cb, mMaterialPlayerGenLut, mProperty.playerToneMap, mProperty.playerColorGrading, mProperty.playerUserLut, ref playerColorGradingParam, PlayerColorLookupEnable());
        CreateLut(cb, mMaterialAlphaGenLut, mProperty.alphaToneMap, mProperty.alphaColorGrading, mProperty.alphaUserLut, ref alphaColorGradingParam, AlphaColorLookupEnable());
    }

    #endregion

    #region hbao
    public static class MersenneTwister
    {
        // Mersenne-Twister random numbers in [0,1).
        public static float[] Numbers = new float[] {
            0.463937f,0.340042f,0.223035f,0.468465f,0.322224f,0.979269f,0.031798f,0.973392f,0.778313f,0.456168f,0.258593f,0.330083f,0.387332f,0.380117f,0.179842f,0.910755f,
            0.511623f,0.092933f,0.180794f,0.620153f,0.101348f,0.556342f,0.642479f,0.442008f,0.215115f,0.475218f,0.157357f,0.568868f,0.501241f,0.629229f,0.699218f,0.707733f
        };
    }

    public void CreateHBAONoiseTex()
    {
        aoNoiseTex = new Texture2D(4, 4, TextureFormat.RGB24, false, true);
        aoNoiseTex.filterMode = FilterMode.Point;
        aoNoiseTex.wrapMode = TextureWrapMode.Repeat;
        int z = 0;
        for (int x = 0; x < 4; ++x)
        {
            for (int y = 0; y < 4; ++y)
            {
                float r1 = MersenneTwister.Numbers[z++];
                float r2 = MersenneTwister.Numbers[z++];
                float angle = 2.0f * Mathf.PI * r1 / 3;
                Color color = new Color(Mathf.Cos(angle), Mathf.Sin(angle), r2);
                aoNoiseTex.SetPixel(x, y, color);
            }
        }
        aoNoiseTex.Apply();
    }

    private void DeleteHBAOResources()
    {
        CommonSet.DeleteTexture(ref aoNoiseTex);
    }

    /*
    private void CreateNoiseTex()
    {
        aoNoiseTex = new Texture2D(64, 64, TextureFormat.RGB24, false, true);
        aoNoiseTex.filterMode = FilterMode.Point;
        aoNoiseTex.wrapMode = TextureWrapMode.Repeat;
        int z = 0;
        for (int x = 0; x < 64; ++x)
        {
            for (int y = 0; y < 64; ++y)
            {
                float r1 = UnityEngine.Random.Range(0.0f, 1.0f);
                float r2 = UnityEngine.Random.Range(0.0f, 1.0f);
                float angle = 2.0f * Mathf.PI * r1 / 3;
                Color color = new Color(Mathf.Cos(angle), Mathf.Sin(angle), r2);
                aoNoiseTex.SetPixel(x, y, color);
            }
        }
        aoNoiseTex.Apply();
    }
    */
    #endregion

    #region volumetricFOG

    public int GetScaledSize(int size, float factor)
    {
        size = (int)(size / factor);
        size /= 4;
        if (size < 1)
            size = 1;
        return size * 4;
    }

    public void CreateFogNoiseTex()
    {
        if (oldFogTex != mProperty.fogTex || noiseColors == null || adjustedColors == null)
        {
            noiseColors = mProperty.fogTex.GetPixels();
            adjustedColors = new Color[noiseColors.Length];
            oldFogTex = mProperty.fogTex;
        }

        float fogNoise = Mathf.Clamp(mProperty.fogNoiseStrength, 0, 0.95f);     // clamped to prevent flat fog on top
        for (int k = 0; k < adjustedColors.Length; k++)
        {
            float t = 1.0f - (mProperty.fogNoiseSparse + noiseColors[k].b) * fogNoise;
            t *= mProperty.fogDensity * mProperty.fogNoiseFinalMult;
            t = Mathf.Clamp01(t);
            adjustedColors[k].a = t;
        }

        Vector3 nlight;
        int nz, disp;
        float nyspec;
        float spec = 1.0001f - mProperty.fogSpecThreshold;
        int tw = mProperty.fogTex.width;

        nlight = new Vector3(-fogSunDirection.x, 0, -fogSunDirection.z).normalized * 0.3f;
        nlight.y = fogSunDirection.y > 0 ? Mathf.Clamp01(1.0f - fogSunDirection.y) : 1.0f - Mathf.Clamp01(-fogSunDirection.y);
        nz = Mathf.FloorToInt(nlight.z * tw) * tw;
        disp = (int)(nz + nlight.x * tw) + adjustedColors.Length;
        nyspec = nlight.y / spec;

        int count = adjustedColors.Length;
        int k0 = 0;
        int k1 = count;

        int z = 0;
        bool hasChanged = false;
        for (int k = k0; k < k1; k++)
        {
            int indexg = (k + disp) % count;
            float a = adjustedColors[k].a;
            float r = (a - adjustedColors[indexg].a) * nyspec;
            r = Mathf.Clamp01(r);

            Color newcolor;
            newcolor = mProperty.fogLightColor * 0.5f + mProperty.fogSpec * r * 0.5f;
            newcolor.a = a;


            if (!hasChanged)
            {
                if (z++ < 100)
                {
                    if (newcolor != adjustedColors[k])
                        hasChanged = true;
                }
                else if (!hasChanged)
                    break;
            }

            adjustedColors[k] = newcolor;
        }

        //if (hasChanged)
        {
            DeleteVolumetricFogResources();
            if (fogNoiseTex == null || fogNoiseTex.width != mProperty.fogTex.width || fogNoiseTex.height != mProperty.fogTex.height)
            {
                fogNoiseTex = new Texture2D(mProperty.fogTex.width, mProperty.fogTex.height, TextureFormat.RGBA32, true);
                fogNoiseTex.hideFlags = HideFlags.DontSave;
            }

            fogNoiseTex.SetPixels(adjustedColors);
            fogNoiseTex.Apply();
        }
    }

    private void DeleteVolumetricFogResources()
    {
        CommonSet.DeleteTexture(ref fogNoiseTex);
    }
    #endregion

    #region init
    public void InitLowwwer()
    {
        if(!EnvironmentManager.Instance.isSupportDepthTex)
        {
            mProperty.alphaBuffer = false;
            mProperty.distortion = false;
            mProperty.playerLayer = false;
            mProperty.volumetricFog = false;
            mProperty.lumaOcclusion = false;
            mProperty.ambientOcclusion = false;
           // mProperty.border = false;
           // mProperty.radialBlur = false;
            mProperty.cloudShadow = false;
            mProperty.depthOfField = false;
            mProperty.dofFast = false;
            mProperty.antialiasing = false;
          //  mProperty.bloom.bloom = false;          
        }
    }    
    void InitBloom()
    {
        bool sceneBloomOn = SceneBloomEnable();
        bool alphaBloomOn = AlphaBloomEnable();
        bool playBloomOn = PlayerBloomEnable();

        SetBloom(mMaterialBloom, mProperty.bloom, sceneBloomOn);
        SetBloom(mMaterialAlphaBloom, mProperty.alphaBloom , alphaBloomOn);    
        SetBloom(mMaterialPlayerBloom, mProperty.playerBloom, playBloomOn);

        if(PlayerLayerEnable())
        {
            CommonSet.SetMaterialKeyword(ref mMaterialBloom, "SCENE", true);
            CommonSet.SetMaterialKeyword(ref mMaterialPlayerBloom, "PLAYER", true);
        }
        else
        {
            CommonSet.SetMaterialKeyword(ref mMaterialBloom, "SCENE", false);
            CommonSet.SetMaterialKeyword(ref mMaterialBloom, "PLAYER", false);
            CommonSet.SetMaterialKeyword(ref mMaterialPlayerBloom, "PLAYER", false);
        }              
       
        CommonSet.SetMaterialKeyword(ref uberMaterial, "ALPHABLOOM", alphaBloomOn);
        CommonSet.SetMaterialKeyword(ref uberMaterial, "BLOOM", sceneBloomOn);
        CommonSet.SetMaterialKeyword(ref uberMaterial, "PLAYERBLOOM", playBloomOn);

        uberMaterial.SetFloat(CommonSet.ShaderProperties.bloomIntensity, mProperty.bloom.bloomIntensity);
        uberMaterial.SetFloat(CommonSet.ShaderProperties.alphaBloomIntensity, mProperty.alphaBloom.bloomIntensity);
        uberMaterial.SetFloat(CommonSet.ShaderProperties.playerBloomIntensity, mProperty.playerBloom.bloomIntensity);
        mMaterialPlayerBloom.SetFloat(CommonSet.ShaderProperties.playerBloomIntensity, mProperty.playerBloom.bloomIntensity);
    }
    void SetBloom(Material bloomMaterial,Property.BloomProperty property,bool enable)
    {
        if (bloomMaterial == null)
            return;
        if (enable)
        {
            float threshold = property.bloomThreshold;
            //mProperty.sceneBloomSoftKnee = 0.5f;
            float knee = threshold * property.bloomSoftKnee + 1e-5f;
            Vector4 bloomCurve = new Vector4(threshold - knee, knee * 2, 0.25f / knee, threshold);
            bloomMaterial.SetVector(CommonSet.ShaderProperties.bloomCurve, bloomCurve);
        }
        else
        {
            bloomMaterial.SetVector(CommonSet.ShaderProperties.bloomCurve, new Vector4(10,0,0,100));
        }      
    }    
    void InitAmbientOcclusion()
    {
        if (AmbientOcclusionEnable())
        {
            // mMaterialAmbientOcclusion.SetFloat("_MaxRadiusPixels", mProperty.maxRadiusPixels);
            mMaterialAmbientOcclusion.SetFloat(CommonSet.ShaderProperties.negInvRadius2, -1.0f / (mProperty.aoRadius * mProperty.aoRadius));
            mMaterialAmbientOcclusion.SetFloat(CommonSet.ShaderProperties.angleBias, mProperty.bias);
            mMaterialAmbientOcclusion.SetFloat(CommonSet.ShaderProperties.aoMultiplier, 2.0f * (1.0f / (1.0f - mProperty.bias)));
            mMaterialOpaque.SetFloat(CommonSet.ShaderProperties.aoIntensity, mProperty.aoIntensity);
            mMaterialAmbientOcclusion.SetFloat(CommonSet.ShaderProperties.maxDistance, mProperty.maxDistance);
            // mMaterialAmbientOcclusion.SetFloat("_DistanceFalloff", mProperty.distanceFalloff);

            mMaterialOpaque.SetColor(CommonSet.ShaderProperties.aoColor, mProperty.aoColor.linear);
            //mMaterialAmbientOcclusion.SetFloat(ShaderProperties.blurSharpness, mProperty.sharpness);

            //mMaterialAmbientOcclusion.SetVector(ShaderProperties.aoBlurOffset, new Vector4(1.0f/cam.pixelWidth , 1.0f/cam.pixelHeight , 0,0));
            if(mProperty.debugAO)
            {
                mMaterialOpaque.EnableKeyword("HBAO_DEBUG");
                mMaterialOpaque.DisableKeyword("HBAO");
            }
            else
            {
                mMaterialOpaque.DisableKeyword("HBAO_DEBUG");
                mMaterialOpaque.EnableKeyword("HBAO");
            }           
        }
        else
        {
            mMaterialOpaque.DisableKeyword("HBAO_DEBUG");
            mMaterialOpaque.DisableKeyword("HBAO");
        }
    }
    void InitCloudShadow()
    {
        bool enable = CloudShadowEnable();
        if (enable)
        {
            if (mProperty.cloudTexture)
                mMaterialOpaque.SetTexture(CommonSet.ShaderProperties.cloudShadowTex, mProperty.cloudTexture);

            mMaterialOpaque.SetColor(CommonSet.ShaderProperties.cloudShadowColor, mProperty.cloudShadowColor.linear);
            Vector4 vec = new Vector4(mProperty.cloudSize * 0.01f, mProperty.cloudDensity, mProperty.cloudDirection.x * mProperty.cloudSpeed, mProperty.cloudDirection.y * mProperty.cloudSpeed);
            mMaterialOpaque.SetVector(CommonSet.ShaderProperties.cloudShadowParams, vec);
        }

        CommonSet.SetMaterialKeyword(ref mMaterialOpaque, "CLOUDSHADOW", enable);
    }
    void InitVolumetricFog()
    {
        bool enable = VolumetricFogEnable();
        if (enable)
        {
            if (mProperty.sunLight && !mProperty.fogCustomDirection)
            {
                fogSunDirection = mProperty.sunLight.transform.forward;
            }
            else
            {
                fogSunDirection = mProperty.fogSunDirection;
            }

            CreateFogNoiseTex();

            mMaterialVolumetricFog.SetTexture(CommonSet.ShaderProperties.fogNoiseTex, fogNoiseTex);
            mMaterialVolumetricFog.SetVector(CommonSet.ShaderProperties.volumetricFogColor, mProperty.fogColor);
            Vector4 fogStep = new Vector4(1.0f / (mProperty.fogStepping + 1), 0, 0, 0);
            mMaterialVolumetricFog.SetVector(CommonSet.ShaderProperties.fogStep, fogStep);
            mMaterialVolumetricFog.SetVector(CommonSet.ShaderProperties.fogData, new Vector4(mProperty.fogBaseHeight, mProperty.fogHeight, 1.0f / mProperty.fogDensity, 0.01f / mProperty.fogNoiseScale));
        }

       // CommonSet.SetMaterialKeyword(ref mMaterialOpaque, "VFOG", enable);
    }
    void InitStochasticSSR()
    {
        bool enable = StochasticSSREnable();
        if (enable)
        {
            mMaterialStochasticSSR.SetInt(CommonSet.ShaderProperties.rayNum, mProperty.rayNum);     
            
        }
    }
    void InitHeightFog()
    {
        bool enable = HeightFogEnable();

        if(enable)
        {
            Shader.SetGlobalColor(CommonSet.ShaderProperties.heightFogColor, mProperty.heightFogColor);
            Shader.SetGlobalColor(CommonSet.ShaderProperties.heightFogEmissionColor, mProperty.heightfogEmissionColor);
            Shader.SetGlobalVector(CommonSet.ShaderProperties.heightFogParam, new Vector4(mProperty.heightFogBaseHeight, mProperty.heightFogHeight, mProperty.heightFogFalloff, mProperty.heightFogEmissionFalloff));
            Shader.SetGlobalVector(CommonSet.ShaderProperties.heightFogWave0, new Vector4(mProperty.heightFogSpeed.x, mProperty.heightFogSpeed.y, mProperty.heightFogFrequency.x, mProperty.heightFogFrequency.y));
            Shader.SetGlobalVector(CommonSet.ShaderProperties.heightFogWave1, new Vector4(mProperty.heightFogAmplitude.x, mProperty.heightFogAmplitude.y, 0, mProperty.heightFogAnimation ? 1 : -1));

            CommonSet.SetMaterialKeyword(ref mMaterialHeightFog, "ANIMATION", mProperty.heightFogType == Property.HeightFogType.POSTPROCESS && mProperty.heightFogAnimation);

            if(mProperty.heightFogType == Property.HeightFogType.VERTEX)
            {
                Shader.EnableKeyword("_HEIGHTFOG");
            }
            else
                Shader.DisableKeyword("_HEIGHTFOG");
        }
        else
            Shader.DisableKeyword("_HEIGHTFOG");      
    }
    void InitDepthOfFiled()
    {
        cocFormat = CommonSet.SelectFormat(RenderTextureFormat.R8, RenderTextureFormat.RHalf);
        //bokeh DOF
        /*
        if (mProperty.depthOfField)
        {         
            const float k_FilmHeight = 0.024f;
            float f = mProperty.focalLength / 1000f;
            float s1 = Mathf.Max(mProperty.focusDistance, f);
            float coeff = f * f / (mProperty.aperture * (s1 - f) * k_FilmHeight * 2);

            depthOfFieldParams.x = s1;
            depthOfFieldParams.y = coeff;
        }
        CommonSet.SetMaterialKeyword(ref uberMaterial, "DEPTHOFFIELD", mProperty.depthOfField); */

        if (mProperty.dofFast)
        {
            depthOfFieldParams.x = mProperty.dofStart;
            depthOfFieldParams.y = mProperty.dofDistance;
        }
        CommonSet.SetMaterialKeyword(ref uberMaterial, "DEPTHOFFIELD", mProperty.dofFast); 
    }
    public void InitColorGrading()
    { 
        bool sceneLutEnable = SceneColorLookupEnable() && sceneColorGradingParam.internalLutTex;
        bool alphaLutEnable = AlphaColorLookupEnable() && alphaColorGradingParam.internalLutTex;
        bool playerLutEnable = PlayerColorLookupEnable() && playerColorGradingParam.internalLutTex;

        InitToneMapLum(CommonSet.ShaderProperties.adaptedLum,mProperty.sceneToneMap);
        InitToneMapLum(CommonSet.ShaderProperties.alphaAdaptedLum, mProperty.alphaToneMap);
        InitToneMapLum(CommonSet.ShaderProperties.playerAdaptedLum, mProperty.playerToneMap);       

        uberMaterial.SetVector(CommonSet.ShaderProperties.lutParams, new Vector4(1.0f / (ColorGradingParam.lutSize * ColorGradingParam.lutSize), 1.0f / ColorGradingParam.lutSize, ColorGradingParam.lutSize - 1.0f,1));
        CommonSet.SetMaterialKeyword(ref uberMaterial, "COLORLOOKUP", sceneLutEnable);
        CommonSet.SetMaterialKeyword(ref uberMaterial, "ALPHACOLORLOOKUP", alphaLutEnable);
        CommonSet.SetMaterialKeyword(ref uberMaterial, "PLAYERCOLORLOOKUP", playerLutEnable);
        CommonSet.SetMaterialKeyword(ref uberMaterial, "PLAYER", PlayerLayerEnable());
        if(sceneLutEnable)
            uberMaterial.SetTexture(CommonSet.ShaderProperties.sceneLutTex, sceneColorGradingParam.internalLutTex);
        if (alphaLutEnable)
            uberMaterial.SetTexture(CommonSet.ShaderProperties.alphaLutTex, alphaColorGradingParam.internalLutTex);
        if (playerLutEnable)
            uberMaterial.SetTexture(CommonSet.ShaderProperties.playerLutTex, playerColorGradingParam.internalLutTex);

        if(playerLutEnable && PlayerBloomEnable())
        {
            mMaterialPlayerBloom.SetTexture(CommonSet.ShaderProperties.playerLutTex, playerColorGradingParam.internalLutTex);
            mMaterialPlayerBloom.SetVector(CommonSet.ShaderProperties.lutParams, new Vector4(1.0f / (ColorGradingParam.lutSize * ColorGradingParam.lutSize), 1.0f / ColorGradingParam.lutSize, ColorGradingParam.lutSize - 1.0f, 1));
            float adaptLumID = 1;

            if (mProperty.playerToneMap.toneMapping)
            {
                if (mProperty.playerToneMap.toneMappingType == Property.ToneMappingType.ACES)
                {
                    adaptLumID = mProperty.playerToneMap.acesExposure;   
                }
                else if (mProperty.playerToneMap.toneMappingType == Property.ToneMappingType.CUSTOM)
                {
                    adaptLumID = mProperty.playerToneMap.customExposure;   
                }
            }
            mMaterialPlayerBloom.SetFloat(CommonSet.ShaderProperties.playerAdaptedLum, adaptLumID);
        }
    }
    void InitToneMapLum(int adaptLumID,Property.ToneMapProperty toneMapProperty)
    {
        uberMaterial.SetFloat(adaptLumID, 1);

        if (toneMapProperty.toneMapping)
        {
            if (toneMapProperty.toneMappingType == Property.ToneMappingType.ACES)
            {
                uberMaterial.SetFloat(adaptLumID, toneMapProperty.acesExposure);
            }
            else if (toneMapProperty.toneMappingType == Property.ToneMappingType.CUSTOM)
            {
                uberMaterial.SetFloat(adaptLumID, toneMapProperty.customExposure);
            }
        }
    }
    void InitAntiAliasing()
    {
        if (mProperty.fxaaQuality == Property.FXAAQuality.LOW)
        {
            mMaterialFXAA.EnableKeyword("FXAA_LOW");
            mMaterialFXAA.DisableKeyword("FXAA_NORMAL");
        }
        else
        {
            mMaterialFXAA.DisableKeyword("FXAA_LOW");
            mMaterialFXAA.EnableKeyword("FXAA_NORMAL");
        }
    }
    void InitMask()
    {
        bool enable = MaskEnable();
        if (enable)
        {
            uberMaterial.SetTexture(CommonSet.ShaderProperties.overlayTex, mProperty.overlayTex);
            uberMaterial.SetColor(CommonSet.ShaderProperties.overlayColor, mProperty.overlayColor.linear);
        }
        CommonSet.SetMaterialKeyword(ref uberMaterial, "OVERLAY", enable);
    }
    void InitVignette()
    {
        bool enable = VignetteEnable();
        if (enable)
        {
            uberMaterial.SetColor(CommonSet.ShaderProperties.vignetteColor, mProperty.vignetteColor.linear);
            float roundness = (1f - mProperty.vignetteRoundness) * 6f + mProperty.vignetteRoundness;
            uberMaterial.SetVector(CommonSet.ShaderProperties.vignetteParam, new Vector4(mProperty.vignetteIntensity * 3f, mProperty.vignetteSmoothness * 5f, roundness, 0));

            if(mProperty.ignoreAlphaBuffer)
            {
                CommonSet.SetMaterialKeyword(ref uberMaterial, "VIGNETTESCENE", true);
                CommonSet.SetMaterialKeyword(ref uberMaterial, "VIGNETTEALL", false);
            }
                
            else
            {
                CommonSet.SetMaterialKeyword(ref uberMaterial, "VIGNETTESCENE", false);
                CommonSet.SetMaterialKeyword(ref uberMaterial, "VIGNETTEALL", true);
            }                
        }
        else
        {
            CommonSet.SetMaterialKeyword(ref uberMaterial, "VIGNETTESCENE", false);
            CommonSet.SetMaterialKeyword(ref uberMaterial, "VIGNETTEALL", false);
        }       
    }
    public void InitBorder()
    {
        bool enable = BorderEnable();
        if (enable)
        {
            uberMaterial.SetColor(CommonSet.ShaderProperties.borderColor, mProperty.borderColor.linear);
            //mMaterialUber.SetVector(CommonSet.ShaderProperties.borderTile, new Vector4(mProperty.borderTile.x,mProperty.borderTile.y,0,0));
            uberMaterial.SetVector(CommonSet.ShaderProperties.borderParam, new Vector4(mProperty.borderTile.x, mProperty.borderTile.y, mProperty.borderIntensity, mProperty.borderMaxAlpha));
            uberMaterial.SetTexture(CommonSet.ShaderProperties.borderMask, mProperty.borderMask);
            uberMaterial.SetTexture(CommonSet.ShaderProperties.borderTex, mProperty.borderTex);
        }

        CommonSet.SetMaterialKeyword(ref uberMaterial, "BORDER", enable);
    }
    public void InitRadialBlur()
    {
        bool enable = RadialBlurEnable();
        if (enable)
        {
            mMaterialRadialBlur.SetFloat(CommonSet.ShaderProperties.radialAmount, mProperty.radialAmount);
            mMaterialRadialBlur.SetFloat(CommonSet.ShaderProperties.radialStrength, mProperty.radialStrength);
        }
    }
    public void InitDistortion()
    {
        CommonSet.SetMaterialKeyword(ref uberMaterial, "DISTORTION", AlphaBufferEnable());  
    }
    void InitLumaOcclusion()
    {
        if (LumaOcclusionEnable())
        {
            if (mProperty.showLO)
            {
                mMaterialOpaque.EnableKeyword("LUMAOCCLUSION_DEBUG");
                mMaterialOpaque.DisableKeyword("LUMAOCCLUSION");
            }
            else
            {
                mMaterialOpaque.DisableKeyword("LUMAOCCLUSION_DEBUG");
                mMaterialOpaque.EnableKeyword("LUMAOCCLUSION");
            }

            CommonSet.SetMaterialKeyword(ref mMaterialLumaOcclusion, "DIRECTIONAL", mProperty.directional);

            lumaFarams = new Vector4(Mathf.Sin(mProperty.radian), Mathf.Cos(mProperty.radian), 0, 0);
            mMaterialLumaOcclusion.SetFloat(CommonSet.ShaderProperties.loThreshold, mProperty.loThreshold);
            mMaterialLumaOcclusion.SetFloat(CommonSet.ShaderProperties.loRadius, mProperty.loRadius);
            mMaterialLumaOcclusion.SetFloat(CommonSet.ShaderProperties.loIntensity, mProperty.loIntensity);
            // mat.SetFloat(ShaderProperties.lumaProtect, 1f - mProperty.lumaProtect);
            mMaterialLumaOcclusion.SetVector(CommonSet.ShaderProperties.loParams, lumaFarams);
        }
        else
        {
            mMaterialOpaque.DisableKeyword("LUMAOCCLUSION_DEBUG");
            mMaterialOpaque.DisableKeyword("LUMAOCCLUSION");
        }
    }
    public void InitChromaticAberration()
    {
        if(ChromaticAberrationEnable() && mProperty.chromaticAberrationType == Property.ChromaticAberrationType.Radial && mProperty.chromaAmount > 0.02f)
        {
            uberMaterial.SetFloat(CommonSet.ShaderProperties.chromaAmount, mProperty.chromaAmount / 20);
            CommonSet.SetMaterialKeyword(ref uberMaterial, "CHROMATICABERRATION_RADIAL", true);
            CommonSet.SetMaterialKeyword(ref uberMaterial, "CHROMATICABERRATION_FULLSCREEN", false);
        }
        else if(ChromaticAberrationEnable() && mProperty.chromaticAberrationType == Property.ChromaticAberrationType.FullScreen)
        {
            Vector4 offset = new Vector4(mProperty.redOffset.x, mProperty.redOffset.y, mProperty.blueOffset.x, mProperty.blueOffset.y);

            float factor = colorOffset == 0 ? 1 : colorOffset;
            uberMaterial.SetVector(CommonSet.ShaderProperties.colorOffset, offset * factor * 0.001f);
            CommonSet.SetMaterialKeyword(ref uberMaterial, "CHROMATICABERRATION_RADIAL", false);
            CommonSet.SetMaterialKeyword(ref uberMaterial, "CHROMATICABERRATION_FULLSCREEN", true);
        }
        else
        {
            CommonSet.SetMaterialKeyword(ref uberMaterial, "CHROMATICABERRATION_RADIAL", false);
            CommonSet.SetMaterialKeyword(ref uberMaterial, "CHROMATICABERRATION_FULLSCREEN", false);
        }      
    }
    #endregion

    public bool HasOpaqueEffect()
    {      
        if (LumaOcclusionEnable())
            return true;
        if (CloudShadowEnable())
            return true;
        if (AmbientOcclusionEnable())
            return true;
        if (StochasticSSREnable())
            return true;

        return false;
    }
    public bool AntialiasingEnable()
    {
        if (graphicsSetting && graphicsSetting.dynamicQuality)
        {
            return (int)EnvironmentManager.Instance.GetCurResolutionLevel() <= (int)ResolutionLevel.HIGH && mProperty.antialiasing;
        }
        else
        {
            return graphicsSetting ? graphicsSetting.antialiasing && mProperty.antialiasing : mProperty.antialiasing;
        }
    }
    public bool AlphaBufferEnable()
    { 
        return graphicsSetting ? graphicsSetting.alphaBuffer && mProperty.alphaBuffer : mProperty.alphaBuffer;
    }
    public bool DistortionEnable()
    {
        return graphicsSetting ? graphicsSetting.distortion && mProperty.distortion &&  AlphaBufferEnable() : mProperty.distortion && AlphaBufferEnable();
    }
    public bool PlayerLayerEnable()
    {
        return graphicsSetting ? graphicsSetting.playerLayer && graphicsSetting.hdr && mProperty.playerLayer : mProperty.playerLayer;
    }
    public bool SceneBloomEnable()
    {
        bool sceneBloom = mMaterialBloom && mProperty.bloom.bloom;

        if (graphicsSetting)
        {
            sceneBloom = sceneBloom && graphicsSetting.sceneBloom;
        }

        return sceneBloom;
    }
    public bool AlphaBloomEnable()
    {
        bool alphaBloom = mMaterialAlphaBloom && mProperty.alphaBloom.bloom && mProperty.alphaBuffer;

        if (graphicsSetting)
        {
            alphaBloom = alphaBloom && graphicsSetting.alphaBloom && graphicsSetting.alphaBuffer;
        }

        return alphaBloom;
    }
    public bool PlayerBloomEnable()
    {
        bool playerBloom = mMaterialPlayerBloom && mProperty.playerBloom.bloom && mProperty.playerLayer;

        if (graphicsSetting)
        {
            playerBloom = playerBloom && graphicsSetting.hdr && graphicsSetting.playerBloom && graphicsSetting.playerLayer;
        }

        return playerBloom;
    }
    public bool SceneColorLookupEnable()
    {
        bool sceneColorLookup = mProperty.sceneColorGrading.colorGrading || mProperty.sceneToneMap.toneMapping || mProperty.sceneUserLut.userLut;

        if (graphicsSetting)
        {
            sceneColorLookup = sceneColorLookup && graphicsSetting.sceneColorLookup;
        }

        return sceneColorLookup;
    }
    public bool PlayerColorLookupEnable()
    {
        bool playerColorLookup = mProperty.playerLayer && (mProperty.sceneColorGrading.colorGrading || mProperty.sceneToneMap.toneMapping || mProperty.sceneUserLut.userLut);

        if (graphicsSetting)
        {
            playerColorLookup = playerColorLookup && graphicsSetting.hdr && graphicsSetting.playerColorLookup && graphicsSetting.playerLayer;
        }

        return playerColorLookup;
    }
    public bool AlphaColorLookupEnable()
    {
        bool alphaColorLookup = mProperty.alphaBuffer && (mProperty.alphaColorGrading.colorGrading || mProperty.alphaToneMap.toneMapping || mProperty.alphaUserLut.userLut);

        if (graphicsSetting)
        {
            alphaColorLookup = alphaColorLookup && graphicsSetting.alphaColorLookup && graphicsSetting.alphaBuffer;
        }

        return alphaColorLookup;
    }
    public bool VolumetricFogEnable()
    {
        bool volumetricFog = mMaterialVolumetricFog && mProperty.volumetricFog && mProperty.fogTex && EnvironmentManager.Instance.isSupportMRT;

        if (graphicsSetting)
        {
            volumetricFog = volumetricFog && graphicsSetting.volumetricFog;
        }

        return volumetricFog;
    }
    public bool CloudShadowEnable()
    {
        bool cloudShadow = mMaterialCloudShadow && mProperty.cloudShadow && EnvironmentManager.Instance.isSupportDepthTex;

        if (graphicsSetting)
        {
            cloudShadow = cloudShadow && graphicsSetting.cloudShadow;
        }

        return cloudShadow;
    }
    public bool AmbientOcclusionEnable()
    {
        bool ambientOcclusion = mMaterialAmbientOcclusion && mProperty.ambientOcclusion && EnvironmentManager.Instance.isSupportMRT && EnvironmentManager.Instance.isSupportDepthTex;

        if (graphicsSetting)
        {
            ambientOcclusion = ambientOcclusion && graphicsSetting.ambientOcclusion;
        }

        return ambientOcclusion;
    }
    public bool StochasticSSREnable()
    {
        bool stochasticSSR = mMaterialStochasticSSR && mProperty.stochasticScreenSpaceReflection && SystemInfo.supportsMotionVectors && EnvironmentManager.Instance.isSupportMRT && EnvironmentManager.Instance.isSupportDepthTex;

        if (graphicsSetting)
        {
            stochasticSSR = stochasticSSR && graphicsSetting.stochasticSSR;
        }

        return stochasticSSR;
    }
    public bool NormalBufferEnable()
    {
        return AmbientOcclusionEnable() || StochasticSSREnable();
    }
    public bool LumaOcclusionEnable()
    {
        bool lumaOcclusion = mMaterialLumaOcclusion && mProperty.lumaOcclusion;

        if (graphicsSetting)
        {
            lumaOcclusion = lumaOcclusion && graphicsSetting.lumaOcclusion;
        }

        return lumaOcclusion;
    }
    public bool VignetteEnable()
    {
        bool vignette = mProperty.vignette;

        if (graphicsSetting)
        {
            vignette = vignette && graphicsSetting.vignette;
        }

        return vignette;
    }
    public bool RadialBlurEnable()
    {
        bool radialBlur = mProperty.radialBlur;

        if (graphicsSetting)
        {
            radialBlur = radialBlur && graphicsSetting.radialBlur;
        }

        return radialBlur;
    }
    public bool BorderEnable()
    {
        bool border = mProperty.border && mProperty.borderTex;

        if (graphicsSetting)
        {
            border = border && graphicsSetting.border;
        }

        return border;
    }
    public bool MaskEnable()
    {
        bool mask = mProperty.mask && mProperty.overlayTex;

        if (graphicsSetting)
        {
            mask = mask && graphicsSetting.mask;
        }

        return mask;
    }
    public bool DepthOfFieldEnable()
    {
        bool depthOfField = mProperty.depthOfField && mMaterialDOF;

        if (graphicsSetting)
        {
            depthOfField = depthOfField && graphicsSetting.depthOfField;
        }

        return depthOfField;
    }
    public bool DofFastEnable()
    {
        bool dofFast = mProperty.dofFast && mMaterialDOF;

        if (graphicsSetting)
        {
            dofFast = dofFast && graphicsSetting.depthOfField;
        }

        return dofFast;
    }
    public bool HeightFogEnable()
    {
        bool heightFog = mProperty.heightFog && mMaterialHeightFog && EnvironmentManager.Instance.isSupportDepthTex;

        if (graphicsSetting)
        {
            heightFog = heightFog && graphicsSetting.heightFog;
        }

        return heightFog;
    }
    public bool ChromaticAberrationEnable()
    {
        bool chromaticAberration = mProperty.chromaticAberration;

        if (graphicsSetting)
        {
            chromaticAberration = chromaticAberration && graphicsSetting.chromaticAberration;
        }

        return chromaticAberration;
    }
    public bool GetDirty()
    {
        if (oldProperty.Diff(mProperty))
        {
            return true;
        }         

        return false;
    }
    public void SetNoDirty()
    {
        oldProperty.Assign(mProperty);
    }
}
