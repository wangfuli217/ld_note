#!/bin/bash

# Load the code under test
. greetings.sh

# Tests
function testCanCallExternalFunction() {
  assertEquals "Hello World" "$(greet)"
}

testWriteGreetingToFile() {
  writeGreeting $tmpFile
  assertTrue "File $tmpFile should exist" "[ -e $tmpFile ]"
}

# Setup & Teardown
oneTimeSetUp() {
  SHUNIT_TMPDIR="work"
  mkdir "$SHUNIT_TMPDIR"
  tmpFile="${SHUNIT_TMPDIR}/greeting"
}

oneTimeTearDown() {
  if [ -e "$SHUNIT_TMPDIR" ]; then
    rm -r "$SHUNIT_TMPDIR"
  fi 
}

setUp() {
  if [ -e $tmpFile  ]; then
    rm -r $tmpFile
  fi
}

# load shunit2
. ../shunit2
