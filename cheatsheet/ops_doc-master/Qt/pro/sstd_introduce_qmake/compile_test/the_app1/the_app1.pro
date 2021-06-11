
TEMPLATE = app

SOURCES += $$PWD/main.cpp

CONFIG += c++17

config_testConstexprValue{
    DEFINES *= HAS_CONSTEXPR
}
