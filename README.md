An alternative to **Alfred**/**Wox**/**Listary**/**Capslock+** .

Inspired by Alfred/Wox/Listary/Capslock+/utools, thank u.


# IMPORTANT
  
- Please run as administrator.
- Please run in 32-bit mode (Open with AutoHotKey Unicode 32-bit).


# Features

* **personalized configuration** : u can modify user_conf.ahk to override the default configuration
* **hot edges** : right/middle mouse click or `Ctrl+8` on the edge (useful for touchpad user)
* **hot corners** : just like mac hot cornes
* **web search** : just like Wox/Listary/Alfred, see `default_conf.ahk` `WebSearchUrlMap`
* **enhanced capslock** : just like Capslock+, see `capslock_plus.ahk`
* **work with Everything** : Everything-Options-General-Keyboard-Show Window Hotkey: see `default_conf.ahk` : `CustomCommandLineMap["ev"]`
* **double click triggers** (include `Alt`/`Ctrl`) : try double click `Alt` to open web search window. see `default_conf.ahk` : `DoubleClickAltTriggerFunc` & `DoubleClickCtrlTriggerFunc`
* **custom theme** : two default theme(dark/light), and u can add ur own theme
* **screen capture** : try `Capslock + Tab`
* **disable win10 auto update**: see `default_conf.ahk` : `disable_win10_auto_update`
* **start nox with windows support**
* **auto update when launch nox support** : see `default_conf.ahk` : `auto_update_when_launch_nox`
* **custom command line map support**:  see `default_conf.ahk` : `CustomCommandLineMap`
<!-- * **auto selection copy** : just like linux terminal -->
<!-- * **hot key to replace string** : copy this line (`my email is @@ “”  ‘’`) to address bar, then Capslock+Shift+F, now u know, see user_conf.ahk -->
<!-- * **game mode** : double Alt then input `game` -->


# CMDs

* `nox` : nox official site
* `nw` : start nox with windows or not
* `ev` : run Everything
* `cmd` : open a command prompt window on the current explorer path 
* `rd` : reload this script
* `dir` : open the directory for this script
* `up` : update nox
* `wau` : turn on/off disable win10 auto update
* `xy` : set second monitor xy for detecting IsCorner()
<!-- * `conf` : Edit user_conf -->
<!-- * `limit` : turn on/off limit mode -->


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
	* copy current and pop out nox search window
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

Just download release then double click nox.exe !

或者对于高级用户, 你也可以安装好autohotkey环境, 然后直接运行nox.ahk.


# Update Log

<!-- I'm so lazy...maybe u could see [nox commits](https://github.com/no5ix/nox/commits/master) -->

## 2020.12.16

添加了二进制exe文件,ev命令现在是用CustomCommandLineMap来配置了

## 2020.10.11

* custom command line map,  see `default_conf.ahk` : `CustomCommandLineMap`

## 2020.10.10

* auto update when launch nox support, see `default_conf.ahk` : `auto_update_when_launch_nox`

## 2020.10.09

* start nox with windows support, try cmd `nw`