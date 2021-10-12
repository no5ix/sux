
if(A_ScriptName=="translate.ahk") {
	ExitApp
}


webapp_gui_http_req = 
__Webapp_wb = 
transformed_cur_seleted_txt =

; with this label, you can include this file on top of the file
Goto, SUB_TRANSLATION_FILE_END_LABEL

#Include %A_ScriptDir%\source\sux_core.ahk
#Include %A_ScriptDir%\source\quick_entry.ahk

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

	if (!cur_sel_text) {
		tt(lang("Please Select text and try again") . ".")
		return
	}

	global webapp_gui_http_req
	webapp_gui_http_req := ComObjCreate("Msxml2.XMLHTTP")

	global transformed_cur_seleted_txt
	; 打开启用异步的请求.
	transformed_cur_seleted_txt := TransformText(cur_sel_text, 18)
	tt(lang("Translate Text") . " : " . transformed_cur_seleted_txt, 1111)
	url := "https://www.youdao.com/w/" . UriEncode(transformed_cur_seleted_txt)
	
	; 100% will be 96 dpi, 125% will be 120 dpi, 150% will be 144 dpi and so on
	if (A_ScreenDPI <= 96) {
		global __Webapp_wb
		__Webapp_Width := 1288
		__Webapp_height := 800
		__Webapp_Name := lang("Translation")
		Gui __Webapp_:New
		; Gui __Webapp_:+Resize +MinSize%__Webapp_Width% -MaximizeBox -MinimizeBox
		Gui __Webapp_:Margin, 0, 0
		; Gui __Webapp_:Color, EEAA99, EEAA99
		Gui __Webapp_:-DPIScale

		Gui __Webapp_:Add, ActiveX, v__Webapp_wb w%__Webapp_Width% h%__Webapp_height%, Shell.Explorer
		__Webapp_wb.silent := true ;Surpress JS Error boxes

		__Webapp_wb.Navigate(url)  ; 该句只适用于 web 浏览器控件.
		
		xMidScrn := GetMouseMonitorMidX()
		xMidScrn -= __Webapp_Width / 2 
		Gui __Webapp_:Show, x%xMidScrn% w%__Webapp_Width% h%__Webapp_height%, %__Webapp_Name%
	}
	else {
		; global __Webapp_wb
		; Gui Add, ActiveX, w980 h640 v__Webapp_wb, Shell.Explorer  ; 最后一个参数是 ActiveX 组件的名称.
		; __Webapp_wb.Navigate(url)  ; 该句只适用于 web 浏览器控件.
		; Gui Show

		webapp_gui_http_req.open("GET", url, true)
		; 设置回调函数 [需要 v1.1.17+].
		webapp_gui_http_req.onreadystatechange := Func("on_webapp_gui_req_ready")
		; 发送请求. Ready() 将在其完成后被调用.
		webapp_gui_http_req.send()
	}
}

on_webapp_gui_req_ready() {
	global webapp_gui_http_req
	global current_selected_text
	global transformed_cur_seleted_txt

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
				<link rel="stylesheet" href="../../min_trans_style.css">
				<script type="text/javascript" src="https://cdn.staticfile.org/jquery/1.9.1/jquery.min.js"></script>
			</head>
			<body>
		
		)

		if (InStr(webapp_gui_http_req.responseText, "<div class=""baav"">")) {
			str_1 := get_str_from_start_end_str(webapp_gui_http_req.responseText, "<div id=""results"">", "<div id=""wordArticle""")
			str_a := ""
			str_2 := ""
			str_3 := get_str_from_start_end_str(webapp_gui_http_req.responseText, "<div id=""examples""", "<div id=""ads"" class=""ads"">")
		}
		; else if (webapp_gui_http_req.responseText, "<div class=""error-wrapper"">"){
		; 	str_1 := get_str_from_start_end_str(webapp_gui_http_req.responseText, "<div id=""results"">", "<div class=""error-wrapper"">")
		; 	str_a := ""
		; 	str_2 := get_str_from_start_end_str(webapp_gui_http_req.responseText, "<div class=""trans-wrapper""", "<div id=""wordArticle""")
		; 	str_3 := get_str_from_start_end_str(webapp_gui_http_req.responseText, "<script src=""https://shared.ydstatic.com/dict/v2016/result/160621/result-wordArticle.js""></script>", "<div id=""ads"" class=""ads"">")
		; }
		else {		
			str_1 := get_str_from_start_end_str(webapp_gui_http_req.responseText, "<div id=""results"">", "<div id=""wordArticle""")
			str_a := ""
			str_2 := get_str_from_start_end_str(webapp_gui_http_req.responseText, "<script src=""https://shared.ydstatic.com/dict/v2016/result/160621/result-wordArticle.js""></script>", "<div id=""ads"" class=""ads"">")
			str_3 := ""
		}

		html_end_str =
		(
					<script type="text/javascript" src="https://shared.ydstatic.com/dict/v2016/160525/autocomplete_json.js"></script>
					<script type="text/javascript" src="https://c.youdao.com/dict/activity/ad/result-min.js"></script>
				</body>
			</html>
		)
		final_html_body_str := html_head_str . str_1 . str_a . str_2 . str_3 . html_end_str
		final_html_body_str := StrReplace(final_html_body_str, "wordbook", "rm_wordbook_button")  ; 为了去除`添加到单词本`的按钮

		pending_rm_str_arr := ["<p>以上为机器翻译结果，长、整句建议使用 <a class=""viaInner"" href=""http://f.youdao.com?keyfrom=dict.result"" target=_blank>人工翻译</a> 。</p>"]

		; yd_html_file.Write(final_html_body_str)
		; yd_html_file.Close()
		
		rm_str_start_arr := ["<a class=""more-example"
		, "class=""sp humanvoice humanvoice-js log-js"
		, "sp dictvoice voice-js log-js"
		, "<img src=""http://dict.youdao.com/pureimage?"
		, "<img src=""https://shared-https.ydstatic.com/dict/v5.16/images/play.png"]

		; 去除所有的 多余的东西
		Loop, parse, final_html_body_str, `n, `r  ; 在 `r 之前指定 `n, 这样可以同时支持对 Windows 和 Unix 文件的解析.
		{
			for _i, _v in rm_str_start_arr {
				if (InStr(A_LoopField, _v))  {
					pending_rm_str_arr.Push(A_LoopField)
				}
			}
		}

		for _i, _v in pending_rm_str_arr {
			final_html_body_str := StrReplace(final_html_body_str, _v, "")
		}

		FileAppend, % final_html_body_str, % TEMP_TRANS_WEBAPP_GUI_HTML_HTML, UTF-8
		; FileAppend, % webapp_gui_http_req.responseText, % TEMP_TRANS_WEBAPP_GUI_HTML_HTML, UTF-8

		global __Webapp_wb
		__Webapp_Width := 700
		__Webapp_height := 480
		__Webapp_Name := lang("Translation")
		Gui __Webapp_:New
		; Gui __Webapp_:+Resize +MinSize%__Webapp_Width% -MaximizeBox -MinimizeBox
		Gui __Webapp_:Margin, 0, 0
		; Gui __Webapp_:Color, EEAA99, EEAA99
		Gui __Webapp_:-DPIScale
		
		; Gui, __Webapp_:Font, s12
		; url := "https://www.youdao.com/w/" . UriEncode(Trim(current_selected_text))
		; s := "<a href=""" url """>" lang("Original Page") "</a>"
		; Gui, __Webapp_:Add, Link,, % s

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
		; while __Webapp_wb.readystate != 4 or __Webapp_wb.busy
		; 	sleep 10
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