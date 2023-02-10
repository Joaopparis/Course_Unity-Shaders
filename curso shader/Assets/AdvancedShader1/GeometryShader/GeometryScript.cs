using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GeometryScript : MonoBehaviour
{
    public Material material;

    Vector3[] points;
    ComputeBuffer buffer;

    void Start()
    {
        points = new Vector3[1];
        buffer = new ComputeBuffer(1, 12);

        points[0] = Vector3.zero;

        buffer.SetData(points);
        material.SetBuffer("buffer", buffer);
    }

    void OnRenderObject()
    {
        material.SetPass(0);
        Graphics.DrawProceduralNow(MeshTopology.Triangles, 4, 1);
    }

    void OnDestroy()
    {
        buffer.Dispose();
    }

    void Update()
    {
        
    }
}
