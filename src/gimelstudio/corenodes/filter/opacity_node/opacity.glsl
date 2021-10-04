// ----------------------------------------------------------------------------
// Gimel Studio Copyright 2019-2021 by Noah Rahm and contributors
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// FILE: opacity.glsl
// AUTHOR(S): Noah Rahm
// PURPOSE: Adjust the opacity of an image
// ----------------------------------------------------------------------------

#version 330

uniform sampler2D input_img;
uniform float opacity_value;
out vec4 output_img;

void main() {
    vec4 color = texelFetch(input_img, ivec2(gl_FragCoord.xy), 0);
    if (color.a > 0) output_img = vec4(color.r, color.g, color.b, opacity_value);
    else output_img = color;
}
