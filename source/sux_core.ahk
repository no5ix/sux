
if(A_ScriptName=="sux_core.ahk") {
	ExitApp
}
; with this label, you can include this file on top of the file


check_update_from_launch = 0
cur_http_req = 
CAPS_REPLACER := "CapsLock & "
DOUBLE_HIT_KEY_PREFIX := "doublehit_"
TRIPLE_HIT_KEY_PREFIX := "triplehit_"

MULTI_HIT_DECORATOR := "~"
; MULTI_HIT_DECORATOR := " Up"

MULTI_HIT_MAP := {}

HANDLE_SINGLE_DOUBLE_HIT_MODE_1 := 1
HANDLE_SINGLE_DOUBLE_HIT_MODE_2 := 2

MULTI_HIT_CNT := 0


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Goto, SUB_SUX_CORE_FILE_END_LABEL


#Include %A_ScriptDir%\source\common_const.ahk
#Include %A_ScriptDir%\source\yaml.ahk
#Include %A_ScriptDir%\source\action.ahk
#Include %A_ScriptDir%\source\tray_menu.ahk
#Include %A_ScriptDir%\source\search_gui.ahk





lang(key)
{
	global LANGUAGE_CONF_MAP
	lang := SuxCore.GetIniConfig("lang", SuxCore.Default_lang)
	if (lang == SuxCore.Default_lang) {
		ret := LANGUAGE_CONF_MAP[key]
		if !ret
			ret := key
	}
	else
		ret := key
	return ret
}


CheckUpdate(from_launch=0)
{
	global LIMIT_MODE
	if (LIMIT_MODE)
		return
	global check_update_from_launch
	check_update_from_launch := from_launch
	SuxCore.get_remote_file(SuxCore.data_ini_file)
}


get_remote_data_ini(url)
{
	global cur_http_req
	cur_http_req := ComObjCreate("Msxml2.XMLHTTP")
	; 打开启用异步的请求.
	cur_http_req.open("GET", url, true)
	; 设置回调函数 [需要 v1.1.17+].
	cur_http_req.onreadystatechange := Func("on_get_remote_data_ini_ready")
	; 发送请求. Ready() 将在其完成后被调用.
	cur_http_req.send()
	SetTimer, handle_req_failed, -6666
}


on_get_remote_data_ini_ready() {
	global cur_http_req
	global check_update_from_launch
	if (cur_http_req.readyState != 4) {  ; 没有完成.
		return
	}
	if (cur_http_req.status == 200) {
		if FileExist(SuxCore.remote_data_ini_file)
			FileDelete, % SuxCore.remote_data_ini_file
		FileAppend, % cur_http_req.responseText, % SuxCore.remote_data_ini_file
		remote_ver_str := SuxCore.get_remote_ini_config("ver")
		if (get_version_sum(remote_ver_str) > get_version_sum(SuxCore.version)) {
			TrayMenu.update_tray_menu()
			MsgBox, 4,, % lang("There is a new version sux, would you like to check it out?")
			IfMsgBox Yes
			{
				run, % SuxCore.remote_download_html
			}
		}
		else {
			if (check_update_from_launch == 0)
				MsgBox,,, % lang("This is the lastest version.") ,6
		}
	}
	else {
		; m("xxd")
		handle_req_failed()
	}
	cur_http_req = 
	check_update_from_launch := 0
}

handle_req_failed() {
	global cur_http_req
	global check_update_from_launch
	; m("xx")
	if !cur_http_req {
	; m("xx1")
		cur_http_req = 
		return
	}
	if (cur_http_req.readyState != 4) {  ; 没有完成.
	; m("xx2")
		cur_http_req = 
		; return
		state_code := 12007
	}
	else {
		state_code := cur_http_req.status
		cur_http_req = 
	}
	if (check_update_from_launch == 0) {
		msg := lang("Can not connect to sux official website.") "`n"
		; if (state_code == 12007 || state_code == 12029) {
			msg := msg lang("Maybe need a proxy.") "`n"
		; }
		msg := msg lang("Do you want to open it with your browser?")
		MsgBox,4,, % msg ,8
		IfMsgBox Yes
		{
			run, % SuxCore.remote_download_html
		} 
	}
	check_update_from_launch := 0
}




