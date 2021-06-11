#!/bin/sh

cd `dirname $0` && . ./common.sh

FOUNDIT="foundit!"

localSetUp() {
	# mock defaults.conf,  which (for now) is the first thing loaded
	cat <<- EOF > "$SHUNIT_TMPDIR/$DEFAULTSCONF"
		echo "$FOUNDIT"
		exit 0
	EOF
}

#-------------------------------------------------------------------------

testDirectCallFromItsDir() {
	assertEquals "Found lib dir" "$FOUNDIT" "$(_runScript ./$SCRIPTNAME)"
}

testDirectCallFromOtherDir() {
	mkdir other && cd other
	assertEquals "Found lib dir" "$FOUNDIT" "$(_runScript ../$SCRIPTNAME)"
}

testSameNameAbsPathSymlinkFromOtherDir() {
	mkdir other && cd other
	ln -s $SHUNIT_TMPDIR/$SCRIPTNAME
	assertEquals "Found lib dir" "$FOUNDIT" "$(_runScript ./$SCRIPTNAME)"
}

testSameNameRelPathSymlinkFromOtherDir() {
	mkdir other && cd other
	ln -s ../$SCRIPTNAME
	assertEquals "Found lib dir" "$FOUNDIT" "$(_runScript ./$SCRIPTNAME)"
}

testDiffNameAbsPathSymlinkFromSameDir() {
	ln -s $SHUNIT_TMPDIR/$SCRIPTNAME newname.sh
	assertEquals "Found lib dir" "$FOUNDIT" "$(_runScript ./newname.sh)"
}

testDiffNameRelPathSymlinkFromSameDir() {
	ln -s ./$SCRIPTNAME newname.sh
	assertEquals "Found lib dir" "$FOUNDIT" "$(_runScript ./newname.sh)"
}

testDiffNameAbsPathSymlinkFromOtherDir() {
	mkdir other && cd other
	ln -s $SHUNIT_TMPDIR/$SCRIPTNAME ./newname.sh
	assertEquals "Found lib dir" "$FOUNDIT" "$(_runScript ./newname.sh)"
}

testDiffNameRelPathSymlinkFromOtherDir() {
	mkdir other && cd other
	ln -s ../$SCRIPTNAME ./newname.sh
	assertEquals "Found lib dir" "$FOUNDIT" "$(_runScript ./newname.sh)"
}

#-------------------------------------------------------------------------

. ./shunit2
