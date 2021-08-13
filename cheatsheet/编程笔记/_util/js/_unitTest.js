/**
 * cm.js 工具类的测试类
 */

// 基本测试
cTest = window.cTest = window['cTest'] || function() {
    // chrome、opera 和 safari 浏览器不支持 window.onerror 事件,需捕获出错信息
    if (window.opera || window.navigator.userAgent.indexOf("Safari") > -1 ||
        window.navigator.userAgent.indexOf("Chrome") > -1) {
        Error = function(msg){ alert(msg); return msg;};
    }

    // 基本验证
    if (!window['c$'] || !c$() || c$() !== c$) throw new Error("没有 c$ 类,无法测试!");
    //if (c$.isTest !== true) throw new Error("c$.isTest 测试错误, 它的值为:" + c$.isTest);

    // 函数测试
    for (var fun in cTest) {
        if (typeof cTest[fun] == 'function') {
            cTest[fun]();
        }
    }
};

// 获取事件
cTest.getEvent = function() {
    var event = c$.getEvent();
    //获取不同浏览器的事件源
    var eventSource = event.target || event.srcElement;
    if(eventSource.tagName !== 'INPUT') throw new Error("获取 event 信息出错!");
};

/* ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 * 内置对象额外添加函数 start
 * --------------------------------------------------------------- */
// 字符串 trim
cTest.String_trim = function() {
    if (!"".trim) throw new Error("字符串的 trim 函数加载出错!");
    if (" dd dd ".trim() !== 'dd dd') throw new Error("字符串的 trim 函数,去除前后空格出错!");
    if ("　dd dd 　".trim() !== 'dd dd') throw new Error("字符串的 trim 函数,去除中文前后空格出错!");
};

// 字符串 startWith
cTest.String_startWith = function() {
    if (!"".startWith) throw new Error("字符串的 startWith 函数加载出错!");
    if ("add dda".startWith('ad') !== true) throw new Error("字符串的 startWith 函数判断出错!");
    if ("add dda".startWith('add ddaa') !== false) throw new Error("字符串的 startWith 函数判断出错!");
    if ("add dda".startWith('') !== true) throw new Error("字符串的 startWith 函数判断出错!");
};

// 字符串 endWith
cTest.String_endWith = function() {
    if (!"".endWith) throw new Error("字符串的 endWith 函数加载出错!");
    if ("add dda".endWith('dda') !== true) throw new Error("字符串的 endWith 函数判断出错!");
    if ("add dda".endWith('add ddaa') !== false) throw new Error("字符串的 endWith 函数判断出错!");
    if ("add dda".endWith('') !== true) throw new Error("字符串的 endWith 函数判断出错!");
};

// 字符串 format
cTest.String_format = function() {
    if (!"".format) throw new Error("字符串的 format 函数加载出错!");
    if ("#1 Name:#Name, Age:#Age".format({Name:"zhangsan", Age:23 }) !== "#1 Name:zhangsan, Age:23") throw new Error("字符串的 format 函数出错!");
    if ("#1 Name:#Name".format({1:"ZH", Age:23 }) !== "ZH Name:#Name") throw new Error("字符串的 format 函数出错!");
};

