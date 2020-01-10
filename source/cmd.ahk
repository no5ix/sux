; ; Note: Save with encoding UTF-8 with BOM if possible.
; ; Notepad will save UTF-8 files with BOM automatically (even though it does not say so).
; ; Some editors however save without BOM, and then special characters look messed up in the AHK GUI.


if Pedersen = help ; Tooltip with list of commands
{
    GuiControl,, Pedersen, ; Clear the input box
    Gosub, gui_commandlibrary
}
else if Pedersen = os ; nox official site
{
    gui_destroy()
    run "https://github.com/no5ix/nox"
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
    ; run as nox run as
    ; run, %comspec% /c Code "%A_ScriptDir%,,hide
    ; run, cmd /c Code "%A_ScriptDir%,,hide
    script_dir = %A_ScriptDir%
    if vscode_path {
        Run_AsUser(vscode_path, script_dir)  ;; call Microsoft VS Code\Code.exe
    }else {
        Run_AsUser("code", script_dir)  ;; call Microsoft VS Code\bin\code , has a ugly cmd window
    }
}
else if Pedersen = touchpad ; switch touchpad mode
{
    use_touchpad := use_touchpad ? 0 : 1
    gui_destroy()
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
else if Pedersen = conf ; Edit user_conf
{
    gui_destroy()
    ; run, notepad.exe "%A_ScriptDir%\user_conf.ahk"
    param = %A_ScriptDir%\conf\user_conf.ahk
    Run_AsUser("notepad.exe", param)

}
; else if Pedersen = up ; update nox
; {
;     MsgBox, 4,, Would you like to update nox?
;     IfMsgBox Yes
;     {
;     	gui_destroy()
;         Gosub gui_spawn
;         UpdateNox()
;     }
; }

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