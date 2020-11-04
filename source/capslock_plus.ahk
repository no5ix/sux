; ; Note: Save with encoding UTF-8 with BOM if possible.
; ; Notepad will save UTF-8 files with BOM automatically (even though it does not say so).
; ; Some editors however save without BOM, and then special characters look messed up in the AHK GUI.


SetCapsLockState, AlwaysOff

;-------------------------------------------------------------------------------
; LAUNCH GUI
;-------------------------------------------------------------------------------
; CapsLock & x::
; 	gui_spawn()
; return

CapsLock::
	Send, {ESC}
	return

;=====================================================================o
;                       CapsLock Switcher:                           ;|
;---------------------------------o-----------------------------------o
;                    CapsLock + ` | {CapsLock}                       ;|
;---------------------------------o-----------------------------------o
CapsLock & Tab:: 
	if GetKeyState("LShift", "P")
	{
		GetKeyState, CapsLockState, CapsLock, T                              ;|
		if CapsLockState = D                                                 ;|
			SetCapsLockState, AlwaysOff                                      ;|
		else
		{
			SetCapsLockState, AlwaysOn
		}
	}
	else
	{
		; ; screen capture
		param = %A_ScriptDir%\source\PrScrn.dll\PrScrn
		DllCall(param)
	}
	; KeyWait, ``                                                          ;|
	return                                                               ;|
;---------------------------------------------------------------------o


; CapsLock & Space::
; 	Send, ^{Space}
; 	ClickUpIfLbDown()
; 	return

CapsLock & v::
	; if GetKeyState("LShift", "P")
	; 	Send, +6  ; ^ like reverse V
	; else 
		; PasteCompatibleWithAutoSelectionCopy()
		Send, +6
		; Send, ^v
		; Send, +{Ins}
	ClickUpIfLbDown()
	return

; CapsLock & x::
; 	; if GetKeyState("LShift", "P")
; 	; 	Send, ^+f
; 	; else if GetKeyState("RShift", "P")
; 	; 	Send, {F2}
; 	; else
; 		; Send, ^f
; 		Send, {F2}
; 		; Send, ^y
; 	ClickUpIfLbDown()
; 	return

CapsLock & w:: 
	; if GetKeyState("LShift", "P")
	; 	Send, +``  ; wave line : w
	; else
		; Send, ^a
		; Send, ``  ; wave line : w
		Send, +{Ins}
	return

CapsLock & e::
	; if GetKeyState("LShift", "P")
	; 	Send, ^/  ; comment : e
	; else
		Send, {Enter}
		; Send, +4
	ClickUpIfLbDown()
	return

CapsLock & f::
	if GetKeyState("LShift", "P") {
		; Send, {Up}
		; Send, {End}
		; Send, ^v

		; store the number of replacements that occurred (0 if none).
		replace_sum := 0
		ClipSaved := ClipboardAll   ; Save the entire clipboard to a variable of your choice.
		; ... here make temporary use of the clipboard, such as for pasting Unicode text via Transform Unicode ...
		Sleep, 66
		Send, ^a
		Sleep, 66
		Send, ^c
		Sleep, 66
		; Read from the array:
		; Loop % Array.MaxIndex()   ; More traditional approach.
		for key, value in StrMap ; Enumeration is the recommended approach in most cases.
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
	else {
		; WebSearch(Clipboard)
		gui_spawn_func := "gui_spawn"
		%gui_spawn_func%(GetCurSelectedText())
	}
	ClickUpIfLbDown()
	return

CapsLock & c::
	; if GetKeyState("LShift", "P")
	; 	Send, +4
	; else
		; Send, ^c
		Send, ^/  ; comment : e
	ClickUpIfLbDown()
	return

CapsLock & s::
	; if GetKeyState("LShift", "P")
	; 	Send, +^s
	; else
		; Send, ^s
		Send, +4
	ClickUpIfLbDown()
	return

CapsLock & r::
	if GetKeyState("LShift", "P")
		; Send, ^+t  ; for chrome, reopen closed tab
		Send, {F2}
	else
		Send, ^y
	return

; CapsLock & `:: 
; 	if GetKeyState("LShift", "P")
; 		Send, +{Ins}
; 	else
; 		Send, {Ins}
; 	return

CapsLock & d:: 
	if GetKeyState("LShift", "P")
		Send, {BS}
	else
		Send, {Del}
	return

CapsLock & y::
	if GetKeyState("LShift", "P")
		Send, +5
	else
		Send, +8
	return

CapsLock & u::
	if GetKeyState("LShift", "P")
		Send, +2
	else
		Send, +1
	return

	; if GetKeyState("LShift", "P")
	; 	Send, ^{Space}
	; else
	; {
	; }
	; return

CapsLock & h::
	if GetKeyState("LShift", "P")
		Send, +{Left}
	else
		Send, {Left}
	return

CapsLock & j::
	if GetKeyState("LShift", "P")
		Send, +{Down}
	else
		Send, {Down}
	return

CapsLock & k::
	if GetKeyState("LShift", "P")
		Send, +{Up}
	else
		Send, {Up}
	return

CapsLock & l::
	if GetKeyState("LShift", "P")
		Send, +{Right}
	else
		Send, {Right}
	return

CapsLock & ,::
	if GetKeyState("LShift", "P")
		Send, +{Home}
	else
		Send, {Home}
	return

CapsLock & .::
	if GetKeyState("LShift", "P")
		Send, +{End}
	else
		Send, {End}
	return

CapsLock & p::
	if GetKeyState("LShift", "P")
		Send, +3
	else
		Send, +7
	return

CapsLock & i::
	if GetKeyState("LShift", "P")
		Send, +^{Left}
	else
		Send, ^{Left}
	return

CapsLock & o::
	if GetKeyState("LShift", "P")
		Send, +^{Right}
	else
		Send, ^{Right}
	return

CapsLock & `;::
	if GetKeyState("LShift", "P")
 		Send, -
	else
		Send, _
	return

CapsLock & '::
	if GetKeyState("LShift", "P")
		Send, +=
	else
		Send, =
	return

CapsLock & /::
	if GetKeyState("LShift", "P")
		Send, +\
	else
		Send, \
	return

CapsLock & 9:: 
	if GetKeyState("LShift", "P")
		Send, {{}
	else
		Send, [
	return

CapsLock & 0:: 
	if GetKeyState("LShift", "P")
		Send, {}}
	else
		Send, ]
	return

CapsLock & n:: 
	if GetKeyState("LShift", "P")
		Send, +{Home}{Del}
	else
	{
		; Send, ^{BS}

		Send, ^+{Left}
		; Sleep, 66
		Send, {Del}
		
		; Send, ^{Left}
		; Sleep, 66
		; Send, ^{Del}
	}
	return

CapsLock & m:: 
	if GetKeyState("LShift", "P")
		Send, +{End}{Del}
	else
		Send, ^{Del}
	return

;;==================================================================;;
;;=========================CapsLock's Stuff=========================;;
;;==================================================================;;