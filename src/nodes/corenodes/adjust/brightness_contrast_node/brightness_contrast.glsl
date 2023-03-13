// ----------------------------------------------------------------------------
// Gimel Studio Copyright 2019-2023 by the Gimel Studio project contributors
// Licensed under the Apache License 2.0
// ----------------------------------------------------------------------------

#version 330

uniform sampler2D input_img;
uniform float brightness_value;
uniform float contrast_value;
out vec4 output_img;

void main() {
    vec4 color = texelFetch(input_img, ivec2(gl_FragCoord.xy), 0);
    output_img = vec4((color.rgb - 0.5) * contrast_value + 0.5 + brightness_value, color.a);
}