// 字符串 has
cTest.String_has = function() {
    if (!"".has) throw new Error("字符串的 has 函数加载出错!");
    if ("".has() !== false) throw new Error("字符串的 has 函数 空字符串处理 出错!");
    if ("哈哈看".has("chinese") !== true) throw new Error("字符串的 has 函数 全中文处理要求 出错!");
    if ("哈哈看".has("c") !== true) throw new Error("字符串的 has 函数 全中文处理要求(缩写) 出错!");
    if ("aaff".has('letter') !== true) throw new Error("字符串的 has 函数 英文处理 出错!");
    if ("aaff".has('l') !== true) throw new Error("字符串的 has 函数 英文处理(缩写) 出错!");
    if ("1234".has('number') !== true) throw new Error("字符串的 has 函数 数字处理 出错!");
    if ("1234".has('n') !== true) throw new Error("字符串的 has 函数 数字处理(缩写) 出错!");
    if ("，".has('symbols') !== true) throw new Error("字符串的 has 函数 中文符号处理 出错!");
    if ("，".has('s') !== true) throw new Error("字符串的 has 函数 中文符号处理 出错!");
    if ("哈哈，看".has('unicode') !== true) throw new Error("字符串的 has 函数 非拉丁文处理要求 出错!");
    if ("哈哈，看".has('u') !== true) throw new Error("字符串的 has 函数 非拉丁文处理要求 出错!");
    if ("aabb12".has('u') !== false) throw new Error("字符串的 has 函数 非拉丁文处理要求 出错!");
    if ("aa，ff".has("chinese", "letter") !== false) throw new Error("字符串的 has 函数 中文符号处理 出错!");
    if ("aa,ff".has("letter") !== true) throw new Error("字符串的 has 函数 英文符号处理 出错!");
    if ("aa哈哈123".has('c','n','l') !== true) throw new Error("字符串的 has 函数 中英文数字混合处理 出错!");
    if ("aa哈哈123".has('u','n','l') !== true) throw new Error("字符串的 has 函数 中英文数字混合处理 出错!");
    if ("aa哈哈".has('u','n') !== false) throw new Error("字符串的 has 函数 数字判断 出错!");
    if ("3.1415".has('n','l') !== false) throw new Error("字符串的 has 函数 英文处理 出错!");
    if ("3_1415aa".has('n','l') !== true) throw new Error("字符串的 has 函数 下划线处理 出错!");
    if ("3_1415aa".has('n','_','l') !== true) throw new Error("字符串的 has 函数 下划线处理 出错!");
    if ("31415aa".has('_') !== false) throw new Error("字符串的 has 函数 下划线处理 出错!");
    if ("aa哈哈".has("letter", "哼", "哈") !== false) throw new Error("字符串的 has 函数 指定字符处理 出错!");
};

// 字符串 is
cTest.String_is = function() {
    if (!"".is) throw new Error("字符串的 is 函数加载出错!");
    if ("".is() !== false) throw new Error("字符串的 is 函数 空字符串处理 出错!");
    if ("哈哈看".is("chinese") !== true) throw new Error("字符串的 is 函数 全中文处理要求 出错!");
    if ("哈哈看".is("c") !== true) throw new Error("字符串的 is 函数 全中文处理要求(缩写) 出错!");
    if ("aaff".is('letter') !== true) throw new Error("字符串的 is 函数 英文处理 出错!");
    if ("aaff".is('l') !== true) throw new Error("字符串的 is 函数 英文处理(缩写) 出错!");
    if ("1234".is('number') !== true) throw new Error("字符串的 is 函数 数字处理 出错!");
    if ("1234".is('n') !== true) throw new Error("字符串的 is 函数 数字处理(缩写) 出错!");
    if ("，".is('symbols') !== true) throw new Error("字符串的 is 函数 中文符号处理 出错!");
    if ("，".is('s') !== true) throw new Error("字符串的 is 函数 中文符号处理 出错!");
    if ("哈哈，看".is('unicode') !== true) throw new Error("字符串的 is 函数 非拉丁文处理要求 出错!");
    if ("哈哈，看".is('u') !== true) throw new Error("字符串的 is 函数 非拉丁文处理要求 出错!");
    if ("aabb12".is('u') !== false) throw new Error("字符串的 is 函数 非拉丁文处理要求 出错!");
    if ("aa，ff".is("chinese", "letter") !== false) throw new Error("字符串的 is 函数 中文符号处理 出错!");
    if ("aa,ff".is("letter") !== false) throw new Error("字符串的 is 函数 英文符号处理 出错!");
    if ("aa哈哈123".is('c','n','l') !== true) throw new Error("字符串的 is 函数 中英文数字混合处理 出错!");
    if ("aa哈哈123".is('u','n','l') !== true) throw new Error("字符串的 is 函数 中英文数字混合处理 出错!");
    if ("3.1415".is('n','l') !== false) throw new Error("字符串的 is 函数 英文符号处理 出错!");
    if ("3_1415aa".is('n','l') !== false) throw new Error("字符串的 is 函数 下划线处理 出错!");
    if ("3_1415aa".is('n','_','l') !== true) throw new Error("字符串的 is 函数 下划线处理 出错!");
    if ("aa哈哈".is("letter", "哼", "哈") !== true) throw new Error("字符串的 is 函数 指定字符处理 出错!");
};

