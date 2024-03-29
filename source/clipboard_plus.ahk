﻿; ; Note: Save with encoding UTF-8 with BOM if possible.
; ; Notepad will save UTF-8 files with BOM automatically (even though it does not say so).
; ; Some editors however save without BOM, and then special characters look messed up in the AHK GUI.


; #Include, %A_ScriptDir%\source
; #Include, sux_core.ahk



if(A_ScriptName=="clipboard_plus.ahk") {
	ExitApp
}


; with this label, you can include this file on top of the file
Goto, SUB_CLIPBOARD_PLUS_FILE_END_LABEL


#Include %A_ScriptDir%\source\sux_core.ahk
#Include %A_ScriptDir%\source\util.ahk



class ClipboardPlus
{
	static CLIPBOARD_TEXT_SUFFIX := "[text] "
	static CLIPBOARD_IMG_SUFFIX := "[img] "
	static CLIPBOARD_FILE_SUFFIX := "[file] "
	static CLIPBOARD_FILES_SUFFIX := "[files] "
	static CLIPBOARD_FOLDER_SUFFIX := "[folder] "
	static CLIPBOARD_FILES_DELIMITER := "|sux-clipboard-files-delimiter|"
	static ClipboardHistoryArr := []
	static ClipsTotalNum = 

	init()
	{
		ClipboardChangeCmdMgr.register_clip_change_func("Sub_ClipboardPlus_OnClipboardChange")
		this.ClipsTotalNum := SuxCore.GetSuxCfg("clipboard-plus.ClipsTotalNum", 50)
	}

	ShowAllClips()
	{
		clipboard_history_cnt := this.ClipboardHistoryArr.MaxIndex()
		Try
		{
			Menu, Clipborad_Plus_Menu, DeleteAll
		}
		Try
		{
			Menu, Clipborad_Plus_Menu_More, DeleteAll
		}
		if (clipboard_history_cnt >= 1) {
			global CLIPBOARD_PLUS_SHORTCUT_KEY_INDEX_ARR
			shortcut_cnt := CLIPBOARD_PLUS_SHORTCUT_KEY_INDEX_ARR.Count()
			Loop, % clipboard_history_cnt
			{
				idx := clipboard_history_cnt - A_Index + 1
				clip_text := this.ClipboardHistoryArr[idx][2]
				if (A_Index <= shortcut_cnt) {
					menu_shortcut_str := get_menu_shortcut_str(CLIPBOARD_PLUS_SHORTCUT_KEY_INDEX_ARR, A_Index, clip_text)
					;; 要为菜单项名称的某个字母加下划线, 在这个字母前加一个 & 符号. 当菜单显示出来时, 此项可以通过按键盘上对应的按键来选中.
					Menu, Clipborad_Plus_Menu, Add, % menu_shortcut_str, Sub_ClipboardPlus_AllClips_Click
					; Menu, Clipborad_Plus_Menu, Add, % clip_text, Sub_ClipboardPlus_AllClips_Click
				}
				Else {
					Menu, Clipborad_Plus_Menu_More, Add, % clip_text, Sub_ClipboardPlus_AllClips_MoreClick
				}
			}
			if (clipboard_history_cnt > shortcut_cnt)
				Menu, Clipborad_Plus_Menu, Add, % lang("More"), :Clipborad_Plus_Menu_More

			Menu, Clipborad_Plus_Menu, Add
			Menu, Clipborad_Plus_Menu, Add, % lang("Paste All") . "`t&v", Sub_Menu_ClipboardPlus_PasteAll
			Menu, Clipborad_Plus_Menu, Add, % lang("Delete All") . "`t&d", Sub_Menu_ClipboardPlus_DeleteAll
			
			Menu, QuickEntry_Menu, Add, % lang("Clipboard Plus") . "`t&v", :Clipborad_Plus_Menu
		}
		else {
			; tt(lang("clipboard currently has no centent, please copy something..."), 2222)
			empty_menu_str := lang("clipboard currently has no centent, please copy something...")
			Menu, Clipborad_Plus_Menu, Add, % empty_menu_str, Clipborad_Plus_Sub_Nothing
			Menu, Clipborad_Plus_Menu, Disable, % empty_menu_str
			Menu, QuickEntry_Menu, Add, % lang("Clipboard Plus") . "`t&v", :Clipborad_Plus_Menu
		}


		; Menu, Clipborad_Plus_Menu, Show
	}

