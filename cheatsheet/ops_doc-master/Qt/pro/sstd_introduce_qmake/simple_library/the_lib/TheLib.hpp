#pragma once

#include <QtCore/qglobal.h>

#if defined (D_THE_LIB_WHEN_BUILD)
#define THE_LIB_IMPORT Q_DECL_EXPORT
#else
#define THE_LIB_IMPORT Q_DECL_IMPORT
#endif

namespace sstd {

    class THE_LIB_IMPORT TheLib{
    public:
        TheLib();
        void printHellowWorld();
    };

}/*namespace sstd*/
