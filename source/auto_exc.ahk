; ; Note: Save with encoding UTF-8 with BOM if possible.
; ; Notepad will save UTF-8 files with BOM automatically (even though it does not say so).
; ; Some editors however save without BOM, and then special characters look messed up in the AHK GUI.


RunAsAdmin() {
	full_command_line := DllCall("GetCommandLine", "str")
	if not (A_IsAdmin or RegExMatch(full_command_line, " /restart(?!\S)"))
	{
		try
		{
			if A_IsCompiled
				Run *RunAs "%A_ScriptFullPath%" /restart
			else
				Run *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%"
		}
		ExitApp
	}
}

IsFirstTimeRunNox() {
	monitor_xy_conf_file := A_ScriptDir "\conf\monitor_xy_conf.ahk"
	return !FileExist(monitor_xy_conf_file)
}


SaveMonitorXyConfToFile() {
	monitor_xy_conf_str := "`;`; This file is generated, please do not modify`n`n"
			. "global second_monitor_min_x := " . second_monitor_min_x . " `n"
			. "global second_monitor_min_y := " . second_monitor_min_y . " `n"
			. "global second_monitor_max_x := " . second_monitor_max_x . " `n"
			. "global second_monitor_max_y := " . second_monitor_max_y

	monitor_xy_conf_file := A_ScriptDir "\conf\monitor_xy_conf.ahk"
	FileDelete %monitor_xy_conf_file%  ; In case previous run was terminated prematurely.
	FileAppend, %monitor_xy_conf_str%, %monitor_xy_conf_file%
	Sleep, 888
	#IncludeAgain *i %A_ScriptDir%\conf\monitor_xy_conf.ahk
}

WriteMonitorConf() {
	monitor_xy_conf_file := A_ScriptDir "\conf\monitor_xy_conf.ahk"
	if !FileExist(monitor_xy_conf_file) {
		FileAppend, 
		(
		;; This file is generated, please do not modify
		), %monitor_xy_conf_file%
	}

	if enable_hot_corners {
		SysGet, monitor_cnt, MonitorCount
		if (monitor_cnt > 2) {
			msg_str := "You have more than 2 monitors, hot corners will not perform exactly at none primary monitor"
			MsgBox,,, %msg_str%
		}
		else {
			#IncludeAgain *i %A_ScriptDir%\conf\monitor_xy_conf.ahk
			if (monitor_cnt == 2 and second_monitor_min_x == 0) {
				msg_str := "You have 2 monitors, if they have two different resolution,"
					. " you can use cmd 'xy' to set the 2th monitor resolustion config. `n`n"
					. " Would you like to set it now(Yes) or later(No)?"
				MsgBox, 4,, %msg_str%
				IfMsgBox Yes
					Set2thMonitorXY()
			}
			SetTimer, HotCorners, %hot_corners_detect_interval%
		}
	}
}


