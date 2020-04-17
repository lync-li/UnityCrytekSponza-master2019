using UnityEngine;
using System.Collections.Generic;
using UnityEditor;
using System.Reflection;
using System.Linq;
using System.IO;

[CustomEditor(typeof(DragonPostProcessBase))]
class DragonPostProcesBaseEditor : Editor
{
    #region Property drawers
    [CustomPropertyDrawer(typeof(DragonPostProcessBase.ColorWheelGroup))]
    class ColorWheelGroupDrawer : PropertyDrawer
    {
        int m_RenderSizePerWheel;
        int m_NumberOfWheels;

        public override float GetPropertyHeight(SerializedProperty property, GUIContent label)
        {
            var wheelAttribute = (DragonPostProcessBase.ColorWheelGroup)attribute;
            property.isExpanded = true;

            m_NumberOfWheels = property.CountInProperty() - 1;
            if (m_NumberOfWheels == 0)
                return 0f;

            m_RenderSizePerWheel = Mathf.FloorToInt((EditorGUIUtility.currentViewWidth) / m_NumberOfWheels) - 30;
            m_RenderSizePerWheel = Mathf.Clamp(m_RenderSizePerWheel, wheelAttribute.minSizePerWheel, wheelAttribute.maxSizePerWheel);
            m_RenderSizePerWheel = Mathf.FloorToInt(pixelRatio * m_RenderSizePerWheel);
            return ColorWheel.GetColorWheelHeight(m_RenderSizePerWheel);
        }

        public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
        {
            if (m_NumberOfWheels == 0)
                return;

            var width = position.width;
            Rect newPosition = new Rect(position.x, position.y, width / m_NumberOfWheels, position.height);

            foreach (SerializedProperty prop in property)
            {
                if (prop.propertyType == SerializedPropertyType.Color)
                    prop.colorValue = ColorWheel.DoGUI(newPosition, prop.displayName, prop.colorValue, m_RenderSizePerWheel);

                newPosition.x += width / m_NumberOfWheels;
            }
        }
    }
    [CustomPropertyDrawer(typeof(DragonPostProcess.IndentedGroup))]
    private class IndentedGroupDrawer : PropertyDrawer
    {
        public override float GetPropertyHeight(SerializedProperty property, GUIContent label)
        {
            return 0f;
        }

        public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
        {
            EditorGUILayout.LabelField(label, EditorStyles.boldLabel);

            EditorGUI.indentLevel++;

            foreach (SerializedProperty prop in property)
                EditorGUILayout.PropertyField(prop);

            EditorGUI.indentLevel--;
        }
    }

    [CustomPropertyDrawer(typeof(DragonPostProcessBase.ChannelMixer))]
    private class ChannelMixerDrawer : PropertyDrawer
    {
        public override float GetPropertyHeight(SerializedProperty property, GUIContent label)
        {
            return 0f;
        }

        public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
        {
            // TODO: Hardcoded variable names, rewrite this function
            if (property.type != "ChannelMixerSettings")
                return;

            SerializedProperty currentChannel = property.FindPropertyRelative("currentChannel");
            int intCurrentChannel = currentChannel.intValue;

            EditorGUILayout.LabelField(label, EditorStyles.boldLabel);

            EditorGUI.indentLevel++;

            EditorGUILayout.BeginHorizontal();
            {
                EditorGUILayout.PrefixLabel("Channel");
                if (GUILayout.Toggle(intCurrentChannel == 0, "Red", EditorStyles.miniButtonLeft)) intCurrentChannel = 0;
                if (GUILayout.Toggle(intCurrentChannel == 1, "Green", EditorStyles.miniButtonMid)) intCurrentChannel = 1;
                if (GUILayout.Toggle(intCurrentChannel == 2, "Blue", EditorStyles.miniButtonRight)) intCurrentChannel = 2;
            }
            EditorGUILayout.EndHorizontal();

            SerializedProperty serializedChannel = property.FindPropertyRelative("channels").GetArrayElementAtIndex(intCurrentChannel);
            currentChannel.intValue = intCurrentChannel;

            Vector3 v = serializedChannel.vector3Value;
            v.x = EditorGUILayout.Slider("Red", v.x, -2f, 2f);
            v.y = EditorGUILayout.Slider("Green", v.y, -2f, 2f);
            v.z = EditorGUILayout.Slider("Blue", v.z, -2f, 2f);
            serializedChannel.vector3Value = v;

            EditorGUI.indentLevel--;
        }
    }

