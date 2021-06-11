#!/bin/sh

SCRIPTNAME=`basename $0`
TMPDIR=`mktemp -d 2>/dev/null || mktemp -d -t "$SCRIPTNAME"`

cd "`dirname $0`/test" && . "./common.sh"
switchToChroot "$TMPDIR" "."

COUNTER=0
for testFile in *test.sh ; do
	echo "# $testFile"
	COUNTER=$(($COUNTER + 1))

	./$testFile
	RTRN=$?
	echo

	if [ 0 -ne $RTRN ]; then
		exit $RTRN
	fi
done

echo Ran $COUNTER test scripts
