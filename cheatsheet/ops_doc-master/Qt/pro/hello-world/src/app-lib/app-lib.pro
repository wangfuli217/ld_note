# qmake project file to build the static library app-lib

TEMPLATE = lib
# TARGET = app-lib      # defaults to basename of project file

QT -= gui

CONFIG += staticlib

HEADERS += appVersion.h
SOURCES += appVersion.cpp

include(../qmake/common.pri)
include(../qmake/version.pri)
