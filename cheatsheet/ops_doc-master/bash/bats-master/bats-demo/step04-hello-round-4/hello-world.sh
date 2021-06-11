#!/bin/bash
errors=()
script_name=$(readlink -f $0 | xargs basename)
#[[ $# -ne 1 ]] && errors+="Usage: $0 <name>"
#[[ $# -ne 1 ]] && errors+=("Usage: $0 <name>")
[[ $# -ne 1 ]] && errors+=("Usage: $script_name <name>")

name=$1
#[[ -z $name ]] && errors+="No name provided. Name is mandatory!"
[[ -z $name ]] && errors+=("No name provided. Name is mandatory!")

#[[ -z ${errors[@]} ]] || { for i in ${errors[@]}; do echo "$i"; done; exit 1; }
[[ -z ${errors[@]} ]] || { for i in "${errors[@]}"; do echo $i; done; exit 1; }

echo "Hello $name!"
