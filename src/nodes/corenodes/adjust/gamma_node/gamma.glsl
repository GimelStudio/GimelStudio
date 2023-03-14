// ----------------------------------------------------------------------------
// Gimel Studio Copyright 2019-2023 by the Gimel Studio project contributors
// Licensed under the Apache License 2.0
// ----------------------------------------------------------------------------

#version 330

uniform sampler2D input_img;
uniform float gamma_value;
out vec4 output_img;

vec4 gamma(vec4 in_color, float g) {
    vec4 abs_color = abs(in_color);
    return vec4(pow(abs_color.r, g), pow(abs_color.g, g), pow(abs_color.b, g), abs_color.a);
}

void main() {
    vec4 col = texelFetch(input_img, ivec2(gl_FragCoord.xy), 0);
    output_img = gamma(col, gamma_value);
}