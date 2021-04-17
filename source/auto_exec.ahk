; ; Note: Save with encoding UTF-8 with BOM if possible.
; ; Notepad will save UTF-8 files with BOM automatically (even though it does not say so).
; ; Some editors however save without BOM, and then special characters look messed up in the AHK GUI.


global hot_corners_detect_interval := 88

global auto_limit_mode_when_full_screen := 0  ; if 1, turn off double shift/ctrl/alt & hot edges/corners when full screen

; ; millisecond, the smaller the value, the faster you have to double-click
global keyboard_double_click_timeout := 222
global mouse_double_click_timeout := 666


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
	border_code := get_border_code()
	if (InStr(border_code, "Corner")) {
		action := HOTKEY_REGISTER_LIST[border_code "|" "hover"]
		; ToolTipWithTimer(border_code "|" "hover")
		; ToolTipWithTimer(action)

		run(action)
		Loop 
		{
			if (get_border_code() == "")
				break ; exits loop when mouse is no longer in the corner
		}
	}
}


HandleStartingNoxWithWindows() {
	; Clipboard =    ; Empties Clipboard
	; Send, ^c        ; Copies filename and path
	; ClipWait 0      ; Waits for copy
	; SplitPath, Clipboard, Name, Dir, Ext, Name_no_ext, Drive

	msg_str := "Would you like to start nox with windows? Yes(Enable) or No(Disable)"
	MsgBox, 3,, %msg_str%
	IfMsgBox Cancel
		return

	Name_no_ext := "nox"
	Name := "nox.ahk"
	Dir = %A_ScriptDir%
	nox_ahk_file_path =  %A_ScriptFullPath%

	IfExist, %A_Startup%\%Name_no_ext%.lnk
	{
		IfMsgBox No
		{
			FileDelete, %A_Startup%\%Name_no_ext%.lnk
			MsgBox, %Name% removed from the Startup folder.
		}
	}
	Else
	{
		IfMsgBox Yes
		{
			FileCreateShortcut, "%nox_ahk_file_path%"
				, %A_Startup%\%Name_no_ext%.lnk
				, %Dir%   ; Line wrapped using line continuation
			MsgBox, %Name% added to Startup folder for auto-launch with Windows.
		}
	}
}



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; m("kkk")
NoxCore.Ini()

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


if(NoxCore.GetFeatureCfg("hotkey.switch", 0))
{
	For key, value in NoxCore.GetFeatureCfg("hotkey.buildin", {})
		register_hotkey(key, value, "")
}

if(NoxCore.GetFeatureCfg("hot-corner-edge.switch", 0))
{
	For border_key, border_action in NoxCore.GetFeatureCfg("hot-corner-edge.action", {})
		for key, value in border_action
			register_hotkey(key, value, border_key)
}

comma_delimiters_arr := ["','", "', '", "'，'", "'， '"]
if(NoxCore.GetFeatureCfg("command.switch", 0))
{
	For key, value in NoxCore.GetFeatureCfg("command.buildin", {})
		register_command(key, StrSplit(value, comma_delimiters_arr))
	For key, value in NoxCore.GetFeatureCfg("command.custom", {})
		register_command(key, StrSplit(value, comma_delimiters_arr))
}

if(NoxCore.GetFeatureCfg("web-search.switch", 0))
{
	For key, value in NoxCore.GetFeatureCfg("web-search.buildin", {})
		register_web_search(key, StrSplit(value, comma_delimiters_arr))
	For key, value in NoxCore.GetFeatureCfg("web-search.custom", {})
		register_web_search(key, StrSplit(value, comma_delimiters_arr))
}

For key, value in NoxCore.GetFeatureCfg("additional-features", {})
	register_additional_features(key, value)

For key, value in NoxCore.GetFeatureCfg("theme", {})
	register_theme_conf(key, value)


if(NoxCore.GetFeatureCfg("clipboard-plus.switch", 0))
{
	For key, value in NoxCore.GetFeatureCfg("clipboard-plus.hotkey", {})
		register_hotkey(key, value, "")
}


