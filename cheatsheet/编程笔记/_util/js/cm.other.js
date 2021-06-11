/**
 * 工具类 cm.js 的额外补充(一些不常用的函数抽离出来,减少主文件体积,用到时再加入),所有函数填充到“c$”类里面,以减少关键字占用。
 * 用法参照 cm.js 文件
 */
(function(window, undefined) {

var document = window.document,
	navigator = window.navigator,
	location = window.location;

// 基础类
c$ = window.c$ = window['c$'] || function() {
    return c$;
};
// 测试类
cTest = window.cTest = window['cTest'] || function() {
};


// 该段代码属于业务逻辑代码，故移出类库,有需要时再写进逻辑加载共用文件
/**
 * 当页面上按下 Enter 时执行指定的 doEnter() 函数
 * @param event firefox时用以接收事件
 */
window.document.onkeydown = function(event) {
    // 为兼顾 IE 和 FireFox
    event = event || window.event;
    // 如果取不到页面事件
    if (!event) return;
    // 获取页面上的按键码
    var currentKey = event.charCode || event.keyCode;
    // 获取事件源
    var eventSource = event.target || event.srcElement;
    // 多行输入框,允许输入换行符
    if ("TEXTAREA" == eventSource.tagName) return;
    // 如果是 Enter 键, 执行指定程序
    if (13 === currentKey) {
        // 执行指定程序
        try {
            // 这里约定页面的回车触发 doEnter() 函数
            if (window['doEnter'] && typeof(doEnter) == "function") {
                doEnter();
            }
        }
        catch (e) {}
        event.returnValue = false;
    }
};


// w3c标准浏览器就FIX,让火狐等标准浏览器兼容IE的部分写法
try {
    if (!window['addEventListener']) throw new Error("非标准浏览器,不再执行");

    if (window['constructor'] && window.constructor.prototype.__defineGetter__) {
        // window.event 兼容
        window.constructor.prototype.__defineGetter__("event", c$.getEvent);
    }

    if (window['Event'] && Event.prototype.__defineGetter__) {
        // event.srcElement 兼容；获取浏览器的事件源
        Event.prototype.__defineGetter__("srcElement", function(){ return this.target || this.srcElement; });

        // event.fromElement 兼容
        Event.prototype.__defineGetter__("fromElement",  function(){
            var node;
            if (this.type == "mouseover") {
                node = this.relatedTarget;
            }
            else if (this.type == "mouseout") {
                node = this.target;
            }
            if (!node) return;
            while (node.nodeType != 1) {
                node = node.parentNode;
            }
            return node;
        });

        // event.toElement 兼容
        Event.prototype.__defineGetter__("toElement",  function(){
            var node;
            if (this.type == "mouseout") {
                node = this.relatedTarget;
            }
            else if (this.type == "mouseover") {
                node = this.target;
            }
            if (!node) return;
            while (node.nodeType != 1) {
                node = node.parentNode;
            }
            return node;
        });
    }

    if (window['HTMLElement'] && HTMLElement.prototype.__defineGetter__) {
        // <element>.runtimeStyle 兼容
        HTMLElement.prototype.__defineGetter__("runtimeStyle", function(){ return this.style; });

        // <element>.innerText 兼容 (Getter)
        HTMLElement.prototype.__defineGetter__("innerText", function(){
            var anyString = "";
            var childS = this.childNodes;
            for (var i = 0, length = childS.length; i < length; i++) {
                if (childS[i].nodeType == 1)
                    anyString += childS[i].tagName == "BR" ? '\n' : childS[i].innerText;
                else if(childS[i].nodeType == 3) {
                    anyString += childS[i].nodeValue;
                }
            }
            return anyString;
        });
        // <element>.innerText 兼容 (Setter)
        HTMLElement.prototype.__defineSetter__("innerText", function(sText) { this.textContent = sText; });
    }
} catch(e){}


/**
 * 获取字符长度
 * @param  {Number} chsLength 一个非拉丁文(如中文)占多少个字符，默认为2个 (改数据库时需改这里)
 * @return {Number} 字符长度
 * @example "aa哈哈".chsLeng() // 返回: 6
 */
String.prototype.chsLeng = function(chsLength) {
    chsLength = (parseInt(chsLength) >= 0) ? parseInt(chsLength) : 2;
    //去除非拉丁文(如中文)的长度
    var noChsLength = this.replace(new RegExp('[^\x00-\xff]','gm'), "").length;
    //中文长度
    var chineseLength = (this.length - noChsLength) * chsLength;
    return noChsLength + chineseLength;
};
// 字符串 chsLeng
cTest.String_chsLeng = function() {
    if (!"".chsLeng) throw new Error("字符串的 chsLeng 函数加载出错!");
    if ("aa哈哈".chsLeng() !== 6) throw new Error("字符串的 chsLeng 函数默认参数出错!");
    if ("aa哈哈".chsLeng(3) !== 8) throw new Error("字符串的 chsLeng 函数传入参数出错!");
};

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
// 字符串 replaceAll
cTest.String_replaceAll = function() {
    if (!"".replaceAll) throw new Error("字符串的 replaceAll 函数加载出错!");
    if ("add dda".replaceAll('a', '55') !== "55dd dd55") throw new Error("字符串的 replaceAll 函数平常替换出错!");
    if ("哈d哈d dda".replaceAll('哈', '嘿') !== "嘿d嘿d dda") throw new Error("字符串的 replaceAll 函数中文替换出错!");
    if ("哈d哈d+d+da".replaceAll('[+]', ' ') !== "哈d哈d d da") throw new Error("字符串的 replaceAll 函数正则替换出错!");
};

/**
 * 全部替换字符串中的指定内容(非正则表达式替换)
 * @param oldStr 要替换的内容
 * @param newStr 替换成这个内容
 * @return 替换后的字符串。注意：当 oldStr 为空时,不会替换
 * @example
 *  "add dda".replaceAllStr('a', '55')  // 返回: "55dd dd55"
 *  "add+d+da".replaceAllStr('+', ' ')   // 不支持正则表达式的字符串替换,返回: "add d da"
 */
String.prototype.replaceAllStr = function(oldStr, newStr) {
    if (!oldStr) return this;
    var str = this;
    while(str.indexOf(oldStr) != -1) str = str.replace(oldStr, newStr);
    return str;
};
// 字符串 replaceAllStr
cTest.String_replaceAllStr = function() {
    if (!"".replaceAllStr) throw new Error("字符串的 replaceAllStr 函数加载出错!");
    if ("add dda".replaceAllStr('a', '55') !== "55dd dd55") throw new Error("字符串的 replaceAllStr 函数平常替换出错!");
    if ("哈d哈d dda".replaceAllStr('哈', '嘿') !== "嘿d嘿d dda") throw new Error("字符串的 replaceAllStr 函数中文替换出错!");
    // 正则替换
    if ('ab\\c[a]\\[d]'.replaceAllStr('\\', ' ') !== 'ab c[a] [d]')  throw new Error('字符串 replaceAllStr 函数, “\\”斜杠 替换出错!');
    if ('abc[a],[d]'.replaceAllStr('[', ' ') !== 'abc a], d]')  throw new Error('字符串 replaceAllStr 函数, “[” 替换出错!');
    if ('abc[a],[d]'.replaceAllStr(']', ' ') !== 'abc[a ,[d ')  throw new Error('字符串 replaceAllStr 函数, “]” 替换出错!');
    if ('ab/c[a]/[d]'.replaceAllStr('/', ' ') !== 'ab c[a] [d]')  throw new Error('字符串 replaceAllStr 函数, “/” 替换出错!');
    if ('5.25.36.1'.replaceAllStr('.', '-') !== '5-25-36-1')  throw new Error('字符串 replaceAllStr 函数, “.” 替换出错!');
    if ('abc{a},{{d}}'.replaceAllStr('{', ' ') !== 'abc a},  d}}')  throw new Error('字符串 replaceAllStr 函数, “{” 替换出错!');
    if ('abc{a},{{d}}'.replaceAllStr('}', ' ') !== 'abc{a ,{{d  ')  throw new Error('字符串 replaceAllStr 函数, “}” 替换出错!');
    if ('abc(a),((d))'.replaceAllStr('(', ' ') !== 'abc a),  d))')  throw new Error('字符串 replaceAllStr 函数, “(” 替换出错!');
    if ('abc(a),((d))'.replaceAllStr(')', ' ') !== 'abc(a ,((d  ')  throw new Error('字符串 replaceAllStr 函数, “)” 替换出错!');
    if ('abc|a||d'.replaceAllStr('|', ' ') !== 'abc a  d')  throw new Error('字符串 replaceAllStr 函数, “|” 替换出错!');
    if ('abc^a^^d'.replaceAllStr('^', ' ') !== 'abc a  d')  throw new Error('字符串 replaceAllStr 函数, “^” 替换出错!');
    if ('abc$a$$d'.replaceAllStr('$', ' ') !== 'abc a  d')  throw new Error('字符串 replaceAllStr 函数, “$” 替换出错!');
    if ('abc*a**d'.replaceAllStr('*', ' ') !== 'abc a  d')  throw new Error('字符串 replaceAllStr 函数, “*” 替换出错!');
    if ('abc+a++d'.replaceAllStr('+', ' ') !== 'abc a  d')  throw new Error('字符串 replaceAllStr 函数, “+” 替换出错!');
    if ('abc?a??d'.replaceAllStr('?', ' ') !== 'abc a  d')  throw new Error('字符串 replaceAllStr 函数, “?” 替换出错!');
    if ('abc-a--d'.replaceAllStr('-', ' ') !== 'abc a  d')  throw new Error('字符串 replaceAllStr 函数, “-” 替换出错!');
    // 混合正则替换
    if ('abc(?a),(?(d))'.replaceAllStr('(?', ' ') !== 'abc a), (d))')  throw new Error('字符串 replaceAllStr 函数, “(?”混合替换出错!');
};

// opera浏览器 没有 数组的 concat 函数,兼容它
[].concat || (Array.prototype.concat = function(){
    var array = [];
    for (var i = 0, length = this.length; i < length; i++) array.push(this[i]);
    for (var i = 0, length = arguments.length; i < length; i++) {
        if(arguments[i].constructor == Array) {
            for(var j = 0, arrayLength = arguments[i].length; j < arrayLength; j++) {
                array.push(arguments[i][j]);
            }
        } else {
            array.push(arguments[i]);
        }
    }
    return array;
});

/**
 * 数组的逐个执行
 * @param  {Function} func 对数组里的每个元素执行的函数
 * @return {Array} 返回数组本身,以便使用连缀
 *
 * @example
 *  var arr = [1, 2, 3];
 *  arr.each(function(value, i){
 *      alert(value); // 会把逐个值 alert 处理
 *      alert(this.length); // 这里面的 this 是指被调用的数组 arr
 *  });
 */
Array.prototype.each = function(func) {
	for (var i = 0, length = this.length; i < length; i++) func.call(this, this[i], i);
    return this;
};
// 数组 each
cTest.Array_each = function() {
    var arr = [1, 2, 3, 'a', 'b', {a:5, b:[1,2]}];
    if (!arr.each) throw new Error("数组的 each 函数加载出错!");
    var count = 0;
    var tem_arr = arr.each(function(value, i) {
        if (arr[i] !== value) throw new Error("数组的 each, 第" + i + "个元素出错!");
        if (this !== arr) throw new Error("数组的 each, 不支持使用 this 出错!");
        count++;
    });
    if (arr.length !== count) throw new Error("数组的 each 函数执行次数出错!");
    if (tem_arr !== arr) throw new Error("数组的 each 函数支持连缀出错!");
};

/**
 * 对数组中的每个元素都执行一次指定的函数
 * 并且创建一个新数组，该数组元素是所有回调函数执行时返回值为 true 的原数组元素。原数组不改变
 * @param  {Function} func 对数组里的每个元素执行的函数
 * @return {Array} 以数组形式返回执行函数时返回值为 true 的原数组元素
 *
 * @example
 *  var arr = [1, 23, 54, 67, 42, 66];
 *  var arr2 = arr.filter(function (value, index) {
 *      alert(this.length); // 这里面的 this 是指被调用的数组 arr
 *      return value % 2 == 0; // 返回偶数
 *  });
 *  alert(arr2); // 值为: [54, 42, 66]
 */
Array.prototype.filter = function(func) {
    var result = [], array = this;
    this.each(function(value, index) {
        if (func.call(array, value, index)) result.push(value);
    });
    return result;
};
// 数组 filter
cTest.Array_filter = function() {
    var arr = [1, 23, 54, 67, 42, 66];
    if (!arr.filter) throw new Error("数组的 filter 函数加载出错!");
    var arr2 = arr.filter(function (value, index) {
        if (this !== arr) throw new Error("数组的 filter, 不支持使用 this 出错!");
        return value % 2 === 0; // 返回偶数
    });
    if (arr.length !== 6) throw new Error("数组 filter 后,原数组数量被修改,出错!");
    if (arr2.length !== 3) throw new Error("数组 filter 后,新数组数量出错!");
    if (arr2.indexOf(54) === -1 || arr2.indexOf(42) === -1 || arr2.indexOf(66) === -1)
        throw new Error("数组 filter 后,新数组元素出错!");
};

/**
 * 删除数组里的某些值(只删除第一个找到的值)
 * @param  {任意类型} 要删除的数组里的对象,可以多个
 * @return {Array} 返回数组本身,以便使用连缀
 *
 * @example
 *  var arr = ['a', 'b', 'c', 'd', 'c'];
 *  arr.remove('c'); // 此时的数组删除了第一个'c', 为: ['a', 'b', 'd', 'c']
 *  arr.remove('a', 'd'); // 还可以同时删除多个值, 此时为: ['b', 'c']
 *  arr.remove('e'); // 传入数组里面没有的值,不对数组产生影响,也不会出现异常, 此时为: ['b', 'c']
 */
Array.prototype.remove = function() {
    for (var i = 0; i < arguments.length; i++) {
        var value = arguments[i];
        var index = this.indexOf(value);
        if (index > -1) this.splice(index, 1);
    }
    return this;
};
// 数组 remove
cTest.Array_remove = function() {
    var arr = ['a', '2', 'c', 'd', 'c'];
    if (!arr.remove) throw new Error("数组的 remove 函数加载出错!");
    arr.remove('c'); // 变为 ['a', '2', 'd', 'c']
    if (arr.length !== 4) throw new Error("数组 remove 后,数量出错!");
    if (arr[3] !== 'c') throw new Error("数组的 remove 后,值被修改出错!");
    arr.remove('a', 'd'); // 变为 ['2','c']
    if (arr.length !== 2) throw new Error("数组 remove 后,数量出错!");
    arr.remove('e', 'd'); // 删除没有的值, 变为 ['2','c']
    if (arr.length !== 2) throw new Error("数组 remove 后,数量出错!");
    var tem_arr = arr.remove(2); // 值需要完全匹配才被删除,变为 ['2','c']
    if (arr.length !== 2) throw new Error("数组 remove 后,数量出错!");
    if (arr[0] !== '2') throw new Error("数组 remove 后,值被修改出错!");
    if (arr[1] !== 'c') throw new Error("数组 remove 后,值被修改出错!");
    if (tem_arr !== arr) throw new Error("数组的 remove 函数支持连缀出错!");
};

/**
 * 返回没有重复值的新数组,原数组不改变
 * @return {Array} 返回过滤重复值后的新数组
 *
 * @example
 *  var arr = ['a', 'b', 'c', 'd', 'c', null];
 *  var arr2 = arr.unique(); // arr2 为: ['a', 'b', 'd', 'c', null]
 */
Array.prototype.unique = function() {
    var result = [];
    for (var i=0,l=this.length; i<l; i++) {
        for (var j=i+1; j<l; j++) {
            if (this[i] === this[j]) j = ++i;
        }
        result.push(this[i]);
    }
    return result;
};
// 数组 unique
cTest.Array_unique = function() {
    var arr = ['a', '2', 'c', 'd', 'c', 'f', 'f'];
    if (!arr.unique) throw new Error("数组的 unique 函数加载出错!");
    var arr2 = arr.unique();
    if (arr.length !== 7) throw new Error("数组 unique 后,原数组数量被修改,出错!");
    if (arr2.length !== 5) throw new Error("数组 unique 后,新数组数量出错!");
    if (arr2.indexOf('a') === -1 || arr2.indexOf('2') === -1 || arr2.indexOf('c') === -1 || arr2.indexOf('d') === -1 || arr2.indexOf('f') === -1)
        throw new Error("数组 unique 后,新数组元素出错!");

    arr = ['a', '2', 'c', null, 'c', undefined, 'f'];
    arr2 = arr.unique();
    if (arr2.length !== 6) throw new Error("数组 unique 后,新数组数量出错!");
};

/**
 * 以数组形式返回原数组中不为 null 与 undefined 的元素。原数组不改变
 * @return {Array} 以数组形式返回原数组中不为 null 与 undefined 的元素
 *
 * @example
 *  var arr = ['a', 'b', 'c', 'd', 'c', null];
 *  var arr2 = arr.notNull(); // arr2 为: ['a', 'b', 'c', 'd', 'c']
 */
Array.prototype.notNull = function() {
    var result = [];
    for (var i=0,l=this.length; i<l; i++) {
        if (this[i] != null) result.push(this[i]);
    }
    return result;
};
// 数组 notNull
cTest.Array_notNull = function() {
    var a = null, b = '', c, d;
    var arr = ['a', 'c', 'd', a, b, c, d];
    if (!arr.notNull) throw new Error("数组的 notNull 函数加载出错!");
    var arr2 = arr.notNull();
    if (arr.length !== 7) throw new Error("数组 notNull 后,原数组数量被修改,出错!");
    if (arr2.length !== 4) throw new Error("数组 notNull 后,新数组数量出错!");
    if (arr2.indexOf('a') === -1 || arr2.indexOf('c') === -1 || arr2.indexOf('d') === -1 || arr2.indexOf('') === -1)
        throw new Error("数组 notNull 后,新数组元素出错!");
};

/**
 * 返回数组里的最大值
 * 如果数组里有不能直接转成数值的值,或者有 NaN,则返回 NaN；空值按0处理,能转成数值的字符串会被转成数值处理
 * @return {Number | NaN} 返回数组里的最大值
 *
 * @example
 *  var arr = ['66', 44, 32.1, null];
 *  var arr2 = ['66', 44, 32.1, null, 'a'];
 *  alert( arr.max() ); // 值为: 66
 *  alert( arr2.max() ); // 值为: NaN
 */
Array.prototype.max = function() {
    return Math.max.apply(null,this);
};

/**
 * 返回数组里的最小值
 * 如果数组里有不能直接转成数值的值,或者有 NaN,则返回 NaN；空值按0处理,能转成数值的字符串会被转成数值处理
 * @return {Number | NaN} 返回数组里的最小值
 *
 * @example
 *  var arr = ['66', 44, 32.1, null, -1];
 *  var arr2 = ['66', 44, 32.1, null];
 *  alert( arr.min() ); // 值为: -1
 *  alert( arr2.min() ); // 值为: 0
 */
Array.prototype.min = function() {
    return Math.min.apply(null,this);
};

/**
 * 触发于 function 执行前
 * @param func 如果参数(func)执行结果为 false 则不再执行原 Function, 否则继续执行原 Function
 * @return 如果参数(func)执行结果为 false 则返回 false, 否则返回原 Function 的执行结果
 */
Function.prototype.before = function(func) {
    var _self = this;
    var _args = arguments;
    return function() {
        if (func.apply(this, _args) === false) {
            return false;
        }
        return _self.apply(this, _args);
    }
};

/**
 * 触发于 function 执行后
 * @param func 如果执行的原 Function 返回结果为 false, 则不再执行参数(func), 否则执行参数(func)
 * @return 返回原 Function 的执行结果
 */
Function.prototype.after = function(func) {
    var _self = this;
    var _args = arguments;
    return function() {
        var ret = _self.apply(this, _args);
        if (ret === false) {
            return false;
        }
        func.apply(this, _args);
        return ret;
    }
};

/**
 * 运行平台判断(是否 windows)
 * @return 如果是 windows 平台则为“true”，其它平台则返回“false”
 * @example if (c$.isWin) alert('这是 window 平台'); // 注意,这个是值,不是函数
 */
c$.isWin = (navigator.appVersion.toLowerCase().indexOf("win") != -1);

/**
 * 添加收藏
 * @param sURL 网站地址
 * @param sTitle 网站名称
 * @return c$ 对象本身，以支持连缀
 */
c$.addFavorite = function(sURL, sTitle) {
    sURL = sURL || location.href;
    sTitle = sTitle || document.title;
    var fns = [
        function () { window.external.addFavorite(sURL, sTitle);},// IE
        function () { window.sidebar.addPanel(sTitle, sURL, "");},// firefox (仅当地址为 ftp://, http:// 开头时可以正常运行)
    ];
    for (var i=0, n=fns.length; i < n; i++) {
        try { fns[i](); return this; }catch(e){}
    }

    // 以上都不行
    alert("加入收藏失败，请使用Ctrl+D进行添加");
    return this;
};

/**
 * 设为首页
 * @param obj 设置对象
 * @param url 网站地址
 * @return c$ 对象本身，以支持连缀
 * @example  <a onclick="c$.setHome(this);">设为首页</a>
 */
c$.setHome = function(obj, url) {
    // 默认地址为本页面
    url = url || location.href;
    try { // IE
        obj = obj || document.body;
        obj.style.behavior = 'url(#default#homepage)';
        obj.setHomePage(url);
    }
    catch(e) {
        if (window.netscape) {
            try { // firefox
                window.netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
            }
            catch (e) {
                alert("此操作被浏览器拒绝！\n请在浏览器地址栏输入“about:config”并回车\n然后将 [signed.applets.codebase_principal_support]的值设置为'true',双击即可。");
            }
            var prefs = Components.classes['@mozilla.org/preferences-service;1'].getService(Components.interfaces.nsIPrefBranch);
            prefs.setCharPref('browser.startup.homepage',url);
        }
    }
    return this;
};

/**
 * 创建一个哈希表对象
 * @return 所创建的哈希表对象
 *
 * @example
 *  var ht = c$.HashTable();  // 创建一个哈希表对象
 *  ht.add('id', 55);   // 添加值
 *  ht.set('id', 66);   // 设值
 *  ht.get('id');       // 取值,没有此值时返回 null
 *  ht.remove('id');    // 删除值
 *  ht.clear();         // 清空哈希表
 *  ht.contains('id');  // 判断是否包含此键,返回 true 或者 false
 *  ht.containsValue(55); // 判断是否包含此值,返回 true 或者 false
 *  ht.count();         // 统计此哈希表里面有多少元素,返回一个整数
 *  ht.keys();          // 返回一个数组,里面包含此哈希表里面所有的 key
 *  ht.toString();      // 返回一个此哈希表的 key 和 value 格式化后的字符串,如: '{"a":1,"b":"哈哈"}'
 *  ht.clear().add('id', 55).set('name', 'myName').remove('age'); // add,set,remove,clear 函数支持连缀
 */
c$.HashTable = function() {
    // 分别保存 key 和 value
    // 原本是用 Object 来保存, 但如果 Object 被扩展了,将会影响结果,且 opera 的 Object 总是含有一个 event,最终改用数组。
    var keyArr = [], valueArr = [];

    // 返回一个哈希对象
    return {
        // 添加一个元素
        add : function(key, value) {
            var index = keyArr.indexOf(key);
            // 没有此值时添加
            if (index === -1) {
                keyArr.push(key);
                valueArr.push(value);
            }
            // 有此值时修改
            else {
                valueArr[index] = value;
            }
            // 返回自身,以便连缀
            return this;
        },

        // 删除一个元素
        remove : function(key) {
            var index = keyArr.indexOf(key); // 数组的 indexOf 是被扩展的
            if (index > -1) {
                keyArr.remove(key); // 数组的 remove 是被扩展的
                valueArr.splice(index, 1);
            }
            return this;
        },

        // 获取一个元素
        get : function(key) {
            var index = keyArr.indexOf(key);
            if (index > -1) {
                return valueArr[index];
            }
            return null;
        },

        // 修改一个元素
        set : function(key, value) {
            return this.add(key, value);
        },

        // 获取所有的 key
        keys : function() {
            // 返回一个复制的 key 数组,以免被外部修改
            return keyArr.clone(); // 数组的 clone 函数是被扩展的
        },

        // 清空
        clear : function() {
            keyArr.clear(); // 数组的 clear 函数是被扩展的
            valueArr.clear();
            return this;
        },

        // 判断是否包含此键
        contains : function(key) {
            return keyArr.contains(key); // 数组的 contains 函数是被扩展的
        },

        // 判断是否包含此值
        containsValue : function(value) {
            return valueArr.contains(value);
        },

        // 统计
        count : function() {
            return keyArr.length;
        }

        // 格式化
        ,toString : function() {
            var arr = [];
            for (var i = 0, n = keyArr.length; i < n; i++) {
                arr.push('"' + encodeURIComponent(keyArr[i]) + '":' + c$.json2str(valueArr[i]));
            }
            return '{' + arr.join(',') + '}';
        }
    };
};
// 哈希表对象(测试函数)
cTest.HashTable = function() {
    // 创建一个哈希表对象
    var ht = c$.HashTable();
    if (!ht || typeof ht != 'object') throw new Error("创建一个哈希表对象出错!");
    if (!ht.count || ht.count() !== 0) throw new Error("创建一个空哈希表对象出错!");
    var ht2 = c$.HashTable();
    if (ht === ht2) throw new Error("哈希表对象 没有重新创建出错!");

    // add, set, count, remove
    ht.add('id', 55);   // 添加值
    if (ht.get('id') !== 55) throw new Error("哈希表对象 add 或者 get 出错!");
    if (ht.count() !== 1) throw new Error("哈希表对象 count 出错!");
    ht.set('id', 66);   // 设值
    if (ht.get('id') !== 66) throw new Error("哈希表对象 set 或者 get 出错!");
    ht.add('id', 55);   // 再次添加值,应该为设值
    if (ht.get('id') !== 55) throw new Error("哈希表对象 set 或者 get 出错!");
    if (ht.count() !== 1) throw new Error("哈希表对象 set 或者 get 导致 count 出错!");
    ht.remove('id');    // 删除值
    if (ht.count() !== 0) throw new Error("哈希表对象 remove 或者 count 出错!");

    // clear
    ht.add('id', 55);
    if (ht.get('id') !== 55) throw new Error("哈希表对象 add 或者 get 出错!");
    if (ht.count() !== 1) throw new Error("哈希表对象 count 出错!");
    ht.clear();         // 清空哈希表
    if (ht.count() !== 0) throw new Error("哈希表对象 clear 出错!");

    // contains, containsValue
    ht.add('id', 55);
    if (ht.contains('id') !== true) throw new Error("哈希表对象 contains 出错!");
    if (ht.contains('name') !== false) throw new Error("哈希表对象 contains 出错!");
    if (ht.containsValue(55) !== true) throw new Error("哈希表对象 containsValue 出错!");
    if (ht.containsValue(51) !== false) throw new Error("哈希表对象 containsValue 出错!");

    // keys
    ht.add('arr', [1, '2', 3]);
    if (ht.count() !== 2) throw new Error("哈希表对象 add 或者 count 出错!");
    var keys = ht.keys();          // 返回一个数组,里面包含此哈希表里面所有的 key
    if (keys.length !== 2) throw new Error("哈希表对象 keys 出错!");
    if (keys[0] !== 'id' && keys[1] !== 'id') throw new Error("哈希表对象 keys 出错!");
    if (keys[0] !== 'arr' && keys[1] !== 'arr') throw new Error("哈希表对象 keys 出错!");

    // toString
    var str = ht.toString(); // 大概是这样： {"id":55, "arr":[1, "2", 3]}
    if (!str || typeof(str) !== 'string') throw new Error("哈希表对象 toString 出错!");
    eval('var htObj = ' + str);
    if (!htObj || typeof(htObj) !== 'object') throw new Error("哈希表对象 toString 出错!");
    if (htObj.id !== 55) throw new Error("哈希表对象 toString 出错!");
    if (htObj.arr[0] !== 1) throw new Error("哈希表对象 toString 出错!");
    if (htObj.arr[1] !== '2') throw new Error("哈希表对象 toString 出错!");
    if (htObj.arr[2] !== 3) throw new Error("哈希表对象 toString 出错!");
    try {
        ht.clear().add('id', 55).set('name', 'myName').remove('age').set('weigh', 65);
    }
    catch (e) {
        throw new Error("哈希表对象 连缀支持 出错!");
    }
};

/**
 * 获取单选按钮对应的编号和名称
 * @param boxName 单选按钮的名称
 * @param init    单选按钮的默认值
 * @param needID  是否需要单选按钮的编号
 * @return 如果参数needID为false或者没有这参数，返回被选中的当选按钮的value
 *         如果参数needID为true,返回: {value: 被选中的按钮的value, number:第几个单选按钮被选中(都没有选择时为-1,从0开始算)}
 */
c$.getRadioValue = function(boxName, init, needID)
{
    //返回值，默认为 ""
    var retValue = "";
    //单选按钮的编号，默认为 -1
    var boxID = -1;
    //单选按钮的值(value)
    var boxValue = "";
    //如果有默认值
    if (arguments.length >= 2)
    {
        retValue = init;
        boxValue = init;
    }

    //如果需要单选按钮的编号
    if (true === needID)
    {
        //如果需要单选按钮的编号，默认返回值为 {value: "", number:-1}
        retValue = {value: boxValue, number:boxID};
    }
    var box = c$.getElement(boxName);
    //如果没有找到所要的单选按钮，则直接返回
    if (!box)
    {
        return retValue;
    }

    //如果只有一个单选按钮
    if ("radio" === box.type && box.checked)
    {
        boxID = 0;
        boxValue = box.value;
    }
    //循环检查选中哪个
    for (var i = 0; i < box.length; i++)
    {
        //如果选中此单选按钮
        if (box[i].checked)
        {
            boxID = i;
            boxValue = box[i].value;
        }
    }

    retValue = boxValue;
    //如果需要单选按钮的编号
    if (true === needID)
    {
        retValue = {value: boxValue, number:boxID};
    }
    return retValue;
};

/**
 * 将对象转换成字符串
 * @param  {任意类型} strValue 包含字符串的对象
 * @return {String} 对象的字符串(undefined、null会返回"")
 */
c$.toStr = function(strValue) {
    if (strValue || 0 === strValue || false === strValue) return ("" + strValue);
    // 不能转换的返回空字符串
    return "";
};

/**
 * 转成 float 类型
 * @param  {String | Number | 任意类型} str 需转换的字符串
 * @return {Number(float)} 数值,转换不成功则返回0
 */
c$.toFloat = function(str) {
    return (parseFloat(str) || 0);
};

/**
 * 获取对象的所有键的数组
 * @param  {Object} object 对象
 * @return {Array} 对象的所有键的数组
 */
c$.keys = function(object) {
    var keys = [];
    for (var property in object) {
        keys.push(property);
    }
    return keys;
};

/**
 * 获取对象的所有值的数组
 * @param  {Object} object 对象
 * @return {Array} 对象的所有值的数组
 */
c$.values = function(object) {
    var values = [];
    for (var property in object) {
        values.push(object[property]);
    }
    return values;
};

/**
 * 把数值转化成指定的数值字符串,指定小数位,可加逗号
 * @param  {String | Number} value 需转化的数值
 * @param  {Number} decimal 小数位。不指定则有小数的默认两位,没小数的不加小数(舍去部分会四舍五入)
 * @param  {Number} signNumber 数字每隔多少位加一个逗号，默认不加逗号
 * @return {String} 处理后的数值字符串
 * @example c$.toNumberStr('15154514541.6471', 2, 3)  // 返回: "15,154,514,541.65"
 */
c$.toNumberStr = function(value, decimal, signNumber) {
    var retValue = "";
    //如果没有value值,赋值为0
    value = value || "0";
    //如果不是数值
    if (false === c$.isNumber(value)) value = "0";

    //去除前后空格,去除数值中的逗号
    value = ("" + value).trim().replaceAll(",");
    //去除非数值，以及0开头的内容
    value = "" + parseFloat(value);

    //分解字符串； number[0]为整数部分， number[1]为小数部分
    var number = value.split(".");
    //如果字符串是个整数
    if (1 === number.length) number[1] = "";
    number[2] = "";

    //如果是负数
    if (0 === value.indexOf("-")) {
        number[0] = number[0].replace("-", "");
        retValue += "-";
    }
    //如果是加号开头
    if (0 === value.indexOf("+")) {
        number[0] = number[0].replace("+", "");
        retValue += "+";
    }

    //如果没有设定小数字，看数值情况，有小数的默认两位，没小数的不加小数
    if (!decimal && 0 !== decimal && value.indexOf(".") > 0) decimal = 2;
    decimal = c$.toInt(decimal); // 取整
    //如果是科学计数法的数字
    if (number[1].indexOf("e") > 0) {
        var numberArry = number[1].split("e");
        number[1] = numberArry[0];
        number[2] = "e" + numberArry[1];
        decimal -= parseInt(numberArry[1]);
    }
    //如果指定保留多少位小数
    if (0 < decimal) {
        //给结果补足要求保留的小数字
        for (var i = 0; i < decimal; i++) {
            number[1] += "0";
        }
        //四舍五入
        var tem_number = retValue + number[0] + number[1].substring(0, decimal) + "." + number[1].substring(decimal, number[1].length);
        tem_number = "" + Math.round(tem_number);
        var intLength = (retValue + number[0]).length;
        number[1] = tem_number.substring(intLength, intLength + decimal);
    }

    signNumber = c$.toInt(signNumber); // 取整
    //如果需要分隔数字
    if (0 < signNumber) {
        //整数的第一部分的长度
        var tem = number[0].length % signNumber;
        //如果整数部分的长度刚好是signNumber的倍数
        if (0 === tem) tem = signNumber;
        //整数的第一部分
        retValue += number[0].substring(0, tem);
        //整数的其他部分
        for (var i = 1; i < parseInt((number[0].length + signNumber - 1) / signNumber); i++) {
            var j = (i - 1) * signNumber + tem;
            retValue += "," + number[0].substring(j, j + signNumber);
        }
    }
    //如果不需要分隔数字
    else {
        retValue += number[0];
    }

    // 如果有小数则加上
    if ((number[1] + number[2]).length > 0) retValue += "." + number[1] + number[2];

    // 返回数值字符串
    return retValue;
};

/**
 * 设置页面覆盖层
 * @param  {Boolean} flag 为true则覆盖,页面不可操作； 否则取消覆盖，页面可操作
 * @param  {Number} zIndex 覆盖层的z-index,默认99999
 * @return {Object} c$ 对象本身，以支持连缀
 *
 * @example
 *  c$.cover();  // 取消页面的覆盖,页面可操作
 *  c$.cover(true);  // 覆盖整个页面,页面不可操作
 */
c$.cover = function(flag, zIndex) {
    var thisFun = arguments.callee;
    // thisFun.overlay 作为覆盖层对象,是这函数的全局变量
    // 覆盖
    if (flag === true) {
        // 隐藏滚动条
        var htmls = document.getElementsByTagName("html");
        for (var i = 0, length = htmls.length; i < length; i++) {
            htmls[i].style.overflow = "hidden";
        }
        // 不存在覆盖层对象,则创建
        if (!thisFun.overlay) {
            thisFun.overlay = document.createElement("div");
            // 覆盖层样式
            var cssText = "position:absolute;";
            cssText += "width:" + Math.max(document.body.scrollWidth, document.body.clientWidth) + "px;";
            cssText += "height:" + Math.max(document.body.scrollHeight, document.body.clientHeight) + "px;";
            cssText += "left: 0px;";
            cssText += "top: 0px;";
            cssText += "background-color: #D4D4D4;";
            cssText += "filter:alpha(opacity=50);";
            cssText += "-moz-opacity:0.50;";
            cssText += "opacity:0.50;";
            thisFun.overlay.style.cssText = cssText;
        }
        thisFun.overlay.style.zIndex = zIndex || 99999;
        document.body.appendChild(thisFun.overlay);
    }
    // 取消覆盖
    else {
        // 不存在覆盖层对象,则不再操作
        if (!thisFun.overlay) return this;
        thisFun.overlay.parentNode.removeChild(thisFun.overlay);
        // 恢复滚动条
        var htmls = document.getElementsByTagName("html");
        for (var i = 0, length = htmls.length; i < length; i++) {
            htmls[i].style.overflow = "";
        }
    }
    return this;
};
// 覆盖层,按 Esc 键取消覆盖(测试函数)
function cover() {
    c$.cover(true);
    document.onkeypress = function(evt) {
        document.onkeypress = null;
        try {
            evt = evt || window.event;
            // Esc 键撤销
            if (evt.keyCode == 27) {
                c$.cover(false);
            }
        }
        catch(e) {}
    };
};


// 整个工具类结束
})(window);