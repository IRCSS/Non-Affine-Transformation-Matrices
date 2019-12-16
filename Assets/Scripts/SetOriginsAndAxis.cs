using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SetOriginsAndAxis : MonoBehaviour {

    private void Update()
    {

        Shader.SetGlobalMatrix("_worldToNeck", this.transform.worldToLocalMatrix);
        Shader.SetGlobalMatrix("_NeckToWorld", this.transform.localToWorldMatrix);
    }
}
