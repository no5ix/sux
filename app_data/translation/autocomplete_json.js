var youdaos = window.youdao || {};
youdaos.global = this,
function(e) {
    function t() {
        for (var e, t = [], i = 0; i < arguments.length; i++)
            e = arguments[i],
            "string" == typeof e && (e = document.getElementById(e)),
            t.push(e);
        return t.length < 2 ? t[0] : t
    }
    e.mixin = function(e, t) {
        for (var i in t)
            e[i] = t[i]
    }
    ,
    e.bind = function(t, i) {
        var s = i || e.global;
        if (arguments.length > 2) {
            var n = Array.prototype.slice.call(arguments, 2);
            return function() {
                var e = Array.prototype.slice.call(arguments);
                return Array.prototype.unshift.apply(e, n),
                t.apply(s, e)
            }
        }
        return function() {
            return t.apply(s, arguments)
        }
    }
    ,
    e.events = {
        element: function(e) {
            return e.target || e.srcElement
        },
        map: {},
        listen: function(e, t, i, s) {
            e.addEventListener ? e.addEventListener(t, i, s) : e.attachEvent && (e["e" + t + i] = i,
            e[t + i] = function() {
                return e["e" + t + i](window.event)
            }
            ,
            e.attachEvent("on" + t, e[t + i]));
            var n = this.map;
            n[e] ? n[e].push({
                type: t,
                fn: i,
                mode: s
            }) : n[e] = [{
                type: t,
                fn: i,
                mode: s
            }]
        },
        unlisten: function(e, t, i, s) {
            e.addEventListener ? e.addEventListener(t, i, s) : e.attachEvent && (e["e" + t + i] = i,
            e[t + i] = function() {
                return e["e" + t + i](window.event)
            }
            ,
            e.attachEvent("on" + t, e[t + i]));
            var n = this.map;
            if (n[e] && "[object Array]" === toString.call(n[e]))
                for (var h = 0, o = n[e].length; o > h; h++) {
                    var r = n[e][h];
                    r.type == t && r.fn == i && n[e].splict(h, 1)
                }
        },
        unlistenAll: function(e) {
            var t = this.map;
            if (t[e])
                for (var i = 0; i < t[e].length; i++) {
                    var s = t[e][i];
                    this.unlisten(e, s.type, s.fn, s.mode)
                }
        }
    },
    e.dom = {
        visible: function(e) {
            return "none" != t(e).style.display
        },
        hide: function() {
            for (var e = 0; e < arguments.length; e++) {
                var i = t(arguments[e]);
                i.style.display = "none"
            }
        },
        show: function() {
            for (var e = 0; e < arguments.length; e++) {
                var i = t(arguments[e]);
                i.style.display = ""
            }
        },
        getHeight: function(e) {
            return e = t(e),
            e.offsetHeight
        },
        addClassName: function(e, i) {
            (e = t(e)) && (e.className = "" == e.className ? i : e.className + " " + i)
        },
        removeClassName: function(e, i) {
            if (e = t(e)) {
                var s = new RegExp("(^| )" + i + "( |$)");
                e.className = e.className.replace(s, "$1").replace(/ $/, "")
            }
        },
        attr: function(e, t, i, s) {
            var n = t;
            if ("string" == typeof t) {
                if (void 0 === i)
                    return e && e.getAttribute(t);
                n = {},
                n[t] = i
            }
            for (var h in n)
                e.setAttribute(h, n[h])
        }
    },
    e.dimension = {
        cumOffset: function(e) {
            var t, i, s, n, h = 0, o = 0, r = !1;
            do
                h += e.offsetTop || 0,
                o += e.offsetLeft || 0,
                e = e.offsetParent,
                e && (t = window.getComputedStyle(e, null),
                i = t.getPropertyValue("position"));
            while (e && "fixed" != i);
            return "fixed" === i && (r = !0,
            s = Number(t.getPropertyValue("top").slice(0, -2)),
            n = Number(t.getPropertyValue("left").slice(0, -2))),
            [o, h, r, s, n]
        }
    },
    e.SK = {
        BACKSPACE: 8,
        TAB: 9,
        RETURN: 13,
        ESC: 27,
        LEFT: 37,
        UP: 38,
        RIGHT: 39,
        DOWN: 40,
        DELETE: 46,
        PAGE_UP: 33,
        PAGE_DOWN: 34,
        END: 35,
        HOME: 36,
        INSERT: 45,
        SHIFT: 16,
        CTRL: 17,
        ALT: 18
    },
    e.Autocomplete = function(t, i, s, n, h, o, r) {
        e.events.listen(document, "click", e.bind(this.hideOnDoc, this)),
        e.events.listen(document, "blur", e.bind(this.hideOnDoc, this)),
        this._dataCache = {},
        this.blurOptions = o || {},
        this.inputType = document.getElementById(r),
        this.objName = i || this.defSugName,
        this.isIE = navigator && -1 != navigator.userAgent.toLowerCase().indexOf("msie"),
        this.hideClose = !!n || !1,
        this.selectCallBack = !1,
        this.box = document.getElementById(t),
        e.events.listen(this.box, "keydown", e.bind(this.onkeydown, this));
        var a = this;
        this.box.onblur = function(e) {
            a.hide(e),
            a.blurOptions.onblur && a.blurOptions.onblur()
        }
        ,
        e.events.listen(this.box, "dblclick", e.bind(this.dbClick, this)),
        this.count = 0,
        this.sugServ = this.defSugServ,
        this.sugServUrlPost = this.S_QUERY_URL_POST,
        s && (this.sugServ = s),
        this.sugMoreParams = "",
        this.logServ = this.defSugServ,
        this.logServUrlPost = this.S_LOG_URL_POST,
        this.searchServ = this.defSearchServ,
        this.searchParamName = this.defSearchParamName,
        this.searchMoreParams = "",
        this.kf = this.defKeyfrom + this.KEYFROM_POST,
        this.openInNewWindow = !1,
        this.clickEnabled = !0,
        this.sptDiv = document.createElement("div"),
        document.body.appendChild(this.sptDiv),
        this.sdiv = document.createElement("div"),
        this.sdiv.style.position = "absolute",
        this.sdiv.style.zIndex = 1e4,
        e.dom.hide(this.sdiv),
        document.body.appendChild(this.sdiv),
        this.iframe = document.createElement("iframe"),
        this.iframe.style.position = "absolute",
        this.iframe.style.zIndex = 9999,
        e.dom.hide(this.iframe),
        document.body.appendChild(this.iframe),
        this.bdiv = document.createElement("div"),
        this.vis = !1,
        this.lastUserQuery = "",
        this.initVal = "",
        this.box && "" != this.box.value && (this.initVal = this.box.value),
        this.curUserQuery = this.initVal,
        this.upDownTag = !1,
        window.onresize = e.bind(this.winResize, this),
        this.clean(),
        !h && this.box && (this.timeoutId = setTimeout(e.bind(this.sugReq, this), this.REQUEST_TIMEOUT))
    }
    ,
    e.mixin(e.Autocomplete.prototype, {
        start: function() {
            0 != this.timeoutId && clearTimeout(this.timeoutId),
            this.timeoutId = setTimeout(e.bind(this.sugReq, this), this.REQUEST_TIMEOUT),
            this.box && "" != this.box.value && (this.initVal = this.box.value,
            this.curUserQuery = this.initVal)
        },
        setOffset: function(e, t) {
            this.offsetX = e,
            this.offsetY = t
        },
        setObjectName: function(e) {
            this.objName = e
        },
        setSugServer: function(e, t) {
            this.sugServ = e,
            t && (this.sugServUrlPost = t),
            this.clean()
        },
        setSugMoreParams: function(e) {
            this.sugMoreParams = e
        },
        setLogServer: function(e, t) {
            this.logServ = e,
            t && (this.logServUrlPost = t)
        },
        setSearchServer: function(e) {
            this.searchServ = e
        },
        setSearchParamName: function(e) {
            this.searchParamName = e
        },
        setSearchMoreParams: function(e) {
            this.searchMoreParams = e
        },
        setKeyFrom: function(e) {
            e.indexOf(this.KEYFROM_POST) > 0 ? this.kf = e : this.kf = e + this.KEYFROM_POST
        },
        setSelectCallBack: function(e) {
            this.selectCallBack = e
        },
        setOpenInNewWindow: function() {
            this.openInNewWindow = !0
        },
        getSearchUrl: function(e) {
            var t = "eng";
            return this.inputType && (t = this.inputType.value),
            encodeURI(this.searchServ + t + "/" + e + "/#keyfrom=" + this.kf)
        },
        getSugQueryUrl: function(e, t, i) {
            return encodeURI(this.sugServ + this.sugServUrlPost + e + this.sugMoreParams + "&keyfrom=" + this.kf + "&o=" + this.objName + "&rn=10" + this.hour()) + "&le=" + i
        },
        clicklog: function(e, t, i, s, n) {
            var h = "";
            t && (h += t),
            i && (h += i),
            s && (h += s),
            n && (h += n);
            var o = new Image;
            return o.src = encodeURI(this.logServ + this.logServUrlPost + e + h + this.time()),
            !0
        },
        dbClick: function() {
            if (this.box.createTextRange) {
                var e = this.box.createTextRange();
                e.moveStart("character", 0),
                e.select()
            } else
                this.box.setSelectionRange && this.box.setSelectionRange(0, this.box.value.length);
            "" != this.box.value && (this.lastUserQuery == this.box.value ? this.sdiv.childNodes.length > 0 && (this.vis ? this.hide() : this.show()) : this.doReq())
        },
        winResize: function() {
            this.vis && this.show()
        },
        onkeydown: function(t) {
            if (t.ctrlKey)
                return !0;
            var i = e.SK;
            switch (t.keyCode) {
            case i.PAGE_UP:
            case i.PAGE_DOWN:
            case i.END:
            case i.HOME:
            case i.INSERT:
            case i.CTRL:
            case i.ALT:
            case i.LEFT:
            case i.RIGHT:
            case i.SHIFT:
            case i.TAB:
                return !0;
            case i.ESC:
                return this.hide(),
                !1;
            case i.UP:
                if (this.vis)
                    this.upDownTag = !0,
                    this.up();
                else {
                    if (this.sdiv.childNodes.length > 1 && this.lastUserQuery == this.box.value)
                        return this.show(),
                        !1;
                    "" != this.box.value && this.doReq()
                }
                return this.isIE ? t.returnValue = !1 : t.preventDefault(),
                !1;
            case i.DOWN:
                if (this.vis)
                    this.upDownTag = !0,
                    this.down();
                else {
                    if (this.sdiv.childNodes.length > 1 && this.lastUserQuery == this.box.value)
                        return this.show(),
                        !1;
                    "" != this.box.value && this.doReq()
                }
                return this.isIE ? t.returnValue = !1 : t.preventDefault(),
                !1;
            case i.RETURN:
                return this.vis && this.curNodeIdx > -1 && !this.select() ? (this.isIE ? t.returnValue = !1 : t.preventDefault(),
                !1) : !0;
            case i.BACKSPACE:
                1 == this.box.value.length && (this.curUserQuery = "");
            default:
                return this.upDownTag = !1,
                !0
            }
        },
        sugReq: function() {
            document.activeElement && document.activeElement != this.box || ("" != this.box.value && this.box.value != this.initVal ? this.lastUserQuery != this.box.value && (this.upDownTag || this.doReq()) : "" != this.lastUserQuery && (this.lastUserQuery = "",
            this.vis && (this.hide(),
            this.clean()))),
            0 != this.timeoutId && clearTimeout(this.timeoutId),
            this.timeoutId = setTimeout(e.bind(this.sugReq, this), this.REQUEST_TIMEOUT)
        },
        select: function(e) {
            if (e)
                var t = this.LOG_MOUSE_SELECT;
            else
                var t = this.LOG_KEY_SELECT;
            if (this.getCurNode()) {
                var i = this.getCurNode().getAttribute(this.ITEM_TYPE)
                  , s = this.getCurNode().getElementsByTagName("td")[0].innerHTML.replace(/<\/?[^>]*>/g, "");
                if ("1" == i) {
                    if (s = this.getElemAttr(this.getCurNode(), this.ITEM_LINK),
                    this.clicklog(t, "&q=" + this.curUserQuery, "&index=0", "&select=" + s, "&direct=true"),
                    this.hide(),
                    this.selectCallBack)
                        return void this.selectCallBack(this.box.value, this.kf);
                    window.open(s, "_blank")
                } else
                    try {
                        if (e)
                            this.clicklog(t, "&q=" + this.curUserQuery, "&index=" + this.curNodeIdx, "&select=" + s),
                            this.curUserQuery = s,
                            this.openInNewWindow || (this.box.value = s);
                        else {
                            if (this.box.value != s)
                                return !0;
                            this.clicklog(t, "&q=" + this.curUserQuery, "&index=" + this.curNodeIdx, "&select=" + s),
                            this.curUserQuery = s,
                            s = this.box.value
                        }
                        this.hide();
                        var n = this.getSearchUrl(s);
                        if (this.openInNewWindow) {
                            if (this.selectCallBack)
                                return void this.selectCallBack(this.box.value, this.kf);
                            window.open(n, "_blank")
                        } else
                            document.location = n
                    } catch (e) {}
            }
            return !1
        },
        submitForm: function(e) {
            var t = document.getElementById(e)
              , i = this;
            t && ("_blank" === t.getAttribute("target") && this.setOpenInNewWindow(),
            this.setSelectCallBack(function(e, s) {
                var n = !1
                  , h = !1
                  , o = document.createElement("input")
                  , r = !1
                  , a = !1;
                o.style.display = "none",
                o.name = i.searchParamName || "query",
                o.value = e,
                t.keyfrom ? (r = t.keyfrom,
                n = r.value,
                r.value = s) : (a = document.createElement("input"),
                a.style.display = "none",
                a.name = "keyfrom",
                a.value = s),
                a && t.appendChild(a),
                t.appendChild(o),
                h = t.action,
                t.action = i.searchServ + i.curUserQuery,
                t.submit(),
                t.action = h,
                a && (t.removeChild(a),
                a = !1),
                r && (r.value = n,
                r = !1),
                t.removeChild(o)
            }))
        },
        doReq: function() {
            this.initVal = "",
            this.curUserQuery = this.box.value;
            var e = this.box.value;
            this.lastUserQuery = this.box.value;
            var t = "eng";
            if (this.inputType)
                var t = this.inputType.value;
            if (this._dataCache[e])
                return void this.updateCall(this._dataCache[e]);
            this.count++;
            var i = this.getSugQueryUrl(e, this.count, t);
            this.excuteCall(i)
        },
        clean: function() {
            this.size = 0,
            this.curNodeIdx = -1,
            this.sdiv.innerHTML = "",
            this.bdiv.innerHTML = ""
        },
        onComplete: function() {
            setTimeout(e.bind(this.updateContent, this), 5)
        },
        cleanScript: function() {
            for (; this.sptDiv.childNodes.length > 0; )
                this.sptDiv.removeChild(this.sptDiv.firstChild)
        },
        isValidNode: function(e) {
            return 1 == e.nodeType
        },
        getReqStr: function(e) {
            return e && e.getElementsByTagName("div").length > 0 ? this.getElemAttr(e.getElementsByTagName("div")[0], this.QUERY_ATTR) : null
        },
        getElemAttr: function(e, t) {
            return this.unescape(e.getAttribute(t))
        },
        updateContent: function() {
            this.cleanScript();
            this.box.value;
            if ("" == this.bdiv.innerHTML)
                return this.hide(),
                void this.clean();
            var t;
            this.sdiv.innerHTML = this.bdiv.innerHTML;
            var i = this.sdiv.getElementsByTagName("table");
            i[2].parentNode.removeChild(i[2]),
            children = i[1].getElementsByTagName("tr"),
            this.size = 0,
            this.childs = new Array;
            for (var s = 0; s < children.length; s++)
                t = children[s],
                this.isValidNode(t) && (t.setAttribute(this.ITEM_INDEX, this.size),
                e.events.listen(t, "mousemove", e.bind(this.mouseMoveItem, this)),
                e.events.listen(t, "mouseover", e.bind(this.mouseOverItem, this)),
                e.events.listen(t, "mouseout", e.bind(this.mouseOutItem, this)),
                e.events.listen(t, "click", e.bind(this.select, this)),
                this.childs.push(t),
                this.size++);
            Number(i.length) >= 3 && this.bindATagWithMouseEvent(i[2], !1),
            this.show(),
            this.canMouseOver = !1
        },
        showContent: function() {
            var t = e.dimension.cumOffset(this.box);
            this.offsetX = this.offsetX || 0,
            this.offsetY = this.offsetY || 0,
            t[2] ? (this.sdiv.style.position = "fixed",
            this.sdiv.style.top = t[1] + (this.box.offsetHeight - 1) + t[3] + this.offsetY + "px",
            this.sdiv.style.left = t[0] + t[4] + this.offsetX + "px") : (this.sdiv.style.position = "absolute",
            this.sdiv.style.top = t[1] + (this.box.offsetHeight - 1) + this.offsetY + "px",
            this.sdiv.style.left = t[0] + this.offsetX + "px"),
            this.sdiv.style.cursor = "default",
            this.sdiv.style.width = this.box.offsetWidth - this.offsetX + "px",
            e.dom.show(this.sdiv),
            this.iframe.style.top = this.sdiv.style.top,
            this.iframe.style.left = this.sdiv.style.left,
            this.iframe.style.width = this.sdiv.style.width,
            this.iframe.style.height = this.sdiv.offsetHeight,
            this.iframe.style.border = 0,
            e.dom.show(this.iframe),
            this.vis = !0,
            this.curNodeIdx = -1
        },
        show: function() {
            this.sdiv.childNodes.length < 1 || this.showContent()
        },
        hide: function() {
            this.hlOff(),
            e.dom.hide(this.sdiv),
            e.dom.hide(this.iframe),
            this.curNodeIdx = -1,
            this.vis = !1
        },
        hideOnDoc: function() {
            this.clickEnabled && (this.hide(),
            this.clickEnabled = !1,
            setTimeout(e.bind(this.enableClick, this), 60))
        },
        enableClick: function() {
            this.clickEnabled = !0
        },
        mouseMoveItem: function(e) {
            this.canMouseOver = !0,
            this.mouseOverItem(e)
        },
        mouseOverItem: function(t) {
            if (this.removeBoxBlur(),
            !this.canMouseOver)
                return void (this.canMouseOver = !0);
            for (var i = e.events.element(t); i.parentNode && (!i.tagName || null == i.getAttribute(this.ITEM_INDEX)); )
                i = i.parentNode;
            var s = i.tagName ? i.getAttribute(this.ITEM_INDEX) : -1;
            -1 != s && s != this.curNodeIdx && (this.hlOff(),
            this.curNodeIdx = Number(s),
            this.hlOn(!1))
        },
        mouseOutItem: function() {
            this.hlOff(),
            this.curNodeIdx = -1,
            this.revertBoxBlur()
        },
        getNode: function(e) {
            return this.childs && e >= 0 && e < this.childs.length ? this.childs[e] : void 0
        },
        getCurNode: function() {
            return this.getNode(this.curNodeIdx)
        },
        hover: function(e, t) {
            e || (this.box.value = t)
        },
        hlOn: function(t) {
            if (this.getCurNode()) {
                var i = this.getCurNode().getElementsByTagName("td");
                this.procInstantResult(),
                t && (this.box.value = i[0].innerHTML.replace(/<\/?[^>]*>/g, ""));
                for (var s = 0; s < i.length; ++s)
                    e.dom.addClassName(i[s], this.ITEM_HIGHLIGHT_STYLE)
            }
        },
        hlOff: function() {
            if (this.getCurNode()) {
                for (var t = this.getCurNode().getElementsByTagName("td"), i = 0; i < t.length; ++i)
                    e.dom.removeClassName(t[i], this.ITEM_HIGHLIGHT_STYLE);
                this.procInstantResultBack()
            }
        },
        procInstantResult: function() {
            var e = this.getCurNode().innerHTML;
            if (-1 != e.indexOf("is_red")) {
                var t = document.getElementById("is_red");
                t && (t.style.color = "#fff"),
                t = document.getElementById("is_green"),
                t && (t.style.color = "#fff")
            }
        },
        procInstantResultBack: function() {
            var e = this.getCurNode().innerHTML;
            if (-1 != e.indexOf("is_red")) {
                var t = document.getElementById("is_red");
                t && (t.style.color = "#c60a00"),
                t = document.getElementById("is_green"),
                t && (t.style.color = "#008000")
            }
        },
        up: function() {
            var e = this.curNodeIdx;
            this.curNodeIdx > 0 ? (this.hlOff(),
            this.curNodeIdx = e - 1,
            this.hlOn(!0)) : 0 == this.curNodeIdx ? (this.hlOff(),
            this.curNodeIdx = e - 1,
            this.box.value = this.curUserQuery) : (this.curNodeIdx = this.size - 1,
            this.hlOn(!0))
        },
        down: function() {
            var e = this.curNodeIdx;
            this.curNodeIdx < 0 ? (this.curNodeIdx = e + 1,
            this.hlOn(!0)) : this.curNodeIdx < this.size - 1 ? (this.hlOff(),
            this.curNodeIdx = e + 1,
            this.hlOn(!0)) : (this.hlOff(),
            this.curNodeIdx = -1,
            this.box.value = this.curUserQuery)
        },
        excuteCall: function(e) {
            var t = document.createElement("script");
            t.src = e,
            t.charset = "utf-8",
            this.sptDiv.appendChild(t)
        },
        unescape: function(e) {
            return e.replace(new RegExp("&quot;","gm"), '"').replace(new RegExp("&gt;","gm"), ">").replace(new RegExp("&lt;","gm"), "<").replace(new RegExp("&amp;","gm"), "&")
        },
        escape: function(e) {
            return e.replace(new RegExp("&","gm"), "&amp;").replace(new RegExp("<","gm"), "&lt;").replace(new RegExp(">","gm"), "&gt;").replace(new RegExp('"',"gm"), "&quot;")
        },
        subLink: function(e) {
            return e.length <= 43 ? e : e.substr(e, 40) + "..."
        },
        updateCall: function(e) {
            var t = unescape(e);
            if (this.bdiv.innerHTML = t,
            this.bdiv.childNodes.length < 2)
                this.bdiv.innerHTML = "";
            else {
                var i, s = this.bdiv.getElementsByClassName("remindtt75"), n = s.length, h = 5, o = s[0].parentNode.parentNode;
                for (i = n - 1; i > h - 1; i--)
                    o.removeChild(s[i].parentNode);
                for (n = s.length,
                i = 0; n > i; i++)
                    s[i].innerHTML = s[i].innerHTML.replace(this.curUserQuery, "<span>" + this.curUserQuery + "</span>");
                var r = this.bdiv.getElementsByTagName("table")[0];
                r.style.background = "#fcfcfe",
                r.style["box-shadow"] = "0 2px 1px 1px #e6e6e6",
                r.style["padding-bottom"] = "10px",
                r.style["border-radius"] = "0 0 5px 5px"
            }
            this.onComplete()
        },
        focusBox: function() {
            if (this.box.focus(),
            this.box.createTextRange) {
                var e = this.box.createTextRange();
                e.moveStart("character", this.box.value.length),
                e.select()
            } else
                this.box.setSelectionRange && this.box.setSelectionRange(this.box.value.length, this.box.value.length)
        },
        pressPoint: function(t) {
            this.clickEnabled && (this.clickEnabled = !1,
            setTimeout(e.bind(this.enableClick, this), 20),
            this.clicklog(this.LOG_ICON_PRESS, "&q=" + this.box.value, "&visible=" + this.vis),
            this.focusBox(),
            this.vis ? this.hide() : this.lastUserQuery != this.box.value ? this.doReq() : "" == this.sdiv.innerHTML ? this.doReq() : this.show())
        },
        removeBoxBlur: function() {
            this.box.onblur = null
        },
        revertBoxBlur: function() {
            this.box.onblur = e.bind(this.hide, this)
        },
        bindATagWithMouseEvent: function(t, i) {
            try {
                if (this.hideClose && t.parentNode)
                    return void t.parentNode.removeChild(t)
            } catch (s) {}
            var n = t.getElementsByTagName("A");
            0 == n.length && (n = t.getElementsByTagName("a"));
            var h = n[0];
            i ? e.events.listen(h, "click", e.bind(this.turnOnSuggest, this)) : e.events.listen(h, "click", e.bind(this.turnOffSuggest, this)),
            e.events.listen(h, "mouseover", e.bind(this.removeBoxBlur, this)),
            e.events.listen(h, "mouseout", e.bind(this.revertBoxBlur, this))
        },
        onCompleteHint: function() {
            setTimeout(e.bind(this.showSugHint, this, arguments[0]), 5)
        },
        showSugHint: function() {
            this.sdiv.childNodes.length < 1 || this.showContent()
        },
        turnOnSuggest: function() {
            return this.clicklog(this.CHANGE_SUG_STATUS, "&s=open&q=" + this.box.value),
            this.lastUserQuery = "",
            this.initVal = this.box.value,
            this.curUserQuery = this.initVal,
            this.upDownTag = !1,
            this.vis && this.hide(),
            this.clean(),
            !1
        },
        turnOffSuggest: function() {
            return this.clicklog(this.CHANGE_SUG_STATUS, "&s=close&q=" + this.box.value),
            this.vis && this.hide(),
            this.clean(),
            !1
        },
        time: function() {
            return "&time=" + new Date
        },
        hour: function() {
            return "&h=" + (new Date).getHours()
        },
        LOG_MOUSE_SELECT: "mouseSelect",
        LOG_KEY_SELECT: "keySelect",
        LOG_ICON_PRESS: "iconPress",
        CHANGE_SUG_STATUS: "changeStatus",
        hintCode1: "<table cellpadding=0 cellspacing=1 border=0 width=100% bgcolor=#8cbbdd align=center><tr><td valign=top><table cellpadding=0 cellspacing=0 border=0 width=100% align=center><tr><td align=left bgcolor=white class='remindtt752'>",
        hintCode2: "</td></tr></table>",
        hintCode4: "</a></td></tr></table></td></tr></table>",
        REQUEST_TIMEOUT: 50,
        ITEM_INDEX: "s_index",
        ITEM_HIGHLIGHT_STYLE: "aa_highlight",
        ITEM_TYPE: "hitt",
        ITEM_QUERY: "hitq",
        ITEM_LINK: "hitl",
        QUERY_ATTR: "squery",
        KEYFROM_POST: ".suggest",
        S_QUERY_URL_POST: "/suggest.s?query=",
        S_LOG_URL_POST: "/clog.s?type=",
        defSugServ: "https://" + location.host + "/suggest/",
        defSearchServ: "http://" + document.domain + "/search?",
        defSearchParamName: "q",
        defKeyfrom: document.domain.replace(/.youdao.com/, ""),
        defSugName: "aa",
        sugCookieName: "SUG_STATUS"
    })
}(youdaos);
