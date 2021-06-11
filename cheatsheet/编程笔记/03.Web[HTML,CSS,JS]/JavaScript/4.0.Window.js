
使用DHtml
    DHTML
       定义：使用JavaScript和CSS级联样式表操作HTML创造出各种动态视觉效果统称为DHTML
       DHTML = CSS + Html + JS
       是一种浏览器端的动态网页技术
    DHTML对象模型(DOM)
       将HTML标记、属性和CSS样式都对象化
       可以动态存取HTML文档中的所有元素
       可以使用属性name或id来存取或标记对象
       改变元素内容或样式后浏览器中显示效果即时更新
       DHTML对象模型包括浏览器对象模型和Document对象模型

Window对象的常用属性：
 * document    对象，代表窗口中显示的HTML文档
   frames      窗口中框架对象的数组
 * history     对象，代表浏览过窗口的历史记录
 * location    对象，代表窗口文件地址，修改属性可以调入新的网页
 * status      (defaultStatus)窗口的状态栏信息
   closed      窗口是否关闭，关闭时该值为true
 * name        窗口名称，用于标识该窗口对象
   opener      对象，是指打开当前窗口的window对象，如果当前窗口被用户打开，则它的值为null
   parent      对象，当前窗口是框架页时指的是包含该框架页的上一级框架窗口
   top         对象，当前窗口是框架页时指的是包含该框架页的最外部的框架窗口
   self        对象，指当前Window对象
   window      对象，指当前Window对象，同self

Window对象的常用方法：
(使用这些方法时，通常不加window也没区别；但在特定情况下必须加，如在内嵌页面用open();)
 * alert(sMsg);          弹出简单对话框
   confirm(sMsg);        选择对话框
   prompt(sMsg, sInit);  弹出输入对话框
 * close();              关闭窗口
   open(sURL, sName, sFeatures, bReplace);   打开窗口
   print();              打印窗口中网页的内容
   focus();              设置焦点并执行 onfocus 事件的代码。
   blur();               失去焦点并触发 onblur 事件。
   moveBy(iX, iY);       将窗口的位置移动指定 x 和 y 偏移值。
   moveTo(iX, iY);       将窗口左上角的屏幕位置移动到指定的 x 和 y 位置。
   resizeBy(iX, iY);     更改窗口的当前位置缩放指定的 x 和 y 偏移量。
   resizeTo(iWidth, iHeight);  将窗口的大小更改为指定的宽度和高度值。
   scrollBy(iX, iY);     将窗口滚动 x 和 y 偏移量。
   scrollTo(iX, iY);     将窗口滚动到指定的 x 和 y 偏移量。
 * setInterval(vCode,iMilliSeconds,sLanguage);    每经过指定毫秒值后执行一段代码。
   clearInterval(iIntervalID);                    取消 setInterval 函数的事件。
 * setTimeout(vCode,iMilliSeconds,sLanguage);     经过指定毫秒值后执行一段代码。(一次性)
   clearTimeout(iTimeoutID);                      取消 setTimeout 函数设置的超时事件。

