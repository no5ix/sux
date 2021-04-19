; ; Note: Save with encoding UTF-8 with BOM if possible.
; ; Notepad will save UTF-8 files with BOM automatically (even though it does not say so).
; ; Some editors however save without BOM, and then special characters look messed up in the AHK GUI.


#Include %A_ScriptDir%\source\common_const.ahk
#Include %A_ScriptDir%\source\util.ahk
#Include %A_ScriptDir%\source\nox_core.ahk
#Include %A_ScriptDir%\source\search_gui.ahk
#Include %A_ScriptDir%\source\clipboard_plus.ahk



HotCorners() {
	global HOTKEY_REGISTER_MAP
	; ToolTipWithTimer("ggsmd")
	border_code := get_border_code()
	if (InStr(border_code, "Corner")) {
		action := HOTKEY_REGISTER_MAP[border_code "|" "hover"]
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





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

NoxCore.Ini()

RunAsAdmin()

; if auto_limit_mode_when_full_screen
; 	SetTimer, LimitModeWhenFullScreen, 88

if ADDITIONAL_FEATURES_REGISTER_MAP["disable_win10_auto_update"]
    SetTimer, DisableWin10AutoUpdate, 66666

if ADDITIONAL_FEATURES_REGISTER_MAP["enable_hot_corners"] {
    SetTimer, HotCorners, %hot_corners_detect_interval%
}