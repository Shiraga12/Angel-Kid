draw_self()

var TEXT;
TEXT = new TextRenderer(
    $"[FONT: sStageIntroFNT][SCALE: 0.5]{getCURRENT_WORLD().getNAME()}"
)
TEXT.setBLEND(c_white, image_alpha);
TEXT.setALIGN(2, 1);
TEXT.draw(x - (207 / 2), y);

var stageNUMBER;
stageNUMBER = new TextRenderer(
    $"[FONT: sStageIntroNumberFNT]{string(API.STAGE + 1)}"
) 
stageNUMBER.setBLEND(c_white, image_alpha);
stageNUMBER.setALIGN(1, 1);
stageNUMBER.draw(x, y);
