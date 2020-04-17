using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine.EventSystems;

namespace PhatRobit
{
	public class SimpleRpgCamera : MonoBehaviour
	{
		#region Public Variables

		#region Collision Settings

		public LayerMask collisionLayers = new LayerMask();             // Determines what objects the camera collides with
		public LayerMask avoidanceLayers = new LayerMask();             // Determines what objects the camera will try to avoid (rotate until object no longer obstructs target)

		public float collisionBuffer = 0.2f;                            // A small value to prevent camera clipping
		public bool collisionClipping = false;                          // Lets you change the camera's near clipping plane value while colliding with an object
		public float collisionNearClipping = 0.01f;                     // The value used while colliding
		public float collisionNoClipping = 0.01f;                       // The value used while not colliding
		public bool collisionClippingDetection = false;                 // Tries to detect if there is a collision within the near clipping plane while not colliding

		public LayerMask collisionAlphaLayers = new LayerMask();        // Determines what objects the camera will fade out in front of it
		public float avoidanceSpeed = 0.5f;                             // The speed at which the camera rotates to avoid objects
		public bool ignoreCurrentTarget = true;                         // Ignore the current target's collider
		public bool clampCollision = true;                              // Prevents the camera from getting closer than the minDistance while colliding with objects
		public bool showCollisionDebugLines = false;                    // Displays the raycast line for collison as well as the hit points in editor

		#endregion

		#region Target Settings

		public bool setTargetDoubleClick = false;
		public LayerMask targetDoubleClickLayers = new LayerMask();
		public float targetDoubleClickDelay = 0.25f;
		public bool lockOnNewTarget = true;
		public Transform target;                                            // The camera's target
		public List<Transform> secondaryTargets = new List<Transform>();    // A list of other targets for the camera to track
		public bool focusOnAllTargets = false;
		public string targetTag = string.Empty;                             // The tag of the camera's target, used if no target is set
		public Vector3 targetOffset = new Vector3();                        // An offset relative to the target's position
		public bool smoothOffset = true;
		public float smoothOffsetSpeed = 5;
		public bool relativeOffset = true;                                  // Sets the offset relative to the target's forward rotation
		public bool useTargetAxis = false;                                  // When true, camera follows and rotates relative to target's rotation
		public bool softTracking = false;
		public float softTrackingRadius = 3;
		public float softTrackingSpeed = 3;
		public float shakeIntensity = 0.25f;
		public float shakeDecay = 0.05f;
		public bool audioListenerAtFocalPoint = false;

		#endregion

		#region Movement Settings

		public bool allowMovementDoubleClick = false;
		public LayerMask movementDoubleClickLayers = new LayerMask();
		public float movementDoubleClickDelay = 0.25f;
		public bool allowMouseDrag = false;
		public bool mouseDragBreaksLock = false;
		public MouseButton mouseDragButton = MouseButton.None;
		public bool autoAdjustDragSensitivity = true;                           // Changes the sensitivity based on zoom distance
		public Vector2 mouseMinDragSensitivity = new Vector2(5, 5);
		public Vector2 mouseMaxDragSensitivity = new Vector2(20, 20);
		public bool allowEdgeMovement = false;
		public bool edgeMovementBreaksLock = false;
		public bool allowEdgeKeys = false;
		public bool edgeKeysBreakLock = false;
		public LayerMask movementCollisionLayers = new LayerMask();
		public bool movementCollisionSmoothing = true;
		public float movementCollisionSmoothingSpeed = 5;
		public float movementHitDistance = 50;
		public float movementHitBuffer = 1;
		public bool highpointDetection = true;
		public bool movementCollisionDebug = false;
		public bool lockToTarget = false;
		public bool holdToLock = true;
		public bool limitBounds = false;
		public bool boundsOriginOnTarget = false;
		public Vector3 boundOrigin = new Vector3();
		public Vector3 boundSize = new Vector3();
		public float edgePadding = 20;
		public float scrollSpeed = 10;
		public KeyCode keyFollowTarget = KeyCode.Space;
		public KeyCode keyMoveUp = KeyCode.W;
		public KeyCode keyMoveDown = KeyCode.S;
		public KeyCode keyMoveLeft = KeyCode.A;
		public KeyCode keyMoveRight = KeyCode.D;
		public bool showEdges = false;
		public Texture2D edgeTexture;
		public bool movementSmoothing = true;
		public float movementSmoothSpeed = 5;

		//public bool movementSmoothing = true;
		//public float movementSmoothingSpeed = 5;

		#endregion

		#region Rotation Settings

		public bool allowRotation = true;                               // Whether or not the camera can be rotated by user input
		public bool disableRotationOverGui = true;                      // Disable rotation control while the mouse is hovering over gui elements
		public string mouseHorizontalAxis = "Mouse X";                  // The horizontal axis for mouse input
		public string mouseVerticalAxis = "Mouse Y";                    // The vertical axis for mouse input
		public bool invertRotationX = false;                            // Reverse the rotation direction for X
		public bool invertRotationY = false;                            // Reverse the rotation direction for Y
		public bool mouseLook = false;                                  // Always rotate the camera, ignoring button input from the mouse
		public bool disableWhileUnlocked = true;                        // Disables rotation while the mouse is unlocked
		public bool useJoystick = false;                                // Enables the use of a joystick for rotation
		public Vector2 joystickSensitivity = new Vector2(1, 1);         // Sensitivity for joystick rotation
		public string joystickHorizontalAxis = "JoystickHorizontal";    // The name of the horizontal axis for the joystick
		public string joystickVerticalAxis = "JoystickVertical";        // The name of the vertical axis for the joystick
		public bool allowRotationLeft = true;                           // Whether or not the camera can be rotated with the left mouse button
		public bool allowRotationMiddle = true;                         // Whether or not the camera can be rotated with the middle mouse button
		public bool allowRotationRight = true;                          // Whether or not the camera can be rotated with the right mouse button
		public Vector2 originRotation = new Vector2();                  // The initial rotation of the camera
		public bool returnToOrigin = false;                             // When true, camera will return to originRotation
		public bool returnToOriginOnKey = false;                        // Only return to origin on key press
		public List<KeyCode> returnToOriginKeys = new List<KeyCode>();  // Returns to origin when any of these keys are pressed
		public bool stayBehindTarget = false;                           // When true, camera will stay behind the target while there is no rotation input
		public bool stayBehindTargetOnKey = false;                      // Only return behind the target when stayBehindTargetKey is pressed
		public List<KeyCode> stayBehindTargetKeys = new List<KeyCode>();// Puts the camera behind the target when any of these keys are pressed
		public KeyCode setOriginKey = KeyCode.None;                     // Sets the origin when this key is pressed
		public bool setOriginLeft = false;                              // When true, originRotation becomes current rotation while pressing left mouse button
		public bool setOriginMiddle = false;                            // When true, originRotation becomes current rotation while pressing middle mouse button
		public bool setOriginRight = false;                             // When true, originRotation becomes current rotation while pressing right mouse button
		public bool limitAngleX = false;                                // Limit the X rotation angle
		public float minAngleX = -180;                                  // The minimum X rotation angle
		public float maxAngleX = 180;                                   // The maximum X rotation angle
		public float minAngleY = -85;                                   // The minimum Y rotation angle
		public float maxAngleY = 85;                                    // The maximum Y rotation angle
		public float rotationSmoothing = 5;                             // Determines how quickly the camera will reach its wanted rotation (higher = faster, slower = smoother)
		public bool autoSmoothing = true;                               // This will automatically adjust rotationSmoothing depending on your sensitivity settings
		public float returnSmoothing = 5;                               // The speed at which the camera will return at
		public float returnDelay = 0;                                   // The time (in seconds) for the camera to return while there's no user interaction
		public Vector2 rotationSensitivity = new Vector2(5, 5);         // Mouse sensitivity for rotation
		public bool lockCursor = true;                                  // Whether or not to lock the cursor while rotating the camera with the mouse
		public bool lockLeft = true;                                    // Whether or not to lock the cursor while rotating the camera with the left mouse button
		public bool lockMiddle = true;                                  // Whether or not to lock the cursor while rotating the camera with the middle mouse button
		public bool lockRight = true;                                   // Whether or not to lock the cursor while rotating the camera with the right mouse button
		public bool allowRotationKeys = true;                           // Whether or not the user can rotate the camera using the rotation keys
		public KeyCode keyRotateUp = KeyCode.Keypad5;                   // The key for rotating the camera up
		public KeyCode keyRotateDown = KeyCode.Keypad2;                 // The key for rotating the camera down
		public KeyCode keyRotateLeft = KeyCode.Keypad1;                 // The key for rotating the camera left
		public KeyCode keyRotateRight = KeyCode.Keypad3;                // The key for rotating the camera right
		public Vector2 rotationKeySensitivity = new Vector2(3, 3);      // Key sensitivity for rotation
		public bool rotateObjects = false;                              // Whether or not objects will face forward relative to the camera while rotating
		public List<Transform> objectsToRotate = new List<Transform>(); // The objects to rotate
		public bool autoAddTargetToRotate = false;                      // Automatically adds the current target to ObjectsToRotate if enabled
		public bool rotateObjectsLeft = false;                          // Rotates objects with the left mouse button
		public bool rotateObjectsMiddle = false;                        // Rotates objects with the middle mouse button
		public bool rotateObjectsRight = false;                         // Rotates objects with the right mouse button
		public bool timeoutRotation = false;                            // The camera will start to rotate on its own after timeoutRotationDelay seconds
		public float timeoutRotationDelay = 5;                          // Seconds until the camera will start auto rotating
		public float timeoutRotationSpeed = 7;                          // The speed at which the camera will auto rotate

