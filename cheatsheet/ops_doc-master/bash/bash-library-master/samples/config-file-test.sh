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

NAME="Bash-Lib script test for configuration files"
VERSION="0.1.0"
DESCRIPTION="A script to test library configuration files management ...";
SCRIPT_VCS='git'

SYNOPSIS="${COMMON_SYNOPSIS_ACTION}"
SYNOPSIS_MANPAGE="${COMMON_SYNOPSIS_ACTION_MANPAGE}"
SYNOPSIS_ERROR="${COMMON_SYNOPSIS_ACTION}\n\
\tread\n\
\twrite\n\
\tadd\n\
\treplace\n\
\tget\n\
\tdelete";
OPTIONS_MANPAGE="<underline>Available actions:</underline>\n\
\t<bold>read</bold>\t\tread the configuration file (default action)\n\
\t<bold>write</bold>\t\twrite the configuration file\n\
\t<bold>add</bold>\t\tadd a configuration entry\n\
\t<bold>replace</bold>\t\treplace a configuration entry\n\
\t<bold>get</bold>\t\tget values from the test config table\n\
\t<bold>delete</bold>\t\tdelete any existing config file\n\n\
\t<underline>Common options</underline> (to use first):\n\
\t${COMMON_OPTIONS_FULLINFO_MANPAGE}";
OPTIONS_USAGE="\n\
Available actions:\n\
\tread\t\tread the configuration file (default action)\n\
\twrite\t\twrite the configuration file\n\
\tadd\t\tadd a configuration entry\n\
\treplace\t\treplace a configuration entry\n\
\tget\t\tget values from the test config table\n\
\tdelete\t\tdelete any existing config file\n\n\
Common options (to use first):${COMMON_OPTIONS_USAGE}";

rearrange_script_options "$@"
[ "${#SCRIPT_OPTS[@]}" -gt 0 ] && set -- "${SCRIPT_OPTS[@]}";
[ "${#SCRIPT_ARGS[@]}" -gt 0 ] && set -- "${SCRIPT_ARGS[@]}";
[ "${#SCRIPT_OPTS[@]}" -gt 0 -a "${#SCRIPT_ARGS[@]}" -gt 0 ] && set -- "${SCRIPT_OPTS[@]}" -- "${SCRIPT_ARGS[@]}";
parse_common_options
quietecho "_ go"

filename=testconfig
keys=(one two three)
values=('value one' 'value two' 'value three')
filepath=$(get_user_configfile "$filename")
actiondone=false

ACTION="${SCRIPT_ARGS[0]}"
if [ -z "$ACTION" ]; then ACTION="read"; fi
if [ ! -z "$ACTION" ]
then
    case "$ACTION" in
        delete)
            verecho "Deleting config file '$filepath':"
            iexec "rm -f $filepath"
            verecho "_ ok"
            ;;
        read)
            verecho "Reading config file '$filepath':"
            iexec "read_configfile $filepath"
            verecho "_ ok"
            echo
            verecho "Testing value of config var 'one':"
            echo "$one"
            echo
            actiondone=true
            verecho "New config file content is:"
            cat "$filepath"
            ;;
        write)
            verecho "Writing config file '$filepath':"
            iexec "write_configfile $filepath keys[@] values[@]"
            verecho "_ ok"
            echo
            actiondone=true
            verecho "New config file content is:"
            cat "$filepath"
            ;;
        add)
            verecho "Adding new value 'four=value four' in config file '$filepath':"
            iexec "set_configval $filepath \"four\" \"value four\""
            verecho "_ ok"
            echo
            actiondone=true
            verecho "New config file content is:"
            cat "$filepath"
            ;;
        replace)
            verecho "Replacing value 'four=new value four' in config file '$filepath':"
            iexec "set_configval $filepath \"four\" \"new value four\""
            verecho "_ ok"
            echo
            actiondone=true
            verecho "New config file content is:"
            cat "$filepath"
            ;;
        get)
            verecho "Getting config value 'three' and 'four' from config file '$filepath':"
            iexec "get_configval $filepath \"three\""
            iexec "get_configval $filepath \"four\""
            verecho "_ ok"
            echo
            actiondone=true
            verecho "Config file content is:"
            cat "$filepath"
            ;;
    esac
fi

quietecho "_ ok"
if [ "$QUIET" != 'true' ]; then libdebug "$*"; fi
exit 0

# Endfile
# vim: autoindent tabstop=4 shiftwidth=4 expandtab softtabstop=4 filetype=sh