    [CustomPropertyDrawer(typeof(DragonPostProcessBase.Curve))]
    private class CurveDrawer : PropertyDrawer
    {
        public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
        {
            DragonPostProcessBase.Curve attribute = (DragonPostProcessBase.Curve)base.attribute;

            if (property.propertyType != SerializedPropertyType.AnimationCurve)
            {
                EditorGUI.LabelField(position, label.text, "Use ClampCurve with an AnimationCurve.");
                return;
            }

            property.animationCurveValue = EditorGUI.CurveField(position, label, property.animationCurveValue, attribute.color, new Rect(0f, 0f, 1f, 1f));
        }
    }
    #endregion

    public static float pixelRatio
    {
        get
        {
#if !(UNITY_3 || UNITY_4 || UNITY_5_0 || UNITY_5_1 || UNITY_5_2 || UNITY_5_3)
            return EditorGUIUtility.pixelsPerPoint;
#else
                return 1f;
#endif
        }
    }

    #region Styling
    public static Styles s_Styles;
    public class Styles
    {
        public GUIStyle thumb2D = "ColorPicker2DThumb";
        public Vector2 thumb2DSize;

        internal Styles()
        {
            thumb2DSize = new Vector2(
                    !Mathf.Approximately(thumb2D.fixedWidth, 0f) ? thumb2D.fixedWidth : thumb2D.padding.horizontal,
                    !Mathf.Approximately(thumb2D.fixedHeight, 0f) ? thumb2D.fixedHeight : thumb2D.padding.vertical
                    );
        }
    }
    public static readonly Color masterCurveColor = new Color(1f, 1f, 1f, 2f);
    public static readonly Color redCurveColor = new Color(1f, 0f, 0f, 2f);
    public static readonly Color greenCurveColor = new Color(0f, 1f, 0f, 2f);
    public static readonly Color blueCurveColor = new Color(0f, 1f, 1f, 2f);
    #endregion
 

    public static class ColorWheel
    {
        // Constants
        private const float PI_2 = Mathf.PI / 2f;
        private const float PI2 = Mathf.PI * 2f;

        // hue Wheel
        private static Texture2D s_WheelTexture;
        private static float s_LastDiameter;
        private static GUIStyle s_CenteredStyle;

        public static Color DoGUI(Rect area, string title, Color color, float diameter)
        {
            var labelrect = area;
            labelrect.height = EditorGUIUtility.singleLineHeight;

            if (s_CenteredStyle == null)
            {
                s_CenteredStyle = new GUIStyle(GUI.skin.GetStyle("Label"))
                {
                    alignment = TextAnchor.UpperCenter
                };
            }

            GUI.Label(labelrect, title, s_CenteredStyle);

            // Figure out the wheel draw area
            var wheelDrawArea = area;
            wheelDrawArea.y += EditorGUIUtility.singleLineHeight;
            wheelDrawArea.height = diameter;

            if (wheelDrawArea.width > wheelDrawArea.height)
            {
                wheelDrawArea.x += (wheelDrawArea.width - wheelDrawArea.height) / 2.0f;
                wheelDrawArea.width = area.height;
            }

            wheelDrawArea.width = wheelDrawArea.height;

            var radius = diameter / 2.0f;
            Vector3 hsv;
            Color.RGBToHSV(color, out hsv.x, out hsv.y, out hsv.z);

            // Retina/HDPI screens handling
            wheelDrawArea.width /= pixelRatio;
            wheelDrawArea.height /= pixelRatio;
            float scaledRadius = radius / pixelRatio;

            if (Event.current.type == EventType.Repaint)
            {
                if (!Mathf.Approximately(diameter, s_LastDiameter))
                {
                    s_LastDiameter = diameter;
                    UpdateHueWheel((int)diameter);
                }

                // Wheel
                GUI.DrawTexture(wheelDrawArea, s_WheelTexture);

                // Thumb
                Vector2 thumbPos = Vector2.zero;
                float theta = hsv.x * PI2;
                float len = hsv.y * scaledRadius;
                thumbPos.x = Mathf.Cos(theta + PI_2);
                thumbPos.y = Mathf.Sin(theta - PI_2);
                thumbPos *= len;
                Vector2 thumbSize = s_Styles.thumb2DSize;
                Color oldColor = GUI.color;
                GUI.color = Color.black;
                Vector2 thumbSizeH = thumbSize / 2f;
                Handles.color = Color.white;
                Handles.DrawAAPolyLine(new Vector2(wheelDrawArea.x + scaledRadius + thumbSizeH.x, wheelDrawArea.y + scaledRadius + thumbSizeH.y), new Vector2(wheelDrawArea.x + scaledRadius + thumbPos.x, wheelDrawArea.y + scaledRadius + thumbPos.y));
                s_Styles.thumb2D.Draw(new Rect(wheelDrawArea.x + scaledRadius + thumbPos.x - thumbSizeH.x, wheelDrawArea.y + scaledRadius + thumbPos.y - thumbSizeH.y, thumbSize.x, thumbSize.y), false, false, false, false);
                GUI.color = oldColor;
            }
            hsv = GetInput(wheelDrawArea, hsv, scaledRadius);

            var sliderDrawArea = wheelDrawArea;
            sliderDrawArea.y = sliderDrawArea.yMax;
            sliderDrawArea.height = EditorGUIUtility.singleLineHeight;

            hsv.y = GUI.HorizontalSlider(sliderDrawArea, hsv.y, 1e-04f, 1f);
            color = Color.HSVToRGB(hsv.x, hsv.y, hsv.z);
            color.a = 0;
            return color;
        }

