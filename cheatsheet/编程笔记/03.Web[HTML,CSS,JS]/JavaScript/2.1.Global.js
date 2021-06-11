
Global 全局函数
    Number()	把对象的值转换为数字。
        如果参数是 Date 对象，Number() 返回从 1970 年 1 月 1 日至今的毫秒数。
        如果对象的值无法转换为数字，那么 Number() 函数返回 NaN 。如: Number('99 88') 返回 NaN.

    String()	把对象的值转换为字符串。

    isFinite(number)	用于检查其参数是否是有穷大的。
        如果 number 是有限数字(或可转换为有限数字),那么返回 true; 否则, 如果 number 是 NaN(非数字), 或者是正、负无穷大的数, 则返回 false 。
        isFinite(-125) 和 isFinite(1.2) 返回 true,
        而 isFinite('易水寒') 和 isFinite('2011-3-11') 返回 false.

    isNaN(object)	对非数字返回 true
        如: isNaN(123) 和 isNaN(0) 返回 false
        isNaN("易水寒") 和 isNaN("100") 返回 true.

    parseFloat(String)	解析一个字符串并返回一个浮点数

    parseInt(String, radix)	解析一个字符串并返回一个整数, 参数 radix 是多少进制
        注意:如果第一个参数字符串不能转成数字,返回 NaN, 而不是返回0.
        如果要求不能转成数字时返回0, 使用"字符串 >> 0"这样运算会更好。

    eval(String)	计算 JavaScript 字符串, 并把它作为脚本代码来执行, 返回计算结果。
        注意：参数必需是string类型的,否则该方法将不作任何改变地返回.

    escape(String)	对字符串进行编码,根据RFC1738转换成转义序列
        该方法不会对 ASCII 字母和数字进行编码，这些 ASCII 标点符号进行编码： - _ . ! ~ * ' ( ) 。其他所有的字符都会被转义序列替换。
        提醒: ECMAScript v3 反对使用该方法，应用使用 decodeURI() 和 decodeURIComponent() 替代它。

    unescape(String)	将 escape() 编码的字符串解码
        该函数的工作原理是这样的：通过找到形式为 %xx 和 %uxxxx 的字符序列(x 表示十六进制的数字), 用 Unicode 字符 \u00xx 和 \uxxxx 替换这样的字符序列进行解码。
        提醒: ECMAScript v3 已从标准中删除了 unescape() 函数，并反对使用它，因此应该用 decodeURI() 和 decodeURIComponent() 取而代之。

    encodeURI(String)	用 UTF-8 编码将字符串变成编码RUI
        提示: 如果 URI 组件中含有分隔符，比如 ? 和 #，则应当使用 encodeURIComponent() 方法分别对各组件进行编码。

    decodeURI(String)	进行encodeURI()函数的还原

    encodeURIComponent(String)	用 UTF-8 编码将字符串变成编码 URI 编码
        请注意 encodeURIComponent() 函数 与 encodeURI() 函数的区别之处，前者假定它的参数是 URI 的一部分（比如协议、主机名、路径或查询字符串）。
        因此 encodeURIComponent() 函数将转义用于分隔 URI 各个部分的标点符号。

    decodeURIComponent(String)	进行encodeURIComponent()函数的还原


全局属性
    Infinity	代表正的无穷大的数值。
    NaN	指示某个值是不是数字值。
    undefined	指示未定义的值。


