
使用iReport制作报表的详细过程(Windows环境下)


一、准备

1.1、 安装JDK
    下载地址：http://www.sun.com
    验证JDK或是JRE是否可以默认运行，在命令行(CMD)打入X:>java 可用时出现：Usage：java..开头的一堆信息
    不可用则必须进行配置，在windows的环境变量设置：
	path：在最后面加入“;java的安装目录”
	JAVA_HOME ：“java的安装目录”
	CLASSPATH：“java的安装目录\bin”
    重新验证JDK或是JRE是否可以在CMD运行

1.2、 下载iReport
    地址：http://ireport.sourceforge.net/

1.3、 准备数据库
    iReport支持绝大部分数据库，只要该数据库能提供JDBC驱动器。
    【特别提示】数据库的版本要求与iReport文件夹下的Lib目录的使用驱动程序兼容，建议下载最新版本的驱动


二、配置基本信息

2.1、配置界面使用的语言
    设置环境，通过【Tools】－【Options】开启配置iReport系统的基本信息对话框。在“Language”里面选择语言，【Apply】确认。

2.2、配置数据库连接 
     这是报表与数据库的接口。点击[Report Datasources]按钮打开对话框。
     iReport 会记录以前使用的所有连接，除非手工删除，否则都会存在配置列表中，不管是否可用。
     点击【New】进入配置新连接界面，填写JDBC连接需要的信息，iReport支持多种数据源连接。
     如果需要报表提供中文内容显示可以在JDBC URL下工夫，比如输入： 
         jdbc:mysql://localhost/SUBRDB?user=****&password=****&useUnicode=true&characterEncoding=GB2312
     [Test]按钮可测试数据库是否可用。

2.3、新建一个空报表的基本配置 
     单击工具栏的第一个工具“New Report”，新建一个报表。

2.4、几个重要的概念 
     1) iReport 的输出格式
        可以支持： PDF、HTML、CSV、JAVA2D、Excel、纯文字、JRViewer，其中最常用的是PDF、JRViewer。
        JRViewer是直接以C/S方式作为报表的输出格式，在JFrame框架下输出。 Jasperreport 提供默认的JRViewer输出类。
     2) 报表的动态对象变量、参数、字段
        ·字段(Fields)：是数据库抽取出来的，希望在报表中出现的数据库内容。比如一个ID的所有值 $F{ filedsName }
        ·参数(Parameters)：这是你的应用需要提供给报表的入口。
         比如你希望在报表被解释的时候提供 Where语句的条件值，那么就可以使用参数 $P{ parameterName }
        ·变量(Variables)：这是报表中一些逻辑运算的表现，比如统计值 $V{ variablesName }
     3) 编译、静态运行、动态运行
        Jasperreport 运行时需要的就是一个jasper后缀的文件，编译过程其实就是把jrxml后缀的文件生成 jasper后缀的文件。
        静态运行和动态运行是相对的，后者带数据源运行，比如带数据库运行。
        静态运行与数据源无关，如果报表中出现和数据源有关的对象，则以null显示。
     4) 报表结构
        大致有：title、pageHeader、columnHeader、detial、columnFooter、pageFooter、summary、groupHeader、groupfooter。
        ·Title：每个报表一般会有一个名字，比如×××销售报表，title就是搁置这个名称的最好地方了
        ·pageHeader：报表的一些公共要素，比如页码、创建时间、创建人等信息放置在这里是比较好的选择。
        ·columnHeader：无可非议的这里是放置列的名称，记住不是列数据。
        ·Detial：放置需要循环的数据，比如销售记录数据。
        ·columnFooter：放置列级别的统计计算值或是列的说明。
        ·pageFooter：放置页级别的统计值或是页的说明。 
        ·Summary：可能需要对几页(你的报表可能由几个页组成)的统计值。在几页的Detial之后，出现一个统计页面。
        ·groupHeader：每个表的内容可能需要根据某个属性进行划分显示内容和计算内容。
         比如以月份为单位每组分开显示记录，那么就可以定义一个组，groupHeader就是放置组说明或是组标志最好的地方。 
        ·Groupfooter：放置组的统计或是说明。

