#!/bin/sh

cd `dirname $0` && . ./common.sh

#-------------------------------------------------------------------------

testMissingPkgChk() {
	PKGCHK=fake_package_check
	runScript -k yes
	checkResults 0 "script finishes even with missing pkg_chk" \
		"Can't find fake_package_check" "script looked for take pkg_chk" \
		"" "nothing on stderr"
}

happyPkgChk() {
	return 0
}

testHappyPkgChk() {
	PKGCHK=happyPkgChk
	runScript -k yes
	checkResults 0 "script exits cleanly" \
		"^Checking for missing" "normal stuff on stdout" \
		"^happyPkgChk says everything is in sync, exiting" "script reports no results, and exiting"
}

sadPkgChk() {
	echo "Here are some $PKGCHK results: $@"
	return 0
}

testSadPkgChk() {
	PKGCHK=sadPkgChk
	PKGLIST=fakepkglist
	runScript -k yes
	checkResults 0 "script exits cleanly" \
		"^  Here are some $PKGCHK results: .*$PKGLIST" \
			"script reports the results to the user, and used the right pkglist path" \
		"" "nothing on stderr"
}

#-------------------------------------------------------------------------

. ./shunit2
