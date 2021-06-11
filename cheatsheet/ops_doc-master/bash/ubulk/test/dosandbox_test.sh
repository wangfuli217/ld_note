#!/bin/sh

cd `dirname $0` && . ./common.sh

localSetUp() {
	SANDBOXDIR="$SHUNIT_TMPDIR/sandbox"
}

#-------------------------------------------------------------------------

testDiesIfFails() {
	SANDBOXDIR="`pwd`/sandbox"
	MKSANDBOX="mkSandboxFail"
	runScript -s yes
	checkResults 23 "died with our failure code" \
		"^Mounting sandbox ($SANDBOXDIR)" "sandbox creation was attempted" \
		"^Error 23 while" "error is reported to user"
}
mkSandboxFail() {
	return 23
}

testCreateSandbox() {
	SANDBOXDIR="./sandbox"
	runScript -s yes
	checkResults 1 "error exit" \
		"^Mounting sandbox ($SANDBOXDIR)" \
			"sandbox creation is reported to user, and is in the right place" \
		"SANDBOXDIR must be an absolute path ($SANDBOXDIR)" \
			"script catches a relative path for sandbox dir"

	assertTrue "sandbox doesn't exist yet" "[ ! -f "$SANDBOXDIR/sandbox" ]"
	SANDBOXDIR="`pwd`/sandbox"
	MKSANDBOX="mkSandboxCreateSandbox"
	runScript -s yes
	checkResults 0 "clean exit" \
		"^Mounting sandbox ($SANDBOXDIR)" \
			"sandbox creation is reported to user, and is in the right place" \
		"" "no errors"
}
mkSandboxCreateSandbox() {
	mksandbox "$@"
	RTRN=$?

	assertTrue "sandbox exists" "[ -f "$SANDBOXDIR/sandbox" ]"

	return $RTRN
}

testArgsAreObeyed() {
	# test is based on the default arg of --rwdirs=/var/spool

	# remember, we're in an outer sandbox/chroot, so the stuff we do here
	# doesn't actually affect the real host

	TEST_FILE="var/spool/ubulk-test-$$"
	assertTrue "test file doesn't exist yet" "[ ! -f '/$TEST_FILE' ]"

	MKSANDBOX=mkSandboxArgsAreObeyed
	runScript -s yes
}
mkSandboxArgsAreObeyed() {
	mksandbox "$@"
	RTRN=$?

	assertTrue "we can 'touch' the test file" "$(touch "$SANDBOXDIR/$TEST_FILE"; echo $?)"
	assertTrue "after which, the file also exists in the mount base (so /var/spool was mounted rw)" \
		"[ -f '/$TEST_FILE' ]"

	return $RTRN
}

testCleansMountAfterCleanExit() {
	POST_SANDBOX_EVENT=0
	setupMountForCleaning

	checkResults $POST_SANDBOX_EVENT "exited with our test code" \
		"^Unmounting sandbox" "stdout says what's happening" \
		"" "nothing on stderr"
}

testCleansMountAfterErrorExit() {
	POST_SANDBOX_EVENT=23
	setupMountForCleaning

	checkResults $POST_SANDBOX_EVENT "exited with our test code" \
		"^Unmounting sandbox" "stdout says what's happening" \
		"" "nothing on stderr"
}

testCleansMountAfterInterrupt() {
	POST_SANDBOX_EVENT="INTERRUPT"
	setupMountForCleaning

	checkResults $((9 + 128)) "exited with term code" \
		"^Unmounting sandbox" "stdout says what's happening" \
		"^Caught signal 'INT'" "stderr explains the signal"
}

testCleansMountAfterTerm() {
	POST_SANDBOX_EVENT="TERM"
	setupMountForCleaning

	checkResults $((15 + 128)) "exited with term code" \
		"^Unmounting sandbox" "stdout says what's happening" \
		"^Caught signal 'TERM'" "stderr explains the signal"
}

setupMountForCleaning() {
	GREPSTR="on $SHUNIT_TMPDIR.\+ type null"
	if mount | grep "$GREPSTR" >/dev/null 2>&1 ; then
		fail "Earlier mounts are still present"
	fi

	assertTrue "sandbox doesn't exist yet" "[ ! -f "$SANDBOXDIR/sandbox" ]"

	MKSANDBOX=killerMkSandbox
	runScript -s yes

	assertTrue "sandbox was deleted" "[ ! -f "$SANDBOXDIR/sandbox" ]"
}

