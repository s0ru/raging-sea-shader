uniform vec3 uDepthColor;
uniform vec3 uSurfaceColor;
uniform float uColorOffset;
uniform float uColorMultiplier;

varying float vElevation;
varying vec3 vNormal;
varying vec3 vPosition;

#include ../includes/pointLight.glsl;

void main()
{
    vec3 normal = normalize(vNormal);
    vec3 viewDirection = normalize(vPosition - cameraPosition);

    vec3 light = vec3(0.0);
    light += pointLight(
        vec3(1.0),              // Color
        10.0,                   // Intensity
        normal,         
        vec3(0.0, 0.25, 0.0),  // Light position
        viewDirection, 
        30.0,                   // Specular pow
        vPosition,
        0.95                    // Decay
    );

    float mixStrength = smoothstep(0.0, 1.0, (vElevation + uColorOffset) * uColorMultiplier);
    vec3 color = mix(uDepthColor, uSurfaceColor, mixStrength);

    color *= light;
    
    gl_FragColor = vec4(color, 1.0);
    #include <colorspace_fragment>
}