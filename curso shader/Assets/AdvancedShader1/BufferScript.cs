using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BufferScript : MonoBehaviour
{
    public Material material;

    Vector3[] vertices;
    ComputeBuffer buffer;    

    void Start()
    {
        vertices = new Vector3[6];
        buffer = new ComputeBuffer(6, 12);

        //triangle 1
        vertices[0] = new Vector3(0, 0, 0);
        vertices[1] = new Vector3(0, 0, 1);
        vertices[2] = new Vector3(1, 0, 0);

        //triangle 2
        vertices[3] = new Vector3(1, 0, 0);
        vertices[4] = new Vector3(0, 0, 1);
        vertices[5] = new Vector3(1, 0, 1);

        buffer.SetData(vertices);
        material.SetBuffer("buffer", buffer);
    }

    void OnRenderObject()
    {
        material.SetPass(0);
        Graphics.DrawProceduralNow(MeshTopology.Triangles, 6, 1);
    }

    void OnDestroy()
    {
        Debug.Log("Desalocando Buffer");
        buffer.Dispose();
    }

    void Update()
    {
        
    }
}
