
String 字符串对象：
    格式编排:anchor()锚、blink()闪烁、fixed()固定、bold()粗体、italics()斜体、strike()删除线
           big()字变大、small()字变小、sub()下标、sup()上标；
           fontcolor(color)字体颜色、fontsize(size)字体大小、link(url)超链接
    大小写转换:  toLowerCase()返回小写字符串、toUpperCase()返回大写字符串
    获取指定字符:charAt(index)返回指定位置字符、charCodeAt(index)返回指定位置字符Unicode编码
    子字符串处理:
       截取:substr(start,length);  //返回从索引位置start开始长为length的子字符串
           substring(start,end);  //返回start开始end结束的子字符串,不包括最后的一个
           slice(start,end);      //同substring，但允许使用负数表示从后计算位置,不包括最后的一个
       替换:replace(findstr,tostr); //返回替换finstr为tostr之后的字符串
       分割:split(bystr);     //返回由bystr分割成的字符串数组(通常bystr是连接符号，如逗号或横杆)
       连接:concat(string2);      //返回 str1 与 string2 连接后的字符串
    查询字符串: indexOf(findstr,index)返回找到字符串的索引位置、lastIndexOf(findstr)返回找到字符串索引位置,反向找起,找不到返回-1
             match(regexp)返回匹配的字符串、search(regexp)返回找到字符串的首字符索引



创建 String 对象的语法:
    new String(s);
    String(s);

属性
    length	长度
    prototype	返回对象类型原型的引用
    constructor	创建对象的函数

