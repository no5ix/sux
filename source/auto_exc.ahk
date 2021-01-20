; ; Note: Save with encoding UTF-8 with BOM if possible.
; ; Notepad will save UTF-8 files with BOM automatically (even though it does not say so).
; ; Some editors however save without BOM, and then special characters look messed up in the AHK GUI.


RunAsAdmin()

if IsFirstTimeRunNox() {
    HandleStartingNoxWithWindows()
    WriteMonitorConf()
}

ReloadAfterWritingUserConf()

if auto_limit_mode_when_full_screen
	SetTimer, LimitModeWhenFullScreen, 88

if disable_win10_auto_update
    SetTimer, DisableWin10AutoUpdate, 66666

if enable_hot_corners
    SetTimer, HotCorners, %hot_corners_detect_interval%

if auto_update_when_launch_nox
    UpdateNox(1)
