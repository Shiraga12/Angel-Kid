varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform sampler2D u_toTexture;
uniform float u_progress;
uniform vec2 u_resolution;
uniform vec2 u_focus;
uniform float u_pixelAmount;

void main() {
    float blendProgress = clamp(u_progress, 0.0, 1.0);
    float effectProgress = abs(blendProgress * 2.0 - 1.0);
    effectProgress = smoothstep(0.0, 1.0, effectProgress);

    vec2 focus = clamp(u_focus, vec2(0.0), vec2(1.0));
    vec2 tuv = v_vTexcoord;
    float aspectRatio = u_resolution.x / max(u_resolution.y, 1.0);
    float pixelSize = max(effectProgress * max(u_pixelAmount, 1.0), 1.0);

    vec2 uv = tuv - focus;
    uv *= pixelSize;
    uv.x *= aspectRatio;
    uv += 0.5;

    vec2 localUv = fract(uv);
    vec2 cellId = floor(uv);

    uv = cellId;
    uv.x /= aspectRatio;
    uv /= pixelSize;
    uv += focus;
    uv = clamp(uv, vec2(0.0), vec2(1.0));

    float diagonalRadius = length(vec2(
        max(focus.x, 1.0 - focus.x) * aspectRatio,
        max(focus.y, 1.0 - focus.y)
    ));

    vec3 fromPixelated = texture2D(gm_BaseTexture, uv).rgb;
    vec3 toPixelated = texture2D(u_toTexture, uv).rgb;
    vec3 fromFull = texture2D(gm_BaseTexture, tuv).rgb;
    vec3 toFull = texture2D(u_toTexture, tuv).rgb;

    vec3 col = mix(fromPixelated, toPixelated, blendProgress);

    float radialMask = length(localUv - vec2(0.5));
    col *= 1.0 - smoothstep(0.4, 0.5 + 0.5 * smoothstep(0.9, 1.0, effectProgress), radialMask);

    float radiusScale = diagonalRadius * pixelSize * max(smoothstep(-0.2, 0.9, effectProgress), 0.0001);
    float normIdInv = 1.0 - length(cellId) / radiusScale;
    normIdInv = clamp(normIdInv, 0.0, 1.0);
    col *= mix(normIdInv, 1.0, pow(effectProgress, 16.0));

    col = mix(fromFull, col, smoothstep(0.0, 0.05, blendProgress));
    col = mix(col, toFull, smoothstep(0.95, 1.0, blendProgress));

    gl_FragColor = vec4(col, 1.0) * v_vColour;
}
