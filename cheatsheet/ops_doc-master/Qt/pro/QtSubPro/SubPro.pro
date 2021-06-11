#-------------------------------------------------
# TEMPLATE：项目的生成模式，可指定app、lib、subdirs等
# CONFIG：工程配置以及编译特性，此处可参考文档，特别注意文档的Qt版本。常用的是c++11、ordered
# SUBDIRS：子工程
#-------------------------------------------------
TEMPLATE = subdirs
CONFIG  += ordered
SUBDIRS += libwidget src

libwidget.file = $$PWD/SubProClass/SubProClass.pro
src.file = $$PWD/SubProMain/SubProMain.pro

