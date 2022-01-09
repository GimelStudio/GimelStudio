// ----------------------------------------------------------------------------
// Gimel Studio Copyright 2019-2022 by Noah Rahm and contributors
// Licensed under the Apache License 2.0
//
// Blend mode GLSL snippets are from https://github.com/jamieowen/glsl-blend 
// licensed under the MIT License (MIT) Copyright (c) 2015 Jamie Owen
// ----------------------------------------------------------------------------

#version 330

uniform sampler2D input_img;
uniform sampler2D input_img2;
uniform float blend_mode;
uniform float opacity;
out vec4 output_img;


// Normal
vec3 blendNormal(vec3 base, vec3 blend) {
	return blend;
}
vec3 blendNormal(vec3 base, vec3 blend, float opacity) {
	return (blendNormal(base, blend) * opacity + base * (1.0 - opacity));
}

// Darken
float blendDarken(float base, float blend) {
	return min(blend,base);
}
vec3 blendDarken(vec3 base, vec3 blend) {
	return vec3(blendDarken(base.r,blend.r),blendDarken(base.g,blend.g),blendDarken(base.b,blend.b));
}
vec3 blendDarken(vec3 base, vec3 blend, float opacity) {
	return (blendDarken(base, blend) * opacity + base * (1.0 - opacity));
}

// Multiply
vec3 blendMultiply(vec3 base, vec3 blend) {
	return base*blend;
}
vec3 blendMultiply(vec3 base, vec3 blend, float opacity) {
	return (blendMultiply(base, blend) * opacity + base * (1.0 - opacity));
}

// Color Burn
float blendColorBurn(float base, float blend) {
	return (blend==0.0)?blend:max((1.0-((1.0-base)/blend)),0.0);
}
vec3 blendColorBurn(vec3 base, vec3 blend) {
	return vec3(blendColorBurn(base.r,blend.r),blendColorBurn(base.g,blend.g),blendColorBurn(base.b,blend.b));
}
vec3 blendColorBurn(vec3 base, vec3 blend, float opacity) {
	return (blendColorBurn(base, blend) * opacity + base * (1.0 - opacity));
}

// Lighten
float blendLighten(float base, float blend) {
	return max(blend,base);
}
vec3 blendLighten(vec3 base, vec3 blend) {
	return vec3(blendLighten(base.r,blend.r),blendLighten(base.g,blend.g),blendLighten(base.b,blend.b));
}
vec3 blendLighten(vec3 base, vec3 blend, float opacity) {
	return (blendLighten(base, blend) * opacity + base * (1.0 - opacity));
}

// Screen
float blendScreen(float base, float blend) {
	return 1.0-((1.0-base)*(1.0-blend));
}
vec3 blendScreen(vec3 base, vec3 blend) {
	return vec3(blendScreen(base.r,blend.r),blendScreen(base.g,blend.g),blendScreen(base.b,blend.b));
}
vec3 blendScreen(vec3 base, vec3 blend, float opacity) {
	return (blendScreen(base, blend) * opacity + base * (1.0 - opacity));
}

// Color Dodge
float blendColorDodge(float base, float blend) {
	return (blend>=1.0)?1.0:min(base/(1.0-blend),1.0);
}
vec3 blendColorDodge(vec3 base, vec3 blend) {
	return vec3(blendColorDodge(base.r,blend.r),blendColorDodge(base.g,blend.g),blendColorDodge(base.b,blend.b));
}
vec3 blendColorDodge(vec3 base, vec3 blend, float opacity) {
	return (blendColorDodge(base, blend) * opacity + base * (1.0 - opacity));
}

// Add
vec3 blendAdd(vec3 base, vec3 blend) {
	return min(base+blend,vec3(1.0));
}
vec3 blendAdd(vec3 base, vec3 blend, float opacity) {
	return (blendAdd(base, blend) * opacity + base * (1.0 - opacity));
}

// Overlay
float blendOverlay(float base, float blend) {
	return base<0.5?(2.0*base*blend):(1.0-2.0*(1.0-base)*(1.0-blend));
}
vec3 blendOverlay(vec3 base, vec3 blend) {
	return vec3(blendOverlay(base.r,blend.r),blendOverlay(base.g,blend.g),blendOverlay(base.b,blend.b));
}
vec3 blendOverlay(vec3 base, vec3 blend, float opacity) {
	return (blendOverlay(base, blend) * opacity + base * (1.0 - opacity));
}

// Soft Light
float blendSoftLight(float base, float blend) {
	return (blend<0.5)?(2.0*base*blend+base*base*(1.0-2.0*blend)):(sqrt(base)*(2.0*blend-1.0)+2.0*base*(1.0-blend));
}
vec3 blendSoftLight(vec3 base, vec3 blend) {
	return vec3(blendSoftLight(base.r,blend.r),blendSoftLight(base.g,blend.g),blendSoftLight(base.b,blend.b));
}
vec3 blendSoftLight(vec3 base, vec3 blend, float opacity) {
	return (blendSoftLight(base, blend) * opacity + base * (1.0 - opacity));
}

// Difference
vec3 blendDifference(vec3 base, vec3 blend) {
	return abs(base-blend);
}
vec3 blendDifference(vec3 base, vec3 blend, float opacity) {
	return (blendDifference(base, blend) * opacity + base * (1.0 - opacity));
}

