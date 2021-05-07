#Include %A_ScriptDir%\source\common_const.ahk
#Include %A_ScriptDir%\source\quick_entry.ahk
#Include %A_ScriptDir%\source\js_eval.ahk
#Include %A_ScriptDir%\source\snip_plus.ahk
#Include %A_ScriptDir%\source\util.ahk



;;;;;;;;;;;;;;;
webapp_gui_http_req = 
__Webapp_wb = 
TranslateSeletedText()
{
	global webapp_gui_http_req
	webapp_gui_http_req := ComObjCreate("Msxml2.XMLHTTP")
	; 打开启用异步的请求.
	st := GetCurSelectedText()
	if !st
		return
	url := "https://www.youdao.com/w/" . st
	webapp_gui_http_req.open("GET", url, true)
	; 设置回调函数 [需要 v1.1.17+].
	webapp_gui_http_req.onreadystatechange := Func("on_webapp_gui_req_ready")
	; 发送请求. Ready() 将在其完成后被调用.
	webapp_gui_http_req.send()
	; SetTimer, handle_webapp_gui_req_failed, -6666
}

on_webapp_gui_req_ready() {
	global webapp_gui_http_req
	if (webapp_gui_http_req.readyState != 4) {  ; 没有完成.
		return
	}
	TEMP_TRANS_WEBAPP_GUI_HTML_HTML := "app_data/trans/TEMP_TRANS_WEBAPP_GUI.html"
	; TRANS_STYLE_CSS := """min_trans_style.css"""
	if (webapp_gui_http_req.status == 200) {
		; yd_html_file := FileOpen(TEMP_TRANS_WEBAPP_GUI_HTML_HTML, "w")
		if FileExist(TEMP_TRANS_WEBAPP_GUI_HTML_HTML)
			FileDelete, % TEMP_TRANS_WEBAPP_GUI_HTML_HTML
		html_head_str = 
		(
		<!DOCTYPE html>
		<html>
			<head>
				<meta http-equiv='X-UA-Compatible' content='IE=edge'>
				<link rel="stylesheet" href="min_trans_style.css">
			</head>
			<body>
		)

		left_pos := InStr(webapp_gui_http_req.responseText, "<div id=""results"">")
		right_pos := InStr(webapp_gui_http_req.responseText, "<div id=""ads"" class=""ads"">")
		final_html_body_str := html_head_str . SubStr(webapp_gui_http_req.responseText, left_pos, right_pos-left_pos+1) . "</body> </html>"
		; yd_html_file.Write(final_html_body_str)
		; yd_html_file.Close()
		FileAppend, % final_html_body_str, % TEMP_TRANS_WEBAPP_GUI_HTML_HTML

		global __Webapp_wb
		__Webapp_Width := 688
		__Webapp_height := 480
		__Webapp_Name := lang("Translation")
		Gui __Webapp_:New
		Gui __Webapp_:Margin, 0, 0
		Gui __Webapp_:Add, ActiveX, v__Webapp_wb w%__Webapp_Width% h%__Webapp_height%, Shell.Explorer
		__Webapp_wb.silent := true ;Surpress JS Error boxes
		__Webapp_wb.Navigate("file://" . GetFullPathName(TEMP_TRANS_WEBAPP_GUI_HTML_HTML))

		;Wait for IE to load the page, before we connect the event handlers
		while __Webapp_wb.readystate != 4 or __Webapp_wb.busy
			sleep 10
		;Use DOM access just like javascript!
		; MyButton1 := wb.document.getElementById("MyButton1")
		; MyButton2 := wb.document.getElementById("MyButton2")
		; MyButton3 := wb.document.getElementById("MyButton3")
		; ComObjConnect(MyButton1, "MyButton1_") ;connect button events
		; ComObjConnect(MyButton2, "MyButton2_")
		; ComObjConnect(MyButton3, "MyButton3_")
		Gui __Webapp_:Show, w%__Webapp_Width% h%__Webapp_height%, %__Webapp_Name%
		; Gui __Webapp_:Default
	}
	else {
		; m("xxd")
		; handle_webapp_gui_req_failed()
	}
	webapp_gui_http_req = 
}

__Webapp_GuiEscape:
__Webapp_GuiClose:
	;make sure taskbar is back on exit
	WinShow, ahk_class Shell_TrayWnd
	WinShow, Start ahk_class Button
	Gui __Webapp_:Destroy
return


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


ScreenShotAndSuspend() {
	SnipPlus.ShowAreaScreenShotAndSuspendMenu()
}


ReplaceText() {
	
	if (!GetCurSelectedText()) {
		send, {Home}
		Sleep, 66
		send, +{End}
	}
	
	global STR_REPLACE_CONF_REGISTER_MAP
	; store the number of replacements that occurred (0 if none).
	replace_sum := 0

	ClipSaved := ClipboardAll   ; Save the entire clipboard to a variable of your choice.
	; ... here make temporary use of the clipboard, such as for pasting Unicode text via Transform Unicode ...
	; Sleep, 66
	; Send, ^a
	; Sleep, 66
	; Send, ^c
	Clipboard := ""
    SendInput, ^{insert}
    ClipWait, 0.6
	; Sleep, 66
	; Read from the array:
	; Loop % Array.MaxIndex()   ; More traditional approach.
	if(!ErrorLevel) {
		for key, value in STR_REPLACE_CONF_REGISTER_MAP ; Enumeration is the recommended approach in most cases.
		{
			cur_replace_cnt := 0
			; Using "Loop", indices must be consecutive numbers from 1 to the number
			; of elements in the array (or they must be calculated within the loop).
			; MsgBox % "Element number " . A_Index . " is " . Array[A_Index]
			; Using "for", both the index (or "key") and its associated value
			; are provided, and the index can be *any* value of your choosing.
			; m(key "//" value)
			Clipboard := StrReplace(Clipboard, key, value, cur_replace_cnt)
			replace_sum += cur_replace_cnt
		}
		Sleep, 66
		if replace_sum != 0
			SafePaste()
		else
			Send, {Right}
	}
	; Sleep, 66
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
	ActivateWindowsUnderCursor()
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
	ActivateWindowsUnderCursor()
	; WinGet,S,MinMax,A
	WinMaximize, A
}

MinWindow() {
	ActivateWindowsUnderCursor()
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


SimulateClickDown() {
	SetDefaultMouseSpeed, 0 ; Move the mouse instantly.
	SetMouseDelay, 0
	fake_lb_down = 1
	Click Down
	Hotkey, RButton, SUB_TILDE_RBUTTON
	Hotkey, RButton, On
}


SUB_TILDE_RBUTTON:
	ClickUpIfLbDown()
	MouseClick, Right
	Return
