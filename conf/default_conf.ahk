; ; Note: Save with encoding UTF-8 with BOM if possible.
; ; Notepad will save UTF-8 files with BOM automatically (even though it does not say so).
; ; Some editors however save without BOM, and then special characters look messed up in the AHK GUI.



; ---------------------------------------------------------------------o
; 					color code definitions default conf
; ---------------------------------------------------------------------o

global cRed := "cc6666"
global cOrange := "de935f"
global cYellow := "f0c674"
global cGreen := "b5bd68"
global cAqua := "8abeb7"
global cBlue := "81a2be"
global cPurple := "b294bb"
global cGray := "808080"
global cWhite := "ffffff"
global cBlack := "000000"

global classic_shadow_type := 0
global modern_shadow_type := 1


; ---------------------------------------------------------------------o
; 			         theme default conf
; ---------------------------------------------------------------------o

; ; dark theme
global nox_width := 620
global nox_text_color := cWhite
global nox_margin_x := 0
global nox_margin_y := 0
global nox_bg_color := "424242"
global nox_control_color := "616161"
global nox_border_shadow_type := classic_shadow_type

; ; ; light theme 
; global nox_width := 620
; global nox_text_color := cBlack
; global nox_margin_x := 0
; global nox_margin_y := 0
; global nox_bg_color := "ececec"
; global nox_control_color := "d9d9d9"
; global nox_border_shadow_type := modern_shadow_type


; ---------------------------------------------------------------------o
; 					general conf 
; ---------------------------------------------------------------------o


; visual studio code path(e.g. "C:\Users\xxxx\AppData\Local\Programs\Microsoft VS Code\Code.exe")
; if blank, leave a ugly cmd window after input cmd `proj`(open nox project with vscode).

global disable_win10_auto_update := 0

global auto_update_when_launch_nox := 0

global enable_hot_edges := 0  ; when ctrl+8 on the edge (useful for touchpad user)


; global DoubleClickShiftTriggerFunc := "Default_DoubleClickShiftTrigger"
global DoubleClickAltTriggerFunc := "Default_DoubleClickAltTrigger"
global DoubleClickCtrlTriggerFunc := "Default_DoubleClickCtrlTrigger"
global HotEdgesTopHalfLeftTriggerFunc := "Default_HotEdgesTopHalfLeftTrigger"
global HotEdgesTopHalfRightTriggerFunc := "Default_HotEdgesTopHalfRightTrigger"
global HotEdgesBottomHalfLeftTriggerFunc := "Default_HotEdgesBottomHalfLeftTrigger"
global HotEdgesBottomHalfRightTriggerFunc := "Default_HotEdgesBottomHalfRightTrigger"
global HotEdgesLeftHalfUpTriggerFunc := "Default_HotEdgesLeftHalfUpTrigger"
global HotEdgesLeftHalfDownTriggerFunc := "Default_HotEdgesLeftHalfDownTrigger"
global HotEdgesRightHalfUpTriggerFunc := "Default_HotEdgesRightHalfUpTrigger"
global HotEdgesRightHalfDownTriggerFunc := "Default_HotEdgesRightHalfDownTrigger"
global HotCornersTopLeftTriggerFunc := "Default_HotCornersTopLeftTrigger"
global HotCornersTopRightTriggerFunc := "Default_HotCornersTopRightTrigger"
global HotCornersBottomLeftTriggerFunc := "Default_HotCornersBottomLeftTrigger"
global HotCornersBottomRightTriggerFunc := "Default_HotCornersBottomRightTrigger"


global enable_hot_corners := 1  ; ; when cursor hover on the corner
global hot_corners_detect_interval := 88

global auto_limit_mode_when_full_screen := 0  ; if 1, turn off double shift/ctrl/alt & hot edges/corners when full screen

; ; millisecond, the smaller the value, the faster you have to double-click
global keyboard_double_click_timeout := 222
global mouse_double_click_timeout := 666



; ; ---------------------------------------------------------------------o
; ; 					replace str map conf
; ; ---------------------------------------------------------------------o

; global StrMap := 
; (join str map
; {
; 	"origin_str" : "new_str (don't del this line)"

; 	,  "[]" : "「」"
; 	,  "{}" : "『』"
; }
; )


; ---------------------------------------------------------------------o
; 					web search url conf  
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
	,  "bb" : ["Bilibili", "https://search.bilibili.com/all?keyword=REPLACEME"]
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
}
)


; ---------------------------------------------------------------------o
; 					custom command line conf  
; ---------------------------------------------------------------------o

global CustomCommandLineMap := 
(join custom command line map
{
	"command_line_key" : "command_line_info (dont del this line)"

	,  "USE_CURRENT_DIRECTORY_PATH_CMDs": {"cmd" : "%UserProfile%\Desktop"}  ;, "git" : "~/Desktop"}
	,  "cmd" : ["cmd.exe"]

	; ,  "ev" : ["C:\Program Files\Everything\Everything.exe"]
	; ,  "git" : ["C:\Program Files\Git\bin\bash.exe", "--login"]
	; ,  "proj" : ["C:\Program Files\Microsoft VS Code\Code.exe", "C:\Users\no5ix\Documents\github\example_proj"]
	; ,  "test.go" : ["notepad.exe", "C:\Users\b\Desktop\test.go"]
	; ,  "test.py" : ["C:\Program Files\Microsoft VS Code\Code.exe", "C:\Users\b\Desktop\test.py"]
}
)