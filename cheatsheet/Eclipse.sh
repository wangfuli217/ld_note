创建Java项目、创建Java包、创建Java类、创建Java接口、创建XML文件。



Eclipse(菜单)
{
File    可以导入和导出工作区的内容及关闭 Eclipse。
Source  Source 菜单关联了一些关于编辑 java 源码的操作。
Navigate    Navigate 菜单包含了一些快速定位到资源的操作。
Project Project 菜单关联了一些创建项目的操作。
        Properties 本项目编辑编译相关的设置。
Window  Window 菜单允许你同时打开多个窗口及关闭视图。 
    Properties： Eclipse 的参数设置也在该菜单下。
   
}

Eclipse(视图)
{
显示内容方式：
Window 菜单中点击 "Show View" 选项打开其他视图。
View中的Task 、 Task List 、Template很有意思 Javadoc在这里也有。


工作方式：
通过"Window"菜单并选择"Open Perspective > Other"来打开透视图对话框。
1. Java EE
2. Java
3. Debug
4. Java Browsing
自定义可选工作方式：
点击菜单栏上的 "Windows" => "Customize Perspective" => 弹出窗口，可以在"Submenus"里面选择你要设置的内容
}

Eclipse(工作空间)
{
1. 项目
2. 文件
3. 文件夹
文件创建向导(File > New > File) 。
文件夹(Folder)创建向导(File > New > Folder) 。

在菜单栏上选择 "Window" => "preferences..." => "General"=>"Workspace"，
Eclipse切换工作空间可以选择菜单栏中选择 "File" => "switch workspace"：


}

Eclipse(创建 Java 项目)
{
选择项目布局（Project Layout），项目布局决定了源代码和 class 文件是否放置在独立的文件夹中。 推荐的选项是为源代码和 class 文件创建独立的文件夹。
}

Eclipse(Java 构建路径)
{
ava构建路径用于在编译Java项目时找到依赖的类，包括以下几项：
    源码包
    项目相关的 jar 包及类文件
    项目引用的的类库
通过使用 Java 项目属性对话框中的 Java Build Path(Java 构建路径)选项来查看和修改 Java 构建路径。


Java 项目属性对话框可以通过在 Package Explorer 视图中鼠标右击指定的 Java 项目并选择 Properties(属性) 菜单项来调用。
然后 在左边窗口选择 Java Build Path(Java 构建路径)。

在 Java 构建路径窗口中我们可以已经引用到的 jar 包。

引用 jar 包可以在 Libraries 选项卡中完成，在 Libraries 选项卡中我们可以通过点击 Add JARs 来添加 Eclipse 工作空间中
存在的jar包或 点击 External JARs 来引入其他文件中的 jar 包。

}

Eclipse(Eclipse 运行配置)
{
在运行配置(Run Configuration)对话框中可以创建多个运行配置。每个配置可以在应用中启用。
运行配置(Run Configuration)对话框可以通过 Run 菜单中选择 Run Configurations 来调用。
如果要给 Java 应用创建运行配置需要在左侧列表中选择 "Java Application" 并点击 New 按钮。

对话框中描述的项有：

    运行配置名称
    项目名
    主类名
Arguments(参数)项有：
    Program arguments(程序参数) 可以 0 个或多个
    VM arguments(Virtual Machine arguments:虚拟机参数) 可以 0 个或多个

Commons 选项卡中提供了通用配置，如标准输入输出的选项，可以到控制台或指定文件。
}

Eclipse(生成jar包)
{
Jar 文件向导可用于将项目导出为可运行的 jar 包。

打开向导的步骤为:

    在 Package Explorer 中选择你要导出的项目内容。如果你要导出项目中所有的类和资源，只需选择整个项目即可。
    点击 File 菜单并选择 Export。
    在输入框中输入"JAR" 。
    
在 JAR File Specification（JAR 文件描述） 页面可进行以下操作：

输入 JAR 文件名及文件夹
默认只导出 class 文件。你也可以通过勾选 "Export Java source files and resources" 选项来导出源码的内容。

点击 Next 按钮修改 JAR 包选项
点击 Next 按钮修改 JAR Manifest 描述信息
点击 Finish 按钮完成操作


}

Eclipse(安装插件)
{
查找和安装插件

Eclipse作为一个集成的IDE开发工具，为我们的软件开发提供了便利，eclipse除了自带的强大功能外，还支持功能丰富的插件。
我们可以通过Eclipse官方市场 (http://marketplace.eclipse.org/)找到并下载我们需要的插件。
例如我们可以查找支持 Python IDE 的插件，如下图所示：

在 Eclipse IDE 中我们也可以通过点击 Help 菜单中的 Eclipse Marketplace（Eclipse 超市）选项来查找插件：

}

Eclipse(代码提示)
{
Eclipse 快捷键列表可通过快捷键 Ctrl + Shift + L 打开 。
如果我们要使用 System.out.println()，我们只需要输入 syso 然后按下 Alt+/ 即可：
}

Eclipse(浏览器)
{
Eclipse 系统内部自带了浏览器，该浏览器可以通过点击 Window 菜单并选择 Show View > Other，在弹出来的对话框的搜索栏中输入 "browser"。
}
