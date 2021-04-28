; ; Note: Save with encoding UTF-8 with BOM if possible.
; ; Notepad will save UTF-8 files with BOM automatically (even though it does not say so).
; ; Some editors however save without BOM, and then special characters look messed up in the AHK GUI.

#Include %A_ScriptDir%\source\sux_core.ahk


; Screen Capture
class SnipPlus
{
	static temp_snip_img_index := 0
	static _TEMP_SNIP_IMG_DIR := "app_data\temp_snip_dir\"
	static _TEMP_SNIP_IMG_PREFIX := "temp_snip_"
	static _TEMP_CLIPBOARD_CONTENT_FILE := SnipPlus._TEMP_SNIP_IMG_DIR . "temp_clipboard_content.clip"


	init()
	{
		SuxCore.OnExit("SnipPlus.ClearTempImg")
		SnipPlus.ClearTempImg()
	}

	ClearTempImg()
	{
		FileRemoveDir, % SnipPlus._TEMP_SNIP_IMG_DIR, 1
		FileCreateDir, % SnipPlus._TEMP_SNIP_IMG_DIR
	}

	AreaScreenShot()
	{
		prscrn_param = %A_ScriptDir%\app_data\prscrn.dll\PrScrn
		DllCall(prscrn_param)
	}

	AreaScreenShotAndSuspend()
	{
		; if (FileExist(SnipPlus._TEMP_CLIPBOARD_CONTENT_FILE)) {
		; 	FileGetSize, _old_temp_clip_file_size, % SnipPlus._TEMP_CLIPBOARD_CONTENT_FILE
		; 	; FileDelete, % SnipPlus._TEMP_CLIPBOARD_CONTENT_FILE
		; }
		; else {
		; 	_old_temp_clip_file_size := 0
		; }

		clipboardOld := ClipboardAll
		SnipPlus.AreaScreenShot()
		; ClipWait, 2
		; 如果 FileAppend的Text 为 %ClipboardAll% 或之前接受了 ClipboardAll 赋值的变量, 则用剪贴板的全部内容无条件覆盖 Filename(即不需要 FileDelete).
		 ; 文件扩展名无关紧要. 很奇怪,经测试, 如果没有真的截图则_new_temp_clip_file_size会为0, 也就是说没内容写入文件
		FileAppend, %ClipboardAll%, % SnipPlus._TEMP_CLIPBOARD_CONTENT_FILE
		FileGetSize, _new_temp_clip_file_size, % SnipPlus._TEMP_CLIPBOARD_CONTENT_FILE

			; m(_old_temp_clip_file_size)
			; m(_new_temp_clip_file_size)
		; if (_new_temp_clip_file_size == _old_temp_clip_file_size)
		; ToolTipWithTimer(_new_temp_clip_file_size)
		if (_new_temp_clip_file_size == 0)
		{
			; m(_new_temp_clip_file_size)
			; m(_old_temp_clip_file_size)
			return
		}

		SnipPlus.temp_snip_img_index += 1
		img_path := SnipPlus._TEMP_SNIP_IMG_DIR SnipPlus._TEMP_SNIP_IMG_PREFIX SnipPlus.temp_snip_img_index ".png"
		SnipPlus.Convert(ClipboardAll, img_path)
		
		; if (FileExist(SnipPlus._TEMP_CLIPBOARD_CONTENT_FILE)) {
		Clipboard := clipboardOld   ; Restore the original clipboard. Note the use of Clipboard (not ClipboardAll).
		clipboardOld := ""   ; Free the memory in case the clipboard was very large.

		if (!FileExist(img_path)) {
			; m("not exi")
			Return
		}

		cur_gui_name := "sux_snipshot_" . SnipPlus.temp_snip_img_index
		Gui, %cur_gui_name%: New
		; Gui %cur_gui_name%:+Resize +AlwaysOnTop -MaximizeBox -MinimizeBox +ToolWindow
		Gui %cur_gui_name%: +AlwaysOnTop
		Gui, Margin, 0, 0

		; CustomColor := "EEAA99"  ; 可以为任意 RGB 颜色(在下面会被设置为透明).
		; Gui +LastFound  ; 避免显示任务栏按钮和 alt-tab 菜单项.
		; Gui, Color, %CustomColor%
		; WinSet, TransColor, %CustomColor% 150

		; Gui +LastFound  ; 
		; WinSet, Transparent, 50

		Gui, Add, Picture, gSUB_CLICK_SNIP_IMG, % img_path
		
		; Menu, FileMenu, Add, &Open`tCtrl+O, Sub_xMenu_Open  ; 关于 Ctrl+O 请参阅后面的备注.
		; Menu, FileMenu, Add, E&xit, Sub_xMenu_Open
		; Menu, HelpMenu, Add, &About, Sub_xMenu_Open
		; Menu, MyMenuBar, Add, &File, :FileMenu  ; 附加上面的两个子菜单.
		; Menu, MyMenuBar, Add, &Help, :HelpMenu
		; Gui, Menu, MyMenuBar

		GuiControl, Focus, Close
		MouseGetPos, Mouse_x, Mouse_y
		Gui, Show, x%Mouse_x% y%Mouse_y%, % SnipPlus.temp_snip_img_index
		; Gui, Show
	}

	;; 不推荐用这个, 透明的也母鸡到底是截了哪儿
	CaptureScreenwithTransparentWindowsAndMouseCursor(aRect = 0, bCursor = False, sFile = "")
	{
		If	!aRect
		{
			SysGet, Mon, Monitor, 1
			nL := MonLeft
			nT := MonTop
			nW := MonRight - MonLeft
			nH := MonBottom - MonTop
		}
		Else If	aRect = 1
			WinGetPos, nL, nT, nW, nH, A
		Else If	aRect = 2
		{
			WinGet, hWnd, ID, A
			VarSetCapacity(rt, 16, 0)
			DllCall("GetClientRect" , "Uint", hWnd, "Uint", &rt)
			DllCall("ClientToScreen", "Uint", hWnd, "Uint", &rt)
			nL := NumGet(rt, 0, "int")
			nT := NumGet(rt, 4, "int")
			nW := NumGet(rt, 8)
			nH := NumGet(rt,12)
		}
		Else If	aRect = 3
		{
			MouseGetPos, x1, y1
			Sleep, 5000
			MouseGetPos, x2, y2
			nL := x1
			nT := y1
			nW := x2 - x1
			nH := y2 - y1
		}
		Else
		{
			StringSplit, rt, aRect, `,, %A_Space%%A_Tab%
			nL := rt1
			nT := rt2
			nW := rt3 - rt1
			nH := rt4 - rt2
			znW := rt5
			znH := rt6
		}

		mDC := DllCall("CreateCompatibleDC", "Uint", 0)
		hBM := SnipPlus.CreateDIBSection(mDC, nW, nH)
		oBM := DllCall("SelectObject", "Uint", mDC, "Uint", hBM)
		hDC := DllCall("GetDC", "Uint", 0)
		DllCall("BitBlt", "Uint", mDC, "int", 0, "int", 0, "int", nW, "int", nH, "Uint", hDC, "int", nL, "int", nT, "Uint", 0x40000000 | 0x00CC0020)
		DllCall("ReleaseDC", "Uint", 0, "Uint", hDC)
		If	bCursor
			SnipPlus.CaptureCursor(mDC, nL, nT)
		DllCall("SelectObject", "Uint", mDC, "Uint", oBM)
		DllCall("DeleteDC", "Uint", mDC)
		If	znW && znH
			hBM := SnipPlus.Zoomer(hBM, nW, nH, znW, znH)
		If	sFile = 0
			SnipPlus.SetClipboardData(hBM)
		Else	SnipPlus.Convert(hBM, sFile), DllCall("DeleteObject", "Uint", hBM)
	}

