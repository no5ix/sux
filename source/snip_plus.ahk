; ; Note: Save with encoding UTF-8 with BOM if possible.
; ; Notepad will save UTF-8 files with BOM automatically (even though it does not say so).
; ; Some editors however save without BOM, and then special characters look messed up in the AHK GUI.



if(A_ScriptName=="snip_plus.ahk") {
	ExitApp
}


SnipSuspendScreenShotImage =

; with this label, you can include this file on top of the file
Goto, SUB_SNIP_PLUS_FILE_END_LABEL

#Include %A_ScriptDir%\source\sux_core.ahk
#Include %A_ScriptDir%\source\util.ahk


; Screen Capture
class SnipPlus
{
	static old_clipboard_content =
	static temp_snip_img_index := 0
	static _TEMP_SNIP_IMG_PREFIX := "temp_snip_"

	static IMG_PATH_2_RATIO_MAP := {}  ;; 截图路径: 截图长宽比例

	init()
	{

	}

	GetCurSnipImgPath()
	{
		Return SuxCore._CACHE_DIR . SnipPlus._TEMP_SNIP_IMG_PREFIX . SnipPlus.temp_snip_img_index . ".png"
	}

	AreaScreenShot()
	{
		prscrn_param = %A_ScriptDir%\app_data\prscrn.dll\PrScrn
		; prscrn_param = %A_ScriptDir%\app_data\TXGYMailCamera.dll\CameraWindow
		; prscrn_param = %A_ScriptDir%\app_data\PrScrn2.dll\PrScrn
		DllCall(prscrn_param)
	}

	AreaScreenShotAndSuspend(with_menu=0)
	{
    	ClipboardChangeCmdMgr.disable_all_clip_change_func()
		SnipPlus.old_clipboard_content := ClipboardAll
		Clipboard := ""

		SnipPlus.AreaScreenShot()

		hBM := CB_hBMP_Get()  
		
		Clipboard := SnipPlus.old_clipboard_content   ; Restore the original clipboard. Note the use of Clipboard (not ClipboardAll).
		SnipPlus.old_clipboard_content := ""   ; Free the memory in case the clipboard was very large.
    	ClipboardChangeCmdMgr.enable_all_clip_change_func()

		SnipPlus.temp_snip_img_index += 1
		img_path := SnipPlus.GetCurSnipImgPath()
		
		If (hBM) {
			GDIP("Startup")
			SavePicture(hBM, img_path) 
			GDIP("Shutdown")
			DllCall( "DeleteObject", "Ptr",hBM )
		}       
		if (FileExist(img_path)) {
			if (with_menu) {
				try {
					Menu, SnipPlus_Menu, DeleteAll
				}
				Menu, SnipPlus_Menu, Add, % lang("Suspend"), Sub_SnipPlus_Menu_clik
				Menu, SnipPlus_Menu, Show
			}
			else {
				SnipPlus.SuspendLastScreenshot()
			}
		}
		else
		{
			; tt(lang("Nothing snipped") . ".")
		}
		
		; Clipboard := clipboardOld   ; Restore the original clipboard. Note the use of Clipboard (not ClipboardAll).
		; clipboardOld := ""   ; Free the memory in case the clipboard was very large.

		; Clipboard := SnipPlus.old_clipboard_content   ; Restore the original clipboard. Note the use of Clipboard (not ClipboardAll).
		; SnipPlus.old_clipboard_content := ""   ; Free the memory in case the clipboard was very large.

	}

