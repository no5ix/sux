
lang(key, default="")
{
	lang := OneQuick.GetConfig("lang", OneQuick.Default_lang)
	lang_file := OneQuick._LANG_DIR "" lang ".ini"
	FileEncoding
	IniRead, out, % lang_file, lang, % key, %A_Space%
	if(out=="") {
		if(lang!="en"||default!="")
			IniWrite,%A_Space%, % lang_file, lang, % key
		if(default=="")
			out := key
		else
			out := default
	}
	; m(out)
	return out
}


class xClipboard
{
	static ClsName := "clipboard"
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
		OneQuick.OnClipboardChange("Sub_xClipboard_OnClipboardChange")
		OneQuick.OnExit("Sub_xClipboard_OnExit")
		this.Clips := OneQuick.UserData["xClipboard_Clips"]
		this.FavourClips := OneQuick.UserData["xClipboard_FavourClips"]
		this.ClipsFirstShowNum := OneQuick.GetFeatureCfg("clipboard.ClipsFirstShowNum", 10)
		this.ClipsTotalNum := OneQuick.GetFeatureCfg("clipboard.ClipsTotalNum", 50)
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
			Menu, xClipboard_AllclipsMenu, Add, % lang("More Clips"), :xClipboard_AllclipsMenu_More
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
		trim_str := xClipboard._Trim(str)
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
	cur_selected_str :=xClipboard.Clips[idx][1]
	ClipSaved := ClipboardAll 
	Clipboard := cur_selected_str   ; Restore the original clipboard. Note the use of Clipboard (not ClipboardAll).
	Sleep, 66                             ; copy selected text to clipboard
	Send, ^v
	Clipboard := ClipSaved   ; Restore the original clipboard. Note the use of Clipboard (not ClipboardAll).
	ClipSaved := ""   ; Free the memory in case the clipboard was very large.
}

; All Clips Menu
Sub_xClipboard_AllClips_Click:
idx := xClipboard.Clips.MaxIndex() - A_ThisMenuItemPos + 1
paste_cur_selected_text(idx)
Return

Sub_xClipboard_AllClips_MoreClick:
idx := xClipboard.Clips.MaxIndex() - A_ThisMenuItemPos + 1 - xClipboard.ClipsFirstShowNum
paste_cur_selected_text(idx)
Return


Sub_Menu_xClipboard_DeleteAll:
xClipboard.DeleteAllClips()
Return

; Clip Menu
Sub_xClipboard_ClipMenu_CLIPTitle:
Return

; OnEvent
Sub_xClipboard_OnClipboardChange:
xClipboard._AddArrClip(xClipboard.Clips, Clipboard)
while (xClipboard.ClipsTotalNum > 0 && xClipboard.Clips.MaxIndex() > xClipboard.ClipsTotalNum)
	xClipboard.Clips.Remove(1)
Return

Sub_xClipboard_OnExit:
OneQuick.UserData["xClipboard_Clips"] := xClipboard.Clips
OneQuick.UserData["xClipboard_FavourClips"] := xClipboard.FavourClips
Return



class Sys
{


	; Sys.Win
	class Win
	{
		GotoPreApp()
		{
			send !+{esc}
			winget, x ,MinMax, A
			if x=-1
				WinRestore A
		}

		GotoNextApp()
		{
			send !{esc}
			winget, x ,MinMax, A
			if x=-1
				WinRestore A
		}

		; Sys.Win.GotoPreTab
		GotoPreTab()
		{
			if(Sys.Win.Class()="PX_WINDOW_CLASS") {
				send ^{PgUp}
			}
			else {
				send ^+{tab}
			}
		}

		; Sys.Win.GotoNextTab
		GotoNextTab()
		{
			if(Sys.Win.Class()="PX_WINDOW_CLASS") {
				send ^{PgDn}
			}
			else {
				send ^{tab}
			}
		}
	}


	class Cursor
	{
		static CornerPixel := 8
		static info_switch := 0

