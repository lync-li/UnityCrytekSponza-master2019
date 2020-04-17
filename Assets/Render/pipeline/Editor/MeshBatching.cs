using UnityEngine;
using UnityEditor;
using System.Collections;
using System.Linq;
using System.IO;
using System.Collections.Generic;
using System.Text;
using System.Runtime.InteropServices;

[ExecuteInEditMode]
public class MeshBatching : ScriptableObject
{
    static Dictionary<string, List<GameObject>> objs;
    static GameObject dirLight;
    [MenuItem("File/Export/Batching")]
    static void Batching()
    {
        objs = new Dictionary<string, List<GameObject>>();
        dirLight = null;
        GameObject[] gos = Selection.gameObjects;
         if(gos.Length > 0)
         {
             getChildGameObjects(gos[0].transform,false);
             combine(gos[0].transform);
         }
    }

    [MenuItem("File/Export/BatchingWithBigVertex")]
    static void BatchingBigVertex()
    {
        objs = new Dictionary<string, List<GameObject>>();
        dirLight = null;
        GameObject[] gos = Selection.gameObjects;
        if (gos.Length > 0)
        {
            getChildGameObjects(gos[0].transform,true);
            combine(gos[0].transform);
        }
    }

    [MenuItem("File/Export/BatchingAll")]
    static void BatchingAll()
    {
        objs = new Dictionary<string, List<GameObject>>();
        dirLight = null;
        GameObject[] gos = Selection.gameObjects;
        if (gos.Length > 0)
        {
            getChildGameObjects(gos[0].transform, true);
            combine(gos[0].transform);
        }
    }

    static void getChildGameObjects(Transform tran,bool bigVertex)
    {
        if (tran.gameObject.activeSelf == false)
            return;

        int childNum = tran.childCount;
        int bigNum = 0;
        for(int i = 0;i < childNum;i++)
        {
            Transform child = tran.GetChild(i);

            if (child.gameObject.activeSelf == false)
                continue;

            MeshFilter filter = child.GetComponent<MeshFilter>();
            MeshRenderer render = child.GetComponent<MeshRenderer>();
            if (filter && filter.sharedMesh && render && render.sharedMaterial)
            {
                string materialName = render.sharedMaterial.name;

               // if (render.castShadows)
                //    materialName += "_Caster";   

                //if (render.receiveShadows)
               //     materialName += "_Receive";

                if(filter.sharedMesh.subMeshCount == 1)
                {
                    if (!bigVertex && filter.sharedMesh.vertexCount > 1500)
                    {
                        materialName += "_BigVertex_" + bigNum;
                        bigNum++;
                    }

                    if (objs.ContainsKey(materialName))
                    {
                        objs[materialName].Add(child.gameObject);
                    }
                    else
                        objs.Add(materialName, new List<GameObject>() { child.gameObject });
                }                   
            }

            if (child.childCount > 0)
                getChildGameObjects(child, bigVertex);

        }
    }