// 字符串 isEmail
cTest.String_isEmail = function() {
    if (!"".isEmail) throw new Error("字符串的 isEmail 函数加载出错!");
    if ("".isEmail() !== false) throw new Error("字符串的 isEmail 函数 空字符串处理 出错!");
    if ("哈哈@看看.中国".isEmail() !== false) throw new Error("字符串的 isEmail 函数 全中文处理 出错!");
    if ("daillow@gmail.com".isEmail() !== true) throw new Error("字符串的 isEmail 函数 普通邮箱地址处理 出错!");
    if ("daillo@163.com".isEmail() !== true) throw new Error("字符串的 isEmail 函数 数字域名处理 出错!");
    if ("292598441@qq.com".isEmail() !== true) throw new Error("字符串的 isEmail 函数 数字用户名处理 出错!");
    if ("daillo@yahoo.com.cn".isEmail() !== true) throw new Error("字符串的 isEmail 函数 多级域名处理 出错!");
    if ("abc-d.54dd@fer-dde-gg_ff.com".isEmail() !== true) throw new Error("字符串的 isEmail 函数 特殊名称处理 出错!");
    if ("daillow#gmail.com".isEmail() !== false) throw new Error("字符串的 isEmail 函数 没有@符号处理 出错!");
    if ("dai@llow@gmail.com".isEmail() !== false) throw new Error("字符串的 isEmail 函数 多个@符号处理 出错!");
    if ("daillow@gmail".isEmail() !== false) throw new Error("字符串的 isEmail 函数 没有后缀域名处理 出错!");
    if ("@gmail.com".isEmail() !== false) throw new Error("字符串的 isEmail 函数 没有用户名处理 出错!");
    if ("daillow@".isEmail() !== false) throw new Error("字符串的 isEmail 函数 没有域名处理 出错!");
    if ("daillow@-gmail.com".isEmail() !== false) throw new Error("字符串的 isEmail 函数 出错域名处理 出错!"); // “-”不能在域名开头
    if ("daillow@gmail-.com".isEmail() !== false) throw new Error("字符串的 isEmail 函数 出错域名处理 出错!"); // “-”不能在域名结尾
    if ("daillow@gmail.com-".isEmail() !== false) throw new Error("字符串的 isEmail 函数 出错域名处理 出错!"); // “-”不能在域名结尾
    if ("daillow@gm--ail.com".isEmail() !== false) throw new Error("字符串的 isEmail 函数 出错域名处理 出错!"); // “-”不能在域名里连续出现
    if ("daillow@192.168.1.100".isEmail() !== true) throw new Error("字符串的 isEmail 函数 普通ip地址处理 出错!");
    if ("daillow@1.0.0.1".isEmail() !== true) throw new Error("字符串的 isEmail 函数 开始ip地址处理 出错!");
    if ("daillow@155.255.255.255".isEmail() !== true) throw new Error("字符串的 isEmail 函数 结束ip地址处理 出错!");
    if ("daillow@1.0.0.0".isEmail() !== false) throw new Error("字符串的 isEmail 函数 开始ip地址处理 出错!");
    if ("daillow@0.0.0.1".isEmail() !== false) throw new Error("字符串的 isEmail 函数 开始ip地址处理 出错!");
    if ("daillow@123.01.01.1".isEmail() !== false) throw new Error("字符串的 isEmail 函数 ip每段都不能0开头 出错!");
    if ("daillow@321.1.1.1".isEmail() !== false) throw new Error("字符串的 isEmail 函数 ip超过255处理 出错!");
    if ("daillow@1.321.1.1".isEmail() !== false) throw new Error("字符串的 isEmail 函数 ip超过255处理 出错!");
};

