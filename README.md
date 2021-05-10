
<!-- [<i class="fa fa-fw fa-github fa-2x"></i>nox](https://github.com/no5ix/sux) 

An alternative to **Alfred**/**Wox**/**Listary**/**Capslock+** .

Inspired by Alfred/Wox/Listary/Capslock+/utools, thank u.

<video width="100%" controls="controls">
<source src="/img/sux/sux_intro.mp4" type="video/mp4" />
</video> -->


![sux](https://github.com/no5ix/no5ix.github.io/blob/source/source/img/sux/sux.svg)

一个工具同时拥有
- 一键翻译: `caps+g`
- 历史剪切板: `caps+v`
- 截图
- 贴图
- 类似listary/alfred/wox的快捷搜索: `caps+q`
- 类似macos的触发角
- 屏幕边缘触发器
- 类似vim的全局自定义快捷键
- 文字替换器: `caps+r`
- 自定义主题
- 可自定义的yaml配置
- blabla...

An alternative to **Alfred**/**Wox**/**Listary**/**Capslock+**/**OneQuick** .

Inspired by Alfred/Wox/Listary/Capslock+/utools/OneQuick, thank u.

<!-- [![](https://github.com/no5ix/no5ix.github.io/blob/source/source//sux/sux/web_search.gif)](https://hulinhong.com/2020/01/09/sux_readme/)
点击图片来看完整视频.click img to see full video. -->


**. . .**<!-- more -->


# 重要
  
- 请以管理员身份运行sux
- Please run sux as administrator.

Just download [<i class="fa fa-download fa-2x fa-fw"></i>sux.zip](https://github.com/no5ix/sux/releases) and unzip it then run sux.exe as admin !


# 快捷搜索search-plus



大多数时候其实都是 `caps+q`然后空格搜东西, 所有的菜单都是可以选中某段文字然后直接查询的, 右边这一排`q/w/e/r`啥的都是快捷键
![](https://github.com/no5ix/no5ix.github.io/blob/source/source/img/sux/WeChat%20Image_20210509173722.png)

为什么`caps+q`出来的不是搜索框?

原来就是那样的, 后来我给一些低端用户(运营岗这种用户)用, 发现他们记不住key.
比如百度是`bd`, 谷歌是`gg`这种对吧?
后来我就做了个这种快捷菜单, 也挺方便的吧?是支持`double alt/ctrl`啥的
但是`alt`会丢失焦点, 所以最建议的是`double ctrl/shift`.
所有的菜单都是可以选中某段文字然后直接查询的


# 类似macos的触发角hot-corner

需要按照下图去sux托盘菜单里开启触发角功能
![](https://github.com/no5ix/no5ix.github.io/blob/source/source/img/sux/WeChat%20Image_20210509191356.png)

当开启之后, 鼠标移动到屏幕左上/左下/右上右下都会触发不同的动作:
- 左上: 跳到浏览器前一个标签页
- 右上: 跳到浏览器后一个标签页
- 左下: 模拟按下`win`键
- 右下: 模拟按下`alt+tab`

这些是默认动作, 你都可以改动自定义配置`conf.user.yaml`来更改
```yaml
hot-corner: 
  action: 
    LeftTopCorner: 
      hover: JumpToPrevTab
      # MButton: 'send {volume_mute}'
    RightTopCorner: 
      hover: JumpToNextTab
    LeftBottomCorner: 
      hover: 'send {LWin}'
    RightBottomCorner: 
      hover: GotoPreApp
```


# 历史剪切板clipboard-plus

这个历史粘贴板目前是不支持图片和其他的二进制文件


# 截图和贴图

`capslock+q` 弹出菜单之后, 然后再按`tab`是截图, `s`是贴图

![](https://github.com/no5ix/no5ix.github.io/blob/source/source/img/sux/WeChat%20Image_20210509173705.png)


# 屏幕边缘触发器hot-edge

![](https://github.com/no5ix/no5ix.github.io/blob/source/source/img/sux/WeChat%20Image_20210509173727.png)

- 你把鼠标放到左边缘的上半部分, 然后滚轮, 你会发现可以调节音量
- 放到显示器上边缘, 滚轮你会发现可以
    - 回到页面顶部
    - 去页面底部
- 放到屏幕下边缘, 滚轮则可以切换桌面
- 放到屏幕左边缘, 然后按鼠标中键则可以把当前窗口移到屏幕左边
- 放到屏幕右边缘, 然后按鼠标中键则可以把当前窗口移到屏幕右边


# capslock增强器-类似vim的全局自定义快捷键capslock_plus

这个工具其实很重磅的功能是capslock_plus, 实现文本输入增强, 你可以通过 Capslock 键配合以下辅助按键实现大部分文本操作需求，不再需要在鼠标和键盘间来回切换。

![](https://github.com/no5ix/no5ix.github.io/blob/source/source/img/sux/WeChat%20Image_20210509173732.png)

可以类似vim一样的, 各种光标移动都十分方便, 比如
- `caps+e`是上
- `caps+hjkl` 也可以来上下左右的
- `+d`是下
- `+s`是左, 比如`caps+alt+s`就是往左选中哈
- `+f`是右
- `+w`是选择当前单词
- `+逗号`是光标移动到最左边
- `+句号`是光标移动到最右边
- `caps+i`就是往左跳一个单词
- `+o`就是往右跳一个单词
- `caps+alt+i`就是往左选中一个单词
- `caps+alt+o`就是往右选中一个单词
- `caps+backspace` : 删除光标所在行所有文字
- `capslock+enter` : 无论光标是否在行末都能新起一个换行而不截断原句子
- 加`alt`就是选中, 不加就是移动


# 文字替换器replace-text

`caps+r`是替换, 比如把`h/`替换为`http://`之类的, 配置可以自由定义, 已经选中文字则是只替换选中文字, 否则替换整行, 

![](https://github.com/no5ix/no5ix.github.io/blob/source/source/img/sux/WeChat%20Image_20210509173736.png)


# 自定义配置

可以在托盘菜单里找到"编辑配置文件"的菜单的, 改了配置记得重启sux哈

![](https://github.com/no5ix/no5ix.github.io/blob/source/source/img/sux/WeChat%20Image_20210509173641.png)
![](https://github.com/no5ix/no5ix.github.io/blob/source/source/img/sux/WeChat%20Image_20210509173654.png)
![](https://github.com/no5ix/no5ix.github.io/blob/source/source/img/sux/WeChat%20Image_20210509173500.png)

- see [Chinese detail](https://wyagd001.github.io/zh-cn/docs/Hotkeys.htm)
- see [English detail](https://www.autohotkey.com/docs/Hotkeys.htm)
- `win: "#" `
- `ctrl: "^" `
- `shift: "+" `
- `alt: "!"`
- `hover: "hover" `
- `capslock: "CapsLock"`
- `lwin: "<#" `
- `rwin: ">#"`
- `lctrl: "<^" `
- `rctrl: ">^"`
- `lshift: "<+" `
- `rshift: ">+"`
- `lalt: "<!" `
- `ralt: ">!"`
- `lbutton:  "LButton" `
- `rbutton:  "RButton" `
- `mbutton: "MButton"`


# CMDs

* `sux` : sux official site
* `cmd` : open a command prompt window on the current explorer path 
* `git` : open a git bash window on the current explorer path 


# Features

* **personalized configuration** : u can modify `conf.user.yaml` to override all default configuration
* **hot edges** : `Ctrl+8` on the edge (useful for touchpad user, set 3 fingers click to `Ctrl+8`), see `hot-corner`-`hot-edge`
* **hot corners** : just like mac hot cornes, see `hot-corner`-`hot-corner`
* **web search** : just like Wox/Listary/Alfred, see `conf.user.yaml`-`search-plus`
* **enhanced capslock** : just like Capslock+, see `conf.user.yaml`-`capslock_plus`
* **work with Everything**
* **custom theme** : two default theme(dark/light), and u can add ur own theme, see `conf.user.yaml`-`theme`
* **screen capture**
* **disable win10 auto update**
* **start sux with windows**
* **custom command line**:  see `conf.user.yaml`-`command`
* **custom hotkey**:  see `conf.user.yaml`-`hotkey`
* **clipboard-plus**:  clipboard history, try `capslock+v`, see `conf.user.yaml`-`clipboard-plus`
<!-- * **auto selection copy** : just like linux terminal -->
<!-- * **hot key to replace string** : copy this line (`my email is @@ “”  ‘’`) to address bar, then Capslock+Shift+F, now u know, see user_conf.ahk -->
<!-- * **game mode** : double Alt then input `game` -->
<!-- * **auto update when launch sux** : see `default_conf.ahk` : `auto_update_when_launch_sux` -->


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



# 捐赠

捐赠! 让作者更有动力给sux加新功能! ^_^

- 微信
  - ![微信](https://github.com/no5ix/no5ix.github.io/blob/source/source/img/sux/donate_wechat.png)
- 支付宝
  - ![支付宝](https://github.com/no5ix/no5ix.github.io/blob/source/source/img/sux/donate_alipay.png)


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
<!-- - 删除记录, 把多条复制记录一次性粘贴到目标窗口 -->
- smart selection 双引号, 括号内, 单引号内
- casplock + tab 2 tab
<!-- - 看还有哪些编辑器里常用的操作如转为大写这类的可以做, 做成菜单 -->
- bug: 历史剪切板有些历史的开头莫名多出一个下划线
<!-- - donate width
- Capslock + Backspace（删除光标所在行所有文字）
- Capslock + Enter（无论光标是否在行末都能新起一个换行而不截断原句子） -->
<!-- - 截图后弹出贴图菜单 -->
<!-- - bug:截图后保存则再也无法贴图 -->
- trans gui change color to gray/ dpi / voice audio / soundmark encoding
- add more action
- clip_plus support img
<!-- - 翻译如果没选, 则弹出提示没选 -->
<!-- - 弄个build看看拿得到ver么 -->
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
