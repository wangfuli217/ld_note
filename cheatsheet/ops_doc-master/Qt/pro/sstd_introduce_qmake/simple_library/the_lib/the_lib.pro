TEMPLATE = lib

QT += gui
QT += core

CONFIG(debug,debug|release){
    TARGET = the_lib_debug
}else{
    TARGET = the_lib
}

DESTDIR =  $$PWD/../bin

SOURCES += $$PWD/TheLib.cpp
HEADERS += $$PWD/TheLib.hpp

win32-msvc*{
    QMAKE_CXXFLAGS += /std:c++latest
}else{
    CONFIG += c++17
}

!win32 {
    QMAKE_LFLAGS += -Wl,-rpath .
}

DEFINES *= D_THE_LIB_WHEN_BUILD