// 字符串 isDate
cTest.String_isDate = function() {
    if (!"".isDate) throw new Error("字符串的 isDate 函数加载出错!");
    if ("".isDate() !== false) throw new Error("字符串的 isDate 函数 空字符串处理 出错!");
    if ("abcde".isDate() !== false) throw new Error("字符串的 isDate 函数 普通日期处理 出错!");
    if ("二零零九年五月十二日".isDate() !== false) throw new Error("字符串的 isDate 函数 全中文处理 出错!");
    if ("1203-02-08".isDate() !== true) throw new Error("字符串的 isDate 函数 普通日期处理 出错!");
    if ("2011-2-2".isDate() !== true) throw new Error("字符串的 isDate 函数 普通日期处理 出错!");
    if ("2011/10/28".isDate() !== true) throw new Error("字符串的 isDate 函数 普通日期处理 出错!");
    if ("2011.10.28".isDate() !== true) throw new Error("字符串的 isDate 函数 普通日期处理 出错!");
    if ("2011年10月28日".isDate() !== true) throw new Error("字符串的 isDate 函数 中文日期处理 出错!");
    if ("2011年10月28".isDate() !== true) throw new Error("字符串的 isDate 函数 中文日期处理 出错!");
    if ("2011-2-29".isDate() !== false) throw new Error("字符串的 isDate 函数 不存在的日期处理 出错!");
    if ("2011-4-31".isDate() !== false) throw new Error("字符串的 isDate 函数 不存在的日期处理 出错!");
    if ("2011-13-28".isDate() !== false) throw new Error("字符串的 isDate 函数 不存在的日期处理 出错!");
    if ("11/10/28".isDate() !== true) throw new Error("字符串的 isDate 函数 短年份日期处理 出错!");
    if ("11年10月28日".isDate() !== true) throw new Error("字符串的 isDate 函数 中文短日期处理 出错!");
    if ("20111028".isDate() !== true) throw new Error("字符串的 isDate 函数 无符号日期处理 出错!");
    if ("111028".isDate() !== true) throw new Error("字符串的 isDate 函数 无符号短日期处理 出错!");
    if ("2011a10a28".isDate() !== false) throw new Error("字符串的 isDate 函数 普通日期处理 出错!");
    if ("2011-0-0".isDate() !== false) throw new Error("字符串的 isDate 函数 普通日期处理 出错!");
    if ("10-28".isDate() !== false) throw new Error("字符串的 isDate 函数 普通日期处理 出错!");
    if ("2011/10-28".isDate() !== false) throw new Error("字符串的 isDate 函数 符号不一致处理 出错!");
    if ("2011-10/28".isDate() !== false) throw new Error("字符串的 isDate 函数 符号不一致处理 出错!");
    if ("2011-1028".isDate() !== false) throw new Error("字符串的 isDate 函数 符号不一致处理 出错!");
    if ("2011年10/28".isDate() !== false) throw new Error("字符串的 isDate 函数 符号不一致处理 出错!");
    if ("2011928".isDate() !== true) throw new Error("字符串的 isDate 函数 无符号短日期处理 出错!");
    if ("201188".isDate() !== true) throw new Error("字符串的 isDate 函数 无符号短日期处理 出错!");
    if ("2011229".isDate() !== false) throw new Error("字符串的 isDate 函数 无符号短日期,不存在的日期处理 出错!");
    if ("2011131".isDate() !== true) throw new Error("字符串的 isDate 函数 无符号短日期处理 出错!");
    if ("20110131".isDate() !== true) throw new Error("字符串的 isDate 函数 无符号日期处理 出错!");
    if ("20111301".isDate() !== false) throw new Error("字符串的 isDate 函数 无符号日期处理 出错!");
};

