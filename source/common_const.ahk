; ; Note: Save with encoding UTF-8 with BOM if possible.
; ; Notepad will save UTF-8 files with BOM automatically (even though it does not say so).
; ; Some editors however save without BOM, and then special characters look messed up in the AHK GUI.

global auto_limit_mode_when_full_screen := 0  ; if 1, turn off double shift/ctrl/alt & hot edges/corners when full screen
global limit_mode := 0
global old_limit_mode := limit_mode

global fake_lb_down := 0

global CornerEdgeOffset := 8  ; adjust tolerance value (pixels to corner) if desired	

global hot_corners_detect_interval := 88

; ; millisecond, the smaller the value, the faster you have to double-click
global keyboard_double_click_timeout := 222
global mouse_double_click_timeout := 666


LANGUAGE_CONF_MAP := {"Donate": "捐赠! 让作者更有动力给sux加新功能! ^_^"
    ,"clipboard currently has no centent, please copy something...": "剪切板里目前没内容, 请复制点东西再试..."
    ,"There is a new version sux, would you like to check it out?": "sux有新版本, 你要看看有啥新功能吗?"
    ,"This is the lastest version.": "这已经是最新版本."
    ,"Can not connect to sux official website.": "无法连接到sux官网."
    ,"Maybe need a proxy.": "可能需要使用代理."
    ,"Do you want to open it with your browser?": "是否要用浏览器打开sux官网查看?"
    ,"Double hit Alt to open search box, hit Esc to close.": "双击Alt打开搜索框, 按Esc来关闭"
    ,"About": "关于"
    ,"Help": "帮助"
    ,"Check Update": "检查更新"
    ,"A New Version! ": "有新版本! "
    ,"Start With Windows": "开机启动"
    ,"Language": "语言"
    ,"Open sux Folder": "打开sux文件夹"
    ,"Edit Config File": "编辑配置文件"
    ,"Disable": "禁用"
    ,"Restart sux": "重启sux"
    ,"Exit": "退出"
    ,"Home Page": "主页"
    ,"Feedback": "反馈"}


; 记录快捷键与对应操作
HOTKEY_REGISTER_MAP := {}

; 记录command与对应操作
CMD_REGISTER_MAP := {}

; 记录web-search与对应操作
WEB_SEARCH_REGISTER_MAP := {}

; 记录additional-features与对应操作
ADDITIONAL_FEATURES_REGISTER_MAP := {}

; 记录theme与对应操作
THEME_CONF_REGISTER_MAP := {}

; 记录replace-string与对应操作
STR_REPLACE_CONF_REGISTER_MAP := {}

