; ; Note: Save with encoding UTF-8 with BOM if possible.
; ; Notepad will save UTF-8 files with BOM automatically (even though it does not say so).
; ; Some editors however save without BOM, and then special characters look messed up in the AHK GUI.

; HandleMouseOnEdges(from) {
; 	if (enable_hot_edges = 0){
; 		return [should_not_ignore_original_action, "Notice: conf.enable_hot_edges is 0, so edge triggers are disabled."]
; 	}
; 	if (limit_mode){
; 		return [should_not_ignore_original_action, "Notice: limit mode is on, edge triggers are disabled."]
; 	}
; 	if IsCorner(){
; 		return [should_not_ignore_original_action, "Notice: Is Corner, so do NOTHING by edge triggers."]
; 	}
; 	CoordMode, Mouse, Screen		; Coordinate mode - coords will be passed to mouse related functions, with coords relative to entire screen 
; 	MouseGetPos, MouseX, MouseY 							; Function MouseGetPos retrieves the current position of the mouse cursor

; 	min_max_xy_arr := GetCurMonitorMinMaxXYArray(MouseX)
; 	cur_monitor_min_x := min_max_xy_arr[1]
; 	cur_monitor_max_x := min_max_xy_arr[2]
; 	cur_monitor_min_y := min_max_xy_arr[3]
; 	cur_monitor_max_y := min_max_xy_arr[4]

; 	cur_monitor_width := abs(cur_monitor_max_x-cur_monitor_min_x)
; 	cur_monitor_height := abs(cur_monitor_max_y-cur_monitor_min_y)

; 	Sleep, 66  ; 不加这个 `Sleep 66`, 可能某些快捷键跟触发快捷键有混杂冲突啥的, 比如可能会有win开始界面一闪而过
; 	if (MouseY < cur_monitor_min_y + CornerEdgeOffset)
; 	{
; 		if Abs(MouseX-cur_monitor_min_x) < (cur_monitor_width / 2)
; 			cur_should_go_on_doing := %HotEdgesTopHalfLeftTriggerFunc%(from)
; 		else
; 			cur_should_go_on_doing := %HotEdgesTopHalfRightTriggerFunc%(from)
; 	}
; 	else if (MouseY > cur_monitor_max_y - CornerEdgeOffset)
; 	{
; 		if Abs(MouseX-cur_monitor_min_x) < (cur_monitor_width / 2)
; 			cur_should_go_on_doing := %HotEdgesBottomHalfLeftTriggerFunc%(from)
; 		else
; 			cur_should_go_on_doing := %HotEdgesBottomHalfRightTriggerFunc%(from)
; 	}
; 	else if (MouseX < cur_monitor_min_x + CornerEdgeOffset)
; 	{
; 		if Abs(MouseY-cur_monitor_min_y) < (cur_monitor_height / 2)
; 			cur_should_go_on_doing := %HotEdgesLeftHalfUpTriggerFunc%(from)
; 		else
; 			cur_should_go_on_doing := %HotEdgesLeftHalfDownTriggerFunc%(from)
; 	}
; 	else if (MouseX > cur_monitor_max_x - CornerEdgeOffset)
; 	{
; 		if Abs(MouseY-cur_monitor_min_y) < (cur_monitor_height / 2)
; 			cur_should_go_on_doing := %HotEdgesRightHalfUpTriggerFunc%(from)
; 		else
; 			cur_should_go_on_doing := %HotEdgesRightHalfDownTriggerFunc%(from)
; 	}
;    return [cur_should_go_on_doing, ""]
; }



; HandleMouseOnEdges(from) {

; }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



RShift::
	if (A_PriorHotkey <> "RShift" or A_TimeSincePriorHotkey > keyboard_double_click_timeout)
	{
		; Too much time between presses, so this isn't a double-press.
		ClickUpIfLbDown()
		Send, ^{Space}
		KeyWait, RShift
		return
	}
	if limit_mode {
		ToolTipWithTimer("	limit mode is on, double RShift is disabled.", 2000)
		return
	}
	; Send, ^{Space}
	Send, ^+{Left}
	; Sleep, 66
	Send, {Del}
	return

~Esc::
	ClickUpIfLbDown()
	return

~LWin::
	ClickUpIfLbDown()
	return
	
~RWin::
	ClickUpIfLbDown()
	return


~Alt::
	; ; 不能这么写, 因为这样长按 alt 也会触发
	; If (A_PriorHotKey = "~Alt") AND (A_TimeSincePriorHotkey < keyboard_double_click_timeout)
	; 	gui_spawn()
	if (A_PriorHotkey <> "~Alt" or A_TimeSincePriorHotkey > keyboard_double_click_timeout)
	{
		; Too much time between presses, so this isn't a double-press.
		ClickUpIfLbDown()
		KeyWait, Alt  ; Wait for the key to be released.
		return
	}
	if limit_mode {
		ToolTipWithTimer("	limit mode is on, double Alt is disabled.", 2000)
		return
	}
	%DoubleClickAltTriggerFunc%()
	return


