/// 

draw_self();

var DIALOGUE = new TextRenderer(
	$"[SCALE: 2]{string_upper("The following is a demo.\nThe elements here are subject to change.")}"
);

DIALOGUE.setALIGN(1, 1);
DIALOGUE.draw(centerX, guiHEIGHT - 100);