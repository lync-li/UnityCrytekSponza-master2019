#if UNITY_EDITOR
namespace AnimTexture
{
    using System.Collections;
    using System.Collections.Generic;
    using UnityEditor;
    using UnityEngine;
    using System.Linq;
    using System.IO;
    using System.Text;
    using UnityEditor.Animations;

    public class AnimTextureEditor : EditorWindow
    {
        public struct AnimClipData
        {
            public AnimationClip clip;
            public float speed;
        }
        //if you change AnimTexture path, need change this path.
        public const string DEFAULT_TEX_DIR = "AnimTexPath";

        private static AnimTextureEditor s_window;

        [SerializeField]
        private GameObject generatedPrefab;

        [MenuItem("AnimTextBake/AnimTex Generator", false)]
        static void MakeWindow()
        {
            s_window = GetWindow(typeof(AnimTextureEditor)) as AnimTextureEditor;
            //ms_window.oColor = GUI.contentColor;
        }

        private void OnGUI()
        {
            GUI.skin.label.richText = true;
            GUILayout.BeginHorizontal();
            {
                GUILayout.FlexibleSpace();
            }
            GUILayout.EndHorizontal();

            generatedPrefab = EditorGUILayout.ObjectField("Animator to Generate", generatedPrefab, typeof(GameObject), true) as GameObject;

            bool error = false;
            if (generatedPrefab)
            {             
                Animator animator = generatedPrefab.GetComponentInChildren<Animator>();
                if (animator == null)
                {
                    EditorGUILayout.LabelField("Error: The prefab should have a Animator Component.");
                    return;
                }
                if (animator.runtimeAnimatorController == null)
                {
                    EditorGUILayout.LabelField("Error: The prefab's Animator should have a Animator Controller.");
                    return;
                }
            }

            if (generatedPrefab && !error)
            {
                if (GUILayout.Button(string.Format("Generate")))
                {
                    var newInst = Object.Instantiate(generatedPrefab);
                    newInst.name = generatedPrefab.name;
                    var animator = newInst.GetComponentInChildren<Animator>();
                    List<AnimClipData> clips = GetClips(animator);
                    Dictionary<int, AnimClipData> states = GetStates(animator, clips);     
                    int clipCount = BakeAllClips(newInst, clips,states);
                    ShowResult(newInst, clipCount);
                    Object.DestroyImmediate(newInst);
                    EditorGUIUtility.PingObject(AssetDatabase.LoadAssetAtPath<Object>($"Assets/{DEFAULT_TEX_DIR}"));
                }
            }
        }
        //// [MenuItem("AnimTexture/BakeAnimClipsToAtlas")]
        //static void BakeAllInOne()
        //{
        //    var objs = Selection.GetFiltered<GameObject>(SelectionMode.DeepAssets);
        //    if(objs.Length == 0)
        //    {
        //        Debug.Log("Select Model with Animations.");
        //        return;
        //    }

        //    foreach (var go in objs)
        //    {
        //        var newInst = Object.Instantiate(go);
        //        newInst.name = go.name;

        //        var animator = go.GetComponentInChildren<Animator>();
        //        List<AnimClipData> clips = GetClips(animator);
        //        Dictionary<int, AnimClipData> states = GetStates(animator, clips);
        //        int clipCount = BakeAllClips(newInst,clips);
        //        Object.DestroyImmediate(newInst);
        //        ShowResult(go, clipCount);
        //    }
        //    EditorGUIUtility.PingObject(AssetDatabase.LoadAssetAtPath<Object>($"Assets/{DEFAULT_TEX_DIR}"));
        //}

        static void ShowResult(GameObject go,int clipCount)
        {
            if (clipCount == 0)
            {
                var sb = new StringBuilder();
                sb.AppendLine("AnimationClips cannt found! Checks:");
                sb.AppendLine("1 (Mesh or AnimationMesh)'s Animation Type must be Legacy!");
                sb.AppendLine("2 Animation Component's Animations maybe has nothing!");
                Debug.Log(sb);
            }
            else
                Debug.Log($"{go} ,clips:{clipCount}");
        }           

        private static List<AnimClipData> GetClips(Animator animator)
        {
            UnityEditor.Animations.AnimatorController controller = animator.runtimeAnimatorController as UnityEditor.Animations.AnimatorController;
            return GetClipsFromStatemachine(controller.layers[0].stateMachine);
        }

