using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerPosition : MonoBehaviour
{

    public Transform player;
    private Renderer _renderer;

    // Start is called before the first frame update
    void Start()
    {
        _renderer = GetComponent<Renderer>();
    }

    // Update is called once per frame
    void Update()
    {
        _renderer.material.SetVector("_PlayerPosition", player.position);
    }
}
