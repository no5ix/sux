; ; Note: Save with encoding UTF-8 with BOM if possible.
; ; Notepad will save UTF-8 files with BOM automatically (even though it does not say so).
; ; Some editors however save without BOM, and then special characters look messed up in the AHK GUI.

; ; git update-index --assume-unchanged <file>
; ; git update-index --no-assume-unchanged <file>
; ; git ls-files -v | grep '^h'. 


; ---------------------------------------------------------------------o
; 					override color code definitions default conf
; ---------------------------------------------------------------------o



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

EverythingShortCut(){
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

user_user_HotCornersTopLeftTrigger(){
	return 0
}
user_user_HotCornersTopRightTrigger(){
	return 0
}
user_HotCornersBottomLeftTrigger(){
	return 0
}
user_HotCornersBottomRightTrigger(){
	return 0
}