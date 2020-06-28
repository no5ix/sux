; ; Note: Save with encoding UTF-8 with BOM if possible.
; ; Notepad will save UTF-8 files with BOM automatically (even though it does not say so).
; ; Some editors however save without BOM, and then special characters look messed up in the AHK GUI.

full_command_line := DllCall("GetCommandLine", "str")
if not (A_IsAdmin or RegExMatch(full_command_line, " /restart(?!\S)"))
{
    try
    {
        if A_IsCompiled
            Run *RunAs "%A_ScriptFullPath%" /restart
        else
            Run *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%"
    }
    ExitApp
}


monitor_xy_conf_file := A_ScriptDir "\conf\monitor_xy_conf.ahk"
if !FileExist(monitor_xy_conf_file) {
	FileAppend, 
	(
	;; This file is generated, please do not modify
	), %monitor_xy_conf_file%
}


SetTimer, IncludeUserConfIFExist, 66


if enable_hot_corners {
    SysGet, monitor_cnt, MonitorCount
    if (monitor_cnt > 2) {
		msg_str := "You have more than 2 monitors, hot corners will not perform exactly at none primary monitor, so we disable it."
		MsgBox,,, %msg_str%        
    }
    else {
	    #IncludeAgain *i %A_ScriptDir%\conf\monitor_xy_conf.ahk
        if (monitor_cnt == 2 and second_monitor_min_x == 0) {
            msg_str := "You have 2 monitors, if they have two different resolution,"
                . " you can use cmd 'xy' to set the 2th monitor resolustion config. `n`n"
                . " Would you like to set it later(Yes) or now(No)?"
            MsgBox, 4,, %msg_str%   
            IfMsgBox No
                Set2thMonitorXY()
        }
    	SetTimer, HotCorners, 66
    }
}


if auto_limit_mode_when_full_screen
	SetTimer, LimitModeWhenFullScreen, 888


if disable_win10_auto_update
    SetTimer, DisableWin10AutoUpdate, 66666

