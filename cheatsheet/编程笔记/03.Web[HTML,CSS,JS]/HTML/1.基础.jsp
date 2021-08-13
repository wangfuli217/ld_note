
一、Html简介
   HTML 是一种标记语言
      忽略大小写，语法宽松
   使用 HTML 标记和元素，可以：
      控制页面和内容的外观
      发布联机文档
      使用 HTML 文档中插入的链接检索联机信息
      创建联机表单，收集用户的信息、执行事务等等
      插入动画
      开发帮助文件
   HTML 标记的格式组成： <ELEMENT ATTRIBUTE = value>
      ELEMENT:   元素 - 标识标记
      ATTRIBUTE: 属性 - 描述标记
      value:     值  - 分配给属性的内容

二、超链接
   <A HREF='protocol://host.domain:port/path/filename'> Hypertext </A>
    Protocol    协议类型
       http      –超文本传输协议<a href="http://127.0.0.1:8080/shopcart/index.html">
       gopher    –搜索文件          <a href="gopher://gopher.baidu.com/00/teams">directory</a>
       telnet    –打开 telnet会话    <a href="telnet://suvax.stateu.edu">...</a>
                                     需端口的 <a href="telnet://suvax.stateu.edu:3000">...</a>
                                     需登录的 <a href="telnet://username:password@suvax.stateu.edu">...</a>
       ftp       –文件传输协议    匿名：<a href="ftp://ftp.baidu.com/pub/xxx.txt">下载</a>
                                     需登录的： <a href="ftp://username:password@ftp.baidu.com/pub/xxx.txt">资料</a>
       mailto    –发送电子邮件      <A HREF="mailto:daillow@gmail.com">电子邮件连接
    Host.domain 服务器的 Internet 地址
    Port        目标服务器的端口号
    Hypertext   用户必须单击才能激活链接的文本或图像

