#!/usr/bin/env bash
#
# Piwi Bash Library - An open source day-to-day bash library
# Copyleft (ↄ) 2013-2015 Pierre Cassat <me@e-piwi.fr> & contributors
# Some rights reserved.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.
# 
# For sources & updates, see <http://github.com/piwi/bash-library>.
#
# For documentation, see <http://github.com/piwi/bash-library/wiki/>.
#
# To transmit bugs, see <http://github.com/piwi/bash-library/issues>.
#
# To read GPL-3.0 license conditions, see <http://www.gnu.org/licenses/gpl-3.0.html>.
#
##@!@##

## for dev usage
#set -u
#set -e

#### REFERENCES #####################################################################

##@ Bash Reference Manual: <http://www.gnu.org/software/bash/manual/bashref.html>
##@ Bash Guide for Beginners: <http://www.tldp.org/LDP/Bash-Beginners-Guide/html/Bash-Beginners-Guide.html>
##@ Advanced Bash-Scripting Guide: <http://www.tldp.org/LDP/abs/html/abs-guide.html>
##@ GNU coding standards: <http://www.gnu.org/prep/standards/standards.html>


#### ENVIRONMENT #############################################################################

##@ SCRIPT_VARS = ( NAME VERSION DATE DESCRIPTION LICENSE HOMEPAGE SYNOPSIS OPTIONS ) (read-only)
## List of variables defined by the caller script used to build all informational strings.
## These are all RECOMMENDED.
declare -rxa SCRIPT_VARS="(NAME VERSION DATE DESCRIPTION LICENSE HOMEPAGE SYNOPSIS OPTIONS)" 2>/dev/null;

##@ USAGE_VARS = ( NAME VERSION DATE DESCRIPTION_USAGE SYNOPSIS_USAGE OPTIONS_USAGE ) (read-only)
## List of variables defined by the caller script used to build the 'usage' string (common option `--usage`).
declare -rxa USAGE_VARS="(NAME VERSION DATE DESCRIPTION_USAGE SYNOPSIS_USAGE OPTIONS_USAGE)" 2>/dev/null;
##@ USAGE_SUFFIX = "_USAGE"
## Suffix used to build some of the `USAGE_VARS` variable names ; it is stripped to fallback over "classic" variable.
declare -rx USAGE_SUFFIX="_USAGE" 2>/dev/null;

##@ VERSION_VARS = ( NAME VERSION DATE DESCRIPTION COPYRIGHT LICENSE HOMEPAGE SOURCES ADDITIONAL_INFO ) (read-only)
## List of variables defined by the caller script used to build the 'version' string (common option `--version`).
##@see <http://www.gnu.org/prep/standards/standards.html#g_t_002d_002dversion>
declare -rxa VERSION_VARS="(NAME VERSION DATE DESCRIPTION COPYRIGHT LICENSE HOMEPAGE SOURCES ADDITIONAL_INFO)" 2>/dev/null;

##@ MANPAGE_VARS = ( NAME VERSION DATE DESCRIPTION_MANPAGE SYNOPSIS_MANPAGE OPTIONS_MANPAGE EXAMPLES_MANPAGE EXIT_STATUS_MANPAGE FILES_MANPAGE ENVIRONMENT_MANPAGE COPYRIGHT_MANPAGE HOMEPAGE_MANPAGE BUGS_MANPAGE AUTHOR_MANPAGE SEE_ALSO_MANPAGE ) (read-only)
## List of variables defined by the caller script used to build the 'manpage' string (common option `--manpage`).
##@see <http://en.wikipedia.org/wiki/Man_page>
declare -rxa MANPAGE_VARS="(NAME VERSION DATE DESCRIPTION_MANPAGE SYNOPSIS_MANPAGE OPTIONS_MANPAGE EXAMPLES_MANPAGE EXIT_STATUS_MANPAGE FILES_MANPAGE ENVIRONMENT_MANPAGE COPYRIGHT_MANPAGE HOMEPAGE_MANPAGE BUGS_MANPAGE AUTHOR_MANPAGE SEE_ALSO_MANPAGE)" 2>/dev/null;
##@ MANPAGE_SUFFIX = "_MANPAGE"
## Suffix used to build some of the `USAGE_VARS` variable names ; it is stripped to fallback over "classic" variable.
declare -rx MANPAGE_SUFFIX="_MANPAGE" 2>/dev/null;

##@ LIB_FLAGS = ( VERBOSE QUIET DEBUG INTERACTIVE FORCED ) (read-only)
## List of variables defined as global flags ; they are enabled/disabled by common options.
declare -rxa LIB_FLAGS="(VERBOSE QUIET DEBUG INTERACTIVE FORCED)" 2>/dev/null;

##@ INTERACTIVE = DEBUG = VERBOSE = QUIET = FORCED = DRYRUN = false
##@ WORKINGDIR = `pwd`
declare -x INTERACTIVE=false
declare -x QUIET=false
declare -x VERBOSE=false
declare -x FORCED=false
declare -x DEBUG=false
declare -x DRYRUN=false
declare -x WORKINGDIR="$(pwd)"
declare -x LOGFILE=''
declare -x LOGFILEPATH=''
declare -x TEMPDIR=''

##@ COLOR_VARS = ( COLOR_LIGHT COLOR_DARK COLOR_INFO COLOR_NOTICE COLOR_WARNING COLOR_ERROR COLOR_COMMENT ) (read-only)
## List of variables defined by the library as "common colors" names.
declare -rxa COLOR_VARS="(COLOR_LIGHT COLOR_DARK COLOR_INFO COLOR_NOTICE COLOR_WARNING COLOR_ERROR COLOR_COMMENT)" 2>/dev/null;

##@ USEROS = "$(uname)" (read-only)
## Current running operating system name.
declare -rx USEROS="$(uname)" 2>/dev/null;
##@ LINUX_OS = ( Linux FreeBSD OpenBSD SunOS ) (read-only)
## List of Linux-like OSs.
declare -rxa LINUX_OS="(Linux FreeBSD OpenBSD SunOS)" 2>/dev/null;
##@ USERSHELL = "$SHELL" (read-only)
## Path of the shell currently in use (value of the global `$SHELL` variable).
declare -rx USERSHELL="$SHELL" 2>/dev/null;
##@ SHELLVERSION = "$BASH_VERSION" (read-only)
## Version number of current shell in use (value of the global `$BASH_VERSION` variable).
declare -rx SHELLVERSION="$BASH_VERSION" 2>/dev/null;


#### SETTINGS #####################################################################

# lib error codes
##@ E_ERROR=90
##@ E_OPTS=81
##@ E_CMD=82
##@ E_PATH=83
## Error codes in Bash must return an exit code between 0 and 255.
## In the library, to be conform with C/C++ programs, we will try to use codes from 80 to 120
## (error codes in C/C++ begin at 64 but the recent evolutions of Bash reserved codes 64 to 78).
declare -x E_ERROR=90
declare -x E_OPTS=81
declare -x E_CMD=82
declare -x E_PATH=83

# colors settings depending on OS
case "$USEROS" in
    Linux|FreeBSD|OpenBSD|SunOS)
        declare -x COLOR_LIGHT='yellow'
        declare -x COLOR_DARK='lightgrey'
        declare -x COLOR_INFO='green'
        declare -x COLOR_NOTICE='blue'
        declare -x COLOR_WARNING='bgmagenta'
        declare -x COLOR_ERROR='bgred'
        declare -x COLOR_COMMENT='small'
        ;;
    *)
        declare -x COLOR_LIGHT='yellow'
        declare -x COLOR_DARK='lightgrey'
        declare -x COLOR_INFO='green'
        declare -x COLOR_NOTICE='cyan'
        declare -x COLOR_WARNING='bgcyan'
        declare -x COLOR_ERROR='bgred'
        declare -x COLOR_COMMENT='grey'
        ;;
esac

##@ LIB_FILENAME_DEFAULT = "piwi-bash-library" (read-only)
declare -rx LIB_FILENAME_DEFAULT='piwi-bash-library' 2>/dev/null;
##@ LIB_NAME_DEFAULT = "piwibashlib" (read-only)
declare -rx LIB_NAME_DEFAULT='piwibashlib' 2>/dev/null;
##@ LIB_LOGFILE = "piwibashlib.log" (read-only)
declare -rx LIB_LOGFILE="${LIB_NAME_DEFAULT}.log" 2>/dev/null;
##@ LIB_TEMPDIR = "tmp" (read-only)
declare -rx LIB_TEMPDIR='tmp' 2>/dev/null;
##@ LIB_SYSHOMEDIR = "${HOME}/.piwi-bash-library/" (read-only)
declare -rx LIB_SYSHOMEDIR="${HOME}/.${LIB_FILENAME_DEFAULT}" 2>/dev/null;
##@ LIB_SYSCACHEDIR = "${LIB_SYSHOMEDIR}/cache/" (read-only)
declare -rx LIB_SYSCACHEDIR="${LIB_SYSHOMEDIR}/cache" 2>/dev/null;

declare -rx VCS_VERSION_MASK='@vcsversion@' 2>/dev/null;
declare -x TEST_VAR='test'


#### COMMON OPTIONS #############################################################################

##@ COMMON_OPTIONS_ALLOWED = "fhiqvVx-:"
## List of default common short options.
##@ COMMON_OPTIONS_ALLOWED_MASK : REGEX mask that matches all common short options
##@ COMMON_LONG_OPTIONS_ALLOWED="working-dir:,working-directory:,force,help,interactive,log:,logfile:,quiet,verbose,version,debug,dry-run,libvers,man,usage"
## List of default common long options.
##@ COMMON_LONG_OPTIONS_ALLOWED_MASK : REGEX mask that matches all common long options
declare -x COMMON_OPTIONS_ALLOWED='fhiqvVx-:'
declare -x COMMON_LONG_OPTIONS_ALLOWED='working-dir:,force,help,interactive,log:,quiet,verbose,version,debug,dry-run,libvers,man,usage'
declare -x COMMON_OPTIONS_ALLOWED_MASK='h|f|i|q|v|x|V'
declare -x COMMON_LONG_OPTIONS_ALLOWED_MASK='working-dir|force|help|interactive|log|quiet|verbose|version|debug|dry-run|libvers|man|usage'

##@ OPTIONS_ALLOWED | LONG_OPTIONS_ALLOWED : to be defined by the script
declare -x OPTIONS_ALLOWED="$COMMON_OPTIONS_ALLOWED"
declare -x LONG_OPTIONS_ALLOWED="$COMMON_LONG_OPTIONS_ALLOWED"

##@ COMMON_SYNOPSIS COMMON_SYNOPSIS_ACTION COMMON_SYNOPSIS_ERROR COMMON_SYNOPSIS_MANPAGE COMMON_SYNOPSIS_ACTION_MANPAGE COMMON_SYNOPSIS_ERROR_MANPAGE (read-only)
## Default values for synopsis strings (final fallback).
declare -rx COMMON_SYNOPSIS="${0}  -[common options]  -[script options [=value]]  [--]  [arguments]" 2>/dev/null;
declare -rx COMMON_SYNOPSIS_ACTION="${0}  -[common options]  -[script options [=value]]  [--]  <action>" 2>/dev/null;
declare -rx COMMON_SYNOPSIS_ERROR="${0}  [-${COMMON_OPTIONS_ALLOWED_MASK}]\n\t[--${COMMON_LONG_OPTIONS_ALLOWED_MASK}]\n\t[--script-options [=value]]  [--]  <arguments>" 2>/dev/null;
declare -rx COMMON_SYNOPSIS_MANPAGE="~\$ <bold>${0}</bold>  -[<underline>common options</underline>]  -[<underline>script options</underline> [=<underline>value</underline>]]  [--]  [<underline>arguments</underline>]" 2>/dev/null;
declare -rx COMMON_SYNOPSIS_ACTION_MANPAGE="~\$ <bold>${0}</bold>  -[<underline>common options</underline>]  -[<underline>script options</underline> [=<underline>value</underline>]]  [--]  [<underline>action</underline>]" 2>/dev/null;
declare -rx COMMON_SYNOPSIS_ERROR_MANPAGE="${0}  [-${COMMON_OPTIONS_ALLOWED_MASK}]\n\t[--${COMMON_LONG_OPTIONS_ALLOWED_MASK}]\n\t[--script-options [=value]]  [--]  <arguments>" 2>/dev/null;

##@ OPTIONS_ADDITIONAL_INFOS_MANPAGE (read-only)
## Information string about command line options how-to
declare -rx OPTIONS_ADDITIONAL_INFOS_MANPAGE="\tYou can group short options like '<bold>-xc</bold>', set an option argument like '<bold>-d(=)value</bold>' \n\
\tor '<bold>--long=value</bold>' and use '<bold>--</bold>' to explicitly specify the end of the script options.\n \
\tOptions are treated in the command line order." 2>/dev/null;

##@ COMMON_OPTIONS_MANPAGE (read-only)
## Information string about common script options
declare -rx COMMON_OPTIONS_MANPAGE="<bold>-h | --help</bold>\t\t\tshow this information message \n\
\t<bold>-v | --verbose</bold>\t\t\tincrease script verbosity \n\
\t<bold>-q | --quiet</bold>\t\t\tdecrease script verbosity, nothing will be written unless errors \n\
\t<bold>-f | --force</bold>\t\t\tforce some commands to not prompt confirmation \n\
\t<bold>-i | --interactive</bold>\t\task for confirmation before any action \n\
\t<bold>-x | --debug</bold>\t\t\tenable debug mode \n\
\t<bold>-V | --version</bold>\t\t\tsee the script version when available ; use option '--quiet' to get the version number only\n\
\t<bold>--working-dir=PATH</bold>\t\tredefine the working directory (default is 'pwd' - 'PATH' must exist)\n\
\t<bold>--log=FILENAME</bold>\t\t\tdefine the log filename to use (default is '${LIB_LOGFILE}')\n\
\t<bold>--usage</bold>\t\t\t\tshow quick usage information \n\
\t<bold>--man</bold>\t\t\t\tsee the current script manpage if available \n\
\t<bold>--dry-run</bold>\t\t\tsee commands to run but not run them actually \n\
\t<bold>--libvers</bold>\t\t\tsee the library version" 2>/dev/null;

##@ COMMON_OPTIONS_USAGE (read-only)
## Raw information string about common script options
declare -rx COMMON_OPTIONS_USAGE="\n\
\t-v, --verbose\t\tincrease script verbosity \n\
\t-q, --quiet\t\tdecrease script verbosity, nothing will be written unless errors \n\
\t-f, --force\t\tforce some commands to not prompt confirmation \n\
\t-i, --interactive\task for confirmation before any action \n\
\t-x, --debug\t\tenable debug mode \n\
\t--working-dir=PATH\tredefine the working directory (default is 'pwd' - 'PATH' must exist)\n\
\t--log=FILENAME\t\tdefine the log filename to use (default is '${LIB_LOGFILE}')\n\
\t--dry-run\t\tsee commands to run but not run them actually \n\n\
\t-V, --version\t\tsee the script version when available\n\
\t\t\t\tuse option '--quiet' to get the version number only\n\
\t-h, --help\t\tshow this information message \n\
\t--usage\t\t\tshow quick usage information \n\
\t--man\t\t\tsee the current script manpage if available \n\
\t\t\t\ta 'manpage-like' output will be guessed otherwise\n\
\t--libvers\t\tsee the library version" 2>/dev/null;

##@ COMMON_OPTIONS_FULLINFO_MANPAGE (read-only)
## Concatenation of COMMON_OPTIONS_MANPAGE & OPTIONS_ADDITIONAL_INFOS_MANPAGE
declare -rx COMMON_OPTIONS_FULLINFO_MANPAGE="${COMMON_OPTIONS_MANPAGE}\n\n${OPTIONS_ADDITIONAL_INFOS_MANPAGE}" 2>/dev/null;


#### LOREM IPSUM #############################################################################

##@ LOREMIPSUM (844 chars.) , LOREMIPSUM_SHORT (446 chars.) , LOREMIPSUM_MULTILINE (861 chars. / 5 lines) (read-only)
declare -rx LOREMIPSUM="At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat." 2>/dev/null;
declare -rx LOREMIPSUM_SHORT="Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum." 2>/dev/null;
declare -rx LOREMIPSUM_MULTILINE="At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi. \n\
Sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. \n\
Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus \n\
autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, \n\
ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat." 2>/dev/null;


#### LIBRARY SETUP #######################################################################

##@ LIB_NAME LIB_VERSION LIB_DATE LIB_VCSVERSION LIB_VCSVERSION LIB_COPYRIGHT LIB_LICENSE_TYPE LIB_LICENSE_URL LIB_SOURCES_URL (read-only)
## Library internal setup
declare -rx LIB_NAME="Piwi Bash library" 2>/dev/null;
declare -rx LIB_VERSION="0.2.0" 2>/dev/null;
declare -rx LIB_DATE="2014-12-20" 2>/dev/null;
declare -rx LIB_VCSVERSION="master@7df65b11b1ae085a7df840e636778e030be8c5e2" 2>/dev/null;
declare -rx LIB_DESCRIPTION="An open source day-to-day bash library" 2>/dev/null;
declare -rx LIB_LICENSE_TYPE="GPL-3.0" 2>/dev/null;
declare -rx LIB_LICENSE_URL="http://www.gnu.org/licenses/gpl-3.0.html" 2>/dev/null;
declare -rx LIB_COPYRIGHT="Copyleft (ↄ) 2013-2015 Pierre Cassat & contributors" 2>/dev/null;
declare -rx LIB_PACKAGE="piwi/bash-library" 2>/dev/null;
declare -rx LIB_SCRIPT_VCS='git' 2>/dev/null;
declare -rx LIB_SOURCES_URL="https://github.com/piwi/bash-library" 2>/dev/null;

declare -rx LIB_LICENSE="License ${LIB_LICENSE_TYPE}: <${LIB_LICENSE_URL}>" 2>/dev/null;
declare -rx LIB_SOURCES="Sources & updates: <${LIB_SOURCES_URL}>" 2>/dev/null;
declare -rx LIB_ADDITIONAL_INFO="This is free software: you are free to change and redistribute it ; there is NO WARRANTY, to the extent permitted by law." 2>/dev/null;

declare -rx LIB_DEPEDENCY_MANPAGE_INFO="This script is based on the <bold>${LIB_NAME}</bold>, \"${LIB_DESCRIPTION}\". \n\
\t${LIB_COPYRIGHT} - Some rights reserved. \n\
\tPackage [<${COLOR_NOTICE}>${LIB_PACKAGE}</${COLOR_NOTICE}>] version [<${COLOR_NOTICE}>${LIB_VERSION}</${COLOR_NOTICE}>].\n\
\t${LIB_LICENSE}.\n\
\t${LIB_SOURCES}.\n\
\tBug reports: <http://github.com/piwi/bash-library/issues>.\n\
\t${LIB_ADDITIONAL_INFO}" 2>/dev/null;


#### SYSTEM #############################################################################

