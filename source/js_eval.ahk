
class JsEval
{
    static obj = 
    static user_ext_file := "user_extension.js"

    init() 
    {
        JsEval.obj := ComObjCreate("HTMLfile")
        JsEval.FixIE(11)
        JsEval.load_script()
    }

    load_script() 
    {
        if (FileExist(JsEval.user_ext_file))
        {
            JsEval.obj.write("<script>")
            loop, Read, % JsEval.user_ext_file
            {
                JsEval.obj.write(A_LoopReadLine . "`n")
            }
            JsEval.obj.write("</script>")
        }
    }

    eval(exp)
    {
        JsEval.load_script()
        exp := JsEval.escapeString(exp)
        JsEval.obj.write("<body><script>(function(){var t=document.body;t.innerText='';t.innerText=eval('" . exp . "');})()</script></body>")
        return inStr(cabbage:=JsEval.obj.body.innerText, "body") ? "ERROR" : cabbage
    }

    escapeString(string)
    {
        ;escape http://www.w3school.com.cn/js/js_special_characters.asp
        string:=regExReplace(string, "('|""|&|\\|\\n|\\r|\\t|\\b|\\f)", "\$1")
        ;replace all newline character to '\n'
        string:=regExReplace(string, "\R", "\n")
        return string
    }

    strSelected2Script(selText)
    {
        regex:="\R[ \t]*?\..+\(.*\)\s*$"
        matchFuncPos:=RegExMatch(selText, regex, funcMatch)
        if(matchFuncPos)
        {
            selText := SubStr(selText,1,matchFuncPos)
            selText := JsEval.escapeString(selText)
            selText := "'" . selText . "'" . RegExReplace(funcMatch, "(^\s*)|(\s*$)")
        }
        return selText
    }

    FixIE(Version=0, ExeName="")
    {
        static Key := "Software\Microsoft\Internet Explorer"
        . "\MAIN\FeatureControl\FEATURE_BROWSER_EMULATION"
        , Versions := {7:7000, 8:8888, 9:9999, 10:10001, 11:11001}
        
        if Versions.HasKey(Version)
            Version := Versions[Version]
        if !ExeName
        {
            if A_IsCompiled
                ExeName := A_ScriptName
            else
                SplitPath, A_AhkPath, ExeName
        }
        RegRead, PreviousValue, HKCU, %Key%, %ExeName%
        ;  msgbox, % PreviousValue . "#" . Version
        if (Version = "")
            RegDelete, HKCU, %Key%, %ExeName%
        else if(PreviousValue != Version)
            RegWrite, REG_DWORD, HKCU, %Key%, %ExeName%, %Version%
            
        ;  msgbox, % Version
        return PreviousValue
    }
}