/************* 解决中文乱码问题 ************************/
      用以下三个方法进行转码就行了：
      escape('你好')                == %u4F60%u597D           //转成 Unicode 编码
      encodeURI('你好/p')           == %E4%BD%A0%E5%A5%BD/p   //转换为UTF-8；URL需要传递中文时使用
      encodeURIComponent('你好/p')  == %E4%BD%A0%E5%A5%BD%2Fp

      三种方法都能对字符进行过滤。后两者是将字符串转换为UTF-8的方式。
    escape() 不会编码的字符有69个: *  +  -  .  /  @  _  0-9  a-z  A-Z
         所有空格、标点符号以及任何其它非 ASCII 字符都用 %xx 编码替换
         其中 xx 表示该字符的16进制数。例如, 空格返回为“%20”。
         (字符值大于 255 的字符以 %uxxxx 格式存储。)
         注意：escape 函数不能用来对“统一资源标识符”(URI) 进行编码。
    unescape() 从用 escape() 编码的 String 对象中返回已解码的字符串。同样不能用于 URI
    encodeURI()返回编码为有效的 URI 字符串。
        不会编码的字符有82个: ! # $ & ' ( ) * + , - . / : ; = ? @ _ ~ 0-9 a-z A-Z
        此函数返回一个已编码的 URI。将编码结果传递给 decodeURI(), 则返回初始的字符串。
    decodeURI() 不对下列字符进行编码： : / ; ?
    encodeURIComponent() 返回编码为 URI 的有效组件的字符串。
        不会编码的字符有71个: ! ' ( ) * - . _ ~ 0-9 a-z A-Z
        注意, 它会编译“/”, 所以不能包含路径, 否则无效。
    decodeURIComponent() 将编码结果解码回初始字符串。

    //把任意编码转成 java 的 ascii 编码(Unicode  native2ascii )
    //注意：html的ascii码是“%”开头的, 但java的却是“\”开头, 所以这里替换了
    function change1( str ) {
        var tem = "";
        for( var j = 0; j < str.length; j++ ) {
             if ( escape(str.charAt(j)).length >= 6) {
                   tem += escape(str.charAt(j)).replace("%", "\\");
             } else { tem += str.charAt(j); }
        }
        return tem;
    }

    // ascii2nactive  解码
    function change2( str ) {
        for( var j = str.length/3; j > 0; j-- ) {
             str = str.replace("\\", "%");
        }
        return unescape(str);
    }


/************* <a> (A标签) 传参时的中文乱码解决方案 ************************/
     利用js的escape函数,转码即可
     <script language="javascript" type="text/javascript">
        /**
         * 打开小视窗
         * @param url 需要打开视窗的网址
         * @param name 视窗名称
         * @param param 视窗显示的参数
         */
        function openWin(url, name, param) {
            var newurl,arrurl;
            if ( typeof(url) === "undefined" || url === "" ) {
                return ;
            }
            else {
                //没有参数时
                if ( url.indexOf("?") == -1 ) {
                    newurl = url;
                }
                //分解参数,并逐个转码
                else {
                    newurl = url.substring(0,url.indexOf("?")+1);
                    arrurl = url.substring(url.indexOf("?")+1).split("&");
                    for ( var i =0; i<arrurl.length; i++ ) {
                        newurl += arrurl[i].split("=")[0] + "=" + encodeURIComponent(arrurl[i].split("=")[1]) + "&";
                    }
                    newurl = newurl.substring(0,newurl.length-1);
                }
            }
            window.open(newurl, name, param);
        }
    </script>

    //使用如下 (下面第二句会更好,测试火狐时第一句会延迟或者没反应)
    <a href="#" onclick="openWin('test.html','test','width=300,height=400');">Links</a>
    <a href="javascript:openWin('test.html','test','width=300,height=400');">Links</a>

    A标签的 href="#" 时, IE浏览器会跳转到页面顶部, 解决方法是把“<A href="#">”改写成“<A href="javascript:void(0);">”或者“<A href="javascript:;">”
    A标签的 onclick 事件, 如果返回 false, 可以阻止页面跳转,如: <A href="/index.html" onclick="alert(8);return false;">test</a>

    注意：使用A标签的 href="javascript:xxx代码" 时, 里面的js代码不能使用 this, event 对象, 因为这相当于浏览器地址栏, this 不代表 A 标签。
    如果需要使用 this 或者 event 来获取此A标签,建议改用 onclick 事件。
    另外 A 标签里面的 onclick 事件返回 false,则不会跳转(即 href 的内容不会触发, href 里面的js也不会执行)。
