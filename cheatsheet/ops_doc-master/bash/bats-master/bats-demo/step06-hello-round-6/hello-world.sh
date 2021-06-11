#!/bin/bash

script_dir=$(readlink -f $0 | xargs dirname)
script_name=$(readlink -f $0 | xargs basename)

source $script_dir/hello-world-logs-functions.sh

function usage() {
   echo "Usages:"
   echo "    hello-world.sh [-v] -n name : output Hello name!"
   echo "    hello-world.sh -h : show the help"
   echo "Parameters :"
   echo "    -v : increase verbosity"
   echo "    -n name : indicates the name of the person to say hello to"
   echo "    -h : display the usage"
}

errors=()
#[[ $# -eq 0 ]] && errors+=("Usage: $script_name [-v] -n name")
[[ $# -eq 0 ]] && usage

# read arguments
#
#name=$1
name=
verbosity=0
while getopts "vhn:" opt; do
  case $opt in
    v)
      let verbosity++
      #echo "verbose mode is on"
      log_info "verbose mode is on"
      ;;
    h)
      usage
      exit
      ;;
    n)
      name=$OPTARG
      #[[ $verbosity -ge 1 ]] && echo "input parameter name = '""$name""'"
      [[ $verbosity -ge 1 ]] && log_info "input parameter name = '""$name""'"
      ;;
  esac
done

# check arguments
#
[[ -z $name ]] && errors+=("No name provided. Name is mandatory!")

#[[ -z ${errors[@]} ]] || { for i in "${errors[@]}"; do echo $i; done; exit 1; }
[[ -z ${errors[@]} ]] || { for i in "${errors[@]}"; do log_error $i; done; exit 1; }

# do the task
#
echo "Hello $name!"
