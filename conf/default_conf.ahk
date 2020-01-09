; ; Note: Save with encoding UTF-8 with BOM if possible.
; ; Notepad will save UTF-8 files with BOM automatically (even though it does not say so).
; ; Some editors however save without BOM, and then special characters look messed up in the AHK GUI.


; ---------------------------------------------------------------------o
; 					general conf 
; ---------------------------------------------------------------------o

global enable_hot_edges := 0  ; when right/middle mouse click or ctrl+8 on the edge (useful for touchpad user)
global use_touchpad := 0  ; if u use touchpad, try ctrl+8(or double click it) / double click right mouse

global is_wgesture_on := 0  ; if u dont use wgesture, set this to 0

global enable_auto_selection_copy := 0  ; should use with `Win+V` or `CapsLock+V`
global enable_double_click_capslock := 0  ; if 1, this may slow down capslock's first hit
global enable_hot_corners := 1  ; ; when cursor hover on the corner

global dark_theme := 0  ; 0 for light theme

; ; millisecond, the smaller the value, the faster you have to double-click
global keyboard_double_click_timeout := 222
global mouse_double_click_timeout := 288


; ---------------------------------------------------------------------o
; 					replace str map conf  ( Capslock+Shift+U )
; ---------------------------------------------------------------------o

global StrMap := 
(join str map
{
	"aaaaaaaawesomeahk" : "please ignore this line and don't del this line"

	,  "“”" : "「」"
	,  "‘’" : "『』"
}
)


; ---------------------------------------------------------------------o
; 					web search url conf  
; ---------------------------------------------------------------------o

global WebSearchUrlMap := 
(join web search url map
{
	"aaaaaaaawesomeahk" : ["please ignore this line and don't del this line", ""] 

    ,  "ahk" : ["AutoHotKey", "https://www.google.com/search?num=50&safe=off&site=&source=hp&q=autohotkey%20REPLACEME&btnG=Search&oq=&gs_l="]
    ,  "gg" : ["Google", "https://www.google.com/search?num=50&safe=off&site=&source=hp&q=REPLACEME&btnG=Search&oq=&gs_l="]
    ,  "yd" : ["Youdao", "http://www.youdao.com/w/REPLACEME"]
    ,  "bd" : ["Baidu", "https://www.baidu.com/#ie=UTF-8&wd=REPLACEME"]
    ,  "bb" : ["Bilibili", "https://search.bilibili.com/all?keyword=REPLACEME"]
    ,  "jd" : ["JD", "https://search.jd.com/Search?keyword=REPLACEME&enc=utf-8"]
    ,  "zh" : ["Zhihu", "https://www.zhihu.com/search?type=content&q=REPLACEME"]
    ,  "gh" : ["GitHub", "https://github.com/search?q=REPLACEME"]
    ,  "so" : ["StackOverflow", "https://stackoverflow.com/search?q=REPLACEME"]
    ,  "yt" : ["Youtube", "https://www.youtube.com/results?search_query=REPLACEME"]
}
)


; ---------------------------------------------------------------------o
; 					double click conf  
; ---------------------------------------------------------------------o

DoubleClickCtrl8Trigger(){
}
DoubleClickShiftTrigger(){
    Send, ^!+e ; Everything
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
        Sleep, 666
        WinGet,S,MinMax,A
        if S=0
            WinMaximize,A
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
