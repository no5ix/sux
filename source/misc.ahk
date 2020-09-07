; ; Note: Save with encoding UTF-8 with BOM if possible.
; ; Notepad will save UTF-8 files with BOM automatically (even though it does not say so).
; ; Some editors however save without BOM, and then special characters look messed up in the AHK GUI.


;-------------------------------------------------------------------------------
; LAUNCH GUI
;-------------------------------------------------------------------------------
~Alt::
	ClickUpIfLbDown()
	
	; ; 不能这么写, 因为这样长按 alt 也会触发
	; If (A_PriorHotKey = "~Alt") AND (A_TimeSincePriorHotkey < keyboard_double_click_timeout)
	; 	gui_spawn()

	if (A_PriorHotkey <> "~Alt" or A_TimeSincePriorHotkey > keyboard_double_click_timeout)
	{
		; Too much time between presses, so this isn't a double-press.
		KeyWait, Alt
		return
	}
	if limit_mode {
		ToolTipWithTimer("	limit mode is on, double Alt is disabled.", 2000)
		return
	}
	%DoubleClickAltTriggerFunc%()
	return

; -----------------------------------------------------------------------------
; ~LShift::
; 	ClickUpIfLbDown()
; 	; TimeButtonDown = %A_TickCount%
; 	; ; Wait for it to be released
; 	; Loop
; 	; {
; 	; 	Sleep 10
; 	; 	GetKeyState, LshiftState, Lshift, P
; 	; 	if LshiftState = U  ; Button has been released.
; 	; 		break
; 	; 	elapsed = %A_TickCount%
; 	; 	elapsed -= %TimeButtonDown%
; 	; 	if elapsed > 200  ; Button was held down long enough
; 	; 	{
; 	; 		x0 = A_CaretX
; 	; 		y0 = A_CaretY
; 	; 		Loop
; 	; 		{
; 	; 			Sleep 20                    ; yield time to others
; 	; 			GetKeyState keystate, Lshift
; 	; 			IfEqual keystate, U, {
; 	; 			x = A_CaretX
; 	; 			y = A_CaretY
; 	; 			break
; 	; 			}
; 	; 		}
; 	; 		if (x-x0 > 5 or x-x0 < -5 or y-y0 > 5 or y-y0 < -5)
; 	; 		{                             ; Caret has moved
; 	; 			clip0 := ClipBoardAll      ; save old clipboard
; 	; 			;ClipBoard =
; 	; 			Send ^c                    ; selection -> clipboard
; 	; 			ClipWait 1, 1              ; restore clipboard if no data
; 	; 			IfEqual ClipBoard,, SetEnv ClipBoard, %clip0%
; 	; 		}
; 	; 		return
; 	; 	}
; 	; }
; 	if (A_PriorHotkey <> "~LShift" or A_TimeSincePriorHotkey > keyboard_double_click_timeout)
; 	{
; 		; Too much time between presses, so this isn't a double-press.
; 		KeyWait, LShift
; 		return
; 	}
; 	if limit_mode {
; 		ToolTipWithTimer("	limit mode is on, double Shift is disabled.", 2000)
; 		return
; 	}
; 	%DoubleClickShiftTriggerFunc%()
; 	return
; -----------------------------------------------------------------------------


~Ctrl::
	ClickUpIfLbDown()
	if (A_PriorHotkey <> "~Ctrl" or A_TimeSincePriorHotkey > keyboard_double_click_timeout)
	{
		; Too much time between presses, so this isn't a double-press.
		KeyWait, Ctrl
		return
	}
	if limit_mode {
		ToolTipWithTimer("	limit mode is on, double Ctrl is disabled.", 2000)
		return
	}
	%DoubleClickCtrlTriggerFunc%()
	return

; -----------------------------------------------------------------------------

~Ins::
	ClickUpIfLbDown()
	if (A_PriorHotkey <> "~Ins" or A_TimeSincePriorHotkey > keyboard_double_click_timeout)
	{
		; Too much time between presses, so this isn't a double-press.
		KeyWait, Ins
		return
	}
	Send, {F2}
	return


~LWin::
	ClickUpIfLbDown()
	return

~RWin::
	ClickUpIfLbDown()
	return

;---------------------------------------------------------------------o

;---------------------------------------------------------------------o
					;Auto copy clipboard begin
