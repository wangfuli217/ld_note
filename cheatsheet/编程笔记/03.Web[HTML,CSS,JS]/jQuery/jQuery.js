
前言：
    jQuery 是一套面向对象的简洁轻量级的 JavaScript Library。
    jQuery 让你用更精简少量的代码来轻松达到跨浏览器 DOM 操作、事件处理、设计页面元素动态效果、AJAX 互动等。
    jQuery 跟 UI 相关的 plugins 已经做过了一些整合，目前独立发布为 jQuery UI (http://ui.jquery.com/)
    jQuery 的函数大多具有批处理的功能，光是这点就可以让你的程序更简洁了。

  获取最新的 jquery.js 文件：
    http://code.jquery.com/jquery.js
    http://code.jquery.com/jquery.min.js
    指定的 js 文件，可以查看 http://code.jquery.com/ 页面底下的文件列表

  在线帮助文档(英文版): http://api.jquery.com/


1. 介绍：
    钱符号 $ 是 jQuery 的函数名称， $("div") 就是用 jQuery 来选取文件内所有的 <div> 元素。
    $("div").addClass("special"); // 让你帮文件上所有的 <div> 元素都加入 class = "special"
    钱符号其实是 jQuery 的缩写， $("div") 跟 jQuery("div") 是一样的。也可以自己设定另外一个缩写。
    jQuery 所支持的 CSS Selector(选择器) 包含了 CSS1、CSS2 以及 CSS3，此外透过 plugin 还可支持常用的 XPath 语法

2. 选择对象：
  1) 基本：
     $("*"):       选取所有的元素集合。多用于结合上下文来搜索。
     $("element"): 根据 元素名 选取元素集合。如：$("div")
     $("#id"):     根据 id 选取一个元素。如果 id 中包含特殊字符，可以用两个斜杠转义。若有id相同者，选第一个
     $(".class"):  根据 class 选取元素集合。一个元素可以有多个 class,只要有一个符合就能被选取到。
     $("Selector1, Selector2, SelectorN"): 将每一个选择器匹配到的元素合并后一起返回。可以指定任意多个选择器，并将匹配到的元素合并到一个结果集内。
                   如：$("div,span,p.myClass")，可选取到 <div>, <p class="myClass">, <span> 元素
     $("element#id"):    选取指定 id 的 element 元素。如：$("div#idName")
     $("element.class"): 选取指定 class 的 element 元素。如：$("div.className")
  2) 层级：
     $("ancestor descendant"): 在给定的祖先元素下选取所有的后代元素(包括子元素的子元素)。如：$("div.className p")
     $("parent > child"):      在给定的父元素下选取所有的一级子元素(不包括子元素的子元素)。如：$("form > input")
     $("prev + next"):         选取所有紧接在 prev 元素后的第一个 next 元素(不是父元素下的子元素)
     $("prev ~ siblings"):     选取 prev 元素之后的所有同辈 siblings 元素
  3) 基本选择器：
     $(":first") .first(): 选取第一个元素。等同於 $(":eq(0)")，如：$("tr:first"), $('li').first()
     $(":last")  .last():  选取最后一个元素。
     $(":not(Selector)") .not(expr): 去除所有与给定选择器匹配的元素。支持复杂选择器。如：$("input:not(:checked)"), $("p").not( $("#selected")[0] )
     $(":even"):  选取所有索引值为偶数的元素，从 0 开始计数。如：$("tr:even")，选取表格的1、3、5...行
     $(":odd"):   选取所有索引值为奇数的元素，从 0 开始计数。如：$("tr:odd")，选取表格的2、4、6...行
     $(":eq(index)"): 选取一个给定索引值的元素，从 0 开始计数。如：$("tr:eq(1)")，选取表格的第2行
     $(":gt(index)"): 选取所有大于给定索引值的元素，从 0 开始计数。如：$("tr:gt(0)")，选取表格的第2至结束行
     $(":lt(index)"): 选取所有小于给定索引值的元素，从 0 开始计数。如：$("tr:lt(2)")，选取表格的第1~2行
     $(":header"): 选取 h1 ~ h6 的标题元素
     $(":animated"): 选取所有正在执行动画效果的元素
  4) 内容:
     $(":contains"): 匹配包含给定文本的元素。$("div:contains('John')")
     $(":empty"):    沒有任何子元素者(有文字也不算，例如 <span>TEXT</span> 就不合格)
     $(":has"):      $("div:has(a)"): 选取至少有包住一个 <a> 的 <div> 元素，如:<div><a>...</a></div> 中的 <div>
     $(":parent"):   选取包含子元素者(文字內容也算，例如:<span>Text</span>)
  5) 可见性:
     $(":hidden"):   选取所有不可见的元素(包含 CSS display=none, visibility=hidden以及<input type="hidden">)
     $(":visible"):  选取所有可见的元素(包含 CSS display=block 或 inline, visibility=visible 但不含 <input type="hidden">)
  6) 属性：
     $("[attribute]"): 根据给定的属性选取元素。如:$("div[id]")，选取含有属性为 id 的<div>元素
     $("element[attribute]"): 选取含有属性的元素，如: $("a[href]") 选取 <a href="#">Amazon</a>
     $("element[attribute='value']"): 选取含有属性为某个值的元素，如: $("a[href='#']") 选取 <a href="#">Amazon</a>
     $("element[attribute!='value']"): 等价于“:not([attr=value])”, 选取不含有属性为某个值的元素
     $("element[attribute^='value']"): 选取给定的属性是以某些值开始的元素
     $("element[attribute$='value']"): 选取给定的属性是以某些值结尾的元素
     $("element[attribute*='value']"): 选取给定的属性是包含某些值的元素
  7) 子元素:
     $(":nth-child(n)"): 返回在所属父元素下，排行第 n 的元素 E。(注意: 从 1 开始算，而非从 0)
     $(":first-child"):  返回在所属父元素下，排行第一的元素(老大)
     $(":last-child"):   返回在所属父元素下，排行最后的元素(老么)
     $(":only-child"):   返回在所属父元素下，是唯一子元素(独子)
  8) 表单:
     $(":input"):    选取所有表单输入元素(包含 input, select, textarea, button).
     $(":text"):     选取所有 <input type="text">
     $(":password"): 选取所有 <input type="password ">
     $(":radio"):    选取所有 <input type="radio ">
     $(":checkbox"): 选取所有 <input type="checkbox">
     $(":submit"):   选取所有 <input type="submit">
     $(":image"):    选取所有 <input type="image">
     $(":reset"):    选取所有 <input type="reset">
     $(":button"):   选取所有 <input type="button">
     $(":file"):     选取所有 <input type="file">
     $(":hidden"):   选取所有不可见的元素(包含 CSS display=none, visibility=hidden以及<input type="hidden">)
  9) 表单对象属性:
     $(":enabled"):  未被停用的 UI 元素 E
     $(":disabled"): 被停用的 UI 元素
     $(":checked"):  被选中的 UI 元素 (适用于 Radio, Checkbox)
     $(":selected"): 被选取的 UI 元素 (适用于 Select 下的 Option 元素)

  10)对象访问
     由于 jQuery Selector 传回的结果是 jQuery 对象所包含的群组，需要几个获取特定元素的函数:
     size() 或 length 传回群组的对象个数
     eq(N) 取出群组中第 N 个 jQuery 对象，从 0 开始计数。
     get() 傳传回元素的数组
     get(N) 取出第 N 个元素
     index(element 或 jQuery 对象) 用来查看某元素在选取结果中的下标，由 0 起算。元素不在群组时传回 -1。


