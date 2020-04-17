using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using UnityEditor;

#if UNITY_5_3 || UNITY_5_4
using UnityEditor.SceneManagement;
using UnityEngine.SceneManagement;
#endif

namespace PhatRobit
{
	[CustomEditor(typeof(SimpleRpgCamera))]
	public class SimpleRpgCameraEditor : Editor
	{
		private string[] _toolbarChoices = new string[] { "Collision", "Target", "Movement", "Rotation", "Zoom", "Fade", "Mobile" };
		private int _toolbarSelection = 0;

		private string[] _mobileChoices = new string[] { "Movement", "Rotation", "Zoom" };
		private int _mobileSelection = 0;

		private bool _foldInvert = false;
		private bool _foldObjectsToRotate = false;
		private bool _foldMouseAllow = false;
		private bool _foldMouseAllowObjectsToRotate = false;
		private bool _foldSecondaryTargets = false;

		private int _objectsToRotateSize = 0;
		private int _secondaryTargetCount = 0;

		private bool _init = false;

		private GUIContent _content;

		private SimpleRpgCamera _self;

		public override void OnInspectorGUI()
		{
			_self = (SimpleRpgCamera)target;

			if(!_init)
			{
				_init = true;
				_objectsToRotateSize = _self.objectsToRotate.Count;
				_secondaryTargetCount = _self.secondaryTargets.Count;
			}

			bool allowSceneObjects = !EditorUtility.IsPersistent(_self);

			_toolbarSelection = GUILayout.Toolbar(_toolbarSelection, _toolbarChoices);

			if(_toolbarSelection == 0)
			{
				#region Collision Settings

				_self.collisionLayers = Utilities.LayerMaskField("Collision Layers", _self.collisionLayers);

				if(_self.collisionLayers.value != 0)
				{
					EditorGUI.indentLevel++;
					_content = new GUIContent("Collision Buffer", "A small value to prevent camera clipping");
					_self.collisionBuffer = EditorGUILayout.FloatField(_content, _self.collisionBuffer);
					_self.collisionClipping = EditorGUILayout.Toggle("Collision Clipping", _self.collisionClipping);

					if(_self.collisionClipping)
					{
						EditorGUI.indentLevel++;
						_self.collisionClippingDetection = EditorGUILayout.Toggle("Clipping Detection", _self.collisionClippingDetection);
						_self.collisionNearClipping = EditorGUILayout.FloatField("While Colliding", _self.collisionNearClipping);
						_self.collisionNoClipping = EditorGUILayout.FloatField("While NOT Colliding", _self.collisionNoClipping);
						EditorGUI.indentLevel--;
					}

					_self.ignoreCurrentTarget = EditorGUILayout.Toggle("Ignore Current Target", _self.ignoreCurrentTarget);
					_self.clampCollision = EditorGUILayout.Toggle("Clamp Collision Distance", _self.clampCollision);
					_self.showCollisionDebugLines = EditorGUILayout.Toggle("Show Debug Lines", _self.showCollisionDebugLines);
					EditorGUI.indentLevel--;
				}

				EditorGUILayout.Separator();

				_self.avoidanceLayers = Utilities.LayerMaskField("Avoidance Layers", _self.avoidanceLayers);

				if(_self.avoidanceLayers.value != 0)
				{
					EditorGUI.indentLevel++;
					_self.avoidanceSpeed = EditorGUILayout.FloatField("Avoidance Speed", _self.avoidanceSpeed);
					EditorGUI.indentLevel--;
				}

				#endregion
			}
			else if(_toolbarSelection == 1)
			{
				#region Target Settings

				_self.setTargetDoubleClick = EditorGUILayout.Toggle("Double Click Sets Target", _self.setTargetDoubleClick);

				if(_self.setTargetDoubleClick)
				{
					EditorGUI.indentLevel++;
					_self.targetDoubleClickLayers = Utilities.LayerMaskField("Double Click Layers", _self.targetDoubleClickLayers);
					_self.targetDoubleClickDelay = EditorGUILayout.FloatField("Double Click Delay", _self.targetDoubleClickDelay);
					_self.lockOnNewTarget = EditorGUILayout.Toggle("Lock On New Target", _self.lockOnNewTarget);
					EditorGUI.indentLevel--;
				}

				_content = new GUIContent("Target Tag", "Search for a target with the specified tag");
				_self.targetTag = EditorGUILayout.TextField(_content, _self.targetTag);
				_self.target = (Transform)EditorGUILayout.ObjectField("Main Target", _self.target, typeof(Transform), allowSceneObjects);

				_foldSecondaryTargets = EditorGUILayout.Foldout(_foldSecondaryTargets, "Secondary Targets");

				if(_foldSecondaryTargets)
				{
					EditorGUI.indentLevel++;

					_secondaryTargetCount = EditorGUILayout.IntField("Size", _secondaryTargetCount);

					if(_secondaryTargetCount < 0)
					{
						_secondaryTargetCount = 0;
					}

					Transform[] secondaryTargets = new Transform[_secondaryTargetCount];

					for(int i = 0; i < _secondaryTargetCount; i++)
					{
						if(_self.secondaryTargets.Count == i)
						{
							break;
						}

						secondaryTargets[i] = _self.secondaryTargets[i];
					}

					for(int i = 0; i < _secondaryTargetCount; i++)
					{
						secondaryTargets[i] = (Transform)EditorGUILayout.ObjectField("Element " + i, secondaryTargets[i], typeof(Transform), allowSceneObjects);
					}

					_self.secondaryTargets = new List<Transform>();

					foreach(Transform t in secondaryTargets)
					{
						if(t)
						{
							_self.secondaryTargets.Add(t);
						}
					}

					EditorGUI.indentLevel--;
				}
				
				_self.focusOnAllTargets = EditorGUILayout.Toggle("Focus On All Targets", _self.focusOnAllTargets);

				_self.targetOffset = EditorGUILayout.Vector3Field("Target Offset", _self.targetOffset);
				_self.smoothOffset = EditorGUILayout.Toggle("Smooth Offset", _self.smoothOffset);

				if(_self.smoothOffset)
				{
					EditorGUI.indentLevel++;

					_self.smoothOffsetSpeed = EditorGUILayout.FloatField("Smooth Offset Speed", _self.smoothOffsetSpeed);

					EditorGUI.indentLevel--;
				}

				_self.relativeOffset = EditorGUILayout.Toggle("Relative Offset", _self.relativeOffset);
				_self.useTargetAxis = EditorGUILayout.Toggle("Use Target Axis", _self.useTargetAxis);

				_self.softTracking = EditorGUILayout.Toggle("Soft Tracking", _self.softTracking);

				if(_self.softTracking)
				{
					EditorGUI.indentLevel++;

					_self.softTrackingRadius = EditorGUILayout.FloatField("Tracking Radius", _self.softTrackingRadius);
					_self.softTrackingSpeed = EditorGUILayout.FloatField("Tracking Speed", _self.softTrackingSpeed);

					EditorGUI.indentLevel--;
				}

				_self.shakeIntensity = EditorGUILayout.FloatField("Shake Intensity", _self.shakeIntensity);
				_self.shakeDecay = EditorGUILayout.FloatField("Shake Decay", _self.shakeDecay);

				_self.audioListenerAtFocalPoint = EditorGUILayout.Toggle("Audio Listener At Focal Point", _self.audioListenerAtFocalPoint);

				#endregion
			}
			else if(_toolbarSelection == 2)
			{
				#region Movement Settings

				_self.allowMovementDoubleClick = EditorGUILayout.Toggle("Allow Double Click", _self.allowMovementDoubleClick);

				if(_self.allowMovementDoubleClick)
				{
					EditorGUI.indentLevel++;
					_self.movementDoubleClickLayers = Utilities.LayerMaskField("Double Click Layers", _self.movementDoubleClickLayers);
					_self.movementDoubleClickDelay = EditorGUILayout.FloatField("Double Click Delay", _self.movementDoubleClickDelay);
					EditorGUI.indentLevel--;
				}

				_self.allowMouseDrag = EditorGUILayout.Toggle("Allow Mouse Drag", _self.allowMouseDrag);

				if(_self.allowMouseDrag)
				{
					EditorGUI.indentLevel++;

					_self.mouseDragBreaksLock = EditorGUILayout.Toggle("Break Target Lock", _self.mouseDragBreaksLock);

					_self.mouseDragButton = (MouseButton)EditorGUILayout.EnumPopup("Drag Button", _self.mouseDragButton);

					_self.autoAdjustDragSensitivity = EditorGUILayout.Toggle("Auto Drag Sensitivity", _self.autoAdjustDragSensitivity);
					_self.mouseMinDragSensitivity = EditorGUILayout.Vector2Field((_self.autoAdjustDragSensitivity ? "Min " : "") + "Drag Sensitivity", _self.mouseMinDragSensitivity);

					if(_self.autoAdjustDragSensitivity)
					{
						_self.mouseMaxDragSensitivity = EditorGUILayout.Vector2Field("Max Drag Sensitivity", _self.mouseMaxDragSensitivity);
					}

					EditorGUI.indentLevel--;
				}

				_self.allowEdgeMovement = EditorGUILayout.Toggle("Allow Edge Movement", _self.allowEdgeMovement);

				if(_self.allowEdgeMovement)
				{
					EditorGUI.indentLevel++;

					_self.edgeMovementBreaksLock = EditorGUILayout.Toggle("Break Target Lock", _self.edgeMovementBreaksLock);

					_self.edgePadding = EditorGUILayout.FloatField("Edge Padding", _self.edgePadding);

					_self.showEdges = EditorGUILayout.Toggle("Show Edges", _self.showEdges);

					if(_self.showEdges)
					{
						EditorGUI.indentLevel++;

						_self.edgeTexture = (Texture2D)EditorGUILayout.ObjectField("Edge Texture", _self.edgeTexture, typeof(Texture2D), allowSceneObjects);

						EditorGUI.indentLevel--;
					}

					EditorGUI.indentLevel--;
				}

				_self.allowEdgeKeys = EditorGUILayout.Toggle("Allow Keys", _self.allowEdgeKeys);

				if(_self.allowEdgeKeys)
				{
					EditorGUI.indentLevel++;

					_self.edgeKeysBreakLock = EditorGUILayout.Toggle("Break Target Lock", _self.edgeKeysBreakLock);

					_self.keyMoveUp = (KeyCode)EditorGUILayout.EnumPopup("Move Up Key", _self.keyMoveUp);
					_self.keyMoveDown = (KeyCode)EditorGUILayout.EnumPopup("Move Down Key", _self.keyMoveDown);
					_self.keyMoveLeft = (KeyCode)EditorGUILayout.EnumPopup("Move Left Key", _self.keyMoveLeft);
					_self.keyMoveRight = (KeyCode)EditorGUILayout.EnumPopup("Move Right Key", _self.keyMoveRight);

					EditorGUI.indentLevel--;
				}

				if(_self.allowMouseDrag || _self.allowEdgeMovement || _self.allowEdgeKeys)
				{
					_self.movementCollisionLayers = Utilities.LayerMaskField("Movement Collision Layers", _self.movementCollisionLayers);

					if(_self.movementCollisionLayers.value != 0)
					{
						EditorGUI.indentLevel++;
						_self.movementCollisionSmoothing = EditorGUILayout.Toggle("Smoothing", _self.movementCollisionSmoothing);

						if(_self.movementCollisionSmoothing)
						{
							EditorGUI.indentLevel++;
							_self.movementCollisionSmoothingSpeed = EditorGUILayout.FloatField("Smoothing Speed", _self.movementCollisionSmoothingSpeed);
							EditorGUI.indentLevel--;
						}

						_self.movementHitDistance = EditorGUILayout.FloatField("Movement Hit Distance", _self.movementHitDistance);
						_self.movementHitBuffer = EditorGUILayout.FloatField("Movement Hit Buffer", _self.movementHitBuffer);
						_self.highpointDetection = EditorGUILayout.Toggle("Highpoint Detection", _self.highpointDetection);
						_self.movementCollisionDebug = EditorGUILayout.Toggle("Show Debug Lines", _self.movementCollisionDebug);
						EditorGUI.indentLevel--;
					}
				}

				_self.lockToTarget = EditorGUILayout.Toggle("Lock To Target", _self.lockToTarget);
				_self.holdToLock = EditorGUILayout.Toggle("Hold To Lock", _self.holdToLock);

				_self.limitBounds = EditorGUILayout.Toggle("Limit Bounds", _self.limitBounds);

				if(_self.limitBounds)
				{
					EditorGUI.indentLevel++;

					_self.boundsOriginOnTarget = EditorGUILayout.Toggle("Bounds Origin On Target", _self.boundsOriginOnTarget);


					_self.boundOrigin = EditorGUILayout.Vector3Field("Origin" + (_self.boundsOriginOnTarget ? " Offset" : ""), _self.boundOrigin);
					_self.boundSize = EditorGUILayout.Vector3Field("Size", _self.boundSize);

					EditorGUI.indentLevel--;
				}

				_self.keyFollowTarget = (KeyCode)EditorGUILayout.EnumPopup("Follow Target Key", _self.keyFollowTarget);

				_self.scrollSpeed = EditorGUILayout.FloatField("Scroll Speed", _self.scrollSpeed);

				_self.movementSmoothing = EditorGUILayout.Toggle("Smooth Movement", _self.movementSmoothing);

				if(_self.movementSmoothing)
				{
					EditorGUI.indentLevel++;
					_self.movementSmoothSpeed = EditorGUILayout.FloatField("Smooth Speed", _self.movementSmoothSpeed);
					EditorGUI.indentLevel--;
				}

				#endregion
			}
			else if(_toolbarSelection == 3)
			{
				#region Rotation Settings

				_self.originRotation = EditorGUILayout.Vector2Field("Origin Rotation", _self.originRotation);
				_self.stayBehindTarget = EditorGUILayout.Toggle("Stay Behind Target", _self.stayBehindTarget);

				if(_self.stayBehindTarget)
				{
					EditorGUI.indentLevel++;

					_self.stayBehindTargetOnKey = EditorGUILayout.Toggle("On Key Press", _self.stayBehindTargetOnKey);

					if(_self.stayBehindTargetOnKey)
					{
						EditorGUI.indentLevel++;

						if(GUILayout.Button("Add Key"))
						{
							_self.stayBehindTargetKeys.Add(KeyCode.None);
						}

						for(int i = 0; i < _self.stayBehindTargetKeys.Count; i++)
						{
							EditorGUILayout.BeginHorizontal();

							GUI.color = Color.red;
							if(GUILayout.Button("Remove"))
							{
								_self.stayBehindTargetKeys.RemoveAt(i);
								continue;
							}
							GUI.color = Color.white;

							_self.stayBehindTargetKeys[i] = (KeyCode)EditorGUILayout.EnumPopup(_self.stayBehindTargetKeys[i]);

							EditorGUILayout.EndHorizontal();
						}

						EditorGUI.indentLevel--;
					}

					EditorGUI.indentLevel--;
				}

				_self.returnToOrigin = EditorGUILayout.Toggle("Return To Origin", _self.returnToOrigin);

				if(_self.returnToOrigin)
				{
					EditorGUI.indentLevel++;

					_self.returnToOriginOnKey = EditorGUILayout.Toggle("On Key Press", _self.returnToOriginOnKey);

					if(_self.returnToOriginOnKey)
					{
						EditorGUI.indentLevel++;

						if(GUILayout.Button("Add Key"))
						{
							_self.returnToOriginKeys.Add(KeyCode.None);
						}

						for(int i = 0; i < _self.returnToOriginKeys.Count; i++)
						{
							EditorGUILayout.BeginHorizontal();

							GUI.color = Color.red;
							if(GUILayout.Button("Remove"))
							{
								_self.returnToOriginKeys.RemoveAt(i);
								continue;
							}
							GUI.color = Color.white;

							_self.returnToOriginKeys[i] = (KeyCode)EditorGUILayout.EnumPopup(_self.returnToOriginKeys[i]);

							EditorGUILayout.EndHorizontal();
						}

						EditorGUI.indentLevel--;
					}

					_self.setOriginKey = (KeyCode)EditorGUILayout.EnumPopup("Set Origin Key", _self.setOriginKey);
					_self.setOriginLeft = EditorGUILayout.Toggle("Set With Left Button", _self.setOriginLeft);
					_self.setOriginMiddle = EditorGUILayout.Toggle("Set With Middle Button", _self.setOriginMiddle);
					_self.setOriginRight = EditorGUILayout.Toggle("Set With Right Button", _self.setOriginRight);

					EditorGUI.indentLevel--;
				}

				if(_self.stayBehindTarget || _self.returnToOrigin)
				{
					_self.returnSmoothing = EditorGUILayout.FloatField("Return Smoothing", _self.returnSmoothing);
					_self.returnDelay = EditorGUILayout.FloatField("Return Delay", _self.returnDelay);
					EditorGUILayout.Space();
				}

				_self.allowRotation = EditorGUILayout.Toggle("Allow Rotation", _self.allowRotation);

				if(_self.allowRotation)
				{
					EditorGUI.indentLevel++;

					_self.disableRotationOverGui = EditorGUILayout.Toggle("Disable Over GUI", _self.disableRotationOverGui);

					_self.mouseHorizontalAxis = EditorGUILayout.TextField("Mouse Horizontal Axis", _self.mouseHorizontalAxis);
					_self.mouseVerticalAxis = EditorGUILayout.TextField("Mouse Vertical Axis", _self.mouseVerticalAxis);

					_self.useJoystick = EditorGUILayout.Toggle("Use Joystick", _self.useJoystick);

					if(_self.useJoystick)
					{
						EditorGUI.indentLevel++;
						_self.joystickSensitivity = EditorGUILayout.Vector2Field("Joystick Sensitivity", _self.joystickSensitivity);
						_self.joystickHorizontalAxis = EditorGUILayout.TextField("Joystick Horizontal Axis", _self.joystickHorizontalAxis);
						_self.joystickVerticalAxis = EditorGUILayout.TextField("Joystick Vertical Axis", _self.joystickVerticalAxis);
						EditorGUI.indentLevel--;
					}

					_self.mouseLook = EditorGUILayout.Toggle("Mouse Look", _self.mouseLook);

					if(_self.mouseLook)
					{
						EditorGUI.indentLevel++;
						_self.lockCursor = EditorGUILayout.Toggle("Lock Mouse", _self.lockCursor);
						_self.disableWhileUnlocked = EditorGUILayout.Toggle("Disable While Unlocked", _self.disableWhileUnlocked);
						EditorGUI.indentLevel--;
					}
					else
					{
						_foldMouseAllow = EditorGUILayout.Foldout(_foldMouseAllow, "Allowed Mouse Buttons");

						if(_foldMouseAllow)
						{
							EditorGUI.indentLevel++;

							_self.allowRotationLeft = EditorGUILayout.Toggle("Left Button", _self.allowRotationLeft);
							_self.allowRotationMiddle = EditorGUILayout.Toggle("Middle Button", _self.allowRotationMiddle);
							_self.allowRotationRight = EditorGUILayout.Toggle("Right Button", _self.allowRotationRight);

							EditorGUI.indentLevel--;
						}

						if(_self.allowRotationLeft || _self.allowRotationMiddle || _self.allowRotationRight)
						{
							_self.lockCursor = EditorGUILayout.Toggle("Lock Mouse", _self.lockCursor);

							if(_self.lockCursor)
							{
								EditorGUI.indentLevel++;

								if(_self.allowRotationLeft)
								{
									_self.lockLeft = EditorGUILayout.Toggle("Left Button", _self.lockLeft);
								}

								if(_self.allowRotationMiddle)
								{
									_self.lockMiddle = EditorGUILayout.Toggle("Middle Button", _self.lockMiddle);
								}

								if(_self.allowRotationRight)
								{
									_self.lockRight = EditorGUILayout.Toggle("Right Button", _self.lockRight);
								}

								EditorGUI.indentLevel--;
							}
						}
					}

					_self.limitAngleX = EditorGUILayout.Toggle("Limit X Angle", _self.limitAngleX);

					if(_self.limitAngleX)
					{
						EditorGUI.indentLevel++;
						EditorGUILayout.LabelField("X Angle Limit [Min: " + _self.minAngleX + " | Max: " + _self.maxAngleX + "]");
						EditorGUILayout.MinMaxSlider(ref _self.minAngleX, ref _self.maxAngleX, -180, 180);

						_self.minAngleX = Mathf.Round(_self.minAngleX);
						_self.maxAngleX = Mathf.Round(_self.maxAngleX);
						EditorGUI.indentLevel--;
					}

					EditorGUILayout.LabelField("Y Angle Limit [Min: " + _self.minAngleY + " | Max: " + _self.maxAngleY + "]");
					EditorGUILayout.MinMaxSlider(ref _self.minAngleY, ref _self.maxAngleY, -89, 89);

					_self.minAngleY = Mathf.Round(_self.minAngleY);
					_self.maxAngleY = Mathf.Round(_self.maxAngleY);

					_foldInvert = EditorGUILayout.Foldout(_foldInvert, "Invert Rotation");

					if(_foldInvert)
					{
						EditorGUI.indentLevel++;
						_self.invertRotationX = EditorGUILayout.Toggle("X", _self.invertRotationX);
						_self.invertRotationY = EditorGUILayout.Toggle("Y", _self.invertRotationY);
						EditorGUI.indentLevel--;
					}

					_self.rotationSensitivity = EditorGUILayout.Vector2Field("Sensitivity", _self.rotationSensitivity);

					if(_self.allowRotationLeft || _self.allowRotationMiddle || _self.allowRotationRight)
					{
						_self.rotateObjects = EditorGUILayout.Toggle("Rotate Objects", _self.rotateObjects);

						if(_self.rotateObjects)
						{
							EditorGUI.indentLevel++;

							_self.autoAddTargetToRotate = EditorGUILayout.Toggle("Auto Add Target", _self.autoAddTargetToRotate);

							if(!_self.mouseLook)
							{
								_foldMouseAllowObjectsToRotate = EditorGUILayout.Foldout(_foldMouseAllowObjectsToRotate, "Allowed Mouse Buttons");

								if(_foldMouseAllowObjectsToRotate)
								{
									EditorGUI.indentLevel++;

									if(_self.allowRotationLeft)
									{
										_self.rotateObjectsLeft = EditorGUILayout.Toggle("Left Button", _self.rotateObjectsLeft);
									}

									if(_self.allowRotationMiddle)
									{
										_self.rotateObjectsMiddle = EditorGUILayout.Toggle("Middle Button", _self.rotateObjectsMiddle);
									}

									if(_self.allowRotationRight)
									{
										_self.rotateObjectsRight = EditorGUILayout.Toggle("Right Button", _self.rotateObjectsRight);
									}

									EditorGUI.indentLevel--;
								}
							}

							_foldObjectsToRotate = EditorGUILayout.Foldout(_foldObjectsToRotate, "Objects To Rotate");

							if(_foldObjectsToRotate)
							{
								EditorGUI.indentLevel++;

								_objectsToRotateSize = EditorGUILayout.IntField("Size", _objectsToRotateSize);

								if(_objectsToRotateSize < 0)
								{
									_objectsToRotateSize = 0;
								}

								Transform[] objectsToRotate = new Transform[_objectsToRotateSize];

								for(int i = 0; i < _objectsToRotateSize; i++)
								{
									if(_self.objectsToRotate.Count == i)
									{
										break;
									}

									objectsToRotate[i] = _self.objectsToRotate[i];
								}

								for(int i = 0; i < _objectsToRotateSize; i++)
								{
									objectsToRotate[i] = (Transform)EditorGUILayout.ObjectField("Element " + i, objectsToRotate[i], typeof(Transform), allowSceneObjects);
								}

								_self.objectsToRotate = new List<Transform>();

								foreach(Transform t in objectsToRotate)
								{
									if(t)
									{
										_self.objectsToRotate.Add(t);
									}
								}

								EditorGUI.indentLevel--;
							}

							EditorGUI.indentLevel--;
						}
					}

					EditorGUI.indentLevel--;
				}

				_self.allowRotationKeys = EditorGUILayout.Toggle("Allow Rotation Keys", _self.allowRotationKeys);

				if(_self.allowRotationKeys)
				{
					EditorGUI.indentLevel++;

					_self.keyRotateUp = (KeyCode)EditorGUILayout.EnumPopup("Up", _self.keyRotateUp);
					_self.keyRotateDown = (KeyCode)EditorGUILayout.EnumPopup("Down", _self.keyRotateDown);
					_self.keyRotateLeft = (KeyCode)EditorGUILayout.EnumPopup("Left", _self.keyRotateLeft);
					_self.keyRotateRight = (KeyCode)EditorGUILayout.EnumPopup("Right", _self.keyRotateRight);
					_self.rotationKeySensitivity = EditorGUILayout.Vector2Field("Sensitivity", _self.rotationKeySensitivity);

					EditorGUI.indentLevel--;
				}

				if(_self.allowRotation || _self.allowRotationKeys)
				{
					_self.autoSmoothing = EditorGUILayout.Toggle("Auto Smoothing", _self.autoSmoothing);

					if(!_self.autoSmoothing)
					{
						_self.rotationSmoothing = EditorGUILayout.FloatField("Rotation Smoothing", _self.rotationSmoothing);

						EditorGUILayout.HelpBox("If you notice some strange 'rubberbanding' effect while rotating the camera quickly, increasing the Rotation Smoothing (or reducing the Sensitivity) may help to reduce it. The Auto Smoothing setting usually helps avoid this issue for you.", MessageType.Info);
					}
				}

				_self.timeoutRotation = EditorGUILayout.Toggle("Timeout Rotation", _self.timeoutRotation);

				if(_self.timeoutRotation)
				{
					EditorGUI.indentLevel++;

					_self.timeoutRotationDelay = EditorGUILayout.FloatField("Timeout Delay", _self.timeoutRotationDelay);
					_self.timeoutRotationSpeed = EditorGUILayout.FloatField("Timeout Rotation Speed", _self.timeoutRotationSpeed);

					EditorGUI.indentLevel--;
				}

				#endregion
			}
			else if(_toolbarSelection == 4)
			{
				#region Zoom Settings

				_self.allowZoom = EditorGUILayout.Toggle("Allow Zoom", _self.allowZoom);

				if(_self.allowZoom || _self.allowZoomKeys)
				{
					EditorGUI.indentLevel++;

					_self.disableZoomOverGui = EditorGUILayout.Toggle("Disable Over GUI", _self.disableZoomOverGui);

					_self.autoAdjustZoomSpeed = EditorGUILayout.Toggle("Auto Zoom Speed", _self.autoAdjustZoomSpeed);

					if(_self.autoAdjustZoomSpeed)
					{
						EditorGUI.indentLevel++;
						_self.minZoomSpeed = EditorGUILayout.FloatField("Min Zoom Speed", _self.minZoomSpeed);
						_self.maxZoomSpeed = EditorGUILayout.FloatField("Max Zoom Speed", _self.maxZoomSpeed);
						EditorGUI.indentLevel--;
					}
					else
					{
						_self.zoomSpeed = EditorGUILayout.FloatField("Zoom Speed", _self.zoomSpeed);
					}

					_self.zoomSmoothing = EditorGUILayout.FloatField("Zoom Smoothing", _self.zoomSmoothing);
					_self.invertZoom = EditorGUILayout.Toggle("Invert Direction", _self.invertZoom);

					EditorGUI.indentLevel--;
				}

				_self.allowZoomKeys = EditorGUILayout.Toggle("Allow Zoom Keys", _self.allowZoomKeys);

				if(_self.allowZoomKeys)
				{
					EditorGUI.indentLevel++;

					_content = new GUIContent("Zoom In Key", "Key for zooming in");
					_self.keyZoomIn = (KeyCode)EditorGUILayout.EnumPopup(_content, _self.keyZoomIn);
					_content = new GUIContent("Zoom Out Key", "Key for zooming out");
					_self.keyZoomOut = (KeyCode)EditorGUILayout.EnumPopup(_content, _self.keyZoomOut);
					_content = new GUIContent("Zoom Key Delay", "The amount of time needed to hold the key down before constant zoom takes effect");
					_self.keyZoomDelay = EditorGUILayout.FloatField(_content, _self.keyZoomDelay);
					_self.zoomKeySensitivity = EditorGUILayout.FloatField("Zoom Key Sensitivity", _self.zoomKeySensitivity);

					EditorGUI.indentLevel--;
				}

				_content = new GUIContent("Distance", "The distance between the camera and target");

				_self.distance = EditorGUILayout.FloatField(_content, _self.distance);
				EditorGUI.indentLevel++;
				EditorGUILayout.LabelField("[Min: " + _self.minDistance + " | Max: " + _self.maxDistance + "]");
				EditorGUILayout.MinMaxSlider(ref _self.minDistance, ref _self.maxDistance, 1, 200);
				EditorGUI.indentLevel--;

				_self.minDistance = Mathf.Round(_self.minDistance);
				_self.maxDistance = Mathf.Round(_self.maxDistance);

				#endregion
			}
			else if(_toolbarSelection == 5)
			{
				#region Fade Settings

				_self.fadeCurrentTarget = EditorGUILayout.Toggle("Fade Current Target", _self.fadeCurrentTarget);

				if(_self.fadeCurrentTarget)
				{
					EditorGUI.indentLevel++;
					_self.fadeDistance = EditorGUILayout.FloatField("Fade Distance", _self.fadeDistance);
					EditorGUI.indentLevel--;
				}

				EditorGUILayout.Separator();

				_self.replaceShaders = EditorGUILayout.Toggle("Replace Shaders", _self.replaceShaders);

				if(_self.replaceShaders)
				{
					EditorGUI.indentLevel++;
					_content = new GUIContent("Transparent Shader", "This will replace the object's current shader with the selected shader when fading (Defaults to Standard Shader if left blank)");
					_self.transparentShader = (Shader)EditorGUILayout.ObjectField(_content, _self.transparentShader, typeof(Shader), false);
					EditorGUI.indentLevel--;
				}

				EditorGUILayout.Separator();

				_self.collisionAlphaLayers = Utilities.LayerMaskField("Collision Alpha Layers", _self.collisionAlphaLayers);

				if(_self.collisionAlphaLayers.value != 0)
				{
					EditorGUI.indentLevel++;
					_content = new GUIContent("Fade Amount", "The alpha value for faded objects in front of the target");
					_self.fadeAmount = EditorGUILayout.Slider(_content, _self.fadeAmount, 0, 1);
					_content = new GUIContent("Fade Speed", "Modifier for the time it takes to fade objects in / out");
					_self.alphaFadeSpeed = EditorGUILayout.FloatField(_content, _self.alphaFadeSpeed);
					EditorGUI.indentLevel--;
				}

				#endregion
			}
			else if(_toolbarSelection == 6)
			{
				#region Mobile Settings

				EditorGUILayout.HelpBox("Note: Most of the desktop settings affect both desktop and mobile functionality. Settings in this tab that are highlighted in yellow will override the desktop settings on mobile devices for convenience.", MessageType.Info);

				_self.allowTouch = EditorGUILayout.Toggle("Allow Touch", _self.allowTouch);

				if(_self.allowTouch)
				{
					_self.touchSensitivity = EditorGUILayout.FloatField("Touch Sensitivity", _self.touchSensitivity);

					_mobileSelection = GUILayout.Toolbar(_mobileSelection, _mobileChoices);

					if(_mobileSelection == 0)
					{
						#region Mobile Movement Settings

						if(_self.allowEdgeMovement)
						{
							_self.mobilePanBreakTargetLock = EditorGUILayout.Toggle("Break Target Lock", _self.mobilePanBreakTargetLock);
							_self.mobilePanType = (PanControlType)EditorGUILayout.EnumPopup("Movement Control Method", _self.mobilePanType);

							if(_self.mobilePanType == PanControlType.Drag)
							{
								EditorGUI.indentLevel++;
								_self.mobilePanningTouchCount = EditorGUILayout.IntField("Panning Touch Count", _self.mobilePanningTouchCount);
								EditorGUI.indentLevel--;
							}
							else if(_self.mobilePanType == PanControlType.Swipe)
							{
								EditorGUI.indentLevel++;
								_self.mobilePanSwipeActiveTime = EditorGUILayout.FloatField("Swipe Detection Time", _self.mobilePanSwipeActiveTime);
								_self.mobilePanSwipeMinDistance = EditorGUILayout.FloatField("Min Swipe Distance", _self.mobilePanSwipeMinDistance);
								_self.mobilePanSwipeDistance = EditorGUILayout.Vector2Field("Movement Distance", _self.mobilePanSwipeDistance);
								EditorGUI.indentLevel--;
							}
						}
						else
						{
							EditorGUILayout.HelpBox("Edge movement is disabled. Enable it in the Movement tab.", MessageType.Info);
						}

						#endregion
					}
					else if(_mobileSelection == 1)
					{
						#region Mobile Rotation Settings

						if(_self.allowRotation || _self.allowRotationKeys)
						{
							_self.mobileRotationType = (RotationControlType)EditorGUILayout.EnumPopup("Rotation Control Method", _self.mobileRotationType);

							if(_self.mobileRotationType == RotationControlType.Swipe)
							{
								EditorGUI.indentLevel++;
								_self.mobileSwipeActiveTime = EditorGUILayout.FloatField("Swipe Detection Time", _self.mobileSwipeActiveTime);
								_self.mobileSwipeMinDistance = EditorGUILayout.FloatField("Min Swipe Distance", _self.mobileSwipeMinDistance);
								_self.mobileSwipeRotationAmount = EditorGUILayout.Vector2Field("Swipe Rotation Amount", _self.mobileSwipeRotationAmount);
								EditorGUI.indentLevel--;
							}
							else if(_self.mobileRotationType == RotationControlType.Drag)
							{
								EditorGUI.indentLevel++;
								_self.mobileDragRotationTouchCount = EditorGUILayout.IntField("Touch Count", _self.mobileDragRotationTouchCount);
								_self.mobileRotationDelay = EditorGUILayout.FloatField("Rotation Delay", _self.mobileRotationDelay);
								EditorGUI.indentLevel--;
							}
						}
						else
						{
							EditorGUILayout.HelpBox("Rotation is disabled. Enable it in the Rotation tab.", MessageType.Info);
						}

						#endregion
					}
					else if(_mobileSelection == 2)
					{
						#region Mobile Zoom Settings

						if(_self.allowZoom || _self.allowZoomKeys)
						{
							_self.autoAdjustMobileZoomSpeed = EditorGUILayout.Toggle("Auto Adjust Speed", _self.autoAdjustMobileZoomSpeed);

							if(_self.autoAdjustMobileZoomSpeed)
							{
								EditorGUI.indentLevel++;
								_self.minMobileZoomSpeed = EditorGUILayout.FloatField("Min Speed", _self.minMobileZoomSpeed);
								_self.maxMobileZoomSpeed = EditorGUILayout.FloatField("Max Speed", _self.maxMobileZoomSpeed);
								EditorGUI.indentLevel--;
							}
							else
							{
								_self.mobileZoomSpeed = EditorGUILayout.FloatField("Zoom Speed", _self.mobileZoomSpeed);
							}
						}
						else
						{
							EditorGUILayout.HelpBox("Zoom is disabled. Enable it in the Zoom tab.", MessageType.Info);
						}

						#endregion
					}
				}

				#endregion
			}

			if(GUI.changed && !EditorApplication.isPlaying)
			{
				EditorUtility.SetDirty(_self);

#if UNITY_5_3 || UNITY_5_4
				EditorSceneManager.MarkSceneDirty(SceneManager.GetActiveScene());
#else
				EditorApplication.MarkSceneDirty();
#endif
			}
		}
	}
}