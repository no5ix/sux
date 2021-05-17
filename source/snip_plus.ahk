; ; Note: Save with encoding UTF-8 with BOM if possible.
; ; Notepad will save UTF-8 files with BOM automatically (even though it does not say so).
; ; Some editors however save without BOM, and then special characters look messed up in the AHK GUI.



if(A_ScriptName=="snip_plus.ahk") {
	ExitApp
}


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


	init()
	{

	}

	GetCurSnipImgPath()
	{
		Return SuxCore._TEMP_DIR . SnipPlus._TEMP_SNIP_IMG_PREFIX . SnipPlus.temp_snip_img_index . ".png"
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
			; ToolTipWithTimer(lang("Nothing snipped") . ".")
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
			; ToolTipWithTimer("Nothing snipped.")
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
		; 	ToolTipWithTimer("Nothing snipped.")
		; 	Clipboard := clipboardOld   ; Restore the original clipboard. Note the use of Clipboard (not ClipboardAll).
		; 	clipboardOld := ""   ; Free the memory in case the clipboard was very large.
		; 	return
		; }

		cur_gui_name := "sux_snipshot_" . SnipPlus.temp_snip_img_index
		Gui, %cur_gui_name%: New
		; Gui %cur_gui_name%:+Resize +AlwaysOnTop -MaximizeBox -MinimizeBox +ToolWindow
		Gui %cur_gui_name%: +AlwaysOnTop +Resize -MaximizeBox
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
		Gui, %cur_gui_name%:Add, Picture, gSUB_CLICK_SNIP_IMG, % img_path
		
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
		Gui, %cur_gui_name%:Show, x%final_x% y%final_y%, % "img-" . SnipPlus.temp_snip_img_index . "  ( " . lang("Tips: ") . lang("click img to make it transparent") . " )"
		; Gui, Show

		
	}
}



Sub_SnipPlus_Menu_clik:
	SnipPlus.SuspendLastScreenshot()
Return

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

	
; //////////////////////////////////////////////////////////////////////////
SUB_SNIP_PLUS_FILE_END_LABEL:
	temp_spfel := "blabla"