// 字符串 isTime
cTest.String_isTime = function() {
    if (!"".isTime) throw new Error("字符串的 isTime 函数加载出错!");
    if ("".isTime() !== false) throw new Error("字符串的 isTime 函数 空字符串处理 出错!");
    if ("abcde".isTime() !== false) throw new Error("字符串的 isTime 函数 普通时间处理 出错!");
    if ("03:04:06".isTime() !== true) throw new Error("字符串的 isTime 函数 普通时间处理 出错!");
    if ("23:4:6".isTime() !== true) throw new Error("字符串的 isTime 函数 普通时间处理 出错!");
    if ("03时05分10秒".isTime() !== true) throw new Error("字符串的 isTime 函数 中文时间处理 出错!");
    if ("3时5分0秒".isTime() !== true) throw new Error("字符串的 isTime 函数 中文短时间处理 出错!");
    if ("0:0:0".isTime() !== true) throw new Error("字符串的 isTime 函数 普通时间处理 出错!");
    if ("0时0分0秒".isTime() !== true) throw new Error("字符串的 isTime 函数 中文短时间处理 出错!");
    if ("24时60分60秒".isTime() !== false) throw new Error("字符串的 isTime 函数 中文结束时间处理 出错!");
    if ("24:60:60".isTime() !== false) throw new Error("字符串的 isTime 函数 结束时间处理 出错!");
    if ("24:0:0".isTime() !== false) throw new Error("字符串的 isTime 函数 结束时间处理 出错!");
    if ("25:1:1".isTime() !== false) throw new Error("字符串的 isTime 函数 结束时间处理 出错!");
    if ("0:60:0".isTime() !== false) throw new Error("字符串的 isTime 函数 结束时间处理 出错!");
    if ("3:61:5".isTime() !== false) throw new Error("字符串的 isTime 函数 结束时间处理 出错!");
    if ("0:0:60".isTime() !== false) throw new Error("字符串的 isTime 函数 结束时间处理 出错!");
    if ("3:4:61".isTime() !== false) throw new Error("字符串的 isTime 函数 结束时间处理 出错!");
    if ("3:41".isTime() !== false) throw new Error("字符串的 isTime 函数 普通时间处理 出错!");
    if ("3:41:".isTime() !== false) throw new Error("字符串的 isTime 函数 普通时间处理 出错!");
    if ("::".isTime() !== false) throw new Error("字符串的 isTime 函数 普通时间处理 出错!");
    if ("23 32 41".isTime() !== false) throw new Error("字符串的 isTime 函数 普通时间处理 出错!");
    if ("03时05分".isTime() !== false) throw new Error("字符串的 isTime 函数 中文时间处理 出错!");
    if ("233241".isTime() !== true) throw new Error("字符串的 isTime 函数 无符号时间处理 出错!");
    if ("23:4:6.532".isTime() !== true) throw new Error("字符串的 isTime 函数 秒之后时间处理 出错!");
    if ("23:4:3532".isTime() !== false) throw new Error("字符串的 isTime 函数 秒之后时间处理 出错!");
    if ("23时4分6秒532".isTime() !== true) throw new Error("字符串的 isTime 函数 中文秒之后时间处理 出错!");
    if ("23时4分6秒532毫秒".isTime() !== true) throw new Error("字符串的 isTime 函数 中文秒之后时间处理 出错!");
    if ("23:4:6.3".isTime() !== true) throw new Error("字符串的 isTime 函数 秒之后时间处理 出错!");
    if ("030510".isTime() !== true) throw new Error("字符串的 isTime 函数 无符号时间处理 出错!");
    if ("030510532".isTime() !== true) throw new Error("字符串的 isTime 函数 无符号时间,秒后面有数字处理 出错!");
    if ("03时05:10秒".isTime() !== false) throw new Error("字符串的 isTime 函数 中文时间处理 出错!");
    if ("03时05:10".isTime() !== false) throw new Error("字符串的 isTime 函数 中文时间处理 出错!");
    if ("03:05分10".isTime() !== false) throw new Error("字符串的 isTime 函数 中文时间处理 出错!");
    if ("03:05:10秒".isTime() !== false) throw new Error("字符串的 isTime 函数 中文时间处理 出错!");
};

