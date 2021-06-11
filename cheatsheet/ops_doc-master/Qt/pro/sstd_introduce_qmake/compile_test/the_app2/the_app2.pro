
TEMPLATE = app

SOURCES += $$PWD/main.cpp

CONFIG += c++17

config_testFromCharsLongDouble{
    DEFINES *= HAS_FROM_CHARS_LONGDOUBLE
}