3. 选择含有特殊字符的元素:
    如：
      <span id="foo:bar"></span>
      <span id="foo[bar]"></span>
      <span id="foo.bar"></span>
    jQuery 代码分别为:
      $("#foo\\:bar");
      $("#foo\\[bar\\]");
      $("#foo\\.bar");


4. 基础用法：
    1)连缀(Chaining)
      jQuery 很重要的一个特性是可以连续地使用函数(Chaining, 连缀), 当你选取了一个或一组的元素后，可以连续对这这些元素进行多个处理。
      例如：
        $("div").hide(); // 将所有的 <div> 隐藏
        $("div").css("color", "blue"); // 修改所有的 <div> 的文字颜色为蓝色
        $("div").slideDown(); // 以下拉的效果显示出来

        上面的三行代码可以用以下一行的代码取代，结果会是完全相同的：
        $("div").hide().css("color", "blue").slideDown();

      在 jQuery 的设计上，大部分的函数都会在处理完该做的事情后，再将原本传入的元素给回传回去，因此函数都可以连续的使用。
      jQuery 的连缀使用，有两个很重要的函数必须在此介绍一下：
      end()  这个函数执行后，会传回「前一组找到的元素」。
      find() 这个函数的用法根据先前找到的元素再找其底下的元素。类似 $() 选择器，不同的是 $() 是找整个页面，而 find() 像是一个再过滤的功能。
      filter() 筛选出与指定表达式匹配的元素集合。类似find(),但find()是查找子元素,而filter()是在此基础上直接过滤。

      如：
        $("ul.open")              // [ ul, ul, ul ]  选择元素,找出页面內所有 class 为 open 的 <ul>
        .children("li")           // [ li, li, li ]  选择元素下的子元素, 过滤出下一层的所有 <li>
        .addClass("open")         // [ li, li, li]   选择器没变， 对这些 <li> 新增一个 class
        .end()                    // [ ul, ul, ul ]  前一组找到的元素， 回前一次查找的结果，也就是所有的 <ul>
        .find("a")                // [ a, a, a ]     再查找元素下的元素， 再找出底下所有的 <a>
        .click(function(){        // [ a, a, a ]     选择器没变， 对 <a> 新增事件处理
            $(this).next().toggle();
            return false;
        })
        .end();                   // [ ul, ul, ul ]  前一组找到的元素

        上面这一段通过连缀，且使用 end() 和 find() 来分别对不同的元素进行操作，詳細的步驟解釋如下：


    2) 名称冲突
        $() 是 jQuery() 的缩写,但一般不喜欢用 jQuery 这样的长名称,而 $ 又会被别的框架占用。
        这时候可以使用别名来避免 $ 符号的名称冲突。

        使用 jQuery 前，先用 jQuery.noConflict() 申明一个名称,就可以避免掉 $() 冲突的問題。如：
        var j$ = jQuery.noConflict();
        j$(document).ready(function() {
          j$("div").addClass("special");
        });


