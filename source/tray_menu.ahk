
if(A_ScriptName=="tray_menu.ahk") {
	ExitApp
}

; with this label, you can include this file on top of the file
Goto, SUB_TRAY_MENU_FILE_END_LABEL


#Include %A_ScriptDir%\source\sux_core.ahk
#Include %A_ScriptDir%\source\action.ahk



class TrayMenu
{
	static ASSET_DIR := "app_data\img\"
	static icon_default := TrayMenu.ASSET_DIR "sux_default.ico"
	static icon_disable := TrayMenu.ASSET_DIR "sux_disable.ico"
	static donate_img_alipay := TrayMenu.ASSET_DIR "donate_alipay.png"
	static donate_img_wechat := TrayMenu.ASSET_DIR "donate_wechat.png"
	static last_tray_icon_x := 0
	static last_tray_icon_y := 0

	init()
	{
		this.SetLang("config")
		this.update_tray_menu()
		; this.SetAutorun("config")
		this.SetTheme("config")
		this.SetHotCorner("config")
		this.SetLimitModeInFullScreen("config")
		this.SetDisableWin10AutoUpdate("config")
		this.SetSwapWinCtrlShiftAlt("config")
		this.SetWindowMover("config", 1)
		; this.SetCheckUpdatesOnStartup("config", 1)
	}

	SetCheckUpdatesOnStartup(act="toggle", from_launch=0)
	{
		global INI_SET_CHECK_UPDATES_ON_STARTUP_SWITCH
		cfg := SuxCore.GetIniConfig(INI_SET_CHECK_UPDATES_ON_STARTUP_SWITCH, SuxCore.Default_check_updates_on_startup_switch)
		switch := (act="config")? cfg : act
		switch := (act="toggle")? !cfg : switch
		SuxCore.SetIniConfig(INI_SET_CHECK_UPDATES_ON_STARTUP_SWITCH, switch)
		if (switch && from_launch) {
			check_update_from_launch()
		}
	}

	SetSwapWinCtrlShiftAlt(act="toggle")
	{
		global INI_SWAP_WIN_CTRL_SHIFT_ALT
		cfg := SuxCore.GetIniConfig(INI_SWAP_WIN_CTRL_SHIFT_ALT, SuxCore.Default_swap_win_ctrl_shift_alt_switch)
		switch := (act="config")? cfg : act
		switch := (act="toggle")? !cfg : switch
		SuxCore.SetIniConfig(INI_SWAP_WIN_CTRL_SHIFT_ALT, switch)
		SuxCore.SetCurrentSwapWinCtrlShiftAltSwitch(switch)
	}

	SetDisableWin10AutoUpdate(act="toggle")
	{
		global INI_DISABLE_WIN10_AUTO_UPDATE_SWITCH
		cfg := SuxCore.GetIniConfig(INI_DISABLE_WIN10_AUTO_UPDATE_SWITCH, SuxCore.Default_disable_win10_auto_update_switch)
		switch := (act="config")? cfg : act
		switch := (act="toggle")? !cfg : switch
		SuxCore.SetIniConfig(INI_DISABLE_WIN10_AUTO_UPDATE_SWITCH, switch)
		if (switch) {
			DisableWin10AutoUpdate()
			SetTimer, DisableWin10AutoUpdate, %tick_disable_win10_auto_interval%
		}
		else {
			SetTimer, DisableWin10AutoUpdate, Delete
			EnableWin10AutoUpdate()
		}
	}

	SetWindowMover(act="toggle", from_launch=0)
	{
	    SysGet, mon_cnt, MonitorCount
		if (mon_cnt <a 2)
			Return
		global INI_WINDOW_MOVER_SWITCH
		cfg := SuxCore.GetIniConfig(INI_WINDOW_MOVER_SWITCH, SuxCore.Default_window_mover_switch)
		switch := (act="config")? cfg : act
		switch := (act="toggle")? !cfg : switch
		SuxCore.SetIniConfig(INI_WINDOW_MOVER_SWITCH, switch)
		Process, Priority,, High
		Gui +LastFound	
		hWnd := WinExist()
		DllCall( "RegisterShellHookWindow", UInt,hWnd )
		MsgNum := DllCall( "RegisterWindowMessage", Str,"SHELLHOOK" )
		if (switch) {
			OnMessage( MsgNum, "ShellMessage" )
			if (from_launch == 0)
				SuxCore.SuxMsgBox(lang("Window Mover is useful for multi monitor users, `nit will automatically move the new window to the monitor where the mouse is") . ".", "info", 8)
		}
		else {
			OnMessage( MsgNum, "" )
		}
	}

