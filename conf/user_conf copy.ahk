; ; Note: Save with encoding UTF-8 with BOM if possible.
; ; Notepad will save UTF-8 files with BOM automatically (even though it does not say so).
; ; Some editors however save without BOM, and then special characters look messed up in the AHK GUI.

; ; git update-index --assume-unchanged <file>
; ; git update-index --no-assume-unchanged <file>
; ; git ls-files -v | grep '^h'.


; ---------------------------------------------------------------------o
; 					override default override color code definitions conf
; ---------------------------------------------------------------------o


; ---------------------------------------------------------------------o
; 					override default override theme conf
; ---------------------------------------------------------------------o

; ; ; dark theme
; global nox_width := 620
; global nox_text_color := cWhite
; global nox_margin_x := 0
; global nox_margin_y := 0
; global nox_bg_color := "424242"
; global nox_control_color := "616161"
; global nox_border_shadow_type := classic_shadow_type

; ; light theme
global nox_width := 620
global nox_text_color := cBlack
global nox_margin_x := 0
global nox_margin_y := 0
global nox_bg_color := "ececec"
global nox_control_color := "d9d9d9"
global nox_border_shadow_type := modern_shadow_type


; ---------------------------------------------------------------------o
; 					override default override general conf
; ---------------------------------------------------------------------o


; ; visual studio code path(e.g. "C:\Users\xxxx\AppData\Local\Programs\Microsoft VS Code\Code.exe")
; ; if blank, leave a ugly cmd window after input cmd proj(open nox project with vscode).

global disable_win10_auto_update := 1

global auto_update_when_launch_nox := 1

global enable_hot_edges := 1  ; when ctrl+8 on the edge (useful for touchpad user)

; global EverythingShortCutFunc := "User_EverythingShortCut"
; global DoubleClickShiftTriggerFunc := ""
; global DoubleClickAltTriggerFunc := ""
; global DoubleClickCtrlTriggerFunc := ""
global HotEdgesTopHalfLeftTriggerFunc := "User_HotEdgesTopHalfLeftTrigger"
global HotEdgesTopHalfRightTriggerFunc := "User_HotEdgesTopHalfRightTrigger"
global HotEdgesBottomHalfLeftTriggerFunc := "User_HotEdgesBottomHalfLeftTrigger"
global HotEdgesBottomHalfRightTriggerFunc := "User_HotEdgesBottomHalfRightTrigger"
global HotEdgesLeftHalfUpTriggerFunc := "User_HotEdgesLeftHalfUpTrigger"
global HotEdgesLeftHalfDownTriggerFunc := "User_HotEdgesLeftHalfDownTrigger"
global HotEdgesRightHalfUpTriggerFunc := "User_HotEdgesRightHalfUpTrigger"
global HotEdgesRightHalfDownTriggerFunc := "User_HotEdgesRightHalfDownTrigger"
; global HotCornersTopLeftTriggerFunc := ""
; global HotCornersTopRightTriggerFunc := ""
; global HotCornersBottomLeftTriggerFunc := ""
; global HotCornersBottomRightTriggerFunc := ""


; global enable_hot_corners := 1  ; ; when cursor hover on the corner

; global limit_mode_when_full_screen := 1  ; if 1, turn off double shift/ctrl/alt & hot edges/corners when full screen
; global enable_auto_selection_copy := 0  ; should use with Win+V or CapsLock+Shift+F

; ; millisecond, the smaller the value, the faster you have to double-click
; global keyboard_double_click_timeout := 222
; global mouse_double_click_timeout := 666


; ---------------------------------------------------------------------o
; 					override default override replace str map conf  ( Capslock+Shift+U )
; ---------------------------------------------------------------------o


; ---------------------------------------------------------------------o
; 					override default override web search url conf
; ---------------------------------------------------------------------o