		#endregion

		#region Zoom Settings

		public bool allowZoom = true;                                   // Whether or not the user can zoom in / out
		public bool disableZoomOverGui = true;                          // Disable zoom control while the mouse is hovering over gui elements
		public float distance = 7;                                      // The distance between the camera and the target
		public float minDistance = 1;                                   // The minimum distance between the camera and the target
		public float maxDistance = 10;                                  // The maximum distance between the camera and the target
		public bool autoAdjustZoomSpeed = false;                        // Increases / Decreases zoom speed based on current distance
		public float zoomSpeed = 1;                                     // The distance the camera will travel while zooming
		public float minZoomSpeed = 1;                                  // The minimum speed used for auto zoom speed adjustment
		public float maxZoomSpeed = 10;                                 // The maximum speed used for auto zoom speed adjustment
		public float zoomSmoothing = 5;                                 // Determines how quickly the camera will reach its wanted zoom level (higher = faster, slower = smoother)
		public bool invertZoom = false;                                 // Reverse the zoom direction
		public bool allowZoomKeys = true;                               // Whether or not the user can zoom in / out using zoom keys
		public KeyCode keyZoomIn = KeyCode.Home;                        // The zoom in key
		public KeyCode keyZoomOut = KeyCode.End;                        // The zoom out key
		public float keyZoomDelay = 0.5f;                               // Delay before zoom is constant while holding a key
		public float zoomKeySensitivity = 0.1f;                         // How fast camera will zoom while key is pressed

		#endregion

		#region Fade Settings

		public bool fadeCurrentTarget = true;
		public float fadeDistance = 1;
		public float fadeAmount = 0.25f;
		public float alphaFadeSpeed = 10;
		public bool replaceShaders = false;
		public Shader transparentShader;

		private Dictionary<Material, Shader> _fadedMats = new Dictionary<Material, Shader>();
		private List<Material> _activeFadedMats = new List<Material>();
		private Dictionary<Material, Shader> _targetMats = new Dictionary<Material, Shader>();

		#endregion

		#region Mobile Settings

		public bool allowTouch = false;
		public float touchSensitivity = 0.7f;

		// Mobile Rotation
		public RotationControlType mobileRotationType = RotationControlType.Drag;
		public int mobileDragRotationTouchCount = 1;
		public float mobileRotationDelay = 0.5f;
		public float mobileSwipeActiveTime = 0.5f;
		public float mobileSwipeMinDistance = 150;
		public Vector2 mobileSwipeRotationAmount = new Vector2(45, 45);

		// Mobile Movement
		public PanControlType mobilePanType = PanControlType.Drag;
		public int mobilePanningTouchCount = 3;
		public float mobilePanSwipeActiveTime = 0.5f;
		public float mobilePanSwipeMinDistance = 150;
		public Vector2 mobilePanSwipeDistance = new Vector2(5, 5);
		public bool mobilePanBreakTargetLock = true;

		// Mobile Zoom
		public bool autoAdjustMobileZoomSpeed = false;
		public float minMobileZoomSpeed = 0.1f;
		public float maxMobileZoomSpeed = 0.7f;
		public float mobileZoomSpeed = 0.1f;

		#endregion

		#endregion

		#region Private Variables

		private float _oldDistance = 0;

		private Vector3 _currentOffset = new Vector3();

		private Quaternion _oldRotation = new Quaternion();
		private Vector2 _angle = new Vector2();

		private bool _targetDoubleClickStarted = false;
		private float _targetDoubleClickTimer = 0;

		private bool _movementDoubleClickStarted = false;
		private float _movementDoubleClickTimer = 0;

		private Vector3 _wantedFocalPosition = new Vector3();

		private float _zoomInTimer = 0;
		private float _zoomOutTimer = 0;

		private float _touchTimer = 0;
		private bool _mobileSwipe = false;
		private float _mobileSwipeStartTime = 0;
		private Vector2 _mobileSwipeStart = new Vector2();
		private float _mobileAngle = 0;

		private bool _mobilePanSwipe = false;
		private float _mobilePanSwipeStartTime = 0;
		private Vector2 _mobilePanSwipeStart = new Vector2();

		private bool _controllable = true;
		private bool _userInControl = false;

		private float _returnTimer = 0;

		private bool _avoidingObject = false;
		private bool _avoidingLeft = false;

		private float _shakeIntensity = 0;
		private float _shakeDecay = 0;
		private Vector3 _shakeOffset = new Vector3();

		private float _currentRotationTimeout = 0;
		private Vector2 _timeoutRotationStartAngle = new Vector2();
		private Vector3 _timeoutPosition = new Vector3();

		private List<Renderer> _targetRenderers = new List<Renderer>();

		private Transform _t;
		private Transform _focalPoint;

		private Camera _camera;

		#endregion

		#region Getters / Setters

		public bool Controllable
		{
			get { return _controllable; }
			set { _controllable = value; }
		}

		public Vector2 CurrentRotation
		{
			get { return _angle; }
			set
			{
				_angle = value;

				Quaternion angleRotation = Quaternion.Euler(_angle.y, _angle.x, 0);
				Quaternion cameraRotation = (useTargetAxis && target ? target.rotation * angleRotation : angleRotation);

				_oldRotation = cameraRotation;
			}
		}

