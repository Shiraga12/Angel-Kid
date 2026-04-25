/// @desc Main menu using the sMM_* sprite set.

menuItems = [
    { sprite: sMM_AngelMode, enabled: true, targetRoom: Room1, notice: "" },
    { sprite: sMM_TimeAttack, enabled: false, targetRoom: noone, notice: "TIME ATTACK COMING SOON" },
    { sprite: sMM_Competition, enabled: false, targetRoom: noone, notice: "COMPETITION COMING SOON" },
    { sprite: sMM_Options, enabled: false, targetRoom: noone, notice: "OPTIONS COMING SOON" }
];

selectedIndex = 0;
menuAnchorX = 0.5;
menuAnchorY = 0.42;
menuScale = 3;
menuSpacing = 78;

transitionDuration = 180;
transitionPixelAmount = 50;
transitionShader = shdSonicFadeToBlackTransition;

noticeText = "";
noticeTimer = 0;
noticeDuration = room_speed;

selectNEXT = function(_direction) {
    var itemCount = array_length(menuItems);
    selectedIndex = (selectedIndex + _direction + itemCount) mod itemCount;
};

activateSELECTED = function() {
    var item = menuItems[selectedIndex];

    if (item.enabled) {
        var guiWidth = max(1, display_get_gui_width());
        var guiHeight = max(1, display_get_gui_height());
        var itemX = guiWidth * menuAnchorX;
        var itemY = guiHeight * menuAnchorY + ((selectedIndex - ((array_length(menuItems) - 1) * 0.5)) * menuSpacing);

        transition_goto(
            item.targetRoom,
            itemX / guiWidth,
            itemY / guiHeight,
            transitionDuration,
            transitionPixelAmount,
            transitionShader
        );
        return;
    }

    noticeText = item.notice;
    noticeTimer = noticeDuration;
};