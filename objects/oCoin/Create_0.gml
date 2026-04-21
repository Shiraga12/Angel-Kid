stateFREE = function() {
	if place_meeting(x,y,oPlayer) {
		STATE = stateDESTROY
		addCOINS(1)
		image_index = 0
	}
}

stateDESTROY = function() {
	sprite_index = sCoinEffect
	if image_index >= sprite_get_number(sprite_index) - 1 {
		instance_destroy();
	}
}

STATE = stateFREE