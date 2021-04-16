
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

DoubleHitWebSearch(){
	; ; 不能这么写, 因为这样长按 alt 也会触发
	; If (A_PriorHotKey = "~Alt") AND (A_TimeSincePriorHotkey < keyboard_double_click_timeout)
	; 	gui_spawn()
	; if (A_PriorHotkey <> "~Alt" or A_TimeSincePriorHotkey > keyboard_double_click_timeout)
	if (A_PriorHotkey <> A_ThisHotkey or A_TimeSincePriorHotkey > keyboard_double_click_timeout)
	{
		; Too much time between presses, so this isn't a double-press.
		ClickUpIfLbDown()
		KeyWait, %A_ThisHotkey%  ; Wait for the key to be released.
		return
	}
	; if limit_mode {
	; 	ToolTipWithTimer("	limit mode is on, double Alt is disabled.", 2000)
	; 	return
	; }
	; %DoubleClickAltTriggerFunc%()
	; return
	gui_spawn_func := "gui_spawn"  ; 这么写是为了让 common.ahk 和 gui.ahk 解耦, 独立开来, common 不应该依赖 gui
	%gui_spawn_func%()
}

WebSearchCurSelectedText() {
    gui_spawn_func := "gui_spawn"
    %gui_spawn_func%(GetCurSelectedText())
}

SwitchInputMethod() {
	if (A_PriorHotkey <> "RShift" or A_TimeSincePriorHotkey > keyboard_double_click_timeout)
	{
		; Too much time between presses, so this isn't a double-press.
		ClickUpIfLbDown()
		Send, ^{Space}
		KeyWait, RShift
		return
	}
	if limit_mode {
		ToolTipWithTimer("	limit mode is on, double RShift is disabled.", 2000)
		return
	}
	; Send, ^{Space}
	Send, ^+{Left}
	; Sleep, 66
	Send, {Del}
	return
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