
Date 时间对象：
   创建日期对象：
     a.不指定参数时：  var nowd1=new Date();document.write(nowd1.toLocaleString( ));
       //显示当前时间，如：2008年11月24日 星期一 19时23分21秒
       //不用"toLocaleString()"则显示： Mon Nov 24 2008 19:23:21 GMT+0800 (CST)
     b.参数为日期字符串： var nowd2=new Date("2008/3/20 11:12");alert(nowd2.toLocaleString());
       //显示： 2008年03月20日 星期六 11时12分00秒
       var nowd3=new Date("08/03/20 11:12");alert(nowd3.toLocaleString( ));
       //显示： 1920年08月03日 星期六 11时12分00秒    //按 月、日、年 的顺序
     c.参数为毫秒数：  var nowd3=new Date(5000); alert(nowd3.toLocaleString( ));
       //显示： 1970年01月01日 星期四 08时00分05秒 //显示本国的时间
       alert(nowd3.toUTCString()); //显示西方的时间： Thu, 01 Jan 1970 00:00:05 GMT
     d.参数为年月日小时分钟秒毫秒： var nowd4=new Date(2008,10,24,11,12,0,300);
       alert(nowd4.toLocaleString( )); //毫秒并不直接显示；月份参数从0~11，所以这里10对应11月份
       //显示： 2008年11月24日 星期一 11时12分00秒
   获取和设置日期、时间的方法：
       getDate()          setDate(day_of_month)       日期 (1~31)
       getDay()                                       星期 (1~7;  没set方法)
       getMonth()         setMonth (month)            月份 (0~11; 别忘加1)
       getFullYear()      setFullYear (year)          完整年份(-271820~275760)
       getYear()          setYear(year)               年 (范围同上； 1900年计算为0)
       getHours()         setHours (hour)             小时 (0~23)
       getMinutes()       setMinutes (minute)         分钟 (0~59)
       getSeconds()       setSeconds (second)         秒 (0~59)
       getMilliseconds()  setMillliseconds (ms)       毫秒(0-999)
       getTime()          setTime (allms)             累计毫秒数(从1970/1/1 00:00:00开始)
       注意：set方法对任意整数有效，影响上一级的数；如setDate(-1)设为上个月30号。 但对小数没效。
   日期和时间的转换：
       getTimezoneOffset()  返回本地时间与GMT的时间差，以分钟为单位(中国为-480；差8小时)
       toUTCString()        返回国际标准时间字符串(默认)
       toLocalString()      返回本地格式时间字符串
       Date.parse(x)        返回累计毫秒数(从1970/1/1 00:00:00到x的本地时间，忽略秒以下的数字)
       Date.UTC(x)          返回累计毫秒数(从1970/1/1 00:00:00到x的UTC时间) 不明UTC是什么


constructor:
    new Date()
    new Date("month day, year hours:minutes:seconds")
    new Date(yr_num, mo_num, day_num)
    new Date(yr_num, mo_num, day_num, hr_num, min_num, sec_num)

方法
    get[UTC]FullYear()	返回Date对象中的年份,用4位数表示,采用本地时间或世界时
    get[UTC]Year()	返回Date对象中的年份,一般不使用该方法,而使用getFullYear()
    get[UTC]Month()	返回Date对象中的月份(0~11),采用本地时间或世界时
    get[UTC]Date()	返回Date对象中的日数(1~31),采用本地时间或世界时
    get[UTC]Day	返回Date对象中的星期(0~6),采用本地时间或世界时
    get[UTC]Hours()	返回Date对象中的小时数(0~23),采用本地时间或世界时
    get[UTC]Minutes()	返回Date对象中的分钟数(0~59),采用本地时间或世界时
    get[UTC]Seconds()	返回Date对象中的秒数(0~59),采用本地时间或世界时
    get[UTC]Milliseconds()	返回Date对象中的毫秒数, 采用本地时间或世界时
    getTimezoneoffset()	返回日期 的本地时间和UTC表示之间的时差,以分钟为单位
    getTime()	返回Date对象的内部毫秒表示。注意,该值独立于时区,所以没有单独的getUTCtime()方法
    set[UTC]FullYear()	设置Date对象中的年,用4位数表示,采用本地时间或世界时
    set[UTC]Year()	设置Date对象中的年,采用本地时间或世界时
    set[UTC]Month()	设置Date对象中的月,采用本地时间或世界时
    set[UTC]Date()	设置Date对象中的日,采用本地时间或世界时
    set[UTC]Hours()	设置Date对象中的小时,采用本地时间或世界时
    set[UTC]Minutes()	设置Date对象中的分钟,采用本地时间或世界时
    set[UTC]Seconds()	设置Date对象中的秒数,采用本地时间或世界时
    set[UTC]Milliseconds()	设置Date对象中的毫秒数,采用本地时间或世界时
    setTime()	使用毫秒形式设置Date对象的各字段
    toDateStirng()	返回日期的日期部分的字符串表示,采用本地时间
    toUTCString()	将Date对象转换成一个字符串,采用世界时
    toLocaleDateString()	返回表示日期的日期部分的字符串,采用地方日期
    toLocaleTimeString()	返回日期的时间部分的字符串,采用本地时间
    toLocaleString()	返回本地时间的字符串
    toString()	将Date对象转换成一个字符串,采用本地时间
    toTimeString()	返回日期的时间部分的字符串表示,采用本地时间
    ValueOf()	将Date对象转换成它的内部毫秒表示