    static void combine(Transform tran)
    {
        string folderName = EditorUtility.SaveFolderPanel("Export file directory", "", "Assets");
        int pathIndex = folderName.IndexOf("Assets");
        string editorPath = folderName.Substring(pathIndex, folderName.Length - pathIndex);
        if(pathIndex < 0)
            Debug.Log("Wrong Path");

        GameObject newParent = new GameObject(tran.name + "_batched");
        newParent.transform.parent = tran.parent;

        foreach (var v in objs)
        {
            List<GameObject> list = v.Value;
            int num = list.Count;

            CombineInstance[] combine = new CombineInstance[num];

            int col = (int)Mathf.Sqrt((float)num);
            if (col * col < num)
                col++;
            int row = num / col;
            if (row * col < num)
                row++;

            for (int i = 0; i < num; i++)
            {
                MeshFilter filter = list[i].GetComponent<MeshFilter>();
                combine[i].mesh = new Mesh();
                combine[i].mesh.vertices = filter.sharedMesh.vertices;
                combine[i].mesh.uv = filter.sharedMesh.uv;
                combine[i].mesh.uv2 = filter.sharedMesh.uv2;
                combine[i].mesh.tangents = filter.sharedMesh.tangents;
                combine[i].mesh.colors = filter.sharedMesh.colors;
                combine[i].mesh.normals = filter.sharedMesh.normals;
                combine[i].mesh.triangles = filter.sharedMesh.triangles;
                // combine[i].mesh.normals = filter.sharedMesh.normals;
                combine[i].transform = filter.transform.localToWorldMatrix;
                combine[i].subMeshIndex = 0;

                int uvRow = i / col;
                int uvCol = i % col;

                if (combine[i].mesh.uv2.Length > 0)
                {
                    Vector2[] newUV2 = new Vector2[combine[i].mesh.uv.Length];

                    for (int j = 0; j < newUV2.Length; j++)
                    {
                        newUV2[j].x = combine[i].mesh.uv2[j].x / (col + 0.005f) + (float)uvCol / col;
                        newUV2[j].y = combine[i].mesh.uv2[j].y / (row + 0.005f) + (float)uvRow / row;
                    }
                    combine[i].mesh.uv2 = newUV2;
                }
            }

            Material mat = list[0].GetComponent<Renderer>().sharedMaterial;

            Mesh mesh = new Mesh();
            mesh.CombineMeshes(combine,true);

            GameObject obj = new GameObject();
            Transform t = obj.transform;
            MeshFilter meshFilter = obj.AddComponent<MeshFilter>();
            meshFilter.mesh = mesh;

            StringBuilder meshString = new StringBuilder();

            string fbxName = normalizeName(v.Key);
            meshString.Append("g ").Append(fbxName).Append("\n");

            meshString.Append(meshToString(t, col,row));

            string filename = folderName + "/" + fbxName + ".fbx";
            while(File.Exists(filename))
            {
                fbxName += "_new";
                filename = folderName + "/" + fbxName + ".fbx";
            }               

            WriteToFile(meshString.ToString(), folderName + "/" + fbxName + ".fbx");

            DestroyImmediate(obj);

            AssetDatabase.Refresh();

            GameObject Combined = AssetDatabase.LoadAssetAtPath<GameObject>(editorPath + "/" + fbxName + ".fbx");

            ModelImporter importer = AssetImporter.GetAtPath(editorPath + "/" + fbxName + ".fbx") as ModelImporter;

            if(importer == null)
            {
                Debug.LogError(editorPath + "/" + fbxName + ".fbx is Wrong!!!");
            }

            importer.meshCompression = ModelImporterMeshCompression.Off;
            importer.animationType = ModelImporterAnimationType.None; 
            importer.importBlendShapes = false;
            importer.importMaterials = false;
            importer.isReadable = false;          
            importer.optimizeMesh = true;
            importer.generateAnimations = ModelImporterGenerateAnimations.None;
            importer.importMaterials = false;
            importer.importLights = false;
            importer.importCameras = false;

            GameObject newGo = new GameObject(fbxName);
            MeshFilter newGoFilter = newGo.AddComponent<MeshFilter>();
            MeshFilter combinedFilter = Combined.GetComponent<MeshFilter>();
            if (combinedFilter)
                newGoFilter.sharedMesh = combinedFilter.sharedMesh;

            newGo.isStatic = true;

            MeshRenderer render = newGo.AddComponent<MeshRenderer>();
            render.sharedMaterial = list[0].GetComponent<Renderer>().sharedMaterial;
            //render.sharedMaterial.CopyPropertiesFromMaterial(list[0].GetComponent<Renderer>().sharedMaterial);
            render.shadowCastingMode = list[0].GetComponent<Renderer>().shadowCastingMode;
            render.receiveShadows = list[0].GetComponent<Renderer>().receiveShadows;

            newGo.transform.parent = newParent.transform;
        }
        AssetDatabase.ImportAsset(editorPath, ImportAssetOptions.ForceUpdate | ImportAssetOptions.ImportRecursive);       
    }
    static string normalizeName(string name)
    {
        int index = name.IndexOf(' ');
        while(index > 0)
        {
            name = name.Remove(index, 1);
            index = name.IndexOf(' ');
        }
        index = name.IndexOf('.');
        while (index > 0)
        {
            name = name.Remove(index, 1);
            index = name.IndexOf('.');
        }
        return name;
    }
    static string meshToString(Transform t,int col,int row)
    {
        Quaternion r = t.localRotation;
        t.localScale = new Vector3(-t.localScale.x, t.localScale.y, t.localScale.z);

        int numVertices = 0;
        MeshFilter mf = t.GetComponent<MeshFilter>();
        Mesh m = mf.sharedMesh;

        StringBuilder sb = new StringBuilder();

        foreach (Vector3 vv in m.vertices)
        {
            Vector3 v = t.TransformPoint(vv);
            v = new Vector3(v.x * 100, v.y * 100, v.z * 100);
            //if (m.uv2.Length > 0)//tree leaf
            //{
            //    float x = Random.Range(0, 100.0f);
            //    float y = Random.Range(0, 100.0f);
            //    float z = Random.Range(0, 100.0f);
            //    Vector3 bias = new Vector3(x / 1000.0f, y / 1000.0f, z / 1000.0f);
            //    v += bias;
            //}
            numVertices++;
            sb.Append(string.Format("v {0} {1} {2}\n", v.x, v.y, v.z));
        }
        sb.Append("\n");
        foreach (Vector3 nn in m.normals)
        {
            Vector3 v = r * nn;
            sb.Append(string.Format("vn {0} {1} {2}\n", -v.x, v.y, v.z));
        }
        sb.Append("\n");
        foreach (Vector3 v in m.uv)
        {
            sb.Append(string.Format("vt {0} {1}\n", v.x, v.y));
        }
        sb.Append("\n");

        if (m.uv2.Length > 0)
        {
            //if(m.uv4.Length > 0)
            //{
            //    for(int i = 0;i<m.uv2.Length;i++)
            //    {
            //        sb.Append(string.Format("vt1 {0} {1}\n", (m.uv2[i].x + m.uv4[i].x)/col, (m.uv2[i].y + m.uv4[i].y)/row));
            //    }     
            //}
            //else
            {
                foreach (Vector2 v in m.uv2)
                {
                    sb.Append(string.Format("vt1 {0} {1}\n", v.x, v.y));
                }
            }           
            sb.Append("\n");
        }
        if (m.uv3.Length > 0)
        {
            foreach (Vector2 v in m.uv3)
            {
                sb.Append(string.Format("vt2 {0} {1}\n", v.x, v.y));
            }
            sb.Append("\n");
        }
        if (m.colors.Length > 0)
        {
            foreach (Color c in m.colors)
            {
                sb.Append(string.Format("vc {0} {1} {2} {3}\n", c.r, c.g, c.b, c.a));
            }
        }

        sb.Append("\n");

        int[] triangles = m.GetTriangles(0);
        for (int i = 0; i < triangles.Length; i += 3)
        {
            sb.Append(string.Format("f {0}/{0}/{0} {1}/{1}/{1} {2}/{2}/{2}\n",
                triangles[i + 2] + 1, triangles[i + 1] + 1, triangles[i + 0] + 1));
        }

        return sb.ToString();

    }

    static void WriteToFile(string s, string filename)
    {
        string tempFilename1 = filename.Substring(0, filename.Length - 4) + ".obj";
        File.Delete(tempFilename1);
        File.Delete(filename);
        using (StreamWriter sw = new StreamWriter(tempFilename1))
        {
            sw.Write(s);
        }

        System.Diagnostics.Process p = new System.Diagnostics.Process();
        p.StartInfo.FileName = Application.dataPath + "/Editor/FbxExport.exe";
        p.StartInfo.Arguments = tempFilename1 + " " + filename;
        p.Start();
        p.WaitForExit();

        File.Delete(tempFilename1);
    }

}
