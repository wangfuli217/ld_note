#!/usr/bin/env bats

@test "simple-echo should output foo" {
  run simple-echo.sh  "foo"
  [ "$status" -eq 0 ]
  [ "$output" = "foo" ]
}
