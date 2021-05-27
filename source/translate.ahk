
if(A_ScriptName=="translate.ahk") {
	ExitApp
}


webapp_gui_http_req = 
__Webapp_wb = 

; with this label, you can include this file on top of the file
Goto, SUB_TRANSLATION_FILE_END_LABEL

#Include %A_ScriptDir%\source\sux_core.ahk

;;;;;;;;;;;;;;;

get_str_from_start_end_str(original_str, start_str, end_str)
{
	left_pos := InStr(original_str, start_str)
	right_pos := InStr(original_str, end_str)
	ret_str := SubStr(original_str, left_pos, right_pos-left_pos) 
	return ret_str
}

TranslateSeletedText(cur_sel_text)
{
	; 	global __Webapp_wb
	; 	__Webapp_Width := 888
	; 	__Webapp_height := 480
	; 	__Webapp_Name := lang("Translation")
	; 	Gui __Webapp_:New
	; 	Gui __Webapp_:Margin, 0, 0
	; 	; Gui __Webapp_:+DPIScale
	; 	Gui __Webapp_:Add, ActiveX, v__Webapp_wb w%__Webapp_Width% h%__Webapp_height%, Shell.Explorer
	; 	__Webapp_wb.silent := true ;Surpress JS Error boxes
		
	; st := GetCurSelectedText()
	; if !st
	; 	return
	; url := "https://www.youdao.com/w/" . UriEncode(Trim(st))
	; 	__Webapp_wb.Navigate(url)
	; 	; __Webapp_wb.Navigate("file://" . GetFullPathName(TEMP_TRANS_WEBAPP_GUI_HTML_HTML))

	; 	;Wait for IE to load the page, before we connect the event handlers
	; 	while __Webapp_wb.readystate != 4 or __Webapp_wb.busy
	; 		sleep 10
	; 	;Use DOM access just like javascript!
	; 	; MyButton1 := wb.document.getElementById("MyButton1")
	; 	; MyButton2 := wb.document.getElementById("MyButton2")
	; 	; MyButton3 := wb.document.getElementById("MyButton3")
	; 	; ComObjConnect(MyButton1, "MyButton1_") ;connect button events
	; 	; ComObjConnect(MyButton2, "MyButton2_")
	; 	; ComObjConnect(MyButton3, "MyButton3_")
	; 	Gui __Webapp_:Show, w%__Webapp_Width% h%__Webapp_height%, %__Webapp_Name%
	; return

	st := cur_sel_text
	if (!st) {
		ToolTipWithTimer(lang("Please Select text and try again") . ".")
		return
	}
	global webapp_gui_http_req
	webapp_gui_http_req := ComObjCreate("Msxml2.XMLHTTP")
	; 打开启用异步的请求.
	url := "https://www.youdao.com/w/" . UriEncode(Trim(st))
	; m(url)
	webapp_gui_http_req.open("GET", url, true)
	; 设置回调函数 [需要 v1.1.17+].
	webapp_gui_http_req.onreadystatechange := Func("on_webapp_gui_req_ready")
	; 发送请求. Ready() 将在其完成后被调用.
	webapp_gui_http_req.send()
	; SetTimer, handle_webapp_gui_req_failed, -6666
}

