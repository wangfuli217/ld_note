TEMPLATE = app

DESTDIR = $$PWD/../bin
INCLUDEPATH += $$PWD/../include

CONFIG(debug,debug|release){
    TARGET = after_link_debug
}else{
    TARGET = after_link
}

win32-msvc*{
    QMAKE_CXXFLAGS += /std:c++latest
}else{
    CONFIG += c++17
    LIBS += -lstdc++fs
}

SOURCES += $$PWD/main.cpp
