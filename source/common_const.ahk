; ; Note: Save with encoding UTF-8 with BOM if possible.
; ; Notepad will save UTF-8 files with BOM automatically (even though it does not say so).
; ; Some editors however save without BOM, and then special characters look messed up in the AHK GUI.



LANGUAGE_CONF_MAP := {"Tips: ": "小技巧: "
    ,"Donate": "捐赠! 让作者更有动力给sux加新功能! ^_^"
    ,"after selecting text, this menu can automatically process it": "选择文本后，此菜单可以自动处理它"
    ,"clipboard currently has no centent, please copy something...": "剪切板里目前没内容, 请复制点东西再试..."
    ,"There is a new version sux, would you like to open sux official website to download the new sux?": "sux有新版本, 您要打开sux官网去下载新sux吗?"
    ," Click me to chekc it out!": " 点击我查看!"
    ,"This is the lastest version.": "这已经是最新版本."
    ,"Unable to connect to the sux official website.": "无法连接到sux官网."
    ,"Maybe need a proxy.": "可能需要使用代理."
    ,"More": "更多"
    ,"More Search": "更多搜索"
    ,"More Command": "更多指令"
    ,"Do you want to open it with your browser?": "是否要用浏览器打开sux官网查看?"
    ,"Double hit Alt to open search box, hit Esc to close.": "双击Alt打开搜索框, 按Esc来关闭"
    ,"sux limit mode auto disable not in full screen mode": "sux限制模式在非全屏时自动关闭"
    ,"sux limit mode auto enable in full screen mode": "sux限制模式在全屏时自动开启"
    ,"click img to make it transparent": "点击图片使其透明"
    ,"Auto": "自动"
    ,"Light": "明"
    ,"Dark": "暗"
    ,"space": "空格"
    ,"quit": "退出"
    ,"Disable Win10 Auto Update": "禁止Win10自动更新"
    ,"Auto Disable sux In Full Screen": "全屏下自动禁用sux"
    ,"Window Mover is useful for multi monitor users, `nit will automatically move the new window to the monitor where the mouse is": "窗口移动器对多显示器用户很有用, `n它将会自动移动新窗口到鼠标所在的显示器"
    ,"Window Mover": "窗口移动器"
    ,"Hot Corner": "触发角"
    ,"Feature Switch": "功能开关"
    ,"Theme": "主题"
    ,"About": "关于"
    ,"Help": "帮助"
    ,"Check Update": "检查更新"
    ,"A New Version v": "有新版本 v"
    ,"Start With Windows": "开机启动"
    ,"Check Updates On Startup": "启动时检查更新"
    ,"Set the current window to always on top": "设置当前窗口永久置顶"
    ,"Set the current window to not always on top": "设置当前窗口不要永久置顶"
    ,"Swap Win/Ctrl Shift/Alt (beta)": "交换 Win/Ctrl Shift/Alt (beta)"
    ,"Language": "语言"
    ,"Open sux Folder": "打开sux文件夹"
    ,"Edit Config File": "编辑配置文件"
    ,"Disable": "禁用"
    ,"Restart sux": "重启sux"
    ,"Exit": "退出"
    ,"Translate Text": "翻译"
    ,"Home Page": "主页"
    ,"Selected": "当前选中"
    ,"Copied": "当前复制"
    ,"Please Select text and try again": "请选中文本后重试"
    ,"No preset replacement words found": "没有找到预设的可替换的词句"
    ,"Nothing snipped": "没有截任何图"
    ,"Suspend": "悬浮"
    ,"Screen Shot && Suspend": "截图 && 贴图"
    ,"Screen Shot": "截图"
    ,"Suspend Screenshot": "贴图"
    ,"Paste All": "粘贴所有"
    ,"Delete All": "删除所有"
    ,"Can not separate words": "无法分割单词"
    ,"Transform Text": "文本变换"
    ,"Replace Text": "文本替换"
    ,"Clipboard Plus": "历史剪切板"
    ,"Lowercase": "小写"
    ,"Uppercase": "大写"
    ,"Command": "指令"
    ,"Default": "默认"
    ,"Google & Baidu": "谷歌 & 百度" 
    ,"Google": "谷歌"
    ,"Baidu": "百度"
    ,"Bing": "必应"
    ,"Google Translate": "谷歌翻译"
    ,"Youdao": "有道"
    ,"Bilibili": "哔哩哔哩"
    ,"Jingdong": "京东"
    ,"Zhihu": "知乎"
    ,"Douban": "豆瓣"
    ,"Youku": "优酷"
    ,"Alipay": "支付宝"
    ,"Wechat": "微信"
    ,"New Release": "新版本"
    ,"What's new?": "新版特性:"
    ,"Download Page": "下载页"
    ,"Open GitHub to light up the little star!": "去GitHub点亮小星星!"
    ,"Open Zhihu to like sux!": "去知乎点赞!"
    ,"[text] ": "[文本] "
    ,"[img] ": "[图片] "
	,"[file] ": "[文件] "
	,"[files] ": "[多文件] "
	,"[folder] ": "[文件夹] "
	,"Click to go to the original page": "点击前往原网页"
	,"Open link in browser": "在浏览器中打开链接"
	,"Related webpages": "相关网页"
    ,"please install Everything and set its path in conf.user.json": "请安装Everything并在conf.user.json里配置它的路径"
    ,"Welcome to sux, `nsux is an efficiency improvement tool that also has the following functions: `n`n- translate`n- history clipboard`n- screenshots`n- stickers`n- quick search similar to Listary / Alfred / Wox `n- MacOS-like firing angle`n- Screen edge trigger`n- Global custom shortcut keys for various operations`n- Text replacer`n- Text converter`n- Custom theme`n- Shortcut instructions `n- Customizable json configuration `n- ...`n": "欢迎使用 sux ,`nsux 是一款效率提升工具同时拥有以下功能 :`n`n- 翻译`n- 历史剪切板`n- 截图`n- 贴图`n- 类似 Listary / Alfred / Wox 的快捷搜索`n- 类似 MacOS 的触发角`n- 屏幕边缘触发器`n- 全局自定义快捷键实现各种操作`n- 文本替换器`n- 文本变换器`n- 自定义主题`n- 快捷指令`n- 可自定义的 json 配置`n- ...`n"
    ,"Try it: Move the mouse to the top half of the left edge of the screen and scroll the wheel, `n`n Effect: adjust the volume quickly": "尝试一下: 将鼠标移到屏幕左边缘上半部分并滚动滚轮,  `n效果：快速调节音量"
    ,"Try it: press shift + space, and then press the shortcut key of any menu option, such as pressing the y key, `n`n Effect: open the shortcut menu, and then use Bing search": "尝试一下：按下 shift + 空格 , 然后按下任何菜单选项的快捷键, 比如按下 y 键,  `n效果：打开快捷菜单, 然后使用必应搜索"
    ,"Try it: right-click on the sux icon in the tray, you can `n `n- check for updates`n- donate`n- change theme`n- change language`n- let sux start on boot`n- open configuration file`n- open Various function switches, such as trigger angle/window mover, etc. `n- ...": "尝试一下: 右击托盘的 sux 图标，你可以`n `n- 检查更新 `n- 捐赠 `n- 更换主题 `n- 更换语言 `n- 让 sux 开机启动 `n- 打开配置文件 `n- 打开各种功能开关, 如 触发角 / 窗口移动器 等 `n- ..."
    ,"Try it: Locate files and folders by name.": "尝试一下: 按名称查找文件和文件夹."
    ,"Open Everything conf help page now, then you can follow the tutorial": "现在打开Everything工具栏的帮助页, 然后你可以按照教程操作"
    ,"Feedback": "反馈"}


