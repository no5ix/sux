
if(A_ScriptName=="search_plus.ahk") {
	ExitApp
}


is_gui_open = 0


; with this label, you can include this file on top of the file
Goto, SUB_SEARCH_PLUS_FILE_END_LABEL
#Include %A_ScriptDir%\source\common_const.ahk
#Include %A_ScriptDir%\source\sux_core.ahk
#Include %A_ScriptDir%\source\util.ahk



class SearchPlus {

	static cur_sel_search_title := ""

	AddSearchPlusSubMenu() {
		global WEB_SEARCH_TITLE_LIST
		global SEARCH_PLUS_SHORTCUT_KEY_INDEX_ARR
		shortcut_cnt_left := SEARCH_PLUS_SHORTCUT_KEY_INDEX_ARR.Count()
		for index, title in WEB_SEARCH_TITLE_LIST {
			if (index <= shortcut_cnt_left) {
				menu_shortcut_str := get_menu_shortcut_str(SEARCH_PLUS_SHORTCUT_KEY_INDEX_ARR, index, lang(title))
				;; 要为菜单项名称的某个字母加下划线, 在这个字母前加一个 & 符号. 当菜单显示出来时, 此项可以通过按键盘上对应的按键来选中.
				Menu, QuickEntry_Menu, Add, % menu_shortcut_str, QuickEntry_Search_Menu_Click
			}
			Else {
				Menu, QuickEntry_Search_Menu_More, Add, % lang(title), QuickEntry_Search_Menu_MoreClick
			}
		}
		if (WEB_SEARCH_TITLE_LIST.Count() > shortcut_cnt_left)
			Menu, QuickEntry_Menu, Add, % lang("More Search"), :QuickEntry_Search_Menu_More

	}

	HandleSearch(search_str) {
		search_title := SearchPlus.cur_sel_search_title
		global WEB_SEARCH_TITLE_2_URL_MAP
		; if (search_str == "")
		; 	return
		; 当填了 url 的时候
		if (IsRawUrl(search_str)) {
			if not IsStandardRawUrl(search_str)
				search_str := StringJoin("", ["http://", search_str]*)
			Run %search_str%
			return
		}

		for _index, search_url in WEB_SEARCH_TITLE_2_URL_MAP[search_title] {
			; m(_index "//" search_url)
			; if (search_str == search_title) {	;; 说明用户动原本search_gui里被默认就选中的的search_title
			if (search_str == "") {	;; 说明用户动原本search_gui里被默认就选中的的search_title
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


	search_gui_spawn(cur_sel_text) {
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

		global is_gui_open
		; m(is_gui_open)

		global THEME_CONF_REGISTER_MAP
		; cur_theme_type := SuxCore.GetIniConfig("theme", SuxCore.Default_theme)
		cur_theme_type := SuxCore.current_real_theme
		cur_theme_info := THEME_CONF_REGISTER_MAP[cur_theme_type]
		
		xMidScrn := GetMouseMonitorMidX()
		xMidScrn -= cur_theme_info["sux_width"] / 2 
		yScrnOffset := A_ScreenHeight / 4

		ToolTipWithTimer(SearchPlus.cur_sel_search_title, 2222, xMidScrn, yScrnOffset-29)
		if (is_gui_open == 1)  {
			return
		}

		is_gui_open = 1

		Gui, SearchGui_: New

		; Gui, +AlwaysOnTop -SysMenu +ToolWindow -caption +Border
		Gui, SearchGui_: -SysMenu +ToolWindow -caption +hWndhMyGUI
		Gui, SearchGui_: Margin, 0, 0

		sux_bg_color := cur_theme_info["sux_bg_color"] 
		Gui, SearchGui_: Color, %sux_bg_color%, %sux_bg_color%
		if (cur_theme_info["sux_border_shadow_type"] == "modern_shadow_type") {
			; SearchPlus.ShadowBorder(hMyGUI)
		; else
			SearchPlus.FrameShadow(hMyGUI)
		}

		Gui, SearchGui_: Font, s22, Segoe UI
		; Gui, Font, s10, Segoe UI
		; Gui, Add, Edit, %gui_control_options% vGuiUserInput gSub_HandleSearchGuiUserInput
		gui_control_options := "-WantReturn xm+6 ym+8 w" . cur_theme_info["sux_width"] . " c" . cur_theme_info["sux_text_color"] . " -E0x200"
		; gui_control_options := "w" . cur_theme_info["sux_width"] . " c" . cur_theme_info["sux_text_color"] . "  -E0x800000"
		; Gui, Add, Edit, %gui_control_options% vGuiUserInput, %final_search_str%
		; pre_input_str := cur_sel_text ? cur_sel_text : SearchPlus.cur_sel_search_title

		pre_input_str := cur_sel_text
		Gui, SearchGui_: Add, Edit, %gui_control_options% vGuiUserInput, % pre_input_str
		; Gui, Add, Edit, %gui_control_options% vGuiUserInput, %curr_select_text%
		; Gui, Add, Edit, xm w620 ccBlack -E0x200 vGuiUserInput, %final_search_str%

		Gui, SearchGui_: Add, Button, x-10 y-10 w1 h1 +default gSub_HandleSearchGuiUserInput ; hidden button

		Gui, SearchGui_: Show, x%xMidScrn% y%yScrnOffset%, myGUI

		global auto_destory_quick_entry_gui_period
		; gui_des := ObjBindMethod(this, "search_gui_destroy")  ; 不建议用这个, 这个不会顶掉原先search_gui_destroy的timer的
		; SetTimer, % gui_des, %auto_destory_gui_period%
		SetTimer, search_gui_destroy, %auto_destory_quick_entry_gui_period%
		return
	}

	HandleSearchGuiUserInput(gui_user_input)
	{
		trim_gui_user_input := Trim(gui_user_input)
		; if !trim_gui_user_input
		; {
		; 	return
		; }
		; else
		; {
			SearchPlus.HandleSearch(trim_gui_user_input)
		; }
	}
}


; Hide GUI
search_gui_destroy(from_timer=1) {
    IfWinActive, ahk_exe AutoHotkey.exe ahk_class AutoHotkeyGUI
	{
		if (from_timer) {
			global auto_destory_quick_entry_gui_period
			SetTimer, search_gui_destroy, %auto_destory_quick_entry_gui_period%
			Return
		}
	}
	global is_gui_open
	is_gui_open = 0
	Gui, SearchGui_:Destroy
}

; Automatically triggered on Escape key:
SearchGui_GuiEscape:
	search_gui_destroy(0)
	return

Sub_HandleSearchGuiUserInput:
	Gui, Submit, NoHide
	search_gui_destroy(0)
	SearchPlus.HandleSearchGuiUserInput(GuiUserInput)
	return


    
; //////////////////////////////////////////////////////////////////////////
SUB_SEARCH_PLUS_FILE_END_LABEL:
	temp_sp := "blabla"