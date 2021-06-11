#!/bin/sh

cd `dirname $0` && . ./common.sh

#-------------------------------------------------------------------------

# mock out git
git() {
	echo "$@: $GIT_OUTPUT"
	return $GIT_RESULT
}

testDoPkgsrc() {
	mkdir pkgsrc

	GIT_RESULT=0
	GIT_OUTPUT="Some example output from git"
	PKGSRC="./pkgsrc"
	runScript -p yes
	checkResults 0 "script finished cleanly" \
		"^Updating pkgsrc (./pkgsrc)" "used right path for pkgsrc" \
		"" "nothing on stderr" \
		"^pull: $GIT_OUTPUT" "called 'pull' and logged the output"

	GIT_RESULT=1
	GIT_OUTPUT="Some error from git"
	runScript -p yes
	checkResults 1 "script died because of git problem" \
		"^Updating pkgsrc (./pkgsrc)" "used right path for pkgsrc" \
		"pull: $GIT_OUTPUT" "showed the user the error" \
		"^pull: $GIT_OUTPUT" "called 'pull' and logged the output"
}

#-------------------------------------------------------------------------

. ./shunit2
