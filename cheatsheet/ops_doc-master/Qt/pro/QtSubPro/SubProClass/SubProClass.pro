#-------------------------------------------------
# QT：加入Qt模块。其中core模块是核心，包括了信号与槽机制等一系列Qt特性
# TARGET：目标文件名
# TEMPLATE：项目的生成模式，可指定app、lib、subdirs等
# CONFIG：工程配置以及编译特性，此处可参考文档，特别注意文档的Qt版本。常用的是c++11、ordered、staticlib
# DEFINES：C编译器预处理宏
#-------------------------------------------------

QT       += core gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets


TEMPLATE = lib
CONFIG += staticlib
CONFIG += widget-buildlib   #自定义名称，用于SubProClass.pri的区域选择（像if语句）
include(SubProClass.pri)
TARGET = $$LIBWIDGET_NAME
DESTDIR = $$PROJECT_LIBDIR
win32{
    DLLDESTDIR = $$PROJECT_BINDIR
    QMAKE_DISTCLEAN += $$PROJECT_BINDIR/$${LIBWIDGET_NAME}.dll
}

DEFINES += LIBWIDGET_BUILD



