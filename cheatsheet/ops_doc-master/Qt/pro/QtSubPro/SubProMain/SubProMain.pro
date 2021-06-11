QT += core
QT += gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = SubProMain
CONFIG += console
CONFIG -= app_bundle
include(../SubProClass/SubProClass.pri) #其中包含了SubDir.pri文件
TEMPLATE = app
DESTDIR = $$PROJECT_BINDIR
unix:QMAKE_RPATHDIR+=$$PROJECT_LIBDIR

SOURCES += main.cpp

