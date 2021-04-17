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



; 把两个字符串数组交叉连接起来
str_array_concate(arr, app, deli="")
{
	ret := []
	if(arr.MaxIndex()=="") {
		arr := [arr]
	}
	if(app.MaxIndex()=="") {
		app := [arr]
	}
	Loop, % arr.MaxIndex() {
		idx1 := A_Index
		Loop, % app.MaxIndex() {
			idx2 := A_Index
			ret.insert(arr[idx1] deli app[idx2])
		}
	}
	return % ret
}


register_command(key_name, action)
{
	global CMD_REGISTER_LIST
	CMD_REGISTER_LIST[key_name] := action
}


register_web_search(key_name, action)
{
	global WEB_SEARCH_REGISTER_LIST
	WEB_SEARCH_REGISTER_LIST[key_name] := action
}


register_additional_features(key_name, val)
{
	global ADDITIONAL_FEATURES_REGISTER_LIST
	ADDITIONAL_FEATURES_REGISTER_LIST[key_name] := val
}


register_theme_conf(key_name, val)
{
	global THEME_CONF_REGISTER_LIST
	THEME_CONF_REGISTER_LIST[key_name] := val
}


register_hotkey(key_name, action, prefix="")
{

	global HOTKEY_REGISTER_LIST
	trans_key := []
	
	StringLower, key_name, key_name
	map1 := {win: "#", ctrl: "^", shift: "+", alt: "!"
			,hover: "hover", capslock: "CapsLock"
			,lwin: "<#", rwin: ">#"
			,lctrl: "<^", rctrl: ">^"
			,lshift: "<+", rshift: ">+"
			,lalt: "<!", ralt: ">!"
			,lclick:  "LButton", rclick:  "RButton", wheelclick: "MButton" }
			; ,wheel: ["wheelUp", "wheelDown"] }
	key_split_arr := StrSplit(key_name, "_")
	; DebugPrintVal(key_split_arr.Length())

	Loop, % key_split_arr.MaxIndex()
	{
		cur_symbol := key_split_arr[A_Index]
		; if (key_split_arr.Length() == 1) 
		maped_symbol := (key_split_arr.Length() == 1) ? key_name : map1[cur_symbol] 
		if(maped_symbol=="") {
			trans_key := str_array_concate(trans_key, [cur_symbol])
		}
		else if(IsObject(maped_symbol)) {
		; m(trans_key)
			trans_key := str_array_concate(trans_key, maped_symbol)
		}
		else {
			trans_key := str_array_concate(trans_key, [maped_symbol])
		}
	}
		; m(trans_key)

	prefix_arr := StrSplit(prefix, "/")
	prefix_trans_keys := str_array_concate(prefix_arr, trans_key, "|")
	Loop, % prefix_trans_keys.MaxIndex()
	{
		key := prefix_trans_keys[A_Index]
		; StringUpper, key, key
		original_key := key
		; if (instr(original_key, "#"))
		; 	m(original_key)
		if !(original_key = "|CapsLock") {
			; m(original_key)
			key := StrReplace(key, "CapsLock", "CapsLock & ")
			key := StrReplace(key, "CapsLock & +", "CapsLock & ")
		}
		; m(key "//" action)
		; m(original_key "//" action)

		HOTKEY_REGISTER_LIST[original_key] := action
		; DebugPrintVal(HOTKEY_REGISTER_LIST[key])
		arr := StrSplit(key, "|")
		
		if (arr[2] == "hover") {
			Continue
		}
		
; DebugPrintVal(key)
; DebugPrintVal(action)
		; if (instr(original_key, "#")){
		; 	m(arr[2])
		; 	m(action)
		; }
; DebugPrintVal(arr[2])

		if(arr[1]!="") {
			Hotkey, IF, border_event_evoke()
			Hotkey, % arr[2], SUB_HOTKEY_ZONE_BORDER
		}
		else {
			Hotkey, IF
			Hotkey, % arr[2], SUB_HOTKEY_ZONE_ANYWAY
		}
	}
}


/*
; HOTKEY evoke
*/
SUB_HOTKEY_ZONE_ANYWAY:
SUB_HOTKEY_ZONE_BORDER:
	border_code := get_border_code()
	pending_replace_str := GetKeyState("LShift", "P") ? "CapsLock+": "CapsLock"
	cur_hotkey := StrReplace(A_ThisHotkey, "CapsLock & ", pending_replace_str)
	action := HOTKEY_REGISTER_LIST[border_code "|" cur_hotkey]
	if(action="") {
		; 鼠标移到边缘但触发普通热键时
		action := HOTKEY_REGISTER_LIST["|" cur_hotkey]
	}
	run(action)
Return


#IF border_event_evoke()
#IF
border_event_evoke()
{
	global HOTKEY_REGISTER_LIST
	border_code := get_border_code()
	; ToolTipWithTimer(border_code)

	key := border_code "|" A_ThisHotkey
	; ToolTipWithTimer(key)

	; StringUpper, key, key
	action := HOTKEY_REGISTER_LIST[key]
	if(action!="")
		return true
}