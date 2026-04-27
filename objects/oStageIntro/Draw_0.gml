draw_self()

var TEXT;
TEXT = new TextRenderer(
    $"[FONT: sStageIntroFNT]{getCURRENT_WORLD().getNAME()}"
)
TEXT.setBLEND(c_white, image_alpha);
TEXT.setALIGN(2, 1);
TEXT.draw(x - (207 / 2), y);