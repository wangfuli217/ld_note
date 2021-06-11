#!/usr/bin/env bash
# global test

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

NAME="Bash-Lib-Test"
VERSION="0.1.0"
DATE="1970-01-01"
DESCRIPTION="A global test file for the Piwi-Bash-Library"
USAGE="\n\
This file is the global test script of the library. You can play with options below to modify its behavior.\n\
Each file of the package like 'bin/***-test.sh' is a demo or test for a specific feature.\n\n\
<bold>USAGE</bold>\n\
\t~\$ ${0} -option(s) --longoption(s)\n\n\
<bold>COMMON OPTIONS</bold>\n\
\t${COMMON_OPTIONS_USAGE}\n\n\
<bold>LIBRARY</bold>\n\
\t${LIB_DEPEDENCY_MANPAGE_INFO}";
OPTIONS_USAGE="${COMMON_OPTIONS_USAGE}";

rearrange_script_options "$@"
[ "${#SCRIPT_OPTS[@]}" -gt 0 ] && set -- "${SCRIPT_OPTS[@]}";
[ "${#SCRIPT_ARGS[@]}" -gt 0 ] && set -- "${SCRIPT_ARGS[@]}";
[ "${#SCRIPT_OPTS[@]}" -gt 0 -a "${#SCRIPT_ARGS[@]}" -gt 0 ] && set -- "${SCRIPT_OPTS[@]}" -- "${SCRIPT_ARGS[@]}";
parse_common_options_strict
quietecho "_ go"

# get_system_info
echo "## get_system_info is: '$(get_system_info)'"
echo

# get_machine_name
echo "## get_machine_name is: '$(get_machine_name)'"
echo

# get_script_path
echo "## pwd is: '$(pwd)'"
echo

# files
echo "## get_script_path: '$(get_script_path)'"
echo "## dirname: '$(get_dirname)'"
echo "## basename: '$(get_basename)'"
echo "## filename: '$(get_filename)'"
echo "## extension: '$(get_extension)'"
echo

## arrays
declare -a arrayname=(element1 element2 element3)
echo "## tests of fct 'array_search' (indexes are 0 based):"
echo "index of 'element2' in array '${arrayname[*]}' : $(array_search element2 "${arrayname[@]}")"
echo 
echo "## tests of fct 'in_array':"
echo "## array is '${LIBCOLORS[*]}'"
echo "- test for 'black' (true):"
if in_array "black" "${LIBCOLORS[@]}"; then echo "=> IS in array"; else echo "=> is NOT in array"; fi
echo "- test for 'mlk' (false):"
if in_array "mlk" "${LIBCOLORS[@]}"; then echo "=> IS in array"; else echo "=> is NOT in array"; fi
echo 

# strings
teststr="my test string"
echo "## tests of fct 'string_length':"
echo "string_length of test string '$teststr' (14) : $(string_length "$teststr")"
echo "string_length of test string '' (0) : $(string_length)"
echo 
echo "## string_to_upper: $(string_to_upper "$teststr")"
echo "## string_to_lower: $(string_to_lower "$teststr")"
echo "## upper_case_first: $(upper_case_first "$teststr")"
echo

# git_is_clone
echo "## test of fct 'git_is_clone' on current dir:"
if git_is_clone; then echo "=> IS git clone"; else echo "=> is NOT git clone"; fi
echo "## test of fct 'git_is_clone' on current dir for remote '${LIB_SOURCES_URL}':"
if git_is_clone "$(pwd)" "$LIB_SOURCES_URL"; then echo "=> IS git clone"; else echo "=> is NOT git clone"; fi
echo "## test of fct 'git_is_clone' on current dir for remote 'https://github.com/piwi/dev-tools':"
if git_is_clone "$(pwd)" "https://github.com/piwi/dev-tools"; then echo "=> IS git clone"; else echo "=> is NOT git clone"; fi
echo

# colorize
echo "## tests of fct 'colorize':"
_echo "$(colorize " My string in bold black grey" bold green blue)"
echo

TESTSTR1="my <green>test text</green> with <bold>tags</bold> and <bgred>sample text</bgred> to test <bgred>some <bold>imbricated</bold> tags</bgred>"
echo "## tests of fct 'parse_color_tags':"
echo "$TESTSTR1"
parse_color_tags "$TESTSTR1"
echo

# verecho() usage
verecho "test of verecho() : this must be seen only with option '-v'"

# quietecho() usage
quietecho "test of quietecho() : this must not be written with option '-q'"

# iexec() usage
verecho "test of iexec() : command will be prompted with option '-i'"
iexec "ls -AlGF ."

# info() usage
verecho "test of info() : this will be shown with any option"
info "My test info string"

# warning() usage
verecho "test of warning() : run option '-i' or '-x' to not throw the error"
iexec "warning 'My test warning info'"

# error() usage
verecho "test of error() : run option '-i' or '-x' to not throw the error"
iexec "error 'My test error' 3"
echo "this will not be seen if the error has been thrown as the 'error()' function exits the script"

quietecho "_ ok"
if [ "$QUIET" != 'true' ]; then libdebug "$*"; fi
exit 0

# Endfile
# vim: autoindent tabstop=4 shiftwidth=4 expandtab softtabstop=4 filetype=sh
