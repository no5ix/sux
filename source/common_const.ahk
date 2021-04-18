﻿; ; Note: Save with encoding UTF-8 with BOM if possible.
; ; Notepad will save UTF-8 files with BOM automatically (even though it does not say so).
; ; Some editors however save without BOM, and then special characters look messed up in the AHK GUI.

global limit_mode := 0
global old_limit_mode := limit_mode

global fake_lb_down := 0

global CornerEdgeOffset := 10  ; adjust tolerance value (pixels to corner) if desired	


global second_monitor_min_x := 0
global second_monitor_min_y := 0
global second_monitor_max_x := 0
global second_monitor_max_y := 0


global hot_corners_detect_interval := 88

global auto_limit_mode_when_full_screen := 0  ; if 1, turn off double shift/ctrl/alt & hot edges/corners when full screen

; ; millisecond, the smaller the value, the faster you have to double-click
global keyboard_double_click_timeout := 222
global mouse_double_click_timeout := 666



; 记录快捷键与对应操作
HOTKEY_REGISTER_LIST := {}

; 记录command与对应操作
CMD_REGISTER_LIST := {}

; 记录web-search与对应操作
WEB_SEARCH_REGISTER_LIST := {}

; 记录additional-features与对应操作
ADDITIONAL_FEATURES_REGISTER_LIST := {}

; 记录theme与对应操作
THEME_CONF_REGISTER_LIST := {}
