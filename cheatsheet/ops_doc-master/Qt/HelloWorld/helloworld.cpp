#include <QApplication>
#include <QDialog>
#include <QLabel>
int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    QDialog w;
    QLabel label(&w);
    label.setText(QObject::tr("Hello World! 你好Qt！"));
    w.show();
    return a.exec();
}

/*
前3行是头文件包含。在Qt中每一个类都有一个与其同名的头文件，因为后面用到了QApplication、QDialog和QLabel这3个类，所以这里要包含这些类的定义。
第4行就是在C++中最常见到的main()函数，它有两个参数，用来接收命令行参数。
在第6行新建了QApplication类对象，用于管理应用程序的资源，任何一个Qt GUI程序都要有一个QApplication对象。因为Qt程序可以接收命令行参数，所以它需要argc和argv两个参数。
第7行新建了一个QDialog对象，QDialog类用来实现一个对话框界面。
第8行新建了一个QLabel对象，并将QDialog对象作为参数，表明了对话框是它的父窗口，也就是说这个标签放在对话框窗口中。
第9行给标签设置要显示的字符。
第10行让对话框显示出来。在默认情况下，新建的可视部件对象都是不可见的，要使用show()函数让它们显示出来。
第11行让QApplication对象进入事件循环，这样当Qt应用程序在运行时便可以接收产生的事件，例如单击和键盘按下等事件。
*/