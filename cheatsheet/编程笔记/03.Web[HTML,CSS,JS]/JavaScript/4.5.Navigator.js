
Navigator对象
    浏览器和OS(系统)的信息 数组



浏览器判断：
     //如果是火狐等浏览器则为“true”
     var isNav = (navigator.appName.indexOf("Netscape") != -1);
     //如果是IE浏览器则为“true”
     var isIE = (navigator.appName.indexOf("Microsoft") != -1); // navigator.appName == "Microsoft Internet Explorer"
     var isIE = (navigator.appVersion.indexOf("MSIE") != -1);
     //判断IE6
     var isIE6 = (navigator.userAgent && navigator.userAgent.split(";")[1].toLowerCase().indexOf("msie 6.0")!="-1");
     //如果是Opera浏览器则为“true”
     var isOpera = (navigator.userAgent.indexOf("Opera") != -1);

OS(系统)判断：
     //浏览器运行的平台，是 windows 则返回 true
     var isWin = (navigator.appVersion.toLowerCase().indexOf("win") != -1);