window主要功能：
   1.窗口的打开和关闭
     window.open(url,name,config) 打开新窗口；url:打开的超链接，name:窗口的名称，返回新窗口对象
        config为窗口的配置参数：menubar 菜单条、toolbar 工具条、location 地址栏、directories 链接、
        status 状态栏、scrollbars 滚动条、resizeable 可调整大小(以上参数值为yes或no，默认yes)；
        width 窗口宽，以像素为单位；height 窗口高，以像素为单位(参数值为数值)
   * window.close() 关闭窗口
   2.对话框
     简单对话框：
        alert(str)        提示框，显示str字符串的内容；按[确定]关闭对话框
        confirm(str)      确认对话框，显示str字符串的内容；按[确定]按钮返回true，[取消]返回false
        prompt(str,value) 输入对话框，显示str的内容；按[确定]按钮返回输入值，[取消]关闭，返回null
     窗口对话框：
        showModalDialog(url,arguments,config)    IE4或更高版本支持该函数
        showModelessDialog(url,arguments,config) IE5或更高版本支持该函数
        参数:url 打开链接，arguments 传入参数名，config 窗口配置参数
         config 外观配置参数：status、resizable、help 是否显示标题栏中的问号按钮、center 是否在桌面中间
         dialogWidth 对话框宽、dialogHeight 对话框高、(上一行参数值为yes或no，这两行参数为多少像素)
         dialogTop 对话框左上角的y坐标、dialogLeft 对话框左上角的x坐标
   3.状态栏
     window.status                 状态栏中的字符串信息允许进行设置或读取
   4.定时器
     tID1=setInterval(exp,time)    周期性执行exp代码；exp 代码块名，time 周期(毫秒)，返回启动的定时器
     clearInterval(tID1)           停止周期性的定时器
     tID2=setTimeout(exp,time)     一次性触发执行代码exp；返回已经启动的定时器
     clearTimeout(tID2)            停止一次性触发的定时器
   5.内容滚动
     window.scroll(x,y)            滚动窗口到指定位置；单位为像素
     window.scrollTo(x,y)          同scroll函数
     window.scrollBy(ax,ay)        从当前位置开始，向右滚动ax像素，向下滚动ay像素
   6.调整窗口大小和位置
     window.moveTo(x,y)            移动窗口到指定位置；单位为像素
     window.moveBy(ax,ay)          向右移动ax像素，向下移动ay像素，参数为负数表示反方向移动
     window.resizeTo(width,height) 调整窗口大小为指定大小
     window.resizeBy(ax,ay)        放大或缩小窗口；参数为负数表示缩小
   7.Screen对象                    // 屏幕信息(属于window的子对象；常用于获取屏幕的分辨率和色彩)
     screen.width                  屏幕分辨率的宽度，例如1024*768分辨率下宽度为1024
     screen.height                 类似上面，屏幕分辨率的高度
     screen.availWidth             屏幕中可用的宽  //排除 Windows 任务栏
     screen.availHeight            屏幕中可用的高  //排除 Windows 任务栏
     screen.colorDepth             屏幕的色彩数
   8.History对象                   // 窗口的访问历史信息(属于window的子对象,常用于返回到已经访问过的页面)
     history.length                历史记录数
     history.foward()              向下一页
     history.back()                返回上一页
     history.go(0)                 刷新。括号里填"-1"就是返回上一页，填"1"就是下一页；其它数字类推

   9.Navigator对象     浏览器和OS(系统)的信息 数组
   10.Location对象     浏览器地址栏的信息  如： location.href="http://www.google.com/";
     location.assign(href);        前往新地址，在历史记录中，用 Back 和 Forward 按钮可回到之前的地址
     location.replace(href);       替代当前文文件，在历史记录中也回不到之前的地址
     location.reload(true);        类似刷新，默认 false
     // location 各属性的用途
     location.href                 整个URl字符串(在浏览器中就是完整的地址栏),如: "http://www.test.com:8080/test/view.htm?id=209&dd=5#cmt1323"
     location.protocol             返回scheme(通信协议)，如: "http:", "https:", "ftp:", "maito:" 等等(后面带有冒号的)
     location.host                 主机部分(域名+端口号)，端口号是80时不显示，返回值如："www.test.com:8080", "www.test.com"
     location.port                 端口部分(字符串类型)。如果采用默认的80端口(即使添加了:80)，那么返回值并不是默认的80而是空字符。
     location.pathname             路径部分(就是文件地址)，如: "/test/view.htm"
     location.search               查询(参数)部分。如: "?id=209&dd=5"
     location.hash                 锚点，如: "#cmt1323"
     不包含参数的地址：            location.protocol + '//' + location.host + location.pathname;


应用例子：窗口最大化
   window.moveTo(0,0); window.resizeTo(screen.availWidth,screen.availHeight);
   或者： moveTo(0,0); resizeTo(screen.width, screen.height);
   //采用screen对象的分辨率属性和resizeTo函数来动态确定窗口最大长度和宽度


选取页面的对象:
    var obj = document.forms["FormName"].elements["elementName"];
    var obj = document.forms[x].elements[y]; //x和y 是int类型，表示第几个表单，第几个元素
    var obj = document.FormName.elementName;
    var obj = document.all["elementName"];
    var obj = document.all["elementID"];
    var obj = document.getElementById("elementID");
    var obj = document.getElementsByName("elementName"); //返回数组
    var obj = document.getElementsByTagName("TagName");  //返回数组


IE上的关闭窗口时不提示
  window.opener = null; // 关闭IE6不提示
  window.open("","_self"); // 关闭IE7不提示
  //关闭窗口
  window.close();

刷新页面的几种方法：
  history.go(0);
  window.navigate(location);
  document.URL = location.href;
  document.execCommand('Refresh'); //火狐不能用
  location.reload();
  location = location;
  location.href = location.href;
  location.assign(location);
  location.replace(location);

