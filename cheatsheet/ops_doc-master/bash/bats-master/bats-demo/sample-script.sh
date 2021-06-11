#!/bin/bash

usage="usage: $0 [-v[v]] -n name -c nb"

# initialisations
#
status=0
statusMessages=( "SUCCESS" "FAILURE" )
errorMessages=()
name=""
count=1
verbosity=0

function clean_exit() {
  # print the status and exit
  echo ${statusMessages[status]}
  #for m in "${errorMessages[@]}"; do
  for m in "${errorMessages[@]}"; do
     echo $m
  done
  exit $status
}

function output_info() {
      [[ $verbosity -ge 1 ]] && echo "INFO $1" >&2
}
function output_debug() {
      [[ $verbosity -ge 2 ]] && echo "DEBUG $1" >&2
}

trap clean_exit SIGHUP SIGINT SIGTERM

# read arguments
#
while getopts "hvn:c:" opt; do
  case $opt in
    h)
      echo $usage
      clean_exit
      #clean_exit
      ;;
    v)
      let verbosity+=1
      ;;
    n)
      name=$OPTARG
      output_debug "-n was triggered. Parameter: $name"
      ;;
    c)
      count=$OPTARG
      output_debug "-c was triggered. Parameter: $count"
      ;;
  esac
done

# check arguments
#
[ $OPTIND -eq 1 ] && errorMessages+=("$usage") && status=1

output_info  "checking names"
[[ -z $name ]] && errorMessages+=('name is mandatory') && status=1
output_info  "checking count"
#[[ $count =~ '^[0-9]+$' ]] && errorMessages+=('count should an integer') && status=1
[[ ! $count =~ ^[0-9]+$ ]] && errorMessages+=('count should an integer') && status=1

[[ $status -ne 0 ]] && clean_exit

# does the task
#
output_info "starting task"
#[[ -z $name ]] || seq $count | xargs  echo "Hello $name"
[[ -z $name ]] || seq $count | xargs -I{} echo "Hello $name"
output_info " end of task"

# end of program
#
clean_exit