	SetLimitModeInFullScreen(act="toggle")
	{
		global INI_LIMIT_MODE_IN_FULL_SCREEN
		cfg := SuxCore.GetIniConfig(INI_LIMIT_MODE_IN_FULL_SCREEN, SuxCore.Default_limit_mode_in_full_screen_switch)
		switch := (act="config")? cfg : act
		switch := (act="toggle")? !cfg : switch
		SuxCore.SetIniConfig(INI_LIMIT_MODE_IN_FULL_SCREEN, switch)
		if (switch) {
			global tick_detect_interval
			SetTimer, HANDLE_LIMIT_MODE_IN_FULL_SCREEN, %tick_detect_interval%
		}
		else {
			SetTimer, HANDLE_LIMIT_MODE_IN_FULL_SCREEN, Off
		}
	}
	
	SetAutorun(act="toggle")
	{
		global INI_AUTORUN
		cfg := SuxCore.GetIniConfig(INI_AUTORUN, SuxCore.Default_autorun_switch)
		autorun := (act="config")? cfg : act
		autorun := (act="toggle")? !cfg : autorun
		SuxCore.SetIniConfig(INI_AUTORUN, autorun)
		Regedit.Autorun(autorun, SuxCore.ProgramName, SuxCore.Launcher_Name)
	}

	SetHotCorner(act="toggle")
	{
		
		global INI_HOT_CORNER
		cfg := SuxCore.GetIniConfig(INI_HOT_CORNER, SuxCore.Default_hot_corner_switch)
		hot_corner_switch := (act="config")? cfg : act
		hot_corner_switch := (act="toggle")? !cfg : hot_corner_switch
		SuxCore.SetIniConfig(INI_HOT_CORNER, hot_corner_switch)
		if (hot_corner_switch) {
			global tick_detect_interval
			SetTimer, TICK_HOT_CORNERS, %tick_detect_interval%
		}
		else {
			SetTimer, TICK_HOT_CORNERS, Off
		}
	}

	SetTheme(act="itemname")
	{
		global INI_THEME
		if(act="itemname")
		{
			; m(A_ThisMenuItem)
			; m(A_ThisMenu)
			; m(A_ThisMenuItemPos)
			cur_theme_list := ["auto", "light", "dark"]
			cur_theme := cur_theme_list[A_ThisMenuItemPos]
		}
		else if (act == "config"){
			cur_theme := SuxCore.GetIniConfig(INI_THEME, SuxCore.Default_theme)
		}
		else {
			cur_theme := act
		}
		SuxCore.SetIniConfig(INI_THEME, cur_theme)
		SuxCore.SetCurrentRealTheme(cur_theme)
	}

	SetLang(act="itemname")
	{
		global INI_LANG
		if(act="itemname")
		{
			lang_map := {"English": "en", "中文": "cn"}
			lang := lang_map[A_ThisMenuItem]
		}
		else if (act="config") {
			lang := SuxCore.GetIniConfig(INI_LANG, SuxCore.Default_lang)
		}
		else {
			lang := act
		}
		SuxCore.SetIniConfig(INI_LANG, lang)
		SuxCore.SetCurrentLang(lang)
	}