5. 常用函数：
    使用 jQuery 来选取元素，其中大部份的语法都是可以让你快速地一次选取多个元素。
    透过 jQuery 内建的函数，你可以：
    1.对 DOM 进行操作，例如对文件节点的新增或修改
    2.添加事件处理
    3.做一些基本的视觉效果，例如隐藏、显示、下拉显示、淡出淡入等等
    4.使用 AJAX 传送窗体内容或取得远程文件

	// 以下执行后的内容，皆为示意结果
	1) 在元素节点下追加一段内容
        $("p").append("<b>Hello</b>");
        执行前：<p>I would like to say: </p>
        执行后：<p>I would like to say: <b>Hello</b></p>

    2) css()
        // 选取 id 为 body 的元素，並且修改两个 css 属性。
        $("#body").css({ border: "1px solid green", height: "40px" });
        执行前: <div id="body"> ... </div>
        执行后: <div id="body" style="border: 1px solid green; height: 40px"> ... </div>

	3) 提交前的判断
        // $(document).ready()事件，在载入就绪时执行。在 body 标签的 onload 事件之前执行。
        // $("form").submit() 相当于给所有的<form>标签加上 onsubmit 的内容
        <html>
          <head>
            <script type="text/javascript" language="javascript" src="../jquery.js"></script>
            <script type="text/javascript" language="javascript">
            $(document).ready(function() {
                $("form").submit(function() {
                    if ( $("input#username").val() === "" ) {
                        $("span").show();
                        return false;
                    }
                });
            });
            </script>
          </head>
          <body>
            <form action="jj.html">
              <label for="username">请输入大名</label>
              <input type="text" id="username" name="username" />
              <span style="display:none"><font color="red">这个栏位必填喔</font></span><br />
              <input type="submit" value="test" /><br />
            </form>
          </body>
        </html>
        // $(document).ready(function(){}) 可简写为: jQuery(function(){})


	5)发送Ajax
		//发送Ajax请求
		jQuery.ajax({
			type:"POST", //提交方式:POST 或者 GET
			url: "ajax_changeYL.jsp", //提交地址,默认本页面
			//发送的数据
			data: $('.wrapper').serialize(), //格式化一个form,得到结果如: "pSource=" + pSource + "&id=change",
			//同步请求,(默认: true) 默认设置下为异步请求。如果需要发送同步请求，此选项设置为 false 。注意，同步请求将锁住浏览器，用户其它操作必须等待请求完成才可以执行。
			async: false,
            dataType:"text", // 返回数据类型:"xml","html","script","json","jsonp","text"
			//错误时
			error:function(XMLHttpRequest, textStatus, errorThrown) { alert(textStatus);},
			//成功时,即回调函数
			success:function(data, textStatus, xhr) {
				// data 可能是 xmlDoc, jsonObj, html, text, 等等...
                // 在 ie 时,data 是 string； 在firefox时,data 是 xmlDoc； 故需要判断一下
                if (typeof data !== 'string') data = xhr.responseText;
				$("#queryResult").html(data); //相当于 $("#queryResult").innerHTML = data;
			},
			//完成时,执行 success 或者 error 之后的回调函数
			complete:function(XMLHttpRequest, textStatus) {
                var data = XMLHttpRequest.responseText;
			}
		});

	6) 序列化
	   $("form").serialize(); // 这会将 form 的所有可提交的内容序列化,结果如: single=单选的值&multiple=多选的值&check=check2&radio=radio1
       $(':text').serialize(); // 也可以单独将某些可提交的元素序列化

    7) 当DOM载入就绪可以查询及操纵时绑定一个要执行的函数
        $(document).ready(function(){
            // 在这里写你的代码...
        });

        //使用 $(document).ready() 的简写，同时内部的 jQuery 代码依然使用 $ 作为别名，而不管全局的 $ 为何。
        jQuery(function($) {
           // 你可以在这里继续使用$作为别名...
        });


        注意: jQuery 的 ready 在IE上的实现，是不断地轮询的,执行起来会影响浏览器效率,且不一定能保证按预期的执行。
        建议的做法是,把需要用这个 ready 执行的代码,写到页面的最底下,即 <html>标签后面的地方。

        如前面的“3) 提交前的判断”,例子即是使用 jQuery 的 ready, 建议改用下面的写法:
          <html>
          <head>
            <script type="text/javascript" language="javascript" src="../jquery.js"></script>
          </head>
          <body>
            <form action="jj.html">
              <label for="username">请输入大名</label>
              <input type="text" id="username" name="username" />
              <span style="display:none"><font color="red">这个栏位必填喔</font></span><br />
              <input type="submit" value="test" /><br />
            </form>
          </body>
          </html>
          <script type="text/javascript" language="javascript">
            (function() {
                $("form").submit(function() {
                    if ( $("input#username").val() === "" ) {
                        $("span").show();
                        return false;
                    }
                });
            })();
          </script>


	8) 绑定事件
        // 执行的函数
        function refreshNode(e) {
			type = e.data.type, // 绑定时的参数
			silent = e.data.silent;
            alert('type:' + type + ' silent:' + silent);
		}

		$(function(){
            // 简单的绑定事件
            $('#foo').bind('click', function() {
              alert('User clicked on "foo."');
            });
            // 带参数的绑定事件
		    $("#test_a").bind("click", { type: "refresh", silent: false }, refreshNode);
		    $("#test_b").bind("click", { type: "add", silent: true }, refreshNode);
		});

        被绑定的元素：
        <A id="foo" href="javascript:;">foo</A>
        <A id="test_a" href="javascript:;">test_a</A>
        <A id="test_b" href="javascript:;">test_b</A>


    9) 判断元素是否隐藏
        if($("#elem_id").is(":hidden")) {}







// http://jsgears.com/thread-63-1-1.html
// http://blog.ericsk.org/archives/tag/jquery-tut



