#!/bin/sh

cd `dirname $0` && . ./common.sh

localOneTimeSetUp() {
	LOG="$SHUNIT_TMPDIR/log"
}

#-------------------------------------------------------------------------

testLogingSetup() {
	(
		. $UTILSH
		setup_console_and_logging
	) >$OUT 2>$ERR
	RTRN=$?
	checkResults 1 "if we don't pass an arg, we die" \
		"" "nothing on stdout" \
		"must pass path to log file" "we're told what the problem is"

	(
		. $UTILSH
		setup_console_and_logging "$LOG"
	) >$OUT 2>$ERR
	RTRN=$?
	checkResults 0 "when we pass log path, everything is happy" \
		"^Logging to $LOG" "stdout tells us where we're logging" \
		"" "nothing on stderr"
}

testOutputDestinationsAndLineOrdering() {
	(
		. $UTILSH
		setup_console_and_logging "$LOG"
		echo "1: stdout goes to log"
		echo >&2 "2: stderr goes to log"
		console "3: console goes to 'real' stdout and to log"
		console_err "4: console err goes to 'real' stderr and to log"
		echo "5: fd3 goes to 'real' stdout and not log" >&3
		echo "6: fd4 goes to 'real' stderr and not log" >&4
	) >$OUT 2>$ERR
	RTRN=$?

	assertEquals "ran cleanly" "0" "$RTRN"

	E_LOG="$(cat <<- EOF
		1: stdout goes to log
		2: stderr goes to log
		3: console goes to 'real' stdout and to log
		4: console err goes to 'real' stderr and to log
	EOF
	)"
	checkLog "log got stdout, stderr, console, and console_err" "$E_LOG"

	E_OUT="$(cat <<- EOF
		Logging to $LOG
		3: console goes to 'real' stdout and to log
		5: fd3 goes to 'real' stdout and not log
	EOF
	)"
	checkOut "stdout got console, fd3" "$E_OUT"

	E_ERR="$(cat <<- EOF
		4: console err goes to 'real' stderr and to log
		6: fd4 goes to 'real' stderr and not log
	EOF
	)"
	checkErr "stderr got console_err, fd4" "$E_ERR"
}

testDieWorksWithNoConsoleCall() {
	(
		. $UTILSH
		setup_console_and_logging "$LOG"
		die 23
	) >$OUT 2>$ERR
	RTRN=$?

	assertEquals "we exited as expected" 23 $RTRN
	checkOut "nothing extra on stdout" "Logging to $LOG"
	checkLog "log shows the error" 'Error 23 while ""'

	E_ERR="$(cat <<- EOF
		Error 23 while ""
		 > 

		See $LOG for details
	EOF
	)"
	checkErr "real stderr shows (somewhat broken) failure info, and log file" "$E_ERR"
}

testDieAfterConsoleCall() {
	START="Starting some process"
	(
		. $UTILSH
		setup_console_and_logging "$LOG"
		console "$START"
		die 23
	) >$OUT 2>$ERR
	RTRN=$?

	assertEquals "we exited as expected" 23 $RTRN

	E_OUT="$(cat <<- EOF
		Logging to $LOG
		$START
	EOF
	)"
	checkOut "stdout shows what we expect" "$E_OUT"


	E_ERR="$(cat <<- EOF
		Error 23 while "$START"
		 > 

		See $LOG for details
	EOF
	)"
	checkErr "stderr shows the error and the prior console message" "$E_ERR"

	E_LOG="$(cat <<- EOF
		$START
		Error 23 while "$START"
	EOF
	)"
	checkLog "log shows the start and the error, but not the rest" "$E_LOG"
}

testLogLinesLimitBasics() {
	(
		. $UTILSH
		setup_console_and_logging "$LOG"
		echo "$LOGLINESLIMIT"  # (to log file)
	) >$OUT 2>$ERR
	checkLog "default LOGLINESLIMIT is 10" "10"

	(
		. $UTILSH
		LOGLINESLIMIT=5
		setup_console_and_logging "$LOG"
		echo "$LOGLINESLIMIT"  # (to log file)
	) >$OUT 2>$ERR
	checkLog "can override LOGLINESLIMIT" "5"
}

testDieLoggingWithLittleLogging() {
	START="Starting some process"
	(
		. $UTILSH
		setup_console_and_logging "$LOG"
		console "$START"
		echo one
		echo two
		die 23
	) >$OUT 2>$ERR
	RTRN=$?

	assertEquals "we exited as expected" 23 $RTRN

	E_OUT="$(cat <<- EOF
		Logging to $LOG
		$START
	EOF
	)"
	checkOut "stdout shows what we expect" "$E_OUT"

	E_ERR="$(cat <<- EOF
		Error 23 while "$START"
		 > one
		 > two

		See $LOG for details
	EOF
	)"
	checkErr "stderr shows the error, the prior console message, and the following logs" "$E_ERR"

	E_LOG="$(cat <<- EOF
		$START
		one
		two
		Error 23 while "$START"
	EOF
	)"
	checkLog "log shows the start, the logs, and the error, but not the rest" "$E_LOG"
}

testDieLoggingWithLotsOfLogging() {
	START="Starting some process"
	(
		. $UTILSH
		LOGLINESLIMIT=0
		setup_console_and_logging "$LOG"
		console "$START"
		echo one
		echo two
		die 23
	) >$OUT 2>$ERR
	RTRN=$?

	assertEquals "we exited as expected" 23 $RTRN

	E_OUT="$(cat <<- EOF
		Logging to $LOG
		$START
	EOF
	)"
	checkOut "stdout shows what we expect" "$E_OUT"

	E_ERR="$(cat <<- EOF
		Error 23 while "$START"

		See $LOG for details
	EOF
	)"
	checkErr "stderr shows the error, the prior console message, and NO following logs" "$E_ERR"

	E_LOG="$(cat <<- EOF
		$START
		one
		two
		Error 23 while "$START"
	EOF
	)"
	checkLog "log shows the start, the logs, and the error, but not the rest" "$E_LOG"
}

testConsoleAndDieAsIfInChroot() {
	MESSAGE="Call console without first setting up logging"
	(
		. $UTILSH

		# inside a chroot, we will still have all the redirections that were
		# setup outside the chroot, but we may not have the environment
		# variables (i.e. LOGPATH). so to test that, we have to go ahead
		# and set up the redirects, then clean up here and there, then unset
		# LOGPATH, so it is basically the same
		setup_console_and_logging "$LOG"
		LOGPATH=
		echo -n > $OUT

		# ok, now we can do stuff
		console "$MESSAGE"
		die 23
	) >$OUT 2>$ERR
	RTRN=$?

	assertEquals "we exited as expected" 23 $RTRN
	checkOut "console works even without setup" "$MESSAGE"
	checkLog "die works even without setup" \
		"$(printf "$MESSAGE\nError 23 while \"$MESSAGE\"")"
	checkErr "real stderr shows failure info even without setup" \
		"Error 23 while \"$MESSAGE\""
}

#-------------------------------------------------------------------------

checkOut() {
	assertEquals "$1" "$2" "$(cat $OUT)"
}

checkErr() {
	assertEquals "$1" "$2" "$(cat $ERR)"
}

checkLog() {
	assertEquals "$1" "$2" "$(cat $LOG)"
}

. ./shunit2 
