using System.IO;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;
using UnityEngine;
using UnityEditor;

public class StandardShaderChange
{
    [MenuItem("Tools/StandardShaderChange")]
    public static void Clean()
    {
        Material[] materials = Selection.GetFiltered<Material>(SelectionMode.Assets | SelectionMode.DeepAssets);
        foreach (var material in materials)
        {
            ShaderChange(material);
        }
    }

    private static bool ShaderChange(Material _material)
    {
        Shader extendShader = Shader.Find("Extend/Standard");
        if (_material.shader.name == "Standard")
            _material.shader = extendShader;

        if (_material.shader.name == "Standard (Specular setup)")
            _material.shader = extendShader;


        return true;
    }


}
