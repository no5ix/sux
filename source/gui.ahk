; Note: Save with encoding UTF-8 with BOM if possible.
; Notepad will save UTF-8 files with BOM automatically (even though it does not say so).
; Some editors however save without BOM, and then special characters look messed up in the AHK GUI.


global gui_control_options := "xm w" . nox_width . " c" . nox_text_color . " -E0x200"
; Initialize variable to keep track of the state of the GUI
global gui_state := closed
; Initialize search_urls as a variable set to zero
global search_urls := 0


gui_spawn() {
	; SaveCurSelectedText()
	if gui_state != closed
	{
		; If the GUI is already open, close it then reopen it.
		gui_destroy()
	}
	gui_state = main

	search_urls := 0

	; Gui, +AlwaysOnTop -SysMenu +ToolWindow -caption +Border
	Gui, -SysMenu +ToolWindow -caption +hWndhMyGUI 
	
	Gui, Margin, %nox_margin_x%, %nox_margin_y%
	Gui, Color, %nox_bg_color%, %nox_control_color%
	if (nox_border_shadow_type = classic_shadow_type)
		ShadowBorder(hMyGUI)
	else
		FrameShadow(hMyGUI)

	Gui, Font, s22, Segoe UI
	; Gui, Add, Text, %gui_control_options% vgui_main_title, ¯\_(ツ)_/¯
	; Gui, Font, s10, Segoe UI
	; Gui, Add, Edit, %gui_control_options% vPedersen gFindus
	Gui, Add, Edit, %gui_control_options% vPedersen
	Gui, Add, Button, x-10 y-10 w1 h1 +default gFindus ; hidden button

	xMidScrn :=  A_ScreenWidth / 2
	CoordMode, Mouse, Screen
	MouseGetPos, MX
	If (MX > A_ScreenWidth)
		xMidScrn += A_ScreenWidth
	xMidScrn -= nox_width / 2
	yScrnOffset := A_ScreenHeight / 4
	Gui, Show, x%xMidScrn% y%yScrnOffset%, myGUI
	; Gui, Show, , myGUI
	if last_search_str {
		SendRaw, %last_search_str%
		Send, ^a
	}
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
Findus:
	Gui, Submit, NoHide
	#Include %A_ScriptDir%\source\cmd.ahk
	return

;
; gui_destroy: Destroy the GUI after use.
;
#WinActivateForce
gui_destroy() {
	global gui_state
	global gui_search_title
	
	gui_state = closed
	; Forget search title variable so the next search does not re-use it
	; in case the next search does not set its own:
	gui_search_title =

	; Clear the tooltip
	Gosub, gui_tooltip_clear

	; Hide GUI
	Gui, Destroy

	; Bring focus back to another window found on the desktop
	WinActivate
}

gui_change_title(message,color = "") {
	; If parameter color is omitted, the message is assumed to be an error
	; message, and given the color red.
	If color =
	{
		global cRed
		color := cRed
	}
	GuiControl,, gui_main_title, %message%
	Gui, Font, s11 %color%
	GuiControl, Font, gui_main_title
	Gui, Font, s10 cffffff ; reset
}

;-------------------------------------------------------------------------------
; SEARCH ENGINES
;-------------------------------------------------------------------------------
;
; gui_search_add_elements: Add GUI controls to allow typing of a search query.
;
gui_search_add_elements:
	GuiControl,, Pedersen, %gui_search_title%
	; Gui, Add, Text, %gui_control_options% %cGray%, %A_Space%%gui_search_title%
	Gui, Add, Edit, %gui_control_options% vgui_SearchEdit -WantReturn
	Gui, Add, Button, x-10 y-10 w1 h1 +default ggui_SearchEnter ; hidden button
	GuiControl, Disable, Pedersen
	GuiControl, focus, gui_SearchEdit
	Gui, Show, AutoSize
	if last_search_str {
		SendRaw, %last_search_str%
		Send, ^a
	}
	return

gui_search(url) {
	global
	if gui_state != search
	{
		gui_state = search
		; if gui_state is "main", then we are coming from the main window and
		; GUI elements for the search field have not yet been added.
		Gosub, gui_search_add_elements
		; SendRaw, %cur_selected_text%
		; Send, ^a
	}

	; Assign the url to a variable.
	; The variables will have names search_url1, search_url2, ...

	search_urls := search_urls + 1
	search_url%search_urls% := url
}

gui_SearchEnter:
	Gui, Submit
	gui_destroy()
	last_search_str := gui_SearchEdit
	safe_query := UriEncode(gui_SearchEdit)
	Loop, %search_urls%
	{
		StringReplace, search_final_url, search_url%A_Index%, REPLACEME, %safe_query%
		run %search_final_url%
	}
	search_urls := 0
	return


;-------------------------------------------------------------------------------
; TOOLTIP
; The tooltip shows all defined commands, along with a description of what
; each command does. It gets the description from the comments in cmd.ahk.
; The code was improved and fixed for Windows 10 with the help of schmimae.
;-------------------------------------------------------------------------------
gui_tooltip_clear:
	ToolTip
	return

gui_commandlibrary:
	; hidden GUI used to pass font options to tooltip:
	CoordMode, Tooltip, Screen ; To make sure the tooltip coordinates is displayed according to the screen and not active window
	Gui, 2:Font,s10, Lucida Console
	Gui, 2:Add, Text, HwndhwndStatic

	tooltiptext =
	maxpadding = 0
	StringCaseSense, Off ; Matching to both if/If in the IfInString command below
	Loop, read, %A_ScriptDir%/source/cmd.ahk
	{
		; search for the string If Pedersen =, but search for each word individually because spacing between words might not be consistent. (might be improved with regex)
		If Substr(A_LoopReadLine, 1, 1) != ";" ; Do not display commented commands
		{
			If A_LoopReadLine contains if
			{
				IfInString, A_LoopReadLine, Pedersen
					IfInString, A_LoopReadLine, =
					{
						StringGetPos, setpos, A_LoopReadLine,=
						StringTrimLeft, trimmed, A_LoopReadLine, setpos+1 ; trim everything that comes before the = sign
						StringReplace, trimmed, trimmed, `%A_Space`%,{space}, All
						tooltiptext .= trimmed
						tooltiptext .= "`n"

						; The following is used to correct padding:
						StringGetPos, commentpos, trimmed,`;
						if (maxpadding < commentpos)
							maxpadding := commentpos
					}
			}
		}
	}
	tooltiptextpadded =
	Loop, Parse, tooltiptext,`n
	{
		line = %A_LoopField%
		StringGetPos, commentpos, line, `;
		spaces_to_insert := maxpadding - commentpos
		Loop, %spaces_to_insert%
		{
			StringReplace, line, line,`;,%A_Space%`;
		}
		tooltiptextpadded .= line
		tooltiptextpadded .= "`n"
	}
	Sort, tooltiptextpadded
	for key, arr in WebSearchUrlMap
	{
		tooltiptextpadded .= key . "    `; Search " . arr[1]
		tooltiptextpadded .= "`n"
	}
	ToolTip %tooltiptextpadded%, 3, 3, 1
	return
