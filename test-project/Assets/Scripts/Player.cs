using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Player : MonoBehaviour
{

    //[SerializeField] private Transform groundCheckTransform = null;
    [SerializeField] private LayerMask playerMask;
    [SerializeField] private float rotationSpeed;
    [SerializeField] private float speed;
    private Rigidbody rigidBodyComponent;
    private float horizontalInput;
    private float verticalInput;
    

    // Start is called before the first frame update
    void Start()
    {
        rigidBodyComponent = GetComponent<Rigidbody>();
    }

    // Update is called once per frame
    void Update()
    {
        horizontalInput = Input.GetAxis("Horizontal");
        verticalInput = Input.GetAxis("Vertical");
    }


    // FixedUpdate is called once every physic update
    private void FixedUpdate()
    {

        rigidBodyComponent.velocity = new Vector3(horizontalInput, 0, verticalInput);
        rigidBodyComponent.velocity.Normalize();
        transform.Translate((rigidBodyComponent.velocity) * speed * Time.deltaTime, Space.World);
      
        if(rigidBodyComponent.velocity != Vector3.zero)
        {
            Quaternion toRotation = Quaternion.LookRotation((-1) * rigidBodyComponent.velocity, Vector3.up);
            transform.rotation = Quaternion.RotateTowards(transform.rotation, toRotation, rotationSpeed * Time.deltaTime);
        }

    }    

}
