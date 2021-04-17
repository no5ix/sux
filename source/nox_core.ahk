

; 记录快捷键与对应操作
HOTKEY_REGISTER_LIST := {}

; 记录command与对应操作
CMD_REGISTER_LIST := {}

; 记录web-search与对应操作
WEB_SEARCH_REGISTER_LIST := {}

; 记录additional-features与对应操作
ADDITIONAL_FEATURES_REGISTER_LIST := {}

; 记录theme与对应操作
THEME_CONF_REGISTER_LIST := {}



class NoxCore
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
	static Launcher_Name := A_WorkingDir "\NoxCore Launcher.exe"
	static Ext_ahk_file := "NoxCore.Ext.ahk"
	static version_yaml_file := NoxCore._CONF_DIR "version.yaml"
	static feature_yaml_file := "conf.user.yaml"
	static feature_yaml_default_file := NoxCore._CONF_DIR "conf.default.yaml"
	static config_file := "config.ini"
	static user_data_file := NoxCore._JSON_DIR "NoxCore.Data." A_ComputerName ".json"
	static icon_default := NoxCore._ICON_DIR "1.ico"
	static icon_suspend := NoxCore._ICON_DIR "2.ico"
	static icon_pause := NoxCore._ICON_DIR "4.ico"
	static icon_suspend_pause := NoxCore._ICON_DIR "3.ico"
	; remote file path
	static remote_branch := "master"
	static remote_raw := "http://raw.githubusercontent.com/XUJINKAI/NoxCore/" NoxCore.remote_branch "/"
	static remote_releases_dir := "https://github.com/XUJINKAI/NoxCore/releases/download/"
	static remote_update_dl_dir := NoxCore.remote_releases_dir "beta0/"
	; github api has limit
	; static remote_contents := "https://api.github.com/repos/XUJINKAI/NoxCore/contents/"
	; update
	static check_update_first_after := 1
	static check_update_period := 1000*3600*24
	static Bkp_limit := 5
	static update_list_path := NoxCore._CONF_DIR "update_list.json"
	; online
	static Project_Home_Page := "https://github.com/XUJINKAI/NoxCore"
	static Project_Issue_page := "https://github.com/XUJINKAI/NoxCore/issues"
	static remote_download_html := "https://github.com/XUJINKAI/NoxCore/releases"
	static remote_help := "https://github.com/XUJINKAI/NoxCore/wiki"
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
	static ProgramName := "NoxCore"
	static Default_lang := "cn"
	static Editor = notepad
	static Browser := "default"

	Ini(asLib=false)
	{
		CoordMode, Mouse, Screen
		; setting
		this.LoadFeatureYaml()

		; initialize module
		ClipboardPlus.Ini()
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

	LoadFeatureYaml()
	{
		if(NoxCore._DEBUG_ && this.debugConfig("load_default_feature_yaml", 0)) {
			NoxCore.FeatureObj := Yaml(NoxCore.feature_yaml_default_file)
		}
		else {
			if(!FileExist(this.feature_yaml_file)) {
				FileCopy, % this.feature_yaml_default_file, % this.feature_yaml_file, 0
			}
			NoxCore.FeatureObj := Yaml(NoxCore.feature_yaml_file)
		}
	}

	OnClipboardChange(func)
	{
		this.OnClipboardChangeCmd.Insert(func)
	}
}