        private static List<AnimClipData> GetClipsFromStatemachine(UnityEditor.Animations.AnimatorStateMachine stateMachine)
        {
            List<AnimClipData> list = new List<AnimClipData>();
            for (int i = 0; i != stateMachine.states.Length; ++i)
            {
                UnityEditor.Animations.ChildAnimatorState state = stateMachine.states[i];
                if (state.state.motion is UnityEditor.Animations.BlendTree)
                {
                    UnityEditor.Animations.BlendTree blendTree = state.state.motion as UnityEditor.Animations.BlendTree;
                    ChildMotion[] childMotion = blendTree.children;
                    for (int j = 0; j != childMotion.Length; ++j)
                    {
                        AnimClipData clipData = new AnimClipData();
                        clipData.clip = childMotion[j].motion as AnimationClip;
                        clipData.speed = 1;
                        list.Add(clipData);
                    }
                }
                else if (state.state.motion != null)
                {
                    AnimClipData  clipData = new AnimClipData();
                    clipData.clip = state.state.motion as AnimationClip;
                    clipData.speed = state.state.speed;
                    list.Add(clipData);
                }                    
            }
            for (int i = 0; i != stateMachine.stateMachines.Length; ++i)
            {
                list.AddRange(GetClipsFromStatemachine(stateMachine.stateMachines[i].stateMachine));
            }

            list = list.Select(q => (AnimClipData)q).Distinct().ToList();
          
            return list;
        }

        private static Dictionary<int, AnimClipData> GetStates(Animator animator, List<AnimClipData> clips)
        {
            UnityEditor.Animations.AnimatorController controller = animator.runtimeAnimatorController as UnityEditor.Animations.AnimatorController;
            Dictionary<int, int> states = GetStatesFromStatemachine(controller.layers[0].stateMachine);

            Dictionary<int, AnimClipData> stateClip = new Dictionary<int, AnimClipData>();

            foreach (var state in states)
            {
                AnimClipData data = clips.Find(delegate (AnimClipData clip)
                {
                    if (Animator.StringToHash(clip.clip.name) == state.Value)
                        return true;
                    else
                        return false;

                });
                stateClip.Add(state.Key, data);
            }

            return stateClip;
        }

        private static Dictionary<int, int> GetStatesFromStatemachine(UnityEditor.Animations.AnimatorStateMachine stateMachine)
        {
            Dictionary<int, int> dict = new Dictionary<int, int>();
            for (int i = 0; i != stateMachine.states.Length; ++i)
            {
                UnityEditor.Animations.ChildAnimatorState state = stateMachine.states[i];
                if (state.state.motion is UnityEditor.Animations.BlendTree)
                {
                    //UnityEditor.Animations.BlendTree blendTree = state.state.motion as UnityEditor.Animations.BlendTree;
                    //ChildMotion[] childMotion = blendTree.children;
                    //for (int j = 0; j != childMotion.Length; ++j)
                    //{
                    //    list.Add(childMotion[j].motion as AnimationClip);
                    //}
                }
                else if (state.state.motion != null)
                {
                    AnimationClip clip = state.state.motion as AnimationClip;
                    dict.Add(state.state.nameHash, Animator.StringToHash(clip.name));
                }
            }
            for (int i = 0; i != stateMachine.stateMachines.Length; ++i)
            {
                Dictionary<int, int> childDict = GetStatesFromStatemachine(stateMachine.stateMachines[i].stateMachine);
                foreach (var d in childDict)
                {
                    dict.Add(d.Key, d.Value);
                }
            }
            // var distinctClips = list.Select(q => (AnimationClip)q).Distinct().ToList();

            return dict;
        }


