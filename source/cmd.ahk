; ; Note: Save with encoding UTF-8 with BOM if possible.
; ; Notepad will save UTF-8 files with BOM automatically (even though it does not say so).
; ; Some editors however save without BOM, and then special characters look messed up in the AHK GUI.




WebSearch(user_input, search_key) {
	gui_destroy()
	; last_search_str := user_input

	search_flag_index = 1
	search_flag := WebSearchUrlMap[search_key][search_flag_index]
	if (search_flag = "URL") {
		if IsStandardRawUrl(user_input) {
			run %user_input%
			return
		}
	} else if (search_flag = "MULTI") {
		for _index, _elem in WebSearchUrlMap[search_key] {
			if _index != search_flag_index
				WebSearch(user_input, _elem)
		}
		return
	}

	safe_query := UriEncode(Trim(user_input))
	search_url := WebSearchUrlMap[search_key][2]
	StringReplace, search_final_url, search_url, REPLACEME, %safe_query%
	RunWait, %search_final_url%
}


trim_p := Trim(Pedersen)
last_search_str := trim_p

if !trim_p
{
	WebSearch(Clipboard, "default")
}
; else if SubStr(Pedersen, 1, 1) = A_Space
; ; else if SubStr(Pedersen, 0, 1) = A_Space
; {
; 	WebSearch(Pedersen, "default")
; }
; else if SubStr(Pedersen, 0, 1) = A_Space
; {
; 	;;; everything search(end with space) & default web search;;;
; 	gui_destroy()
; 	%EverythingShortCutFunc%()
; 	WinWaitActive, ahk_exe Everything.exe, , 0.666
; 	if ErrorLevel{
; 		; MsgBox,,, please install Everything and set its shortcut in user_conf.ahk
; 		WebSearch(Pedersen, "default")
; 	}
; 	else{
; 		last_search_str := Pedersen
; 		; Sleep, 88
; 		; SendRaw, %trim_p%
; 		Sleep, 222
; 		; SendRaw, %last_search_str%
; 		Send, {Blind}{Text}%trim_p%
; 	}
; }
else
{
	if trim_p = help ; Tooltip with list of commands
	{
		GuiControl,, trim_p, ; Clear the input box
		Gosub, gui_commandlibrary
	}
	; else if trim_p = ev ; Everything
	; {
	; 	;;; everything search(end with space) & default web search;;;
	; 	gui_destroy()
	; 	%EverythingShortCutFunc%()
	; 	WinWaitActive, ahk_exe Everything.exe, , 2.222
	; 	if ErrorLevel
	; 		MsgBox,,, please install Everything and set its shortcut in user_conf.ahk
	; }
	else if trim_p = os ; nox official site
	{
		gui_destroy()
		run "https://github.com/no5ix/nox"
	}
	; else if trim_p = url ; Open an URL from the clipboard (naive - will try to run whatever is in the clipboard)
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
	else if trim_p = cmd ; open a command prompt window on the current explorer path 
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
	else if trim_p = proj ; open this proj with vs code
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
		MaximizeWindow(1111, "Code.exe")
	}
	else if trim_p = rd ; Reload this script
	{
		gui_destroy() ; removes the GUI even when the reload fails
		Reload
	}
	else if trim_p = dir ; Open the directory for this script
	{
		gui_destroy()
		Run, %A_ScriptDir%
	}
	; else if trim_p = conf ; Edit user_conf
	; {
	; 	gui_destroy()
	; 	; run, notepad.exe "%A_ScriptDir%\user_conf.ahk"
	; 	param = %A_ScriptDir%\conf\user_conf.ahk
	; 	Run_AsUser("notepad.exe", param)
	; }
	; else if trim_p = up ; update nox
	; {
	;     MsgBox, 4,, Would you like to update nox?
	;     IfMsgBox Yes
	;     {
	;     	gui_destroy()
	;         Gosub gui_spawn
	;         UpdateNox()
	;     }
	; }
	; else if trim_p = limit ; turn on/off limit mode
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
	else if trim_p = wau ; turn on/off disable win10 auto update
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
	else if trim_p = xy ; set second monitor xy for detecting IsCorner()
	{
		Set2thMonitorXY()
		gui_destroy()
	}
	;-------------------------------------------------------------------------------
	;;; web search ;;;
	;-------------------------------------------------------------------------------
	; else if WebSearchUrlMap.HasKey(trim_p)
	; {
	; 	; for key, arr in WebSearchUrlMap ; Enumeration is the recommended approach in most cases.
	; 	; {
	; 	; 	; Using "Loop", indices must be consecutive numbers from 1 to the number
	; 	; 	; of elements in the array (or they must be calculated within the loop).
	; 	; 	; MsgBox % "Element number " . A_Index . " is " . Array[A_Index]
	; 	; 	; Using "for", both the index (or "key") and its associated value
	; 	; 	; are provided, and the index can be *any* value of your choosing.
	; 	; 	if trim_p = %key%
	; 	; 	{
	; 	; 		gui_search_title := arr[1]
	; 	; 		gui_search(arr[2])
	; 	; 		Break
	; 	; 	}
	; 	; }

	; 	gui_search_title := WebSearchUrlMap[trim_p][1]
	; 	gui_search(WebSearchUrlMap[trim_p][2])
	; }
	else
	{
		word_array := StrSplit(trim_p, A_Space, ,2)
		if (word_array[1] == "ev") {
			;;; everything search(end with space) & default web search;;;
			gui_destroy()
			%EverythingShortCutFunc%()
			WinWaitActive, ahk_exe Everything.exe, , 2.222
			if ErrorLevel
				MsgBox,,, please install Everything and set its shortcut in user_conf.ahk
			else if word_array[2]
			{
				
				last_search_str := Pedersen
				; Sleep, 88
				; SendRaw, %trim_p%
				Sleep, 222
				; SendRaw, %last_search_str%
				ev_search_str := word_array[2]
				Send, {Blind}{Text}%ev_search_str%
			}

		}
		else if WebSearchUrlMap.HasKey(word_array[1]){
			if !word_array[2]
				WebSearch(Clipboard, word_array[1])
			else
				WebSearch(word_array[2], word_array[1])
		}
		else
			WebSearch(Pedersen, "default")
	}
}
