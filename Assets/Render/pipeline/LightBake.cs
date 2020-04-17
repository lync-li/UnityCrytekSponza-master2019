using UnityEngine;
using UnityEngine.Rendering;
using System.Collections;
using System;
using System.IO;
using UnityEngine.Events;

public class LightBake: MonoBehaviour {

    //
    // 摘要:
    //     In case of a LightmapBakeType.Mixed light, contains the index of the light as
    //     seen from the occlusion probes point of view if any, otherwise -1.
    public int probeOcclusionLightIndex;
    //
    // 摘要:
    //     In case of a LightmapBakeType.Mixed light, contains the index of the occlusion
    //     mask channel to use if any, otherwise -1.
    public int occlusionMaskChannel;
    //
    // 摘要:
    //     This property describes what part of a light's contribution was baked.
    public LightmapBakeType lightmapBakeType;
    //
    // 摘要:
    //     In case of a LightmapBakeType.Mixed light, describes what Mixed mode was used
    //     to bake the light, irrelevant otherwise.
    public MixedLightingMode mixedLightingMode;
    //
    // 摘要:
    //     Is the light contribution already stored in lightmaps and/or lightprobes?
    public bool isBaked;


    private Light bakeLight;

    private void Start()
    {
        bakeLight = GetComponent<Light>();
    }
    void Update()
    {
        if(isBaked != bakeLight.bakingOutput.isBaked
            || lightmapBakeType != bakeLight.bakingOutput.lightmapBakeType
            || mixedLightingMode != bakeLight.bakingOutput.mixedLightingMode
            || probeOcclusionLightIndex != bakeLight.bakingOutput.probeOcclusionLightIndex
            || occlusionMaskChannel != bakeLight.bakingOutput.occlusionMaskChannel)
        {
            LightBakingOutput output = new LightBakingOutput();
            output.isBaked = isBaked;
            output.occlusionMaskChannel = occlusionMaskChannel;
            output.mixedLightingMode = mixedLightingMode;
            output.occlusionMaskChannel = probeOcclusionLightIndex;
            output.lightmapBakeType = lightmapBakeType;
            bakeLight.bakingOutput = output;
        }
    }
}
