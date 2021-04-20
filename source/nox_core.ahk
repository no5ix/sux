
if(A_ScriptName=="nox_core.ahk") {
	ExitApp
}
; with this label, you can include this file on top of the file
Goto, SUB_NOX_CORE_FILE_END_LABEL


#Include %A_ScriptDir%\source\common_const.ahk
#Include %A_ScriptDir%\source\yaml.ahk
#Include %A_ScriptDir%\source\action.ahk
#Include %A_ScriptDir%\source\tray_menu.ahk





lang(key)
{
	global LANGUAGE_CONF_MAP
	lang := NoxCore.GetConfig("lang", NoxCore.Default_lang)
	if (lang == NoxCore.Default_lang) {
		ret := LANGUAGE_CONF_MAP[key]
		if !ret
			ret := key
	}
	else
		ret := key
	return ret
}


check_update_from_launch = 0

CheckUpdate(from_launch=0)
{
	global check_update_from_launch
	check_update_from_launch := from_launch
	NoxCore.get_remote_file(NoxCore.data_ini_file)
}

cur_http_req =

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
}

on_get_remote_data_ini_ready() {
	global cur_http_req
	global check_update_from_launch
	if (cur_http_req.readyState != 4) {  ; 没有完成.
		return
	}
	if (cur_http_req.status == 200) {
		if FileExist(NoxCore.remote_data_ini_file)
			FileDelete, % NoxCore.remote_data_ini_file
		FileAppend, % cur_http_req.responseText, % NoxCore.remote_data_ini_file
		remote_ver_str := NoxCore.get_remote_config("ver")
		if (get_version_sum(remote_ver_str) > get_version_sum(NoxCore.version)) {
			TrayMenu.update_tray_menu()
			MsgBox, 4,, % lang("There is a new version nox, would you like to check it out?")
			IfMsgBox Yes
			{
				run, % NoxCore.remote_download_html
			}
		}
		else {
			if (check_update_from_launch == 0)
				MsgBox,,, % lang("This is the lastest version.") ,6
		}
	}
	else {
		if (check_update_from_launch == 0) {
			msg := lang("Can not connect to GitHub.")
			if (cur_http_req.status == 12007) {
				msg := msg lang(" Maybe need a proxy.")
			}
			MsgBox,,, % msg ,6
		}
	}
	check_update_from_launch := 0
}



class NoxCore
{
	; dir
	static _ICON_DIR := "icon/"
	static _APP_DATA_DIR := "app_data/"
	; file
	static Launcher_Name := A_WorkingDir "\nox.exe"
	static conf_user_yaml_file := "conf.user.yaml"
	static conf_default_yaml_file := "conf.default.yaml"
	static data_ini_file := NoxCore._APP_DATA_DIR "data.ini"
	static remote_data_ini_file := NoxCore._APP_DATA_DIR "remote_data.ini"
	static icon_default := NoxCore._ICON_DIR "1.ico"
	static icon_suspend := NoxCore._ICON_DIR "2.ico"
	static icon_pause := NoxCore._ICON_DIR "4.ico"
	static icon_suspend_pause := NoxCore._ICON_DIR "3.ico"
	; update
	; online
	static Project_Home_Page := "https://github.com/no5ix/nox"
	static Project_Issue_page := "https://github.com/no5ix/nox/issues"
	static donate_page := "https://github.com/no5ix/nox#%E6%8D%90%E8%B5%A0"
	static remote_download_html := "https://github.com/no5ix/nox/releases"
	static help_addr := "https://github.com/no5ix/nox#features"
	; remote file path
	static stable_branch := "master"
	static remote_raw_addr := "https://raw.githubusercontent.com/no5ix/nox/" NoxCore.stable_branch "/"
	;
	static FeatureObj =
	static version =
	static UserData := {}
	; callback
	static OnExitCmd := []
	static OnClipboardChangeCmd := []
	static OnPauseCmd := []
	static OnSuspendCmd := []
	; static var
	static ProgramName := "nox"
	static Default_lang := "cn"
	static Browser := "default"