		public float CurrentDistance
		{
			get { return _oldDistance; }
			set
			{
				_oldDistance = value;
				distance = _oldDistance;
			}
		}

		public Transform FocalPoint
		{
			get { return _focalPoint; }
		}

		#endregion

		#region Unity Functions

		void Start()
		{
			_t = Camera.main.transform;

			_oldDistance = distance;
			_angle = originRotation;
			_currentOffset = targetOffset;

			_camera = Camera.main;

			CreateFocalPoint();
			Automagics();

			Quaternion angleRotation = Quaternion.Euler(_angle.y, _angle.x, 0);
			Quaternion cameraRotation = (useTargetAxis && target ? target.rotation * angleRotation : angleRotation);

			// Adjust the camera position using the focal point and calculated rotation and distance from above
			_t.position = _focalPoint.position - cameraRotation * Vector3.forward * distance;

			// Look at the focal point using the target's local up direction converted into world space
			_t.LookAt(_focalPoint.position, (useTargetAxis && target ? target.TransformDirection(Vector3.up) : Vector3.up));

			_oldRotation = cameraRotation;

			if(!transparentShader)
			{
				transparentShader = Shader.Find("Standard");
			}

			if(target)
			{
				_targetRenderers = new List<Renderer>(target.GetComponentsInChildren<Renderer>());
			}
		}

