// ----------------------------------------------------------------------------
// Gimel Studio Copyright 2019-2023 by the Gimel Studio project contributors
// Licensed under the Apache License 2.0
//
// GLSL code is from https://github.com/kajott/GIPS
// licensed under the SPDX License Copyright (c) 2021 Martin J. Fiedler
// ----------------------------------------------------------------------------

#version 330

uniform sampler2D input_img;
uniform float red;
uniform float green;
uniform float blue;
uniform float keep_luma = 1.0;
out vec4 output_img;

void main() {
    vec4 color = texelFetch(input_img, ivec2(gl_FragCoord.xy), 0);

	float luma = dot(color.rgb, vec3(.25, .5, .25));
    color.r *= 1.0 + red;
    color.g *= 1.0 + green;
    color.b *= 1.0 + blue;
    if (keep_luma > 0.5) {
        color.rgb *= luma / dot(color.rgb, vec3(.25, .5, .25));
    }
    output_img = vec4(color.rgb, color.a);
}