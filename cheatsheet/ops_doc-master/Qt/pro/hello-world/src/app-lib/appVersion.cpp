// A simple version providing class.
// Copyright: GNU General Public License (GPL) Version 3

#include "appVersion.h"
#include "buildtag.h"

const char * AppVersion::build()
{
    return BUILDTAG;
}

const char * AppVersion::revision()
{
    return GITVERSION;
}
