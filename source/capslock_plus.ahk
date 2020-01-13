; ; Note: Save with encoding UTF-8 with BOM if possible.
; ; Notepad will save UTF-8 files with BOM automatically (even though it does not say so).
; ; Some editors however save without BOM, and then special characters look messed up in the AHK GUI.


;;==================================================================;;
;;=========================CapsLock's Stuff=========================;;
;;==================================================================;;
;; 请某些忽略注释, 代码重新写了, 某些注释是旧的
; SetCapsLockState, AlwaysOff  ; 如果是跟Host.ahk一起用, 不能写这里, 要写Host.ahk里

; CapsLock::Send, {ESC}                  ; Vimer's love	Capslock = {ESC}


;-------------------------------------------------------------------------------
; LAUNCH GUI
;-------------------------------------------------------------------------------
CapsLock & x::
if getkeystate("shift")
    gui_spawn()
return


#Persistent
CapsLock::
if enable_double_click_capslock = 0
{
    Send, {ESC}
    return
}
if caps_press_cnt > 0 ; SetTimer 已经启动，所以我们记录按键。
{
    caps_press_cnt += 1
    return
}

; 否则，这是新一系列按键的首次按键。将计数设为 1 并启动定时器：
caps_press_cnt = 1
SetTimer, CapsTimerFunc, 200 ; 在 x 毫秒内等待更多的按键。
return

CapsTimerFunc:
SetTimer, CapsTimerFunc, off
if caps_press_cnt = 1 ; 该键已按过一次。
{
    Gosub singleCapsClick
	; ToolTip, 1
}
else if caps_press_cnt = 2 ; 该键已按过一次。
{
    Gosub doubleCapsClick
	; ToolTip, 2
}

; 不论上面哪个动作被触发，将计数复位以备下一系列的按键：
caps_press_cnt = 0
return

singleCapsClick:
	Send, {ESC}
    return

doubleCapsClick:
    DoubleClickCapsTrigger()
    return



;=====================================================================o
;                       CapsLock Switcher:                           ;|
;---------------------------------o-----------------------------------o
;                    CapsLock + ` | {CapsLock}                       ;|
;---------------------------------o-----------------------------------o
CapsLock & Tab::                                                       ;|
GetKeyState, CapsLockState, CapsLock, T                              ;|
if CapsLockState = D                                                 ;|
    SetCapsLockState, AlwaysOff                                      ;|
else                                                                 ;|
    SetCapsLockState, AlwaysOn                                       ;|
KeyWait, ``                                                          ;|
return                                                               ;|
;---------------------------------------------------------------------o

;;=============================Navigator============================||
;===========================;U = PageDown
;===========================;H = Left
CapsLock & f::
if getkeystate("shift") = 0
    Send, ^v
else
	PasteCompatibleWithAutoSelectionCopy()
ClickUpIfLbDown()
return

CapsLock & e::
    Send, {Enter}
return

CapsLock & w::
if getkeystate("shift") = 0
    Send, ^c
else
    Send, ^x
ClickUpIfLbDown()
return

CapsLock & s::
    Send, ^s
    ClickUpIfLbDown()
return

CapsLock & u::
if getkeystate("shift") = 0
    Send, ^{Space}
else
{
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
return

CapsLock & Ins::
if getkeystate("shift") = 0
Send, +``
else
Send, +8
return

CapsLock & h::
if getkeystate("shift") = 0
Send, {Left}
else
Send, +{Left}
return

CapsLock & j::
if getkeystate("shift") = 0
Send, {Down}
else
Send, +{Down}
return

CapsLock & k::
if getkeystate("shift") = 0
Send, {Up}
else
Send, +{Up}
return

CapsLock & l::
if getkeystate("shift") = 0
Send, {Right}
else
Send, +{Right}
return

CapsLock & ,::
if getkeystate("shift") = 0
Send, {Home}
else
Send, +{Home}
return

CapsLock & .::
if getkeystate("shift") = 0
Send, {End}
else
Send, +{End}
return

CapsLock & r::  ; redo/undo
if getkeystate("shift") = 0
Send, ^z
else
Send, ^y
return

CapsLock & p::
if getkeystate("shift") = 0
Send, +7
else
Send, +3
return

CapsLock & y::
if getkeystate("shift") = 0
Send, +1
else
Send, +2
return

CapsLock & i::
if getkeystate("shift") = 0
Send, ^{Left}
else
Send, +^{Left}
return

CapsLock & o::
if getkeystate("shift") = 0
Send, ^{Right}
else
Send, +^{Right}
return

CapsLock & `;::
if getkeystate("shift") = 0
Send, _
else
Send, -
return

CapsLock & '::
if getkeystate("shift") = 0
Send, =
else
Send, +=
return

CapsLock & /::
if getkeystate("shift") = 0
Send, \
else
Send, +\
return

CapsLock & 9:: 
if getkeystate("shift") = 0
Send, [
else
Send, {{}
return

CapsLock & 0:: 
if getkeystate("shift") = 0
Send, ]
else
Send, {}}
return

CapsLock & n:: 
if getkeystate("shift") = 0
{
    ; Send, ^{BS}
    Send, ^+{Left}
    Send, {Del}
}
else
Send, +{Home}{Del}
return

CapsLock & m:: 
if getkeystate("shift") = 0
Send, ^{Del}
else
Send, +{End}{Del}
return

CapsLock & d:: 
if getkeystate("shift") = 0
Send, {Del}
else
Send, {BS}
return

;;==================================================================;;
;;=========================CapsLock's Stuff=========================;;
;;==================================================================;;