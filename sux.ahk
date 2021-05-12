; ; Note: Save with encoding UTF-8 with BOM if possible.
; ; Notepad will save UTF-8 files with BOM automatically (even though it does not say so).
; ; Some editors however save without BOM, and then special characters look messed up in the AHK GUI.


#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
; SendMode Input  ; 发现这一行会导致pycharm一直把caps弄得一直处于按住状态, 所以注释了. Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance


SetCapsLockState, AlwaysOff  ; 因为ahk语言的自身局限性, 必须得在这里加这一行, 只放在 sux_core.ahk里的话, 会有bug


-----------------------


; #Include %A_ScriptDir%\source\common_const.ahk
#Include %A_ScriptDir%\source\util.ahk
#Include %A_ScriptDir%\source\sux_core.ahk
; #Include %A_ScriptDir%\source\quick_entry.ahk
; #Include %A_ScriptDir%\source\clipboard_plus.ahk


;;;;;;;;;;;;;;;;;;;;;;;;;;;
RunAsAdmin()
SuxCore.init()