ReloadAfterWritingUserConf() {
	user_conf_file := A_ScriptDir "\conf\user_conf.ahk"
	if !FileExist(user_conf_file) {
		FileAppend, 
 		(
; ; ; Note: Save with encoding UTF-8 with BOM if possible.
; ; ; Notepad will save UTF-8 files with BOM automatically (even though it does not say so).
; ; ; Some editors however save without BOM, and then special characters look messed up in the AHK GUI.

; ; ; git update-index --assume-unchanged <file>
; ; ; git update-index --no-assume-unchanged <file>
; ; ; git ls-files -v | grep '^h'.


; ; ---------------------------------------------------------------------o
; ; 					override default override color code definitions conf
; ; ---------------------------------------------------------------------o


; ; ---------------------------------------------------------------------o
; ; 					override default override theme conf
; ; ---------------------------------------------------------------------o

; ; ; ; dark theme
; ; global nox_width := 620
; ; global nox_text_color := cWhite
; ; global nox_margin_x := 0
; ; global nox_margin_y := 0
; ; global nox_bg_color := "424242"
; ; global nox_control_color := "616161"
; ; global nox_border_shadow_type := classic_shadow_type

; ; ; light theme
; global nox_width := 620
; global nox_text_color := cBlack
; global nox_margin_x := 0
; global nox_margin_y := 0
; global nox_bg_color := "ececec"
; global nox_control_color := "d9d9d9"
; global nox_border_shadow_type := modern_shadow_type


; ; ---------------------------------------------------------------------o
; ; 					override default override general conf
; ; ---------------------------------------------------------------------o


; ; ; visual studio code path(e.g. "C:\Users\xxxx\AppData\Local\Programs\Microsoft VS Code\Code.exe")
; ; ; if blank, leave a ugly cmd window after input cmd proj(open nox project with vscode).

; global disable_win10_auto_update := 1

; global auto_update_when_launch_nox := 0  ; if 1, git is required

; global enable_hot_edges := 1  ; when ctrl+8 on the edge (useful for touchpad user)

; ; global DoubleClickShiftTriggerFunc := ""
; ; global DoubleClickAltTriggerFunc := ""
; ; global DoubleClickCtrlTriggerFunc := ""
; global HotEdgesTopHalfLeftTriggerFunc := "User_HotEdgesTopHalfLeftTrigger"
; global HotEdgesTopHalfRightTriggerFunc := "User_HotEdgesTopHalfRightTrigger"
; global HotEdgesBottomHalfLeftTriggerFunc := "User_HotEdgesBottomHalfLeftTrigger"
; global HotEdgesBottomHalfRightTriggerFunc := "User_HotEdgesBottomHalfRightTrigger"
; global HotEdgesLeftHalfUpTriggerFunc := "User_HotEdgesLeftHalfUpTrigger"
; global HotEdgesLeftHalfDownTriggerFunc := "User_HotEdgesLeftHalfDownTrigger"
; global HotEdgesRightHalfUpTriggerFunc := "User_HotEdgesRightHalfUpTrigger"
; global HotEdgesRightHalfDownTriggerFunc := "User_HotEdgesRightHalfDownTrigger"
; ; global HotCornersTopLeftTriggerFunc := ""
; ; global HotCornersTopRightTriggerFunc := ""
; ; global HotCornersBottomLeftTriggerFunc := ""
; ; global HotCornersBottomRightTriggerFunc := ""


; ; global enable_hot_corners := 1  ; ; when cursor hover on the corner

; ; global limit_mode_when_full_screen := 1  ; if 1, turn off double shift/ctrl/alt & hot edges/corners when full screen
; ; global enable_auto_selection_copy := 0  ; should use with Win+V or CapsLock+Shift+F

; ; ; millisecond, the smaller the value, the faster you have to double-click
; ; global keyboard_double_click_timeout := 222
; ; global mouse_double_click_timeout := 666


; ; ---------------------------------------------------------------------o
; ; 					override default override replace str map conf  ( Capslock+Shift+U )
; ; ---------------------------------------------------------------------o


; ; ---------------------------------------------------------------------o
; ; 					override default override web search url conf
; ; ---------------------------------------------------------------------o

; ; special flags:
; ; - MULTI : use multi existing web search key
; ; - URL : raw url
; global WebSearchUrlMap := 
; (join web search url map
; {
; 	"search_input_key" : ["search_flag(MULTI for special use)", "extra_info (don't del this line)"] 

; 	,  "default" : ["MULTI", "gg", "bd"]
; 	,  "nox" : ["Nox", "https://github.com/no5ix/nox"]

; 	,  "gg" : ["Google", "https://www.google.com.hk/search?safe=off&site=&source=hp&q=REPLACEME&btnG=Search&oq=&gs_l="]
; 	,  "bi" : ["Bing", "https://www.bing.com/search?q=REPLACEME&qs=n&FORM=BESBTB&sp=-1&pq=REPLACEME&sc=8-8&sk=&cvid=278DBE315C2D48E0AFC1B7B88E5878F3&ensearch=1"]
; 	,  "yd" : ["Youdao", "http://www.youdao.com/w/REPLACEME"]
; 	,  "bd" : ["Baidu", "https://www.baidu.com/#ie=UTF-8&wd=REPLACEME"]
; 	,  "bb" : ["Bilibili", "search.bilibili.com/all?keyword=REPLACEME"]
; 	,  "jd" : ["JD", "https://search.jd.com/Search?keyword=REPLACEME&enc=utf-8"]
; 	,  "zh" : ["Zhihu", "https://www.zhihu.com/search?type=content&q=REPLACEME"]
; 	,  "gh" : ["GitHub", "https://github.com/search?q=REPLACEME"]
; 	,  "so" : ["StackOverflow", "https://stackoverflow.com/search?q=REPLACEME"]
; 	,  "yt" : ["Youtube", "https://www.youtube.com/results?search_query=REPLACEME"]
; 	,  "ph" : ["PornHub", "https://www.pornhub.com/video/search?search=REPLACEME"]
; 	,  "db" : ["Douban", "https://www.douban.com/search?q=REPLACEME"]
; 	,  "qm" : ["QiMai", "https://www.qimai.cn/search/index/country/cn/search/REPLACEME"]
; 	,  "yk" : ["YouKu", "https://so.youku.com/search_video/q_REPLACEME?searchfrom=1"]
; 	,  "lc" : ["LeetCode", "https://leetcode-cn.com/problemset/all/?search=REPLACEME"]

; 	,  "np" : ["noodle_plan", "https://hulinhong.com/2018/08/06/noodle_plan/"]
;	,  "an" : ["algo_newbie", "https://hulinhong.com/2018/10/23/algo_newbie/"]
;	,  "anl" : ["algo_newbie", "http://localhost:9009/2018/10/23/algo_newbie/"]
; 	,  "npl" : ["noodle_plan local", "http://localhost:9009/2018/08/06/noodle_plan/"]
; }
; )


; ; ---------------------------------------------------------------------o
; ; 					override custom command line conf  
; ; ---------------------------------------------------------------------o

; global CustomCommandLineMap := 
; (join custom command line map
; {
; 	"command_line_key" : "command_line_info (dont del this line)"

; 	,  "USE_CURRENT_DIRECTORY_PATH_CMDs": {"cmd" : "%UserProfile%\Desktop", "git" : "~/Desktop"}
; 	,  "cmd" : ["cmd.exe"]


;	,  "ev" : ["C:\Program Files\Everything\Everything.exe"]
; 	,  "git" : ["C:\Program Files\Git\bin\bash.exe", "--login"]
; 	,  "blog" : ["C:\Program Files\Microsoft VS Code\Code.exe", "C:\Users\b\Documents\github\hexo-theme-next-optimized"]
; 	,  "proj" : ["C:\Program Files\Microsoft VS Code\Code.exe", "C:\Users\b\Documents\github\nox"]
; 	,  "test.py" : ["C:\Program Files\Microsoft VS Code\Code.exe", "C:\Users\b\Desktop\test.py"]
; 	,  "test.go" : ["C:\Program Files\Microsoft VS Code\Code.exe", "C:\Users\b\Desktop\test.go"]
; 	,  "test.cpp" : ["C:\Program Files\Microsoft VS Code\Code.exe", "C:\Users\b\Desktop\test.cpp"]
; }
; )


; ; ---------------------------------------------------------------------o
; ; 					override default TriggerFunc conf
; ; ---------------------------------------------------------------------o

; ; User_EverythingShortCut() {
; ; 	; u can set your own Everything shortcut here, just like ` Send, ^!+e `
; ; }

; User_HotEdgesTopHalfLeftTrigger(from) {
; 	if (from = "Ctrl+8") {
; 		; ; Sets ErrorLevel to the Process ID (PID) if a matching process exists, or 0 otherwise.
; 		; Process, Exist, cloudmusic.exe
; 		; if !ErrorLevel
; 		; {
; 			ToolTipWithTimer("Launching Music App ...", 1111)
; 			run "C:\Program Files (x86)\Netease\CloudMusic\cloudmusic.exe"
; 		; }
; 		; else
; 		; {
; 		; 	Send, ^+!0
; 		; 	ToolTipWithTimer("Pause/Play music ...", 1111)
; 		; }
; 		return should_ignore_original_action
; 	}					
; 	return should_not_ignore_original_action
; }

; User_HotEdgesTopHalfRightTrigger(from) {
; 	if (from = "Ctrl+8") {						
; 		; Send, #e
; 		run "explorer.exe"
; 		ToolTipWithTimer("Launching File Explorer ...", 1111)
; 		MaximizeWindow(1111, "Explorer.exe")
; 		return should_ignore_original_action
; 	}					
; 	return should_not_ignore_original_action
; }

; User_HotEdgesBottomHalfRightTrigger(from) {
; 	if (from = "Ctrl+8") {
; 		; ToolTipWithTimer("Launching WeChat ...", 1111)
; 		; ; run "C:\Program Files (x86)\Tencent\WeChat\WeChat.exe"
; 		; Send, ^+!7
; 		; MaximizeWindow(1111, "WeChat.exe")
; 		Send, {F5}	
; 		ToolTipWithTimer(" Refresh tab ...", 1111)
; 		return should_ignore_original_action
; 	}					
; 	; else if (from = "MButton") {
; 	; 	Send, #d
; 	; 	return should_ignore_original_action
; 	; }					
; 	return should_not_ignore_original_action
; }

; User_HotEdgesBottomHalfLeftTrigger(from) {
; 	if (from = "Ctrl+8") {												
; 		; Send, ^+{Esc}
; 		; ToolTipWithTimer("Launching Task Manager ...", 1111)
; 		; MaximizeWindow(1111, "taskmgr.exe")
; 		Send, ^+t
; 		; Send, !{F4}
; 		ToolTipWithTimer("Reopen closed tap...", 1111)
; 		return should_ignore_original_action
; 	}					
; 	; else if (from = "MButton") {
; 	; 	Send, ^+t
; 	; 	return should_ignore_original_action
; 	; }
; 	return should_not_ignore_original_action
; }

; User_HotEdgesLeftHalfDownTrigger(from) {
; 	if (from = "Ctrl+8") {
; 	; 	Send, ^+!1
; 	; 	ToolTipWithTimer("Last Song ...", 1111)
; 	; 	return should_ignore_original_action
; 	; }					
; 	; else if (from = "MButton") {
; 		Send, #{Tab}
; 		return should_ignore_original_action
; 	}				
; 	return should_not_ignore_original_action
; }

; User_HotEdgesRightHalfDownTrigger(from) {
; 	if (from = "Ctrl+8") {
; 	; 	Send, ^+!2
; 	; 	ToolTipWithTimer("Next song ...", 1111)
; 	; 	return should_ignore_original_action
; 	; }	
; 	; else if (from = "MButton") {
; 		Send, #a
; 		return should_ignore_original_action
; 	}				
; 	return should_not_ignore_original_action
; }

; User_HotEdgesLeftHalfUpTrigger(from){
; 	if (from = "Ctrl+8") {		
; 	; 	WebSearch(GetCurSelectedText())
; 	; 	return should_ignore_original_action
; 	; }			
; 	; else if (from = "MButton") {
; 		Send {LWin Down}
; 		Send, {Left}
; 		Sleep, 111
; 		Send {LWin Up}
; 		return should_ignore_original_action
; 	}					
; 	return should_not_ignore_original_action
; }

; User_HotEdgesRightHalfUpTrigger(from){
; 	if (from = "Ctrl+8") {	
; 	; 	return should_ignore_original_action
; 	; }			
; 	; else if (from = "MButton") {
; 		Send {LWin Down}
; 		Send, {Right}
; 		Sleep, 111
; 		Send {LWin Up}
; 		return should_ignore_original_action
; 	}						
; 	return should_not_ignore_original_action
; }


		), %user_conf_file%
		
		SetTimer, ReloadForIncludingUserConf, -88
	}
	; else {
	; 	; #IncludeAgain *i %A_ScriptDir%\conf\user_conf.ahk
	; 	; SetTimer, ReloadAfterWritingUserConf, off
	; }
}