class SuxCore
{
	; dir
	static _APP_DATA_DIR := "app_data/"
	; file
	static Launcher_Name := A_WorkingDir "\sux.exe"
	static conf_user_yaml_file := "conf.user.yaml"
	static conf_default_yaml_file := SuxCore._APP_DATA_DIR "conf.default.yaml"
	static data_ini_file := SuxCore._APP_DATA_DIR "data.ini"
	static remote_data_ini_file := SuxCore._APP_DATA_DIR "remote_data.ini"
	; update
	; online
	static Project_Home_Page := "https://github.com/no5ix/sux"
	static Project_Issue_page := "https://github.com/no5ix/sux/issues"
	static donate_page := "https://github.com/no5ix/sux#%E6%8D%90%E8%B5%A0"
	static remote_download_html := "https://github.com/no5ix/sux/releases"
	static help_addr := "https://github.com/no5ix/sux#features"
	; remote file path
	static stable_branch := "master"
	static remote_raw_addr := "https://raw.githubusercontent.com/no5ix/sux/" SuxCore.stable_branch "/"
	;
	static FeatureObj =
	static version := "0.2.3"
	static UserData := {}
	; callback
	static OnExitCmd := []
	static OnClipboardChangeCmd := []
	static OnPauseCmd := []
	static OnSuspendCmd := []
	; static var
	static ProgramName := "sux"
	static Default_lang := "cn"
	static Default_theme := "light"
	static Default_autorun_switch := 0
	static Default_hot_corner_switch := 0
	static Default_limit_mode_in_full_screen_switch := 1
	static Default_disable_win10_auto_update_switch := 0
	static Browser := "default"

	init()
	{
		SetBatchLines, -1   ; maximize script speed!
		SetWinDelay, -1
		CoordMode, Mouse, Screen
		CoordMode, ToolTip, Screen
		CoordMode, Menu, Screen

		if !FileExist(SuxCore._APP_DATA_DIR)  
        	FileCreateDir, % SuxCore._APP_DATA_DIR

		this.HandleConfYaml()
		; this.version := SuxCore.GetIniConfig("ver")
		CheckUpdate(1)

		ClipboardPlus.init()
		; WinMenu.init()
		TrayMenu.init()
		SearchGui.init()
	}

	get_remote_file(path)
	{
		StringReplace, path, % path, \, /, All
		url := SuxCore.remote_raw_addr path
		get_remote_data_ini(url)
	}

	get_remote_ini_config(key, default="", section="sux", autoWrite=true)
	{
		IniRead, output, % SuxCore.remote_data_ini_file, % section, % key, ""
		return output
	}

	GetIniConfig(key, default="", section="sux", autoWrite=true)
	{
		IniRead, output, % SuxCore.data_ini_file, % section, % key
		if(output=="ERROR" || output == "")
		{
			if(autoWrite) {
				SuxCore.SetIniConfig(key, default, section)
			}
			return default
		}
		return output
	}

	SetIniConfig(key, value, section="sux")
	{
		IniWrite, % value, % SuxCore.data_ini_file, % section, % key
	}

	OnClipboardChange(func)
	{
		this.OnClipboardChangeCmd.Insert(func)
	}

	GetYamlCfg(keyStr, default="")
	{
		keyArray := StrSplit(keyStr, ".")
		obj := SuxCore.FeatureObj
		Loop, % keyArray.MaxIndex()-1
		{
			cur_key := keyArray[A_Index]
			obj := obj[cur_key]
		}
		cur_key := keyArray[keyArray.MaxIndex()]
		if(obj[cur_key]=="")
		{
			return default
		}
		return obj[cur_key]
	}

