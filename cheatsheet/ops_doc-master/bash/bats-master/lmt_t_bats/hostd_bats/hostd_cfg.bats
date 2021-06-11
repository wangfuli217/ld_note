#!/usr/bin/env bats
#
# depend on https://github.com/sstephenson/bats
#

RTUCLIENT="hostd -q -H 192.168.27.172 -p 8002"

load ../test_helper

@test "hostd cfg" {
  output="$($RTUCLIENT cfg-default 2>&1)"
  [[ $status -eq 0 ]]
  [ $( echo $output | grep "default value" -c ) -ne 0 ]
}

test_hostd_cfg(){
  output="$($RTUCLIENT cfg-default 2>&1)"
  [[ $status -eq 0 ]]
  [ $( echo $output | grep "default value" -c ) -ne 0 ]
}


