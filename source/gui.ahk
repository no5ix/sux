; Note: Save with encoding UTF-8 with BOM if possible.
; Notepad will save UTF-8 files with BOM automatically (even though it does not say so).
; Some editors however save without BOM, and then special characters look messed up in the AHK GUI.


; Initialize variable to keep track of the state of the GUI
; global gui_state := closed


gui_spawn(curr_select_text="") {
	; curr_select_text := GetCurSelectedText()
	; if (StrLen(curr_select_text) >= 60 || str)
	; 	curr_select_text := ""
	last_search_str := curr_select_text ? curr_select_text : last_search_str

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
	; Gui, Add, Edit, %gui_control_options% vGuiUserInput gHandleGuiUserInput
	gui_control_options := "xm w" . nox_width . " c" . nox_text_color . " -E0x200"
	Gui, Add, Edit, %gui_control_options% vGuiUserInput, %last_search_str%
	; Gui, Add, Edit, %gui_control_options% vGuiUserInput, %curr_select_text%
	; Gui, Add, Edit, xm w620 ccBlack -E0x200 vGuiUserInput, %last_search_str%

	Gui, Add, Button, x-10 y-10 w1 h1 +default gHandleGuiUserInput ; hidden button

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
HandleGuiUserInput:
	Gui, Submit, NoHide
	; #Include %A_ScriptDir%\source\cmd.ahk

	trim_gui_user_input := Trim(GuiUserInput)
	last_search_str := trim_gui_user_input

	if !trim_gui_user_input
	{
		WebSearch(Clipboard, "default")
		gui_destroy()
	}
	; else if SubStr(GuiUserInput, 1, 1) = A_Space
	; ; else if SubStr(GuiUserInput, 0, 1) = A_Space
	; {
	; 	WebSearch(GuiUserInput, "default")
		; gui_destroy()
	; }
	; else if SubStr(GuiUserInput, 0, 1) = A_Space
	; {
	; 	;;; everything search(end with space) & default web search;;;
	; 	gui_destroy()
	; 	%EverythingShortCutFunc%()
	; 	WinWaitActive, ahk_exe Everything.exe, , 0.666
	; 	if ErrorLevel{
	; 		; MsgBox,,, please install Everything and set its shortcut in user_conf.ahk
	; 		WebSearch(GuiUserInput, "default")
			; gui_destroy()

	; 	}
	; 	else{
	; 		last_search_str := GuiUserInput
	; 		; Sleep, 88
	; 		; SendRaw, %trim_gui_user_input%
	; 		Sleep, 222
	; 		; SendRaw, %last_search_str%
	; 		Send, {Blind}{Text}%trim_gui_user_input%
	; 	}
	; }
	else
	{
		; else if trim_gui_user_input = ev ; Everything
		; {
		; 	;;; everything search(end with space) & default web search;;;
		; 	gui_destroy()
		; 	%EverythingShortCutFunc%()
		; 	WinWaitActive, ahk_exe Everything.exe, , 2.222
		; 	if ErrorLevel
		; 		MsgBox,,, please install Everything and set its shortcut in user_conf.ahk
		; }
		; else
		; if trim_gui_user_input = os ; nox official site
		; {
		; 	gui_destroy()
		; 	run "https://github.com/no5ix/nox"
		; }
		; else if trim_gui_user_input = url ; Open an URL from the clipboard (naive - will try to run whatever is in the clipboard)
		; {
		; 	; msg_str := "This is your clipboard url content : `n`n" . ClipBoard . " `n`n Would you like to open it ?"
		; 	; MsgBox, 4,, %msg_str%
		; 	; IfMsgBox Yes
		; 	; {
		; 	; 	gui_destroy()
		; 	; 	run %ClipBoard%
		; 	; }
			
		; 	gui_search_title := "URL"
		; 	gui_search("http://REPLACEME", 1)
		; }
		; else
		if trim_gui_user_input = cmd ; open a command prompt window on the current explorer path 
		{
			gui_destroy()
			IfWinActive, ahk_exe explorer.exe
			{
				Send, !d
				SendInput, cmd.exe`n  ; 等同于下面这两句
				; SendRaw, cmd
				; Send, {Enter}
			}
			else
			{
				run cmd.exe
			}
		}
		;-------------------------------------------------------------------------------
		;;; INTERACT WITH THIS AHK SCRIPT ;;;
		;-------------------------------------------------------------------------------
		; else if trim_gui_user_input = proj ; open this proj with vs code
		; {
		; 	gui_destroy()
		; 	; run, %comspec% /c Code "%A_ScriptDir%,,hide
		; 	; run, cmd /c Code "%A_ScriptDir%,,hide
		; 	script_dir = %A_ScriptDir%
		; 	if vscode_path {
		; 		Run_AsUser(vscode_path, script_dir)  ;; call Microsoft VS Code\Code.exe
		; 	}else {
		; 		Run_AsUser("code", script_dir)  ;; call Microsoft VS Code\bin\code , has a ugly cmd window
		; 	}
		; 	MaximizeWindow(6666, "Code.exe")
		; }
		else if trim_gui_user_input = rd ; Reload this script
		{
			gui_destroy() ; removes the GUI even when the reload fails
			Reload
		}
		else if trim_gui_user_input = dir ; Open the directory for this script
		{
			gui_destroy()
			Run, %A_ScriptDir%
		}
		; else if trim_gui_user_input = conf ; Edit user_conf
		; {
		; 	gui_destroy()
		; 	; run, notepad.exe "%A_ScriptDir%\user_conf.ahk"
		; 	param = %A_ScriptDir%\conf\user_conf.ahk
		; 	Run_AsUser("notepad.exe", param)
		; }
		else if trim_gui_user_input = up ; update nox
		{
			MsgBox, 4,, Would you like to update nox?
			IfMsgBox Yes
			{
				gui_destroy()
				; Gosub gui_spawn
				UpdateNox(0)
			}
		}
		; else if trim_gui_user_input = limit ; turn on/off limit mode
		; {
		; 	msg_str := "Would you like to turn " . (limit_mode ? "off" : "on") . " limit mode?"
		; 	MsgBox, 4,, %msg_str%
		; 	IfMsgBox Yes
		; 	{
		; 		gui_destroy()
		; 		limit_mode := limit_mode ? 0 : 1
		; 		if limit_mode {
		; 			if enable_hot_corners
		; 				SetTimer, LimitModeWhenFullScreen, Off
		; 			MsgBox, Double Shift is disabled in limit mode`, you can CapsLock+X to open nox input box.
		; 		} else {
		; 			if enable_hot_corners
		; 				SetTimer, LimitModeWhenFullScreen, 888
		; 		}
		; 	}
		; }
		else if trim_gui_user_input = wau ; turn on/off disable win10 auto update
		{
			msg_str := "Would you like to turn " . (disable_win10_auto_update ? "off" : "on") . " disable win10 auto update?"
			MsgBox, 4,, %msg_str%
			IfMsgBox Yes
			{
				gui_destroy()
				disable_win10_auto_update := disable_win10_auto_update ? 0 : 1
				if (disable_win10_auto_update == 0) {
					SetTimer, DisableWin10AutoUpdate, off
					run, cmd /c sc config wuauserv start= auto,,hide
					run, cmd /c net start wuauserv,,hide
				} else {
					DisableWin10AutoUpdate()
					SetTimer, DisableWin10AutoUpdate, 66666
				}
			}
		}
		else if trim_gui_user_input = xy ; set second monitor xy for detecting IsCorner()
		{
			Set2thMonitorXY()
			gui_destroy()
		}
		else if trim_gui_user_input = nw ; start nox with windows
		{
			StartNoxWithWindows()
			gui_destroy()
		}
		;-------------------------------------------------------------------------------
		;;; web search ;;;
		;-------------------------------------------------------------------------------
		; else if WebSearchUrlMap.HasKey(trim_gui_user_input)
		; {
		; 	; for key, arr in WebSearchUrlMap ; Enumeration is the recommended approach in most cases.
		; 	; {
		; 	; 	; Using "Loop", indices must be consecutive numbers from 1 to the number
		; 	; 	; of elements in the array (or they must be calculated within the loop).
		; 	; 	; MsgBox % "Element number " . A_Index . " is " . Array[A_Index]
		; 	; 	; Using "for", both the index (or "key") and its associated value
		; 	; 	; are provided, and the index can be *any* value of your choosing.
		; 	; 	if trim_gui_user_input = %key%
		; 	; 	{
		; 	; 		gui_search_title := arr[1]
		; 	; 		gui_search(arr[2])
		; 	; 		Break
		; 	; 	}
		; 	; }

		; 	gui_search_title := WebSearchUrlMap[trim_gui_user_input][1]
		; 	gui_search(WebSearchUrlMap[trim_gui_user_input][2])
		; }

		;-------------------------------------------------------------------------------
		;;; custom command line ;;;
		;-------------------------------------------------------------------------------
		else if CustomCommandLineMap.HasKey(trim_gui_user_input)
		{
			gui_destroy()
			Run_AsUser(CustomCommandLineMap[trim_gui_user_input]*)
		}
		else
		{
			word_array := StrSplit(trim_gui_user_input, A_Space, ,2)
			if !word_array[2]
				pending_search_str := Clipboard
			else
				pending_search_str := word_array[2]
				
			if (word_array[1] == "ev") {
				;;; everything search
				gui_destroy()
				%EverythingShortCutFunc%()
				WinWaitActive, ahk_exe Everything.exe, , 2.222
				if ErrorLevel
					MsgBox,,, please install Everything and set its shortcut in user_conf.ahk
				else
				{
					; last_search_str := GuiUserInput
					; Sleep, 88
					; SendRaw, %trim_gui_user_input%
					Sleep, 222
					; SendRaw, %last_search_str%
					Send, {Blind}{Text}%pending_search_str%
				}
			}
			else if WebSearchUrlMap.HasKey(word_array[1]){
				WebSearch(pending_search_str, word_array[1])
				gui_destroy()
			}
			else {
				WebSearch(GuiUserInput, "default")
				gui_destroy()
			}

		}
	}

	return
