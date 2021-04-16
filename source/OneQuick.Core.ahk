
class Sys
{


	; Sys.Win
	class Win
	{
		GotoPreApp()
		{
			send !+{esc}
			winget, x ,MinMax, A
			if x=-1
				WinRestore A
		}

		GotoNextApp()
		{
			send !{esc}
			winget, x ,MinMax, A
			if x=-1
				WinRestore A
		}

		; Sys.Win.GotoPreTab
		GotoPreTab()
		{
			if(Sys.Win.Class()="PX_WINDOW_CLASS") {
				send ^{PgUp}
			}
			else {
				send ^+{tab}
			}
		}

		; Sys.Win.GotoNextTab
		GotoNextTab()
		{
			if(Sys.Win.Class()="PX_WINDOW_CLASS") {
				send ^{PgDn}
			}
			else {
				send ^{tab}
			}
		}
	}


	class Cursor
	{
		static CornerPixel := 8
		static info_switch := 0

		CornerPos(X := "", Y := "", cornerPix = "")
		{
			if (X = "") or (Y = "")
			{
				MouseGetPos, X, Y
			}
			if(cornerPix = "")
			{
				cornerPix := this.CornerPixel
			}
			; Multi Monitor Support
			SysGet, MonitorCount, MonitorCount
			Loop, % MonitorCount
			{
				SysGet, Mon, Monitor, % A_Index
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

	}

}



m(str := "")
{
	if(IsObject(str)) {
		str := "[Object]`n" Yaml_dump(str)
	}
	MsgBox, , % OneQuick.ProgramName, % str
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
			brw := OneQuick.Browser
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
			OneQuick.Edit(f1)
			return
		}
		Try
		{
			; m("kl")
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
					MsgBox, 0x30, % OneQuick.ProgramName, % "Can't run command """ command """"
			; }
		}
	}
}