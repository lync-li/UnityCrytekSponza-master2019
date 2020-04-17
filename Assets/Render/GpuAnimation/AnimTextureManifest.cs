namespace AnimTexture
{
    using System.Collections;
    using System.Collections.Generic;
    using UnityEngine;

    public class AnimTextureManifest : ScriptableObject
    {  
        public List<AnimTextureClipInfo> animInfos = new List<AnimTextureClipInfo>();
        public List<StateInfo> stateInfos = new List<StateInfo>();
        public Texture2D posTex;
        public Texture2D normalTex;
        public Texture2D tangentTex;
    }

    [System.Serializable]
    public class AnimTextureClipInfo
    {
        public string clipName;
        public int clipNameHash;
        public int startFrame;
        public int endFrame;
        public bool isLoop;
        public float length;
        public float frameRate;
        public float speed;

        public AnimTextureClipInfo(string clipName,int startFrame,int endFrame)
        {
            this.clipName = clipName;
            this.startFrame = startFrame;
            this.endFrame = endFrame;

            if(!string.IsNullOrEmpty(clipName))
                clipNameHash = Animator.StringToHash(clipName);
        }
    }

    [System.Serializable]
    public class StateInfo
    {       
        public int stateNameHash;
        public int index;
        public float crossFadeTime;

        public StateInfo(int stateNameHash, int index)
        {
            this.stateNameHash = stateNameHash;
            this.index = index;          
        }
    }
}