#### get_system_info ()
get_system_info () {
    if in_array "${USEROS}" "${LINUX_OS[@]}"
    then uname -osr
    else uname -vsr
    fi
    return "$?"
}

#### get_machine_name ()
get_machine_name () {
    uname -n
    return "$?"
}

#### get_path ()
## read current PATH values as human readable string
get_path () {
    echo -e "$PATH" | tr : \\n; return 0;
}

#### add_path ( path )
## add a path to global environment PATH
add_path () {
    if [ -n "$1" ]
    then
        export PATH="${PATH}:${1}"; return 0;
    else
        echo "add_path: empty argument!" >&2; return 1;
    fi
}

#### get_script_path ( script = $0 )
## get the full real path of a script directory (passed as argument) or from current executed script
get_script_path () {
    local arg="${1:-${0}}"
    local relpath="$(dirname "$arg")"
    local abspath="$(cd "$relpath" && pwd)"
    if [ -z "$abspath" ]; then return 1; fi
    echo "$abspath"
    return 0
}

#### get_date ( timestamp = NOW )
## cf. <http://www.admin-linux.fr/?p=1965>
get_date () {
    if [ -n "$1" ]
    then date -d "@${1}" +'%d/%m/%Y (%A) %X (UTC %z)'
    else date +'%d/%m/%Y (%A) %X (UTC %z)'
    fi
    return $?
}

#### get_ip ()
## this will load current IP address in USERIP & USERISP
get_ip () {
    export USERIP="$(ifconfig | awk '/inet / { print $2 } ' | sed -e "s/addr://" 2>&-)"
    export USERISP="$(ifconfig | awk '/P-t-P/ { print $3 } ' | sed -e "s/P-t-P://" 2>&-)"
    return 0
}

#### FILES #############################################################################

#### file_exists ( file_path )
## test if a file, link or directory exists in the file-system
file_exists () {
    local tmpvar="$1"
    if [ -n "$tmpvar" ] && [ -e "$tmpvar" ]; then
        return 0
    fi
    return 1
}

#### is_file ( file_path )
## test if a file exists in the file-system and is a 'true' file
is_file () {
    local tmpvar="$1"
    if [ -n "$tmpvar" ] && file_exists "$tmpvar" && [ -f "$tmpvar" ]; then
        return 0
    fi
    return 1
}

#### is_dir ( file_path )
## test if a file exists in the file-system and is a directory
is_dir () {
    local tmpvar="$1"
    if [ -n "$tmpvar" ] && file_exists "$tmpvar" && [ -d "$tmpvar" ]; then
        return 0
    fi
    return 1
}

#### is_link ( file_path )
## test if a file exists in the file-system and is a symbolic link
is_link () {
    local tmpvar="$1"
    if [ -n "$tmpvar" ] && file_exists "$tmpvar" && [ -L "$tmpvar" ]; then
        return 0
    fi
    return 1
}

#### is_executable ( file_path )
## test if a file or link exists in the file-system and has executable rights
is_executable () {
    local tmpvar="$1"
    if
        [ -n "$tmpvar" ] && file_exists "$tmpvar" &&
        ( is_file "$tmpvar" || ( is_link "$tmpvar" && is_file "$(readlink "$tmpvar")" ) ) &&
        [ -x "$tmpvar" ];
    then
        return 0
    fi
    return 1
}

#### get_extension ( path = $0 )
## retrieve a file extension
get_extension () {
    local arg="${1:-${0}}"
    echo "${arg##*.}" && return 0 || return 1;
}

#### get_filename ( path = $0 )
## isolate a file name without dir & extension
get_filename () {
    local arg="${1:-${0}}"
    filename="$(get_basename "$arg")"
    echo "${filename%.*}" && return 0 || return 1;
}

#### get_basename ( path = $0 )
## isolate a file name
get_basename () {
    local arg="${1:-${0}}"
    basename "$arg" && return 0 || return 1;
}

#### get_dirname ( path = $0 )
## isolate a file directory name
get_dirname () {
    local arg="${1:-${0}}"
    dirname "$arg" && return 0 || return 1;
}

#### get_absolute_path ( script = $0 )
## get the real path of a script (passed as argument) or from current executed script
get_absolute_path () {
    local arg="${1:-${0}}"
    local dirpath="$(get_script_path "$arg")"
    if [ -z "$dirpath" ]; then return 1; fi
    echo "${dirpath}/$(basename "$arg")" && return 0 || return 1;
}

#### / realpath ( string )
## alias of 'get_absolute_path'
realpath () { get_absolute_path $*; }

#### resolve ( path )
## resolve a system path replacing '~' and '.'
resolve () {
    if [ $# -eq 0 ]; then return 0; fi
    local _path="$1"
    if [ "${_path:0:1}" = '~' ]; then _path="${_path/\~/${HOME}}"; fi
    if [ "${_path:0:1}" != '/' ]; then _path="$(pwd)/${_path}"; fi
    echo "$_path"
}

#### ARRAY #############################################################################

#### in_array ( item , $array[@] )
##@return 0 if item is found in array
in_array () {
    needle="$1"; shift
    for item; do
        [ "$needle" = "$item" ] && return 0
    done
    return 1
}

#### array_search ( item , $array[@] )
##@return the index of an array item, 0 based
array_search () {
    local i=0; local search="$1"; shift
    while [ "$search" != "$1" ]
    do ((i++)); shift
        [ -z "$1" ] && { i=0; break; }
    done
    [ "$i" != '0' ] && echo "$i" && return 0
    return 1
}

#### array_filter ( $array[@] )
##@return array with cleaned values
array_filter () {
    local -a cleaned=()
    for item; do
        if test "$item"; then cleaned+=("$item"); fi
    done
    echo "${cleaned[@]-}"
}


#### STRING #############################################################################

#### string_length ( string )
##@return the number of characters in string
string_length () {
    echo "${#1}"; return 0;
}

#### / strlen ( string )
## alias of 'string_length'
strlen () { string_length "$*"; }

#### string_to_upper ( string )
string_to_upper () {
    if [ -n "$1" ]; then
        echo "$1" | tr '[:lower:]' '[:upper:]'; return 0;
    fi
    return 1
}

#### / strtoupper ( string )
## alias of 'string_to_upper'
strtoupper () { string_to_upper "$*"; }

#### string_to_lower ( string )
string_to_lower () {
    if [ -n "$1" ]; then
        echo "$1" | tr '[:upper:]' '[:lower:]'; return 0;
    fi
    return 1
}

#### / strtolower ( string )
## alias of 'string_to_lower'
strtolower () { string_to_lower "$*"; }

#### upper_case_first ( string )
upper_case_first () {
    if [ -n "$1" ]; then
        echo "$(string_to_upper "${1:0:1}")${1:1:${#1}}"; return 0;
    fi
    return 1
}

#### / ucfirst ( string )
## alias of 'upper_case_first'
ucfirst () { upper_case_first "$*"; }

##@ MAX_LINE_LENGTH = 80 : default max line length for word wrap (integer)
declare -xi MAX_LINE_LENGTH=80
##@ LINE_ENDING = \n : default line ending character for word wrap
declare -x LINE_ENDING="\n"

#### word_wrap ( text )
# wrap a text in MAX_LINE_LENGTH max lengthes lines
word_wrap () {
    if [ $# -gt 0 ]; then
        echo "$*" | sed -e "s/.\{${MAX_LINE_LENGTH}\} /&${LINE_ENDING}/g"
        return 0
    fi
    return 1
}

#### explode ( str , delim = ' ' )
# explode a string in an array using a delimiter
# result is loaded in '$EXPLODED_ARRAY'
explode () {
    if [ -n "$1" ]; then
        local IFS="${2:- }"
        read -a EXPLODED_ARRAY <<< "$1"
        export EXPLODED_ARRAY
        return 0
    fi
    return 1
}

#### implode ( array[@] , delim = ' ' )
# implode an array in a string using a delimiter
implode () {
    if [ -n "$1" ]; then
        declare -a _array=("${!1}")
        declare _delim="${2:- }"
        local oldIFS="$IFS"
        IFS="$_delim"
        local _arraystr="${_array[*]}"
        IFS="$oldIFS"
        export IFS
        echo "$_arraystr"
        return 0
    fi
    return 1
}

#### explode_letters ( str )
# explode a string in an array of single letters
# result is loaded in '$EXPLODED_ARRAY'
explode_letters () {
    if [ -n "$1" ]; then
        local _input="$1"
        local i=0
        local -a letters=()
        while [ $i -lt ${#_input} ]; do letters[$i]="${_input:$i:1}"; i=$((i+1)); done
        EXPLODED_ARRAY=( "${letters[@]}" )
        export EXPLODED_ARRAY
        return 0
    fi
    return 1
}

#### BOOLEAN #############################################################################

#### onoff_bit ( bool )
## echoes 'on' if bool=true, 'off' if it is false
onoff_bit () {
    if [ "$1" = 'true' ]; then echo 'on'; else echo 'off'; fi; return 0;
}


#### UTILS #############################################################################

#### is_numeric ( value )
is_numeric () {
    local var="$1"
    echo -e "$var" | grep "[^0-9]" > /dev/null
    local _status="$?"
    [ "$_status" = '1' ] && return 0;
    [ "$_status" = '0' ] && return 1;
}

#### is_numeric_by_variable_name ( variable_name )
is_numeric_by_variable_name () {
    export tmpvar="${!1}"
    is_numeric "$tmpvar"
    return "$?"
}

#### is_array ( $array[*] )
## this will (only for now) test if there 1 or more arguments passed
##+ and will therfore return '1' (false) for a single item array
is_array () {
    [ $# -gt 1 ] && return 0;
    return 1;
#    export tmpvar=${!1}
##    echo "${tmpvar[*]}"
#    is_array_by_variable_name tmpvar
#    return "$?"
}

#### is_array_by_variable_name ( variable_name )
is_array_by_variable_name () {
    local var="$1"
    declare -p "$var" 2> /dev/null | grep -q 'declare \-a'
    return "$?"
}

#### is_boolean ( value )
is_boolean () {
    local var="$1"
    if [ "$var" = 'true' ]||[ "$var" = 'false' ]||[ "$var" = '1' ]||[ "$var" = '0' ]
    then return 0
    else return 1
    fi
}

#### is_boolean_by_variable_name ( variable_name )
is_boolean_by_variable_name () {
    export tmpvar="${!1}"
    is_boolean "$tmpvar"
    return "$?"
}

#### is_string ( value )
is_string () {
    local tmpvar=$1
    if
        [ $# -eq 1 ] &&
        ! is_numeric "$tmpvar" &&
        ! is_boolean "$tmpvar" ;
    then
        return 0
    fi
    return 1
}

#### is_string_by_variable_name ( variable_name )
is_string_by_variable_name () {
    export tmpvar="${!1}"
    is_string "$tmpvar"
    return "$?"
}


#### VCS #############################################################################

declare -rxa VCS_VARS="(VCSVERSION SCRIPT_VCS)" 2>/dev/null;

##@ VCSVERSION
## Variable used as version marker like `branch@commit_sha`

##@ SCRIPT_VCS
## VCS type of the script (only 'git' for now)
declare -x SCRIPT_VCS=''

#### get_version_string ( file_path = $0 , constant_name = VCSVERSION )
## get the version string from a file_path
get_version_string () {
    local fpath="${1:-$0}"
    local cstname="${2:-VCSVERSION}"
    if [ ! -z "${!cstname}" ]
    then
        echo "${!cstname}"
    else
        local _infile
        if [ -f "$fpath" ]; then
            _infile=$(head -n200 "$fpath" | grep -o -e "${cstname}=\".*\"" | sed "s|^${cstname}=\"\(.*\)\"$|\1|g")
        fi
        if [ ! -z "$_infile" ]; then
            echo "$_infile"
        elif [ "$SCRIPT_VCS" = 'git' ]; then
            if git_is_clone 2>/dev/null; then
                local _gitvers=$(git_get_version 2>/dev/null)
                [ ! -z "$_gitvers" ] && echo "$_gitvers";
            fi
        fi
    fi
    return 0
}

#### get_version_sha ( get_version_string )
## get last commit sha from a GIT version string
get_version_sha () {
    if [ $# -gt 0 ]; then
        echo "$1" | cut -d'@' -f 2
        return 0
    fi
    return 1
}

#### get_version_branch ( get_version_string )
## get the branch name from a GIT version string
get_version_branch () {
    if [ $# -gt 0 ]; then
        echo "$1" | cut -d'@' -f 1
        return 0
    fi
    return 1
}

#### vcs_is_clone ( path = pwd , remote_url = null )
vcs_is_clone () {
    if [ "$SCRIPT_VCS" = '' ]; then
        error "You must define the 'SCRIPT_VCS' variable to use vcs methods!"
    fi
    local _path="${1:-$(pwd)}"
    local _remote_url="${2:-}"
    local _status=1
    case "$SCRIPT_VCS" in
        git) git_is_clone "$_path" "$_remote_url"; _status="$?";;
    esac
    return "$_status"
}

#### vcs_get_branch ( path = pwd )
vcs_get_branch () {
    if [ "$SCRIPT_VCS" = '' ]; then
        error "You must define the 'SCRIPT_VCS' variable to use vcs methods!"
    fi
    local _path="${1:-$(pwd)}"
    local _status=1
    case "$SCRIPT_VCS" in
        git) git_get_branch "$_path"; _status="$?";;
    esac
    return "$_status"
}

#### vcs_get_commit ( path = pwd )
vcs_get_commit () {
    if [ "$SCRIPT_VCS" = '' ]; then
        error "You must define the 'SCRIPT_VCS' variable to use vcs methods!"
    fi
    local _path="${1:-$(pwd)}"
    local _status=1
    case "$SCRIPT_VCS" in
        git) git_get_commit "$_path"; _status="$?";;
    esac
    return "$_status"
}

#### vcs_get_version ( path = pwd )
vcs_get_version () {
    if [ "$SCRIPT_VCS" = '' ]; then
        error "You must define the 'SCRIPT_VCS' variable to use vcs methods!"
    fi
    local _path="${1:-$(pwd)}"
    local _status=1
    case "$SCRIPT_VCS" in
        git) git_get_version "$_path"; _status="$?";;
    esac
    return "$_status"
}

#### vcs_get_remote_version ( path = pwd , branch = HEAD )
vcs_get_remote_version () {
    if [ "$SCRIPT_VCS" = '' ]; then
        error "You must define the 'SCRIPT_VCS' variable to use vcs methods!"
    fi
    local _path="${1:-$(pwd)}"
    local _branch="${2:-HEAD}"
    local _status=1
    case "$SCRIPT_VCS" in
        git) git_get_remote_version "$_path" "$_branch"; _status="$?";;
    esac
    return "$_status"
}

#### vcs_make_clone ( repository_url , target_dir = LIB_SYSCACHEDIR )
vcs_make_clone () {
    if [ "$SCRIPT_VCS" = '' ]; then
        error "You must define the 'SCRIPT_VCS' variable to use vcs methods!"
    fi
    local _repo_url="${1:-}"
    local _target_dir="${2:-${LIB_SYSCACHEDIR}}"
    local _status=1
    case "$SCRIPT_VCS" in
        git) git_make_clone "$_repo_url" "$_target_dir"; _status="$?";;
    esac
    return "$_status"
}

#### vcs_update_clone ( target_dir )
vcs_update_clone () {
    if [ "$SCRIPT_VCS" = '' ]; then
        error "You must define the 'SCRIPT_VCS' variable to use vcs methods!"
    fi
    local _target_dir="${1:-}"
    local _status=1
    case "$SCRIPT_VCS" in
        git) git_update_clone "$_target_dir"; _status="$?";;
    esac
    return "$_status"
}

#### vcs_change_branch ( target_dir , branch = 'master' )
vcs_change_branch () {
    if [ "$SCRIPT_VCS" = '' ]; then
        error "You must define the 'SCRIPT_VCS' variable to use vcs methods!"
    fi
    local _target_dir="${1:-}"
    local _branch="${2:-master}"
    local _status=1
    case "$SCRIPT_VCS" in
        git) git_change_branch "$_target_dir" "$_branch"; _status="$?";;
    esac
    return "$_status"
}

##@ CURRENT_GIT_CLONE_DIR
## Environment variable to store current GIT clone directory
declare -x CURRENT_GIT_CLONE_DIR