	init()
	{
		SetBatchLines, -1   ; maximize script speed!
		SetWinDelay, -1
		CoordMode, Mouse, Screen
		CoordMode, ToolTip, Screen
		CoordMode, Menu, Screen

		if !FileExist(NoxCore._APP_DATA_DIR)  
        	FileCreateDir, % NoxCore._APP_DATA_DIR

		this.HandleConfYaml()
		this.version := NoxCore.GetConfig("ver")
		CheckUpdate(1)

		ClipboardPlus.init()
		WinMenu.init()
		TrayMenu.init()
	}

	get_remote_file(path)
	{
		StringReplace, path, % path, \, /, All
		url := NoxCore.remote_raw_addr path
		get_remote_data_ini(url)
	}

	get_remote_config(key, default="", section="nox", autoWrite=true)
	{
		IniRead, output, % NoxCore.remote_data_ini_file, % section, % key, ""
		return output
	}

	GetConfig(key, default="", section="nox", autoWrite=true)
	{
		IniRead, output, % NoxCore.data_ini_file, % section, % key
		if(output=="ERROR")
		{
			if(autoWrite) {
				NoxCore.SetConfig(key, default, section)
			}
			return default
		}
		return output
	}

	SetConfig(key, value, section="nox")
	{
		IniWrite, % value, % NoxCore.data_ini_file, % section, % key
	}


	SetLang(act="itemname")
	{
		if(act="itemname")
		{
			lang_map := {"English": "en", "中文": "cn"}
			lang := lang_map[A_ThisMenuItem]
		}
		else {
			lang := act
		}
		NoxCore.SetConfig("lang", lang)
		NoxCore.ReloadNox()
	}

	ExitNox(show_msg=true)
	{
		ExitApp
	}

	ReloadNox()
	{
		Reload
	}

	SetDisable(act="toggle")
	{
		setdisable := (act="toggle")? !(A_IsPaused&&A_IsSuspended): act
		NoxCore.SetState(setdisable, setdisable)
	}

	Edit_conf_yaml()
	{
		EditFile(NoxCore.conf_user_yaml_file)
	}

	SetState(setsuspend="", setpause="")
	{
		setsuspend := (setsuspend="")? A_IsSuspended: setsuspend
		setpause := (setpause="")? A_IsPaused: setpause
		if(!A_IsSuspended && setsuspend) {
			RunArr(NoxCore.OnSuspendCmd)
		}
		if(!A_IsPaused && setpause) {
			RunArr(NoxCore.OnPauseCmd)
		}
		if(setsuspend) {
			Suspend, On
		}
		else {
			Suspend, Off
		}
		if(setpause) {
			Pause, On, 1
		}
		else {
			Pause, Off
		}
		NoxCore.update_tray_menu()
	}

	OnClipboardChange(func)
	{
		this.OnClipboardChangeCmd.Insert(func)
	}