		void Update()
		{
			bool mouseOverGui = EventSystem.current && EventSystem.current.IsPointerOverGameObject();

			#region Rotation Input

			_userInControl = false;
			bool cursorLock = false;

#if UNITY_5
			cursorLock = Cursor.lockState == CursorLockMode.Locked;
#else
		cursorLock = Screen.lockCursor;
#endif

            if (_controllable &&
                allowRotation &&
                ((disableRotationOverGui && !mouseOverGui) || !disableRotationOverGui) &&
                    (useJoystick ||
                    (mouseLook && (disableWhileUnlocked && cursorLock || !disableWhileUnlocked)) ||
                    (allowRotationLeft && Input.GetMouseButton(0)) ||
                    (allowRotationMiddle && Input.GetMouseButton(2)) ||
                    (allowRotationRight && Input.GetMouseButton(1)) ||
                    allowTouch && Input.touchCount > 0))
            {
                _userInControl = true;
                _returnTimer = 0;

                float inputX = 0;
                float inputY = 0;

                // Mobile controls
                if (allowTouch && Application.isMobilePlatform)
                {
                    if (mobileRotationType == RotationControlType.Swipe && Input.touchCount == 1)
                    {
                        Touch touch = Input.GetTouch(0);

                        switch (touch.phase)
                        {
                            case TouchPhase.Began:
                                _mobileSwipe = true;
                                _mobileSwipeStart = touch.position;
                                _mobileSwipeStartTime = Time.time;
                                break;
                            case TouchPhase.Moved:
                            case TouchPhase.Stationary:
                                if (_mobileSwipe)
                                {
                                    if (Time.time - _mobileSwipeStartTime > mobileSwipeActiveTime)
                                    {
                                        _mobileSwipe = false;
                                    }
                                }
                                break;
                            case TouchPhase.Ended:
                                if (_mobileSwipe)
                                {
                                    Vector2 swipeDistance = new Vector2(Mathf.Abs(touch.position.x - _mobileSwipeStart.x), Mathf.Abs(touch.position.y - _mobileSwipeStart.y));
                                    Vector2 swipeDirection = new Vector2();

                                    if (swipeDistance.x > mobileSwipeMinDistance)
                                    {
                                        swipeDirection.x = Mathf.Sign(touch.position.x - _mobileSwipeStart.x);
                                        swipeDirection.x = invertRotationX ? -swipeDirection.x : swipeDirection.x;
                                    }

                                    if (swipeDistance.y > mobileSwipeMinDistance)
                                    {
                                        swipeDirection.y = Mathf.Sign(touch.position.y - _mobileSwipeStart.y);
                                        swipeDirection.y = invertRotationY ? -swipeDirection.y : swipeDirection.y;
                                    }

                                    _angle.x += mobileSwipeRotationAmount.x * swipeDirection.x;
                                    _angle.y += mobileSwipeRotationAmount.y * swipeDirection.y;
                                }

                                _mobileSwipe = false;
                                break;
                        }
                    }
                    else if (mobileRotationType == RotationControlType.TwoTouchRotate && Input.touchCount == 2)
                    {
                        Touch touch = Input.GetTouch(0);
                        Touch touch2 = Input.GetTouch(1);

                        if (touch.phase == TouchPhase.Began ||
                        touch2.phase == TouchPhase.Began)
                        {
                            _mobileAngle = GetAngle(touch.position, touch2.position);
                        }
                        else if (touch.phase == TouchPhase.Moved ||
                        touch2.phase == TouchPhase.Moved)
                        {
                            float a = GetAngle(touch.position, touch2.position);
                            float delta = _mobileAngle - a;

                            if (delta > 180F)
                            {
                                delta = 360F - delta;
                            }
                            else if (delta < -180f)
                            {
                                delta = delta + 360f;
                            }

                            _angle.x += delta * touchSensitivity;

                            _mobileAngle = a;
                        }
                    }
                    else if (mobileRotationType == RotationControlType.Drag && (Input.touchCount == 1 || Input.touchCount == 2))
					{
                        Touch touch = Input.GetTouch(0);
                        bool allowed = false;

                        if(Input.touchCount == 1)
                        {                  
                            if (!EventSystem.current.IsPointerOverGameObject(Input.GetTouch(0).fingerId))
                                allowed = true;
                        }
                        else if (Input.touchCount == 2)
                        {                            
                            if (!EventSystem.current.IsPointerOverGameObject(Input.GetTouch(0).fingerId))
                            {
                                touch = Input.GetTouch(0);
                                allowed = true;
                            }
                               
                            else if(!EventSystem.current.IsPointerOverGameObject(Input.GetTouch(1).fingerId))
                            {
                                touch = Input.GetTouch(1);
                                allowed = true;
                            }
                        }

                        if(!allowed)
                        {

                        }
						else if(touch.phase == TouchPhase.Began)
						{
							_touchTimer = 0;
						}
						else if(touch.phase == TouchPhase.Moved || touch.phase == TouchPhase.Stationary)
						{
							if(_touchTimer >= mobileRotationDelay)
							{
								inputX += touch.deltaPosition.x * touchSensitivity;
								inputY += touch.deltaPosition.y * touchSensitivity;
							}
							else
							{
								_touchTimer += Time.deltaTime;
							}
						}
					}
				}
				else
				{
					if((mouseLook && (disableWhileUnlocked && cursorLock || !disableWhileUnlocked)) ||
								  (allowRotationLeft && Input.GetMouseButton(0)) ||
								  (allowRotationMiddle && Input.GetMouseButton(2)) ||
								  (allowRotationRight && Input.GetMouseButton(1)))
					{
						// Get the mouse axis for camera rotation
						inputX = Input.GetAxis(mouseHorizontalAxis) * rotationSensitivity.x;
						inputY = Input.GetAxis(mouseVerticalAxis) * rotationSensitivity.y;
					}
				}

				if(useJoystick)
				{
					inputX += Input.GetAxis(joystickHorizontalAxis) * joystickSensitivity.x;
					inputY += Input.GetAxis(joystickVerticalAxis) * joystickSensitivity.y;
				}

				_angle.x += inputX * (invertRotationX ? -1 : 1);

				// Limit the X rotation angle
				if(limitAngleX)
				{
					_angle.x = Mathf.Clamp(_angle.x, minAngleX, maxAngleX);
				}

				// Limit the Y rotation angle
				_angle.y = Mathf.Clamp(_angle.y - inputY * (invertRotationY ? -1 : 1), minAngleY, maxAngleY);

				ClampAngle(ref _angle);

				if(Input.GetKey(setOriginKey) ||
				   (setOriginLeft && Input.GetMouseButton(0)) ||
				   (setOriginMiddle && Input.GetMouseButton(2)) ||
				   (setOriginRight && Input.GetMouseButton(1)))
				{
					// Sets the origin rotation to the current rotation
					originRotation = _angle;
				}

				// Lock the cursor if enabled
				bool lockTheCursor = (lockCursor && (mouseLook ||
									(lockLeft && Input.GetMouseButton(0)) ||
									(lockMiddle && Input.GetMouseButton(2)) ||
									(lockRight && Input.GetMouseButton(1))));

#if UNITY_5
				Cursor.lockState = lockTheCursor ? CursorLockMode.Locked : CursorLockMode.None;
#else
			Screen.lockCursor = lockTheCursor;
#endif

				// Force the target's y rotation to face forward (if enabled) when rotating
				if(rotateObjects && (mouseLook ||
									(rotateObjectsLeft && Input.GetMouseButton(0)) ||
									(rotateObjectsMiddle && Input.GetMouseButton(2)) ||
									(rotateObjectsRight && Input.GetMouseButton(1))))
				{
					RotateObjects();
				}
			}
			else if(_controllable &&
					allowRotationKeys && (Input.GetKey(keyRotateUp) ||
										  Input.GetKey(keyRotateDown) ||
										  Input.GetKey(keyRotateLeft) ||
										  Input.GetKey(keyRotateRight)))
			{
				_userInControl = true;
				_returnTimer = 0;

				// Shorthand for pressing either left or right rotation keys, but not both
				int directionX = !(Input.GetKey(keyRotateLeft) && Input.GetKey(keyRotateRight)) ?
									(Input.GetKey(keyRotateLeft) ? 1 :
										(Input.GetKey(keyRotateRight) ? -1 : 0)) : 0;

				_angle.x += directionX * rotationKeySensitivity.x * (invertRotationX ? -1 : 1);

				// Limit the X rotation angle
				if(limitAngleX)
				{
					_angle.x = Mathf.Clamp(_angle.x, minAngleX, maxAngleX);
				}

				// Shorthand for pressing either up or down rotation keys, but not both
				int directionY = !(Input.GetKey(keyRotateUp) && Input.GetKey(keyRotateDown)) ?
									(Input.GetKey(keyRotateUp) ? -1 :
										(Input.GetKey(keyRotateDown) ? 1 : 0)) : 0;

				// Limit the Y rotation angle
				_angle.y = Mathf.Clamp(_angle.y - directionY * rotationKeySensitivity.y * (invertRotationY ? -1 : 1), minAngleY, maxAngleY);

				ClampAngle(ref _angle);
			}
			else
			{
				_userInControl = false;

				if(Input.GetKey(setOriginKey))
				{
					originRotation = _angle;
				}

				if(returnToOrigin)
				{
					// Forces the camera back to the origin rotation
					if(_returnTimer >= returnDelay)
					{
						bool returnKey = false;

						if(returnToOriginOnKey)
						{
							foreach(KeyCode key in returnToOriginKeys)
							{
								if(Input.GetKey(key))
								{
									returnKey = true;
									break;
								}
							}
						}

						if(!returnToOriginOnKey || returnKey)
						{
							_angle = originRotation;
						}
					}
					else
					{
						_returnTimer += Time.deltaTime;
					}
				}

				if(target && stayBehindTarget)
				{
					// Forces the camera to be behind the target
					if(_returnTimer >= returnDelay)
					{
						bool returnKey = false;

						if(stayBehindTargetOnKey)
						{
							foreach(KeyCode key in stayBehindTargetKeys)
							{
								if(Input.GetKey(key))
								{
									returnKey = true;
									break;
								}
							}
						}

						if(!stayBehindTargetOnKey || returnKey)
						{
							_angle.x = target.rotation.eulerAngles.y;
						}
					}
					else
					{
						_returnTimer += Time.deltaTime;
					}
				}

				// Unlock the cursor
#if UNITY_5
				Cursor.lockState = CursorLockMode.None;
#else
			Screen.lockCursor = false;
#endif
			}

#if UNITY_5
			Cursor.visible = Cursor.lockState == CursorLockMode.None;
#endif

			#endregion

			#region Zoom Input

			if(_controllable && ((disableZoomOverGui && !mouseOverGui) || !disableZoomOverGui))
			{
				if(allowZoom || allowZoomKeys)
				{
					if(allowTouch && Application.isMobilePlatform)
					{
						if(Input.touchCount == 2)
						{
							Touch t1 = Input.GetTouch(0);
							Touch t2 = Input.GetTouch(1);

							Vector2 t1Previous = t1.position - t1.deltaPosition;
							Vector2 t2Previous = t2.position - t2.deltaPosition;

							float previousDelta = (t1Previous - t2Previous).magnitude;
							float currentDelta = (t1.position - t2.position).magnitude;

							float deltaMagnitude = previousDelta - currentDelta;

							float zSpeed = mobileZoomSpeed;

							if(autoAdjustMobileZoomSpeed)
							{
								float d = (distance - minDistance) / (maxDistance - minDistance);
								zSpeed = Mathf.Lerp(minMobileZoomSpeed, maxMobileZoomSpeed, d);
							}

							distance = Mathf.Clamp(distance + deltaMagnitude * zSpeed, minDistance, maxDistance);
						}
					}
					else
					{
						float scrollDirection = 0;
						float zoomModifier = 1;

						if(allowZoom)
						{
							// Zoom mouse control
							scrollDirection = Input.GetAxis("Mouse ScrollWheel");
						}

						if(allowZoomKeys)
						{
							// Zoom key control

							// If zoom in key pressed, add to the zoom in delay timer
							if(Input.GetKey(keyZoomIn))
							{
								zoomModifier = zoomKeySensitivity;
								if(_zoomInTimer < keyZoomDelay)
								{
									_zoomInTimer += Time.deltaTime;
								}
							}
							else
							{
								_zoomInTimer = 0;
							}

							// If zoom out key pressed, add to the zoom out delay timer
							if(Input.GetKey(keyZoomOut))
							{
								zoomModifier = zoomKeySensitivity;
								if(_zoomOutTimer < keyZoomDelay)
								{
									_zoomOutTimer += Time.deltaTime;
								}
							}
							else
							{
								_zoomOutTimer = 0;
							}

							// If both zoom keys are pressed, don't allow constant zooming
							if(Input.GetKey(keyZoomIn) && Input.GetKey(keyZoomOut))
							{
								_zoomInTimer = 0;
								_zoomOutTimer = 0;
							}

							if(Input.GetKeyDown(keyZoomIn) || _zoomInTimer >= keyZoomDelay)
							{
								scrollDirection = 1;
							}

							if(Input.GetKeyDown(keyZoomOut) || _zoomOutTimer >= keyZoomDelay)
							{
								scrollDirection = -1;
							}
						}

						float zSpeed = zoomSpeed;

						if(autoAdjustZoomSpeed)
						{
							float d = (distance - minDistance) / (maxDistance - minDistance);
							zSpeed = Mathf.Lerp(minZoomSpeed, maxZoomSpeed, d);
						}

						// Adjust the distance with the mouse scrollwheel while clamping it to min and max values and invert it if enabled
						distance = Mathf.Clamp(distance + (scrollDirection != 0 ? (scrollDirection < 0 ? (invertZoom ? -zSpeed : zSpeed) : (invertZoom ? zSpeed : -zSpeed)) : 0) * zoomModifier, minDistance, maxDistance);
					}
				}
			}

			#endregion

			#region Movement Input

			if(_focalPoint)
			{
				if(_controllable && (allowEdgeMovement || allowEdgeKeys || allowMouseDrag || allowMovementDoubleClick))
				{
					Vector3 mousePosition = Input.mousePosition;
					Vector3 scrollVelocity = new Vector3();

					if(allowMovementDoubleClick)
					{
						if(_movementDoubleClickStarted)
						{
							if(Input.GetMouseButtonDown(0))
							{
								Ray ray = _camera.ScreenPointToRay(mousePosition);
								RaycastHit hit;

								if(Physics.Raycast(ray, out hit, 1000, movementDoubleClickLayers))
								{
									_wantedFocalPosition = hit.point;
								}

								_movementDoubleClickStarted = false;
							}

							_movementDoubleClickTimer += Time.deltaTime;

							if(_movementDoubleClickTimer >= movementDoubleClickDelay)
							{
								_movementDoubleClickStarted = false;
							}
						}
						else
						{
							if(Input.GetMouseButtonDown(0))
							{
								_movementDoubleClickStarted = true;
								_movementDoubleClickTimer = 0;
							}
						}
					}

					if(allowTouch && Application.isMobilePlatform)
					{
						if(mobilePanType == PanControlType.Swipe)
						{
							if(Input.touchCount > 0)
							{
								Touch touch = Input.GetTouch(0);

								switch(touch.phase)
								{
									case TouchPhase.Began:
										_mobilePanSwipe = true;
										_mobilePanSwipeStart = touch.position;
										_mobilePanSwipeStartTime = Time.time;
										break;
									case TouchPhase.Moved:
									case TouchPhase.Stationary:
										if(_mobilePanSwipe)
										{
											if(Time.time - _mobilePanSwipeStartTime > mobilePanSwipeActiveTime)
											{
												_mobilePanSwipe = false;
											}
										}
										break;
									case TouchPhase.Ended:
										if(_mobilePanSwipe)
										{
											Vector2 swipeDistance = new Vector2(Mathf.Abs(touch.position.x - _mobilePanSwipeStart.x), Mathf.Abs(touch.position.y - _mobilePanSwipeStart.y));
											Vector2 swipeDirection = new Vector2();

											if((Time.time - _mobilePanSwipeStartTime <= mobilePanSwipeActiveTime))
											{
												if(swipeDistance.x > mobilePanSwipeMinDistance)
												{
													swipeDirection.x = Mathf.Sign(touch.position.x - _mobilePanSwipeStart.x);
												}

												if(swipeDistance.y > mobilePanSwipeMinDistance)
												{
													swipeDirection.y = Mathf.Sign(touch.position.y - _mobilePanSwipeStart.y);
												}

												scrollVelocity = new Vector3(swipeDirection.x * mobilePanSwipeDistance.x, 0, swipeDirection.y * mobilePanSwipeDistance.y);

												if(lockToTarget && mobilePanBreakTargetLock)
												{
													lockToTarget = false;
												}
											}

											_mobilePanSwipe = false;
										}
										break;
								}
							}
						}
						else if(mobilePanType == PanControlType.Drag)
						{
							if(Input.touchCount == mobilePanningTouchCount)
							{
								Vector2 delta = Input.GetTouch(0).deltaPosition;

								scrollVelocity = new Vector3(delta.x, 0, delta.y) * touchSensitivity;

								if(lockToTarget && mobilePanBreakTargetLock)
								{
									lockToTarget = false;
								}
							}
						}
					}
					else
					{
						float topEdge = Screen.height - edgePadding;
						float bottomEdge = edgePadding;
						float leftEdge = edgePadding;
						float rightEdge = Screen.width - edgePadding;
						Rect screenRect = new Rect(0, 0, Screen.width, Screen.height);
						bool mouseInWindow = screenRect.Contains(Input.mousePosition);

						// Set the movement direction based off of mouse position or key input
						if((mousePosition.y >= topEdge && allowEdgeMovement && mouseInWindow) || (Input.GetKey(keyMoveUp) && allowEdgeKeys))
						{
							if(lockToTarget && ((edgeMovementBreaksLock && !Input.GetKey(keyMoveUp)) || (edgeKeysBreakLock && Input.GetKey(keyMoveUp))))
							{
								lockToTarget = false;
							}

							scrollVelocity.z = -scrollSpeed;
						}
						else if((mousePosition.y <= bottomEdge && allowEdgeMovement && mouseInWindow) || (Input.GetKey(keyMoveDown) && allowEdgeKeys))
						{
							if(lockToTarget && ((edgeMovementBreaksLock && !Input.GetKey(keyMoveDown)) || (edgeKeysBreakLock && Input.GetKey(keyMoveDown))))
							{
								lockToTarget = false;
							}

							scrollVelocity.z = scrollSpeed;
						}

						if((mousePosition.x <= leftEdge && allowEdgeMovement && mouseInWindow) || (Input.GetKey(keyMoveLeft) && allowEdgeKeys))
						{
							if(lockToTarget && ((edgeMovementBreaksLock && !Input.GetKey(keyMoveLeft)) || (edgeKeysBreakLock && Input.GetKey(keyMoveLeft))))
							{
								lockToTarget = false;
							}

							scrollVelocity.x = scrollSpeed;
						}
						else if((mousePosition.x >= rightEdge && allowEdgeMovement && mouseInWindow) || (Input.GetKey(keyMoveRight) && allowEdgeKeys))
						{
							if(lockToTarget && ((edgeMovementBreaksLock && !Input.GetKey(keyMoveRight)) || (edgeKeysBreakLock && Input.GetKey(keyMoveRight))))
							{
								lockToTarget = false;
							}

							scrollVelocity.x = -scrollSpeed;
						}

						if(allowMouseDrag && Input.GetMouseButton((int)mouseDragButton))
						{
							Vector2 sensitivity = mouseMinDragSensitivity;

							if(autoAdjustDragSensitivity)
							{
								float d = (distance - minDistance) / (maxDistance - minDistance);
								sensitivity = Vector2.Lerp(mouseMinDragSensitivity, mouseMaxDragSensitivity, d);
							}

							if(lockToTarget && mouseDragBreaksLock)
							{
								lockToTarget = false;
							}

							scrollVelocity = new Vector3(Input.GetAxis(mouseHorizontalAxis) * sensitivity.x, 0, Input.GetAxis(mouseVerticalAxis) * sensitivity.y);
						}
					}

					// Get the camera's forward direction so we can move relative to it
					Vector3 cameraDirection = _t.forward;
					cameraDirection.y = 0;
					Quaternion referentialShift = Quaternion.FromToRotation(-Vector3.forward, cameraDirection);
					Vector3 moveDirection = referentialShift * scrollVelocity;

					// Move the focal point
					_wantedFocalPosition += moveDirection * Time.deltaTime;

					// Movement Collision Detection
					if(movementCollisionLayers != 0)
					{
						float highest = 0;
						Ray ray = new Ray(_wantedFocalPosition + Vector3.up * movementHitDistance, Vector3.down);
						RaycastHit hit;

						if(Physics.Raycast(ray, out hit, movementHitDistance * 2, movementCollisionLayers))
						{
							highest = hit.point.y;
						}

						// find the highest point between the camera and focal point and move the focal point Y to it
						if(highpointDetection)
						{
							List<float> peaks = new List<float>();

							for(int n = 0; n < 12; n++)
							{
								Vector3 point = Vector3.Lerp(_wantedFocalPosition, _t.position, n / 12f);

								Ray pointRay = new Ray(point + Vector3.up * movementHitDistance, Vector3.down);
								RaycastHit pointHit;

								if(Physics.Raycast(pointRay, out pointHit, movementHitDistance * 2, movementCollisionLayers))
								{
									if(movementCollisionDebug)
									{
										Debug.DrawLine(point, pointHit.point, Color.red);
									}

									if(pointHit.point.y > highest)
									{
										peaks.Add(pointHit.point.y);
									}
								}
							}

							foreach(float peak in peaks)
							{
								if(peak > highest)
								{
									highest = peak;
								}
							}
						}
						//

						_wantedFocalPosition = movementCollisionSmoothing ? Vector3.Lerp(_wantedFocalPosition, new Vector3(_wantedFocalPosition.x, highest + movementHitBuffer, _wantedFocalPosition.z), Time.deltaTime * movementCollisionSmoothingSpeed) : new Vector3(_wantedFocalPosition.x, highest + movementHitBuffer, _wantedFocalPosition.z);
					}

					if(limitBounds)
					{
						// Make sure we don't go out of bounds
						Vector3 origin = boundOrigin;

						if(boundsOriginOnTarget)
						{
							origin = target.position + boundOrigin;
						}

						Vector3 position = _wantedFocalPosition;

						position.x = Mathf.Clamp(_wantedFocalPosition.x, origin.x - boundSize.x / 2f, origin.x + boundSize.x / 2f);
						position.y = Mathf.Clamp(_wantedFocalPosition.y, origin.y - boundSize.y / 2f, origin.y + boundSize.y / 2f);
						position.z = Mathf.Clamp(_wantedFocalPosition.z, origin.z - boundSize.z / 2f, origin.z + boundSize.z / 2f);

						_wantedFocalPosition = position;
					}

					_focalPoint.position = movementSmoothing ? Vector3.Lerp(_focalPoint.position, _wantedFocalPosition, Time.deltaTime * movementSmoothSpeed) : _wantedFocalPosition;
				}

				// If we aren't using edge movement or want to lock to the target, set the focal point to the target
				if(target)
				{
					if(Input.GetKey(keyFollowTarget))
					{
						lockToTarget = true;
					}
					else if(holdToLock)
					{
						lockToTarget = false;
					}

					if(setTargetDoubleClick)
					{
						if(_targetDoubleClickStarted)
						{
							if(Input.GetMouseButtonDown(0))
							{
								Ray ray = _camera.ScreenPointToRay(Input.mousePosition);
								RaycastHit hit;

								if(Physics.Raycast(ray, out hit, 1000, targetDoubleClickLayers))
								{
									target = hit.transform;
									lockToTarget = lockOnNewTarget;
								}

								_targetDoubleClickStarted = false;
							}

							_targetDoubleClickTimer += Time.deltaTime;

							if(_targetDoubleClickTimer >= targetDoubleClickDelay)
							{
								_targetDoubleClickStarted = false;
							}
						}
						else
						{
							if(Input.GetMouseButtonDown(0))
							{
								_targetDoubleClickStarted = true;
								_targetDoubleClickTimer = 0;
							}
						}
					}

					if(lockToTarget || (!allowEdgeMovement && !allowEdgeKeys && !allowMouseDrag))
					{
						Vector3 offset = target.rotation * targetOffset;

						if(!relativeOffset)
						{
							offset = targetOffset;
						}

						_currentOffset = smoothOffset ? Vector3.Lerp(_currentOffset, offset, smoothOffsetSpeed * Time.deltaTime) : offset;

						Vector3 focalPointTarget = target.position + _currentOffset;

						// set the focal point position in the middle of all targets (if enabled)
						if(focusOnAllTargets)
						{
							Vector3 combinedPositions = target.position;

							foreach(Transform sTarget in secondaryTargets)
							{
								if(sTarget)
								{
									combinedPositions += sTarget.position;
								}
							}

							focalPointTarget = combinedPositions / (secondaryTargets.Count + 1) + _currentOffset;
						}

						if(softTracking && softTrackingRadius > 0)
						{
							float distanceToTarget = Vector3.Distance(_focalPoint.position, focalPointTarget);
							Vector3 newFpTarget = _focalPoint.position;

							if(distanceToTarget > softTrackingRadius)
							{
								newFpTarget = Vector3.Lerp(_focalPoint.position, _focalPoint.position + (focalPointTarget - _focalPoint.position).normalized, Time.deltaTime * (distanceToTarget / softTrackingRadius) * softTrackingSpeed);
							}

							focalPointTarget = newFpTarget;
						}

						_focalPoint.position = focalPointTarget + _shakeOffset;
						_wantedFocalPosition = _focalPoint.position;
					}
				}
			}

			#endregion

			#region FocalPoint Creation, TargetTag and Fade Control

			// auto rotation timeout
			if(timeoutRotation && _currentRotationTimeout < timeoutRotationDelay)
			{
				_currentRotationTimeout += Time.deltaTime;

				if(_currentRotationTimeout >= timeoutRotationDelay)
				{
					_timeoutRotationStartAngle = _angle;
				}
			}

			if(!timeoutRotation ||
				Input.anyKey ||
				Input.GetAxis(mouseHorizontalAxis) != 0 ||
				Input.GetAxis(mouseVerticalAxis) != 0 ||
				Input.GetAxis(joystickHorizontalAxis) != 0 ||
				Input.GetAxis(joystickVerticalAxis) != 0 ||
				Vector3.Distance(_wantedFocalPosition, _timeoutPosition) > 0.1f)
			{
				if(_currentRotationTimeout >= timeoutRotationDelay)
				{
					_angle = _timeoutRotationStartAngle;
				}

				_currentRotationTimeout = 0;
				_timeoutPosition = _wantedFocalPosition;
			}

			if(!_focalPoint)
			{
				CreateFocalPoint();
			}

			if(!target)
			{
				// Find our target via tag if we don't have a target
				if(targetTag != string.Empty)
				{
					GameObject targetGameObject = GameObject.FindWithTag(targetTag);

					if(targetGameObject)
					{
						target = targetGameObject.transform;
						Automagics();
						MoveToTarget();

						if(target)
						{
							_targetRenderers = new List<Renderer>(target.GetComponentsInChildren<Renderer>());
						}
					}
				}
			}

			// Fade the current target depending on zoom distance
			if(fadeCurrentTarget)
			{
				float alpha = Mathf.Clamp(_oldDistance - fadeDistance, 0, 1);

				if(alpha < 1)
				{
					for(int i = 0; i < _targetRenderers.Count; i++)
					{
						if(_targetRenderers[i])
						{
							for(int m = 0; m < _targetRenderers[i].materials.Length; m++)
							{
								if(!_targetMats.ContainsKey(_targetRenderers[i].materials[m]))
								{
									_targetMats.Add(_targetRenderers[i].materials[m], _targetRenderers[i].materials[m].shader);

									if(replaceShaders)
									{
										_targetRenderers[i].materials[m].shader = transparentShader;

										if(_targetRenderers[i].materials[m].shader.name == "Standard")
										{
											_targetRenderers[i].materials[m].SetFloat("_Mode", 2);
											_targetRenderers[i].materials[m].SetInt("_SrcBlend", (int)UnityEngine.Rendering.BlendMode.SrcAlpha);
											_targetRenderers[i].materials[m].SetInt("_DstBlend", (int)UnityEngine.Rendering.BlendMode.OneMinusSrcAlpha);
											_targetRenderers[i].materials[m].SetInt("_ZWrite", 1);
											_targetRenderers[i].materials[m].DisableKeyword("_ALPHATEST_ON");
											_targetRenderers[i].materials[m].EnableKeyword("_ALPHABLEND_ON");
											_targetRenderers[i].materials[m].DisableKeyword("_ALPHAPREMULTIPLY_ON");
											_targetRenderers[i].materials[m].renderQueue = 3000;
										}
									}
								}

								if(_targetRenderers[i].materials[m].HasProperty("_Color"))
								{
									Color c = _targetRenderers[i].materials[m].color;
									c.a = alpha;
									_targetRenderers[i].materials[m].color = c;
								}
							}
						}
					}
				}
				else
				{
					if(_targetMats.Count > 0)
					{
						foreach(KeyValuePair<Material, Shader> entry in _targetMats)
						{
							if(entry.Key.HasProperty("_Color"))
							{
								Color c = entry.Key.color;
								c.a = 1;
								entry.Key.color = c;
							}

							if(replaceShaders)
							{
								entry.Key.shader = entry.Value;
							}
						}

						_targetMats.Clear();
					}
				}
			}
			else
			{
				if(_targetMats.Count > 0)
				{
					foreach(KeyValuePair<Material, Shader> entry in _targetMats)
					{
						if(entry.Key.HasProperty("_Color"))
						{
							Color c = entry.Key.color;
							c.a = 1;
							entry.Key.color = c;
						}

						if(replaceShaders)
						{
							entry.Key.shader = entry.Value;
						}
					}

					_targetMats.Clear();
				}
			}

			// Fade back in the faded out objects that were in front of the camera
			if(_fadedMats.Count > 0)
			{
				foreach(KeyValuePair<Material, Shader> entry in _fadedMats)
				{
					if(_activeFadedMats.Contains(entry.Key))
					{
						continue;
					}

					if((entry.Key.HasProperty("_Color") && entry.Key.color.a >= 0.99f) || !entry.Key.HasProperty("_Color"))
					{
						if(replaceShaders)
						{
							entry.Key.shader = entry.Value;
						}

						_fadedMats.Remove(entry.Key);
						break;
					}
					else
					{
						Color c = entry.Key.color;
						c.a = 1;
						entry.Key.color = Color.Lerp(entry.Key.color, c, Time.deltaTime * alphaFadeSpeed);
					}
				}
			}

			#endregion
		}

