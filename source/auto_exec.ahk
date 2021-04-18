; ; Note: Save with encoding UTF-8 with BOM if possible.
; ; Notepad will save UTF-8 files with BOM automatically (even though it does not say so).
; ; Some editors however save without BOM, and then special characters look messed up in the AHK GUI.


#Include %A_ScriptDir%\source\common_const.ahk
#Include %A_ScriptDir%\source\util.ahk
#Include %A_ScriptDir%\source\nox_core.ahk
#Include %A_ScriptDir%\source\cmd_web_search.ahk
#Include %A_ScriptDir%\source\clipboard_plus.ahk



IsFirstTimeRunNox() {
	; monitor_xy_conf_file := A_ScriptDir "\conf\monitor_xy_conf.ahk"
	; return !FileExist(monitor_xy_conf_file)
}


HotCorners() {
	global HOTKEY_REGISTER_LIST
	; ToolTipWithTimer("ggsmd")
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
	
	; Autorun()

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

NoxCore.Ini()

RunAsAdmin()

if IsFirstTimeRunNox() {
    HandleStartingNoxWithWindows()
    ; WriteMonitorConf()
}

; if auto_limit_mode_when_full_screen
; 	SetTimer, LimitModeWhenFullScreen, 88

if ADDITIONAL_FEATURES_REGISTER_LIST["disable_win10_auto_update"]
    SetTimer, DisableWin10AutoUpdate, 66666

if ADDITIONAL_FEATURES_REGISTER_LIST["enable_hot_corners"] {
    SetTimer, HotCorners, %hot_corners_detect_interval%
}