#### git_is_clone ( path = pwd , remote_url = null )
## check if a path, or `pwd`, is a git clone of a remote if 2nd argument is set
git_is_clone () {
    local curpath="$(pwd)"
    local targetpath="${1:-${curpath}}"
    local gitcmd="$(which git)"
    if [ $# -gt 1 ]; then
        if [ -n "$gitcmd" ]
        then
            cd "$targetpath"
            local gitremote="$(git config --get remote.origin.url)"
            if [ "$gitremote" = "${2}.git" ]||[ "$gitremote" = "$2" ]
                then return 0; else return 1;
            fi
            cd "$curpath"
        else
            command_error 'git'
        fi
    fi
    local gitpath="${targetpath}/.git"
    if [ -d "$gitpath" ]; then return 0; fi;
    targetpath="$(get_absolute_path "$targetpath")"
    local subdir="${targetpath/${curpath}/}"
    if [ "$subdir" != "$targetpath" ]; then
        local subdirgitpath="${subdir}/.git"
        if [ -d "$subdirgitpath" ]; then cd "$curpath" && return 0; fi;
    fi
    return 1
}

#### git_get_branch ( path = pwd )
git_get_branch () {
    if [ $# -gt 0 ]; then cd "$1"; fi
    if git_is_clone; then
        local gitcmd="$(which git)"
        if [ -n "$gitcmd" ]; then
            git rev-parse --abbrev-ref HEAD
            return 0
        fi
    fi
    return 1
}

#### git_get_commit ( path = pwd )
git_get_commit () {
    if [ $# -gt 0 ]; then cd "$1"; fi
    if git_is_clone; then
        local gitcmd="$(which git)"
        if [ -n "$gitcmd" ]; then
            git rev-parse HEAD
            return 0
        fi
    fi
    return 1
}

#### git_get_version ( path = pwd )
git_get_version () {
    if [ $# -gt 0 ]; then cd "$1"; fi
    if git_is_clone; then
        local gitcmd="$(which git)"
        if [ -n "$gitcmd" ]; then
            local _getbr="$(git_get_branch)"
            local _gethash="$(git_get_commit)"
            if [ -n "$_getbr" ] && [ -n "$_gethash" ]; then
                echo "${_getbr}@${_gethash}"
                return 0
            fi
        fi
    fi
    return 1
}

#### git_get_remote_version ( path = pwd , branch = HEAD )
## get the last GIT commit SHA from the remote in branch
git_get_remote_version () {
    local clonedir="${1:-$(pwd)}"
    local branch="${2:-HEAD}"
    git ls-remote "$clonedir" | awk "/${branch}/ {print \$1}" | sort -u ;
    return 0
}

#### git_make_clone ( repository_url , target_dir = LIB_SYSCACHEDIR )
## create a git clone of a distant repository in CURRENT_GIT_CLONE_DIR
##@env clone directory is loaded in CURRENT_GIT_CLONE_DIR
git_make_clone () {
    if [ $# -eq 0 ]; then return 0; fi
    local repourl="$1"
    if [ $# -eq 1 ]
    then
        local _dirname="$(basename "$repourl")"
        _dirname="${_dirname/.git/}"
        local target="${LIB_SYSCACHEDIR}/${_dirname}"
        make_library_cachedir
    else
        local target="$2"
        if [ ! -d "$target" ]; then mkdir -p "$target"; fi
    fi
    local oldpwd="$(pwd)"
    local gitcmd="$(which git)"
    if [ -z "$gitcmd" ]; then command_error 'git'; fi
    local tocreate=true
    if [ -d "$target" ]; then
        if git_is_clone "$target" "$repourl"; then tocreate=false; fi
    fi
    if [ "$tocreate" = 'true' ]; then
        rm -rf "$target" && mkdir "$target"
        verecho "- creating git clone of repository '${repourl}' into '${target}' ..."
        git clone -q "$repourl" "$target"
        cd "$oldpwd"
    fi
    export CURRENT_GIT_CLONE_DIR="$target"
    return 0
}

#### git_update_clone ( target_dir )
## update a git clone
##@param target_dir: name of the clone in LIB_SYSCACHEDIR or full path of concerned clone
git_update_clone () {
    if [ $# -eq 0 ]; then return 0; fi
    local oldpwd="$(pwd)"
    local gitcmd="$(which git)"
    if [ -z "$gitcmd" ]; then command_error 'git'; fi
    local target="$1"
    if [ ! -d "$target" ]; then
        local fulltarget="${LIB_SYSCACHEDIR}/${target}"
        if [ ! -d "$fulltarget" ]; then
            path_error "git clone target '${target}' not found"
        fi
        target="$fulltarget"
    fi
    cd "$target"
    verecho "- updating git clone in '${target}' ..."
    git pull -q
    cd "$oldpwd"
    export CURRENT_GIT_CLONE_DIR="$target"
    return 0
}

#### git_change_branch ( target_dir , branch = 'master' )
## change a git clone tracking branch
##@param target_dir: name of the clone in LIB_SYSCACHEDIR or full path of concerned clone
git_change_branch () {
    if [ $# -eq 0 ]; then return 0; fi
    local oldpwd="$(pwd)"
    local gitcmd="$(which git)"
    if [ -z "$gitcmd" ]; then command_error 'git'; fi
    local target="$1"
    if [ ! -d "$target" ]; then
        local fulltarget="${LIB_SYSCACHEDIR}/${target}"
        if [ ! -d "$fulltarget" ]; then
            path_error "git clone target '${target}' not found"
        fi
        target="$fulltarget"
    fi
    local targetbranch="${2:-master}"
    cd "$target"
    if [ "$targetbranch" != "$(git_get_branch)" ]; then
        verecho "- switching git clone branch to '${targetbranch}' in '${target}' ..."
        git checkout -q "$targetbranch" && git pull -q
    fi
    cd "$oldpwd"
    return 0
}


#### COLORIZED CONTENTS #############################################################################

##@ LIBCOLORS = ( default black red green yellow blue magenta cyan grey white lightred lightgreen lightyellow lightblue lightmagenta lightcyan lightgrey ) (read-only)
## Terminal colors table
declare -rxa LIBCOLORS="(default black red green yellow blue magenta cyan grey white lightred lightgreen lightyellow lightblue lightmagenta lightcyan lightgrey)" 2>/dev/null;
declare -rxa LIBCOLORS_CODES_FOREGROUND="(39 30 31 32 33 34 35 36 90 97 91 92 93 94 95 96 37)" 2>/dev/null;
declare -rxa LIBCOLORS_CODES_BACKGROUND="(49 40 41 42 43 44 45 46 100 107 101 102 103 104 105 106 47)" 2>/dev/null;

##@ LIBTEXTOPTIONS = ( normal bold small underline blink reverse hidden ) (read-only)
## Terminal text options table
declare -rxa LIBTEXTOPTIONS="(normal bold small underline blink reverse hidden)" 2>/dev/null;
declare -rxa LIBTEXTOPTIONS_CODES="(0 1 2 4 5 7 8)" 2>/dev/null;

#### get_text_format_tag ( code )
## echoes the terminal tag code for color: "\ 033[CODEm"
##@param code must be one of the library colors or text-options codes
get_text_format_tag () {
    if [ -n "$1" ]; then
        case "$USEROS" in
            Linux|FreeBSD|OpenBSD|SunOS)
                echo "\033[${1}m";;
            *)
                echo "\x1B[${1}m";;
        esac
        return 0
    fi
    return 1
}

#### get_color_code ( name , background = false )
##@param name must be in LIBCOLORS
get_color_code () {
    if [ -n "$1" ]; then
        if in_array "$1" "${LIBCOLORS[@]}"; then
            if [ $# -gt 1 ]
                then echo "${LIBCOLORS_CODES_BACKGROUND[$(array_search "$1" "${LIBCOLORS[@]}")]}";
                else echo "${LIBCOLORS_CODES_FOREGROUND[$(array_search "$1" "${LIBCOLORS[@]}")]}";
            fi
            return 0
        fi
    fi
    return 1
}

#### get_color_tag ( name , background = false )
##@param name must be in LIBCOLORS
get_color_tag () {
    if [ -n "$1" ]; then
        if in_array "$1" "${LIBCOLORS[@]}"; then
            if [ $# -gt 1 ]
                then get_text_format_tag "${LIBCOLORS_CODES_BACKGROUND[$(array_search "$1" "${LIBCOLORS[@]}")]}";
                else get_text_format_tag "${LIBCOLORS_CODES_FOREGROUND[$(array_search "$1" "${LIBCOLORS[@]}")]}";
            fi
            return 0;
        fi
    fi
    return 1
}

#### get_text_option_code ( name )
##@param name must be in LIBTEXTOPTIONS
get_text_option_code () {
    if [ -n "$1" ]; then
        if in_array "$1" "${LIBTEXTOPTIONS[@]}"
        then
            echo "${LIBTEXTOPTIONS_CODES[$(array_search "$1" "${LIBTEXTOPTIONS[@]}")]}";
            return 0;
        fi
    fi
    return 1
}

#### get_text_option_tag ( name )
##@param name must be in LIBTEXTOPTIONS
get_text_option_tag () {
    if [ -n "$1" ]; then
        if in_array "$1" "${LIBTEXTOPTIONS[@]}"
        then
            get_text_format_tag "${LIBTEXTOPTIONS_CODES[$(array_search "$1" "${LIBTEXTOPTIONS[@]}")]}";
            return 0;
        fi
    fi
    return 1
}

#### get_text_option_tag_close ( name )
##@param name must be in LIBTEXTOPTIONS
get_text_option_tag_close () {
    if [ -n "$1" ]; then
        if in_array "$1" "${LIBTEXTOPTIONS[@]}"
        then
            get_text_format_tag "2${LIBTEXTOPTIONS_CODES[$(array_search "$1" "${LIBTEXTOPTIONS[@]}")]}";
            return 0;
        fi
    fi
    return 1
}

#### colorize ( string , text_option , foreground , background )
## echoes a colorized string ; all arguments are optional except `string`
##@param text_option must be in LIBTEXTOPTIONS
##@param foreground must be in LIBCOLORS
##@param background must be in LIBCOLORS
colorize () {
    if [ $# -eq 0 ]; then return 0; fi
    local textopt
    if [ $# -gt 1 ]; then textopt=$(get_text_option_code "$2"); fi
    local fgopt
    if [ $# -gt 2 ]; then fgopt=$(get_color_code "$3"); fi
    local bgopt
    if [ $# -gt 3 ]; then bgopt=$(get_color_code "$4" true); fi
    local add=''
    if [ ! -z "$textopt" ]; then add+="$textopt"; fi
    if [ ! -z "$fgopt" ]; then
        if [ -n "$add" ]; then add+=";${fgopt}"; else add+="$fgopt"; fi
    fi
    if [ ! -z "$bgopt" ]; then
        if [ -n "$add" ]; then add+=";${bgopt}"; else add+="$bgopt"; fi
    fi
    opentag="$(get_text_format_tag "$add")"
    closetag="$(get_text_format_tag "$(get_text_option_code normal)")"
    if [ ! -n "$add" ]
        then echo "$1"
        else echo "${opentag}${1}${closetag}"
    fi
    return 0
}

#### parse_color_tags ( "string with <bold>tags</bold>" )
## parse in-text tags like:
##     ... <bold>my text</bold> ...     // "tag" in LIBTEXTOPTIONS
##     ... <red>my text</red> ...       // "tag" in LIBCOLORS
##     ... <bgred>my text</bgred> ...   // "tag" in LIBCOLORS, constructed as "bgTAG"
parse_color_tags () {
    if [ $# -eq 0 ]; then return 0; fi
    transformed=''
    while read -r line; do
        doneopts=()
        transformedline="$line"
        for opt in $(echo "$line" | grep -o '<.[^/>]*>' | sed "s|^.*<\(.[^>]*\)>.*\$|\1|g"); do
            opt="${opt/\//}"
            if in_array "$opt" "${doneopts[@]-}"; then continue; fi
            doneopts+=("$opt")
            if in_array "$opt" "${LIBTEXTOPTIONS[@]}"; then
                code="$(get_text_option_code "$opt")"
                tag="$(get_text_option_tag "$opt")"
                if in_array "$USEROS" "${LINUX_OS[@]}"
                    then normaltag="$(get_text_option_tag_close "$opt")"
                    else normaltag="$(get_text_option_tag normal)"
                fi
            elif in_array "$opt" "${LIBCOLORS[@]}"; then
                code="$(get_color_code "$opt")"
                tag="$(get_color_tag "$opt")"
                normaltag="$(get_color_tag default)"
            else
                code="$(get_color_code "${opt/bg/}" true)"
                tag="$(get_color_tag "${opt/bg/}" true)"
                normaltag="$(get_color_tag default true)"
           fi
            if in_array "$USEROS" "${LINUX_OS[@]}"; then
                 tag="$(printf '\%s' "$tag")"
                 normaltag="$(printf '\%s' "$normaltag")"
            fi
            if [ ! -z "$tag" ]; then
                strsubstituted=$(echo "$transformedline" | sed "s|<${opt}>|${tag}|g;s|</${opt}>|${normaltag}|g" 2> /dev/null);
                if [ ! -z "$strsubstituted" ]; then transformedline="$strsubstituted"; fi
            fi
        done
        if [ -n "$transformed" ]; then transformed+="\n"; fi
        transformed+="$transformedline"
    done <<< "$1"
    _echo "$transformed"
    return 0
}

#### strip_colors ( string )
strip_colors () {
    if [ $# -eq 0 ]; then return 0; fi
    transformed=''
    while read -r line; do
        case "$USEROS" in
            Linux|FreeBSD|OpenBSD|SunOS)
                stripped_line=$(echo "${line}" | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g");;
            *)
                stripped_line=$(echo "${line}" | sed 's|\x1B\[[0-9;]*[a-zA-Z]||g');;
        esac
        if [ -n "${transformed}" ]; then transformed+="\n"; fi
        transformed+="${stripped_line}"
    done <<< "$1"
    _echo "${transformed}"
    return 0
}


#### TEMPORARY FILES #####################################################################

#### get_tempdir_path ( dirname = "LIB_TEMPDIR" )
## creates a default temporary dir with fallback: first in current dir then in system '/tmp/'
## the real temporary directory path is loaded in the global `TEMPDIR`
##@param dirname The name of the directory to create (default is `tmp/`)
get_tempdir_path () {
    if [ -n "$TEMPDIR" ]; then return 0; fi
    local tmpdir="${1:-${LIB_TEMPDIR}}"
    local tmpsyspath="/tmp/${LIB_NAME_DEFAULT}"
    local tmppwdpath="${WORKINGDIR}/${tmpdir}"
    if [ ! -d "$tmppwdpath" ]; then
        mkdir "$tmppwdpath" && chmod 777 "$tmppwdpath"
        if [ ! -d "$tmppwdpath" ]||[ ! -w "$tmppwdpath" ]; then
            if [ ! -d "$tmpsyspath" ]; then
                mkdir "$tmpsyspath" && chmod 777 "$tmpsyspath"
                if [ ! -d "$tmpsyspath" ]||[ ! -w "$tmpsyspath" ]
                    then error "Can not create temporary directory (tries to create '${tmppwdpath}' then '${tmpsyspath}')"
                    else export TEMPDIR="$tmpsyspath";
                fi
            else export TEMPDIR="$tmpsyspath";
            fi
        else export TEMPDIR="$tmppwdpath";
        fi
    else export TEMPDIR="$tmppwdpath";
    fi
    return 0
}

#### get_tempfile_path ( filename , dirname = "LIB_TEMPDIR" )
## this will echoes a unique new temporary file path
##@param filename The temporary filename to use
##@param dirname The name of the directory to create (default is `tmp/`)
get_tempfile_path () {
    if [ -z "$1" ]; then return 0; fi
    local tmpfile="$1"
    if [ ! -z "$2" ]
        then
            export TEMPDIR=''
            get_tempdir_path "$2"
        else
            get_tempdir_path
    fi
    local filepath="${TEMPDIR}/${tmpfile}"
    while [ -f "$filepath" ]; do
        n=$(( ${n:=0} + 1 ))
        filepath="${TEMPDIR}/${tmpfile}-${n}"
    done
    echo "$filepath"
    return 0
}

#### create_tempdir ( dirname = "LIB_TEMPDIR" )
## this will create a temporary directory in the working directory with full rights
## use this method to over-write an existing temporary directory
##@param dirname The name of the directory to create (default is `tmp/`)
create_tempdir () {
    if [ $# -gt 0 ]
        then
            export TEMPDIR=''
            get_tempdir_path "$1"
        else
            get_tempdir_path
    fi
    return 0
}

#### clear_tempdir ( dirname = "LIB_TEMPDIR" )
## this will deletes the temporary directory
##@param dirname The name of the directory (default is `tmp/`)
clear_tempdir () {
    if [ $# -gt 0 ]
        then get_tempdir_path "$1"
        else get_tempdir_path
    fi
    if [ -d "$TEMPDIR" ]; then
        rm -rf "$TEMPDIR"
    fi
    return 0
}

#### clear_tempfiles ( dirname = "LIB_TEMPDIR" )
## this will deletes the temporary directory contents (not the directory itself)
##@param dirname The name of the directory (default is `tmp/`)
clear_tempfiles () {
    if [ $# -gt 0 ]
        then get_tempdir_path "$1"
        else get_tempdir_path
    fi
    if [ -d "$TEMPDIR" ]; then
        rm -rf "${TEMPDIR}/*"
    fi
    return 0
}


#### LOG FILES #####################################################################

#### get_log_filepath ()
## creates a default placed log file with fallback: first in '/var/log' then in LIB_SYSHOMEDIR, finally in current dir
## the real log file path is loaded in the global `LOGFILEPATH
get_log_filepath () {
    if [ ! -n "$LOGFILE" ]; then export LOGFILE="$LIB_LOGFILE"; fi
    local logsys="/var/log/${LOGFILE}"
    touch "$logsys" 2> /dev/null;
    if [ -w "$logsys" ]
    then
        export LOGFILEPATH="$logsys"
    else
        make_library_homedir
        local logsys="${LIB_SYSHOMEDIR}/${LOGFILE}"
        touch "$logsys" 2> /dev/null;
        if [ -w "$logsys" ]
        then export LOGFILEPATH="$logsys"
        else export LOGFILEPATH="$LOGFILE"
        fi
    fi
    return 0
}

#### log ( message , type='' )
## this will add an entry in LOGFILEPATH
log () {
    if [ $# -eq 0 ]; then return 0; fi
    local add=''
    if [ $# -gt 1 ]; then add=" <${2}>"; fi
    if [ ! -n "$LOGFILEPATH" ]; then get_log_filepath; fi
    echo "$(date '+%B %d %T') $(get_machine_name) [${USER}] [$$]${add} - ${1}" >> "$LOGFILEPATH"
    return 0
}

#### read_log ()
## this will read the LOGFILEPATH content
read_log () {
    if [ ! -n "$LOGFILEPATH" ]; then get_log_filepath; fi
    if [ -r "$LOGFILEPATH" ] && [ -f "$LOGFILEPATH" ]; then cat "$LOGFILEPATH"; fi
    return 0
}


#### CONFIGURATION FILES #####################################################################

#### get_global_configfile ( file_name )
get_global_configfile () {
    if [ -z "$1" ]; then
        warning "'get_global_configfile()' requires a file name as argument"
        return 0
    fi
    local filename="$1"
    echo "/etc/${filename}.conf"
    return 0
}

#### get_user_configfile ( file_name )
get_user_configfile () {
    if [ -z "$1" ]; then
        warning "'get_user_configfile()' requires a file name as argument"
        return 0
    fi
    local filename="$1"
    echo "~/.${filename}.conf"
    return 0
}

#### read_config ( file_name )
## read a default placed config file with fallback: first in 'etc/' then in '~/'
read_config () {
    if [ -z "$1" ]; then
        warning "'read_config()' requires a file name as argument"
        return 0
    fi
    local filename="$1"
    local global_filepath="/etc/${filename}"
    local user_filepath="~/.${filename}"
    if [ -r "$global_filepath" ]; then
        source "$global_filepath"
    fi
    if [ -r "$user_filepath" ]; then
        source "$user_filepath"
    fi
    return 0
}

#### read_configfile ( file_path )
## read a config file
read_configfile () {
    if [ -z "$1" ]; then
        warning "'read_configfile()' requires a file path as argument"
        return 0
    fi
    local filepath="$1"
    if [ ! -f "$filepath" ]; then
        warning "Config file '$1' not found!"
        return 0
    fi
    while read line; do
        if [[ "$line" =~ ^[^#]*= ]]; then
            name="${line%%=*}"
            value="${line##*=}"
            export "${name}"="${value}"
        fi
    done < "$filepath"
    return 0
}

#### write_configfile ( file_path , array_keys , array_values )
## array params must be passed as "array[@]" (no dollar sign)
write_configfile () {
    if [ -z "$1" ]; then
        warning "'write_configfile()' requires a file name as 1st argument"
        return 0
    fi
    if [ -z "$2" ]; then
        warning "'write_configfile()' requires a configuration keys array as 2nd argument"
        return 0
    fi
    if [ -z "$3" ]; then
        warning "'write_configfile()' requires a configuration values array as 3rd argument"
        return 0
    fi
    local filepath="$1"
    declare -a array_keys=("${!2}")
    declare -a array_values=("${!3}")
    touch "$filepath"
    cat > "$filepath" <<EOL
$(build_configstring array_keys[@] array_values[@])
EOL
    if [ -f "$filepath" ]
        then return 0
        else return 1
    fi
}

#### set_configval ( file_path , key , value )
set_configval () {
    if [ -z "$1" ]; then
        warning "'set_configval()' requires a file name as 1st argument"
        return 0
    fi
    if [ -z "$2" ]; then
        warning "'set_configval()' requires a configuration key as 2nd argument"
        return 0
    fi
    if [ -z "$3" ]; then
        warning "'set_configval()' requires a configuration value as 3rd argument"
        return 0
    fi
    local filepath="$1"
    local key="$2"
    local value="$3"
    touch "$filepath"
    if grep -q "${key}=*" "$filepath"; then
        if in_array "${USEROS}" "${LINUX_OS[@]}"
            then sed -i -e "s|\(${key}=\).*|\1${value}|" "$filepath"
            else sed -i '' -e "s|\(${key}=\).*|\1${value}|" "$filepath"
        fi
    else
       echo "${key}=${value}" >> "$filepath"
    fi
    return 0
}

#### get_configval ( file_path , key )
get_configval () {
    if [ -z "$1" ]; then
        warning "'get_configval()' requires a file name as 1st argument"
        return 0
    fi
    if [ -z "$2" ]; then
        warning "'get_configval()' requires a configuration key as 2nd argument"
        return 0
    fi
    local filepath="$1"
    local key="$2"
    if [ -f "$filepath" ]; then
        if grep -q "${key}=*" "$filepath"; then
           local line="$(grep "^${key}=" "$filepath")"
           echo "${line##*=}"
        fi
    fi
    return 0
}

#### build_configstring ( array_keys , array_values )
## params must be passed as "array[@]" (no dollar sign)
build_configstring () {
    if [ $# -eq 0 ]; then return 0; fi
    declare -a array_keys=("${!1}")
    declare -a array_values=("${!2}")
    local i=0
    local CONFIG_STR=''
    for key in "${array_keys[@]}"; do
        value="${array_values[${i}]}"
        sep=''
        if [ -n "$CONFIG_STR" ]; then sep="\n"; fi
        CONFIG_STR="${CONFIG_STR}${sep}${key}=${value}"
        ((i++))
    done
    _echo "$CONFIG_STR"
    return 0
}


#### LIBRARY VARS #############################################################################

#### verbose_mode ( 1/0 )
## This enables or disables the "verbose" mode.
## If it is enabled, the "quiet" mode is disabled.
##@env VERBOSE
verbose_mode () {
    if [ -n "$1" ] && ( [ "$1" = '1' ]||[ "$1" = 'true' ] ); then
        quiet_mode 0
        export VERBOSE=true
        return 0
    elif [ -n "$1" ] && ( [ "$1" = '0' ]||[ "$1" = 'false' ] ); then
        export VERBOSE=false
        return 0
    fi
    return 1
}

#### quiet_mode ( 1/0 )
## This enables or disables the "quiet" mode.
## If it is enabled, the "verbose" mode is disabled.
##@env QUIET
quiet_mode () {
    if [ -n "$1" ] && ( [ "$1" = '1' ]||[ "$1" = 'true' ] ); then
        debug_mode 0
        verbose_mode 0
        export QUIET=true
        return 0
    elif [ -n "$1" ] && ( [ "$1" = '0' ]||[ "$1" = 'false' ] ); then
        export QUIET=false
        return 0
    fi
    return 1
}

#### debug_mode ( 1/0 )
## This enables or disables the "debug" mode.
## If it is enabled, the "verbose" mode is enabled too and the "quiet" mode is disabled.
##@env DEBUG
debug_mode () {
    if [ -n "$1" ] && ( [ "$1" = '1' ]||[ "$1" = 'true' ] ); then
        verbose_mode 1
        export DEBUG=true
        return 0
    elif [ -n "$1" ] && ( [ "$1" = '0' ]||[ "$1" = 'false' ] ); then
        export DEBUG=false
        return 0
    fi
    return 1
}

#### interactive_mode ( 1/0 )
## This enables or disables the "interactive" mode.
## If it is enabled, the "forced" mode is disabled.
##@env INTERACTIVE
interactive_mode () {
    if [ -n "$1" ] && ( [ "$1" = '1' ]||[ "$1" = 'true' ] ); then
        forcing_mode 0
        export INTERACTIVE=true
        return 0
    elif [ -n "$1" ] && ( [ "$1" = '0' ]||[ "$1" = 'false' ] ); then
        export INTERACTIVE=false
        return 0
    fi
    return 1
}

#### forcing_mode ( 1/0 )
## This enables or disables the "forced" mode.
## If it is enabled, the "interactive" mode is disabled.
##@env INTERACTIVE
forcing_mode () {
    if [ -n "$1" ] && ( [ "$1" = '1' ]||[ "$1" = 'true' ] ); then
        interactive_mode 0
        export FORCED=true
        return 0
    elif [ -n "$1" ] && ( [ "$1" = '0' ]||[ "$1" = 'false' ] ); then
        export FORCED=false
        return 0
    fi
    return 1
}

#### dryrun_mode ( 1/0 )
## This enables or disables the "dry-run" mode.
## If it is enabled, the "interactive" and "forced" modes are disabled.
##@env DRYRUN
dryrun_mode () {
    if [ -n "$1" ] && ( [ "$1" = '1' ]||[ "$1" = 'true' ] ); then
        forcing_mode 0
        interactive_mode 0
        export DRYRUN=true
        verecho "- dry-run option enabled: commands shown as 'debug >> \"cmd\"' are not executed"
        return 0
    elif [ -n "$1" ] && ( [ "$1" = '0' ]||[ "$1" = 'false' ] ); then
        export DRYRUN=false
        return 0
    fi
    return 1
}

#### set_working_directory ( path )
## handles the '-d' option for instance
## throws an error if 'path' does not exist
set_working_directory () {
    if [ -n "$1" ]
    then
        local _wd="$(resolve "$1")"
        if [ -d "$1" ]
            then export WORKINGDIR="$_wd"
            else path_error "$1"
        fi
        cd "$WORKINGDIR"
        return 0
    else
        echo "set_working_directory: empty argument!" >&2; return 1;
    fi
}

#### set_log_filename ( path )
## handles the '-l' option for instance
set_log_filename () {
    if [ -n "$1" ]
    then
        export LOGFILE="$1"; return 0;
    else
        echo "set_log_filename: empty argument!" >&2; return 1;
    fi
}

##@ ECHOCMD (read-only: 'builtin' or 'gnu')
## Test if 'echo' is shell builtin or program
if [ "$($(which echo) --version)" = '--version' ]
then declare -rx ECHOCMD='builtin' 2>/dev/null;
else declare -rx ECHOCMD='gnu' 2>/dev/null;
fi

#### _echo ( string )
## echoes the string with the true 'echo -e' command
## use this for colorization
_echo () {
#    tput sgr0
    case "$ECHOCMD" in
        gnu) $(which echo) -e "$*";;
        builtin) echo "$*";;
    esac
    return 0
}

#### _necho ( string )
## echoes the string with the true 'echo -en' command
## use this for colorization and no new line
_necho () {
#    tput sgr0
    case "$ECHOCMD" in
        gnu) $(which echo) -en "$*";;
        builtin) echo -n "$*" >&2;;
    esac
    return 0
}

#### prompt ( string , default = y , options = Y/n )
## prompt user a string proposing different response options and selecting a default one
## final user fill is loaded in USERRESPONSE
prompt () {
    if [ $# -eq 0 ]; then return 0; fi
    local add=''
    if [ -n "$3" ]; then add+="[${3}] "; fi
    colored=$(colorize "?  >> ${1} ?" bold)
    _necho "${colored} ${add}" >&2
    read answer
    export USERRESPONSE="${answer:-${2}}"
    return 0
}

#### selector_prompt ( list[@] , string , list_string , default = 1 )
## prompt user a string proposing an indexed list of answers for selection
##+ and returns a valid result (user is re-prompted while the answer seems not correct)
## NOTE - the 'list' MUST be passed like `list[@]` (no quotes and dollar sign)
## final user choice is loaded in USERRESPONSE
selector_prompt () {
    if [ $# -eq 0 ]; then return 0; fi
    local list=( "${!1}" )
    local list_count="${#list[@]}"
    local string="$2"
    local list_string="$3"
    local selected=0
    local first_time=1
    while [ "$selected" -lt 1 ]||[ "$selected" -gt "$list_count" ]; do
        if [ "$first_time" -eq 0 ]
        then
            echo "! - Unknown index '${selected}'"
            prompt "Please select a value in the list (use indexes between brackets)" "${3:-1}"
        else
            first_time=0
            if [ ! -z "$string" ]; then echo "> ${list_string}:"; fi
            for i in "${!list[@]}"; do echo "    - [$((i + 1))] ${list[$i]}"; done
            prompt "$string" "${3:-1}"
        fi
        selected="$USERRESPONSE"
    done
    export USERRESPONSE="${list[$((selected - 1))]}"
    return 0
}

#### verbose_echo ( string )
## Echoes the string(s) in "verbose" mode.
verbose_echo () {
    if [ "$VERBOSE" = 'true' ]; then _echo "$*"; fi; return 0;
}

#### / verecho ( string )
## alias of 'verbose_echo'
verecho () { verbose_echo $*; return "$?"; }

#### quiet_echo ( string )
## Echoes the string(s) in not-"quiet" mode.
quiet_echo () {
    if [ "$QUIET" != 'true' ]; then _echo "$*"; fi; return 0;
}

#### / quietecho ( string )
## alias of 'quiet_echo'
quietecho () { quiet_echo $*; return "$?"; }

#### debug_echo ( string )
## Echoes the string(s) in "debug" mode.
debug_echo () {
    if [ "$DEBUG" = 'true' ]; then _echo "$*"; fi; return 0;
}

#### / debecho ( string )
## alias of 'debug_echo'
debecho () { debug_echo $*; return "$?"; }

#### evaluate ( command )
## evaluates the command catching events:
## - stdout is loaded in global `$CMD_OUT`
## - stderr is loaded in global `$CMD_ERR`
## - final status is loaded in global `$CMD_STATUS`
##@env CMD_OUT CMD_ERR CMD_STATUS : loaded with evaluated command's STDOUT, STDERR and STATUS
##@error will end with any caught error (exit status !=0)
evaluate () {
    unset CMD_OUT CMD_ERR CMD_STATUS
    local f_out=$(mktemp);
    local f_err=$(mktemp);
    eval "($*) 1>$f_out 2>$f_err;";
    CMD_STATUS="$?";
    CMD_OUT="$(cat "$f_out")" && rm -f "$f_out";
    CMD_ERR="$(cat "$f_err")" && rm -f "$f_err";
    echo "$CMD_OUT" >&1;
    echo "$CMD_ERR" >&2;
    export CMD_OUT CMD_ERR CMD_STATUS
    return "$CMD_STATUS"
}

#### debug_evaluate ( command )
## evaluates the command if "dryrun" is "off", just write it on screen otherwise
debug_evaluate () {
    if [ $# -eq 0 ]; then return 0; fi
    unset CMD_OUT CMD_ERR CMD_STATUS
    if [ "$DRYRUN" = 'true' ]
    then
        _echo "$(colorize 'dry-run >>' bold) \"$*\""
        local status=0
    else
        debug_echo "$(colorize '>>' bold) \"$*\""
        unset CMD_OUT CMD_ERR CMD_STATUS
        evaluate "$@" 1>/dev/null 2>&1
        [ ! -z "$CMD_OUT" ] && echo "$CMD_OUT" >&1
        [ ! -z "$CMD_ERR" ] && echo "$CMD_ERR" >&2
        local status="$CMD_STATUS"
    fi
    return "$status"
}

#### / debevaluate ( command )
## alias of 'debug_evaluate'
debevaluate () { debug_evaluate "$1"; return "$?"; }

#### / debeval ( command )
## alias of 'debug_evaluate'
debeval () { debug_evaluate "$1"; return "$?"; }

#### interactive_evaluate ( command , debug_exec = true )
## evaluates the command after user confirmation if "interactive" is "on"
interactive_evaluate () {
    if [ $# -eq 0 ]; then return 0; fi
    local DEBEXECUTION="${2:-true}"
    if [ "$INTERACTIVE" = 'true' ]; then
        prompt "Run command: \"$1\"" "y" "Y/n"
        while true; do
            case "$USERRESPONSE" in
                [yY]* ) break;;
                * ) _echo "_ no"; return 0; break;;
            esac
        done
    fi
    cmd_fct="${FUNCNAME[2]}"
    cmd_line="${BASH_LINENO[1]}"
    if [ "$DEBEXECUTION" = 'true' ]
    then
        debug_evaluate "$1"
    else
        evaluate "$1"
    fi
    if [ "$CMD_STATUS" -ne 0 ]; then
        error "error on execution: ${CMD_ERR}" "$CMD_STATUS" "$cmd_fct" "$cmd_line"
    fi
    return "${CMD_STATUS:-0}"
}

#### / ievaluate ( command )
## alias of 'interactive_evaluate'
ievaluate () { interactive_evaluate "$1" "${2:-true}"; return "$?"; }

#### / ieval ( command )
## alias of 'interactive_evaluate'
ieval () { interactive_evaluate "$1" "${2:-true}"; return "$?"; }

#### execute ( command )
## executes the command with outputs and status handling
execute () {
    if [ $# -eq 0 ]; then return 0; fi
    cmd_fct="${FUNCNAME[1]}"
    cmd_line="${BASH_LINENO[1]}"
    cmd_out="$( eval "$1" 2>&1 )"
    cmd_status="$?"
    if [ -n "$cmd_status" ] && [ "$cmd_status" -eq '0' ]; then
        echo "$cmd_out"
        return "$cmd_status"
    else
        error "error on execution: ${cmd_out}" "$cmd_status" "$cmd_fct" "$cmd_line"
        return "$?"
    fi
}

#### debug_execute ( command )
## execute the command if "dryrun" is "off", just write it on screen otherwise
debug_execute () {
    if [ $# -eq 0 ]; then return 0; fi
    if [ "$DRYRUN" = 'true' ]
    then
        _echo "$(colorize 'dry-run >>' bold) \"$1\""
        return 0
    else
        debug_echo "$(colorize '>>' bold) \"$1\""
        execute "$1"
        return "$?"
    fi
}

#### / debug_exec ( command )
## alias of 'debug_execute'
debug_exec () { debug_execute "$1"; return "$?"; }

#### / debexec ( command )
## alias of 'debug_execute'
debexec () { debug_execute "$1"; return "$?"; }

#### interactive_execute ( command , debug_exec = true )
## executes the command after user confirmation if "interactive" is "on"
##@return
interactive_execute () {
    if [ $# -eq 0 ]; then return 0; fi
    local DEBEXECUTION="${2:-true}"
    if [ "$INTERACTIVE" = 'true' ]; then
        prompt "Run command: \"$1\"" "y" "Y/n"
        while true; do
            case "$USERRESPONSE" in
                [yY]* ) break;;
                * ) _echo "_ no"; return 1; break;;
            esac
        done
    fi
    if [ "$DEBEXECUTION" = 'true' ]
    then
        debug_execute "$1"
        return "$?"
    else
        execute "$1"
        return "$?"
    fi
}

#### / interactive_exec ( command , debug_exec = true )
## alias of 'interactive_execute'
interactive_exec () { interactive_execute "$1" "${2:-true}"; return "$?"; }

#### / iexec ( command , debug_exec = true )
## alias of 'interactive_execute'
iexec () { interactive_execute "$1" "${2:-true}"; return "$?"; }


#### MESSAGES / ERRORS #############################################################################

#### info ( string, bold = true )
## writes the string on screen and return
info () {
    if [ $# -eq 0 ]; then return 0; fi
    local USEBOLD="${2:-true}"
    if [ "$USEBOLD" = 'true' ]
        then _echo "$(colorize "   >> ${1}" bold "${COLOR_INFO}")"
        else _echo "$(colorize '   >>' bold) ${1}"
    fi
    return 0
}

#### warning ( string , funcname = FUNCNAME[1] , line = BASH_LINENO[1] , tab='    ' )
## writes the error string on screen and return
warning () {
    if [ $# -eq 0 ]; then return 0; fi
    local TAG="${4:-    }"
    local PADDER=$(printf '%0.1s' " "{1..1000})
    local LINELENGTH="$(tput cols)"
    local FIRSTLINE="${TAG}[at ${3:-${FUNCNAME[1]}} line ${4:-${BASH_LINENO[1]}}]"
    local SECONDLINE="$(colorize "${TAG}!! >> ${1:-unknown warning}" bold)"
    printf -v TMPSTR \
        "%*.*s\\\n%-*s\\\n%-*s\\\n%*.*s" \
        0 "$LINELENGTH" "$PADDER" \
        $((LINELENGTH - $(string_length "$FIRSTLINE"))) "$FIRSTLINE" \
        $((LINELENGTH - $(string_length "$SECONDLINE"))) "${SECONDLINE}<${COLOR_WARNING}>";
    parse_color_tags "\n<${COLOR_WARNING}>${TMPSTR}</${COLOR_WARNING}>\n"
    return 0
}

#### error ( string , status = 90 , funcname = FUNCNAME[1] , line = BASH_LINENO[1] , tab='   ' )
## writes the error string on screen and then exit with an error status
##@error default status is E_ERROR (90)
error () {
    local TAG="${5:-    }"
    local PADDER=$(printf '%0.1s' " "{1..1000})
    local LINELENGTH=$(tput cols)
    local ERRSTRING="${1:-unknown error}"
    local ERRSTATUS="${2:-${E_ERROR}}"
    if [ -n "$LOGFILEPATH" ]; then log "${ERRSTRING}" "error:${ERRSTATUS}"; fi
    local FIRSTLINE="${TAG}[at ${3:-${FUNCNAME[1]}} line ${4:-${BASH_LINENO[1]}}] (to get help, try option '--help')"
    local SECONDLINE="$(colorize "${TAG}!! >> ${ERRSTRING}" bold)"
    printf -v TMPSTR \
        "%*.*s\\\n%-*s\\\n%-*s\\\n%*.*s" \
        0 "$LINELENGTH" "$PADDER" \
        "$((LINELENGTH - $(string_length "$FIRSTLINE")))" "$FIRSTLINE" \
        "$((LINELENGTH - $(string_length "$SECONDLINE")))" "${SECONDLINE}<${COLOR_ERROR}>";
    parse_color_tags "\n<${COLOR_ERROR}>${TMPSTR}</${COLOR_ERROR}>\n" >&2
    exit "$ERRSTATUS"
}

#### get_synopsis_string ( short_opts=OPTIONS_ALLOWED , long_opts=LONG_OPTIONS_ALLOWED )
## builds a synopsis string using script's declared available options
get_synopsis_string () {
    local shortopts="${1:-${OPTIONS_ALLOWED}}"
    local longopts="${2:-${LONG_OPTIONS_ALLOWED}}"
    local -a short_options=( $(get_short_options_array "$shortopts") )
    local -a long_options=( $(get_long_options_array "$longopts") )
    local short_options_string=''
    local long_options_string=''
    local i=1
    for o in "${short_options[@]}"; do
        short_options_string+="${o//:/}"
        if [ "$i" -lt "${#short_options[@]}" ]; then
            short_options_string+='|'
        fi
        i=$((i + 1))
    done
    i=1
    for o in "${long_options[@]}"; do
        long_options_string+="${o//:/}"
        if [ "$i" -lt "${#long_options[@]}" ]; then
            long_options_string+='|'
        fi
        i=$((i + 1))
    done
    synopsis="${0}  [-${short_options_string}]\n\t[--${long_options_string}]\n\t[--]  <arguments>";
    echo "$synopsis"
    return 0
}

#### simple_synopsis ()
## writes a synopsis string using script's declared available options
simple_synopsis () {
    printf "$(parse_color_tags "<bold>usage:</bold> %s \nRun option '--help' for help.")" "$(get_synopsis_string)";
    echo
    return 0
}

#### simple_usage ( synopsis = SYNOPSIS_ERROR )
## writes a synopsis usage info
simple_usage () {
    local USAGESTR=''
    if [ ! -z "${1:-}" ]; then
        if [ "$1" = 'lib' ]; then
            USAGESTR="$(_echo "$COMMON_SYNOPSIS")"
        elif [ "$1" = 'action' ]; then
            USAGESTR="$(_echo "$COMMON_SYNOPSIS_ACTION")"
        else
            USAGESTR="$(_echo "$1")"
        fi
    elif [ -n "$SYNOPSIS_ERROR" ]; then
        USAGESTR="$(_echo "$SYNOPSIS_ERROR")"
    else
        USAGESTR="$(_echo "$COMMON_SYNOPSIS_ERROR")"
    fi
    printf "$(parse_color_tags "<bold>usage:</bold> %s \nRun option '--help' for help.")" "$USAGESTR";
    echo
    return 0
}

#### simple_error ( string , status = 90 , synopsis = SYNOPSIS_ERROR , funcname = FUNCNAME[1] , line = BASH_LINENO[1] )
## writes an error string as a simple message with a synopsis usage info
##@error default status is E_ERROR (90)
simple_error () {
    local ERRSTRING="${1:-unknown error}"
    local ERRSTATUS="${2:-${E_ERROR}}"
    if [ "$DEBUG" = 'true' ]; then
        ERRSTRING=$(gnu_error_string "${ERRSTRING}" '' "${3}" "${4}")
    fi
    if [ -n "$LOGFILEPATH" ]; then log "$ERRSTRING" "error:${ERRSTATUS}"; fi
    printf "$(parse_color_tags "<bold>error:</bold> %s")" "$ERRSTRING" >&2;
    echo >&2
    simple_usage "${3:-}" >&2
    exit "$ERRSTATUS"
}

#### simple_error_multi ( array[@] , status = 90 , synopsis = SYNOPSIS_ERROR , funcname = FUNCNAME[1] , line = BASH_LINENO[1] )
## writes multiple errors strings as a simple message with a synopsis usage info
##@error default status is E_ERROR (90)
simple_error_multi () {
    local -a ERRSTACK=( "${!1:-unknown error}" )
    local ERRSTATUS="${2:-${E_ERROR}}"
    for ERRSTRING in "${ERRSTACK[@]}"; do
        if [ "$DEBUG" = 'true' ]; then
            ERRSTRING=$(gnu_error_string "${ERRSTRING}" '' "${3}" "${4}")
        fi
        if [ -n "$LOGFILEPATH" ]; then log "$ERRSTRING" "error:${ERRSTATUS}"; fi
        printf "$(parse_color_tags "<bold>error:</bold> %s")" "$ERRSTRING" >&2;
        echo >&2
    done
    simple_usage "${3:-}" >&2
    exit "$ERRSTATUS"
}

#### dev_error ( string , status = 90 , filename = BASH_SOURCE[2] , funcname = FUNCNAME[2] , line = BASH_LINENO[2] )
## print a formated error string with dev info using the 'caller' stack trace and exit
## print a full back trace it `VERBOSE=true`
dev_error () {
    local ERRSTRING="${1:-unknown error}"
    local ERRSTATUS="${2:-${E_ERROR}}"
    echo
    gnu_error_string "$ERRSTRING" "${3:-${BASH_SOURCE[2]}}" "${4:-${FUNCNAME[2]}}" "${5:-${BASH_LINENO[2]}}" >&2
    echo
    if [ "$VERBOSE" = 'true' ]
    then
        get_stack_trace
        echo "this is [${SHELL} ${BASH_VERSION}]"
    else
        echo "use option '--verbose' to get a stack trace."
    fi
    echo "use option '--help' to get help."
    exit "$ERRSTATUS"
}

#### get_stack_trace ( first_item = 0 )
## get a formated stack trace
get_stack_trace () {
    echo "Stack trace:"
    local i="${1:-0}"
    for t in "${BASH_SOURCE[@]}"; do
        if [ "$i" -lt "$(("${#BASH_SOURCE[@]}" - 1))" ]
        then echo "#${i} '${FUNCNAME[${i}]} ()' : called in '${BASH_SOURCE[$((i+1))]}' at line ${BASH_LINENO[${i}]}"
        else echo "#${i} ${BASH_SOURCE[${i}]} : ${FUNCNAME[${i}]}"
        fi
        i=$((i + 1))
    done
    return 0
}

#### gnu_error_string ( string , filename = BASH_SOURCE[2] , funcname = FUNCNAME[2] , line = BASH_LINENO[2] )
## must echoes something like 'sourcefile:lineno: message'
gnu_error_string () {
    local errorstr=''
    local _source="${2:-${BASH_SOURCE[2]}}"
    if [ -n "$_source" ]; then errorstr+="${_source}:"; fi
    local _func="${3:-${FUNCNAME[2]}}"
    if [ -n "$_func" ]; then errorstr+="${_func}:"; fi
    local _line="${4:-${BASH_LINENO[2]}}"
    if [ -n "$_line" ]; then errorstr+="${_line}:"; fi
    echo "${errorstr} ${1}"
    return 0
}

#### no_option_error ()
## no script option error
##@error exits with status E_OPTS (81)
no_option_error () {
    error "No option or argument not understood ! Nothing to do ..." "${E_OPTS}" \
        "${FUNCNAME[1]}" "${BASH_LINENO[0]}";
}

#### no_option_simple_error ()
## no script option simple error
##@error exits with status E_OPTS (81)
no_option_simple_error () {
    simple_error "No option or argument not understood ! Nothing to do ..." "${E_OPTS}" \
        "${FUNCNAME[1]}" "${BASH_LINENO[0]}";
}

#### unknown_option_error ( option )
## invalid script option error
##@error exits with status E_OPTS (81)
unknown_option_error () {
    error "Unknown option '${1:-?}'" "${E_OPTS}" \
        "${FUNCNAME[1]}" "${BASH_LINENO[0]}";
}

#### unknown_option_simple_error ( option )
## invalid script option simple error
##@error exits with status E_OPTS (81)
unknown_option_simple_error () {
    simple_error "Unknown option '${1:-?}'" "${E_OPTS}" \
        "${FUNCNAME[1]}" "${BASH_LINENO[0]}";
}

#### command_error ( cmd )
## command not found error
##@error exits with status E_CMD (82)
command_error () {
    error "'$1' command seems not installed on your machine ... The process can't be done !" \
        "${E_CMD}" "${FUNCNAME[1]}" "${BASH_LINENO[0]}";
}

#### command_simple_error ( cmd )
## command not found simple error
##@error exits with status E_CMD (82)
command_simple_error () {
    simple_error "'$1' command seems not installed on your machine ... The process can't be done !" \
        "${E_CMD}" "${FUNCNAME[1]}" "${BASH_LINENO[0]}";
}

#### path_error ( path )
## path not found error
##@error exits with status E_PATH (83)
path_error () {
    error "Path '$1' (file or dir) can't be found ..." "${E_PATH}" \
        "${FUNCNAME[1]}" "${BASH_LINENO[0]}";
}

#### path_simple_error ( path )
## path not found simple error
##@error exits with status E_PATH (83)
path_simple_error () {
    simple_error "Path '$1' (file or dir) can't be found ..." "${E_PATH}" \
        "${FUNCNAME[1]}" "${BASH_LINENO[0]}";
}


#### SCRIPT OPTIONS / ARGUMENTS #############################################################################

##@ ORIGINAL_SCRIPT_OPTS="$@" (read-only)
## Original list of raw command line arguments
declare -rx ORIGINAL_SCRIPT_OPTS="$@" 2>/dev/null;
##@ SCRIPT_PARAMS=''
## String of re-arranged parameters (options & arguments)
declare -x SCRIPT_PARAMS=''
##@ SCRIPT_PIPED_INPUT=''
## String of any piped content from previous command
declare -x SCRIPT_PIPED_INPUT=''
##@ SCRIPT_OPTS=()
## Array of options with arguments
declare -xa SCRIPT_OPTS=()
##@ SCRIPT_ARGS=()
## Array of script's arguments
declare -xa SCRIPT_ARGS=()
##@ SCRIPT_PROGRAMS=()
## Array of program's options
declare -xa SCRIPT_PROGRAMS=()
##@ SCRIPT_OPTS_ERRS=()
## Array of options errors
declare -ax SCRIPT_OPTS_ERRS=()
##@ ARGIND
## Integer of current argument index
declare -xi ARGIND=0
##@ ARGUMENT
## Current argument string (see `ARGIND`)
declare -x ARGUMENT=''

## Options errors messages
declare -rx UNKNOWN_OPTION_MASK="unknown option '%s'!" 2>/dev/null;
declare -rx MISSING_OPTION_ARGUMENT_MASK="option '%s' requires an argument!" 2>/dev/null;

#### read_from_pipe ( file=/dev/stdin )
read_from_pipe () {
    local fpipe="${1:-/dev/stdin}"
    local fpipedir="$(dirname "$fpipe")"
    if [ -e "$fpipe" ] && [ -p "$fpipe" ]; then
#        while [[ -L "$fpipe" ]]; do
#            fpipe="$(readlink "$fpipe")"
#            if [ ! -e "$fpipe" ]; then
#                fpipe="${fpipedir}/${fpipe}"
#            fi
#        done
        SCRIPT_PIPED_INPUT="$(cat "$fpipe")"
    fi
    export SCRIPT_PIPED_INPUT
}

#### get_short_options_array ( short_opts=OPTIONS_ALLOWED )
get_short_options_array () {
    local shortopts="${1:-${OPTIONS_ALLOWED}}"
    local -a short_options=()
    local shortoptions="${shortopts//-:/}"
    explode_letters "$shortoptions"
    local b=''
    for i in "${EXPLODED_ARRAY[@]}"; do
        if [ "$i" = ':' ] && [ -n "$b" ]; then
            b="${b}${i}"
        elif [ "$i" != '-' ]; then
            [ -n "$b" ] && short_options+=( "$b" );
            b="$i"
        else
            [ -n "$b" ] && short_options+=( "$b" );
            b=''
        fi
    done
    [ -n "$b" ] && short_options+=( "$b" );
    echo "${short_options[@]}"
    return 0
}

#### get_short_options_string ( delimiter = '|' , short_opts=OPTIONS_ALLOWED )
get_short_options_string () {
    local delimiter="${1:-|}"
    local shortopts="${2:-${OPTIONS_ALLOWED}}"
    local -a short_options=( $(get_short_options_array "$shortopts") )
    implode short_options[@] "${delimiter}"
    return 0
}

#### get_option_declaration ( option_name , short_opts=OPTIONS_ALLOWED )
get_option_declaration () {
    local _optname="$1"
    local shortopts="${2:-${OPTIONS_ALLOWED}}"
    local -a opts_table=( $(get_options_array "$shortopts") )
    local optiondef_ind=$(array_search "$_optname" "${opts_table[@]}")
    [ -z "$optiondef_ind" ] && optiondef_ind=$(array_search "${_optname}:" "${opts_table[@]}");
    [ -z "$optiondef_ind" ] && optiondef_ind=$(array_search "${_optname}::" "${opts_table[@]}");
    echo "${opts_table[${optiondef_ind}]}"
    return 0
}

#### get_option_argument ( "$x" )
## echoes the argument of an option
get_option_argument () {
    if [ -n "$1" ]; then echo "${1#=}"; fi; return 0;
}

#### / get_option_arg ( "$x" )
## alias of 'get_option_argument'
get_option_arg () { get_option_argument $*; return "$?"; }

#### get_long_options_array ( long_opts=LONG_OPTIONS_ALLOWED )
get_long_options_array () {
    local longopts="${1:-${LONG_OPTIONS_ALLOWED}}"
    local -a long_options=()
    explode "$longopts" ","
    for i in "${EXPLODED_ARRAY[@]}"; do
        long_options+=( "$i" )
    done
    echo "${long_options[@]}"
    return 0
}

#### get_long_options_string ( delimiter = '|' , long_opts=LONG_OPTIONS_ALLOWED )
get_long_options_string () {
    local delimiter="${1:-|}"
    local longopts="${2:-${LONG_OPTIONS_ALLOWED}}"
    local -a long_options=( $(get_long_options_array "$longopts") )
    implode long_options[@] "$delimiter"
    return 0
}

#### get_long_option_declaration ( option_name , long_opts=LONG_OPTIONS_ALLOWED )
get_long_option_declaration () {
    local _optname="$1"
    local longopts="${2:-${LONG_OPTIONS_ALLOWED}}"
    local -a opts_table=( $(get_long_options_array "$longopts") )
    local optiondef_ind=$(array_search "$_optname" "${opts_table[@]}")
    [ -z "$optiondef_ind" ] && optiondef_ind=$(array_search "${_optname}:" "${opts_table[@]}");
    [ -z "$optiondef_ind" ] && optiondef_ind=$(array_search "${_optname}::" "${opts_table[@]}");
    echo "${opts_table[${optiondef_ind}]}"
    return 0
}

#### get_long_option_name ( "$x" )
## echoes the name of a long option
get_long_option_name () {
    local arg="$1"
    if [ -n "$arg" ]; then
        if [[ "$arg" =~ .*=.* ]]; then arg="${arg%=*}"; fi
        echo "$arg" | cut -d " " -f1
        return 0
    fi
    return 1
}

#### / get_long_option ( "$x" )
## alias of 'get_long_option_name()'
get_long_option () { get_long_option_name $*; return "$?"; }

#### get_long_option_argument ( "$x" )
## echoes the argument of a long option
get_long_option_argument () {
    local arg=''
    local argstr="$1"
    if [ -n "$argstr" ]; then
        [[ "$argstr" =~ .*\ .* ]] && arg="$(echo "$argstr" | cut -d " " -f2-)";
        [[ "$argstr" =~ .*=.* ]] && arg="${argstr#*=}";
        [[ "$argstr" != "$arg" ]] && echo "$arg";
        return 0
    fi
    return 1
}

#### / get_long_option_arg ( "$x" )
## alias of 'get_long_option_argument'
get_long_option_arg () { get_long_option_argument $*; return "$?"; }

##@ LONGOPTNAME=''
## The name of current long option treated
declare -x LONGOPTNAME=''
##@ LONGOPTARG=''
## The argument set for current long option
declare -x LONGOPTARG=''

#### parse_long_option ( $OPTARG , ${!OPTIND} )
## This will parse and retrieve the name and argument of current long option.
parse_long_option () {
    [ $# -eq 0 ] && return 1;
    local _optarg="$1"
    local _nextarg="${2:-}"
    LONGOPTNAME="$(get_long_option "$_optarg")"
    LONGOPTARG="$(get_long_option_arg "$_optarg")"
    local optiondef="$(get_long_option_declaration "$LONGOPTNAME")"
#    if [ -z "$LONGOPTARG" ] && [ "${optiondef: -1}" = ':' ] && [ "${optiondef: -2}" != '::' ]; then
    if [ -z "$LONGOPTARG" ] && [ "${optiondef: -1}" = ':' ]; then
        LONGOPTARG="$_nextarg"
        ((OPTIND++))
    fi
    LONGOPTARG="$(echo "$LONGOPTARG" | sed -e "s/^'//" -e "s/'$//")"
    export LONGOPTNAME LONGOPTARG OPTIND
    return 0
}

#### init_arguments ()
## init the script arguments treatment putting `ARGIND` on `1` if arguments exist
init_arguments () {
    if [ "${#SCRIPT_ARGS[@]}" -gt 0 ]; then
        export ARGIND=1
    fi
    return 0
}

#### getargs ( VAR_NAME )
## method to loop over command line's arguments just like `getopts` does for options
## this will load current argument's value in `VAR_NAME` and increment `ARGIND` at each turn
getargs () {
    local argvar="${1:-ARGUMENT}"
    get_next_argument
    local _status=$?
    if [ "$ARGIND" -eq 0 ]||[ "$_status" -ne 0 ]; then
        return 1
    fi
    if [ "$argvar" != 'ARGUMENT' ]; then
        eval "export $argvar=\"$ARGUMENT\"";
    fi
    return 0
}

#### get_next_argument ()
## get next script argument according to current `ARGIND`
## load it in `ARGUMENT` and let `ARGIND` incremented
get_next_argument () {
    local argsnum="${#SCRIPT_ARGS[@]}"
    if [ "${#SCRIPT_ARGS[@]}" -gt 0 ] && [ "$ARGIND" -lt "$((argsnum + 1))" ]
    then
        ARGUMENT="${SCRIPT_ARGS[$((ARGIND - 1))]}"
        ((ARGIND++))
        export ARGIND ARGUMENT
        return 0
    else
        return 1
    fi
}

#### get_last_argument ()
## echoes the last script argument
get_last_argument () {
    if [ "${#SCRIPT_ARGS[@]}" -gt 0 ]
    then
        echo "${SCRIPT_ARGS[${#SCRIPT_ARGS[@]}-1]}"
        return 0
    else
        return 1
    fi
}

#### rearrange_script_options_new ( "$0" , "$@"  )
rearrange_script_options_new () {
    getopt --test > /dev/null
    local _vers="$?"
    if [ -n "$_vers" ] && [ "$_vers" -ne 4 ]; then
        verecho "> your version of 'getopt' seems to be old! Processing alternative 'rearrange_script_options()' method."
        rearrange_script_options "$@"
        return 0
    fi
    local progname="$1"
    shift
    # use '--alernative' option to allow single dash for long options
    SCRIPT_PARAMS="$(getopt --quiet --shell 'bash' --options "$OPTIONS_ALLOWED" --longoptions "$LONG_OPTIONS_ALLOWED" --name "$progname" -- "$@")"
    local _ret="$?"
    case "$_ret" in
        2) error "an internal 'getopt' error occurred!";;
        3) error "an internal error occurred while calling 'getopt'!";;
    esac
    if [ "$SCRIPT_PARAMS" = ' --' ]; then SCRIPT_PARAMS=''; fi
    export SCRIPT_PARAMS
    eval set -- "$SCRIPT_PARAMS"
    rearrange_script_options "$@"
    return 0
}

#### rearrange_script_options ( "$@" )
## this will separate script options from script arguments (emulation of GNU "getopt")
## options are loaded in $SCRIPT_OPTS with their arguments
## arguments are loaded in $SCRIPT_ARGS
rearrange_script_options () {
    SCRIPT_OPTS=()
    SCRIPT_ARGS=()
    local oldoptind="$OPTIND"
    local -a params=( "$@" )
    local numargs="${#params[@]}"
    local -a longopts_table=( $(get_long_options_array) )
    local firstoptdone=false
    local firstchar
    local arg
    if [ -z "$SCRIPT_PARAMS" ]; then
        for i in "${!params[@]}"; do
            arg="${params[${i}]}"
            firstchar="${arg:0:1}"
            if [ "$firstchar" != "-" ]
                then SCRIPT_ARGS+=( "$arg" )
                elif [ "$firstoptdone" != 'true' ]; then firstoptdone=true;
            fi
            if [ "$firstoptdone" != 'true' ]; then unset params["$i"]; fi
        done
    fi
    OPTIND=1
    local eoo=false
    while getopts ":${OPTIONS_ALLOWED}" OPTION "${params[@]-}"; do
        OPTNAME="$OPTION"
        OPTARG="$(get_option_arg "${OPTARG:-}")"
        local argindex=false
        case "$OPTNAME" in
            -)  LONGOPTNAME="$(get_long_option "$OPTARG")"
                LONGOPTARG="$(get_long_option_arg "$OPTARG")"
                optiondef=$(get_long_option_declaration "$LONGOPTNAME")
                if [ -z "$LONGOPTARG" ] && [ "${optiondef: -1}" = ':' ]; then
                    if [ -z "$SCRIPT_PARAMS" ]; then
                        ((OPTIND++))
                    fi
                    if [ "${!OPTIND:0:1}" != '-' ]
                    then
                        LONGOPTARG="${!OPTIND}"
                        if [ -n "$SCRIPT_PARAMS" ]; then
                            ((OPTIND++))
                        fi
                    fi
                fi
                case "$LONGOPTNAME" in
                    -)  eoo=true;
                        ((OPTIND++))
                        break;;
                    *)  if [ ! -z "$LONGOPTARG" ] && [ "$LONGOPTNAME" != "$LONGOPTARG" ]; then
                            SCRIPT_OPTS+=( "--${LONGOPTNAME}='${LONGOPTARG}'" )
                            SCRIPT_ARGS=( "${SCRIPT_ARGS[@]//${LONGOPTARG}}" )
                        else
                            SCRIPT_OPTS+=( "--${LONGOPTNAME}" )
                        fi;;
                esac ;;
            \?)
                SCRIPT_ARGS+=( "-${OPTION}" )
                ;;
            *)  if [ "$eoo" != 'true' ]; then
                    if [ ! -z "$OPTARG" ]; then
                        SCRIPT_OPTS+=( "-${OPTION}='${OPTARG}'" )
                        SCRIPT_ARGS=( "${SCRIPT_ARGS[@]//${OPTARG}}" )
                    else
                        SCRIPT_OPTS+=( "-${OPTION}" )
                    fi
                fi;;
        esac
    done
    if [ -z "$SCRIPT_PARAMS" ]; then
        ((OPTIND++))
    fi
    while [ "$OPTIND" -lt $((numargs + 1)) ]; do
        if [ "${!OPTIND}" != '--' ]; then
            if [ -z "$SCRIPT_PARAMS" ]; then
                SCRIPT_ARGS=( "${SCRIPT_ARGS[@]//${!OPTIND}}" )
            fi
            SCRIPT_ARGS+=( "${!OPTIND}" )
        fi
        ((OPTIND++))
    done
    OPTIND="$oldoptind"
    SCRIPT_ARGS=( $(array_filter "${SCRIPT_ARGS[@]-}") )
    if [ -z "$SCRIPT_PARAMS" ]; then
        if [ "${#SCRIPT_OPTS[@]}" -gt 0 ] && [ "${#SCRIPT_ARGS[@]}" -eq 0 ];
            then SCRIPT_PARAMS="${SCRIPT_OPTS[*]}";
        elif [ "${#SCRIPT_OPTS[@]}" -eq 0 ] && [ "${#SCRIPT_ARGS[@]}" -gt 0 ];
            then SCRIPT_PARAMS="${SCRIPT_ARGS[*]}";
        elif [ "${#SCRIPT_OPTS[@]}" -gt 0 ] && [ "${#SCRIPT_ARGS[@]}" -gt 0 ];
            then SCRIPT_PARAMS="${SCRIPT_OPTS[*]} -- ${SCRIPT_ARGS[*]}";
        fi
    fi
    init_arguments
    export OPTIND SCRIPT_OPTS SCRIPT_ARGS SCRIPT_PARAMS
    return 0
}

#### parse_common_options_strict ( "$@" = SCRIPT_OPTS )
## parse common script options as described in $COMMON_OPTIONS_INFO throwing an error for unknown options
## this will stop options treatment at '--'
parse_common_options_strict () {
    if [ $# -gt 0 ]
        then parse_common_options "$@"
        else parse_common_options
    fi
    if [ "${#SCRIPT_OPTS[@]}" -gt 0 ] && [ "${#SCRIPT_ARGS[@]}" -eq 0 ]; then set -- "${SCRIPT_OPTS[@]}";
    elif [ "${#SCRIPT_OPTS[@]}" -eq 0 ] && [ "${#SCRIPT_ARGS[@]}" -gt 0 ]; then set -- "${SCRIPT_ARGS[@]}";
    elif [ "${#SCRIPT_OPTS[@]}" -gt 0 ] && [ "${#SCRIPT_ARGS[@]}" -gt 0 ]; then set -- "${SCRIPT_OPTS[@]}" -- "${SCRIPT_ARGS[@]}";
    fi
    local -a params=( "$@" )
    local numargs="${#params[@]}"
    local -a short_options=( $(get_short_options_array) )
    local -a long_options=( $(get_long_options_array) )
    local oldoptind="$OPTIND"
    local argreq=false
    local prevopt
    OPTIND=1
    while [ "$OPTIND" -lt $((numargs + 1)) ]; do
        opt="${!OPTIND}"
        if [ "$opt" = '--' ]
        then
            break;
        elif [ "${opt:0:2}" = '--' ]
        then
            if [ "$argreq" = 'true' ]; then
                SCRIPT_OPTS_ERRS+=("$(printf "$MISSING_OPTION_ARGUMENT_MASK" "$prevopt")")
            fi
            OPTARG="${opt:2}"
            LONGOPT="$(get_long_option "$OPTARG")"
            LONGOPTARG="$(get_long_option_arg "$OPTARG")"
            prevopt="$LONGOPT"
            if
                ! in_array "$LONGOPT" "${long_options[@]}" &&
                ! in_array "${LONGOPT}:" "${long_options[@]}" &&
                ! in_array "${LONGOPT}::" "${long_options[@]}";
            then
                SCRIPT_OPTS_ERRS+=("$(printf "$UNKNOWN_OPTION_MASK" "$LONGOPT")")
                argreq=false
            else
                if in_array "${LONGOPT}:" "${long_options[@]}" && [ -z "$LONGOPTARG" ]; then
                    argreq=true
                else
                    argreq=false
                fi
            fi
        elif [ "${opt:0:1}" = '-' ]
        then
            if [ "$argreq" = 'true' ]; then
                SCRIPT_OPTS_ERRS+=("$(printf "$MISSING_OPTION_ARGUMENT_MASK" "$prevopt")")
            fi
            SHORTOPT="${opt:1:1}"
            SHORTOPTARG="$(get_option_arg "${opt:2}")"
            prevopt="$SHORTOPT"
            if
                ! in_array "$SHORTOPT" "${short_options[@]}" &&
                ! in_array "${SHORTOPT}:" "${short_options[@]}" &&
                ! in_array "${SHORTOPT}::" "${short_options[@]}";
            then
                SCRIPT_OPTS_ERRS+=("$(printf "$UNKNOWN_OPTION_MASK" "$SHORTOPT")")
            else
                if in_array "${SHORTOPT}:" "${short_options[@]}" && [ -z "$SHORTOPTARG" ]; then
                    argreq=true
                else
                    argreq=false
                fi
            fi
        else
            argreq=false
        fi
        ((OPTIND++))
    done
    if [ "${#SCRIPT_OPTS_ERRS[@]}" -gt 0 ]; then
        simple_error_multi SCRIPT_OPTS_ERRS[@] "$E_OPTS"
        return 1
    fi

#    while getopts ":${OPTIONS_ALLOWED}" OPTION; do
#        if [ "$OPTION" = '-' ]
#        then LONGOPT="$(get_long_option "$OPTARG")"
#            if ! in_array "$LONGOPT" "${long_options[@]}"; then
#                unknown_option_simple_error "$LONGOPT"
#            fi
#        else
#            if ! in_array "$OPTION" "${short_options[@]}"; then
#                unknown_option_simple_error "$OPTION"
#            fi
#        fi
#    done
    OPTIND="$oldoptind"
    export OPTIND SCRIPT_OPTS_ERRS
    return 0
}

#### parse_common_options ( "$@" = SCRIPT_OPTS )
## parse common script options as described in $COMMON_OPTIONS_INFO
## this will stop options treatment at '--'
parse_common_options () {
    local oldoptind="$OPTIND"
    local actiontodo
    if [ $# -gt 0 ]
        then local options=("$@")
        else local options=("${SCRIPT_OPTS[@]-}")
    fi
    while getopts ":${OPTIONS_ALLOWED}" OPTION "${options[@]}"; do
        OPTARG="$(get_option_arg "${OPTARG:-}")"
        case "$OPTION" in
        # common options
            f)  forcing_mode 1;;
            h)  if [ -z "$actiontodo" ]; then actiontodo='help'; fi;;
            i)  interactive_mode 1;;
            q)  quiet_mode 1;;
            v)  verbose_mode 1;;
            V)  if [ -z "$actiontodo" ]; then actiontodo='version'; fi;;
            x)  debug_mode 1;;
            -)  LONGOPTARG="$(get_long_option_arg "$OPTARG")"
                case "$OPTARG" in
        # common options
                    debug)      debug_mode 1;;
                    dry-run)    dryrun_mode 1;;
                    force)      forcing_mode 1;;
                    help)       if [ -z "$actiontodo" ]; then actiontodo='help'; fi;;
                    interactive) interactive_mode 1;;
                    man*)       if [ -z "$actiontodo" ]; then actiontodo='man'; fi;;
                    quiet)      quiet_mode 1;;
                    usage)      if [ -z "$actiontodo" ]; then actiontodo='usage'; fi;;
                    verbose)    verbose_mode 1;;
                    version)    if [ -z "$actiontodo" ]; then actiontodo='version'; fi;;
        # library options
                    libvers*)   if [ -z "$actiontodo" ]; then actiontodo='libversion'; fi;;
                    log*)       set_log_filename "$LONGOPTARG";;
                    working-dir*) set_working_directory "$LONGOPTARG";;
        # no error for others
                    *)  if [ -n "$LONGOPTARG" ] && [ "$(which "$OPTARG")" ]; then
                            SCRIPT_PROGRAMS+=( "$OPTARG" )
                        fi;;
                esac ;;
            *) continue;;
        esac
    done
    OPTIND="$oldoptind"
    export OPTIND SCRIPT_PROGRAMS
    if [ ! -z "$actiontodo" ]; then
        case "$actiontodo" in
            help) script_long_usage; exit 0;;
            usage) script_usage; exit 0;;
            man) script_manpage; exit 0;;
            version) script_version "$QUIET"; exit 0;;
            libversion) library_version "$QUIET"; exit 0;;
        esac
    fi
    return 0
}