	CaptureCursor(hDC, nL, nT)
	{
		VarSetCapacity(mi, 20, 0)
		mi := Chr(20)
		DllCall("GetCursorInfo", "Uint", &mi)
		bShow   := NumGet(mi, 4)
		hCursor := NumGet(mi, 8)
		xCursor := NumGet(mi,12)
		yCursor := NumGet(mi,16)

		VarSetCapacity(ni, 20, 0)
		DllCall("GetIconInfo", "Uint", hCursor, "Uint", &ni)
		xHotspot := NumGet(ni, 4)
		yHotspot := NumGet(ni, 8)
		hBMMask  := NumGet(ni,12)
		hBMColor := NumGet(ni,16)

		If	bShow
			DllCall("DrawIcon", "Uint", hDC, "int", xCursor - xHotspot - nL, "int", yCursor - yHotspot - nT, "Uint", hCursor)
		If	hBMMask
			DllCall("DeleteObject", "Uint", hBMMask)
		If	hBMColor
			DllCall("DeleteObject", "Uint", hBMColor)
	}

	Zoomer(hBM, nW, nH, znW, znH)
	{
		mDC1 := DllCall("CreateCompatibleDC", "Uint", 0)
		mDC2 := DllCall("CreateCompatibleDC", "Uint", 0)
		zhBM := SnipPlus.CreateDIBSection(mDC2, znW, znH)
		oBM1 := DllCall("SelectObject", "Uint", mDC1, "Uint",  hBM)
		oBM2 := DllCall("SelectObject", "Uint", mDC2, "Uint", zhBM)
		DllCall("SetStretchBltMode", "Uint", mDC2, "int", 4)
		DllCall("StretchBlt", "Uint", mDC2, "int", 0, "int", 0, "int", znW, "int", znH, "Uint", mDC1, "int", 0, "int", 0, "int", nW, "int", nH, "Uint", 0x00CC0020)
		DllCall("SelectObject", "Uint", mDC1, "Uint", oBM1)
		DllCall("SelectObject", "Uint", mDC2, "Uint", oBM2)
		DllCall("DeleteDC", "Uint", mDC1)
		DllCall("DeleteDC", "Uint", mDC2)
		DllCall("DeleteObject", "Uint", hBM)
		Return	zhBM
	}

