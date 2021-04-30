; ; Note: Save with encoding UTF-8 with BOM if possible.
; ; Notepad will save UTF-8 files with BOM automatically (even though it does not say so).
; ; Some editors however save without BOM, and then special characters look messed up in the AHK GUI.


; #Include, %A_ScriptDir%\source
; #Include, sux_core.ahk
; #Include, yaml.ahk



if(A_ScriptName=="clipboard_plus.ahk") {
	ExitApp
}

; with this label, you can include this file on top of the file
Goto, SUB_CLIPBOARD_PLUS_FILE_END_LABEL


#Include %A_ScriptDir%\source\sux_core.ahk
#Include %A_ScriptDir%\source\util.ahk



class ClipboardPlus
{
	static ClipboardHistoryArr := []
	static ClipsTotalNum = 

	init()
	{
		SuxCore.register_clip_change_func("Sub_ClipboardPlus_OnClipboardChange")
		this.ClipsTotalNum := SuxCore.GetYamlCfg("clipboard-plus.ClipsTotalNum", 50)
	}

	ShowAllClips()
	{
		clipboard_history_cnt := this.ClipboardHistoryArr.MaxIndex()
		if (clipboard_history_cnt < 1) {
			ToolTipWithTimer(lang("clipboard currently has no centent, please copy something..."), 2222)
			Return
		}
		Try
		{
			Menu, Clipborad_Plus_Menu, DeleteAll
		}
		Try
		{
			Menu, Clipborad_Plus_Menu_More, DeleteAll
		}
		global SHORTCUT_KEY_INDEX_ARR_LEFT
		shortcut_cnt := SHORTCUT_KEY_INDEX_ARR_LEFT.Count()
		dot_space_str := ".      "
		Loop, % clipboard_history_cnt
		{
			idx := clipboard_history_cnt - A_Index + 1
			clip_text := this.ClipboardHistoryArr[idx][2]
			if (A_Index <= shortcut_cnt) {
				menu_shortcut_str := get_menu_shortcut_str(SHORTCUT_KEY_INDEX_ARR_LEFT, A_Index, dot_space_str, clip_text)
				; _cur_shortcut_str := SHORTCUT_KEY_INDEX_ARR_LEFT[A_Index]
				; if (_cur_shortcut_str == " ") {
				; 	;; 如果快捷键为空格的话, 得特殊处理
				; 	; _cur_shortcut_str := _cur_shortcut_str == " " ? _cur_shortcut_str . "(" . lang("space") . ")" : _cur_shortcut_str
				; 	final_str := "&" . _cur_shortcut_str . "(" . lang("space") . ")" . dot_space_str . clip_text
				; }
				; else if (_cur_shortcut_str == "q") {
				; 	final_str := "&" . _cur_shortcut_str . "(" . lang("exit") . ")"
				; }
				; else {
				; 	final_str := "&" . _cur_shortcut_str . dot_space_str . clip_text
				; }
				;; 要为菜单项名称的某个字母加下划线, 在这个字母前加一个 & 符号. 当菜单显示出来时, 此项可以通过按键盘上对应的按键来选中.
				Menu, Clipborad_Plus_Menu, Add, % menu_shortcut_str, Sub_ClipboardPlus_AllClips_Click
				; Menu, Clipborad_Plus_Menu, Add, % (A_Index<10?"&":"") A_Index ". " clip_text, Sub_ClipboardPlus_AllClips_Click
			}
			Else {
				Menu, Clipborad_Plus_Menu_More, Add, % A_Index . dot_space_str . clip_text, Sub_ClipboardPlus_AllClips_MoreClick
			}
		}
		if (clipboard_history_cnt > shortcut_cnt)
			Menu, Clipborad_Plus_Menu, Add, % lang("More"), :Clipborad_Plus_Menu_More
		Menu, Clipborad_Plus_Menu, Show
	}

	_Trim(str_ori, add_time := 1)
	{
		str := Trim(str_ori, " `t`r`n")
		tabfind := InStr(str, "`t")
		if (tabfind > 0)
		{
			str := SubStr(str, 1, tabfind -1)
		}
		if (str == "")
			str := "<space>"
		Else if (SubStr(str, 1, 1) != SubStr(str_ori, 1, 1))
			str := "_" str
		if StrLen(str) > 50
			str := SubStr(str, 1, 50)
		str := str "`t[" StrLen(str_ori) "]"
		if(add_time)
		{
			str := str "[" A_Hour ":" A_Min ":" A_Sec "]"
		}
		Return % str
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


paste_cur_selected_text(idx) {
	cur_selected_str :=ClipboardPlus.ClipboardHistoryArr[idx][1]
	ClipSaved := ClipboardAll 
	Clipboard := ""
	Clipboard := cur_selected_str
	; m(Clipboard)
    ClipWait, 0.6
	if (!ErrorLevel) {
		SafePaste()
	}
	; Sleep, 66
	; SafePaste()
	Clipboard := ClipSaved   ; Restore the original clipboard-plus. Note the use of Clipboard (not ClipboardAll).
	ClipSaved := ""   ; Free the memory in case the clipboard-plus was very large.
}


Sub_ClipboardPlus_AllClips_Click:
SuxCore.unregister_clip_change_func("Sub_ClipboardPlus_OnClipboardChange")  ;; 防止paste_cur_selected_text里污染了剪切板顺序
idx := ClipboardPlus.ClipboardHistoryArr.MaxIndex() - A_ThisMenuItemPos + 1
; clipboard_guard("paste_cur_selected_text", idx)
paste_cur_selected_text(idx)
SuxCore.register_clip_change_func("Sub_ClipboardPlus_OnClipboardChange")

Return

Sub_ClipboardPlus_AllClips_MoreClick:
SuxCore.unregister_clip_change_func("Sub_ClipboardPlus_OnClipboardChange")
idx := ClipboardPlus.ClipboardHistoryArr.MaxIndex() - A_ThisMenuItemPos + 1 - SHORTCUT_KEY_INDEX_ARR_LEFT.Count()
; clipboard_guard("paste_cur_selected_text", idx)
paste_cur_selected_text(idx)
SuxCore.register_clip_change_func("Sub_ClipboardPlus_OnClipboardChange")
Return

; OnEvent
Sub_ClipboardPlus_OnClipboardChange:
; ToolTipWithTimer(888888)
ClipboardPlus._AddArrClip(ClipboardPlus.ClipboardHistoryArr, Clipboard)
while (ClipboardPlus.ClipsTotalNum > 0 && ClipboardPlus.ClipboardHistoryArr.MaxIndex() > ClipboardPlus.ClipsTotalNum)
	ClipboardPlus.ClipboardHistoryArr.Remove(1)
Return



; //////////////////////////////////////////////////////////////////////////
SUB_CLIPBOARD_PLUS_FILE_END_LABEL:
	temp_cp := "blabla"