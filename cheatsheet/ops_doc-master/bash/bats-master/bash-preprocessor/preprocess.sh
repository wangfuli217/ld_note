#!/bin/bash

set -euo pipefail

# Parameters:
source_file=$1           # source file, mandatory
start=${2:-@@@START@@@}  # preprocess start token, optional
end=${3:-@@@END@@@}      # preprocess end token, optional

# State variables:
tmp=""                   # temp file where the result of the processing is accumulated
macro_code=""            # temp file where the macro code is accumulated to be executed later
shebang_line=""          # shebang to be used to execute the macros
in_macro="false"         # indicates if the current processed line is macro code or not
line_number=0            # number of currently processed line

main() {
  # Create temp files in the current directory.
  export TMPDIR=$(dirname "$0")

  # Create an empty temp file with the same permissions and attributes as the source file
  tmp=$(mktemp)
  cp "${source_file}" "${tmp}"
  printf "" > "${tmp}"

  # Create a temp file to store the macro code
  macro_code=$(mktemp)

  # Use the shebang line found in the input file to execute the macros
  shebang_line=$(head -n 1 "${source_file}")
  # If the first line is not a shebang line, use a default
  if [[  "${shebang_line}" != "#!"* ]]; then
    shebang_line="#!/bin/bash"
  fi

  # Loop over each line of the input file
  while IFS= read -r line
  do
    line_trim=$(string::trim "$line")
    line_number=$((line_number+1))

    if [[ "${in_macro}" == "false" ]]; then
      if [[ "${line_trim}" == "${end}" ]];
      then
        error "Unmatched ${end} found"
      elif [[ "${line_trim}" == "${start}" ]];
      then
        in_macro="true"
        echo "${shebang_line}" > $macro_code
      else
        echo "$line" >> $tmp
      fi
    else
      if [[ "${line_trim}" == "${start}" ]];
      then
        error "${start} can not be nested"
      elif [[ "${line_trim}" == "${end}" ]];
      then
        in_macro="false"
        chmod +x $macro_code
        $macro_code >> $tmp
      else
        echo "${line}" >> $macro_code
      fi
    fi
  done < "$source_file"

  # Overwrite source file with the result
  cp "${tmp}" "${source_file}"
}

# Error handling: print error and exit immediately to prevent the corruption of the source file.
error() {
    local msg=$1
	>&2 echo "Preprocessor error at line ${line_number}: ${msg}"
	exit 1
}

# Trim string, e.g. " hello " -> "hello"
# From https://github.com/labbots/bash-utility/blob/master/src/string.sh
string::trim() {
    [[ $# = 0 ]] && printf "%s: Missing arguments\n" "${FUNCNAME[0]}" && return 2

    : "${1#"${1%%[![:space:]]*}"}"
    : "${_%"${_##*[![:space:]]}"}"
    printf '%s\n' "$_"
}

# Remove temporary files at exit
cleanup_temp_files() {
  rm "${tmp}"
  rm "${macro_code}"
}
trap cleanup_temp_files EXIT

main

