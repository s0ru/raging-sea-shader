uniform float uTime;
uniform float uBigWavesElevation;
uniform vec2 uBigWavesFrequency;
uniform float uBigWavesSpeed;

uniform float uSmallWavesElevation;
uniform float uSmallWavesFrequency;
uniform float uSmallWavesSpeed;
uniform float uSmallIterations;

varying float vElevation;
varying vec3 vNormal;
varying vec3 vPosition;

#include ../includes/perlinClassic3D.glsl;

float waveElevation(vec3 position){
    float elevation = sin(position.x * uBigWavesFrequency.x + uTime * uBigWavesSpeed) *
                      sin(position.z * uBigWavesFrequency.y + uTime * uBigWavesSpeed) *
                      uBigWavesElevation;

    for(float i = 1.0; i <= uSmallIterations; i++)
    {
        elevation -= abs(perlinClassic3D(vec3(position.xz * uSmallWavesFrequency * i, uTime * uSmallWavesSpeed)) * uSmallWavesElevation / i);
    }

    return elevation;
}

void main()
{
    float shift = 0.01;
    vec4 modelPosition = modelMatrix * vec4(position, 1.0);
    vec3 neighbourA = modelPosition.xyz + vec3(shift, 0, 0);
    vec3 neighbourB = modelPosition.xyz + vec3(0, 0, -shift);

    float elevation = waveElevation(modelPosition.xyz);
    modelPosition.y += elevation;
    neighbourA.y += waveElevation(neighbourA);
    neighbourB.y += waveElevation(neighbourB);

    vec4 viewPosition = viewMatrix * modelPosition;
    vec4 projectedPosition = projectionMatrix * viewPosition;
    gl_Position = projectedPosition;

    vElevation = elevation;
    vPosition = modelPosition.xyz;

    // Compute normals
    vec3 toNeighbourA = normalize(neighbourA - modelPosition.xyz);
    vec3 toNeighbourB = normalize(neighbourB - modelPosition.xyz);
    vec3 computedNormal = cross(toNeighbourA, toNeighbourB);
    vNormal = computedNormal;
}