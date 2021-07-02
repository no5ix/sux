

#Include %A_ScriptDir%\source\common_const.ahk
#Include %A_ScriptDir%\source\js_eval.ahk



m(str := "")
{
    ; if(IsObject(str)) {
    ;     str := "[Object]`n" Yaml_dump(str)
    ; }
    MsgBox, , , % str
}


ToolTipWithTimer(msg, delay_for_remove=1111)
{
    ToolTip, %msg%
    SetTimer, RemoveToolTip, -%delay_for_remove%
    return

    RemoveToolTip:
        ToolTip
        return
}


get_menu_shortcut_str(shortcut_key_index_arr, index, text_str)
{
    _cur_shortcut_str := shortcut_key_index_arr[A_Index]
    if (_cur_shortcut_str == " ") {
        ;; 如果快捷键为空格的话, 得特殊处理
        ; _cur_shortcut_str := _cur_shortcut_str == " " ? _cur_shortcut_str . "(" . lang("space") . ")" : _cur_shortcut_str
        ; if (dot_space_str)
        ; 	; menu_shortcut_str := "& (" . lang("space") . ")" . dot_space_str . StrReplace(text_str, "&", "&&")
        ; 	menu_shortcut_str := StrReplace(text_str, "&", "&&") . " & (" . lang("space") . ")"
        ; else
            menu_shortcut_str := StrReplace(text_str, "&", "&&") . " `t& (" . lang("space") . ")"
    }
    else if (_cur_shortcut_str == "`t") {
        ;; 如果快捷键为空格的话, 得特殊处理
        ; _cur_shortcut_str := _cur_shortcut_str == " " ? _cur_shortcut_str . "(" . lang("space") . ")" : _cur_shortcut_str
        ; if (dot_space_str)
        ; 	; menu_shortcut_str := "& (" . lang("space") . ")" . dot_space_str . StrReplace(text_str, "&", "&&")
        ; 	menu_shortcut_str := StrReplace(text_str, "&", "&&") . " & (" . lang("space") . ")"
        ; else
            menu_shortcut_str := StrReplace(text_str, "&", "&&") . " `t&`t(" . lang("tab") . ")"
    }
    ; else if (_cur_shortcut_str == "q") {
    ; 	menu_shortcut_str := "&q(" . lang("quit") . ")"
    ; }
    else {
        ; if (dot_space_str)
        ; 	; menu_shortcut_str := "&" . _cur_shortcut_str . dot_space_str . StrReplace(text_str, "&", "&&")
        ; 	menu_shortcut_str := StrReplace(text_str, "&", "&&") . " &" . _cur_shortcut_str
        ; else
            menu_shortcut_str := StrReplace(text_str, "&", "&&") . " `t &" . _cur_shortcut_str
    }
    return menu_shortcut_str
}


ClickUpIfLbDown()
{
    global fake_lb_down
    if fake_lb_down
    {
        Hotkey, RButton, Off  ;; 防止wgesture这类右键手势软件失效
        fake_lb_down = 0
        Click Up
        ; ToolTipWithTimer("simulate click UP.", 1111)
    }
}


get_version_sum(version_str) {
    ver_arr := StrSplit(version_str, ".")
    ver_arr_len := ver_arr.Length()
    x_num = 1
    ver_sum = 0
    loop % ver_arr_len {
        ver_sum += ver_arr[ver_arr_len-A_Index+1] * x_num
        x_num *= 10
    }
    return ver_sum
}



DownloadFileWithProgressBar(UrlToFile, SaveFileAs, Overwrite := True, UseProgressBar := True) {
    ;Check if the file already exists and if we must not overwrite it
      If (!Overwrite && FileExist(SaveFileAs))
          Return
    ;Check if the user wants a progressbar
      If (UseProgressBar) {
          ;Initialize the WinHttpRequest Object
            WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
          ;Download the headers
            WebRequest.Open("HEAD", UrlToFile)
            WebRequest.Send()
          ;Store the header which holds the file size in a variable:
            FinalSize := WebRequest.GetResponseHeader("Content-Length")
          ;Create the progressbar and the timer
            Progress, H80, , Downloading..., %UrlToFile%
            SetTimer, __UpdateProgressBar, 100
      }
    ;Download the file
      UrlDownloadToFile, %UrlToFile%, %SaveFileAs%
    ;Remove the timer and the progressbar because the download has finished
      If (UseProgressBar) {
          Progress, Off
          SetTimer, __UpdateProgressBar, Off
      }
    Return
    
    ;The label that updates the progressbar
      __UpdateProgressBar:
          ;Get the current filesize and tick
            CurrentSize := FileOpen(SaveFileAs, "r").Length ;FileGetSize wouldn't return reliable results
            CurrentSizeTick := A_TickCount
          ;Calculate the downloadspeed
            Speed := Round((CurrentSize/1024-LastSize/1024)/((CurrentSizeTick-LastSizeTick)/1000)) . " Kb/s"
          ;Save the current filesize and tick for the next time
            LastSizeTick := CurrentSizeTick
            LastSize := FileOpen(SaveFileAs, "r").Length
          ;Calculate percent done
            PercentDone := Round(CurrentSize/FinalSize*100)
          ;Update the ProgressBar
            Progress, %PercentDone%, %PercentDone%`% Done, Downloading...  (%Speed%), Downloading %SaveFileAs% (%PercentDone%`%)
      Return
}

