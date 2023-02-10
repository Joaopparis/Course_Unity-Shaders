using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MyGrass : MonoBehaviour
{
    [Range(1, 500)]
    public int amount;
    public Material material;

    [Range(0,10)]public int space;

    Vector3[] points;
    ComputeBuffer buffer;

    void Start()
    {
        points = new Vector3[amount];
        buffer = new ComputeBuffer(amount, 12);

        for (int i = 0; i < amount; i++)
        {
            points[i] = new Vector3(Random.Range(-space, space), 0, Random.Range(-space, space));
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
