// A simple version providing class.
// Copyright: GNU General Public License (GPL) Version 3

#if !defined(APPVERSION_H)
#define APPVERSION_H

struct AppVersion
{
    static const char * build();    // e.g. Jenkins / Hudson build number
    static const char * revision(); // SCM revision
};

#endif
