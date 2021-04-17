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


; 把两个字符串数组交叉连接起来
str_array_concate(arr, app, deli="")
{
	ret := []
	if(arr.MaxIndex()=="") {
		arr := [arr]
	}
	if(app.MaxIndex()=="") {
		app := [arr]
	}
	Loop, % arr.MaxIndex() {
		idx1 := A_Index
		Loop, % app.MaxIndex() {
			idx2 := A_Index
			ret.insert(arr[idx1] deli app[idx2])
		}
	}
	return % ret
}


register_command(key_name, action)
{
	global CMD_REGISTER_LIST
	CMD_REGISTER_LIST[key_name] := action
}


register_web_search(key_name, action)
{
	global WEB_SEARCH_REGISTER_LIST
	WEB_SEARCH_REGISTER_LIST[key_name] := action
}


register_additional_features(key_name, val)
{
	global ADDITIONAL_FEATURES_REGISTER_LIST
	ADDITIONAL_FEATURES_REGISTER_LIST[key_name] := val
}


register_theme_conf(key_name, val)
{
	global THEME_CONF_REGISTER_LIST
	THEME_CONF_REGISTER_LIST[key_name] := val
}


register_hotkey(key_name, action, prefix="")
{

	global HOTKEY_REGISTER_LIST
	trans_key := []
	
	StringLower, key_name, key_name
	map1 := {win: "#", ctrl: "^", shift: "+", alt: "!"
			,hover: "hover", capslock: "CapsLock"
			,lwin: "<#", rwin: ">#"
			,lctrl: "<^", rctrl: ">^"
			,lshift: "<+", rshift: ">+"
			,lalt: "<!", ralt: ">!"
			,lclick:  "LButton", rclick:  "RButton", wheelclick: "MButton" }
			; ,wheel: ["wheelUp", "wheelDown"] }
	key_split_arr := StrSplit(key_name, "_")
	; DebugPrintVal(key_split_arr.Length())

	Loop, % key_split_arr.MaxIndex()
	{
		cur_symbol := key_split_arr[A_Index]
		; if (key_split_arr.Length() == 1) 
		maped_symbol := (key_split_arr.Length() == 1) ? key_name : map1[cur_symbol] 
		if(maped_symbol=="") {
			trans_key := str_array_concate(trans_key, [cur_symbol])
		}
		else if(IsObject(maped_symbol)) {
		; m(trans_key)
			trans_key := str_array_concate(trans_key, maped_symbol)
		}
		else {
			trans_key := str_array_concate(trans_key, [maped_symbol])
		}
	}
		; m(trans_key)

	prefix_arr := StrSplit(prefix, "/")
	prefix_trans_keys := str_array_concate(prefix_arr, trans_key, "|")
	Loop, % prefix_trans_keys.MaxIndex()
	{
		key := prefix_trans_keys[A_Index]
		; StringUpper, key, key
		original_key := key
		; if (instr(original_key, "#"))
		; 	m(original_key)
		if !(original_key = "|CapsLock") {
			; m(original_key)
			key := StrReplace(key, "CapsLock", "CapsLock & ")
			key := StrReplace(key, "CapsLock & +", "CapsLock & ")
		}
		; m(key "//" action)
		; m(original_key "//" action)

		HOTKEY_REGISTER_LIST[original_key] := action
		; DebugPrintVal(HOTKEY_REGISTER_LIST[key])
		arr := StrSplit(key, "|")
		
		if (arr[2] == "hover") {
			Continue
		}
		
; DebugPrintVal(key)
; DebugPrintVal(action)
		; if (instr(original_key, "#")){
		; 	m(arr[2])
		; 	m(action)
		; }
; DebugPrintVal(arr[2])

		if(arr[1]!="") {
			Hotkey, IF, border_event_evoke()
			Hotkey, % arr[2], SUB_HOTKEY_ZONE_BORDER
		}
		else {
			Hotkey, IF
			Hotkey, % arr[2], SUB_HOTKEY_ZONE_ANYWAY
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


/*
; HOTKEY evoke
*/
SUB_HOTKEY_ZONE_ANYWAY:
SUB_HOTKEY_ZONE_BORDER:
	border_code := get_border_code()
	pending_replace_str := GetKeyState("LShift", "P") ? "CapsLock+": "CapsLock"
	cur_hotkey := StrReplace(A_ThisHotkey, "CapsLock & ", pending_replace_str)
	action := HOTKEY_REGISTER_LIST[border_code "|" cur_hotkey]
	if(action="") {
		; 鼠标移到边缘但触发普通热键时
		action := HOTKEY_REGISTER_LIST["|" cur_hotkey]
	}
	run(action)
Return


#IF border_event_evoke()
#IF

border_event_evoke()
{
	global HOTKEY_REGISTER_LIST
	border_code := get_border_code()
	; ToolTipWithTimer(border_code)

	key := border_code "|" A_ThisHotkey
	; ToolTipWithTimer(key)

	; StringUpper, key, key
	action := HOTKEY_REGISTER_LIST[key]
	if(action!="")
		return true
}