	HandleConfYaml()
	{
		if(!FileExist(this.conf_user_yaml_file)) {
			FileCopy, % this.conf_default_yaml_file, % this.conf_user_yaml_file, 0
		}
		SuxCore.FeatureObj := Yaml(SuxCore.conf_user_yaml_file)

		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		
		check_update_interval_hour := SuxCore.GetYamlCfg("check-update-interval-hour", 2)
		check_update_millisec := check_update_interval_hour * 3600 * 1000
		SetTimer, CheckUpdate, % check_update_millisec

		if(SuxCore.GetYamlCfg("hotkey.enable", 0))
		{
			For key, value in SuxCore.GetYamlCfg("hotkey.buildin", {})
				register_hotkey(key, value, "")
			For key, value in SuxCore.GetYamlCfg("hotkey.custom", {})
				register_hotkey(key, value, "")
		}
		if(SuxCore.GetYamlCfg("capslock_plus.enable", 0))
		{
			if (SuxCore.GetYamlCfg("capslock_plus.buildin.capslock", 0) == 0) {
				SetCapsLockState,  ; 如果省略SetCapsLockState后面的参数, 则清除按键的 AlwaysOn/Off 状态(如果存在). 
			}

			For key, value in SuxCore.GetYamlCfg("capslock_plus.buildin", {})
				register_hotkey(key, value, "")
			For key, value in SuxCore.GetYamlCfg("capslock_plus.custom", {})
				register_hotkey(key, value, "")
		}
		else {
			SetCapsLockState,  ; 如果省略SetCapsLockState后面的参数, 则清除按键的 AlwaysOn/Off 状态(如果存在). 
		}

		if(SuxCore.GetYamlCfg("hot-corner", {}))
		{
			For border_key, border_action in SuxCore.GetYamlCfg("hot-corner.action", {}) {
				for key, value in border_action
					register_hotkey(key, value, border_key)
			}
		}

		if(SuxCore.GetYamlCfg("hot-edge.enable", 0))
		{
			For border_key, border_action in SuxCore.GetYamlCfg("hot-edge.action", {})
				for key, value in border_action
					register_hotkey(key, value, border_key)
		}

		comma_delimiters_arr := ["','", "', '", "'，'", "'， '"]
		if(SuxCore.GetYamlCfg("command.enable", 0))
		{
			For key, value in SuxCore.GetYamlCfg("command.buildin", {})
				register_command(key, StrSplit(value, comma_delimiters_arr))
			For key, value in SuxCore.GetYamlCfg("command.custom", {})
				register_command(key, StrSplit(value, comma_delimiters_arr))
		}

		if(SuxCore.GetYamlCfg("web-search.enable", 0))
		{
			_temp_map := {"normal-search": "SearchGui.search_gui_spawn", "search-selected-text":"WebSearchSelectedText"}
			For key, value in SuxCore.GetYamlCfg("web-search.shortcut-key", {})
				register_hotkey(value, _temp_map[key], "")
			For key, value in SuxCore.GetYamlCfg("web-search.buildin", {})
				register_web_search(key, StrSplit(value, comma_delimiters_arr))
			For key, value in SuxCore.GetYamlCfg("web-search.custom", {})
				register_web_search(key, StrSplit(value, comma_delimiters_arr))
		}

		if(SuxCore.GetYamlCfg("replace-text.enable", 0))
		{
			_temp_map := {"replace-all-text": "ReplaceAllText", "replace-selected-text":"ReplaceSelectedText"}
			For key, value in SuxCore.GetYamlCfg("replace-text.shortcut-key", {})
				register_hotkey(value, _temp_map[key], "")
			For key, value in SuxCore.GetYamlCfg("replace-text.buildin", {})
				register_replace_str(key, value)
			For key, value in SuxCore.GetYamlCfg("replace-text.custom", {})
				register_replace_str(key, value)
		}

		For theme_type, theme_info in SuxCore.GetYamlCfg("theme", {}) {
			cur_theme_info := {}
			For theme_key, theme_val in theme_info
				cur_theme_info[theme_key] := theme_val
			register_theme_conf(theme_type, cur_theme_info)
		}

		if(SuxCore.GetYamlCfg("clipboard-plus.enable", 0))
		{
			; For key, value in SuxCore.GetYamlCfg("clipboard-plus.shortcut-key", {})
			; 	register_hotkey(key, value, "")
			shortcut_key := SuxCore.GetYamlCfg("clipboard-plus.shortcut-key", "win_alt_v")
			register_hotkey(shortcut_key, "ClipboardPlus.ShowAllClips")
		}

		global MULTI_HIT_MAP
		global HOTKEY_REGISTER_MAP
		global HANDLE_SINGLE_DOUBLE_HIT_MODE_1
		global HANDLE_SINGLE_DOUBLE_HIT_MODE_2
		global MULTI_HIT_DECORATOR
		for ltrimed_key_name, original_key_2_action_map in MULTI_HIT_MAP {
			if (original_key_2_action_map.Count() == 1 && !original_key_2_action_map.HasKey(TRIPLE_HIT_KEY_PREFIX . ltrimed_key_name)) {
				for key, action in original_key_2_action_map {
					; m(key)
					register_hotkey(key, action, "", HANDLE_SINGLE_DOUBLE_HIT_MODE_1)
				}
			}
			else {
				; m(ltrimed_key_name)
				; register_hotkey(ltrimed_key_name, MULTI_HIT_MAP[ltrimed_key_name][ltr], "", HANDLE_SINGLE_DOUBLE_HIT_MODE_2)
				; is_already_set := 0
				if (original_key_2_action_map.HasKey(ltrimed_key_name)) {
					final_key := ltrimed_key_name
				}
				else {
					final_key := MULTI_HIT_DECORATOR . ltrimed_key_name
				}
				register_hotkey(final_key, "", "", HANDLE_SINGLE_DOUBLE_HIT_MODE_2)  ;; 只用不带doublehit/triplehit的注册, 免得
				for key, action in original_key_2_action_map {
					; m(key)
					HOTKEY_REGISTER_MAP[key] := action

					; if (Instr(key, DOUBLE_HIT_KEY_PREFIX)) {
					; 	HOTKEY_REGISTER_MAP[key] := action
					; 	; register_hotkey(key, action, "", 1)
					; }
					; else {
						; if (is_already_set == 0) {
						; 	register_hotkey(key, action, "", HANDLE_SINGLE_DOUBLE_HIT_MODE_2)
						; 	is_already_set := 1
						; }
					; 	; HOTKEY_REGISTER_MAP[key] := action
					; }
				}
			}
		}

	}
}



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
	global CMD_REGISTER_MAP
	CMD_REGISTER_MAP[key_name] := action
}

