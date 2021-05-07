![sux](app_data/img/sux.svg)

An alternative to **Alfred**/**Wox**/**Listary**/**Capslock+**/**OneQuick** .

Inspired by Alfred/Wox/Listary/Capslock+/utools/OneQuick, thank u.

[![](https://github.com/no5ix/no5ix.github.io/blob/source/source/app_data/sux/web_search.gif)](https://hulinhong.com/2020/01/09/sux_readme/)
click img to see full video


# IMPORTANT
  
- Please run as administrator.


# Features

* **personalized configuration** : u can modify `conf.user.yaml` to override all default configuration
* **hot edges** : `Ctrl+8` on the edge (useful for touchpad user, set 3 fingers click to `Ctrl+8`), see `hot-corner`-`hot-edge`
* **hot corners** : just like mac hot cornes, see `hot-corner`-`hot-corner`
* **web search** : just like Wox/Listary/Alfred, try double click `Alt` and input sth, see `conf.user.yaml`-`search-plus`
* **enhanced capslock** : just like Capslock+, see `conf.user.yaml`-`capslock_plus`
* **work with Everything** : try double tap `Alt`, then input `ev `
* **custom theme** : two default theme(dark/light), and u can add ur own theme, see `conf.user.yaml`-`theme`
* **screen capture** : try `Capslock + Tab`
* **disable win10 auto update**: see `conf.user.yaml`-`additional-features`-`disable_win10_auto_update`
* **start sux with windows**
* **custom command line**:  see `conf.user.yaml`-`command`
* **custom hotkey**:  see `conf.user.yaml`-`hotkey`
* **clipboard-plus**:  clipboard history, try `win+alt+v`, see `conf.user.yaml`-`clipboard-plus`
<!-- * **auto selection copy** : just like linux terminal -->
<!-- * **hot key to replace string** : copy this line (`my email is @@ “”  ‘’`) to address bar, then Capslock+Shift+F, now u know, see user_conf.ahk -->
<!-- * **game mode** : double Alt then input `game` -->
<!-- * **auto update when launch sux** : see `default_conf.ahk` : `auto_update_when_launch_sux` -->


# CMDs

* `sux` : sux official site
* `cmd` : open a command prompt window on the current explorer path 
* `git` : open a git bash window on the current explorer path 
* `ev` : run Everything
<!-- * `limit` : turn on/off limit mode -->


# remarks

- see [Chinese detail](https://wyagd001.github.io/zh-cn/docs/Hotkeys.htm)
- see [English detail](https://www.autohotkey.com/docs/Hotkeys.htm)
- win: "#" 
- ctrl: "^" 
- shift: "+" 
- alt: "!"
- hover: "hover" 
- capslock: "CapsLock"
- lwin: "<#" 
- rwin: ">#"
- lctrl: "<^" 
- rctrl: ">^"
- lshift: "<+" 
- rshift: ">+"
- lalt: "<!" 
- ralt: ">!"
- lbutton:  "LButton" 
- rbutton:  "RButton" 
- mbutton: "MButton"


# hot-corner

* LeftTopCorner: 
	- hover: JumpToPrevTab
* RightTopCorner: 
	- hover: JumpToNextTab
* LeftBottomCorner: 
	- hover: 'send {LWin}'
* RightBottomCorner: 
	- hover: 'send !{Tab}'


# hot-edge:

- TopHalfLeftEdge: 
	- ctrl_8: 'C:\Program Files (x86)\Netease\CloudMusic\cloudmusic.exe'
- TopHalfRightEdge: 
	- ctrl_8: 'explorer.exe'
- BottomHalfLeftEdge:
	- ctrl_8: 'send ^+t'
- BottomHalfRightEdge: 
	- ctrl_8: 'send {F5}'
- LeftHalfBottomEdge: 
	- ctrl_8: 'send #{Tab}'
- LeftHalfTopEdge: 
	- ctrl_8: 'send #{Left}'
	- wheeldown: 'Send {volume_down}'
	- wheelup: 'Send {volume_up}'
- RightHalfTopEdge: 
	- ctrl_8: 'send #{Right}'
- RightHalfBottomEdge: 
	- ctrl_8: 'send #a'


# CapsLock+

* `CapsLock` :
    *  `Esc`
* `CapsLock` & `H` :
	* `Left`
	* with shift : `Shift`+`Left`
* `CapsLock` & `J` :
	* `Down`
	* with shift : `Shift`+`Down`
* `CapsLock` & `K` :
	* `Up`
	* with shift : `Shift`+`Up`
* `CapsLock` & `L` :
	* `Right`
	* with shift : `Shift`+`Right`
* `CapsLock` & `Tab` :
    * screen capture
	* with shift : `CapsLock`
* `CapsLock` & `V` :
    * `^`
* `CapsLock` & `F` :
	* copy current and pop out sux search window
	<!-- * with shift : `Ctrl`+`Shift`+`F` -->
* `CapsLock` & `W` :
	* `Shift`+`Ins`
* `CapsLock` & `E` :
	* Enter
	<!-- * with shift : `Ctrl`+`/` -->
<!-- * `CapsLock` & `X` :
    *  `Ctrl`+` -->
* `CapsLock` & `C` :
	* `Ctrl`+`/`
	<!-- * with shift : `$` -->
* `CapsLock` & `S` :
	<!-- * `Ctrl`+`S` -->
	<!-- * with shift : `Ctrl`+`Shift`+`S` -->
	* `$`
* `CapsLock` & `R` :
	* `Ctrl`+`Y`
	<!-- * with shift : `Ctrl`+`Y` -->
<!-- * `CapsLock` & `Tab` :
	* `Shift`+`Ins`
	* with shift : `Ins` -->
* `CapsLock` & `d` :
	* `Del`
	* with shift : `BS`
* `CapsLock` & `Y` :
	* `*`
	* with shift : `%`
* `CapsLock` & `U` :
	* `!`
	* with shift : `@`
* `CapsLock` & `,` :
	* `Home`
	* with shift : `Shift`+`Home`
* `CapsLock` & `.` :
	* `End`
	* with shift : `Shift`+`End`
* `CapsLock` & `P` :
	* `&`
	* with shift : `#`
* `CapsLock` & `I` :
	* `Ctrl`+`Left`
	* with shift : `Ctrl`+`Shift`+`Left`
* `CapsLock` & `O` :
	* `Ctrl`+`Right`
	* with shift : `Ctrl`+`Shift`+`Right`
* `CapsLock` & `;` :
	* `_`
	* with shift : `-`
* `CapsLock` & `'` :
	* `=`
	* with shift : `+`
* `CapsLock` & `/` :
	* `\`
	* with shift : `|`
* `CapsLock` & `9` :
	* `[`
	* with shift : ``
* `CapsLock` & `0` :
	* `]`
	* with shift : `}`
* `CapsLock` & `N` :
	* `Ctrl`+`Backspace`
	* with shift : `Ctrl`+`Shift`+`Backspace`
* `CapsLock` & `M` :
	* `Ctrl`+`Del`
	* with shift : `Shift`+`End`+`Del`


# 设置Everything始终以运行次数排序

0. Everything设置如下:  
    * [ ] 保存设置和数据到%APPDATA%\Everything目录  
    * [x] 随系统自启动  
    * [x] 以管理员身份运行  
    * [x] Everything服务  
1. 退出Everything
2. 找到其配置文件 Everything.ini , 并在其文件末尾添加
    ```
    sort=Run Count
    sort_ascending=0
    always_keep_sort=1
    ```
3. 运行Everything


# How to use

Just download [<i class="fa fa-download fa-2x fa-fw"></i>sux.zip](https://github.com/no5ix/sux/releases) and unzip it then run sux.exe as admin !


# 捐赠

捐赠! 让作者更有动力给sux加新功能! ^_^

- 微信
  - ![微信](/app_data/img/donate_wechat.png)
- 支付宝
  - ![支付宝](/app_data/img/donate_alipay.png)


# TODO List

<!-- - refractor HandleMouseOnEdges -->
<!-- - ini -->
<!-- - clipboard history -->
<!-- - 处理不要caps plus的逻辑 -->
<!-- - 托盘暂停 -->
<!-- - auto install ahk -->
<!-- - custom tray menu -->
<!-- - rshift issue -->
<!-- - git cmd not goto desktop -->
<!-- - check update -->
<!-- - add about sux version -->
<!-- - add donate page -->
<!-- - add icon -->
<!-- - hover tray icon display sux -->
<!-- - 短语替换 -->
<!-- - 同时搜两个 -->
<!-- - bug: 双屏tophalfleft -->
<!-- - caps + alt -->
<!-- - add ver to code -->
<!-- - limit mode notify in full screen app -->
<!-- - hot corner bug -->
<!-- - rshift bug -->
<!-- - theme dark/light tray menu -->
<!-- - search/replace conf key modify -->
<!-- - 最小化 -->
<!-- - TEST double rshift/single rshift exist together -->
<!-- - 点击了菜单之后双击alt没反应, 还得点击一下其他地方才有反应 -->
<!-- - 暗模式的其他gui的阴影不正常 -->
<!-- - add donate gui pic -->
<!-- - caps+f一键搜索并弹出菜单可选yd/gg等 -->
- add more action
- trans gui change color to gray/ dpi
<!-- - 中文翻译 -->
<!-- - 弄个clip guard对象, 来处理 Send, {Blind}{Text}慢的问题 -->
<!-- - 即时光标在单词中间也能复制此单词的快捷键 -->
<!-- - unify all menu -->
<!-- - after copy from clip_plus mess up the order -->
<!-- - 支持command菜单 -->
<!-- - 支持url直接书写 -->
<!-- - 支持不输入任何东西则为官网 -->
<!-- - 截图贴图menu -->
<!-- - check update失败, 点击"取消"打开浏览器的时候有乱切换软件的bug -->
<!-- - 限制menu宽度 -->
<!-- - 看看caps+的词语替换如何做的 -->
<!-- - 改default的上下左右快捷键 -->
<!-- - 看怎么调用js -->
<!-- - suspend img -->
<!-- - 弄个有道翻译面板 -->
- smart selection 双引号, 括号内, 单引号内
<!-- - fix check update -->
<!-- - click down 之后记得释放 -->
<!-- - 浏览器中, click down之后双击就没选中了 -->
<!-- - rshift双击和单击可以分开conf -->
- add newbie tutorial
<!-- - hot corner/edge/capslock switcher to tray menu -->
- update chinese readme, add some gif/mp4
- auto update
<!-- - fix bug: cant open conf.user.yaml with notepad -->
<!-- - refactor tray menu code -->
<!-- - fix lang logic: "Autorun" -> "Start with Windows" -->
<!-- - modify default conf: disable win auto update -->
<!-- - hot corner: check on same monitor  -->
<!-- - occasional: fix web search gui window lost caret - make caret center -->
- 失焦则销毁
<!-- - 第二个屏幕就显示sux在第二个屏幕上 -->
<!-- - fix default lang -->

<!-- - 增加可供用户扩展的脚本, 方便用户配置各种自定义action -->
<!-- - gitignore user conf -->
<!-- - start with win -->
- ext ahk
<!-- - auto compile -->
<!-- - fix 启动之后马上打开自动消失web-search窗口的bug: 已经找到, 是因为UpdateSuxImpl的锅 -->
<!-- - internal Everything -->


<!-- # 设置开机以管理员权限启动

1. 对“A.exe”创建快捷方式, 然后将这个快捷方式改名为“A” (不用改名为A.lnk, 因为windows的快捷方式默认扩展名就是lnk)
2. 右键这个快捷方式-> 高级，勾选用管理员身份运行； 
3. 新建“A.bat”文件，将这个快捷方式的路径信息写入并保存，如：
```
@echo off
start C:\Users\b\Desktop\A.lnk
```
4. 因为直接运行 A.bat 会有个窗口一闪而过, 所以新建个 A.vbs 来运行这个bat来避免这个窗口
```
createobject("wscript.shell").run "D:\A.bat",0
```
5. 打开“运行”输入“shell:startup”然后回车，然后将“A.vbs”剪切到打开的目录中 -->
