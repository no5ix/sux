; ; Note: Save with encoding UTF-8 with BOM if possible.
; ; Notepad will save UTF-8 files with BOM automatically (even though it does not say so).
; ; Some editors however save without BOM, and then special characters look messed up in the AHK GUI.


if Pedersen = help ; Tooltip with list of commands
{
    GuiControl,, Pedersen, ; Clear the input box
    Gosub, gui_commandlibrary
}
else if Pedersen = url ; Open an URL from the clipboard (naive - will try to run whatever is in the clipboard)
{
    gui_destroy()
    run %ClipBoard%
}
else if Pedersen = cmd ; open a command prompt window on the current explorer path 
{
    gui_destroy()
    IfWinActive, ahk_exe explorer.exe
    {
        Send, !d
        SendRaw, cmd
        Send, {Enter}
    }
    else
    {
        run cmd.exe
    }
}
else if Pedersen = proj ; open this proj with vs code
{
    gui_destroy()
    run, %comspec% /c Code "%A_ScriptDir%,,hide
}
else if Pedersen = touchpad ; switch touchpad mode
{
    use_touchpad := use_touchpad ? 0 : 1
    gui_destroy()
}
else if Pedersen = conf ; Edit host script
{
    gui_destroy()
    run, notepad.exe "%A_ScriptDir%\default_conf.ahk"
}



;-------------------------------------------------------------------------------
;;; INTERACT WITH THIS AHK SCRIPT ;;;
;-------------------------------------------------------------------------------
else if Pedersen = rd ; Reload this script
{
    gui_destroy() ; removes the GUI even when the reload fails
    Reload
}
else if Pedersen = dir ; Open the directory for this script
{
    gui_destroy()
    Run, %A_ScriptDir%
}
else if Pedersen = theme ; switch theme
{
    dark_theme := dark_theme ? 0 : 1
    gui_destroy()
    Gosub, gui_autoexecute
    Gosub gui_spawn
}

;-------------------------------------------------------------------------------
;;; web search ;;;
;-------------------------------------------------------------------------------
else
{
    for key, arr in WebSearchUrlMap ; Enumeration is the recommended approach in most cases.
    {
        ; Using "Loop", indices must be consecutive numbers from 1 to the number
        ; of elements in the array (or they must be calculated within the loop).
        ; MsgBox % "Element number " . A_Index . " is " . Array[A_Index]
        ; Using "for", both the index (or "key") and its associated value
        ; are provided, and the index can be *any* value of your choosing.
        if Pedersen = %key%
        {
            gui_search_title := arr[1]
            gui_search(arr[2])
            Break
        }
    }
}