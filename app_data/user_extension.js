//所有方法为了和内置方法区别, 需要以 jsfunc_ 开头

//返回当前日期
function jsfunc_date(){
    return (new Date()).toLocaleDateString();
}

//返回当前时间
function jsfunc_time(){
    return (new Date()).toLocaleTimeString();
    // return (new Date()).toLocaleDateString();
}

//返回当前日期和时间
function jsfunc_dateTime(){
    return (new Date()).toLocaleString();
}