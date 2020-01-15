; ; Note: Save with encoding UTF-8 with BOM if possible.
; ; Notepad will save UTF-8 files with BOM automatically (even though it does not say so).
; ; Some editors however save without BOM, and then special characters look messed up in the AHK GUI.

trim_p := trim(Pedersen)

if trim_p = help ; Tooltip with list of commands
{
	GuiControl,, trim_p, ; Clear the input box
	Gosub, gui_commandlibrary
}
else if trim_p = os ; nox official site
{
	gui_destroy()
	run "https://github.com/no5ix/nox"
}
else if trim_p = url ; Open an URL from the clipboard (naive - will try to run whatever is in the clipboard)
{
	gui_destroy()
	run %ClipBoard%
}
else if trim_p = cmd ; open a command prompt window on the current explorer path 
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



;-------------------------------------------------------------------------------
;;; INTERACT WITH THIS AHK SCRIPT ;;;
;-------------------------------------------------------------------------------
else if trim_p = proj ; open this proj with vs code
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
else if trim_p = touchpad ; switch touchpad mode
{
	use_touchpad := use_touchpad ? 0 : 1
	gui_destroy()
}
else if trim_p = rd ; Reload this script
{
	gui_destroy() ; removes the GUI even when the reload fails
	Reload
}
else if trim_p = dir ; Open the directory for this script
{
	gui_destroy()
	Run, %A_ScriptDir%
}
; else if trim_p = conf ; Edit user_conf
; {
; 	gui_destroy()
; 	; run, notepad.exe "%A_ScriptDir%\user_conf.ahk"
; 	param = %A_ScriptDir%\conf\user_conf.ahk
; 	Run_AsUser("notepad.exe", param)
; }
; else if trim_p = up ; update nox
; {
;     MsgBox, 4,, Would you like to update nox?
;     IfMsgBox Yes
;     {
;     	gui_destroy()
;         Gosub gui_spawn
;         UpdateNox()
;     }
; }
else if trim_p = game ; turn on/off game mode
{
	msg_str := "Would you like to turn " . (game_mode ? "off" : "on") . " game mode?"
    MsgBox, 4,, %msg_str%
    IfMsgBox Yes
    {
		gui_destroy()
		game_mode := game_mode ? 0 : 1
		if game_mode
			MsgBox, Double Alt is disabled in game mode`, you can CapsLock+Shift+X to open nox input box.
    }
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
		if trim_p = %key%
		{
			gui_search_title := arr[1]
			gui_search(arr[2])
			Break
		}
	}
}