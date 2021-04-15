
class Sys
{

	class Cursor
	{
		static CornerPixel := 8
		static info_switch := 0

		CornerPos(X := "", Y := "", cornerPix = "")
		{
; DebugPrintVal("0jlkj8812")

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
                ; ToolTipWithTimer(MonBottom)
                ; ToolTipWithTimer(X)
                ; ToolTipWithTimer(MonBottom - cornerPix)

				if(X>=MonLeft && Y>= MonTop && X<MonRight && Y<MonBottom)
				{
					str =
					if ( X < MonLeft + cornerPix ){
; DebugPrintVal("jlkj8812")
						str .= "L"
                    }
					else if ( X >= MonRight - cornerPix) {
; DebugPrintVal("jlkj88123")
						str .= "R"
                    }
					if ( Y < MonTop + cornerPix ) {
; DebugPrintVal("jlkj88124")
						str .= "T"
                    }
					else if ( Y >= MonBottom - cornerPix) {
; DebugPrintVal("jlkj88125")
						str .= "B"
                    }
; DebugPrintVal("jlkj88126")
					return % str
				}
			}
; DebugPrintVal("jlkj88127")
			return ""
		}

		; IsPos(pos, cornerPix = "")
		; {
		; 	StringUpper, pos, pos
		; 	pos_now := this.CornerPos("", "", cornerPix)
		; 	if (pos_now == "") && (pos == "")
		; 		Return
		; 	if StrLen(pos_now) == 1
		; 		Return % (pos_now == pos)
		; 	Else
		; 		pos_now2 := SubStr(pos_now,2,1) SubStr(pos_now,1,1)
		; 	Return ((pos_now == pos) || (pos_now2 == pos))
		; }

		; Info()
		; {
		; 	this.info_switch := !this.info_switch
		; 	if (this.info_switch)
		; 	{
		; 		Gosub, Sub_Sys_Cursor_Info
		; 		Settimer, Sub_Sys_Cursor_Info, 500
		; 	}
		; }
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
			run, %command%
			Return
		}
		Catch
		{
			if(IsFunc("run_user"))
			{
				func_name = run_user
				%func_name%(command)
			}
			else if (throwErr == 1)
				MsgBox, 0x30, % OneQuick.ProgramName, % "Can't run command """ command """"
		}
	}
}