OpenFolderAndSelectFile(file_path_str) {
    Run %COMSPEC% /c explorer.exe /select`, "%file_path_str%",, Hide
}

OpenFolder(folder_path_str) {
    Run %COMSPEC% /c explorer.exe "%folder_path_str%",, Hide
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


; Which can be used like this:
; MsgBox % StringJoin("`n", "one", "two", "three") 
; substrings := ["one", "two", "three"]
; MsgBox % StringJoin("-", substrings*)
StringJoin(sep, params*) {
    for index,param in params
        str .= sep . param
    return SubStr(str, StrLen(sep)+1)
}


IsFileExplorerActive() {
    IfWinActive, ahk_exe explorer.exe ahk_class CabinetWClass  ; from file explorer
    {
        return 1
    }
    return 0
}

Is_Clipboard_As_File() {
    ClipSaved := ClipboardAll
    size := StrLen(ClipSaved) * (A_IsUnicode ? 2 : 1)
    if (size < 1000) {  ; 大于1000说明已经是文件而不是路径了
    	; ToolTipWithTimer(size)
        return 0
    }
    max_i := 0
	  Loop, parse, clipboard, `n, `r
    {
        max_i := A_Index
        if (!FileExist(A_LoopField)) {
            return 0
        }
    }
    if (max_i > 1 && !IsFileExplorerActive()) {
        return 0
    }
    return 1
}


enable_all_clip_change_func_impl()
{
    ClipboardChangeCmdMgr.OnClipboardChangeCmd := ClipboardChangeCmdMgr.OnClipboardChangeCmdBak
}

class ClipboardChangeCmdMgr
{
    static OnClipboardChangeCmd := []
    static OnClipboardChangeCmdBak := []

    register_clip_change_func(func_name)
    {
        this.OnClipboardChangeCmd.Push(func_name)
        this.OnClipboardChangeCmdBak.Push(func_name)
    }

    enable_all_clip_change_func()
    {
        ; If the script itself changes the clipboard, its OnClipboardChange function or label is typically not executed immediately; that is, commands immediately below the command that changed the clipboard are likely to execute beforehand. To force the function or label to execute immediately, use a short delay such as Sleep 20 after changing the clipboard.
        Sleep, 66  ; 根据上一行注释, 所以这一行 `Sleep 66` 就是让`OnClipboardChange`立即执行, 免得污染历史剪切板之类的东西
        this.OnClipboardChangeCmd := this.OnClipboardChangeCmdBak
        ; SetTimer, enable_all_clip_change_func_impl, -3333
    }

    disable_all_clip_change_func()
    {
        this.OnClipboardChangeCmd := []
    }
}


PasteContent(pending_paste_content_or_cb, args*) {
    ClipboardChangeCmdMgr.disable_all_clip_change_func()

    ClipSaved := ClipboardAll 
    if (IsFunc(pending_paste_content_or_cb)) {
        %pending_paste_content_or_cb%(args*)
        SafePaste()
    }
    else {
        Clipboard := ""
        Clipboard := pending_paste_content_or_cb
        ; m(Clipboard)
        ClipWait, 0.1
        if (!ErrorLevel) {
            SafePaste()
        }
    }
    Clipboard := ClipSaved   ; Restore the original clipboard-plus. Note the use of Clipboard (not ClipboardAll).
    ClipSaved := ""   ; Free the memory in case the clipboard-plus was very large.
    ClipboardChangeCmdMgr.enable_all_clip_change_func()
}

SafePaste() {
    ; Send, ^v
    Send, +{Insert}
    Sleep, 66  ;; 这个sleep是防止之后clipboard马上就被写入东西
}

GetCurSelectedText() {
    ClipboardChangeCmdMgr.disable_all_clip_change_func()

    clipboardOld := ClipboardAll            ; backup clipboard
    ; Send, ^c
    Clipboard := ""
    SendInput, ^{insert}
    ClipWait, 0.1
    ; Sleep, 66
    ; Read from the array:
    ; Loop % Array.MaxIndex()   ; More traditional approach.
    cur_selected_text := ""
    if(!ErrorLevel) {
        ; Sleep, 66                             ; copy selected text to clipboard
        cur_selected_text := Clipboard                ; store selected text
        StringRight, lastChar, cur_selected_text, 1
        if(Asc(lastChar)==10) ;如果最后一个字符是换行符，就认为是在IDE那复制了整行，不要这个结果
        {
            cur_selected_text := ""
        }
    }
    Clipboard := clipboardOld   ; Restore the original clipboard. Note the use of Clipboard (not ClipboardAll).
    clipboardOld := ""   ; Free the memory in case the clipboard was very large.
    ClipboardChangeCmdMgr.enable_all_clip_change_func()
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
    if (Instr(user_input, " "))
        return 0
    raw_url_str_arr := ["localhost:", "127.0.0.1", "192.168", "http://", "https://", ".com", ".net", ".cn", "www.", ".io", ".org", ".cc", ".tk", ".me", ".ru", ".xyz", ".tv"]
    Loop % raw_url_str_arr.Length() {
        if (InStr(user_input, raw_url_str_arr[A_Index])) {
            return 1
        }
    }
    return 0
}

EnableWin10AutoUpdate(){
    run, cmd /c sc config wuauserv start= auto,,hide
    run, cmd /c net start wuauserv,,hide
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


ActivateWindowsUnderCursor() {
    ; activate the window currently under mouse cursor
    MouseGetPos,,, curr_hwnd 
    WinActivate, ahk_id %curr_hwnd%
}

IsMouseActiveWindowAtSameMonitor(cur_active_window_X="") {
    if (cur_active_window_X == "") {
        WinGetPos, cur_active_window_X, cur_active_window_Y,,, A
    }
    MouseGetPos, Mouse_x, Mouse_y 							; Function MouseGetPos retrieves the current position of the mouse cursor
    ; m(cur_active_window_X "//" mouse_X)
    ; MsgBox, The Mouse_ is at %Mouse_x%`,%Mouse_y%
    ; MsgBox, The active window is at %cur_active_window_X%`,%cur_active_window_Y%
    real_cur_active_window_X := cur_active_window_X + 8  ; 经测试, 实际上全屏后也总是会加8
    SysGet, mon_cnt, MonitorCount
    Loop, % mon_cnt
    {
        SysGet, Mon, Monitor, % A_Index
        if (Mouse_x >= MonLeft && Mouse_x < MonRight && real_cur_active_window_X >= MonLeft && real_cur_active_window_X < MonRight) {
            ; m(1)
            return 1
        }
    }
    ; m(0)
    return 0
}

GetMouseMonitorMidX() {
        MouseGetPos, Mouse_x
        ; yScrnOffset := A_ScreenHeight / 4
        SysGet, mon_cnt, MonitorCount
        ; if (mon_cnt == 1) {
        ; 	Gui, Show, xCenter  y%yScrnOffset%, myGUI
    ;   return 
        ; }
        ; else {
            xMidScrn := 0
            last_mon_width := 0
            Loop, % mon_cnt
            {
                SysGet, Mon, Monitor, % A_Index
                _mon_width := (MonRight - MonLeft)
                xMidScrn += _mon_width
                last_mon_width := _mon_width
                if (Mouse_x >= MonLeft && Mouse_x < MonRight)
                    break
            }
            xMidScrn -= last_mon_width / 2
            ; xMidScrn -= cur_theme_info["sux_width"] / 2 
            ; Gui, Show, x%xMidScrn% y%yScrnOffset%, myGUI
        ; }
      return xMidScrn
}



; 万能的run 函数
; 参数可以是cmd命令，代码中的sub，function，网址d
run(command, args*)
{
    global LIMIT_MODE
    if (LIMIT_MODE)
        Return

    if !command
        return

      if (IsObject(command)) {  ;; 如果action是个列表的话
        RunArr(command, args*)
        Return
    }
    ; is_arr := 0  
    ; for _i, _cmd in command {
    ;     ; m(_i " // " cmd)
    ;     run(_cmd)
    ;     is_arr := 1
    ; }
    ; if (is_arr)
    ;     Return

    ClickUpIfLbDown()
    
    ; ToolTipWithTimer(command, 666)

    if(IsLabel(command)) {
        Gosub, %command%
    }
    else if (IsFunc(command)) {
        Array := StrSplit(command, ".")
        If (Array.MaxIndex() >= 2) {
            cls := Array[1]
            cls := %cls%
            Loop, % Array.MaxIndex() - 2
            {
                cls := cls[Array[A_Index+1]]
            }
            return cls[Array[Array.MaxIndex()]](args*)
        }
        Else {
            return %command%(args*)
        }
    }
    else if (Instr(command, "jsfunc_")) {
        return JsEval.eval(command . "()")
        ; res := JsEval.eval(command . "()")
        ; m(res)
    }
    Else if (IsRawUrl(command) || Instr(command, ".exe") || Instr(command, ".bat") || Instr(command, ".cmd")) {
        ; if(RegExMatch(command, "^https?://")) {
        ;     brw := SuxCore.Browser
        ;     if(brw=""||brw="default")
        ;         run, %command%
        ;     Else if(brw == "microsoft-edge:")
        ;         run, %brw%%command%
        ;     Else
        ;         run, %brw% %command%
        ;     Return
        ; }
        ; else 
        ; if(RegExMatch(command, "i)send (.*)", sd)) {
            ; send, % sd1
            ; return
        ; }
        ; else if(RegExMatch(command, "i)m:(.*)", msg)) {
        ;     m(msg1)
        ;     return
        ; }
        ; else if(RegExMatch(command, "i)edit:\s*(.*)", f)) {
        ;     SuxCore.Edit(f1)
        ;     return
        ; }
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
        Catch {
            ; Try
            ; {
            ; 	m(command)
            ; 	Run_AsUser(command*)
            ; }
            ; Catch
            ; {
                if(IsFunc("run_user")) {
                    func_name = run_user
                    return %func_name%(command)
                }
                else
                    MsgBox, 0x30,, % "Can't run command """ command """"
            ; }
        }
    }
    else {
        send, % command
    }
}


RunArr(arr, args*)
{
    for _i, _v in arr {
        run(_v, args*)
        Sleep, 66
    }
    ; Loop, % arr.MaxIndex()
    ; {
    ;     run(arr[A_Index], args*)
    ; }
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
    tempFile := A_Temp "\" DllCall("GetCurrentProcessId") "_sux_temp.txt"                           ; "
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
    ; m(mon_cnt)
    last_mon_width := 0
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
        ; m(A_Index)
        ; m(cur_mon_width)
        ; m(cur_mon_height)
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
                    if (X < last_mon_width + (cur_mon_width / 2))
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
                    if (X < last_mon_width + (cur_mon_width / 2))
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
        last_mon_width := cur_mon_width
    }
    return ""
}


; UpdateSuxWithGit(from_launch) {
; 	; ToolTipWithTimer("sux background updating, please wait...", 2222)
; 	; RunWait, cmd.exe /c git pull origin master,,hide
; 	run_result := RunWaitOne("git pull origin master", from_launch)
; 	; if (InStr(run_result, "Already up to date")) {
; 	if (RegExMatch(run_result, "Already.*up.*to.*date")) {
; 		if from_launch
; 			return
; 		MsgBox,,, sux is already up to date. , 6
; 	}
; 	else if (!run_result || Instr(run_result, "FATAL:") || Instr(run_result, "fatal:") || Instr(run_result, "error:")){
; 		msg_str := "sux update failed, " . (run_result ? "this is the error log: " . run_result : "please `git pull` to check.")
; 		MsgBox,,, %msg_str%
; 	}
; 	else {
; 		; MsgBox,,, sux update finished. , 6
; 		msg_str := "sux update finished, would you like to see update log?"
; 		MsgBox, 4,, %msg_str%, 6
; 		IfMsgBox Yes
; 			Run	"https://github.com/no5ix/sux#update-log"
; 		Reload
; 	}
; }


class EnhancedArray
{
    ; EnhancedArray.merge
    merge(arr1, arr2)
    {
        Loop, % arr2.MaxIndex()
        {
            arr1.Insert(arr2[A_Index])
        }
        return % arr1
    }
    ; EnhancedArray.remove
    remove(arr, value)
    {
        Loop, % arr.MaxIndex()
        {
            if(arr[A_Index]=value) {
                arr.RemoveAt(A_Index)
                return % EnhancedArray.remove(arr, value)
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


; obj := new ScriptingDictionary
; obj[3] := 1
; obj[2] := 2
; obj.B  := 3
; obj.b  := 4
; obj.a  := 5
; obj.A  := 6

; for k, v in obj
;    MsgBox,, , % k . ": " . v

; keys := obj.Keys
; for k, v in keys
;    MsgBox,, Keys, % v

; values := obj.Items
; for k, v in values
;    MsgBox,, Values, % v

; obj.Delete("a")
; MsgBox, % obj.HasKey("a")
; MsgBox, % obj.HasKey("A")
class ScriptingDictionary  ;; case sensitive dict (maintain key order, no key autosort)
{
   __New() {
      this._dict_ := ComObjCreate("Scripting.Dictionary")
   }
   
   __Delete() {
      this._dict_.RemoveAll()
      this.SetCapacity("_dict_", 0)
      this._dict_ := ""
   }
   
   __Set(key, value) {
      if !(key == "_dict_") {
         if !this._dict_.Exists(key)
            this._dict_.Add(key, value)
         else
            this._dict_.Item(key) := value
         Return value
      }
   }
   
   __Get(key) {
      if (key == "_dict_")
         Return
      if (key == "Keys" || key == "Items") {
         keys := this._dict_[key]
         arr := []
         Loop % this._dict_.Count
            arr.Push(keys[A_Index - 1])
         Return arr
      }
      else
         Return this._dict_.Item(key)
   }
   
   _NewEnum() {
      Return new ScriptingDictionary._CustomEnum_(this._dict_)
   }
   
   class _CustomEnum_
   {
      __New(dict) {
         this.i := -1
         this.dict := dict
         this.keys := this.dict.Keys()
         this.items := this.dict.Items()
      }
      
      Next(ByRef k, ByRef v) {
         if ( ++this.i = this.dict.Count() )
            Return false
         k := this.keys[this.i]
         v := this.items[this.i]
         Return true
      }
   }
   
   Delete(key) {
      if this._dict_.Exists(key) {
         value := this._dict_.Item(key)
         this._dict_.Remove(key)
      }
      Return value
   }
   
   HasKey(key) {
      Return !!this._dict_.Exists(key)
   }
}



; Copyright © 2013 VxE. All rights reserved.
; Uses a two-pass iterative approach to deserialize a json string
json2obj( str ) {

    quot := """" ; firmcoded specifically for readability. Hardcode for (minor) performance gain
    ws := "`t`n`r " Chr(160) ; whitespace plus NBSP. This gets trimmed from the markup
    ; obj := {} ; dummy object
    obj := new ScriptingDictionary ; dummy object
    objs := [] ; stack
    keys := [] ; stack
    isarrays := [] ; stack
    literals := [] ; queue
    y := nest := 0

; First pass swaps out literal strings so we can parse the markup easily
    StringGetPos, z, str, %quot% ; initial seek
    while !ErrorLevel
    {
        ; Look for the non-literal quote that ends this string. Encode literal backslashes as '\u005C' because the
        ; '\u..' entities are decoded last and that prevents literal backslashes from borking normal characters
        StringGetPos, x, str, %quot%,, % z + 1
        while !ErrorLevel
        {
            StringMid, key, str, z + 2, x - z - 1
            StringReplace, key, key, \\, \u005C, A
            If SubStr( key, 0 ) != "\"
                Break
            StringGetPos, x, str, %quot%,, % x + 1
        }
    ;	StringReplace, str, str, %quot%%t%%quot%, %quot% ; this might corrupt the string
        str := ( z ? SubStr( str, 1, z ) : "" ) quot SubStr( str, x + 2 ) ; this won't

    ; Decode entities
        StringReplace, key, key, \%quot%, %quot%, A
        StringReplace, key, key, \b, % Chr(08), A
        StringReplace, key, key, \t, % A_Tab, A
        StringReplace, key, key, \n, `n, A
        StringReplace, key, key, \f, % Chr(12), A
        StringReplace, key, key, \r, `r, A
        StringReplace, key, key, \/, /, A
        while y := InStr( key, "\u", 0, y + 1 )
            if ( A_IsUnicode || Abs( "0x" SubStr( key, y + 2, 4 ) ) < 0x100 )
                key := ( y = 1 ? "" : SubStr( key, 1, y - 1 ) ) Chr( "0x" SubStr( key, y + 2, 4 ) ) SubStr( key, y + 6 )

        literals.insert(key)

        StringGetPos, z, str, %quot%,, % z + 1 ; seek
    }

; Second pass parses the markup and builds the object iteratively, swapping placeholders as they are encountered
    key := isarray := 1

    ; The outer loop splits the blob into paths at markers where nest level decreases
    Loop Parse, str, % "]}"
    {
        StringReplace, str, A_LoopField, [, [], A ; mark any array open-brackets

        ; This inner loop splits the path into segments at markers that signal nest level increases
        Loop Parse, str, % "[{"
        {
            ; The first segment might contain members that belong to the previous object
            ; Otherwise, push the previous object and key to their stacks and start a new object
            if ( A_Index != 1 )
            {
                objs.insert( obj )
                isarrays.insert( isarray )
                keys.insert( key )
                ; obj := {}
                obj := new ScriptingDictionary ; dummy object
                isarray := key := Asc( A_LoopField ) = 93
            }

            ; arrrrays are made by pirates and they have index keys
            if ( isarray )
            {
                Loop Parse, A_LoopField, `,, % ws "]"
                    if ( A_LoopField != "" )
                        obj[key++] := A_LoopField = quot ? literals.remove(1) : A_LoopField
            }
            ; otherwise, parse the segment as key/value pairs
            else
            {
                Loop Parse, A_LoopField, `,
                    Loop Parse, A_LoopField, :, % ws
                        if ( A_Index = 1 )
                            key := A_LoopField = quot ? literals.remove(1) : A_LoopField
                        else if ( A_Index = 2 && A_LoopField != "" )
                            obj[key] := A_LoopField = quot ? literals.remove(1) : A_LoopField
            }
            nest += A_Index > 1
        } ; Loop Parse, str, % "[{"

        If !--nest
            Break

        ; Insert the newly closed object into the one on top of the stack, then pop the stack
        pbj := obj
        obj := objs.remove()
        obj[key := keys.remove()] := pbj
        If ( isarray := isarrays.remove() )
            key++

    } ; Loop Parse, str, % "]}"

    Return obj
} ; json2obj( str )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Version 1.0.0.17 http://www.autohotkey.com/forum/viewtopic.php?t=70559
;; Version 1.0.0.17 https://github.com/HotKeyIt/Yaml
Yaml(YamlText,IsFile=1,YamlObj=0){
  static
  static base:={Dump:"Yaml_Dump",Save:"Yaml_Save",Add:"Yaml_Add",Merge:"Yaml_Merge",__Delete:"__Delete",_Insert:"_Insert",_Remove:"_Remove",_GetCapacity:"_GetCapacity",_SetCapacity:"_SetCapacity",_GetAddress:"_GetAddress",_MaxIndex:"_MaxIndex",_MinIndex:"_MinIndex",_NewEnum:"_NewEnum",_HasKey:"_HasKey",_Clone:"_Clone",Insert:"Insert",Remove:"Remove",GetCapacity:"GetCapacity",SetCapacity:"SetCapacity",GetAddress:"GetAddress",MaxIndex:"MaxIndex",MinIndex:"MinIndex",NewEnum:"NewEnum",HasKey:"HasKey",Clone:"Clone",base:{__Call:"Yaml_Call"}}
  static BackupVars:="LVL,SEQ,KEY,SCA,TYP,VAL,CMT,LFL,CNT",IncompleteSeqMap
  local maxLVL:=0,LastContObj:=0,LastContKEY:=0,LinesAdded:=0,_LVLChanged:=0,_LVL,_SEQ,_KEY,_SCA,_TYP,_VAL,_CMT,_LFL,_CNT,_NXT,__LVL,__SEQ,__KEY,__SCA,__TYP,__VAL,__CMT,__LFL,__CNT,__NXT
  AutoTrim % ((AutoTrim:=A_AutoTrim)="On")?"Off":"Off"
  LVL0:=pYaml:=YamlObj?YamlObj:Object("base",base),__LVL:=0,__LVL0:=0
  If IsFile
    FileRead,YamlText,%YamlText%
  Loop,Parse,YamlText,`n,`r
  {
    If (!_CNT && (A_LoopField=""||RegExMatch(A_LoopField,"^\s+$"))){ ;&&__KEY=""&&__SEQ="")){
            If ((OBJ:=LVL%__LVL%[""].MaxIndex())&&IsObject(LVL%__LVL%["",OBJ])&&__SEQ){
                If (__KEY!="")
                    Yaml_Continue(LastContObj:=LVL%__LVL%["",Obj],LastContKEY:=__key,"",__SCA)
                else Yaml_Continue(LastContObj:=LVL%__LVL%[""],LastContKEY:=Obj,"",__SCA,__SEQ)
            } else If (__SEQ && OBJ){
                Yaml_Continue(LastContObj:=LVL%__LVL%[""],LastContKEY:=OBJ,"",__SCA,__SEQ)
            } else If (OBJ){
                Yaml_Continue(LastContObj:=LVL%__LVL%[""],LastContKEY:=OBJ,"",__SCA,1)
            } else if (__KEY!="")
                Yaml_Continue(LastContObj:=LVL%__LVL%,LastContKEY:=__KEY,"",__SCA)
            else LinesAdded--
            LinesAdded++
      Continue
    } else If (!_CNT && LastContObj
    && ( RegExMatch(A_LoopField,"^(---)?\s*?(-\s)?("".+""\s*:\s|'.+'\s*:\s|[^:""'\{\[]+\s*:\s)")
    || RegExMatch(A_LoopField,"^(---)|\s*(-\s)") )){
            If !__SCA
        LastContObj[LastContKEY]:=SubStr(LastContObj[LastContKEY],1,-1*LinesAdded)
      LastContObj:=0,LastContKEY:=0,LinesAdded:=0
    }
    If InStr(A_LoopField,"#"){
      If (RegexMatch(A_LoopField,"^\s*#.*") || InStr(A_LoopField,"%YAML")=1) ;Comments only, do not parse
        continue
      else if Yaml_IsQuoted(LTrim(A_LoopField,"- ")) || RegExMatch(A_LoopField,"(---)?\s*?(-\s)?("".+""\s*:\s|'.+'\s*:\s|[^:""'\{\[]+\s*:\s)\s*([\|\>][+-]?)?\s*(!!\w+\s)?\s*("".+|'.+)$")&&!RegExMatch(A_LoopField,"[^\\]""\s+#")
        LoopField:=A_LoopField
      else if RegExMatch(A_LoopField,"\s+#.*$","",RegExMatch(A_LoopField,"(---)?\s*?(-\s)?("".+""\s*:\s|'.+'\s*:\s|[^:""'\{\[]+\s*:\s)?\s*([\|\>][+-]?)?\s*(!!\w+\s)?\s*("".+""|'.+')?\K")-1)
        LoopField:=SubStr(A_LoopField,1,RegExMatch(A_LoopField,"\s+#.*$","",RegExMatch(A_LoopField,"(---)?\s*?(-\s)?("".+""\s*:\s|'.+'\s*:\s|[^:""'\{\[]+\s*:\s)?\s*([\|\>][+-]?)?\s*(!!\w+\s)?\s*("".+""|'.+')?\K")-1)-1)
      else LoopField:=A_LoopField
    } else LoopField:=A_LoopField
    If _CNT {
      If Yaml_IsSeqMap(RegExReplace(IncompleteSeqMap LoopField,"^(\s+)?(-\s)?("".+""\s*:\s|'.+'\s*:\s|[^:""'\{\[]+\s*:\s)?"))
        LoopField:=IncompleteSeqMap LoopField,_CNT:=0,IncompleteSeqMap:=""
      else {
                IncompleteSeqMap.=LoopField
                continue
            }
    }
    If (LoopField="---"){
      Loop % (maxLVL)
        LVL%A_Index%:=""
      Loop,Parse,BackupVars,`,
        __%A_LoopField%:="",__%A_LoopField%0:=""
      Loop,Parse,BackupVars,`,
        Loop % maxLVL
        __%A_LoopField%%A_Index%:=""
      maxLVL:=0
      __LVL:=0,__LVL0:=0
      If !IsObject(pYaml[""])
        pYaml[""]:=LVL0:=Object("base",base)
      pYaml[""].Insert(LVL0:=Object("base",base))
      Continue
    } else if (LoopField="..."){
      LVL0:=pYaml
      Loop % maxLVL
        LVL%A_Index%:=""
      Loop,Parse,BackupVars,`,
        __%A_LoopField%:="",__%A_LoopField%0:=""
      Loop,Parse,BackupVars,`,
        Loop % maxLVL
        __%A_LoopField%%A_Index%:=""
      maxLVL:=0
      __LVL:=0,__LVL0:=0
      Continue
    }
    If (SubStr(LoopField,0)=":")
      LoopField.=A_Space ; add space to force RegEx to match even if the value and space after collon is missing e.g. Object:`n  objects item
    RegExMatch(LoopField,"S)^(?<LVL>\s+)?(?<SEQ>-\s)?(?<KEY>"".+""\s*:\s|'.+'\s*:\s|[^:""'\{\[]+\s*:\s)?\s*(?<SCA>[\|\>][+-]?)?\s*(?<TYP>!!\w+\s)?\s*(?<VAL>"".+""|'.+'|.+)?\s*$",_)
        If _KEY ;cut off (:)
     StringTrimRight,_KEY,_KEY,2
    _KEY:=Yaml_UnQuoteIfNeed(_KEY)
    If IsVal:=Yaml_IsQuoted(_VAL)
            _VAL:=Yaml_UnQuoteIfNeed(_VAL)
    ;determine current level
    _LVL:=Yaml_S2I(_LVL)
    If _LVL-__LVL>1||(_LVL>__LVL&&_LVLChanged) ;&&!(__SEQ&&__KEY!=""&&_KEY!="")) ; (__SEQ?2:1)
    {
      Loop % (_LVLChanged?_LVL-_LVLChanged:_LVL-__LVL-1)
        LoopField:=SubStr(LoopField,SubStr(LoopField,1,1)=A_Tab?1:2)
      _LVL:=_LVLChanged?_LVLChanged:__LVL+1,_LVLChanged:=_LVLChanged?_LVLChanged:_LVL ;__LVL%_LVL%:=__LVL%_NXT% ; (__SEQ?2:1)
    } else if _LVLChanged
      _LVL:=_LVLChanged
    else _LVLChanged:=0
    If (maxLVL<_LVL)
      maxLVL:=_LVL+(_SEQ?1:0)
    ; Cut off the leading tabs/spaces conform _LVL
    SubStr:=0,Tabs:=0
    Loop,Parse,LoopField
      If (_LVL*2=SubStr || !SubStr:=SubStr+(A_LoopField=A_Tab?2:1)), Tabs:=Tabs+(A_LoopField=A_Tab?1:0)
        break
    _LFL:=SubStr(LoopField,SubStr-Tabs+1+(_SEQ?2:0))
    _LFL:=Yaml_UnQuoteIfNeed(_LFL)
    _NXT:=_LVL+1 ;next indentation level
    __NXT:=_NXT+1
    _PRV:=_LVL=0?0:_LVL-1
    Loop,Parse,BackupVars,`,
      __%A_LoopField%:=__%A_LoopField%%_PRV%
    If RegExMatch(_LFL,"^-\s*$"){
      _SEQ:="-",_KEY:="",_VAL:=""
    }
    If (!IsVal && !_CNT && (_CNT:=Yaml_Incomplete(Trim(_LFL))||Yaml_Incomplete(Trim(_VAL)))){
      IncompleteSeqMap:=LoopField
      continue
    }
    If (_LVL<__LVL){ ;Reset Objects and Backup vars
      Loop % (maxLVL)
        If (A_Index>_LVL){
          Loop,Parse,BackupVars,`,
            __%A_LoopField%%maxLVL%:=""
          LVL%A_Index%:="",maxLVL:=maxLVL-1
        }
      If (_LVL=0 && !__LVL:=__LVL0:=0)
        Loop,Parse,BackupVars,`,
          __%A_LoopField%:="",__%A_LoopField%0:=""
    }
    If (_SEQ&&_LVL>__LVL&&(__VAL!=""||__SCA))
      _SEQ:="",_KEY:="",_VAL:="",_LFL:="- " _LFL
    If (__CNT)||(_LVL>__LVL&&(__KEY!=""&&_KEY="")&&(__VAL!=""||__SCA))||(__SEQ&&__SCA)
      _KEY:="",_VAL:=""
    If (__CNT||(_LVL>__LVL&&(__KEY!=""||(__SEQ&&(__LFL||__SCA)&&!Yaml_IsSeqMap(__LFL)))&&!(_SEQ||_KEY!=""))){
            If ((OBJ:=LVL%__LVL%[""].MaxIndex())&&IsObject(LVL%__LVL%["",OBJ])&&__SEQ){
        If __KEY!=
          Yaml_Continue(LVL%__LVL%["",Obj],__key,_LFL,__SCA),__CNT:=Yaml_SeqMap(LVL%__LVL%["",OBJ],__KEY,LVL%__LVL%["",OBJ,__KEY])?"":__CNT
        else Yaml_Continue(LVL%__LVL%[""],Obj,_LFL,__SCA,__SEQ),__CNT:=Yaml_SeqMap(LVL%__LVL%[""],OBJ,LVL%__LVL%["",OBJ],__SEQ)?"":__CNT
      } else If (__SEQ && OBJ){
        Yaml_Continue(LVL%__LVL%[""],Obj,_LFL,__SCA,__SEQ)
        __CNT:=Yaml_SeqMap(LVL%__LVL%[""],OBJ,LVL%__LVL%["",OBJ],__SEQ)?"":__CNT
      } else If (OBJ && __KEY=""){
        Yaml_Continue(LVL%__LVL%[""],OBJ,_LFL,__SCA,1)
        __CNT:=Yaml_SeqMap(LVL%__LVL%[""],OBJ,LVL%__LVL%["",OBJ],1)?"":__CNT
      } else {
        Yaml_Continue(LVL%__LVL%,__KEY,_LFL,__SCA)
        __CNT:=Yaml_SeqMap(LVL%__LVL%,__KEY,LVL%__LVL%[__KEY])?"":__CNT
      }
      Continue
    }
    ;Create sequence or map
    If (__SEQ&&(_LVL>__LVL)&&_KEY!=""&&__KEY!=""){
            OBJ:=LVL%__LVL%[""].MaxIndex()
      If _SEQ {
          If !Yaml_SeqMap(LVL%_LVL%["",OBJ,__KEY,""],_KEY,_VAL){
            If !IsObject(LVL%__LVL%["",OBJ,__KEY,""])
              LVL%__LVL%["",OBJ,__KEY,""]:={base:base}
            LVL%__LVL%["",OBJ,__KEY,""].Insert({(_KEY):_VAL!=""?_VAL:(LVL%_NXT%:={base:base}),base:base})
          }
      } else If !Yaml_SeqMap(LVL%_LVL%["",OBJ],_KEY,_VAL){
        LVL%__LVL%["",OBJ,_KEY]:=_VAL!=""?_VAL:(LVL%_NXT%:={base:base})
            }
      If _VAL!=
        continue
    } else If (_SEQ){
      If !IsObject(LVL%_LVL%[""])
        LVL%_LVL%[""]:=Object("base",base)
      While (SubStr(_LFL,1,2)="- "){
        _LFL:=SubStr(_LFL,3),_KEY:=(_KEY!="")?_LFL:=SubStr(_KEY,3):_KEY,LVL%_LVL%[""].Insert(LVL%_NXT%:=Object("",Object("base",base),"base",base)),_LVL:=_LVL+1,_NXT:=_NXT+1,__NXT:=_NXT+1,_PRV:=_LVL-1,maxLVL:=(maxLVL<_LVL)?_LVL:maxLVL
        Loop,Parse,BackupVars,`,
          __%A_LoopField%:=_%A_LoopField%
          ,__%A_LoopField%%_PRV%:=_%A_LoopField%
      }
      If (_KEY="" && _VAL="" && !IsVal){
        If !Yaml_SeqMap(LVL%_LVL%[""],"",_LFL)
          LVL%_LVL%[""].Insert(LVL%_NXT%:=Object("base",base))
      } else If (_KEY!="") {
        LVL%_LVL%[""].Insert(LVL%__NXT%:=Object(_KEY,LVL%_NXT%:=Object("base",base),"base",base))
        If !Yaml_SeqMap(LVL%__NXT%,_KEY,_VAL){
          LVL%_LVL%[""].Remove()
          LVL%_LVL%[""].Insert(LVL%__NXT%:=Object(_KEY,(_VAL!=""||IsVal)?_VAL:LVL%_NXT%:=Object("base",base),"base",base))
        }
      } else {
        If !Yaml_SeqMap(LVL%_LVL%[""],"",_LFL)
          LVL%_LVL%[""].Insert(_LFL)
      }
      If !LVL%_LVL%[""].MaxIndex()
        LVL%_LVL%.Remove("")
    } else if (_KEY!=""){
      If (__SEQ && _LVL>__LVL) {
        If (OBJ:=LVL%_PRV%[""].MaxIndex())&&IsObject(LVL%_PRV%["",OBJ]){
          If !Yaml_SeqMap(LVL%_PRV%["",OBJ],_KEY,_VAL)
            LVL%_PRV%["",OBJ,_KEY]:=(_VAL!=""||IsVal)?_VAL:(LVL%_NXT%:=Object("base",base))
        } else {
          LVL%_PRV%[""].Insert(Object(_KEY,(_VAL!=""||IsVal)?_VAL:(LVL%_NXT%:=Object("base",base)),"base",base))
          Yaml_SeqMap(LVL%_PRV%["",OBJ?OBJ+1:1],_KEY,_VAL)
        }
      } else
        If !Yaml_SeqMap(LVL%_LVL%,_KEY,_VAL)
          LVL%_LVL%[_KEY]:=_VAL!=""?_VAL:(LVL%_NXT%:=Object("base",base))
    } else if (_LVL>__LVL && (__KEY!="")) {
      If (__VAL!="" || __SCA){
        Yaml_Continue(LVL%__LVL%,__KEY,_LFL,__SCA)
        Yaml_SeqMap(LVL%__LVL%,__KEY,LVL%__LVL%[__KEY])
        Continue
      } else {
        If !Yaml_SeqMap(LVL%__LVL%[__KEY],_KEY,_VAL) ;!!! no Scalar???
          LVL%__LVL%[__KEY,_KEY]:=_VAL
          Continue
      }
    } else {
      If (_LVL>__LVL&&(OBJ:=LVL%__LVL%[""].MaxIndex())&&IsObject(LVL%__LVL%["",OBJ])&&__SEQ){
        If __CNT
          Yaml_Continue(LVL%__LVL%[""],LVL%__LVL%[""].MaxIndex(),_LFL,__SCA,1)
        If (__CNT:=Yaml_SeqMap(LVL%__LVL%[""],"",_LFL)?"":1)
          LVL%__LVL%[""].Insert(_LFL) 
      } else {
        If !IsObject(LVL%_LVL%[""])
          LVL%_LVL%[""]:=Object("base",base)
        If __CNT
          Yaml_Continue(LVL%__LVL%[""],LVL%__LVL%[""].MaxIndex(),_LFL,__SCA,1)
        If (__CNT:=Yaml_SeqMap(LVL%_LVL%[""],"",_LFL)?"":1)
          LVL%_LVL%[""].Insert(_LFL)
      }
      Continue
    }
    Loop,Parse,BackupVars,`,
      __%A_LoopField%:=_%A_LoopField%
      ,__%A_LoopField%%_LVL%:=_%A_LoopField%
  }
  If (LastContObj && !__SCA)
      LastContObj[LastContKEY]:=SubStr(LastContObj[LastContKEY],1,-1*LinesAdded)
  AutoTrim %AutoTrim%
  Loop,Parse,BackupVars,`,
      If !(__%A_LoopField%:="")
        Loop % maxLVL
          __%A_LoopField%%A_Index%:=""
  Return pYaml,pYaml.base:=base
}
Yaml_Save(obj,file,level=""){
  FileMove,% file,% file ".bakupyml",1
  FileAppend,% obj.Dump(),% file
  If !ErrorLevel
    FileDelete,% file ".bakupyml"
  else {
    FileMove,% file ".bakupyml",% file
    MsgBox,0, Error creating file, old file was restored.
  }
}
Yaml_Call(NotSupported,f,p*){
  If (p.MaxIndex()>1){
    Loop % p.MaxIndex()
      If A_Index>1
        f:=f[""][p[A_Index-1]]
  }
  Return (!p.MaxIndex()?f[""].MaxIndex():f[""][p[p.MaxIndex()]])
}
Yaml_Merge(obj,merge){
  for k,v in merge
  {
    If IsObject(v){
      If obj.HasKey(k){
        If IsObject(obj[k])
          Yaml_Merge(obj[k],v)
        else obj[k]:=v
      } else obj[k]:=v
    } else obj[k]:=v
  }
}
Yaml_Add(O,Yaml="",IsFile=0){
  static base:={Dump:"Yaml_Dump",Save:"Yaml_Save",Add:"Yaml_Add",Merge:"Yaml_Merge",__Delete:"__Delete",_Insert:"_Insert",_Remove:"_Remove",_GetCapacity:"_GetCapacity",_SetCapacity:"_SetCapacity",_GetAddress:"_GetAddress",_MaxIndex:"_MaxIndex",_MinIndex:"_MinIndex",_NewEnum:"_NewEnum",_HasKey:"_HasKey",_Clone:"_Clone",Insert:"Insert",Remove:"Remove",GetCapacity:"GetCapacity",SetCapacity:"SetCapacity",GetAddress:"GetAddress",MaxIndex:"MaxIndex",MinIndex:"MinIndex",NewEnum:"NewEnum",HasKey:"HasKey",Clone:"Clone",base:{__Call:"Yaml_Call"}}
  If Yaml_IsSeqMap(Trim(Yaml)){
    If !IsObject(O[""])
      O[""]:=Object("base",base)
    Yaml_SeqMap(O[""],"",Yaml)
  } else Yaml(Yaml,IsFile,O)
}
Yaml_Dump(O,J="",R=0,Q=0){
  static M1:="{",M2:="}",S1:="[",S2:="]",N:="`n",C:=", ",S:="- ",E:="",K:=": "
  local dump:="",M,MX,F,I,key,value
  If (J=0&&!R)
    dump.= S1
  for key in O
    M:=A_Index
  If IsObject(O[""]){
    M--
    for key in O[""]
      MX:=A_Index
    If IsObject(O[""][""])
      MX--
    If O[""].MaxIndex()
      for key, value in O[""]
      {
        If key=
          continue
        I++
        F:=IsObject(value)?(IsObject(value[""])?"S":"M"):E
        If (J!=""&&J<=R){
          dump.=(F?(%F%1 Yaml_Dump(value,J,R+1,F) %F%2):Yaml_EscIfNeed(value)) (I=MX&&!M?E:C) ;(Q="S"&&I=1?S1:E)(Q="S"&&I=MX?S2:E)
        } else if F,dump:=dump N Yaml_I2S(R) S
          dump.= (J!=""&&J<=(R+1)?%F%1:E) Yaml_Dump(value,J,R+1,F) (J!=""&&J<=(R+1)?%F%2:E)
        else {
          ; If RegexMatch(value,"[\x{007F}-\x{FFFF}""\{\[']|:\s|\s#")
            dump .= Yaml_EscIfNeed(value)
          ; else {
            ; value:= (value=""?"''":RegExReplace(RegExReplace(Value,"m)^(.*[\r\n].*)$","|" (SubStr(value,-1)="`n`n"?"+":SubStr(value,0)=N?"":"-") "`n$1"),"ms)(*ANYCRLF)\R",N Yaml_I2S(R+1)))
            ; StringReplace,value,value,% N Yaml_I2S(R+1) N Yaml_I2S(R+1),% N Yaml_I2S(R+1),A
            ; dump.=value
          ; }
        }
      }
  }
  I=0
  for key, value in O
  {
    If key=
      continue
    I++
    F:=IsObject(value)?(IsObject(value[""])?"S":"M"):E
    If (J=0&&!R)
      dump.= M1
    If (J!=""&&J<=R){
      dump.=(Q="S"&&I=1?M1:E) Yaml_EscIfNeed(key) K
      dump.=F?(%F%1 Yaml_Dump(value,J,R+1,F) %F%2):Yaml_EscIfNeed(value)
      dump.=(Q="S"&&I=M?M2:E) (J!=0||R?(I=M?E:C):E)
    } else if F,dump:=dump N Yaml_I2S(R) Yaml_EscIfNeed(key) K
      dump.= (J!=""&&J<=(R+1)?%F%1:E) Yaml_Dump(value,J,R+1,F) (J!=""&&J<=(R+1)?%F%2:E)
    else {
      ; If RegexMatch(value,"[\x{007F}-\x{FFFF}""\{\['\t]|:\s|\s#")
        dump .= Yaml_EscIfNeed(value)
      ; else {
        ; value:= (value=""?"''":RegExReplace(RegExReplace(Value,"m)^(.*[\r\n].*)$","|" (SubStr(value,-1)="`n`n"?"+":SubStr(value,0)="`n"?"":"-") "`n$1"),"ms)(*ANYCRLF)\R","`n" Yaml_I2S(R+1)))
        ; StringReplace,value,value,% "`n" Yaml_I2S(R+1) "`n" Yaml_I2S(R+1),% "`n" Yaml_I2S(R+1),A
        ; dump.= value
      ; }
    }
    If (J=0&&!R){
      dump.=M2 (I<M?C:E)
    }
  }
  If (J=0&&!R)
    dump.=S2
  If (R=0)
    dump:=RegExReplace(dump,"^\R+")
  Return dump
}
Yaml_UniChar( string ) {
  static a:="`a",b:="`b",t:="`t",n:="`n",v:="`v",f:="`f",r:="`r",e:=Chr(0x1B)
  Loop,Parse,string,\
  {
    If (A_Index=1){
      var.=A_LoopField
      continue
    } else If lastempty {
      var.="\" A_LoopField
      lastempty:=0
      Continue
    } else if (A_LoopField=""){
      lastempty:=1
      Continue
    }
    If InStr("ux",SubStr(A_LoopField,1,1))
      str:=SubStr(A_LoopField,1,RegExMatch(A_LoopField,"^[ux]?([\dA-F]{4})?([\dA-F]{2})?\K")-1)
    else
      str:=SubStr(A_LoopField,1,1)
    If (str=="N")
      str:="\x85"
    else if (str=="P")
      str:="\x2029"
    else if (str=0)
      str:="\x0"
    else if (str=="L")
      str:="\x2028"
    else if (str=="_")
      str:="\xA0"
    If RegexMatch(str,"i)^[ux][\da-f]+$")
      var.=Chr(Abs("0x" SubStr(str,2)))
    else If str in a,b,t,n,v,f,r,e
      var.=%str%
    else var.=str
    If InStr("ux",SubStr(A_LoopField,1,1))
      var.=SubStr(A_LoopField,RegExMatch(A_LoopField,"^[ux]?([\dA-F]{4})?([\dA-F]{2})?\K"))
    else var.=SubStr(A_LoopField,2)
  }
  return var
}
Yaml_CharUni( string ) {
  static ascii:={"\":"\","`a": "a","`b": "b","`t": "t","`n": "n","`v": "v","`f": "f","`r": "r",Chr(0x1B): "e","""": """",Chr(0x85): "N",Chr(0x2029): "P",Chr(0x2028): "L","": "0",Chr(0xA0): "_"}
  If !RegexMatch(string,"[\x{007F}-\x{FFFF}]"){
    Loop,Parse,string
    {
      If ascii[A_LoopField]
        var.="\" ascii[A_LoopField]
      else
        var.=A_LoopField
    }
    return var
  }
  format:=A_FormatInteger
  SetFormat,Integer,H
  Loop,Parse,string
  {
    If ascii[A_LoopField]
        var.="\" ascii[A_LoopField]
    else if Asc(A_LoopField)<128
      var.=A_LoopField
    else {
      str:=SubStr(Asc(A_LoopField),3)	
      var.="\u" (StrLen(str)<2?"000":StrLen(str)<3?"00":StrLen(str)<4?"0":"") str
    }
  }
  SetFormat,Integer,%Format%
  return var
}
Yaml_EscIfNeed(s){
  If (s="")
    return "''"
  else If RegExMatch(s,"m)[\{\[""'\r\n]|:\s|,\s|\s#")||RegExMatch(s,"^[\s#\\\-:>]")||RegExMatch(s,"m)\s$")||RegExMatch(s,"m)[\x{7F}-\x{7FFFFFFF}]")
    return ("""" . Yaml_CharUni(s) . """")
  else return s
}
Yaml_IsQuoted(ByRef s){
    return InStr(".''."""".","." SubStr(Trim(s),1,1) SubStr(Trim(s),0) ".")?1:0
}
Yaml_UnQuoteIfNeed(s){
  s:=Trim(s)
  If !(SubStr(s,1,1)=""""&&SubStr(s,0)="""")
    return (SubStr(s,1,1)="'"&&SubStr(s,0)="'")?SubStr(s,2,StrLen(s)-2):s
  else return Yaml_UniChar(SubStr(s,2,StrLen(s)-2))
}
Yaml_S2I(str){
  local idx:=0
  Loop,Parse,str
    If (A_LoopField=A_Tab)
      idx++
    else if !Mod(A_index,2)
      idx++
  Return idx
}
Yaml_I2S(idx){
  Loop % idx
    str .= "  "
  Return str
}
Yaml_Continue(Obj,key,value,scalar="",isval=0){
  If !IsObject(isObj:=obj[key])
    v:=isObj
  If scalar {
    StringTrimLeft,scaopt,scalar,1
    scalar:=Asc(scalar)=124?"`n":" "
  } else scalar:=" ",scaopt:="-"
  temp := (value=""?"`n":(SubStr(v,0)="`n"&&scalar="`n"?"":(v=""?"":scalar))) value (scaopt!="-"?(v&&value=""?"`n":""):"")
  obj[key]:=Yaml_UnQuoteIfNeed(v temp)
}
Yaml_Quote(ByRef L,F,Q,B,ByRef E){
  Return (F="\"&&!E&&(E:=1))||(E&&!(E:=0)&&(L:=L ("\" F)))
}
Yaml_SeqMap(o,k,v,isVal=0){
  v:=Trim(v,A_Tab A_Space "`n"),m:=SubStr(v,1,1) SubStr(v,0)
  If Yaml_IsSeqMap(v)
    return m="[]"?Yaml_Seq(o,k,SubStr(v,2,StrLen(v)-2),isVal):m="{}"?Yaml_Map(o,k,SubStr(v,2,StrLen(v)-2),isVal):0
}
Yaml_Seq(obj,key,value,isVal=0){
  static base:={Dump:"Yaml_Dump",Save:"Yaml_Save",Add:"Yaml_Add",Merge:"Yaml_Merge",__Delete:"__Delete",_Insert:"_Insert",_Remove:"_Remove",_GetCapacity:"_GetCapacity",_SetCapacity:"_SetCapacity",_GetAddress:"_GetAddress",_MaxIndex:"_MaxIndex",_MinIndex:"_MinIndex",_NewEnum:"_NewEnum",_HasKey:"_HasKey",_Clone:"_Clone",Insert:"Insert",Remove:"Remove",GetCapacity:"GetCapacity",SetCapacity:"SetCapacity",GetAddress:"GetAddress",MaxIndex:"MaxIndex",MinIndex:"MinIndex",NewEnum:"NewEnum",HasKey:"HasKey",Clone:"Clone",base:{__Call:"Yaml_Call"}}
  ContinueNext:=0
  If (obj=""){
    If (SubStr(value,0)!="]")
      Return 0
    else
      value:=SubStr(value,2,StrLen(value)-2)
  } else {
    If (key=""){
      obj.Insert(Object("",cObj:=Object("base",base),"base",base))
    } else if (isval && IsObject(obj[key,""])){
        cObj:=obj[key,""]
    } else obj[key]:=Object("",cObj:=Object("base",base),"base",base)
  }
  Count:=StrLen(value)
  Loop,Parse,value
  {
    If ((Quote=""""&&Yaml_Quote(LF,A_LoopField,Quote,Bracket,Escape)) || (ContinueNext && !ContinueNext:=0))
      Continue
    If (Quote){
      If (A_LoopField=Quote){
        Quote=
        If Bracket
          LF.= A_LoopField
        else LF:=SubStr(LF,2)
        Continue
      }
      LF .= A_LoopField
      continue
    } else if (!Quote&&InStr("""'",A_LoopField)){
      Quote:=A_LoopField
      If !Bracket
        VQ:=Quote
      LF.=A_LoopField
      Continue
    } else if (!Quote&&Bracket){
      If (Asc(A_LoopField)=Asc(Bracket)+2)
        BCount--
      else if (A_LoopField=Bracket)
        BCount++
      If (BCount=0)
        Bracket=
      LF .= A_LoopField
      Continue
    } else if (!Quote&&!Bracket&&InStr("[{",A_LoopField)){
      Bracket:=A_LoopField
      BCount:=1
      LF.=A_LoopField
      Continue
    }
    If (A_Index=Count)
      LF .= A_LoopField
    else if (!Quote&&!Bracket&&A_LoopField=","&&(!InStr("0123456789",SubStr(value,A_Index-1,1)) | !InStr("0123456789",SubStr(value,A_Index+1,1)))){
      ContinueNext:=SubStr(value,A_Index+1,1)=A_Space||SubStr(value,A_Index+1,1)=A_Tab
      LF:=LF
    } else {
      LF .= A_LoopField
      continue
    }
    If (obj=""){
      If !VQ
        If (Asc(LF)=91 && !Yaml_Seq("","",LF))
          ||(Asc(LF)=123 && !Yaml_Map("","",LF))
          Return 0
    } else {
      If (VQ || !Yaml_SeqMap(cObj,"",LF))
        cObj.Insert(VQ?Yaml_UniChar(LF):Trim(LF))
    }
    LF:="",VQ:=""
  }
  If (LF){
    If (obj=""){
      If !VQ
        If (Asc(LF)=91 && !Yaml_Seq("","",LF))||(Asc(LF)=123 && !Yaml_Map("","",LF))
          Return 0
    } else If (VQ || !Yaml_SeqMap(cObj,"",LF))
      cObj.Insert(VQ?Yaml_UniChar(LF):Trim(LF))
  }
  Return (obj=""?(Quote Bracket=""):1)
}
Yaml_Map(obj,key,value,isVal=0){
  static base:={Dump:"Yaml_Dump",Save:"Yaml_Save",Add:"Yaml_Add",Merge:"Yaml_Merge",__Delete:"__Delete",_Insert:"_Insert",_Remove:"_Remove",_GetCapacity:"_GetCapacity",_SetCapacity:"_SetCapacity",_GetAddress:"_GetAddress",_MaxIndex:"_MaxIndex",_MinIndex:"_MinIndex",_NewEnum:"_NewEnum",_HasKey:"_HasKey",_Clone:"_Clone",Insert:"Insert",Remove:"Remove",GetCapacity:"GetCapacity",SetCapacity:"SetCapacity",GetAddress:"GetAddress",MaxIndex:"MaxIndex",MinIndex:"MinIndex",NewEnum:"NewEnum",HasKey:"HasKey",Clone:"Clone",base:{__Call:"Yaml_Call"}}
  ContinueNext:=0
  If (obj=""){
    If (SubStr(value,0)!="}")
      Return 0
    else
      value:=SubStr(value,2,StrLen(value)-2)
  } else {
    If (key="")
      obj.Insert(cObj:=Object("base",base))
    else obj[key]:=(cObj:=Object("base",base))
  }
  Count:=StrLen(value)
  Loop,Parse,value
  {

    If ((Quote=""""&&Yaml_Quote(LF,A_LoopField,Quote,Bracket,Escape)) || (ContinueNext && !ContinueNext:=0))
      Continue
    If (Quote){
      If (A_LoopField=Quote){
        Quote=
        LF.=A_LoopField
      } else LF .= A_LoopField
      continue
    } else if (!Quote&&(k=""||v="")&&InStr("""'",A_LoopField)){
      Quote:=A_LoopField
      If (k && !Bracket)
        VQ:=Quote
      else if !Bracket
        KQ:=Quote
      LF.=Quote
      Continue
    } else If (k!=""&&LF=""&&InStr("`n`r `t",A_LoopField)){
      Continue
    }
    If (!Quote&&Bracket){
      If (Asc(A_LoopField)=Asc(Bracket)+2)
        BCount--
      else if (A_LoopField=Bracket)
        BCount++
      If (BCount=0)
        Bracket=
      LF .= A_LoopField
      Continue
    } else if (!Quote&&!Bracket&&InStr("[{",A_LoopField)){
      Bracket:=A_LoopField
      BCount=1
      LF.=A_LoopField
      Continue
    }
    If (A_Index=Count&&k!=""){
      v:=LF A_LoopField
      v:=Trim(v)
      If (InStr("""'",SubStr(v,0))&&SubStr(v,1,1)=SubStr(v,0))
        v:=SubStr(v,2,StrLen(v)-2)
    } else If (!Quote&&!Bracket&&k!=""&&A_LoopField=","&&SubStr(value,A_Index+1,1)=A_Space){
      ContinueNext:=1
      LF:=Trim(LF)
      If VQ
        LF:=SubStr(LF,2,StrLen(LF)-2)
      v:=LF,LF:=""
    } else if (!Quote&&!Bracket&&k=""&&A_LoopField=":"){
      LF:=Trim(LF)
      If (InStr("""'",SubStr(LF,0))&&SubStr(LF,1,1)=SubStr(LF,0))
        LF:=SubStr(LF,2,StrLen(LF)-2)
      k:=LF,LF:=""
      continue
    } else {
      LF .= A_LoopField
      continue
    }
    If (obj=""){
      If VQ=
        If (Asc(v)=91 && !Yaml_Seq("","",v))
          ||(Asc(v)=123 && !Yaml_Map("","",v))
          Return 0
    } else {
      If (VQ || !Yaml_SeqMap(cObj,k,v))
        cObj[KQ?Yaml_UniChar(k):k]:=(VQ?Yaml_UniChar(v):Trim(v))
    }
    k:="",v:="",VQ:="",KQ:=""
  }
  If (k){
    If (obj=""){
      If (Asc(LF)=91 && !Yaml_Seq("","",LF))||(Asc(LF)=123 && !Yaml_Map("","",LF))
        Return 0
    } else {
      LF:=Trim(LF)
      If (VQ)
        LF:=SubStr(LF,2,StrLen(LF)-2),cObj[k]:=Yaml_UniChar(LF)
      else If (!Yaml_SeqMap(cObj,k,LF))
        cObj[k]:=Trim(LF)
    }
  }
  Return (obj=""?(Quote Bracket=""):1)
}
Yaml_Incomplete(value){
  return (Asc(Trim(value,"`n" A_Tab A_Space))=91 && !Yaml_Seq("","",Trim(value,"`n" A_Tab A_Space)))
            || (Asc(Trim(value,"`n" A_Tab A_Space))=123 && !Yaml_Map("","",Trim(value,"`n" A_Tab A_Space)))
}
Yaml_IsSeqMap(value){
    return (Asc(Trim(value,"`n" A_Tab A_Space))=91 && Yaml_Seq("","",Trim(value,"`n" A_Tab A_Space)))
            || (Asc(Trim(value,"`n" A_Tab A_Space))=123 && Yaml_Map("","",Trim(value,"`n" A_Tab A_Space)))
}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

GetFullPathName(path) {
    cc := DllCall("GetFullPathName", "str", path, "uint", 0, "ptr", 0, "ptr", 0, "uint")
    VarSetCapacity(buf, cc*(A_IsUnicode?2:1))
    DllCall("GetFullPathName", "str", path, "uint", cc, "str", buf, "ptr", 0, "uint")
    return buf
}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; https://www.autohotkey.com/boards/viewtopic.php?t=67716
CB_hBMP_Get() {  ;;                                                  ; By SKAN on D293 @ bit.ly/2L81pmP
    Local OK := [0,0,0,0]
      OK.1 := DllCall( "OpenClipboard", "Ptr",0 )
    OK.2 := OK.1 ? DllCall( "IsClipboardFormatAvailable", "UInt",8 ) : 0  ; CF_BITMAP
    OK.3 := OK.2 ? DllCall( "GetClipboardData", "UInt", 2, "Ptr" )   : 0
    OK.4 := OK.1 ? DllCall( "CloseClipboard" ) : 0  
    Return OK.3 ? DllCall( "CopyImage", "Ptr",OK.3, "Int",0, "Int",0, "Int",0, "UInt",0x200C, "Ptr" )
        + ( ErrorLevel := 0 ) : ( ErrorLevel := !OK.2 ? 1 : 2 ) >> 2          
}

SavePicture(hBM, sFile) {
    Local V,  pBM := VarSetCapacity(V,16,0)>>8,  Ext := LTrim(SubStr(sFile,-3),"."),  E := [0,0,0,0]
    Local Enc := 0x557CF400 | Round({"bmp":0, "jpg":1,"jpeg":1,"gif":2,"tif":5,"tiff":5,"png":6}[Ext])
    E[1] := DllCall("gdi32\GetObjectType", "Ptr",hBM ) <> 7
    E[2] := E[1] ? 0 : DllCall("gdiplus\GdipCreateBitmapFromHBITMAP", "Ptr",hBM, "UInt",0, "PtrP",pBM)
    NumPut(0x2EF31EF8,NumPut(0x0000739A,NumPut(0x11D31A04,NumPut(Enc+0,V,"UInt"),"UInt"),"UInt"),"UInt")
    E[3] := pBM ? DllCall("gdiplus\GdipSaveImageToFile", "Ptr",pBM, "WStr",sFile, "Ptr",&V, "UInt",0) : 1
    E[4] := pBM ? DllCall("gdiplus\GdipDisposeImage", "Ptr",pBM) : 1
    Return E[1] ? 0 : E[2] ? -1 : E[3] ? -2 : E[4] ? -3 : 1  
} 

GDIP(C:="Startup") {
    Static SI:=Chr(!(VarSetCapacity(Si,24,0)>>16)), pToken:=0, hMod:=0, Res:=0, AOK:=0
    If (AOK := (C="Startup" and pToken=0) Or (C<>"Startup" and pToken<>0))  {
      If (C="Startup") {
          hMod := DllCall("LoadLibrary", "Str","gdiplus.dll", "Ptr")
          Res  := DllCall("gdiplus\GdiplusStartup", "PtrP",pToken, "Ptr",&SI, "UInt",0)
      } Else { 
          Res  := DllCall("gdiplus\GdiplusShutdown", "Ptr",pToken )
          DllCall("FreeLibrary", "Ptr",hMod),   hMod:=0,   pToken:=0
    }}  
    Return (AOK ? !Res : Res:=0)    
}

;;;;;;;;;;;
; https://autohotkey.com/board/topic/23162-how-to-copy-a-file-to-the-clipboard/#entry150209
; https://autohotkey.com/board/topic/23162-how-to-copy-a-file-to-the-clipboard/page-4#entry463462
FileToClipboard(PathToCopy,Method="copy")
{
    ; Expand to full paths:
    Loop, Parse, PathToCopy, `n, `r
        Loop, %A_LoopField%, 1
            temp_list .= A_LoopFileLongPath "`n"
    PathToCopy := SubStr(temp_list, 1, -1)

    FileCount:=0
    PathLength:=0

    ; Count files and total string length
    Loop,Parse,PathToCopy,`n,`r
    {
        FileCount++
        PathLength+=StrLen(A_LoopField)
    }

    pid:=DllCall("GetCurrentProcessId","uint")
    hwnd:=WinExist("ahk_pid " . pid)
    ; 0x42 = GMEM_MOVEABLE(0x2) | GMEM_ZEROINIT(0x40)
    hPath := DllCall("GlobalAlloc","uint",0x42,"uint",20 + (PathLength + FileCount + 1) * 2,"UPtr")
    pPath := DllCall("GlobalLock","UPtr",hPath)
    NumPut(20,pPath+0),pPath += 16 ; DROPFILES.pFiles = offset of file list
    NumPut(1,pPath+0),pPath += 4 ; fWide = 0 -->ANSI,fWide = 1 -->Unicode
    Offset:=0
    Loop,Parse,PathToCopy,`n,`r ; Rows are delimited by linefeeds (`r`n).
        offset += StrPut(A_LoopField,pPath+offset,StrLen(A_LoopField)+1,"UTF-16") * 2

    DllCall("GlobalUnlock","UPtr",hPath)
    DllCall("OpenClipboard","UPtr",hwnd)
    DllCall("EmptyClipboard")
    DllCall("SetClipboardData","uint",0xF,"UPtr",hPath) ; 0xF = CF_HDROP

    ; Write Preferred DropEffect structure to clipboard to switch between copy/cut operations
    ; 0x42 = GMEM_MOVEABLE(0x2) | GMEM_ZEROINIT(0x40)
    mem := DllCall("GlobalAlloc","uint",0x42,"uint",4,"UPtr")
    str := DllCall("GlobalLock","UPtr",mem)

    if (Method="copy")
        DllCall("RtlFillMemory","UPtr",str,"uint",1,"UChar",0x05)
    else if (Method="cut")
        DllCall("RtlFillMemory","UPtr",str,"uint",1,"UChar",0x02)
    else
    {
        DllCall("CloseClipboard")
        return
    }

    DllCall("GlobalUnlock","UPtr",mem)

    cfFormat := DllCall("RegisterClipboardFormat","Str","Preferred DropEffect")
    DllCall("SetClipboardData","uint",cfFormat,"UPtr",mem)
    DllCall("CloseClipboard")
    return
}


GetFileNameFromFullPath(file_path_str) {
    ; file_path_str just like: "C:\Program Files\Git\bin\bash.exe"
    RegExMatch(file_path_str, "([^<>/\\\|:""\*\?]+)[\.\w+]$", file_name)  ; file_name just like: "bash.exe""
    ; file_name just like: "bash.exe""
    return file_name
}


IsDesktopActive() { ; Modified.. orignal by HotKeyIt
    MouseGetPos,,,win
    WinGetClass, class, ahk_id %win%
    If class in Progman,WorkerW
        Return True
    Return False
}


TransformText(selected_text, transform_text_map_index) { ; transform_text_map_index 指的是 common.ahk 的 TRANSFORM_TEXT_MAP 的 index
	st := Trim(selected_text)
	if (!st) {
		; SelectCurrentWordAndCopy()
		; st := GetCurSelectedText()
		; if (!st) {
			ToolTipWithTimer(lang("Please Select text and try again") . ".")
		; 	Return
		; }
	}

	delimiters_arr := ["_", "-", " "]
	if (transform_text_map_index == 1) {
		; for _i, deli in delimiters_arr
		; 	st := StrReplace(st, deli, "")
		StringUpper, st, st
	}
	else if (transform_text_map_index == 2) {
		; for _i, deli in delimiters_arr
		; 	st := StrReplace(st, deli, "")
		StringLower, st, st
	}
	else if (transform_text_map_index >= 4) {
		if st is upper
		{
			; ToolTipWithTimer(lang("Can not separate words") . ".")	
			return st
		}
		else if st is lower
		{
			; ToolTipWithTimer(lang("Can not separate words") . ".")	
			return st
		}

		temp_st_arr := StrSplit(st, delimiters_arr)
		st_arr := []
		for _i, single_w in temp_st_arr {
			if single_w is upper
			{
				st_arr.Push(single_w)
				Continue
			} 
			if single_w is lower
			{
				st_arr.Push(single_w)
				Continue
			}
			last_start_i := 1
			is_last_iter_char_upper := 0
			Loop, parse, single_w
			{
				if (A_Index == 1)
					Continue
				if A_LoopField is upper
				{
					if (!is_last_iter_char_upper) {
						st_arr.Push(SubStr(single_w, last_start_i, A_Index-last_start_i))
						last_start_i := A_Index
					}
					is_last_iter_char_upper := 1
				}
				else {
					is_last_iter_char_upper := 0
				}
			}
			st_arr.Push(SubStr(single_w, last_start_i, StrLen(single_w)-last_start_i+1))
		}
		; for _i, s in st_arr {
		; 	m(s)
		; }

		st := ""
        ; 以下的这些 map 都是根据 common.ahk 文件里的 `TRANSFORM_TEXT_MAP` 来生成的
		deli_map := {1: "", 2: "", 4: "", 5: "", 7: "_", 8: "_", 9: "_", 10: "_", 12: "-", 13: "-", 14: "-", 15: "-", 17: " ", 18: " ", 19: " "}
		first_letter_lower_case_map := {5: "", 10: "", 15: ""}
		title_case_map := {4: "", 5: "", 9: "", 10: "",  14: "", 15: "", 19: ""}
		lower_case_map := {2: "", 8: "", 13: "", 18: ""}
		upper_case_map := {1: "", 7: "", 12: "", 17: ""}

		cur_delimiter := deli_map[transform_text_map_index]
		for index, _single_w in st_arr {
			if (st != "")
				st .= cur_delimiter
			if (index == 1 && first_letter_lower_case_map.HasKey(transform_text_map_index))
				StringLower, _single_w, _single_w
			else if (title_case_map.HasKey(transform_text_map_index))
				StringUpper, _single_w, _single_w, T
			else if (lower_case_map.HasKey(transform_text_map_index))
				StringLower, _single_w, _single_w
			else if (upper_case_map.HasKey(transform_text_map_index))
				StringUpper, _single_w, _single_w

			st .= _single_w
		}
	}
    return st
}


MoveWindowToMouseMonitor(active_id="") {
  
		;; 让打开的窗口永远和鼠标在同一个屏幕
		Sleep, 66

    if (active_id == "") {
        WinGet, active_id, ID, A
    }
    WinGetTitle, cur_title, ahk_id %active_id%
    
	  WinGet, maximized, MinMax, %cur_title%
		if (maximized == -1)
			Return

		WinGetPos, cur_window_x, cur_window_y, cur_window_width, cur_window_height, %cur_title%
		
		if (IsMouseActiveWindowAtSameMonitor(cur_window_x)) {
			Return
		}
		MouseGetPos, mouse_X, mouse_Y   ; get mouse location 

		; WinMinimize, %cur_title%
		
		; -1: 窗口处于最小化状态(使用 WinRestore 可以让它还原).
		; 1: 窗口处于最大化状态(使用 WinRestore 可以让它还原).
		; 0: 窗口既不处于最小化状态也不处于最大化状态.
		if (maximized = 1)  ; 窗口处于最大化状态(使用 WinRestore 可以让它还原).
		{ 
			WinRestore, %cur_title%
			; WinMove, %cur_title%, , %mouse_X%, %mouse_Y%
			; WinMove, %cur_title%, , %mouse_X%, 111
			; Sleep, 222
			; WinMaximize, %cur_title%
		}
		mid_x := GetMouseMonitorMidX()
		mid_x -= cur_window_width / 2
		yScrnOffset := 222
		WinMove, %cur_title%, , %mid_x%, %yScrnOffset% 
		if (maximized = 1)  ; 窗口处于最大化状态(使用 WinRestore 可以让它还原).
		{
			WinMaximize, %cur_title%
		}
}