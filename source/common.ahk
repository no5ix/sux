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


HandleMouseOnEdges(from) {
	if (enable_hot_edges = 0){
		return [should_not_ignore_original_action, "Notice: conf.enable_hot_edges is 0, so edge triggers are disabled."]
	}
	if (limit_mode){
		return [should_not_ignore_original_action, "Notice: limit mode is on, edge triggers are disabled."]
	}
	if IsCorner(){
		return [should_not_ignore_original_action, "Notice: Is Corner, so do NOTHING by edge triggers."]
	}
	CoordMode, Mouse, Screen		; Coordinate mode - coords will be passed to mouse related functions, with coords relative to entire screen 
	MouseGetPos, MouseX, MouseY 							; Function MouseGetPos retrieves the current position of the mouse cursor

	min_max_xy_arr := GetCurMonitorMinMaxXYArray(MouseX)
	cur_monitor_min_x := min_max_xy_arr[1]
	cur_monitor_max_x := min_max_xy_arr[2]
	cur_monitor_min_y := min_max_xy_arr[3]
	cur_monitor_max_y := min_max_xy_arr[4]

	cur_monitor_width := abs(cur_monitor_max_x-cur_monitor_min_x)
	cur_monitor_height := abs(cur_monitor_max_y-cur_monitor_min_y)

	Sleep, 66  ; 不加这个 `Sleep 66`, 可能某些快捷键跟触发快捷键有混杂冲突啥的, 比如可能会有win开始界面一闪而过
	if (MouseY < cur_monitor_min_y + CornerEdgeOffset)
	{
		if Abs(MouseX-cur_monitor_min_x) < (cur_monitor_width / 2)
			cur_should_go_on_doing := %HotEdgesTopHalfLeftTriggerFunc%(from)
		else
			cur_should_go_on_doing := %HotEdgesTopHalfRightTriggerFunc%(from)
	}
	else if (MouseY > cur_monitor_max_y - CornerEdgeOffset)
	{
		if Abs(MouseX-cur_monitor_min_x) < (cur_monitor_width / 2)
			cur_should_go_on_doing := %HotEdgesBottomHalfLeftTriggerFunc%(from)
		else
			cur_should_go_on_doing := %HotEdgesBottomHalfRightTriggerFunc%(from)
	}
	else if (MouseX < cur_monitor_min_x + CornerEdgeOffset)
	{
		if Abs(MouseY-cur_monitor_min_y) < (cur_monitor_height / 2)
			cur_should_go_on_doing := %HotEdgesLeftHalfUpTriggerFunc%(from)
		else
			cur_should_go_on_doing := %HotEdgesLeftHalfDownTriggerFunc%(from)
	}
	else if (MouseX > cur_monitor_max_x - CornerEdgeOffset)
	{
		if Abs(MouseY-cur_monitor_min_y) < (cur_monitor_height / 2)
			cur_should_go_on_doing := %HotEdgesRightHalfUpTriggerFunc%(from)
		else
			cur_should_go_on_doing := %HotEdgesRightHalfDownTriggerFunc%(from)
	}
   return [cur_should_go_on_doing, ""]
}


HotCorners() {				; Timer content 
	if (limit_mode){
		return
	}

	; if IsCorner("IsOnTop"){
	; 	LButtonDown := GetKeyState("LButton","P")
	; 	if LButtonDown
	; 		return
	; 	HotEdgesTopTrigger()
	; 	Loop 
	; 	{
	; 		if ! IsCorner("IsOnTop")
	; 			break ; exits loop when mouse is no longer in the corner
	; 	}
	; 	return
	; }

	if IsCorner("TopLeft")
	{
		%HotCornersTopLeftTriggerFunc%()
		Loop 
		{
			if ! IsCorner("TopLeft")
				break ; exits loop when mouse is no longer in the corner
		}
		return
	}
	else if IsCorner("TopRight")
	{	
		%HotCornersTopRightTriggerFunc%()
		Loop
		{
			if ! IsCorner("TopRight")
				break ; exits loop when mouse is no longer in the corner
		}	
		return
	}
	else if IsCorner("BottomLeft")
	{	
		%HotCornersBottomLeftTriggerFunc%()
		Loop
		{
			if ! IsCorner("BottomLeft")
				break ; exits loop when mouse is no longer in the corner
		}	
		return
	}
	else if IsCorner("BottomRight")
	{	
		%HotCornersBottomRightTriggerFunc%()
		Loop
		{
			if ! IsCorner("BottomRight")
				break ; exits loop when mouse is no longer in the corner
		}	
		return
	}
}