	; feature.yaml
	GetFeatureCfg(keyStr, default="")
	{
		keyArray := StrSplit(keyStr, ".")
		obj := NoxCore.FeatureObj
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
		NoxCore.FeatureObj := Yaml(NoxCore.conf_user_yaml_file)

		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		
		check_update_interval_hour := NoxCore.GetFeatureCfg("check-update-interval-hour", 2)
		check_update_millisec := check_update_interval_hour * 3600 * 1000
		SetTimer, CheckUpdate, % check_update_millisec

		if(NoxCore.GetFeatureCfg("hotkey.enable", 0))
		{
			For key, value in NoxCore.GetFeatureCfg("hotkey.buildin", {})
				register_hotkey(key, value, "")
			For key, value in NoxCore.GetFeatureCfg("hotkey.custom", {})
				register_hotkey(key, value, "")
		}
		if(NoxCore.GetFeatureCfg("capslock_plus.enable", 0))
		{
			if (NoxCore.GetFeatureCfg("capslock_plus.buildin.capslock", 0) == 0) {
				SetCapsLockState,  ; 如果省略SetCapsLockState后面的参数, 则清除按键的 AlwaysOn/Off 状态(如果存在). 
			}

			For key, value in NoxCore.GetFeatureCfg("capslock_plus.buildin", {})
				register_hotkey(key, value, "")
			For key, value in NoxCore.GetFeatureCfg("capslock_plus.custom", {})
				register_hotkey(key, value, "")
		}
		else {
			SetCapsLockState,  ; 如果省略SetCapsLockState后面的参数, 则清除按键的 AlwaysOn/Off 状态(如果存在). 
		}

		if(NoxCore.GetFeatureCfg("hot-corner.enable", 0))
		{
			For border_key, border_action in NoxCore.GetFeatureCfg("hot-corner.action", {})
				for key, value in border_action
					register_hotkey(key, value, border_key)
			SetTimer, tick_hot_corners, %hot_corners_detect_interval%
		}

		if(NoxCore.GetFeatureCfg("hot-edge.enable", 0))
		{
			For border_key, border_action in NoxCore.GetFeatureCfg("hot-edge.action", {})
				for key, value in border_action
					register_hotkey(key, value, border_key)
		}

		comma_delimiters_arr := ["','", "', '", "'，'", "'， '"]
		if(NoxCore.GetFeatureCfg("command.enable", 0))
		{
			For key, value in NoxCore.GetFeatureCfg("command.buildin", {})
				register_command(key, StrSplit(value, comma_delimiters_arr))
			For key, value in NoxCore.GetFeatureCfg("command.custom", {})
				register_command(key, StrSplit(value, comma_delimiters_arr))
		}

		if(NoxCore.GetFeatureCfg("web-search.enable", 0))
		{
			For key, value in NoxCore.GetFeatureCfg("web-search.buildin", {})
				register_web_search(key, StrSplit(value, comma_delimiters_arr))
			For key, value in NoxCore.GetFeatureCfg("web-search.custom", {})
				register_web_search(key, StrSplit(value, comma_delimiters_arr))
		}

		For key, value in NoxCore.GetFeatureCfg("additional-features", {}) {
			register_additional_features(key, value)
			if (ADDITIONAL_FEATURES_REGISTER_MAP["disable_win10_auto_update"])
				SetTimer, DisableWin10AutoUpdate, 66666
		}

		For key, value in NoxCore.GetFeatureCfg("theme", {})
			register_theme_conf(key, value)


		if(NoxCore.GetFeatureCfg("clipboard-plus.enable", 0))
		{
			For key, value in NoxCore.GetFeatureCfg("clipboard-plus.hotkey", {})
				register_hotkey(key, value, "")
		}
	}
}


tick_hot_corners() {
	global HOTKEY_REGISTER_MAP
	; ToolTipWithTimer("ggsmd")
	border_code := get_border_code()
	if (InStr(border_code, "Corner")) {
		action := HOTKEY_REGISTER_MAP[border_code "|" "hover"]
		; ToolTipWithTimer(border_code "|" "hover")
		; ToolTipWithTimer(action)

		run(action)
		Loop 
		{
			if (get_border_code() == "")
				break ; exits loop when mouse is no longer in the corner
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


register_additional_features(key_name, val)
{
	global ADDITIONAL_FEATURES_REGISTER_MAP
	ADDITIONAL_FEATURES_REGISTER_MAP[key_name] := val
}


register_theme_conf(key_name, val)
{
	global THEME_CONF_REGISTER_MAP
	THEME_CONF_REGISTER_MAP[key_name] := val
}


register_hotkey(key_name, action, prefix="")
{

	global HOTKEY_REGISTER_MAP
	trans_key := []
	
	StringLower, key_name, key_name
	map1 := {win: "#", ctrl: "^", shift: "+", alt: "!"
			,hover: "hover", capslock: "CapsLock"
			,lwin: "<#", rwin: ">#"
			,lctrl: "<^", rctrl: ">^"
			,lshift: "<+", rshift: ">+"
			,lalt: "<!", ralt: ">!"
			,lbutton:  "LButton", rbutton:  "RButton", mbutton: "MButton"}
	key_split_arr := StrSplit(key_name, "_")

	Loop, % key_split_arr.MaxIndex()
	{
		cur_symbol := key_split_arr[A_Index]
		maped_symbol := (key_split_arr.Length() == 1) ? key_name : map1[cur_symbol] 
		; maped_symbol := map1[cur_symbol] 
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

		HOTKEY_REGISTER_MAP[original_key] := action
		; DebugPrintVal(HOTKEY_REGISTER_MAP[key])
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
; m(arr[2])

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
SUB_NOX_CORE_FILE_END_LABEL:
	temp_nc := "blabla"


