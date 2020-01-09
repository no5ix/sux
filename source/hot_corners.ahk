; ; Note: Save with encoding UTF-8 with BOM if possible.
; ; Notepad will save UTF-8 files with BOM automatically (even though it does not say so).
; ; Some editors however save without BOM, and then special characters look messed up in the AHK GUI.


#Persistent 				; Keeps script running persisitantly 
if enable_hot_corners
	SetTimer, HotCorners, 66 		; HotCorners is name of timer, will be reset every 0 seconds until process is killed


HotCorners() {				; Timer content 
	CoordMode, Mouse, Screen		; Coordinate mode - coords will be passed to mouse related functions, with coords relative to entire screen 

	; if IsCorner("IsOnTop"){
	; 	LButtonDown := GetKeyState("LButton","P")
	; 	if LButtonDown
	; 		return
	; 	HotEdgesTopTrigger()
	; 	Loop 
	; 	{
	; 		if ! IsCorner("IsOnTop")
	; 			break ; exits loop when mouse is no longer in the corner
	; 	}
	; 	return
	; }


	if IsCorner("TopLeft")
	{
		HotCornersTopLeftTrigger()
		Loop 
		{
			if ! IsCorner("TopLeft")
				break ; exits loop when mouse is no longer in the corner
		}
		return
	}

	if IsCorner("TopRight")
	{	
		HotCornersTopRightTrigger()
		Loop
		{
			if ! IsCorner("TopRight")
				break ; exits loop when mouse is no longer in the corner
		}	
		return
	}

	if IsCorner("BottomLeft")
	{	
		HotCornersBottomLeftTrigger()
		Loop
		{
			if ! IsCorner("BottomLeft")
				break ; exits loop when mouse is no longer in the corner
		}	
		return
	}

	if IsCorner("BottomRight")
	{	
		HotCornersBottomRightTrigger()
		Loop
		{
			if ! IsCorner("BottomRight")
				break ; exits loop when mouse is no longer in the corner
		}	
		return
	}
}