; ; Note: Save with encoding UTF-8 with BOM if possible.
; ; Notepad will save UTF-8 files with BOM automatically (even though it does not say so).
; ; Some editors however save without BOM, and then special characters look messed up in the AHK GUI.


; ---------------------------------------------------------------------o
; 					overrides general default conf 
; ---------------------------------------------------------------------o

; global enable_hot_edges := 1  ; when right/middle mouse click or ctrl+8 on the edge (useful for touchpad user)
; global use_touchpad := 1  ; if u use touchpad, try ctrl+8(or double click it) / double click right mouse

; global is_wgesture_on := 1  ; if u dont use wgesture, set this to 0

; global enable_auto_selection_copy := 0  ; should use with `Win+V` or `CapsLock+V`
; global enable_double_click_capslock := 0  ; if 1, this may slow down capslock's first hit
; global enable_hot_corners := 1  ; ; when cursor hover on the corner

; global dark_theme := 0  ; 0 for light theme

; ; ; millisecond, the smaller the value, the faster you have to double-click
; global keyboard_double_click_timeout := 222
; global mouse_double_click_timeout := 288


; ---------------------------------------------------------------------o
; 					overrides replace str map default conf  ( Capslock+shift+U )
; ---------------------------------------------------------------------o

; global StrMap := 
; (join str map
; {
; 	"aaaaaaaawesomeahk" : "please ignore this line and don't del this line"

; 	,  "“”" : "「」"
; 	,  "“”" : "「」"
; 	,  "@@" : "xxxx@gmail.com"
; }
; )


; ---------------------------------------------------------------------o
; 					overrides web search url default conf  
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
; }
; )