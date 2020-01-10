; ; Note: Save with encoding UTF-8 with BOM if possible.
; ; Notepad will save UTF-8 files with BOM automatically (even though it does not say so).
; ; Some editors however save without BOM, and then special characters look messed up in the AHK GUI.


global Xmax := 0	
global Ymax := 0	
WinGetPos, , , Xmax, Ymax, Program Manager  ; ,  get desktop size (`Program Manager` is the title of the desktop window)

global RightEdge = Xmax - 1
global BottomEdge = Ymax - 1

global CornerXOffset := 10  ; adjust tolerance value (pixels to corner) if desired	

; compatible with dual monitor
IsCorner(cornerID)
{
	MouseGetPos, MouseX, MouseY 							; Function MouseGetPos retrieves the current position of the mouse cursor

	; IsOnTop := (MouseY = 0 and ((MouseX > IsTopXOffset and MouseX < A_ScreenWidth - IsTopXOffset) Or ((MouseX > (A_ScreenWidth + IsTopXOffset) and (MouseX < Xmax - IsTopXOffset)))))  					; Boolean stores whether mouse cursor is in top left corner
	CornerTopLeft := (MouseY < CornerXOffset and ((MouseX < CornerXOffset) Or ((MouseX < (A_ScreenWidth + CornerXOffset) and (MouseX >= A_ScreenWidth)))))  					; Boolean stores whether mouse cursor is in top left corner
	CornerTopRight := (MouseY < CornerXOffset and ((MouseX > Xmax - CornerXOffset) Or ((MouseX > (A_ScreenWidth - CornerXOffset) and (MouseX < A_ScreenWidth))))) 			; Boolean stores whether mouse cursor is in top right corner
	CornerBottomLeft := (((MouseX < CornerXOffset) Or ((MouseX < (A_ScreenWidth + CornerXOffset) and (MouseX >= A_ScreenWidth)))) and MouseY > Ymax - CornerXOffset) 			; Boolean stores whether mouse cursor is in bottom left corner
	CornerBottomRight := (((MouseX > Xmax - CornerXOffset) Or ((MouseX > (A_ScreenWidth - CornerXOffset) and (MouseX < A_ScreenWidth)))) and MouseY > Ymax - CornerXOffset) 	; Boolean stores whether mouse cursor is in top left corner
	
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
			; fake_lb_down = 0
		Click Up
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
	if enable_hot_edges = 0
		return IsOnEdge
	CoordMode, Mouse, Screen		; Coordinate mode - coords will be passed to mouse related functions, with coords relative to entire screen 
	MouseGetPos, MouseX, MouseY 							; Function MouseGetPos retrieves the current position of the mouse cursor

	IsOnEdge := 0
	if (MouseY = 0)
	{
        Sleep, 66  ; 不加这个 `Sleep 66`, 可能某些快捷键跟触发快捷键有混杂冲突啥的, 比如可能会有win开始界面一闪而过
		IsOnEdge = 1
		HotEdgesTopTrigger(from)
	}
	else if (MouseY = BottomEdge)
	{
		Sleep, 66  ; 不加这个 `Sleep 66`, 可能某些快捷键跟触发快捷键有混杂冲突啥的, 比如可能会有win开始界面一闪而过
		IsOnEdge = 1
		HotEdgesBottomTrigger(from)
	}
	else if (MouseX = 0)
	{
		Sleep, 66  ; 不加这个 `Sleep 66`, 可能某些快捷键跟触发快捷键有混杂冲突啥的, 比如可能会有win开始界面一闪而过
		IsOnEdge = 1
		HotEdgesLeftTrigger(from)
	}
	else if (MouseX = RightEdge)
	{
		Sleep, 66  ; 不加这个 `Sleep 66`, 可能某些快捷键跟触发快捷键有混杂冲突啥的, 比如可能会有win开始界面一闪而过
		IsOnEdge = 1
		HotEdgesRightTrigger(from)
	}

	if is_wgesture_on  ; 为了防止触发两次
	{
		Loop
		{
			MouseGetPos, MouseX, MouseY 							; Function MouseGetPos retrieves the current position of the mouse cursor
			if !(MouseY = 0 or MouseY = BottomEdge or MouseX = 0 or MouseX = Right)
				break ; exits loop when mouse is no longer in the edge
		}	
	}
   return IsOnEdge
}

UpdateNox() {
	RunWait, cmd.exe /c git pull origin master,,hide
	MsgBox,,, nox update finished. , 6
	Reload
}

HotCorners() {				; Timer content 
	CoordMode, Mouse, Screen		; Coordinate mode - coords will be passed to mouse related functions, with coords relative to entire screen 

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