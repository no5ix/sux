; Note: Save with encoding UTF-8 with BOM if possible.
; Notepad will save UTF-8 files with BOM automatically (even though it does not say so).
; Some editors however save without BOM, and then special characters look messed up in the AHK GUI.


global gui_control_options := "xm w" . nox_width . " c" . nox_text_color . " -E0x200"
; Initialize variable to keep track of the state of the GUI
global gui_state := closed


gui_spawn() {
	if gui_state != closed
	{
		; If the GUI is already open, close it then reopen it.
		gui_destroy()
	}
	gui_state = main

	; Gui, +AlwaysOnTop -SysMenu +ToolWindow -caption +Border
	Gui, -SysMenu +ToolWindow -caption +hWndhMyGUI 
	
	Gui, Margin, %nox_margin_x%, %nox_margin_y%
	Gui, Color, %nox_bg_color%, %nox_control_color%
	if (nox_border_shadow_type = classic_shadow_type)
		ShadowBorder(hMyGUI)
	else
		FrameShadow(hMyGUI)

	Gui, Font, s22, Segoe UI
	; Gui, Font, s10, Segoe UI
	; Gui, Add, Edit, %gui_control_options% vGuiUserInput gIncludeCmd
	Gui, Add, Edit, %gui_control_options% vGuiUserInput, %last_search_str%
	Gui, Add, Button, x-10 y-10 w1 h1 +default gIncludeCmd ; hidden button

	xMidScrn :=  A_ScreenWidth / 2
	CoordMode, Mouse, Screen
	MouseGetPos, MX
	If (MX > A_ScreenWidth)
		xMidScrn += A_ScreenWidth
	xMidScrn -= nox_width / 2
	yScrnOffset := A_ScreenHeight / 4
	Gui, Show, x%xMidScrn% y%yScrnOffset%, myGUI
	; Gui, Show, , myGUI
	return
}


;-------------------------------------------------------------------------------
; GUI FUNCTIONS AND SUBROUTINES
;-------------------------------------------------------------------------------
; Automatically triggered on Escape key:
GuiEscape:
	gui_destroy()
	return

; The callback function when the text changes in the input field.
IncludeCmd:
	Gui, Submit, NoHide
	#Include %A_ScriptDir%\source\cmd.ahk
	return

;
; gui_destroy: Destroy the GUI after use.
;
#WinActivateForce
gui_destroy() {
	global gui_state
	
	gui_state = closed

	; Hide GUI
	Gui, Destroy

	; Bring focus back to another window found on the desktop
	WinActivate
}
