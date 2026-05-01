if (bannerTimer > 0) {
    bannerTimer -= 1;
}

uiAlpha = lerp(uiAlpha, uiTargetAlpha, 0.14);
if (abs(uiTargetAlpha - uiAlpha) < 0.01) {
    uiAlpha = uiTargetAlpha;
}