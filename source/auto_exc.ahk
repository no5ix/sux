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


if enable_hot_corners {
    SysGet, monitor_cnt, MonitorCount
    if (monitor_cnt > 2) {
		msg_str := "You have more than 2 monitors, hot corners will not perform exactly at none primary monitor, so we disable it."
		MsgBox,,, %msg_str%        
    }
    else {
        if (monitor_cnt == 2) {
            msg_str := "You have 2 monitors, if they have two different resolution, please use cmd 'xy' to set the 2th monitor resolustion config. `n`n Would you like to set it now?"
            MsgBox, 4,, %msg_str%   
            IfMsgBox Yes
                Set2thMonitorXY()
        }
    	SetTimer, HotCorners, 66
    }
}


if limit_mode_when_full_screen
	SetTimer, LimitModeWhenFullScreen, 88

if disable_win10_auto_update
    SetTimer, DisableWin10AutoUpdate, 66666