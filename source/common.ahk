; ; Note: Save with encoding UTF-8 with BOM if possible.
; ; Notepad will save UTF-8 files with BOM automatically (even though it does not say so).
; ; Some editors however save without BOM, and then special characters look messed up in the AHK GUI.

global limit_mode := 0
global old_limit_mode := limit_mode

global cur_selected_text := ""

global fake_lb_down := 0

global CornerEdgeOffset := 10  ; adjust tolerance value (pixels to corner) if desired	

global trim_p = ""
global last_search_str = ""

global second_monitor_min_x := 0
global second_monitor_min_y := 0
global second_monitor_max_x := 0
global second_monitor_max_y := 0



HandleMouseOnEdges(from) {
	IsOnEdge := 0
	if (enable_hot_edges = 0){
		ToolTipWithTimer("	conf.enable_hot_edges is 0, so edge triggers are disabled.", 2000)
		return IsOnEdge
	}
	if (limit_mode){
		ToolTipWithTimer("	limit mode is on, edge triggers are disabled.", 2000)
		return IsOnEdge
	}
	if IsCorner(){
		ToolTipWithTimer("	Is Corner, so do NOTHING by edge triggers.", 2000)
		return IsOnEdge
	}
	CoordMode, Mouse, Screen		; Coordinate mode - coords will be passed to mouse related functions, with coords relative to entire screen 
	MouseGetPos, MouseX, MouseY 							; Function MouseGetPos retrieves the current position of the mouse cursor

	min_max_xy_arr := GetCurMonitorMinMaxXYArray(MouseX)
	cur_monitor_min_x := min_max_xy_arr[1]
	cur_monitor_max_x := min_max_xy_arr[2]
	cur_monitor_min_y := min_max_xy_arr[3]
	cur_monitor_max_y := min_max_xy_arr[4]

	Sleep, 66  ; 不加这个 `Sleep 66`, 可能某些快捷键跟触发快捷键有混杂冲突啥的, 比如可能会有win开始界面一闪而过
	if (MouseY < cur_monitor_min_y + CornerEdgeOffset)
	{
		IsOnEdge = 1
		if mod(MouseX, cur_monitor_max_x) < (cur_monitor_max_x / 2)
			%HotEdgesTopHalfLeftTriggerFunc%(from)
		else
			%HotEdgesTopHalfRightTriggerFunc%(from)
	}
	else if (MouseY > cur_monitor_max_y - CornerEdgeOffset)
	{
		IsOnEdge = 1
		if mod(MouseX, cur_monitor_max_x) < (cur_monitor_max_x / 2)
			%HotEdgesBottomHalfLeftTriggerFunc%(from)
		else
			%HotEdgesBottomHalfRightTriggerFunc%(from)
	}
	else if (MouseX < cur_monitor_min_x + CornerEdgeOffset)
	{
		IsOnEdge = 1
		if mod(MouseY, cur_monitor_max_y) < (cur_monitor_max_y / 2)
			%HotEdgesLeftHalfUpTriggerFunc%(from)
		else
			%HotEdgesLeftHalfDownTriggerFunc%(from)
	}
	else if (MouseX > cur_monitor_max_x - CornerEdgeOffset)
	{
		IsOnEdge = 1
		if mod(MouseY, cur_monitor_max_y) < (cur_monitor_max_y/ 2)
			%HotEdgesRightHalfUpTriggerFunc%(from)
		else
			%HotEdgesRightHalfDownTriggerFunc%(from)
	}
   return IsOnEdge
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
	SetTimer, RemoveToolTip, %delay_for_remove%
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
		ToolTipWithTimer("simulate click UP.", 1111)
	}
}


PasteCompatibleWithAutoSelectionCopy() {
    if (enable_auto_selection_copy)
        Send, #v
    else
        Send, ^v
}


Run_AsUser(prms*) {
    ComObjCreate("Shell.Application")
    .Windows.FindWindowSW(0, 0, 0x08, 0, 0x01)  
    .Document.Application.ShellExecute(prms*) 
}


