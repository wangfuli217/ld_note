# this qmake project file generates the application binary

TEMPLATE = app
TARGET = hello      # defaults to basename of project file, but need different name
DESTDIR = ..        # want to have it in the build dir, not in my subdir there

QT -= gui

CONFIG += console
CONFIG -= app_bundle    # for Mac users

SOURCES += hello.cpp

DEPENDENCY_LIBRARIES += \
    app-lib \

include(../qmake/common.pri)
include(../qmake/includes.pri)
