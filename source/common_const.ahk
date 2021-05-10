; ; Note: Save with encoding UTF-8 with BOM if possible.
; ; Notepad will save UTF-8 files with BOM automatically (even though it does not say so).
; ; Some editors however save without BOM, and then special characters look messed up in the AHK GUI.



LANGUAGE_CONF_MAP := {"Donate": "捐赠! 让作者更有动力给sux加新功能! ^_^"
    ,"clipboard currently has no centent, please copy something...": "剪切板里目前没内容, 请复制点东西再试..."
    ,"There is a new version sux, would you like to check it out?": "sux有新版本, 你要看看有啥新功能吗?"
    ," Click me to chekc it out!": " 点击我查看!"
    ,"This is the lastest version.": "这已经是最新版本."
    ,"Unable to connect to the sux official website.": "无法连接到sux官网."
    ,"Maybe need a proxy.": "可能需要使用代理."
    ,"More": "更多"
    ,"More Search": "更多搜索"
    ,"More Command": "更多指令"
    ,"Do you want to open it with your browser?": "是否要用浏览器打开sux官网查看?"
    ,"Double hit Alt to open search box, hit Esc to close.": "双击Alt打开搜索框, 按Esc来关闭"
    ,"Light": "明"
    ,"Dark": "暗"
    ,"space": "空格"
    ,"quit": "退出"
    ,"Disable Win10 Auto Update": "禁止Win10自动更新"
    ,"Auto Disable sux In Full Screen": "全屏下自动禁用sux"
    ,"Hot Corner": "触发角"
    ,"Feature Switch": "功能开关"
    ,"Theme": "主题"
    ,"About": "关于"
    ,"Help": "帮助"
    ,"Check Update": "检查更新"
    ,"A New Version v": "有新版本 v"
    ,"Start With Windows": "开机启动"
    ,"Language": "语言"
    ,"Open sux Folder": "打开sux文件夹"
    ,"Edit Config File": "编辑配置文件"
    ,"Disable": "禁用"
    ,"Restart sux": "重启sux"
    ,"Exit": "退出"
    ,"Translation": "翻译"
    ,"Home Page": "主页"
    ,"Selected": "当前选择"
    ,"Nothing selected": "没有选中任何东西"
    ,"Nothing snipped": "没有截任何图"
    ,"Suspend": "悬浮"
    ,"ScreenShot && Suspend": "截图 && 贴图"
    ,"ScreenShot": "截图"
    ,"SuspendScreenshot": "贴图"
    ,"Paste All": "粘贴所有"
    ,"Delete All": "删除所有"
    ,"Can not separate words": "无法分割单词"
    ,"Transform Text": "变换文本"
    ,"Replace Text": "替换文本"
    ,"_Default": "默认"
    ,"Google & Baidu": "谷歌 & 百度" 
    ,"Google": "谷歌"
    ,"Baidu": "百度"
    ,"Bing": "必应"
    ,"Youdao": "有道"
    ,"Bilibili": "哔哩哔哩"
    ,"Jingdong": "京东"
    ,"Zhihu": "知乎"
    ,"Douban": "豆瓣"
    ,"Youku": "优酷"
    ,"Feedback": "反馈"}


global LIMIT_MODE := 0

global fake_lb_down := 0

global CornerEdgeOffset := 8  ; adjust tolerance value (pixels to corner) if desired	

global tick_detect_interval := 88

; ; millisecond, the smaller the value, the faster you have to double-click
global keyboard_double_click_timeout := 222
global keyboard_triple_click_timeout := 333
global auto_destory_quick_entry_gui_period := -22222  ; millisecond

global tick_disable_win10_auto_interval := 66666

global SHORTCUT_KEY_INDEX_ARR_LEFT := [" ", "q", "w", "e", "a", "s", "d", "z", "x", "c", "b", "t"]
global SHORTCUT_KEY_INDEX_ARR_RIGHT := ["h", "j", "k", "l", "y", "u", "i", "o", "p", "n", "m"]

global INI_DISABLE_WIN10_AUTO_UPDATE_SWITCH := "disable-win10-auto-update-switch"
global INI_LIMIT_MODE_IN_FULL_SCREEN := "limit-mode-in-full-screen"
global INI_HOT_CORNER := "hot-corner"
global INI_AUTORUN := "autorun"
global INI_THEME := "theme"
global INI_LANG := "lang"


; 记录快捷键与对应操作
HOTKEY_REGISTER_MAP := {}

; 记录command与对应操作
COMMAND_TITLE_2_ACTION_MAP := {}
COMMAND_TITLE_LIST := []

; 记录web-search与对应操作
WEB_SEARCH_TITLE_2_URL_MAP := {}
WEB_SEARCH_TITLE_LIST := []

; 记录theme与对应操作
THEME_CONF_REGISTER_MAP := {}

; 记录replace-string与对应操作
STR_REPLACE_CONF_REGISTER_MAP := {}

