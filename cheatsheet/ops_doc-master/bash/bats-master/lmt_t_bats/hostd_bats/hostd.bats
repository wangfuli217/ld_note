#!/usr/bin/env bats
#
# depend on https://github.com/sstephenson/bats
#

RTUCLIENT="hostd -q -H 192.168.27.172 -p 8002"

load ../test_helper

@test "hostd version" {
  run ${RTUCLIENT} -v
  [ $status -eq 0 ]
  [ $( echo $output | grep "xianleidi" -c ) -ne 0 ]
}

@test "hostd config" {
  run ${RTUCLIENT} config
  [ $status -eq 0 ]
  [ $( echo $output | grep "xianleidi" -c ) -ne 0 ]
}

@test "hostd script" {
  echo "serial" >script
  run ${RTUCLIENT} -f script
  [ $status -eq 0 ]
  [ $( echo $output | grep "@mcu@" -c ) -ne 0 ]
  rm script
}

@test "hostd conn-info" {
  run ${RTUCLIENT} conn-info
  [ $status -eq 0 ]
  [ $( echo $output | grep "info" -c ) -ne 0 ]
}