/************* 给 Date 额外添加函数 ************************/
/**
 * 把时间格式化成字符串
 * 月(M)、日(d)、12小时(h)、24小时(H)、分(m)、秒(s)、季度(q) 可以用 1-2 个占位符
 * 年(y)可以用 1-4 个占位符, 周(E)可以用 1-3 个占位符, 毫秒(S)只能用 1 个占位符(是 1-3 位的数字)
 * @param  {String} format 格式化的字符串(默认为：yyyy-MM-dd HH:mm:ss )
 * @return {String} 格式化时间后的字符串
 * @example alert(new Date().format("yyyy-MM-dd HH:mm:ss.S EEE")); // 显示如: "2013-01-29 17:01:13.25 星期二"
 */
Date.prototype.format = function(format) {
    // 默认显示格式
    format = format || "yyyy-MM-dd HH:mm:ss";
    var o = {
        "M{1,2}" : this.getMonth()+1, // 月份  (返回1~12,或者01~12)
        "d{1,2}" : this.getDate(), // 日期  (返回1~31,或者01~31)
        "h{1,2}" : this.getHours() % 12 == 0 ? 12 : this.getHours() % 12, // 小时  (返回1~12,或者01~12)
        "H{1,2}" : this.getHours(), // 小时  (返回1~23,或者01~23)
        "m{1,2}" : this.getMinutes(), // 分钟  (返回1~59,或者01~59)
        "s{1,2}" : this.getSeconds(), // 秒  (返回1~59,或者01~59)
        "q{1,2}" : Math.floor((this.getMonth()+3)/3), // 季度  (返回1~4,或者01~04)
        "S" : this.getMilliseconds() // millisecond  (返回1~999,或者01~99) 注意，“S”只能写一个
    }
    // 年份
    if (/([y|Y]{1,4})/.test(format)) {
        format = format.replace(RegExp.$1,(this.getFullYear()+"").substr(4 - RegExp.$1.length));
    }
    // 星期
	if (/(E{1,3})/.test(format)) {
        var week = { "0" : "\u65e5", "1" : "\u4e00", "2" : "\u4e8c", "3" : "\u4e09", "4" : "\u56db", "5" : "\u4e94", "6" : "\u516d" };
		format = format.replace(RegExp.$1, ((RegExp.$1.length >= 2) ? (RegExp.$1.length == 3 ? "\u661f\u671f" : "\u5468") : "") + week[this.getDay() + ""]);
    }
    // 其余逐个处理
    for (var k in o) {
        if (new RegExp("("+ k +")").test(format)) {
            format = format.replace(RegExp.$1, (RegExp.$1.length == 1 ? o[k] :("00"+ o[k]).substr((""+ o[k]).length)));
        }
    }
    return format;
};

/**
 * 添加时间
 * @param {Number | Object} option 要添加的时间,需key/value格式(key忽略大小写),或者int格式(表示多少毫秒)
 *  其中对应的写法为: {
 *     year : 1, // 缩写为 y, 加上多少年, 想减少1年则写 -1
 *     month : 2, // 缩写为 m, 加上多少个月
 *     date : 1,  // 缩写为 d, 加上多少天
 *     hour : 1,  // 缩写为 h, 加上多少小时
 *     minute : 1,  // 缩写为 n, 加上多少分钟
 *     seconds : 1,  // 缩写为 s, 加上多少秒
 *     time : 1  // 缩写为 t, 加上多少毫秒
 *  }
 * @return {Date} 返回添加后的时间(支持连缀),原时间也会被改变
 *
 * @example
 *    var d = new Date();
 *    d.add(15); // 加上15毫秒
 *    d.add({year: 2}); // 加上2年
 *    d.add({y:2, d:3}); // 加上2年零3天
 */
Date.prototype.add = function(option) {
    var o = this;
    // 数值类型的参数
    if (typeof option == 'number') {
        return o.setTime(o.getTime() + option);
    }
    // key/value格式的参数
    for (var key in option) {
        var value = c$.toInt(option[key]); // value 需取整
        if (value == 0) continue;
        switch(key.trim().toLowerCase()) {
            case 'year':
            case 'y':
                o.setUTCFullYear(o.getUTCFullYear() + value); break;
            case 'month':
            case 'm':
                o.setUTCMonth(o.getUTCMonth() + value); break;
            case 'date':
            case 'd':
                o.setUTCDate(o.getUTCDate() + value); break;
            case 'hour':
            case 'h':
                o.setUTCHours(o.getUTCHours() + value); break;
            case 'minute':
            case 'n':
                o.setUTCMinutes(o.getUTCMinutes() + value); break;
            case 'seconds':
            case 's':
                o.setUTCSeconds(o.getUTCSeconds() + value); break;
            case 'time':
            case 't':
                o.setTime(o.getTime() + value); break;
            default:;
        }
    }
    return o;
};
