#!/bin/sh

ehlo foo
from ${DEFAULTNAME}@${DEFAULTSOURCE}
rcpt ${DEFAULTNAME}@${DEFAULTTARGET}
data
header ${DEFAULTSUBJECT} $0 $$
body `c 80 A`
eom
