#!/bin/bash

if which wget >/dev/null 2>&1 ; then
	exec wget -O- http://drze.net/chunks/${1}
elif which curl >/dev/null 2>&1 ; then
	exec curl http://drze.net/chunks/${1}
else
	echo "No wget or curl in PATH." 1>&2
fi

