#!/usr/bin/env bash
# interface-test
#
# interface-test.sh -vi --project=PROJECT action
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

#### script settings ##########################

_REALPATH=$(realpath "$BASH_SOURCE")
declare -x _BASEDIR="$(dirname "$_REALPATH")/interface-test"
declare -x _BACKUP_DIR="${_BASEDIR}/backup/"
declare -x _PROJECT="project"
declare -x _SET="full"
declare -x _TARGET
declare -x _TARGETMEDIA

declare -x ACTION
declare -x ACTION_DESCRIPTION=""
declare -x SCRIPTMAN=false

NAME="Test of a script interface"
VERSION="0.1.0"
DESCRIPTION="A script to test a library usage for a central action script interface managing sub-scripts dependencies ..."
SYNOPSIS="${COMMON_SYNOPSIS_ACTION}"
OPTIONS="<bold>-z | --actions</bold>\t\tget the list of available actions\n\
\t<bold>-s | --set=NAME</bold>\t\tpool set for action (default is '${_SET}')\n\
\t<bold>-p | --project=NAME</bold>\tthe project name\n\
\t<bold>-t | --target=PATH</bold>\ttarget directory used for some actions\n\n\
\t<underline>Common options</underline> (to use first):\n\
\t${COMMON_OPTIONS_FULLINFO_MANPAGE}";
OPTIONS_USAGE="\n\
\t-z, --actions\t\tget the list of available actions\n\
\t-s, --set=NAME\t\tpool set for action (default is '${_SET}')\n\
\t-p, --project=NAME\tthe project name\n\
\t-t, --target=PATH\ttarget directory used for some actions${COMMON_OPTIONS_USAGE}";
SCRIPT_VCS='git'

#### internal lib ##########################

#### list_actions ()
# list available action scripts
list_actions () {
    local actions_str="\n<underline>Available actions:</underline>\n"
    export SCRIPTMAN=true
    for action in $_BASEDIR/*.sh; do
        myaction="${action##$_BASEDIR/}"
        actions_str="${actions_str}\n    <bold>${myaction%%.sh}</bold> \n"
        source "${_BASEDIR}/${myaction}"
        if [ -n "$ACTION_DESCRIPTION" ]; then
            actions_str="${actions_str}\t${ACTION_DESCRIPTION}\n"
        fi
    done
    actions_str="${actions_str}\n<${COLOR_COMMENT}>$(library_info)</${COLOR_COMMENT}>";
    parse_color_tags "${actions_str}\n"
}

#### root_required ()
# ensure current user is root
root_required () {
    THISUSER=$(whoami)
    if [ "$THISUSER" != "root" ]; then
        error "You need to run this as a 'sudo' user!"
    fi
}

#### project_required ()
# ensure the project name is defined
project_required () {
    if [ -z "$_PROJECT" ]; then
        prompt 'Name of the project to work on' '' ''
        export _PROJECT=$USERRESPONSE
    fi
}

#### targetdir_required ()
# ensure the project root directory is defined
targetdir_required () {
    if [ -z "$_TARGET" ]; then
        prompt 'Target directory of the project to work on' "$(pwd)" ''
        export _TARGET=$USERRESPONSE
    fi
    if [ ! -d "$_TARGET" ]; then error "Unknown root directory '${_TARGET}' !"; fi
    export _TARGETMEDIA="${_TARGET}/media"
}

#### first setup ##########################

if [ ! -d "${_BASEDIR}" ]; then
    error "Unknown dependencies directory '${_BASEDIR}' (this is where you must put your dependencies dirs/files) !"
fi

if [ ! -d "${_BACKUP_DIR}" ]; then
    mkdir "${_BACKUP_DIR}" && chmod 777 "${_BACKUP_DIR}"
    if [ ! -d "${_BACKUP_DIR}" ]; then
        error "Backup directory '${_BACKUP_DIR}' can't be created (try to run this script as 'sudo') !"
    fi
fi

#### options treatment ##########################

OPTIONS_ALLOWED="zs:p:t:${COMMON_OPTIONS_ALLOWED}"

rearrange_script_options "$@"
[ "${#SCRIPT_OPTS[@]}" -gt 0 ] && set -- "${SCRIPT_OPTS[@]}";
[ "${#SCRIPT_ARGS[@]}" -gt 0 ] && set -- "${SCRIPT_ARGS[@]}";
[ "${#SCRIPT_OPTS[@]}" -gt 0 -a "${#SCRIPT_ARGS[@]}" -gt 0 ] && set -- "${SCRIPT_OPTS[@]}" -- "${SCRIPT_ARGS[@]}";
parse_common_options

OPTIND=1
ACTION="${SCRIPT_ARGS[0]}"
while getopts "${OPTIONS_ALLOWED}" OPTION; do
    OPTARG="${OPTARG#=}"
    case "$OPTION" in
        d|f|h|i|l|q|v|V|x) rien=rien;;
        z) script_title; list_actions; exit 0;;
        s) _SET="$OPTARG";;
        p) _PROJECT="$OPTARG";;
        t) _TARGET="$OPTARG";;
        -) LONGOPTARG=$(get_long_option_arg "$OPTARG")
            case "$OPTARG" in
                actions) script_title; list_actions; exit 0;;
                set*) _SET="$LONGOPTARG";;
                project*) _PROJECT="$LONGOPTARG";;
                target*) _TARGET="$LONGOPTARG";;
                \?) error "Unknown long option '$OPTARG'";;
            esac ;;
        \?) error "Unknown option '$OPTION'";;
    esac
done

#### process ##########################
if [ ! -z "$ACTION" ]
then
    ACTIONFILE="${_BASEDIR}/${ACTION}.sh"
    if [ -f "$ACTIONFILE" ]
    then
        quietecho "_ go"
        export _BASEDIR _BACKUP_DIR _PROJECT _SET _TARGET _TARGETMEDIA
        source "$ACTIONFILE"
        quietecho "_ ok"
        libdebug "$*"
    else
        error "Unknown action '${ACTION}' (use option '-z' to list available action scripts) !"
    fi
else
    simple_error 'please define an action to launch'
fi

if [ "$QUIET" != 'true' ]; then libdebug "$*"; fi
exit 0
# Endfile
# vim: autoindent tabstop=4 shiftwidth=4 expandtab softtabstop=4 filetype=sh
