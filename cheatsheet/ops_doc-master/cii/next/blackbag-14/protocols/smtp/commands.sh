#!/bin/sh

heluhook() { 
    cat > t.$$ <<EOF
EHLO $1
EOF

    cat t.$$ | bkb sub | bkb blit
    rm -f t.$$
}

helu() {
    heluhook $*
}

helohook() { 
    cat > t.$$ <<EOF
HELO $1
EOF

    cat t.$$ | bkb sub | bkb blit
    rm -f t.$$
}

helo() { 
    helohook $*
}

ehlohook() { 
    helu $*
}

ehlo() { 
    ehlohook $*
}

from() {
    cat > t.$$ <<EOF
MAIL FROM:<$1>
EOF

    cat t.$$ | bkb sub | bkb blit
    rm -f t.$$
}

mailhook() {
    from $*
}

mail() { 
    mailhook $*
}

to() {
    cat > t.$$ <<EOF
RCPT TO:<$1>
EOF

    cat t.$$ | bkb sub | bkb blit
    rm -f t.$$
}

rcpthook() { 
    to $*
}

rcpt() { 
    rcpthook $*
}

recips() { 
    X=$1
    while [ ! -z $1 ]; do
	to "$X"
	shift
	X=$1
    done    
}

msg() { 
    echo "DATA" | bkb blit
}

datahook() {
    msg $*
}

data() {
    datahook $*
}

header() { 
    NAME=$1
    shift
    cat > t.$$ <<EOF
$NAME: $*
EOF

    cat t.$$ | bkb sub | bkb blit
    rm -f t.$$
}

body() { 
    cat > t.$$ <<EOF

$*
EOF

    cat t.$$ | bkb sub | bkb blit
    rm -f t.$$

}

eom() {
    bkb binhex 0d0a2e0d0a | bkb blit
}

reset() { 
    echo "RSET" | bkb blit
}

rset() { 
    reset $*
}

$*
