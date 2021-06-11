# this qmake project file generates the unit test application

TEMPLATE = app
TARGET = unit-test      # defaults to basename of project file, but need different name
DESTDIR = ..            # want to have it in the build dir, not in my subdir there

QT += testlib
QT -= gui

CONFIG += console
CONFIG -= app_bundle    # for Mac users
CONFIG += testcase      # adds make target for 'make check'

HEADERS += \
    AutoTest.h

SOURCES += \
    testApp.cpp \
    testmain.cpp \
    testVersion.cpp \

DEPENDENCY_LIBRARIES += \
    app-lib \

include(../qmake/common.pri)
include(../qmake/includes.pri)
