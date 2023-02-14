// ----------------------------------------------------------------------------
// Gimel Studio Copyright 2019-2023 by the Gimel Studio project contributors
// Licensed under the Apache License 2.0
// ----------------------------------------------------------------------------

#version 330 core

uniform sampler2D input_img;
in vec2 tex_coord;
out vec4 output_img;

mat3 sobel_x = mat3(1.0, 5.0, 1.0, 0.0, 0.0, 0.0, -1.0, -5.0, -1.0);
mat3 sobel_y = mat3(1.0, 0.0, -1.0, 5.0, 0.0, -5.0, 1.0, 0.0, -1.0);

void main() {
    vec3 diffuse = texture(input_img, tex_coord.st).rgb;
    mat3 I;
    for (int i=0; i<3; i++) {
        for (int j=0; j<3; j++) {
            vec3 sample  = texelFetch(input_img, ivec2(gl_FragCoord) + ivec2(i-1,j-1), 0 ).rgb;
            I[i][j] = length(sample);
        }
    }

    float gx = dot(sobel_x[0], I[0]) + dot(sobel_x[1], I[1]) + dot(sobel_x[2], I[2]);
    float gy = dot(sobel_y[0], I[0]) + dot(sobel_y[1], I[1]) + dot(sobel_y[2], I[2]);

    float grad_magnitude = sqrt(pow(gx, 2.0)+pow(gy, 2.0));
    output_img = vec4(diffuse - vec3(grad_magnitude), 1.0);
}
