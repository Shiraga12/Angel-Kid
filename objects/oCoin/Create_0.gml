stateFREE = new stateFUNCS(
	function() {
		if place_meeting(x,y,oPlayer) {
			state = stateDESTROY;
			addCOINS(1)
			var coinSound = asset_get_index("sndCoin");
			if (coinSound != -1) {
				audio_play_sound(coinSound, 0, false);
			}
			image_index = 0
		}
	}
);

stateDESTROY = new stateFUNCS(
	function() {
		sprite_index = sCoinEffect
		if image_index >= sprite_get_number(sprite_index) - 1 {
			instance_destroy();
		}
	}
);

state = stateFREE;