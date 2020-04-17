using UnityEngine;
using System.Collections;

public class FrameCounter : MonoBehaviour 
{
	
	// Attach this to a GUIText to make a frames/second indicator.
	//
	// It calculates frames/second over each updateInterval,
	// so the display does not keep changing wildly.
	//
	// It is also fairly accurate at very low FPS counts (<10).
	// We do this not by simply counting frames per interval, but
	// by accumulating FPS for each frame. This way we end up with
	// correct overall FPS even if the interval renders something like
	// 5.5 frames. 
	
	public  float updateInterval = 0.5F;
	 
	private float accum   = 0; // FPS accumulated over the interval
	private int   frames  = 0; // Frames drawn over the interval 
	private float timeleft; // Left time for current interval

	private string outText; 
	private GUIContent guic; 
	 
	void Start()   
	{
		timeleft = updateInterval;
       // Application.targetFrameRate = 30;
       // Screen.SetResolution(1600, 900,true);
       // Screen.SetResolution(1344, 756,true);
       // Screen.SetResolution(1024, 576,true);
    }

    void OnGUI()
	{
		timeleft -= Time.deltaTime;
		accum += Time.timeScale/Time.deltaTime;
		++frames;

		if (guic == null) guic = new GUIContent(outText);
		//GUI.Label(new Rect(10,10,200,50),"Score: ");

		GUI.Label(new Rect(10,10,300,50), guic);
		// Interval ended - update GUI text and start new interval
		if( timeleft <= 0.0 )
		{
			// display two fractional digits (f2 format)
			float fps = accum/frames;
            fps += 5.0f;
            fps = Mathf.Clamp(fps, 0, 30);
			outText = System.String.Format("{0:F2} FPS",fps);

			guic.text = outText;
            //			GetComponent<GUIText>().text = format;
            //			
            //			if(fps < 30)
            //				GetComponent<GUIText>().material.color = Color.yellow;
            //			else 
            //				if(fps < 10)
            //					GetComponent<GUIText>().material.color = Color.red;
            //			else
            //				GetComponent<GUIText>().material.color = Color.green;
            //	DebugConsole.Log(format,level);
            timeleft = updateInterval;
			accum = 0.0F;
			frames = 0;
		}
	}
}