on_webapp_gui_req_ready() {
	global webapp_gui_http_req
	if (webapp_gui_http_req.readyState != 4) {  ; 没有完成.
		return
	}
	TEMP_TRANS_WEBAPP_GUI_HTML_HTML := SuxCore._CACHE_DIR . "TEMP_TRANS_WEBAPP_GUI.html"
	if (webapp_gui_http_req.status == 200) {
		yd_html_file := FileOpen(TEMP_TRANS_WEBAPP_GUI_HTML_HTML, "w")
		if FileExist(TEMP_TRANS_WEBAPP_GUI_HTML_HTML)
			FileDelete, % TEMP_TRANS_WEBAPP_GUI_HTML_HTML
		html_head_str = 
		(
		<!DOCTYPE html>
		<html>
			<head>
				<meta http-equiv='X-UA-Compatible' content='IE=edge'>
				<link rel="stylesheet" href="../../translate/min_trans_style.css">
				<script type="text/javascript" src="https://cdn.staticfile.org/jquery/1.9.1/jquery.min.js"></script>
			</head>
			<body>
		
		)

		str_1 := get_str_from_start_end_str(webapp_gui_http_req.responseText, "<div id=""results"">", "<div class=""baav"">")
		str_a := " </h2>"
		str_2 := get_str_from_start_end_str(webapp_gui_http_req.responseText, "<div class=""trans-container"">", "<div id=""wordArticle""")
		str_3 := get_str_from_start_end_str(webapp_gui_http_req.responseText, "<div id=""examples""", "<div id=""ads"" class=""ads"">")

		html_end_str =
		(
					<script type="text/javascript" src="https://shared.ydstatic.com/dict/v2016/160525/autocomplete_json.js"></script>
					<script type="text/javascript" src="https://c.youdao.com/dict/activity/ad/result-min.js"></script>
				</body>
			</html>
		)
		; final_html_body_str := html_head_str . html_center_str . html_end_str
		final_html_body_str := html_head_str . str_1 . str_a . str_2 . str_3 . html_end_str
		; yd_html_file.Write(final_html_body_str)
		; yd_html_file.Close()
		FileAppend, % final_html_body_str, % TEMP_TRANS_WEBAPP_GUI_HTML_HTML, UTF-8

		global __Webapp_wb
		__Webapp_Width := 700
		__Webapp_height := 480
		__Webapp_Name := lang("Translation")
		Gui __Webapp_:New
		; Gui __Webapp_:+Resize +MinSize%__Webapp_Width% -MaximizeBox -MinimizeBox
		Gui __Webapp_:Margin, 0, 0
		; Gui __Webapp_:Color, EEAA99, EEAA99
		Gui __Webapp_:-DPIScale
		Gui __Webapp_:Add, ActiveX, v__Webapp_wb w%__Webapp_Width% h%__Webapp_height%, Shell.Explorer
		__Webapp_wb.silent := true ;Surpress JS Error boxes
		
	; st := GetCurSelectedText()
	; if !st
	; 	return
	; ; m(st)
	; url := "https://www.youdao.com/w/" . UriEncode(Trim(st))
	; __Webapp_wb.Navigate(url)

		__Webapp_wb.Navigate("file://" . GetFullPathName(TEMP_TRANS_WEBAPP_GUI_HTML_HTML))

		;Wait for IE to load the page, before we connect the event handlers
		while __Webapp_wb.readystate != 4 or __Webapp_wb.busy
			sleep 10
		;Use DOM access just like javascript!
		; MyButton1 := wb.document.getElementById("MyButton1")
		; MyButton2 := wb.document.getElementById("MyButton2")
		; MyButton3 := wb.document.getElementById("MyButton3")
		; ComObjConnect(MyButton1, "MyButton1_") ;connect button events
		; ComObjConnect(MyButton2, "MyButton2_")
		; ComObjConnect(MyButton3, "MyButton3_")
		
		xMidScrn := GetMouseMonitorMidX()
		xMidScrn -= __Webapp_Width / 2 
		Gui __Webapp_:Show, x%xMidScrn% w%__Webapp_Width% h%__Webapp_height%, %__Webapp_Name%
		; Gui __Webapp_:Default
	}
	else {
		; m("xxd")
		; handle_webapp_gui_req_failed()
	}
	webapp_gui_http_req = 
}

__Webapp_GuiEscape:
__Webapp_GuiClose:
	;make sure taskbar is back on exit
	WinShow, ahk_class Shell_TrayWnd
	WinShow, Start ahk_class Button
	Gui __Webapp_:Destroy
return



; //////////////////////////////////////////////////////////////////////////
SUB_TRANSLATION_FILE_END_LABEL:
	temp_trans := "blabla"