#Include %A_ScriptDir%\source\common_const.ahk
#Include %A_ScriptDir%\source\quick_entry.ahk
#Include %A_ScriptDir%\source\js_eval.ahk
#Include %A_ScriptDir%\source\snip_plus.ahk
#Include %A_ScriptDir%\source\util.ahk




ShowSuxMenu() {
	QuickEntry.ShowQuickEntryMenu()
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

StartSuxAhkWithWin() {
	msg_str := "Would you like to start sux with windows? Yes(Enable) or No(Disable)"
	MsgBox, 3,, %msg_str%
	IfMsgBox Cancel
		return

	Name_no_ext := "sux"
	Name := "sux.ahk"
	Dir = %A_ScriptDir%
	sux_ahk_file_path =  %A_ScriptFullPath%

	IfExist, %A_Startup%\%Name_no_ext%.lnk
	{
		IfMsgBox No
		{
			FileDelete, %A_Startup%\%Name_no_ext%.lnk
			MsgBox, %Name% removed from the Startup folder.
		}
		else {
			MsgBox, %Name% already added to Startup folder for auto-launch with Windows.
		}
	}
	Else
	{
		IfMsgBox Yes
		{
			FileCreateShortcut, "%sux_ahk_file_path%"
				, %A_Startup%\%Name_no_ext%.lnk
				, %Dir%   ; Line wrapped using line continuation
			MsgBox, %Name% added to Startup folder for auto-launch with Windows.
		}
	}
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
	if (!IsMouseActiveWindowAtSameMonitor())
		ActivateWindowsUnderCursor()
	Send {LControl Down}{LShift Down}
	Send, {Tab}
	Sleep, 111
	Send {LControl Up}{LShift Up}
}

JumpToNextTab() {
	if (!IsMouseActiveWindowAtSameMonitor())
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


SwitchInputMethodAndDeleteLeft() {
	global MULTI_HIT_DECORATOR
	global keyboard_double_click_timeout
	cur_key := StrReplace(A_ThisHotkey, MULTI_HIT_DECORATOR)
	; cur_key := StrReplace(A_ThisHotkey, "~")
	if (A_PriorHotkey <> A_ThisHotkey or A_TimeSincePriorHotkey > keyboard_double_click_timeout)
	; if (A_PriorHotkey != "~Alt" or A_TimeSincePriorHotkey > keyboard_double_click_timeout)
	{
		; Too much time between presses, so this isn't a double-press.
		Send, ^{Space}
		; ToolTipWithTimer(A_PriorKey)  ; LAlt
		; ToolTipWithTimer(A_ThisHotkey)  ; ~alt
		; ToolTipWithTimer(A_PriorHotkey)  ; ~alt
		KeyWait, % cur_key ; Wait for the key to be released.
		; KeyWait, % A_ThisHotkey ; Wait for the key to be released.
		; KeyWait, %A_PriorHotkey%  ; Wait for the key to be released.
		; KeyWait, Alt  ; Wait for the key to be released.
		; ToolTipWithTimer(A_PriorKey)
		return
	}
	; Send, ^{Space}
	Send, ^+{Left}
	; Sleep, 66
	Send, {Del}
	return
}


MaxMinWindow() {
	; ActivateWindowsUnderCursor()
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

MaxWindow() {
	; ActivateWindowsUnderCursor()
	; WinGet,S,MinMax,A
	WinMaximize, A
}

MinWindow() {
	; ActivateWindowsUnderCursor()
	; WinGet,S,MinMax,A
	WinMinimize, A
}

ReloadSux() {
	ToolTipWithTimer("reloading sux ...")
	Reload
}


SelectCurrentWord() {
	Send, ^{Left}
	Sleep, 66
	Send, ^+{Right}
	; Send, ^c
}

SelectCurrentLine() {
	Send, {Home}
	Sleep, 66
	Send, +{End}
}

InsertLineBelow() {
	Send, {End}
	Sleep, 66
	Send, {Enter}
	Sleep, 66
	Loop 8
	{
		Send, {WheelLeft}
	}
}

InsertLineAbove() {
	Send, {Home}
	Sleep, 66
	Send, {Enter}
	Sleep, 66
	Send, {Up}
	Sleep, 66
	Loop 8
	{
		Send, {WheelLeft}
	}
}

DeleteCurrentLine() {
	SelectCurrentLine()
	Sleep, 66
	Send, {BackSpace}
}

; SmartSelectWithSymbol() {
; 	symbol_map := {"'": "'", """": """", "(": ")", "[": "]", "{": "}", "<": ">"}
; 	max_step := 888
; 	cur_step := 0
; 	left_symbol := ""
; 	break_loop := 0

; 	walk_more_flag := 0

; 	Loop
; 	{
; 		cur_step += 1
; 		if (cur_step > max_step) {
; 			return
; 		}
; 		Send, +^{Left}
; 		; Sleep, 66
; 		st := GetCurSelectedText()

; 		for k, v in symbol_map {
; 			if (Instr(st, k)) {
; 				left_symbol := k
; 				Send, {Left}

; 				Send, +{Right}
; 				cur_step -= 1
; 				if (GetCurSelectedText() != k) {
; 					walk_more_flag := 1
; 					Send, ^{Right}
; 				}
; 				while (cur_step > 0) {
; 					Send, +^{Right}
; 					cur_step -= 1
; 				}
; 				break_loop := 1
; 				break
; 			}
; 		}
; 		if (break_loop)
; 			break
; 	}

; 	right_symbol := symbol_map[left_symbol]
; 	Loop
; 	{
; 		cur_step += 1
; 		if (cur_step > max_step) {
; 			return
; 		}
; 		Send, +^{Right}
; 		; Sleep, 66
; 		st := GetCurSelectedText()
; 		if (Instr(st, right_symbol,,2)) {
; 			if (walk_more_flag)
; 				Send, +^{Left}
; 			break
; 		}
; 	}
; }

IndentCurrentLine() {
	Send, {Home}
	Sleep, 66
	Send, {Tab}
}


SaveSelectedFilePathToClipboard() {
    ClipboardChangeCmdMgr.disable_all_clip_change_func()
    Clipboard := ""
    SendInput, ^{insert}
    ClipWait, 0.1
    if(!ErrorLevel) {
		path := Clipboard
		Clipboard := ""
   		ClipboardChangeCmdMgr.enable_all_clip_change_func()
		Clipboard := path
	}
}

SimulateClickDown() {
	fake_lb_down = 1
	Click Down
	Hotkey, RButton, SUB_TEMP_RBUTTON
	Hotkey, RButton, On
}


MoveCurrentWindowToMouseMonitor() {
	MoveWindowToMouseMonitor()
}


SUB_TEMP_RBUTTON:
	ClickUpIfLbDown()
	MouseClick, Right
	Return