// 字符串 isDateTime
cTest.String_isDateTime = function() {
    if (!"".isDateTime) throw new Error("字符串的 isDateTime 函数加载出错!");
    if ("".isDateTime() !== false) throw new Error("字符串的 isDateTime 函数 空字符串处理 出错!");
    if ("1203-02-08 12:03:05".isDateTime() !== true) throw new Error("字符串的 isDateTime 函数 普通时间处理 出错!");
    if ("1203/02/08 12:03:05".isDateTime() !== true) throw new Error("字符串的 isDateTime 函数 普通时间处理 出错!");
    if ("1203.02.08 12:03:05".isDateTime() !== true) throw new Error("字符串的 isDateTime 函数 普通时间处理 出错!");
    if ("1203-2-8 23:3:5".isDateTime() !== true) throw new Error("字符串的 isDateTime 函数 普通时间处理 出错!");
    if ("1203年02月08日 12时03分05秒".isDateTime() !== true) throw new Error("字符串的 isDateTime 函数 中文时间处理 出错!");
    if ("1203年2月8日23时3分5秒".isDateTime() !== true) throw new Error("字符串的 isDateTime 函数 中文时间处理 出错!");
    if ("2011-2-2".isDateTime() !== false) throw new Error("字符串的 isDateTime 函数 普通时间处理 出错!");
    if ("23:4:6".isDateTime() !== false) throw new Error("字符串的 isDateTime 函数 普通时间处理 出错!");
    if ("2011.10.28 2:3:8.365".isDateTime() !== true) throw new Error("字符串的 isDateTime 函数 秒之后时间处理 出错!");
    if ("1203年02月08日 12:03:05".isDateTime() !== true) throw new Error("字符串的 isDateTime 函数 中文时间处理 出错!");
    if ("1203年02月08日12:03:05".isDateTime() !== true) throw new Error("字符串的 isDateTime 函数 中文时间处理 出错!");
    if ("1203/02/08 23时4分6秒".isDateTime() !== true) throw new Error("字符串的 isDateTime 函数 普通时间处理 出错!");
    if ("12030208230406".isDateTime() !== true) throw new Error("字符串的 isDateTime 函数 无符号时间处理 出错!");
    if ("12030208230406".isDateTime() !== true) throw new Error("字符串的 isDateTime 函数 无符号时间处理 出错!");
};
/*
// 字符串 isUrl
cTest.String_isUrl = function() {
    if (!"".isUrl) throw new Error("字符串的 isUrl 函数加载出错!");
    if ("".isUrl() !== false) throw new Error("字符串的 isUrl 函数 空字符串处理 出错!");
    if ("http://www.163.com".isUrl() !== true) throw new Error("字符串的 isUrl 函数 普通网址处理 出错!");
    if ("https://www.baidu.com/".isUrl() !== true) throw new Error("字符串的 isUrl 函数 普通网址处理 出错!");
    if ("ftp://a.abc.cn/index.html?aa=98&jj=abs".isUrl() !== true) throw new Error("字符串的 isUrl 函数 普通网址处理 出错!");
    if ("http://163.com/?aa=98&jj=abs".isUrl() !== true) throw new Error("字符串的 isUrl 函数 普通网址处理 出错!");
    if ("http://www.网易.com/?aa=测试值&jj=哈".isUrl() !== true) throw new Error("字符串的 isUrl 函数 中文网址处理 出错!");
    if ("abcde".isUrl() !== false) throw new Error("字符串的 isUrl 函数 普通网址处理 出错!");
    if ("12345".isUrl() !== false) throw new Error("字符串的 isUrl 函数 普通网址处理 出错!");
    if ("http://www\\\\/////c.....om&&&???ddd".isUrl() !== false) throw new Error("字符串的 isUrl 函数 普通网址处理 出错!");
    if ("http://1234456".isUrl() !== false) throw new Error("字符串的 isUrl 函数 普通网址处理 出错!");
};
*/

