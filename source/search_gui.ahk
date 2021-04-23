; Note: Save with encoding UTF-8 with BOM if possible.
; Notepad will save UTF-8 files with BOM automatically (even though it does not say so).
; Some editors however save without BOM, and then special characters look messed up in the AHK GUI.

; Initialize variable to keep track of the state of the GUI
; global gui_state := closed


if(A_ScriptName=="search_gui.ahk") {
	ExitApp
}

; with this label, you can include this file on top of the file
Goto, SUB_CMD_WEB_SEARCH_FILE_END_LABEL

#Include %A_ScriptDir%\source\common_const.ahk

global THEME_CONF_REGISTER_MAP


last_search_str = ""
trim_gui_user_input = ""



class SearchGui {

	init() {
		; ; Esc一下, 不然第一次打开search_gui的阴影会有一个从淡到浓的bug
		Send, {Esc}
		; this.search_gui_spawn("Hello, sux.")	
		; SetTimer, GuiEscape, -1666
	}

	WebSearch(user_input, search_key="") {
		global WEB_SEARCH_REGISTER_MAP
		if (user_input == "" && search_key == "")
			return
		; 当只填了 url 而没填 search_key 的时候
		if (IsRawUrl(user_input) && search_key == "") {
			if not IsStandardRawUrl(user_input)
				user_input := StringJoin("", ["http://", user_input]*)
			Run %user_input%
			return
		}
		if (search_key == "") {
			search_key := "default"

		; if (search_key = "default") {
			; for _index, _elem in WEB_SEARCH_REGISTER_MAP[search_key] {
			; 	; if (_index != search_flag_index) {
			; 		SearchGui.WebSearch(user_input, _elem)
			; 		; Sleep, 666
			; 	; }
			; }
			; return
		; }
		}

		; search_flag_index = 1
		; search_flag := WEB_SEARCH_REGISTER_MAP[search_key][search_flag_index]
		; search_url := WEB_SEARCH_REGISTER_MAP[search_key]
		; if (search_url.Length() == 1) {
		; 	search_url := search_url[1]
		; }
		for _index, search_url in WEB_SEARCH_REGISTER_MAP[search_key] {
			SearchGui.WebSearchImpl(user_input, search_url)
			Sleep, 88  ; 为了给浏览器开tab的时候可以几个tab挨在一起
		}
	}

