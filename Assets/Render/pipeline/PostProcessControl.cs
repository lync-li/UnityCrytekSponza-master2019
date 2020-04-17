using UnityEngine;
using UnityEngine.UI;

public class PostProcessControl : MonoBehaviour
{
    public DragonPostProcess postProcess;

    //reduceResolution
    public Toggle reduceResolutionToggle;
    private bool oldReduceResolution;

    //beforeTransparent
    public Toggle beforeTransparentToggle;
    private bool oldBeforeTransparent;

    //show
    public Toggle show0Toggle;
    public Text show0Text;
    public Toggle show1Toggle;
    public Text show1Text;
    //ao
    public Toggle aoToggle;
    public Toggle aoDebugToggle;
    public Toggle aoBlurToggle;
    public Slider aoRadiusSlider;
    public Slider aoBiasSlider;
    public Slider aoIntensitySlider;
    private bool oldAo;
    private bool oldAoBlur;
    private bool oldAoDebug;
    private float oldAoRadius;
    private float oldAoBias;
    private float oldAoIntensity;

    //shadow
    public Toggle shadowToggle;
    private bool oldShadow;

    //AA
    public Toggle aaToggle;
    public Slider aaLevelSlider;
    public Text aaText;
    private bool oldAa;
    private int oldAalevel;

    //bloom 
    public Toggle bloomToggle;
    public Slider bloomThresholdSlider;
    public Slider bloomRadiusSlider;
    public Slider bloomIntensitySlider;
    private bool  oldBloom;
    private float oldBloomThreshold;
    private float oldBloomRadius;
    private float oldBloomIntensity;

    //tonmemapping
    public Toggle acesToggle;
    public Toggle filmicToggle;
    private bool oldAces;
    private bool oldFilmic;

    //color grading
    public Toggle colorGradingToggle;
    private bool oldColorGrading;

    //overlay
    public Toggle maskToggle;
    private bool oldMask;

    
    //dof
    public Toggle dofToggle;
    public Slider focusSlider;
    public Slider apertureSlider;
    public Slider focalLengthSlider;
    public Slider dofBlurSlider;
    private bool  oldDof;
    private float oldFocus;
    private float oldAperture;
    private float oldFocalLength;
    private float oldDofBlur;

    //lumaOcclusion
    public Toggle loToggle;
    public Toggle loDebugToggle;
    public Toggle loBlurToggle;
    public Toggle loDirectionToggle;
    public Slider loRadiusSlider;
    public Slider loThresholdSlider;
    public Slider loRadianSlider;
    public Slider loIntensitySlider;
    private bool oldLo;
    private bool oldLoBlur;
    private bool oldLoDebug;
    private bool oldLoDirection;
    private float oldLoThreshold;
    private float oldLoRadius;
    private float oldLoRadian;
    private float oldLoIntensity;

    //dof
    public Toggle fogToggle;
    public Slider fogDensitySlider;
    public Slider fogHeightSlider;
    public Toggle fogNoiseToggle;
    public Slider fogNoiseStrengthSlider;
    public Slider fogNoiseScaleSlider;
    public Slider fogWindSpeedSlider;
    public Slider fogDownSampleSlider;
    public Toggle fogEdgeImproveToggle;
    public Slider fogStepSlider;
    private bool oldFog;
    private float oldFogDensity;
    private float oldFogHeight;
    private bool oldFogNoise;
    private float oldFogNoiseStrength;
    private float oldFogNoiseScale;
    private float oldFogWindSpeed;
    private float oldFogDownSample;
    private bool oldFogEdgeImprove;
    private float oldFogStep;

    //beforeTransparent
    public Toggle vignetteToggle;
    private bool oldVignette;


    public void Start()
    {
       // FindPostProcess();
    }

