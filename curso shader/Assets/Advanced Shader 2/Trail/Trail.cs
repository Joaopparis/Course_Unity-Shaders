using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Trail : MonoBehaviour
{
    public Material material;
    int pointsCount = 16;
    Vector3[] points;
    ComputeBuffer buffer;

    public ComputeShader compute;
    int kernel;

    [Range(0,10)]
    public float velocity;

    void Start()
    {
        points = new Vector3[pointsCount];
        buffer = new ComputeBuffer(pointsCount, 12);
        for (int i = 0; i < pointsCount; i++)
        {
            points[i] = Vector3.zero;
        }
        buffer.SetData(points);
        material.SetBuffer("buffer", buffer);

        kernel = compute.FindKernel("Move");
        compute.SetBuffer(kernel, "buffer", buffer);
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

    // Update is called once per frame
    void Update()
    {
        compute.SetFloat("velocity", velocity);
        compute.SetVector("position", transform.position);
        compute.Dispatch(kernel, buffer.count / 16, 1, 1);
    }
}
