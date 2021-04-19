
#Include %A_ScriptDir%\source\common_const.ahk


m(str := "")
{
	if(IsObject(str)) {
		str := "[Object]`n" Yaml_dump(str)
	}
	MsgBox, , , % str
}


ToolTipWithTimer(msg, delay_for_remove=600)
{
	ToolTip, %msg%
	SetTimer, RemoveToolTip, -%delay_for_remove%
	return

	RemoveToolTip:
		ToolTip
		return
}


EditFile(filename, admin := 0)
{
	if not FileExist(filename)
	{
		m("Can't find " filename "")
		Return
	}
	cmd := "notepad " . filename
	if ((not A_IsAdmin) && admin)
	{
		Run *RunAs %cmd%
	}
	Else
	{
		Run % cmd
	}
}

; modified from jackieku's code (http://www.autohotkey.com/forum/post-310959.html#310959)
UriEncode(Uri, Enc = "UTF-8")
{
	StrPutVar(Uri, Var, Enc)
	f := A_FormatInteger
	SetFormat, IntegerFast, H
	Loop
	{
		Code := NumGet(Var, A_Index - 1, "UChar")
		If (!Code)
			Break
		If (Code >= 0x30 && Code <= 0x39 ; 0-9
			|| Code >= 0x41 && Code <= 0x5A ; A-Z
			|| Code >= 0x61 && Code <= 0x7A) ; a-z
			Res .= Chr(Code)
		Else
			Res .= "%" . SubStr(Code + 0x100, -1)
	}
	SetFormat, IntegerFast, %f%
	Return, Res
}

