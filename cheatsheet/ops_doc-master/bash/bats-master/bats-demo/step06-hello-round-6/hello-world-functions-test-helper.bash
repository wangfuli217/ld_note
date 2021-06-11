#!/bin/bash
source $BATS_TEST_DIRNAME/hello-world-logs-functions.sh
# change $BATS_TEST_DIRNAME if code under test is not in same folder as test

function functions_test_helper() {
  $@
}

function log_info_test_helper() {
  msg=$1 log_info_message
}

function log_error_test_helper() {
  msg=$1 log_error_message
}

function filter_stderr_test_helper() {
  $@ 1>/dev/null
}
