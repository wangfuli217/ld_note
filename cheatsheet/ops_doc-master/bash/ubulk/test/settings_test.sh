#!/bin/sh

cd `dirname $0` && . ./common.sh

#-------------------------------------------------------------------------

testUnknownArg() {
	runScript -abcdefghijklmnopqrstuvwxyz

	checkResults 1 "script exited non-zero" \
		"" "stdout was empty" \
		"^usage: " "stderr was usage"
}

testDashH() {
	runScript -h

	checkResults 0 "script exited true" \
		"" "stdout was empty" \
		"^usage: " "stderr was usage"
}

testDashV() {
	echo "exit 23" > $DEFAULTSCONF
	OLDPS4="$PS4"
	PS4="UNIQUETESTVALUE "
	runScript -v

	checkResults 23 "script exited as expected" \
		"" "stdout has no output" \
		"^$PS4" "stderr has verbose output"

	PS4="$OLDPS4"
}

testConfig() {
	checkDefaultsFile "CONFIG" "/etc/ubulk.conf" "/etc/fake"

	mv $DEFAULTSCONF ${DEFAULTSCONF}.save
	echo 'CONFIG=./fake.conf' > $DEFAULTSCONF
	echo 'exit 23' > ./fake.conf
	runScript
	checkResults 23 "script is obeying the default CONFIG path, by default" \
		"" "stdout has no output" \
		"" "stderr has no output"
	mv ${DEFAULTSCONF}.save $DEFAULTSCONF

	echo 'exit 24' > ./fake2.conf
	runScript -C ./fake2.conf
	checkResults 24 "script obeys command-arg over hard-coded default" \
		"" "stdout has no output" \
		"" "stderr has no output"

	runScript -C fake2.conf
	checkResults 24 "script fixes up a local-dir ref, so it works" \
		"" "stdout has no output" \
		"" "stderr has no output"

	runScript -C ./doesnotexist.conf
	checkResults 1 "a missing command-line config file means an error" \
		"" "empty stdout" \
		"doesnotexist" "stderr complains about the missing file"

	echo 'CONFIG=./doesnotexist.conf' >> $DEFAULTSCONF
	echo 'exit 23' > $UTILSH  #prevent the script from continuing after reading defaults
	runScript
	checkResults 23 "script exited like we expected" \
		"" "empty stdout" \
		"" "script didn't complain about missing config file"
}

testDoPkgChk() {
	checkDefaultsFile "DOPKGCHK" "yes" "no"

	cp $DEFAULTSCONF ${DEFAULTSCONF}.save
	echo >> $DEFAULTSCONF && echo "DOPKGCHK=no" >> $DEFAULTSCONF
	runScript
	checkResults 0 "script exits cleanly" \
		"^Skipping pkg_chk" "script obeyed the hard-coded default" \
		"" "nothing on stderr"
	cp ${DEFAULTSCONF}.save $DEFAULTSCONF

	echo "DOPKGCHK=no" > ./testubulk.conf
	runScript -C ./testubulk.conf
	checkResults 0 "script exits cleanly" \
		"^Skipping pkg_chk" "setting trumps hard-coded default" \
		"" "nothing on stderr"

	runScript -k no
	checkResults 0 "script exits cleanly" \
		"^Skipping pkg_chk" "command-arg trumps hard-coded default" \
		"" "nothing on stderr"

	echo "DOPKGCHK=yes" > ./testubulk.conf
	runScript -C ./testubulk.conf -k no
	checkResults 0 "script exits cleanly" \
		"^Skipping pkg_chk" "command-arg trumps config file" \
		"" "nothing on stderr"
}