	SuspendLastScreenshot()
	{
		; if (FileExist(SnipPlus._TEMP_CLIPBOARD_CONTENT_FILE)) {
		; 	FileGetSize, _old_temp_clip_file_size, % SnipPlus._TEMP_CLIPBOARD_CONTENT_FILE
		; 	; FileDelete, % SnipPlus._TEMP_CLIPBOARD_CONTENT_FILE
		; }
		; else {
		; 	_old_temp_clip_file_size := 0
		; }
		
		; SnipPlus.is_clipboard_changed := 0
		; clipboardOld := ClipboardAll
		; Clipboard := ""
		; SnipPlus.AreaScreenshot()
		; Sleep, 222
		; if (SnipPlus.is_clipboard_changed == 0) {
			; tt("Nothing snipped.")
			; Return
		; }

		; ; ; 如果 FileAppend的Text 为 %ClipboardAll% 或之前接受了 ClipboardAll 赋值的变量, 则用剪贴板的全部内容无条件覆盖 Filename(即不需要 FileDelete).
		; ; ; 文件扩展名无关紧要. 很奇怪,经测试, 如果没有真的截图则_new_temp_clip_file_size会为一个较小的size, 也就是说没内容写入文件
		; FileAppend, %ClipboardAll%, % SnipPlus._TEMP_CLIPBOARD_CONTENT_FILE
		; FileGetSize, _new_temp_clip_file_size, % SnipPlus._TEMP_CLIPBOARD_CONTENT_FILE, K

		; if (_new_temp_clip_file_size < 6)  ;; 经测试, 小于6KB则说明用户没有截图
		; {
		; 	; m(_new_temp_clip_file_size)
		; 	; m(_old_temp_clip_file_size)
		; 	tt("Nothing snipped.")
		; 	Clipboard := clipboardOld   ; Restore the original clipboard. Note the use of Clipboard (not ClipboardAll).
		; 	clipboardOld := ""   ; Free the memory in case the clipboard was very large.
		; 	return
		; }


;;;;;;;;;;;;;;;; 带名字版本

		; cur_gui_name := "sux_snipshot_" . SnipPlus.temp_snip_img_index
		; Gui, %cur_gui_name%: New
		; ; Gui %cur_gui_name%:+Resize +AlwaysOnTop -MaximizeBox -MinimizeBox +ToolWindow
		; Gui %cur_gui_name%: +AlwaysOnTop +Resize -MaximizeBox
		; Gui, Margin, 0, 0

		; ; CustomColor := "EEAA99"  ; 可以为任意 RGB 颜色(在下面会被设置为透明).
		; ; ; CustomColor := "White"  ; 可以为任意 RGB 颜色(在下面会被设置为透明).
		; ; Gui +LastFound  ; 避免显示任务栏按钮和 alt-tab 菜单项.
		; ; Gui, Color, %CustomColor%
		; ; WinSet, TransColor, Off
		; ; WinSet, TransColor, %CustomColor% 150

		; ; Gui +LastFound  ; 
		; ; WinSet, Transparent, 50

		; img_path := SnipPlus.GetCurSnipImgPath()
		; Gui, %cur_gui_name%:Add, Picture, v%cur_gui_name%, gSUB_CLICK_SNIP_IMG, %img_path%
		
		; ; Menu, FileMenu, Add, &Open`tCtrl+O, Sub_xMenu_Open  ; 关于 Ctrl+O 请参阅后面的备注.
		; ; Menu, FileMenu, Add, E&xit, Sub_xMenu_Open
		; ; Menu, HelpMenu, Add, &About, Sub_xMenu_Open
		; ; Menu, MyMenuBar, Add, &File, :FileMenu  ; 附加上面的两个子菜单.
		; ; Menu, MyMenuBar, Add, &Help, :HelpMenu
		; ; Gui, Menu, MyMenuBar

		; GuiControl, Focus, Close
		; MouseGetPos, Mouse_x, Mouse_y
		; final_x := Mouse_x - 88
		; final_y := Mouse_y - 11
		; Gui, %cur_gui_name%:Show, x%final_x% y%final_y%, % "img-" . SnipPlus.temp_snip_img_index . "  ( " . lang("Tips: ") . lang("click img to make it transparent") . " )"
		; ; Gui, Show

		

;;;;;;;;;;;;;;;; 不带名字版本

		Gui, New
		; Gui +Resize +AlwaysOnTop -MaximizeBox -MinimizeBox +ToolWindow
		Gui, +AlwaysOnTop +Resize
		Gui, Margin, 0, 0

		; CustomColor := "EEAA99"  ; 可以为任意 RGB 颜色(在下面会被设置为透明).
		; ; CustomColor := "White"  ; 可以为任意 RGB 颜色(在下面会被设置为透明).
		; Gui +LastFound  ; 避免显示任务栏按钮和 alt-tab 菜单项.
		; Gui, Color, %CustomColor%
		; WinSet, TransColor, Off
		; WinSet, TransColor, %CustomColor% 150

		; Gui +LastFound  ; 
		; WinSet, Transparent, 50

		img_path := SnipPlus.GetCurSnipImgPath()
		Gui, Add, Picture, gSUB_CLICK_SNIP_IMG vSnipSuspendScreenShotImage, %img_path%

		GuiControlGet, pic_name, , SnipSuspendScreenShotImage
		GuiControlGet, PicInfo, Pos, SnipSuspendScreenShotImage  ; Stores the position and size in PicInfoX, PicInfoY, PicInfoW, and PicInfoH.
		SnipPlus.IMG_PATH_2_RATIO_MAP[pic_name] := PicInfoW / PicInfoH

		; Menu, FileMenu, Add, &Open`tCtrl+O, Sub_xMenu_Open  ; 关于 Ctrl+O 请参阅后面的备注.
		; Menu, FileMenu, Add, E&xit, Sub_xMenu_Open
		; Menu, HelpMenu, Add, &About, Sub_xMenu_Open
		; Menu, MyMenuBar, Add, &File, :FileMenu  ; 附加上面的两个子菜单.
		; Menu, MyMenuBar, Add, &Help, :HelpMenu
		; Gui, Menu, MyMenuBar

		GuiControl, Focus, Close
		MouseGetPos, Mouse_x, Mouse_y
		final_x := Mouse_x - 88
		final_y := Mouse_y - 11
		Gui, Show, x%final_x% y%final_y%, % "img-" . SnipPlus.temp_snip_img_index . "  ( " . lang("Tips: ") . lang("click img to make it transparent") . " )"
	}
}



