<%@ page 
	language="java"
	pageEncoding="utf-8"
	import="java.util.*"
	import="java.io.*"
	import="java.io.File"
	import="java.io.FileOutputStream"
	import="java.io.InputStream"
	import="java.util.Date"
%><%

if ( request.getContentType() != null )
{
	doUpload(request);
	%>
  	<center>
  		<font color='red'>文件上传成功！</font>
  	</center>
	<%
}

%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>文件上传</title>
		<meta http-equiv="content-type" content="text/html; charset=utf-8">
	</head>

	<body>
		<center>
			<h1>请输入上传文件</h1>
			<form action="#" method="post" enctype="multipart/form-data">
				文件上传：
				<input type="file" name="file" />
				<br />
				<input type='submit' value="upload" />
				<input type='hidden' name="method" value="upload" />
			</form>
		</center>
	</body>
</html>

<%!

	public void fileupload(HttpServletRequest request) {
		System.out.println("************************************"); //*************
		//1.判断是否文件上传
		String contentType = request.getContentType();
		System.out.println("** contentType: " +contentType); //*************
		
		//2.获取boundary
		String boundary = null;
		if(contentType.indexOf("multipart/form-data") != -1) {
			boundary = contentType.substring(contentType.indexOf("boundary=") + 9);
			System.out.println("** boundary: " + boundary); //*************
		}
		
		//3.获取request请求的内容长度
		int contentLength = request.getContentLength();
		//4.临时存放http数据的byte数组
		byte[] databuffer = new byte[contentLength];
		
		//5.以流的形式读取http请求内容
		InputStream is = null;
		try {
			int dataRead = 0;
			int totalDataRead = 0;
			is = request.getInputStream();
			while ((dataRead = is.read(databuffer, totalDataRead, contentLength)) != -1) {
				totalDataRead += dataRead;
			}
		} catch (Exception e) {
			//e.printStackTrace();
			System.out.println("** Exception 1 : " + e); //*************
		}
		
		//6.转换为String
		String content = new String(databuffer);
		System.out.println("** content:" + content); //*************
		
		//7.获取文件名
		String filename = content.substring(content.indexOf("filename=\"") + 10);
		filename = filename.substring(0, filename.indexOf("\""));
		System.out.println("** filename: " + filename); //*************
		
		//8.寻找文件的起止位置
		int pos = content.indexOf("filename=\"");
		pos = content.indexOf("\n", pos) + 1;
		pos = content.indexOf("\n", pos) + 1;
		pos = content.indexOf("\n", pos) + 1;
		
		int boundaryEnd = content.indexOf(boundary, pos) - 3;
		
		//9.同时可以处理文本文件、二进制文件
		int start = content.substring(0, pos).getBytes().length;
		int end = content.substring(0, boundaryEnd).getBytes().length;
		
		//10.保存到文件系统
		String dirStr = new File(getServletContext().getRealPath("/")).getAbsolutePath();
		dirStr += "/uploading/";
		File dir = new File(dirStr);
		if(!dir.exists()) {
			dir.mkdir();
		}
		File file = new File(dirStr + filename);
		if(file.exists()) {
			//
			filename = filename + (new Date()).getTime();
		}
		
		FileOutputStream fos = null;
		try {
			fos = new FileOutputStream(dirStr + filename);
			fos.write(databuffer, start, (end - start));
			fos.close();
		} catch (Exception e) {
			//e.printStackTrace();
			System.out.println("** Exception 2 : " + e); //*************
		} finally {
			if(fos != null) {
				try {
					fos.close();
				} catch(Exception ee) {
					ee.printStackTrace();
				}
			}
		}
	}


public void doUpload(HttpServletRequest request) throws IOException {
	String dirStr = new File(getServletContext().getRealPath("/")).getAbsolutePath();
	PrintWriter pw = new PrintWriter(new BufferedWriter(new FileWriter(dirStr+"/test.txt")));
	ServletInputStream in = request.getInputStream();
	int i = in.read();
	while (i != -1)
	{
		pw.print((char) i);
		i = in.read();
	}
	pw.close();
}
%>