testDoPkgsrc() {
	checkDefaultsFile "DOPKGSRC" "yes" "no"

	cp $DEFAULTSCONF ${DEFAULTSCONF}.save
	echo >> $DEFAULTSCONF &&  echo "DOPKGSRC=no" >> $DEFAULTSCONF
	runScript
	checkResults 0 "script exits cleanly" \
		"^Skipping pkgsrc update" "script obeyed the hard-coded default" \
		"" "nothing on stderr"
	cp ${DEFAULTSCONF}.save $DEFAULTSCONF

	echo "DOPKGSRC=no" > ./testubulk.conf
	runScript -C ./testubulk.conf
	checkResults 0 "script exits cleanly" \
		"^Skipping pkgsrc update" "setting trumps hard-coded default" \
		"" "nothing on stderr"

	runScript -p no
	checkResults 0 "script exits cleanly" \
		"^Skipping pkgsrc update" "command-arg trumps hard-coded default" \
		"" "nothing on stderr"

	echo "DOPKGSRC=yes" > ./testubulk.conf
	runScript -C ./testubulk.conf -p no
	checkResults 0 "script exits cleanly" \
		"^Skipping pkgsrc update" "command-arg trumps config file" \
		"" "nothing on stderr"
}

testPkgsrc() {
	checkDefaultsFile "PKGSRC" "/usr/pkgsrc" "/usr/packagesource"

	cp $DEFAULTSCONF ${DEFAULTSCONF}.save
	echo >> $DEFAULTSCONF && echo "PKGSRC=/tmp/myfaketestdir" >> $DEFAULTSCONF
	runScript -p yes
	checkResults 2 "script dies as expected" \
		"^Updating pkgsrc (/tmp/myfaketestdir)" "script obeyed the hard-coded default" \
		"can't cd to" "stderr complains about fake dir"
	cp ${DEFAULTSCONF}.save $DEFAULTSCONF

	echo "PKGSRC=/tmp/myotherfaketestdir" > ./testubulk.conf
	runScript -C ./testubulk.conf -p yes
	checkResults 2 "script dies as expected" \
		"^Updating pkgsrc (/tmp/myotherfaketestdir)" "script obeyed the config-file value" \
		"can't cd to" "stderr complains about fake dir"
}

testBuildLog() {
	checkDefaultsFile "BUILDLOG" "/var/log/ubulk-build.log" "somewhereelse"

	cp $DEFAULTSCONF ${DEFAULTSCONF}.save
	echo >> $DEFAULTSCONF &&  echo "BUILDLOG=./mybuildlog" >> $DEFAULTSCONF
	runScript
	checkResults 0 "script finishes cleanly" \
		"^Logging to ./mybuildlog" "script obeyed the hard-coded default" \
		"" "stderr is empty"
	cp ${DEFAULTSCONF}.save $DEFAULTSCONF

	echo "BUILDLOG=./myotherbuildlog" > ./testubulk.conf
	runScript -C ./testubulk.conf
	checkResults 0 "script finishes cleanly" \
		"^Logging to ./myotherbuildlog" "script obeyed the config-file value" \
		"" "stderr is empty"
}

testPkgList() {
	checkDefaultsFile "PKGLIST" "/etc/pkglist" "/etc/packagelist"

	cp $DEFAULTSCONF ${DEFAULTSCONF}.save
	echo >> $DEFAULTSCONF && echo "PKGLIST=/tmp/myfakepkglist" >> $DEFAULTSCONF
	runScript -k yes
	checkResults 1 "script dies as expected" \
		"Checking for missing" "script ran pkg_chk" \
		"Unable to read.*/tmp/myfakepkglist" "script complains about bad pkglist"
	cp ${DEFAULTSCONF}.save $DEFAULTSCONF

	echo "PKGLIST=/tmp/myotherfakepkglist" > ./testubulk.conf
	runScript -C ./testubulk.conf -k yes
	checkResults 1 "script dies as expected" \
		"Checking for missing" "script ran pkg_chk" \
		"Unable to read.*/tmp/myotherfakepkglist" "script complains about bad pkglist"
}

