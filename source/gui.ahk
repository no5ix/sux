; Note: Save with encoding UTF-8 with BOM if possible.
; Notepad will save UTF-8 files with BOM automatically (even though it does not say so).
; Some editors however save without BOM, and then special characters look messed up in the AHK GUI.


; Initialize variable to keep track of the state of the GUI
; global gui_state := closed



; global classic_shadow_type := 0
; global modern_shadow_type := 1
global THEME_CONF_REGISTER_LIST

ShadowBorder(handle)
{
    DllCall("user32.dll\SetClassLongPtr", "ptr", handle, "int", -26, "ptr", DllCall("user32.dll\GetClassLongPtr", "ptr", handle, "int", -26, "uptr") | 0x20000)
}

FrameShadow(handle) {
	DllCall("dwmapi\DwmIsCompositionEnabled","IntP",_ISENABLED) ; Get if DWM Manager is Enabled
	if !_ISENABLED ; if DWM is not enabled, Make Basic Shadow
		DllCall("SetClassLong","UInt",handle,"Int",-26,"Int",DllCall("GetClassLong","UInt",handle,"Int",-26)|0x20000)
	else {
		VarSetCapacity(_MARGINS,16)
		NumPut(1,&_MARGINS,0,"UInt")
		NumPut(1,&_MARGINS,4,"UInt")
		NumPut(1,&_MARGINS,8,"UInt")
		NumPut(1,&_MARGINS,12,"UInt")
		DllCall("dwmapi\DwmSetWindowAttribute", "Ptr", handle, "UInt", 2, "Int*", 2, "UInt", 4)
		DllCall("dwmapi\DwmExtendFrameIntoClientArea", "Ptr", handle, "Ptr", &_MARGINS)
	}
}


gui_destroy() {
	; Hide GUI
	Gui, Destroy
}