		void LateUpdate()
		{
			if(target && _focalPoint)
			{
				#region Camera Control

				// Auto Timeout Rotation
				if(timeoutRotation && _currentRotationTimeout >= timeoutRotationDelay)
				{
					_angle.x += Time.deltaTime * timeoutRotationSpeed;
				}

				// Object Avoidance
				if(!_userInControl && Physics.Linecast(_focalPoint.position, _t.position, avoidanceLayers))
				{
					if(_avoidingObject)
					{
						_angle.x += _avoidingLeft ? -avoidanceSpeed : avoidanceSpeed;
					}
					else
					{
						_avoidingObject = true;

						RaycastHit leftHit;
						RaycastHit rightHit;
						bool left = false;
						bool right = false;

						left = Physics.Linecast(_focalPoint.position, _t.position + Vector3.left, out leftHit, avoidanceLayers);
						right = Physics.Linecast(_focalPoint.position, _t.position + Vector3.right, out rightHit, avoidanceLayers);

						if(left && right)
						{
							float leftDistance = Vector3.Distance(leftHit.point, _t.position);
							float rightDistance = Vector3.Distance(rightHit.point, _t.position);

							_avoidingLeft = rightDistance < leftDistance;
						}
						else if(right)
						{
							_avoidingLeft = false;
						}
						else
						{
							_avoidingLeft = true;
						}
					}
				}
				else
				{
					_avoidingLeft = false;
					_avoidingObject = false;
				}

				if(autoSmoothing)
				{
					rotationSmoothing = (rotationSensitivity.x > rotationSensitivity.y ? rotationSensitivity.x : rotationSensitivity.y) + 3;
					rotationSmoothing += useJoystick ? (joystickSensitivity.x > joystickSensitivity.y ? joystickSensitivity.x : joystickSensitivity.y) + 3 : 0;
				}

				// Smoothly rotate the camera based on input angle
				Quaternion angleRotation = Quaternion.Euler(_angle.y, _angle.x, 0);
				Quaternion cameraRotation = (useTargetAxis ? target.rotation * angleRotation : angleRotation);

				Quaternion currentRotation = Quaternion.Lerp(_oldRotation, cameraRotation, Time.deltaTime * (_userInControl || _returnTimer < returnDelay ? rotationSmoothing : ((returnToOrigin || stayBehindTarget) ? returnSmoothing : rotationSmoothing)));

				_oldRotation = currentRotation;

				// Smoothly adjust the distance from the target
				float currentDistance = Mathf.Lerp(_oldDistance, distance, Time.deltaTime * zoomSmoothing);

				if(Mathf.Abs(currentDistance - distance) <= 0.001f)
				{
					currentDistance = distance;
				}

				// See where the camera WANTS to be so we can detect collisions
				Vector3 wantedPosition = _focalPoint.position - currentRotation * Vector3.forward * (distance + collisionBuffer);

				// Test if there are objects between the camera and the target using collision layers
				RaycastHit[] hits = Physics.RaycastAll(_focalPoint.position, wantedPosition - _focalPoint.position, distance + collisionBuffer, collisionLayers);
				List<float> hitDistances = new List<float>();

				if(showCollisionDebugLines)
				{
					Debug.DrawLine(_focalPoint.position, wantedPosition, Color.yellow);
				}

				// Set the near clipping plane value if enabled
				if(collisionClipping)
				{
					if(hits.Length > 0)
					{
						_camera.nearClipPlane = collisionNearClipping;
					}
					else
					{
						float clip = collisionNoClipping;

						if(collisionClippingDetection)
						{
							RaycastHit clippingHit;

							if(Physics.Raycast(new Ray(wantedPosition, Vector3.down), out clippingHit, collisionNoClipping, collisionLayers))
							{
								clip = Vector3.Distance(wantedPosition, clippingHit.point);
							}
						}

						_camera.nearClipPlane = Mathf.Clamp(clip, collisionNearClipping, collisionNoClipping);
					}
				}

				foreach(RaycastHit hit in hits)
				{
					bool collision = true;

					if(showCollisionDebugLines)
					{
						Debug.DrawLine(hit.point, hit.point + hit.normal, Color.red);
					}

					if(ignoreCurrentTarget)
					{
						Collider[] colliders = target.GetComponentsInChildren<Collider>();

						foreach(Collider collider in colliders)
						{
							if(collider && hit.collider == collider)
							{
								collision = false;
								break;
							}
						}
					}

					if(collision)
					{
						// Put all collision distances into a list so we can find the closest one
						hitDistances.Add(Vector3.Distance(_focalPoint.position, hit.point) - collisionBuffer);
					}
				}

				float closest = Mathf.Infinity;

				foreach(float hitDistance in hitDistances)
				{
					if(hitDistance < closest)
					{
						closest = hitDistance;
					}
				}

				if(currentDistance > closest)
				{
					currentDistance = clampCollision ? Mathf.Clamp(closest, minDistance, maxDistance) : closest;
				}

				_oldDistance = currentDistance;

				// Adjust the camera position using the focal point and calculated rotation and distance from above
				_t.position = _focalPoint.position - currentRotation * Vector3.forward * currentDistance;

				// Look at the focal point using the target's local up direction converted into world space
				_t.LookAt(_focalPoint.position, (useTargetAxis ? target.TransformDirection(Vector3.up) : Vector3.up));

				#endregion

				#region Fade Control

				// Fade out any objects in front of the camera in the alpha layer mask
				Ray ray = new Ray(_focalPoint.position, _t.position - _focalPoint.position);
				RaycastHit[] alphaHits = Physics.RaycastAll(ray, _oldDistance, collisionAlphaLayers);

				_activeFadedMats.Clear();

				foreach(RaycastHit alphaHit in alphaHits)
				{
					Renderer hitRenderer = alphaHit.transform.GetComponent<Renderer>();

					if(hitRenderer)
					{
						Material[] mats = hitRenderer.materials;

						foreach(Material mat in mats)
						{
							if(mat.HasProperty("_Color"))
							{
								Color c = mat.color;
								c.a = fadeAmount;

								mat.color = Color.Lerp(mat.color, c, Time.deltaTime * alphaFadeSpeed);
							}

							_activeFadedMats.Add(mat);

							if(!_fadedMats.ContainsKey(mat))
							{
								_fadedMats.Add(mat, mat.shader);

								if(replaceShaders)
								{
									mat.shader = transparentShader;

									if(mat.shader.name == "Standard")
									{
										mat.SetFloat("_Mode", 2);
										mat.SetInt("_SrcBlend", (int)UnityEngine.Rendering.BlendMode.SrcAlpha);
										mat.SetInt("_DstBlend", (int)UnityEngine.Rendering.BlendMode.OneMinusSrcAlpha);
										mat.SetInt("_ZWrite", 1);
										mat.DisableKeyword("_ALPHATEST_ON");
										mat.EnableKeyword("_ALPHABLEND_ON");
										mat.DisableKeyword("_ALPHAPREMULTIPLY_ON");
										mat.renderQueue = 3000;
									}
								}
							}
						}
					}
				}

				#endregion
			}
		}

