varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform sampler2D u_toTexture;
uniform float u_progress;

#define offsets normalize(vec3(5.0, 2.0, 1.0))

vec3 sonicFadeToBlack(vec3 color, float amount) {
    float t = smoothstep(0.0, 1.0, clamp(amount, 0.0, 1.0));
    return clamp(color - t * offsets * 8.0, 0.0, 1.0);
}

void main() {
    float progress = clamp(u_progress, 0.0, 1.0);
    vec3 fromColor = texture2D(gm_BaseTexture, v_vTexcoord).rgb;
    vec3 toColor = texture2D(u_toTexture, v_vTexcoord).rgb;
    vec3 color;

    if (progress < 0.5) {
        color = sonicFadeToBlack(fromColor, progress / 0.5);
    }
    else {
        color = sonicFadeToBlack(toColor, (1.0 - progress) / 0.5);
    }

    gl_FragColor = vec4(color, 1.0) * v_vColour;
}