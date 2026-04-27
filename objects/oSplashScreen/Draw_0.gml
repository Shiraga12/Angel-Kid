/// 

draw_self();

var DIALOGUE = new TextRenderer(
	$"[COLOR: c_white]{string_upper("This is normal. ")}[SPRITE: sCoin]"+
	$"[COLOR: c_red]{string_upper("This is red, and [WAVE]this waves[/WAVE] while still red")}[/COLOR].{string_upper("Now normal again.")}\n" +
	$"[SINE: 6, 2]{string_upper("Floating text")}[/SINE]\n" +
    $"[JITTER: 3][HSV: 3]{string_upper("ERROR ERROR ERROR")}[/HSV][/JITTER]\n" +
	$"[RAINBOW: 2][SCALE: 2]{string_upper("Wonderful!")}[/SCALE][/RAINBOW]"
);

DIALOGUE.setBOX(420, 160);

DIALOGUE.draw(64, 64);