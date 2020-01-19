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

global enable_hot_edges := 0  ; when right/middle mouse click or ctrl+8 on the edge (useful for touchpad user)
global use_touchpad := 0  ; if u use touchpad, try ctrl+8(or double click it) / double click right mouse

global is_wgesture_on := 0  ; if u dont use wgesture, set this to 0

global limit_mode_when_full_screen := 1  ;
global enable_auto_selection_copy := 0  ; should use with `Win+V` or `CapsLock+V`
global enable_double_click_capslock := 0  ; if 1, this may slow down capslock's first hit
global enable_hot_corners := 1  ; ; when cursor hover on the corner

; ; millisecond, the smaller the value, the faster you have to double-click
global keyboard_double_click_timeout := 222
global mouse_double_click_timeout := 288

; visual studio code path(e.g. "C:\Users\xxxx\AppData\Local\Programs\Microsoft VS Code\Code.exe")
; if blank, leave a ugly cmd window after open vsc.
global vscode_path := ""


; ---------------------------------------------------------------------o
; 					replace str map conf  ( Capslock+Shift+U )
; ---------------------------------------------------------------------o

global StrMap := 
(join str map
{
	"aaaaaaaawesomeahk" : "please ignore this line and don't del this line"

	,  "[]" : "「」"
	,  "{}" : "『』"
}
)


; ---------------------------------------------------------------------o
; 					web search url conf  
; ---------------------------------------------------------------------o

global WebSearchUrlMap := 
(join web search url map
{
	"aaaaaaaawesomeahk" : ["please ignore this line and don't del this line", ""] 

	,  "default" : ["Google", "https://www.google.com/search?num=50&safe=off&site=&source=hp&q=REPLACEME&btnG=Search&oq=&gs_l="]

	,  "ahk" : ["AutoHotKey", "https://www.google.com/search?num=50&safe=off&site=&source=hp&q=autohotkey%20REPLACEME&btnG=Search&oq=&gs_l="]
	,  "py" : ["Python", "https://www.google.com/search?num=50&safe=off&site=&source=hp&q=python%20REPLACEME&btnG=Search&oq=&gs_l="]
	,  "gg" : ["Google", "https://www.google.com/search?num=50&safe=off&site=&source=hp&q=REPLACEME&btnG=Search&oq=&gs_l="]
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
}
)


; ---------------------------------------------------------------------o
; 					Everything shortCut conf  
; ---------------------------------------------------------------------o

EverythingShortCut()
{
	Send, ^!+e
}

; ---------------------------------------------------------------------o
; 					double click conf  
; ---------------------------------------------------------------------o

DoubleClickCtrl8Trigger(){
	; 会有副作用, 因为单击 ctrl+8 是按住鼠标左键 
}
DoubleClickShiftTrigger(){
	; EverythingShortCut()
}
DoubleClickMButtonTrigger(){
}
DoubleClickCapsTrigger(){
}
DoubleClickCtrlTrigger(){
}


; ---------------------------------------------------------------------o
;                       hot edge conf 
; ---------------------------------------------------------------------o

HotEdgesTopTrigger(from){
	if (from = "Ctrl+8") {
		; ; OutputVar is made blank if no matching window exists; otherwise, it is set to one of the following numbers:
		; ; -1: The window is minimized (WinRestore can unminimize it).
		; ; 1: The window is maximized (WinRestore can unmaximize it).
		; ; 0: The window is neither minimized nor maximized.
		WinGet,S,MinMax,A
		if S=0
			WinMaximize, A
		else if S=1
			WinMinimize, A
		; else if S=-1
		;     WinRestore, A
	}
	else if (from = "RButton") {
	}
	else if (from = "MButton") {
	}
}
HotEdgesBottomTrigger(from){
	if (from = "Ctrl+8") {
		Send, #e
		MaximizeWindow("Explorer.exe")
	}
	else if (from = "RButton") {
	}
	else if (from = "MButton") {
	}
}
HotEdgesLeftTrigger(from){
	if (from = "Ctrl+8") {
		Send, #{Tab}
	}
	else if (from = "RButton") {
	}
	else if (from = "MButton") {
	}
}
HotEdgesRightTrigger(from){
	if (from = "Ctrl+8") {
		Send, #a
	}
	else if (from = "RButton") {
	}
	else if (from = "MButton") {
	}
}


; ---------------------------------------------------------------------o
; 					hot corners conf  
; ---------------------------------------------------------------------o

HotCornersTopLeftTrigger(){
	Send, ^#{Left}
}
HotCornersTopRightTrigger(){
	Send, ^#{Right}
}
HotCornersBottomLeftTrigger(){
	; Send, ^{Tab}
	Send, {LWin}
}
HotCornersBottomRightTrigger(){
	Send, !{Tab}
}
