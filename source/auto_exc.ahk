; ; Note: Save with encoding UTF-8 with BOM if possible.
; ; Notepad will save UTF-8 files with BOM automatically (even though it does not say so).
; ; Some editors however save without BOM, and then special characters look messed up in the AHK GUI.


RunAsAdmin()

HandleMonitorConfWhenFirstRun()

SetTimer, IncludeUserConfIFExist, 66

if auto_limit_mode_when_full_screen
	SetTimer, LimitModeWhenFullScreen, 88

if disable_win10_auto_update
    SetTimer, DisableWin10AutoUpdate, 66666

if IsFirstTimeRunNox()
    StartNoxWithWindows()

if auto_update_when_launch_nox
    UpdateNox()