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
CapsLock & `:: 
	if GetKeyState("Shift", "P")
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

;;=============================Navigator============================||
;===========================;U = PageDown
;===========================;H = Left
CapsLock & v::
	; if GetKeyState("Shift", "P")
		Send, ^v
	; else
		; PasteCompatibleWithAutoSelectionCopy()
		; Send, +6
	ClickUpIfLbDown()
	return

CapsLock & f::
	if GetKeyState("Shift", "P")
		Send, ^+f
	else
		Send, ^f
	ClickUpIfLbDown()
	return

CapsLock & w:: 
	if GetKeyState("Shift", "P")
		Send, +``  ; wave line : w
	else
		Send, ^a
	return

CapsLock & e::
	if GetKeyState("Shift", "P")
		Send, ^/  ; comment : e
	else
		Send, {Enter}
		; Send, +4
	ClickUpIfLbDown()
	return

CapsLock & x::
	if GetKeyState("Shift", "P")
		Send, +6
	else
		Send, ^x
	ClickUpIfLbDown()
	return

CapsLock & c::
	if GetKeyState("Shift", "P")
		Send, +4
	else
		Send, ^c
	ClickUpIfLbDown()
	return

CapsLock & s::
	if GetKeyState("Shift", "P")
		Send, +^s
	else
		Send, ^s
	ClickUpIfLbDown()
	return

CapsLock & r::  ; redo/undo
	if GetKeyState("Shift", "P")
		Send, ^y
	else
		Send, ^z
	return

CapsLock & Tab:: 
	if GetKeyState("Shift", "P")
		Send, {Ins}
	else
		Send, +{Ins}
	return

CapsLock & d:: 
	if GetKeyState("Shift", "P")
		Send, {BS}
	else
		Send, {Del}
	return

CapsLock & y::
	if GetKeyState("Shift", "P")
		Send, +5
	else
		Send, +8
	return

CapsLock & u::
	if GetKeyState("Shift", "P")
		Send, +2
	else
		Send, +1
	return

	; if GetKeyState("Shift", "P")
	; 	Send, ^{Space}
	; else
	; {
	; 	; store the number of replacements that occurred (0 if none).
	; 	replace_sum := 0
	; 	ClipSaved := ClipboardAll   ; Save the entire clipboard to a variable of your choice.
	; 	; ... here make temporary use of the clipboard, such as for pasting Unicode text via Transform Unicode ...
	; 	Sleep, 66
	; 	Send, ^a
	; 	Sleep, 66
	; 	Send, ^c
	; 	Sleep, 66
	; 	; Read from the array:
	; 	; Loop % Array.MaxIndex()   ; More traditional approach.
	; 	for key, value in StrMap ; Enumeration is the recommended approach in most cases.
	; 	{
	; 		cur_replace_cnt := 0
	; 		; Using "Loop", indices must be consecutive numbers from 1 to the number
	; 		; of elements in the array (or they must be calculated within the loop).
	; 		; MsgBox % "Element number " . A_Index . " is " . Array[A_Index]
	; 		; Using "for", both the index (or "key") and its associated value
	; 		; are provided, and the index can be *any* value of your choosing.
	; 		Clipboard := StrReplace(Clipboard, key, value, cur_replace_cnt)
	; 		replace_sum += cur_replace_cnt
	; 	}
	; 	Sleep, 66
	; 	if replace_sum != 0
	; 		Send, ^v
	; 	else
	; 		Send, {Right}
	; 	Sleep, 66
	; 	Clipboard := ClipSaved   ; Restore the original clipboard. Note the use of Clipboard (not ClipboardAll).
	; 	ClipSaved := ""   ; Free the memory in case the clipboard was very large.
	; }
	; return

CapsLock & h::
	if GetKeyState("Shift", "P")
		Send, +{Left}
	else
		Send, {Left}
	return

CapsLock & j::
	if GetKeyState("Shift", "P")
		Send, +{Down}
	else
		Send, {Down}
	return

CapsLock & k::
	if GetKeyState("Shift", "P")
		Send, +{Up}
	else
		Send, {Up}
	return

CapsLock & l::
	if GetKeyState("Shift", "P")
		Send, +{Right}
	else
		Send, {Right}
	return

CapsLock & ,::
	if GetKeyState("Shift", "P")
		Send, +{Home}
	else
		Send, {Home}
	return

CapsLock & .::
	if GetKeyState("Shift", "P")
		Send, +{End}
	else
		Send, {End}
	return

CapsLock & p::
	if GetKeyState("Shift", "P")
		Send, +3
	else
		Send, +7
	return

CapsLock & i::
	if GetKeyState("Shift", "P")
		Send, +^{Left}
	else
		Send, ^{Left}
	return

CapsLock & o::
	if GetKeyState("Shift", "P")
		Send, +^{Right}
	else
		Send, ^{Right}
	return

CapsLock & `;::
	if GetKeyState("Shift", "P")
 		Send, -
	else
		Send, _
	return

CapsLock & '::
	if GetKeyState("Shift", "P")
		Send, +=
	else
		Send, =
	return

CapsLock & /::
	if GetKeyState("Shift", "P")
		Send, +\
	else
		Send, \
	return

CapsLock & 9:: 
	if GetKeyState("Shift", "P")
		Send, {{}
	else
		Send, [
	return

CapsLock & 0:: 
	if GetKeyState("Shift", "P")
		Send, {}}
	else
		Send, ]
	return

CapsLock & n:: 
	if GetKeyState("Shift", "P")
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
	if GetKeyState("Shift", "P")
		Send, +{End}{Del}
	else
		Send, ^{Del}
	return

;;==================================================================;;
;;=========================CapsLock's Stuff=========================;;
;;==================================================================;;