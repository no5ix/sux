; ; Note: Save with encoding UTF-8 with BOM if possible.
; ; Notepad will save UTF-8 files with BOM automatically (even though it does not say so).
; ; Some editors however save without BOM, and then special characters look messed up in the AHK GUI.


#Include, %A_ScriptDir%\source
#Include, OneQuick.Core.ahk
#Include, Yaml.ahk


class OneQuick
{
	; dir
	static _MAIN_WORKDIR := ""
	static _JSON_DIR := "data/"
	static _ICON_DIR := "icon/"
	static _LANG_DIR := "lang/"
	static _CONF_DIR := "conf/"
	static _Update_bkp_DIR := "_bkp/"
	static _Update_dl_DIR := "_bkp/dl/"
	static _Update_bkp_folder_prefix := "_auto_"
	; file
	static Launcher_Name := A_WorkingDir "\OneQuick Launcher.exe"
	static Ext_ahk_file := "OneQuick.Ext.ahk"
	static version_yaml_file := OneQuick._CONF_DIR "version.yaml"
	static feature_yaml_file := "OneQuick.feature.yaml"
	static feature_yaml_default_file := OneQuick._CONF_DIR "OneQuick.feature.default.yaml"
	static config_file := "config.ini"
	static user_data_file := OneQuick._JSON_DIR "OneQuick.Data." A_ComputerName ".json"
	static icon_default := OneQuick._ICON_DIR "1.ico"
	static icon_suspend := OneQuick._ICON_DIR "2.ico"
	static icon_pause := OneQuick._ICON_DIR "4.ico"
	static icon_suspend_pause := OneQuick._ICON_DIR "3.ico"
	; remote file path
	static remote_branch := "master"
	static remote_raw := "http://raw.githubusercontent.com/XUJINKAI/OneQuick/" OneQuick.remote_branch "/"
	static remote_releases_dir := "https://github.com/XUJINKAI/OneQuick/releases/download/"
	static remote_update_dl_dir := OneQuick.remote_releases_dir "beta0/"
	; github api has limit
	; static remote_contents := "https://api.github.com/repos/XUJINKAI/OneQuick/contents/"
	; update
	static check_update_first_after := 1
	static check_update_period := 1000*3600*24
	static Bkp_limit := 5
	static update_list_path := OneQuick._CONF_DIR "update_list.json"
	; online
	static Project_Home_Page := "https://github.com/XUJINKAI/OneQuick"
	static Project_Issue_page := "https://github.com/XUJINKAI/OneQuick/issues"
	static remote_download_html := "https://github.com/XUJINKAI/OneQuick/releases"
	static remote_help := "https://github.com/XUJINKAI/OneQuick/wiki"
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
	static ProgramName := "OneQuick"
	static Default_lang := "cn"
	static Editor = notepad
	static Browser := "default"

	Ini(asLib=false)
	{
		CoordMode, Mouse, Screen
		; setting
		this.LoadFeatureYaml()

		; initialize module
		xClipboard.Ini()
	}

	; feature.yaml
	GetFeatureCfg(keyStr, default="")
	{
		keyArray := StrSplit(keyStr, ".")
		obj := OneQuick.FeatureObj
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

	LoadFeatureYaml()
	{
		if(OneQuick._DEBUG_ && this.debugConfig("load_default_feature_yaml", 0)) {
			OneQuick.FeatureObj := Yaml(OneQuick.feature_yaml_default_file)
		}
		else {
			if(!FileExist(this.feature_yaml_file)) {
				FileCopy, % this.feature_yaml_default_file, % this.feature_yaml_file, 0
			}
			OneQuick.FeatureObj := Yaml(OneQuick.feature_yaml_file)
		}
	}

	OnClipboardChange(func)
	{
		this.OnClipboardChangeCmd.Insert(func)
	}
}

; event callback
OnClipboardChange:
RunArr(OneQuick.OnClipboardChangeCmd)
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
border_code := Sys.Cursor.CornerPos()
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
	border_code := Sys.Cursor.CornerPos()
	; ToolTipWithTimer(border_code)

	key := border_code "|" A_ThisHotkey
	; ToolTipWithTimer(key)

	; StringUpper, key, key
	action := HOTKEY_REGISTER_LIST[key]
	if(action!="")
		return true
}