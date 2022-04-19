; Note: Save with encoding UTF-8 with BOM if possible.
; Notepad will save UTF-8 files with BOM automatically (even though it does not say so).
; Some editors however save without BOM, and then special characters look messed up in the AHK GUI.

; Initialize variable to keep track of the state of the GUI
; global gui_state := closed


if(A_ScriptName=="quick_entry.ahk") {
	ExitApp
}


; last_search_str = ""
; trim_gui_user_input = ""
current_selected_text = ""


; with this label, you can include this file on top of the file
Goto, SUB_QUICK_ENTRY_FILE_END_LABEL

#Include %A_ScriptDir%\source\common_const.ahk
#Include %A_ScriptDir%\source\sux_core.ahk
#Include %A_ScriptDir%\source\util.ahk
#Include %A_ScriptDir%\source\snip_plus.ahk
#Include %A_ScriptDir%\source\translate.ahk
#Include %A_ScriptDir%\source\search_plus.ahk






class QuickEntry {

	static command_menu_pos_offset := 0
	static screenshot_menu_pos_offset := 0

	init() {
		; ; ; Esc一下, 不然第一次打开search_gui的阴影会有一个从淡到浓的bug
		; Send, {Esc}

		global WEB_SEARCH_TITLE_LIST
		global SEARCH_PLUS_SHORTCUT_KEY_INDEX_ARR

		ws_cnt := WEB_SEARCH_TITLE_LIST.Count()
		sk_l_cnt := SEARCH_PLUS_SHORTCUT_KEY_INDEX_ARR.Count()
		dec_cnt := (ws_cnt > sk_l_cnt) ? sk_l_cnt+1 : ws_cnt  ;; 因为有个"More Search", 所以是 sk_l_cnt+1
		dec_cnt += 1  ; 截图的菜单 和 search 之间有个分割线

		QuickEntry.screenshot_menu_pos_offset := dec_cnt

		; dec_cnt += 1  ; 中间还有1个截图的菜单
		; dec_cnt += 1  ; 中间还有1个贴图的菜单
		; dec_cnt += 1  ; 1个分割线
		dec_cnt += 1  ; 1个Everything的菜单
		dec_cnt += 1  ; 1个翻译的菜单
		dec_cnt += 1  ; 1个替换文本的菜单
		dec_cnt += 1  ; 1个变换文本
		dec_cnt += 1  ; 1个历史剪切板的菜单
		QuickEntry.command_menu_pos_offset := dec_cnt
	}

	
	ShowQuickEntryMenu() {
		search_gui_destroy()

		try {
			Menu, QuickEntry_Menu, DeleteAll
		}
		try {
			Menu, QuickEntry_Search_Menu_More, DeleteAll
		}
		try {
			Menu, QuickEntry_Command_Menu, DeleteAll
		}
		try {
			Menu, QuickEntry_Command_Menu_More, DeleteAll
		}
		try {
			Menu, QuickEntry_TransformText_Detail_Menu, DeleteAll
		}

		global current_selected_text
		current_selected_text := GetCurSelectedText()
		if (current_selected_text) {
			tips_msg := lang("Selected") . ": " . SubStr(current_selected_text, 1, 6) . "..."
			; m(tips_msg)
			Menu, QuickEntry_Menu, Add, % tips_msg, QuickEntry_Sub_Nothing
			Menu, QuickEntry_Menu, Disable, % tips_msg
			Menu, QuickEntry_Menu, Add
		}
		else {
			; tips_msg := lang("Tips: ") . lang("after selecting text, this menu can automatically process it") . "."
			
		}
		
		; global WEB_SEARCH_TITLE_LIST
		; global SEARCH_PLUS_SHORTCUT_KEY_INDEX_ARR
		; shortcut_cnt_left := SEARCH_PLUS_SHORTCUT_KEY_INDEX_ARR.Count()
		; for index, title in WEB_SEARCH_TITLE_LIST {
		; 	if (index <= shortcut_cnt_left) {
		; 		menu_shortcut_str := get_menu_shortcut_str(SEARCH_PLUS_SHORTCUT_KEY_INDEX_ARR, index, lang(title))
		; 		;; 要为菜单项名称的某个字母加下划线, 在这个字母前加一个 & 符号. 当菜单显示出来时, 此项可以通过按键盘上对应的按键来选中.
		; 		Menu, QuickEntry_Menu, Add, % menu_shortcut_str, QuickEntry_Search_Menu_Click
		; 	}
		; 	Else {
		; 		Menu, QuickEntry_Search_Menu_More, Add, % lang(title), QuickEntry_Search_Menu_MoreClick
		; 	}
		; }
		; if (WEB_SEARCH_TITLE_LIST.Count() > shortcut_cnt_left)
		; 	Menu, QuickEntry_Menu, Add, % lang("More Search"), :QuickEntry_Search_Menu_More

		SearchPlus.AddSearchPlusSubMenu()

		;;;;;; Screen Shot
		Menu, QuickEntry_Menu, Add  ;; 加个分割线
		; Menu, QuickEntry_Menu, Add, % lang("Screen Shot") . "`t&`t(" . lang("tab") . ")", QuickEntry_ScreenShot_Suspend_Menu_Click
		; Menu, QuickEntry_Menu, Add, % lang("Suspend Screenshot") . "`t&s", QuickEntry_ScreenShot_Suspend_Menu_Click
		; Menu, QuickEntry_Menu, Add  ;; 加个分割线
		Menu, QuickEntry_Menu, Add, % lang("Everything") . "`t&e", QuickEntry_Everything_Menu_Click
		Menu, QuickEntry_Menu, Add, % lang("Translate Text") . "`t&f", QuickEntry_Translation_Menu_Click
		Menu, QuickEntry_Menu, Add, % lang("Replace Text") . "`t&r", QuickEntry_ReplaceText_Menu_Click

		;;; clipboard_plus
		ClipboardPlus.ShowAllClips()

		;;;;;; command
		global COMMAND_TITLE_LIST
		global SHORTCUT_KEY_INDEX_ARR_LEFT_HAS_SPACE_TAB
		cur_shortcut_cnt := SHORTCUT_KEY_INDEX_ARR_LEFT_HAS_SPACE_TAB.Count()
		for index, title in COMMAND_TITLE_LIST {
			if (index <= cur_shortcut_cnt) {
				menu_shortcut_str := get_menu_shortcut_str(SHORTCUT_KEY_INDEX_ARR_LEFT_HAS_SPACE_TAB, index, title)
				Menu, QuickEntry_Command_Menu, Add, % menu_shortcut_str, QuickEntry_Command_Menu_Click
			}
			Else {
				Menu, QuickEntry_Command_Menu_More, Add, % title, QuickEntry_Command_Menu_MoreClick
			}
		}
		Menu, QuickEntry_Menu, Add, % lang("Command") . "`t&c", :QuickEntry_Command_Menu
		if (COMMAND_TITLE_LIST.Count() > cur_shortcut_cnt)
			Menu, QuickEntry_Command_Menu, Add, % lang("More Command"), :QuickEntry_Command_Menu_More
		
		;; transform text
		global TRANSFORM_TEXT_SHORTCUT_KEY_INDEX_ARR
		global TRANSFORM_TEXT_MAP
		for index, pattern in TRANSFORM_TEXT_MAP {
			if (pattern == "|")
				Menu, QuickEntry_TransformText_Detail_Menu, Add
			else {
				; Menu, QuickEntry_TransformText_Detail_Menu, Add, % "&" . index . ".`t" . pattern, QuickEntry_TransformText_Detail_Menu_click
				menu_shortcut_str := get_menu_shortcut_str(TRANSFORM_TEXT_SHORTCUT_KEY_INDEX_ARR, index, lang(pattern))
				Menu, QuickEntry_TransformText_Detail_Menu, Add, % menu_shortcut_str, QuickEntry_TransformText_Detail_Menu_click
			}
		}
		Menu, QuickEntry_Menu, Add, % lang("Transform Text") . "`t&g", :QuickEntry_TransformText_Detail_Menu
		
		;;;
		Menu, QuickEntry_Menu, Show
	} 