;---------------------------------------------------------------------o
; 功能: 
; - 双击则复制, 如果笔记本触摸板开启了双击拖动就可以多选的话, 则双击无法复制
; - 三击则复制
; - 选中则复制
; ~LButton::
; fake_lb_down = 0
; if (!enable_auto_selection_copy or limit_mode)
; 	return
; MouseGetPos, xx
; TimeButtonDown = %A_TickCount%
; ; Wait for it to be released
; Loop
; {
; 	Sleep 10
; 	GetKeyState, LButtonState, LButton, P
; 	if LButtonState = U  ; Button has been released.
; 	{
; 		If WinActive("Crimson Editor") and (xx < 25) ; Single Click in the Selection Area of CE
; 		{
; 			Send, ^c
; 			ToolTipWithTimer("copy selection finished.")
; 			return
; 		}
; 		break
; 	}
; 	elapsed = %A_TickCount%
; 	elapsed -= %TimeButtonDown%
; 	if elapsed > 200  ; Button was held down too long, so assume it's not a double-click.
; 	{
; 		MouseGetPos x0, y0            ; save start mouse position
; 		Loop
; 	{
; 		Sleep 20                    ; yield time to others
; 		GetKeyState keystate, LButton
; 		IfEqual keystate, U, {
; 		MouseGetPos x, y          ; position when button released
; 		break
; 		}
; 	}
; 	if (x-x0 > 5 or x-x0 < -5 or y-y0 > 5 or y-y0 < -5)
; 	{                             ; mouse has moved
; 		clip0 := ClipBoardAll      ; save old clipboard
; 		;ClipBoard =
; 		Send ^c                    ; selection -> clipboard
; 			ToolTipWithTimer("copy selection finished.")

; 		ClipWait 1, 1              ; restore clipboard if no data
; 		IfEqual ClipBoard,, SetEnv ClipBoard, %clip0%
; 	}
; 		return
; 	}
; }
; ; Otherwise, button was released quickly enough.  Wait to see if it's a double-click:
; TimeButtonUp = %A_TickCount%
; Loop
; {
; 	Sleep 10
; 	GetKeyState, LButtonState, LButton, P
; 	if LButtonState = D  ; Button has been pressed down again.
; 		break
; 	elapsed = %A_TickCount%
; 	elapsed -= %TimeButtonUp%
; 	if elapsed > 350  ; No click has occurred within the allowed time, so assume it's not a double-click.
; 		return
; }

; ;Button pressed down again, it's at least a double-click
; TimeButtonUp2 = %A_TickCount%
; Loop
; {
; 	Sleep 10
; 	GetKeyState, LButtonState2, LButton, P
; 	if LButtonState2 = U  ; Button has been released a 2nd time, let's see if it's a tripple-click.
; 		break
; }
; ;Button released a 2nd time
; TimeButtonUp3 = %A_TickCount%
; Loop
; {
; 	Sleep 10
; 	GetKeyState, LButtonState3, LButton, P
; 	if LButtonState3 = D  ; Button has been pressed down a 3rd time.
; 		break
; 	elapsed = %A_TickCount%
; 	elapsed -= %TimeButtonUp%
; 	if elapsed > 350  ; No click has occurred within the allowed time, so assume it's not a tripple-click.
; 	{  ;Double-click
; 		Send, ^c
; 		ToolTipWithTimer("copy selection finished.")
; 		return
; 	}
; }
; ;Tripple-click:
; 	Sleep, 100
; 	Send, ^c
; 	ToolTipWithTimer("copy selection finished.")
; return
; ---------------------------------------------------------------------o
; 					Auto copy clipboard end
; ---------------------------------------------------------------------o


;=====================================================================o
;                       For Notebook:                                 ;|
;---------------------------------o-----------------------------------o

; 功能(主要用于笔记本触摸板): 
; - 单击快捷键Ctrl+8: 模拟鼠标左键按下, 在触摸板上拖动则可选中
#Persistent
^8::
	result_arr := HandleMouseOnEdges("Ctrl+8")
	if result_arr[1] = 1
		return
	SetDefaultMouseSpeed, 0 ; Move the mouse instantly.
	SetMouseDelay, 0
	fake_lb_down = 1
	Click Down
	ToolTipWithTimer("simulate click DOWN. `n" . result_arr[2], 2222)
	return