killerMkSandbox() {
	mksandbox "$@"
	RTRN=$?

	assertTrue "sandbox was created" "[ -f "$SANDBOXDIR/sandbox" ]"

	# note that this way of testing forces the script to have set up the traps
	# *before* calling mksandbox (which is what we want)
	getSubshellPid
	if [ "TERM" = "$POST_SANDBOX_EVENT" ]; then
		kill -SIGTERM $SUBSHELL_PID
	elif [ "INTERRUPT" = "$POST_SANDBOX_EVENT" ]; then
		kill -SIGINT $SUBSHELL_PID
	else
		exit $POST_SANDBOX_EVENT
	fi

	# just in case we survive this far
	return $RTRN
}
getSubshellPid() {
	# not POSIX, and a big hack, but it seem to be the best way
	# other than using bash explicitly
	SUBSHELL_PID=$(sh -c 'ps -p $$ -o ppid=')
}

testCheckMkConfDateIfNotDoingSandbox() {
	REALMK="/etc/mk.conf"
	FAKEMK="/tmp/fakemk.conf.$$"
	touch "$FAKEMK"

	mksandbox $MKSANDBOXARGS "$SANDBOXDIR" >/dev/null 2>&1
	assertTrue "sandbox script succeeded" $?
	assertTrue "sandbox is really there" "[ -f $SANDBOXDIR/sandbox ]"

	DOSANDBOX='no'

	MAKECONF="$REALMK"
	runScript -s no
	checkResults 0 "clean exit" \
		"^Skipping sandbox" "sandbox step skipped" \
		"" "no errors, with default mk.conf"

	touch "$REALMK" # remember, we're already in a chroot
	runScript -s no
	checkResults 0 "clean exit" \
		"^Skipping sandbox" "sandbox step skipped" \
		"WARNING: $MAKECONF is newer than $SANDBOXDIR/$MAKECONF" \
			"script warns if sandbox's settings are out of date"

	touch "$SANDBOXDIR/$FAKEMK"
	MAKECONF="$FAKEMK"
	runScript -s no
	checkResults 0 "clean exit" \
		"^Skipping sandbox" "sandbox step skipped" \
		"" "no warnings, even with alternate mk.conf path"

	sleep 1
	touch "$FAKEMK"
	runScript -s no
	checkResults 0 "clean exit" \
		"^Skipping sandbox" "sandbox step skipped" \
		"WARNING: $MAKECONF is newer than $SANDBOXDIR/$MAKECONF" \
			"script uses MAKECONF correctly"
}

testDoSandboxCreate() {
	SANDBOXDIR="`pwd`/sandbox"
	MKSANDBOX="mkSandboxCreateSandbox" # reuse it from above
	runScript -s create
	checkResults 0 "clean exit" \
		"^Mounting sandbox ($SANDBOXDIR)" "sandbox creation is reported to user" \
		"" "no errors"
	cat "$OUT" | grep "^Deleting sandbox" >/dev/null 2>&1;
	assertFalse "sandbox wasn't reported to be deleted" $?
	assertTrue "sandbox is really there" "[ -d $SANDBOXDIR ]"
	mount | grep "on $SANDBOXDIR" >/dev/null 2>&1
	assertTrue "sandbox is still mounted" $?

	"$SANDBOXDIR/sandbox" umount
}

testDoSandboxFailIfSandboxMounted() {
	SANDBOXDIR="`pwd`/sandbox"
	MKSANDBOX="mkSandboxCreateSandbox" # reuse it from above
	runScript -s create
	checkResults 0 "clean exit" \
		"^Mounting sandbox ($SANDBOXDIR)" "sandbox creation is reported to user" \
		"" "no errors"
	mount | grep "on $SANDBOXDIR" >/dev/null 2>&1
	assertTrue "sandbox is still mounted" $?

	runScript -s create # 'yes' would have worked as well
	checkResults 1 "error exit" \
		"^Mounting sandbox" "it started to mount the sandbox" \
		"^$SANDBOXDIR is already mounted" \
			"it won't re-mount if it's already mounted"

	"$SANDBOXDIR/sandbox" umount
}

#-------------------------------------------------------------------------

. ./shunit2
