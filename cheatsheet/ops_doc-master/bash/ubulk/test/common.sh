#-------------------------------------------------------------------------
# set a few handy globals

SCRIPTNAME=ubulk-build
DEFAULTSCONF=lib/defaults.conf
UTILSH=lib/util.sh

if [ -n "$1" ]; then
	TESTNAME="$1"
	shift
fi

#-------------------------------------------------------------------------
# some test helpers (and auto-setup)

oneTimeSetUp() {
	switchToChroot "$SHUNIT_TMPDIR"

	OUT="$SHUNIT_TMPDIR/stdout"
	ERR="$SHUNIT_TMPDIR/stderr"

	if fn_exists "localOneTimeSetUp" ; then
		localOneTimeSetUp
	fi
}

oneTimeTearDown() {
	if fn_exists "localOneTimeTearDown" ; then
		localOneTimeTearDown
	fi
}

setUp() {
	local - && set -e

	cp "../$SCRIPTNAME" "$SHUNIT_TMPDIR/"
	if [ -d "$SHUNIT_TMPDIR/lib" ]; then
		# this happens if DELETE_SANDBOX is 'no'
		rm -rf "$SHUNIT_TMPDIR/lib.prior"
		mv "$SHUNIT_TMPDIR/lib" "$SHUNIT_TMPDIR/lib.prior"
	fi
	mkdir "$SHUNIT_TMPDIR/lib"
	cp ../lib/* "$SHUNIT_TMPDIR/lib/"

	neuterPaths "$SHUNIT_TMPDIR"

	if fn_exists "localSetUp" ; then
		localSetUp
	fi

	INITDIR=`pwd`
	cd "$SHUNIT_TMPDIR"

	checkNeuters

	if [ -n "$TESTNAME" ]; then
		if echo "${_shunit_test_}" | grep -v "$TESTNAME" >/dev/null 2>&1 ; then
			echo -n "Skipping " # shunit2 is about to output the name for us
			startSkipping
			eval "${_shunit_test_}() { return 0; }"
		fi
	fi
}

tearDown() {
	local - && set -e

	cleanupSandboxes

	cd "$INITDIR"
	if [ "no" != "$DELETE_SANDBOX" ]; then 
		rm -rf "$SHUNIT_TMPDIR"/*
	fi
}

runScript() {
	_runScript "./$SCRIPTNAME" "$@" >/dev/null
}
_runScript() {
	(
		TO_RUN="$1"
		shift

		# a hack, necessary because we are 'source'ing rather than calling
		BASH_SOURCE="`pwd`/$TO_RUN"

		# have to 'source' the script to be able to mock methods
		# (but this makes trap handling exceedingly tricky)
		. "$TO_RUN" "$@"
	) >$OUT 2>$ERR
	RTRN=$?

	# convenience for our callers
	cat "$OUT"
}

checkResults() {
	local - && set -v
	E_EXIT=$1
	EXIT_MSG="$2"
	E_OUT="$3"
	OUT_MSG="$4"
	E_ERR="$5"
	ERR_MSG="$6"
	E_LOG="$7"
	LOG_MSG="$8"

	if [ $E_EXIT -eq 0 ]; then
		assertTrue "$EXIT_MSG" $RTRN || echo "($RTRN)"
	else
		assertFalse "$EXIT_MSG" $RTRN || echo "($RTRN)"
	fi

	if [ "" = "$E_OUT" ]; then
		assertNull "$OUT_MSG" "$(cat $OUT)" || cat $OUT
	else
		cat "$OUT" | grep "$E_OUT" >/dev/null 2>&1
		assertTrue "$OUT_MSG" $? || cat $OUT
	fi

	if [ "" = "$E_ERR" ]; then
		assertNull "$ERR_MSG" "$(cat $ERR)" || cat $ERR
	else
		cat "$ERR" | grep "$E_ERR" >/dev/null 2>&1
		assertTrue "$ERR_MSG" $? || cat $ERR
	fi

	if [ "" != "$E_LOG" ]; then
		cat "$BUILDLOG" | grep "$E_LOG" >/dev/null 2>&1
		assertTrue "$LOG_MSG" $? || cat "$BUILDLOG"
	fi
}

fn_exists() {
	type $1 | grep >/dev/null 2>&1 'function'
}

neuterPaths() {
	PATHROOT="$1"
	# point path-based settings to a local dir
	CONFIG="$PATHROOT/ubulk.conf"
	BUILDLOG="$PATHROOT/ubulk-build.log"
	PKGLIST="$PATHROOT/pkglist"
	EXTRACHROOTVARS="MAKECONF"
	# these are "real" (inside the test sandbox) and so help make all the
	# tests that don't do a chroot work
	SANDBOXDIR="/." # functionally equivalent to "/"
	PKGSRC="/usr/pkgsrc"

	# turn every build step off
	DOPKGSRC=no
	DOPKGCHK=no
	DOSANDBOX=no
	DOCHROOT=no
	INSTPBULK=no

	# odds-and-ends
	PKGCHK=pkg_chk
	MKSANDBOX=mksandbox
	MKSANDBOXARGS="--without-x --rwdirs=/var/spool"
	CHROOT=chroot
	BOOTSTRAP="./bootstrap"
	CLEANUP="./cleanup"
	CHROOTWORKDIR="/tmp/chrootworkdir-$$" # this has to be the same as prod
	CHROOTSCRIPTNAME="inchroot.sh" # this has to be the same as prod
}

loadDefaultVarList() {
	TMPSCRIPT="/tmp/tmpscript.$$"
	cat <<- EOF >$TMPSCRIPT
		#!/bin/sh
		BEFORE=\`set\`
		. $DEFAULTSCONF
		AFTER=\`set\`
		echo "\$BEFORE" "\$AFTER" | sort | uniq -u | grep "=" | grep -v "^PS.=" | grep -v "^PWD="
	EOF
	chmod +x $TMPSCRIPT
	DEFAULTVARS=$(
		env -i $TMPSCRIPT | sed -r 's/^([^=]+)=.*$/\1/'
	)
	rm $TMPSCRIPT
}

checkNeuters() {
	loadDefaultVarList
	echo "$DEFAULTVARS" | while read LINE ; do
		if [ -z "$(eval "echo \"\$$LINE\"")" ]; then
			echo >&2 "$DEFAULTSCONF sets $LINE but this test doesn't override it"
		fi
	done
}

#-------------------------------------------------------------------------
# use an actual sandbox/chroot to isolate the main system from the tests

switchToChroot() {
	CHROOT_DIR="$1"
	SCRIPT_PATH_PREFIX="${2:-test}"

	TOKEN=".test_is_in_chroot"
	if [ -f /$TOKEN -o "yes" = "$DISABLE_UBULK_TEST_SANDBOX" ]; then
		if [ "no" = "$DELETE_SANDBOX" ]; then 
			# disable shunit2's traps
			trap 'handle_trap EXIT 0' 0
			trap 'handle_trap INT 2' 2
			trap 'handle_trap TERM 15' 15
		fi

		return
	fi

	if [ ! -n "`command -v mksandbox`" ]; then
		cat << EOF >&2
ERROR: mksandbox is missing.
These tests automatically set up a chroot sandbox to isolate the
system from any real side-effects of the tests.  If you can't or
don't want to install mksandbox (from pkgsrc), the tests can be
run without the sandbox (but this is NOT recommended - they run as
root!); but if that's what you want, set DISABLE_UBULK_TEST_SANDBOX=yes
in your environment.

Note that creating the sandbox requires root permissions. The test
script will automatically try to use sudo, if the tests are not
run as root.

EOF
		exit 1
	fi

	echo "Mounting sandbox in $CHROOT_DIR"

	if [ `/usr/bin/id -u` -ne 0 ]; then
		DO_SUDO="sudo"
	fi

	trap > .trap.$$ && PRIOR_TRAPS=$(cat .trap.$$) && rm .trap.$$
	trap 'handle_trap EXIT 0' 0
	trap 'handle_trap INT 2' 2
	trap 'handle_trap TERM 15' 15

	: ${PKGDIR:=/usr/pkg}
	: ${PKGSRCDIR:=/usr/pkgsrc}
	: ${PKG_DBDIR:=/var/db/pkg}
	$DO_SUDO mksandbox --without-pkgsrc --without-x \
		--rodirs=$PKGDIR,$PKGSRCDIR,$PKG_DBDIR \
		"$CHROOT_DIR" >/dev/null

	WORKDIR="workdir"
	$DO_SUDO mkdir -p "$CHROOT_DIR/$WORKDIR"
	$DO_SUDO cp -r ../* "$CHROOT_DIR/$WORKDIR/"

	$DO_SUDO touch "$CHROOT_DIR/$TOKEN"

	BOOTSTRAP="/tmp/bootstrap.$$"
	cat <<- EOF > "$CHROOT_DIR/$BOOTSTRAP"
		#!/bin/sh
		cd /$WORKDIR/$SCRIPT_PATH_PREFIX/
		DELETE_SANDBOX=$DELETE_SANDBOX TESTNAME=$TESTNAME $0
		exit \$?
	EOF
	$DO_SUDO chmod +x "$CHROOT_DIR/$BOOTSTRAP"

	echo "Switching into chroot"
	echo "---------------------"
	echo
	$DO_SUDO chroot "$CHROOT_DIR" "$BOOTSTRAP"
	RTRN=$?

	# shunit expects tests to be run, but all our tests were run in the chroot
	__shunit_reportGenerated=${SHUNIT_TRUE}

	exit $RTRN
}

cleanup() {
	echo
	echo "---------------------"
	if mount | grep "on $CHROOT_DIR" >/dev/null 2>&1 ; then
		echo "Unmounting sandbox"
		$DO_SUDO "$CHROOT_DIR/sandbox" umount  # this doesn't emit an appropriate return code
		if mount | grep "on $CHROOT_DIR" >/dev/null 2>&1 ; then
			echo "Problem unmounting sandbox - exiting"
			exit 1
		fi
	fi
	if [ "no" != "$DELETE_SANDBOX" ]; then 
		echo "Deleting sandbox dir"
		$DO_SUDO rm -rf "$CHROOT_DIR"
	else
		echo "Leaving sandbox dir ($CHROOT_DIR)"
	fi
}

handle_trap() {
	EXIT_CODE=$?
	TRAP_NAME=$1
	TRAP_NUMBER=$2

	# first explitly turn off the traps, then try to restore the prior ones
	trap EXIT
	trap INT
	trap TERM
	if [ "no" != "$DELETE_SANDBOX" ]; then 
		eval "$PRIOR_TRAPS"
	fi

	if [ -f /$TOKEN ]; then
		exit $EXIT_CODE
	else
		cleanup

		if [ $TRAP_NAME != 'EXIT' ]; then
			kill -s $TRAP_NAME $$

			exit `expr $TRAP_NUMBER + 128`
		else
			exit $EXIT_CODE
		fi
	fi
}

# this is way at the bottom because vim chokes on the syntax highlighting
cleanupSandboxes() {
	# if you want this cleanup script to catch your sandbox, it had better be
	# under $SHUNIT_TMPDIR
	GREPSTR="on $SHUNIT_TMPDIR.\+/usr/bin type null"
	for c in 1 2 3 4 5 ; do # 'sandbox umount' doesn't return an appropriate exit code, so limit the number of attempts manually
		MOUNTED="$(mount)"
		SANDBOXES="$(echo "$MOUNTED" | grep "$GREPSTR")" || SANDBOXES=""
		if [ -n "$SANDBOXES" ]; then
			if [ 5 -eq $c ]; then
				echo >&2 "We've tried 5 times to clean up sandbox mounts, and there are still some left:"
				echo >&2 "$MOUNTED"
				echo >&2 "...so we're giving up and exiting"
				exit 1
			fi
			SANDBOXES="$(echo "$SANDBOXES" | head -n 1)"
			SBDIR="$(echo "$SANDBOXES" | sed -r "s#^.*(${SHUNIT_TMPDIR}.+)/usr/bin.*\$#\1#")"
			"$SBDIR/sandbox" umount
		else
			break
		fi
	done
}

