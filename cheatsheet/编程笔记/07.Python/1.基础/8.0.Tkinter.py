_tkinter 对底层DLL或者动态库的封装
Tkinter模块内重要的两个模块：Tkinter和Tkconstants # Tkinter是一个和Tk接口的Python模块，Tkinter库提供了对 Tk API的接口，
import Tkinter 更好是 from Tkinter import *
# Tcl(工具命令语言)是个宏语言，用于简化shell下复杂程序的开发，Tk工具包是和Tcl一起开发的， 目的是为了简化用户接口的设计过程。

https://wiki.python.org/moin/GuiProgramming


Button          按钮控件；       在程序中显示按钮。
Canvas          画布控件；       显示图形元素如线条或文本
Checkbutton     多选框控件；     用于在程序中提供多项选择框
Entry           输入控件；       用于显示简单的文本内容
Frame           框架控件；       在屏幕上显示一个矩形区域，多用来作为容器
Label           标签控件；       可以显示文本和位图
Listbox         列表框控件；     在Listbox窗口小部件是用来显示一个字符串列表给用户
Menubutton      菜单按钮控件，   由于显示菜单项。
Menu            菜单控件；       显示菜单栏,下拉菜单和弹出菜单
Message         消息控件；       用来显示多行文本，与label比较类似
Radiobutton     单选按钮控件；   显示一个单选的按钮状态
Scale           范围控件；       显示一个数值刻度，为输出限定范围的数字区间
Scrollbar       滚动条控件，     当内容超过可视化区域时使用，如列表框。.
Text            文本控件；       用于显示多行文本
Toplevel        容器控件；       用来提供一个单独的对话框，和Frame比较类似
Spinbox         输入控件；      与Entry类似，但是可以指定输入范围值
PanedWindow     PanedWindow     是一个窗口布局管理的插件，可以包含一个或者多个子控件。
LabelFrame      labelframe      是一个简单的容器控件。常用与复杂的窗口布局。
tkMessageBox    用于显示你应用程序的消息框。

标准属性

标准属性也就是所有控件的共同属性，如大小，字体和颜色等等。
属性          描述
Dimension   控件大小；
Color       控件颜色；
Font        控件字体；
Anchor      锚点；
Relief      控件样式；
Bitmap      位图；
Cursor      光标；