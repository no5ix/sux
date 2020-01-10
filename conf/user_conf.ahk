; ; Note: Save with encoding UTF-8 with BOM if possible.
; ; Notepad will save UTF-8 files with BOM automatically (even though it does not say so).
; ; Some editors however save without BOM, and then special characters look messed up in the AHK GUI.

; ; git update-index --assume-unchanged <file>
; ; git update-index --no-assume-unchanged <file>
; ; git ls-files -v | grep '^h'. 


; ---------------------------------------------------------------------o
; 					override color code definitions default conf
; ---------------------------------------------------------------------o

; global cRed := "cc6666"
; global cOrange := "de935f"
; global cYellow := "f0c674"
; global cGreen := "b5bd68"
; global cAqua := "8abeb7"
; global cBlue := "81a2be"
; global cPurple := "b294bb"
; global cGray := "808080"
; global cWhite := "ffffff"
; global cBlack := "000000"

; global classic_shadow_type := 0
; global modern_shadow_type := 1


; ---------------------------------------------------------------------o
; 					override theme default conf
; ---------------------------------------------------------------------o

; ; ; dark theme
; global nox_width := 620
; global nox_text_color := cWhite
; global nox_margin_x := 0
; global nox_margin_y := 0
; global nox_bg_color := "424242"
; global nox_control_color := "616161"
; global nox_border_shadow_type := classic_shadow_type

; ; ; light theme 
; global nox_width := 620
; global nox_text_color := cBlack
; global nox_margin_x := 0
; global nox_margin_y := 0
; global nox_bg_color := "ececec"
; global nox_control_color := "d9d9d9"
; global nox_border_shadow_type := modern_shadow_type

; ; ; add your own theme here, for example :
; global nox_width := 666
; global nox_text_color := cWhite
; global nox_margin_x := 8
; global nox_margin_y := 8
; global nox_bg_color := cGray
; global nox_control_color := cRed
; global nox_border_shadow_type := classic_shadow_type


; ---------------------------------------------------------------------o
; 					override general default conf 
; ---------------------------------------------------------------------o

; global enable_hot_edges := 0  ; when right/middle mouse click or ctrl+8 on the edge (useful for touchpad user)
; global use_touchpad := 0  ; if u use touchpad, try ctrl+8(or double click it) / double click right mouse

; global is_wgesture_on := 0  ; if u dont use wgesture, set this to 0

; global enable_auto_selection_copy := 0  ; should use with `Win+V` or `CapsLock+V`
; global enable_double_click_capslock := 0  ; if 1, this may slow down capslock's first hit
; global enable_hot_corners := 1  ; ; when cursor hover on the corner

; ; ; millisecond, the smaller the value, the faster you have to double-click
; global keyboard_double_click_timeout := 222
; global mouse_double_click_timeout := 288

; visual studio code path(e.g. "C:\Users\xxxx\AppData\Local\Programs\Microsoft VS Code\Code.exe")
; if blank, leave a ugly cmd window after open vsc.
; global vscode_path := ""


; ---------------------------------------------------------------------o
; 					override replace str map default conf  ( Capslock+Shift+U )
; ---------------------------------------------------------------------o

; global StrMap := 
; (join str map
; {
; 	"aaaaaaaawesomeahk" : "please ignore this line and don't del this line"

	; ,  "“”" : "「」"
	; ,  "‘’" : "『』"
; 	,  "@@" : "xxxx@gmail.com"
; }
; )


; ---------------------------------------------------------------------o
; 					override web search url default conf  
; ---------------------------------------------------------------------o

; global WebSearchUrlMap := 
; (join web search url map
; {
; 	"aaaaaaaawesomeahk" : ["please ignore this line and don't del this line", ""] 

;     ,  "ahk" : ["AutoHotKey", "https://www.google.com/search?num=50&safe=off&site=&source=hp&q=autohotkey%20REPLACEME&btnG=Search&oq=&gs_l="]
;     ,  "gg" : ["Google", "https://www.google.com/search?num=50&safe=off&site=&source=hp&q=REPLACEME&btnG=Search&oq=&gs_l="]
;     ,  "yd" : ["Youdao", "http://www.youdao.com/w/REPLACEME"]
;     ,  "bd" : ["Baidu", "https://www.baidu.com/#ie=UTF-8&wd=REPLACEME"]
;     ,  "bb" : ["Bilibili", "https://search.bilibili.com/all?keyword=REPLACEME"]
;     ,  "jd" : ["JD", "https://search.jd.com/Search?keyword=REPLACEME&enc=utf-8"]
;     ,  "zh" : ["Zhihu", "https://www.zhihu.com/search?type=content&q=REPLACEME"]
;     ,  "gh" : ["GitHub", "https://github.com/search?q=REPLACEME"]
;     ,  "so" : ["StackOverflow", "https://stackoverflow.com/search?q=REPLACEME"]
;     ,  "yt" : ["Youtube", "https://www.youtube.com/results?search_query=REPLACEME"]
    ; ,  "ph" : ["PornHub", "https://www.pornhub.com/video/search?search=REPLACEME"]
; }
; )