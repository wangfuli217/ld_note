#!/bin/sh 

source tls-constants.sh

# ------------------------------------------------------------ 

tlsVersion() { 
    if [ -z "$1" ]; then
	major=$TLS_Major
	minor=$TLS_Minor
    else
	if [ -z "$2" ]; then
	    major=$1
	    minor=$TLS_Minor
	else
	    major=$1
	    minor=$2
	fi
    fi
    
    (bkb nint 8 $major ; bkb nint 8 $minor)      
}

# ------------------------------------------------------------ 

tlsPlaintext() { 
    if [ -z "$1" ]; then
	t=$application_data
    else
	t=$1
    fi

    ( bkb nint 8 $t ; tlsVersion ; bkb len -ts 16 )
}

# ------------------------------------------------------------ 

_split() {
    IFS="," ; echo $1 ; IFS=" "
}

# ------------------------------------------------------------ 

_tlsCipherSuitesGo() { 
    for N in "$*"; do
	binhex $N
    done
}

tlsCipherSuites() {
    _tlsCipherSuitesGo `_split "$1"` | bkb len -t -s 16
}

# ------------------------------------------------------------ 

_tlsCompressionMethodsGo() { 
    for N in $*; do
	binhex $N
    done
}

tlsCompressionMethods() { 
    ( _tlsCompressionMethodsGo `_split "$1"` ) | bkb len -t -s 8 
}

# ------------------------------------------------------------ 

tlsRandom() { 
    (bkb nint t 0; r8 28)
}

# ------------------------------------------------------------ 

tlsSessionID() { 
    (r8 255 | bkb len -t -s 8 )
}

# ------------------------------------------------------------ 

tlsHandshake() { 
    if [ -z "$1" ]; then
	t=$hello_request
    else
	t=$1
    fi

    (bkb nint 8 $t; bkb len -t -s 24 )
}

# ------------------------------------------------------------ 

tlsClientHello() { 
    (tlsVersion; tlsRandom; tlsSessionID ; tlsCipherSuites $1 ; tlsCompressionMethods $2 )
}

# ------------------------------------------------------------ 

tlsClientHelloMsg() { 
      ( tlsClientHello $1 $2 | 
	tlsHandshake $client_hello | 
	tlsPlaintext $handshake )
}

# ------------------------------------------------------------ 

_certs() { 
    for F in $*; do
	cat $F | bkb len -t -s 24
    done
}

# ------------------------------------------------------------ 

tlsFinished() {
    if [[ -z "$1" || ${#1} -ne 24 ]]; then
	  PRF=`c 24 0`
    else
	  PRF=$1
    fi		
    
    binhex $PRF | tlsHandshake $finished | tlsPlaintext $handshake
}

# ------------------------------------------------------------ 

tlsChangeCipherSpec() { 
    binhex 01 | tlsPlaintext $change_cipher_spec
}

# ------------------------------------------------------------ 

tlsCertificate() { 
  ( ( _certs $* | bkb len -t -s 24 ) | tlsHandshake $certificate ) | tlsPlaintext $handshake
}

# ------------------------------------------------------------ 

tlsHelloRequestMsg() { 
      ( echo -n "" | 
        tlsHandshake $hello_request |
	tlsPlaintext $handshake )
}

# ------------------------------------------------------------ 