gui_spawn(curr_select_text="") {
	gui_destroy()
	; curr_select_text := GetCurSelectedText()
	; if (StrLen(curr_select_text) >= 60 || str)
	; 	curr_select_text := ""
	last_search_str := curr_select_text ? curr_select_text : last_search_str

	; Gui, +AlwaysOnTop -SysMenu +ToolWindow -caption +Border
	Gui, -SysMenu +ToolWindow -caption +hWndhMyGUI 
	
	Gui, Margin, THEME_CONF_REGISTER_LIST["nox_margin_x"], THEME_CONF_REGISTER_LIST["nox_margin_y"]
	nox_bg_color := THEME_CONF_REGISTER_LIST["nox_bg_color"] 
	nox_control_color := THEME_CONF_REGISTER_LIST["nox_control_color"] 
	Gui, Color, %nox_bg_color%, %nox_control_color%
	if (THEME_CONF_REGISTER_LIST["nox_border_shadow_type"] == "classic_shadow_type")
		ShadowBorder(hMyGUI)
	else
		FrameShadow(hMyGUI)

	Gui, Font, s22, Segoe UI
	; Gui, Font, s10, Segoe UI
	; Gui, Add, Edit, %gui_control_options% vGuiUserInput gHandleGuiUserInput
	gui_control_options := "xm w" . THEME_CONF_REGISTER_LIST["nox_width"] . " c" . THEME_CONF_REGISTER_LIST["nox_text_color"] . " -E0x200"
	; DebugPrintVal(gui_control_options)

	Gui, Add, Edit, %gui_control_options% vGuiUserInput, %last_search_str%
	; Gui, Add, Edit, %gui_control_options% vGuiUserInput, %curr_select_text%
	; Gui, Add, Edit, xm w620 ccBlack -E0x200 vGuiUserInput, %last_search_str%

	Gui, Add, Button, x-10 y-10 w1 h1 +default gHandleGuiUserInput ; hidden button

	xMidScrn :=  A_ScreenWidth / 2
	CoordMode, Mouse, Screen
	MouseGetPos, MX
	If (MX > A_ScreenWidth)
		xMidScrn += A_ScreenWidth
	xMidScrn -= THEME_CONF_REGISTER_LIST["nox_width"] / 2
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
		; WebSearch(Clipboard)
		gui_destroy()
	}
	; else if SubStr(GuiUserInput, 1, 1) = A_Space
	; ; else if SubStr(GuiUserInput, 0, 1) = A_Space
	; {
	; 	WebSearch(GuiUserInput)
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
	; 		WebSearch(GuiUserInput)
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
		; else 
		; if trim_gui_user_input = rd ; Reload this script
		; {
		; 	gui_destroy() ; removes the GUI even when the reload fails
		; 	Reload
		; }
		; else if trim_gui_user_input = dir ; Open the directory for this script
		; {
		; 	gui_destroy()
		; 	; Run, %A_ScriptDir%  ; 用这种方式会把nox文件夹之前的文件夹里的exe执行..头疼..所以改用下面这行代码来写
		; 	Run, explorer %A_ScriptDir%
		; }
		; ; else if trim_gui_user_input = conf ; Edit user_conf
		; ; {
		; ; 	gui_destroy()
		; ; 	; run, notepad.exe "%A_ScriptDir%\user_conf.ahk"
		; ; 	param = %A_ScriptDir%\conf\user_conf.ahk
		; ; 	Run_AsUser("notepad.exe", param)
		; ; }
		; else if trim_gui_user_input = up ; update nox
		; {
		; 	MsgBox, 4,, Would you like to update nox?
		; 	IfMsgBox Yes
		; 	{
		; 		gui_destroy()
		; 		; Gosub gui_spawn
		; 		UpdateNox(0)
		; 	}
		; }
		; ; else if trim_gui_user_input = limit ; turn on/off limit mode
		; ; {
		; ; 	msg_str := "Would you like to turn " . (limit_mode ? "off" : "on") . " limit mode?"
		; ; 	MsgBox, 4,, %msg_str%
		; ; 	IfMsgBox Yes
		; ; 	{
		; ; 		gui_destroy()
		; ; 		limit_mode := limit_mode ? 0 : 1
		; ; 		if limit_mode {
		; ; 			if THEME_CONF_REGISTER_LIST["enable_hot_corners"]
		; ; 				SetTimer, LimitModeWhenFullScreen, Off
		; ; 			MsgBox, Double Shift is disabled in limit mode`, you can CapsLock+X to open nox input box.
		; ; 		} else {
		; ; 			if THEME_CONF_REGISTER_LIST["enable_hot_corners"]
		; ; 				SetTimer, LimitModeWhenFullScreen, 888
		; ; 		}
		; ; 	}
		; ; }
		; else if trim_gui_user_input = wau ; turn on/off disable win10 auto update
		; {
		; 	msg_str := "Would you like to turn " . (THEME_CONF_REGISTER_LIST["disable_win10_auto_update"] ? "off" : "on") . " disable win10 auto update?"
		; 	MsgBox, 4,, %msg_str%
		; 	IfMsgBox Yes
		; 	{
		; 		gui_destroy()
		; 		THEME_CONF_REGISTER_LIST["disable_win10_auto_update"] := THEME_CONF_REGISTER_LIST["disable_win10_auto_update"] ? 0 : 1
		; 		if (THEME_CONF_REGISTER_LIST["disable_win10_auto_update"] == 0) {
		; 			SetTimer, DisableWin10AutoUpdate, off
		; 			run, cmd /c sc config wuauserv start= auto,,hide
		; 			run, cmd /c net start wuauserv,,hide
		; 		} else {
		; 			DisableWin10AutoUpdate()
		; 			SetTimer, DisableWin10AutoUpdate, 66666
		; 		}
		; 	}
		; }
		; else if trim_gui_user_input = xy ; set second monitor xy for detecting IsCorner()
		; {
		; 	Set2thMonitorXY()
		; 	gui_destroy()
		; }
		; else if trim_gui_user_input = nw ; start nox with windows
		; {
		; 	HandleStartingNoxWithWindows()
		; 	gui_destroy()
		; }
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
		; global CMD_REGISTER_LIST
		; if (CMD_REGISTER_LIST.HasKey(trim_gui_user_input))
		; {
		; 	run(CMD_REGISTER_LIST[trim_gui_user_input])
		; }
		;-------------------------------------------------------------------------------
		;;; custom command line ;;;
		;-------------------------------------------------------------------------------
		
		; if trim_gui_user_input = cmd ; open a command prompt window on the current explorer path 
		; {
		; 	gui_destroy()
		; 	IfWinActive, ahk_exe explorer.exe
		; 	{
		; 		Send, !d
		; 		SendInput, cmd.exe`n  ; 等同于下面这两句
		; 		; SendRaw, cmd
		; 		; Send, {Enter}
		; 	}
		; 	else
		; 	{
		; 		run cmd.exe
		; 	}
		; }
		global CMD_REGISTER_LIST
		if (CMD_REGISTER_LIST.HasKey(trim_gui_user_input) || SubStr(trim_gui_user_input, 1, 3) == "ev ")
		{
			; m("uio")
			gui_destroy()
			; p_cmd := CustomCommandLineMap["USE_CURRENT_DIRECTORY_PATH_CMDs"]
			; use_cur_path := 0
			; Loop % p_cmd.Length()
    		; 	if (p_cmd[A_Index] == trim_gui_user_input) {
			; 		use_cur_path := 1
			; 		Break
			; 	}

			word_array := StrSplit(trim_gui_user_input, A_Space, ,2)
			if (word_array[1] == "ev"){
				;;; everything search
				; Run_AsUser(CustomCommandLineMap["ev"]*)  ; 这一句没有`run, %everything_exe_path%`快
				everything_exe_path := CMD_REGISTER_LIST["ev"][1]
				run, %everything_exe_path%
				WinWaitActive, ahk_exe Everything.exe, , 2.222
				if ErrorLevel
					MsgBox,,, please install Everything and set its shortcut in user_conf.ahk
				else if (word_array[2]){
					
					pending_search_str := word_array[2]
					; last_search_str := GuiUserInput
					; Sleep, 88
					; SendRaw, %trim_gui_user_input%
					; Sleep, 222
					; SendRaw, %last_search_str%
					Send, {Blind}{Text}%pending_search_str%
				}
				return
			}

			; if (word_array[1] == "git" || word_array[1] == "cmd"){
			USE_CURRENT_DIRECTORY_PATH_CMDs := {"cmd" : "%UserProfile%\Desktop", "git" : "~/Desktop"}
			use_cur_path := USE_CURRENT_DIRECTORY_PATH_CMDs.HasKey(trim_gui_user_input)
			IfWinActive, ahk_exe explorer.exe ahk_class CabinetWClass  ; from file explorer
			{
				if (use_cur_path) {
					Send, !d
					final_cmd_str := StringJoin(" ", CMD_REGISTER_LIST[trim_gui_user_input]*) . "`n"
					SendInput, %final_cmd_str%  ; 类似于等同于下面这两句
					; SendRaw, cmd
					; Send, {Enter}
					return
				}
			}
			; }
			; is_on_desktop := 0
			; IfWinActive, ahk_exe explorer.exe ahk_class WorkerW  ; from desktop
			; {
			; 	is_on_desktop := 1
			; }
			; run(CMD_REGISTER_LIST[trim_gui_user_input])
			; DebugPrintVal(CMD_REGISTER_LIST[trim_gui_user_input][1])
			; DebugPrintVal(CMD_REGISTER_LIST[trim_gui_user_input][2])
			; m(CMD_REGISTER_LIST[trim_gui_user_input])
			run(CMD_REGISTER_LIST[trim_gui_user_input])
		; 	Run_AsUser(CMD_REGISTER_LIST[trim_gui_user_input]*)
			if (use_cur_path) {
				file_path_str := CMD_REGISTER_LIST[trim_gui_user_input][1]  ; just like: "C:\Program Files\Git\bin\bash.exe"
				; DebugPrintVal(file_path_str)
				RegExMatch(file_path_str, "([^<>\/\\|:""\*\?]+)\.\w+$", file_name)  ; file_name just like: "bash.exe""
				; DebugPrintVal(file_name)
				WinWaitActive, ahk_exe %file_name%,, 2222
				if !ErrorLevel {
					cd_user_desktop_cmd_input := "cd " . USE_CURRENT_DIRECTORY_PATH_CMDs[trim_gui_user_input] . "`n"
					SendInput, %cd_user_desktop_cmd_input%
				}
			}
			; }
		}
		; else if (CustomCommandLineMap.HasKey(trim_gui_user_input) || SubStr(trim_gui_user_input, 1, 3) == "ev ")
		; {
		; 	gui_destroy()
		; 	; p_cmd := CustomCommandLineMap["USE_CURRENT_DIRECTORY_PATH_CMDs"]
		; 	; use_cur_path := 0
		; 	; Loop % p_cmd.Length()
    	; 	; 	if (p_cmd[A_Index] == trim_gui_user_input) {
		; 	; 		use_cur_path := 1
		; 	; 		Break
		; 	; 	}

		; 	word_array := StrSplit(trim_gui_user_input, A_Space, ,2)
		; 	if (word_array[1] == "ev"){
		; 		;;; everything search
		; 		; Run_AsUser(CustomCommandLineMap["ev"]*)  ; 这一句没有`run, %everything_exe_path%`快
		; 		everything_exe_path := CustomCommandLineMap["ev"][1]
		; 		run, %everything_exe_path%
		; 		WinWaitActive, ahk_exe Everything.exe, , 2.222
		; 		if ErrorLevel
		; 			MsgBox,,, please install Everything and set its shortcut in user_conf.ahk
		; 		else if (word_array[2]){
					
		; 			pending_search_str := word_array[2]
		; 			; last_search_str := GuiUserInput
		; 			; Sleep, 88
		; 			; SendRaw, %trim_gui_user_input%
		; 			; Sleep, 222
		; 			; SendRaw, %last_search_str%
		; 			Send, {Blind}{Text}%pending_search_str%
		; 		}
		; 		return
		; 	}

		; 	use_cur_path := CustomCommandLineMap["USE_CURRENT_DIRECTORY_PATH_CMDs"].HasKey(trim_gui_user_input)
		; 	IfWinActive, ahk_exe explorer.exe ahk_class CabinetWClass  ; from file explorer
		; 	{
		; 		if (use_cur_path) {
		; 			Send, !d
		; 			final_cmd_str := StringJoin(" ", CustomCommandLineMap[trim_gui_user_input]*) . "`n"
		; 			SendInput, %final_cmd_str%  ; 类似于等同于下面这两句
		; 			; SendRaw, cmd
		; 			; Send, {Enter}
		; 			return
		; 		}
		; 	}
		; 	; is_on_desktop := 0
		; 	; IfWinActive, ahk_exe explorer.exe ahk_class WorkerW  ; from desktop
		; 	; {
		; 	; 	is_on_desktop := 1
		; 	; }
		; 	Run_AsUser(CustomCommandLineMap[trim_gui_user_input]*)
		; 	if (use_cur_path) {
		; 		file_path_str := CustomCommandLineMap[trim_gui_user_input][1]  ; just like: "C:\Program Files\Git\bin\bash.exe"
		; 		; DebugPrintVal(file_path_str)
		; 		RegExMatch(file_path_str, "([^<>\/\\|:""\*\?]+)\.\w+$", file_name)  ; file_name just like: "bash.exe""
		; 		; DebugPrintVal(file_name)
		; 		WinWaitActive, ahk_exe %file_name%,, 2222
		; 		if !ErrorLevel {
		; 			cd_user_desktop_cmd_input := "cd " . CustomCommandLineMap["USE_CURRENT_DIRECTORY_PATH_CMDs"][trim_gui_user_input] . "`n"
		; 			SendInput, %cd_user_desktop_cmd_input%
		; 		}
		; 	}
		; }
		else
		{
			gui_destroy()
			word_array := StrSplit(trim_gui_user_input, A_Space, ,2)

			if WEB_SEARCH_REGISTER_LIST.HasKey(word_array[1]){
				WebSearch(word_array[2], word_array[1])
			}
			else {
				WebSearch(GuiUserInput)
			}
		}
		; else
		; {
		; 	gui_destroy()
		; 	word_array := StrSplit(trim_gui_user_input, A_Space, ,2)
		; 	if WebSearchUrlMap.HasKey(word_array[1]){
		; 		WebSearch(word_array[2], word_array[1])
		; 	}
		; 	else {
		; 		WebSearch(GuiUserInput)
		; 	}
		; }
	}

	return