页面跳转：
  location.href = "yourURL"
  window.location = 'url'
  window.location.href = "yourURL"
  window.navigate("top.jsp");
  self.location = 'top.htm' //令所在框架页面跳转，大框架不变
  top.location = 'xx.jsp';  //在框架內令整個页面跳转

页面跳转/刷新 的注意：
  需要先执行其他代码，然后再页面跳转或者刷新。因为页面跳转或者刷新后不再执行下面的代码。
  如：alert('请先登录'); window.location.href = 'index.jsp';

改变标题(即改变<title>标签的内容)
  document.title = "title_content";











属性
    document	对窗口或框架中含有文档的Document对象的只读引用
    document.body.offsetHeight; 返回当前网页高度//.offsetwidth
    defaultStatus	一个可读写的字符,用于指定状态栏的默认消息
    frames	表示当前对象中所有frame对象的集合
    location	用于代表窗口或框架的Location对象。如果将一个URL赋予给该属性,那浏览器将加载并显示该URL指定的文档
    length	窗口或框架包含的框架个数
    history	对窗口或框架的History对象的只读引用
    name	用于 存放窗口的名字
    status	一个可读写的字符,用于指定状态栏中的当前信息
    top	表示最顶层的浏览器窗口
    parent	表示包含当前窗口的父窗口
    opener	表示打开当前窗口的父窗口
    closed	一个只读的布尔值,表示当前窗口是否关闭。但浏览器窗口关闭时,表示该窗口的Window对象并不会消失,不过它的Closed属性被设置成True
    self	表示当前窗口
    screen	对窗口或框架的Screen对象的只读引用,提供屏幕尺寸、颜色深度等消息
    screen.availWidth 返回当前屏幕宽度(空白空间) //avail Height
    screen.width 返回当前屏幕宽度(分辨率值)// Height
    navigator	对窗口或框架的Navigator对象的只读引用,通过Navigator对象可以获得与浏览器相关的信息

方法
    alert()	弹出一个警告对话框
    confirm()	显示一个确认对话框,单击确认按钮时返回True,否则返回False
    prompt()	弹出一个提示对话框,并要求输入一个简单的字符串
    blur()	把键盘焦点从顶层浏览器窗口中移走。在多数平台上,这将使用窗口移到最后面
    close()	关闭窗口
    focus()	把键盘焦点从顶层浏览器窗口中移走。在多数平台上,这将使用窗口移到最前面
    open()	打开一个新窗口
      参数说明
        windowVar=window.open(url,windowname[,location])
        windowVar	当前打开窗口的句柄。如果open()方法执行成功,则windowVar的值为一个Window对象的句柄。否则windowVar的值是一个空值
        url	目标窗口的URL。如果URl是一个空字符串,那浏览器将打开一个空白窗口 ,允许用write()创建动态的html
        windowname	用于指定新窗口的名字,这个名字可以作为<a>标记和<form>的target属性的值。如果该参数指定了一个已经存在的窗口,那么opne()方法将不再创建一个新的窗口,而只是返回对指定窗口的引用
        location	对窗口属性进行设置,其可选参数如下表所示
      窗口属性设置的可选参数
        width	窗口的宽度
        height	窗口的高度
        scrollbars	是否显示滚动条
        resizable	设置窗口大小是否固定
        toolbar	浏览器工具条,包括后退及前进按钮等
        menubar	菜单条,一般包括文件、编辑及其他菜单项
        location	定位区,也叫地址栏,是可以输入URL的浏览器文本区
        direction	更新信息的按钮
        fullscreen	全屏显示
    scrollTo(x,y)	把窗口滚动到指定的x,y坐标指定的位置
    scrollBy(offsetx,offsety)	按照指定的位移量滚动窗口
    setTimeout(timer)	在经过指定的时间后执行代码
    clearTimeout()	取消对指定代码的延迟执行
    moveTo(x,y)	将敞口移动到一个绝对位置
    moveBy(offsetx,offsety)	将窗口移动到指定的位移量处
    resizeTo(x,y)	设置窗口的大小
    resizeBy(offsetx,offsety)	按照指定的位移量设置窗口的大小
    print()	相当于浏览器工具栏中的“打印”按钮
    setInterval()	周期执行指定的代码
    clearInterval()	停止周期性的执行代码
    navigate()	IE方法,用于装载并显示指定的URL
    back()	Netscape方法,相当与单击了Netscape浏览器中的“Back”按钮
    forward()	Netscape方法,相当与单击了Netscape浏览器中的“Forward”按钮
    home()	Netscape方法,用于显示浏览器的主页
    stop()	Netscape方法,相当与单击了Netscape浏览器中的“Stop”按钮
