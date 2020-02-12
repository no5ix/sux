; ; Note: Save with encoding UTF-8 with BOM if possible.
; ; Notepad will save UTF-8 files with BOM automatically (even though it does not say so).
; ; Some editors however save without BOM, and then special characters look messed up in the AHK GUI.

; ; git update-index --assume-unchanged <file>
; ; git update-index --no-assume-unchanged <file>
; ; git ls-files -v | grep '^h'. 


; ---------------------------------------------------------------------o
; 					override color code definitions default conf
; ---------------------------------------------------------------------o

; global enable_hot_edges := 1  ; when right/middle mouse click or ctrl+8 on the edge (useful for touchpad user)
; global use_touchpad := 1  ; if u use touchpad, try ctrl+8(or double click it) / double click right mouse

; ; visual studio code path(e.g. "C:\Users\xxxx\AppData\Local\Programs\Microsoft VS Code\Code.exe")
; ; if blank, leave a ugly cmd window after open vsc.
; global vscode_path := "C:\Program Files\Microsoft VS Code\Code.exe"
; global music_app_path := "C:\Program Files (x86)\Netease\CloudMusic\cloudmusic.exe"


; ---------------------------------------------------------------------o
; 					override theme default conf
; ---------------------------------------------------------------------o



; ---------------------------------------------------------------------o
; 					override general default conf 
; ---------------------------------------------------------------------o



; ---------------------------------------------------------------------o
; 					override replace str map default conf  ( Capslock+Shift+U )
; ---------------------------------------------------------------------o



; ---------------------------------------------------------------------o
; 					override web search url default conf  
; ---------------------------------------------------------------------o





; ---------------------------------------------------------------------o
; 					Everything shortCut conf  
; ---------------------------------------------------------------------o

user_EverythingShortCut(){
	; Send, ^!+e
	return 0
}

; ---------------------------------------------------------------------o
; 					double click conf  
; ---------------------------------------------------------------------o

user_DoubleClickShiftTrigger(){
	return 0
}
user_DoubleClickAltTrigger(){
	return 0
}
user_DoubleClickCtrlTrigger(){
	return 0
}


; ---------------------------------------------------------------------o
; 					hot corners conf  
; ---------------------------------------------------------------------o

user_HotCornersTopLeftTrigger(){
	; Send, ^+{Tab}
	; return 1
	return 0
}
user_HotCornersTopRightTrigger(){
	; Send, ^{Tab}
	; return 1
	return 0
}
user_HotCornersBottomLeftTrigger(){
	; Send, {LWin}
	; return 1
	return 0
}
user_HotCornersBottomRightTrigger(){
	return 0
}