~Ctrl::
	if (A_PriorHotkey <> "~Ctrl" or A_TimeSincePriorHotkey > keyboard_double_click_timeout)
	{
		; Too much time between presses, so this isn't a double-press.
		ClickUpIfLbDown()
		KeyWait, Ctrl
		return
	}
	if limit_mode {
		ToolTipWithTimer("	limit mode is on, double Ctrl is disabled.", 2000)
		return
	}
	%DoubleClickCtrlTriggerFunc%()
	return



;=====================================================================o
;                       For Notebook: 
; 功能(主要用于笔记本触摸板): 			                                ;|
;---------------------------------o-----------------------------------o

; - 单击快捷键Ctrl+8: 模拟鼠标左键按下, 在触摸板上拖动则可选中

; ^8::
; 	result_arr := HandleMouseOnEdges("Ctrl+8")
; 	if result_arr[1] = should_ignore_original_action
; 		return
; 	SetDefaultMouseSpeed, 0 ; Move the mouse instantly.
; 	SetMouseDelay, 0
; 	fake_lb_down = 1
; 	Click Down
; 	; ToolTipWithTimer("simulate click DOWN. `n" . result_arr[2], 2222)
; 	return


; MButton::
; 	ClickUpIfLbDown()
; 	result_arr := HandleMouseOnEdges("MButton")
; 	if result_arr[1] = should_ignore_original_action
; 		return
; 	MouseClick, Middle
; 	return


; RButton::
; 	ClickUpIfLbDown()
; 	result_arr := HandleMouseOnEdges("RButton")
; 	if result_arr[1] = should_ignore_original_action
; 		return
; 	MouseClick, Right
; 	return


^+!m::
	MaxMinWindow()
	return


; ; 这个$符号是为了防止下方代码中的`Send, ^w`一直触发自己
; $^w::
; 	result_arr := HandleMouseOnEdges("Ctrl+W")
; 	if result_arr[1] = should_ignore_original_action
; 		return
; 	Send, ^w
; 	return



; -----------------------------------------------------------------------------
; ~LShift::
; 	ClickUpIfLbDown()
; 	; TimeButtonDown = %A_TickCount%
; 	; ; Wait for it to be released
; 	; Loop
; 	; {
; 	; 	Sleep 10
; 	; 	GetKeyState, LshiftState, Lshift, P
; 	; 	if LshiftState = U  ; Button has been released.
; 	; 		break
; 	; 	elapsed = %A_TickCount%
; 	; 	elapsed -= %TimeButtonDown%
; 	; 	if elapsed > 200  ; Button was held down long enough
; 	; 	{
; 	; 		x0 = A_CaretX
; 	; 		y0 = A_CaretY
; 	; 		Loop
; 	; 		{
; 	; 			Sleep 20                    ; yield time to others
; 	; 			GetKeyState keystate, Lshift
; 	; 			IfEqual keystate, U, {
; 	; 			x = A_CaretX
; 	; 			y = A_CaretY
; 	; 			break
; 	; 			}
; 	; 		}
; 	; 		if (x-x0 > 5 or x-x0 < -5 or y-y0 > 5 or y-y0 < -5)
; 	; 		{                             ; Caret has moved
; 	; 			clip0 := ClipBoardAll      ; save old clipboard
; 	; 			;ClipBoard =
; 	; 			Send ^c                    ; selection -> clipboard
; 	; 			ClipWait 1, 1              ; restore clipboard if no data
; 	; 			IfEqual ClipBoard,, SetEnv ClipBoard, %clip0%
; 	; 		}
; 	; 		return
; 	; 	}
; 	; }
; 	if (A_PriorHotkey <> "~LShift" or A_TimeSincePriorHotkey > keyboard_double_click_timeout)
; 	{
; 		; Too much time between presses, so this isn't a double-press.
; 		KeyWait, LShift
; 		return
; 	}
; 	if limit_mode {
; 		ToolTipWithTimer("	limit mode is on, double Shift is disabled.", 2000)
; 		return
; 	}
; 	%DoubleClickShiftTriggerFunc%()
; 	return
; -----------------------------------------------------------------------------


; -----------------------------------------------------------------------------