		CornerPos(X := "", Y := "", cornerPix = "")
		{
			if (X = "") or (Y = "")
			{
				MouseGetPos, X, Y
			}
			if(cornerPix = "")
			{
				cornerPix := this.CornerPixel
			}
			; Multi Monitor Support
			SysGet, MonitorCount, MonitorCount
			Loop, % MonitorCount
			{
				SysGet, Mon, Monitor, % A_Index
                cur_mon_width := MonRight - MonLeft
                cur_mon_height := MonBottom - MonTop
				if(X>=MonLeft && Y>= MonTop && X<MonRight && Y<MonBottom)
				{
					str =
					if ( X < MonLeft + cornerPix ){
                        if (Y < cur_mon_height / 2)
						    str .= "LeftHalfTopEdge"
                        else
                            str .= "LeftHalfBottomEdge"
                    }
					else if ( X >= MonRight - cornerPix) {
						; str .= "RightEdge"
                        if (Y < cur_mon_height / 2)
						    str .= "RightHalfTopEdge"
                        else
                            str .= "RightHalfBottomEdge"
                    }
					if ( Y < MonTop + cornerPix ) {
                        if (str == "") {
                            if (X < cur_mon_width / 2)
                                str .= "TopHalfLeftEdge"
                            else
                                str .= "TopHalfRightEdge"
                        }
                            ; str .= "TopEdge"
                        else {
                            str := StrSplit(str, "Half")[1]
                            str .= "TopCorner"
                        }
						; str .= (str == "") ? "TopEdge" : "TopCorner"
                    }
					else if ( Y >= MonBottom - cornerPix) {
                        if (str == "") {
                            if (X < cur_mon_width / 2)
                                str .= "BottomHalfLeftEdge"
                            else
                                str .= "BottomHalfRightEdge"
                        }
                            ; str .= "BottomEdge"
                        else {
                            str := StrSplit(str, "Half")[1]
                            str .= "BottomCorner"
                        }
						; str .= (str == "") ? "BottomEdge" : "BottomCorner"
                    }
					return % str
				}
			}
			return ""
		}

	}

}



m(str := "")
{
	if(IsObject(str)) {
		str := "[Object]`n" Yaml_dump(str)
	}
	MsgBox, , % OneQuick.ProgramName, % str
}


; 万能的run 函数
; 参数可以是cmd命令，代码中的sub，function，网址，b站av号，还可以扩展
run(command, throwErr := 1)
{
	if (command.Length() == 1)
	{
		command := command[1]
	}
	
	if(IsLabel(command))
	{
		Gosub, %command%
	}
	else if (IsFunc(command))
	{
		Array := StrSplit(command, ".")
		If (Array.MaxIndex() >= 2)
		{
			cls := Array[1]
			cls := %cls%
			Loop, % Array.MaxIndex() - 2
			{
				cls := cls[Array[A_Index+1]]
			}
			return cls[Array[Array.MaxIndex()]]()
		}
		Else
		{
			return %command%()
		}
	}
	Else
	{
		if(RegExMatch(command, "^https?://"))
		{
			brw := OneQuick.Browser
			if(brw=""||brw="default")
				run, %command%
			Else if(brw == "microsoft-edge:")
				run, %brw%%command%
			Else
				run, %brw% %command%
			Return
		}
		else if(RegExMatch(command, "i)av(\d+)", avn))
		{
			run("http://www.bilibili.com/video/av" avn1)
			return
		}
		else if(RegExMatch(command, "i)send (.*)", sd))
		{
			send, % sd1
			return
		}
		else if(RegExMatch(command, "i)m:(.*)", msg))
		{
			m(msg1)
			return
		}
		else if(RegExMatch(command, "i)edit:\s*(.*)", f))
		{
			OneQuick.Edit(f1)
			return
		}
		Try
		{
			; m("kl")
			if (command.Length() > 1) {
				Run_AsUser(command*)
			}
			else {
				run %command%
			}
			; m(command)
			; run %command%
			Return
		}
		Catch
		{
			; Try
			; {
			; 	m(command)
			; 	Run_AsUser(command*)
			; }
			; Catch
			; {
				if(IsFunc("run_user"))
				{
					func_name = run_user
					%func_name%(command)
				}
				else if (throwErr == 1)
					MsgBox, 0x30, % OneQuick.ProgramName, % "Can't run command """ command """"
			; }
		}
	}
}


RunArr(arr)
{
	Loop, % arr.MaxIndex()
	{
		run(arr[A_Index])
	}
}