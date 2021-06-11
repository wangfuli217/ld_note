#!/usr/bin/env bash
# colors rendering benchmark

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

NAME="Terminal colors rendering benchmark"
VERSION="0.1.0"
DESCRIPTION="A script to test your terminal colors rendering ..."
SCRIPT_VCS='git'

parse_common_options "$@"
quietecho "_ go"
echo

linelg=$(tput cols)
normalcode=$(get_text_option_tag normal)
padder=$(printf '%0.1s' "-"{1..1000})

# test of colors foreground and background
colorstr=""
col1lg=$(( (linelg - 4) / 5 ))
col2lg=$(( 2 * col1lg ))
printf -v line "+%*.*s+%*.*s+%*.*s+\n" 0 $col1lg "$padder" 0 $col2lg "$padder"  0 $col2lg "$padder";
colorstr="${colorstr}${line}"
for col in "${LIBCOLORS[@]}"; do
    fgcolor=$(get_color_code "$col")
    bgcolor=$(get_color_code "$col" true)
    fgcolorcode=$(get_text_format_tag "$fgcolor")
    bgcolorcode=$(get_text_format_tag "$bgcolor")
    printf -v line \
        "|%-*s|%-*s|%-*s|\n" \
        "$col1lg" " color ${col} " \
        $((col2lg + $(string_length "$fgcolorcode") + $(string_length "$normalcode") )) " ${fgcolorcode} foreground code=${fgcolor} ${normalcode} " \
        $((col2lg + $(string_length "$bgcolorcode") + $(string_length "$normalcode") )) " ${bgcolorcode} background code=${bgcolor} ${normalcode} ";
    colorstr="${colorstr}${line}"
done
printf -v line "+%*.*s+%*.*s+%*.*s+\n" 0 "$col1lg" "$padder" 0 "$col2lg" "$padder" 0 "$col2lg" "$padder";
colorstr="${colorstr}${line}"
echo "## Text colors demo:"
_echo "$colorstr"

# test of text options
txtoptstr=""
col1lg=$(( (linelg - 3) / 5 ))
col2lg=$(( 4 * col1lg ))
printf -v line "+%*.*s+%*.*s+\n" 0 "$col1lg" "$padder" 0 "$col2lg" "$padder";
txtoptstr="${txtoptstr}${line}"
for col in "${LIBTEXTOPTIONS[@]}"; do
    txtopt=$(get_text_option_code "$col")
    txtoptcode=$(get_text_format_tag "$txtopt")
    cell="using code=${txtopt}: ${txtoptcode}%-.*s${normalcode}";
    printf -v cuttedcell "$cell" $(( col2lg - $(strlen "$cell") + $(strlen "$normalcode") + $(strlen "$normalcode") )) "$LOREMIPSUM"
    printf -v line \
        "|%-*s|%-*s|\n" \
        "$col1lg" " text option ${col} " \
        $((col2lg + $(strlen "$cell") - 40)) " $cuttedcell ";
    txtoptstr="${txtoptstr}${line}"
done
printf -v line "+%*.*s+%*.*s+\n" 0 "$col1lg" "$padder" 0 "$col2lg" "$padder";
txtoptstr="${txtoptstr}${line}"
echo "## Text options demo:"
_echo "$txtoptstr"

# test of library presets
presetoptstr=""
col1lg=$(( (linelg - 3) / 5 ))
col2lg=$(( 4 * col1lg ))
printf -v line "+%*.*s+%*.*s+\n" 0 "$col1lg" "$padder" 0 "$col2lg" "$padder";
presetoptstr="${presetoptstr}${line}"
for col in "${COLOR_VARS[@]}"; do
    cell="<${!col}>%-.*s</${!col}>";
    printf -v cuttedcell "$cell" $((col2lg - $(string_length "$cell") - $(string_length "$col") - $(string_length "$col") )) "$LOREMIPSUM"
    printf -v line \
        "|%-*s|%-*s|\n" \
        "$col1lg" " preset ${col} " \
        $((col2lg + $(string_length "$cell") - 5)) " $cuttedcell ";
    presetoptstr="${presetoptstr}${line}"
done
printf -v line "+%*.*s+%*.*s+\n" 0 "$col1lg" "$padder" 0 "$col2lg" "$padder";
presetoptstr="${presetoptstr}${line}"
echo "## Library presets demo:"
parse_color_tags "$presetoptstr"


quietecho "_ ok"
if [ "$QUIET" != 'true' ]; then libdebug "$*"; fi
exit 0

# Endfile
# vim: autoindent tabstop=4 shiftwidth=4 expandtab softtabstop=4 filetype=sh