    /*
public void FindPostProcess()
{

    postProcess = Camera.main.gameObject.GetComponentInChildren<DragonPostProcess>();

    reduceResolutionToggle.isOn = oldReduceResolution = postProcess.mProperty.reduceResolution;

    beforeTransparentToggle.isOn = oldBeforeTransparent = postProcess.mProperty.lookupBeforeTransparent;


    aoToggle.isOn = oldAo = postProcess.mProperty.ambientOcclusion;
    aoDebugToggle.isOn = oldAoDebug = postProcess.mProperty.debugAO;
    aoBlurToggle.isOn = oldAoBlur = postProcess.mProperty.aoBlur;
    aoRadiusSlider.value = oldAoRadius = postProcess.mProperty.radius;
    aoBiasSlider.value = oldAoBias = postProcess.mProperty.bias;
    aoIntensitySlider.value = oldAoIntensity = postProcess.mProperty.aoIntensity;

    loToggle.isOn = oldLo = postProcess.mProperty.lumaOcclusion;
    loDebugToggle.isOn = oldLoDebug = postProcess.mProperty.showLO;
    loBlurToggle.isOn = oldLoBlur = postProcess.mProperty.loBlur;
    loDirectionToggle.isOn = oldLoDirection = postProcess.mProperty.directional;
    loRadiusSlider.value = oldLoRadius = postProcess.mProperty.loRadius;
    loThresholdSlider.value = oldLoThreshold = postProcess.mProperty.loThreshold;
    loRadianSlider.value = oldLoRadian = postProcess.mProperty.radian;
    loIntensitySlider.value = oldLoIntensity = postProcess.mProperty.loIntensity;

    dofToggle.isOn = oldDof = postProcess.mProperty.depthOfField;
    focusSlider.value = oldFocus = postProcess.mProperty.focusDistance;
    apertureSlider.value = oldAperture = postProcess.mProperty.aperture;
    focalLengthSlider.value = oldFocalLength = postProcess.mProperty.focalLength;
    dofBlurSlider.value = oldDofBlur = postProcess.mProperty.kernelSize;

    shadowToggle.isOn = oldShadow = !(QualitySettings.shadows == 0);

    aaToggle.isOn = oldAa = postProcess.mProperty.antialiasing;
    oldAalevel = (int)postProcess.mProperty.fxaaQuality;
    aaLevelSlider.value = oldAalevel;

    bloomToggle.isOn = oldBloom = postProcess.mProperty.sceneBloom;
    bloomThresholdSlider.value = oldBloomThreshold = postProcess.mProperty.sceneBloomThreshold;
    bloomRadiusSlider.value = oldBloomRadius = postProcess.mProperty.sceneBloomRadius;
    bloomIntensitySlider.value = oldBloomIntensity = postProcess.mProperty.sceneBloomIntensity;

    if(postProcess.mProperty.toneMapping)
    {
        acesToggle.isOn = oldAces = (postProcess.mProperty.toneMappingType == DragonPostProcess.Property.ToneMappingType.ACES);
        filmicToggle.isOn = oldFilmic = (postProcess.mProperty.toneMappingType == DragonPostProcess.Property.ToneMappingType.FILMIC);

    }
    else
    {
        acesToggle.isOn = oldAces = false;
        filmicToggle.isOn = oldFilmic = false;
    }

    maskToggle.isOn = oldMask = postProcess.mProperty.mask;

    colorGradingToggle.isOn = oldColorGrading = postProcess.mProperty.colorGrading;

    fogToggle.isOn = oldFog = postProcess.mProperty.volumetricFog;
    fogDensitySlider.value = oldFogDensity = postProcess.mProperty.fogDensity;
    fogHeightSlider.value = oldFogHeight = postProcess.mProperty.fogHeight;
    fogNoiseStrengthSlider.value = oldFogNoiseStrength = postProcess.mProperty.fogNoiseStrength;
    fogNoiseScaleSlider.value = oldFogNoiseScale = postProcess.mProperty.fogNoiseScale;
    fogWindSpeedSlider.value = oldFogWindSpeed = postProcess.mProperty.fogWindSpeed;
    fogDownSampleSlider.value = oldFogDownSample = postProcess.mProperty.fogDownSampling;
    fogEdgeImproveToggle.isOn = oldFogEdgeImprove = postProcess.mProperty.fogEdgeImprove;
    fogStepSlider.value = oldFogStep = postProcess.mProperty.fogStepping;

    vignetteToggle.isOn = oldVignette = postProcess.mProperty.vignette;
}


public void Update()
{
    if (postProcess)
    {
        //reduceResolution
        if (oldReduceResolution != reduceResolutionToggle.isOn)
        {
            postProcess.mProperty.reduceResolution = oldReduceResolution = reduceResolutionToggle.isOn;
            postProcess.UpdatePostProcess();
        }

        //beforeTransparent
        if (oldBeforeTransparent != beforeTransparentToggle.isOn)
        {
            postProcess.mProperty.lookupBeforeTransparent = oldBeforeTransparent = beforeTransparentToggle.isOn;
            postProcess.UpdatePostProcess();
        }

        //dof
        if (oldDof != dofToggle.isOn)
        {
            postProcess.mProperty.depthOfField = oldDof = dofToggle.isOn;
            postProcess.UpdatePostProcess();
        }
        if (oldFocus != focusSlider.value)
        {
            postProcess.mProperty.focusDistance = oldFocus = focusSlider.value;
            postProcess.UpdatePostProcess();
        }
        if (oldAperture != apertureSlider.value)
        {
            postProcess.mProperty.aperture = oldAperture = apertureSlider.value;
            postProcess.UpdatePostProcess();
        }
        if (oldFocalLength != focalLengthSlider.value)
        {
            postProcess.mProperty.focalLength = oldFocalLength = focalLengthSlider.value;
            postProcess.UpdatePostProcess();
        }
        if (oldDofBlur != dofBlurSlider.value)
        {
            postProcess.mProperty.kernelSize = (int)dofBlurSlider.value;
            oldDofBlur = postProcess.mProperty.kernelSize;
            dofBlurSlider.value = oldDofBlur;
            postProcess.UpdatePostProcess();
        }

        //lo
        if (oldLo != loToggle.isOn)
        {
            postProcess.mProperty.lumaOcclusion = oldLo = loToggle.isOn;
            postProcess.UpdatePostProcess();
        }
        if (oldLoDebug != loDebugToggle.isOn)
        {
            postProcess.mProperty.showLO = oldLoDebug = loDebugToggle.isOn;
            postProcess.UpdatePostProcess();
        }
        if (oldLoBlur != loBlurToggle.isOn)
        {
            postProcess.mProperty.loBlur = oldLoBlur = loBlurToggle.isOn;
            postProcess.UpdatePostProcess();
        }
        if (oldLoDirection != loDirectionToggle.isOn)
        {
            postProcess.mProperty.directional = oldLoDirection = loDirectionToggle.isOn;
            postProcess.UpdatePostProcess();
        }

        if (oldLoRadius != loRadiusSlider.value)
        {
            postProcess.mProperty.loRadius = oldLoRadius = loRadiusSlider.value;
            postProcess.UpdatePostProcess();
        }

        if (oldLoThreshold != loThresholdSlider.value)
        {
            postProcess.mProperty.loThreshold = oldLoThreshold = loThresholdSlider.value;
            postProcess.UpdatePostProcess();
        }   

        if (oldLoIntensity != loIntensitySlider.value)
        {
            postProcess.mProperty.loIntensity = oldLoIntensity = loIntensitySlider.value;
            postProcess.UpdatePostProcess();
        }

        if (oldLoRadian != loRadianSlider.value)
        {
            postProcess.mProperty.radian = oldLoRadian = loRadianSlider.value;
            postProcess.UpdatePostProcess();
        }

        //a0
        if (oldAo != aoToggle.isOn)
        {
            postProcess.mProperty.ambientOcclusion = oldAo = aoToggle.isOn;
            postProcess.UpdatePostProcess();
            postProcess.initAoCommandBuffer = true;
        }

        if (oldAoBlur != aoBlurToggle.isOn)
        {
            postProcess.mProperty.aoBlur = oldAoBlur = aoBlurToggle.isOn;
            postProcess.UpdatePostProcess();
            postProcess.initAoCommandBuffer = true;
        }

        if (oldAoDebug != aoDebugToggle.isOn)
        {
            postProcess.mProperty.debugAO = oldAoDebug = aoDebugToggle.isOn;
            postProcess.UpdatePostProcess();
            postProcess.initAoCommandBuffer = true;
        }

        if (oldAoRadius != aoRadiusSlider.value)
        {
            postProcess.mProperty.radius = oldAoRadius = aoRadiusSlider.value;
            postProcess.UpdatePostProcess();
            postProcess.initAoCommandBuffer = true;
        }

        if (oldAoBias != aoBiasSlider.value)
        {
            postProcess.mProperty.bias = oldAoBias = aoBiasSlider.value;
            postProcess.UpdatePostProcess();
            postProcess.initAoCommandBuffer = true;
        }

        if (oldAoIntensity != aoIntensitySlider.value)
        {
            postProcess.mProperty.aoIntensity = oldAoIntensity = aoIntensitySlider.value;
            postProcess.UpdatePostProcess();
            postProcess.initAoCommandBuffer = true;
        }

        //shadow
        if (oldShadow != shadowToggle.isOn)
        {
            if (shadowToggle.isOn)
            {
                    QualitySettings.shadows = ShadowQuality.All;       
            }
            else
                QualitySettings.shadows = ShadowQuality.Disable;
            oldShadow = shadowToggle.isOn;
        }

        //aa
        if(oldAa != aaToggle.isOn)
        {
            postProcess.mProperty.antialiasing = oldAa = aaToggle.isOn;
            postProcess.UpdatePostProcess();
        }

        if(oldAalevel != aaLevelSlider.value)
        {
            oldAalevel = (int)aaLevelSlider.value;
            postProcess.mProperty.fxaaQuality = (DragonPostProcess.Property.FXAAQuality)oldAalevel;
            aaLevelSlider.value = oldAalevel;
            if (postProcess.mProperty.fxaaQuality == DragonPostProcess.Property.FXAAQuality.LOW)
                aaText.text = "AA-低";
            else if(postProcess.mProperty.fxaaQuality == DragonPostProcess.Property.FXAAQuality.NORMAL)
                aaText.text = "AA-中";
        }

        //bloom
        if (oldBloom != bloomToggle.isOn)
        {
            postProcess.mProperty.sceneBloom = oldBloom = bloomToggle.isOn;
            postProcess.UpdatePostProcess();
        }
        if (oldBloomThreshold != bloomThresholdSlider.value)
        {
            postProcess.mProperty.sceneBloomThreshold = oldBloomThreshold = bloomThresholdSlider.value;
            postProcess.UpdatePostProcess();
        }
        if (oldBloomRadius != bloomRadiusSlider.value)
        {
            postProcess.mProperty.sceneBloomRadius = oldBloomRadius = bloomRadiusSlider.value;
            postProcess.UpdatePostProcess();
        }
        if (oldBloomIntensity != bloomIntensitySlider.value)
        {
            postProcess.mProperty.sceneBloomIntensity = oldBloomIntensity = bloomIntensitySlider.value;
            postProcess.UpdatePostProcess();
        }

        //tonemap
        if(oldAces != acesToggle.isOn || oldFilmic != filmicToggle.isOn)
        {
            if(acesToggle.isOn || filmicToggle.isOn)
            {
                postProcess.mProperty.toneMapping = true;
                if (acesToggle.isOn && oldAces != acesToggle.isOn)
                {
                    postProcess.mProperty.toneMappingType = DragonPostProcess.Property.ToneMappingType.ACES;
                    filmicToggle.isOn = false;
                }                        
                if (filmicToggle.isOn && oldFilmic != filmicToggle.isOn)
                {
                    postProcess.mProperty.toneMappingType = DragonPostProcess.Property.ToneMappingType.FILMIC;
                    acesToggle.isOn = false;
                }                        

            }
            else
            {
                postProcess.mProperty.toneMapping = false;
            }
            postProcess.UpdatePostProcess();
            oldAces = acesToggle.isOn;
            oldFilmic = filmicToggle.isOn;
        }

        //Mask
        if (oldMask != maskToggle.isOn)
        {
            postProcess.mProperty.mask = oldMask = maskToggle.isOn;
            postProcess.UpdatePostProcess();
        }

        //Color Grading
        if (oldColorGrading != colorGradingToggle.isOn)
        {
            postProcess.mProperty.colorGrading = oldColorGrading = colorGradingToggle.isOn;
            postProcess.UpdatePostProcess();
        }

        //FOG
        if (oldFog != fogToggle.isOn)
        {
            postProcess.mProperty.volumetricFog = oldFog = fogToggle.isOn;
            postProcess.UpdatePostProcess();
        }

        if (oldFogDensity != fogDensitySlider.value)
        {
            postProcess.mProperty.fogDensity = oldFogDensity = fogDensitySlider.value;
            postProcess.UpdatePostProcess();
        }

        if (oldFogHeight != fogHeightSlider.value)
        {
            postProcess.mProperty.fogHeight = oldFogHeight = fogHeightSlider.value;
            postProcess.UpdatePostProcess();
        }

        if (oldFogNoiseStrength != fogNoiseStrengthSlider.value)
        {
            postProcess.mProperty.fogNoiseStrength = oldFogNoiseStrength = fogNoiseStrengthSlider.value;
            postProcess.UpdatePostProcess();
        }

        if (oldFogNoiseScale != fogNoiseScaleSlider.value)
        {
            postProcess.mProperty.fogNoiseScale = oldFogNoiseScale = fogNoiseScaleSlider.value;
            postProcess.UpdatePostProcess();
        }

        if (oldFogWindSpeed != fogWindSpeedSlider.value)
        {
            postProcess.mProperty.fogWindSpeed = oldFogWindSpeed = fogWindSpeedSlider.value;
            postProcess.UpdatePostProcess();
        }

        if (oldFogDownSample != fogDownSampleSlider.value)
        {
            oldFogDownSample = (int)fogDownSampleSlider.value;
            postProcess.mProperty.fogDownSampling = (int)fogDownSampleSlider.value;
            postProcess.UpdatePostProcess();
        }

        if (oldFogEdgeImprove != fogEdgeImproveToggle.isOn)
        {
            postProcess.mProperty.fogEdgeImprove = oldFogEdgeImprove = fogEdgeImproveToggle.isOn;
            postProcess.UpdatePostProcess();
        }

        if (oldFogStep != fogStepSlider.value)
        {
            postProcess.mProperty.fogStepping = oldFogStep = fogStepSlider.value;
            postProcess.UpdatePostProcess();
        }

        //vignette
        if (oldVignette != vignetteToggle.isOn)
        {
            postProcess.mProperty.vignette = oldVignette = vignetteToggle.isOn;
            postProcess.UpdatePostProcess();
        }

    }

}
*/
}
