#!/bin/sh 

# Certificate  ::=  SEQUENCE  {
#         tbsCertificate       TBSCertificate,
#         signatureAlgorithm   AlgorithmIdentifier,
#         signatureValue       BIT STRING  
# }

# TBSCertificate  ::=  SEQUENCE  {
#         version         [0]  EXPLICIT Version DEFAULT v1,
#         serialNumber         CertificateSerialNumber,
#         signature            AlgorithmIdentifier,
#         issuer               Name,
#         validity             Validity,
#         subject              Name,
#         subjectPublicKeyInfo SubjectPublicKeyInfo,
#         issuerUniqueID  [1]  IMPLICIT UniqueIdentifier OPTIONAL,
#                              -- If present, version shall be v2 or v3
#         subjectUniqueID [2]  IMPLICIT UniqueIdentifier OPTIONAL,
#                              -- If present, version shall be v2 or v3
#         extensions      [3]  EXPLICIT Extensions OPTIONAL
#                              -- If present, version shall be v3
# }

PKCS_1=1.2.840.113549.1.1
PKCS_RSA=${PKCS_1}.1
PKCS_MD2_RSA=${PKCS_1}.2
PKCS_MD5_RSA=${PKCS_1}.4
PKCS_SHA1_RSA=${PKCS_1}.5

# ------------------------------------------------------------ 

x509version() { 
    if [ -z "$1" ] ; then
	v=0
    else
	v=$1
    fi

    ( bkb asn1 int $v | bkb asn1 seq -Tcc0 ) 
}

# ------------------------------------------------------------ 

x509serial() { 
    if [ -z "$1" ] ; then
	v=0
    else
	v=$1
    fi

    bkb asn1 int $v
#     r8 500 | bkb asn1 int -r
}

# ------------------------------------------------------------ 

atvs() { 
    while [ $# -gt 1 ]; do
	x=$1
	y=$2
	( ( bkb asn1 oid $1 ; echo -n $2 | bkb asn1 printablestring ) | bkb asn1 seq ) | bkb asn1 sset
	shift;shift
    done
}

# ------------------------------------------------------------ 

generalizedTimeNow() { 
    `date "+20%y%m%d%H%M"` | bkb asn1 string -T23
}

# ------------------------------------------------------------ 

generalizedTimeLastYear() { 
    now=`date "+20%y%m%d%H%M"`
    then=`echo $now 31536000 - p | dc`
    echo $then | bkb asn1 string -T23
}

# ------------------------------------------------------------ 

generalizedTimeNextYear() { 
    now=`date "+20%y%m%d%H%M"`
    then=`echo $now 31536000 - p | dc`
     echo $then | bkb asn1 string -T23
#    c 5000 A | bkb asn1 string -T23
}

# ------------------------------------------------------------ 

x509validity() { 
   ( generalizedTimeLastYear ; generalizedTimeNextYear ) | bkb asn1 seq 
}

# ------------------------------------------------------------ 

x509algo() { 
    ( bkb asn1 oid $1 ; bkb asn1 null ) | bkb asn1 seq
}

# ------------------------------------------------------------ 

x509name() { 
    ( atvs $* ) | bkb asn1 seq
}

# ------------------------------------------------------------ 

x509cert() {
    bkb asn1 seq $*
}

# ------------------------------------------------------------ 

x509TBSCert() { 
    bkb asn1 seq $*
}

# ------------------------------------------------------------ 

randhex() { 
	echo "\${hex:$1}" | bkb sub 
}

randbin() { 
	bkb binhex `randhex $1`
}

RSAKEYSIZE=50

randrsakey() {
  bkb binhex 00 ; ( ( randbin ${RSAKEYSIZE} | bkb asn1 int -r ; \
      randbin ${RSAKEYSIZE} | bkb asn1 int -r ) | bkb asn1 seq )
}

# ------------------------------------------------------------ 

x509publicRSAKeyInfo() { 
    if [ -z "$1" ]; then
	( x509algo ${PKCS_RSA} ; randrsakey | bkb asn1 bitstring ) | bkb asn1 seq
    else
	( x509algo ${PKCS_RSA} ; echo "$1" | binhex | bkb asn1 bitstring ) | bkb asn1 seq
    fi
}

# ------------------------------------------------------------ 

x509simpleCert() { 
    ( ( x509version ;                           \
	x509serial ;                            \
	x509algo ${PKCS_MD5_RSA} ;              \
	x509name $* ;                           \
	x509validity ;                          \
	x509name $* ;                           \
	x509publicRSAKeyInfo                    \
      ) | x509TBSCert ;                         \
	  x509algo ${PKCS_MD5_RSA} ;            \
          binhex `c 40 F` | bkb asn1 bitstring  \
   ) | x509cert ; bkb asn1 eoc
}

# ------------------------------------------------------------ 

ID_AT=2.5.4
AT_NAME=${ID_AT}.41
AT_SURNAME=${ID_AT}.4
AT_GIVENNAME=${ID_AT}.42
AT_INITIALS=${ID_AT}.43
AT_COMMONNAME=${ID_AT}.3
AT_LOCALITY=${ID_AT}.7
AT_STATE=${ID_AT}.8
AT_ORG=${ID_AT}.10
AT_OU=${ID_AT}.11
AT_TITLE=${ID_AT}.12
AT_COUNTRY=${ID_AT}.6

# ------------------------------------------------------------ 

x509simpleCert    $AT_COUNTRY usa \
	    $AT_STATE il \
	    $AT_LOCALITY chicago \
	    $AT_ORG matasano \
	    $AT_OU research \
	    $AT_NAME foo