		// Draw the edge textures and bound limit, mostly for debugging
		void OnGUI()
		{
			if(allowEdgeMovement && showEdges && edgeTexture)
			{
				Rect topEdge = new Rect(0, 0, Screen.width, edgePadding);
				Rect bottomEdge = new Rect(0, Screen.height - edgePadding, Screen.width, Screen.height);
				Rect leftEdge = new Rect(0, 0, edgePadding, Screen.height);
				Rect rightEdge = new Rect(Screen.width - edgePadding, 0, Screen.width, Screen.height);

				GUI.DrawTexture(topEdge, edgeTexture);
				GUI.DrawTexture(bottomEdge, edgeTexture);
				GUI.DrawTexture(leftEdge, edgeTexture);
				GUI.DrawTexture(rightEdge, edgeTexture);
			}
		}

		void OnDrawGizmos()
		{
			if(limitBounds)
			{
				if(target && boundsOriginOnTarget)
				{
					Gizmos.DrawWireCube(target.position + boundOrigin, boundSize);
				}
				else
				{
					Gizmos.DrawWireCube(boundOrigin, boundSize);
				}
			}

			if(softTracking && target)
			{
				Gizmos.DrawWireSphere(target.position, softTrackingRadius);
			}
		}

		#endregion

		#region Helper Functions

