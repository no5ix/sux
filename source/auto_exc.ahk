; ; Note: Save with encoding UTF-8 with BOM if possible.
; ; Notepad will save UTF-8 files with BOM automatically (even though it does not say so).
; ; Some editors however save without BOM, and then special characters look messed up in the AHK GUI.


; #Persistent 				; Keeps script running persisitantly 
if enable_hot_corners
	SetTimer, HotCorners, 66
