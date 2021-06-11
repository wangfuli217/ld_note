
跨浏览器

1.浏览器判断：
     //如果是火狐等浏览器则为“true”
     var isNav = (navigator.appName.indexOf("Netscape") != -1);
     //如果是IE浏览器则为“true”
     var isIE = (navigator.appName.indexOf("Microsoft") != -1); // navigator.appName == "Microsoft Internet Explorer"
     var isIE = (navigator.appVersion.indexOf("MSIE") != -1);
     //判断IE6
     var isIE6 = (navigator.userAgent && navigator.userAgent.split(";")[1].toLowerCase().indexOf("msie 6.0")!="-1");
     //如果是Opera浏览器则为“true”
     var isOpera = (navigator.userAgent.indexOf("Opera") != -1);
     //浏览器运行的平台，是 windows 则返回 true
     var isWin = (navigator.appVersion.toLowerCase().indexOf("win") != -1);

2.event 事件
    在 IE4+ 和 Firefox下的 event
    function doEventThing(event)
    {
        //获取不同浏览器的 event
        event = event || window.event; // window.event for IE; 参数event for firefox
        //获取不同浏览器的键盘输入记录
        var currentKey = event.keyCode || event.charCode; // keyCode 目前兼容了
        //获取不同浏览器的事件源
        var eventSource = event.target || event.srcElement; // srcElement for IE; target for firefox
        var target = event.relatedTarget || event.toElement; // 将会去到的元素,像 onmouseout 会触发
        //屏蔽Form提交事件
        //if ( event.returnValue ) event.returnValue = false; // for IE
        //if ( event.preventDefault ) event.preventDefault(); // for firefox
        ( e.preventDefault ) ? (e.preventDefault()) : (e.returnValue = false);
        //添加事件
        if ( event.attachEvent ) {
            event.attachEvent('onclick', func ); // for IE; 需要加上“on”,如 onmouseover
        } else if ( event.addEventListener ) {
            event.addEventListener('clcik', func, false); // for firefox; 不需要加上“on”,直接写“click”
        }
        //改变事件; 但上面的绑定事件方法并不改变原有的onclick事件，而是添加事件
        event.onclick = func;
    }
    //Firefox 下必须手动输入参数,调用时如: <input type="button" onclick="doEventThing(event);"/>

3. firefox 的 click() 事件,由于 firefox 不支持 click() 事件,代替方式：
        // 获取需要触发 onclick() 的元素
        var element = document.getElementsByTagName('a')[0];
        // For IE
        if ( document.all ) {
            element.click();
        // FOR DOM2
        } else if ( document.createEvent ) {
            var ev = document.createEvent('MouseEvents'); //'MouseEvents' 改成 'HTMLEvents' 的话,firfox2不通过
            ev.initEvent('click', false, true);
            element.dispatchEvent(ev);
        }