	HandleCommand(command_title, cur_sel_text) 
	{
		global COMMAND_TITLE_2_ACTION_MAP
		if (COMMAND_TITLE_2_ACTION_MAP.HasKey(command_title))
		{
			if (command_title == "Everything" && cur_sel_text) {
				;;; everything search
				everything_exe_path := COMMAND_TITLE_2_ACTION_MAP["Everything"]
				run, %everything_exe_path%
				WinWaitActive, ahk_exe Everything.exe, , 2.222
				if ErrorLevel
					MsgBox,0x10,% SuxCore.ProgramName, % lang("please install Everything and set its path in conf.user.json") . " ."
				else if (cur_sel_text) {
					; Send, {Blind}{Text}%cur_sel_text%
					PasteContent(cur_sel_text)
				}
				; m("xxd")
				return
			}


			USE_CURRENT_DIRECTORY_PATH_CMDs := {"cmd" : "C: && cd %UserProfile%\Desktop`n", "git" : "cd ~/Desktop`n"}
			use_cur_path := USE_CURRENT_DIRECTORY_PATH_CMDs.HasKey(command_title)
			if (IsFileExplorerActive())
			{
				if (use_cur_path) {
					Send, !d
					final_cmd_str := StringJoin(" ", COMMAND_TITLE_2_ACTION_MAP[command_title])
					Send, {Blind}{Text}%final_cmd_str%
					; tt(final_cmd_str, 2222)
					Sleep, 66
					; PasteContent(final_cmd_str)
					; Sleep, 66
					Send, {Enter}
					return
				}
			}
			run(COMMAND_TITLE_2_ACTION_MAP[command_title])
			if (IsDesktopActive() && use_cur_path) {
				file_path_str := COMMAND_TITLE_2_ACTION_MAP[command_title]  ; just like: "C:\Program Files\Git\bin\bash.exe"
				; m(file_path_str)
				; RegExMatch(file_path_str, "([^<>\/\\|:""\*\?]+)\.\w+", file_name)  ; file_name just like: "bash.exe""
				file_name := GetFileNameFromFullPath(file_path_str)
				; m(file_name)
				WinWaitActive, ahk_exe %file_name%,, 2222
				if !ErrorLevel {
					cd_user_desktop_cmd_input := USE_CURRENT_DIRECTORY_PATH_CMDs[command_title]
					Send, {Blind}{Text}%cd_user_desktop_cmd_input%
					; PasteContent(cd_user_desktop_cmd_input)
					; Send, {Enter}
				}
			}
		}
	}

}


