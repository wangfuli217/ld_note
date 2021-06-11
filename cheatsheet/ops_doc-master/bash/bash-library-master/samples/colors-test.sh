#!/usr/bin/env bash
# colors test

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

NAME="Bash-Lib colors test"
VERSION="0.1.0"
DESCRIPTION="A script to test colorized functions of the Piwi-Bash-Library"
SCRIPT_VCS='git'

parse_common_options "$@"
quietecho "_ go"

# color codes
echo 
echo "## tests of fct 'get_color_code':"
echo "color code for 'black': $(get_color_code black)"
echo "color code for 'black' background: $(get_color_code black true)"
echo "color code for 'abcd': $(get_color_code abcd)"
echo 
echo "# tests of fct 'get_text_option_code':"
echo "text option code for 'bold': $(get_text_option_code bold)"
echo "text option code for 'normal': $(get_text_option_code normal)"
echo "text options code for 'abcd': $(get_text_option_code abcd)"
echo 

# colorize
echo "## tests of fct 'colorize':"
_echo "$(colorize "my string to colorize" bold green red)"
_echo "$(colorize " My string in normal red " normal red)"
_echo "$(colorize " My string in bold grey black" bold grey black)"
_echo "$(colorize " My string in bold black grey" bold black grey)"
_echo "$(colorize " My string in underline red green" underline red green)"
_echo "$(colorize " My string in blink yellow cyan" blink yellow cyan)"
_echo "$(colorize " My string in reverse magenta blue" reverse magenta blue)"
_echo "$(colorize " My string in bold" bold)"
_echo

TESTSTR1="my <green>test text</green> with <bold>tags</bold> and <bgred>sample text</bgred> to test <bgred>some <bold>imbricated</bold> tags</bgred>"
TESTSTR2="my <green>test text</green> to test"
TESTSTR3="my <bold>tags</bold> to test"
TESTSTR4="my <bgred>sample text</bgred> to test"
TESTSTR5="my test with <bgred>some <bold>imbricated</bold> tags</bgred> to test"
TESTSTR6="my test text with tags and sample text to test some imbricated tags"
TESTSTR7="
my <green>test text</green> with <bold>tags</bold> and <bgred>sample text</bgred>
with multi-line to test <bgred>some</bgred> <bold>tags</bold>
"
echo "## tests of fct 'parse_color_tags':"
echo "$TESTSTR1"
parse_color_tags "$TESTSTR1"
echo
echo "$TESTSTR2"
parse_color_tags "$TESTSTR2"
echo
echo "$TESTSTR3"
parse_color_tags "$TESTSTR3"
echo
echo "$TESTSTR4"
parse_color_tags "$TESTSTR4"
echo
echo "$TESTSTR5"
parse_color_tags "$TESTSTR5"
echo
echo "$TESTSTR6"
parse_color_tags "$TESTSTR6"
echo
echo "$TESTSTR7"
parse_color_tags "$TESTSTR7"

echo
echo "## tests of 'COLOR_*' variables:"
TESTSTR_VAR="<%s>my test text for constant %s</%s>"
for col in "${COLOR_VARS[@]}"; do
    eval "colcode=\$$col"
    parse_color_tags "$(printf "$TESTSTR_VAR" "$colcode" "$col" "$colcode")"
done

TESTSTR8="<bold>some bold text</bold>"
TESTSTR9="<bold>some bold text</bold>\n\
and <green>multiline</green>";
echo
echo "## test of the 'strip_colors' method"
echo 
PARSEDTESTSTR8=$(parse_color_tags "$TESTSTR8")
_echo "colorized: ${PARSEDTESTSTR8}"
strip_colors "stripped: ${PARSEDTESTSTR8}"
echo 
PARSEDTESTSTR9=$(parse_color_tags "$TESTSTR9")
_echo "colorized: ${PARSEDTESTSTR9}"
strip_colors "stripped: ${PARSEDTESTSTR9}"

quietecho "_ ok"
if [ "$QUIET" != 'true' ]; then libdebug "$*"; fi
exit 0

# Endfile
# vim: autoindent tabstop=4 shiftwidth=4 expandtab softtabstop=4 filetype=sh
