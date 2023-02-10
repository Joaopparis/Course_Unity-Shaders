using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Grass : MonoBehaviour
{
    [Range(1, 1000)]
    public int amount;
    [Range(0, 100)]
    public float range;
    public Material material;

    Vector3[] points;
    ComputeBuffer buffer;

    void Start()
    {
        points = new Vector3[amount];
        buffer = new ComputeBuffer(amount, 12);

        for (int i = 0; i < amount; i++)
        {
            points[i] = new Vector3(Random.Range(-range, range), 0, Random.Range(-range, range));
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
