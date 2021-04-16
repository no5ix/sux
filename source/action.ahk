
JumpToPrevTab() {
	if (IsMouseActiveWindowAtSameMonitor() == 0) {
		; activate the window currently under mouse cursor
		MouseGetPos,,, curr_hwnd 
		WinActivate, ahk_id %curr_hwnd%
	}
	Send {LControl Down}{LShift Down}
	Send, {Tab}
	Sleep, 111
	Send {LControl Up}{LShift Up}
}

JumpToNextTab() {
	if (IsMouseActiveWindowAtSameMonitor() == 0) {
		; activate the window currently under mouse cursor
		MouseGetPos,,, curr_hwnd 
		WinActivate, ahk_id %curr_hwnd%
	}
	Send {LControl Down}
	Send, {Tab}
	Sleep, 111
	Send {LControl Up}
}

SwitchCapsState() {
    GetKeyState, CapsLockState, CapsLock, T                              ;|
    if CapsLockState = D                                                 ;|
        SetCapsLockState, AlwaysOff                                      ;|
    else
    {
        SetCapsLockState, AlwaysOn
    }
}

ScreenShot() {
    ; ; screen capture
    param = %A_ScriptDir%\source\printscrn.dll\PrScrn
    DllCall(param)
}

WebSearchCurSelectedText() {
    gui_spawn_func := "gui_spawn"
    %gui_spawn_func%(GetCurSelectedText())
}