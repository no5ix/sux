; ; Note: Save with encoding UTF-8 with BOM if possible.
; ; Notepad will save UTF-8 files with BOM automatically (even though it does not say so).
; ; Some editors however save without BOM, and then special characters look messed up in the AHK GUI.

; ; git update-index --assume-unchanged <file>
; ; git update-index --no-assume-unchanged <file>
; ; git ls-files -v | grep '^h'. 


; ---------------------------------------------------------------------o
; 					override default override color code definitions conf
; ---------------------------------------------------------------------o


; ---------------------------------------------------------------------o
; 					override default override theme conf
; ---------------------------------------------------------------------o

; ; ; dark theme
; global nox_width := 620
; global nox_text_color := cWhite
; global nox_margin_x := 0
; global nox_margin_y := 0
; global nox_bg_color := "424242"
; global nox_control_color := "616161"
; global nox_border_shadow_type := classic_shadow_type

; ; ; light theme 
; global nox_width := 620
; global nox_text_color := cBlack
; global nox_margin_x := 0
; global nox_margin_y := 0
; global nox_bg_color := "ececec"
; global nox_control_color := "d9d9d9"
; global nox_border_shadow_type := modern_shadow_type


; ---------------------------------------------------------------------o
; 					override default override general conf 
; ---------------------------------------------------------------------o


; ; visual studio code path(e.g. "C:\Users\xxxx\AppData\Local\Programs\Microsoft VS Code\Code.exe")
; ; if blank, leave a ugly cmd window after input cmd `proj`(open nox project with vscode).
; global vscode_path := ""
; global music_app_path := ""

; global disable_win10_auto_update := 1

; global enable_hot_edges := 0  ; when ctrl+8 on the edge (useful for touchpad user)



; ---------------------------------------------------------------------o
; 					override default override replace str map conf  ( Capslock+Shift+U )
; ---------------------------------------------------------------------o


; ---------------------------------------------------------------------o
; 					override default override web search url conf  
; ---------------------------------------------------------------------o


; ---------------------------------------------------------------------o
; 					override default Everything shortCut conf  
; ---------------------------------------------------------------------o

user_EverythingShortCut(){
	; Send, ^!+e
	return 0
}

; ---------------------------------------------------------------------o
; 					override default double click conf  
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
; 					override default hot corners conf  
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