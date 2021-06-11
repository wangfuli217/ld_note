#include "ui_hellodialog.h"
int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    QDialog w;
    Ui::HelloDialog ui;
    ui.setupUi(&w);
    w.show();
    return a.exec();
}

/*
第1行代码是头文件包含。因为在ui_hellodialog.h中已经包含了其他类的定义，所以这里只需要包含这个文件就可以了。
对于头文件的包含，使用“<>”时，系统会到默认目录（编译器及环境变量、工程文件所定义的头文件寻找目录，包括Qt
安装的include目录，即“C:\Qt\Qt5.6.1\5.6\mingw49_32\include”）查找要包含的文件，这是标准方式；用双引号时，
系统先到用户当前目录（即项目目录）中查找要包含的文件，找不到再按标准方式查找。因为ui_hellodialog.h文件在
我们自己的项目目录中，所以使用了双引号包含。

第6行代码使用命名空间Ui中的HelloDialog类定义了一个ui对象。

在第7行中使用了setupUi()函数，并将对话框类对象作为参数，这样就可以将设计好的界面应用到对象w所表示的对话框上了。
*/

