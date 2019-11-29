#include <itowns/precision_qualifier>
#include <common>
#include <itowns/project_pars_vertex>
#include <itowns/elevation_pars_vertex>
#include <logdepthbuf_pars_vertex>
attribute vec2      uv_0;
#if NUM_CRS > 1
attribute vec2      uv_1;
#endif
attribute vec3      normal;
attribute vec2      wgs84;
attribute vec2      l93;

uniform mat4 modelMatrix;
uniform bool lightingEnabled;

// itownsresearch mod
uniform float zDisplacement;
// itownsresearch mod over

#if MODE == MODE_FINAL
#include <fog_pars_vertex>
varying vec3        vUv;
varying vec3        vNormal;
#endif
varying vec2        vWgs84;
varying vec2        vL93;
void main() {
        vec2 uv = vec2(uv_0.x, 1.0 - uv_0.y);

        #include <begin_vertex>
        #include <itowns/elevation_vertex>

        // itownsresearch mod
        transformed += zDisplacement * normal;
        // itownsresearch mod over

        #include <project_vertex>
        #include <logdepthbuf_vertex>
#if MODE == MODE_FINAL
        #include <fog_vertex>
        #if NUM_CRS > 1
        vUv = vec3(uv_0, (uv_1.y > 0.) ? uv_1.y : uv_0.y); // set uv_1 = uv_0 if uv_1 is undefined
        #else
        vUv = vec3(uv_0, 0.0);
        #endif
        vNormal = normalize ( mat3( modelMatrix[0].xyz, modelMatrix[1].xyz, modelMatrix[2].xyz ) * normal );
        vWgs84 = wgs84;
        vL93 = l93;
#endif
}
