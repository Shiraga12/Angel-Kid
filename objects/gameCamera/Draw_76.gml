var camW = camera_get_view_width(view_camera[0]);
var camH = camera_get_view_height(view_camera[0]);
x = clamp(oPlayer.x - camW/2, 0, room_width - camW);
y = clamp(oPlayer.y - camH/2, 0, room_width - camH);

camera_set_view_pos(view_camera[0], x, y);