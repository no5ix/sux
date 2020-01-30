; ; Note: Save with encoding UTF-8 with BOM if possible.
; ; Notepad will save UTF-8 files with BOM automatically (even though it does not say so).
; ; Some editors however save without BOM, and then special characters look messed up in the AHK GUI.

ltrim_input := LTrim(Pedersen)

if ltrim_input = help ; Tooltip with list of commands
{
	GuiControl,, ltrim_input, ; Clear the input box
	Gosub, gui_commandlibrary
}
else if ltrim_input = os ; nox official site
{
	gui_destroy()
	run "https://github.com/no5ix/nox"
}
else if ltrim_input = url ; Open an URL from the clipboard (naive - will try to run whatever is in the clipboard)
{
	msg_str := "This is your clipboard url content : `n`n" . ClipBoard . " `n`n Would you like to open it ?"
    MsgBox, 4,, %msg_str%
    IfMsgBox Yes
    {
		gui_destroy()
		run %ClipBoard%
	}
}
else if ltrim_input = cmd ; open a command prompt window on the current explorer path 
{
	gui_destroy()
	IfWinActive, ahk_exe explorer.exe
	{
		Send, !d
		SendInput, cmd`n  ; 等同于下面这两句
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
else if ltrim_input = proj ; open this proj with vs code
{
	gui_destroy()
	; run, %comspec% /c Code "%A_ScriptDir%,,hide
	; run, cmd /c Code "%A_ScriptDir%,,hide
	script_dir = %A_ScriptDir%
	if vscode_path {
		Run_AsUser(vscode_path, script_dir)  ;; call Microsoft VS Code\Code.exe
	}else {
		Run_AsUser("code", script_dir)  ;; call Microsoft VS Code\bin\code , has a ugly cmd window
	}
	; MaximizeWindow("Code.exe")
	MaximizeWindow(1111)
}
else if ltrim_input = touchpad ; switch touchpad mode
{
	msg_str := "Would you like to turn " . (use_touchpad ? "off" : "on") . " touchpad mode?"
    MsgBox, 4,, %msg_str%
    IfMsgBox Yes
    {
		use_touchpad := use_touchpad ? 0 : 1
		gui_destroy()
    }
}
else if ltrim_input = rd ; Reload this script
{
	gui_destroy() ; removes the GUI even when the reload fails
	Reload
}
else if ltrim_input = dir ; Open the directory for this script
{
	gui_destroy()
	Run, %A_ScriptDir%
}
; else if ltrim_input = conf ; Edit user_conf
; {
; 	gui_destroy()
; 	; run, notepad.exe "%A_ScriptDir%\user_conf.ahk"
; 	param = %A_ScriptDir%\conf\user_conf.ahk
; 	Run_AsUser("notepad.exe", param)
; }
; else if ltrim_input = up ; update nox
; {
;     MsgBox, 4,, Would you like to update nox?
;     IfMsgBox Yes
;     {
;     	gui_destroy()
;         Gosub gui_spawn
;         UpdateNox()
;     }
; }
else if ltrim_input = game ; turn on/off game mode
{
	msg_str := "Would you like to turn " . (limit_mode ? "off" : "on") . " game mode?"
    MsgBox, 4,, %msg_str%
    IfMsgBox Yes
    {
		gui_destroy()
		limit_mode := limit_mode ? 0 : 1
		if limit_mode
			MsgBox, Double Alt is disabled in game mode`, you can CapsLock+X to open nox input box.
    }
}


;-------------------------------------------------------------------------------
;;; web search ;;;
;-------------------------------------------------------------------------------
else if WebSearchUrlMap.HasKey(ltrim_input)
{
	; for key, arr in WebSearchUrlMap ; Enumeration is the recommended approach in most cases.
	; {
	; 	; Using "Loop", indices must be consecutive numbers from 1 to the number
	; 	; of elements in the array (or they must be calculated within the loop).
	; 	; MsgBox % "Element number " . A_Index . " is " . Array[A_Index]
	; 	; Using "for", both the index (or "key") and its associated value
	; 	; are provided, and the index can be *any* value of your choosing.
	; 	if ltrim_input = %key%
	; 	{
	; 		gui_search_title := arr[1]
	; 		gui_search(arr[2])
	; 		Break
	; 	}
	; }

	gui_search_title := WebSearchUrlMap[ltrim_input][1]
	gui_search(WebSearchUrlMap[ltrim_input][2])
}

;-------------------------------------------------------------------------------
;;; everything search(end with space) & default web search;;;
;-------------------------------------------------------------------------------
else
{
	trim_p := Trim(Pedersen)
	if SubStr(ltrim_input, 0, 1) = A_Space
	{
		gui_destroy()
		EverythingShortCut()
		WinWaitActive, ahk_exe Everything.exe, , 0.222
		if ErrorLevel
			DefaultWebSearch(trim_p)
		else
			SendRaw, %trim_p%
	}
	else
		DefaultWebSearch(trim_p)
}

