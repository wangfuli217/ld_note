#!/usr/bin/env bats
#
# depend on https://github.com/sstephenson/bats
#

RTUCLIENT="hostd -q -H 192.168.27.172 -p 8002"

load ../test_helper


@test "hostd debug" {
  run ${RTUCLIENT} debug 0
  [ $status -eq 0 ]
  [ $( echo $output | grep "disable" -c ) -ne 0 ]
  
  run ${RTUCLIENT} debug 1
  [ $status -eq 0 ]
  [ $( echo $output | grep "enable" -c ) -ne 0 ]
}



