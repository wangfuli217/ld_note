<%--
    /**
     * 文件下载页面
     * 使用范例： <A href='download.jsp?path=help&name=install.bat'>安装文件</A>
     */

--%><%@page
    language = "java"
    contentType = "text/html; charset=utf-8"
    import = "java.io.File"
    import = "java.io.FileInputStream"
%><%

try {
	String path = request.getParameter("path"); // 文件的项目路径
	String name = request.getParameter("name"); // 文件名
    path = new String(path.getBytes("ISO-8859-1"), "UTF-8"); // 转码,否则会有乱码问题
    name = new String(name.getBytes("ISO-8859-1"), "UTF-8");

	String filepath = application.getRealPath("/") + path + "/" + name; // 文件的绝对路径
	File myfile = new File(filepath);
    // 文件不存在时
    if (!myfile.exists()) {
        System.out.println("不存在文件: " + filepath);
        return;
    }

    // 设置HTTP输出头参数
    response.setContentType("application/octet-stream;charset="+application.getInitParameter(request.getLocale().toString()));
	String isoName = new String(name.getBytes(), "ISO-8859-1");
    response.setHeader("Content-Disposition", "attachment; filename=\""+isoName+"\"");
    response.setHeader("Connection", "close");
    // response.setHeader("Content-Type", "application/octet-stream");
    response.setHeader("Location", isoName);
    // response.setHeader("Cache-Control", "max-age=" + cacheTime);
    response.setContentLength((int)myfile.length());

	FileInputStream fileInputStream = new FileInputStream(myfile);
	int l = (int)myfile.length();
	byte[] b =new byte[l];
	int i;
	while ((i=fileInputStream.read(b,0,l))!= -1) {
		response.getOutputStream().write(b,0,i);
	}
	fileInputStream.close();
}
// 会抛出 IOException
catch (Exception e) {
    System.out.println("Exception:" + e);
}
%>