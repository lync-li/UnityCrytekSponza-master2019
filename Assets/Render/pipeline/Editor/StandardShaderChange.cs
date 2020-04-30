using System.IO;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;
using UnityEngine;
using UnityEditor;

public class StandardShaderChange
{
    [MenuItem("Tools/ExtendStandardChange")]
    public static void StandardChange()
    {
        Material[] materials = Selection.GetFiltered<Material>(SelectionMode.Assets | SelectionMode.DeepAssets);
        foreach (var material in materials)
        {
            ShaderChange0(material);
        }
    }

    private static bool ShaderChange0(Material _material)
    {
        Shader extendShader = Shader.Find("Extend/Standard");
        if (_material.shader.name == "Standard")
            _material.shader = extendShader;

        if (_material.shader.name == "Standard (Specular setup)")
            _material.shader = extendShader;

        if (_material.shader.name == "CGBull/Infinity_Shader/SuperStandard")
            _material.shader = extendShader;

        return true;
    }

    [MenuItem("Tools/SuperStandardChange")]
    public static void ShaderChange1()
    {
        Material[] materials = Selection.GetFiltered<Material>(SelectionMode.Assets | SelectionMode.DeepAssets);
        foreach (var material in materials)
        {
            ShaderChange1(material);
        }
    }

    private static bool ShaderChange1(Material _material)
    {
        Shader super = Shader.Find("CGBull/Infinity_Shader/SuperStandard");
        if (_material.shader.name == "Standard")
            _material.shader = super;

        if (_material.shader.name == "Standard (Specular setup)")
            _material.shader = super;

        if (_material.shader.name == "Extend/Standard")
            _material.shader = super;


        return true;
    }


}
