; ; Note: Save with encoding UTF-8 with BOM if possible.
; ; Notepad will save UTF-8 files with BOM automatically (even though it does not say so).
; ; Some editors however save without BOM, and then special characters look messed up in the AHK GUI.

global limit_mode := 0
global old_limit_mode := limit_mode

global cur_selected_text := ""

global fake_lb_down := 0

global CornerEdgeOffset := 10  ; adjust tolerance value (pixels to corner) if desired	

global trim_gui_user_input = ""
global last_search_str = ""

global second_monitor_min_x := 0
global second_monitor_min_y := 0
global second_monitor_max_x := 0
global second_monitor_max_y := 0

global should_not_ignore_original_action := 0
global should_ignore_original_action := 1


; 记录快捷键与对应操作
HOTKEY_REGISTER_LIST := {}

; 记录command与对应操作
CMD_REGISTER_LIST := {}

; 记录web-search与对应操作
WEB_SEARCH_REGISTER_LIST := {}

; 记录additional-features与对应操作
ADDITIONAL_FEATURES_REGISTER_LIST := {}

; 记录theme与对应操作
THEME_CONF_REGISTER_LIST := {}



; modified from jackieku's code (http://www.autohotkey.com/forum/post-310959.html#310959)
UriEncode(Uri, Enc = "UTF-8")
{
	StrPutVar(Uri, Var, Enc)
	f := A_FormatInteger
	SetFormat, IntegerFast, H
	Loop
	{
		Code := NumGet(Var, A_Index - 1, "UChar")
		If (!Code)
			Break
		If (Code >= 0x30 && Code <= 0x39 ; 0-9
			|| Code >= 0x41 && Code <= 0x5A ; A-Z
			|| Code >= 0x61 && Code <= 0x7A) ; a-z
			Res .= Chr(Code)
		Else
			Res .= "%" . SubStr(Code + 0x100, -1)
	}
	SetFormat, IntegerFast, %f%
	Return, Res
}

