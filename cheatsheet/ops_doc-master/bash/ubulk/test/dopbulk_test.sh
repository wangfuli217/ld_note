#!/bin/sh

cd `dirname $0` && . ./common.sh

localSetUp() {
	# bootstrap takes WAY too long to run every test
	BOOTSTRAP='true'
	CLEANUP='true'
}

#-------------------------------------------------------------------------

testDirsAndUsers() {
	SANDBOXDIR="$PATHROOT/sandbox"
	mkdir -p "$SANDBOXDIR"

	runScript -s create -i yes
	checkResults 0 "script exited cleanly" \
		"^Creating work directories and users" "we did the setup" \
		"" "nothing on stderr"

	assertTrue "bulklog was created" "[ -d /bulklog ]"
	assertTrue "scratch was created" "[ -d /scratch ]"
	id -u pbulk >/dev/null 2>&1
	assertTrue "pbulk user was created" $?
	[ -n "$(find /scratch -user pbulk -print -prune -o -prune)" ]
	assertTrue "scratch dir is owned by pbulk" $?
}

testRenameThisTestFile() {
	# XXX do it
}

testRealBootstrap() {
	SANDBOXDIR="$PATHROOT/sandbox"
	CHROOT='chroot_bootstrap'
	BOOTSTRAP='./bootstrap'
	CLEANUP='./cleanup'
	echo "(warning: this test takes a long time - minutes)"
	runScript -s yes -c yes -i yes
	checkResults 0 "script exited cleanly" \
		"^bootstrap dir exists" "bootstrap dir exists" \
		"" "nothing on stderr"
	cat "$OUT" | grep "^pkgdb exists" >/dev/null 2>&1
	assertTrue "pkgdb exists" $?
}
chroot_bootstrap() {
	cat <<- EOF >> "$SANDBOXDIR$CHROOTSCRIPT"
		[ -d /usr/pkg_bulk ] && console "bootstrap dir exists"
		[ -d /usr/pkg_bulk/.pkgdb ] && console "pkgdb exists"
	EOF
	
	chroot "$@"
}

# bootstrap happens
# build fails if bootstrap fails
# obeys PKGSRCDIR
# old dir is removed first
# mk.conf is correct
# build PATH is correct
# pbulk is installed, into the right place
# pbulk is not installed chroot-wide
# obey config option not to do it

#-------------------------------------------------------------------------

. ./shunit2