testPkgChk() {
	checkDefaultsFile "PKGCHK" "pkg_chk" "package_check"

	PKGCHK=package_check_fake
	runScript -k yes
	checkResults 0 "script finishes even with missing pkg_chk" \
		"Can't find package_check_fake" "script looked for fake pkg_chk" \
		"" "nothing on stderr"

	# this isn't really meant to be user-settable, so we don't test that it is
}

testMkSandbox() {
	checkDefaultsFile "MKSANDBOX" "mksandbox" "make_a_sandbox"

	MKSANDBOX=make_a_sandbox
	SANDBOXDIR="$PATHROOT/sandbox"
	runScript -s yes
	checkResults 1 "script dies when mksandbox is missing" \
		"Logging to" "regular stuff on stdout" \
		"Can't find make_a_sandbox" "script looked for fake mksandbox"

	# this isn't really meant to be user-settable, so we don't test that it is
}

testSandboxDir() {
	checkDefaultsFile "SANDBOXDIR" "/usr/sandbox" "/usr/sandboxers"

	MKSANDBOX='mkSandboxCreateSandbox'

	TEST_SANDBOX_DIR="$SHUNIT_TMPDIR/tmp/sandbox1"
	assertTrue 'sandbox does not exist yet' "[ ! -r '$TEST_SANDBOX_DIR/sandbox' ]"
	cp $DEFAULTSCONF ${DEFAULTSCONF}.save
	echo >> $DEFAULTSCONF && echo "SANDBOXDIR=$TEST_SANDBOX_DIR" >> $DEFAULTSCONF
	runScript -s yes
	checkResults 0 "script will make a sandbox anywhere!" \
		"Mounting sandbox" "script ran mksandbox step" \
		"" "mksandbox never complains!"
	cp ${DEFAULTSCONF}.save $DEFAULTSCONF

	TEST_SANDBOX_DIR="$SHUNIT_TMPDIR/tmp/sandbox2"
	assertTrue 'sandbox does not exist yet' "[ ! -r '$TEST_SANDBOX_DIR/sandbox' ]"
	echo "SANDBOXDIR=$TEST_SANDBOX_DIR" > ./testubulk.conf
	runScript -C ./testubulk.conf -s yes
	checkResults 0 "script will make a sandbox anywhere!" \
		"Mounting sandbox" "script ran mksandbox step" \
		"" "mksandbox never complains!"
}
mkSandboxCreateSandbox() {
	mksandbox "$@"
	RTRN=$?

	assertTrue "sandbox exists" "[ -f "$TEST_SANDBOX_DIR/sandbox" ]"

	return $RTRN
}

testDoSandbox() {
	checkDefaultsFile "DOSANDBOX" "yes" "no"

	cp $DEFAULTSCONF ${DEFAULTSCONF}.save
	echo >> $DEFAULTSCONF &&  echo "DOSANDBOX=no" >> $DEFAULTSCONF
	runScript
	checkResults 0 "script exits cleanly" \
		"^Skipping sandbox creation" "script obeyed the hard-coded default" \
		"" "nothing on stderr"
	cp ${DEFAULTSCONF}.save $DEFAULTSCONF

	echo "DOSANDBOX=no" > ./testubulk.conf
	runScript -C ./testubulk.conf
	checkResults 0 "script exits cleanly" \
		"^Skipping sandbox creation" "setting trumps hard-coded default" \
		"" "nothing on stderr"

	runScript -s no
	checkResults 0 "script exits cleanly" \
		"^Skipping sandbox creation" "command-arg trumps hard-coded default" \
		"" "nothing on stderr"

	echo "DOSANDBOX=yes" > ./testubulk.conf
	runScript -C ./testubulk.conf -s no
	checkResults 0 "script exits cleanly" \
		"^Skipping sandbox creation" "command-arg trumps config file" \
		"" "nothing on stderr"
}

