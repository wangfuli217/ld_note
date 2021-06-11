TEMPLATE = app

DESTDIR = $$PWD/../bin
INCLUDEPATH += $$PWD/../include

CONFIG(debug,debug|release){
    TARGET = before_link_debug
}else{
    TARGET = before_link
}

win32-msvc*{
    QMAKE_CXXFLAGS += /std:c++latest
}else{
    CONFIG += c++17
    LIBS += -lstdc++fs
}

SOURCES += $$PWD/main.cpp