		public void CameraShake(float intensity = 0, float decay = 0)
		{
			_shakeIntensity = intensity == 0 ? shakeIntensity : intensity;
			_shakeDecay = decay == 0 ? shakeDecay : decay;
			StartCoroutine(ShakeAndBake());
		}

		private IEnumerator ShakeAndBake()
		{
			while(_shakeIntensity > 0)
			{
				_shakeOffset = Random.insideUnitSphere * _shakeIntensity;
				_shakeIntensity -= _shakeDecay * shakeIntensity;

				yield return new WaitForEndOfFrame();
			}

			_shakeOffset = new Vector3();
		}

		public void SetTarget(Transform newTarget)
		{
			if(target)
			{
				if(_targetMats.Count > 0)
				{
					foreach(KeyValuePair<Material, Shader> entry in _targetMats)
					{
						if(entry.Key.HasProperty("_Color"))
						{
							Color c = entry.Key.color;
							c.a = 1;
							entry.Key.color = c;
						}

						entry.Key.shader = entry.Value;
					}

					_targetMats.Clear();
				}
			}

			target = newTarget;

			if(target)
			{
				_targetRenderers = new List<Renderer>(target.GetComponentsInChildren<Renderer>());
			}
		}

		public void AddSecondaryTarget(Transform newTarget)
		{
			if(newTarget)
			{
				secondaryTargets.Add(newTarget);
			}
		}