	; WebSearchImpl(user_input, search_key="", search_url) {
	WebSearchImpl(user_input, search_url) {
		if (user_input == "") {	
			if !InStr(search_url, "REPLACEME") {
			; if (search_flag = "URL") {
				Run %search_url%
				return
			} 
			; domain_url just like: "https://www.google.com"
			; 建议到 https://c.runoob.com/front-end/854 去测试这个正则
			RegExMatch(search_url, "((\w)+://)?(\w+(-)*(\.)?)+(:(\d)+)?", domain_url)
			if not IsStandardRawUrl(domain_url)
				domain_url := StringJoin("", ["http://", domain_url]*)
			Run %domain_url%
			return
			; DebugPrintVal(pending_search_str)
			; return
			; pending_search_str := Clipboard
			; if StrLen(pending_search_str) >= 88 {
			; 	ToolTipWithTimer("ClipBoard string is too long. Please input some short pending search string.", 2222)
			; 	search_gui_destroy()
			; 	return
			; }
		}

		; if (search_key = "default") {
		; 	for _index, _elem in WEB_SEARCH_REGISTER_MAP[search_key] {
		; 		; if (_index != search_flag_index) {
		; 			SearchGui.WebSearch(user_input, _elem)
		; 			; Sleep, 666
		; 		; }
		; 	}
		; 	return
		; }

		safe_query := UriEncode(Trim(user_input))
		StringReplace, search_final_url, search_url, REPLACEME, %safe_query%
		if not IsStandardRawUrl(search_final_url)
			search_final_url := StringJoin("", ["http://", search_final_url]*)
		Run, %search_final_url%
	}


	ShadowBorder(handle) {
		DllCall("user32.dll\SetClassLongPtr", "ptr", handle, "int", -26, "ptr", DllCall("user32.dll\GetClassLongPtr", "ptr", handle, "int", -26, "uptr") | 0x20000)
	}

	FrameShadow(handle) {
		DllCall("dwmapi\DwmIsCompositionEnabled","IntP",_ISENABLED) ; Get if DWM Manager is Enabled
		if !_ISENABLED ; if DWM is not enabled, Make Basic Shadow
			DllCall("SetClassLong","UInt",handle,"Int",-26,"Int",DllCall("GetClassLong","UInt",handle,"Int",-26)|0x20000)
		else {
			VarSetCapacity(_MARGINS,16)
			NumPut(1,&_MARGINS,0,"UInt")
			NumPut(1,&_MARGINS,4,"UInt")
			NumPut(1,&_MARGINS,8,"UInt")
			NumPut(1,&_MARGINS,12,"UInt")
			DllCall("dwmapi\DwmSetWindowAttribute", "Ptr", handle, "UInt", 2, "Int*", 2, "UInt", 4)
			DllCall("dwmapi\DwmExtendFrameIntoClientArea", "Ptr", handle, "Ptr", &_MARGINS)
		}
	}


	search_gui_spawn(curr_select_text="") {
		search_gui_destroy()
		; curr_select_text := GetCurSelectedText()
		; if (StrLen(curr_select_text) >= 60 || str)
		; 	curr_select_text := ""
		global last_search_str
		last_search_str := curr_select_text ? curr_select_text : last_search_str

		; Gui, +AlwaysOnTop -SysMenu +ToolWindow -caption +Border
		Gui, -SysMenu +ToolWindow -caption +hWndhMyGUI 
		Gui, Margin, 0, 0

		cur_theme_type := SuxCore.GetIniConfig("theme", SuxCore.Default_theme)
		cur_theme_info := THEME_CONF_REGISTER_MAP[cur_theme_type]

		sux_bg_color := cur_theme_info["sux_bg_color"] 
		Gui, Color, %sux_bg_color%, %sux_bg_color%
		if (cur_theme_info["sux_border_shadow_type"] == "modern_shadow_type") {
			; SearchGui.ShadowBorder(hMyGUI)
		; else
			SearchGui.FrameShadow(hMyGUI)
		}

		Gui, Font, s22, Segoe UI
		; Gui, Font, s10, Segoe UI
		; Gui, Add, Edit, %gui_control_options% vGuiUserInput gHandleSearchGuiUserInput
		gui_control_options := "xm+6 ym+6 w" . cur_theme_info["sux_width"] . " c" . cur_theme_info["sux_text_color"] . " -E0x200"
		; gui_control_options := "w" . cur_theme_info["sux_width"] . " c" . cur_theme_info["sux_text_color"] . "  -E0x800000"
		Gui, Add, Edit, %gui_control_options% vGuiUserInput, %last_search_str%
		; Gui, Add, Edit, %gui_control_options% vGuiUserInput, %curr_select_text%
		; Gui, Add, Edit, xm w620 ccBlack -E0x200 vGuiUserInput, %last_search_str%

		Gui, Add, Button, x-10 y-10 w1 h1 +default gHandleSearchGuiUserInput ; hidden button

		MouseGetPos, Mouse_x
		yScrnOffset := A_ScreenHeight / 4
		SysGet, mon_cnt, MonitorCount
		if (mon_cnt == 1) {
			Gui, Show, xCenter  y%yScrnOffset%, myGUI
		}
		else {
			xMidScrn := 0
			last_mon_width := 0
			Loop, % mon_cnt
			{
				SysGet, Mon, Monitor, % A_Index
				_mon_width := (MonRight - MonLeft)
				xMidScrn += _mon_width
				last_mon_width := _mon_width
				if (Mouse_x >= MonLeft && Mouse_x < MonRight)
					break
			}
			xMidScrn -= last_mon_width / 2
			xMidScrn -= cur_theme_info["sux_width"] / 2 
			Gui, Show, x%xMidScrn% y%yScrnOffset%, myGUI
		}

		auto_destory_gui_period := -22222  ; millisecond
		; gui_des := ObjBindMethod(this, "search_gui_destroy")  ; 不建议用这个, 这个不会顶掉原先search_gui_destroy的timer的
		; SetTimer, % gui_des, %auto_destory_gui_period%
		SetTimer, search_gui_destroy, %auto_destory_gui_period%
		return
	}

}


search_gui_destroy() {
	; Hide GUI
	Gui, Destroy
}


;-------------------------------------------------------------------------------
; GUI FUNCTIONS AND SUBROUTINES
;-------------------------------------------------------------------------------
; Automatically triggered on Escape key:
GuiEscape:
	search_gui_destroy()
	return

; The callback function when the text changes in the input field.
HandleSearchGuiUserInput:
	Gui, Submit, NoHide
	; #Include %A_ScriptDir%\source\cmd.ahk

	trim_gui_user_input := Trim(GuiUserInput)
	last_search_str := trim_gui_user_input

	if !trim_gui_user_input
	{
		search_gui_destroy()
	}
	else
	{
		global CMD_REGISTER_MAP
		if (CMD_REGISTER_MAP.HasKey(trim_gui_user_input) || SubStr(trim_gui_user_input, 1, 3) == "ev ")
		{
			search_gui_destroy()

			word_array := StrSplit(trim_gui_user_input, A_Space, ,2)
			if (word_array[1] == "ev"){
				;;; everything search
				; Run_AsUser(CustomCommandLineMap["ev"]*)  ; 这一句没有`run, %everything_exe_path%`快
				everything_exe_path := CMD_REGISTER_MAP["ev"][1]
				run, %everything_exe_path%
				WinWaitActive, ahk_exe Everything.exe, , 2.222
				if ErrorLevel
					MsgBox,,, please install Everything and set its shortcut in user_conf.ahk
				else if (word_array[2]){
					
					pending_search_str := word_array[2]
					; last_search_str := GuiUserInput
					; Sleep, 88
					; SendRaw, %trim_gui_user_input%
					; Sleep, 222
					; SendRaw, %last_search_str%
					Send, {Blind}{Text}%pending_search_str%
				}
				return
			}

			; if (word_array[1] == "git" || word_array[1] == "cmd"){
			USE_CURRENT_DIRECTORY_PATH_CMDs := {"cmd" : "C: && cd %UserProfile%\Desktop", "git" : "cd ~/Desktop"}
			use_cur_path := USE_CURRENT_DIRECTORY_PATH_CMDs.HasKey(trim_gui_user_input)
			IfWinActive, ahk_exe explorer.exe ahk_class CabinetWClass  ; from file explorer
			{
				if (use_cur_path) {
					Send, !d
					final_cmd_str := StringJoin(" ", CMD_REGISTER_MAP[trim_gui_user_input]*) . "`n"
					SendInput, %final_cmd_str%  ; 类似于等同于下面这两句
					; SendRaw, cmd
					; Send, {Enter}
					return
				}
			}
			run(CMD_REGISTER_MAP[trim_gui_user_input])
			if (use_cur_path) {
				file_path_str := CMD_REGISTER_MAP[trim_gui_user_input][1]  ; just like: "C:\Program Files\Git\bin\bash.exe"
				; m(file_path_str)
				RegExMatch(file_path_str, "([^<>\/\\|:""\*\?]+)\.\w+", file_name)  ; file_name just like: "bash.exe""
				; m(file_name)
				WinWaitActive, ahk_exe %file_name%,, 2222
				if !ErrorLevel {
					cd_user_desktop_cmd_input := USE_CURRENT_DIRECTORY_PATH_CMDs[trim_gui_user_input] . "`n"
					SendInput, %cd_user_desktop_cmd_input%
				}
			}
			; }
		}
		else
		{
			search_gui_destroy()
			word_array := StrSplit(trim_gui_user_input, A_Space, ,2)

			if WEB_SEARCH_REGISTER_MAP.HasKey(word_array[1]){
				SearchGui.WebSearch(word_array[2], word_array[1])
			}
			else {
				SearchGui.WebSearch(GuiUserInput)
			}
		}
	}

return



; //////////////////////////////////////////////////////////////////////////
SUB_CMD_WEB_SEARCH_FILE_END_LABEL:
	temp_cws := "blabla"