SaveCurSelectedText() {
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


WebSearch(user_input, search_key) {
	gui_destroy()
	last_search_str := user_input
	search_flag_index = 1
	search_flag := WebSearchUrlMap[search_key][search_flag_index]
	if (search_flag = "URL") {
		if IsRawUrl(user_input) {
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

	safe_query := UriEncode(Trim(last_search_str))
	search_url := WebSearchUrlMap[search_key][2]
	StringReplace, search_final_url, search_url, REPLACEME, %safe_query%
	RunWait, %search_final_url%
}


IsRawUrl(user_input){
	http_str := "http://"
	https_str := "https://"
	return InStr(user_input, http_str) or InStr(user_input, https_str)
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
	SetTimer, HotCorners, Off
	
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

	monitor_xy_conf_str := "`;`; This file is generated, please do not modify`n`n"
			. "global second_monitor_min_x := " . second_monitor_min_x . " `n"
			. "global second_monitor_min_y := " . second_monitor_min_y . " `n"
			. "global second_monitor_max_x := " . second_monitor_max_x . " `n"
			. "global second_monitor_max_y := " . second_monitor_max_y

	monitor_xy_conf_file := A_ScriptDir "\conf\monitor_xy_conf.ahk"
	FileDelete %monitor_xy_conf_file%  ; In case previous run was terminated prematurely.
	FileAppend, %monitor_xy_conf_str%, %monitor_xy_conf_file%
	#IncludeAgain *i %A_ScriptDir%\conf\monitor_xy_conf.ahk

	; MsgBox,,, 2th monitor resolution config string has already copy to your Clipboard, you can paste it in user_conf.ahk if you want to.
	gui_destroy()
	SetTimer, HotCorners, 66
}


UpdateNox() {
	RunWait, cmd.exe /c git pull origin master,,hide
	MsgBox,,, nox update finished. , 6
	Reload
}





; ---------------------------------------------------------------------o
; 					Everything shortCut conf  
; ---------------------------------------------------------------------o

Default_EverythingShortCut(){
	Send, ^!+e
}

; ---------------------------------------------------------------------o
; 					double click conf  
; ---------------------------------------------------------------------o

Default_DoubleClickShiftTrigger(){
	gui_spawn()
}
Default_DoubleClickAltTrigger(){
	Default_EverythingShortCut()
}
Default_DoubleClickCtrlTrigger(){
}


; ---------------------------------------------------------------------o
;                       hot edge conf 
; ---------------------------------------------------------------------o

Default_HotEdgesTopHalfLeftTrigger(from){
	if (from = "Ctrl+8") {
		ToolTipWithTimer("Launching Music App ...", 1111)
		run %music_app_path%
	}
}
Default_HotEdgesTopHalfRightTrigger(from){
	if (from = "Ctrl+8") {						
		Send, #e
		ToolTipWithTimer("Launching File Explorer ...", 1111)
		MaximizeWindow(1111, "Explorer.exe")
	}					
}
Default_HotEdgesBottomHalfLeftTrigger(from){
	if (from = "Ctrl+8") {												
		Send, ^+{Esc}
		ToolTipWithTimer("Launching Task Manager ...", 1111)
		MaximizeWindow(1111, "taskmgr.exe")
	}					
}
Default_HotEdgesBottomHalfRightTrigger(from){
	if (from = "Ctrl+8") {
		Send, #m				
	}					
}
Default_HotEdgesLeftHalfUpTrigger(from){
	if (from = "Ctrl+8") {		
		Send {LWin Down}
		Send, {Left}
		Sleep, 111
		Send {LWin Up}

	}			
}
Default_HotEdgesLeftHalfDownTrigger(from){
	if (from = "Ctrl+8") {
		Send, #{Tab}
	}			
}
Default_HotEdgesRightHalfUpTrigger(from){
	if (from = "Ctrl+8") {		
		Send {LWin Down}
		Send, {Right}
		Sleep, 111
		Send {LWin Up}
	}			
}
Default_HotEdgesRightHalfDownTrigger(from){
	if (from = "Ctrl+8") {
		Send, #a
	}			
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
; ; Note: Save with encoding UTF-8 with BOM if possible.
; ; Notepad will save UTF-8 files with BOM automatically (even though it does not say so).
; ; Some editors however save without BOM, and then special characters look messed up in the AHK GUI.

; ; git update-index --assume-unchanged <file>
; ; git update-index --no-assume-unchanged <file>
; ; git ls-files -v | grep '^h'. 


; ---------------------------------------------------------------------o
; 					override default override color code definitions conf
; ---------------------------------------------------------------------o


; ---------------------------------------------------------------------o
; 					override default override theme conf
; ---------------------------------------------------------------------o

; ; ; dark theme
; global nox_width := 620
; global nox_text_color := cWhite
; global nox_margin_x := 0
; global nox_margin_y := 0
; global nox_bg_color := "424242"
; global nox_control_color := "616161"
; global nox_border_shadow_type := classic_shadow_type

; ; ; light theme 
; global nox_width := 620
; global nox_text_color := cBlack
; global nox_margin_x := 0
; global nox_margin_y := 0
; global nox_bg_color := "ececec"
; global nox_control_color := "d9d9d9"
; global nox_border_shadow_type := modern_shadow_type


; ---------------------------------------------------------------------o
; 					override default override general conf 
; ---------------------------------------------------------------------o


; ; visual studio code path(e.g. "C:\Users\xxxx\AppData\Local\Programs\Microsoft VS Code\Code.exe")
; ; if blank, leave a ugly cmd window after input cmd `proj`(open nox project with vscode).
; global vscode_path := "C:\Program Files\Microsoft VS Code\Code.exe"

; global music_app_path := "C:\Program Files (x86)\Netease\CloudMusic\cloudmusic.exe"

; global disable_win10_auto_update := 1

; global enable_hot_edges := 1  ; when ctrl+8 on the edge (useful for touchpad user)

; global EverythingShortCutFunc := "User_EverythingShortCut"
; global DoubleClickShiftTriggerFunc := ""
; global DoubleClickAltTriggerFunc := ""
; global EverythingShortCutFunc := ""
; global DoubleClickCtrlTriggerFunc := ""
; global HotEdgesTopHalfLeftTriggerFunc := ""
; global HotEdgesTopHalfRightTriggerFunc := ""
; global HotEdgesBottomHalfLeftTriggerFunc := ""
; global HotEdgesBottomHalfRightTriggerFunc := ""
; global HotEdgesLeftHalfUpTriggerFunc := ""
; global HotEdgesLeftHalfDownTriggerFunc := ""
; global HotEdgesRightHalfUpTriggerFunc := ""
; global HotEdgesRightHalfDownTriggerFunc := ""
; global HotCornersTopLeftTriggerFunc := ""
; global HotCornersTopRightTriggerFunc := ""
; global HotCornersBottomLeftTriggerFunc := ""
; global HotCornersBottomRightTriggerFunc := ""


; global enable_hot_corners := 1  ; ; when cursor hover on the corner

; global limit_mode_when_full_screen := 1  ; if 1, turn off double shift/ctrl/alt & hot edges/corners when full screen
; global enable_auto_selection_copy := 0  ; should use with `Win+V` or `CapsLock+Shift+F`

; ; millisecond, the smaller the value, the faster you have to double-click
; global keyboard_double_click_timeout := 222
; global mouse_double_click_timeout := 666


; ---------------------------------------------------------------------o
; 					override default override replace str map conf  ( Capslock+Shift+U )
; ---------------------------------------------------------------------o


; ---------------------------------------------------------------------o
; 					override default override web search url conf  
; ---------------------------------------------------------------------o


; ---------------------------------------------------------------------o
; 					override default TriggerFunc conf  
; ---------------------------------------------------------------------o

; User_EverythingShortCut() {
; 	; u can set your own Everything shortcut here, like ` Send, ^!+e `
; }

		), %user_conf_file%
	}
	else {
		#IncludeAgain *i %A_ScriptDir%\conf\user_conf.ahk
		SetTimer, IncludeUserConfIFExist, off
	}
}