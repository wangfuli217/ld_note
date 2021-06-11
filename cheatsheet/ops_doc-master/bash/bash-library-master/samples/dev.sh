#!/usr/bin/env bash
#
# dev - use this script as a model for yours
# For a full documemntation, see <http://github.com/piwi/bash-library/wiki/>
#

######## Inclusion of the lib #####################################################################
##@doc see <http://github.com/piwi/bash-library/wiki/Installation-Usage.md#usage>

# you MUST (re-)define here the path of the library
LIBFILE="$(dirname "$0")/../bin/piwi-bash-library"

if [ -f "$LIBFILE" ]; then source "$LIBFILE"; else
    PADDER=$(printf '%0.1s' "#"{1..1000})
    printf "\n### %*.*s\n    %s\n    %s\n%*.*s\n\n" 0 $(($(tput cols)-4)) "ERROR! ${PADDER}" \
        "Unable to find required library file '${LIBFILE}'!" \
        "Sent in '${0}' line '${LINENO}' by '$(whoami)' - pwd is '$(pwd)'" \
        0 "$(tput cols)" "$PADDER";
    exit 1
fi

######## Script information #######################################################################
##@doc see <http://github.com/piwi/bash-library/wiki/Scripts-informational-strings.md>
NAME="Bash-Lib-dev"
VERSION="x.y.z-dev"
DATE="1970-01-01"
DESCRIPTION="A dev file for tests"
LICENSE="GPL-v3 license"
HOMEPAGE="http://github.com/piwi/bash-library/blob/master/bin/dev.sh"
DESCRIPTION_MANPAGE="A dev file for tests ; you can use this script as a model to build your own ..."
DESCRIPTION_USAGE="A simple development file for tests"
OPTIONS_MANPAGE="${COMMON_OPTIONS_FULLINFO_MANPAGE}"
OPTIONS_USAGE="${COMMON_OPTIONS_USAGE}"
SYNOPSIS="${COMMON_SYNOPSIS}"
SYNOPSIS_ERROR="${COMMON_SYNOPSIS}"
SCRIPT_VCS='git'

######## Custom overrides #########################################################################
##@doc see <http://github.com/piwi/bash-library/wiki/Installation-Usage.md#usage>



######## Re-arrangement of command lines arguments ################################################
##@doc see <http://github.com/piwi/bash-library/wiki/Scripts-Usage.md>
rearrange_script_options_new "$0" "$@"
#rearrange_script_options "$@"
[ -n "$SCRIPT_PARAMS" ] && eval set -- "$SCRIPT_PARAMS"
parse_common_options "$@"
#parse_common_options_strict "$@"

######## Your script comes here ... ###############################################################
##@doc see <http://github.com/piwi/bash-library/wiki/Global-documentation.md>

#simple_error "this is the classic usage error"











######## Debug & exit #############################################################################

# a debug info in 'debug' mode
if [ "$DEBUG" = 'true' ]; then libdebug "$*"; fi

# exit with no error
exit 0

# Endfile
# vim: autoindent tabstop=4 shiftwidth=4 expandtab softtabstop=4 filetype=sh
