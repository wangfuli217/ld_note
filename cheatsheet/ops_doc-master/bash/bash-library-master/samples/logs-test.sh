#!/usr/bin/env bash
# config files

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

#LOGFILE="bashlibtest.log"

NAME="Bash-Lib script test for log messages"
VERSION="0.1.0"
DESCRIPTION="A script to test library log infos management ...";

SYNOPSIS="${COMMON_SYNOPSIS_ACTION}"
SYNOPSIS_ERROR="${COMMON_SYNOPSIS_ACTION}\n\
\tread\n\
\twrite\n\
\tthrow\n\
\tdelete"
OPTIONS="\n\
\t<underline>Available actions:</underline>\n\
\t<bold>read</bold>\t\tread the current log file\n\
\t<bold>write</bold>\t\twrite 10 tests log messages in log file\n\
\t<bold>throw</bold>\t\tthrows an error to test log error message\n\
\t<bold>delete</bold>\t\tdelete log file\n\n\
\t<underline>Common options</underline> (to use first):\n\
\t${COMMON_OPTIONS_FULLINFO_MANPAGE}";
OPTIONS_USAGE="\n\
\tread\t\tread the current log file\n\
\twrite\t\twrite 10 tests log messages in log file\n\
\tthrow\t\tthrows an error to test log error message\n\
\tdelete\t\tdelete log file\n\
\t${COMMON_OPTIONS_USAGE}";

rearrange_script_options "$@"
[ "${#SCRIPT_OPTS[@]}" -gt 0 ] && set -- "${SCRIPT_OPTS[@]}";
[ "${#SCRIPT_ARGS[@]}" -gt 0 ] && set -- "${SCRIPT_ARGS[@]}";
[ "${#SCRIPT_OPTS[@]}" -gt 0 -a "${#SCRIPT_ARGS[@]}" -gt 0 ] && set -- "${SCRIPT_OPTS[@]}" -- "${SCRIPT_ARGS[@]}";
parse_common_options
quietecho "_ go"

OPTIND=1
ACTION="${SCRIPT_ARGS[0]}"
if [ ! -z "$ACTION" ]
then
    case "$ACTION" in
        write)
            if [ ! -n "$LOGFILEPATH" ]; then get_log_filepath; fi
            verecho "Writing 10 test messages in log file '$LOGFILEPATH':"
            for i in {1..10}; do
                log "my test message (item $i)"
                log "my DEBUG test message (item $i)" "debug"
                log "my WARNING test message (item $i)" "warning"
            done
            verecho "_ ok"
            echo
            verecho "New log file content is:"
            read_log
            ;;
        read)
            if [ ! -n "$LOGFILEPATH" ]; then get_log_filepath; fi
            verecho "Reading log file '$LOGFILEPATH':"
            read_log
            ;;
        throw)
            if [ ! -n "$LOGFILEPATH" ]; then get_log_filepath; fi
            error "test throwing error"
            ;;
        delete)
            if [ ! -n "$LOGFILEPATH" ]; then get_log_filepath; fi
            verecho "Deleting log file '$LOGFILEPATH':"
            iexec "rm -f $LOGFILEPATH"
            ;;
    esac
else
    simple_error 'please choose an action to do'
fi

quietecho "_ ok"
if [ "$QUIET" != 'true' ]; then libdebug "$*"; fi
exit 0

# Endfile
# vim: autoindent tabstop=4 shiftwidth=4 expandtab softtabstop=4 filetype=sh