	DeleteAllClips()
	{
		this.ClipboardHistoryArr := []
	}

	IsClipPlusFile(pending_paste)
	{
 		return Instr(pending_paste, lang(ClipboardPlus.CLIPBOARD_FILE_SUFFIX)) || Instr(pending_paste, lang(ClipboardPlus.CLIPBOARD_FILES_SUFFIX)) || Instr(pending_paste, lang(ClipboardPlus.CLIPBOARD_FOLDER_SUFFIX))
	}

	IsClipPlusImg(pending_paste)
	{
		return Instr(pending_paste, lang(ClipboardPlus.CLIPBOARD_IMG_SUFFIX))
	}

	PasteClipPlusContent(pending_paste)
	{
		if (ClipboardPlus.IsClipPlusFile(pending_paste)) {  ;; 这里先判断 file, 因为有可能文件名里刚好有 [img] 标记
			pending_paste_file_path := StrSplit(pending_paste, ClipboardPlus.CLIPBOARD_FILES_DELIMITER)
			original_pending_paste_file_path := pending_paste_file_path[2]
			Loop, parse, original_pending_paste_file_path, `n, `r
			{
				if (FileExist(A_LoopField)) {
					PasteContent("FileToClipboard", A_LoopField)
				}
				else {
					PasteContent(A_LoopField)
				}
				Sleep, 88
			}
		}
		else if (ClipboardPlus.IsClipPlusImg(pending_paste)) {
			img_path := SuxCore._CACHE_DIR . pending_paste . ".png"
			if (!FileExist(img_path)) {
				hBM := StrReplace(pending_paste, lang(ClipboardPlus.CLIPBOARD_IMG_SUFFIX))
				GDIP("Startup")
				SavePicture(hBM, img_path)
				GDIP("Shutdown")
				DllCall( "DeleteObject", "Ptr", hBM )
			}
			if (FileExist(img_path)) {
				PasteContent("FileToClipboard", img_path)
			}
			else {
				PasteContent(pending_paste)
			}
		}
		else {
			pending_paste := StrReplace(pending_paste, lang(ClipboardPlus.CLIPBOARD_TEXT_SUFFIX))
			PasteContent(pending_paste)
		}
		Sleep, 88
	}

	_Trim(str_ori, add_time := 1)
	{
		_trimed_str := Trim(str_ori, " `t`r`n")
		tabfind := InStr(_trimed_str, "`t")
		if (tabfind > 0)
		{
			_trimed_str := SubStr(_trimed_str, 1, tabfind -1)
		}
		if (_trimed_str == "")
			_trimed_str := "<space>"
		; Else if (SubStr(_trimed_str, 1, 1) != SubStr(str_ori, 1, 1))
		; 	_trimed_str := "_" _trimed_str
		if StrLen(_trimed_str) > 50
			_trimed_str := SubStr(_trimed_str, 1, 50)
		; _trimed_str := _trimed_str "`t[" StrLen(str_ori) "]"

		; final_str := "[" StrLen(str_ori) "]"
		final_str := ""
		if(add_time)
		{
			final_str := final_str "[" A_Hour ":" A_Min ":" A_Sec "]"
		}
		final_str := final_str . "  " . _trimed_str
		Return % final_str
	}

	_AddArrClip(ByRef Arr, str)
	{
		trim_str := ClipboardPlus._Trim(str)
		if str !=
		{
			Loop, % Arr.MaxIndex()
			{
				if (str == Arr[A_Index][1])
				{
					Arr.Remove(A_Index)
				}
			}
			Arr.Insert([str, trim_str])
		}
	}