; ~Ins::
; 	ClickUpIfLbDown()
; 	if (A_PriorHotkey <> "~Ins" or A_TimeSincePriorHotkey > keyboard_double_click_timeout)
; 	{
; 		; Too much time between presses, so this isn't a double-press.
; 		KeyWait, Ins
; 		return
; 	}
; 	Send, {F2}
; 	return


;---------------------------------------------------------------------o

;---------------------------------------------------------------------o
					;Auto copy clipboard begin
;---------------------------------------------------------------------o
; 功能: 
; - 双击则复制, 如果笔记本触摸板开启了双击拖动就可以多选的话, 则双击无法复制
; - 三击则复制
; - 选中则复制
; ~LButton::
; fake_lb_down = 0
; if (!enable_auto_selection_copy or limit_mode)
; 	return
; MouseGetPos, xx
; TimeButtonDown = %A_TickCount%
; ; Wait for it to be released
; Loop
; {
; 	Sleep 10
; 	GetKeyState, LButtonState, LButton, P
; 	if LButtonState = U  ; Button has been released.
; 	{
; 		If WinActive("Crimson Editor") and (xx < 25) ; Single Click in the Selection Area of CE
; 		{
; 			Send, ^c
; 			ToolTipWithTimer("copy selection finished.")
; 			return
; 		}
; 		break
; 	}
; 	elapsed = %A_TickCount%
; 	elapsed -= %TimeButtonDown%
; 	if elapsed > 200  ; Button was held down too long, so assume it's not a double-click.
; 	{
; 		MouseGetPos x0, y0            ; save start mouse position
; 		Loop
; 	{
; 		Sleep 20                    ; yield time to others
; 		GetKeyState keystate, LButton
; 		IfEqual keystate, U, {
; 		MouseGetPos x, y          ; position when button released
; 		break
; 		}
; 	}
; 	if (x-x0 > 5 or x-x0 < -5 or y-y0 > 5 or y-y0 < -5)
; 	{                             ; mouse has moved
; 		clip0 := ClipBoardAll      ; save old clipboard
; 		;ClipBoard =
; 		Send ^c                    ; selection -> clipboard
; 			ToolTipWithTimer("copy selection finished.")

; 		ClipWait 1, 1              ; restore clipboard if no data
; 		IfEqual ClipBoard,, SetEnv ClipBoard, %clip0%
; 	}
; 		return
; 	}
; }
; ; Otherwise, button was released quickly enough.  Wait to see if it's a double-click:
; TimeButtonUp = %A_TickCount%
; Loop
; {
; 	Sleep 10
; 	GetKeyState, LButtonState, LButton, P
; 	if LButtonState = D  ; Button has been pressed down again.
; 		break
; 	elapsed = %A_TickCount%
; 	elapsed -= %TimeButtonUp%
; 	if elapsed > 350  ; No click has occurred within the allowed time, so assume it's not a double-click.
; 		return
; }

; ;Button pressed down again, it's at least a double-click
; TimeButtonUp2 = %A_TickCount%
; Loop
; {
; 	Sleep 10
; 	GetKeyState, LButtonState2, LButton, P
; 	if LButtonState2 = U  ; Button has been released a 2nd time, let's see if it's a tripple-click.
; 		break
; }
; ;Button released a 2nd time
; TimeButtonUp3 = %A_TickCount%
; Loop
; {
; 	Sleep 10
; 	GetKeyState, LButtonState3, LButton, P
; 	if LButtonState3 = D  ; Button has been pressed down a 3rd time.
; 		break
; 	elapsed = %A_TickCount%
; 	elapsed -= %TimeButtonUp%
; 	if elapsed > 350  ; No click has occurred within the allowed time, so assume it's not a tripple-click.
; 	{  ;Double-click
; 		Send, ^c
; 		ToolTipWithTimer("copy selection finished.")
; 		return
; 	}
; }
; ;Tripple-click:
; 	Sleep, 100
; 	Send, ^c
; 	ToolTipWithTimer("copy selection finished.")
; return
; ---------------------------------------------------------------------o
; 					Auto copy clipboard end
; ---------------------------------------------------------------------o

#Include, %A_ScriptDir%\source
#Include, OneQuick.Core.ahk
#Include, Yaml.ahk


