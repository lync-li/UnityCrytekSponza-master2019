namespace AnimTexture
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using UnityEngine;

    public class TextureAnimation : MonoBehaviour
    {
        readonly int ID_START_END_FRAME = Shader.PropertyToID("_StartEndFrame"); // startFrame,endFrame,nextStartFrame,nextEndFrame
        readonly int ID_ANIM_PARAM0 = Shader.PropertyToID("_AnimParam0"); // startTime,loop,frameRate,crossFadeTime
        readonly int ID_ANIM_PARAM1 = Shader.PropertyToID("_AnimParam1"); // oldStartTime,oldLoop,
        readonly int ID_UNITY_TIME = Shader.PropertyToID("_Time"); 

        public AnimTextureManifest manifest;

        public int curAnimIndex = 0;
        public string animName;

        private Animator animator;
        private Renderer render;
        private MaterialPropertyBlock block;
        private Dictionary<string, int> stringNameDict;
        private Dictionary<int, int> stateDict;

        private int oldAnimIndex = 0;
        private int oldStateHashName;
        private float lastPlayTime;


        // Start is called before the first frame update
        void Awake()
        {
            render = GetComponent<Renderer>();
            block = new MaterialPropertyBlock();

            animator = GetComponentInParent<Animator>();
         
            stringNameDict = new Dictionary<string, int>();
            for (int i = 0;i< manifest.animInfos.Count;i++ )
            {               
                stringNameDict.Add(manifest.animInfos[i].clipName, i);
            }

            stateDict = new Dictionary<int, int>();
            for (int i = 0; i < manifest.stateInfos.Count; i++)
            {
                stateDict.Add(manifest.stateInfos[i].stateNameHash, manifest.stateInfos[i].index);
            }


            if (curAnimIndex >= 0 && animator == null)
            {
                oldAnimIndex = curAnimIndex;
                Play(curAnimIndex);
            }

        }

        public void Play(string name, float crossFadeTime = 0.25f)
        {
            Play(stringNameDict[name], crossFadeTime);
        }

        public void Play(int index,float crossFadeTime = 0.25f)
        {
            //first play
            if (oldAnimIndex < 0)
                oldAnimIndex = index;

            if (index >= manifest.animInfos.Count || oldAnimIndex >= manifest.animInfos.Count)
            {
                Debug.Log("Index : " + index.ToString() + " out");
                return;
            }
               
            AnimTextureClipInfo oldClipInfo = manifest.animInfos[oldAnimIndex];
            AnimTextureClipInfo nextClipInfo = manifest.animInfos[index];
            block.SetVector(ID_START_END_FRAME, new Vector4(nextClipInfo.startFrame, nextClipInfo.endFrame,oldClipInfo.startFrame,oldClipInfo.endFrame));
            float curPlayTime = Shader.GetGlobalVector(ID_UNITY_TIME).y;
            block.SetVector(ID_ANIM_PARAM0, new Vector4(curPlayTime, nextClipInfo.isLoop == true ? 0 : 1,nextClipInfo.speed, 1.0f/nextClipInfo.frameRate));
            block.SetVector(ID_ANIM_PARAM1, new Vector4(lastPlayTime, oldClipInfo.isLoop == true ? 0 : 1, oldClipInfo.speed, (crossFadeTime == 0)? 9999999.0f : 1.0f /crossFadeTime));
            lastPlayTime = curPlayTime;          

            render.SetPropertyBlock(block);
            oldAnimIndex = index;
            animName = nextClipInfo.clipName;
        }

        public void Update()
        {
            if (animator)
            {
                int shortHashName;
                float crossFadeTime = 0;
                if (animator.IsInTransition(0))
                {
                    crossFadeTime = animator.GetAnimatorTransitionInfo(0).duration;
                    shortHashName = animator.GetNextAnimatorStateInfo(0).shortNameHash;                    
                }               
                else 
                {
                    shortHashName = animator.GetCurrentAnimatorStateInfo(0).shortNameHash;                                     
                }               

                if (shortHashName != oldStateHashName)
                {
                    bool hasKey = stateDict.ContainsKey(shortHashName);
                    if (hasKey)
                    {
                        Play(stateDict[shortHashName], crossFadeTime);
                        oldStateHashName = shortHashName;
                    }
                    else
                    {
                        //没有包含动作的状态 现在不处理
                        //Debug.LogError(animator.GetCurrentAnimatorStateInfo(0).shortNameHash + "cannot find in Dict. Dict count = " + stateDict.Count);                             
                    }                          
                }
            }
            else
            {
                if (curAnimIndex != oldAnimIndex)
                    Play(curAnimIndex, 0.2f);
            }
        }
    }
}
