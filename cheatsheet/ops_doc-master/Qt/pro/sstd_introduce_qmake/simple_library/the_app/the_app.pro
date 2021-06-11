TEMPLATE = app

QT += gui
QT += core

CONFIG(debug,debug|release){
    TARGET = the_app_debug
}else{
    TARGET = the_app
}

DESTDIR =  $$PWD/../bin

win32-msvc*{
    QMAKE_CXXFLAGS += /std:c++latest
}else{
    CONFIG += c++17
}

!win32 {
    QMAKE_LFLAGS += -Wl,-rpath .
}

equals(TEMPLATE, "vcapp") {
    CONFIG += console
}

include($$PWD/../the_lib/import_the_lib.pri)

SOURCES += $$PWD/main.cpp
