// ----------------------------------------------------------------------------
// Gimel Studio Copyright 2019-2023 by the Gimel Studio project contributors
// Licensed under the Apache License 2.0
// ----------------------------------------------------------------------------

#version 330

uniform sampler2D input_img;
uniform sampler2D input_img2;
uniform float factor;
out vec4 output_img;

void main() {
    vec4 color1 = texelFetch(input_img, ivec2(gl_FragCoord.xy), 0);
    vec4 color2 = texelFetch(input_img2, ivec2(gl_FragCoord.xy), 0);

    output_img = mix(color1, color2, factor);
}