testMkSandboxArgs() {
	checkDefaultsFile "MKSANDBOXARGS" "--without-x --rwdirs=/var/spool" "--fakeargs"

	SANDBOXDIR="$PATHROOT/sandbox"

	TEST_ARGS="--totallyfake"
	cp $DEFAULTSCONF ${DEFAULTSCONF}.save
	echo >> $DEFAULTSCONF && echo "MKSANDBOXARGS=$TEST_ARGS" >> $DEFAULTSCONF
	runScript -s yes
	checkResults 1 "illegal args means mksandbox failure" \
		"Mounting sandbox" "script ran mksandbox step" \
		"usage: mksandbox" "mksandbox complaints about invalid args"
	cp ${DEFAULTSCONF}.save $DEFAULTSCONF

	echo "MKSANDBOXARGS=$TEST_ARGS" > ./testubulk.conf
	runScript -C ./testubulk.conf -s yes
	checkResults 1 "illegal args means mksandbox failure" \
		"Mounting sandbox" "script ran mksandbox step" \
		"usage: mksandbox" "mksandbox complaints about invalid args"
}

testDoChroot() {
	checkDefaultsFile "DOCHROOT" "yes" "no"

	cp $DEFAULTSCONF ${DEFAULTSCONF}.save
	echo >> $DEFAULTSCONF &&  echo "DOCHROOT=no" >> $DEFAULTSCONF
	runScript
	checkResults 0 "script exits cleanly" \
		"^WARNING: Not using chroot" "script obeyed the hard-coded default" \
		"" "nothing on stderr"
	cp ${DEFAULTSCONF}.save $DEFAULTSCONF

	echo "DOCHROOT=no" > ./testubulk.conf
	runScript -C ./testubulk.conf
	checkResults 0 "script exits cleanly" \
		"^WARNING: Not using chroot" "setting trumps hard-coded default" \
		"" "nothing on stderr"

	runScript -c no
	checkResults 0 "script exits cleanly" \
		"^WARNING: Not using chroot" "command-arg trumps hard-coded default" \
		"" "nothing on stderr"

	echo "DOCHROOT=yes" > ./testubulk.conf
	runScript -C ./testubulk.conf -c no
	checkResults 0 "script exits cleanly" \
		"^WARNING: Not using chroot" "command-arg trumps config file" \
		"" "nothing on stderr"
}

testExtraChrootArgs() {
	checkDefaultsFile "EXTRACHROOTVARS" "MAKECONF" "MAKE_A_CONF"

	SANDBOXDIR="$PATHROOT/sandbox"
	CHROOT='chroot_env'
	unset EXTRACHROOTVARS

	TESTVAR1='hello'
	cp $DEFAULTSCONF ${DEFAULTSCONF}.save
	echo >> $DEFAULTSCONF && echo "EXTRACHROOTVARS='TESTVAR1'" >> $DEFAULTSCONF
	runScript -s yes -c yes
	checkResults 0 "script ran cleanly" \
		"^Entering chroot" "we entered the chroot" \
		"" "nothing on stderr" \
		"^CHROOT SET:$" "the environment was reported to us"
	cat "$BUILDLOG" | grep "^TESTVAR1=" >/dev/null 2>&1
	assertTrue "config via environment succeeded" $?
	cp ${DEFAULTSCONF}.save $DEFAULTSCONF

	assertNull "var is not set here" "$EXTRACHROOTVARS"

	echo "EXTRACHROOTVARS='TESTVAR1'" > ./testubulk.conf
	runScript -C ./testubulk.conf -s yes -c yes
	checkResults 0 "script ran cleanly" \
		"^Entering chroot" "we entered the chroot" \
		"" "nothing on stderr" \
		"^CHROOT SET:$" "the environment was reported to us"
	cat "$BUILDLOG" | grep "^TESTVAR1=" >/dev/null 2>&1
	assertTrue "config via config file succeeded" $?

	assertNull "var is not set here" "$EXTRACHROOTVARS"

	echo "EXTRACHROOTVARS=" > ./testubulk.conf
	runScript -C ./testubulk.conf -s yes -c yes
	checkResults 0 "script ran cleanly" \
		"^Entering chroot" "we entered the chroot" \
		"" "nothing on stderr" \
		"^CHROOT SET:$" "the environment was reported to us"
	cat "$BUILDLOG" | grep "^TESTVAR1=" >/dev/null 2>&1
	assertFalse "no extra vars in environment" $?
}
chroot_env() {
	cat <<- EOF >> "$SANDBOXDIR$CHROOTSCRIPT"
		echo "CHROOT SET:"
		set
	EOF

	chroot "$@"
}

