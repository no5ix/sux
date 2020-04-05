; ; Note: Save with encoding UTF-8 with BOM if possible.
; ; Notepad will save UTF-8 files with BOM automatically (even though it does not say so).
; ; Some editors however save without BOM, and then special characters look messed up in the AHK GUI.


#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance

SetCapsLockState, AlwaysOff
-----------------------


#Include %A_ScriptDir%\conf\default_conf.ahk

user_conf_file := A_ScriptDir "\conf\user_conf.ahk"
; if !FileExist(user_conf_file) {
; 	monitor_xy_conf_str := "修复bottom右半边不可用的问题
; 	FileAppend, %monitor_xy_conf_str%, %user_conf_file%
; }
#Include %A_ScriptDir%\conf\user_conf.ahk

monitor_xy_conf_file := A_ScriptDir "\conf\monitor_xy_conf.ahk"
if !FileExist(monitor_xy_conf_file) {
	FileAppend, 
	(
	;; This file is generated, please do not modify
	), %monitor_xy_conf_file%
}
;; The FileName parameter may optionally be preceded by *i and a single space,
;; which causes the program to ignore any failure to load the included file.
;; For example: #Include *i SpecialOptions.ahk.
;; This option should be used only when the included file's contents are not essential to the main script's operation.
#Include *i %A_ScriptDir%\conf\monitor_xy_conf.ahk


; #Include %A_ScriptDir%\conf\monitor_xy_conf.ahk

#Include %A_ScriptDir%\source\common.ahk

#Include %A_ScriptDir%\source\auto_exc.ahk
#Include %A_ScriptDir%\source\gui.ahk
#Include %A_ScriptDir%\source\capslock_plus.ahk
#Include %A_ScriptDir%\source\misc.ahk