2.5、向表添加对象
     1) 添加静态对象(Static Text)
        添加文本，拖动到[Static Text]Label到需要的地方，双击他写进内容。还可编辑其大小、颜色等。
        添加图片，点击[Image Tool]，选择图片，操作与Text 类似。其他静态对象操作步骤类似。
     2) 创建 SQL 查询语句 
        通过菜单【资料来源】－【报表查询】开启SQL输入对话框，并在【ReportSQL Query】Label中输入SQL语句
        可自动或手动获取数据库表的可用Fields。单击【OK】 ，保存报表。 
     3) 创建字段动态对象
        字段也就是数据库中的字段，通过字段的列表(工具条上可以找到 [Text Field])，可以拖放detial段
     4) 创建组
        组是一个很重要的概念，一个报表可以多个组，每个组以一个关键字为标记。
        比如希望Bug统计是根据项目（或是产品）进行统计的。那么可以设立一个项目标记的组。
     5) 添加参数和使用参数(Parameter)
        参数作用，一般是需要外界提供参数给报表的入口，比如SQL语句的 where 条件的表达式。
        通过【预览】－【报表参数】开启报表参数列表对话框(工具条上可以找到相应的工具)。
        当应用提供参数时，只要指定提供给这个参数，那么报表解释引擎即可替换这些变量然后再执行SQL语句
        例如：添加参数 id 后，可在报表的查询语句里加入 where memid = $P{id} ，页面没传来这参数时，它的值为null
     6) 添加变量和使用变量
        变量的定义类似参数，通过【预览】－【报表变量】开启报表变量列表对话框(工具条上可以找到相应的工具)
        如定义一个Bug的计数器。除了自定义变量，iReport 还有提供一些内嵌(Buildin)的变量，比如页码，行记录数等。 

三、JSP生成文件
     以下是一个生成报表文件的jsp页面实例

<%@ page pageEncoding="UTF-8" %>
<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ page import="net.sf.jasperreports.engine.export.*" %>
<%@ page import="net.sf.jasperreports.view.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<html>
<head>
    <title></title>
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
</head>
<body>
<%
    request.setCharacterEncoding("UTF-8");
    String printer = request.getParameter("printer");//页面传来的参数
    String doc = request.getParameter("doc"); //页面传过来的，需要调用的报表的名称(如“member.jasper”就写member)
    String loadType = request.getParameter("loadType");//需生成报表的文件类型

    //连接到数据库
    String url ="jdbc:mysql://127.0.0.1:3306/test";
    Class.forName("com.mysql.jdbc.Driver");
    Connection conn = DriverManager.getConnection(url,"root", "root");
    //設置生成報表參數
    Map parameters = new HashMap();
    parameters.put("printer", printer);//把页面参数传给报表

    //設置jasper文件
    //如果写在Servlet里，则这句的“application”应写成“this.getServletContext()”
    File reportFile = new File(application.getRealPath("/reports/" + doc +".jasper"));
    JasperPrint jasperPrint = JasperFillManager.fillReport(reportFile.getPath(),parameters,conn);

    try
    {   
    	JRExporter exporter = null;
        if ( "xls".compareTo(loadType) == 0 )
    	{
    	    response.setContentType("application/vnd.ms-excel");
    	    response.addHeader("Content-Disposition", "attachment;filename=" + jasperPrint.getName() + ".xls");
    		exporter = new JRXlsExporter();
    		exporter.setParameter(JRXlsExporterParameter.IS_ONE_PAGE_PER_SHEET, Boolean.FALSE); 
    		exporter.setParameter(JRXlsExporterParameter.IS_REMOVE_EMPTY_SPACE_BETWEEN_ROWS, Boolean.TRUE);
      		exporter.setParameter(JRXlsExporterParameter.IS_WHITE_PAGE_BACKGROUND, Boolean.FALSE);
    	} 
    	else if ( "pdf".compareTo(loadType) == 0 )
    	{
    	    response.setContentType("application/pdf");
    	    response.addHeader("Content-Disposition", "attachment;filename=" + jasperPrint.getName() + ".pdf");
            exporter = new JRPdfExporter();
    	}
    	else if ( "html".compareTo(loadType) == 0 )
    	{
    	    response.setContentType("application/octet-stream");
    	    response.addHeader("Content-Disposition", "attachment;filename=" + jasperPrint.getName() + ".html");
            exporter = new JRHtmlExporter();
            exporter.setParameter(JRHtmlExporterParameter.IS_USING_IMAGES_TO_ALIGN, Boolean.FALSE);
    	}
    	else if ( "rtf".compareTo(loadType) == 0 )
    	{ 
    	    response.setContentType("application/octet-stream");
    	    response.addHeader("Content-Disposition", "attachment;filename=" + jasperPrint.getName() + ".rtf");
            exporter = new JRRtfExporter();
    	}
    	else if ( "csv".compareTo(loadType) == 0 )
    	{ 
    	    response.setContentType("application/octet-stream");
    	    response.addHeader("Content-Disposition", "attachment;filename=" + jasperPrint.getName() + ".csv");
            exporter = new JRCsvExporter();
    	}
    	else if ( "xml".compareTo(loadType) == 0 )
    	{
            exporter = new JRXmlExporter();
    	}
    	else
    	{
            JasperViewer.viewReport(jasperPrint); //不建议用到这个
            throw new Exception();
    	}
        exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
        exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, response.getOutputStream());
        exporter.exportReport();
    }
    catch ( JRException e )
    {
    	System.out.println("-----report.jsp.err: " + e);
    	throw new ServletException(e);
    }
    catch ( Exception e )
    {
    	System.out.println("----- view report -----");
    }
    finally
    {
        if(conn!=null)try{conn.close();}catch(Exception e){e.printStackTrace();}
    }
%>
</body>
</html>





















