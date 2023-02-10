using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GrassRocket : MonoBehaviour
{

    public Transform lightPos;
    public int pointsCount;
    public float offset;

    public struct Point{
        public Vector3 pos;
        public Vector3 dir;
    };

    public Material material;
    Point[] Points;
    ComputeBuffer buffer;

    void Awake()
    {
        QualitySettings.vSyncCount = 0;
        Application.targetFrameRate = 45;
    }

    void Start()
    {
        Points = new Point[pointsCount];
        buffer = new ComputeBuffer(pointsCount, 24);

        for (int i = 0; i < pointsCount/2; i++)
        {
            Points[i].pos = new Vector3(i * offset, 0, 0);
            Points[i].dir = new Vector3(0,0,1);
        }

        for (int i = 0; i < pointsCount/2; i++)
        {
            Points[i + pointsCount/2].pos = new Vector3(0, 0, i * offset);
            Points[i + pointsCount/2].dir = new Vector3(1,0,0);
        }

        buffer.SetData(Points);
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
        material.SetVector("lightPos", lightPos.position);
    }
}
