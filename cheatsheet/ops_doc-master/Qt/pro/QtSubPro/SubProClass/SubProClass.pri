#-------------------------------------------------
# 此目录同时被SubProClass.pro和SubProMain.pro使用
# SubProClass.pro使用将了其中的LIBWIDGET_NAME和SOURCES、HEADERS等文件信息
# SubProMain.pro使用了LIBS += （其中-L指定文件夹，-l指定单个文件）
#-------------------------------------------------

INCLUDEPATH += $$PWD
DEPENDPATH += $$PWD
TEMPLATE += fakelib
LIBWIDGET_NAME = $$qtLibraryTarget(mywidget)
TEMPLATE -= fakelib
include(../SubDir.pri)
!widget-buildlib{
    LIBS += -L$$PROJECT_LIBDIR -l$$LIBWIDGET_NAME
}else{
    SOURCES +=  subproc.cpp
    HEADERS += subproc.h
    FORMS   += subproc.ui
}
