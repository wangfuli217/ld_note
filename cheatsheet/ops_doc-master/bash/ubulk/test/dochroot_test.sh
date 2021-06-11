#!/bin/sh

cd `dirname $0` && . ./common.sh

localSetUp() {
	SANDBOXDIR="$PATHROOT/sandbox"
}

#-------------------------------------------------------------------------

testScriptDiesIfChrootBreaks() {
	CHROOT='chroot_die'
	runScript -c yes
	checkResults 23 "script exited with test code" \
		"^Entering chroot ($SANDBOXDIR)" "we tried to enter the chroot" \
		"^Error 23 while \"Entering chroot" "the error is reported on console_err"
}
chroot_die() {
	return 23
}

testLogOutput() {
	CHROOT='chroot_logging'
	runScript -s yes -c yes
	checkResults 0 "script exited cleanly" \
		"^This is chroot console$" "'console' works in chroot" \
		"^This is chroot console_err" "'console_err' works in chroot" \
		"^This is chroot stdout" "chroot stdout goes to external log file"
	if cat $OUT | grep "This is chroot stdout" >/dev/null 2>&1 ; then
		fail "chroot stdout is going to console"
		cat $OUT
	fi
	cat "$BUILDLOG" | grep "^This is chroot stderr" >/dev/null 2>&1
	assertTrue "chroot stderr goes to external log file" $? || cat "$BUILDLOG"
}
chroot_logging() {
	cat <<- EOF >> "$SANDBOXDIR$CHROOTSCRIPT"
		echo "This is chroot stdout"
		echo "This is chroot stderr" >&2
		console "This is chroot console"
		console_err "This is chroot console_err"
	EOF
	
	chroot "$@"
}

TESTFILE="/tmp/canyouseeme.$$"
testChrootIsMade() {
	touch "$TESTFILE"
	CHROOT='chroot_ismade'
	runScript -s yes -c yes
	checkResults 0 "script exited cleanly" \
		"^In chroot; file visible: no" "script in chroot can't see TESTFILE" \
		"" "nothing on stderr"
}
chroot_ismade() {
	cat <<- EOF >> "$SANDBOXDIR$CHROOTSCRIPT"
		if [ -f $TESTFILE ]; then
			FILE_VISIBLE=yes
		else
			FILE_VISIBLE=no
		fi
		console "In chroot; file visible: \$FILE_VISIBLE"
	EOF

	chroot "$@"
}

testChrootExitsNoMatterWhat() {
	CHROOT='chroot_kill'
	runScript -s yes -c yes
	checkResults 137 "exit code indicates kill" \
		"^We are in the chroot$" "stdout shows that we were in the chroot" \
		"^Error 137 while \"Entering chroot" "death is reported gracefully" \
		"Killed.*chroot" "Log indicates the error"
}
chroot_kill() {
	cat <<- EOF >> "$SANDBOXDIR$CHROOTSCRIPT"
		console "We are in the chroot"
		trap - SIGKILL
		kill -SIGKILL \$\$
	EOF

	chroot "$@"
}

testSandboxFromPriorRun() {
	CHROOT='chroot_first'
	runScript -s create -c yes
	checkResults 0 "script made it through first round" \
		"^Creating test file" "script created test file" \
		"" "nothing on stderr"

	CHROOT='chroot_second'
	runScript -s no -c yes
	checkResults 0 "script made it through second round" \
		"^Found test file" "test file is still there" \
		"" "nothing on stderr"
}
chroot_first() {
	cat <<- EOF >> "$SANDBOXDIR$CHROOTSCRIPT"
		console "Creating test file"
		touch /testfile
	EOF

	chroot "$@"
}
chroot_second() {
	cat <<- EOF >> "$SANDBOXDIR$CHROOTSCRIPT"
		if [ -f /testfile ]; then
			console "Found test file"
		fi
	EOF

	chroot "$@"
}

INCLUDED_VARS="PKGLIST
PKGSRC"
EXCLUDED_VARS="BOOTSTRAP
BUILDLOG
CHROOT
CHROOTSCRIPTNAME
CHROOTWORKDIR
CONFIG
DOCHROOT
DOPKGCHK
DOPKGSRC
DOSANDBOX
EXTRACHROOTVARS
INSTPBULK
DOPBULK
MKSANDBOX
MKSANDBOXARGS
PKGCHK
SANDBOXDIR"
testScriptVarsArePassedIn() {
	CHROOT='chroot_env'
	runScript -s yes -c yes
	checkResults 0 "script ran cleanly" \
		"^Entering chroot" "we entered the chroot" \
		"" "nothing on stderr" \
		"^CHROOT SET:$" "the environment was reported to us"

	loadDefaultVarList # see common.sh
	echo "$DEFAULTVARS" | while read LINE ; do
		if echo "$INCLUDED_VARS" | grep "$LINE" >/dev/null 2>&1 ; then
			cat "$BUILDLOG" | grep "^$LINE=" >/dev/null 2>&1
			assertTrue "var $LINE was present" $?
		elif echo "$EXCLUDED_VARS" | grep "$LINE" >/dev/null 2>&1 ; then
			cat "$BUILDLOG" | grep "^$LINE=" >/dev/null 2>&1
			assertFalse "var $LINE was not present" $?
		else
			fail "you need to add $LINE to INCLUDED_VARS or EXCLUDED_VARS"
		fi
	done
}
chroot_env() {
	cat <<- EOF >> "$SANDBOXDIR$CHROOTSCRIPT"
		echo "CHROOT SET:"
		set
	EOF

	chroot "$@"
}

testExtraVarsArePassedIn() {
	CHROOT='chroot_env'
	EXTRACHROOTVARS='TESTVAR1 TESTVAR2 TESTVAR3'
	TESTVAR1='this one is set'
	TESTVAR2=""
	unset TESTVAR3
	assertTrue "TESTVAR3 is unset" "[ -z ${TESTVAR3+x} ]"

	runScript -s yes -c yes
	checkResults 0 "script ran cleanly" \
		"^Entering chroot" "we entered the chroot" \
		"" "nothing on stderr" \
		"^CHROOT SET:$" "the environment was reported to us"

	cat "$BUILDLOG" | grep "^TESTVAR1='this one is set'$" >/dev/null 2>&1
	assertTrue "a set var was passed in" $?

	cat "$BUILDLOG" | grep "^TESTVAR2=$" >/dev/null 2>&1
	assertTrue "a set-to-empty var was passed in" $?

	cat "$BUILDLOG" | grep "^TESTVAR3=" > /dev/null 2>&1
	assertFalse "an unset var was not passed in" $?
}

testPathsAndUsersAreConfigurableXXX() {
	# scratch -> PBULK_WRKOBJDIR
	# bulklog -> PBULK_BULKLOG
	# pbulk user -> PBULK_UNPRIVILIGED_USER
	startSkipping
	fail "impelement this" # XXX
}

testChrootIsNotStrictlyNecessary() {
	# remember, we're already in a chroot

	SANDBOXDIR="/." # override our localSetUp
	runScript # everything is off
	checkResults 0 "script runs fine this way" \
		"WARNING: Not using chroot" "the user was warned" \
		"" "nothing on stderr"

	# also check that extra vars weren't passed in
	cat "$OUT" | grep "^Extra chroot var" >/dev/null 2>&1
	assertFalse "chroot vars weren't passed in" $?
}

#-------------------------------------------------------------------------

. ./shunit2

