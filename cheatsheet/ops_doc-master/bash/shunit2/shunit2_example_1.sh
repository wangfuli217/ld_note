#! /bin/sh
#assume this test script is in a subdirectory under the shunit directory; a sibling of examples

#Load test helpers.
. shunit2_test_helpers

testOne() {
assertTrue 0
}

testTwo() {
assertTrue 0
}

setUp() {
echo "in setUp"
}

tearDown() {
#need this to suppress tearDown on script EXIT
\[ "${_shunit_name_}" = 'EXIT' ] && return 0
echo "in tearDown"
}

oneTimeSetUp() {
echo "in oneTimeSetUp"
}

oneTimeTearDown() {
echo "in oneTimeTearDown"
}

#Load and run shUnit2.
. shunit2