
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
	ret := key
	if (lang == NoxCore.Default_lang)
		ret := LANGUAGE_CONF_MAP[key]
	return ret
}


class NoxCore
{
	; dir
	static _MAIN_WORKDIR := ""
	static _JSON_DIR := "data/"
	static _ICON_DIR := "icon/"
	; static _LANG_DIR := "lang/"
	static _CONF_DIR := "conf/"
	static _APP_DATA_DIR := "app_data/"
	static _Update_bkp_DIR := "_bkp/"
	static _Update_dl_DIR := "_bkp/dl/"
	static _Update_bkp_folder_prefix := "_auto_"
	; file
	static Launcher_Name := A_WorkingDir "\nox.exe"
	static Ext_ahk_file := "NoxCore.Ext.ahk"
	static version_yaml_file := NoxCore._CONF_DIR "version.yaml"
	static conf_user_yaml_file := "conf.user.yaml"
	static conf_default_yaml_file := "conf.default.yaml"
	static app_data_ini_file := NoxCore._APP_DATA_DIR "app_data_auto_gen.ini"
	static user_data_file := NoxCore._JSON_DIR "NoxCore.Data." A_ComputerName ".json"
	static icon_default := NoxCore._ICON_DIR "1.ico"
	static icon_suspend := NoxCore._ICON_DIR "2.ico"
	static icon_pause := NoxCore._ICON_DIR "4.ico"
	static icon_suspend_pause := NoxCore._ICON_DIR "3.ico"
	; remote file path
	static remote_branch := "master"
	static remote_update_dl_dir := NoxCore.remote_releases_dir "beta0/"
	; update
	static check_update_first_after := 1
	static check_update_period := 1000*3600*24
	static Bkp_limit := 5
	static update_list_path := NoxCore._CONF_DIR "update_list.json"
	; online
	static Project_Home_Page := "https://github.com/no5ix/nox"
	static Project_Issue_page := "https://github.com/no5ix/nox/issues"
	static donate_page := "https://github.com/no5ix/nox"
	static remote_download_html := "https://github.com/no5ix/nox/releases"
	static help_addr := "https://github.com/no5ix/nox"
	;
	; setting object (read only, for feature configuration)
	static FeatureObj =
	; version object (read only, for check update)
	static versionObj =
	; running user data (e.g. clipboard history), read after run & write before exit
	static UserData := {}
	; callback
	static OnExitCmd := []
	static OnClipboardChangeCmd := []
	static OnPauseCmd := []
	static OnSuspendCmd := []
	; static var
	static ProgramName := "nox"
	static Default_lang := "cn"
	static Editor = notepad
	static Browser := "default"

	init()
	{
		if !FileExist(NoxCore._APP_DATA_DIR)  
        	FileCreateDir, % NoxCore._APP_DATA_DIR

		CoordMode, Mouse, Screen

		this.HandleConfYaml()
		ClipboardPlus.init()
		WinMenu.init()
		TrayMenu.init()
	}


	GetConfig(key, default="", section="nox", autoWrite=true)
	{
		IniRead, output, % NoxCore.app_data_ini_file, % section, % key
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
		IniWrite, % value, % NoxCore.app_data_ini_file, % section, % key
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
		NoxCore.Update_Tray_Menu()
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
			SetTimer, HotCorners, %hot_corners_detect_interval%
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

		For key, value in NoxCore.GetFeatureCfg("additional-features", {})
			register_additional_features(key, value)

		For key, value in NoxCore.GetFeatureCfg("theme", {})
			register_theme_conf(key, value)


		if(NoxCore.GetFeatureCfg("clipboard-plus.enable", 0))
		{
			For key, value in NoxCore.GetFeatureCfg("clipboard-plus.hotkey", {})
				register_hotkey(key, value, "")
		}
	}
}


HotCorners() {
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