global LIMIT_MODE := 0

global fake_lb_down := 0

global CornerEdgeOffset := 8  ; adjust tolerance value (pixels to corner) if desired	

global tick_detect_interval := 88

; ; millisecond, the smaller the value, the faster you have to double-click
global keyboard_double_click_timeout := 222
global keyboard_triple_click_timeout := 333
global auto_destory_quick_entry_gui_period := -28222  ; millisecond

global clipboard_old := ""
global auto_restore_the_original_clipboard_period := -88  ; millisecond

global tick_disable_win10_auto_interval := 66666

global SEARCH_PLUS_SHORTCUT_KEY_INDEX_ARR := [" ", "`t", "q", "w", "e", "r", "t", "a", "s", "d", "f", "z", "x", "b", "y", "u", "i", "o", "p", "h", "k", "j", "l", "n", "m"]
global SHORTCUT_KEY_INDEX_ARR := [" ", "`t", "q", "w", "e", "r", "t", "a", "s", "d", "f", "z", "x", "b", "y", "u", "i", "o", "p", "h", "k", "j", "l", "n", "m"]
; global SEARCH_PLUS_SHORTCUT_KEY_INDEX_ARR := [" ", "a", "s", "d", "z", "x", "q", "w", "", "b", "l", "t", "h", "j", "k", "u", "i", "o", "p", "n", "m"]
global CLIPBOARD_PLUS_SHORTCUT_KEY_INDEX_ARR := ["a", " ", "`t", "q", "w", "e", "r", "s", "f", "z", "x", "c", "g", "b", "t"]
global SHORTCUT_KEY_INDEX_ARR_LEFT := ["q", "w", "e", "r", "a", "s", "d", "f", "z", "x", "c", "v", "b", "g", "t"]
global SHORTCUT_KEY_INDEX_ARR_LEFT_HAS_SPACE_TAB := [" ", "`t", "q", "w", "r", "e", "a", "s", "d", "f", "z", "x", "c", "v", "b", "g", "t"]
global TRANSFORM_TEXT_SHORTCUT_KEY_INDEX_ARR := [" ", "`t", "|", "q", "w", "|", "e", "r", "a", "s", "|", "d", "f", "z", "x", "|", "c", "v", "b", "g", "t", "j", "k", "l"]
global SHORTCUT_KEY_INDEX_ARR_RIGHT := ["h", "j", "k", "l", "y", "u", "i", "o", "p", "n", "m"]

global INI_SET_CHECK_UPDATES_ON_STARTUP_SWITCH := "check-updates-on-startup-switch"
global INI_WINDOW_MOVER_SWITCH := "window-mover-switch"
global INI_DISABLE_WIN10_AUTO_UPDATE_SWITCH := "disable-win10-auto-update-switch"
global INI_SWAP_WIN_CTRL_SHIFT_ALT := "swap-win-ctrl-shift-alt"
global INI_LIMIT_MODE_IN_FULL_SCREEN := "limit-mode-in-full-screen"
global INI_HOT_CORNER := "hot-corner"
global INI_AUTORUN := "autorun"
global INI_THEME := "theme"
global INI_LANG := "lang"


global TRANSFORM_TEXT_MAP := {1: "Uppercase"
    , 2: "Lowercase"
    , 3: "|"
    , 4: "AbCd"
    , 5: "abCd"
    , 6: "|"
    , 7: "AB_CB"
    , 8: "ab_cd"
    , 9: "Ab_Cd"
    , 10: "ab_Cd"
    , 11: "|"
    , 12: "AB-CD"
    , 13: "ab-cd"
    , 14: "Ab-Cd"
    , 15: "ab-Cd"
    , 16: "|"
    , 17: "AB CB"
    , 18: "ab cd"
    , 19: "Ab Cd"}


OnClipboardChangeCmd := {}

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