	_RemoveArrClip(ByRef Arr, str)
	{
		Loop, % Arr.MaxIndex()
		{
			if (str == Arr[A_Index][1])
			{
				Arr.Remove(A_Index)
			}
		}
	}
}


Clipborad_Plus_Sub_Nothing:
Return


Sub_Menu_ClipboardPlus_PasteAll:
max_i := ClipboardPlus.ClipboardHistoryArr.MaxIndex()
Loop, % max_i
{
	pending_paste := ClipboardPlus.ClipboardHistoryArr[A_Index][1]
	if (A_Index != max_i && !ClipboardPlus.IsClipPlusFile(pending_paste) && !ClipboardPlus.IsClipPlusImg(pending_paste)) {
		pending_paste .= "`r`n"
	}
	Sleep, 88
	ClipboardPlus.PasteClipPlusContent(pending_paste)
}
Return


Sub_Menu_ClipboardPlus_DeleteAll:
ClipboardPlus.DeleteAllClips()
Return


Sub_ClipboardPlus_AllClips_Click:
if (A_ThisMenuItemPos == 1) {
	SafePaste()
	return
}
idx := ClipboardPlus.ClipboardHistoryArr.MaxIndex() - A_ThisMenuItemPos + 1
pending_paste := ClipboardPlus.ClipboardHistoryArr[idx][1]
ClipboardPlus.PasteClipPlusContent(pending_paste)
Return


Sub_ClipboardPlus_AllClips_MoreClick:
idx := ClipboardPlus.ClipboardHistoryArr.MaxIndex() - A_ThisMenuItemPos + 1 - CLIPBOARD_PLUS_SHORTCUT_KEY_INDEX_ARR.Count()
pending_paste := ClipboardPlus.ClipboardHistoryArr[idx][1]
ClipboardPlus.PasteClipPlusContent(pending_paste)
Return


Sub_ClipboardPlus_OnClipboardChange:
if (A_EventInfo == 1) {
	if (Is_Clipboard_As_File()) {
		file_arr := StrSplit(Clipboard, "`r`n")
		if (file_arr.Count() == 1) {
			if (InStr(FileExist(file_arr[1]), "D"))
				pending_add_content := lang(ClipboardPlus.CLIPBOARD_FOLDER_SUFFIX)
			else
				pending_add_content := lang(ClipboardPlus.CLIPBOARD_FILE_SUFFIX)
		}
		else {
			pending_add_content := lang(ClipboardPlus.CLIPBOARD_FILES_SUFFIX)
		}
		pending_add_content .= GetFileNameFromFullPath(file_arr[1])
		; m(pending_add_content)
		for _i, _v in file_arr {
			if (_i <= 1)
				Continue
			; m(_v)
			pending_add_content .= " & " . GetFileNameFromFullPath(_v)
		}
		pending_add_content .= "                                               " . ClipboardPlus.CLIPBOARD_FILES_DELIMITER . Clipboard
	}
	else {
		pending_add_content := lang(ClipboardPlus.CLIPBOARD_TEXT_SUFFIX) . Clipboard
	}
}
else if (A_EventInfo == 2) {
	If (hBM := CB_hBMP_Get()) {
		pending_add_content := lang(ClipboardPlus.CLIPBOARD_IMG_SUFFIX) . hBM
	}
	else {
		pending_add_content := lang(ClipboardPlus.CLIPBOARD_TEXT_SUFFIX) . Clipboard
	}
}
ClipboardPlus._AddArrClip(ClipboardPlus.ClipboardHistoryArr, pending_add_content)
while (ClipboardPlus.ClipsTotalNum > 0 && ClipboardPlus.ClipboardHistoryArr.MaxIndex() > ClipboardPlus.ClipsTotalNum)
	ClipboardPlus.ClipboardHistoryArr.Remove(1)
Return



; //////////////////////////////////////////////////////////////////////////
SUB_CLIPBOARD_PLUS_FILE_END_LABEL:
	temp_cp := "blabla"