        public int BakeAllClips(GameObject go, List<AnimClipData> clips, Dictionary<int, AnimClipData> states)
        {
            var skin = go.GetComponentInChildren<SkinnedMeshRenderer>();
            
            var dir = $"{Application.dataPath}/{DEFAULT_TEX_DIR}/";
            if (!Directory.Exists(dir))
            {
                Directory.CreateDirectory(dir);
            }

            var manifest = ScriptableObject.CreateInstance<AnimTextureManifest>();

            Vector3 tempPos = skin.transform.position;
            Vector3 tempEuler = go.transform.eulerAngles;
            Vector3 tempScale = skin.transform.lossyScale;

            go.transform.localPosition = Vector3.zero;
            go.transform.localEulerAngles = Vector3.zero;
            go.transform.localScale = Vector3.one;

            skin.transform.parent = go.transform;

            skin.transform.localPosition = Vector3.zero;
            skin.transform.localEulerAngles = Vector3.zero;
            skin.transform.localScale = Vector3.one;

            var yList = GenerateAtlas(skin, clips, out manifest.posTex,out manifest.normalTex,out manifest.tangentTex);
            var count = BakeClip(go, skin, clips, manifest, yList,states);
            manifest.posTex.Apply();
            manifest.normalTex.Apply();

            //output atlas
            AssetDatabase.CreateAsset(manifest.posTex, $"Assets/{DEFAULT_TEX_DIR}/{go.name}_PosTexture.asset");
            AssetDatabase.CreateAsset(manifest.normalTex, $"Assets/{DEFAULT_TEX_DIR}/{go.name}_NormalTexture.asset");
            AssetDatabase.CreateAsset(manifest.tangentTex, $"Assets/{DEFAULT_TEX_DIR}/{go.name}_TangentTexture.asset");
            //output infos
            AssetDatabase.CreateAsset(manifest, $"Assets/{DEFAULT_TEX_DIR}/{go.name}_{typeof(AnimTextureManifest).Name}.asset");

            AssetDatabase.Refresh();

            GameObject newObj = Instantiate(go);
            newObj.name = "GpuAnim_" + go.name;
            var skinObj = newObj.GetComponentInChildren<SkinnedMeshRenderer>();
            GameObject gpuMesh = new GameObject(skinObj.name + "_Gpu");
            gpuMesh.transform.parent = newObj.transform;
            DestroyImmediate(skinObj.gameObject);            
            MeshFilter filter = gpuMesh.AddComponent<MeshFilter>();
            filter.mesh = skin.sharedMesh;
            gpuMesh.AddComponent<MeshRenderer>();
            TextureAnimation aniTex = gpuMesh.AddComponent<TextureAnimation>();
            aniTex.manifest = manifest;
            newObj.transform.localRotation = generatedPrefab.transform.localRotation;
            newObj.transform.localScale = generatedPrefab.transform.localScale;

            //GameObject newObj = new GameObject("GpuAnim_" + go.name);
            //MeshFilter filter = newObj.AddComponent<MeshFilter>();
            //filter.mesh = skin.sharedMesh;
            //newObj.AddComponent<MeshRenderer>();
            //TextureAnimation aniTex = newObj.AddComponent<TextureAnimation>();
            //aniTex.manifest = manifest;
            //Animator newAnimator = newObj.AddComponent<Animator>();
            //Animator oldAnimator = go.GetComponent<Animator>();
            //newAnimator.runtimeAnimatorController = oldAnimator.runtimeAnimatorController;
            //newAnimator.updateMode = oldAnimator.updateMode;
            //newAnimator.cullingMode = oldAnimator.cullingMode;
            //newObj.transform.position = tempPos;
            //newObj.transform.eulerAngles = tempEuler;
            //newObj.transform.localScale = tempScale;

            return count;
        }

        private static int BakeClip(GameObject go, SkinnedMeshRenderer skin, List<AnimClipData> clips, AnimTextureManifest manifest, List<int> yList, Dictionary<int, AnimClipData> states)
        {
            var index = 0;
            foreach (AnimClipData data in clips)
            {
                //tex
                var y = yList[index];
                var width = skin.sharedMesh.vertexCount;
                var frameCount = (int)(data.clip.length * data.clip.frameRate);
                Texture2D posTex = null;
                Texture2D normalTex = null;
                Texture2D tangentTex = null;
                AnimTextureUtils.BakeMeshToTexture(skin, go, data.clip, out posTex,out normalTex,out tangentTex);
                manifest.posTex.SetPixels(0, y, posTex.width, posTex.height, posTex.GetPixels());
                manifest.normalTex.SetPixels(0, y, normalTex.width, normalTex.height, normalTex.GetPixels());
                manifest.tangentTex.SetPixels(0, y, tangentTex.width, tangentTex.height, tangentTex.GetPixels());
                Object.DestroyImmediate(posTex);
                Object.DestroyImmediate(normalTex);
                Object.DestroyImmediate(tangentTex);

                manifest.animInfos.Add(new AnimTextureClipInfo(data.clip.name, y, yList[index + 1])
                {
                    isLoop = data.clip.isLooping,
                    length = data.clip.length,
                    frameRate = data.clip.frameRate,
                    speed = data.speed
                });
                index++;
            }

            foreach(var state in states)
            {
                int i = 0;
                for(; i < clips.Count; i++)
                {
                    if (state.Value.clip.name == clips[i].clip.name)
                        break;
                }
                manifest.stateInfos.Add(new StateInfo(state.Key, i));
            }

            return index;
        }

        static List<int> GenerateAtlas(SkinnedMeshRenderer skin, List<AnimClipData> clips, out Texture2D posTex, out Texture2D normalTex,out Texture2D tangentTex)
        {
            var yList = new List<int>(); 
            var width = skin.sharedMesh.vertexCount;
            var y = 0;
            yList.Add(0);

            foreach (AnimClipData data in clips)
            {
                y += (int)(data.clip.length * data.clip.frameRate);
                yList.Add(y);
            }
            posTex = new Texture2D(width, y, TextureFormat.RGBAHalf, false,true);
            posTex.filterMode = FilterMode.Point;
            normalTex = new Texture2D(width, y, TextureFormat.RGBA32, false,true);
            normalTex.filterMode = FilterMode.Point;
            tangentTex = new Texture2D(width, y, TextureFormat.RGBA32, false, true);
            tangentTex.filterMode = FilterMode.Point;
            return yList;
        }

        public static string GetManifestPath(string goName)
        {
            string path = $"Assets/{DEFAULT_TEX_DIR}/{goName}_{typeof(AnimTextureManifest).Name}.asset";
            return path;
        }
    }
}
#endif