		public void RemoveSecondaryTarget(Transform targetToRemove)
		{
			if(targetToRemove && secondaryTargets.Contains(targetToRemove))
			{
				secondaryTargets.Remove(targetToRemove);
			}
		}

		public void Automagics()
		{
			// Automatically add current target to ObjectsToRotate / ObjectsToFade
			if(target)
			{
				if(autoAddTargetToRotate && !objectsToRotate.Contains(target))
				{
					objectsToRotate.Add(target);
				}
			}
		}

		public void RotateObjects()
		{
			foreach(Transform o in objectsToRotate)
			{
				o.rotation = Quaternion.Euler(0, _angle.x, 0);
			}
		}

		private void CreateFocalPoint()
		{
			GameObject go = new GameObject();
			go.name = "_SRPGCfocalPoint";
			_focalPoint = go.transform;

			if(audioListenerAtFocalPoint)
			{
				AudioListener listener = GetComponent<AudioListener>();

				if(listener)
				{
					listener.enabled = false;
				}

				go.AddComponent<AudioListener>();
			}

			MoveToTarget();
		}

		public void MoveToTarget()
		{
			if(target)
			{
				_focalPoint.position = target.position + target.rotation * targetOffset;
				_wantedFocalPosition = _focalPoint.position;
			}
		}

		// These functions just keep our angle values between -180 and 180
		private void ClampAngle(ref Vector3 angle)
		{
			if(angle.x < -180) angle.x += 360;
			else if(angle.x > 180) angle.x -= 360;

			if(angle.y < -180) angle.y += 360;
			else if(angle.y > 180) angle.y -= 360;

			if(angle.z < -180) angle.z += 360;
			else if(angle.z > 180) angle.z -= 360;
		}

		private void ClampAngle(ref Vector2 angle)
		{
			if(angle.x < -180) angle.x += 360;
			else if(angle.x > 180) angle.x -= 360;

			if(angle.y < -180) angle.y += 360;
			else if(angle.y > 180) angle.y -= 360;
		}

		private float GetAngle(Vector2 fromVector2, Vector2 toVector2)
		{
			Vector2 v2 = fromVector2 - toVector2;
			float angle = Mathf.Atan2(v2.y, v2.x) * Mathf.Rad2Deg;
			angle += 180f;
			//_debugtext = "Angle " + angle + " T1X "+ fromVector2.x + " T1Y "+ fromVector2.y + " T2X "+ toVector2.x + " T2Y "+ toVector2.y;

			return angle;
		}

		#endregion
	}
}