IsAt_left(MouseX, cur_monitor_min_x) {
	return MouseX < (cur_monitor_min_x + CornerEdgeOffset)
}
IsAt_right(MouseX, cur_monitor_max_x) {
	return MouseX > (cur_monitor_max_x - CornerEdgeOffset)  
}
IsAt_top(MouseY, cur_monitor_min_y) {
	return MouseY < (cur_monitor_min_y + CornerEdgeOffset)
}
IsAt_bottom(MouseY, cur_monitor_max_y) {
	return MouseY > (cur_monitor_max_y - CornerEdgeOffset)
}

GetCurMonitorMinMaxXYArray(cur_mouse_x) {
	if (cur_mouse_x < 0 or cur_mouse_x >= A_ScreenWidth) {
		if (second_monitor_min_x == 0) {  ; means have 2 same resolution monitor
			second_monitor_min_x := cur_mouse_x < 0 ? -A_ScreenWidth : A_ScreenWidth
			second_monitor_max_x := cur_mouse_x < 0 ? 0 : (2 * A_ScreenWidth)
			second_monitor_min_y := 0
			second_monitor_max_y := A_ScreenHeight
			SaveMonitorXyConfToFile()
		}
		cur_monitor_min_x := second_monitor_min_x	
		cur_monitor_min_y := second_monitor_min_y	
		cur_monitor_max_x := second_monitor_max_x	
		cur_monitor_max_y := second_monitor_max_y	
	} else {
		cur_monitor_min_x := 0	
		cur_monitor_min_y := 0	
		cur_monitor_max_x := A_ScreenWidth	
		cur_monitor_max_y := A_ScreenHeight
	}
	return [cur_monitor_min_x, cur_monitor_max_x, cur_monitor_min_y, cur_monitor_max_y]
}

; compatible with dual monitor
IsCorner(cornerID="")
{
	CoordMode, Mouse, Screen		; Coordinate mode - coords will be passed to mouse related functions, with coords relative to entire screen 
	MouseGetPos, MouseX, MouseY 							; Function MouseGetPos retrieves the current position of the mouse cursor

	min_max_xy_arr := GetCurMonitorMinMaxXYArray(MouseX)

	if (cornerID = "TopLeft"){
		return IsAt_left(MouseX, min_max_xy_arr[1]) and IsAt_top(MouseY, min_max_xy_arr[3]) 
	}
	else if (cornerID = "TopRight"){
		return IsAt_right(MouseX, min_max_xy_arr[2]) and IsAt_top(MouseY, min_max_xy_arr[3]) 
	}
	else if (cornerID = "BottomLeft"){
		return IsAt_left(MouseX, min_max_xy_arr[1]) and IsAt_bottom(MouseY, min_max_xy_arr[4])
	}
	else if  (cornerID = "BottomRight") {
		return IsAt_right(MouseX, min_max_xy_arr[2]) and IsAt_bottom(MouseY, min_max_xy_arr[4])
	}
	else{
		CornerTopLeft := IsAt_top(MouseY, min_max_xy_arr[3]) and IsAt_left(MouseX, min_max_xy_arr[1])	
		CornerTopRight := IsAt_top(MouseY, min_max_xy_arr[3]) and IsAt_right(MouseX, min_max_xy_arr[2])  
		CornerBottomLeft := IsAt_bottom(MouseY, min_max_xy_arr[4]) and IsAt_left(MouseX, min_max_xy_arr[1])
		CornerBottomRight := IsAt_bottom(MouseY, min_max_xy_arr[4]) and IsAt_right(MouseX, min_max_xy_arr[2]) 
		return (CornerTopLeft or CornerTopRight or CornerBottomLeft or CornerBottomRight)
	}
}

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

