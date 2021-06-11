#!/bin/sh 

source commands.sh
source config.sh

VERB=`echo $0 | cut -d - -f 2`
FUZZ=`echo $0 | cut -d - -f 3`

if [ "$FUZZ" == "long" ]; then
    F=`echo $0 | cut -d - -f 4 | binhex`
    WIDTH=`echo $0 | cut -d - -f 5`
    FUZZ=`c $WIDTH $F`
else
    FUZZ=`echo $FUZZ binhex`
fi

case $VERB in 
    ( helo ) 
	ehlo() { 
	   helohook "y${FUZZ}.com"
	}
	;;

    ( ehlo ) 
	ehlo() { 
	   ehlohook "y${FUZZ}.com"
	}
	;;

    ( mail ) 
	mail() { 
	   mailhook "x${FUZZ}@y.com"
	}
	;;

    ( rcpt ) 
	rcpt() { 
	   rcpthook "x${FUZZ}@y.com"
	}
	;;

    ( data ) 
	data() { 
	   echo "DATA ${FUZZ}" | bkb blit
	}
	;;
esac
      
source drytemplate.sh
