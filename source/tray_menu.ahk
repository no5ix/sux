
if(A_ScriptName=="tray_menu.ahk") {
	ExitApp
}

; with this label, you can include this file on top of the file
Goto, SUB_TRAY_MENU_FILE_END_LABEL


#Include %A_ScriptDir%\source\nox_core.ahk
; #Include %A_ScriptDir%\source\util.ahk

class TrayMenu
{
	init() {
		this.Update_Tray_Menu()
		this.SetAutorun("config")
	}

	SetAutorun(act="toggle")
	{
		cfg := NoxCore.GetConfig("autorun", 0)
		autorun := (act="config")? cfg :act
		autorun := (act="toggle")? !cfg :autorun
		Regedit.Autorun(autorun, NoxCore.ProgramName, NoxCore.Launcher_Name)
		NoxCore.SetConfig("autorun", autorun)
		if(autorun)
		{
			Menu, Tray, Check, % lang("Start With Windows")
		}
		Else
		{
			Menu, Tray, UnCheck, % lang("Start With Windows")
		}
	}

	; Tray Menu
	Update_Tray_Menu()
	{
		; version_str := lang("About") " v" this.versionObj["version"]
		autorun := NoxCore.GetConfig("autorun", 0)
		; autoupdate := NoxCore.GetConfig("auto_update", 0)
		; bigVer := NoxCore.GetBiggerRemVersion()
		; if(bigVer!="") {
		; 	check_update_name := lang("! New Version !") " v" bigVer
		; }
		; else {
		; 	check_update_name := lang("Check Update")
		; }
		m("ggs")
		lang := NoxCore.GetConfig("lang", NoxCore.Default_lang)
		m(lang)
		Menu, Tray, Tip, % this.ProgramName
		xMenu.New("TrayLanguage"
			,[["English", "NoxCore.SetLang", {check: lang=="en"}]
			, ["中文", "NoxCore.SetLang", {check: lang=="cn"}]])
		; xMenu.New("TrayAdvanced"
		; 	,[["Suspend Hotkey", "NoxCore.SetSuspend", {check: A_IsSuspended}]
		; 	,["Pause Thread", "NoxCore.SetPause", {check: A_IsPaused}]
		; 	,[]
		; 	,[lang("AHK Standard Menu"), "NoxCore.Standard_Tray_Menu", {check: NoxCore._switch_tray_standard_menu}]
		; 	,[]
		; 	,[lang("Reset Program"), "NoxCore.ResetProgram"]])
		TrayMenuList := []
		TrayMenuList := xArray.merge(TrayMenuList
			,[[lang("About"), "TrayMenu.AboutNox"]
			,[lang("Help"), NoxCore.help_addr]
			,[lang("Donate"), NoxCore.donate_page]
			; ,[check_update_name, "NoxCore.Check_update"]
			,[]
			,[lang("Start With Windows"), "TrayMenu.SetAutorun", {check: autorun}]
			; ,[lang("AutoUpdate"), "NoxCore.SetAutoUpdate", {check: autoupdate}]
			,["Language",, {"sub": "TrayLanguage"}]
			; ,[lang("Advanced"),, {"sub": "TrayAdvanced"}]
			,[]
			,[lang("Open nox Folder"), A_WorkingDir]
			; ,[lang("Edit Ext.ahk"), "edit:" NoxCore.Ext_ahk_file]
			,[lang("Edit Config File"), "NoxCore.Edit_conf_yaml"]
			; ,[]
			; ,[lang("Open AutoHotkey.exe Folder"), "Sub_nox_EXE_Loc"]
			; ,[lang("AutoHotKey Help"), "Sub_nox_AHKHelp"]
			,[]
			,[lang("Disable"), "NoxCore.SetDisable", {check: A_IsPaused&&A_IsSuspended}]
			,[lang("Restart nox"), "NoxCore.ReloadNox"]
			,[lang("Exit"), "NoxCore.ExitNox"] ])
		this.SetMenu(TrayMenuList, NoxCore._switch_tray_standard_menu)
		Menu, Tray, Default, % lang("Disable")
		Menu, Tray, Click, 1
		this.Update_Icon()
	}

	static _switch_tray_standard_menu := 0
	Standard_Tray_Menu(act="toggle")
	{
		NoxCore._switch_tray_standard_menu := (act="toggle")? !NoxCore._switch_tray_standard_menu :act
		this.Update_Tray_Menu()
	}

