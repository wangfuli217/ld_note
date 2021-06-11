#!/usr/bin/env bash
# getopts
#
# getopts-test.sh -vi -t "two words" -a -q --test="three wor ds" -- -x
#

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

NAME="Bash-Lib-Test-Getopts"
VERSION="0.1.0"
DATE="2014-12-01"
DESCRIPTION="A dev test script for options handling"
OPTIONS_USAGE="\n\
This file is a development test for options, arguments and piped content handling.\n\
To test it, use one of the followings:\n\n\
- full test with a large set of options with arguments and some 'actions' mixed:\n\
\t$0 myaction1 -v --interactive -t 'two -- words' -u=qsdf -a --force --test1 'three wor ds' --test2='three wor ds' --log=myfile.txt myaction2 -- myaction3 -x\n\n\
- same test with a piped content from a previous command:\n\
\techo 'this is my piped contet' | $0 myaction1 -v --interactive -t 'two -- words' -u=qsdf -a --force --test1 'three wor ds' --test2='three wor ds' --log=myfile.txt myaction2 -- myaction3 -x\n\n\
- same test with options errors:\n\
\t$0 myaction1 -v --interactive -z -t -u=qsdf -a --force --test1 --test2='three wor ds' --test3='mlkj' --log=myfile.txt myaction2 -- myaction3 -x\n\n\
";
# definitions of short and long options
OPTIONS_ALLOWED="t:u::a${COMMON_OPTIONS_ALLOWED}"
LONG_OPTIONS_ALLOWED="test1:,test2::,${COMMON_LONG_OPTIONS_ALLOWED}"

# methods override
simple_usage () {
    _echo "$(simple_synopsis)"
    exit 0
}
script_long_usage () {
    local TMP_USAGE="$(parse_color_tags  "<bold>$(script_short_title)</bold>")"
    if [ -n "$DESCRIPTION_USAGE" ]; then
        TMP_USAGE+="\n${DESCRIPTION_USAGE}";
    elif [ -n "$DESCRIPTION" ]; then
        TMP_USAGE+="\n${DESCRIPTION}";
    fi
    local SYNOPSIS_STR="$(get_synopsis_string)"
    local OPTIONS_STR=''
    if [ $# -gt 0 ]; then
        if [ "$1" = 'lib' ]; then
            OPTIONS_STR="$COMMON_OPTIONS_USAGE"
        else
            OPTIONS_STR="$1"
        fi
    elif [ -n "$OPTIONS_USAGE" ]; then
        OPTIONS_STR="$OPTIONS_USAGE"
    elif [ -n "$OPTIONS" ]; then
        OPTIONS_STR="$OPTIONS"
    fi
    printf "$(parse_color_tags "\n%s\n\n<bold>usage:</bold> %s\n%s\n\n<${COLOR_COMMENT}>%s</${COLOR_COMMENT}>")" \
        "$(_echo "$TMP_USAGE")" "$(_echo "$SYNOPSIS_STR")" "$(_echo "$OPTIONS_STR")" \
        "$(library_info)";
    echo
    return 0
}

# let's go
parse_common_options "$@"

quietecho "_ go"
echo

# command line "as is"
echo "> original script's arguments are: $*"
echo

# check
echo "> script settings:"
echo " - short options are:         ${OPTIONS_ALLOWED}"
shortopts_table=( $(get_short_options_array) )
echo " - short options table is:    ${shortopts_table[*]}"
echo " - long options are:          ${LONG_OPTIONS_ALLOWED}"
longopts_table=( $(get_long_options_array) )
echo " - long options table is:     ${longopts_table[*]}"
echo

# parse common options BEFORE re-arrangement for eventual errors
echo "> parsing common options ..."
parse_common_options_strict "$@"
echo

# rearrangement of options & arguments using 'getopt'
rearrange_script_options_new "$0" "$@"
#rearrange_script_options "$@"
echo "> re-arranging options & arguments:"
echo " - SCRIPT_PARAMS are: $SCRIPT_PARAMS"
echo " - SCRIPT_OPTS are:   ${SCRIPT_OPTS[*]}"
echo " - SCRIPT_ARGS are:   ${SCRIPT_ARGS[*]}"
[ -n "$SCRIPT_PARAMS" ] && eval set -- "$SCRIPT_PARAMS"
echo

# check of new script arguments
echo "> script's arguments are now: $*"
echo

# parse common options after re-arrangement
echo "> parsing common options ..."
parse_common_options_strict "$@"
echo

# loop over options
echo "> options loop:"
if [ $# -gt 0 ]
then
    OPTIND=1
    while getopts ":${OPTIONS_ALLOWED}" OPTION; do

        # OPTIND is the current option index

        # OPTNAME should be the one letter name of short option
        OPTNAME="$OPTION"

        # OPTARG should be the optional argument of the option
        OPTARG="$(get_option_arg "${OPTARG:-}")"

    #    echo "> for option index '${OPTIND}' option is '${OPTNAME}' with argument '${OPTARG}'"
        case "$OPTION" in

            # case of long options
            -)

                # full self-handling
#                # LONGOPTIND should be the same as OPTIND
#
#                # LONGOPTNAME should be the name of the long option
#                LONGOPTNAME="$(get_long_option "$OPTARG")"
#
#                # LONGOPTARG should be the optional argument of the option
#                LONGOPTARG="$(get_long_option_arg "$OPTARG")"
#
#                # special load of arg if it is required (no mandatory equal sign)
#                optiondef=$(get_long_option_declaration "$LONGOPTNAME")
##                if [ -z "$LONGOPTARG" ] && [ "${optiondef: -1}" = ':' ] && [ "${optiondef: -2}" != '::' ]; then
#                if [ -z "$LONGOPTARG" ] && [ "${optiondef: -1}" = ':' ]; then
#                    LONGOPTARG="${!OPTIND}"
#                    OPTIND=$((OPTIND + 1))
#                fi

                # all-in-one facility
                parse_long_option "$OPTARG" "${!OPTIND}"

                case "$LONGOPTNAME" in
                    *) echo " - [${OPTIND}] long option '${LONGOPTNAME}' with arg '${LONGOPTARG}'";;
                    \?) echo " - [${OPTIND}] unknown long option '${LONGOPTNAME}'";;
                esac
                ;;

            # case of short options
            *) echo " - [${OPTIND}] option '$OPTION' with arg '$OPTARG'";;
            \?) echo " - [${OPTIND}] unknown option '$OPTION'";;

        esac
    done
else
    echo " - none"
fi
echo

# loop over arguments
echo "> arguments loop:"
if [ "${#SCRIPT_ARGS[@]}" -gt 0 ]; then
    ARGIND=1
    while getargs MYARG; do
        echo " - [${ARGIND}] argument is '$MYARG'"
    done
else
    echo " - none"
fi
echo

# read any piped content via '/dev/stdin'
#read_from_pipe '/dev/stdin'
read_from_pipe
echo "> caught piped content:"
if [ -n "$SCRIPT_PIPED_INPUT" ]; then
    echo " - $SCRIPT_PIPED_INPUT"
else
    echo " - none"
fi
echo

quietecho "_ ok"
if [ "$QUIET" != 'true' ]; then libdebug "$*"; fi
exit 0

# Endfile
# vim: autoindent tabstop=4 shiftwidth=4 expandtab softtabstop=4 filetype=sh
