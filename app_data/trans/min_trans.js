function closeHandWrite() {
    document.getElementById("handWrite").style.display = "none",
    document.getElementById("hnwBtn").className = "hand-write"
}
function insertQuery(e) {
    document.getElementById("query").value += e
}
function hlgt(e) {
    $(e).addClass("highLight")
}
function unhlgt(e) {
    $(e).removeClass("highLight")
}
!function() {
    $("body").delegate("[node-type=search]", "submit", function() {
        var e = $(this)
          , t = e.find("input[name=le]").val()
          , o = encodeURIComponent(e.find("input[name=q]").val())
          , n = ["/w", "eng" == t ? "" : t, o, ""].join("/") + "#keyfrom=" + e.find("input[name=keyfrom]").val();
        return n = n.replace(/\/+/g, "/"),
        o ? (location.href = n,
        !1) : (location.href = "/",
        !1)
    })
}(),
function(e) {
    for (var t = 4, o = document.createElement("div"), n = o.getElementsByTagName("i"); o.innerHTML = "<!--[if gt IE " + ++t + "]><i></i><![endif]-->",
    n[0]; )
        ;
    o = n = null;
    var i = t > 5;
    e.browser = {
        msie: i,
        version: t
    }
}(jQuery),
function(e) {
    e.fn.extend({
        hasMenu: function(t, o, n, i) {
            var a = e(t)
              , r = e(o)
              , s = this;
            return e("body").click(function() {
                r.hide()
            }),
            this.click(function() {
                var o = e(this).offset();
                return r.each(function() {
                    "#" + e(this).attr("id") != t && e(this).hide()
                }),
                e(this).blur(),
                a.css({
                    left: o.left + n,
                    top: o.top + i
                }).toggle(),
                !1
            }),
            function(o) {
                e(window).unbind("resize.resetPos" + t),
                e(window).on("resize.resetPos" + t, function() {
                    if (e(t).size() > 0 && o) {
                        var i = o.offset();
                        i && e(t).css({
                            left: i.left + n
                        })
                    }
                })
            }(s),
            this
        },
        hasMenu2: function(t, o, n, i) {
            var a = e(o)
              , r = e(n)
              , s = e(t);
            return null == a || null == r || null == s ? this : (e("body").click(function() {
                s.removeClass("un_box_on"),
                r.hide()
            }),
            this.click(function() {
                var t = e(this);
                t.hasClass("un_box_on") ? t.removeClass("un_box_on") : t.addClass("un_box_on");
                var n = t.width();
                return e.isFunction(i) && i(),
                r.each(function() {
                    "#" + e(this).attr("id") != o && e(this).hide()
                }),
                e(this).blur(),
                a.css({
                    width: n - 4
                }).toggle(),
                !1
            }),
            this)
        },
        hasSubMenu: function(t, o, n) {
            return n = n || function() {}
            ,
            this.each(function() {
                var i = e(this)
                  , a = e(this).find(t);
                a.css("cursor", "pointer").click(function(e) {
                    i.toggleClass(o),
                    a.blur(),
                    n(),
                    e.preventDefault()
                })
            }),
            this
        },
        hasTab: function(t, o, n, i, a) {
            return this.each(function() {
                var r = e(this).find(t)
                  , s = e(this).find("a[class=tab-current]")
                  , c = 0;
                if (s.length > 0)
                    c = r.index(s);
                else if ("string" == typeof i) {
                    var l = e(this).find("a[rel=" + i + "]");
                    l.length > 0 && (c = r.index(l))
                } else
                    c = i;
                var d = r.eq(c).addClass(n);
                r.eq(c).attr("rel");
                var u = e(this).find(o).hide();
                e(r.eq(c).attr("rel")).show(),
                r.click(function() {
                    d.removeClass(n),
                    u.hide();
                    var t = e(this).addClass(n);
                    d = t,
                    e(t.attr("rel")).show(),
                    e(this).parent().siblings(".toggleClose").click(),
                    t.blur(),
                    e.isFunction(a) && a(this)
                })
            }),
            this
        },
        isVideo: function() {
            var t = function(t) {
                var o = '<div style="width:320px;height:185px;" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" type="application/x-shockwave-flash" id="simplayer" name="simplayer" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab"><param name="movie" value="' + t + '"><param name="menu" value="false"><param name="scale" value="noScale"><param name="allowFullscreen" value="true"><param name="allowScriptAccess" value="always"><param name="bgcolor" value="#FFFFFF"><embed src="' + t + '" quality="high" bgcolor="#ffffff" width="320" height="185" name="simplayer" align="middle" play="true" loop="false" quality="high" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer"></embed></div>';
                return e(o)
            }
              , o = e(this).find(".play")
              , n = e(this).find(".close");
            o.click(function(o) {
                e("#simplayer").siblings(".close").click(),
                stopVoice(),
                e(this).hide();
                var n = document.title;
                e(this).parent().append(t(e(this).attr("href"))),
                e.fixIETitleBug(n),
                e(this).siblings(".close").show(),
                o.preventDefault()
            }),
            n.click(function(t) {
                var o = document.title;
                e("#simplayer").remove(),
                e.fixIETitleBug(o),
                e(this).siblings(".play").show(),
                e(this).hide(),
                t.preventDefault()
            })
        }
    }),
    e.extend({
        toggle: function() {
            e(".toggle").click(function() {
                return e(this).attr("class").indexOf("toggleOpen") < 0 ? (e(this).removeClass("toggleClose").addClass("toggleOpen"),
                e(e(this).attr("rel")).show()) : (e(this).removeClass("toggleOpen").addClass("toggleClose"),
                e(e(this).attr("rel")).hide()),
                !1
            })
        },
        tabLink: function(t, o) {
            var n = e(t);
            n.click(function() {
                return e.isFunction(o) && o(this),
                !1
            })
        },
        stringFormat: function() {
            var t = '{"' + arguments[0].replace(/&/g, '","').replace(/\=/g, '":"') + '"}'
              , o = e.parseJSON(t)
              , n = decodeURIComponent(o.q.replace(/\+/g, " "));
            void 0 !== o.le && "" !== o.le || (o.le = "eng");
            var i = o.le
              , a = o.keyfrom;
            return {
                le: i,
                keyfrom: a,
                query: n
            }
        },
        fixIETitleBug: function(e) {}
    })
}(jQuery),
function(e, t) {
    e(function() {
        setTimeout(function() {
            t.setJSReady()
        }, 200);
        var o = !!document.createElement("audio").canPlayType && document.createElement("audio").canPlayType("audio/mpeg") && !e("html").hasClass("ua-linux") && navigator.userAgent.indexOf("Maxthon") < 0
          , n = "dictVoice.swf?onload=swfLoad&time=" + e.now()
          , i = e(o ? '<audio id="dictVoice" style="display: none"></audio>' : '<object width="1" height= "1" type="application/x-shockwave-flash" id="dictVoice" wmode="transparent" data="' + n + '"><param name="src" value="' + n + '"/><param name="quality" value="high"/><param name="allowScriptAccess" value="always"><param name="wmode" value="transparent" /></object>');
        i.appendTo("body");
        var a = i.get(0);
        i.play = function() {
            var t = function(e) {
                var t = e;
                return e.indexOf("http://dict.youdao.com/") < 0 && (t = location.protocol + "//dict.youdao.com/dictvoice?audio=" + e),
                t
            }
              , n = function() {
                var e = arguments[0];
                i.attr("src", t(e)),
                a.play()
            }
              , r = function() {
                var o = arguments[0];
                stopVoice(),
                swfReady && (e("#simplayer").siblings(".close").click(),
                a.playVoice(t(o)))
            };
            return o ? n : r
        }(),
        e("#results-contents h2 a.voice-js").on("mouseenter", function(t) {
            i.play(e(this).data("rel")),
            t.preventDefault()
        }),
        e("a.voice-js,a.humanvoice-js").on("click", function(t) {
            i.play(e(this).data("rel")),
            t.preventDefault()
        }),
        window.stopVoice = function() {
            e.isFunction(a.stopVoice) && a.stopVoice(),
            e.isFunction(a.pause) && (a.pause(),
            a.currentTime > 0 && (a.currentTime = 0))
        }
    }),
    t.swfReady = !1,
    t.jsReady = !1,
    t.isContainerReady = function() {
        return jsReady
    }
    ,
    t.setSWFIsReady = function() {
        swfReady = !0
    }
    ,
    t.setJSReady = function() {
        jsReady = !0
    }
}(jQuery, window),
function(e) {
    function t(e, t) {
        for (var o = null == t ? window : t, n = e.split("."), i = 0; i < n.length; i++)
            o[n[i]] || (o[n[i]] = {}),
            o = o[n[i]];
        return o
    }
    t("dict.dU");
    var o = {
        ns: t,
        Drawer: function(e) {
            this.id = e
        },
        CheckData: function(e) {
            this.configSet = e,
            this.config()
        },
        tab: function() {
            var t = {}
              , n = function(e, t) {
                this.tabsContainer = e,
                this.afterSelected = t,
                this.bind()
            };
            return n.prototype = {
                constructor: n,
                defaultCallback: function(t, n) {
                    var i = t.parent().siblings("a.toggle");
                    i.hasClass("toggleOpen") || (i.addClass("toggleOpen"),
                    e(i.attr("rel")).show(),
                    o.saveToggleStatus(i));
                    var a = e(this.tabsContainer);
                    a.hasClass("dontRemember") || dict.eti.saveString(dC.curTab + "_" + a.attr("id"), t.attr("rel"))
                },
                current: function() {
                    var t = this.tabsContainer
                      , o = t + " span.tabs a"
                      , n = dict.eti.loadString(dC.curTab + "_" + e(t).attr("id"))
                      , i = 0 == e(t + " a[rel='" + n + "']").length ? e(o).eq(0).attr("rel") : n;
                    void 0 !== i && (e(t + " a[rel='" + i + "']").addClass("tab-current"),
                    e(i).addClass("current-content"),
                    0 === e(o + ".tab-current").size() && (e(o).eq(0).addClass("tab-current"),
                    e(e(o).eq(0).attr("rel")).addClass("current-content")))
                },
                bind: function() {
                    var t, o, n, i, a = this.tabsContainer + " span.tabs a", r = this;
                    e("#deskdict_main").delegate(a, "click", function() {
                        t = e(a + ".tab-current"),
                        o = e(t.attr("rel")),
                        n = e(this),
                        i = e(n.attr("rel")),
                        o.removeClass("current-content"),
                        t.removeClass("tab-current"),
                        n.addClass("tab-current"),
                        i.addClass("current-content"),
                        e.isFunction(r.afterSelected) && r.afterSelected(n, i),
                        r.defaultCallback(n, i)
                    })
                }
            },
            {
                bind: function(e, o) {
                    for (var i = e.split(","), a = 0; a < i.length; a += 1)
                        t[i[a]] = new n(i[a],o[i[a]])
                },
                getTab: function(e) {
                    return t[e]
                },
                currents: function() {
                    for (var e in t)
                        t.hasOwnProperty(e) && t[e].current()
                }
            }
        }(),
        collapse: function(t, o, n) {
            e("#deskdict_main").delegate(t + " " + o, "click", function(o) {
                e(this).closest(t).toggleClass(n),
                e(this).blur(),
                o.preventDefault()
            })
        },
        toggle: function() {
            e("#deskdict_main").delegate("a.toggle", "click", function() {
                return e(this).toggleClass("toggleOpen"),
                e(e(this).attr("rel")).toggle(),
                !1
            })
        },
        swfObject: function(e) {
            return '<div style="width:320px;height:185px;" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" type="application/x-shockwave-flash" id="simplayer" name="simplayer" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab"><param name="movie" value="' + e + '"><param name="menu" value="false"><param name="scale" value="noScale"><param name="allowFullscreen" value="true"><param name="allowScriptAccess" value="always"><param name="bgcolor" value="#FFFFFF"><embed  src="' + e + '" quality="high" bgcolor="#ffffff" width="320" height="185" name="simplayer" align="middle" play="true" loop="false" quality="high" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer"></embed></div>'
        },
        timerProxy: function() {
            var t = function() {
                window.timerProxyTimeout && window.clearTimeout(window.timerProxyTimeout)
            };
            return function n(i, a) {
                o.timerProxy.clearProxy = n.clearProxy = t,
                t(),
                window.timerProxyTimeout = window.setTimeout(function() {
                    e.isFunction(i) && i()
                }, a)
            }
        }(),
        getScrollTop: function() {
            return document.documentElement.scrollTop + document.body.scrollTop
        },
        resetPosAndTextSelect: function() {
            document.documentElement.scrollTop = 0,
            document.selection.empty()
        },
        loadJs: function(t, o) {
            var n = document.head || document.getElementsByTagName("head")[0] || document.documentElement
              , i = document.createElement("script");
            i.setAttribute("type", "text/javascript"),
            i.setAttribute("src", t),
            i.setAttribute("charset", "utf-8");
            var a = !1;
            i.onload = i.onreadystatechange = function() {
                a || this.readyState && "loaded" !== this.readyState && "complete" !== this.readyState || (e.isFunction(o.successFunc) && o.successFunc(),
                i.onload = i.onreadystatechange = null,
                n && i.parentNode && n.removeChild(i),
                i = null,
                a = !0)
            }
            ,
            i.onerror = function() {
                e.isFunction(o.errorFunc) && o.errorFunc()
            }
            ,
            n.insertBefore(i, n.firstChild)
        },
        check: function() {
            var t = {
                mobile: /^0*(13|15|18)(\d{9}|\d-\d{3}-\d{5}|\d-\d{4}-\d{4}|\d{2}-\d{3}-\d{4}|\d{2}-\d{4}-\d{3})$/,
                phone: /^((0*\d{1,4}|\+\d{1,4}|\(\d{1,4}\))[ -]?)?(\d{2,4}[ -]?)?\d{3,4}[ -]?\d{3,4}([ -]\d{1,5})?$/,
                email: /^([a-z0-9_][a-z0-9_.-]*)?[a-z0-9_]@([a-z0-9-]+\.){0,4}([a-z0-9][a-z0-9-]{0,61})?[a-z0-9]\.[a-z]{2,6}$/i,
                qq: /^[1-9]\d{4,14}$/,
                empty: /^$/,
                "null": /.+/
            }
              , o = []
              , n = {
                or: function(e, n, i) {
                    for (var a in n)
                        if (n.hasOwnProperty(a)) {
                            var r = n[a].exec ? n[a] : t[n[a]];
                            if (r.exec(""),
                            r.exec(i))
                                return !0;
                            o.push(a)
                        }
                    return o
                },
                and: function(e, n, i) {
                    for (var a in n)
                        if (n.hasOwnProperty(a)) {
                            var r = n[a].exec ? n[a] : t[n[a]];
                            if (r.exec(""),
                            !r.exec(i))
                                return o.push(a),
                                o
                        }
                    return !0
                }
            }
              , i = function(t, o) {
                e.isFunction(o.error) ? o.error(t) : (o.elem.addClass("data-error"),
                o.elem.after(r(t, o.tagName, o.className, o.msgNum)))
            }
              , a = function(t) {
                o = [],
                e.isFunction(t.errorReset) ? t.errorReset() : (t.elem.removeClass("data-error"),
                e(t.elem.parent()).find(".error-message").remove())
            }
              , r = function(e, t, o, n) {
                n = n || 0;
                for (var i = 0; i < e.length; i += 1)
                    if (n === i + 1)
                        return "<" + (t || "span") + ' class="' + (o || "") + ' error-message">' + e[i] + "</" + (t || "span") + ">";
                return ""
            }
              , s = function(t) {
                if (0 === t.elem.size() || t.additional && t.additional())
                    return !0;
                a(t);
                var o = n[t.concat || "or"](t.elem, t.types, e.trim(t.elem.val()));
                return !e.isArray(o) || (i(o, t),
                !1)
            }
              , c = function(e) {
                for (var t = e.configs, o = 0; o < t.length; o += 1)
                    !function(e) {
                        var o = t[e];
                        o.elem.bind("change", function() {
                            s(o)
                        })
                    }(o)
            }
              , l = function(e) {
                for (var t = e.callback, o = e.configs, n = !0, i = 0; i < o.length; i += 1)
                    s(o[i]) || (n = !1);
                n && t()
            }
              , d = function(e) {
                this.configSet = e,
                this.config()
            };
            return d.prototype = {
                constructor: d,
                config: function() {
                    c(this.configSet)
                },
                run: function() {
                    l(this.configSet)
                }
            },
            function(e) {
                return new d(e)
            }
        }()
    };
    o.Drawer.prototype = {
        constructor: o.Drawer,
        toggleCatalog: function(t) {
            var o = this;
            e("#" + o.id + " .main-catalog").each(function(n) {
                "show" !== t && "hide" !== t || e("#" + o.id + " .group_" + (n + 1))[t]()
            })
        },
        setMainCatalogSelectedStatus: function(t) {
            this.toggleCatalog("hide"),
            e("#" + this.id + " .group_" + t).length > 0 ? (e(e("#" + this.id + " .main-catalog")[t - 1]).addClass("main-catalog-selected"),
            e("#" + this.id + " .group_" + t).show()) : e(e("#" + this.id + " .main-catalog")[t - 1]).addClass("main-catalog-selected")
        },
        setSubCatalogSelectedStatus: function() {
            e("#" + this.id + " .sub-catalog").each(function(t) {
                e(e(this).find("li")).removeClass("sub-catalog-selected")
            });
            for (var t = 0; t < arguments.length; t++)
                e("#" + this.id + " ." + arguments[t]).addClass("sub-catalog-selected")
        },
        openMainCatalog: function(t) {
            e("#" + this.id + " ." + t).click()
        },
        openSubCatalogs: function() {
            for (var t = 0; t < arguments.length; t++)
                e("#" + this.id + " ." + arguments[t]).click()
        },
        initMain: function(t) {
            var o = this
              , n = e("#" + o.id + " .main-catalog");
            n.each(function(i) {
                e("#" + o.id + " .group_" + (i + 1)).length > 0 && e(this).find(".lable").addClass("nav-tip"),
                e(this).click(function() {
                    n.removeClass("main-catalog-selected"),
                    e(this).addClass("main-catalog-selected"),
                    o.setMainCatalogSelectedStatus(i + 1),
                    t(this)
                })
            }),
            e("#example_navigator a").click(function(e) {
                e.preventDefault()
            }).attr("hidefocus", !0)
        },
        initSubSelected: function(t) {
            e("#" + this.id + " .sub-catalog").each(function(o) {
                var n = e(this).find("li");
                n.click(function() {
                    n.each(function() {
                        e(this).removeClass("sub-catalog-selected")
                    }),
                    e(this).addClass("sub-catalog-selected"),
                    t(this)
                })
            })
        },
        init: function(t) {
            this.toggleCatalog("hide");
            var o = e.isFunction(t.mainFn) ? t.mainFn : function() {}
              , n = e.isFunction(t.subFn) ? t.subFn : function() {}
            ;
            this.initMain(o),
            this.initSubSelected(n),
            t.main && !!t.main > 0 && this.setMainCatalogSelectedStatus(t.main),
            t.sub && this.setSubCatalogSelectedStatus(t.sub),
            0 == e(".dont_show_nav").length && e("#" + this.id).show()
        }
    },
    jQuery.fn.extend({
        placeHolder: function() {
            var t = "placeholder"in document.createElement("input")
              , o = function(e, t) {
                var o = e.css("color")
                  , n = function() {
                    e.css("color", t.color || "#999999"),
                    e.val(t.info || "例如")
                };
                n(),
                e.bind("focus.clearIt", function() {
                    e.val() === t.info && e.val("")
                }),
                e.bind("blur.restoreIt", function() {
                    "" === e.val() && n()
                }),
                e.bind("keydown", function() {
                    e.css("color", o)
                }),
                e.bind("check", function() {
                    e.css("color", o)
                })
            };
            return function(n) {
                var i = e(this);
                t ? i.attr("placeholder", n.info || "例如") : o(i, n)
            }
        }()
    }),
    function() {
        var e = function() {
            this.mudules = {},
            this.listeners = {}
        }
          , t = function(e) {
            var t = e.split(".")
              , o = {};
            return o.etype = t[0],
            2 === t.length && (o.ns = t[1]),
            o
        }
          , n = 0;
        e.prototype = {
            constructor: e,
            on: function(e, o) {
                var i = t(e)
                  , a = i.etype
                  , r = i.ns;
                "undefined" == typeof this.listeners[a] && (this.listeners[a] = {}),
                this.listeners[a]["__eidx_" + n] = o,
                o.eidx = "__eidx_" + n,
                void 0 !== r && ("undefined" == typeof this.mudules[r] && (this.mudules[r] = []),
                this.mudules[r].push("__eidx_" + n)),
                n++
            },
            un: function(e, o) {
                if ("undefined" == typeof e)
                    return this.listeners = {},
                    void (this.mudules = {});
                var n = t(e)
                  , i = n.etype
                  , a = n.ns;
                if (void 0 !== this.listeners[i])
                    for (var r = this.listeners[i], s = this.mudules[a], c = 0, l = s.length; c < l; c++)
                        r[s[c]] = null;
                o && o.eidx && (r[o.eidx] = null)
            },
            fire: function(e) {
                if ("string" == typeof e && (e = {
                    type: e
                }),
                e.target || (e.target = this),
                !e.type)
                    throw new Error("Event Object missing type property");
                if (null !== this.listeners[e.type]) {
                    var t = this.listeners[e.type];
                    for (var o in t)
                        t.hasOwnProperty(o) && null !== t[o] && t[o].call(this, e)
                }
            }
        },
        o.ke = function(t) {
            return "undefined" == typeof e[t] && (e[t] = new e(t)),
            e[t]
        }
    }(),
    function() {
        o.msg = {};
        var t, n, i = function() {
            var e, t;
            window.innerHeight && window.scrollMaxY ? (e = document.body.scrollWidth,
            t = window.innerHeight + window.scrollMaxY) : (e = Math.max(document.body.scrollWidth, document.body.offsetWidth),
            t = Math.max(document.body.scrollHeight, document.body.offsetHeight));
            var o, n;
            o = document.documentElement.clientWidth || document.body.clientWidth,
            n = document.documentElement.clientHeight || document.body.clientHeight;
            var i = Math.max(t, n)
              , a = Math.max(e, o);
            return {
                page: {
                    width: a,
                    height: i
                },
                window: {
                    width: o,
                    height: n
                }
            }
        }, a = function(t) {
            var o = e(window).height()
              , n = e(window).width()
              , i = document.body.scrollTop || document.documentElement.scrollTop
              , a = document.body.scrollLeft || document.documentElement.scrollLeft;
            t.css({
                top: (o - t.height()) / 2 + i,
                left: (n - t.width()) / 2 + a
            })
        }, r = function(t) {
            var o;
            0 === e(".light-box").size() && (o = e('<div class="light-box"></div>').appendTo("body"));
            var n = function() {
                o.css({
                    height: i().page.height,
                    width: i().page.width
                })
            };
            n();
            var r = {
                open: function() {
                    o.show(),
                    a(t),
                    t.show()
                },
                close: function() {
                    o.hide(),
                    t.fadeOut()
                }
            };
            return a(t),
            e(window).resize(function() {
                a(t),
                n()
            }),
            e(window).scroll(function() {
                n(),
                a(t)
            }),
            t.click(function(e) {
                e.stopPropagation()
            }),
            r
        };
        o.msg.msgContainer = function(o) {
            e(o).size() > 0 && (t = e(o))
        }
        ;
        var s = function(t) {
            void 0 !== t && (e(document).unbind("click.lboxClose"),
            t || e(document).bind("click.lboxClose", function(e) {
                n.close(),
                e.stopPropagation()
            }))
        };
        o.msg.open = function(o, i, a) {
            n || (n = r(t)),
            t || (t = e('<div class="message-container"></div>').appendTo("body")),
            window.msg.updateMsg(o, i, a),
            n.open()
        }
        ,
        o.msg.updateMsg = function(o, n, i) {
            "undefined" != typeof o && o.size ? (t.empty(),
            t.append(o)) : "string" == typeof o && (t.empty(),
            t.html(o)),
            e.isFunction(o) && (n = o),
            "boolean" == typeof o && (i = o),
            "boolean" == typeof n && (i = n),
            e.isFunction(n) && n(t),
            "boolean" == typeof i && s(i)
        }
        ,
        o.msg.closeMsg = function() {
            n.close()
        }
    }(),
    dict.dU = o
}(jQuery),
function() {
    $(function() {
        e()
    });
    var e = function() {
        $("body").click(function() {
            $("#hnwBtn").removeClass("hnw_btn_on")
        }),
        $(".mn").click(function() {
            $("#hnwBtn").removeClass("hnw_btn_on")
        }),
        $("#hnwBtn").hover(function() {
            $(this).addClass("hnw_btn_hover")
        }, function() {
            $(this).removeClass("hnw_btn_hover")
        }),
        $("#hnwBtn").click(function() {
            $(this).toggleClass("hnw_btn_on")
        }),
        $("#hnwBtn").hasMenu("#handWrite", ".pm", -8, 31),
        $(window).resize(function() {
            $("#handWrite").css("left", $("#hnwBtn").offset().left + -8)
        })
    }
}(),
function(e) {
    e(function() {
        e("#query").focus(),
        t(),
        o()
    });
    var t = function() {
        e("#uname").hasMenu2("#uname", ".dm", ".dm")
    }
      , o = function() {
        e("#nav .product-js,#nv .product-js").click(function() {
            this.href = "http://" + e(this).data("product") + "." + global.fromVm.searchDomain + "/";
            var t = e("#query").val()
              , o = void 0 === e(this).data("trans") ? "search?q=" : e(this).data("trans");
            "" != t && (t = t.replace(/(^link:)|(^inlink:)|(^related:)|(^lj:)/, ""),
            this.href += o + encodeURIComponent(t) + "&keyfrom=dict.top")
        })
    }
}(jQuery),
jQuery.cookie = function(e, t, o) {
    if ("undefined" == typeof t) {
        var n = null;
        if (document.cookie && "" != document.cookie)
            for (var i = document.cookie.split(";"), a = 0; a < i.length; a++) {
                var r = jQuery.trim(i[a]);
                if (r.substring(0, e.length + 1) == e + "=") {
                    n = decodeURIComponent(r.substring(e.length + 1));
                    break
                }
            }
        return n
    }
    o = o || {},
    null === t && (t = "",
    o.expires = -1);
    var s = "";
    if (o.expires && ("number" == typeof o.expires || o.expires.toUTCString)) {
        var c;
        "number" == typeof o.expires ? (c = new Date,
        c.setTime(c.getTime() + 24 * o.expires * 60 * 60 * 1e3)) : c = o.expires,
        s = "; expires=" + c.toUTCString()
    }
    var l = o.path ? "; path=" + o.path : ""
      , d = o.domain ? "; domain=" + o.domain : ""
      , u = o.secure ? "; secure" : "";
    document.cookie = [e, "=", encodeURIComponent(t), s, l, d, u].join("")
}
,
function() {
    $(function() {
        t(),
        e()
    });
    var e = function() {
        $("body").click(function() {
            $("#langSelector .aca").removeClass("aca_btn_on")
        }),
        $("#langSelector .aca").click(function() {
            $(this).toggleClass("aca_btn_on")
        }),
        $("#langSelector").hasMenu("#langSelection", ".pm", 0, 42),
        $("#langSelection a").each(function() {
            var e = $(this);
            e.attr("rel") == $("#le").attr("value") && e.addClass("current"),
            e.click(function() {
                return $("#langSelection .current").removeClass("current"),
                e.addClass("current"),
                $("#le").attr("value", e.attr("rel")),
                $("#langText").text(e.text()),
                "" != $("#query").val() ? $("#f").submit() : void 0,
                $("#langSelection").hide(),
                $("#langSelector .aca").removeClass("aca_btn_on"),
                !1
            })
        })
    }
      , t = function() {
        youdaos && youdaos.events.listen(window, "load", function() {
            form = new youdaos.Autocomplete("query","form","","","","","le"),
            form.setSearchServer("http://" + window.location.host + "/w/"),
            form.setSugServer("https://dsuggest.ydstatic.com"),
            form.submitForm("form"),
            form.setKeyFrom("dict2.top"),
            form.setOffset(-10, 17)
        })
    }
}(),
function() {
    var e = $(".c-topbar-wrapper")
      , t = $(".c-topbar")
      , o = $(window);
    o.scroll(function(n) {
        o.scrollTop() > 53 ? (e.addClass("setTop"),
        t.addClass("setTop")) : (e.removeClass("setTop"),
        t.removeClass("setTop"))
    })
}(),
function(e) {
    var t = function() {
        var t = navigator.userAgent.toLowerCase()
          , o = /360se/.test(t)
          , n = /tencenttraveler/.test(t)
          , i = /se\s\S+\smetasr\s\d+\.\d+/.test(t)
          , a = /maxthon/.test(t);
        if (e.browser.msie) {
            var r = parseInt(e.browser.version);
            return (6 === r || 7 === r || 8 === r) && !(o || a || i || n)
        }
    }
      , o = function() {
        return e('<div id="chromeBox" class="chromeBox"><div class="chromeWrap"><a id="no-remind" class="no-remind log-js" data-4log="noRemind" rel="nofollow" hidefocus="true">不再提醒</a><span class="tips"><span class="chromeExploreTip">有道提示：</span>为获得更好的查词体验，请使用快速稳定的Google Chrome浏览器！<a class="toUse log-js" data-4log="gotoChrome" rel="nofollow" hidefocus="true" href="http://chrome.163.com/download.html?keyfrom=dict2">试试chrome浏览器</a></span></div></div>')
    }
      , n = function() {
        return e('<div id="chromeBox" class="chromeBox"><div class="chromeWrap"><a id="no-remind" class="no-remind log-js" data-4log="noRemind" rel="nofollow" hidefocus="true">X</a><span class="tips"><span class="chromeExploreTip">有道提示：</span>为获得更好的查词体验，请使用快速稳定的Google Chrome浏览器！<a class="log-js" id="todownLoad" data-4log="gotoChrome" rel="nofollow" hidefocus="true" href="http://codown.youdao.com/163chrome/a/output/ChromeSetup/ChromeSetup.exe">点击下载</a></span></div></div>')
    }
      , i = function(t) {
        e(t).remove();
        var o = window.location.hostname
          , n = {
            expires: 30,
            path: "/",
            domain: o
        };
        e.cookie("click.noRemind", "noRemind", n)
    }
      , a = function() {
        if (t() && 0 === e("#chromeBox").size() && "noRemind" !== e.cookie("click.noRemind")) {
            if (e("body").hasClass("t1"))
                var a = o()
                  , r = "45px";
            else if (e("body").hasClass("t0"))
                var a = n()
                  , r = "32px";
            e(a).animate({
                height: r
            }, 1e3, "linear").insertBefore(e("#doc")),
            e("#no-remind").click(function() {
                e(a).animate({
                    height: 0
                }, 1e3, "linear", function() {
                    i(this)
                })
            }),
            e("#todownLoad").click(function() {
                i(a)
            })
        }
    }
      , r = function() {
        var t = e("#result_navigator")
          , o = t.offset().top
          , n = "/ugc/"
          , i = n + "api/v1/clientLog"
          , a = e("#query").val();
        e(window).scroll(function() {
            var n = dict.dU.getScrollTop();
            o <= n + 91 && n - o <= e("#results").height() - t.height() ? t.stop().animate({
                top: n + 91 - o
            }, 100) : (0 === o || o > n) && t.stop().animate({
                top: 0
            }, 100)
        }),
        e(".vote-btns").on("click", "button", function(t) {
            t.preventDefault(),
            e(this).hasClass("up") ? e(this).hasClass("pressed") ? (e(this).removeClass("pressed"),
            e.post(i, {
                clientLog: "cancel_word_up",
                word: a
            })) : (e(".vote-btns .down.pressed").removeClass("pressed"),
            e(this).addClass("pressed"),
            e.post(i, {
                clientLog: "word_up",
                word: a
            })) : e(this).hasClass("pressed") ? (e(this).removeClass("pressed"),
            e.post(i, {
                clientLog: "cancel_word_down",
                word: a
            })) : (e(".vote-btns .up.pressed").removeClass("pressed"),
            e(this).addClass("pressed"),
            e.post(i, {
                clientLog: "word_down",
                word: a
            }))
        })
    };
    e("#tPETrans-type-list .p-type").on("click", function(t) {
        e("#tPETrans-all-trans>li").hide(),
        e("#tPETrans-type-list a.selected_link").removeClass("selected_link"),
        e(this).addClass("selected_link"),
        e("#tPETrans-all-trans ." + e(this).attr("rel")).show(),
        t.preventDefault()
    }),
    e(function() {
        l(),
        u(),
        s()
    });
    var s = function() {
        var t = navigator.userAgent;
        null !== t.toLowerCase().match(/chrome\/([\d.]+)/) && e("#hnw").attr("wmode", "opaque")
    }
      , c = function() {
        e("#simplayer").siblings(".close").click(),
        stopVoice()
    }
      , l = function() {
        var t = function() {
            e("#result_navigator .go-top").click(function(e) {
                window.scrollTo(0, 0),
                e.preventDefault()
            })
        }
          , o = function() {
            e("#wordGroup").hasSubMenu(".more", "more-collapse"),
            e("#wordGroup2").hasSubMenu(".more", "more-collapse"),
            e("#webPhrase").hasSubMenu(".more", "more-collapse"),
            e("#authDictTrans").hasSubMenu(".more", "more-collapse", function() {
                e(this).hasClass("more-collapse") || window.scrollTo(0, e("#authTrans").offset().top)
            }),
            e(".wt-container").hasSubMenu("div>a:not(.add-fav)", "wt-collapse"),
            e(".wt-container").hasSubMenu("div.title span", "wt-collapse"),
            e("#collinsResult .pr-container").hasSubMenu(".more", "more-collapse")
        }
          , n = function() {
            var t = window.location.hostname
              , o = {
                expires: 7,
                path: "/",
                domain: t
            };
            e("#eTransform").hasTab(".tabs a", ".tab-content", "tab-current", e.cookie("tabRecord.eTransform"), function(t) {
                e.cookie("tabRecord.eTransform", t.rel, o)
            }),
            e("#webTrans").hasTab(".tabs a", ".tab-content", "tab-current", e.cookie("tabRecord.webTrans"), function(t) {
                e.cookie("tabRecord.webTrans", t.rel, o)
            }),
            e("#examples").hasTab(".tabs a", ".tab-content", "tab-current", e.cookie("tabRecord.examples"), function(t) {
                e.cookie("tabRecord.examples", t.rel, o),
                c()
            }),
            e("#authTrans").hasTab(".tabs a", ".tab-content", "tab-current", e.cookie("tabRecord.authTrans"), function(t) {
                e.cookie("tabRecord.authTrans", t.rel, o)
            })
        }
          , i = function() {
            var t = function() {
                var e = window.location;
                return e.protocol + "//" + e.host + e.pathname + e.search
            }
              , o = function(t) {
                var o = e("a[name=" + t.substring(1) + "]")
                  , n = e(t)
                  , i = 0;
                o.length > 0 ? i = o.offset().top : n.length > 0 && (i = n.offset().top),
                window.scrollTo(0, i)
            };
            return function() {
                e("a.nav-js").click(function(n) {
                    var i = e(this).attr("href");
                    i && (i = i.replace(t(), ""),
                    i.length >= 2 && "#" === i.substring(0, 1) ? o(i) : "#" === i && window.scrollTo(0, 0)),
                    n.preventDefault()
                })
            }
        }()
          , s = function() {
            e(".trans-js").click(function() {
                var t = e("#query").val()
                  , o = void 0 === e(this).data("trans") ? "search?q=" : e(this).data("trans");
                "" !== t && (t = t.replace(/(^link:)|(^inlink:)|(^related:)|(^lj:)/, ""),
                this.href += o + encodeURIComponent(t) + "&keyfrom=dict.top")
            })
        }
          , l = function(t, o, n, i) {
            var a = "";
            switch (t) {
            case "logo":
                a = "https://shared.ydstatic.com/dsp_website/webdict/ad_dict_web_test.html?time=" + +new Date;
                break;
            case "text":
                a = "https://impservice.youdao.com/imp/request.s?req=https%3A%2F%2Fdict.youdao.com&doctype=dws&syndid=57&posid=0&memberid=110636&tn=text_250_320&width=250&height=320&ref2=https://dict.youdao.com/&time=" + +new Date;
                break;
            case "banner":
                a = "https://shared.ydstatic.com/dsp_website/webdict/ad_dict_web_top.html?req=https%3A%2F%2Fdict.youdao.com&doctype=dw&memberid=110636&tn=text_960_60&width=960&height=60&posid=202&ref2=https://dict.youdao.com&syndid=57&time=" + +new Date
            }
            e("#" + o).html('<iframe src="' + a + '"width="' + n + '" height="' + i + '" frameborder="no" border="0" marginwidth="0" marginheight="0" scrolling="no"> </iframe>')
        }
          , u = function() {
            l("logo", "baidu-adv", 250, 250),
            l("banner", "topImgAd", 960, 60),
            l("text", "dict-adv", 250, 320),
            document.domain = "youdao.com"
        };
        return function() {
            window.scrollTo(0, 0),
            r(),
            t(),
            c(),
            h(),
            o(),
            n(),
            i(),
            f(),
            s(),
            d(),
            e.toggle(),
            u(),
            a()
        }
    }()
      , d = function() {
        var t = encodeURIComponent(e.trim(e("#results h2 .keyword").text()))
          , o = function() {
            var t = decodeURIComponent(window.location.search).replace(/^.*\?/, "")
              , o = '{"' + t.replace(/&/g, '","').replace(/=/g, '":"') + '"}'
              , n = {};
            o.q ? n = o ? e.parseJSON(o) : {} : n.q = e(".keyword").text(),
            n.q = n.q || location.pathname.match(/\/([^\/]*)\/$/)[1];
            decodeURIComponent(n.q.replace(/\+/g, " "));
            return void 0 !== n.le && "" !== n.le || (n.le = "eng"),
            n
        }
          , n = function(t) {
            var o = e('<div id="login_notice_box" style="padding:10px 10px;position:absolute;left:280px;top:122px;background:#ffff99;font-size:12px;z-index:1000000;"></div>')
              , n = e(t).offset();
            /wordbook/.test(t) ? o.html('登录后，生词与PC版、手机版词典同步，随时随地背单词 <a href="http://dict.youdao.com/wordbook/wordlist?keyfrom=notice">登录</a>') : (o.html('登录后，可以提交您的修改 <a href="http://account.youdao.com/login?service=dict&back_url=' + location.href + '" >登录</a>'),
            n.left += 15,
            n.top -= 5),
            e("#login_notice_box").size() ? (e("#login_notice_box").css({
                left: 25 + n.left + "px",
                top: -6 + n.top + "px"
            }),
            e("#login_notice_box").show(),
            setTimeout(function() {
                e("#login_notice_box").hide()
            }, 2500)) : (e("body").append(o),
            e("#login_notice_box").css({
                left: 25 + n.left + "px",
                top: -6 + n.top + "px"
            }),
            e("#login_notice_box").show(),
            setTimeout(function() {
                e("#login_notice_box").hide()
            }, 2500))
        }
          , i = function() {
            var i = o();
            e("#wordbook").hasClass("add_to_wordbook") ? e.get("/wordbook/ajax?action=addword&q=" + t + "&date=" + (new Date).toString(), {
                le: i.le
            }, function(t) {
                "adddone" === t.message ? (e("#wordbook").attr("title", "已添加，点击编辑单词本"),
                e("#wordbook").removeClass("add_to_wordbook"),
                e("#wordbook").addClass("remove_from_wordbook")) : "nouser" === t.message && n("#wordbook")
            }) : e.get("/wordbook/ajax?action=getoneword&q=" + t + "&date=" + (new Date).toString(), function(t) {
                if ("hasword" === e(t).find("result").text()) {
                    var o = e("#wordbook").offset();
                    e("#editwordform").css({
                        display: "block",
                        top: o.top + 30 + "px"
                    }),
                    e("#wordbook-word").attr("readonly", "true").val(e(t).find("word").text()).css({
                        background: "#ccc",
                        border: "1px solid #7F9DB9"
                    }),
                    e("#wordbook-phonetic").val(e(t).find("phonetic").text()),
                    e("#wordbook-desc").val(e(t).find("trans").text()),
                    e("#wordbook-tags").val(e(t).find("tags").text()),
                    e("#tag-select-list").empty(),
                    e(t).find("tagitem").each(function() {
                        e("#tag-select-list").append("<li>" + e(this).text() + "</li>")
                    })
                } else
                    "nouser" === t.message && n("#wordbook")
            })
        };
        0 == e("#wordbook").size() && e("#results h2.wordbook-js .keyword").after(e("<a>", {
            href: "javascript:void(0);",
            id: "wordbook",
            click: i
        })),
        document.getElementById("uname") ? e.get("/wordbook/ajax?action=getoneword&q=" + t + "&date=" + (new Date).toString(), function(t) {
            "hasword" === e(t).find("result").text() ? e("#wordbook").attr({
                "class": "remove_from_wordbook",
                title: "已添加，点击编辑单词本"
            }) : e("#wordbook").attr({
                "class": "add_to_wordbook",
                title: "未添加，点击添加到单词本"
            })
        }) : (e("#wordbook").attr({
            "class": "add_to_wordbook",
            title: "未添加，点击添加到单词本"
        }),
        e(".amend").click(function(e) {
            e.preventDefault(),
            n(".amend")
        }))
    }
      , u = function() {
        e("#delword").click(function() {
            var t = encodeURIComponent(e.trim(e("#results h2 .keyword").text()));
            e.get("/wordbook/ajax?action=delword&q=" + t + "&date=" + (new Date).toString(), function(t) {
                "1" === t.success && (e("#editwordform").css("display", "none"),
                e("#wordbook").attr("title", "未添加，点击添加到单词本"),
                e("#wordbook").removeClass("remove_from_wordbook"),
                e("#wordbook").addClass("add_to_wordbook"))
            })
        }),
        e("#addword").click(function(t) {
            t.preventDefault();
            var o = encodeURIComponent(e.trim(e("#results h2 .keyword").text()))
              , n = e("#wordbook-phonetic").val()
              , i = e("#wordbook-desc").val()
              , a = e("#wordbook-tags").val();
            e.get("/wordbook/ajax?action=addword&q=" + o + "&date=" + (new Date).toString(), {
                phonetic: n,
                trans: i,
                tags: a
            }, function(t) {
                "editdone" === t.message && (e("#editwordform").css("display", "none"),
                e("#wordbook").attr("title", "已添加，点击编辑单词本"),
                e("#wordbook").addClass("remove_from_wordbook"))
            })
        });
        var t = e("ul#tag-select-list");
        e("#close-editwordform").click(function() {
            e("#editwordform").css("display", "none")
        }),
        e("#wordbook-tags").focus(function() {
            t.css("display", "block")
        }),
        t.on("click", "li", function() {
            e("#wordbook-tags").val(e(this).text()),
            t.hide()
        }),
        t.on("mouseover", "li", function() {
            e(this).css("background", "#cccccc")
        }).on("mouseout", "li", function() {
            e(this).css("background", "none")
        }),
        e(document).bind("click", function(o) {
            var n = o.target
              , i = t.get(0);
            n === i || e(n).is("#wordbook-tags") || e.contains(i, n) || t.hide()
        })
    }
      , f = function() {
        e.tabLink("#examples tabs a", function(e) {})
    }
      , h = function() {
        e(".video").isVideo()
    };
    (function() {
        var t = {}
          , o = 20
          , n = []
          , i = 0
          , a = function(e, a) {
            t[e] = a,
            i < o ? (i += 1,
            n.push(e)) : (delete t[n.shift()],
            n.push(e))
        };
        return "" === window.location.hash && a(encodeURIComponent(window.location.search.substring(1)), e("#scontainer")),
        function(e, o) {
            return void 0 === e || void 0 === o ? void 0 !== e && void 0 === o ? t[e] || !1 : t : void a(e, o)
        }
    }
    )()
}(jQuery),
function() {
    var e = $("#result_navigator");
    e.find("a").map(function(e, t) {
        "#" === $(t).attr("href")[0] && ($(t).attr("data-href", $(t).attr("href")),
        $(t).attr("href", "javascript:void(0);"))
    }),
    e.click(function(e) {
        "A" === e.target.nodeName && $(e.target).attr("data-href") && ("#" === $(e.target).attr("data-href") ? $(window).scrollTop(0) : $(window).scrollTop($($(e.target).attr("data-href")).offset().top - 91))
    })
}(),
function() {
    $(function() {
        $(".tabs a").on("click", function() {
            var o = $(this.rel)
              , n = e(o) + "." + o.attr("id");
            t(this, n)
        }),
        $("#results .more").on("click", function() {
            var o = e($(this)) + ".more";
            t(this, o)
        }),
        $(".wt-container .do-detail").on("click", function() {
            var o = e($(this)) + ".detail";
            t(this, o)
        }),
        $(".log-js").on("click", function() {
            t(this, $(this).data("4log"))
        })
    });
    var e = function() {
        var e = function(e) {
            if ("" !== e && e.indexOf("Toggle") < 0)
                return e
        };
        return function(t) {
            return t.parentsUntil("#results").map(function() {
                return e(this.id)
            }).get().reverse().join(".")
        }
    }()
      , t = function(e, t) {
        (new Image).src = "/ctlog?q=" + $("#query").val() + "&url=" + encodeURIComponent(e.href) + "&pos=1&cfd=1&spt=1&action=CLICK&ctype=" + t
    }
}();
var docCookies = {
    getItem: function(e) {
        return unescape(document.cookie.replace(new RegExp("(?:(?:^|.*;)\\s*" + escape(e).replace(/[\-\.\+\*]/g, "\\$&") + "\\s*\\=\\s*([^;]*).*$)|^.*$"), "$1")) || null
    },
    setItem: function(e, t, o, n, i, a) {
        if (!e || /^(?:expires|max\-age|path|domain|secure)$/i.test(e))
            return !1;
        var r = "";
        if (o)
            switch (o.constructor) {
            case Number:
                r = o === 1 / 0 ? "; expires=Fri, 31 Dec 9999 23:59:59 GMT" : "; max-age=" + o;
                break;
            case String:
                r = "; expires=" + o;
                break;
            case Date:
                r = "; expires=" + o.toGMTString()
            }
        return document.cookie = escape(e) + "=" + escape(t) + r + (i ? "; domain=" + i : "") + (n ? "; path=" + n : "") + (a ? "; secure" : ""),
        !0
    },
    removeItem: function(e, t) {
        return !(!e || !this.hasItem(e)) && (document.cookie = escape(e) + "=; expires=Thu, 01 Jan 1970 00:00:00 GMT" + (t ? "; path=" + t : ""),
        !0)
    },
    hasItem: function(e) {
        return new RegExp("(?:^|;\\s*)" + escape(e).replace(/[\-\.\+\*]/g, "\\$&") + "\\s*\\=").test(document.cookie)
    },
    keys: function() {
        for (var e = document.cookie.replace(/((?:^|\s*;)[^\=]+)(?=;|$)|^\s*|\s*(?:\=[^;]*)?(?:\1|$)/g, "").split(/\s*(?:\=[^;]*)?;\s*/), t = 0; t < e.length; t++)
            e[t] = unescape(e[t]);
        return e
    }
};
"object" != typeof JSON && (JSON = {}),
function() {
    "use strict";
    function f(e) {
        return e < 10 ? "0" + e : e
    }
    function quote(e) {
        return escapable.lastIndex = 0,
        escapable.test(e) ? '"' + e.replace(escapable, function(e) {
            var t = meta[e];
            return "string" == typeof t ? t : "\\u" + ("0000" + e.charCodeAt(0).toString(16)).slice(-4)
        }) + '"' : '"' + e + '"'
    }
    function str(e, t) {
        var o, n, i, a, r, s = gap, c = t[e];
        switch (c && "object" == typeof c && "function" == typeof c.toJSON && (c = c.toJSON(e)),
        "function" == typeof rep && (c = rep.call(t, e, c)),
        typeof c) {
        case "string":
            return quote(c);
        case "number":
            return isFinite(c) ? String(c) : "null";
        case "boolean":
        case "null":
            return String(c);
        case "object":
            if (!c)
                return "null";
            if (gap += indent,
            r = [],
            "[object Array]" === Object.prototype.toString.apply(c)) {
                for (a = c.length,
                o = 0; o < a; o += 1)
                    r[o] = str(o, c) || "null";
                return i = 0 === r.length ? "[]" : gap ? "[\n" + gap + r.join(",\n" + gap) + "\n" + s + "]" : "[" + r.join(",") + "]",
                gap = s,
                i
            }
            if (rep && "object" == typeof rep)
                for (a = rep.length,
                o = 0; o < a; o += 1)
                    "string" == typeof rep[o] && (n = rep[o],
                    i = str(n, c),
                    i && r.push(quote(n) + (gap ? ": " : ":") + i));
            else
                for (n in c)
                    Object.prototype.hasOwnProperty.call(c, n) && (i = str(n, c),
                    i && r.push(quote(n) + (gap ? ": " : ":") + i));
            return i = 0 === r.length ? "{}" : gap ? "{\n" + gap + r.join(",\n" + gap) + "\n" + s + "}" : "{" + r.join(",") + "}",
            gap = s,
            i
        }
    }
    "function" != typeof Date.prototype.toJSON && (Date.prototype.toJSON = function() {
        return isFinite(this.valueOf()) ? this.getUTCFullYear() + "-" + f(this.getUTCMonth() + 1) + "-" + f(this.getUTCDate()) + "T" + f(this.getUTCHours()) + ":" + f(this.getUTCMinutes()) + ":" + f(this.getUTCSeconds()) + "Z" : null
    }
    ,
    String.prototype.toJSON = Number.prototype.toJSON = Boolean.prototype.toJSON = function() {
        return this.valueOf()
    }
    );
    var cx = /[\u0000\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g, escapable = /[\\\"\x00-\x1f\x7f-\x9f\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g, gap, indent, meta = {
        "\b": "\\b",
        "\t": "\\t",
        "\n": "\\n",
        "\f": "\\f",
        "\r": "\\r",
        '"': '\\"',
        "\\": "\\\\"
    }, rep;
    "function" != typeof JSON.stringify && (JSON.stringify = function(e, t, o) {
        var n;
        if (gap = "",
        indent = "",
        "number" == typeof o)
            for (n = 0; n < o; n += 1)
                indent += " ";
        else
            "string" == typeof o && (indent = o);
        if (rep = t,
        t && "function" != typeof t && ("object" != typeof t || "number" != typeof t.length))
            throw new Error("JSON.stringify");
        return str("", {
            "": e
        })
    }
    ),
    "function" != typeof JSON.parse && (JSON.parse = function(text, reviver) {
        function walk(e, t) {
            var o, n, i = e[t];
            if (i && "object" == typeof i)
                for (o in i)
                    Object.prototype.hasOwnProperty.call(i, o) && (n = walk(i, o),
                    void 0 !== n ? i[o] = n : delete i[o]);
            return reviver.call(e, t, i)
        }
        var j;
        if (text = String(text),
        cx.lastIndex = 0,
        cx.test(text) && (text = text.replace(cx, function(e) {
            return "\\u" + ("0000" + e.charCodeAt(0).toString(16)).slice(-4)
        })),
        /^[\],:{}\s]*$/.test(text.replace(/\\(?:["\\\/bfnrt]|u[0-9a-fA-F]{4})/g, "@").replace(/"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g, "]").replace(/(?:^|:|,)(?:\s*\[)+/g, "")))
            return j = eval("(" + text + ")"),
            "function" == typeof reviver ? walk({
                "": j
            }, "") : j;
        throw new SyntaxError("JSON.parse")
    }
    )
}(),
function(e, t, o, n) {
    function i() {
        var e = new Date(h.lastShowDate);
        return h.notShowInDays && e.setDate(e.getDate() + parseInt(h.notShowInterval, 10)),
        e < new Date((new Date).toDateString())
    }
    function a() {
        var e = u + "?req=" + h.req + "&syndid=63&memberid=635&width=" + h.width + "&height=" + h.height;
        o.ajax({
            url: e,
            dataType: "jsonp",
            jsonpCallback: "gotAdDataCallback",
            jsonp: "callback"
        })
    }
    function r(e) {
        return ['<div class="hd-ad" style="overflow:hidden;">', '<div style="display:none;position:relative;width:960px;margin:0 auto;">', '<a target="_blank" style="background:url(' + e.mimeSrc + ");" + p + '" href="' + e.link + '" target="_blank">', "</a>", '<span class="close" style="' + m + '" data-closeurl="' + e.closeUrl + '"></span>', "</div>", "</div>"].join("")
    }
    function s(e) {
        return ['<div class="hd-ad" style="overflow:hidden;">', '<div style="display:none;position:relative;width:960px;margin:0 auto;">', '<object  width="' + e.width + '" height = "' + e.height + '">', '<param name="wmode" value="transparent">', '<param name="movie" value="' + e.mimeSrc + '">', '<embed src="' + e.mimeSrc + '"  width="' + e.width + '" height = "' + e.height + '" wmode="transparent">', "</embed>", "</object>", '<a target="_blank" href="' + e.link + '" style="' + p + g + '"></a>', '<span class="close" style="' + m + '" data-closeurl="' + e.closeUrl + '"></span>', "</div>", "</div>"].join("")
    }
    function c(e) {
        var t = /(flash)|(swf)$/g.test(e.mimeType) ? s(e) : r(e)
          , n = o(t);
        n.prependTo("body"),
        n.find("div").slideDown(1e3).delay(h.showtime + 1e3).slideUp(50),
        n.find(".close").mouseover(function() {
            o(this).css("background", "url(" + f + "images/x_hover.png)")
        }).mouseout(function() {
            o(this).css("background", "url(" + f + "images/x.png)")
        }).click(function() {
            n.hide();
            var e = new Image;
            e.src = o(this).data("closeurl"),
            h.notShowInDays = !0,
            b(JSON.stringify(h))
        })
    }
    function l() {
        a()
    }
    var d = "webDict_HdAD"
      , u = "https://impservice.youdao.com/imp/request.s"
      , f = "https://shared-https.ydstatic.com/dict/v5.15/"
      , h = {
        req: "http://dict.youdao.com",
        width: 960,
        height: 240,
        showtime: 5e3,
        fadetime: 500,
        notShowInterval: 3,
        notShowInDays: !1,
        lastShowDate: new Date("11/08/2010").toDateString()
    }
      , p = ["height:" + h.height + "px", "width:" + h.width + "px", "display:block"].join(";")
      , m = ["display:block", "width:29px", "height:29px", "background:url(" + f + "images/x.png)", "position:absolute", "right:20px", "bottom:20px", "cursor:pointer", "z-index:100000"].join(";")
      , g = ["display:block", "position:absolute", "height:" + h.height + "px", "width:" + h.width + "px", "top:0", "left:0", "background:red", "opacity:0", "filter:alpha(opacity=0)"].join(";")
      , w = function(e) {
        return docCookies.getItem(e)
    }
      , v = function(e, t) {
        return docCookies.setItem(e, t)
    }
      , b = function(e) {
        v(d, e)
    };
    w(d) && "" !== w(d) ? h = JSON.parse(w(d)) : b(JSON.stringify(h));
    e.testData = '{"showTime":"3","fadeTime":"0.5","notShowInterval":"3","title":"行走的力量","desc":"行走的力量","mimeType":"swf","mimeSrc":"https://www.xiami.com/res/player/xiamiMusicPlayer_2012090701.swf","width":960,"height":240,"link":"https://youdao.com","closeUrl":"https://impservice.youdao.com/shutup/request.s?yodao_ad_id=-2798942585617907…fGj6hHFwmmOMCAq5WIKq%2FdLBl%2FWo4dtjrqBJFmzSCs32lwVglwG7nYRLRUz5Z5Hg%3D%3D"}',
    e.gotAdDataCallback = function(e) {
        c(e[0]),
        h.lastShowDate = (new Date).toDateString(),
        h.showtime = 1e3 * e[0].showTime,
        h.fadetime = 1e3 * e[0].fadeTime,
        h.notShowInterval = e[0].notShowInterval,
        b(JSON.stringify(h))
    }
    ;
    i() && l()
}(this, document, $);
var _rlog = _rlog || [];
$(function() {
    var e = function(e, t, o) {
        var n = new Date;
        n.setDate(n.getDate() + o),
        document.cookie = e + "=" + t + "; path=/;expires = " + n.toGMTString()
    }
      , t = function(e) {
        for (var t = document.cookie.split("; "), o = 0; o < t.length; o++) {
            var n = t[o].split("=");
            if (n[0] == e)
                return n[1]
        }
        return ""
    }
      , o = function(e) {
        for (var t = {
            mac: [{
                css: "down",
                rlog: "search-popup-mac-down",
                url: "http://c.youdao.com/dict/download.html?url=http://codown.youdao.com/cidian/download/MacDict_unsilent2.dmg&vendor=search-popup-mac-down"
            }, {
                css: "appstore",
                rlog: "search-popup-mac-appstore",
                url: "http://c.youdao.com/dict/download.html?url=https://itunes.apple.com/cn/app/you-dao-ci-dian/id491854842&vendor=search-popup-mac-appstore"
            }],
            win: [{
                css: "down",
                rlog: "search-popup-win-down",
                url: "http://codown.youdao.com/cidian/YoudaoDict_unsilent2.exe?vendor=unsilent2"
            }]
        }, o = ['<a href="javascript:;" data-rlog="search-popup-close-' + e + '" class="close js_close"></a>'], n = t[e], i = 0, a = n.length; i < a; i++) {
            var r = n[i];
            o.push('<a href="' + r.url + '" data-rlog="' + r.rlog + '" class="' + r.css + ' js_close" target="_blank"></a>')
        }
        return o.join("")
    }
      , n = function(e) {
        var t = '<div class="dialog-guide-download">      <s></s>      <i></i>    </div>'
          , n = $(t);
        n.addClass(e + "-download"),
        n.find("i").append(o(e)).delegate(".js_close", "click", function() {
            n.remove()
        }),
        $("body").append(n),
        _rlog.push(["_trackEvent", "search-popup-show-" + e])
    }
      , i = new Date
      , a = t("search-popup-show");
    if (i = i.getMonth() + 1 + "-" + i.getDate(),
    "-1" != a && i != a) {
        var r, s = navigator.platform.toLocaleLowerCase(), c = document.referrer;
        if (s.indexOf("mac") != -1)
            r = "mac";
        else {
            if (!/win/i.test(s))
                return;
            r = "win"
        }
        if (c.indexOf("so.com") > -1 || c.indexOf("baidu.com") > -1 || c.indexOf("sogou.com") > -1 || c.indexOf("youdao.com") > -1 || c.indexOf("haosou.com") > -1) {
            n(r);
            var l = i;
            a && (l = "-1"),
            e("search-popup-show", l, 365)
        }
    }
});
