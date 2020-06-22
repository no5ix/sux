; ; Note: Save with encoding UTF-8 with BOM if possible.
; ; Notepad will save UTF-8 files with BOM automatically (even though it does not say so).
; ; Some editors however save without BOM, and then special characters look messed up in the AHK GUI.


#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
; SendMode Input  ; 发现这一行会导致pycharm一直把caps弄得一直处于按住状态, 所以注释了. Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance

SetCapsLockState, AlwaysOff


-----------------------


#Include %A_ScriptDir%\conf\default_conf.ahk
;;  *i ignore any failure to load the included file.
#Include *i %A_ScriptDir%\conf\user_conf.ahk


#Include %A_ScriptDir%\source\common.ahk

#Include %A_ScriptDir%\source\auto_exc.ahk
#Include %A_ScriptDir%\source\gui.ahk
#Include %A_ScriptDir%\source\capslock_plus.ahk
#Include %A_ScriptDir%\source\misc.ahk