UriDecode(Uri, Enc = "UTF-8")
{
	Pos := 1
	Loop
	{
		Pos := RegExMatch(Uri, "i)(?:%[\da-f]{2})+", Code, Pos++)
		If (Pos = 0)
			Break
		VarSetCapacity(Var, StrLen(Code) // 3, 0)
		StringTrimLeft, Code, Code, 1
		Loop, Parse, Code, `%
			NumPut("0x" . A_LoopField, Var, A_Index - 1, "UChar")
		StringReplace, Uri, Uri, `%%Code%, % StrGet(&Var, Enc), All
	}
	Return, Uri
}

StrPutVar(Str, ByRef Var, Enc = "")
{
	Len := StrPut(Str, Enc) * (Enc = "UTF-16" || Enc = "CP1200" ? 2 : 1)
	VarSetCapacity(Var, Len, 0)
	Return, StrPut(Str, &Var, Enc)
}


ClickUpIfLbDown()
{
	if fake_lb_down
	{
		fake_lb_down = 0
		Click Up
		; ToolTipWithTimer("simulate click UP.", 1111)
	}
}


; PasteCompatibleWithAutoSelectionCopy() {
;     if (enable_auto_selection_copy)
;         Send, #v
;     else
;         Send, ^v
; }


GetCurSelectedText() {
	clipboardOld := ClipboardAll            ; backup clipboard
	Send, ^c
	Sleep, 66                             ; copy selected text to clipboard
	if (Clipboard != clipboardOld) {
		cur_selected_text := Clipboard                ; store selected text
		Clipboard := clipboardOld   ; Restore the original clipboard. Note the use of Clipboard (not ClipboardAll).
		clipboardOld := ""   ; Free the memory in case the clipboard was very large.
	}
	return cur_selected_text
}


/*! TheGood
    Checks if a window is in fullscreen mode.
    ______________________________________________________________________________________________________________
    sWinTitle       - WinTitle of the window to check. Same syntax as the WinTitle parameter of, e.g., WinExist().
    bRefreshRes     - Forces a refresh of monitor data (necessary if resolution has changed)
    Return value    o If window is fullscreen, returns the index of the monitor on which the window is fullscreen.
                    o If window is not fullscreen, returns False.
    ErrorLevel      - Sets ErrorLevel to True if no window could match sWinTitle
    
        Based on the information found at http://support.microsoft.com/kb/179363/ which discusses under what
    circumstances does a program cover the taskbar. Even if the window passed to IsFullscreen is not the
    foreground application, IsFullscreen will check if, were it the foreground, it would cover the taskbar.
*/
IsFullscreen(sWinTitle = "A", bRefreshRes = False) {
    Static
    Local iWinX, iWinY, iWinW, iWinH, iCltX, iCltY, iCltW, iCltH, iMidX, iMidY, iMonitor, c, D, iBestD
    
    ErrorLevel := False
    
    If bRefreshRes Or Not Mon0 {
        SysGet, Mon0, MonitorCount
        SysGet, iPrimaryMon, MonitorPrimary
        Loop %Mon0% { ;Loop through each monitor
            SysGet, Mon%A_Index%, Monitor, %A_Index%
            Mon%A_Index%MidX := Mon%A_Index%Left + Ceil((Mon%A_Index%Right - Mon%A_Index%Left) / 2)
            Mon%A_Index%MidY := Mon%A_Index%Top + Ceil((Mon%A_Index%Top - Mon%A_Index%Bottom) / 2)
        }
    }
    
    ;Get the active window's dimension
    hWin := WinExist(sWinTitle)
    If Not hWin {
        ErrorLevel := True
        Return False
    }
    
    ;Make sure it's not desktop
    WinGetClass, c, ahk_id %hWin%
    If (hWin = DllCall("GetDesktopWindow") Or (c = "Progman") Or (c = "WorkerW"))
        Return False
    
    ;Get the window and client area, and style
    VarSetCapacity(iWinRect, 16), VarSetCapacity(iCltRect, 16)
    DllCall("GetWindowRect", UInt, hWin, UInt, &iWinRect)
    DllCall("GetClientRect", UInt, hWin, UInt, &iCltRect)
    WinGet, iStyle, Style, ahk_id %hWin%
    
    ;Extract coords and sizes
    iWinX := NumGet(iWinRect, 0), iWinY := NumGet(iWinRect, 4)
    iWinW := NumGet(iWinRect, 8) - NumGet(iWinRect, 0) ;Bottom-right coordinates are exclusive
    iWinH := NumGet(iWinRect, 12) - NumGet(iWinRect, 4) ;Bottom-right coordinates are exclusive
    iCltX := 0, iCltY := 0 ;Client upper-left always (0,0)
    iCltW := NumGet(iCltRect, 8), iCltH := NumGet(iCltRect, 12)
    
    ;Check in which monitor it lies
    iMidX := iWinX + Ceil(iWinW / 2)
    iMidY := iWinY + Ceil(iWinH / 2)
    
	;Loop through every monitor and calculate the distance to each monitor
	iBestD := 0xFFFFFFFF
    Loop % Mon0 {
		D := Sqrt((iMidX - Mon%A_Index%MidX)**2 + (iMidY - Mon%A_Index%MidY)**2)
		If (D < iBestD) {
			iBestD := D
			iMonitor := A_Index
		}
	}
    
    ;Check if the client area covers the whole screen
    bCovers := (iCltX <= Mon%iMonitor%Left) And (iCltY <= Mon%iMonitor%Top) And (iCltW >= Mon%iMonitor%Right - Mon%iMonitor%Left) And (iCltH >= Mon%iMonitor%Bottom - Mon%iMonitor%Top)
    If bCovers
        Return True
    
    ;Check if the window area covers the whole screen and styles
    bCovers := (iWinX <= Mon%iMonitor%Left) And (iWinY <= Mon%iMonitor%Top) And (iWinW >= Mon%iMonitor%Right - Mon%iMonitor%Left) And (iWinH >= Mon%iMonitor%Bottom - Mon%iMonitor%Top)
    If bCovers { ;WS_THICKFRAME or WS_CAPTION
        bCovers := bCovers And (Not (iStyle & 0x00040000) Or Not (iStyle & 0x00C00000))
        Return bCovers ? iMonitor : False
    } Else Return False
}


MaximizeWindow(timeout=2222, exe_name="") {
	if !exe_name
	{
		Sleep, timeout
		WinGet,S,MinMax,A
		if S=0
			WinMaximize, A
	}
	else
	{
		WinWaitActive, ahk_exe %exe_name%, , %timeout%
		if ErrorLevel
			ToolTipWithTimer("WinWaitActive " . %exe_name% . " timed out.")
		else
			WinMaximize
	}
}


IsStandardRawUrl(user_input){
	http_str := "http://"
	https_str := "https://"
	return InStr(user_input, http_str) or InStr(user_input, https_str)
}


IsRawUrl(user_input){
	if Instr(user_input, " ")
		return 0
	raw_url_str_arr := ["192.168", "http://", "https://", ".com", ".net", ".cn", "www.", ".io", ".org", ".cc", ".tk", ".me", ".ru", ".xyz", ".tv"]
	Loop % raw_url_str_arr.Length()
		if InStr(user_input, raw_url_str_arr[A_Index]) {
			return 1
		}
	return 0
}

DisableWin10AutoUpdate(){
	; run, cmd /c sc delete wuauserv,,hide
	run, cmd /c sc config wuauserv start= disabled,,hide
	run, cmd /c net stop wuauserv,,hide
	run, cmd /c sc config bits start= disabled,,hide
	run, cmd /c net stop bits,,hide
	run, cmd /c sc config dosvc start= disabled,,hide
	run, cmd /c net stop dosvc,,hide
}


; Which can be used like this:
; Code: Select all - Toggle Line numbers

; MsgBox % Join("`n", "one", "two", "three") 
; substrings := ["one", "two", "three"]
; MsgBox % Join("-", substrings*)
StringJoin(sep, params*) {
    for index,param in params
        str .= sep . param
    return SubStr(str, StrLen(sep)+1)
}


IsMouseActiveWindowAtSameMonitor() {
	MouseGetPos, Mouse_x, Mouse_y 							; Function MouseGetPos retrieves the current position of the mouse cursor
	WinGetPos, cur_active_window_X, cur_active_window_Y,,, A
	; MsgBox, The Mouse_ is at %Mouse_x%`,%Mouse_y%
	; MsgBox, The active window is at %cur_active_window_X%`,%cur_active_window_Y%
	real_cur_active_window_X := cur_active_window_X + 8  ; 经测试, 实际上全屏后也总是会加8
	SysGet, mon_cnt, MonitorCount
	Loop, % mon_cnt
	{
		SysGet, Mon, Monitor, % A_Index
		if (Mouse_x >= MonLeft && Mouse_x < MonRight && real_cur_active_window_X >= MonLeft && real_cur_active_window_X < MonRight)
			return 1
	}
	return 0
}



; 万能的run 函数
; 参数可以是cmd命令，代码中的sub，function，网址，b站av号，还可以扩展
run(command, throwErr := 1)
{
	if (command.Length() == 1)
	{
		command := command[1]
	}
	
	if(IsLabel(command))
	{
		Gosub, %command%
	}
	else if (IsFunc(command))
	{
		Array := StrSplit(command, ".")
		If (Array.MaxIndex() >= 2)
		{
			cls := Array[1]
			cls := %cls%
			Loop, % Array.MaxIndex() - 2
			{
				cls := cls[Array[A_Index+1]]
			}
			return cls[Array[Array.MaxIndex()]]()
		}
		Else
		{
			return %command%()
		}
	}
	Else
	{
		if(RegExMatch(command, "^https?://"))
		{
			brw := NoxCore.Browser
			if(brw=""||brw="default")
				run, %command%
			Else if(brw == "microsoft-edge:")
				run, %brw%%command%
			Else
				run, %brw% %command%
			Return
		}
		else if(RegExMatch(command, "i)av(\d+)", avn))
		{
			run("http://www.bilibili.com/video/av" avn1)
			return
		}
		else if(RegExMatch(command, "i)send (.*)", sd))
		{
			send, % sd1
			return
		}
		else if(RegExMatch(command, "i)m:(.*)", msg))
		{
			m(msg1)
			return
		}
		else if(RegExMatch(command, "i)edit:\s*(.*)", f))
		{
			NoxCore.Edit(f1)
			return
		}
		Try
		{
			if (command.Length() > 1) {
				Run_AsUser(command*)
			}
			else {
				run %command%
			}
			; m(command)
			; run %command%
			Return
		}
		Catch
		{
			; Try
			; {
			; 	m(command)
			; 	Run_AsUser(command*)
			; }
			; Catch
			; {
				if(IsFunc("run_user"))
				{
					func_name = run_user
					%func_name%(command)
				}
				else if (throwErr == 1)
					MsgBox, 0x30, % NoxCore.ProgramName, % "Can't run command """ command """"
			; }
		}
	}
}


RunArr(arr)
{
	Loop, % arr.MaxIndex()
	{
		run(arr[A_Index])
	}
}


Run_AsUser(prms*) {
    ComObjCreate("Shell.Application")
    .Windows.FindWindowSW(0, 0, 0x08, 0, 0x01)  
    .Document.Application.ShellExecute(prms*) 
}


; run multiple commands in one go and retrieve their output, but cannot hide window
; for example: 
; 	MsgBox % RunWaitMany("
; 	(
; 	echo Put your commands here,
; 	echo each one will be run,
; 	echo and you'll get the output.
; 	)")
RunWaitMany(commands) {
    shell := ComObjCreate("WScript.Shell")
    ; Open cmd.exe with echoing of commands disabled
    exec := shell.Exec(ComSpec " /Q /K echo off")
    ; Send the commands to execute, separated by newline
    exec.StdIn.WriteLine(commands "`nexit")  ; Always exit at the end!
    ; Read and return the output of all commands
    return exec.StdOut.ReadAll()
}


; ; run single command and retrieve their output
RunWaitOne(command, hide_window) {
	; Get a temporary file path
	tempFile := A_Temp "\" DllCall("GetCurrentProcessId") "_nox_temp.txt"                           ; "
	; Run the console program hidden, redirecting its output to
	; the temp. file (with a program other than powershell.exe or cmd.exe,
	; prepend %ComSpec% /c; use 2> to redirect error output), and wait for it to exit.
	if hide_window
		RunWait, cmd.exe /c %command% > %tempFile%,, hide
	else
		RunWait, cmd.exe /c %command% > %tempFile%
	; Read the temp file into a variable and then delete it.
	FileRead, content, %tempFile%
	FileDelete, %tempFile%
	return content
}


get_border_code(X := "", Y := "", cornerPix = "")
{
	if (X = "") or (Y = "")
	{
		MouseGetPos, X, Y
	}
	if(cornerPix = "")
	{
		cornerPix := CornerEdgeOffset
	}
	; Multi Monitor Support
	SysGet, mon_cnt, MonitorCount
	Loop, % mon_cnt
	{
		SysGet, Mon, Monitor, % A_Index
	; m(MonLeft)
	; m(MonLeft)
	; m(MonTop)
	; m(MonBottom)
	; ToolTipWithTimer(MonTop)
		cur_mon_width := MonRight - MonLeft
		cur_mon_height := MonBottom - MonTop
		if(X>=MonLeft && Y>= MonTop && X<MonRight && Y<MonBottom)
		{
			str =
			if ( X < MonLeft + cornerPix ){
				if (Y < cur_mon_height / 2)
					str .= "LeftHalfTopEdge"
				else
					str .= "LeftHalfBottomEdge"
			}
			else if ( X >= MonRight - cornerPix) {
				; str .= "RightEdge"
				if (Y < cur_mon_height / 2)
					str .= "RightHalfTopEdge"
				else
					str .= "RightHalfBottomEdge"
			}
			if ( Y < MonTop + cornerPix ) {
				if (str == "") {
					if (X < cur_mon_width / 2)
						str .= "TopHalfLeftEdge"
					else
						str .= "TopHalfRightEdge"
				}
					; str .= "TopEdge"
				else {
					str := StrSplit(str, "Half")[1]
					str .= "TopCorner"
				}
				; str .= (str == "") ? "TopEdge" : "TopCorner"
			}
			else if ( Y >= MonBottom - cornerPix) {
				if (str == "") {
					if (X < cur_mon_width / 2)
						str .= "BottomHalfLeftEdge"
					else
						str .= "BottomHalfRightEdge"
				}
					; str .= "BottomEdge"
				else {
					str := StrSplit(str, "Half")[1]
					str .= "BottomCorner"
				}
				; str .= (str == "") ? "BottomEdge" : "BottomCorner"
			}
			return % str
		}
	}
	return ""
}



RunAsAdmin() {
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
}



; LimitModeWhenFullScreen() {
; 	limit_mode := IsFullscreen() ? 1 : 0
; 	if (old_limit_mode = 0 and limit_mode = 1) or (old_limit_mode = 1 and limit_mode = 0)
; 	{
; 		ToolTipWithTimer("limit mode is " . (limit_mode ? "on. NOTICE: corner triggers is disabled." : "off"), 1111)
; 		old_limit_mode := limit_mode
; 	}
; }

; UpdateNoxImpl(from_launch) {
; 	; ToolTipWithTimer("nox background updating, please wait...", 2222)
; 	; RunWait, cmd.exe /c git pull origin master,,hide
; 	run_result := RunWaitOne("git pull origin master", from_launch)
; 	; if (InStr(run_result, "Already up to date")) {
; 	if (RegExMatch(run_result, "Already.*up.*to.*date")) {
; 		if from_launch
; 			return
; 		MsgBox,,, nox is already up to date. , 6
; 	}
; 	else if (!run_result || Instr(run_result, "FATAL:") || Instr(run_result, "fatal:") || Instr(run_result, "error:")){
; 		msg_str := "nox update failed, " . (run_result ? "this is the error log: " . run_result : "please `git pull` to check.")
; 		MsgBox,,, %msg_str%
; 	}
; 	else {
; 		; MsgBox,,, nox update finished. , 6
; 		msg_str := "nox update finished, would you like to see update log?"
; 		MsgBox, 4,, %msg_str%, 6
; 		IfMsgBox Yes
; 			Run	"https://github.com/no5ix/nox#update-log"
; 		Reload
; 	}
; }


class xArray
{
	; xArray.merge
	merge(arr1, arr2)
	{
		Loop, % arr2.MaxIndex()
		{
			arr1.Insert(arr2[A_Index])
		}
		return % arr1
	}
	; xArray.remove
	remove(arr, value)
	{
		Loop, % arr.MaxIndex()
		{
			if(arr[A_Index]=value) {
				arr.RemoveAt(A_Index)
				return % xArray.remove(arr, value)
			}
		}
		return % arr
	}
}


class Regedit
{
	static Subkey_Autorun := "Software\Microsoft\Windows\CurrentVersion\Run"
	; Regedit.Autorun
	Autorun(switch, name, path="")
	{
		if(switch)
		{
			RegWrite, REG_SZ, HKCU, % Regedit.Subkey_Autorun, % name, % path
		}
		Else
		{
			RegDelete, HKCU, % Regedit.Subkey_Autorun, % name
		}
	}
	; Regedit.IsAutorun
	IsAutorun(name, path)
	{
		RegRead, output, HKCU, % Regedit.Subkey_Autorun, % name
		return % output==path
	}
}