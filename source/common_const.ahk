; ; Note: Save with encoding UTF-8 with BOM if possible.
; ; Notepad will save UTF-8 files with BOM automatically (even though it does not say so).
; ; Some editors however save without BOM, and then special characters look messed up in the AHK GUI.

global limit_mode := 0
global old_limit_mode := limit_mode

global fake_lb_down := 0

global CornerEdgeOffset := 8  ; adjust tolerance value (pixels to corner) if desired	

global hot_corners_detect_interval := 88

global auto_limit_mode_when_full_screen := 0  ; if 1, turn off double shift/ctrl/alt & hot edges/corners when full screen

; ; millisecond, the smaller the value, the faster you have to double-click
global keyboard_double_click_timeout := 222
global mouse_double_click_timeout := 666


LANGUAGE_CONF_MAP := {"Donate": "捐赠! 让作者更有动力给nox加新功能! ^_^"
    ,"clipboard currently has no centent, please copy something...": "剪切板里目前没内容, 请复制点东西再试..."
    ,"There is a new version nox, would you like to check it out?": "nox有新版本, 你要看看有啥新功能吗?"
    ,"This is the lastest version.": "这已经是最新版本."
    ,"Can not connect to GitHub.": "无法连接到GitHub."
    ,"Maybe need a proxy.": "可能需要使用代理."
    ,"Do you want to open the nox official website with your browser?": "是否要用浏览器打开nox官网查看?"
    ,"About": "关于"
    ,"Help": "帮助"
    ,"Check Update": "检查更新"
    ,"A New Version! ": "有新版本! "
    ,"Start With Windows": "开机启动"
    ,"Language": "语言"
    ,"Open nox Folder": "打开nox文件夹"
    ,"Edit Config File": "编辑配置文件"
    ,"Disable": "禁用"
    ,"Restart nox": "重启nox"
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

