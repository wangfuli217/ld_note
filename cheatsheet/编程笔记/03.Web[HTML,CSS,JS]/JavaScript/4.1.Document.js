
选取页面的对象:
    var obj = document.forms["FormName"].elements["elementName"];
    var obj = document.forms[x].elements[y]; //x和y 是int类型，表示第几个表单，第几个元素
    var obj = document.FormName.elementName;
    var obj = document.all["elementName"];
    var obj = document.all["elementID"];
    var obj = document.getElementById("elementID");
    var obj = document.getElementsByName("elementName"); //返回数组
    var obj = document.getElementsByTagName("TagName");  //返回数组



Document对象
  属性
    all(elementID)	表示文档中所有<html>标记的集合(只适用与IE)
    alinkColor	设置一个被激活链接的颜色
    anchors	获取文档中<anchor>标记的集合(数组)
    bfColor	设置背景颜色
    fgColor	设置文档的前景色(文本)
    cookie	获取与文档相关的Cookie
    domain	用于指定文档的安全域
    embeds	代表文档中所有<embed>标记的数组
    forms	代表文档中所有<form>标记的数组
    getSelection()	返回选中的文本
    images	代表文档中所有<image>标记的数组
    lastModified	代表文档的最后修改时间
    linkColor	设置未访问过的链接的颜色
    links	代表文档中所有<a>标记的数组
    title	获得文档的标题
    URL	返回文档对应的URL
    vinkColor	设置以访问过链接的颜色
  方法
    open([mimetype])	未write()和writeln()语句准备一个流,它的参数mimetype可以时几个MIME类型(包括text/html,text/plain,image/x-bitmap和plugln(any Netscape plug-in MIMEtype))之一,默认值是text/html
    close()	关闭由open()方法打开的流
    focus()	让指定的文档获得焦点
    write()	向文档职工写入文本
    writeln()	向文档职工写入文本,并向文档的末尾追加一个换行符