// 日期 format
cTest.Date_format = function() {
    // 设时间为：    2013/1/9 13:3:58.332
    var d = new Date(2013,0,9,13,3,58,332); // 注意月份数值,从0开始的
    var d2 = new Date(2013,10,19,10,21,8,12);
    // 年份
    if (d.format('y') !== '3') throw new Error("日期的 format 出错,一位小写年份错误!");
    if (d.format('Y') !== '3') throw new Error("日期的 format 出错,一位大写年份错误!");
    if (d.format('yy') !== '13' || d.format('YY') !== '13') throw new Error("日期的 format 出错,两位年份错误!");
    if (d.format('yyy') !== '013' || d.format('YYY') !== '013') throw new Error("日期的 format 出错,三位年份错误!");
    if (d.format('yyyy') !== '2013' || d.format('YYYY') !== '2013') throw new Error("日期的 format 出错,四位年份错误!");
    if (d.format('yyyyy') !== '2013y' || d.format('YYYYYY') !== '2013YY') throw new Error("日期的 format 出错,超过四位年份错误!");
    // 年份
    if (d.format('M') !== '1') throw new Error("日期的 format 出错,一位月份错误!");
    if (d.format('MM') !== '01') throw new Error("日期的 format 出错,两位月份错误!");
    if (d.format('MMMM') !== '01MM') throw new Error("日期的 format 出错,超过两位月份错误!");
    if (d2.format('M') !== '11') throw new Error("日期的 format 出错,一位月份错误,此时应返回两位月份!");
    // 日期
    if (d.format('d') !== '9') throw new Error("日期的 format 出错,一位日期错误!");
    if (d.format('dd') !== '09') throw new Error("日期的 format 出错,两位日期错误!");
    if (d.format('ddd') !== '09d') throw new Error("日期的 format 出错,超过两位日期错误!");
    if (d2.format('d') !== '19') throw new Error("日期的 format 出错,一位日期错误,此时应返回两位日期!");
    // 小时
    if (d.format('h') !== '1') throw new Error("日期的 format 出错,一位12小时错误!");
    if (d2.format('h') !== '10') throw new Error("日期的 format 出错,一位12小时错误,此时应返回两位12小时!");
    if (d.format('hh') !== '01') throw new Error("日期的 format 出错,两位12小时错误!");
    if (d.format('hhh') !== '01h') throw new Error("日期的 format 出错,超过两位12小时错误!");
    if (d.format('H') !== '13') throw new Error("日期的 format 出错,一位24小时错误!");
    if (d.format('HH') !== '13') throw new Error("日期的 format 出错,两位24小时错误!");
    if (d.format('HHH') !== '13H') throw new Error("日期的 format 出错,超过两位24小时错误!");
    // 分钟
    if (d.format('m') !== '3') throw new Error("日期的 format 出错,一位分钟错误!");
    if (d.format('mm') !== '03') throw new Error("日期的 format 出错,两位分钟错误!");
    if (d.format('mmm') !== '03m') throw new Error("日期的 format 出错,超过两位分钟错误!");
    if (d2.format('m') !== '21') throw new Error("日期的 format 出错,一位分钟错误,此时应返回两位分钟!");
    // 秒
    if (d2.format('s') !== '8') throw new Error("日期的 format 出错,一位秒错误!");
    if (d2.format('ss') !== '08') throw new Error("日期的 format 出错,两位秒错误!");
    if (d2.format('sss') !== '08s') throw new Error("日期的 format 出错,超过两位秒错误!");
    if (d.format('s') !== '58') throw new Error("日期的 format 出错,一位秒错误,此时应返回两位秒!");
    // 季度
    if (d.format('q') !== '1') throw new Error("日期的 format 出错,一位季度错误!");
    if (d.format('qq') !== '01') throw new Error("日期的 format 出错,两位季度错误!");
    if (d.format('qqq') !== '01q') throw new Error("日期的 format 出错,超过两位季度错误!");
    // 毫秒
    if (d.format('S') !== '332') throw new Error("日期的 format 出错,一位毫秒错误,应显示3位!");
    if (d2.format('S') !== '12') throw new Error("日期的 format 出错,一位毫秒错误,应显示2位!");
    if (d.format('SS') !== '332S') throw new Error("日期的 format 出错,超过一位毫秒错误!");
    if (d2.format('SS') !== '12S') throw new Error("日期的 format 出错,超过一位毫秒错误!");
    // 星期
    if (d.format('E') !== '三') throw new Error("日期的 format 出错,一位星期错误!");
    if (d.format('EE') !== '周三') throw new Error("日期的 format 出错,两位季度错误!");
    if (d.format('EEE') !== '星期三') throw new Error("日期的 format 出错,两位季度错误!");
    if (d.format('EEEEE') !== '星期三EE') throw new Error("日期的 format 出错,超过两位季度错误!");
    // 综合
    if (d.format('yyyy/MM-dd HH:mm:ss.S EEE') != '2013/01-09 13:03:58.332 星期三') throw new Error("日期的 format 出错,综合错误!");
};

// 数组 clear
cTest.Array_clear = function() {
    var arr = [1, 2, 3, 'a', 'b', {a:5, b:[1,2]}];
    if (!arr.clear) throw new Error("数组的 clear 函数加载出错!");
    var tem_arr = arr.clear();
    if (arr.length !== 0) throw new Error("数组的 clear 出错,数量错误!");
    if (arr[0] !== undefined) throw new Error("数组的 clear 出错,值错误!");
    if (tem_arr !== arr) throw new Error("数组的 clear 函数支持连缀出错!");
};

// 数组 indexOf
cTest.Array_indexOf = function() {
    var arr = ['a', 'b', 'c', 'd', 'c', 2];
    if (!arr.indexOf) throw new Error("数组的 indexOf 函数加载出错!");
    if (arr.indexOf('c') !== 2) throw new Error("数组的 indexOf 出错,查找存在的值出错!");
    if (arr.indexOf('e') !== -1) throw new Error("数组的 indexOf 出错,查找不存在的值出错!");
    //if (arr.indexOf('2') !== -1) throw new Error("数组的 indexOf 出错,值不是完全匹配!");
};