        private static readonly int k_ThumbHash = "colorWheelThumb".GetHashCode();

        private static Vector3 GetInput(Rect bounds, Vector3 hsv, float radius)
        {
            Event e = Event.current;
            var id = GUIUtility.GetControlID(k_ThumbHash, FocusType.Passive, bounds);

            Vector2 mousePos = e.mousePosition;
            Vector2 relativePos = mousePos - new Vector2(bounds.x, bounds.y);

            if (e.type == EventType.MouseDown && e.button == 0 && GUIUtility.hotControl == 0)
            {
                if (bounds.Contains(mousePos))
                {
                    Vector2 center = new Vector2(bounds.x + radius, bounds.y + radius);
                    float dist = Vector2.Distance(center, mousePos);

                    if (dist <= radius)
                    {
                        e.Use();
                        GetWheelHueSaturation(relativePos.x, relativePos.y, radius, out hsv.x, out hsv.y);
                        GUIUtility.hotControl = id;
                    }
                }
            }
            else if (e.type == EventType.MouseDrag && e.button == 0 && GUIUtility.hotControl == id)
            {
                Vector2 center = new Vector2(bounds.x + radius, bounds.y + radius);
                float dist = Vector2.Distance(center, mousePos);

                if (dist <= radius)
                {
                    e.Use();
                    GetWheelHueSaturation(relativePos.x, relativePos.y, radius, out hsv.x, out hsv.y);
                }
            }
            else if (e.type == EventType.MouseUp && e.button == 0 && GUIUtility.hotControl == id)
            {
                e.Use();
                GUIUtility.hotControl = 0;
            }

            return hsv;
        }

        private static void GetWheelHueSaturation(float x, float y, float radius, out float hue, out float saturation)
        {
            float dx = (x - radius) / radius;
            float dy = (y - radius) / radius;
            float d = Mathf.Sqrt(dx * dx + dy * dy);
            hue = Mathf.Atan2(dx, -dy);
            hue = 1f - ((hue > 0) ? hue : PI2 + hue) / PI2;
            saturation = Mathf.Clamp01(d);
        }

        private static void UpdateHueWheel(int diameter)
        {
            CleanTexture(s_WheelTexture);
            s_WheelTexture = MakeTexture(diameter);

            var radius = diameter / 2.0f;

            Color[] pixels = s_WheelTexture.GetPixels();

            for (int y = 0; y < diameter; y++)
            {
                for (int x = 0; x < diameter; x++)
                {
                    int index = y * diameter + x;
                    float dx = (x - radius) / radius;
                    float dy = (y - radius) / radius;
                    float d = Mathf.Sqrt(dx * dx + dy * dy);

                    // Out of the wheel, early exit
                    if (d >= 1f)
                    {
                        pixels[index] = new Color(0f, 0f, 0f, 0f);
                        continue;
                    }

                    // red (0) on top, counter-clockwise (industry standard)
                    float saturation = d;
                    float hue = Mathf.Atan2(dx, dy);
                    hue = 1f - ((hue > 0) ? hue : PI2 + hue) / PI2;
                    Color color = Color.HSVToRGB(hue, saturation, 1f);

                    // Quick & dirty antialiasing
                    color.a = (saturation > 0.99) ? (1f - saturation) * 100f : 1f;

                    pixels[index] = color;
                }
            }

            s_WheelTexture.SetPixels(pixels);
            s_WheelTexture.Apply();
        }

        private static Texture2D MakeTexture(int dimension)
        {
            return new Texture2D(dimension, dimension, TextureFormat.ARGB32, false, true)
            {
                filterMode = FilterMode.Point,
                wrapMode = TextureWrapMode.Clamp,
                hideFlags = HideFlags.HideAndDontSave,
                alphaIsTransparency = true
            };
        }

        private static void CleanTexture(Texture2D texture)
        {
            if (texture != null)
                DestroyImmediate(texture);
        }

        public static float GetColorWheelHeight(int renderSizePerWheel)
        {
            // wheel height + title label + alpha slider
            return renderSizePerWheel + 2 * EditorGUIUtility.singleLineHeight;
        }
    }
}
