using System;
using UnityEngine;

[ExecuteInEditMode]
[RequireComponent (typeof(Camera))]
public class BlurScreenCapture : MonoBehaviour
{
    [Range(0, 2)]
    public int downsample = 1;

    [Range(0.0f, 10.0f)]
    public float blurSize = 3.0f;

    [Range(1, 4)]
    public int blurIterations = 2;

    private Material blurMaterial = null;

    private bool needUpdate = false;
    private RenderTexture blurRT;

    private void Awake()
    {
        needUpdate = false;

        if (blurMaterial == null)
        {
            Shader shader = Shader.Find("Hidden/FastBlur");
            if (shader && shader.isSupported)
            {
                blurMaterial = new Material(shader);
            }
        }
    }

    public void OnEnable()
    {
        needUpdate = true;
    }

    public void OnDisable()
    {
        needUpdate = false;
        Camera.main.cullingMask = -1;
    }

    public void OnDestroy ()
    {
        if (blurMaterial)
        {
#if UNITY_EDITOR
            DestroyImmediate(blurMaterial);
#else
            Destroy(blurMaterial);
#endif
            blurMaterial = null;
        }
    }

    public void OnRenderImage (RenderTexture source, RenderTexture destination) {
       
        if(needUpdate)
        {
            if (blurRT)
                blurRT.DiscardContents();
            float widthMod = 1.0f / (1.0f * (1 << downsample));

            blurMaterial.SetVector("_Parameter", new Vector4(blurSize * widthMod, -blurSize * widthMod, 0.0f, 0.0f));
            source.filterMode = FilterMode.Bilinear;

            int rtW = source.width >> downsample;
            int rtH = source.height >> downsample;

            // downsample
            RenderTexture rt = RenderTexture.GetTemporary(rtW, rtH, 0, source.format);

            rt.filterMode = FilterMode.Bilinear;
            Graphics.Blit(source, rt, blurMaterial, 0);

            var passOffs = 0;

            for (int i = 0; i < blurIterations; i++)
            {
                float iterationOffs = (i * 1.0f);
                blurMaterial.SetVector("_Parameter", new Vector4(blurSize * widthMod + iterationOffs, -blurSize * widthMod - iterationOffs, 0.0f, 0.0f));

                // vertical blur
                RenderTexture rt2 = RenderTexture.GetTemporary(rtW, rtH, 0, source.format);
                rt2.filterMode = FilterMode.Bilinear;
                Graphics.Blit(rt, rt2, blurMaterial, 1 + passOffs);
                RenderTexture.ReleaseTemporary(rt);
                rt = rt2;

                // horizontal blur
                rt2 = RenderTexture.GetTemporary(rtW, rtH, 0, source.format);
                rt2.filterMode = FilterMode.Bilinear;
                Graphics.Blit(rt, rt2, blurMaterial, 2 + passOffs);
                RenderTexture.ReleaseTemporary(rt);
                rt = rt2;
            }

            if (blurRT == null)
                blurRT = new RenderTexture(source.width, source.height, 0, source.format);
            Graphics.Blit(rt, blurRT);
            RenderTexture.ReleaseTemporary(rt);
            needUpdate = false;
            Camera.main.cullingMask = 0;
        }

        if (blurRT)
            source = blurRT;

        Graphics.Blit(source, destination);
    }
}