4. 跨浏览器技巧：
     1) IE不能用 setAttribute 设定 class 属性。
        解决方法1: 同时使用 setAttribute("class","newClassName") 和 setAttribute("className","newClassName")
        解决方法2:  <element>.className = "newClassName"

     2) IE中不能使用 setAttribute 设定 style 属性。即 <element>.setAttribute("style","fontweight:bold;") 不相容。
        解决方法：使用 <element>.style.cssText = "fontweight:bold;"

     3) 使用appendChild将<tr>元素直接增加到<table>中，则在IE中这一行并不出现，但其它浏览器却会出现。
        解决方法：在<table>下增加<tbody>元素，再添加<tr>

     4) IE不能直接添加按钮处理事件。如：addButton.setAttribute("onclick","addEmployee('unid');");不适用。
        解决方法：addButton.onclick = function() { addEmployee('unid'); };//用匿名函数调用addEmployee()函数。
        此外,onmouseover,onmouseout 等事件也要使用此方法。

     5) firefox 不支持 document.all
        解决方法: 用 document.getElementsByTagName("*") 替代,可以得到得到所有元素的集合

     6) 设置元素的id
        同时使用 .id 和 setAttribute 来设置
        var div = document.createElement('div');
        div.id="btc";
        div.setAttribute("id","btc");


  5.Firefox注册innerText写法
    if ( (navigator.appName.indexOf("Netscape") != -1) )
    {
        //注册 Getter
        HTMLElement.prototype.__defineGetter__("innerText", function(){
            var anyString = "";
            var childS = this.childNodes;
            for ( var i=0; i < childS.length; i++ ) {
                if ( childS[i].nodeType == 1 )
                    anyString += childS[i].tagName == "BR" ? '\n' : childS[i].innerText;
                else if(childS[i].nodeType == 3 ) {
                    anyString += childS[i].nodeValue;
                }
            }
            return anyString;
        });

        //注册 Setter
        HTMLElement.prototype.__defineSetter__("innerText",
            function ( sText ) { this.textContent = sText; }
        );
    }
    //在非IE浏览器中使用 textContent 代替 innerText

  6.长度：FireFox长度必须加“px”，IE无所谓
    解决方法：统一使用 obj.style.height = imgObj.height + "px";
  7.父控件下的子控件：IE是“children”，FireFox是“childNodes”
  8.XmlHttp
    在IE中，XmlHttp.send(content)函数的content可以为空，而firefox则不能为空，应该用send(" ")，否则会出现411错误

  9.event.x 与 event.y 问题
    问题： 在IE中，event 对象有x,y属性，FF中没有
    解决方法：
    在FF中，与 event.x 等效的是 event.pageX ，但event.pageX IE中没有
    故采用 event.clientX 代替 event.x ，在IE中也有这个变量
    event.clientX 与 event.pageX 有微妙的差别，就是滚动条
    要完全一样，可以这样：
    mX = event.x ? event.x : event.pageX;

  10.禁止选取网页内容
    问题：FF需要用CSS禁止，IE用JS禁止
    解决方法：
    IE: obj.onselectstart = function() {return false;}
    FF: -moz-user-select:none;

  11.各种浏览器的特征及其userAgent。
    IE
      只有IE支持创建ActiveX控件，因此她有一个其他浏览器没有的东西，就是 window.ActiveXObject 函数。
      IE各个版本典型的userAgent如下(其中，版本号是MSIE之后的数字)：
        Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.0)
        Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.2)
        Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)
        Mozilla/4.0 (compatible; MSIE 5.0; Windows NT)

    Firefox
       Firefox中的DOM元素都有一个getBoxObjectFor函数，用来获取该DOM元素的位置和大小(IE对应的中是getBoundingClientRect函数)。这是Firefox独有的，判断它即可知道是当前浏览器是Firefox。
       Firefox几个版本的userAgent大致如下(其中，版本号是Firefox之后的数字)：
        Mozilla/5.0 (Windows; U; Windows NT 5.2) Gecko/2008070208 Firefox/3.0.1
        Mozilla/5.0 (Windows; U; Windows NT 5.1) Gecko/20070309 Firefox/2.0.0.3
        Mozilla/5.0 (Windows; U; Windows NT 5.1) Gecko/20070803 Firefox/1.5.0.12

    Opera
       Opera提供了专门的浏览器标志，就是 window.opera 属性。
       Opera典型的userAgent如下(其中，版本号是Opera之后的数字)：
        Opera/9.27 (Windows NT 5.2; U; zh-cn)
        Opera/8.0 (Macintosh; PPC Mac OS X; U; en)
        Mozilla/5.0 (Macintosh; PPC Mac OS X; U; en) Opera 8.0

    Safari
       Safari浏览器中有一个其他浏览器没有的openDatabase函数，可做为判断Safari的标志。
       Safari典型的userAgent如下(其版本号是Version之后的数字)：
        Mozilla/5.0 (Windows; U; Windows NT 5.2) AppleWebKit/525.13 (KHTML, like Gecko) Version/3.1 Safari/525.13
        Mozilla/5.0 (iPhone; U; CPU like Mac OS X) AppleWebKit/420.1 (KHTML, like Gecko) Version/3.0 Mobile/4A93 Safari/419.3

    Chrome
      Chrome有一个 window.MessageEvent 函数，但Firefox也有。不过，好在Chrome并没有Firefox的getBoxObjectFor函数，根据这个条件还是可以准确判断出Chrome浏览器的。
      目前，Chrome的userAgent是(其中，版本号在Chrome之后的数字)：
        Mozilla/5.0 (Windows; U; Windows NT 5.2) AppleWebKit/525.13 (KHTML, like Gecko) Chrome/0.2.149.27 Safari/525.13

    下面是判断浏览器的代码：
        var Sys = {};
        var ua = navigator.userAgent.toLowerCase();
        if (window.ActiveXObject)
            Sys.ie = ua.match(/msie ([\d.]+)/i)[1];
        else if (document.getBoxObjectFor) // 火狐判断出错
            Sys.firefox = ua.match(/firefox\/([\d.]+)/i)[1];
        else if (window.opera)
            Sys.opera = ua.match(/opera.([\d.]+)/i)[1];
        else if (window.MessageEvent)
            Sys.chrome = ua.match(/chrome\/([\d.]+)/i)[1];
        else if (window.openDatabase)
            Sys.safari = ua.match(/version\/([\d.]+)/i)[1];

        //以下进行测试
        if(Sys.ie) alert('IE: '+Sys.ie);
        if(Sys.firefox) alert('Firefox: '+Sys.firefox);
        if(Sys.chrome) alert('Chrome: '+Sys.chrome);
        if(Sys.opera) alert('Opera: '+Sys.opera);
        if(Sys.safari) alert('Safari: '+Sys.safari);