HotCorners() {				; Timer content 
	if (limit_mode){
		return
	}

	; if IsCorner("IsOnTop"){
	; 	LButtonDown := GetKeyState("LButton","P")
	; 	if LButtonDown
	; 		return
	; 	HotEdgesTopTrigger()
	; 	Loop 
	; 	{
	; 		if ! IsCorner("IsOnTop")
	; 			break ; exits loop when mouse is no longer in the corner
	; 	}
	; 	return
	; }

	if IsCorner("TopLeft")
	{
		%HotCornersTopLeftTriggerFunc%()
		Loop 
		{
			if ! IsCorner("TopLeft")
				break ; exits loop when mouse is no longer in the corner
		}
		return
	}
	else if IsCorner("TopRight")
	{	
		%HotCornersTopRightTriggerFunc%()
		Loop
		{
			if ! IsCorner("TopRight")
				break ; exits loop when mouse is no longer in the corner
		}	
		return
	}
	else if IsCorner("BottomLeft")
	{	
		%HotCornersBottomLeftTriggerFunc%()
		Loop
		{
			if ! IsCorner("BottomLeft")
				break ; exits loop when mouse is no longer in the corner
		}	
		return
	}
	else if IsCorner("BottomRight")
	{	
		%HotCornersBottomRightTriggerFunc%()
		Loop
		{
			if ! IsCorner("BottomRight")
				break ; exits loop when mouse is no longer in the corner
		}	
		return
	}
}