	AboutNox()
	{
		; lang := NoxCore.GetConfig("lang", NoxCore.Default_lang)
		Gui, nox_About: New
		Gui nox_About:+Resize +AlwaysOnTop +MinSize400 -MaximizeBox -MinimizeBox
		Gui, Font, s12
		; s := "NoxCore v" NoxCore.versionObj["version"]
		; Gui, Add, Text,, % s
		s := "<a href=""" NoxCore.Project_Home_Page """>" lang("Home Page") "</a>"
		Gui, Add, Link,, % s
		s := "<a href=""" NoxCore.Project_Issue_page """>" lang("Feedback") "</a>"
		Gui, Add, Link,, % s
		; s := "<a href=""" NoxCore.help_addr """>" lang("Help") "</a>"
		; Gui, Add, Link,, % s
		; s := "Author: XJK <a href=""mailto:jack8461@msn.cn"">jack8461@msn.cn</a>"
		; Gui, Add, Link,, % s
		; s := "<a href=""" NoxCore.donate_page """>" lang("Donate") "</a>"
		; ; s .= " <a href=""https://www.zhihu.com/question/36847530/answer/92868539"">去知乎点赞!</a>"
		; Gui, Add, Link,, % s
		Gui, Add, Text
		; Gui, Add, Button, Default gSub_Close_nox_About, Close
		GuiControl, Focus, Close
		Gui, Show,, About nox
	}

	Update_Icon()
	{
		setsuspend := A_IsSuspended
		setpause := A_IsPaused
		if !setpause && !setsuspend {
			this.SetIcon(this.icon_default)
		}
		Else if !setpause && setsuspend {
			this.SetIcon(this.icon_pause)
		}
		Else if setpause && !setsuspend {
			this.SetIcon(this.icon_suspend)
		}
		Else if setpause && setsuspend {
			this.SetIcon(this.icon_suspend_pause)
		}
	}

	; Tray.SetIcon
	SetIcon(path)
	{
		if(FileExist(path))
			Menu, Tray, Icon, %path%,,1
	}

	; Tray.SetMenu
	SetMenu(menuList, ahk_std_menu=0)
	{
		Menu, Tray, DeleteAll
		if(ahk_std_menu) {
			Menu, Tray, Standard
			Menu, Tray, Add
		}
		else {
			Menu, Tray, NoStandard
		}
		xMenu.add("Tray", menuList)
	}
}


; class Tray
; {
; 	; Tray.Tip
; 	Tip(msg, seconds=1, opt=0x1)
; 	{
; 		; //BUG traytip弹出后，第一次单击托盘图标的动作将失效，第二次单击或显示托盘菜单后正常
; 		TrayTip, % NoxCore.ProgramName, % msg, % seconds, % opt
; 		Return
; 		title := NoxCore.ProgramName
; 		cmd = "%A_AhkPath%" "%A_ScriptDir%\NoxCore.Core.ahk" -traytip "%title%" "%msg%" "%opt%"
; 		Run, %cmd%
; 		Return
; 	}

; 	; Tray.SetMenu
; 	SetMenu(menuList, ahk_std_menu=0)
; 	{
; 		Menu, Tray, DeleteAll
; 		if(ahk_std_menu) {
; 			Menu, Tray, Standard
; 			Menu, Tray, Add
; 		}
; 		else {
; 			Menu, Tray, NoStandard
; 		}
; 		xMenu.add("Tray", menuList)
; 	}

; 	; ; Tray.SetIcon
; 	; SetIcon(path)
; 	; {
; 	; 	if(FileExist(path))
; 	; 		Menu, Tray, Icon, %path%,,1
; 	; }
; }


; //////////////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////////////
/*

*/
class WinMenu
{
	static InfoObj := {}
	static HideIDs := {}
	static ini_registered := 0

	init()
	{
		if (this.ini_registered == 1)
			Return
		this.HideIDs := NoxCore.UserData["WinMenu_HideIDs"]
		if not IsObject(this.HideIDs)
			this.HideIDs := {}
		NoxCore.OnExit("Sub_WinMenu_OnExit")
		this.ini_registered := 1
	}

	Show(ID := "")
	{
		if (ID == "")
			ID := Sys.Win.ID()
		Title := Sys.Win.Title(ID)
		Path := Sys.Win.Path(ID)
		Cls := Sys.Win.Class(ID)
		this.InfoObj[1] := Title
		this.InfoObj[2] := Path
		this.InfoObj[3] := ID
		this.InfoObj[4] := Cls
		Title := SubStr(Title, 1, 150)
		Path := SubStr(Path, 1, 150)
		try
		{
			Menu, windowMenu, DeleteAll
		}
		Try
		{
			Menu, windowMenu_ShowWinMenu, DeleteAll
		}
		Try
		{
			Menu, WinMenu_Trans, DeleteAll
		}
		Menu, windowMenu, Add, % lang("Topmost"), Sub_WinMenu_TopMost
		if Sys.Win.IsTopmost(winID)
			Menu, windowMenu, Check, % lang("Topmost")
		Loop, 9
		{
			Menu, WinMenu_Trans, Add, % (110-A_Index*10)`%, Sub_WinMenu_Trans
		}
		Trans := Sys.Win.Transparent()
		Try
		{
			Menu, WinMenu_Trans, Check, %Trans%`%
		}
		Menu, windowMenu, Add, % lang("Transparent") ": " Trans "`%", :WinMenu_Trans
		Menu, windowMenu, Add, % lang("Open Location"), Sub_WinMenu_ExplorerSelect
		Menu, windowMenu, Add
		Menu, windowMenu, Add, Title:     %Title%, Sub_WinMenu_CopyToClipboard
		Menu, windowMenu, Add, Path:    %Path%, Sub_WinMenu_CopyToClipboard
		Menu, windowMenu, Add, ID:        %ID%, Sub_WinMenu_CopyToClipboard
		Menu, windowMenu, Add, Class:   %Cls%, Sub_WinMenu_CopyToClipboard
		Menu, windowMenu, Add
		Menu, windowMenu, Add, Hide Window, Sub_WinMenu_HideWindow
		HideIDs_IsVoid := 1
		For k, v in this.HideIDs
		{
			Menu, windowMenu_ShowWinMenu, Add, % k, Sub_WinMenu_ShowWindow
			HideIDs_IsVoid := 0
		}
		if (HideIDs_IsVoid)
		{
			Menu, windowMenu_ShowWinMenu, Add, <empty>, Sub_WinMenu_ShowWindow
			Menu, windowMenu_ShowWinMenu, Disable, <empty>
		}
		Menu, windowMenu, Add, Show Window, :windowMenu_ShowWinMenu
		Menu, windowMenu, Show
	}
}

Sub_WinMenu_TopMost:
Sys.Win.Topmost(WinMenu.InfoObj[3])
Return

Sub_WinMenu_Trans:
Sys.Win.Transparent(ceil(110-A_ThisMenuItemPos*10))
Return

Sub_WinMenu_ExplorerSelect:
Sys.Win.ExplorerSelect(WinMenu.InfoObj[2])
Return

Sub_WinMenu_CopyToClipboard:
xClipboard.ShowClipMenu(WinMenu.InfoObj[A_ThisMenuItemPos - 4])
Return

Sub_WinMenu_HideWindow:
id := WinMenu.InfoObj[3]
WinHide, ahk_id %id%
WinMenu.HideIDs[id "  " WinMenu.InfoObj[1]] := id
Return

Sub_WinMenu_ShowWindow:
id := WinMenu.HideIDs[A_ThisMenuItem]
Sys.Win.Show(id)
WinMenu.HideIDs.Remove(A_ThisMenuItem)
Return

Sub_WinMenu_OnExit:
NoxCore.UserData["WinMenu_HideIDs"] := WinMenu.HideIDs
Return


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
				if(Key == "check")
					Menu, % cfg_entry[1], Check, % cfg_entry[2]
				if(Key == "uncheck")
					Menu, % cfg_entry[1], UnCheck, % cfg_entry[2]
				if(Key == "togglecheck")
					Menu, % cfg_entry[1], ToggleCheck, % cfg_entry[2]
				if(Key == "enable")
					Menu, % cfg_entry[1], Enable, % cfg_entry[2]
				if(Key == "disable")
					Menu, % cfg_entry[1], Disable, % cfg_entry[2]
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

Sub_xMenu_Open:
Run(xMenu.MenuList[A_ThisMenu "_" A_ThisMenuItem])
Return


; //////////////////////////////////////////////////////////////////////////
SUB_TRAY_MENU_FILE_END_LABEL:
	temp_tm := "blabla"