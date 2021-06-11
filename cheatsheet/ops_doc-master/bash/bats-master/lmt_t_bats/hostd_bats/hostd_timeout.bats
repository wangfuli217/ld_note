#!/usr/bin/env bats
#
# depend on https://github.com/sstephenson/bats
#

RTUCLIENT="hostd -q -H 192.168.27.172 -p 8002"

load ../test_helper


@test "hostd test-timeout" {
  run ${RTUCLIENT} test-timeout 1000
  [ $status -eq 0 ]
  [ $( echo $output | grep "1000" -c ) -ne 0 ]
  
  run ${RTUCLIENT} test-timeout
  [ $status -eq 0 ]
}



