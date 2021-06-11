INCLUDEPATH += $$PWD

LIBS += -L$$PWD/../bin
CONFIG(debug,debug|release){
    LIBS += -lthe_lib_debug
}else{
    LIBS += -lthe_lib
}
