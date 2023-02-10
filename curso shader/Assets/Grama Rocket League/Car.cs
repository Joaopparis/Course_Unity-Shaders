using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Car : MonoBehaviour
{
    [SerializeField]float _speed;
    Rigidbody _rb;
    public Transform cam;
    void Start()
    {
        _rb = GetComponent<Rigidbody>();
    }

    void Update()
    {
        move();
        cam.position = new Vector3(transform.position.x, transform.position.y + 0.6f, transform.position.z - 1.15f);
    }

    void move()
    {
        float Horizontal = Input.GetAxis("Horizontal");
        float Vertical = Input.GetAxis("Vertical");

        Vector3 Inputs = new Vector3(Horizontal, 0f, Vertical);
        transform.LookAt(transform.position + new Vector3(Inputs.x, 0, Inputs.z));
        _rb.velocity = Vector3.Normalize(Inputs) * _speed;
    }
}
