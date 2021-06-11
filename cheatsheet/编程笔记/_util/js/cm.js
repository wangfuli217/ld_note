/**
 * <P> Title: JavaScript Util                        </P>
 * <P> Description: JavaScript 工具                  </P>
 * <P> Modify: 2013/02/08                            </P>
 * @author 冯万里
 * @version 1.0
 *
 * 为减少 js 关键词的占用,此文件只占用“c$”一个关键词;
 * 使用时用: c$.函数名(参数列表); 或者 c$().函数名(参数列表)
 * 字符串操作函数、日期操作函数、数组操作函数等,直接增加到 String、Date、Array 类里面,便于直接使用
 * 注意: Array 数组、 Function 函数 的原型链慎用 prototype 。 Array 改变后会导致 for each 遍历出错, Function 会影响所有执行的函数。
 */
(function(window, undefined) {

var document = window.document,
	navigator = window.navigator,
	location = window.location;

/**
 * 获取元素,或者在DOM加载完成时执行某函数
 * @param  {String | Function} arg 此参数为字符串时,认为是 c$.getElement 的缩写,用来获取元素。用法参考 c$.getElement
 *          如果 arg 是 function 则认为是 c$.ready 的缩写,在dom加载完成时执行。没有此参数则返回 c$ 对象。
 * @param  {HTMLElement} dom 需要选择的DOM对象,默认是 window.document
 * @return {Object | HTMLElement | Array[HTMLElement]} arg参数为空或者是函数时返回 c$ 对象，arg参数是字符串时返回查询的元素。
 *
 * @example
 *  c$("mytext")  // 返回 id 或者 name 为"mytext"的元素
 *  c$("#mytext") // 返回 id 为"mytext"的元素
 *  c$("@mytext") // 返回 name 为"mytext"的所有元素
 *  c$(".class1") // 返回 class 为"class1"的所有元素
 *  c$("$div")    // 返回 标签 为"div"的所有元素
 *  c$("$div #text1")  // 返回 div 标签里面 id 为"text1"的元素(支持多级查询，以空格分隔)
 *  c$(function(){alert('执行DOM加载完成事件');}); // 为 c$.ready(fun) 的缩写
 *
 *  c$.函数名(参数列表)    // 调用这工具类里面的函数
 *  c$().函数名(参数列表)  // 调用这工具类里面的函数
 */
c$ = window.c$ = function(arg, dom) {
    // 如果没有参数，则返回 本对象；让程序可以这样写： c$().函数名(参数列表)
    if (arguments.length == 0) return c$;
    if (typeof arg == 'function') return c$.ready(arg);
    // 有参数则调用获取元素的函数,为 c$.getElement 的缩写
    return c$.getElement(arg, dom);
};

/**
 * 这是错误调试程序
 * 当页面发生错误时，提示错误讯息；仅测试环境里会提示，正式环境下不提示错误。
 * 注意：仅IE、fiefox有效,w3c标准里面没有此定义, chrome、opera 和 safari 浏览器不支持此事件
 */
window.onerror = function(msg, url, sLine) {
    var hostUrl = window.location.href;
    // 判断网址,测试时可以提示出错信息;正式发布时不提示
    if (hostUrl.indexOf("http://localhost") === 0 || hostUrl.indexOf("http://127.0.0.1") === 0 ||
        hostUrl.indexOf("http://192.168.") === 0 || hostUrl.indexOf("file://") === 0) {
        var errorMsg = "当前页面的javascript发生错误.\n\n";
        errorMsg += "错误: " + msg + "\n";   // 出错信息
        errorMsg += "URL: " + url + "\n";    // 出错文件的地址
        errorMsg += "行: " + sLine + "\n\n"; // 发生错误的行
        errorMsg += "点击“确定”以继续。\n\n";
        window.alert( errorMsg );
    }
    // 返回true,会消去 IE下那个恼人的“网页上有错误”的提示
    return true;
};

/* ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 * 浏览器兼容 start
 * --------------------------------------------------------------- */
/**
 * 获取浏览器类型
 * @return {Array[String(浏览器名称), String(版本)]}
 * @example if (c$.browser()[0] == 'IE') alert('这是 IE 浏览器, 版本号为:' + c$.browser()[1]);
 */
c$.browser = function() {
    var thisFun = arguments.callee;
    // 如果曾经获取过,不用再重复判断,以提高效率
    return thisFun._retValue || (thisFun._retValue = (function() {
        var ua = navigator.userAgent.toLowerCase();
        if (ua.indexOf('msie') > -1) return ['IE', ua.match(/msie ([\d.]+)/)[1]];
        if (ua.indexOf('firefox') > -1) return ['Firefox', ua.match(/firefox\/([\d.]+)/)[1]];
        if (ua.indexOf('opera') > -1) return ['Opera', ua.match(/opera.([\d.]+)/)[1]];
        if (ua.indexOf('chrome') > -1) return ['Chrome', ua.match(/chrome\/([\d.]+)/)[1]];
        if (ua.indexOf('safari') > -1) return ['Safari', ua.match(/version\/([\d.]+)/)[1]];
        return ['Other', null];
    })());
};

/**
 * 浏览器判断(注意,以下这些是值,不是函数)
 * @example
 *   if (c$.browser.isIE) alert('这是 IE 浏览器');
 *   if (c$.browser.isIE6) alert('这是 IE6 浏览器');
 *   if (c$.browser.isNav) alert('这是 Netscape 浏览器');
 *   if (c$.browser.isFF) alert('这是 Firefox 浏览器');
 *   if (c$.browser.type == 'IE') alert('这是 IE 浏览器, 版本号为:' + c$.browser.version);
 *   alert('这是 ' + c$.browser.type + ' 浏览器, 版本号为:' + c$.browser.version);
 */
// 如果是火狐等浏览器则为“true”，IE浏览器则返回“false”
c$.browser.isNav = (navigator.appName.indexOf("Netscape") != -1);
// 是否火狐
c$.browser.isFF = (navigator.userAgent.indexOf("Firefox") != -1);
// 是否IE
c$.browser.isIE = (navigator.appName.indexOf("Microsoft") != -1);
// 是否IE6
c$.browser.isIE6 = (navigator.userAgent &&
   navigator.userAgent.split(";").length >= 2 &&
   navigator.userAgent.split(";")[1].toLowerCase().indexOf("msie 6.0") != -1);
// 另一种获取浏览器类型的写法(值为字符串),值会有: IE, Firefox, Opera, Chrome, Safari, Other
c$.browser.type = c$.browser()[0];
// 浏览器的版本(值为字符串)
c$.browser.version = c$.browser()[1];


/**
 * 获取事件的 event
 * @return {Event} 事件的 event
 */
c$.getEvent = function() {
    if (c$.browser.isIE) return window.event; // IE
    var func = c$.getEvent.caller;
    while (func != null) {
        var arg0 = func.arguments[0];
        if (arg0 instanceof Event) {
            return arg0;
        }
        func = func.caller;
    }
    return null;
};

// w3c标准浏览器就FIX,让火狐等标准浏览器兼容IE的部分写法
try {
    if (!window.addEventListener) throw new Error("非标准浏览器,不再执行");
    // window.event 兼容
    if (window.constructor && window.constructor.prototype.__defineGetter__) {
        window.constructor.prototype.__defineGetter__("event", c$.getEvent);
    }
} catch(e){}
/* -------------------------------------------------------------------
 * 浏览器兼容 end
 * ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ */


/* ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 * 内置对象额外添加函数 start
 * --------------------------------------------------------------- */
/**
 * 去除字符串的前后空格
 * @return {String} 去除前后空格后的字符串
 * @example  " dd dd ".trim()  // 返回: "dd dd"
 */
String.prototype.trim = function() {
    var str = this.replace(/^\s+/, ''), // 截取开头
        end = str.length - 1,
        ws = /\s/;
    // 截取结尾(结尾用正则会比较慢)
    while (ws.test(str.charAt(end))) {
        end--;
    }
    return str.slice(0, end + 1);
    //return this.replace(new RegExp("(^[\\s　]+)|([\\s　]+$)", "g"), "");
};

/**
 * 判断是否以子串开头
 * @param  {String} sub 被判断的子串
 * @return {Boolean} 以子串开头则返回 true，否则返回false
 * @example:
 *      "abcde".startWith('ab')  // 返回: true
 *      "abcde".startWith('bc')  // 返回: false
 */
String.prototype.startWith = function(sub) {
    if (this == sub || sub == '') return true;
    return this.length >= sub.length && this.slice(0, sub.length) == sub;
};

/**
 * 判断是否以子串结尾
 * @param  {String} sub 被判断的子串
 * @return {String} 以子串结尾则返回 true，否则返回false
 * @example:
 *      "['abcde']".endWith("de")  // 返回: false
 *      "['abcde']".endWith("']")  // 返回: true
 */
String.prototype.endWith = function(sub) {
    if (this == sub || sub == '') return true;
    return this.length >= sub.length && this.slice(0 - sub.length) == sub;
};

/**
 * 字符串格式化输出
 * @param  {Object} value 格式化的对象内容(说明: 1. 属性名称区分大小写; 2. 没有匹配到到属性输出原始字符串。)
 * @return {String} 格式化后的字符串
 * @example  "#1 Name:#Name, Age:#Age".format({Name:"zhangsan", Age:23 }); // 返回："#1 Name:zhangsan, Age:23"
 */
String.prototype.format = function(value) {
    return this.replace(new RegExp('#\\w+', 'gi'), function(match) {
        var name = match.substring(1);
        return value.hasOwnProperty(name) ? value[name] : match;
    });
};

/**
 * 检查字符串是否包含有汉字、非拉丁文、字母、数字、下划线,或者指定的字符
 * @param  {String} 参数可以多个,每个参数指定一种类型或者字符,多个则是这些参数的内容都必须有
 *                  参数可以是: "chinese"(汉字,缩写"c"),"symbols"(全角符号,缩写"s"),"unicode"(非拉丁文,缩写"u"),
 *                  "number"(数字,缩写"n"),"letter"(字母,缩写"l"),"_"(下划线),指定某些字符(有正则作用)
 * @return {Boolean} 如果通过验证返回true,否则返回false (注:空字符串返回 false)
 *
 * @example
 *  "123".has("number") // 返回: true
 *  "aa哈哈".has("letter") // 返回: true
 *  "aa哈哈".has("chinese", "l") // 返回: true
 *  "aa哈哈".has("letter", "哈") // 返回: true
 *  "aa哈哈".has("chinese", "l", "n") // 因为不含有number类型, 返回: false
 */
String.prototype.has = function() {
    var length = this.length;
    if (length == 0) return false;
    for (var i = 0, len = arguments.length; i < len; i++) {
        var type = arguments[i];
        switch ((type + '').trim().toLowerCase()) {
            case 'chinese':
            case 'c': // \u4E00-\u9FA5 是汉字
                if (this.replace(new RegExp("[\u4E00-\u9FA5]",'gm'), "").length >= length) return false; break;
            case 'symbols':
            case 's': // \uFE30-\uFFA0 是全角符号
                if (this.replace(new RegExp("[\uFE30-\uFFA0]",'gm'), "").length >= length) return false; break;
            case 'unicode':
            case 'u': // 所有的非拉丁文
                if (this.replace(new RegExp("[\u0100-\uFFFF]",'gm'), "").length >= length) return false; break;
            case 'number':
            case 'n':
                if (this.replace(new RegExp("\\d",'gm'), "").length >= length) return false; break;
            case 'letter':
            case 'l':
                if (this.replace(new RegExp("[a-zA-Z]",'gm'), "").length >= length) return false; break;
            default:
                if (this.indexOf(type) == -1) return false;
        }
    }
    return true;
};

/**
 * 检查字符串是否只由汉字、非拉丁文、字母、数字、下划线,或者指定的字符(有正则作用)组成
 * @param  {String} 参数可以多个,每个参数指定一种类型或者字符,多个则表示这些参数的内容涵盖了这字符串的内容
 *                  参数可以是: "chinese"(汉字,缩写"c"),"symbols"(全角符号,缩写"s"),"unicode"(非拉丁文,缩写"u"),
 *                   "number"(数字,缩写"n"),"letter"(字母,缩写"l"),"_"(下划线),指定某些字符(有正则作用)
 * @return {Boolean} 如果通过验证返回true,否则返回false (注:空字符串返回 false)
 *
 * @example
 *  "123".is("number") // 返回: true
 *  "aa哈哈".is("letter") // 返回: false
 *  "aa哈哈".is("chinese", "l", "n") // 返回: true
 *  "aa哈哈".is("letter", "哼", "哈") // 返回: true
 */
String.prototype.is = function() {
    var reg = "";
    for (var i = 0, len = arguments.length; i < len; i++) {
        var type = arguments[i];
        switch ((type + '').trim().toLowerCase()) {
            case 'chinese':
            case 'c':
                reg += "\u4E00-\u9FA5"; break; // \u4E00-\u9FA5 是汉字
            case 'symbols':
            case 's':
                reg += "\uFE30-\uFFA0"; break; // \uFE30-\uFFA0 是全角符号
            case 'unicode':
            case 'u':
                reg += "\u0100-\uFFFF"; break; // 所有的非拉丁文
            case 'number':
            case 'n':
                reg += "0-9"; break;
            case 'letter':
            case 'l':
                reg += "a-zA-Z"; break;
            default:
                if (typeof type == 'string') reg += type;
        }
    }
    if (!reg) return false; // 没有参数时
    return new RegExp("^[" + reg + "]+$").test(this);
};

/**
 * 检查字符串是否为email地址
 * @return {Boolean} 符合返回true,否则返回false (注:空字符串返回 false)
 */
String.prototype.isEmail = function() {
    return new RegExp("^[a-z0-9][a-z0-9\\-_.]*[a-z0-9]+@(([a-z0-9]([a-z0-9]*[-_]?[a-z0-9]+)+\\.[a-z0-9]+(\\.[a-z0-9]+)?)|(([1-9]|([1-9]\\d)|(1\\d\\d)|(2([0-4]\\d|5[0-5])))\\.(([\\d]|([1-9]\\d)|(1\\d\\d)|(2([0-4]\\d|5[0-5])))\\.){2}([1-9]|([1-9]\\d)|(1\\d\\d)|(2([0-4]\\d|5[0-5])))))$",'gi').test(this.trim());
};

/**
 * 检查字符串是否为日期格式(正确格式如: 2011-03-28 或者 11/3/28, 2011年03月28日, 20111028)
 * @return {Boolean} 符合返回true,否则返回false (注:空字符串返回 false)
 */
String.prototype.isDate = function() {
    // 匹配检查
    var r = this.has("chinese") ?
        this.match(/^(\d{1,4})(年)((0?[1-9])|(1[0-2]))月((0?[1-9])|([12]\d)|(3[01]))日?$/) : // 中文处理
        this.match(/^(\d{1,4})(-|\/|\.)?((0?[1-9])|(1[0-2]))\2((0?[1-9])|([12]\d)|(3[01]))$/);
    if ( r == null ) return false;
    // 日期是否存在检查
    var d = new Date(r[1], r[3]-1, r[6]);
    return ((d.getFullYear()==r[1] || d.getYear()==r[1]) && (d.getMonth()+1)==r[3] && d.getDate()==r[6]);
};

/**
 * 检查字符串是否为时间格式(正确格式如: 13:04:06 或者 21时5分10秒, 210521)
 * @return {Boolean} 符合返回true,否则返回false (注:空字符串返回 false)
 */
String.prototype.isTime = function() {
    // 匹配检查
    var a = this.has("chinese") ?
        this.match(/^(\d{1,2})([时時])(\d{1,2})分(\d{1,2})秒(\d+([毫微纳納诺諾皮可飞飛阿托]秒)?)?$/) : // 中文处理
        this.match(/^(\d{1,2})(:)?(\d{1,2})\2(\d{1,2})([.]?\d+)?$/);
    if (a == null) return false;
    // 时间检查
    if (a[1]>=24 || a[3]>=60 || a[4]>=60) return false;
    // 如果有“:”来分隔时间,则秒后面的数也要求有“.”来分隔
    if (a[2]==':' && a[5] && a[5].indexOf('.')==-1) return false;
    // 验证成功
    return true;
};

/**
 * 检查字符串是否为日期和时间格式 (正确格式如: 2003/12/05 13:04:06 或者 2001年10月20日10时5分30秒, 20110208230406)
 * @return {Boolean} 符合返回true,否则返回false (注:空字符串返回 false)
 */
String.prototype.isDateTime = function() {
    var dateTimes = this.split(' ');
    // 中文时,可以不用空格隔开日期和时间
    if (dateTimes.length != 2 && this.indexOf('日') != -1) {
        dateTimes = this.split('日');
        dateTimes[0] += '日';
    }
    // 无符号时,可以不用空格隔开日期和时间
    if (dateTimes.length != 2 && this.indexOf(':') == -1
        && this.indexOf('-') == -1 && this.indexOf('/') == -1 && this.indexOf('.') == -1) {
        // 完整日期和时间
        if (this.length >= 14) {
            dateTimes[0] = this.substr(0, 8);
            dateTimes[1] = this.substr(8);
        }
        // 短日期和时间,认为日期部分为6位
        else {
            dateTimes[0] = this.substr(0, 6);
            dateTimes[1] = this.substr(6);
        }
    }
    // 英文时，必须空格隔开日期和时间
    if (dateTimes.length != 2) return false;
    return (dateTimes[0].isDate() && dateTimes[1].isTime());
};

/**
 * 检查字符串是否为URL地址
 * @return {Boolean} 符合返回true,否则返回false (注:空字符串返回 false)
 */
String.prototype.isUrl = function() {
    return /^(ftp|http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/.test(this);
};

/**
 * 转换字符串成 Unicode 编码
 * @return {String} 转换后的字符串
 * @example "哈,哈".toUnicode() 返回: "\u54C8\u002C\u54C8"
 */
String.prototype.toUnicode = function() {
    // 注，不会编码的字符：  *  +  -  .  /  @  _  0-9  a-z  A-Z
    return escape(this).
    // 替换中文
    replace(new RegExp('%u[0-9a-f]{4}', 'gim'), function(match) {
        return '\\' + match.substring(1);
    }).
    // 替换英文符号
    replace(new RegExp('%[0-9a-f]{2}', 'gim'), function(match) {
        return "\\u00" + match.substring(1);
    });
};

/**
 * 转换字符串成 Html 页面上显示的编码
 * @return {String} 转换后的字符串
 * @example "<div>".toHtml() 返回: "&lt;div&gt;"
 */
String.prototype.toHtml = function() {
    var div = document.createElement('div');
    var text = document.createTextNode(this);
    div.appendChild(text);
    return div.innerHTML;
};

/**
 * 转换字符串由 Html 页面上显示的编码变回正常编码(与 toHtml 函数对应)
 * @return {String} 转换后的字符串
 * @example "&nbsp;".toText() // 返回: " "
 */
String.prototype.toText = function() {
    var div = document.createElement("div");
    div.innerHTML = this;
    return div.innerText || div.textContent || '';
};

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
 *     month : 2, // 缩写为 m, 加上多少个月, 想减去多少个月则写负数
 *     date : 1,  // 缩写为 d, 加上多少天, 想减去多少天则写负数
 *     hour : 1,  // 缩写为 h, 加上多少小时, 想减去多少小时则写负数
 *     minute : 1,  // 缩写为 n, 加上多少分钟, 想减去多少分钟则写负数
 *     seconds : 1,  // 缩写为 s, 加上多少秒, 想减去多少秒则写负数
 *     time : 1  // 缩写为 t, 加上多少毫秒, 想减去多少毫秒则写负数
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

/**
 * 清空数组
 * @return {Array} 返回本数组(即清空后的情况,可以不接收返回值,原数组已经被清空)
 *
 * @example
 *  var arr = [1, 2, 3];
 *  arr.clear();
 *  alert(arr.length); // 提示为0
 *  alert(arr[0]); // 提示为 undefined
 */
Array.prototype.clear = function() {
    this.length = 0;
    return this;
};

/**
 * 查找数组里的某个值的下标(w3c标准的浏览器已经有此函数了)
 * @param  {任意类型} value 要查找的值(需完全匹配)
 * @param  {Number} startNum 查找的起始下标(默认为0)
 * @return {Number} 查找到的值的下标,有多个这样的值时返回第一个查找到的下标,找不到则返回 -1
 *
 * @example
 *  var arr = ['a', 'b', 'c'];
 *  arr.indexOf('c'); // 返回 2
 */
[].indexOf || (Array.prototype.indexOf = function(value, startNum){
	startNum = startNum || 0;
	for (var i = startNum, length = this.length; i < length; i++) {
		if (this[i] === value) return i;
    }
	return -1;
});

/**
 * 查找数组里的某个值的下标(从后面找起,w3c标准的浏览器已经有此函数了)
 * @param  {任意类型} value 要查找的值(需完全匹配)
 * @return {Number} 查找到的值的下标,有多个这样的值时返回最后一个查找到的下标,找不到则返回 -1
 *
 * @example
 *  var arr = ['a', 'b', 'c', 'd', 'c'];
 *  arr.lastIndexOf('c'); // 返回 4
 */
[].lastIndexOf || (Array.prototype.lastIndexOf = function(value, startNum) {
	startNum = startNum || this.length;
    for (var i = startNum - 1; i > 0; i--) {
        if (this[i] === value) return i;
    }
    return -1;
});

/**
 * 判断数组里是否包含此值
 * @param  {任意类型} 要查找的值, 可以有多个
 * @return {Boolean} 只有一个参数时：包含有则返回 true,没有则返回 false；有多个参数时,要求每一个参数都包含才返回 true,否则返回 false
 *  注：引用对象的判断,只是简单判断引用地址是否相等,不判断里面的值
 *
 * @example
 *  var arr = ['a', 'b', 'c'];
 *  arr.contains('c'); // 返回 true
 *  arr.contains('d'); // 返回 false
 *  arr.contains('c', 'a'); // 返回 true
 *  arr.contains('a', 'd'); // 返回 false
 */
Array.prototype.contains = function() {
    for (var i=0, len = arguments.length; i < len; i++) {
        if (this.indexOf(arguments[i]) == -1) return false;
    }
    return true;
};

/**
 * 复制数组(浅拷贝)
 * @return {Array} 返回复制后的数组
 *
 * @example
 *  var arr = ['a', 'b', 'c', 'd', 'c'];
 *  var arr2 = arr.clone(); // 返回的是另一个数组,对 arr2 的操作不再影响 arr
 */
Array.prototype.clone = function() {
    return this.slice(0);
};

/**
 * 删除数组里的某些值(删除所有找到的值)
 * @param  {任意类型} 要删除的数组里的对象,可以多个
 * @return {Array} 返回数组本身,以便使用连缀
 *
 * @example
 *  var arr = ['a', 'b', 'c', 'd', 'c'];
 *  arr.removeAll('c'); // 此时的数组删除了所有的'c', 为: ['a', 'b', 'd']
 *  arr.removeAll('a', 'd'); // 还可以同时删除多个值, 此时为: ['b']
 *  arr.removeAll('e'); // 传入数组里面没有的值,不对数组产生影响,也不会出现异常, 此时为: ['b']
 */
Array.prototype.removeAll = function() {
    var index;
    for (var i = 0; i < arguments.length; i++) {
        var value = arguments[i];
        // 赋值给 index 且判断是否大于 -1, 避免获取两次 index 以提高效率
        while ((index = this.indexOf(value)) > -1) {
            this.splice(index, 1);
        }
    }
    return this;
};
/* -------------------------------------------------------------------
 * 内置对象额外添加函数 end
 * ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ */


/**
 * 获取单选按钮对应的编号和名称
 * @param  {String} boxName 单选按钮的name (注:不能根据id来查找)
 * @param  {String} init    单选按钮的默认值
 * @return {String} 返回被选中的单选按钮的value
 */
c$.getRadioValue = function(boxName, init) {
    init = init || '';
    var elements = document.getElementsByName(boxName);
    // 如果没有找到所要的单选按钮，则直接返回
    if (!elements) return init;

    // 如果只有一个单选按钮
    if ("radio" == elements.type && elements.checked) {
        return elements.value;
    }
    // 循环检查选中哪个
    for (var i = 0, length = elements.length; i < length; i++) {
        //如果选中此单选按钮
        if ("radio" == elements[i].type && elements[i].checked) {
            return elements[i].value;
        }
    }
    return init;
};

/**
 * checkbox全选: 全部勾上 或者全部不选
 * @param  {HTMLElement | Array[HTMLElement]} checkboxList checkbox列表,可一个或者多个
 * @param  {Boolean} checked 为true则勾上，为false则全部不勾上；没有这参数则以列表的第一个的反选为准
 * @return {Object} c$ 对象本身，以支持连缀
 */
c$.selectAll = function(checkboxList, checked) {
    // 没有时选择所有的checkbox
    if (!checkboxList) {
        var inputList = document.getElementsByTagName('INPUT');
        checkboxList = [];
        for (var i = 0, length = inputList.length; i < length; i++) {
            if (inputList[i].type == "checkbox") checkboxList.push(inputList[i]);
        }
        // 没有一个checkbox时,不用再执行
        if ( checkboxList.length == 0 ) return this;
    }
    // 没有这参数时
    if ( typeof checked == 'undefined' ) {
        checked = ( "checkbox" == checkboxList.type ) ? (!checkboxList.checked) : (!checkboxList[0].checked);
    }
    // 保证 checked 为 boolean 值
    checked = !!checked;
    // 只有一个时
    if ( "checkbox" == checkboxList.type ) {
        checkboxList.checked = checked;
    }
    // 两个或者两个以上时
    else {
        for ( var i = 0, length = checkboxList.length; i < length; i++ ) {
            checkboxList[i].checked = checked;
        }
    }
    return this;
};

/**
 * 创建一个类
 * @param  {Object} arg 类里面的属性和方法,其中 init 或者 initialize 属性可作为类的初始化函数
 * @return {Object} 扩展后的类(可以不接收参数,原被扩展的类会被修改而引用不变)
 *
 * @example
 *  // 初始化类
 *  var Student = c$.create({
 *      init: function(name, age) {this.name=name; this.age=age;},
 *      show: function(){alert('name: ' + this.name + '  age:' + this.age);}
 *  });
 *  var stu1 = new Student('jack', 23); // new 一个实体类
 *  stu1.show();
 *  var stu2 = new Student('tom', 25); //  再 new 一个实体类
 *  stu2.show();
 */
c$.create = function(arg) {
    function _fun() {
        if (this.init && typeof this.init == 'function') this.init.apply(this, arguments);
        else if (this.initialize && typeof this.initialize == 'function') this.initialize.apply(this, arguments);
    }
    if (arg && typeof arg == 'object') _fun.prototype = arg;
    return _fun;
};

/**
 * 类的扩展
 * @param {Object} destination 被扩展的类
 * @param {Object} source 要扩展的内容(没有此参数则直接扩展到 c$ 类里面)
 * @param {Boolean} rewrite 是否重写属性/方法
 * @return {Object} 扩展后的类(可以不接收参数,原被扩展的类会被修改而引用不变)
 *
 * @example
 *  var a = new Object();
 *  c$.extend(a, {
 *      alertStr: function(str){alert(str);}
 *  });
 *  a.alertStr('要提示的内容'); // 调用
 */
c$.extend = function(destination, source, rewrite) {
    source = source || this;
    for (var property in source) {
        if (rewrite || null == destination[property]) {
            destination[property] = source[property];
        }
    }
    return destination;
};

/**
 * 返回某对象的复制(浅拷贝)
 * @param  {Object} 要复制的对象
 * @return {Object} 对象的复制
 */
c$.clone = function(object) {
    return c$.extend({}, object);
};

/**
 * 对象的深拷贝
 * @param {任意类型, HTMLElement除外} source 要被拷贝的对象
 * @return {输入的类型} 深拷贝后的对象
 */
c$.deepClone = function (source) {
    // typeof的值: undefined, null, boolean, number, string, object, function
    if (typeof (source) != 'object' || source.constructor == Date || source.constructor == Math || source.constructor == RegExp) {
        return source; // 不需要，或者不能拷贝的
    }

    var destination = {};
    var thisFun = arguments.callee;
    // 数组
    if (source.constructor == Array) {
        // 先浅拷贝一份
        destination = source.slice(0);
        for (var i=0, len=source.length; i < len; i++) {
            // 需要深拷贝的
            if (typeof(source[i]) == 'object') {
                destination[i] = thisFun(source[i]);
            }
        }
    }
    // object 类型
    else {
        for (var key in source) {
            destination[key] = thisFun(source[key]);
        }
    }
    return destination;
};

/**
 * 转成 int 类型
 * @param  {String | Number | 任意类型} v 需转换的字符串
 * @return {Number(int)} 数值,转换不成功则返回0
 */
c$.toInt = function(v) {
    //return (parseInt(v, 10) || 0);
    return v >> 0;
};

/**
 * 获取 form 表单的所有元素(仅 input, checkbox 等可以表单提交的元素)
 * @param  {HTMLElement} formField 表单(没有参数则是整个页面的所有 form),给出的不是 form 元素而是 div,table 之类的元素也可以
 * @return {Array[HTMLElement]} 返回一个数组,里面保存着获取的元素
 */
c$.getElements = function(formField) {
    //储存元素
    var elements = [];
    // 如果传入的是字符串,则根据此字符串获取对象
    if (typeof formField == 'string') formField = c$(formField);
    // 获取指定form的元素
    if (c$.isElement(formField)) {
        if (formField.tagName == 'FORM') {
            elements = formField.elements;
        }
        // 如果给出的不是form,而是div之类的,照样获取里面可提交的元素
        else {
            var inputs = formField.getElementsByTagName('INPUT');
            if (inputs && inputs.length > 0) {
                for (var i = 0, length = inputs.length; i < length; i++) {
                    elements.push(inputs[i]);
                }
            }
            var selects = formField.getElementsByTagName('SELECT');
            if (selects && selects.length > 0) {
                for(var i=0, length = selects.length; i<length; i++){
                    elements.push(selects[i]);
                }
            }
            var textareas = formField.getElementsByTagName('TEXTAREA');
            if (textareas && textareas.length > 0) {
                for(var i=0, length = textareas.length; i<length; i++){
                    elements.push(textareas[i]);
                }
            }
        }
    }
    // 获取form的所有元素
    else {
        var formArray = document.forms;
        for (var i = 0; i < formArray.length; i++) {
            formField = formArray[i];
            for (var j = 0, length = formField.length; j < length; j++) {
                elements.push(formField[j]);
            }
        }
    }
    // 返回元素列表
    return elements;
};

/**
 * 检查表单是否可提交
 * @param  {HTMLElement} formField 待检查的form,给出的不是 form 元素而是 div,table 之类的元素也可以
 * @param  {String} type 提示类型,有： alert(逐步提示,缩写A)、confirm(逐步判断,缩写C)、show(文字显示,缩写S,默认是show)
 *                  注: 以 alert 或者 confirm 提示信息时,只要有其中一个验证不正确则不再验证下面,直接返回 false,避免不断地alert；而show则验证完整个form
 *                  如果 type 是 show 类型,且需要指定页面显示位置,则可指定显示元素的id或者name,如: type={id:'显示元素的id', name:'显示元素的name'}
 * @return {Boolean} 检查是否通过
 *
 * @example
 *  <form action="#">
 *  <table>
 *     <tr>
 *       <td>名称：<input name="txt1" type="text" checkType="R{请输入名称}S{id:'error1'}" onchange="c$.checkElement(this)"/></td>
 *       <td id="error1">&nbsp;</td>
 *     </tr>
 *     <tr>
 *       <td>金额：<input name="txt2" type="text" checkType="S{id:'error2'}F{max:999.99, min:0, dec:2, msg:'请输入正确的金额'}" onchange="c$.checkElement(this)"/></td>
 *       <td id="error2">&nbsp;</td>
 *     </tr>
 *     <tr>
 *       <td>人数：<input name="txt3" type="text" checkType="S{id:'error3'}R{请输入人数}I{max:999, min:0, msg:'请输入正确的人数'}" onchange="c$.checkElement(this)"/></td>
 *       <td id="error3">&nbsp;</td>
 *     </tr>
 *  </table>
 *  <input type="submit" value="提交" onclick="return c$.checkForm(this.form);" />
 *  </form>
 */
c$.checkForm = function(formField, type) {
    // 类型默认是 show,
    type = type || 'show';
    // 转成小写
    type = typeof type=='string' ? type.toLowerCase() : type;

    var return_value = true;
    //元素列表
    var elements = c$.getElements(formField);

    //检查窗体的所有元素
    for (var index=0, length=elements.length; index < length; index++) {
        if (false === c$.checkElement(elements[index], type)) {
            return_value = false;
            // alert 和 confirm 验证需要中断,避免不断地提示
            if (type == 'alert' || type == 'a' || type == 'confirm' || type == 'c') return false;
        }
    }
    //检查通过
    return return_value;
};

/**
 * 检查一个元素
 * @param  {HTMLElement} element 需检查的元素
 * @param  {String} type 提示类型,有： alert(缩写A)、confirm(缩写C)、show(文字显示,缩写S,默认是show)
 *                  如果 type 是 show 类型,且需要指定页面显示位置,则可指定显示元素的id或者name,如: type={id:'显示元素的id', name:'显示元素的name'}
 * @return {Boolean} 检查通过返回true,否则返回false
 *
 * @example
 *  <input id="txt1" name='txt1' type="text" checkType="R{请输入金额}F{max:999.99, min:0, dec:2, msg:'请输入正确的金额'}" />
 *  <input type="submit" value="提交" onclick="return c$.checkElement(document.getElementById('txt1'));" />
 *
 * 说明: 检查类型的关键词需紧跟大括号,不跟大括号则提示“M”的讯息或者默认的讯息;
 * 使用“C”关键词则是选择提示框,点选“确定”可忽略此提示
 * 大括号里面的 msg 属性是对应的提示讯息,需用引号括起来; 大括号里面没有冒号则认为全是提示讯息; 注:不能嵌套大括号
 */
c$.checkElement = function(element, type) {
    //防呆
    if (!element) return true;
    // 类型默认是 show,
    type = type || 'show';
    // 转成小写
    type = typeof type=='string' ? type.toLowerCase() : type;

    //所有需检查讯息
    var message = ("" + element.getAttribute("checkType")).trim();
    if (!element.getAttribute("checkType") || !message)return true;//防呆
    //获取需检查的类型,去除大括号里面的内容
    var checkType = message.replace(new RegExp("({[^}]*})*", 'g'), "").toUpperCase();
    var value = element.value;

    //验证类型
    //必须输入 (用法: checkType="R{请输入名称}" 或者 checkType="R{msg:'请输入名称'}" 或者 checkType="M{请输入名称}R")
    var R_pos = (checkType.indexOf('R') > -1);

    //整型 (用法: checkType="I{max:100, min:-50, name:'人数'}" 或者 checkType="I{min:-50,max:100,msg:'请输入正确的人数'}")
    // 注:有 name 属性时, msg 属性将不会生效; name属性是提示讯息的名称; 属性 max, min 分别表示最大值最小值(含)
    var I_pos = (checkType.indexOf('I') > -1);

    //浮点型 (用法: checkType="F{max:999.99, min:0, dec:2, name:'金额'}" 或者 checkType="F{dec:2,max:999.99,msg:'请输入正确的金额'}")
    // 注:有 name 属性时, msg 属性将不会生效; name属性是提示讯息的名称; dec 属性表示小数字数限制; 属性 max, min 分别表示最大值最小值(含)
    var F_pos = (checkType.indexOf('F') > -1);

    //验证字母数字下划线 (用法: checkType="N{ID只能是字母,数字和下划线} 或者 checkType="N{msg:'ID只能是字母、数字和下划线',type:['chinese','letter','number','_']}")
    var N_pos = (checkType.indexOf("N") > -1);

    //验证输入长度 (用法: checkType="L{len:100, msg:'名称长度不能超过100'}")
    var L_pos = (checkType.indexOf("L") > -1);

    //验证 email (用法: checkType="@{请输入正确的邮箱地址}")
    var EMail_pos = (checkType.indexOf("@") > -1);

    //验证 日期 (用法: checkType="D{日期输入不正确}" 或者 checkType="D{msg:'日期输入不正确'}")
    var D_pos = (checkType.indexOf("D") > -1);

    //验证 时间 (用法: checkType="T{时间输入不正确}" 或者 checkType="T{msg:'时间输入不正确'}")
    var T_pos = (checkType.indexOf("T") > -1);

    //验证 日期和时间 (用法: checkType="V{时间输入不正确}" 或者 checkType="V{msg:'时间输入不正确'}")
    var V_pos = (checkType.indexOf("V") > -1);

    //验证 URL (用法: checkType="U{URL地址输入不正确}" 或者 checkType="U{msg:'URL地址输入不正确'}")
    var U_pos = (checkType.indexOf("U") > -1);

    // 共享的提示讯息,可以多个验证都提示此一个(用法: M{提示讯息})
    var M_pos = (checkType.indexOf('M') > -1);

    //确认提示框,以提示框的形式提示出来,并可以选择是否忽略此提示
    var C_pos = (checkType.indexOf('C') > -1) || type == 'confirm' || type == 'c';

    // 直接显示到页面,不使用提示框
    // 用法: 建议在函数的type参数上设值,也可以在元素上设定: checkType="R{请输入名称}S{id:'text1', name:'text1'}"  或者 checkType="SR{请输入名称}"
    // 可根据属性 id 或者 name 获取要显示的位置,不写参数则默认显示在节点的后面； 显示内容使用 .innerHTML 追加进去,红色字体显示
    var S_pos = (checkType.indexOf('S') > -1) || type == 'show' || type == 's' || !!(type.id) || !!(type.name);


    var thisFun = arguments.callee;
    /*
     * 获取所需检查的类型的类别(匿名函数,仅供此函数内部使用; 缓存此函数以减少内存消耗)
     * @param  {String} key 对应的键
     * @param  {String} message 所有需检查讯息
     * @return {Object} 所需检查的类型的类别
     */
    var getCheckTypeObj = thisFun.getCheckTypeObj = thisFun.getCheckTypeObj || function(key, message) {
        var upMess = message.toUpperCase();
        // 如果此关键词没有跟大括号,返回空类别
        if (upMess.indexOf(key + "{") < 0) return {};
        // 取出对应的大括号的讯息
        var key_mess = message.substring(upMess.indexOf(key + "{")+1);
        key_mess = key_mess.substring(0, key_mess.indexOf('}') + 1);
        try {
            // 将大括号的讯息转成的类别
            eval("var tem_obj = " + key_mess);
            return tem_obj;
        }
        catch (e) {
            // 如果大括号里面的讯息不能转成类别,则认为它全是提示讯息
            return {msg: key_mess.substring(1, key_mess.length - 1)};
        }
    };

    /*
     * 提示出对应的讯息(匿名函数,仅供此函数内部使用)
     * @param  {String} key 对应的键
     * @param  {HTMLElement} element 需检查的元素
     * @param  {String} message 所有需检查讯息
     * @param  {String} iniMess 默认的提示讯息
     * @return {Boolean} 一般都返回false,仅当显示选择框点选“是”时返回true
     */
    var showDialog = thisFun.showDialog = thisFun.showDialog || function(key, element, message, C_pos, S_pos, iniMess) {
        // 获取提示讯息
        var alert_message = (getCheckTypeObj(key, message).msg || getCheckTypeObj("M", message).msg || iniMess)  + "!";
        c$.setFocus(element);

        // "C"类型用 confirm 选择框
        if (C_pos) return confirm(alert_message);
        // "S"类型用文字显示到页面
        if (S_pos) {
            var tem_obj = getCheckTypeObj("S", message);
            // 创建一个对象来显示内容
            var font  = document.createElement('font');
            font.color = 'red';
            // 以 element 作为提示元素的标志
            font.element = element;
            font.innerHTML = alert_message;

            var showElement = null;
            if (tem_obj.id) showElement = document.getElementById(tem_obj.id);
            else if (tem_obj.name) showElement = document.getElementsByName(tem_obj.name)[0];
            else if (type.id) showElement = document.getElementById(type.id);
            else if (type.name) showElement = document.getElementsByName(type.name)[0];

            // 没有获取到显示的元素,或者设置id或者name属性时,追加到节点后面
            if (!showElement) {
                document.body.appendChild(font);
                // 插入到元素的后面
                var pos = element.nextSibling;
                pos.parentNode.insertBefore(font, pos);
            }
            else {
                showElement.appendChild(font);
                var br  = document.createElement('br');
                br.element = element;
                showElement.appendChild(br);
            }
        }
        else {
            // 使用 alert 提示出来
            alert(alert_message);
        }
        return false;
    };


    // 页面显示提示信息时,先清除页面的旧显示
    if (S_pos) {
        var tem_obj = getCheckTypeObj("S", message);
        var showElement = null;
        if (tem_obj.id) showElement = document.getElementById(tem_obj.id);
        else if (tem_obj.name) showElement = document.getElementsByName(tem_obj.name)[0];
        else if (type.id) showElement = document.getElementById(type.id);
        else if (type.name) showElement = document.getElementsByName(type.name)[0];

        // 没有获取到显示的元素,或者设置id或者name属性时,追加到节点后面
        if (!showElement) {
            var nextElement = element.nextSibling;
            if (nextElement && nextElement.tagName && nextElement.element === element) {
                nextElement.parentNode.removeChild(nextElement);
            }
        }
        else {
            var childs = showElement.childNodes;
            for (var i=0, length = childs.length; i < length; i++) {
                if (childs[i] && childs[i].tagName && childs[i].element === element) {
                    showElement.removeChild(childs[i]); // 删除 font 标签
                    showElement.removeChild(childs[i]); // 删除 br 标签
                    break;
                }
            }
        }
    }

    //一定要输入
    if (R_pos && "" === value && false === showDialog("R", element, message, C_pos, S_pos, "请输入必要的值")) {
        return false;
    }
    //可以不输入时
    else if ("" === value) {
        return true;
    }
    //验证整形
    if (I_pos) {
        var tem_obj = getCheckTypeObj("I", message);
        if (S_pos) {
            var checkResult = c$.isInt(element, tem_obj.max, tem_obj.min, tem_obj.name, false, S_pos);
            if (true !== checkResult && false === showDialog("I", element, message, C_pos, S_pos, checkResult.errMessage || "请输入正确的整数值")) return false;
        }
        else if (false === c$.isInt(element, tem_obj.max, tem_obj.min, tem_obj.name, false)) {
            //有name属性时按名称提示,这里不用重复提示; 否则取提示讯息
            if (tem_obj.name || false === showDialog("I", element, message, C_pos, S_pos, "请输入正确的整数值")) {
                return false;
            }
        }
    }
    //验证浮点型
    if (F_pos) {
        var tem_obj = getCheckTypeObj("F", message);
        if (S_pos) {
            var checkResult = c$.isNumber(element, tem_obj.max, tem_obj.min, tem_obj.dec, tem_obj.name, false, S_pos);
            if (true !== checkResult && false === showDialog("F", element, message, C_pos, S_pos, checkResult.errMessage || "请输入正确的数值")) return false;
        }
        else if (false === c$.isNumber(element, tem_obj.max, tem_obj.min, tem_obj.dec, tem_obj.name, false)) {
            //有name属性时按名称提示,这里不用重复提示; 否则取提示讯息
            if (tem_obj.name || false === showDialog("F", element, message, C_pos, S_pos, "请输入正确的数值")) {
                return false;
            }
        }
    }
    //验证输入长度
    if (L_pos) {
        var tem_obj = getCheckTypeObj("L", message);
        if (value.length > tem_obj.len && false === showDialog("L", element, message, C_pos, S_pos, "输入的内容超过长度了，请缩短内容")) {
            return false;
        }
    }
    //验证字母数字下划线组合
    if (N_pos) {
        var tem_obj = getCheckTypeObj("N", message);
        var t = tem_obj.type || ['number','letter','_'];
        if (false === ''.is.apply(value,t) && false === showDialog("N", element, message, C_pos, S_pos, "此处只能输入字母、数字和下划线")) {
            return false;
        }
    }
    //email验证
    if (EMail_pos && false === value.isEmail() && false === showDialog("@", element, message, C_pos, S_pos, "请输入正确的邮箱地址")) return false;
    //日期验证
    if (D_pos && false === value.isDate() && false === showDialog("D", element, message, C_pos, S_pos, "请输入正确的日期")) return false;
    //时间验证
    if (T_pos && false === value.isTime() && false === showDialog("T", element, message, C_pos, S_pos, "请输入正确的时间")) return false;
    //日期和时间验证
    if (V_pos && false === value.isDateTime() && false === showDialog("V", element, message, C_pos, S_pos, "请输入正确的时间")) return false;
    //URL验证
    if (U_pos && false === value.isUrl() && false === showDialog("U", element, message, C_pos, S_pos, "请输入正确的URL地址")) return false;

    //检查通过
    return true;
};

/**
 * 整数检查，判断对象是否为数字(包括负数、科学记数法、逗号分隔的数)
 * @param  {HTMLElement} element 需检查的对象,或者是字符串
 * @param  {Number} max 最大值(含), 默认为 2147483647
 * @param  {Number} min 最小值(含), 默认为 -2147483648
 * @param  {String} name 提示的讯息的名称
 * @param  {Boolean} isMust 是否可以为空,true表示不可以为空, 否则可为空
 * @param  {Boolean} isAlert 是否以alert提示出错信息,为true时返回出错信息但不提示,否则以alert提示。验证没错时,不管 isAlert 是什么值都将返回 true
 *                   注： isAlert 为false或者没有这参数时,直接 alert 提示出错信息,返回结果是 true 或 false。
 *                   但 isAlert 为true,且出错时,将返回结果对象：{result:true|false, errMessage:'出错信息'}
 * @return {Boolean} 验证符合则返回true,否则返回false
 * @example  if(c$.isInt(document.getElementById("amt"), 9999999, -9999999, "人数", flase))...
 */
c$.isInt = function(element, max, min, name, isMust, isAlert) {
    // 没有最大值时,默认为整型的最大值
    if (typeof max != 'number') {
        max = 2147483647;
    }
    // 没有最大值时,默认为整型的最大值
    if (typeof min != 'number') {
        min = -2147483648;
    }
    return c$.isNumber(element, max, min, 0, name, isMust, isAlert);
};

/**
 * 数字检查，判断对象是否为数字(包括负数、科学记数法、逗号分隔的数)
 * @param  {HTMLElement} element 需检查的对象,或者是字符串
 * @param  {Number} max 最大值(含)
 * @param  {Number} min 最小值(含)
 * @param  {Number} decimal 小数多少位
 * @param  {String} name 提示的讯息的名称
 * @param  {Boolean} isMust 是否可以为空,true表示不可以为空, 否则可为空
 * @param  {Boolean} isAlert 是否以alert提示出错信息,为true时返回出错信息但不提示,否则以alert提示。验证没错时,不管 isAlert 是什么值都将返回 true
 *                   注： isAlert 为false或者没有这参数时,直接 alert 提示出错信息,返回结果是 true 或 false。
 *                   但 isAlert 为true,且出错时,将返回结果对象：{result:true|false, errMessage:'出错信息'}
 * @return {Boolean} 验证符合则返回true,否则返回false
 *
 * @example if(c$.isNumber(document.getElementById("amt"), 9999999.999, -9999999.999, 3, "金额", flase))...
 */
c$.isNumber = function(element, max, min, decimal, name, isMust, isAlert) {
    var thisFun = arguments.callee;
    //出错时: 提示讯息,设定焦点,返回true
    var doError = thisFun.doError || (thisFun.doError = function(msg, name, element, isAlert) {
        var tem_name = name || '此项';
        msg = msg.format({ name:tem_name });
        // 有 isAlert 时不提示，但返回出错结果
        if (isAlert) return {result:false, errMessage:msg};
        // 有 name 属性时提示讯息,没有则不提示
        if (name) {
            c$.setFocus(element);
            alert(msg);
        }
        return false;
    });

    //获取字符串
    var str = element.value || element.innerHTML || "" + element;
    //去除空白; 去除逗号; 转成大写
    str = str.replace(/\s/gi, '').replace(/[,]/gi, '').toUpperCase();

    //不可以为空; 提示讯息: 请输入 name !
    if (true === isMust && "" === str) return doError("请输入 #name !", name, element, isAlert);
    //可以为空
    if (!isMust && "" === str) return true;

    //是否为数值; 提示讯息: name 不是正确的数字!
    if (!str.match(/^[+-]?\d+([.]?\d*)([eE][+-]\d+)?$/g)) return doError("#name 不是正确的数字!", name, element, isAlert);
    // 如果没有指定最大值,不可以超过数值的最大值
    if (0 !== max && !max) max = Number.MAX_VALUE;
    //判断最大值,提示讯息: name 不能大于 max
    if (parseFloat(str) > parseFloat(max)) return doError("#name 不能大于 " + max, name, element, isAlert);
    // 如果没有指定最小值,不可以小于数值的最小值
    if (0 !== min && !min) min = -1 * Number.MAX_VALUE;
    //判断最小值,提示讯息: name 不能小于 min
    if (parseFloat(str) < parseFloat(min)) return doError("#name 不能小于 " + min, name, element, isAlert);

    //小数判断
    decimal = parseInt(decimal);
    if (decimal >= 0 && (str.indexOf(".") > -1 || str.indexOf("E") > -1)) {
        //获取小数点后的数字
        var val = str.replace(/^[+-]?\d+[.]/g, '');
        val = val.replace(/0*([E][+-]\d+)?$/g, '');
        //小数长度
        var decimalLength = val.length;

        //如果是科学记算法
        if (str.indexOf("E") > -1) {
            decimalLength = val.length - parseInt(str.substring(str.indexOf("E") + 1, str.length));
        }
        // 要求整数时; 提示讯息: name 必须是整数
        if (decimal === 0 && (decimalLength > 0 || (str.indexOf(".") > -1 && str.indexOf("E") == -1))) {
            return doError("#name 必须是整数!", name, element, isAlert);
        }
        //小数位判断; 提示讯息: name 请保留 decimal 位小数
        if (decimalLength > decimal) {
            return doError("#name 请保留 " + decimal + " 位小数!", name, element, isAlert);
        }
    }
    //检验通过
    return true;
};

/**
 * 判断对象是否函数
 * 说明：因为 typeof 判断可能会把 dom 对象、正则等判断为 function，故此做严谨判断
 * @param  {Function} fn 需判断的对象
 * @return {Boolean} 是函数则为 true, 否则为 false
 */
c$.isFunction = function(fn) {
    return (!!fn && !fn.nodeName && fn.constructor != String && fn.constructor != RegExp && fn.constructor != Array && /function/i.test( fn + "" ));
};

/**
 * 判断对象是否页面元素
 * @param  {HTMLElement | 任意对象} obj 需判断的对象
 * @return {Boolean} 是页面元素则为 true, 否则为 false
 */
c$.isElement = function(obj) {
    return !!(obj && obj.nodeType == 1);
};

/**
 * 清除form里各元素的值
 * @param  {HTMLElement} form 需操作的form元素对象,默认所有form,给出的不是 form 元素而是 div,table 之类的元素也可以
 * @return {Object} c$ 对象本身，以支持连缀
 */
c$.clearForm = function(form) {
    //元素列表
    var elements = c$.getElements(form);

    // 逐个元素处理
    for (var i = 0, length = elements.length; i < length; i++) {
        var tagName = elements[i].tagName.toLowerCase();
        if (tagName == "textarea" || tagName == "select") {
            elements[i].value = "";
            continue;
        }

        // 处理 input
        // "button", "submit", "reset", "hidden", "image" 类型的不处理
        if (!elements[i].type) continue;
        var type = elements[i].type.toLowerCase();
        // 选择项
        if ("checkbox" == type || "radio" == type) elements[i].checked = false;
        // 单行输入框, 多行输入框, 下拉选单
        else if ("text" == type || "password" == type) elements[i].value = "";
        // 文件上传框
        else if ("file" == type) {
            //elements[i].value = ""; // firfox
            //elements[i].outerHTML = elements[i].outerHTML; // IE
            c$.clearFileInput(elements[i]); // 上面两行的写法也可以,只是改用这种更加好
        }
    }
    return this;
};

/**
 * 清空file的值
 * @param  {HTMLElement} file file元素
 * @return {Object} c$ 对象本身，以支持连缀
 */
c$.clearFileInput = function(file) {
    // 建立临时form来实现
    var form = document.createElement('form');
    document.body.appendChild(form);
    // 记住file在旧窗体中的地址
    var pos = file.nextSibling;
    form.appendChild(file);
    form.reset();
    pos.parentNode.insertBefore(file,pos);
    document.body.removeChild(form);
    return this;
};

/**
 * 过滤数字(不符合的不让输入)
 * @param  {Boolean} isFloat 是否允许输入一个小数点
 * @param  {Event} event 兼容 IE 和 FireFox 的事件
 * @return {Boolean} 是否符合要求
 * @example <input type="text" name="stdcost" onkeydown="return c$.inputNumber(true, event);"/>
 */
c$.inputNumber = function(isFloat, event) {
    event = event || window.event;
    // 获取事件源
    var source = event.target || event.srcElement;
    // 不允许 shift 键
    if ( event.shiftKey === true) return false;

    var keyCode = event.charCode || event.keyCode;
    // 只允许输入数字、删除、左右键; 小数时可输入一个小数点
    if ( (keyCode >= 48 && keyCode <= 57) || (keyCode >= 96 && keyCode <= 105) ||
       keyCode == 8  || keyCode == 46 || keyCode == 39 || keyCode == 37 ||
       (isFloat && (keyCode == 110 || keyCode == 190) && source.value.length>0 && source.value.indexOf(".") == -1)
    ) return true;

    return false;
};

/**
 * 过滤字母(不符合的不让输入)
 * @param  {Event} event 兼容 IE 和 FireFox 的事件
 * @return {Boolean} 是否符合要求
 * @example <input type="text" name="stdcost" onkeydown="return c$.inputLetter(event);"/>
 */
c$.inputLetter = function(event) {
    event = event || window.event;
    // 不允许 ctrl 键和 shift 键
    if ( event.ctrlKey === true || event.shiftKey === true) return false;

    var keyCode = event.charCode || event.keyCode;
    // 只允许输入字母、删除、左右键
    if ((keyCode >= 65 && keyCode <= 90) || keyCode == 8 || keyCode == 37 || keyCode == 39 || keyCode == 46) return true;

    return false;
};

/**
 * 过滤字母数字(不符合的不让输入)
 * @param  {Event} event 兼容 IE 和 FireFox 的事件
 * @return {Boolean} 是否符合要求
 * @example <input type="text" name="stdcost" onkeydown="return c$.inputNumLetter(event);"/>
 */
c$.inputNumLetter = function(event) {
    event = event || window.event;
    // 不允许 ctrl 键和 shift 键
    if ( event.ctrlKey === true || event.shiftKey === true) return false;

    var keyCode = event.charCode || event.keyCode;
    // 只允许输入字母、数字、删除、左右键
    if ((keyCode >= 65 && keyCode <= 90) ||
        (keyCode >= 96 && keyCode <= 105) || (keyCode >= 48 && keyCode <= 57) ||
        keyCode == 8 || keyCode == 37 || keyCode == 39 || keyCode == 46
    ) return true;

    return false;
};

/**
 * 设定按钮是否可用
 * @param  {Boolean} isDisabled 是否不可用,true为不可用，false为可用(默认可用)
 * @param  {HTMLElement} dom Dom对象，默认是 document
 * @return {Object} c$ 对象本身，以支持连缀
 *
 * @example
 *  c$.setButtonUsed(true);  // 设置页面上所有的按钮都不可用
 *  c$.setButtonUsed();  // 恢复页面上所有的按钮都可用
 */
c$.setButtonUsed = function(isDisabled, dom) {
    isDisabled = isDisabled || false;
    dom = dom || document;

    //INPUT对象
    var obj = dom.getElementsByTagName("INPUT");
    //INPUT对象判断
    for (var i = 0, length = obj.length; i < length; i++) {
        var type = obj[i].type.toUpperCase();
        if (type == "BUTTON" || type == "SUBMIT" || type == "RESET") {
            obj[i].disabled = isDisabled;
        }
    }

    //BUTTON对象
    var obj = dom.getElementsByTagName("BUTTON");
    //INPUT对象判断
    for (var i = 0, length = obj.length; i < length; i++) {
        obj[i].disabled = isDisabled;
    }
    return this;
};


/**
 * 设置元素可用或者不可用
 * @param  {HTMLElement} objEle 元素对象(要设置多个元素可传此参数为数组,如果元素是iframe,则改变整个iframe)
 * @param  {Boolean} canUse 是否可用,true为可用，false为不可用(默认不可用)
 * @return {Object} c$ 对象本身，以支持连缀
 *
 * @example
 *  c$.setElementDisable(document.getElementById('text1'));  // 设置id为text1的元素不可用
 *  c$.setElementDisable(document.getElementById('text1'),true);  // 恢复id为text1的元素可用
 */
c$.setElementDisable = function(objEle, canUse) {
    // 防呆
    if (!objEle || (!objEle.tagName && !objEle.length)) return this;
    // 设置是否可用(默认不可用)
    var disabled = !canUse;

    if (objEle.tagName) {
        var tagName = objEle.tagName.toLowerCase();
        // 输入框,可用而不可写
        if ("textarea" == tagName) {
            objEle.disabled = false;
            objEle.readOnly = disabled;
        }
        // 图片, 下拉菜单, 选择框
        else if ("img" == tagName || 'button' == tagName || 'select' == tagName) {
            objEle.disabled = disabled;
        }
        // A 标签
        else if ("a" == tagName) {
            objEle.disabled = disabled;
            // 修改点击事件
            if (disabled) {
                // 有 onclick 事件，则先备份着
                if (objEle.onclick) objEle.onclick_bak = objEle.onclick;
                // 修改点击事件
                objEle.onclick = function(){return false;};
            }
            // 让 A 可用时,让它可点击，并还原点击事件
            else {
                // 有备份着 onclick 事件，则还原
                if (objEle.onclick_bak) {
                    objEle.onclick = objEle.onclick_bak;
                    objEle.onclick_bak = null;
                }
                else {
                    objEle.onclick = null;
                }
            }
        }
        // iframe 框架,设置里面的全部元素
        else if ("iframe" == tagName) {
            var dom = objEle.contentDocument || objEle.contentWindow.document;
            // 存在跨域问题时, iframe 的 document 不可访问
            if (dom) c$.setDomDisable(canUse, dom);
        }
        // input 元素
        else if (objEle.type) {
            var type = objEle.type.toLowerCase();
            // 输入框,可用而不可写
            if ("text" == type) {
                objEle.disabled = false;
                objEle.readOnly = disabled;
            }
            // 选择框,按钮
            else if ("radio" == type || "checkbox" == type || "button" == type || "submit" == type || "reset" == type) {
                objEle.disabled = disabled;
            }
        }
    }
    // 数组，要递归
    else if (objEle.length) {
        for (var i = 0, length = objEle.length; i < length; i++) {
            c$.setElementDisable(objEle[i], canUse);
        }
    }
    return this;
};

/**
 * 设置整个页面的元素都可用或者都不可用 (对frame,iframe里面的元素暂未处理)
 * @param  {Boolean} canUse 是否可用,true为可用，false为不可用(默认不可用)
 * @param  {HTMLElement} dom Dom对象，默认是 document
 * @param  {Function} notChangeFun 不需要设置的元素的判断函数,参数为元素,返回true表示不需要设置
 * @return {Object} c$ 对象本身，以支持连缀
 *
 * @example
 *  c$.setDomDisable();  // 设置整个页面所有的元素都不可用
 *  c$.setDomDisable(true);  // 恢复整个页面所有的元素都可用
 *  c$.setDomDisable(false, document, function(e){return e.value == '预览'}); // 除value为'预览'的所有元素外，设置整个页面的元素不可用
 */
c$.setDomDisable = function(canUse, dom, notChangeFun) {
    dom = dom || window.document;
    var elements = dom.getElementsByTagName("*");
    // 逐个元素遍历修改
    for (var i = 0, length = elements.length; i < length; i++ ) {
        if (!elements[i] || !elements[i].tagName) continue;
		// 页面上不需更改的元素
        if (notChangeFun && notChangeFun(elements[i])) continue;
        c$.setElementDisable(elements[i], canUse);
    }
    return this;
};

/**
 * 打开窗口(没有高和宽参数时默认全屏)
 * @param  {String} url 窗口地址
 * @param  {String} name 窗口名称
 * @param  {Number} width 窗口宽度
 * @param  {Number} height 窗口高度
 * @return {HTMLElement} 返回打开的子窗口对象
 * @example c$.openWin('../common/Member.html?pform=form1&retid=Memid&retname=MemName', '');
 */
c$.openWin = function(url, name, width, height) {
    // 默认宽度和高度为全屏
    width = width || window.screen.width;
    height = height || window.screen.height;
    // 让窗口显示在屏幕中间
    var top = (window.screen.height - height)/2;
    var left = (window.screen.width - width)/2;
    name = name || "";
    var param = 'scrollbars=yes,top=' + top + ',left=' + left + ',width=' + width + ',height=' + height + ',resizable=yes';
    return window.open(url, name, param);
};

/**
 * 关闭窗口(IE上的关闭窗口时不提示)
 * @param  {HTMLElement} win 窗口对象
 * @return {Object} c$ 对象本身，以支持连缀
 */
c$.closeWin = function(win) {
    win = win || window;
    win.opener = null; // 关闭IE6不提示
    win.open("","_self"); // 关闭IE7不提示
    //关闭窗口
    win.close();
    return this;
};

/**
 * 删除节点
 * @param  {HTMLElement} element 要删除的元素
 * @return {Object} c$ 对象本身，以支持连缀
 * @example c$.removeElement(document.getElementById('text1')) // 删除id为text1的节点
 */
c$.removeElement = function(element) {
    if (element && element.nodeName) {
        element.parentNode.removeChild(element);
    }
    return this;
};

/**
 * 给网址加上时间戳,避免浏览器缓存(已经有时间戳的，会修改时间戳)
 * @param  {String} url 网址,没有时使用所在页面的地址
 * @param  {String} flag 时间戳的参数名称,默认用 timeStamp
 * @return {String} 加上时间戳之后的url
 *
 * @example
 *  c$.addTimeStamp('http://localhost/index.html') // 返回字符串： http://localhost/index.html?timeStamp=1315377347731
 *  c$.addTimeStamp('http://localhost/index.html?a=1&timeStamp=1315377347731')  // 返回字符串：http://localhost/index.html?a=1&timeStamp=1315388347762
 */
c$.addTimeStamp = function(url, flag) {
    url = url || location.href;
    // 时间戳的参数名称
    flag = flag || 'timeStamp';

    // 判断网址是否已经有时间戳,有则替换掉旧的时间戳
    var flag_reg = new RegExp('([?&])' + flag + '=\\d*');
    if (flag_reg.test(url)) {
        return url.replace(flag_reg, RegExp.$1 + flag + '=' + new Date().getTime());
    }

    // 给网址增加时间戳参数
    url += (url.indexOf("?") > 0) ? "&" : "?";
    url += flag + "=" + new Date().getTime();
    return url;
};

/**
 * 获取URL里面的网站域名
 * @param  {String} url 网址；没有参数时默认使用所在网页的网址
 * @return {String} 返回网站的域名字符串；不是有效网址时返回空字符串
 */
c$.getHost = function(url) {
    // 没有参数时，默认用本站的
    url = url || location.href;
    // 用正则表达式来匹配
    var match = url.match(/.*\:\/\/([^\/]*).*/);
    // 能匹配则返回匹配的内容
    if (match) return match[1];
    // 无法匹配(不是有效的网址)，则返回 null
    return "";
};

/**
 * 将 JSON 对象内容转成字符串(注：中文会被url转码, 日期类型会被格式化成字符串)
 * @param  {Object} obj 被转换的JSON对象
 * @param  {Boolean} encode 是否需要将key和value使用encodeURI转码
 * @param  {Boolean} key2lowerCase 是否需要将key转成小写,为true则转成小写，否则不转
 * @return {String} 返回字符串形式的json内容
 * @example
 *    c$.json2str({a:1, b:[1,'2',3], c:'哈哈'}) // 返回字符串: '{"a":1,"b":[1,"2",3],"c":"哈哈"}'
 *    c$.json2str({a:1, b:[1,'2',3], c:'哈哈'}, true) // 返回字符串: '{"a":1,"b":[1,"2",3],"c":"%E5%93%88%E5%93%88"}'
 */
c$.json2str = function (obj, encode, key2lowerCase) {
    var arr = [];
    if (obj === '') return '""'; // 空字符串处理
    // undefined, null, false, 0, NaN, Infinity
    if (!obj) return "" + obj;
    var thisFun = arguments.callee;
    // 转换字符串
    var format = function(value) {
        // 对字符串的处理，URI转码, 以便提交数据
        if (typeof value == 'string') {
            value = encode ? encodeURIComponent(value) : value;
            return '"' + value.replace(new RegExp('"', "g"), '\\"') + '"';
        }
        // 处理 日期
        if (value && value.constructor == Date) return '"' + value.format() + '"';
        // 处理 正则表达式,返回“/^\s+/gi”格式的内容
        if (value && value.constructor == RegExp) return '' + value;
        // 处理 数组
        if (value && value.constructor == Array) {
            // 使用临时变量，避免修改源数据
            var temArr = [];
            for (var i=0; i < value.length; i++) {
                if (typeof value[i] == 'function') continue; // 自添加的函数,不用转换
                temArr.push(format(value[i]));
            }
            return '[' + temArr.join(',') + ']';
        }
        // 如果是 函数
        if (typeof value == 'function') try { return format(value());}catch(e){ return value + ""; };
        // 如果是 object, 这里认为是 json，递归调用
        if (typeof value == 'object' && value != null) return thisFun(value, encode, key2lowerCase);
        // undefined, null, bool, number 类型，直接返回
        return value;
    }
    // bool, number, string, function, 数组, 日期
    if (typeof obj != 'object' || obj.constructor == Array || obj.constructor == Date || obj.constructor == RegExp) return format(obj);
    for (var key in obj) {
        // 将key转成小写
        var tem_key = key2lowerCase ? ("" + key).toLowerCase() : key;
        arr.push('"' + (encode ? encodeURIComponent(tem_key) : tem_key) + '":' + format(obj[key]));
    }
    return '{' + arr.join(',') + '}';
};

/**
 * 分解URL请求参数
 * @param  {String} href 网址；没有参数时默认使用所在网页的网址
 * @param  {Boolean} key2lowerCase 是否需要将key转成小写,为true则转成小写，否则不转(默认不干涉)
 * @return {Object} 返回json形式的参数内容
 * @example c$.getRequestParams("http://localhost/index.html?d2d=%E5%93%88%E5%93%88&dd=oo111") // 返回对象: {d2d:'哈哈', dd:'oo111'}
 */
c$.getRequestParams = function(href, key2lowerCase) {
    href = href || location.href;
    var result = {};
    var regex = /(\w+)=([^&]*)/gi;
    var ms = href.match(regex);
    if (ms == null) return result;

    for(var i = 0, length = ms.length; i < length; i++) {
        var ns = ms[i].match(regex);
        var key = RegExp.$1;
        key = key2lowerCase ? ("" + key).toLowerCase() : key;
        try {
            result[key] = decodeURIComponent(RegExp.$2); // 转码需要完全转
            result[key] = result[key].replace('+', ' '); // 空格会变成加号
        }catch(e){}
    }

    return result;
};

/**
 * 对链接进行 UTF-8 编码
 * @param  {String} href 网址; 没有网址返回空字符串
 * @param  {Boolean} key2lowerCase 是否需要将key转成小写,为true则转成小写，否则不转(默认不干涉)
 * @return {String} 返回转编码后的网址
 * @example c$.encodeUrl("http://localhost/index.html?d2d=哈哈&dd=oo111") // 返回: "http://localhost/index.html?d2d=%E5%93%88%E5%93%88&dd=oo111"
 */
c$.encodeUrl = function(href, key2lowerCase) {
    return c$.toQueryStr(null, href, key2lowerCase);
};

/**
 * 把对象格式化成 URL 的参数形式
 * @param  {Object} obj 需要转成参数的对象
 * @param  {String} href 网址; 没有网址则只返回格式化后的参数部分,有网址则拼接到网址上(还会修改网址上原有的值)
 * @param  {Boolean} key2lowerCase 是否需要将key转成小写,为true则转成小写，否则不转(默认不干涉)
 * @return {String} 返回编码后的字符串
 * @example
 *  c$.toQueryStr({d2d:'看看', b:2}, "http://localhost/index.html?d2d=哈哈&dd=oo111") // 返回: "http://localhost/index.html?d2d=%E7%9C%8B%E7%9C%8B&dd=oo111&b=2"
 *  c$.toQueryStr({d2d:'哈哈', b:2}) // 返回: "d2d=%E5%93%88%E5%93%88&b=2"
 */
c$.toQueryStr = function(obj, href, key2lowerCase) {
    if (!href || typeof href != 'string') {
        href = "";
    }
    // 把网址上的参数拼接到 obj 类里面
    else {
        if (!obj || typeof obj != 'object') {
            obj = c$.getRequestParams(href, key2lowerCase);
        } else {
            obj = c$.extend(c$.getRequestParams(href, key2lowerCase), obj);
        }
    }

    // 截取出网址(去掉参数部分)
    var index = href.indexOf("?");
    if (index > 0) {
        href = href.substring(0, index) + '?';
    }
    else if (href) {
        href += '?';
    }

    var parts = [];
    for (var key in obj) {
        key = key2lowerCase ? ("" + key).toLowerCase() : key;
        parts.push(encodeURIComponent(key) + '=' + encodeURIComponent(c$.json2str(obj[key])));
    }
    href += parts.join('&');
    return href;
};

/**
 * 获取URL的参数
 * @param  {String} name 要获取的参数名称
 * @param  {String} url 保存着参数的 URL
 * @return {String} 返回获取到的值,没有对应的键时返回 null
 */
c$.getRequestValue = function(name, url) {
    url = url || location.href;
    var res = new RegExp( "[\\?&]" + name + "=([^&#]*)" ).exec( url );
    return res ? decodeURIComponent(res[1]) : null;
};

/**
 * 获取鼠标的坐标
 * @param  {Event} 事件对象,写上则可兼容IE和ff
 * @return {Object} 返回鼠标位置,形式如：{x: 531, y: 26}
 */
c$.getMousePos = function(ev) {
    ev = ev || window.event;
    var getX = 0, getY = 0;
    if (!ev) {
        // firfox(取不到 event 时)
        if (typeof window.pageYOffset == 'number') {
            getX = 'window.pageXOffset', getY = 'window.pageYOffset';
        }
        else {
            return { x: getX, y: getY };
        }
    }
    // firfox
    else if (typeof ev.pageX == 'number') {
        getX = 'ev.pageX', getY = 'ev.pageY';
    }
    // IE
    else if (typeof ev.clientX == 'number') {
        if (document.documentElement && typeof document.documentElement.scrollLeft == 'number') {
            getX = 'ev.clientX + document.documentElement.scrollLeft - document.documentElement.clientLeft';
            getY = 'ev.clientY + document.documentElement.scrollTop - document.documentElement.clientTop';
        }
        else if (document.body && typeof document.body.scrollLeft == 'number') {
            getX = 'ev.clientX + document.body.scrollLeft - document.body.clientLeft';
            getY = 'ev.clientY + document.body.scrollTop - document.body.clientTop';
        }
    }
    // 重置函数,以提高效率,不用每次都判断
    eval('c$.getMousePos = function(ev){ ev = ev || window.event; return { x: ' + getX + ', y: ' + getY + ' }};');
    // 执行此函数,上面已经重置了此函数
    return c$.getMousePos(ev);
};

/**
 * 获取元素位置
 * @param  {String | HTMLElement} element 元素或者此元素的id
 * @return {Object} 返回元素位置,形式如：{left: 531, top: 26}
 */
c$.getElementPos = function(element) {
    if (typeof element == 'string') { element = document.getElementById(element); }
    var left = 0, top = 0;
    do {
        left += element.offsetLeft;
        top += element.offsetTop;
      // 循环追加获取父节点的位置
    } while (element = element.offsetParent);
    return {left: left, top: top};
};

/**
 * 滚动到某元素
 * @param  {String | HTMLElement} element 元素或者此元素的id
 * @return {Object} c$ 对象本身，以支持连缀
 */
c$.scrollTo = function (element) {
    var offset = c$.getElementPos(element);
    window.scrollTo(offset.left, offset.top);
    return this;
};

/**
 * 时间转换,把 Unix时间 转换成年月日格式
 * @param  {Number} date Unix时间(单位为秒)
 * @param  {String} format 显示的时间格式化的字符串(默认为：yyyy-MM-dd HH:mm:ss )
 * @return {String} 格式化时间后的字符串
 * @example c$.formatUnixDate(1); // 返回: 1970-01-01 08:00:01
 */
c$.formatUnixDate = function (date, format) {
    date = c$.toInt(date); // 变整数
    var d = new Date(date * 1000); // js的时间是格林威治时间(1970-01-01 08:00:00)的毫秒数,故需要乘1000
    return d.format(format);
};

/**
 * 设定iframe适应高度(必须在 iframe元素加载后执行,如在 onload 里面执行,否则无效)
 * @param  {HTMLElement} iframe iframe元素
 * @return {Object} c$ 对象本身，以支持连缀
 * @example <iframe src='test.html' onload='c$.setIframeHeight(this)' />  // 加载 iframe 时，让它自动调整高度
 */
c$.setIframeHeight = function(iframe) {
    iframe = iframe || document.getElementsByTagName("iframe")[0] || window.parent.document.getElementsByTagName("iframe")[0];
    if ( !iframe ) return this;
    // IE
    if ( iframe.Document && iframe.Document.body.scrollHeight ) {
        iframe.height = iframe.Document.body.scrollHeight;
    }
    // Firefox
    else if ( iframe.contentDocument && iframe.contentDocument.documentElement ) {
        iframe.height = iframe.contentDocument.documentElement.scrollHeight + 'px';
        //jQuery(iframe).height(jQuery(iframe.contentDocument.documentElement).height());
    }
    return this;
};

/**
 * 设定为焦点
 * @param  {HTMLElement} element 对象
 * @return {Object} c$ 对象本身，以支持连缀
 * @example c$.setFocus(docuemnt.getElementById('text1')); // 在id为text1的元素上设置焦点
 */
c$.setFocus = function(element) {
    //element.focus();
    setTimeout(function(){try { element.focus(); } catch (e){}}, 10);
    return this;
};

/**
 * cookie 操作(包括: 设值、获取、删除)
 * @param  {String} name cookie名称(必须有)
 * @param  {String} value 对应这名称的值(为 null 时是删除cookie, 不填写此值则是获取cookie)
 * @param  {Object} options 其它的 cookie 参数,包括:
 *   @option {Number | Date} expires 为 Number 类型则是过期时间的天数。 为 Date 类型,则指定过期时间。
 *   @option {String} path 这个 cookie 的路径 (默认: path 为创建此 cookie 的页面).
 *   @option {String} domain 这个 cookie 的域名 (默认: 域名为创建此 cookie 的页面的域名).
 *   @option {Boolean} secure 是否加密协议,为 true 则需要一个加密的协议(如: https)
 * @return {String | Object | null} 获取时返回获取到的值(String类型, 取不到时返回null), 设值和删除时返回 c$ 对象本身，以支持连缀
 *
 * @example
 *   c$.cookie('the_cookie', 'the_value');  // 设值(创建、修改)
 *   c$.cookie('the_cookie');  // 获取值
 *   c$.cookie('the_cookie', 'the_value', { expires: 7, path: '/', domain: 'jquery.com', secure: true });  // 设值,并设置cookie的参数
 *   c$.cookie('the_cookie', null); // 删除cookie,但需要保证设置的 options 里面的 path 和 domain 一致
 */
c$.cookie = function(name, value, options) {
    if (typeof value != 'undefined') { // name and value given, set cookie
        options = options || {};
        if (value === null) {
            value = '';
            options.expires = -1;
        }
        var expires = '';
        if (options.expires && (typeof options.expires == 'number' || options.expires.toUTCString)) {
            var date;
            if (typeof options.expires == 'number') {
                date = new Date();
                date.setTime(date.getTime() + (options.expires * 24 * 60 * 60 * 1000));
            } else {
                date = options.expires;
            }
            expires = '; expires=' + date.toUTCString(); // use expires attribute, max-age is not supported by IE
        }
        // options.path 和 options.domain 需要括号括起来，因为解析它的值时可能会是 undefined
        var path = options.path ? '; path=' + (options.path) : '';
        var domain = options.domain ? '; domain=' + (options.domain) : '';
        var secure = options.secure ? '; secure' : '';
        document.cookie = [encodeURIComponent(name), '=', encodeURIComponent(value), expires, path, domain, secure].join('');
    } else { // only name given, get cookie
        var cookieValue = null;
        if (!document.cookie) return cookieValue;
        name = encodeURIComponent(name);
        var cookies = document.cookie.split(';');
        for (var i = 0; i < cookies.length; i++) {
            var cookie = cookies[i].trim();
            // Does this cookie string begin with the name we want?
            if (cookie.substring(0, name.length + 1) == (name + '=')) {
                cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
                break;
            }
        }
        return cookieValue;
    }
};

/* ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 * Ajax start
 * --------------------------------------------------------------- */

/**
 * 创建 XMLHttpRequest
 * @return {Object} XMLHttpRequest
 */
c$.createXMLHttpRequest = function() {
    var fns = [
        function () { return new XMLHttpRequest(); }, // w3c, IE7+
        function () { return new ActiveXObject('Msxml2.XMLHTTP'); }, // IE6
        function () { return new ActiveXObject('Microsoft.XMLHTTP'); }, // IE5
    ];
    var xmlHttp = false;
    for (var i=0, n=fns.length; i < n; i++) {
        try {
            xmlHttp = fns[i]();
            c$.createXMLHttpRequest = fns[i]; // 重置函数, 不用每次调用都重复判断
            break;
        }catch(e){}
    }
    return (xmlHttp || false);
};

/**
 * 发送 Ajax 请求
 * 需改变的参数则需写上，使用默认的不用写，所有的参数都可以不写
 * @param  {Object} paramObj 参数对象,具体参考下面的用例
 * @return {Object} c$ 对象本身，以支持连缀
 *
 * c$.ajax({
 *    url : "submit.html",                         // 需要发送的地址(默认: 当前页地址)
 *    param : "a=1&b=2",                           // 需要发送的传参字符串
 *    async : true,                                // 异步或者同步请求(默认: true, 异步请求)。如果需要发送同步请求，请将此选项设置为 false
 *    cache : true,                                // 是否允许缓存请求(默认: true, 允许缓存)
 *    method : "GET",                              // 请求方式(默认: "GET"),也可用"POST"
 *    success : function(xmlHttp){....},           // 请求成功返回的动作
 *    error : function(xmlHttp, status){....},     // 请求失败时的动作
 *    complete : function(xmlHttp, status){....}   // 请求返回后的动作(不管成败,且在 success 和 error 之后运行)
 * });
 */
c$.ajax = function(paramObj) {
    // 创建 XMLHttpRequest
    var xmlHttp = c$.createXMLHttpRequest();
    // 如果不支缓 Ajax，提示信息
    if (!xmlHttp) {
        alert("您的浏览器不支持 Ajax，部分功能无法使用！");
        return this;
    }

    // 需要发送的地址(默认: 当前页地址)
    paramObj.url = paramObj.url || "#";
    // 异步或者同步请求(默认: true, 异步请求)
    if (typeof paramObj.async == 'undefined') {
        paramObj.async = true;
    }
    // 请求方式(默认: "GET")
    paramObj.method = paramObj.method || "GET";
    // get形式，将参数放到URL上
    if ("GET" == ("" + paramObj.method).toUpperCase() && paramObj.param) {
        paramObj.url += (paramObj.url.indexOf("?") > 0) ? "&" : "?";
        paramObj.url += paramObj.param;
        paramObj.param = null;
        paramObj.url = c$.encodeUrl(paramObj.url);
    }
    // 发送请求
    xmlHttp.open(paramObj.method, paramObj.url, paramObj.async);
    // 执行回调方法
    xmlHttp.onreadystatechange = function() {
        // XMLHttpRequest对象响应内容解析完成
        if (4 !== xmlHttp.readyState) return;
        var status = xmlHttp.status;
        // 200为正常返回状态, 0是本地直接打开文件(没有使用服务器时)
        if (200 == status || 0 === status) {
            // 请求成功时的动作
            if (paramObj.success) paramObj.success(xmlHttp);
        }
        else {
            // 请求失败时的动作
            if (paramObj.error)  paramObj.error(xmlHttp, status);
            // 默认的出错处理
            else alert("页面发生Ajax错误，请联系管理人员! \n错误类型：" + status + ": “" + location.pathname + "”");
        }
        // 请求返回后的动作(不管成败,且在 success 和 error 之后运行)
        if (paramObj.complete) paramObj.complete(xmlHttp, status);
    };
    // 缓存策略(默认: 缓存)
    if (false === paramObj.cache) {
        xmlHttp.setRequestHeader("If-Modified-Since","0");
        xmlHttp.setRequestHeader("Cache-Control","no-cache");
    }
    // 请求方式("POST")
    if (paramObj.method.toUpperCase() == "POST") xmlHttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded;charset=utf-8");
    xmlHttp.setRequestHeader("Charset", "UTF-8");
    // 发送参数
    xmlHttp.send(paramObj.param);
    return this;
};

/**
 * 获取xmlHttp里符合的资料
 * @param  {Object} xmlHttp XMLHttpRequest
 * @param  {String} tagName 资料的 TagName
 * @param  {Number} init    默认值
 * @param  {Number} index   第几个子元素
 * @return {String} 符合的数据的字符串
 */
c$.getAjaxValue = function(xmlHttp, tagName, init, index) {
    init = init || "";
    index = index || 0;
    // 没法继续执行
    if (!xmlHttp || !tagName) return init;

    try {
        //获取xmlHttp里对应的值
        var element1 = xmlHttp.responseXML.getElementsByTagName(tagName)[index].firstChild;
        var value = element1.nodeValue || element1.data;
        //如果能获取值
        if (value) return value;
    }
    catch (e) {}
    // 异常或者没能取到值时,返回默认值
    return init;
};

/**
 * 探测 url 是否存在(注意不能跨域, js的限制)
 * @param url 要探测的网址,可以绝对地址，也可以相对地址。(注意：只能探测域名相同的)
 * @return 网址存在则返回true，否则返回false。
 */
c$.checkUrl = function (url) {
    // 创建 XMLHttpRequest
    var xmlHttp = c$.createXMLHttpRequest();
    // XMLHTTP的Head方法是不用全部返回的,这样就可以快速获取状态,不必等页面内容全部返回。注意不能跨域
    xmlHttp.open("HEAD",url,false);
    xmlHttp.send();
    return xmlHttp.status==200 || xmlHttp.status==0;
};
/* -------------------------------------------------------------------
 * Ajax end
 * ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ */


/**
 * 获取元素
 * @param  {String} str 直接写则是指元素的ID或者name
 *                  如果需要精确指定则使用“#”开头表示id,“@”开头表示name,“.”开头表示class,“$”开头表示tagName
 *                  根据 name、class、tagName 查找时,如果只找到一个则返回一个元素,找到多个则返回数组； 根据id查找时只会返回一个
 * @param  {HTMLElement} dom 需要选择的DOM对象,默认是 window.document
 * @return {HTMLElement | Array[HTMLElement]} 如果能找到指定名称的元素，返回元素对象； 如果找不到指定的元素，返回 null
 *
 * @example
 *  c$.getElement("mytext")  // 返回 id 或者 name 为"mytext"的元素
 *  c$.getElement("#mytext") // 返回 id 为"mytext"的元素
 *  c$.getElement("@mytext") // 返回 name 为"mytext"的元素
 *  c$.getElement(".class1") // 返回 class 为"class1"的元素
 *  c$.getElement("$div")    // 返回 标签 为"div"的所有元素
 *  c$.getElement("$div #text1")  // 返回 div 标签里面 id 为"text1"的元素(支持多级查询，以空格分隔)
 */
c$.getElement = function(str, dom) {
    if (!str) return null;
    // 默认要查找的 dom 对象
    dom = dom || document;

    // 如果本身是页面对象,直接返回
    if (c$.isElement(str)) return str;

    // 判断返回：只有一个的时候，返回一个元素；多个则返回数组
    var return_arr = function(elements) {
        // 参数是数组
        if (elements && elements.constructor == Array) {
            // 空数组时
            if (elements.length == 0) return false;
            // 只有一个的时候，直接返回一个元素
            if (elements.length == 1 && c$.isElement(elements[0])) return elements[0];
            // 多个时传回数组
            return elements;
        }
        // 参数是元素
        if (c$.isElement(elements)) return elements;
        // 没有符合的
        return false;
    }

    // 获取查找的类型,以及查找的字符串
    var getType = function(str) {
        var type = null;
        var find_str = str.substr(1);
        // 判断要查询的类型
        switch(str.substr(0, 1)) {
            case "#": type = 'id'; break;
            case "@": type = 'name'; break;
            case ".": type = 'class'; break;
            case "$": type = 'tagName'; break;
            // 没有精确指定时
            default:  find_str = str;
        }
        return [type, find_str];
    }

    // 获取dom里面的元素
    var getDomElements = function(type, find_str, DOM) {
        var elements = [];
        if (DOM) {
            // 如果 dom 是个数组
            if (DOM.length && DOM.constructor == Array) {
                for(var i=0, length = DOM.length; i<length; i++){
                    if (DOM[i].getElementsByTagName) {
                        var tem_elements = [];
                        // 根据 tagName 获取元素
                        if (type == 'tagName') {elements = elements.concat(DOM[i].getElementsByTagName(find_str));}
                        // 获取 dom 里面的所有元素
                        else {elements = elements.concat(DOM[i].getElementsByTagName('*') || DOM[i].all);}
                    }
                }
            }
            // 单个的 dom
            else {
                if (DOM.getElementsByTagName) {
                    // 根据 tagName 获取元素
                    if (type == 'tagName') {elements = DOM.getElementsByTagName(find_str);}
                    // 获取 dom 里面的所有元素
                    else {elements = DOM.getElementsByTagName('*') || DOM.all;}
                }
            }
        }
        if (elements && elements.length) {
            var ets = []; // 返回值
            for (var i=0, length = elements.length; i < length; i++) {
                var et = elements[i];
                if (c$.isElement(et)) {
                    // 判断要查询的类型
                    switch(type) {
                        case 'id': if(et.id == find_str)ets.push(et); break;
                        case 'name': if(et.name == find_str)ets.push(et); break;
                        case 'class': if((" "+et.className+" ").indexOf(" "+find_str+" ") != -1)ets.push(et); break;
                        case 'tagName': if(et.tagName.toUpperCase() == find_str.toUpperCase())ets.push(et); break;
                        // 没有精确指定时
                        default: if(et.id == find_str || et.name == find_str)ets.push(et);
                    }
                }
            }
            var et = return_arr(ets);
            if (et) return et;
        }
        // 没有找到时
        return null;
    }

    // 根据 string 来获取对象
    if ("string" == typeof str) {
        //按照空格分割参数
        var values = str.trim().replace(/\s+/g, " ").split(" ");
        var type = getType(values[0])[0];
        var find_str = getType(values[0])[1];
        // 优化一下效率; 根据 id 获取元素
        if (dom.getElementById && (type == 'id' || type === null)) {
            var element = dom.getElementById(find_str);
            if (c$.isElement(element)) {
                if (values.length == 1)return element;
                dom = element;
                values.shift();
            }
        }
        // 优化一下效率; 根据 name 获取元素
        if (dom.getElementsByName && (type == 'name' || type === null)) {
            var elements = dom.getElementsByName(find_str);
            var et = return_arr(elements);
            if (et) {
                if (values.length == 1)return et;
                dom = et;
                values.shift();
            }
        }
        // 遍历查询
        for(var i=0, length = values.length; i<length; i++) {
            type = getType(values[i])[0];
            find_str = getType(values[i])[1];
            dom = getDomElements(type, find_str, dom);
            if (dom === null) return null; // 找不到时不再继续
        }
        if (dom) return dom;
    }

    // 找不到元素，则返回 null
    return null;
};

/**
 * 获取元素的值
 * @param  {String} name 元素的ID或者name
 * @param  {String} init 默认值
 * @return {String} 元素的值(value 或者 innerHTML 或者 checkbox、radio选中的值)
 */
c$.getValue = function(name, init) {
    //返回值
    var retValue = "";
    //如果没有传入默认值
    if (arguments.length <= 1) init = "";
    var data = c$.getElement(name);
    //如果没有找到所要的元素，则直接返回默认值
    if (!data) return init;

    //如果它是选择框
    if ("checkbox" == data.type) {
        if (data.checked) return data.value;
        return init;
    }
    //如果它是单选按钮
    if ("radio" == data.type || (1 < data.length && "radio" == data[0].type)) {
        return c$.getRadioValue(name, init);
    }

    //获取元素的值; 没有value属性则取innerHTML
    retValue = data.value || data.innerHTML;
    //如果没有取到值，返回默认值
    return (retValue || init);
};

/**
 * 表单序列化
 * @param  {HTMLElement} form 表单的id,name 或者表单对象,给出的不是 form 元素而是 div,table 之类的元素也可以
 * @param  {Boolean} encode 是否将值转成 URL 编码
 * @return {String} 表单序列化后的字符串
 */
c$.serialize = function(form, encode) {
    //元素列表
    var elements = c$.getElements(form);
    // 拼接参数
    var param = "";
    for (var i = 0, length = elements.length; i < length; i++) {
        if (elements[i].type) {
            var type = elements[i].type.toLowerCase();
            // 选择项,没选中时跳过
            if (type == "radio" || type == "checkbox") {
                if (!elements[i].checked) continue;
            }
            // 按钮不需要序列化
            if ("button" == type || "submit" == type || "reset" == type) continue;
        }
        // 保存名称和值
        var name = elements[i].name;
        var value = elements[i].value;
        // 如果需要转变中文编码
        value = encode ? encodeURIComponent(value) : value;
        if (param.length > 0) param += "&";
        param += name + "=" + value;
    }
    return param;
};

/**
 * 添加 onload 事件
 * 注：多次调用此函数时不能保证各函数的执行顺序
 * @param  {Function} fun 要添加到 onload 事件的函数
 * @param  {Object} win 要添加 onload 事件的窗口对象,默认为 window
 * @return {Object} c$ 对象本身，以支持连缀
 */
c$.addOnloadFun = function(fun, win) {
    if (!fun || typeof fun !== 'function') return this;
    win = win || window;

    // IE
    if (win.attachEvent) {
        win.attachEvent('onload', fun);
    }
    // firfox
    else if (win.addEventListener) {
        win.addEventListener('load', fun, false);
    }
    return this;
};

/**
 * 当DOM载入就绪时执行某函数(比window.onload更早)
 * @param  {Function} fun [必填]需要执行的函数
 * @return {Object} c$ 对象本身，以支持连缀
 *
 * @example
 *  c$.ready(function(){alert('执行DOM加载完成事件');});
 *  c$(function(){alert('执行DOM加载完成事件');}); // 为 c$.ready(fun) 的缩写
 */
c$.ready = function (fun) {
    if (!fun || typeof fun !== 'function') return this;
    var thisFun = arguments.callee;
    // thisFun.funList 作为本函数的全局变量,保证多次调用本函数时可以共用
    thisFun.funList = thisFun.funList || [];
    thisFun.funList.push(fun);
    if (thisFun.funList.length > 1) return this;
    // 执行的函数
    var doReady = function () {
        var fn,  i = 0,  readyList;
        if (thisFun.funList) {
            // 为了减少变量查询带来的性能损耗，将它赋值给本地变量
            readyList = thisFun.funList;
            // 释放引用
            thisFun.funList = null;
            while( (fn = readyList[ i++ ]) ){
                fn.call( document );
            }
        }
    };
    // FF, Opera, 高版webkit, 其他
    if (document.addEventListener) {
        document.addEventListener( "DOMContentLoaded", function(){
            document.removeEventListener( "DOMContentLoaded", arguments.callee, false );
            doReady();
        }, false );
        window.addEventListener('load', doReady, false); // 为了保险起见，还注册了 onload 事件
    }
    // IE
    else if (document.attachEvent) {
        document.attachEvent("onreadystatechange", function() {
            if (document.readyState == "complete") {
                document.detachEvent( "onreadystatechange", arguments.callee );
                doReady();
            }
        });
        window.attachEvent('onload', doReady);

        // 判断文档是否处于最顶层,如果文档处于iframe中，调用doScroll方法成功时并不代表DOM加载完毕
        var isToplevel = false;
        try {
            isToplevel = window.frameElement == null;
        } catch(e) {}

        if (document.documentElement.doScroll && isToplevel) {
            (function(){
                try {
                    document.documentElement.doScroll("left");
                } catch (error) {
                    window.setTimeout(arguments.callee, 0);
                    return;
                }
                doReady();
            })();
        }
    }
    return this;
};


// 整个工具类结束
})(window);