; special flags:
; - MULTI : use multi existing web search key
; - URL : raw url
global WebSearchUrlMap := 
(join web search url map
{
	"search_input_key" : ["search_flag(MULTI for special use)", "extra_info (don't del this line)"] 

	,  "default" : ["MULTI", "gg", "bd"]
	,  "nox" : ["Nox", "https://github.com/no5ix/nox"]

	,  "gg" : ["Google", "https://www.google.com.hk/search?safe=off&site=&source=hp&q=REPLACEME&btnG=Search&oq=&gs_l="]
	,  "bi" : ["Bing", "https://www.bing.com/search?q=REPLACEME&qs=n&FORM=BESBTB&sp=-1&pq=REPLACEME&sc=8-8&sk=&cvid=278DBE315C2D48E0AFC1B7B88E5878F3&ensearch=1"]
	,  "yd" : ["Youdao", "http://www.youdao.com/w/REPLACEME"]
	,  "bd" : ["Baidu", "https://www.baidu.com/#ie=UTF-8&wd=REPLACEME"]
	,  "bb" : ["Bilibili", "search.bilibili.com/all?keyword=REPLACEME"]
	,  "jd" : ["JD", "https://search.jd.com/Search?keyword=REPLACEME&enc=utf-8"]
	,  "zh" : ["Zhihu", "https://www.zhihu.com/search?type=content&q=REPLACEME"]
	,  "gh" : ["GitHub", "https://github.com/search?q=REPLACEME"]
	,  "so" : ["StackOverflow", "https://stackoverflow.com/search?q=REPLACEME"]
	,  "yt" : ["Youtube", "https://www.youtube.com/results?search_query=REPLACEME"]
	,  "ph" : ["PornHub", "https://www.pornhub.com/video/search?search=REPLACEME"]
	,  "db" : ["Douban", "https://www.douban.com/search?q=REPLACEME"]
	,  "qm" : ["QiMai", "https://www.qimai.cn/search/index/country/cn/search/REPLACEME"]
	,  "yk" : ["YouKu", "https://so.youku.com/search_video/q_REPLACEME?searchfrom=1"]
	,  "lc" : ["LeetCode", "https://leetcode-cn.com/problemset/all/?search=REPLACEME"]

	,  "np" : ["noodle_plan", "https://hulinhong.com/2018/08/06/noodle_plan/"]
	,  "an" : ["algo_newbie", "https://hulinhong.com/2018/10/23/algo_newbie/"]
	,  "anl" : ["algo_newbie", "http://localhost:9009/2018/10/23/algo_newbie/"]
	,  "npl" : ["noodle_plan local", "http://localhost:9009/2018/08/06/noodle_plan/"]
}
)


; ---------------------------------------------------------------------o
; 					override custom command line conf  
; ---------------------------------------------------------------------o

; global CustomCommandLineMap := 
; (join custom command line map
; {
; 	"command_line_key" : "command_line_info (dont del this line)"

; 	,  "USE_CURRENT_DIRECTORY_PATH_CMDs": {"cmd" : "%UserProfile%\Desktop", "git" : "~/Desktop"}
; 	,  "cmd" : ["cmd.exe"]

; 	,  "ev" : ["C:\Program Files\Everything\Everything.exe"]
; 	,  "git" : ["C:\Program Files\Git\bin\bash.exe", "--login"]
; 	,  "blog" : ["C:\Program Files\Microsoft VS Code\Code.exe", "C:\Users\b\Documents\github\hexo-theme-next-optimized"]
; 	,  "proj" : ["C:\Program Files\Microsoft VS Code\Code.exe", "C:\Users\b\Documents\github\nox"]
; 	,  "test.py" : ["C:\Program Files\Microsoft VS Code\Code.exe", "C:\Users\b\Desktop\test.py"]
; 	,  "test.go" : ["C:\Program Files\Microsoft VS Code\Code.exe", "C:\Users\b\Desktop\test.go"]
; 	,  "test.cpp" : ["C:\Program Files\Microsoft VS Code\Code.exe", "C:\Users\b\Desktop\test.cpp"]
; }
; )


; ---------------------------------------------------------------------o
; 					override default TriggerFunc conf
; ---------------------------------------------------------------------o

