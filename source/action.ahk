#Include %A_ScriptDir%\source\common_const.ahk
#Include %A_ScriptDir%\source\search_gui.ahk


ReplaceAllText() {
	send, ^a
	ReplaceSelectedText()
}

ReplaceSelectedText() {
	global STR_REPLACE_CONF_REGISTER_MAP
	; store the number of replacements that occurred (0 if none).
	replace_sum := 0
	ClipSaved := ClipboardAll   ; Save the entire clipboard to a variable of your choice.
	; ... here make temporary use of the clipboard, such as for pasting Unicode text via Transform Unicode ...
	; Sleep, 66
	; Send, ^a
	Sleep, 66
	Send, ^c
	Sleep, 66
	; Read from the array:
	; Loop % Array.MaxIndex()   ; More traditional approach.
	for key, value in STR_REPLACE_CONF_REGISTER_MAP ; Enumeration is the recommended approach in most cases.
	{
		cur_replace_cnt := 0
		; Using "Loop", indices must be consecutive numbers from 1 to the number
		; of elements in the array (or they must be calculated within the loop).
		; MsgBox % "Element number " . A_Index . " is " . Array[A_Index]
		; Using "for", both the index (or "key") and its associated value
		; are provided, and the index can be *any* value of your choosing.
		Clipboard := StrReplace(Clipboard, key, value, cur_replace_cnt)
		replace_sum += cur_replace_cnt
	}
	Sleep, 66
	if replace_sum != 0
		Send, ^v
	else
		Send, {Right}
	Sleep, 66
	Clipboard := ClipSaved   ; Restore the original clipboard. Note the use of Clipboard (not ClipboardAll).
	ClipSaved := ""   ; Free the memory in case the clipboard was very large.
}

MoveWindowToLeftSide() {
	send, #{Left}
}

MoveWindowToRightSide() {
	send, #{Right}
}

OpenFileExplorer() {
	run explorer.exe
}

OpenActionCenter() {
	send, #a
}

CloseCurrentWindow() {
	send, !{F4}
}

GoTop() {
	send, ^{Home}
}

GoBottom() {
	send, ^{End}
}

GoBack() {
	send, !{Left}
}

GoForward() {
	send, !{Right}
}

LockPc() {
	send, #l
}

OpenTaskView() {
	send, #{Tab}
}

VolumeMute() {
	Send {volume_mute}
}

VolumeUp() {
	Send {volume_up}
}

VolumeDown() {
	Send {volume_down}
}

GotoNextDesktop() {
	send, ^#{Right}
}

GotoPreDesktop() {
	send, ^#{Left}
}

RefreshTab() {
	send {F5}
}

ReopenLastTab() {
	send ^+t
}

GotoPreApp() {
	send !{Tab}
}

JumpToPrevTab() {
	ActivateWindowsUnderCursor()
	Send {LControl Down}{LShift Down}
	Send, {Tab}
	Sleep, 111
	Send {LControl Up}{LShift Up}
}

JumpToNextTab() {
	ActivateWindowsUnderCursor()
	Send {LControl Down}
	Send, {Tab}
	Sleep, 111
	Send {LControl Up}
}

SwitchCapsState() {
	; SetCapsLockState % !GetKeyState("CapsLock", "T")  ; Toggles CapsLock to its opposite state.
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
    param = %A_ScriptDir%\app_data\prscrn.dll\PrScrn
    DllCall(param)
}

DoubleHitWebSearch(){
	; ; 不能这么写, 因为这样长按 alt 也会触发
	; If (A_PriorHotKey = "~Alt") AND (A_TimeSincePriorHotkey < keyboard_double_click_timeout)
	; 	SearchGui.search_gui_spawn()
	; if (A_PriorHotkey <> "~Alt" or A_TimeSincePriorHotkey > keyboard_double_click_timeout)
	if (A_PriorHotkey <> A_ThisHotkey or A_TimeSincePriorHotkey > keyboard_double_click_timeout)
	{
		; Too much time between presses, so this isn't a double-press.
		ClickUpIfLbDown()
		KeyWait, %A_PriorKey%  ; Wait for the key to be released.
		return
	}
	; if limit_mode {
	; 	ToolTipWithTimer("	limit mode is on, double Alt is disabled.", 2000)
	; 	return
	; }
	; %DoubleClickAltTriggerFunc%()
	; return
	SearchGui.search_gui_spawn()
	return
}

WebSearchSelectedText() {
    ; search_gui_spawn_func := "search_gui_spawn"
    ; %search_gui_spawn_func%(GetCurSelectedText())
    SearchGui.search_gui_spawn(GetCurSelectedText())
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

ReloadSux() {
	Reload
}


SimulateClickDown() {
	SetDefaultMouseSpeed, 0 ; Move the mouse instantly.
	SetMouseDelay, 0
	fake_lb_down = 1
	Click Down
}