testInstPbulk() {
	checkDefaultsFile "INSTPBULK" "yes" "no"

	cp $DEFAULTSCONF ${DEFAULTSCONF}.save
	echo >> $DEFAULTSCONF &&  echo "INSTPBULK=no" >> $DEFAULTSCONF
	runScript
	checkResults 0 "script exits cleanly" \
		"^Skipping pbulk setup" "script obeyed the hard-coded default" \
		"" "nothing on stderr"
	cp ${DEFAULTSCONF}.save $DEFAULTSCONF

	echo "INSTPBULK=no" > ./testubulk.conf
	runScript -C ./testubulk.conf
	checkResults 0 "script exits cleanly" \
		"^Skipping pbulk setup" "setting trumps hard-coded default" \
		"" "nothing on stderr"

	runScript -i no
	checkResults 0 "script exits cleanly" \
		"^Skipping pbulk setup" "command-arg trumps hard-coded default" \
		"" "nothing on stderr"

	echo "INSTPBULK=yes" > ./testubulk.conf
	runScript -C ./testubulk.conf -i no
	checkResults 0 "script exits cleanly" \
		"^Skipping pbulk setup" "command-arg trumps config file" \
		"" "nothing on stderr"
}

testBootstrap() {
	checkDefaultsFile "BOOTSTRAP" "./bootstrap" "shoestrap"

	SANDBOXDIR="`pwd`/sandbox"
	BOOTSTRAP=shoestrap
	runScript -s yes -i yes
	checkResults 1 "script dies when bootstrap is missing" \
		"Bootstrapping pkgsrc for pbulk" "we tried to bootstrap" \
		"shoestrap: not found" "error is reported to user"

	# this isn't really meant to be user-settable, so we don't test that it is
}

testChrootScript() {
	checkDefaultsFile "CHROOTWORKDIR" "/tmp/chrootworkdir-$$" "something_else"
	checkDefaultsFile "CHROOTSCRIPTNAME" "inchroot.sh" "footroot.sh"

	SANDBOXDIR="/some_sandbox"
	CHROOTWORKDIR="/tmp/onetimeonly.$$"
	CHROOTSCRIPTNAME="thistime.sh"
	runScript
	assertTrue "custom CHROOTSCRIPT was created" \
		"[ -f $SANDBOXDIR/$CHROOTWORKDIR/$CHROOTSCRIPTNAME ]"

	# this isn't really meant to be user-settable, so we don't test that it is
}

	# source defaults.conf ourselves
	# check for correct value
	# check that value doesn't overwrite already-set value
	# write fake defaults.conf
	# check that script obeys the fake defaults.conf
	# setting overrides default
	# command-arg overrides default
	# command-arg overrides setting
#-------------------------------------------------------------------------

checkDefaultsFile() {
	VAR=$1
	E_VALUE=$2
	T_VALUE=$3

	OLDVAL=$(eval "echo \$$VAR")
	eval "unset $VAR"

	VALUE=$(
		. $DEFAULTSCONF
		eval "echo \$$VAR"
	)
	assertEquals "$VAR has expected hard-coded value" "$E_VALUE" "$VALUE"

	VALUE=$(
		eval "$VAR=$T_VALUE"
		. $DEFAULTSCONF
		eval "echo \$$VAR"
	)
	assertEquals "$VAR doesn't override already-set value" "$T_VALUE" "$VALUE"

	eval "$VAR='$OLDVAL'"
}

. ./shunit2