register_web_search(key_name, action)
{
	global WEB_SEARCH_REGISTER_MAP
	WEB_SEARCH_REGISTER_MAP[key_name] := action
}

register_replace_str(key_name, val)
{
	global STR_REPLACE_CONF_REGISTER_MAP
	STR_REPLACE_CONF_REGISTER_MAP[key_name] := val
}

register_theme_conf(key_name, val)
{
	global THEME_CONF_REGISTER_MAP
	THEME_CONF_REGISTER_MAP[key_name] := val
}



register_hotkey(key_name, action, prefix="", handle_single_double_hit_mode=0)
{
	global HOTKEY_REGISTER_MAP
	global MULTI_HIT_DECORATOR
	global DOUBLE_HIT_KEY_PREFIX
	global TRIPLE_HIT_KEY_PREFIX
	global CAPS_REPLACER
	global MULTI_HIT_MAP
	global HANDLE_SINGLE_DOUBLE_HIT_MODE_1
	global HANDLE_SINGLE_DOUBLE_HIT_MODE_2

	StringLower, key_name, key_name
	multi_hit_ltrimed_key := StrReplace(key_name, DOUBLE_HIT_KEY_PREFIX)
	multi_hit_ltrimed_key := StrReplace(multi_hit_ltrimed_key, TRIPLE_HIT_KEY_PREFIX)
	; m(multi_hit_ltrimed_key)
	key_split_arr := StrSplit(multi_hit_ltrimed_key, "_")
	excluede_single_key_map := {"hover": "", "wheeldown": "", "wheelup": ""}
	
	if (key_split_arr.Length() == 1 && handle_single_double_hit_mode == 0 && !excluede_single_key_map.HasKey(multi_hit_ltrimed_key)) {
	; if (handle_single_double_hit_mode == 0 && (Instr(key_name, DOUBLE_HIT_KEY_PREFIX) || Instr(key_name, TRIPLE_HIT_KEY_PREFIX))) {
		if !MULTI_HIT_MAP.HasKey(multi_hit_ltrimed_key)
			MULTI_HIT_MAP[multi_hit_ltrimed_key] := {}
		MULTI_HIT_MAP[multi_hit_ltrimed_key][key_name] := action
		return
	}
	map1 := {win: "#", ctrl: "^", shift: "+", alt: "!"
			,hover: "hover", capslock: "CapsLock"
			,lwin: "<#", rwin: ">#"
			,lctrl: "<^", rctrl: ">^"
			,lshift: "<+", rshift: ">+"
			,lalt: "<!", ralt: ">!"
			,lbutton:  "LButton", rbutton:  "RButton", mbutton: "MButton"}

	; if Instr(key_name, "hover")
	; if Instr(key_name, DOUBLE_HIT_KEY_PREFIX)
	; 	m(multi_hit_ltrimed_key)
	; multi_hit_ltrimed_key := StrReplace(key_name, DOUBLE_HIT_KEY_PREFIX)
	; if Instr(key_name, "hover")
	; if Instr(key_name, DOUBLE_HIT_KEY_PREFIX)
	; 	m(multi_hit_ltrimed_key)
	trans_key := []
	Loop, % key_split_arr.MaxIndex()
	{
		cur_symbol := key_split_arr[A_Index]
		if (key_split_arr.Length() == 1) {
			; if (handle_single_double_hit_mode == 0 && !excluede_single_key_map.HasKey(multi_hit_ltrimed_key)) {
			; 	; m(multi_hit_ltrimed_key)
			; 	if !MULTI_HIT_MAP.HasKey(multi_hit_ltrimed_key)
			; 		MULTI_HIT_MAP[multi_hit_ltrimed_key] := {}
			; 	MULTI_HIT_MAP[multi_hit_ltrimed_key][key_name] := action
			; 	return
			; }
			; else {
				if (Instr(key_name, DOUBLE_HIT_KEY_PREFIX) || Instr(key_name, TRIPLE_HIT_KEY_PREFIX)) {
				; 	; m(multi_hit_ltrimed_key)
					maped_symbol := MULTI_HIT_DECORATOR . multi_hit_ltrimed_key
				; 	; maped_symbol := multi_hit_ltrimed_key . MULTI_HIT_DECORATOR
				}
				else {
					maped_symbol := multi_hit_ltrimed_key
				}
			; }
		}
		else { 
		; maped_symbol := (key_split_arr.Length() == 1) ? key_name : map1[cur_symbol] 
			maped_symbol := map1[cur_symbol] 
		}
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

	prefix_arr := StrSplit(prefix, "/")
	prefix_trans_keys := str_array_concate(prefix_arr, trans_key, "|")
	Loop, % prefix_trans_keys.MaxIndex()
	{
		key := prefix_trans_keys[A_Index]
		; StringUpper, key, key
		original_key := key
		if !(original_key = "|CapsLock") {
			; m(original_key)
			key := StrReplace(key, "CapsLock", CAPS_REPLACER)
			key := StrReplace(key, "CapsLock & +", CAPS_REPLACER)
			key := StrReplace(key, "CapsLock & !", CAPS_REPLACER)
			key := StrReplace(key, "CapsLock & ^", CAPS_REPLACER)
			; m(key)
		}

		; if (key_name == "rshift") {
		; 	m(key "//" action)
		; 	m(original_key "//" action)
		; }
		; if (key_name == "doublehit_rshift")
		; 	m(handle_single_double_hit_mode)
		; if (key_name == "rshift")
		; 	m(handle_single_double_hit_mode)

		arr := StrSplit(key, "|")
		if (handle_single_double_hit_mode == HANDLE_SINGLE_DOUBLE_HIT_MODE_2) {
			; m(key_name)
			; HOTKEY_REGISTER_MAP[key_name] := action
			if(arr[1]!="") {
				Hotkey, IF, border_event_evoke()
				Hotkey, % arr[2], SUB_HOTKEY_ZONE_MULTI_HIT
			}
			else {
				; m(arr[2])
				Hotkey, IF
				Hotkey, % arr[2], SUB_HOTKEY_ZONE_MULTI_HIT
			}
		}
		else if (Instr(key_name, DOUBLE_HIT_KEY_PREFIX)) {
		; if (key_split_arr.Length() == 1 && !excluede_single_key_map.HasKey(multi_hit_ltrimed_key)) {
			; if (key_name == "doublehit_rshift") {
			; 	m(original_key)
			; 	m(key "//" action)
				; m(arr[2])
			; }
			; m(key_name)
			HOTKEY_REGISTER_MAP[key_name] := action
			if(arr[1]!="") {
				Hotkey, IF, border_event_evoke()
				Hotkey, % arr[2], SUB_HOTKEY_ZONE_ONLY_DOUBLE_HIT
			}
			else {
				Hotkey, IF
				Hotkey, % arr[2], SUB_HOTKEY_ZONE_ONLY_DOUBLE_HIT
			}
		}
		else {
			; if (key_name == "rshift") {
			; 	m(arr[1])
			; 	m(arr[2])
			; }
			HOTKEY_REGISTER_MAP[original_key] := action
			if (arr[2] == "hover") {
				Continue
			}
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
}


/*
; HOTKEY evoke
*/
SUB_HOTKEY_ZONE_MULTI_HIT:
	global LIMIT_MODE
	global HOTKEY_REGISTER_MAP
	global MULTI_HIT_DECORATOR
	global DOUBLE_HIT_KEY_PREFIX
	global TRIPLE_HIT_KEY_PREFIX
	global MULTI_HIT_CNT

	if (LIMIT_MODE)
		return

	if (MULTI_HIT_CNT > 0) ; SetTimer 已经启动, 所以我们记录键击.
	{
		MULTI_HIT_CNT += 1
		return
	}
	; 否则, 这是新开始系列中的首次按下. 把次数设为 1 并启动
	; 计时器:
	MULTI_HIT_CNT := 1
	SetTimer, MULTI_HIT_TIMER_CB, -400 ; 在 400 毫秒内等待更多的键击.
	return


MULTI_HIT_TIMER_CB:
	global LIMIT_MODE
	global HOTKEY_REGISTER_MAP
	global MULTI_HIT_DECORATOR
	global DOUBLE_HIT_KEY_PREFIX
	global TRIPLE_HIT_KEY_PREFIX
	global MULTI_HIT_CNT

	cur_key := StrReplace(A_ThisHotkey, MULTI_HIT_DECORATOR)
	if (MULTI_HIT_CNT = 1) ; 此键按下了一次.
	{
		; m(cur_key)
		action := HOTKEY_REGISTER_MAP[cur_key]
		; run(action)
	}
	else if (MULTI_HIT_CNT = 2) ; 此键按下了两次.
	{
		; m(cur_key)
		action := HOTKEY_REGISTER_MAP[DOUBLE_HIT_KEY_PREFIX . cur_key]
		; run(action)
	}
	else if (MULTI_HIT_CNT > 2)
	{
		; m(cur_key)
		; MsgBox, Three or more clicks detected.
		action := HOTKEY_REGISTER_MAP[TRIPLE_HIT_KEY_PREFIX . cur_key]
		; run(action)
	}
	; 不论触发了上面的哪个动作, 都对 count 进行重置
	; 为下一个系列的按下做准备:
	run(action)
	MULTI_HIT_CNT := 0
	Return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


SUB_HOTKEY_ZONE_ONLY_DOUBLE_HIT:
	global LIMIT_MODE
	global HOTKEY_REGISTER_MAP
	global MULTI_HIT_DECORATOR
	global DOUBLE_HIT_KEY_PREFIX

	if (LIMIT_MODE)
		return
	; ToolTipWithTimer(A_TimeSincePriorHotkey)
	; ToolTipWithTimer(A_ThisHotkey)
	global keyboard_double_click_timeout
	; cur_key := StrReplace(A_ThisHotkey, "~")
	cur_key := StrReplace(A_ThisHotkey, MULTI_HIT_DECORATOR)
	if (A_PriorHotkey <> A_ThisHotkey or A_TimeSincePriorHotkey > keyboard_double_click_timeout)
	; if (A_PriorHotkey != "~Alt" or A_TimeSincePriorHotkey > keyboard_double_click_timeout)
	{
		; Too much time between presses, so this isn't a double-press.
		; ToolTipWithTimer(A_PriorKey)  ; LAlt
		; ToolTipWithTimer(A_ThisHotkey)  ; ~alt
		; ToolTipWithTimer(A_PriorHotkey)  ; ~alt
		; run(HOTKEY_REGISTER_MAP[cur_key])  ; single hit key action
		KeyWait, % cur_key ; Wait for the key to be released.
		; KeyWait, % A_ThisHotkey ; Wait for the key to be released.
		; KeyWait, %A_PriorHotkey%  ; Wait for the key to be released.
		; KeyWait, Alt  ; Wait for the key to be released.
		; ToolTipWithTimer(A_PriorKey)
		return
	}
	; ToolTipWithTimer(A_ThisHotkey)
	; cur_key := StrReplace(A_ThisHotkey, "~")
	action := HOTKEY_REGISTER_MAP[DOUBLE_HIT_KEY_PREFIX . cur_key]
	; m(action)
	; if(action="") {
	; 	return
	; }
	run(action)
Return


SUB_HOTKEY_ZONE_ANYWAY:
SUB_HOTKEY_ZONE_BORDER:
	global LIMIT_MODE
	global HOTKEY_REGISTER_MAP
	global CAPS_REPLACER

	if (LIMIT_MODE)
		return
	border_code := get_border_code()

	pending_replace_str := "CapsLock"
	pending_replace_str .= GetKeyState("LShift", "P") ? "+": ""
	pending_replace_str .= GetKeyState("Alt", "P") ? "!": ""
	pending_replace_str .= GetKeyState("Control", "P") ? "^": ""
	; m(pending_replace_str)
	
	cur_hotkey := StrReplace(A_ThisHotkey, CAPS_REPLACER, pending_replace_str)
	action := HOTKEY_REGISTER_MAP[border_code "|" cur_hotkey]
	if(action="") {
		; 鼠标移到边缘但触发普通热键时
		action := HOTKEY_REGISTER_MAP["|" cur_hotkey]
	}
	run(action)
Return


#IF border_event_evoke()
#IF

border_event_evoke()
{
	global HOTKEY_REGISTER_MAP
	border_code := get_border_code()
	; ToolTipWithTimer(border_code)

	key := border_code "|" A_ThisHotkey
	; ToolTipWithTimer(key)

	; StringUpper, key, key
	action := HOTKEY_REGISTER_MAP[key]
	if(action!="")
		return true
}





; //////////////////////////////////////////////////////////////////////////
SUB_SUX_CORE_FILE_END_LABEL:
	temp_nc := "blabla"


