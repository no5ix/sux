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


; event callback
OnClipboardChange:
RunArr(SuxCore.OnClipboardChangeCmd)
Return



class ClipboardPlus
{
	static ClipboardHistoryArr := []
	static ClipsTotalNum = 

	init()
	{
		SuxCore.OnClipboardChange("Sub_xClipboard_OnClipboardChange")
		this.ClipsTotalNum := SuxCore.GetYamlCfg("clipboard-plus.ClipsTotalNum", 50)
	}

	ShowAllClips()
	{
		ClipsCount := this.ClipboardHistoryArr.MaxIndex()
		if (ClipsCount < 1) {
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
		global SHORTCUT_KEY_INDEX_ARR
		cnt := SHORTCUT_KEY_INDEX_ARR.Count()
		Loop, % ClipsCount
		{
			idx := ClipsCount - A_Index + 1
			keyName := this.ClipboardHistoryArr[idx][2]
			if (A_Index <= cnt)
				Menu, Clipborad_Plus_Menu, Add, % (A_Index<cnt ? "&":"") SHORTCUT_KEY_INDEX_ARR[A_Index] ".      " keyName, Sub_xClipboard_AllClips_Click
				; Menu, Clipborad_Plus_Menu, Add, % (A_Index<10?"&":"") A_Index ". " keyName, Sub_xClipboard_AllClips_Click
			Else
				Menu, Clipborad_Plus_Menu_More, Add, % A_Index ". " keyName, Sub_xClipboard_AllClips_MoreClick
		}
		if (ClipsCount > cnt)
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
	Clipboard := cur_selected_str   ; Restore the original clipboard-plus. Note the use of Clipboard (not ClipboardAll).
	Sleep, 66                             ; copy selected text to clipboard-plus
	Send, ^v
	Clipboard := ClipSaved   ; Restore the original clipboard-plus. Note the use of Clipboard (not ClipboardAll).
	ClipSaved := ""   ; Free the memory in case the clipboard-plus was very large.
}


; All ClipboardHistoryArr Menu
Sub_xClipboard_AllClips_Click:
idx := ClipboardPlus.ClipboardHistoryArr.MaxIndex() - A_ThisMenuItemPos + 1
paste_cur_selected_text(idx)
Return

Sub_xClipboard_AllClips_MoreClick:
idx := ClipboardPlus.ClipboardHistoryArr.MaxIndex() - A_ThisMenuItemPos + 1 - SHORTCUT_KEY_INDEX_ARR.Count()
paste_cur_selected_text(idx)
Return

; OnEvent
Sub_xClipboard_OnClipboardChange:
ClipboardPlus._AddArrClip(ClipboardPlus.ClipboardHistoryArr, Clipboard)
while (ClipboardPlus.ClipsTotalNum > 0 && ClipboardPlus.ClipboardHistoryArr.MaxIndex() > ClipboardPlus.ClipsTotalNum)
	ClipboardPlus.ClipboardHistoryArr.Remove(1)
Return



; //////////////////////////////////////////////////////////////////////////
SUB_CLIPBOARD_PLUS_FILE_END_LABEL:
	temp_cp := "blabla"