IsAt_left(MouseX, cur_monitor_min_x) {
	return MouseX < (cur_monitor_min_x + CornerEdgeOffset)
}
IsAt_right(MouseX, cur_monitor_max_x) {
	return MouseX > (cur_monitor_max_x - CornerEdgeOffset)  
}
IsAt_top(MouseY, cur_monitor_min_y) {
	return MouseY < (cur_monitor_min_y + CornerEdgeOffset)
}
IsAt_bottom(MouseY, cur_monitor_max_y) {
	return MouseY > (cur_monitor_max_y - CornerEdgeOffset)
}

GetCurMonitorMinMaxXYArray(cur_mouse_x) {
	if (cur_mouse_x < 0 or cur_mouse_x >= A_ScreenWidth) {
		if (second_monitor_min_x == 0) {  ; means have 2 same resolution monitor
			second_monitor_min_x := cur_mouse_x < 0 ? -A_ScreenWidth : A_ScreenWidth
			second_monitor_max_x := cur_mouse_x < 0 ? 0 : (2 * A_ScreenWidth)
			second_monitor_min_y := 0
			second_monitor_max_y := A_ScreenHeight
			SaveMonitorXyConfToFile()
		}
		cur_monitor_min_x := second_monitor_min_x	
		cur_monitor_min_y := second_monitor_min_y	
		cur_monitor_max_x := second_monitor_max_x	
		cur_monitor_max_y := second_monitor_max_y	
	} else {
		cur_monitor_min_x := 0	
		cur_monitor_min_y := 0	
		cur_monitor_max_x := A_ScreenWidth	
		cur_monitor_max_y := A_ScreenHeight
	}
	return [cur_monitor_min_x, cur_monitor_max_x, cur_monitor_min_y, cur_monitor_max_y]
}