	Convert(sFileFr = "", sFileTo = "")
	{
		If	sFileTo  =
			sFileTo := A_ScriptDir . "\screen.bmp"
		SplitPath, sFileTo, , sDirTo, sExtTo, sNameTo

		If Not	hGdiPlus := DllCall("LoadLibrary", "str", "gdiplus.dll")
			Return	sFileFr+0 ? SnipPlus.SaveHBITMAPToFile(sFileFr, sDirTo . "\" . sNameTo . ".bmp") : ""
		VarSetCapacity(si, 16, 0), si := Chr(1)
		DllCall("gdiplus\GdiplusStartup", "UintP", pToken, "Uint", &si, "Uint", 0)

		If	!sFileFr
		{
			DllCall("OpenClipboard", "Uint", 0)
			If	 DllCall("IsClipboardFormatAvailable", "Uint", 2) && (hBM:=DllCall("GetClipboardData", "Uint", 2))
			DllCall("gdiplus\GdipCreateBitmapFromHBITMAP", "Uint", hBM, "Uint", 0, "UintP", pImage)
			DllCall("CloseClipboard")
		}
		Else If	sFileFr Is Integer
			DllCall("gdiplus\GdipCreateBitmapFromHBITMAP", "Uint", sFileFr, "Uint", 0, "UintP", pImage)
		Else	DllCall("gdiplus\GdipLoadImageFromFile", "Uint", SnipPlus.Unicode4Ansi(wFileFr,sFileFr), "UintP", pImage)

		DllCall("gdiplus\GdipGetImageEncodersSize", "UintP", nCount, "UintP", nSize)
		VarSetCapacity(ci, nSize)
		DllCall("gdiplus\GdipGetImageEncoders", "Uint", nCount, "Uint", nSize, "Uint", &ci)
		Loop,	%nCount%
		{
			If	!InStr(SnipPlus.Ansi4Unicode(NumGet(ci, 76 * (A_Index - 1) + 44)), "." . sExtTo)
				Continue
			pCodec := &ci + 76 * (A_Index - 1)
				Break
		}

		If	pImage
			pCodec	? DllCall("gdiplus\GdipSaveImageToFile", "Uint", pImage, "Uint", SnipPlus.Unicode4Ansi(wFileTo,sFileTo), "Uint", pCodec, "Uint", 0) : DllCall("gdiplus\GdipCreateHBITMAPFromBitmap", "Uint", pImage, "UintP", hBitmap, "Uint", 0) . SnipPlus.SetClipboardData(hBitmap), DllCall("gdiplus\GdipDisposeImage", "Uint", pImage)

		DllCall("gdiplus\GdiplusShutdown" , "Uint", pToken)
		DllCall("FreeLibrary", "Uint", hGdiPlus)
	}

	CreateDIBSection(hDC, nW, nH, bpp = 32, ByRef pBits = "")
	{
		NumPut(VarSetCapacity(bi, 40, 0), bi)
		NumPut(nW, bi, 4)
		NumPut(nH, bi, 8)
		NumPut(bpp, NumPut(1, bi, 12, "UShort"), 0, "Ushort")
		NumPut(0,  bi,16)
		Return	DllCall("gdi32\CreateDIBSection", "Uint", hDC, "Uint", &bi, "Uint", 0, "UintP", pBits, "Uint", 0, "Uint", 0)
	}

	SaveHBITMAPToFile(hBitmap, sFile)
	{
		DllCall("GetObject", "Uint", hBitmap, "int", VarSetCapacity(oi,84,0), "Uint", &oi)
		hFile:=	DllCall("CreateFile", "Uint", &sFile, "Uint", 0x40000000, "Uint", 0, "Uint", 0, "Uint", 2, "Uint", 0, "Uint", 0)
		DllCall("WriteFile", "Uint", hFile, "int64P", 0x4D42|14+40+NumGet(oi,44)<<16, "Uint", 6, "UintP", 0, "Uint", 0)
		DllCall("WriteFile", "Uint", hFile, "int64P", 54<<32, "Uint", 8, "UintP", 0, "Uint", 0)
		DllCall("WriteFile", "Uint", hFile, "Uint", &oi+24, "Uint", 40, "UintP", 0, "Uint", 0)
		DllCall("WriteFile", "Uint", hFile, "Uint", NumGet(oi,20), "Uint", NumGet(oi,44), "UintP", 0, "Uint", 0)
		DllCall("CloseHandle", "Uint", hFile)
	}

	SetClipboardData(hBitmap)
	{
		DllCall("GetObject", "Uint", hBitmap, "int", VarSetCapacity(oi,84,0), "Uint", &oi)
		hDIB :=	DllCall("GlobalAlloc", "Uint", 2, "Uint", 40+NumGet(oi,44))
		pDIB :=	DllCall("GlobalLock", "Uint", hDIB)
		DllCall("RtlMoveMemory", "Uint", pDIB, "Uint", &oi+24, "Uint", 40)
		DllCall("RtlMoveMemory", "Uint", pDIB+40, "Uint", NumGet(oi,20), "Uint", NumGet(oi,44))
		DllCall("GlobalUnlock", "Uint", hDIB)
		DllCall("DeleteObject", "Uint", hBitmap)
		DllCall("OpenClipboard", "Uint", 0)
		DllCall("EmptyClipboard")
		DllCall("SetClipboardData", "Uint", 8, "Uint", hDIB)
		DllCall("CloseClipboard")
	}

	Unicode4Ansi(ByRef wString, sString)
	{
		nSize := DllCall("MultiByteToWideChar", "Uint", 0, "Uint", 0, "Uint", &sString, "int", -1, "Uint", 0, "int", 0)
		VarSetCapacity(wString, nSize * 2)
		DllCall("MultiByteToWideChar", "Uint", 0, "Uint", 0, "Uint", &sString, "int", -1, "Uint", &wString, "int", nSize)
		Return	&wString
	}

	Ansi4Unicode(pString)   
	{
		nSize := DllCall("WideCharToMultiByte", "Uint", 0, "Uint", 0, "Uint", pString, "int", -1, "Uint", 0, "int",  0, "Uint", 0, "Uint", 0)
		VarSetCapacity(sString, nSize)
		DllCall("WideCharToMultiByte", "Uint", 0, "Uint", 0, "Uint", pString, "int", -1, "str", sString, "int", nSize, "Uint", 0, "Uint", 0)
		Return	sString
	}   
}



SUB_CLICK_SNIP_IMG:
	; m("clikkkkkkk")
	Gui +LastFound  ; 
	WinGet, cur_transparent_level, Transparent
	if (cur_transparent_level < 255)
		WinSet, Transparent, 255
	else
		WinSet, Transparent, 22
	Return


; SUB_SNIP_FULL_SCREEN:
; ; #n::
; 	Name=%A_Now%
; 	SnipPlus.CaptureScreenwithTransparentWindowsAndMouseCursor(0,0,"Screen.PNG")
; 	FileMove, Screen.PNG,E:\My Documents\My Pictures\Screenshots\%Name%.PNG
; 	SnipPlus.Convert(ClipboardAll, "Screen1.PNG")
; 	Return


; SUB_SNIP_AREA:
; ; #j::
; 	CoordMode, Mouse, Screen
; 	SnipPlus.CaptureScreenwithTransparentWindowsAndMouseCursor(3,0,"Screen.PNG")
; 	Name=%A_Now%
; 	FileMove, Screen.PNG,E:\My Documents\My Pictures\Screenshots\%Name%.PNG
; 	CoordMode, Mouse, Relative
; 	Return