Sub_SnipPlus_Menu_clik:
	SnipPlus.SuspendLastScreenshot()
Return

SUB_CLICK_SNIP_IMG:
	Gui +LastFound  ; 
	WinGet, cur_transparent_level, Transparent
	if (cur_transparent_level < 255) {
		WinSet, Transparent, 255
        ; WinSet, ExStyle, -0x20, A
	}
	else {
		WinSet, Transparent, 200
        ; WinSet, ExStyle, +0x20, A
	}

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


; 让贴图能够跟着窗口的大小变化而同时变化
GuiSize(GuiHwnd, EventInfo, Width, Height) {
	;; 1. 跟着窗口同比例变化
    ; GuiControl, MoveDraw, SnipSuspendScreenShotImage, % "w" . (A_GuiWidth) . " h" . (A_GuiHeight)

	;; 2. 保留图片本身的比例
	GuiControlGet, pic_name, , SnipSuspendScreenShotImage
	GuiControlGet, PicInfo, Pos, SnipSuspendScreenShotImage  ; Stores the position and size in PicInfoX, PicInfoY, PicInfoW, and PicInfoH.
	pic_ratio := SnipPlus.IMG_PATH_2_RATIO_MAP[pic_name]
	gui_ratio := Width / Height
	final_w =
	final_h =
	if (gui_ratio < pic_ratio) {
		; 说明gui纵向太长
		final_w := Width
		final_h := Width/pic_ratio
	} else {
		; 说明gui横向太长
		final_w := pic_ratio*Height
		final_h := Height
	}
	GuiControl, MoveDraw, SnipSuspendScreenShotImage, % "w" . final_w . " h" . final_h  ; 把图的比例按照算好的长宽设置一下
	GuiControl, Move, SnipSuspendScreenShotImage, % "x" . (Width/2 - final_w/2) . " y" . (Height/2 - final_h/2)  ;; 把图上下都居中
}
	
; //////////////////////////////////////////////////////////////////////////
SUB_SNIP_PLUS_FILE_END_LABEL:
	temp_spfel := "blabla"