UriDecode(Uri, Enc = "UTF-8")
{
	Pos := 1
	Loop
	{
		Pos := RegExMatch(Uri, "i)(?:%[\da-f]{2})+", Code, Pos++)
		If (Pos = 0)
			Break
		VarSetCapacity(Var, StrLen(Code) // 3, 0)
		StringTrimLeft, Code, Code, 1
		Loop, Parse, Code, `%
			NumPut("0x" . A_LoopField, Var, A_Index - 1, "UChar")
		StringReplace, Uri, Uri, `%%Code%, % StrGet(&Var, Enc), All
	}
	Return, Uri
}

StrPutVar(Str, ByRef Var, Enc = "")
{
	Len := StrPut(Str, Enc) * (Enc = "UTF-16" || Enc = "CP1200" ? 2 : 1)
	VarSetCapacity(Var, Len, 0)
	Return, StrPut(Str, &Var, Enc)
}


ToolTipWithTimer(msg, delay_for_remove=600)
{
	ToolTip, %msg%
	SetTimer, RemoveToolTip, -%delay_for_remove%
	return

	RemoveToolTip:
		ToolTip
		return
}


ClickUpIfLbDown()
{
	if fake_lb_down
	{
		fake_lb_down = 0
		Click Up
		; ToolTipWithTimer("simulate click UP.", 1111)
	}
}


; PasteCompatibleWithAutoSelectionCopy() {
;     if (enable_auto_selection_copy)
;         Send, #v
;     else
;         Send, ^v
; }


Run_AsUser(prms*) {
    ComObjCreate("Shell.Application")
    .Windows.FindWindowSW(0, 0, 0x08, 0, 0x01)  
    .Document.Application.ShellExecute(prms*) 
}


GetCurSelectedText() {
	clipboardOld := ClipboardAll            ; backup clipboard
	Send, ^c
	Sleep, 66                             ; copy selected text to clipboard
	if (Clipboard != clipboardOld) {
		cur_selected_text := Clipboard                ; store selected text
		Clipboard := clipboardOld   ; Restore the original clipboard. Note the use of Clipboard (not ClipboardAll).
		clipboardOld := ""   ; Free the memory in case the clipboard was very large.
	}
	return cur_selected_text
}


/*! TheGood
    Checks if a window is in fullscreen mode.
    ______________________________________________________________________________________________________________
    sWinTitle       - WinTitle of the window to check. Same syntax as the WinTitle parameter of, e.g., WinExist().
    bRefreshRes     - Forces a refresh of monitor data (necessary if resolution has changed)
    Return value    o If window is fullscreen, returns the index of the monitor on which the window is fullscreen.
                    o If window is not fullscreen, returns False.
    ErrorLevel      - Sets ErrorLevel to True if no window could match sWinTitle
    
        Based on the information found at http://support.microsoft.com/kb/179363/ which discusses under what
    circumstances does a program cover the taskbar. Even if the window passed to IsFullscreen is not the
    foreground application, IsFullscreen will check if, were it the foreground, it would cover the taskbar.
*/
IsFullscreen(sWinTitle = "A", bRefreshRes = False) {
    Static
    Local iWinX, iWinY, iWinW, iWinH, iCltX, iCltY, iCltW, iCltH, iMidX, iMidY, iMonitor, c, D, iBestD
    
    ErrorLevel := False
    
    If bRefreshRes Or Not Mon0 {
        SysGet, Mon0, MonitorCount
        SysGet, iPrimaryMon, MonitorPrimary
        Loop %Mon0% { ;Loop through each monitor
            SysGet, Mon%A_Index%, Monitor, %A_Index%
            Mon%A_Index%MidX := Mon%A_Index%Left + Ceil((Mon%A_Index%Right - Mon%A_Index%Left) / 2)
            Mon%A_Index%MidY := Mon%A_Index%Top + Ceil((Mon%A_Index%Top - Mon%A_Index%Bottom) / 2)
        }
    }
    
    ;Get the active window's dimension
    hWin := WinExist(sWinTitle)
    If Not hWin {
        ErrorLevel := True
        Return False
    }
    
    ;Make sure it's not desktop
    WinGetClass, c, ahk_id %hWin%
    If (hWin = DllCall("GetDesktopWindow") Or (c = "Progman") Or (c = "WorkerW"))
        Return False
    
    ;Get the window and client area, and style
    VarSetCapacity(iWinRect, 16), VarSetCapacity(iCltRect, 16)
    DllCall("GetWindowRect", UInt, hWin, UInt, &iWinRect)
    DllCall("GetClientRect", UInt, hWin, UInt, &iCltRect)
    WinGet, iStyle, Style, ahk_id %hWin%
    
    ;Extract coords and sizes
    iWinX := NumGet(iWinRect, 0), iWinY := NumGet(iWinRect, 4)
    iWinW := NumGet(iWinRect, 8) - NumGet(iWinRect, 0) ;Bottom-right coordinates are exclusive
    iWinH := NumGet(iWinRect, 12) - NumGet(iWinRect, 4) ;Bottom-right coordinates are exclusive
    iCltX := 0, iCltY := 0 ;Client upper-left always (0,0)
    iCltW := NumGet(iCltRect, 8), iCltH := NumGet(iCltRect, 12)
    
    ;Check in which monitor it lies
    iMidX := iWinX + Ceil(iWinW / 2)
    iMidY := iWinY + Ceil(iWinH / 2)
    
	;Loop through every monitor and calculate the distance to each monitor
	iBestD := 0xFFFFFFFF
    Loop % Mon0 {
		D := Sqrt((iMidX - Mon%A_Index%MidX)**2 + (iMidY - Mon%A_Index%MidY)**2)
		If (D < iBestD) {
			iBestD := D
			iMonitor := A_Index
		}
	}
    
    ;Check if the client area covers the whole screen
    bCovers := (iCltX <= Mon%iMonitor%Left) And (iCltY <= Mon%iMonitor%Top) And (iCltW >= Mon%iMonitor%Right - Mon%iMonitor%Left) And (iCltH >= Mon%iMonitor%Bottom - Mon%iMonitor%Top)
    If bCovers
        Return True
    
    ;Check if the window area covers the whole screen and styles
    bCovers := (iWinX <= Mon%iMonitor%Left) And (iWinY <= Mon%iMonitor%Top) And (iWinW >= Mon%iMonitor%Right - Mon%iMonitor%Left) And (iWinH >= Mon%iMonitor%Bottom - Mon%iMonitor%Top)
    If bCovers { ;WS_THICKFRAME or WS_CAPTION
        bCovers := bCovers And (Not (iStyle & 0x00040000) Or Not (iStyle & 0x00C00000))
        Return bCovers ? iMonitor : False
    } Else Return False
}


LimitModeWhenFullScreen() {
	limit_mode := IsFullscreen() ? 1 : 0
	if (old_limit_mode = 0 and limit_mode = 1) or (old_limit_mode = 1 and limit_mode = 0)
	{
		ToolTipWithTimer("limit mode is " . (limit_mode ? "on. NOTICE: corner triggers is disabled." : "off"), 1111)
		old_limit_mode := limit_mode
	}
}


MaximizeWindow(timeout=2222, exe_name="") {
	if !exe_name
	{
		Sleep, timeout
		WinGet,S,MinMax,A
		if S=0
			WinMaximize, A
	}
	else
	{
		WinWaitActive, ahk_exe %exe_name%, , %timeout%
		if ErrorLevel
			ToolTipWithTimer("WinWaitActive " . %exe_name% . " timed out.")
		else
			WinMaximize
	}
}


IsStandardRawUrl(user_input){
	http_str := "http://"
	https_str := "https://"
	return InStr(user_input, http_str) or InStr(user_input, https_str)
}


IsRawUrl(user_input){
	if Instr(user_input, " ")
		return 0
	raw_url_str_arr := ["192.168", "http://", "https://", ".com", ".net", ".cn", "www.", ".io", ".org", ".cc", ".tk", ".me", ".ru", ".xyz", ".tv"]
	Loop % raw_url_str_arr.Length()
		if InStr(user_input, raw_url_str_arr[A_Index]) {
			return 1
		}
	return 0
}

DisableWin10AutoUpdate(){
	; run, cmd /c sc delete wuauserv,,hide
	run, cmd /c sc config wuauserv start= disabled,,hide
	run, cmd /c net stop wuauserv,,hide
	run, cmd /c sc config bits start= disabled,,hide
	run, cmd /c net stop bits,,hide
	run, cmd /c sc config dosvc start= disabled,,hide
	run, cmd /c net stop dosvc,,hide
}


DebugPrintVal(val) {
	MsgBox,,, %val%
}


Set2thMonitorXY() {
	if (ADDITIONAL_FEATURES_REGISTER_LIST["enable_hot_corners"]){
		SetTimer, HotCorners, Off
	}
	CoordMode, Mouse, Screen		; Coordinate mode - coords will be passed to mouse related functions, with coords relative to entire screen 
	msg_str := "Please move mouse to the second monitor left-bottom corner, press enter when u are ready."
	MsgBox,,, %msg_str%
	MouseGetPos, lbX, lbY

	second_monitor_min_x := lbX
	second_monitor_max_y := lbY	
	; DebugPrintVal(second_monitor_min_x)
	; DebugPrintVal(second_monitor_max_y)

	msg_str := "Please move mouse to the second monitor right-top corner, press enter when u are ready."
	MsgBox,,, %msg_str%
	MouseGetPos, rtX, rtY 	
	
	second_monitor_min_y := rtY	
	second_monitor_max_x := rtX
	; DebugPrintVal(second_monitor_min_y)
	; DebugPrintVal(second_monitor_max_x)

	SaveMonitorXyConfToFile()

	; MsgBox,,, 2th monitor resolution config string has already copy to your Clipboard, you can paste it in user_conf.ahk if you want to.
	if (ADDITIONAL_FEATURES_REGISTER_LIST["enable_hot_corners"]){
		SetTimer, HotCorners, %hot_corners_detect_interval%
	}
}


; ; run single command and retrieve their output, but cannot hide window
; RunWaitOne(command) {
;     ; WshShell object: http://msdn.microsoft.com/en-us/library/aew9yb99
;     shell := ComObjCreate("WScript.Shell")
;     ; Execute a single command via cmd.exe
;     exec := shell.Exec(ComSpec " /C " command)
;     ; Read and return the command's output
;     return exec.StdOut.ReadAll()
; }


; run multiple commands in one go and retrieve their output, but cannot hide window
; for example: 
; 	MsgBox % RunWaitMany("
; 	(
; 	echo Put your commands here,
; 	echo each one will be run,
; 	echo and you'll get the output.
; 	)")
RunWaitMany(commands) {
    shell := ComObjCreate("WScript.Shell")
    ; Open cmd.exe with echoing of commands disabled
    exec := shell.Exec(ComSpec " /Q /K echo off")
    ; Send the commands to execute, separated by newline
    exec.StdIn.WriteLine(commands "`nexit")  ; Always exit at the end!
    ; Read and return the output of all commands
    return exec.StdOut.ReadAll()
}


; ; run single command and retrieve their output
RunWaitOne(command, hide_window) {
	; Get a temporary file path
	tempFile := A_Temp "\" DllCall("GetCurrentProcessId") "_nox_temp.txt"                           ; "
	; Run the console program hidden, redirecting its output to
	; the temp. file (with a program other than powershell.exe or cmd.exe,
	; prepend %ComSpec% /c; use 2> to redirect error output), and wait for it to exit.
	if hide_window
		RunWait, cmd.exe /c %command% > %tempFile%,, hide
	else
		RunWait, cmd.exe /c %command% > %tempFile%
	; Read the temp file into a variable and then delete it.
	FileRead, content, %tempFile%
	FileDelete, %tempFile%
	return content
}


UpdateNoxImpl(from_launch) {
	; ToolTipWithTimer("nox background updating, please wait...", 2222)
	; RunWait, cmd.exe /c git pull origin master,,hide
	run_result := RunWaitOne("git pull origin master", from_launch)
	; if (InStr(run_result, "Already up to date")) {
	if (RegExMatch(run_result, "Already.*up.*to.*date")) {
		if from_launch
			return
		MsgBox,,, nox is already up to date. , 6
	}
	else if (!run_result || Instr(run_result, "FATAL:") || Instr(run_result, "fatal:") || Instr(run_result, "error:")){
		msg_str := "nox update failed, " . (run_result ? "this is the error log: " . run_result : "please `git pull` to check.")
		MsgBox,,, %msg_str%
	}
	else {
		; MsgBox,,, nox update finished. , 6
		msg_str := "nox update finished, would you like to see update log?"
		MsgBox, 4,, %msg_str%, 6
		IfMsgBox Yes
			Run	"https://github.com/no5ix/nox#update-log"
		Reload
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


WebSearch(user_input, search_key="") {
	global WEB_SEARCH_REGISTER_LIST
	if (user_input == "" && search_key == "")
		return
	; 当只填了 url 而没填 search_key 的时候
	if (IsRawUrl(user_input) && search_key == "") {
		if not IsStandardRawUrl(user_input)
			user_input := StringJoin("", ["http://", user_input]*)
		Run %user_input%
		return
	}
	if (search_key == "")
		search_key := "default"

	; search_flag_index = 1
	; search_flag := WEB_SEARCH_REGISTER_LIST[search_key][search_flag_index]
	search_url := WEB_SEARCH_REGISTER_LIST[search_key]
	if (search_url.Length() == 1) {
		search_url := search_url[1]
	}
	if (user_input == "") {	
		if !InStr(search_url, "REPLACEME") {
		; if (search_flag = "URL") {
			Run %search_url%
			return
		} 
		; domain_url just like: "https://www.google.com"
		; 建议到 https://c.runoob.com/front-end/854 去测试这个正则
		RegExMatch(search_url, "((\w)+://)?(\w+(-)*(\.)?)+(:(\d)+)?", domain_url)
		if not IsStandardRawUrl(domain_url)
			domain_url := StringJoin("", ["http://", domain_url]*)
		Run %domain_url%
		return
		; DebugPrintVal(pending_search_str)
		; return
		; pending_search_str := Clipboard
		; if StrLen(pending_search_str) >= 88 {
		; 	ToolTipWithTimer("ClipBoard string is too long. Please input some short pending search string.", 2222)
		; 	gui_destroy()
		; 	return
		; }
	}

	DebugPrintVal(search_key)
	
	if (search_key = "default") {
		for _index, _elem in WEB_SEARCH_REGISTER_LIST[search_key] {
			; if (_index != search_flag_index) {
				WebSearch(user_input, _elem)
				Sleep, 666
			; }
		}
		return
	}

	safe_query := UriEncode(Trim(user_input))
	StringReplace, search_final_url, search_url, REPLACEME, %safe_query%
	if not IsStandardRawUrl(search_final_url)
		search_final_url := StringJoin("", ["http://", search_final_url]*)
	Run, %search_final_url%
}

; WebSearch(user_input, search_key="") {
; 	if (user_input == "" && search_key == "")
; 		return

; 	; 当只填了 url 而没填 search_key 的时候
; 	if (IsRawUrl(user_input) && search_key == "") {
; 		if not IsStandardRawUrl(user_input)
; 			user_input := StringJoin("", ["http://", user_input]*)
; 		Run %user_input%
; 		return
; 	}
	
; 	if (search_key == "")
; 		search_key := "default"

; 	search_flag_index = 1
; 	search_flag := WebSearchUrlMap[search_key][search_flag_index]
; 	search_url := WebSearchUrlMap[search_key][2]
; 	if (user_input == "") {	
; 		if !InStr(search_url, "REPLACEME") {
; 		; if (search_flag = "URL") {
; 			Run %search_url%
; 			return
; 		} 
; 		; domain_url just like: "https://www.google.com"
; 		; 建议到 https://c.runoob.com/front-end/854 去测试这个正则
; 		RegExMatch(search_url, "((\w)+://)?(\w+(-)*(\.)?)+(:(\d)+)?", domain_url)
; 		if not IsStandardRawUrl(domain_url)
; 			domain_url := StringJoin("", ["http://", domain_url]*)
; 		Run %domain_url%
; 		return
; 		; DebugPrintVal(pending_search_str)
; 		; return
; 		; pending_search_str := Clipboard
; 		; if StrLen(pending_search_str) >= 88 {
; 		; 	ToolTipWithTimer("ClipBoard string is too long. Please input some short pending search string.", 2222)
; 		; 	gui_destroy()
; 		; 	return
; 		; }
; 	}
	
; 	if (search_flag = "MULTI") {
; 		for _index, _elem in WebSearchUrlMap[search_key] {
; 			if (_index != search_flag_index) {
; 				WebSearch(user_input, _elem)
; 				Sleep, 666
; 			}
; 		}
; 		return
; 	}

; 	safe_query := UriEncode(Trim(user_input))
; 	StringReplace, search_final_url, search_url, REPLACEME, %safe_query%
; 	if not IsStandardRawUrl(search_final_url)
; 		search_final_url := StringJoin("", ["http://", search_final_url]*)
; 	Run, %search_final_url%
; }

; Which can be used like this:
; Code: Select all - Toggle Line numbers

; MsgBox % Join("`n", "one", "two", "three") 
; substrings := ["one", "two", "three"]
; MsgBox % Join("-", substrings*)
StringJoin(sep, params*) {
    for index,param in params
        str .= sep . param
    return SubStr(str, StrLen(sep)+1)
}


IsMouseActiveWindowAtSameMonitor() {
	MouseGetPos, Mouse_x, Mouse_y 							; Function MouseGetPos retrieves the current position of the mouse cursor
	WinGetPos, cur_active_window_X, cur_active_window_Y,,, A
	; MsgBox, The Mouse_ is at %Mouse_x%`,%Mouse_y%
	; MsgBox, The active window is at %cur_active_window_X%`,%cur_active_window_Y%
	active_window_x_limit := second_monitor_min_x - 8  ; 经测试, 实际上全屏后也总是会减8
	; MsgBox, active_window_x_limit is at %active_window_x_limit%`
	if (second_monitor_min_x != 0) && ((Mouse_x >= second_monitor_min_x && cur_active_window_X < active_window_x_limit) || (Mouse_x < second_monitor_min_x && cur_active_window_X >= active_window_x_limit)) { 
		return 0
	}
	return 1
}

