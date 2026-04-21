///
if STATIC {
	
}
else {
	VSP += GRV
    if place_meeting(x, y + 2, COLLISIONS) {
        VSP = 0
    }

    move_and_collide(HSP, VSP, COLLISIONS)
}