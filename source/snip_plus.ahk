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

		; ; 如果 FileAppend的Text 为 %ClipboardAll% 或之前接受了 ClipboardAll 赋值的变量, 则用剪贴板的全部内容无条件覆盖 Filename(即不需要 FileDelete).
		; ; 文件扩展名无关紧要. 很奇怪,经测试, 如果没有真的截图则_new_temp_clip_file_size会为一个较小的size, 也就是说没内容写入文件
		FileAppend, %ClipboardAll%, % SnipPlus._TEMP_CLIPBOARD_CONTENT_FILE
		FileGetSize, _new_temp_clip_file_size, % SnipPlus._TEMP_CLIPBOARD_CONTENT_FILE, K

		if (_new_temp_clip_file_size < 6)  ;; 经测试, 小于6KB则说明用户没有截图
		{
			; m(_new_temp_clip_file_size)
			; m(_old_temp_clip_file_size)
			ToolTipWithTimer("Nothing snipped.")
			Clipboard := clipboardOld   ; Restore the original clipboard. Note the use of Clipboard (not ClipboardAll).
			clipboardOld := ""   ; Free the memory in case the clipboard was very large.
			return
		}

		hBM := SnipPlus.CB_hBMP_Get()  
		; if (FileExist(SnipPlus._TEMP_CLIPBOARD_CONTENT_FILE)) {
		Clipboard := clipboardOld   ; Restore the original clipboard. Note the use of Clipboard (not ClipboardAll).
		clipboardOld := ""   ; Free the memory in case the clipboard was very large.

		SnipPlus.temp_snip_img_index += 1
		img_path := SnipPlus._TEMP_SNIP_IMG_DIR SnipPlus._TEMP_SNIP_IMG_PREFIX SnipPlus.temp_snip_img_index ".png"
		
		If (hBM) {
			SnipPlus.GDIP("Startup")
			SnipPlus.SavePicture(hBM, img_path) 
			SnipPlus.GDIP("Shutdown")
			DllCall( "DeleteObject", "Ptr",hBM )
		}       
		if (!FileExist(img_path)) {
			ToolTipWithTimer("Save snipped pic failed.")
			Return
		}

		cur_gui_name := "sux_snipshot_" . SnipPlus.temp_snip_img_index
		Gui, %cur_gui_name%: New
		; Gui %cur_gui_name%:+Resize +AlwaysOnTop -MaximizeBox -MinimizeBox +ToolWindow
		Gui %cur_gui_name%: +AlwaysOnTop
		Gui, Margin, 0, 0

		; CustomColor := "EEAA99"  ; 可以为任意 RGB 颜色(在下面会被设置为透明).
		; ; CustomColor := "White"  ; 可以为任意 RGB 颜色(在下面会被设置为透明).
		; Gui +LastFound  ; 避免显示任务栏按钮和 alt-tab 菜单项.
		; Gui, Color, %CustomColor%
		; WinSet, TransColor, Off
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
		final_x := Mouse_x - 88
		final_y := Mouse_y - 8
		Gui, Show, x%final_x% y%final_y%, % SnipPlus.temp_snip_img_index
		; Gui, Show
	}


	;; https://www.autohotkey.com/boards/viewtopic.php?t=67716
	CB_hBMP_Get() {  ;;                                                  ; By SKAN on D293 @ bit.ly/2L81pmP
		Local OK := [0,0,0,0]
			OK.1 := DllCall( "OpenClipboard", "Ptr",0 )
		OK.2 := OK.1 ? DllCall( "IsClipboardFormatAvailable", "UInt",8 ) : 0  ; CF_BITMAP
		OK.3 := OK.2 ? DllCall( "GetClipboardData", "UInt", 2, "Ptr" )   : 0
		OK.4 := OK.1 ? DllCall( "CloseClipboard" ) : 0  
		Return OK.3 ? DllCall( "CopyImage", "Ptr",OK.3, "Int",0, "Int",0, "Int",0, "UInt",0x200C, "Ptr" )
				+ ( ErrorLevel := 0 ) : ( ErrorLevel := !OK.2 ? 1 : 2 ) >> 2          
	}

	SavePicture(hBM, sFile) {
		Local V,  pBM := VarSetCapacity(V,16,0)>>8,  Ext := LTrim(SubStr(sFile,-3),"."),  E := [0,0,0,0]
		Local Enc := 0x557CF400 | Round({"bmp":0, "jpg":1,"jpeg":1,"gif":2,"tif":5,"tiff":5,"png":6}[Ext])
		E[1] := DllCall("gdi32\GetObjectType", "Ptr",hBM ) <> 7
		E[2] := E[1] ? 0 : DllCall("gdiplus\GdipCreateBitmapFromHBITMAP", "Ptr",hBM, "UInt",0, "PtrP",pBM)
		NumPut(0x2EF31EF8,NumPut(0x0000739A,NumPut(0x11D31A04,NumPut(Enc+0,V,"UInt"),"UInt"),"UInt"),"UInt")
		E[3] := pBM ? DllCall("gdiplus\GdipSaveImageToFile", "Ptr",pBM, "WStr",sFile, "Ptr",&V, "UInt",0) : 1
		E[4] := pBM ? DllCall("gdiplus\GdipDisposeImage", "Ptr",pBM) : 1
		Return E[1] ? 0 : E[2] ? -1 : E[3] ? -2 : E[4] ? -3 : 1  
	} 

	GDIP(C:="Startup") {
		Static SI:=Chr(!(VarSetCapacity(Si,24,0)>>16)), pToken:=0, hMod:=0, Res:=0, AOK:=0
		If (AOK := (C="Startup" and pToken=0) Or (C<>"Startup" and pToken<>0))  {
			If (C="Startup") {
					hMod := DllCall("LoadLibrary", "Str","gdiplus.dll", "Ptr")
					Res  := DllCall("gdiplus\GdiplusStartup", "PtrP",pToken, "Ptr",&SI, "UInt",0)
			} Else { 
					Res  := DllCall("gdiplus\GdiplusShutdown", "Ptr",pToken )
					DllCall("FreeLibrary", "Ptr",hMod),   hMod:=0,   pToken:=0
		}}  
		Return (AOK ? !Res : Res:=0)    
	}
}



SUB_CLICK_SNIP_IMG:
	Gui +LastFound  ; 
	WinGet, cur_transparent_level, Transparent
	if (cur_transparent_level < 255)
		WinSet, Transparent, 255
	else
		WinSet, Transparent, 22

	; CustomColor := "EEAA99"  ; 可以为任意 RGB 颜色(在下面会被设置为透明).
	; ; CustomColor := "White"  ; 可以为任意 RGB 颜色(在下面会被设置为透明).
	; Gui +LastFound  ; 避免显示任务栏按钮和 alt-tab 菜单项.
	; ; Gui, Color, %CustomColor%
	; WinSet, TransColor, Off
	; WinSet, TransColor, %CustomColor% 150

	; Gui +LastFound  ; 
	; MouseGetPos, MouseX, MouseY
	; PixelGetColor, MouseRGB, %MouseX%, %MouseY%, RGB
	; ; 似乎有必要首先关闭任何现有的透明度:
	; WinSet, TransColor, Off
	; WinSet, TransColor, %MouseRGB%
	
	; MouseGetPos, MouseX, MouseY, MouseWin
	; PixelGetColor, MouseRGB, %MouseX%, %MouseY%, RGB
	; ; 似乎有必要首先关闭任何现有的透明度:
	; WinSet, TransColor, Off, ahk_id %MouseWin%
	; WinSet, TransColor, %MouseRGB% 66, ahk_id %MouseWin%

	Return