QuickEntry_Sub_Nothing:
	Return


QuickEntry_Search_Menu_Click:
	dec_cnt := current_selected_text ? 2 : 0
	SearchPlus.cur_sel_search_title := WEB_SEARCH_TITLE_LIST[A_ThisMenuItemPos - dec_cnt]
	; if current_selected_text
	; 	SearchPlus.HandleSearch(current_selected_text)
	; else
		SearchPlus.search_gui_spawn(current_selected_text)
	Return

QuickEntry_Search_Menu_MoreClick:
	SearchPlus.cur_sel_search_title := WEB_SEARCH_TITLE_LIST[SEARCH_PLUS_SHORTCUT_KEY_INDEX_ARR.Count() + A_ThisMenuItemPos]
	; if current_selected_text
	; 	SearchPlus.HandleSearch(current_selected_text)
	; else
		SearchPlus.search_gui_spawn(current_selected_text)
	Return


QuickEntry_Command_Menu_Click:
	; dec_cnt := (current_selected_text ? 2 : 0) + QuickEntry.command_menu_pos_offset
	; search_title := COMMAND_TITLE_LIST[A_ThisMenuItemPos - dec_cnt]
	search_title := COMMAND_TITLE_LIST[A_ThisMenuItemPos]
	QuickEntry.HandleCommand(search_title, current_selected_text)
	Return


QuickEntry_Command_Menu_MoreClick:
	search_title := COMMAND_TITLE_LIST[SHORTCUT_KEY_INDEX_ARR_LEFT_HAS_SPACE_TAB.Count() + A_ThisMenuItemPos]
	QuickEntry.HandleCommand(search_title, current_selected_text)
	Return


QuickEntry_ScreenShot_Suspend_Menu_Click:
	dec_cnt := (current_selected_text ? 2 : 0) + QuickEntry.screenshot_menu_pos_offset
	if (A_ThisMenuItemPos - dec_cnt == 1) {
		SnipPlus.AreaScreenShot()
	}
	else {
		SnipPlus.AreaScreenShotAndSuspend()
	}
	Return



QuickEntry_Everything_Menu_Click:
	st := current_selected_text
	if (!st) {
		st := GetCurSelectedText()
		if (st) {
			Sleep, 222
		}
	}
	Send, #!s
	if (st) {
		Sleep, 666
		PasteContent(st)
	}
	Return


QuickEntry_Translation_Menu_Click:
	TranslateSeletedText(GetCurSelectedText())
	Return


QuickEntry_TransformText_Detail_Menu_click:
	st := TransformText(GetCurSelectedText(), A_ThisMenuItemPos)
	PasteContent(st)
	Return


QuickEntry_ReplaceText_Menu_Click:
	st := current_selected_text
	if (!current_selected_text) {
		send, {Home}
		Sleep, 66
		send, +{End}
		st := GetCurSelectedText()
	}
	
	global STR_REPLACE_CONF_REGISTER_MAP
	; store the number of replacements that occurred (0 if none).
	replace_sum := 0
	for key, value in STR_REPLACE_CONF_REGISTER_MAP ; Enumeration is the recommended approach in most cases.
	{
		cur_replace_cnt := 0
		; Using "Loop", indices must be consecutive numbers from 1 to the number
		; of elements in the array (or they must be calculated within the loop).
		; MsgBox % "Element number " . A_Index . " is " . Array[A_Index]
		; Using "for", both the index (or "key") and its associated value
		; are provided, and the index can be *any* value of your choosing.
		; m(key "//" value)
		st := StrReplace(st, key, value, cur_replace_cnt)
		replace_sum += cur_replace_cnt
	}
	Sleep, 66
	if replace_sum != 0
		PasteContent(st)
	else
		Send, {Right}
	Return



; //////////////////////////////////////////////////////////////////////////
SUB_QUICK_ENTRY_FILE_END_LABEL:
	temp_cws := "blabla"
