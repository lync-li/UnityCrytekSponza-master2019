namespace AnimTexture
{
    using System.Collections;
    using System.Collections.Generic;
    using UnityEditor;
    using UnityEngine;

    public class AnimTextureUtils
    {
        public static void BakeMeshToTexture(SkinnedMeshRenderer skin, GameObject clipGo, AnimationClip clip,out Texture2D posTex,out Texture2D normalTex,out Texture2D tangentTex)
        {
            var width = skin.sharedMesh.vertexCount;
            var frameCount = (int)(clip.length * clip.frameRate);
            var timePerFrame = clip.length / frameCount;
            posTex = new Texture2D(width, frameCount, TextureFormat.RGBAHalf, false, true);
            normalTex = new Texture2D(width, frameCount, TextureFormat.RGBA32, false, true);
            tangentTex = new Texture2D(width, frameCount, TextureFormat.RGBA32, false, true);

            posTex.name = clip.name;

            float time = 0;
            Mesh mesh = new Mesh();
            for (int y = 0; y < frameCount; y++)
            {
                clip.SampleAnimation(clipGo, time += timePerFrame);
                skin.BakeMesh(mesh);

                var colors = new Color[mesh.vertexCount];

                for (int x = 0; x < mesh.vertexCount; x++)
                {
                    var v = mesh.vertices[x];
                    var normal = mesh.normals[x];
                    normal = normal.normalized;                   

                    colors[x] = new Vector4(v.x, v.y, v.z);
                }
                posTex.SetPixels(0, y, width, 1, colors);

                for (int x = 0; x < mesh.vertexCount; x++)
                {
                    var normal = mesh.normals[x];
                    normal = normal.normalized;
                    
                    colors[x] = new Vector4(normal.x * 0.5f + 0.5f, normal.y * 0.5f + 0.5f, normal.z * 0.5f + 0.5f);
                }
                normalTex.SetPixels(0, y, width, 1, colors);

                for (int x = 0; x < mesh.vertexCount; x++)
                {
                    Vector3 tangent = mesh.tangents[x];
                    tangent = tangent.normalized;
                    colors[x] = new Vector4(tangent.x * 0.5f + 0.5f, tangent.y * 0.5f + 0.5f, tangent.z * 0.5f + 0.5f);
                }
                tangentTex.SetPixels(0, y, width, 1, colors);
            }
            posTex.Apply();
            normalTex.Apply();
            tangentTex.Apply();
        }
    }
}