#### SCRIPT INFO #####################################################################

#### get_script_version_string ( quiet = false )
get_script_version_string () {
    local gitvers="$(vcs_get_version)"
    if [ -n "$gitvers" ]
        then
            echo "$gitvers"
        else
            if [ -n "$VERSION" ]; then echo "$VERSION"; fi
    fi
    return 0
}

#### script_title ( lib = false )
## this function must echo an information about script NAME and VERSION
## setting `$lib` on true will add the library infos
script_title () {
    local TITLE="$NAME"
    if [ -n "$VERSION" ]; then TITLE="${TITLE} - v. [${VERSION}]"; fi
    _echo "$(colorize "##  ${TITLE}  ##" bold)"
    local _vers="$(get_version_string)"
    if [ -n "$_vers" ]; then
        _echo "[${_vers}]"
    elif [ -n "$DATE" ]; then
        _echo "[${DATE}]"
    fi
    if [ $# -gt 0 ]; then
        _echo "[using $(library_version) - ${LIB_SOURCES_URL}]"
    fi
    return 0
}

#### script_short_title ()
## this function must echo an information about script NAME and VERSION
script_short_title () {
    local TITLE="$NAME"
    if [ -n "$VERSION" ]; then TITLE="${TITLE} ${VERSION}"; fi
    local _vers="$(get_version_string)"
    if [ -n "$_vers" ]; then
        TITLE+=" [${_vers}]"
    elif [ -n "$DATE" ]; then
        TITLE+=" [${DATE}]"
    fi
    echo "$TITLE"
    return 0
}

#### script_usage ()
## this function must echo the simple usage
script_usage () {
    simple_usage
    return 0
}

#### script_long_usage ( synopsis = SYNOPSIS_ERROR , options_string = COMMON_OPTIONS_USAGE )
## writes a long synopsis usage info
script_long_usage () {
    local TMP_USAGE="$(parse_color_tags  "<bold>$(script_short_title)</bold>")"
    if [ -n "$DESCRIPTION_USAGE" ]; then
        TMP_USAGE+="\n${DESCRIPTION_USAGE}";
    elif [ -n "$DESCRIPTION" ]; then
        TMP_USAGE+="\n${DESCRIPTION}";
    fi
    local SYNOPSIS_STR=''
    if [ $# -gt 0 ]; then
        if [ "$1" = 'lib' ]; then
            SYNOPSIS_STR="$COMMON_SYNOPSIS"
        elif [ "$1" = 'action' ]; then
            SYNOPSIS_STR="$COMMON_SYNOPSIS_ACTION"
        else
            SYNOPSIS_STR="$1"
        fi
    elif [ -n "$SYNOPSIS_USAGE" ]; then
        SYNOPSIS_STR="$SYNOPSIS_USAGE"
    elif [ -n "$SYNOPSIS" ]; then
        SYNOPSIS_STR="$SYNOPSIS"
    elif [ -n "$SYNOPSIS_ERROR" ]; then
        SYNOPSIS_STR="$SYNOPSIS_ERROR"
    else
        SYNOPSIS_STR="$COMMON_SYNOPSIS_ERROR"
    fi
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

#### script_help ( lib_info = true )
## this function must echo the help information USAGE (with option "-h")
script_help () {
    local lib_info="${1:-true}"
    local TMP_VERS="$(library_info)"
    local USAGESTR=''
    if [ -n "$USAGE" ] && [ "$lib_info" = 'true' ]; then
        USAGESTR+="$(script_title)"
        USAGESTR+="$(parse_color_tags "\n$USAGE\n")"
        USAGESTR+="$(parse_color_tags "\n<${COLOR_COMMENT}>${TMP_VERS}</${COLOR_COMMENT}>")"
    else
        local TMP_TITLE="${NAME:-?}"
        if [ -n "$VERSION" ]; then TMP_TITLE="${TMP_TITLE} - v. [${VERSION}]"; fi
        local TMP_USAGE="\n<bold>NAME</bold>\n\t<bold>${TMP_TITLE}</bold>";
        TMP_USAGE+="\n";
        for section in "${MANPAGE_VARS[@]}"; do
            eval "section_name=\"${section/${MANPAGE_SUFFIX}/}\""
            eval "section_ctt=\"\$${section}\""
            eval "glob_section_ctt=\"\$${section_name}\""
            local toshow=''
            if [ "$section_name" != 'NAME' ] && [ "$section_name" != 'DATE' ] && [ "$section_name" != 'VERSION' ]; then
                if [ -n "$section_ctt" ]; then
                    toshow="$section_ctt"
                elif [ -n "$glob_section_ctt" ]; then
                    toshow="$glob_section_ctt"
                elif [ "$section_name" = 'SYNOPSIS' ]; then
                    eval "section_default_ctt=\"\$COMMON_${section}\""
                    eval "section_global_default_ctt=\"\$COMMON_${section/${MANPAGE_SUFFIX}/}\""
                    if [ -n "$section_default_ctt" ]; then
                        toshow="$section_default_ctt"
                    elif [ -n "$section_global_default_ctt" ]; then
                        toshow="$section_global_default_ctt"
                    fi
                fi
                if [ -n "$toshow" ] && [ "$toshow" != '' ]; then
                    TMP_USAGE+="\n<bold>${section_name}</bold>\n\t${toshow}\n";
                fi
            fi
        done
        if [ "${MANPAGE_NODEPEDENCY:-false}" = 'false' ]; then
            if [ "$lib_info" = 'true' ]; then
                TMP_USAGE+="\n<bold>DEPENDENCIES</bold>\n\t${LIB_DEPEDENCY_MANPAGE_INFO}\n";
            fi
        fi
        TMP_USAGE+="\n<${COLOR_COMMENT}>${TMP_VERS}</${COLOR_COMMENT}>";
        USAGESTR+="$(parse_color_tags "$TMP_USAGE")"
    fi
    local _done=false
    if [ "${#SCRIPT_PROGRAMS[@]}" -gt 0 ]; then
        local _tmpfile="$(get_tempfile_path "$(get_filename "$0").usage")"
        if in_array "less" "${SCRIPT_PROGRAMS[@]}"; then
            echo "$USAGESTR" > "$_tmpfile"
            cat "$_tmpfile" | less -cfre~
            _done=true
        elif in_array "more" "${SCRIPT_PROGRAMS[@]}"; then
            echo "$USAGESTR" > "$_tmpfile"
            cat "$_tmpfile" | more -cf
            _done=true
        fi
    fi
    if [ "$_done" != 'true' ]; then echo "$USAGESTR"; fi
    return 0;
}

#### script_manpage ( cmd = $0 , section = 3 )
## will open the manpage of $0 if found in system manpages or if `$0.man` exists
## else will trigger 'script_help' method
script_manpage () {
    local cmd="${1:-${0}}"
    local cmd_filename=$(get_filename "$cmd")
    local cmd_localman="${cmd%.*}.man"
    local section="${2:-3}"
    if man -w -s "$section" "$cmd_filename" 2> /dev/null; then
        man -s "$section" "$cmd_filename"
    elif [ -f "$cmd_localman" ]; then
        man "./${cmd_localman}"
    else
        quietecho "- no manpage for '${cmd}' ; running 'help'"
        clear; script_help
    fi
    return 0
}

#### script_short_version ( quiet = false )
script_short_version () {
    local bequiet="${1:-false}"
    if ${bequiet}; then
        echo "${VERSION:-?}"
        return 0
    fi
    local TMP_STR="$VERSION"
    if [ -n "$VERSION" ]; then
        if [ -n "$NAME" ]
            then TMP_STR="${NAME} ${TMP_STR}"
            else TMP_STR="${0} ${TMP_STR}"
        fi
        local gitvers="$(get_version_string)"
        if [ -n "$gitvers" ]; then TMP_STR+=" ${gitvers}"
        elif [ -n "$DATE" ]; then TMP_STR+=" ${DATE}"
        fi
        echo "$TMP_STR"
    fi
    return 0;
}

#### script_version ( quiet = false )
script_version () {
    local bequiet="${1:-false}"
    if [ "$bequiet" = 'true' ]; then
        echo "${VERSION:-?}"
        return 0
    fi
    script_short_version
    for section in "${VERSION_VARS[@]}"; do
        case "$section" in
            NAME|VERSION|DATE);;
            *) if [ -n "${!section}" ]; then echo "${!section}"; fi;;
        esac
    done
    return 0;
}


#### DOCBUILDER ##########################################################################

## Documentation builder rules, tags and masks
##@ DOCBUILDER_MASKS = ()
declare -xa DOCBUILDER_MASKS=()
##@ DOCBUILDER_MARKER = '##@!@##'
declare -x DOCBUILDER_MARKER='##@!@##'
##@ DOCBUILDER_RULES = ( ... )
declare -xa DOCBUILDER_RULES=(
    '^#### [^#]* #*$'                       # title line        : #### title # (this will be followed by the line number and a new line)
    '^#### [^#]*$'                          # fct name line     : #### name ( what ever )
    '^##@ .*$'                              # var line          : ##@ varname ( what ever )
    '^## .*$'                               # comment line      : ## comment (will NOT match "##! comment")
    '^##+ .*$'                              # 2nd comment line  : ##+ comment (will NOT match "##! comment")
    '^##@[^ ]* .*$'                         # tag line          : ##@tagname string
);

declare -xa DOCBUILDER_TERMINAL_MASKS=(
    "s|^#### \(.*\) #*$|\\\n# \1 #|g"                   # title line
    "s|^#### \(.*\)$|\\\n\\\t\1|g"                      # fct name line
    "s|^##@ \(.*\)$|\\\t\1|g"                           # var line
    "s|^## \(.*\)$|\\\t\\\t\1|g"                        # comment line
    "s|^##+ \(.*\)$|\\\t\\\t\1|g"                       # 2nd comment line
    "s|^##\(@[^ ]*\) \(.*\)$|\\\t\\\t\1 \2|g"           # tag line
);
declare -xa DOCBUILDER_MARKDOWN_MASKS=(
    "s|^#### \(.*\) #*$|\\\n## \1|g"                    # title line
    "s|^#### \(.*\)$|\\\n-   \*\*\1\*\*\\\n|g"          # fct name line
    "s|^##@ \(.*\)$|\\\n-   \*\*\1\*\*|g"               # var line
    "s|^## \(.*\)$|\\\n\\\t\1|g"                        # comment line
    "s|^##+ \(.*\)$|\\\t\1|g"                           # 2nd comment line
    "s|^##\(@[^ ]*\) \(.*\)$|\\\n\\\t\*\*\1:\*\* \2|g"  # tag line
);

#### build_documentation ( type = TERMINAL , output = null , source = BASH_SOURCE[0] )
build_documentation () {
    local type="${1:-TERMINAL}"
    local output="${2}"
    local source="${3:-${BASH_SOURCE[0]}}"
    local type_var="DOCBUILDER_$(string_to_upper "$type")_MASKS"
    if [ -z "${!type_var}" ]; then
        error "unknown doc-builder type '${type}'"
    fi
    eval "export DOCBUILDER_MASKS=( \"\${${type_var}[@]}\" )"
    verecho "- generating documentation in format '${type}' from file '${source}'" >&2;
    generate_documentation "$source" "$output"
    return 0
}

#### generate_documentation ( filepath = BASH_SOURCE[0] , output = null )
generate_documentation () {
    local sourcefile="${1:-${BASH_SOURCE[0]}}"
    if [ ! -f "$sourcefile" ]; then path_error "$sourcefile"; fi
    local output="$2"
    local docstr=''
    if [ -n "$DOCUMENTATION_TITLE" ]
        then docstr="# ${DOCUMENTATION_TITLE}"
        else docstr="# Documentation of '$sourcefile'"
    fi
    if [ -n "$DOCUMENTATION_INTRO" ]; then
        docstr+="\n\n${DOCUMENTATION_INTRO}\n\n----\n";
    fi
    i=0
    old_IFS="$IFS"
    IFS=$'\n'
    local indoc=false
    local intag=false
    while read line; do
        if [ "${line:0:2}" != '##' ]; then continue; fi
        if [ "$line" = "$DOCBUILDER_MARKER" ]; then
            if [ "$indoc" = 'true' ]; then indoc=false; break; else indoc=true; fi
            continue;
        fi
        if [ "$indoc" = 'true' ]; then
            line_str=''
            title_line="$(echo "$line" | grep -o "${DOCBUILDER_RULES[0]}" | sed "${DOCBUILDER_MASKS[0]}")"
            fct_line="$(echo "$line" | grep -o "${DOCBUILDER_RULES[1]}" | sed "${DOCBUILDER_MASKS[1]}")"
            var_line="$(echo "$line" | grep -o "${DOCBUILDER_RULES[2]}" | sed "${DOCBUILDER_MASKS[2]}")"
            if [ -n "${title_line}" ]; then
                line_str="${title_line} (line ${i})\n"
            elif [ -n "$fct_line" ]; then
                line_str="$fct_line"
                intag=true
            elif [ -n "$var_line" ]; then
                line_str="$var_line"
                intag=true
            elif [ "$intag" = 'true' ]; then
                comm_line="$(echo "$line" | grep -o "${DOCBUILDER_RULES[3]}" | sed "${DOCBUILDER_MASKS[3]}")"
                comm_line_alt="$(echo "$line" | grep -o "${DOCBUILDER_RULES[4]}" | sed "${DOCBUILDER_MASKS[4]}")"
                arg_line="$(echo "$line" | grep -o "${DOCBUILDER_RULES[5]}" | sed "${DOCBUILDER_MASKS[5]}")"
                if [ "$VERBOSE" = 'true' ]; then
                    if [ -n "$arg_line" ]; then
                        line_str="$arg_line"
                    elif [ -n "$comm_line" ]; then
                        line_str="$comm_line"
                    elif [ -n "$comm_line_alt" ]; then
                        line_str="$comm_line_alt"
                    fi
                else
                    if [ -n "$comm_line" ] && [ -n "$comm_line_alt" ]; then intag=false; fi
                fi
            fi
            if [ -n "$line_str" ]; then docstr+="\n${line_str}"; fi
        fi
        i=$((i+1))
    done < "$sourcefile" ;
    IFS="$old_IFS"
    export IFS
    now="$(date '+%d-%-m-%Y %X')"
    docstr+="\n\n----\n\n[*Doc generated at ${now} from path '${sourcefile}'*]"
    if [ -n "$output" ]
        then _echo "$docstr" > "$output"
        else _echo "$docstr"
    fi
    return 0
}


#### LIBRARY INFO #####################################################################

#### get_library_version_string ( path = $0 )
## extract the GIT version string from a file matching line 'LIB_VCSVERSION=...'
get_library_version_string () {
    local fpath="${1:-$0}"
    if [ ! -f "$fpath" ]; then error "file '${fpath}' not found!"; fi
    local _vers="$(get_version_string "$fpath")"
    if [ -z "$_vers" ]; then
        _vers="$(get_version_string "$fpath" LIB_VCSVERSION)"
    fi
    echo "$_vers"
    return 0
}

#### library_info ()
library_info () {
    library_short_version
    return 0;
}

#### library_path ()
library_path () {
    realpath "${BASH_SOURCE[0]}"
    return 0;
}

#### library_help ()
library_help () {
    local _lib="$(library_path)"
    if in_array "${USEROS}" "${LINUX_OS[@]}"
        then "$_lib" help
        else "$(which sh)" "$_lib" help
    fi
    return 0
}

#### library_usage ()
library_usage () {
    local _lib="$(library_path)"
    if in_array "${USEROS}" "${LINUX_OS[@]}"
        then "$_lib" usage
        else "$(which sh)" "$_lib" usage
    fi
    return 0
}

#### library_short_version ( quiet = false )
## this function must echo an information about library name & version
library_short_version () {
    local bequiet="${1:-false}"
    if [ "$bequiet" = 'true' ]; then
        echo "$LIB_VERSION"
        return 0
    fi
    local TMP_VERS="${LIB_NAME} ${LIB_VERSION}"
    local LIB_MODULE="$(dirname "$LIBRARY_REALPATH")/.."
    local _done=false
    if git_is_clone "$LIB_MODULE" "$LIB_SOURCES_URL" 2>/dev/null; then
        add="$(git_get_version)"
        if [ -n "$add" ]; then
            _done=true
            TMP_VERS+=" ${add}"
        fi
    fi
    if [ "$_done" = 'false' ] && [ -f "$BASH_SOURCE" ]; then
        TMP_VERS+=" $(get_library_version_string "${BASH_SOURCE}")"
    fi
    echo "$TMP_VERS"
    return 0
}

#### library_version ( quiet = false )
## this function must echo an FULL information about library name & version (GNU like)
library_version () {
    local OLD_VCSVERSION="$VCSVERSION"
    export VCSVERSION="$LIB_VCSVERSION"
    for section in "${VERSION_VARS[@]}"; do
        eval "local OLD_$section=\$$section"
        eval "export $section=\$LIB_$section"
    done
    script_version "${1:-false}"
    for section in "${VERSION_VARS[@]}"; do
        eval "export $section=\$OLD_$section"
    done
    export VCSVERSION="${OLD_VCSVERSION}"
    return 0
}

#### library_debug ( "$*" )
## see all common options flags values & some debug infos
library_debug () {
    OPTIND=1
    local TOP_STR=" \$ $0 ${ORIGINAL_SCRIPT_OPTS}"
    if [ "$*" != "${ORIGINAL_SCRIPT_OPTS}" ]; then
        TOP_STR="${TOP_STR}\n re-arranged in:\n \$ $0 $*"
    fi
    local TMP_DEBUG_MASK=" \n\
---- DEBUG -------------------------------------------------------------\n\
${TOP_STR}\n\
------------------------------------------------------------------------\n\
- %s is set on %s\n\
- %s is set on %s\n\
- %s mode is %s (option '%s')\n\
- %s mode is %s (option '%s')\n\
- %s mode is %s (option '%s')\n\
- %s mode is %s (option '%s')\n\
- %s mode is %s (option '%s')\n\
------------------------------------------------------------------------\n\
 status: %s - pid: %s - user: %s - shell: %s\n\
 %s\n\
------------------------------------------------------------------------";
    printf -v TMP_DEBUG "$TMP_DEBUG_MASK" \
        "$(colorize 'USEROS' bold)" "$(colorize "$USEROS" bold "$COLOR_INFO")" \
        "$(colorize 'WORKINGDIR' bold)" "$(colorize "$WORKINGDIR" bold "$COLOR_INFO")" \
        "$(colorize 'VERBOSE' bold)" "$(colorize "$(onoff_bit "$VERBOSE")" bold "$COLOR_INFO")" "-v" \
        "$(colorize 'INTERACTIVE' bold)" "$(colorize "$(onoff_bit "$INTERACTIVE")" bold "$COLOR_INFO")" "-i" \
        "$(colorize 'FORCED' bold)" "$(colorize "$(onoff_bit "$FORCED")" bold "$COLOR_INFO")" "-f" \
        "$(colorize 'DEBUG' bold)" "$(colorize "$(onoff_bit "$DEBUG")" bold "$COLOR_INFO")" "-x" \
        "$(colorize 'QUIET' bold)" "$(colorize "$(onoff_bit "$QUIET")" bold "$COLOR_INFO")" "-q" \
        "$?" "$$" "$(whoami)" "${USERSHELL} ${SHELLVERSION}" "$(get_system_info)";
    TMP_DEBUG+="\n$(parse_color_tags "<${COLOR_COMMENT}>$(library_info)</${COLOR_COMMENT}>")";
    _echo "$TMP_DEBUG"
    return 0
}

#### / libdebug ( "$*" )
## alias of library_debug
libdebug () {
    library_debug $*
}

#### LIBRARY INTERNALS ###################################################################

##@ LIBRARY_REALPATH LIBRARY_DIR LIBRARY_BASEDIR LIBRARY_SOURCEFILE
declare -rx LIBRARY_REALPATH="$(realpath "${BASH_SOURCE[0]}")" 2>/dev/null;
declare -rx LIBRARY_DIR="$(dirname "$LIBRARY_REALPATH")" 2>/dev/null;
declare -rx LIBRARY_BASEDIR="$(dirname "$LIBRARY_DIR")" 2>/dev/null;
declare -rx LIBRARY_SOURCEFILE="$(basename "$LIBRARY_REALPATH")" 2>/dev/null;

#### make_library_homedir ()
## make dir '$HOME/.piwi-bash-library' if it doesn't exist
make_library_homedir () {
    if [ ! -d "$LIB_SYSHOMEDIR" ]; then mkdir "$LIB_SYSHOMEDIR"; fi
    return 0
}

#### make_library_cachedir ()
## make dir '$HOME/.piwi-bash-library/cache' if it doesn't exist
make_library_cachedir () {
    make_library_homedir
    if [ ! -d "$LIB_SYSCACHEDIR" ]; then mkdir "$LIB_SYSCACHEDIR"; fi
    return 0
}

#### clean_library_cachedir ()
## clean dir '$HOME/.piwi-bash-library/cache' if it exists
clean_library_cachedir () {
    if [ -d "$LIB_SYSCACHEDIR" ]; then rm -rf "$LIB_SYSCACHEDIR"; fi
    return 0
}

#### INSTALLATION WIZARD #################################################################
##! All internal installation methods are prefixed with 'instwiz_'
##! All internal installation constants are prefixed with 'LIBINST_'

##@ INSTALLATION_VARS = ( SCRIPT_VCS VCSVERSION SCRIPT_REPOSITORY_URL SCRIPT_FILES SCRIPT_FILES_BIN SCRIPT_FILES_MAN SCRIPT_FILES_CONF ) (read-only)
declare -rxa INSTALLATION_VARS="(SCRIPT_VCS VCSVERSION SCRIPT_REPOSITORY_URL SCRIPT_FILES SCRIPT_FILES_BIN SCRIPT_FILES_MAN SCRIPT_FILES_CONF)" 2>/dev/null;

##@ SCRIPT_REPOSITORY_URL = url of a distant repository
declare -x SCRIPT_REPOSITORY_URL=''
##@ SCRIPT_FILES = array of installable files
declare -xa SCRIPT_FILES=()
##@ SCRIPT_FILES_BIN = array of installable binary files
declare -xa SCRIPT_FILES_BIN=()
##@ SCRIPT_FILES_MAN = array of manpages files
declare -xa SCRIPT_FILES_MAN=()
##@ SCRIPT_FILES_CONF = array of configuration files
declare -xa SCRIPT_FILES_CONF=()

##! internal vars for installation
declare -x LIBINST_TARGET=''
declare -x LIBINST_CLONE=''
declare -x LIBINST_BRANCH='master'

## instwiz_get_real_version ( path = LIBINST_CLONE )
## get the real vcs_get_version from a repo
instwiz_get_real_version () {
    local clonedir="${1:-${LIBINST_CLONE}}"
    vcs_get_version "$clonedir"
    return 0
}

## instwiz_remoteversion ( path = LIBINST_CLONE , branch = HEAD )
## get the last commit SHA from the remote in branch
instwiz_remoteversion () {
    vcs_get_remote_version "${1:-${LIBINST_CLONE}}" "${2:-HEAD}"
    return 0
}

## instwiz_prepare_install_cmd ()
instwiz_prepare_install_cmd () {
    local installcmd=''
    # all files
    for file in "${SCRIPT_FILES[@]}"; do
        local _originalfilepath="${LIBINST_CLONE}/${file}"
        local _targetfilepath="${LIBINST_TARGET}/${file}"
        if [ -e ${_originalfilepath} ]; then
            if [ "$(string_length "$installcmd")" -gt 0 ]; then installcmd+=" && "; fi
            if [ -d "$_originalfilepath" ]
            then installcmd+="cp -rf '${_originalfilepath}' '${_targetfilepath}'"
            else installcmd+="cp -f '${_originalfilepath}' '${_targetfilepath}'"
            fi
        else
            echo "! > file '${LIBINST_CLONE}/${file}' not found and won't be installed!"
        fi
    done
    # binary files
    for file in "${SCRIPT_FILES_BIN[@]}"; do
        local _originalfilepath="${LIBINST_CLONE}/${file}"
        local _targetfilepath="${LIBINST_TARGET}/${file}"
        if [ -f "$_originalfilepath" ]; then
            if [ "$(string_length "$installcmd")" -gt 0 ]; then installcmd+=" && "; fi
            installcmd+="chmod a+x '${_targetfilepath}'"
        fi
    done
# @TODO : install man and conf
    # command to execute
    echo "$installcmd"
    return 0
}

## instwiz_prepare_uninstall_cmd ()
instwiz_prepare_uninstall_cmd () {
    local uninstallcmd=''
    # all files
    for file in "${SCRIPT_FILES[@]}"; do
        local _targetfilepath="${LIBINST_TARGET}/${file}"
        if [ -e "$_targetfilepath" ]; then
            if [ "$(string_length "$uninstallcmd")" -gt 0 ]; then uninstallcmd+=" && "; fi
            if [ -d "$_targetfilepath" ]
            then uninstallcmd+="rm -rf '${_targetfilepath}'"
            else uninstallcmd+="rm -f '${_targetfilepath}'"
            fi
        fi
    done
# @TODO : un-install man and conf
    # command to execute
    echo "$uninstallcmd"
    return 0
}

#### script_installation_target ( target_dir = $HOME/bin )
script_installation_target () {
    export LIBINST_TARGET="${1:-${HOME}/bin}"
    if [ ! -d "$LIBINST_TARGET" ]; then
        mkdir -p "$LIBINST_TARGET" || simple_error "target path '${LIBINST_TARGET}' not found and can't be created!"
    fi
    return 0
}

#### script_installation_source ( clone_repo = SCRIPT_REPOSITORY_URL , clone_dir = LIB_SYSCACHEDIR )
script_installation_source () {
    if [ $# -gt 0 ]; then export SCRIPT_REPOSITORY_URL="$1"; fi
    local _dirname="$(basename "$repourl")"
    _dirname="${_dirname/.git/}"
    if [ "$_dirname" != "$(basename "$repourl")" ]; then export SCRIPT_VCS='git'; fi
    local target="${LIB_SYSCACHEDIR}/${_dirname}"
    make_cachedir
    if [ $# -gt 1 ]; then export SCRIPT_HOME="$1"; fi
    export LIBINST_TARGET="${1:-${HOME}/bin}"
    if [ ! -d "$LIBINST_TARGET" ]; then
        mkdir -p "$LIBINST_TARGET" || simple_error "target path '${LIBINST_TARGET}' not found and can't be created!"
    fi
    return 0
}

#### script_install ( path = $HOME/bin/ )
script_install () {
    local installcmd="$(instwiz_prepare_install_cmd)"
    log "script_install: '${installcmd}'"
    iexec "$installcmd"
    quietecho ">> ok, script installed in '${LIBINST_TARGET}'"
    return 0
}

#### script_check ( file_name , original = LIBINST_CLONE , target = LIBINST_TARGET )
##@param file_name: the file to check and compare on both sides
script_check () {
    if [ $# -eq 0 ]; then return 0; fi
    local filename="$1"
    local clonedir="${2:-${LIBINST_CLONE}}"
    local targetdir="${3:-${LIBINST_TARGET}}"
    # target
    local targetvers="$(get_version_string "${targetdir}/${filename}")"
    local targetvers_sha="$(get_version_sha "$targetvers")"
    local targetvers_branch="$(get_version_branch "$targetvers")"
    # distant GIT
    local remotevers_sha="$(instwiz_remoteversion "$clonedir" "$targetvers_branch")"
    if [ "$targetvers_sha" != "$remotevers_sha" ]
        then echo "New version ${remotevers_sha} available ..."; return 1;
        else echo "Up-to-date"; touch "${targetdir}/${filename}";
    fi
    return 0
}

#### script_update ( path = $HOME/bin/ )
script_update () {
    local installcmd="$(instwiz_prepare_install_cmd)"
    log "script_update: '${installcmd}'"
    iexec "$installcmd"
    quietecho ">> ok, script updated in '${LIBINST_TARGET}'"
    return 0
}

#### script_uninstall ( path = $HOME/bin/ )
script_uninstall () {
    local uninstallcmd="$(instwiz_prepare_uninstall_cmd)"
    if [ "$uninstallcmd" = '' ]; then
        quietecho ">> nothing to un-install!"
        return 1
    fi
    log "script_uninstall: '${uninstallcmd}'"
    iexec "$uninstallcmd"
    quietecho ">> ok, script removed from '${LIBINST_TARGET}'"
    return 0
}


#### COMPATIBILITY #####################################################################
# to be deleted in next major version !!


##@!@##
##########################################################################################
# Internal API
##########################################################################################

# this MUST only be parsed when calling the lib directly
# any method of the internal api is prefixed by `intlib_`
#if [ "$_" != "$0" ] || [ "$(basename "$0")" != "$(basename "${BASH_SOURCE[0]}")" ]; then return 0; fi
if [ "$(basename "$0")" != "$(basename "${BASH_SOURCE[0]}")" ]; then return 0; fi
#echo "BASH LIBRARY !!!"

declare -x INTLIB_BIN_FILENAME="${LIB_FILENAME_DEFAULT}.sh"
declare -x INTLIB_DEVDOC_FILENAME="${LIB_FILENAME_DEFAULT}-DOC.md"
declare -x INTLIB_README_FILENAME="${LIB_FILENAME_DEFAULT}-README.md"
declare -x INTLIB_MAN_FILENAME="${LIB_FILENAME_DEFAULT}.man"
declare -x INTLIB_PRESET='default'
declare -x INTLIB_BRANCH='master'
declare -x INTLIB_TARGET
declare -x INTLIB_RELEASE
declare -x INTLIB_EXEC
declare -rx INTLIB_RELEASE_MASK="%s.tar.gz" 2>/dev/null;
declare -rx INTLIB_RELEASE_MASK_URL="${LIB_SOURCES_URL}/archive/%s" 2>/dev/null;
# days to make automatic version check
declare -x INTLIB_OUTDATED_CHECK=30
# days to force user update (message is always shown)
declare -x INTLIB_OUTDATED_FORCE=90
declare -rxa INTLIB_PRESET_ALLOWED="( default dev user full )" 2>/dev/null;
declare -rxa INTLIB_ACTION_ALLOWED="( install uninstall check update version help usage documentation mddocumentation clean exec )" 2>/dev/null;

# script man infos
MANPAGE_NODEPEDENCY=true
for section in "${MANPAGE_VARS[@]}";        do eval "${section}=\$LIB_${section}"; done
for section in "${SCRIPT_VARS[@]}";         do eval "${section}=\$LIB_${section}"; done
for section in "${VERSION_VARS[@]}";        do eval "${section}=\$LIB_${section}"; done
for section in "${USAGE_VARS[@]}";          do eval "${section}=\$LIB_${section}"; done
for section in "${INSTALLATION_VARS[@]}";   do eval "${section}=\$LIB_${section}"; done
SCRIPT_REPOSITORY_URL="${LIB_SOURCES_URL}"
OPTIONS_ALLOWED="b:t:p:r:e:${COMMON_OPTIONS_ALLOWED}"
LONG_OPTIONS_ALLOWED="exec:,branch:,target:,preset:,release:,local,${COMMON_LONG_OPTIONS_ALLOWED}"
INTLIB_PRESET_INFO=''
for pres in "${INTLIB_PRESET_ALLOWED[@]}"; do
    INTLIB_PRESET_INFO+=" '${pres}'"
done
DESCRIPTION_USAGE="${LIB_DESCRIPTION}\n\n\
To use the library, just include its source file using: \`source path/to/piwi-bash-library.bash\` and call its methods.\n\
Try option '--man' for the library full manpage.";
OPTIONS_USAGE="\n\
$(parse_color_tags "<bold><action> in:</bold>")\n\
\tinstall\t\t\tinstall a copy locally or in your system\n\
\tcheck\t\t\tcheck if a copy is up-to-date\n\
\tupdate\t\t\tupdate a copy with newer version if so\n\
\tuninstall\t\tuninstall a copy from a system path\n\
\tversion\t\t\tget a copy version infos ; use option '--quiet' to get only the version number\n\
\tdocumentation\t\tsee the library documentation ; use option '--verbose' to increase verbosity\n\
\tclean\t\t\tclean library cache\n\n\
$(parse_color_tags "<bold>available options:</bold>")\n\
\t-e, --exec='string'\ta bash string to evaluate in the library's environment\n\
\t-t, --target=PATH\tdefine the target directory ('PATH' must exist - default is '\$HOME/bin/')\n\
\t-p, --preset=TYPE\tdefine a preset for an installation ; can be ${INTLIB_PRESET_INFO}\n\
\t-b, --branch=NAME\tdefine the GIT branch to use from the library remote repository (default is '${INTLIB_BRANCH}')\n\
\t-r, --release=VERSION\tdefine the GIT release tag to use from the library remote repository (default is empty)\n\
\t--local\t\t\tlocal installation in current directory (alias of '--target=\$(pwd)')\
${COMMON_OPTIONS_USAGE}";
SYNOPSIS_ERROR=" ${0}  [-${COMMON_OPTIONS_ALLOWED_MASK}] \n\
\t[-t | --target=<path>]  [--local] \n\
\t[-b | --branch=<branch>]  [-r | --release=<version>] \n\
\t[-p | --preset= (${INTLIB_PRESET_ALLOWED[@]}) ] \n\
\t[-e | --exec=<'string to eval'>] \n\
\thelp | usage\n\
\tversion\n\
\tcheck\n\
\tinstall\n\
\tupdate\n\
\tuninstall\n\
\tdocumentation\n\
\tclean\n";
SYNOPSIS_USAGE=" ${0}  [-${COMMON_OPTIONS_ALLOWED_MASK}] \n\
\t[-t | --target=<path>]  [--local] \n\
\t[-b | --branch=<branch>]  [-r | --release=<version>] \n\
\t[-p | --preset= (${INTLIB_PRESET_ALLOWED[@]}) ] \n\
\t[-e | --exec=<'string to eval'>] \n\
\t[--] <action>";
declare -x DOCUMENTATION_TITLE="Piwi Bash Library documentation\n\n[*$(library_info)*]"
declare -x DOCUMENTATION_INTRO="\
\tPackage [${LIB_PACKAGE}] version [${LIB_VERSION}].\n\
\t${LIB_COPYRIGHT} - Some rights reserved. \n\
\t${LIB_LICENSE}.\n\
\t${LIB_SOURCES}.\n\
\tBug reports: <http://github.com/piwi/bash-library/issues>.\n\
\t${LIB_ADDITIONAL_INFO}";

# internal API methods

# -> check preset validity
intlib_preset_valid () {
    in_array "${INTLIB_PRESET}" "${INTLIB_PRESET_ALLOWED[@]}" || simple_error "unknown preset '${INTLIB_PRESET}'!";
    SCRIPT_FILES=( ${INTLIB_BIN_FILENAME} ${INTLIB_MAN_FILENAME} )
    SCRIPT_FILES_BIN=( ${INTLIB_BIN_FILENAME} )
    SCRIPT_FILES_MAN=( ${INTLIB_MAN_FILENAME} )
    if [ "$INTLIB_PRESET" = 'dev' ]||[ "$INTLIB_PRESET" = 'full' ]; then
        SCRIPT_FILES=( "${SCRIPT_FILES[@]}" ${INTLIB_DEVDOC_FILENAME} )
    fi
    if [ "$INTLIB_PRESET" = 'user' ]||[ "$INTLIB_PRESET" = 'full' ]; then
        SCRIPT_FILES=( "${SCRIPT_FILES[@]}" ${INTLIB_README_FILENAME} )
    fi
    export SCRIPT_FILES SCRIPT_FILES_BIN SCRIPT_FILES_MAN
    return 0
}

# -> prepare a clone of the library repo
intlib_prepare_libclone () {
    if [ "$INTLIB_RELEASE" != '' ]
    then
        make_library_cachedir
        local oldpwd="$(pwd)"
        if [ "${INTLIB_RELEASE:0:1}" != 'v' ]; then export INTLIB_RELEASE="v${INTLIB_RELEASE}"; fi
        local _tag="$(printf "$INTLIB_RELEASE_MASK" "$INTLIB_RELEASE")"
        local _tag_url="$(printf "$INTLIB_RELEASE_MASK_URL" "$_tag")"
        local _target="${LIB_SYSCACHEDIR}/${INTLIB_RELEASE}"
        if [ ! -d "$_target" ]; then
            local wgetcmd="$(which wget)"
            if [ -z "$wgetcmd" ]; then command_error 'wget'; fi
            cd "$LIB_SYSCACHEDIR"
            "$wgetcmd" "$_tag_url"
            local _tar_dirname="$(tar -tzf "$_tag" | sed -n 1p)"
            _tar_dirname="${_tar_dirname%/}"
            if [ -d "$_tar_dirname" ]; then rm -rf "$_tar_dirname"; fi
            if [ "$VERBOSE" = 'true' ]
            then tar xvf "$_tag"
            else tar xf "$_tag"
            fi
            mv "$_tar_dirname" "$INTLIB_RELEASE"
        fi
        export LIBINST_CLONE="$_target"
        cd "$oldpwd"
    else
        local target="${LIB_SYSCACHEDIR}/$(basename "$LIB_SOURCES_URL")-${LIBINST_BRANCH}"
        git_make_clone "$LIB_SOURCES_URL" "$target"
        export LIBINST_CLONE="$CURRENT_GIT_CLONE_DIR"
        git_change_branch "$LIBINST_CLONE" "$LIBINST_BRANCH"
        git_update_clone "$LIBINST_CLONE"
    fi
    return 0
}

# -> prepare required install files in ${clone}/tmp/
intlib_prepare_install () {
    intlib_prepare_libclone
    local tmpdir="${LIBINST_CLONE}/tmp"
    rm -rf "$tmpdir" && mkdir "$tmpdir"
    cp -f "${LIBINST_CLONE}/bin/piwi-bash-library.bash" "${tmpdir}/${INTLIB_BIN_FILENAME}"
    cp -f "${LIBINST_CLONE}/man/piwi-bash-library.man" "${tmpdir}/${INTLIB_MAN_FILENAME}"
    cp -f "${LIBINST_CLONE}/DOCUMENTATION.md" "${tmpdir}/${INTLIB_DEVDOC_FILENAME}"
    cp -f "${LIBINST_CLONE}/README.md" "${tmpdir}/${INTLIB_README_FILENAME}"
    export LIBINST_CLONE="$tmpdir"
    return 0
}

# internal library actions
intlibaction_documentation () {
    build_documentation
    return 0
}
intlibaction_documentation_tomd () {
    build_documentation 'markdown'
    return 0
}
intlibaction_clean () {
    clean_library_cachedir
    quietecho ">> cache cleaned"
    return 0
}
intlibaction_check () {
    script_installation_target "$INTLIB_TARGET"
    intlib_prepare_libclone
    script_check "$INTLIB_BIN_FILENAME"
    return 0
}
intlibaction_install () {
    script_installation_target "$INTLIB_TARGET"
    intlib_preset_valid
    intlib_prepare_install
    local oldquiet="$QUIET"
    export QUIET=true
    script_install
    export QUIET="$oldquiet"
    quietecho ">> ok, library installed in '${LIBINST_TARGET}'"
    return 0
}
intlibaction_update () {

# @TODO: test version to make a warning if upgrade

    local installed="${INTLIB_TARGET}/${INTLIB_BIN_FILENAME}"
    if [ ! -f "$installed" ]; then
        simple_error "no installed library found to update in '${INTLIB_TARGET}'!"
    fi
    script_installation_target "$INTLIB_TARGET"
    intlib_preset_valid
    intlib_prepare_install
    local oldquiet="$QUIET"
    export QUIET=true
    script_update
    export QUIET="$oldquiet"
    quietecho ">> ok, library updated in '${LIBINST_TARGET}'"
    return 0
}
intlibaction_uninstall () {
    script_installation_target "$INTLIB_TARGET"
    intlib_preset_valid
    local oldquiet="$QUIET"
    export QUIET=true
    local result="$(script_uninstall)"
    export QUIET="$oldquiet"
    if [ "$result" != 'false' ]
    then quietecho ">> ok, library deleted from '${LIBINST_TARGET}'"
    else quietecho "nothing to un-install"
    fi
    return 0
}
intlibaction_version () {
    script_installation_target "$INTLIB_TARGET"
    library_version "$QUIET"
    return 0
}
intlibaction_help () {
    script_long_usage; return 0
}
intlibaction_usage () {
    script_usage; return 0
}
intlibaction_evaluate () {
    verbose_echo "> evaluating: '$INTLIB_EXEC'"
    evaluate "$INTLIB_EXEC" 1>/dev/null 2>&1;
    ( [ -n "$CMD_OUT" ] && [ "$QUIET" = 'false' ] ) && echo "$CMD_OUT" >&1;
    [ -n "$CMD_ERR" ] && echo "$CMD_ERR" >&2;
    return "$CMD_STATUS";
}
intlib_check_uptodate () {
    if [ "$QUIET" = 'true' ]; then return 0; fi
    local now="$(date '+%s')"
    local fmdate="$(stat -c "%Y" "$0")"
    local checkdiff=$((now - fmdate))
    # simple check
    local ts_limit=$((INTLIB_OUTDATED_CHECK * 24 * 60 * 60))
    if [ "$checkdiff" -gt "$ts_limit" ]; then
        export INTLIB_TARGET="$(dirname "$0")"
        if ! intlibaction_check 1> /dev/null; then
            info "This library version is more than ${INTLIB_OUTDATED_CHECK} days old and a newer version is available ... You should run '$0 update' to update it.";
        fi
    fi
    # forced check
    local ts_limit_forced=$((INTLIB_OUTDATED_FORCE * 24 * 60 * 60))
    if [ "$checkdiff" -gt "$ts_limit_forced" ]; then
        info "This library version is more than ${INTLIB_OUTDATED_FORCE} days old ... You should run '$0 update' to get last version.";
    fi
    return 0
}

# get any piped content
read_from_pipe
# parsing options
#rearrange_script_options "$@"
rearrange_script_options_new "$0" "$@"
[ -n "$SCRIPT_PARAMS" ] && eval set -- "$SCRIPT_PARAMS"
parse_common_options_strict "$@"
OPTIND=1
while getopts ":${OPTIONS_ALLOWED}" OPTION; do
    OPTARG="${OPTARG#=}"
    case "$OPTION" in
        h|f|i|q|v|x|V|d|l) ;;
        t) INTLIB_TARGET="$OPTARG";;
        p) INTLIB_PRESET="$OPTARG";;
        b) LIBINST_BRANCH="$OPTARG";;
        r) INTLIB_RELEASE="$OPTARG";;
        e) INTLIB_EXEC="${OPTARG:-${SCRIPT_PIPED_INPUT}}"; ACTION='exec';;
        -)  parse_long_option "$OPTARG" "${!OPTIND}"
            case "$LONGOPTNAME" in
                target) INTLIB_TARGET="$LONGOPTARG";;
                local)  INTLIB_TARGET="$(pwd)";;
                preset) INTLIB_PRESET="$LONGOPTARG";;
                branch) LIBINST_BRANCH="$LONGOPTARG";;
                release)INTLIB_RELEASE="$LONGOPTARG";;
                exec)   INTLIB_EXEC="${LONGOPTARG:-${SCRIPT_PIPED_INPUT}}"; ACTION='exec';;
                ?) ;;
            esac ;;
        ?) ;;
    esac