三、Html的基本标记
    标记：左尖括号“<”和右尖括号“>”之间的文本
      1. 在<  >中的称为开始标记；在</  >中的称为结束标记
      2. 空标记：不包含元素的标记。空标签必须以“/>”结束。格式： <空标记的名称/> <空标记的名称 属性列表/>
    注意：
      除空标记外，标签必须成对：有始有终。所有的开始标签和结束标签必须匹配。
      在标记符“<“和"标记的名称"之间不能含有空格。在标记符"/>"前面可以有空格或回行。
      标签必须嵌套正确。
      由于浏览器间的恶性竞争，标记的使用也不再严格。例如，允许只有开始标记而没有结束标记，标签嵌套不正确等。

   标题标记    <h1>~<h6> 标题标记，可显示六种大小的标题(1最大，6最小)
   段落级标记  <ADDRESS> 可包含：到主页的链接,搜索字符串功能,版权信息,文档的作者、地址、签名等信息
               <BLOCKQUOTE> 显示文档中的引用文本。用于较长的引用且显示为缩进式段落。
               <PRE> 此元素用于预定义文本的格式。文本在浏览器中显示时遵循在HTML源文档中定义的格式。
   块标记      <SPAN>定义段落内的内容块； <DIV>可以定义跨段落的内容块
   字符级标记  (见下面的语法大全，字体效果)
   列表        <li type=...> 指定符号type="disc"空心圆/"circle"实心圆/"square"方形
               <OL TYPE="a/A/i/I"> 有序号的列表(内嵌<li>)(a/A用字母标示，i/I希腊字母标示)
               <UL TYPE="disc/circle/square"> 无序号的列表(内嵌<li>)
              从第n个值开始编号<OL START = n> type=数值：从1开始(任何数值都是这样)
              OL与UL没区别；TYPE="a/A/i/I"就有序号，TYPE="disc/circle/square"就没序号
              定义列表包含在<DL>标记内。<DT>标记用于指定要定义的术语，而<DD>标记用于对术语的定义。
   水平标尺标记 <HR> 用于在页面上绘制一条水平线。它没有结束标记，且不包含任何内容。
   字体标记    <FONT> 可以指定size、color、style(样式)等属性。
   图像标记    <IMG>  语法为：<IMG SRC="URL">。 支持GIF(支持图形渐近,动画)； JPEG(.JPG)； PNG

   使用META标记
      1. 提供关于网页的信息
        <META NAME="Generator" CONTENT="EditPlus"/>
        <META NAME="Author" CONTENT="daillo"/>           <!--获得文档的作者名称-->
        <META NAME="Keywords" CONTENT=""/>               <!--根据关键词生成响应-->
        <META NAME="Description" CONTENT="noting Book"/> <!--对网页的描述-->
      2. 应用：关键词生成响应
        <META http-equiv="Expires" content="Mon, 15 Sep 2003 14:25:27 GMT"/>
          设置网页的到期值:响应   Expires: Mon, 15 Sep 2003 14:25:27 GMT
      3. 自动刷新页面
        <META http-equiv="Refresh" content="10; url=http://yourlink"/>
          应用：如网上实时新闻报道。 content指每多少秒更新一次
      4. 设置网页所使用的编码
        <META http-equiv="Content-Type" content="text/html; charset=utf-8"/>
          设置网页使用gb2312: 页面显示中文(还可设置utf8等等)  应用：如在不同浏览器上正确显示中文。

   指定页面小图标
      <link rel="shortcut icon" href="images/favicon.ico"/>

   在HTML文档中使用特殊字符(跟XML的一样)
      &gt;   ==== >   大于号(&#62;)       &lt;   ==== <   litter 小于(&#60;)
      &ge;   ==== ≥   大于等于            &le;   ==== ≤   小于等于
      &ne;   ==== ≠  不等于              &nbsp; ====     空格(&#160;)
      &#92;  ==== \   反斜杆              &frasl;==== /   正斜杆(&#47;)
      &amp;  ==== &   与符号(&#38;)       &#37;  ==== %   百分号
      &quot; ==== "   双引号(&#34;)       &#39;  ==== '   单引号
      &copy; ==== ©   版权符号            &reg;  ==== ®   注册商标
      &#64;  ==== @   邮件符号            &#95;  ==== _   下划线
      &#43;  ==== +   加號


四、使用表<Table>
    与表相关的标记
    <TABLE>表标记
    <tr>指定表格中的一行
    <th>指定标题列
    <td>指定表格中的单元格
    在<TH>或<TD>标记中使用COLSPAN="n"表示跨n列(合并n列)；ROWSPAN="n"表示跨n行(合并n行)
    border定义边框宽；cellSpacing定义单元格间距(单位像素)；cellpadding定义格边界与格内容的间距

    <!-- 表单用例。 -->
    <html>
    <head>
        <title>注册页面</title>
        <META http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    </head>
    <body background="1.jpg" bgcolor="#04D4F3" ><!--定义背景颜色和背景图片(图片在上层)-->
        <br /><br /><!-- 换行 -->
        <fieldset><!-- 用一个 fieldset外框 把内容括起来 -->
            <legend>用户注册</legend><!-- 给这个 fieldset外框 定一个标题 -->
        <form name="pageForm" method="post" action="#"><!--action输入文本要提交的地方-->
        <table align="center" style='font-size:25' border='3'><!-- table可定义整体外观 -->
            <caption><h3>User Register</h3></caption>      <!-- 表单的标题 -->
            <tr align="center" bgcolor='blue'><!-- tr 定义一行的属性-->
                <th colspan='2'>注册页</th><!--colspan横向合并单元格，rowspan纵向；部分结束格式可不写-->
            </tr>
            <tr><!--th表示一行的标题，稍加粗点；td定义各个单元格-->
                <th>用户名：</th><!--单行文本-->
                <td><input type="text" name="username" placeholder="请填写用户名"/></td>
                <!-- placeholder 属性显示预期值,该提示会在输入字段为空时显示,<input> 类型：text, search, url, telephone, email 以及 password。 是 HTML5 中的新属性 -->
            </tr>
            <tr>
                <th>密码：</th><!-- 密码隐藏，不显示； -->
                <td><input type="password" name="password"/></td>
            </tr>
            <tr><th>确认密码：</th>
                <td><input type="password" name="password"/></td>
            </tr>
            <tr><th>性别：</th><!--单选选项--><!-- checked 是默认值，对 checkbox 同样可设置 -->
                <td><!-- 单选框, checked 是默认选中的值，对 checkbox 同样可设置。 注意,各个 radio 的name属性要相同，否则没关联了 -->
                    <input type="radio" id='gender1' name="gender" value="male" checked/><label for='gender1'>男</label>
                    <!-- label标签的for需对应 radio 的id值,这样，点击label的文字时，会自动选中对应的 radio -->
                    <input type="radio" id='gender2' name="gender" value="female"/><label for='gender2'>女</label>
                    <input type="radio" id='gender3' name="gender" value="none"/><label for='gender3'>保密</label>
                </td>
            </tr>
            <tr><th>学历：</th><!--下拉菜单选项-->
                <td>
                    <select name="xueli"><!-- 下拉菜单选项，预设值为 selected -->
                        <option value="blank">没读书</option>
                        <option value="xx">小学</option>
                        <option value="cz">初中</option>
                        <option value="gz">高中</option>
                        <option value="dz">大专</option>
                        <option value="bk" selected>本科</option>
                        <option value="ss">硕士</option>
                        <option value="bs">博士</option>
                        <option value="bsh">博士后</option>
                    </select>
                </td>
            </tr>
            <tr><th>爱好：</th><!--多选选项--><!-- checked 是默认勾上的值 -->
                <td>旅游<input type="checkbox" name="hobby1" value="travel" checked/>
                    看书<input type="checkbox" name="hobby2" value="book"/><br />
                    音乐<input type="checkbox" name="hobby3" value="music"/>
                    交友<input type="checkbox" name="hobby4" value="friends"/>
                </td>
            </tr>
            <tr><th>照片：</th><!-- 浏览文件框 -->
                <td><input type="file" name="photo" /></td>
            </tr>
            <tr><th>自我介绍：</th><!--多行文本,这textarea不能用空标志-->
                <td><textarea cols="17" rows="3"></textarea></td>
            </tr>
            <tr align="center" bgcolor=blue>
                <td><input type="reset"/></td>
                <td><input type="submit" value="提交"/></td>
            </tr>
        </table>
        </form>
        </fieldset>
    </body>
    </html>


	标签使用:
	<input type="text" name="username" id="username" value="kk" maxLength="20" size="10" title="请输入用户名"/>
	input type=text 标签里,value值可认为是默认值,maxLength值是输入长度的限制,size值是输入框的长短大小,title值是提示内容


五、在Html中使用多媒体
    (在<body>中插入)
    插入图片  <IMG SRC=./picture/cart.gif ALT="购物车">
    插入声音  <BGSOUND SRC="E:\\解决方案\\音乐\\3.mid"> (windows的路径写法)
             <bgsound src="上海滩.mp3">
    音频/视频 <EMBED ALIGN=CENTER SRC= "\path\file name" AUTOSTART= "TRUE" >

六、表单的使用
    用途：收集信息，发送给程序处理
      ACCEPT="Internet media type"
      ACTION="URL"  指定处理提交的表单的脚本的位置
      METHOD = (GET | POST)   指定向服务器发送数据的方法。
    <input>属性：
      TYPE=  此属性指定表单元素的类型。可用的选项有 TEXT(默认；单行文本)、CHECKBOX(多选)、
             RADIO(单选)、SUBMIT(提交)、RESET(重置)、FILE(浏览文件)、HIDDEN、
             PASSWORD(显示特定符号的单行文本)、IMAGE(插图) 和 BUTTON。
      VALUE= 此属性是可选属性，它指定表单元素的初始值
      NAME=  此属性指定表单元素的名称。例如，如果表单上有几个文本框，可以按照名称来标识它们
      MAXLENGHT= 此属性用于指定在TEXT或PASSWORD表单元素中可以输入的最大字符数。默认值为无限的
      CHECKED= 是Boolean属性，指定按钮是否是被选中的。当输入类型为RADIO或CHECKBOX时使用。
      SIZE=  此属性指定表单元素的显示长度。用于文本输入的表单元素即输入类型是TEXT或PASSWORD的
    input-type (见属性 TYPE= )
    除input外，其它输入元素：
      TextArea 元素(属性：Cols、Rows、Size) 多行文本
      BUTTON 元素(属性：Name、Value、Type)
      SELECT 元素(属性：Name、Size、Multiple、option) 下拉菜单(单选)

七、框架(frame)
    框架将 Web 浏览器分成多个不同的区域，每个区域都可以显示独立、可滚动的页面。达到多个视图的效果。
    <FRAMESET Rows Cols> 创建框架。 Rows分行；Cols分列。行列都分窗口时需要嵌套
    <frameset cols="20%,*,20%"> 分割左中右三个框架；将左边和右边框架分割大小为20%；其余的自动调整
    <frameset rows="20%,*"> 上下分割,将上面框架分割大小为20%；下面框架的大小浏览器会自动调整
    <FRAME src="x.html"> 在 FRAMESET 元素内指定单个框架。 属性有Name、Src、Noresize、
        Scrolling=yes|no、 Frameborder、Marginwidth、Marginheight
    <NOFRAMES> 对那些不支持 FRAMESET 的浏览器使用的 HTML。 定义不出现分割窗口的文字
    <IFRAME src="xxx.html"> 内嵌框架，不需要 frameset ，随处可用。
        属性:Name,Width,Height,scrolling=auto,frameborder

八、实例与技巧
	1. input 标签的特殊字符
	   按钮上的文字换行: <input type="button" value=" 登   入 &#13; login " />
	   按钮的value上,可以使用特殊字符,页面上即可显示
	   同时,在输入框内也可以使用特殊字符,传值时会自动转码: <input type="text" value="a &lt; b" />

	2.checkbox 点击文字时选中
	   有两种 <label> 写法，一个是 <label> 里面的 for 属性指向 checkbox 的id。
	   另一种写法是 <label> 包含着 checkbox 标签。如下
		<label><input type="checkbox" name="task_ticket_types" value="111"/>公积金</label>&nbsp;&nbsp;
		<input type="checkbox" name="task_ticket_types" id='t2' value="111"/><label for="t2">社保</label>
