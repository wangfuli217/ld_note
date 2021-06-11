

四、 摘录：
   1. 省略对象名称，用 with() 命令。
      如: document.write(".....<br/>");
          document.write(".....<br/>");
      可省略写为：
          with (document) {
             write(".....<br/>");
             write(".....<br/>");
          }  //把相同的 document 省略掉。
       省略对象名称，变量。
       如： document.myForm.myText.value;
       可省略写为： f = document.myForm;  f.myText.value;

   2.页面调试
      javascript 加入如下语句，出错时会提示
      注意： chrome、opera 和 safari 等浏览器不支持 window.onerror 事件(w3c标准没有此事件),需另外捕获出错信息
     <script type="text/javascript">
        /**
         * 这是出错调试代码
         * 当页面发生错误时，提示错误信息
         * @param msg   出错信息
         * @param url   出错文件的地址
         * @param sLine 发生错误的行
         * @return true 让出错时不显示出错图标
         */
        window.onerror = function ( msg, url, sLine ) {
            var hostUrl = window.location.href;
            // 判断网址,测试时可以提示出错信息;正式发布时不提示
            if ( hostUrl.indexOf("http://localhost") === 0 || hostUrl.indexOf("http://127.0.0.1") === 0 ||
                hostUrl.indexOf("http://192.168.") === 0 || hostUrl.indexOf("file://") === 0 )
            {
                var errorMsg = "当前页面的脚本发生错误.\n\n";
                errorMsg += "错误: " + msg + "\n";
                errorMsg += "URL: " + url + "\n";
                errorMsg += "行: " + sLine + "\n\n";
                errorMsg += "点击“确定”消去此错误，“取消”保留此错误。\n\n";
                return window.confirm( errorMsg );
            }
            // 返回true,会消去 IE下那个恼人的“网页上有错误”的提示
            return true;
        };
      </script>

   3.把数值变成 奇 \ 偶数(利用位运算)
      n = n | 1 ;            //一定得到奇数。如果原本是偶数则加一。
      n = (n >> 1) <<1;      //一定得到偶数。如果原本是奇数则减一。
      n = n ^ 1;             //奇偶互换。对偶数加一，对奇数减一。

   4.取出数值的整数部分(取整)。
      // 以下第一种方法不受浏览器和版本的影响，后两种受版本影响。
      n = ( n > 0 ) ? Math.floor(n) : Math.ceil(n);
      n = Number ( (String(n).split("."))[0]);
      n = parseInt(n,10);
      // 下面做法更简便高效,用位运算来做(右移0位,或者两次取反),且非数值型的值会转成0
      alert(5>>0);      alert(~~5);      // 值为 5
      alert(5.55>>0);   alert(~~5.55);   // 值为 5
      alert(-98.4>>0);  alert(~~-98.4);  // 值为 -98
      alert('absd'>>0); alert(~~'absd'); // 值为 0
      alert(null>>0);   alert(~~null);   // 值为 0
      alert('34.5'>>0); alert(~~'34.5'); // 值为 34

   5.取出数值的小数部分。
      须先检查小数点是否存在。但有时会发生运算误差。
      n = Math.abs(n);  if(n>0) n = n - Math.floor(n); else n = 0;
      n = parseInt(n,10) - parseFloat(n);
      if((""+n).indexOf(".") > -1) n = Number("0."+(String(n).split("."))[1]); else n = 0;

   6.在任意位置插入一行js(单行程序)：
     <script type="text/javascript">alert("中断一下");</script>
     <input type="button" onclick="javascript:formName.DataName.value='';formName.DataName.focus();" />

   7.设置焦点：
     //document.all["DateID"].onfocus;
     document.all["DateID"].focus();
     formName.DataName.focus();

   8.默认参数：
     function show() {
        alert( arguments[0] );
     }
     这个函数会alert出第一个参数，如调用时： show("haha")，则alert("haha");

   9.禁止 confirm 與 alert
      window.confirm = function(str){return true;};
      window.alert = function(str){};

   10.获取下拉菜单的内容
      <select name="seleName" >
         <option value="value1">Text</option>
      </select>
      获取选中的下拉菜单的内容：
        var seleElement = document.formName.seleName;
        var optionText = seleElement.options[seleElement.selectedIndex].text;

   11.设置默认值:
      edittype = edittype || "text"; //edittype预设为 text
      上面一句: 如果 edittype 之前有值,则取之前的值; 之前没有值,则取默认值

   12.数值的截取:
      numObj.toFixed([fractionDigits])
      //numObj:必选项。一个 Number 对象。
      //fractionDigits:可选项。小数点后的数字位数。其值必须在 0 – 20 之间，包括 0 和 20。 预设为0
      toFixed 函数返回一个以定点表示法表示的数字的字符串形式。对数值进行四舍五入截取到指定位数的小数
      如: 55.3654.toFixed(2) //返回55.37


   18.if 判断对象是否存在
      一般可以用 if 判断对象是否存在,但直接写“ if(对象名){...} ”判断时,如果对象不存在则浏览器会抛异常。
      这里建议用“ if(window['对象名']){...} ”的写法来判断
      当确认对象已经存在时,用“对象名.变量名”跟“对象名['变量名']”没什么区别。
      如： var c = new Object(); // 假如这是写在另一个js文件里的变量,下面用的时候需要判断这对象是否存在
      if (c) {alert('c存在');} // 如果这对象确实存在，则没有问题。但对象不存在时会抛异常
      if (window['c']){alert('c存在');}; if (window.c){alert('c存在');} // 推荐用这两种写法之一,不管对象是否存在,都不会抛异常,且存在时可正常使用。


