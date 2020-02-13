; ; Note: Save with encoding UTF-8 with BOM if possible.
; ; Notepad will save UTF-8 files with BOM automatically (even though it does not say so).
; ; Some editors however save without BOM, and then special characters look messed up in the AHK GUI.

global limit_mode := 0
global old_limit_mode := limit_mode

global cur_selected_text := ""

global fake_rb_down := 0
global fake_lb_down := 0
global IsTopXOffset := A_ScreenWidth / 3

global Xmax := 0	
global Ymax := 0	
WinGetPos, , , Xmax, Ymax, Program Manager  ; ,  get desktop size (`Program Manager` is the title of the desktop window)

global RightEdge = Xmax - 1
global BottomEdge = Ymax - 1

global CornerOffset := 10  ; adjust tolerance value (pixels to corner) if desired	

global trim_p = ""
global last_search_str = ""


; compatible with dual monitor
IsCorner(cornerID="")
{
	CoordMode, Mouse, Screen		; Coordinate mode - coords will be passed to mouse related functions, with coords relative to entire screen 

	MouseGetPos, MouseX, MouseY 							; Function MouseGetPos retrieves the current position of the mouse cursor

	; IsOnTop := (MouseY = 0 and ((MouseX > IsTopXOffset and MouseX < A_ScreenWidth - IsTopXOffset) Or ((MouseX > (A_ScreenWidth + IsTopXOffset) and (MouseX < Xmax - IsTopXOffset)))))  					; Boolean stores whether mouse cursor is in top left corner
	CornerTopLeft := (MouseY < CornerOffset and ((MouseX < CornerOffset) Or ((MouseX < (A_ScreenWidth + CornerOffset) and (MouseX >= A_ScreenWidth)))))  					; Boolean stores whether mouse cursor is in top left corner
	CornerTopRight := (MouseY < CornerOffset and ((MouseX > Xmax - CornerOffset) Or ((MouseX > (A_ScreenWidth - CornerOffset) and (MouseX < A_ScreenWidth))))) 			; Boolean stores whether mouse cursor is in top right corner
	CornerBottomLeft := (((MouseX < CornerOffset) Or ((MouseX < (A_ScreenWidth + CornerOffset) and (MouseX >= A_ScreenWidth)))) and MouseY > Ymax - CornerOffset) 			; Boolean stores whether mouse cursor is in bottom left corner
	CornerBottomRight := (((MouseX > Xmax - CornerOffset) Or ((MouseX > (A_ScreenWidth - CornerOffset) and (MouseX < A_ScreenWidth)))) and MouseY > Ymax - CornerOffset) 	; Boolean stores whether mouse cursor is in top left corner
	
	; if (cornerID = "IsOnTop"){
	; 	return IsOnTop
	; }
	; else 
	if (cornerID = "TopLeft"){
		return CornerTopLeft
	}
	else if (cornerID = "TopRight"){
		return CornerTopRight
	}
	else if (cornerID = "BottomLeft"){
		return CornerBottomLeft
	}
	else if  (cornerID = "BottomRight") {
		return CornerBottomRight
	}
	else{
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

HandleMouseOnEdges(from) {
	IsOnEdge := 0
	if (enable_hot_edges = 0){
		; ToolTipWithTimer("	conf.enable_hot_edges is 0, so do NOTHING by edge triggers.", 2000)
		return IsOnEdge
	}
	if (limit_mode){
		; ToolTipWithTimer("	limit mode is on, so do NOTHING by edge triggers.", 2000)
		return IsOnEdge
	}
	if IsCorner(){
		IsOnEdge = 1
		; ToolTipWithTimer("	Is Corner, so do NOTHING by edge triggers.", 2000)
		return IsOnEdge
	}
	CoordMode, Mouse, Screen		; Coordinate mode - coords will be passed to mouse related functions, with coords relative to entire screen 
	MouseGetPos, MouseX, MouseY 							; Function MouseGetPos retrieves the current position of the mouse cursor

	Sleep, 66  ; 不加这个 `Sleep 66`, 可能某些快捷键跟触发快捷键有混杂冲突啥的, 比如可能会有win开始界面一闪而过
	IsOnEdge := 0
	if (MouseY = 0)
	{
		IsOnEdge = 1
		if mod(MouseX, A_ScreenWidth) < (A_ScreenWidth / 2)
			HotEdgesTopHalfLeftTrigger(from)
		else
			HotEdgesTopHalfRightTrigger(from)
	}
	else if (MouseY = BottomEdge)
	{
		IsOnEdge = 1
		if mod(MouseX, A_ScreenWidth) < (A_ScreenWidth / 2)
			HotEdgesBottomHalfLeftTrigger(from)
		else
			HotEdgesBottomHalfRightTrigger(from)
	}
	else if (MouseX = 0)
	{
		IsOnEdge = 1
		if mod(MouseY, A_ScreenHeight) < (A_ScreenHeight / 2)
			HotEdgesLeftHalfUpTrigger(from)
		else
			HotEdgesLeftHalfDownTrigger(from)
	}
	else if (MouseX = RightEdge)
	{
		IsOnEdge = 1
		if mod(MouseY, A_ScreenHeight) < (A_ScreenHeight/ 2)
			HotEdgesRightHalfUpTrigger(from)
		else
			HotEdgesRightHalfDownTrigger(from)
	}

	; if is_wgesture_on and (from = "RButton" or from = "MButton")  ; 为了防止触发两次
	; {
	; 	Loop
	; 	{
	; 		MouseGetPos, MouseX, MouseY 							; Function MouseGetPos retrieves the current position of the mouse cursor
	; 		if !(MouseY = 0 or MouseY = BottomEdge or MouseX = 0 or MouseX = Right)
	; 			break ; exits loop when mouse is no longer in the edge
	; 	}	
	; }
   return IsOnEdge
}

UpdateNox() {
	RunWait, cmd.exe /c git pull origin master,,hide
	MsgBox,,, nox update finished. , 6
	Reload
}

HotCorners() {				; Timer content 
	if (limit_mode){
		ToolTipWithTimer("	limit mode is on, so do NOTHING by corner triggers.", 2000)
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
		HotCornersTopLeftTrigger()
		Loop 
		{
			if ! IsCorner("TopLeft")
				break ; exits loop when mouse is no longer in the corner
		}
		return
	}

	if IsCorner("TopRight")
	{	
		HotCornersTopRightTrigger()
		Loop
		{
			if ! IsCorner("TopRight")
				break ; exits loop when mouse is no longer in the corner
		}	
		return
	}

	if IsCorner("BottomLeft")
	{	
		HotCornersBottomLeftTrigger()
		Loop
		{
			if ! IsCorner("BottomLeft")
				break ; exits loop when mouse is no longer in the corner
		}	
		return
	}

	if IsCorner("BottomRight")
	{	
		HotCornersBottomRightTrigger()
		Loop
		{
			if ! IsCorner("BottomRight")
				break ; exits loop when mouse is no longer in the corner
		}	
		return
	}
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
		ToolTipWithTimer("limit mode is " . (limit_mode ? "on" : "off"), 1111)
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


DefaultWebSearch(user_input) {
	gui_destroy()
	last_search_str := user_input
	if IsRawUrl(user_input){
		run %user_input%
		return
	}
	safe_query := UriEncode(Trim(last_search_str))
	default_search_url := WebSearchUrlMap["default"][2]
	StringReplace, search_final_url, default_search_url, REPLACEME, %safe_query%
	run %search_final_url%
}


IsRawUrl(user_input){
	http_str := "http://"
	https_str := "https://"
	return InStr(user_input, http_str) or InStr(user_input, https_str)
}