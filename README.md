
An alternative to **Alfred**/**Wox**/**Listary**/**Capslock+** .

IMPORTANT : Please run as administrator.

Inspired by Alfred/Wox/Listary/Public-AutoHotKey-Scripts/Capslock+/utools, thank u.


# Features

- **personalized configuration** : u can modify user_conf.ahk to override the default configuration
- **hot edges** : right/middle mouse click or `Ctrl+8` on the edge (useful for touchpad user)
- **hot corners** : just like mac hot cornes
- **web search** : just like Wox/Listary/Alfred
- **enhanced capslock** : just like Capslock+
- **double click triggers** (include `Ctrl+8`/`right mouse`/`middle mouse`/`Capslock`/`Ctrl`/`Shift`) : see default_conf.ahk
- **auto selection copy** : just like linux terminal
- **custom theme.** : two default theme(dark/light), and u can add ur own theme
- **hot key to replace string** : copy this line (`my email is @@ “”  ‘’`) to address bar, then Capslock+Shift+U, now u know, see user_conf.ahk


# 设置Everything始终以运行次数排序

0. Everything设置如下:  
    [ ] 保存设置和数据到%APPDATA%\Everything目录  
    [x] 随系统自启动  
    [x] 以管理员身份运行  
    [x] Everything服务  
1. 退出Everything
2. 找到其配置文件 Everything.ini , 并在其文件末尾添加
    ```
    sort=Run Count
    sort_ascending=0
    always_keep_sort=1
    ```
3. 运行Everything