; User_EverythingShortCut() {
; 	; u can set your own Everything shortcut here, just like ` Send, ^!+e `
; }

User_HotEdgesTopHalfLeftTrigger(from) {
	if (from = "Ctrl+8") {
		; ; Sets ErrorLevel to the Process ID (PID) if a matching process exists, or 0 otherwise.
		; Process, Exist, cloudmusic.exe
		; if !ErrorLevel
		; {
			ToolTipWithTimer("Launching Music App ...", 1111)
			run "C:\Program Files (x86)\Netease\CloudMusic\cloudmusic.exe"
		; }
		; else
		; {
		; 	Send, ^+!0
		; 	ToolTipWithTimer("Pause/Play music ...", 1111)
		; }
		return should_ignore_original_action
	}					
	return should_not_ignore_original_action
}

User_HotEdgesTopHalfRightTrigger(from) {
	if (from = "Ctrl+8") {						
		; Send, #e
		run "explorer.exe"
		ToolTipWithTimer("Launching File Explorer ...", 1111)
		MaximizeWindow(1111, "Explorer.exe")
		return should_ignore_original_action
	}					
	return should_not_ignore_original_action
}

User_HotEdgesBottomHalfRightTrigger(from) {
	if (from = "Ctrl+8") {
		; ToolTipWithTimer("Launching WeChat ...", 1111)
		; ; run "C:\Program Files (x86)\Tencent\WeChat\WeChat.exe"
		; Send, ^+!7
		; MaximizeWindow(1111, "WeChat.exe")
		Send, {F5}	
		ToolTipWithTimer(" Refresh tab ...", 1111)
		return should_ignore_original_action
	}					
	; else if (from = "MButton") {
	; 	Send, #d
	; 	return should_ignore_original_action
	; }					
	return should_not_ignore_original_action
}

User_HotEdgesBottomHalfLeftTrigger(from) {
	if (from = "Ctrl+8") {												
		; Send, ^+{Esc}
		; ToolTipWithTimer("Launching Task Manager ...", 1111)
		; MaximizeWindow(1111, "taskmgr.exe")
		Send, ^+t
		; Send, !{F4}
		ToolTipWithTimer("Reopen closed tap...", 1111)
		return should_ignore_original_action
	}					
	; else if (from = "MButton") {
	; 	Send, ^+t
	; 	return should_ignore_original_action
	; }
	return should_not_ignore_original_action
}

User_HotEdgesLeftHalfDownTrigger(from) {
	if (from = "Ctrl+8") {
	; 	Send, ^+!1
	; 	ToolTipWithTimer("Last Song ...", 1111)
	; 	return should_ignore_original_action
	; }					
	; else if (from = "MButton") {
		Send, #{Tab}
		return should_ignore_original_action
	}				
	return should_not_ignore_original_action
}

User_HotEdgesRightHalfDownTrigger(from) {
	if (from = "Ctrl+8") {
	; 	Send, ^+!2
	; 	ToolTipWithTimer("Next song ...", 1111)
	; 	return should_ignore_original_action
	; }	
	; else if (from = "MButton") {
		Send, #a
		return should_ignore_original_action
	}				
	return should_not_ignore_original_action
}

User_HotEdgesLeftHalfUpTrigger(from){
	if (from = "Ctrl+8") {		
	; 	WebSearch(GetCurSelectedText())
	; 	return should_ignore_original_action
	; }			
	; else if (from = "MButton") {
		Send {LWin Down}
		Send, {Left}
		Sleep, 111
		Send {LWin Up}
		return should_ignore_original_action
	}					
	return should_not_ignore_original_action
}

User_HotEdgesRightHalfUpTrigger(from){
	if (from = "Ctrl+8") {	
	; 	%EverythingShortCutFunc%()
	; 	return should_ignore_original_action
	; }			
	; else if (from = "MButton") {
		Send {LWin Down}
		Send, {Right}
		Sleep, 111
		Send {LWin Up}
		return should_ignore_original_action
	}						
	return should_not_ignore_original_action
}