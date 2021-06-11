#!/bin/sh

#set -e

generate_package_file_list()
{
	for p in `grep -v '^#' /etc/pkglist`; do
		cd /usr/pkgsrc/$p
		PKGFILE=`/usr/bin/make show-var VARNAME=PKGNAME`
		PKGFILEPATH=$PKG_PATH/$PKGFILE.tgz
		# if [ -f $PKGFILEPATH ]; then
			echo $PKGFILEPATH
		# else
		# 	echo 2>&1 ERROR: $p / $PKGFILEPATH is missing
		# 	exit 1
		# fi
	done
}

echo Generating desired package file list...
PKGFILES=`generate_package_file_list`

echo Installing packages...
for l in $PKGFILES; do
	echo $l
	pkg_add $l >/dev/null
	echo OUTCOME: $?
	echo
done

echo Done!

exit 0

