#!/bin/sh

aclocal -I .
autoheader
autoreconf
automake --add-missing --copy --foreign
