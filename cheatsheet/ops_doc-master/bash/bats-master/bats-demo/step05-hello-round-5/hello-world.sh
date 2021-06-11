#!/bin/bash
errors=()
script_name=$(readlink -f $0 | xargs basename)
#[[ $# -ne 1 ]] && errors+=("Usage: $script_name <name>")
#[[ $# -eq 0 ]] && errors+=("Usage: $script_name <name>")
[[ $# -eq 0 ]] && errors+=("Usage: $script_name [-v] -n name")

# read arguments
#
#name=$1
name=
verbosity=0
while getopts "vn:" opt; do
  case $opt in
    v)
      let verbosity++
      echo "verbose mode is on"
      ;;
    n)
      name=$OPTARG
      #echo "input parameter name = '""$name""'"
      [[ $verbosity -ge 1 ]] && echo "input parameter name = '""$name""'"
      ;;
  esac
done

# check arguments
#
[[ -z $name ]] && errors+=("No name provided. Name is mandatory!")

[[ -z ${errors[@]} ]] || { for i in "${errors[@]}"; do echo $i; done; exit 1; }

# do the task
#
echo "Hello $name!"
