#!/usr/bin/env bash
# manpage

######## Inclusion of the lib
LIBFILE="$(dirname "$0")/../bin/piwi-bash-library"
if [ -f "$LIBFILE" ]; then source "$LIBFILE"; else
    PADDER=$(printf '%0.1s' "#"{1..1000})
    printf "\n### %*.*s\n    %s\n    %s\n%*.*s\n\n" 0 $(($(tput cols)-4)) "ERROR! ${PADDER}" \
        "Unable to find required library file '${LIBFILE}'!" \
        "Sent in '${0}' line '${LINENO}' by '$(whoami)' - pwd is '$(pwd)'" \
        0 "$(tput cols)" "$PADDER";
    exit 1
fi
######## !Inclusion of the lib

NAME="Bash-Lib script manpage test"
VERSION="0.1.0"
DESCRIPTION="A script to test library automatic manpages"
SCRIPT_VCS='git'

LINE_ENDING="\n\t\t"
TMP_MANPAGE_VARS=$(word_wrap "${MANPAGE_VARS[@]}")
DESCRIPTION_MANPAGE="A script to test library automatic manpages ...\n\
\tTo test it, run:\n\
\t\t~\$ path/to/manpage-test.sh\n\
\tResult is the default script manpage using in-script variables\n\
\t\t${TMP_MANPAGE_VARS}\n\
\tThen run:\n\
\t\t~\$ path/to/manpage-test.sh --testusage\n\
\tResult is a simple custom manpage using in-script variable USAGE.\n\
\tThen run:\n\
\t\t~\$ path/to/manpage-test.sh --library\n\
\tResult is the default library manpage.\n\n\
\tYou can use option '-v' to add the DEPENDENCIES section of the default manpage.\n\
\tYou can use special program name long option like '--less' or '--more'.";
SYNOPSIS="${COMMON_SYNOPSIS}"
SYNOPSIS_ERROR="${COMMON_SYNOPSIS}\n\
\t--testusage\n\
\t--default\n\
\t--library";

# for custom options, write an info string about usage
# you can use the common library options string with $COMMON_OPTIONS_INFO
OPTIONS_MANPAGE="<bold>--testusage</bold>\tget a sample USAGE manpage\n\
\t<bold>--default</bold>\tthe default script manpage (this is the default action)\n\
\t<bold>--library</bold>\tthe library manpage\n\
\t${COMMON_OPTIONS_MANPAGE}";
OPTIONS_USAGE="\n\
\t--testusage\n\
\t--default\n\
\t--library${COMMON_OPTIONS_USAGE}";

parse_common_options "$@"
quietecho "_ go"

if [ "$VERBOSE" = 'false' ]; then
    MANPAGE_NODEPEDENCY=true
fi

actiondone=false
OPTIND=1
while getopts "${COMMON_OPTIONS_ALLOWED}" OPTION; do
    OPTARG="${OPTARG#=}"
    case "$OPTION" in
        -) case "$OPTARG" in
            library)
                library_help
                actiondone=true
                ;;
            libraryusage)
                library_usage
                actiondone=true
                ;;
            testusage)
                USAGE="\n\
This is a simple test of in-script full 'USAGE' custom string (so automatic manpage construction is avoid).\n\n\
<bold>USAGE</bold>\n\
\t~\$ ${0} -option(s) --longoption(s)";
                script_help
                actiondone=true
                ;;
            esac ;;
        ?) ;;
    esac
done

if [ "$actiondone" != 'true' ]; then
    script_help
fi

quietecho "_ ok"
if [ "$QUIET" != 'true' ]; then libdebug "$*"; fi
exit 0

# Endfile
# vim: autoindent tabstop=4 shiftwidth=4 expandtab softtabstop=4 filetype=sh
