//This script will only work in editor mode. You cannot adjust the scale dynamically in-game!
using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class PlayerControl : MonoBehaviour 
{

    public float turnSpeed = 5.0f;
    public float walkSpeed = 20.0f;

    private UnityEngine.AI.NavMeshAgent agent;
    private Animation animation;

    private Vector3 input = new Vector3();
    private Vector3 velocity = new Vector3();
    private float strafe = 0;

    void Start()
    {
        agent = GetComponent<UnityEngine.AI.NavMeshAgent>();

        if (!agent)
        {
            Debug.LogWarning("There is no NavMeshAgent Component attached to this gameObject");
        }

        animation = GetComponentInChildren<Animation>();
    }

    public void move(Vector2 input2)
    {

        input.x = input2.x ;
        input.y = input2.y ;
    }

    public void moveEnd()
    {

        input.x = 0;
        input.y = 0;
    }

    void Update()
    {
        if (agent)
        {
#if UNITY_EDITOR
            input.x = Input.GetAxis("Horizontal");
            input.y = Input.GetAxis("Vertical");

            if (!Input.GetMouseButton(1) && input.x != 0 && strafe == 0)
            {
                transform.Rotate(new Vector3(0, input.x * (turnSpeed / 2.0f), 0));
                input.x = 0;
            }
            else
            {
                if (strafe != 0)
                {
                    input.x = strafe;
                }
            }
#endif

            velocity = new Vector3(input.x, 0, input.y);
            velocity = Camera.main.transform.TransformDirection(velocity) * walkSpeed;
            if (velocity.sqrMagnitude < 1)
                animation.Play("IDLE");
            else
            {
                animation.Play("MOVE_FORWARD");
                transform.eulerAngles = new Vector3(0, Camera.main.transform.eulerAngles.y,0);
            }
               
        }      
    }
    void FixedUpdate()
    {
        agent.Move(velocity * Time.deltaTime);
    }
}
