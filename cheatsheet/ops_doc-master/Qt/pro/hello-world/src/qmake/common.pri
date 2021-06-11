# qmake project include file with common settings

CONFIG += silent    # comment out to see full compiler call
win32-g++ {
    # due to a nasty '\' problem, linking will fail on win32 with MinGW if
    # 'silent' is enabled, so just be sure to have it disabled ...
    CONFIG -= silent
}
#CONFIG += debug    # may be specified on command line by QtCreator, see project settings
#CONFIG += c++11    # in case you need the C+11 standard

*-g++ {
    # note: -Wall and -Wextra (-W) are enabled by default
    QMAKE_CXXFLAGS += \
        -Werror \
        -Wdeprecated \

}

INCLUDEPATH += ..   # to allow #include "app-lib/someHeader.h"
