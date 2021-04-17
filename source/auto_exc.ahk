; ; Note: Save with encoding UTF-8 with BOM if possible.
; ; Notepad will save UTF-8 files with BOM automatically (even though it does not say so).
; ; Some editors however save without BOM, and then special characters look messed up in the AHK GUI.


RunAsAdmin() {
	full_command_line := DllCall("GetCommandLine", "str")
	if not (A_IsAdmin or RegExMatch(full_command_line, " /restart(?!\S)"))
	{
		try
		{
			if A_IsCompiled
				Run *RunAs "%A_ScriptFullPath%" /restart
			else
				Run *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%"
		}
		ExitApp
	}
}

IsFirstTimeRunNox() {
	monitor_xy_conf_file := A_ScriptDir "\conf\monitor_xy_conf.ahk"
	return !FileExist(monitor_xy_conf_file)
}


HotCorners() {
	global HOTKEY_REGISTER_LIST
	border_code := Sys.Cursor.CornerPos()
	if (InStr(border_code, "Corner")) {
		action := HOTKEY_REGISTER_LIST[border_code "|" "hover"]
		; ToolTipWithTimer(border_code "|" "hover")
		; ToolTipWithTimer(action)

		run(action)
		Loop 
		{
			if (Sys.Cursor.CornerPos() == "")
				break ; exits loop when mouse is no longer in the corner
		}
	}
}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;






OneQuick.Ini()



/*
普通快捷键
*/
if(OneQuick.GetFeatureCfg("hotkey.switch", 0))
{
	For key, value in OneQuick.GetFeatureCfg("hotkey.buildin", {})
		register_hotkey(key, value, "")
}

/*
屏幕边缘操作
*/
if(OneQuick.GetFeatureCfg("screen-border.switch", 0))
{
	For border_key, border_action in OneQuick.GetFeatureCfg("screen-border.action", {})
		for key, value in border_action
			register_hotkey(key, value, border_key)
}

comma_delimiters_arr := ["','", "', '", "'，'", "'， '"]
if(OneQuick.GetFeatureCfg("command.switch", 0))
{
	For key, value in OneQuick.GetFeatureCfg("command.buildin", {})
		register_command(key, StrSplit(value, comma_delimiters_arr))
	For key, value in OneQuick.GetFeatureCfg("command.custom", {})
		register_command(key, StrSplit(value, comma_delimiters_arr))
}

if(OneQuick.GetFeatureCfg("web-search.switch", 0))
{
	For key, value in OneQuick.GetFeatureCfg("web-search.buildin", {})
		register_web_search(key, StrSplit(value, comma_delimiters_arr))
	For key, value in OneQuick.GetFeatureCfg("web-search.custom", {})
		register_web_search(key, StrSplit(value, comma_delimiters_arr))
}

For key, value in OneQuick.GetFeatureCfg("additional-features", {})
	register_additional_features(key, value)

For key, value in OneQuick.GetFeatureCfg("theme", {})
	register_theme_conf(key, value)


if(OneQuick.GetFeatureCfg("clipboard.switch", 0))
{
	For key, value in OneQuick.GetFeatureCfg("clipboard.hotkey", {})
		register_hotkey(key, value, "")
}


global hot_corners_detect_interval := 88

global auto_limit_mode_when_full_screen := 0  ; if 1, turn off double shift/ctrl/alt & hot edges/corners when full screen

; ; millisecond, the smaller the value, the faster you have to double-click
global keyboard_double_click_timeout := 222
global mouse_double_click_timeout := 666


RunAsAdmin()

if IsFirstTimeRunNox() {
    HandleStartingNoxWithWindows()
    ; WriteMonitorConf()
}


if auto_limit_mode_when_full_screen
	SetTimer, LimitModeWhenFullScreen, 88

if ADDITIONAL_FEATURES_REGISTER_LIST["disable_win10_auto_update"]
    SetTimer, DisableWin10AutoUpdate, 66666

if ADDITIONAL_FEATURES_REGISTER_LIST["enable_hot_corners"]
    SetTimer, HotCorners, %hot_corners_detect_interval%

; if ADDITIONAL_FEATURES_REGISTER_LIST["auto_update_when_launch_nox"]
;     UpdateNoxImpl(1)

