using System;
using System.Numerics;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class Fire : MonoBehaviour
{

    public struct Data{
        public UnityEngine.Vector3 pos;
        public float vel;
    };

    [Range(1,50)]public int amount;
    public Material material;
    Data[] points;
    ComputeBuffer buffer;
    
    void Start()
    {
        points = new Data[amount];
        buffer = new ComputeBuffer(amount, 16);

        for (int i = 0; i < amount; i++)
        {
            float x = UnityEngine.Random.Range(0, 360);
            x = Mathf.Cos(x * Mathf.Deg2Rad);

            float z = UnityEngine.Random.Range(0, 360);
            z = Mathf.Cos(z * Mathf.Deg2Rad);

            points[i].pos = new UnityEngine.Vector3(x, 0, z);
            points[i].vel = UnityEngine.Random.Range(0.5f, 1f);
        }

        buffer.SetData(points);
        material.SetBuffer("buffer", buffer);
    }

    void OnRenderObject()
    {
        material.SetPass(0);
        Graphics.DrawProceduralNow(MeshTopology.Points, buffer.count, 1);
    }

    void OnDestroy()
    {
        buffer.Dispose();
    }
    
    void Update()
    {
        
    }
}