// 数组 lastIndexOf
cTest.Array_lastIndexOf = function() {
    var arr = ['a', 'b', 'c', 'd', 'c', 2];
    if (!arr.lastIndexOf) throw new Error("数组的 lastIndexOf 函数加载出错!");
    if (arr.lastIndexOf('c') !== 4) throw new Error("数组的 lastIndexOf 出错,查找存在的值出错!");
    if (arr.lastIndexOf('e') !== -1) throw new Error("数组的 lastIndexOf 出错,查找不存在的值出错!");
    //if (arr.indexOf('2') !== -1) throw new Error("数组的 lastIndexOf 出错,值不是完全匹配!");
};

// 数组 contains
cTest.Array_contains = function() {
    var arr = ['a', 'b', 'c', 'd', {a:5, b:[1,2]}, 2];
    if (!arr.contains) throw new Error("数组的 contains 函数加载出错!");
    if (arr.contains('c') !== true) throw new Error("数组的 contains 出错,比较存在的值出错!");
    if (arr.contains('e') !== false) throw new Error("数组的 contains 出错,比较不存在的值出错!");
    //if (arr.contains('2') !== false) throw new Error("数组的 contains 出错,比较的值不完全匹配出错!");
    if (arr.contains('c', 'a') !== true) throw new Error("数组的 contains 多值判断出错,比较存在的值出错!");
    if (arr.contains('a', 'e') !== false) throw new Error("数组的 contains 多值判断出错,比较不存在的值出错!");
};

// 数组 clone
cTest.Array_clone = function() {
    var arr = ['a', 'b', 'c', 'd', {a:5, b:[1,2]}];
    if (!arr.clone) throw new Error("数组的 clone 函数加载出错!");
    var arr2 = arr.clone();
    if (arr === arr2) throw new Error("数组的 clone 出错,影响原数组或者没有拷贝出来!");
    if (arr.length !== 5) throw new Error("数组的 clone 出错,破坏原数组!");
    if (arr.length !== arr2.length) throw new Error("数组的 clone 出错,数组长度不同!");
    for (var i=0; i<arr.length; i++) {
        if (arr2[i] !== arr[i]) throw new Error("数组的 clone 出错, 数组里的值被修改!");
    }
};

// 数组 removeAll
cTest.Array_removeAll = function() {
    var arr = ['a', '2', 'c', 'd', 'c', 'f', 'f'];
    if (!arr.removeAll) throw new Error("数组的 removeAll 函数加载出错!");
    arr.removeAll('c'); // 变为 ['a', '2', 'd', 'f', 'f']
    if (arr.length !== 5) throw new Error("数组 removeAll 后,数量出错!");
    if (arr[3] !== 'f') throw new Error("数组的 removeAll 后,值被修改出错!");
    arr.removeAll('a', 'd'); // 变为 ['2', 'f', 'f']
    if (arr.length !== 3) throw new Error("数组 removeAll 后,数量出错!");
    arr.removeAll('e', 'd'); // 删除没有的值, 变为 ['2', 'f', 'f']
    if (arr.length !== 3) throw new Error("数组 removeAll 后,数量出错!");
    var tem_arr = arr.removeAll(2); // 值需要完全匹配才被删除,变为 ['2', 'f', 'f']
    if (arr.length !== 3) throw new Error("数组 removeAll 后,数量出错!");
    if (arr[0] !== '2') throw new Error("数组 removeAll 后,值被修改出错!");
    if (arr[1] !== 'f') throw new Error("数组 removeAll 后,值被修改出错!");
    if (arr[2] !== 'f') throw new Error("数组 removeAll 后,值被修改出错!");
    if (tem_arr !== arr) throw new Error("数组的 removeAll 函数支持连缀出错!");
};

/* -------------------------------------------------------------------
 * 内置对象额外添加函数 end
 * ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ */

// cookie 测试
cTest.cookie = function() {
    var theName = "计数器";
    var count = c$.cookie(theName) >> 0;
    count += 1;
    alert("这是第 " + count + " 次访问本页面");
    c$.cookie(theName, count, {
       expires: 1
    });
};