五、JavaScript 技巧
    1.获取表单的内容
      <HTML>
      <HEAD>
      <SCRIPT LANGUAGE="JavaScript">
      <!--
         function aa(){
             //var value=document.all("td1").value; //.innerHTML
             var value=document.getElementById("td1").value;//上句也可行
             document.all("ta").value=value;
         }
      //-->
      </SCRIPT>
      </HEAD>
      <BODY>
      <input id="td1" name="haha" type="text" onkeydown="if(13==event.keyCode){aa();return false;}"/><br/>
      <INPUT TYPE="button" NAME="" value="引用" onclick="aa()"><br/>
      <TEXTAREA id="ta" ROWS="15" COLS="20"></TEXTAREA>
      </BODY>
      </HTML>

    2. IE3.0 和 NN2.0(Netscape Navigator)上能同时运作的程序
         为照顾不同的浏览器和版本，只好多作几次判断。看程序中的几个 if 实现的是同一功能就明白。
        <html>
        <head>
        <title>写能同时在IE和NN上运行的程序</title>
        <script language="JavaScript">
        <!--
            x = 0;
            function moveLayer() {
                x = x + 2;
                if(document.all) {document.all["myLay"].style.left = x;} //IE4以上版本可用，IE4之前和NN上都没有 all
                if(document.layers) {document.layers["myLay"].left = x;} //仅NN4上运行，NN4外没有layers对象
                /* 下面这句仅NN6以后版本可用。
                   因为document.getElementById()在IE5.x上有，所以需 " !document.all "  */
                if(!document.all && document.getElementById) {document.getElementById("myLay").style.left = x;}
            }
        // -->
        </script>
        </head>
        <body bgcolor = "white" onLoad="setInterval('moveLayer()',1000)">
        <div id="myLay" style="position:absolute;left:0px"> <img src="btn1.gif"></div>
        </body>
        </html>

    3. 读取 Behavior 文档 (任意标签都可触发 onclick 事件) (IE5.0以上可用)
        //在 html 文件上写：
        <html>
        <head>
        <title>读取 Behavior 文件</title>
        <style type="text/css">
        <!--
               div { behavior:url(a.htc); }
        -->
        </style>
        <script language="JavaScript">
        <!--
               function testA() { alert("haha"); }  //<a>标签的 onclick事件
               function check() {    //获取 id 和 class 名称
                    alert("id = "+document.all["myObj"].id+"; className="+document.all["myObj"].className);
               }
        // -->
        </script>
        </head>
        <body bgcolor = "white"><center>
        <div>点击文字</div><br/><br/>
        <a href="JavaScript:testA()">sample</a><br/><br/><br/>
        <input id="myObj" class="mz" type=button value="test" onclick="check()" />
        </center></body>
        </html>

       //在此 html 文件的同一目录下的 a.htc 文件里写：
        <script language="JavaScript">
        <!--
           attachEvent("onclick",msg);
           function msg() { alert("oh!");}
        // -->
        </script>

    4.定时器，每隔一段时间进行处理(IE3.0以上，NN2.0以上可用)
        <html>
        <head>
        <title>定时器</title>
        <script language="JavaScript">
        <!--
            var timerId;
            var n = 0;
            function timerUpdate(){
                window.document.myForm.result.value = n++ ;
                //这是个一次性触发的方法，这里以反复调用来实现周期性触发
                timerId = setTimeout("timerUpdate()",100); //第一个参数是要执行的函数,也可以直接写匿名函数而不用字符串
            }
            function timerStart() {
                //防止连续多次点击，导致计数器速度迭加
                document.getElementById("StartCount").onclick = "";
                setTimeout("timerUpdate()",1);
            }
            function timerEnd() {
                clearTimeout(timerId);
                //这两句的效果一样。
                //clearInterval(timerId);
                //还原 "StartTime"按钮 的点击能力
                document.getElementById("StartCount").onclick = timerStart;
            }
        // -->
        </script>
        </head>
        <body>
           <form name="myForm">
                <input type="text" name="result"/><br/><br/>
           </form>
           <input type="button" id="StartCount" value="StartTime" onclick="timerStart()"/>
           <input type="button" value="EndTime" onclick="timerEnd()"/>
        </body>
        </html>

     5.根据 javaScript 的开闭状态来显示网页(适用IE3.0和NN2.0以上版本)
         以 <meta> 配合  location.href 来实现。
         下面的 <meta> 里的content的5表示当javascript关闭时，5秒后跳转到closeJavaScript.html 页面。
         location.href="openJavaScript.html";  表示当javascript可用时，跳转到 openJavaScript.html 页面。
         在 html 里加入"<noscript>您使用的浏览器不支持或者禁止了Javascript</noscript>"则在本页面提示。

        <meta http-equiv="refresh" content="5; url=closeJavaScript.html">
        <script language="JavaScript">
        <!--
               location.href="openJavaScript.html";
        // -->
        </script>

    7.淡入/淡出效果(背景色适用IE3.0和NN2.0以上版本，文字色适用IE4以上版本)
      <body bgcolor="black" onLoad="newCount('bgColor'); fade('0123456789ABCDEF')">
      <script language="JavaScript">
           var count = 0 ;
           var obj = null ;
           function fade(str){
              c = str.charAt(count++);
              if (obj=='bgColor') {document.bgColor = "#"+c+c+c+c+c+c+c+c;} //改变背景颜色，颜色码8位
              if (obj=='word') {document.all["strId"].style.color = "#"+c+c+"0000";} //改变文字颜色，颜色码6位
              if(count < str.length) setTimeout("fade('"+str+"')",250);
           }
           function newCount(object){ count = 0 ;  obj = object ; }
      </script>
           <input type="button" value="toWhite" onclick="newCount('bgColor'); fade('0123456789ABCDEF')"/>
           <input type="button" value="toBlack" onclick="newCount('bgColor'); fade('fedcba9876543210')"/><br/><br/>
           <span id="strId" onMouseover="newCount('word'); fade('fedcba9876543210')">点击淡入淡出的文字</span>
      </body>

    8.窗口的振动效果(适用IE4.0和NN4.0以上版本)
         <script language="JavaScript">
                 //指定窗口的错位。
                 x = new Array( 10,  3, -6,  8, -10, -7,  5, -3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
                 y = new Array(-12,  6, -3, 10, -9,  -2,  8,  2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
                 count = 0;
         function purupuruWin() {
                 if(x[count] != 0) moveBy(x[count], y[count]); //窗口的振动
                 count++;
                 if(count >= x.length )count = 0;
                 setTimeout("purupuruWin()",100);
         }
         </script>
         <input type="button" name="" value="StartPuru" onclick="purupuruWin()">

    9.检查电子邮件地址是否正确(适用IE4.0和NN3.0以上版本)
        <script language="JavaScript">
               function checkMailAddr(dstText){
                       var data = dstText.match(/^\S+@\S+\.\S+$/); //检查是否邮件的表达式
                       if(!data || !dstText ) alert('电子邮件地址不正确！'); else  alert('电子邮件地址正确！');
               }
        </script>
        <form>
        电子邮件：<input type="text" name="address" />
        <input type="button" value="check" onclick="checkMailAddr(this.form.address.value)"/>
        </form>

    10. cookie 的使用。显示访问次数。(适用IE3.0和NN2.0以上版本)
        <script language="JavaScript">
           if ( !navigator.cookieEnabled ) alert("can not use cookie");
           //在 cookie 中存储访问次数。
           function setCount(n){
               var theDay = 30;
               var setDay = new Date();
               setDay.setTime(setDay.getTime()+(theDay*1000*60*60*24));
               document.cookie = "count=" + n + ";expires=" + setDay.toGMTString();
           }
           function getCount() {
               var theName = "count=";
               var theCookie = document.cookie + ";" ;
               var start = theCookie.indexOf(theName);  //没有cookie时返回“-1”
               if (start != -1) {  //这是对第2次以后的访问的处理
                    var end  = theCookie.indexOf(";",start);
                    var count = eval(unescape(theCookie.substring(start+theName.length,end)));
                    document.write("这是第 "+count+" 次访问本页面");
                    setCount(count+1);
               } else {   //这是对第1次访问的处理
                    document.write("这是第1次访问本页面");
                    setCount(2);
               }
           }
           getCount();
        </script>

    11.简单的预防二次提交 (适用IE3.0和NN3.0以上版本)
        <script language="JavaScript">
           var flag = false;
           function send() {
               if (flag) { alert("提交完毕！"); return false; }
               flag = true ;   return true;
           }
           function send2(form) {
               if ( !flag ){ form.submit(); }
           }
        </script>
        <form name="myForm" method="post" action="send.html" enctype="text/plain" onSubmit="return send()">
        <input type="submit" value="提交" />
        <!-- onclick里的函数要用双引号括起来，form表单的名称不能加引号，字符则须用单引号括起来-->
        <input type="button" value="按钮" onclick="send2(myform);" >
        </form>


    14.修改表单内容
        <html>
        <head><title>修改表单内容</title>
            <script language="JavaScript" type="text/javascript" >
        /**
         * 编辑按钮
         * @param form  页面提交的<form>的name
         * @param dataId  要编辑的行的 id
         * @param number  要编辑的列的数量
         */
        var isedit = false;
        function edit ( form, dataId, number )
        {
            if ( isedit ){ alert("请编辑完再编辑下一笔！");return;}
            isedit = true;
            //获取需编辑的对象(<tr>卷标对象)
            var data = document.getElementById("data_"+dataId);
            //获取需编辑的各子对象(<td>卷标对象)。注意：各<td>间别换行，换行符也算子元素。
            var dataNodes = data.childNodes;
            //写进去的内容。这将是数组对象
            var dataInput;
            //循环修改须编辑的列的内容
            for ( var i=number-1; i >= 1; i=i-1 ) {
                var editname = "edit_" + i;
                dataInput = "<input type='text' name='" + editname + "' id='" + editname + "' ";
                dataInput += " size='10' maxlength='15' value='" + dataNodes[i].innerHTML + "' \/>"
                dataNodes[i].innerHTML = dataInput;
            }
            // 第一栏是学号等 ID字段，不许修改。但提交时需在提交窗体里找到它。
            dataInput = "<input type='hidden' name='edit_0' value='";
            dataInput += dataNodes[0].innerHTML + "' \/>" + dataNodes[0].innerHTML;
            dataNodes[0].innerHTML = dataInput;
            //性别栏，下拉菜单
            dataInput = "<select name='edit_2'>"
            //dataNodes[2].innerHTML.indexOf("男") 如果相同则传回"0"，不同传回"-1"
            if(dataNodes[2].innerHTML.indexOf("男") === 0){
               dataInput += "<option value='m' selected>男<\/option>";
               dataInput += "<option value='f' >女<\/option><\/select>";
            } else {
               dataInput += "<option value='m' >男<\/option>";
               dataInput += "<option value='f' selected>女<\/option><\/select>";
            }
            dataNodes[2].innerHTML = dataInput;
            //按钮栏
            dataInput = "<input type='button' value='确认' onclick=\"updateValue(";
            dataInput += form.name + ", " + number + ", 'edit_' );\"\/>";
            dataNodes[ (dataNodes.length -2) ].innerHTML = dataInput;
            dataNodes[ (dataNodes.length -1) ].innerHTML = "";  //编辑时不给删除
            form.SQLmethod.value = "modify"; //表单提交信息，与这里无关
            form.submitId.value = dataId;    //表单提交信息，与这里无关
        }
        /**
         * 编辑后确认，提交
         * @param form  页面提交的<form>的name
         * @param number 要编辑的列的数量
         * @param str name属性的开始字段
         */
        function updateValue ( form , number , str ) {
            var editname;
            //循环处理，主要是 alert() 提醒客户端必须填写某些内容
            for ( var i=1; i < number; i=i+1 ) {
                editname = str + i;
                if( document.all[editname].value.length === 0) {
                    document.all[editname].focus();
                    alert("请填写各栏目内容！");
                    return ;
                }
            }
            form.submit();
        }
            </script>
        </head>

        <body>
        <form name="pageForm" action="" >
            <table border="1">
                 <TR><TH>学号</TH><TH>姓名</TH><TH>性别</TH>
                     <TH style="BORDER-LEFT: black 1px solid; BORDER-BOTTOM: black 1px solid"></TH>
                     <TH style="BORDER-BOTTOM: #000000 1px solid"></TH>
                 </TR>
                 <tr id='data_1' ><td>101</td><td>stu1</td><td>男</td><td><INPUT type='button' value='编辑' onclick="edit(pageForm,1,2 ); " ></td><td><INPUT type='button' value='删除' onclick="del(pageForm,1, 'del');" ></td></tr>
                 <tr id='data_2' ><td>102</td><td>stu2</td><td>女</td><td><INPUT type='button' value='编辑' onclick="edit(pageForm,'2',2 ); " ></td><td><INPUT type='button' value='删除' onclick="del(pageForm,2, 'del');" ></td></tr>
            </table>
        </form>
        </body>
        </html>


    15.可变长参数 的 动态函数：
       函数是一个对象，一个Function对象
       (函数参数列表及函数主体事实上只是Function对象的构造函数的参数而已)
       函数参数是可变的，比如定义函数时的参数列表有3个参数，调用时可以传2个参数，或者5个参数
       arguments.length 是实际参数的个数(被传递参数的个数)
       函数名.length    期望参数的个数(定义函数时的参数列表的参数个数)

      动态函数：
       var square = new Function("x", "y", "var sum;sum=x*x+y*y;return sum;");
       alert(square(2,3)); //值为13
       动态函数的作用：函数体是由一个字符串构成的，故函数体可动态生成。


    16.页面刷新的方法：
       history.go(0);
       location.reload();
       location=location;
       location.assign(location);
       document.execCommand('Refresh');
       window.navigate(location);
       location.replace(location);
       document.URL=location.href;

       自动刷新的方法：
       1) <head> 里使用标签：<meta http-equiv="refresh" content="20"> //其中20指每隔20秒刷新一次页面
       2) 使用javascript：
          <script language="JavaScript">
            function myrefresh() {
               window.location.reload();
            }
            setTimeout('myrefresh()',1000); //指定1秒刷新一次
          </script>

       页面自动跳转：
       <meta http-equiv="refresh" content="20;url=http://www.wyxg.com"> //20秒后跳转到url指定的页面

       刷新框架的js:
       //刷新包含该框架的页面用
       parent.location.reload();
       //子窗口刷新父窗口
       self.opener.location.reload();  ( 或 <a href="javascript:opener.location.reload()">刷新</a> )
       //刷新另一个框架的页面用
       parent.otherFrameID.location.reload();

       关闭或者打开窗口时刷新，在<body>中用 onload 或 onUnload 即可。
       <body onload="opener.location.reload()">   //打开窗口时刷新
       <body onUnload="opener.location.reload()"> //关闭窗口时刷新
       window.opener.document.location.reload(); // ?


    17.用 javascript 处理 JSON：
       JSON 是 javascript 的一个子集，所以，在javascript 中使用JSON是非常简单的。
       JSON的规则很简单： 对象是一个无序的“‘名称/值’对”集合。一个对象以“{”（左括号）开始，“}”（右括号）结束。
       每个“名称”后跟一个“:”（冒号）；“‘名称/值’ 对”之间使用“,”（逗号）分隔。
       1) 创建 JSON 对象，如下创建了只包含一个成员 "bindings" 的一个对象，bindings 则包含了一个由3个对象组成的数组。
          var myJSONObject = {"bindings": [
              {"ircEvent": "PRIVMSG", "method": "newURI", "regex": "^http://.*"},
              {"ircEvent": "PRIUUCG", "method": "deleteURI", "regex": "^delete.*"},
              {"ircEvent": "PRIIPKD", "method": "randomURI", "regex": "^random.*"}
            ]
          };
       2) 获取对象： 在javascript 中， 成员可以通过“点号”来获取。
          如： myJSONObject.bindings[0].method  // 结果： newURI
          alert(myJSONObject.bindings[1].method); //alert信息: deleteURI
       3) 通过eval() 函数可以将JSON字符串转化为对象。
          如： var myJSONtext = '{"ircEvent": "PRIUUCG", "method": "deleteURI", "regex": "^delete.*"}';
               var myObject = eval('(' + myJSONtext + ')');
               alert(myObject.ircEvent); //alert信息: PRIUUCG
          如： var myObject2 = eval('({ircEvent: "PRIUUCG", method: "delete"})'); //名称也可以不用引號括起來
               alert(myObject2.ircEvent); //alert信息: PRIUUCG
       4) 基于安全的考虑的 JSON 解析器。
          eval 函数非常快，但是它可以编译任何 javascirpt 代码，这样的话就可能产生安全的问题。
          eval 的使用是基于传入的代码参数是可靠的假设的，有一些情况下，可能客户端是不可信任的。
          一个 JSON 解析器将只接受 JSON 文本。所以是更安全的。
          如： var myObject = JSON.parse(myJSONtext, filter);
               可选的 filter 参数将遍历每一个 value key 值对， 并进行相关的处理。
          如： myData = JSON.parse(text, function (key, value) {
                  return key.indexOf('date') >= 0 ? new Date(value) : value;
               });


    18.匿名函数与 Module 模式
       JavaScript 的任何变量，函数或是对象，除非是在某个函数内部定义，否则，就是全局的。
       意味着同一网页的别的代码可以访问并改写这个变量(ECMA 的 JavaScript 5 已经改变了这一状况 - 译者)
       使用匿名函数，你可以绕过这一问题。
       比如，你有这样一段代码，很显然，变量 name, age, status 将成为全局变量:
       var name = 'Chris';
       var age = 18;
       function createMenber() {
            // ...
       }
       function getMenber() {
            // ...
       }
       为了避免这一问题，你可以使用匿名函数:
       var myApp = function() {
            var name = 'Chris';
            var age = 18;
            // 如果在函数里面再定义函数,建议如下写法,如果写“function createMenber(){...}”则IE7会报错
            var createMenber = function() {
                // ...
            }
            var getMenber = function() {
                // ...
            }
       }();
       如果这个函数不会被再次调用，可以连这个函数的名称也省了，更直接写为:
       (function() {
            var name = 'Chris';
            var age = 18;
            var createMenber = function() {
                // ...
            }
            var getMenber = function() {
                // ...
            }
       }) ();
       如果要访问其中的对象或函数，可以:
       var myApp = function() {
            var name = 'Chris';
            var age = 18;
            return {
                createMenber: function() {
                    // ...
                }
                getMenber: function () {
                    // ...
                }
            }
       } ();
      // myApp.createMenber() 和 myApp.getMenber() 可以使用
      所谓 Module 模式或单例模式(Singleton)，假如你想在别的地方调用里面的方法，可以在匿名函数中返回这些方法，甚至用简称返回：
      var myApp = function() {
          var name = 'Chris';
          var age = 18;
          var createMenber = function () {
              // ...
          }
          var getMenber = function () {
              // ...
          }
          return {
              create:createMenber,
              get:getMenber
          }
      } ();
      // myApp.create() 和 myApp.get() 可以使用


    19.事件委托
       事件是JavaScript非常重要的一部分。
       我们想给一个列表中的链接绑定点击事件，一般的做法是写一个循环，给每个链接对象绑定事件，HTML代码如下：

      <h2>Great Web resources</h2>
      <ul id="resources">
          <li><a href="http://opera.com/wsc">Opera Web Standards Curriculum</a></li>
          <li><a href="http://sitepoint.com">Sitepoint</a></li>
          <li><a href="http://alistapart.com">A List Apart</a></li>
          <li><a href="http://yuiblog.com">YUI Blog</a></li>
          <li><a href="http://blameitonthevoices.com">Blame it on the voices</a></li>
          <li><a href="http://oddlyspecific.com">Oddly specific</a></li>
      </ul>

      代码如下：
      // 典型事件绑定示例
      (function(){
          //回调函数
          var handler = function (e){
            e = e || window.event;
            //获取事件源(被点击的元素对象)
            var x = e.target || e.srcElement;
            alert('Event delegation:' + x);
            //屏蔽Form提交事件
            if ( e.returnValue ) e.returnValue = false; //for IE
            if ( e.preventDefault ) e.preventDefault(); //for Firefox
          };
          var resources = document.getElementById('resources');
          var links = resources.getElementsByTagName('a'); // Dom 对象下获取子对象
          var all = links.length;
          // 给每个链接绑定点击事件
          for(var i=0;i<all;i++){
              var link = links[i];
              if ( link.attachEvent ) {
                  link.attachEvent('onclick',handler);
              }
              else if ( link.addEventListener ) {
                  link.addEventListener('click',handler,false);
              }
          };
      })();

      更合理的写法是只给列表的父对象绑定事件，代码如下：
      (function(){
          var handler = function (e) {
            e = e || window.event;
            var x = e.target || e.srcElement;
            // 确认被点击的对象是 A标签
            if ( x.nodeName.toLowerCase() === 'a' ) {
                alert('Event delegation:' + x);
                //屏蔽Form提交事件
                ( e.preventDefault ) ? (e.preventDefault()) : (e.returnValue = false);
            }
          };
          var resources = document.getElementById('resources');
          resources.onclick = handler; //也可以像上面用 addEventListener 和 attachEvent 添加 onclick 事件
      })();


    20.window.open() 子窗口控制
       // 窗口参数,控制位置和大小、显示等
       var param = 'top='+(screen.height-pHeight)/2+',left='+(screen.width-pWidth)/2+',width='+ pWidth +',height=' + pHeight + ',resizable=yes,scrollbars=yes,location=no, status=no';
       // 参数解释:
       height=100 窗口高度； // 这里 pHeight 需要先设定参数值
       width=400 窗口宽度；  // 这里 pWidth  需要先设定参数值
       top=0 窗口距离屏幕上方的象素值； //top=(screen.height-pHeight)/2 和 left=(screen.width-pWidth)/2 让窗口居中显示
       left=0 窗口距离屏幕左侧的象素值；
       toolbar=no 是否显示工具栏，yes为显示；
       menubar，scrollbars 表示菜单栏和滚动栏。
       resizable=no 是否允许改变窗口大小，yes为允许；
       location=no 是否显示地址栏，yes为允许；
       status=no 是否显示状态栏内的信息（通常是文件已经打开），yes为允许；
       // 子窗口网址
       var url = "test.html";
       var pName = "windowsName" // 子窗口的名称: 如果子窗口名称相同,会覆盖旧的窗口
       // 打开窗口,返回子窗口对象
       var win = window.open(url,pName,param);
       // 父窗口控制子窗口的对象
       win.window.document.getElementById("productName").innerHTML = "<%=prod.Name%>";
       // 父窗口调用子窗口的函数
       win.testFun();

       // 子窗口控制父窗口
       window.opener.window.document.getElementById("bnt").value = "重新查看";
       // 子窗口调用父窗口的函数
       window.opener.testfun();

       注意:父窗口刚打开子窗口时马上对它进行赋值或者调用其函数等操作可能会失败,因为子窗口未完全加载
            需要这样做时,最好在子窗口写加载的js,再调用父窗口; 以免操作失败。


    21.URL编程
       javascript允许直接在URL地址栏写程序，这令js做的验证全部都是不安全，必须后台在验证一次。
       如，在一个页面的地址栏输入：“javascript:alert(55);”，那页面即可执行 alert 函数，同理也可执行任意的js函数。
       利用这点，<A>标签的地址也可以编程，如：“<A href='javascript:alert(5);testFun();'></A>”


    22.页面的script结束符问题
       如下写法，html页面不会alert,反而会在页面上显示“');”的内容
        <script>
        alert('</script>');
        </script>

       因为浏览器把alert的字符串中的“</script>”解析成结束符了，需要“\”转换一下，如下写成能正常：
        <script>
        alert('<\/script>');
        </script>


    23.z-index(zIndex)涂层使用
       在css里面用 z-index, 而javascript里面用 zIndex, 如：
        <div id='fl' style="Z-INDEX: 9999999;">...</div>
        <script>
            var element = document.getElementById('fl');
            element.style.zIndex = 9;
        </script>

       z-index(zIndex) 默认为0,(其实打印的时候为空),涂层的数值越大越往上，也就是显示时覆盖涂层低的。
       注意：IE6上，层级会影响涂层，按先后出现的顺序来绝定层的堆叠顺序，不同层级的元素需要设置祖先元素(上溯到同层级为止)的z-index才生效。

    24. iframe 的操作
        1) 获得 iframe 的 window 对象。存在跨域访问限制。
            chrome:  iframeElement. contentWindow
            firefox: iframeElement.contentWindow
            ie6: iframeElement.contentWindow

            function getIframeWindow(element){
                return  element.contentWindow;
                //return  element.contentWindow || element.contentDocument.parentWindow;
            }

        2) 获得 iframe 的 document 对象。存在跨域访问限制。
            chrome:  iframeElement.contentDocument
            firefox: iframeElement.contentDocument
            ie:  iframeElement.contentWindow.document // ie没有 iframeElement.contentDocument 属性。

            function getIframeDocument(element) {
                return  element.contentDocument || element.contentWindow.document;
            }

        3) iframe 中获得父页面的 window 对象。存在跨域访问限制。
            父页面：window.parent
            顶层页面：window.top
            适用于所有浏览器

        4) 获得 iframe 的内容。存在跨域访问限制。
            firefox: iframeElement.contentDocument.documentElement.textContent
            ie:  iframeElement.contentWindow.document.documentElement.innerText

            function getIframeText(element) {
                var iframeDocument = element.contentDocument || element.contentWindow.document;
                var documentElement = iframeDocument.documentElement || iframeDocument.body;
                return documentElement.textContent || documentElement.innerText;
            }

        5) iframe的 onload 事件
            非ie浏览器都提供了 onload 事件。例如下面代码在ie中是不会有弹出框的。
            var ifr = document.createElement('iframe');
            ifr.src = 'http://www.b.com/index.html';
            ifr.onload = function() {
                alert('loaded');
            };
            document.body.appendChild(ifr);

            但是ie却又似乎提供了onload事件，下面两种方法都会触发onload
            //方法一：
            <iframe onload="alert('loaded');" src="http://www.b.com/index.html"></iframe>

            //只有ie才支持为createElement传递这样的参数
            var ifr = document.createElement('<iframe onload="alert(\'loaded\');" src="http://www.b.com/index.html"></iframe>');
            document.body.appendChild(ifr);由于iframe元素包含于父级页面中，因此以上方法均不存在跨域问题。

            实际上IE提供了 onload 事件，但必须使用attachEvent进行绑定。所以最好的 onload事件写法如下：

            var ifr = document.createElement('iframe');
            ifr.src = 'http://b.a.com/b.html';
            var loaded_fun = function(){ alert('loaded'); }; // 要执行的 onload 事件
            if (ifr.attachEvent) {
                ifr.attachEvent('onload', loaded_fun );
            } else {
                ifr.onload = loaded_fun;
            }
            document.body.appendChild(ifr);

        6) frames
            window.frames 可以取到页面中的帧( iframe, frame 等)，需要注意的是取到的是 window 对象，而不是 HTMLElement 。
            var ifr1 = document.getElementById('ifr1');
            var ifr1win = window.frames[0];
            ifr1win.frameElement === ifr1;   // true
            ifr1win === ifr1;    // false


    25. 反射
        在JavaScript中能利用 for in 语句实现反射,如：
        // 下面这段语句遍历obj对象的所有属性和函数
        for (var p in obj) {
            if (typeof(obj[p]=="function") {
                obj[p](); // 执行函数,也还可以传参数
            } else {
                alert(obj[p]);
            }
        }

        obj.函数名(参数列表); // 这样执行函数，可以使用下面的反射形式来代替
        obj["函数名"](参数列表);


    26. 过滤数组的重复值
        /**
         * 返回没有重复值的新数组,原数组不改变
         * @return 返回过滤重复值后的新数组
         *
         * @example
         *  var arr = ['a', 'b', 'c', 'd', 'c', null];
         *  var arr2 = arr.unique(); // arr2 为: ['a', 'b', 'd', 'c', null]
         */
        Array.prototype.unique = function() {
            var result = [];
            // 注意学习此算法
            for (var i=0,l=this.length; i<l; i++) {
                for (var j=i+1; j<l; j++) {
                    if (this[i] === this[j]) j = ++i;
                }
                result.push(this[i]);
            }
            return result;
        };


    27. 巧用“||”、“&&”和“!”
     松散性语言的特性, if 判断时可以用任意值,  false、 null、 undefine、 ''、 0、 NaN  都会被当成 false
     利用js的松散性和没类型特性, 可简化一些代码:

     function fun1(name, fun2, obj, add_step) {

        // 设预设值
        name = name || '匿名';
        // 上面一句相当于下面这一句
        if ( !name ) name = '匿名';

        // 假如传入的 fun2 是个函数, 当有此值传入时执行, 没有则不执行
        fun2 && fun2();
        // 上面一句相当于下面这一句
        if ( fun2 ) fun2();

        // 转成布尔值,不管传入的 obj 是什么类型的值, 都会返回布尔类型的值
        return !!obj;
        // 上面一句相当于下面这几句
        if ( obj ) {
            return true;
        } else {
            return false;
        }

        // && 多重的if判断,或者swith判断,可以这样简写
        var add_level = (add_step>10 && 3) || (add_step>5 && 2) || (add_step>0 && 1) || 0;
        // 上面一句相当于下面这几句
        var add_level;
        if (add_step > 10) {
            add_level = 3;
        } else if (add_step > 5) {
            add_level = 2;
        } else if (add_step > 0) {
            add_level = 1;
        } else {
            add_level = 0;
        }

     }
     // “||”、“&&”和“!”的特性帮我们精简了代码,同时也降低了代码的可读性。 这就需要我们自己来权衡了。
     // 不一定非得用这些精简写法,但得读得懂,因为很多框架用上了这类写法。
     // 之所以会牺牲可读性来用这些简便写法,是为了压缩代码量,减少访问时间。


    28. 注册鼠标滚轮事件
        var scrollFunc = function (event) { /* code... */ };
        // 标签元素
        <element>.onmousewheel = scrollFunc; //IE/Opera/Chrome, 可以直接赋值
        if (<element>.addEventListener) { // W3C、firefox 的鼠标滚轮
            <element>.addEventListener('DOMMouseScroll', scrollFunc, false);
        }

        // 整个页面
        window.onmousewheel = window.document.onmousewheel = scrollFunc;//IE/Opera/Chrome
        if (document.addEventListener) { // W3C、firefox
            document.addEventListener('DOMMouseScroll', scrollFunc, false);
        }

    29. 设全屏、居中
        // 窗口大小
        var screenWidth = window.screen.availWidth;
        var screenHeight = window.screen.availHeight;

        // 设全屏
    	window.moveTo(0,0);
    	window.resizeTo(screenWidth, screenHeight);

    	// 设置位置(居中)
        var showWidth = <element>.style.width >> 0; // 元素的宽度
        var showHeight = <element>.style.height >> 0; // 元素的高度
    	window.moveTo((screenWidth - showWidth)/2, (screenHeight - showHeight)/2);
    	// 设置窗口大小,单位为像素
    	window.resizeTo(showWidth, showHeight);


    30. 检查表单数据是否改变
        有的时候，需要检查用户是否修改了一个表单中的内容，则可以使用下面的技巧，其中如果修改了表单的内容则返回 true, 没修改表单的内容则返回 false 。代码如下：

        function formIsDirty(form) {
          for (var i = 0; i < form.elements.length; i++) {
            var element = form.elements[i];
            var type = element.type;
            if (type == "checkbox" || type == "radio") {
              if (element.checked != element.defaultChecked) {
                return true;
              }
            }
            else if (type == "hidden" || type == "password" ||
                     type == "text" || type == "textarea") {
              if (element.value != element.defaultValue) {
                return true;
              }
            }
            else if (type == "select-one" || type == "select-multiple") {
              for (var j = 0; j < element.options.length; j++) {
                if (element.options[j].selected !=
                    element.options[j].defaultSelected) {
                  return true;
                }
              }
            }
          }
          return false;
        }

        window.onbeforeunload = function(e) {
          e = e || window.event;
          if (formIsDirty(document.forms["someForm"])) {
            // IE 和 Firefox
            if (e) {
              e.returnValue = "You have unsaved changes.";
            }
            // Safari 浏览器
            return "You have unsaved changes.";
          }
        };