	; Tray Menu
	update_tray_menu()
	{
		; global INI_SET_CHECK_UPDATES_ON_STARTUP_SWITCH
		global INI_WINDOW_MOVER_SWITCH
		global INI_DISABLE_WIN10_AUTO_UPDATE_SWITCH
		global INI_LIMIT_MODE_IN_FULL_SCREEN
		global INI_HOT_CORNER
		global INI_AUTORUN
		global INI_THEME
		global INI_LANG
		version_str := lang("About") " sux v" SuxCore.version
		autorun := SuxCore.GetIniConfig(INI_AUTORUN, 0)
		; check_updates_on_startup_switch := SuxCore.GetIniConfig(INI_SET_CHECK_UPDATES_ON_STARTUP_SWITCH, 0)
		remote_ver_str := SuxCore.get_remote_ini_config("ver")
		if (remote_ver_str != "ERROR" && get_version_sum(remote_ver_str) > get_version_sum(SuxCore.version)) {
			check_update_menu_name := lang("A New Version v") remote_ver_str . " !" lang(" Click me to chekc it out!")
			; check_update_menu_func := SuxCore.remote_download_html
			check_update_menu_func := "TrayMenu.ShowNewVerReleaseNote"
		}
		else {
			check_update_menu_name := lang("Check Update")
			check_update_menu_func := "check_update_from_tray"
		}
		lang := SuxCore.CurrentLang
		cur_theme := SuxCore.GetIniConfig(INI_THEME, SuxCore.Default_theme)
		hot_corner_switch := SuxCore.GetIniConfig(INI_HOT_CORNER, SuxCore.Default_hot_corner_switch)
		limit_mode_in_full_screen_switch := SuxCore.GetIniConfig(INI_LIMIT_MODE_IN_FULL_SCREEN, SuxCore.Default_limit_mode_in_full_screen_switch)
		disable_win10_auto_update_switch := SuxCore.GetIniConfig(INI_DISABLE_WIN10_AUTO_UPDATE_SWITCH, SuxCore.Default_disable_win10_auto_update_switch)
		swap_win_ctrl_shift_alt_switch := SuxCore.GetIniConfig(INI_SWAP_WIN_CTRL_SHIFT_ALT, SuxCore.Default_swap_win_ctrl_shift_alt_switch)
		window_mover_switch := SuxCore.GetIniConfig(INI_WINDOW_MOVER_SWITCH, SuxCore.Default_window_mover_switch)

		Menu, Tray, Tip, % SuxCore.ProgramName
		xMenu.New("TrayLanguage"
			,[["中文", "TrayMenu.SetLang", {"check": lang=="cn"}]
			, ["English", "TrayMenu.SetLang", {"check": lang=="en"}]])
		xMenu.New("SearchGuiTheme"
			,[[lang("Auto"), "TrayMenu.SetTheme", {"check": cur_theme=="auto"}]
			, [lang("Light"), "TrayMenu.SetTheme", {"check": cur_theme=="light"}]
			, [lang("Dark"), "TrayMenu.SetTheme", {"check": cur_theme=="dark"}]])

	    SysGet, mon_cnt, MonitorCount
		xMenu.New("SensitiveFeatureSwitch", [[lang("Auto Disable sux In Full Screen"), "TrayMenu.SetLimitModeInFullScreen", {"check": limit_mode_in_full_screen_switch==1}]
			, [lang("Hot Corner"), "TrayMenu.SetHotCorner", {"check": hot_corner_switch==1}]
			, [lang("Disable Win10 Auto Update"), "TrayMenu.SetDisableWin10AutoUpdate", {"check": disable_win10_auto_update_switch==1}]
			, [lang("Swap Win/Ctrl Shift/Alt"), "TrayMenu.SetSwapWinCtrlShiftAlt", {"check": swap_win_ctrl_shift_alt_switch==1}]
			, [lang("Window Mover"), "TrayMenu.SetWindowMover", mon_cnt==1 ? {"disable": 1}: {"check": window_mover_switch==1}]])

		TrayMenuList := []
		TrayMenuList := EnhancedArray.merge(TrayMenuList
			,[[version_str, "TrayMenu.AboutSux"]
			,[lang("Help"), SuxCore.help_addr]
			,[lang("Donate"), "TrayMenu.ShowDonatePic"]
			,[check_update_menu_name, check_update_menu_func]
			,[]
			,[lang("Start With Windows"), "TrayMenu.SetAutorun", {"check": autorun}]
			; ,[lang("Check Updates On Startup"), "TrayMenu.SetCheckUpdatesOnStartup", {"check": check_updates_on_startup_switch}]
			,["Language",, {"sub": "TrayLanguage"}]
			,[lang("Theme"),, {"sub": "SearchGuiTheme"}]
			,[lang("Feature Switch"),, {"sub": "SensitiveFeatureSwitch"}]
			,[]
			,[lang("Open sux Folder"), "TrayMenu.OpenSuxFolder"]
			,[lang("Edit Config File"), "TrayMenu.Edit_conf"]
			,[]
			,[lang("Disable"), "TrayMenu.SetDisable", {"check": A_IsPaused&&A_IsSuspended}]
			,[lang("Restart sux"), "ReloadSux"]
			,[lang("Exit"), "TrayMenu.ExitSux"] ])
		this.SetMenu(TrayMenuList)
		Menu, Tray, Default, % lang("Disable")
		Menu, Tray, Click, 1
		; OnMessage(0x404, "AHK_NOTIFYICON")		
		this.Update_Icon()
	}