方法
    anchor(name)	创建 HTML 锚。添加<a name=name ></a>标记对
    big()	用大号字体显示字符串。添加<big></big>标记对
    blink()	显示闪动字符串,添加<blink></blink>标记对
        注: 此方法无法工作于 Internet Explorer 中。

    bold()	使用粗体显示字符串。添加<b></b>标记对
    charAt(index)	返回在指定位置的字符。位置的有效值为0到字符串长度减1的数值。
        一个字符串的第一个索引位置为0,第二个为1,依次类推。当指定的索引位置超出有效范围时,charAt返回一个空字符串。

    charCodeAt(index)	返回一个整数,表示指定的位置的字符的 Unicode 编码。
    concat(s1,,,,,sn)	连接字符串。返回拼接后的新字符串
    fixed()	以打字机文本显示字符串。添加<tt></tt>标记对
    fontcolor(color)	使用指定的颜色来显示字符串。加上<font color=color></font>标记对
        color为字符串规定 font-color。该值必须是颜色名(red)、RGB 值(rgb(255,0,0))或者十六进制数(#FF0000)。
    fontsize(size)	使用指定的尺寸来显示字符串。加上的<font size=size></font>标记对
    fromCharCode(num1,num2,...,numX)	从字符编码创建一个字符串。
        参数必需。一个或多个 Unicode 值，即要创建的字符串中的字符的 Unicode 编码。
        该方法是 String 的静态方法，因此它的语法应该是 String.fromCharCode()，而不是 myStringObject.fromCharCode()。

    indexOf(pattern)	检索字符串。
        返回字符串中包含参数字符串的第一次出现的位置值。(值的范围:0~stringObject.length - 1)如果不包含则返回-1
    indexOf(Pattern,startIndex)	同上,只是从startIndex指定位置开始查找
        注: indexOf() 方法对大小写敏感！
    italics()	使用斜体显示字符串。添加<i></i>标记对
    lastIndexOf(Pattern)	从后向前搜索字符串。返回字符串中包含参数字符串的最后一次出现的位置值。如果不包含则返回-1
    lastIndexOf(Pattern,startIndex)	同上,只是从startIndex指定位置开始
        注: lastIndexOf() 方法对大小写敏感！
    link(url)	将字符串显示为链接。加上超级链接标记对<a url=url ></a>
    localeCompare(targetStr)	用本地特定的顺序来比较两个字符串。
        如果 stringObject 小于 targetStr, 则返回小于 0 的数。
        如果 stringObject 大于 targetStr,则该方法返回大于 0 的数。
        如果两个字符串相等，或根据本地排序规则没有区别，该方法返回 0。

    match(regexp)	找到一个或多个正则表达式的匹配。返回一个包含该搜索结果的数组, 如果没有匹配则返回null
        该方法类似 indexOf() 和 lastIndexOf()，但是它返回指定的值，而不是字符串的位置。
        如果该参数不是 RegExp 对象，则需要首先把它传递给 RegExp 构造函数，将其转换为 RegExp 对象。
        这个方法的行为在很大程度上有赖于 regexp 是否具有标志 g。有则全局检索,返回匹配的多个; 没有则只返回匹配的第一个。

    replace(regexp/substr,replacement)	用于在字符串中用一些字符替换另一些字符，或替换一个与正则表达式匹配的子串。
        返回一个新的字符串，是用 replacement 替换了 regexp 的第一次匹配或所有匹配之后得到的。
        如果参数 regexp 具有全局标志 g，那么 replace() 方法将替换所有匹配的子串。否则，它只替换第一个匹配子串。
        参数 substr 如果是字符串，则只按字符串处理，不会转成 RegExp.
        参数 replacement 可以是字符串，也可以是函数。如果它是字符串，那么每个匹配都将由字符串替换。但是 replacement 中的 $ 字符具有特定的含义。
        如下表所示，它说明从模式匹配得到的字符串将用于替换。
            字符	替换文本
            $1、$2、...、$99	与 regexp 中的第 1 到第 99 个子表达式相匹配的文本。
            $&	与 regexp 相匹配的子串。
            $`	位于匹配子串左侧的文本。
            $'	位于匹配子串右侧的文本。
            $$	直接量符号。

    search(regExp)	返回使用正则表达式搜索时,第一个匹配的子字符串的下标
        下标从0开始计数,即第一个字符的位置为0.如果没有找到则返回 -1。
        如果该参数不是 RegExp 对象，则需要首先把它传递给 RegExp 构造函数，将其转换为 RegExp 对象。
        注: 它总是匹配第一个, 会忽略 regExp 的标志 g 和 lastIndex 属性。

    slice(start,end)	返回下标从start开始到end前一个字符的子串
        参数start,指要抽取的片断的起始下标。如果是负数，则该参数规定的是从字符串的尾部开始算起的位置。也就是说，-1 指字符串的最后一个字符，-2 指倒数第二个字符，以此类推。
        参数end,指紧接着要抽取的片段的结尾的下标。若不指定此参数，则从 start 截取到末尾。如果该参数是负数，那么它规定的是从字符串的尾部开始算起的位置。

    small()	使用小字号来显示字符串，加上<small></small>标记对

    split(separator,limit)	把一个字符串分割成字符串数组
        参数 separator：必需。字符串或正则表达式，从该参数指定的地方分割字符串。它不作为任何数组元素的一部分返回
        如果 separator 是包含子表达式的正则表达式，那么返回的数组中包括与这些子表达式匹配的字串（但不包括与整个正则表达式匹配的文本）。
        参数limit:可选。该参数可指定返回的数组的最大长度。如果设置了该参数，返回的子串不会多于这个参数指定的数组。如果没有设置该参数，整个字符串都会被分割，不考虑它的长度。
        注: 如果把空字符串 ("") 用作 separator，那么字符串中的每个字符之间都会被分割。
        String.split() 执行的操作与 Array.join 执行的操作是相反的。

    strike()	显示删除线，加上<strike></strike>标记对
    sub()	显示为上标。加上<sub></sub>标记对
    substr(start,length)	返回字符串中从start开始的length个字符的子字符串
    substring(from,to)	返回下标从from开始,到to结束的子字符串

    sup()	显示为下标。加上html的<sup></sup>标记对

    toLocaleLowerCase()	把字符串转换为小写。
    toLocaleUpperCase()	把字符串转换为大写。
    toLowerCase()	返回一个字符串,该字符串中的所有字母都被转换成小写字母
    toUpperCase()	返回一个字符串,该字符串中的所有字母都被转换成大写字母

    toString()	返回对象的字符串值
    valueOf()	返回某个字符串对象的原始值


/************* String 范例 ************************/

// 格式编排:
    var s = '哈哈，你好';
    alert(s.big()); // <big>哈哈，你好</big>
    alert(s); // 哈哈，你好   (格式编排函数,不会改变原字符串)
    alert(s.anchor('myAn')); // <a name="myAn">哈哈，你好</a>

// 静态方法 fromCharCode 和 它对应的 charCodeAt
    alert(String.fromCharCode(72,69,76,76,79)); // HELLO
    alert('HELLO'.charCodeAt(0)); // 72

// match:
    var str = "Hello world!"
    alert(str.match("world!")); // world!
    alert(str.match("World"));  // null  (大小写敏感,匹配不到返回 null)
    alert(str.match("[o]"));    // o     (字符串自动转成正则表达式)
    alert(str.match(/o/g));     // o, o  (regexp 具有标志 g, 匹配多个)

// replace:
    var s = "hello tom!"
    alert(s.replace('o', '8')); // hell8 tom!   (不是 g 标志的 regexp,只替换第一个)
    alert(s.replace('[o]', '8')); // hello tom!   (第一个参数的字符串不会自动转存 regexp,匹配不到则不替换)
    alert(s.replace(new RegExp('[o]', 'g'), '8')); // hell8 t8m!   (有 g 标志的 regexp, 全局替换)
    alert(s.replace(/L/, 'L')); // heLLo tom!   (regexp 的其它标志也生效, 如不区分大小的i, 还有多行的m)
    alert(s.replace(/\b\w+\b/g, function(word) {  // Hello Tom!  (把字符串中所有单词的首字母都转换为大写, 第二个参数使用函数的情况)
        return word.substring(0,1).toUpperCase()+word.substring(1);
    }));
    var s2 = '"a", "b"';
    alert(s2.replace(new RegExp('"([^"]*)"', 'g'), "'$1'")); // 'a', 'b'  (将双引号替换成单引号, 使用 $1、$2 等替位符)

// search:
    var s = "hello tom!"
    alert(s.search('[o]')); // 4   (如果参数不是 RegExp, 会自动转成 RegExp)
    alert(s.search(/o/g));  // 4   (RegExp 的 g 标志失效)
    alert(s.search('O'));   // -1  (大小写敏感)
    alert(s.search(/O/i));  // 4   (RegExp 的 i 标志依然生效)

// 字符串截取
    String 对象的方法 slice()、substring() 和 substr() （不建议使用）都可返回字符串的指定部分。
    slice() 比 substring() 要灵活一些，因为它允许使用负数作为参数。
    slice() 与 substr() 有所不同，因为它用两个字符的位置来指定子串，而 substr() 则用字符位置和长度来指定子串。
    还要注意的是, String.slice() 与 Array.slice() 相似。

    var str = "Hello happy world!";
    alert(str.slice(6)); // happy world!
    alert(str.slice(6,11)); // happy
    alert(str.slice(-6, -1)); // world
    alert(str.substr(6, 3)); // hap
    alert(str.substring(6,11)); // happy

// split:
    var str = "How are you doing today?";
    alert(str.split(" "));   // How,are,you,doing,today?
    alert(str.split(""));    // H,o,w, ,a,r,e, ,y,o,u, ,d,o,i,n,g, ,t,o,d,a,y,?
    alert(str.split(" ",3)); // How,are,you
    "|a|b||c".split("|")     // ["", "a", "b", "", "c"]      (分隔符分开的地方没有内容，则是"")
    "abc12df4gip8".split(/\d+/)   // ["abc", "df", "gip", ""]      (使用正则分隔)



/************* 给 String 额外添加函数 ************************/

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
 */
String.prototype.startWith = function(sub) {
    if (this == sub || sub == '') return true;
    return this.length >= sub.length && this.slice(0, sub.length) == sub;
};

/**
 * 判断是否以子串结尾
 * @param  {String} sub 被判断的子串
 * @return {String} 以子串结尾则返回 true，否则返回false
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


///////////////////// 工具类里去掉的 ///////////////////////////
/**
 * 全部替换字符串中的指定内容(正则表达式替换)
 * @param  {String} regexp 把字符串里的regexp内容替换成newSubStr(此参数会作为正则表达式的字符串处理)
 * @param  {String} newSubStr 把字符串里的regexp内容替换成newSubStr
 * @param  {String} flags 正则表达式的匹配方式,有: g global(全文查找出现的所有 pattern),i ignoreCase(忽略大小写),m multiLine(多行查找)；默认是 "gm"
 * @return {String} 替换后的字符串。注意：当regexp为空时,字符串的每个字前面都会加上newSubStr
 * @example
 *  "add dda".replaceAll('a', '55')  // 返回: "55dd dd55"
 *  "add+d+da".replaceAll('\\+', ' ')  // 支持正则表达式的字符串替换,特殊字符需要转义,返回: "add d da"
 */
String.prototype.replaceAll = function(regexp, newSubStr, flags) {
    regexp = regexp || '';
    newSubStr = newSubStr || '';
    flags = flags || 'gm';
    var raRegExp = new RegExp("" + regexp, flags);
    return this.replace(raRegExp, "" + newSubStr);
};