; FrameShadow(handle)
; {
;     DllCall("dwmapi.dll\DwmIsCompositionEnabled", "int*", DwmEnabled)
;     if !(DwmEnabled)
;         DllCall("user32.dll\SetClassLongPtr", "ptr", handle, "int", -26, "ptr", DllCall("user32.dll\GetClassLongPtr", "ptr", handle, "int", -26) | 0x20000)
;     else {
;         VarSetCapacity(MARGINS, 16, 0) && NumPut(1, NumPut(1, NumPut(1, NumPut(1, MARGINS, "int"), "int"), "int"), "int")
;         DllCall("dwmapi.dll\DwmSetWindowAttribute", "ptr", handle, "uint", 2, "ptr*", 2, "uint", 4)
;         DllCall("dwmapi.dll\DwmExtendFrameIntoClientArea", "ptr", handle, "ptr", &MARGINS)
;     }
; }

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

StrPutVar(Str, ByRef Var, Enc = "")
{
	Len := StrPut(Str, Enc) * (Enc = "UTF-16" || Enc = "CP1200" ? 2 : 1)
	VarSetCapacity(Var, Len, 0)
	Return, StrPut(Str, &Var, Enc)
}



; BS::MsgBox % "Morse press pattern " Morse()

; !z::
;    p := Morse()
;    If (p = "0")
;       MsgBox Short press
;    Else If (p = "00")
;       MsgBox Two short presses
;    Else If (p = "01")
;       MsgBox Short+Long press
;    Else
;       MsgBox Press pattern %p%
; Return
Morse(timeout = 200) { ;
   tout := timeout/1000
   key := RegExReplace(A_ThisHotKey,"[\*\~\$\#\+\!\^]")
   Loop {
      t := A_TickCount
      KeyWait %key%
      Pattern .= A_TickCount-t > timeout
      KeyWait %key%,DT%tout%
      If (ErrorLevel)
         Return Pattern
   }
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


MaxMinWindow() {
	; ; OutputVar is made blank if no matching window exists; otherwise, it is set to one of the following numbers:
	; ; -1: The window is minimized (WinRestore can unminimize it).
	; ; 1: The window is maximized (WinRestore can unmaximize it).
	; ; 0: The window is neither minimized nor maximized.
	WinGet,S,MinMax,A
	if S=0
		WinMaximize, A
	else if S=1
		WinMinimize, A
	; else if S=-1
	;     WinRestore, A
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
	raw_url_str_arr := ["http://", "https://", ".com", ".net", ".cn", "www.", ".io", ".org", ".cc", ".tk", ".me", ".ru", ".xyz", ".tv"]
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


HandleMonitorConfWhenFirstRun() {
	monitor_xy_conf_file := A_ScriptDir "\conf\monitor_xy_conf.ahk"
	if !FileExist(monitor_xy_conf_file) {
		FileAppend, 
		(
		;; This file is generated, please do not modify
		), %monitor_xy_conf_file%
	}

	if enable_hot_corners {
		SysGet, monitor_cnt, MonitorCount
		if (monitor_cnt > 2) {
			msg_str := "You have more than 2 monitors, hot corners will not perform exactly at none primary monitor, so we disable it."
			MsgBox,,, %msg_str%        
		}
		else {
			#IncludeAgain *i %A_ScriptDir%\conf\monitor_xy_conf.ahk
			if (monitor_cnt == 2 and second_monitor_min_x == 0) {
				msg_str := "You have 2 monitors, if they have two different resolution,"
					. " you can use cmd 'xy' to set the 2th monitor resolustion config. `n`n"
					. " Would you like to set it later(Yes) or now(No)?"
				MsgBox, 4,, %msg_str%
				IfMsgBox No
					Set2thMonitorXY()
			}
			SetTimer, HotCorners, %hot_corners_detect_interval%
		}
	}
}


SaveMonitorXyConfToFile() {
	monitor_xy_conf_str := "`;`; This file is generated, please do not modify`n`n"
			. "global second_monitor_min_x := " . second_monitor_min_x . " `n"
			. "global second_monitor_min_y := " . second_monitor_min_y . " `n"
			. "global second_monitor_max_x := " . second_monitor_max_x . " `n"
			. "global second_monitor_max_y := " . second_monitor_max_y

	monitor_xy_conf_file := A_ScriptDir "\conf\monitor_xy_conf.ahk"
	FileDelete %monitor_xy_conf_file%  ; In case previous run was terminated prematurely.
	FileAppend, %monitor_xy_conf_str%, %monitor_xy_conf_file%
	#IncludeAgain *i %A_ScriptDir%\conf\monitor_xy_conf.ahk
}


Set2thMonitorXY() {
	if (enable_hot_corners){
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
	if (enable_hot_corners){
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


UpdateNox(from_launch) {
	; ToolTipWithTimer("nox background updating, please wait...", 2222)
	; RunWait, cmd.exe /c git pull origin master,,hide
	run_result := RunWaitOne("git pull origin master", from_launch)
	if (InStr(run_result, "Already up to date")) {
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



; ---------------------------------------------------------------------o
; 					double click conf  
; ---------------------------------------------------------------------o

Default_DoubleClickShiftTrigger(){
	gui_spawn_func := "gui_spawn"  ; 这么写是为了让 common.ahk 和 gui.ahk 解耦, 独立开来, common 不应该依赖 gui
	%gui_spawn_func%()
}
Default_DoubleClickAltTrigger(){
	gui_spawn_func := "gui_spawn"  ; 这么写是为了让 common.ahk 和 gui.ahk 解耦, 独立开来, common 不应该依赖 gui
	%gui_spawn_func%()
}
Default_DoubleClickCtrlTrigger(){
}


; ---------------------------------------------------------------------o
;                       hot edge conf 
; ---------------------------------------------------------------------o

Default_HotEdgesTopHalfLeftTrigger(from){
	; if (from = "Ctrl+8") {
	; 	ToolTipWithTimer("Launching Music App ...", 1111)
	; 	run %music_app_path%
	; 	; Send, #e
	; 	; ToolTipWithTimer("Launching File Explorer ...", 1111)
	; 	; MaximizeWindow(1111, "Explorer.exe")

	; }
	return should_not_ignore_original_action
}
Default_HotEdgesTopHalfRightTrigger(from){
	if (from = "Ctrl+8") {						
		; Send, #e
		run "explorer.exe"
		ToolTipWithTimer("Launching File Explorer ...", 1111)
		MaximizeWindow(1111, "Explorer.exe")
		return should_ignore_original_action
	}					
	return should_not_ignore_original_action
}
Default_HotEdgesBottomHalfLeftTrigger(from){
	if (from = "Ctrl+8") {												
		Send, ^+{Esc}
		ToolTipWithTimer("Launching Task Manager ...", 1111)
		MaximizeWindow(1111, "taskmgr.exe")
		return should_ignore_original_action
	}					
	return should_not_ignore_original_action
}
Default_HotEdgesBottomHalfRightTrigger(from){
	; if (from = "Ctrl+8") {
	; 	; Send, #m				
	; 	; Send, #{Up}				
	; 	; Send, !{F4}

	; 	ToolTipWithTimer("Launching WeChat ...", 1111)
	; 	run %im_path%
	; 	; MaximizeWindow(1111, "WeChat.exe")
	; }					
	return should_not_ignore_original_action
}
Default_HotEdgesLeftHalfUpTrigger(from){
	if (from = "Ctrl+8") {		
		Send {LWin Down}
		Send, {Left}
		Sleep, 111
		Send {LWin Up}
		return should_ignore_original_action
	}					
	return should_not_ignore_original_action
}
Default_HotEdgesLeftHalfDownTrigger(from){
	if (from = "Ctrl+8") {
		Send, #{Tab}
		return should_ignore_original_action
	}					
	return should_not_ignore_original_action
}
Default_HotEdgesRightHalfUpTrigger(from){
	if (from = "Ctrl+8") {		
		Send {LWin Down}
		Send, {Right}
		Sleep, 111
		Send {LWin Up}
		return should_ignore_original_action
	}					
	return should_not_ignore_original_action
}
Default_HotEdgesRightHalfDownTrigger(from){
	if (from = "Ctrl+8") {
		Send, #a
		return should_ignore_original_action
	}					
	return should_not_ignore_original_action
}


; ---------------------------------------------------------------------o
; 					hot corners conf  
; ---------------------------------------------------------------------o

Default_HotCornersTopLeftTrigger(){
	Send {LControl Down}{LShift Down}
	Send, {Tab}
	Sleep, 111
	Send {LControl Up}{LShift Up}
}
Default_HotCornersTopRightTrigger(){
	Send {LControl Down}
	Send, {Tab}
	Sleep, 111
	Send {LControl Up}
}
Default_HotCornersBottomLeftTrigger(){
		Send, {LWin}
}
Default_HotCornersBottomRightTrigger(){
		Send, !{Tab}
}


IncludeUserConfIFExist() {
	user_conf_file := A_ScriptDir "\conf\user_conf.ahk"
	if !FileExist(user_conf_file) {
		FileAppend, 
 		(
; ; ; Note: Save with encoding UTF-8 with BOM if possible.
; ; ; Notepad will save UTF-8 files with BOM automatically (even though it does not say so).
; ; ; Some editors however save without BOM, and then special characters look messed up in the AHK GUI.

; ; ; git update-index --assume-unchanged <file>
; ; ; git update-index --no-assume-unchanged <file>
; ; ; git ls-files -v | grep '^h'.


; ; ---------------------------------------------------------------------o
; ; 					override default override color code definitions conf
; ; ---------------------------------------------------------------------o


; ; ---------------------------------------------------------------------o
; ; 					override default override theme conf
; ; ---------------------------------------------------------------------o

; ; ; ; dark theme
; ; global nox_width := 620
; ; global nox_text_color := cWhite
; ; global nox_margin_x := 0
; ; global nox_margin_y := 0
; ; global nox_bg_color := "424242"
; ; global nox_control_color := "616161"
; ; global nox_border_shadow_type := classic_shadow_type

; ; ; light theme
; global nox_width := 620
; global nox_text_color := cBlack
; global nox_margin_x := 0
; global nox_margin_y := 0
; global nox_bg_color := "ececec"
; global nox_control_color := "d9d9d9"
; global nox_border_shadow_type := modern_shadow_type


; ; ---------------------------------------------------------------------o
; ; 					override default override general conf
; ; ---------------------------------------------------------------------o


; ; ; visual studio code path(e.g. "C:\Users\xxxx\AppData\Local\Programs\Microsoft VS Code\Code.exe")
; ; ; if blank, leave a ugly cmd window after input cmd proj(open nox project with vscode).

; global disable_win10_auto_update := 1

; global auto_update_when_launch_nox := 1

; global enable_hot_edges := 1  ; when ctrl+8 on the edge (useful for touchpad user)

; ; global DoubleClickShiftTriggerFunc := ""
; ; global DoubleClickAltTriggerFunc := ""
; ; global DoubleClickCtrlTriggerFunc := ""
; global HotEdgesTopHalfLeftTriggerFunc := "User_HotEdgesTopHalfLeftTrigger"
; global HotEdgesTopHalfRightTriggerFunc := "User_HotEdgesTopHalfRightTrigger"
; global HotEdgesBottomHalfLeftTriggerFunc := "User_HotEdgesBottomHalfLeftTrigger"
; global HotEdgesBottomHalfRightTriggerFunc := "User_HotEdgesBottomHalfRightTrigger"
; global HotEdgesLeftHalfUpTriggerFunc := "User_HotEdgesLeftHalfUpTrigger"
; global HotEdgesLeftHalfDownTriggerFunc := "User_HotEdgesLeftHalfDownTrigger"
; global HotEdgesRightHalfUpTriggerFunc := "User_HotEdgesRightHalfUpTrigger"
; global HotEdgesRightHalfDownTriggerFunc := "User_HotEdgesRightHalfDownTrigger"
; ; global HotCornersTopLeftTriggerFunc := ""
; ; global HotCornersTopRightTriggerFunc := ""
; ; global HotCornersBottomLeftTriggerFunc := ""
; ; global HotCornersBottomRightTriggerFunc := ""


; ; global enable_hot_corners := 1  ; ; when cursor hover on the corner

; ; global limit_mode_when_full_screen := 1  ; if 1, turn off double shift/ctrl/alt & hot edges/corners when full screen
; ; global enable_auto_selection_copy := 0  ; should use with Win+V or CapsLock+Shift+F

; ; ; millisecond, the smaller the value, the faster you have to double-click
; ; global keyboard_double_click_timeout := 222
; ; global mouse_double_click_timeout := 666


; ; ---------------------------------------------------------------------o
; ; 					override default override replace str map conf  ( Capslock+Shift+U )
; ; ---------------------------------------------------------------------o


; ; ---------------------------------------------------------------------o
; ; 					override default override web search url conf
; ; ---------------------------------------------------------------------o

; ; special flags:
; ; - MULTI : use multi existing web search key
; ; - URL : raw url
; global WebSearchUrlMap := 
; (join web search url map
; {
; 	"search_input_key" : ["search_flag(MULTI for special use)", "extra_info (don't del this line)"] 

; 	,  "default" : ["MULTI", "gg", "bd"]
; 	,  "nox" : ["Nox", "https://github.com/no5ix/nox"]

; 	,  "gg" : ["Google", "https://www.google.com.hk/search?safe=off&site=&source=hp&q=REPLACEME&btnG=Search&oq=&gs_l="]
; 	,  "bi" : ["Bing", "https://www.bing.com/search?q=REPLACEME&qs=n&FORM=BESBTB&sp=-1&pq=REPLACEME&sc=8-8&sk=&cvid=278DBE315C2D48E0AFC1B7B88E5878F3&ensearch=1"]
; 	,  "yd" : ["Youdao", "http://www.youdao.com/w/REPLACEME"]
; 	,  "bd" : ["Baidu", "https://www.baidu.com/#ie=UTF-8&wd=REPLACEME"]
; 	,  "bb" : ["Bilibili", "search.bilibili.com/all?keyword=REPLACEME"]
; 	,  "jd" : ["JD", "https://search.jd.com/Search?keyword=REPLACEME&enc=utf-8"]
; 	,  "zh" : ["Zhihu", "https://www.zhihu.com/search?type=content&q=REPLACEME"]
; 	,  "gh" : ["GitHub", "https://github.com/search?q=REPLACEME"]
; 	,  "so" : ["StackOverflow", "https://stackoverflow.com/search?q=REPLACEME"]
; 	,  "yt" : ["Youtube", "https://www.youtube.com/results?search_query=REPLACEME"]
; 	,  "ph" : ["PornHub", "https://www.pornhub.com/video/search?search=REPLACEME"]
; 	,  "db" : ["Douban", "https://www.douban.com/search?q=REPLACEME"]
; 	,  "qm" : ["QiMai", "https://www.qimai.cn/search/index/country/cn/search/REPLACEME"]
; 	,  "yk" : ["YouKu", "https://so.youku.com/search_video/q_REPLACEME?searchfrom=1"]
; 	,  "lc" : ["LeetCode", "https://leetcode-cn.com/problemset/all/?search=REPLACEME"]

; 	,  "np" : ["noodle_plan", "https://hulinhong.com/2018/08/06/noodle_plan/"]
;	,  "an" : ["algo_newbie", "https://hulinhong.com/2018/10/23/algo_newbie/"]
;	,  "anl" : ["algo_newbie", "http://localhost:9009/2018/10/23/algo_newbie/"]
; 	,  "npl" : ["noodle_plan local", "http://localhost:9009/2018/08/06/noodle_plan/"]
; }
; )


; ; ---------------------------------------------------------------------o
; ; 					override custom command line conf  
; ; ---------------------------------------------------------------------o

; global CustomCommandLineMap := 
; (join custom command line map
; {
; 	"command_line_key" : "command_line_info (dont del this line)"

; 	,  "USE_CURRENT_DIRECTORY_PATH_CMDs": {"cmd" : "%UserProfile%\Desktop", "git" : "~/Desktop"}
; 	,  "cmd" : ["cmd.exe"]


;	,  "ev" : ["C:\Program Files\Everything\Everything.exe"]
; 	,  "git" : ["C:\Program Files\Git\bin\bash.exe", "--login"]
; 	,  "blog" : ["C:\Program Files\Microsoft VS Code\Code.exe", "C:\Users\b\Documents\github\hexo-theme-next-optimized"]
; 	,  "proj" : ["C:\Program Files\Microsoft VS Code\Code.exe", "C:\Users\b\Documents\github\nox"]
; 	,  "test.py" : ["C:\Program Files\Microsoft VS Code\Code.exe", "C:\Users\b\Desktop\test.py"]
; 	,  "test.go" : ["C:\Program Files\Microsoft VS Code\Code.exe", "C:\Users\b\Desktop\test.go"]
; 	,  "test.cpp" : ["C:\Program Files\Microsoft VS Code\Code.exe", "C:\Users\b\Desktop\test.cpp"]
; }
; )


; ; ---------------------------------------------------------------------o
; ; 					override default TriggerFunc conf
; ; ---------------------------------------------------------------------o

; ; User_EverythingShortCut() {
; ; 	; u can set your own Everything shortcut here, just like ` Send, ^!+e `
; ; }

; User_HotEdgesTopHalfLeftTrigger(from) {
; 	if (from = "Ctrl+8") {
; 		; ; Sets ErrorLevel to the Process ID (PID) if a matching process exists, or 0 otherwise.
; 		; Process, Exist, cloudmusic.exe
; 		; if !ErrorLevel
; 		; {
; 			ToolTipWithTimer("Launching Music App ...", 1111)
; 			run "C:\Program Files (x86)\Netease\CloudMusic\cloudmusic.exe"
; 		; }
; 		; else
; 		; {
; 		; 	Send, ^+!0
; 		; 	ToolTipWithTimer("Pause/Play music ...", 1111)
; 		; }
; 		return should_ignore_original_action
; 	}					
; 	return should_not_ignore_original_action
; }

; User_HotEdgesTopHalfRightTrigger(from) {
; 	if (from = "Ctrl+8") {						
; 		; Send, #e
; 		run "explorer.exe"
; 		ToolTipWithTimer("Launching File Explorer ...", 1111)
; 		MaximizeWindow(1111, "Explorer.exe")
; 		return should_ignore_original_action
; 	}					
; 	return should_not_ignore_original_action
; }

; User_HotEdgesBottomHalfRightTrigger(from) {
; 	if (from = "Ctrl+8") {
; 		; ToolTipWithTimer("Launching WeChat ...", 1111)
; 		; ; run "C:\Program Files (x86)\Tencent\WeChat\WeChat.exe"
; 		; Send, ^+!7
; 		; MaximizeWindow(1111, "WeChat.exe")
; 		Send, {F5}	
; 		ToolTipWithTimer(" Refresh tab ...", 1111)
; 		return should_ignore_original_action
; 	}					
; 	; else if (from = "MButton") {
; 	; 	Send, #d
; 	; 	return should_ignore_original_action
; 	; }					
; 	return should_not_ignore_original_action
; }

; User_HotEdgesBottomHalfLeftTrigger(from) {
; 	if (from = "Ctrl+8") {												
; 		; Send, ^+{Esc}
; 		; ToolTipWithTimer("Launching Task Manager ...", 1111)
; 		; MaximizeWindow(1111, "taskmgr.exe")
; 		Send, ^+t
; 		; Send, !{F4}
; 		ToolTipWithTimer("Reopen closed tap...", 1111)
; 		return should_ignore_original_action
; 	}					
; 	; else if (from = "MButton") {
; 	; 	Send, ^+t
; 	; 	return should_ignore_original_action
; 	; }
; 	return should_not_ignore_original_action
; }

; User_HotEdgesLeftHalfDownTrigger(from) {
; 	if (from = "Ctrl+8") {
; 	; 	Send, ^+!1
; 	; 	ToolTipWithTimer("Last Song ...", 1111)
; 	; 	return should_ignore_original_action
; 	; }					
; 	; else if (from = "MButton") {
; 		Send, #{Tab}
; 		return should_ignore_original_action
; 	}				
; 	return should_not_ignore_original_action
; }

; User_HotEdgesRightHalfDownTrigger(from) {
; 	if (from = "Ctrl+8") {
; 	; 	Send, ^+!2
; 	; 	ToolTipWithTimer("Next song ...", 1111)
; 	; 	return should_ignore_original_action
; 	; }	
; 	; else if (from = "MButton") {
; 		Send, #a
; 		return should_ignore_original_action
; 	}				
; 	return should_not_ignore_original_action
; }

; User_HotEdgesLeftHalfUpTrigger(from){
; 	if (from = "Ctrl+8") {		
; 	; 	WebSearch(GetCurSelectedText())
; 	; 	return should_ignore_original_action
; 	; }			
; 	; else if (from = "MButton") {
; 		Send {LWin Down}
; 		Send, {Left}
; 		Sleep, 111
; 		Send {LWin Up}
; 		return should_ignore_original_action
; 	}					
; 	return should_not_ignore_original_action
; }

; User_HotEdgesRightHalfUpTrigger(from){
; 	if (from = "Ctrl+8") {	
; 	; 	return should_ignore_original_action
; 	; }			
; 	; else if (from = "MButton") {
; 		Send {LWin Down}
; 		Send, {Right}
; 		Sleep, 111
; 		Send {LWin Up}
; 		return should_ignore_original_action
; 	}						
; 	return should_not_ignore_original_action
; }


		), %user_conf_file%
		
		SetTimer, ReloadForIncludingUserConf, -66
	}
	; else {
	; 	; #IncludeAgain *i %A_ScriptDir%\conf\user_conf.ahk
	; 	; SetTimer, IncludeUserConfIFExist, off
	; }
}


ReloadForIncludingUserConf() {
	user_conf_file := A_ScriptDir "\conf\user_conf.ahk"
	if FileExist(user_conf_file) {
		Reload
	}
}

StartNoxWithWindows() {
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


RunAsAdmin() {
	full_command_line := DllCall("GetCommandLine", "str")
	if not (A_IsAdmin or RegExMatch(full_command_line, " /restart(?!\S)"))
	{
		try
		{
			if A_IsCompiled
				Run *RunAs "%A_ScriptFullPath%" /restart
			else
				Run *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%"
		}
		ExitApp
	}
}


IsFirstTimeRunNox() {
	monitor_xy_conf_file := A_ScriptDir "\conf\monitor_xy_conf.ahk"
	return !FileExist(monitor_xy_conf_file)
}


gui_destroy() {
	; Hide GUI
	Gui, Destroy
}


WebSearch(user_input, search_key="") {
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

	search_flag_index = 1
	search_flag := WebSearchUrlMap[search_key][search_flag_index]
	search_url := WebSearchUrlMap[search_key][2]
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
	
	if (search_flag = "MULTI") {
		for _index, _elem in WebSearchUrlMap[search_key] {
			if (_index != search_flag_index) {
				WebSearch(user_input, _elem)
				Sleep, 666
			}
		}
		return
	}

	safe_query := UriEncode(Trim(user_input))
	StringReplace, search_final_url, search_url, REPLACEME, %safe_query%
	if not IsStandardRawUrl(search_final_url)
		search_final_url := StringJoin("", ["http://", search_final_url]*)
	Run, %search_final_url%
}

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