done
export INTLIB_TARGET INTLIB_PRESET LIBINST_BRANCH INTLIB_RELEASE
if [ -z "$ACTION" ]; then
    get_next_argument
    ACTION="$ARGUMENT"
fi

# check last updates
intlib_check_uptodate

# checking env
# -> action is required
if [ -z "$ACTION" ]; then simple_error 'nothing to do'; fi
# -> check action validity
in_array "$ACTION" "${INTLIB_ACTION_ALLOWED[@]}" || simple_error "unknown action '${ACTION}'!";

# prepare
INTLIB_TARGET="$(resolve "$INTLIB_TARGET")"

# executing action
if [ "$DEBUG" = 'true' ]; then library_debug "$*"; fi
case "$ACTION" in
    clean) intlibaction_clean; exit 0;;
    check) intlibaction_check; exit 0;;
    install) intlibaction_install; exit 0;;
    update) intlibaction_update; exit 0;;
    uninstall) intlibaction_uninstall; exit 0;;
    help) intlibaction_help; exit 0;;
    usage) intlibaction_usage; exit 0;;
    version) intlibaction_version; exit 0;;
    documentation) intlibaction_documentation; exit 0;;
    mddocumentation) intlibaction_documentation_tomd; exit 0;;
    exec) intlibaction_evaluate; exit $?;;
esac

# Endfile
# vim: autoindent tabstop=4 shiftwidth=4 expandtab softtabstop=4 filetype=sh