; compatible with dual monitor
IsCorner(cornerID="")
{
	CoordMode, Mouse, Screen		; Coordinate mode - coords will be passed to mouse related functions, with coords relative to entire screen 
	MouseGetPos, MouseX, MouseY 							; Function MouseGetPos retrieves the current position of the mouse cursor

	min_max_xy_arr := GetCurMonitorMinMaxXYArray(MouseX)

	if (cornerID = "TopLeft"){
		return IsAt_left(MouseX, min_max_xy_arr[1]) and IsAt_top(MouseY, min_max_xy_arr[3]) 
	}
	else if (cornerID = "TopRight"){
		return IsAt_right(MouseX, min_max_xy_arr[2]) and IsAt_top(MouseY, min_max_xy_arr[3]) 
	}
	else if (cornerID = "BottomLeft"){
		return IsAt_left(MouseX, min_max_xy_arr[1]) and IsAt_bottom(MouseY, min_max_xy_arr[4])
	}
	else if  (cornerID = "BottomRight") {
		return IsAt_right(MouseX, min_max_xy_arr[2]) and IsAt_bottom(MouseY, min_max_xy_arr[4])
	}
	else{
		CornerTopLeft := IsAt_top(MouseY, min_max_xy_arr[3]) and IsAt_left(MouseX, min_max_xy_arr[1])	
		CornerTopRight := IsAt_top(MouseY, min_max_xy_arr[3]) and IsAt_right(MouseX, min_max_xy_arr[2])  
		CornerBottomLeft := IsAt_bottom(MouseY, min_max_xy_arr[4]) and IsAt_left(MouseX, min_max_xy_arr[1])
		CornerBottomRight := IsAt_bottom(MouseY, min_max_xy_arr[4]) and IsAt_right(MouseX, min_max_xy_arr[2]) 
		return (CornerTopLeft or CornerTopRight or CornerBottomLeft or CornerBottomRight)
	}
}



ReloadForIncludingUserConf() {
	user_conf_file := A_ScriptDir "\conf\user_conf.ahk"
	if FileExist(user_conf_file) {
		Reload
	}
}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





RunAsAdmin()

if IsFirstTimeRunNox() {
    HandleStartingNoxWithWindows()
    WriteMonitorConf()
}

ReloadAfterWritingUserConf()

if auto_limit_mode_when_full_screen
	SetTimer, LimitModeWhenFullScreen, 88

if disable_win10_auto_update
    SetTimer, DisableWin10AutoUpdate, 66666

if enable_hot_corners
    SetTimer, HotCorners, %hot_corners_detect_interval%

if auto_update_when_launch_nox
    UpdateNox(1)
