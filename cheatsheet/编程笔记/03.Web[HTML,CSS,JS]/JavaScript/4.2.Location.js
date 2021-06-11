
Location对象     浏览器地址栏的信息  如： location.href="http://www.google.com/";
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






Location对象
  属性
    hash	表示当前URL中的锚部分,包括前导散列符“#”(如#top)。文档URL的这一部分(#top)指定了锚在文档中的名字
    host	表示当前URL中的主机和端口号部分
    hostname	表示主机名和domain名
    pathname	表示当前的URL路径名
    href	表示URL的全名
    port	表示当前URL的通信端口号
    protocol	表示当先URL的协议部分,例如http,ftp等
    search	表示当前URL的查询字符串部分,也就是?后传送给服务器的参数
  方法
    reload()	刷新当前页面
    replace()	用URL指定的页面替代当前页面