class OneQuick
{
	; dir
	static _MAIN_WORKDIR := ""
	static _JSON_DIR := "data/"
	static _ICON_DIR := "icon/"
	static _LANG_DIR := "lang/"
	static _CONF_DIR := "conf/"
	static _Update_bkp_DIR := "_bkp/"
	static _Update_dl_DIR := "_bkp/dl/"
	static _Update_bkp_folder_prefix := "_auto_"
	; file
	static Launcher_Name := A_WorkingDir "\OneQuick Launcher.exe"
	static Ext_ahk_file := "OneQuick.Ext.ahk"
	static version_yaml_file := OneQuick._CONF_DIR "version.yaml"
	static feature_yaml_file := "OneQuick.feature.yaml"
	static feature_yaml_default_file := OneQuick._CONF_DIR "OneQuick.feature.default.yaml"
	static config_file := "config.ini"
	static user_data_file := OneQuick._JSON_DIR "OneQuick.Data." A_ComputerName ".json"
	static icon_default := OneQuick._ICON_DIR "1.ico"
	static icon_suspend := OneQuick._ICON_DIR "2.ico"
	static icon_pause := OneQuick._ICON_DIR "4.ico"
	static icon_suspend_pause := OneQuick._ICON_DIR "3.ico"
	; remote file path
	static remote_branch := "master"
	static remote_raw := "http://raw.githubusercontent.com/XUJINKAI/OneQuick/" OneQuick.remote_branch "/"
	static remote_releases_dir := "https://github.com/XUJINKAI/OneQuick/releases/download/"
	static remote_update_dl_dir := OneQuick.remote_releases_dir "beta0/"
	; github api has limit
	; static remote_contents := "https://api.github.com/repos/XUJINKAI/OneQuick/contents/"
	; update
	static check_update_first_after := 1
	static check_update_period := 1000*3600*24
	static Bkp_limit := 5
	static update_list_path := OneQuick._CONF_DIR "update_list.json"
	; online
	static Project_Home_Page := "https://github.com/XUJINKAI/OneQuick"
	static Project_Issue_page := "https://github.com/XUJINKAI/OneQuick/issues"
	static remote_download_html := "https://github.com/XUJINKAI/OneQuick/releases"
	static remote_help := "https://github.com/XUJINKAI/OneQuick/wiki"
	;
	; setting object (read only, for feature configuration)
	static FeatureObj =
	; version object (read only, for check update)
	static versionObj =
	; running user data (e.g. clipboard history), read after run & write before exit
	static UserData := {}
	; callback
	static OnExitCmd := []
	static OnClipboardChangeCmd := []
	static OnPauseCmd := []
	static OnSuspendCmd := []
	; static var
	static ProgramName := "OneQuick"
	static Default_lang := "cn"
	static Editor = notepad
	static Browser := "default"

	Ini(asLib=false)
	{
		CoordMode, Mouse, Screen
		; setting
		this.LoadFeatureYaml()
	}

	; feature.yaml
	GetFeatureCfg(keyStr, default="")
	{
		keyArray := StrSplit(keyStr, ".")
		obj := OneQuick.FeatureObj
		Loop, % keyArray.MaxIndex()-1
		{
			cur_key := keyArray[A_Index]
			obj := obj[cur_key]
		}
		cur_key := keyArray[keyArray.MaxIndex()]
		if(obj[cur_key]=="")
		{
			return default
		}
		return obj[cur_key]
	}

	LoadFeatureYaml()
	{
		if(OneQuick._DEBUG_ && this.debugConfig("load_default_feature_yaml", 0)) {
			OneQuick.FeatureObj := Yaml(OneQuick.feature_yaml_default_file)
		}
		else {
			if(!FileExist(this.feature_yaml_file)) {
				FileCopy, % this.feature_yaml_default_file, % this.feature_yaml_file, 0
			}
			OneQuick.FeatureObj := Yaml(OneQuick.feature_yaml_file)
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


register_hotkey(key_name, action, prefix="")
{

	global HOTKEY_REGISTER_LIST
	trans_key := []
	map1 := {win: "#", ctrl: "^", shift: "+", alt: "!"
			,hover: "hover", caps: "CapsLock"
			,lwin: "<#", rwin: ">#"
			,lctrl: "<^", rctrl: ">^"
			,lshift: "<+", rshift: ">+"
			,lalt: "<!", ralt: ">!"
			,lclick:  "LButton", rclick:  "RButton", wheelclick: "MButton" }
			; ,wheel: ["wheelUp", "wheelDown"] }
	key_split_arr := StrSplit(key_name, "_")
	Loop, % key_split_arr.MaxIndex()
	{
		cur_symbol := key_split_arr[A_Index]
		maped_symbol := map1[cur_symbol]
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


/*
; HOTKEY evoke
*/
SUB_HOTKEY_ZONE_ANYWAY:
SUB_HOTKEY_ZONE_BORDER:
border_code := Sys.Cursor.CornerPos()
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
	border_code := Sys.Cursor.CornerPos()
	; ToolTipWithTimer(border_code)

	key := border_code "|" A_ThisHotkey
	; ToolTipWithTimer(key)

	; StringUpper, key, key
	action := HOTKEY_REGISTER_LIST[key]
	if(action!="")
		return true
}