	static _switch_tray_standard_menu := 0
	Standard_Tray_Menu(act="toggle")
	{
		SuxCore._switch_tray_standard_menu := (act="toggle")? !SuxCore._switch_tray_standard_menu :act
		this.update_tray_menu()
	}

	ShowNewVerReleaseNote() {
		Gui, new_ver_release_note: New
		Gui new_ver_release_note:+Resize +AlwaysOnTop +MinSize400 -MaximizeBox -MinimizeBox
		Gui, new_ver_release_note:Font, s16

		s := lang("New Release") . "! sux v" . SuxCore.get_remote_ini_config("ver")
		Gui, new_ver_release_note:Add, Text,, % s
		s := lang("What's new?")
		Gui, new_ver_release_note:Add, Text,, % s

		Gui, new_ver_release_note:Font, s11
		remote_ver_release_note_str := lang(SuxCore.get_remote_ini_config("release_note_" . SuxCore.CurrentLang))
		_arr := StrSplit(remote_ver_release_note_str, "-")
		for _i, _s in _arr {
			if (!_s)
				Continue
			Gui, new_ver_release_note:Add, Text,, % "- " . lang(_s)
		}

		s := "<a href=""" SuxCore.remote_download_html """>" lang("Download Page") "</a>"
		Gui, new_ver_release_note:Add, Link,, % s
		Gui, new_ver_release_note:Add, Text
		GuiControl, Focus, Close
		s := lang("New Release")
		Gui, new_ver_release_note:Show,, % s
	}

	ShowDonatePic() {
		Gui, sux_donate: New
		Gui sux_donate: +AlwaysOnTop
		Gui, sux_donate:Font, s11 wbold
		Gui, sux_donate:Add, Text
		s := lang("Donate")
		Gui, sux_donate:Add, Text,, % s
		Gui, sux_donate:Add, Text

		Gui, sux_donate:Font, s10 wnorm
		s := lang("Alipay")
		Gui, sux_donate:Add, Text,, % s
		Gui, sux_donate:Add, Picture, w300 h-1, % TrayMenu.donate_img_alipay
		; Gui, sux_donate:Add, Picture, w300 h-1, C:\Users\b\Documents\github\sux\app_data\donate_alipay.png
		Gui, sux_donate:Add, Text
		s := lang("Wechat")
		Gui, sux_donate:Add, Text,, % s
		Gui, sux_donate:Add, Picture, w300 h-1, % TrayMenu.donate_img_wechat
		Gui, sux_donate:Add, Text
		GuiControl, Focus, Close
		s := "sux"
		Gui, sux_donate:Show, w330, % s
	}

	AboutSux() {
		Gui, sux_About: New
		Gui sux_About:+Resize +AlwaysOnTop +MinSize400 -MaximizeBox -MinimizeBox
		Gui, sux_About:Font, s12
		sux_ver := "sux v" SuxCore.version
		; Gui, sux_About:Add, Text,, % sux_ver
		Gui, sux_About:Add, Text
		
		s := "<a href=""" SuxCore.Project_Home_Page """>" lang("Home Page") "</a>"
		Gui, sux_About:Add, Link,, % s
		s := "<a href=""" SuxCore.Project_Issue_page """>" lang("Feedback") "</a>"
		Gui, sux_About:Add, Link,, % s
		s := "<a href=""" SuxCore.Project_GitHub_Page """>" lang("Open GitHub to light up the little star!") "</a>"
		Gui, sux_About:Add, Link,, % s
		s := "<a href=""" SuxCore.Project_Zhihu_Page """>" lang("Open Zhihu to like sux!") "</a>"
		Gui, sux_About:Add, Link,, % s
		Gui, sux_About:Add, Text
		GuiControl, Focus, Close
		s := lang("About") . " " . sux_ver
		Gui, sux_About:Show,, % s
	}

	Update_Icon()
	{
		setsuspend := A_IsSuspended
		setpause := A_IsPaused
		if !setpause && !setsuspend {
			this.SetIcon(this.icon_default)
		}
		Else if !setpause && setsuspend {
			this.SetIcon(this.icon_disable)
		}
		Else if setpause && !setsuspend {
			this.SetIcon(this.icon_disable)
		}
		Else if setpause && setsuspend {
			this.SetIcon(this.icon_disable)
		}
	}

	; Tray.SetIcon
	SetIcon(path)
	{
		if(FileExist(path)) {
			Menu, Tray, Icon, %path%,,1
		}
	}

	; Tray.SetMenu
	SetMenu(menuList)
	{
		Menu, Tray, DeleteAll
		Menu, Tray, NoStandard
		xMenu.add("Tray", menuList)
	}

	ExitSux(show_msg=true)
	{
		ExitApp
	}

	Edit_conf()
	{
		OpenFolderAndSelectFile(SuxCore.conf_user_json_file)
	}

	OpenSuxFolder()
	{
		; OpenFolderAndSelectFile(SuxCore.conf_user_json_file)
		OpenFolder(A_WorkingDir)
	}

	SetDisable(act="toggle")
	{
		setdisable := (act="toggle")? !(A_IsPaused&&A_IsSuspended): act
		TrayMenu.SetState(setdisable, setdisable)
	}

	SetState(setsuspend="", setpause="")
	{
		setsuspend := (setsuspend="")? A_IsSuspended: setsuspend
		setpause := (setpause="")? A_IsPaused: setpause
		if(!A_IsSuspended && setsuspend) {
			RunArr(SuxCore.OnSuspendCmd)
		}
		if(!A_IsPaused && setpause) {
			RunArr(SuxCore.OnPauseCmd)
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
		TrayMenu.update_tray_menu()
	}
}



; //////////////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////////////
/*
e.g.
xMenu.Add("Menu1", [["item1","func1"],["item2","func2"],[]
				,["submenu",["subitem_1","func3"]
				,["subitem_2",, {sub: "SubMenu", "disable"}]]])
xMenu.Show("Menu1")
*/
class xMenu
{
	static MenuList := {}

	Show(Menu_Name, X := "", Y := "")
	{
		if (X == "" || Y == "")
			Menu, %Menu_Name%, Show
		Else
			Menu, %Menu_Name%, Show, % X, % Y
	}

	New(Menu_Name, Menu_Config)
	{
		this.Clear(Menu_Name)
		this.Add(Menu_Name, Menu_Config)
	}

	Clear(Menu_Name)
	{
		Try
		{
			Menu, %Menu_Name%, DeleteAll
		}
	}

	Add(Menu_Name, Menu_Config)
	{
		ParsedCfg := this._Config_Parse(Menu_Name, Menu_Config)
		Loop, % ParsedCfg.MaxIndex()
		{
			cfg_entry := ParsedCfg[A_Index]
			if (cfg_entry[4].HasKey("sub"))
			{
				sub_name := cfg_entry[4]["sub"]
				Menu, % cfg_entry[1], Add, % cfg_entry[2], :%sub_name%
			}
			Else
			{
				Menu, % cfg_entry[1], Add, % cfg_entry[2], Sub_xMenu_Open
				this.MenuList[cfg_entry[1] "_" cfg_entry[2]] := cfg_entry[3]
			}
			For Key, Value in cfg_entry[4]
			{
				if Value = 0
					Continue
				StringLower, Key, Key
				if(Key == "check") {
					Menu, % cfg_entry[1], Check, % cfg_entry[2]
				}
				if(Key == "uncheck")
					Menu, % cfg_entry[1], UnCheck, % cfg_entry[2]
				if(Key == "togglecheck")
					Menu, % cfg_entry[1], ToggleCheck, % cfg_entry[2]
				if(Key == "enable")
					Menu, % cfg_entry[1], Enable, % cfg_entry[2]
				if(Key == "disable") {
					Menu, % cfg_entry[1], Disable, % cfg_entry[2]
				}
				if(Key == "toggleenable")
					Menu, % cfg_entry[1], ToggleEnable, % cfg_entry[2]
			}
		}
	}

	_Config_Parse(PName, Config)
	{
		ParsedCfg := {}
		Loop, % Config.MaxIndex()
		{
			cfg_entry := Config[A_Index]
			If IsObject(cfg_entry[2])
			{
				ParsedCfg_Sub := this._Config_Parse(cfg_entry[1], cfg_entry[2])
				Loop, % ParsedCfg_Sub.MaxIndex()
				{
					sub_entry := ParsedCfg_Sub[A_Index]
					ParsedCfg.Insert([sub_entry[1],sub_entry[2],sub_entry[3],sub_entry[4]])
				}
				ParsedCfg.Insert([PName,cfg_entry[1],,{"sub":cfg_entry[1]}])
			}
			Else
			{
				if cfg_entry.MaxIndex() == 3
					cfg_ctrl := cfg_entry[3]
				Else
					cfg_ctrl := {}
				ParsedCfg.Insert([PName,cfg_entry[1],cfg_entry[2],cfg_ctrl])
			}
		}
		Return % ParsedCfg
	}
}


; AHK_NOTIFYICON(wParam, lParam)
; {
;     if (lParam = 0x205) ; WM_RBUTTONUP
;     {
;         ; SetTimer, ShowRbuttonMenu, -1
; 		MouseGetPos, mouse_x, mouse_y
; 		TrayMenu.last_tray_icon_x := mouse_x
; 		TrayMenu.last_tray_icon_y := mouse_y
; 		ToolTipWithTimer(TrayMenu.last_tray_icon_x "  \\ " TrayMenu.last_tray_icon_y)
; 		Menu, Tray, Show
; 		; Menu, Tray, Show, % TrayMenu.last_tray_icon_x, % TrayMenu.last_tray_icon_y
;         return 0
;     }
;     else if (lParam = 0x202) ; WM_LBUTTONUP
;     {
; 		; ToolTipWithTimer(111)
; 		TrayMenu.SetDisable()
; 		; TrayMenu.update_tray_menu()
; 		return 0
; 	}
; }


ShellMessage( wParam,lParam ) {
  	If ( wParam = 1 ) ;  HSHELL_WINDOWCREATED := 1
	{
		MoveWindowToMouseMonitor(lParam)
	}
}


Sub_xMenu_Open:
	; ActiveHwnd := WinExist("A")
	Run(xMenu.MenuList[A_ThisMenu "_" A_ThisMenuItem])

	;; 下面这两行不能调换顺序, 否则会有乱切换软件的bug
	; Send, !{esc}  ; GotoNextApp,  没有这一行的话, 点击了菜单之后双击alt没反应, 还得点击一下其他地方才有反应
	TrayMenu.update_tray_menu()
	; 	ToolTipWithTimer(TrayMenu.last_tray_icon_x "  \\ " TrayMenu.last_tray_icon_y)
	; Menu, Tray, Show, % TrayMenu.last_tray_icon_x, % TrayMenu.last_tray_icon_y+2

	; WinActivate
	; WinActivate, ahk_id %ActiveHwnd%	
	Return



TICK_HOT_CORNERS:
	global LIMIT_MODE
	if (LIMIT_MODE) {
		return
	}
	global HOTKEY_REGISTER_MAP
	border_code := get_border_code()
	; ToolTipWithTimer(border_code)
	if (InStr(border_code, "Corner")) {
		action := HOTKEY_REGISTER_MAP[border_code "|" "hover"]
		; ToolTipWithTimer(border_code "|" "hover")
		; ToolTipWithTimer(action, 1111)
		run(action)
		Loop 
		{
			if (get_border_code() == "")
				break ; exits loop when mouse is no longer in the corner
		}
	}
	Return


HANDLE_LIMIT_MODE_IN_FULL_SCREEN:
	global LIMIT_MODE
	if (IsFullscreen()) {
		; WinGetClass, class, A
		; ToolTipWithTimer(class)
		if (WinActive("ahk_class #32770")) {  ;; #32770是截图的ahk_class, 因为截图也是全屏模式, 所以要避免截图的时候进入limit_mode
			Return
		}
		if (LIMIT_MODE == 0) {
			; ToolTipWithTimer(lang("sux limit mode auto enable in full screen mode") . ".", 1111)
			LIMIT_MODE := 1
		}
	}
	else {
		if (LIMIT_MODE == 1) {
			; ToolTipWithTimer(lang("sux limit mode auto disable not in full screen mode") . ".", 1111)
			LIMIT_MODE := 0
		}
	}
	Return



; //////////////////////////////////////////////////////////////////////////
SUB_TRAY_MENU_FILE_END_LABEL:
	temp_tm := "blabla"