; ; Note: Save with encoding UTF-8 with BOM if possible.
; ; Notepad will save UTF-8 files with BOM automatically (even though it does not say so).
; ; Some editors however save without BOM, and then special characters look messed up in the AHK GUI.


; #Include, %A_ScriptDir%\source
; #Include, nox_core.ahk
; #Include, yaml.ahk


; event callback
OnClipboardChange:
RunArr(NoxCore.OnClipboardChangeCmd)
Return


class ClipboardPlus
{
	static ClsName := "clipboard-plus"
	static ini_registered := 0
	static Clips := []
	static FavourClips := []
	static BrowserArr := []
	static BrowserItemName := ""
	static SearchArr := []
	static ClipsFirstShowNum = 
	static ClipsTotalNum = 

	Ini()
	{
		if (this.ini_registered == 1)
			Return
		NoxCore.OnClipboardChange("Sub_xClipboard_OnClipboardChange")
		NoxCore.OnExit("Sub_xClipboard_OnExit")
		this.Clips := NoxCore.UserData["xClipboard_Clips"]
		this.FavourClips := NoxCore.UserData["xClipboard_FavourClips"]
		this.ClipsFirstShowNum := NoxCore.GetFeatureCfg("clipboard-plus.ClipsFirstShowNum", 10)
		this.ClipsTotalNum := NoxCore.GetFeatureCfg("clipboard-plus.ClipsTotalNum", 50)
		if not IsObject(this.Clips)
			this.Clips := []
		if not IsObject(this.FavourClips)
			this.FavourClips := []
		this.ini_registered := 1
	}

	ShowAllClips()
	{
		Try
		{
			Menu, xClipboard_AllclipsMenu, DeleteAll
		}
		Try
		{
			Menu, xClipboard_AllclipsMenu_More, DeleteAll
		}
		; Try
		; {
		; 	Menu, xClipboard_AllclipsMenu_Favour, DeleteAll
		; }
		ClipsCount := this.Clips.MaxIndex()
		shortcut_key_index_arr := ["q", "w", "e", "r", "a", "s", "d", "f", "g", "z", "x", "c", "v", "t", "b"]
		Loop, % ClipsCount
		{
			idx := ClipsCount - A_Index + 1
			keyName := this.Clips[idx][2]
			if (A_Index <= this.ClipsFirstShowNum)
				Menu, xClipboard_AllclipsMenu, Add, % (A_Index<10?"&":"") shortcut_key_index_arr[A_Index] ".      " keyName, Sub_xClipboard_AllClips_Click
				; Menu, xClipboard_AllclipsMenu, Add, % (A_Index<10?"&":"") A_Index ". " keyName, Sub_xClipboard_AllClips_Click
			Else
				Menu, xClipboard_AllclipsMenu_More, Add, % A_Index ". " keyName, Sub_xClipboard_AllClips_MoreClick
		}
		if (ClipsCount >= this.ClipsFirstShowNum)
			Menu, xClipboard_AllclipsMenu, Add, % "More Clips", :xClipboard_AllclipsMenu_More
		if (ClipsCount > 0)
			Menu, xClipboard_AllclipsMenu, Show
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
	cur_selected_str :=ClipboardPlus.Clips[idx][1]
	ClipSaved := ClipboardAll 
	Clipboard := cur_selected_str   ; Restore the original clipboard-plus. Note the use of Clipboard (not ClipboardAll).
	Sleep, 66                             ; copy selected text to clipboard-plus
	Send, ^v
	Clipboard := ClipSaved   ; Restore the original clipboard-plus. Note the use of Clipboard (not ClipboardAll).
	ClipSaved := ""   ; Free the memory in case the clipboard-plus was very large.
}

; All Clips Menu
Sub_xClipboard_AllClips_Click:
idx := ClipboardPlus.Clips.MaxIndex() - A_ThisMenuItemPos + 1
paste_cur_selected_text(idx)
Return

Sub_xClipboard_AllClips_MoreClick:
idx := ClipboardPlus.Clips.MaxIndex() - A_ThisMenuItemPos + 1 - ClipboardPlus.ClipsFirstShowNum
paste_cur_selected_text(idx)
Return

; OnEvent
Sub_xClipboard_OnClipboardChange:
ClipboardPlus._AddArrClip(ClipboardPlus.Clips, Clipboard)
while (ClipboardPlus.ClipsTotalNum > 0 && ClipboardPlus.Clips.MaxIndex() > ClipboardPlus.ClipsTotalNum)
	ClipboardPlus.Clips.Remove(1)
Return

Sub_xClipboard_OnExit:
NoxCore.UserData["xClipboard_Clips"] := ClipboardPlus.Clips
NoxCore.UserData["xClipboard_FavourClips"] := ClipboardPlus.FavourClips
Return

