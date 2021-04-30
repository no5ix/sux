; Note: Save with encoding UTF-8 with BOM if possible.
; Notepad will save UTF-8 files with BOM automatically (even though it does not say so).
; Some editors however save without BOM, and then special characters look messed up in the AHK GUI.

; Initialize variable to keep track of the state of the GUI
; global gui_state := closed


if(A_ScriptName=="search_plus.ahk") {
	ExitApp
}


; last_search_str = ""
; trim_gui_user_input = ""

; with this label, you can include this file on top of the file
Goto, SUB_CMD_WEB_SEARCH_FILE_END_LABEL

#Include %A_ScriptDir%\source\common_const.ahk
#Include %A_ScriptDir%\source\sux_core.ahk






class SearchPlus {

	static cur_sel_search_title := ""

	init() {
		; ; Esc一下, 不然第一次打开search_gui的阴影会有一个从淡到浓的bug
		Send, {Esc}
	}

	HandleSearch(search_str) {
		search_title := SearchPlus.cur_sel_search_title
		global WEB_SEARCH_TITLE_2_URL_MAP
		if (search_str == "")
			return
		; 当填了 url 的时候
		if (IsRawUrl(search_str)) {
			if not IsStandardRawUrl(search_str)
				search_str := StringJoin("", ["http://", search_str]*)
			Run %search_str%
			return
		}
		for _index, search_url in WEB_SEARCH_TITLE_2_URL_MAP[search_title] {
			; m(_index "//" search_url)

			if (search_str == search_title) {	;; 说明用户动原本search_gui里被默认就选中的的search_title
				if !InStr(search_url, "REPLACEME") {
					Run %search_url%
					Continue
				} 
				; domain_url just like: "https://www.google.com"
				; 建议到 https://c.runoob.com/front-end/854 去测试这个正则
				RegExMatch(search_url, "((\w)+://)?(\w+(-)*(\.)?)+(:(\d)+)?", domain_url)
				if not IsStandardRawUrl(domain_url)
					domain_url := StringJoin("", ["http://", domain_url]*)
				Run %domain_url%
				Continue
			}


			safe_query := UriEncode(Trim(search_str))
			StringReplace, search_final_url, search_url, REPLACEME, %safe_query%
			if not IsStandardRawUrl(search_final_url)
				search_final_url := StringJoin("", ["http://", search_final_url]*)
			Run, %search_final_url%

			Sleep, 88  ; 为了给浏览器开tab的时候可以几个tab挨在一起
		}
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


	search_gui_spawn() {
		; search_gui_destroy()
		; static hMyGUI =
		; if (WinExist("ahk_id " hMyGUI)) {
		; 	; ToolTipWithTimer(hmyGUI)
		; 	WinActivate, ahk_id %hMyGUI%
		; 	Return
		; }
		; curr_select_text := GetCurSelectedText()
		; if (StrLen(curr_select_text) >= 60 || str)
		; 	curr_select_text := ""
		; global last_search_str
		; final_search_str := curr_select_text ? curr_select_text : last_search_str

		; Gui, +AlwaysOnTop -SysMenu +ToolWindow -caption +Border
		Gui, -SysMenu +ToolWindow -caption +hWndhMyGUI
		Gui, Margin, 0, 0

		global THEME_CONF_REGISTER_MAP
		cur_theme_type := SuxCore.GetIniConfig("theme", SuxCore.Default_theme)
		cur_theme_info := THEME_CONF_REGISTER_MAP[cur_theme_type]

		sux_bg_color := cur_theme_info["sux_bg_color"] 
		Gui, Color, %sux_bg_color%, %sux_bg_color%
		if (cur_theme_info["sux_border_shadow_type"] == "modern_shadow_type") {
			; SearchPlus.ShadowBorder(hMyGUI)
		; else
			SearchPlus.FrameShadow(hMyGUI)
		}

		Gui, Font, s22, Segoe UI
		; Gui, Font, s10, Segoe UI
		; Gui, Add, Edit, %gui_control_options% vGuiUserInput gSub_HandleSearchGuiUserInput
		gui_control_options := "-WantReturn xm+6 ym+6 w" . cur_theme_info["sux_width"] . " c" . cur_theme_info["sux_text_color"] . " -E0x200"
		; gui_control_options := "w" . cur_theme_info["sux_width"] . " c" . cur_theme_info["sux_text_color"] . "  -E0x800000"
		; Gui, Add, Edit, %gui_control_options% vGuiUserInput, %final_search_str%
		Gui, Add, Edit, %gui_control_options% vGuiUserInput, % SearchPlus.cur_sel_search_title
		; Gui, Add, Edit, %gui_control_options% vGuiUserInput, %curr_select_text%
		; Gui, Add, Edit, xm w620 ccBlack -E0x200 vGuiUserInput, %final_search_str%

		Gui, Add, Button, x-10 y-10 w1 h1 +default gSub_HandleSearchGuiUserInput ; hidden button

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

		global auto_destory_search_plus_gui_period
		; gui_des := ObjBindMethod(this, "search_gui_destroy")  ; 不建议用这个, 这个不会顶掉原先search_gui_destroy的timer的
		; SetTimer, % gui_des, %auto_destory_gui_period%
		SetTimer, search_gui_destroy, %auto_destory_search_plus_gui_period%
		return
	}

	
	ShowSearchPlusMenu() {
		search_gui_destroy()

		try {
			Menu, SearchPlus_Command_Menu, DeleteAll
		}
		try {
			Menu, SearchPlus_Menu_More, DeleteAll
		}
		try {
			Menu, Command_Menu_More, DeleteAll
		}

		selected_text := GetCurSelectedText()
		if selected_text {
			sub_selected_text := SubStr(selected_text, 1, 2) . "..."
			; m(sub_selected_text)
			Menu, SearchPlus_Command_Menu, Add, % sub_selected_text, Sub_Nothing
			Menu, SearchPlus_Command_Menu, Disable, % sub_selected_text
			Menu, SearchPlus_Command_Menu, Add
		}
		
		global WEB_SEARCH_TITLE_LIST
		global SHORTCUT_KEY_INDEX_ARR_LEFT
		shortcut_cnt_left := SHORTCUT_KEY_INDEX_ARR_LEFT.Count()
		dot_space_str := ""
		for index, title in WEB_SEARCH_TITLE_LIST {
			if (index <= shortcut_cnt_left) {
				menu_shortcut_str := get_menu_shortcut_str(SHORTCUT_KEY_INDEX_ARR_LEFT, index, dot_space_str, title)
				; _cur_shortcut_str := SHORTCUT_KEY_INDEX_ARR_LEFT[index]
				; ;; 如果快捷键为空格的话, 得特殊处理
				; _cur_shortcut_str := _cur_shortcut_str == " " ? _cur_shortcut_str . "(" . lang("space") . ")" : _cur_shortcut_str
				; m(_cur_shortcut_str)
				;; 要为菜单项名称的某个字母加下划线, 在这个字母前加一个 & 符号. 当菜单显示出来时, 此项可以通过按键盘上对应的按键来选中.
				Menu, SearchPlus_Command_Menu, Add, % menu_shortcut_str, SearchPlus_Menu_Click
			}
			Else {
				Menu, SearchPlus_Menu_More, Add, % index . dot_space_str . title, SearchPlus_Menu_MoreClick
			}
		}
		if (WEB_SEARCH_TITLE_LIST.Count() > shortcut_cnt_left)
			Menu, SearchPlus_Command_Menu, Add, % lang("More"), :SearchPlus_Menu_More

		;;;;;; command
		Menu, SearchPlus_Command_Menu, Add  ;; 加个分割线
		global COMMAND_TITLE_LIST
		global SHORTCUT_KEY_INDEX_ARR_RIGHT
		shortcut_cnt_right := SHORTCUT_KEY_INDEX_ARR_RIGHT.Count()
		for index, title in COMMAND_TITLE_LIST {
			if (index <= shortcut_cnt_right) {
				menu_shortcut_str := get_menu_shortcut_str(SHORTCUT_KEY_INDEX_ARR_RIGHT, index, dot_space_str, title)
				Menu, SearchPlus_Command_Menu, Add, % menu_shortcut_str, Command_Menu_Click
			}
			Else {
				Menu, Command_Menu_More, Add, % index . dot_space_str . title, Command_Menu_MoreClick
			}
		}
		if (COMMAND_TITLE_LIST.Count() > shortcut_cnt_right)
			Menu, SearchPlus_Command_Menu, Add, % lang("More"), :Command_Menu_More

		Menu, SearchPlus_Command_Menu, Show
	} 

	HandleSearchGuiUserInput(gui_user_input)
	{
		trim_gui_user_input := Trim(gui_user_input)
		if !trim_gui_user_input
		{
			return
		}
		else
		{
			SearchPlus.HandleSearch(trim_gui_user_input)
		}
	}


	HandleCommand(command_title, cur_sel_text) 
	{
		global COMMAND_TITLE_2_ACTION_MAP
		if (COMMAND_TITLE_2_ACTION_MAP.HasKey(command_title))
		{
			if (command_title == "Everything" && cur_sel_text) {
				;;; everything search
				everything_exe_path := COMMAND_TITLE_2_ACTION_MAP["Everything"][1]
				run, %everything_exe_path%
				WinWaitActive, ahk_exe Everything.exe, , 2.222
				if ErrorLevel
					MsgBox,,, please install Everything and set its path in conf.user.yaml
				else if (cur_sel_text) {
					Send, {Blind}{Text}%cur_sel_text%
				}
				return
			}

			USE_CURRENT_DIRECTORY_PATH_CMDs := {"cmd" : "C: && cd %UserProfile%\Desktop", "git" : "cd ~/Desktop"}
			use_cur_path := USE_CURRENT_DIRECTORY_PATH_CMDs.HasKey(command_title)
			IfWinActive, ahk_exe explorer.exe ahk_class CabinetWClass  ; from file explorer
			{
				if (use_cur_path) {
					Send, !d
					final_cmd_str := StringJoin(" ", COMMAND_TITLE_2_ACTION_MAP[command_title]*) . "`n"
					; m(final_cmd_str)
					; SendInput, %final_cmd_str%  ; 类似于等同于下面这两句
					; SendRaw, cmd
					; Send, {Enter}
					Send, {Blind}{Text}%final_cmd_str%
					; SendRaw, %final_cmd_str%
					return
				}
			}
			run(COMMAND_TITLE_2_ACTION_MAP[command_title])
			if (use_cur_path) {
				file_path_str := COMMAND_TITLE_2_ACTION_MAP[command_title][1]  ; just like: "C:\Program Files\Git\bin\bash.exe"
				; m(file_path_str)
				RegExMatch(file_path_str, "([^<>\/\\|:""\*\?]+)\.\w+", file_name)  ; file_name just like: "bash.exe""
				; m(file_name)
				WinWaitActive, ahk_exe %file_name%,, 2222
				if !ErrorLevel {
					cd_user_desktop_cmd_input := USE_CURRENT_DIRECTORY_PATH_CMDs[command_title] . "`n"
					; SendInput, %cd_user_desktop_cmd_input%
					Send, {Blind}{Text}%cd_user_desktop_cmd_input%
				}
			}
		}
	}

}



Sub_Nothing:
	Return


SearchPlus_Menu_Click:
	cur_sel_text := GetCurSelectedText()
	dec_cnt := cur_sel_text ? 2 : 0
	SearchPlus.cur_sel_search_title := WEB_SEARCH_TITLE_LIST[A_ThisMenuItemPos - dec_cnt]
	if cur_sel_text
		SearchPlus.HandleSearch(cur_sel_text)
	else
		SearchPlus.search_gui_spawn()
	Return

SearchPlus_Menu_MoreClick:
	cur_sel_text := GetCurSelectedText()
	SearchPlus.cur_sel_search_title := WEB_SEARCH_TITLE_LIST[SHORTCUT_KEY_INDEX_ARR_LEFT.Count() + A_ThisMenuItemPos]
	if cur_sel_text
		SearchPlus.HandleSearch(cur_sel_text)
	else
		SearchPlus.search_gui_spawn()
	Return


Command_Menu_Click:
	cur_sel_text := GetCurSelectedText()
	dec_cnt := cur_sel_text ? 2 : 0
	ws_cnt := WEB_SEARCH_TITLE_LIST.Count()
	sk_l_cnt := SHORTCUT_KEY_INDEX_ARR_LEFT.Count()
	dec_cnt += (ws_cnt > sk_l_cnt) ? sk_l_cnt : ws_cnt
	dec_cnt += 1  ; search 和 command 之间有个分割线

	search_title := COMMAND_TITLE_LIST[A_ThisMenuItemPos - dec_cnt]
	SearchPlus.HandleCommand(search_title, cur_sel_text)
	Return


Command_Menu_MoreClick:
	cur_sel_text := GetCurSelectedText()
	search_title := COMMAND_TITLE_LIST[SHORTCUT_KEY_INDEX_ARR_RIGHT.Count() + A_ThisMenuItemPos]
	SearchPlus.HandleCommand(search_title, cur_sel_text)
	Return




;-------------------------------------------------------------------------------
; GUI FUNCTIONS AND SUBROUTINES
;-------------------------------------------------------------------------------

search_gui_destroy() {
	; Hide GUI
	Gui, Destroy
}

; Automatically triggered on Escape key:
GuiEscape:
	search_gui_destroy()
	return

Sub_HandleSearchGuiUserInput:
	Gui, Submit, NoHide
	search_gui_destroy()
	SearchPlus.HandleSearchGuiUserInput(GuiUserInput)
	return



; //////////////////////////////////////////////////////////////////////////
SUB_CMD_WEB_SEARCH_FILE_END_LABEL:
	temp_cws := "blabla"