// Subtract
float blendSubtract(float base, float blend) {
	return max(base+blend-1.0,0.0);
}
vec3 blendSubtract(vec3 base, vec3 blend) {
	return max(base+blend-vec3(1.0),vec3(0.0));
}
vec3 blendSubtract(vec3 base, vec3 blend, float opacity) {
	return (blendSubtract(base, blend) * opacity + blend * (1.0 - opacity));
}

// Divide
float blendDivide(float base, float blend) {
	return (blend==1.0)?blend:min(base/blend,1.0);
}
vec3 blendDivide(vec3 base, vec3 blend) {
	return vec3(blendDivide(base.r,blend.r),blendDivide(base.g,blend.g),blendDivide(base.b,blend.b));
}
vec3 blendDivide(vec3 base, vec3 blend, float opacity) {
	return (blendDivide(base, blend) * opacity + base * (1.0 - opacity));
}

// Reflect
float blendReflect(float base, float blend) {
	return (blend==1.0)?blend:min(base*base/(1.0-blend),1.0);
}
vec3 blendReflect(vec3 base, vec3 blend) {
	return vec3(blendReflect(base.r,blend.r),blendReflect(base.g,blend.g),blendReflect(base.b,blend.b));
}
vec3 blendReflect(vec3 base, vec3 blend, float opacity) {
	return (blendReflect(base, blend) * opacity + base * (1.0 - opacity));
}

// Glow
vec3 blendGlow(vec3 base, vec3 blend) {
	return blendReflect(blend,base);
}
vec3 blendGlow(vec3 base, vec3 blend, float opacity) {
	return (blendGlow(base, blend) * opacity + base * (1.0 - opacity));
}

// Average
vec3 blendAverage(vec3 base, vec3 blend) {
	return (base+blend)/2.0;
}
vec3 blendAverage(vec3 base, vec3 blend, float opacity) {
	return (blendAverage(base, blend) * opacity + base * (1.0 - opacity));
}

// Exclusion
vec3 blendExclusion(vec3 base, vec3 blend) {
	return base+blend-2.0*base*blend;
}
vec3 blendExclusion(vec3 base, vec3 blend, float opacity) {
	return (blendExclusion(base, blend) * opacity + base * (1.0 - opacity));
}


void main() {
    vec4 color1 = texelFetch(input_img, ivec2(gl_FragCoord.xy), 0);
    vec4 color2 = texelFetch(input_img2, ivec2(gl_FragCoord.xy), 0);

    if (blend_mode == 1.0) { // Normal
        vec3 color = blendNormal(color2.rgb, color1.rgb, opacity);
        output_img = vec4(color, 1.0);

    } else if (blend_mode == 2.0) { // Darken
        vec3 color = blendDarken(color2.rgb, color1.rgb, opacity);
        output_img = vec4(color, 1.0);

    } else if (blend_mode == 3.0) { // Multiply
        vec3 color = blendMultiply(color2.rgb, color1.rgb, opacity);
        output_img = vec4(color, 1.0);

    } else if (blend_mode == 4.0) { // Color Burn
        vec3 color = blendColorBurn(color2.rgb, color1.rgb, opacity);
        output_img = vec4(color, 1.0);

    } else if (blend_mode == 5.0) { // Lighten
        vec3 color = blendLighten(color2.rgb, color1.rgb, opacity);
        output_img = vec4(color, 1.0);

    } else if (blend_mode == 6.0) { // Screen
        vec3 color = blendScreen(color2.rgb, color1.rgb, opacity);
        output_img = vec4(color, 1.0);

    } else if (blend_mode == 7.0) { // Color Dodge
        vec3 color = blendColorDodge(color2.rgb, color1.rgb, opacity);
        output_img = vec4(color, 1.0);
        
    } else if (blend_mode == 8.0) { // Add
        vec3 color = blendAdd(color2.rgb, color1.rgb, opacity);
        output_img = vec4(color, 1.0);

    } else if (blend_mode == 9.0) { // Overlay
        vec3 color = blendOverlay(color2.rgb, color1.rgb, opacity);
        output_img = vec4(color, 1.0);

    } else if (blend_mode == 10.0) { // Soft Light
        vec3 color = blendSoftLight(color2.rgb, color1.rgb, opacity);
        output_img = vec4(color, 1.0);

    } else if (blend_mode == 11.0) { // Difference
        vec3 color = blendDifference(color2.rgb, color1.rgb, opacity);
        output_img = vec4(color, 1.0);

    } else if (blend_mode == 12.0) { // Subtract
        vec3 color = blendSubtract(color2.rgb, color1.rgb, opacity);
        output_img = vec4(color, 1.0);

    } else if (blend_mode == 13.0) { // Divide
        vec3 color = blendDivide(color2.rgb, color1.rgb, opacity);
        output_img = vec4(color, 1.0);

    } else if (blend_mode == 14.0) { // Reflect
        vec3 color = blendReflect(color2.rgb, color1.rgb, opacity);
        output_img = vec4(color, 1.0);

    } else if (blend_mode == 15.0) { // Glow
        vec3 color = blendGlow(color2.rgb, color1.rgb, opacity);
        output_img = vec4(color, 1.0);

    } else if (blend_mode == 16.0) { // Average
        vec3 color = blendAverage(color2.rgb, color1.rgb, opacity);
        output_img = vec4(color, 1.0);

    } else if (blend_mode == 17.0) { // Exclusion
        vec3 color = blendExclusion(color2.rgb, color1.rgb, opacity);
        output_img = vec4(color, 1.0);
    
    }

}