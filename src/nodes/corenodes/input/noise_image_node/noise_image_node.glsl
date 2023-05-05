// ----------------------------------------------------------------------------
// Gimel Studio Copyright 2019-2023 by the Gimel Studio project contributors
// Licensed under the Apache License 2.0
// ----------------------------------------------------------------------------

#version 330 core

uniform sampler2D input_img;
in vec2 tex_coord;
out vec4 output_img;

float random (vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}

float simplex_noise(vec2 pos) {
    float n = 0.0;
    float s = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 4; i++) {
        vec2 p = pos * pow(2.0, float(i));
        s += amplitude;
        n += amplitude * random(p);
        amplitude *= 0.5;
    }
    return n / s;
}

void main() {
    vec2 res = textureSize(input_img, 0);
    vec2 st = gl_FragCoord.xy/res;
    float randomValue = simplex_noise(st);
    vec3 color = step(0.5, vec3(randomValue));
    gl_FragColor = vec4(vec3(color),1.0);
}