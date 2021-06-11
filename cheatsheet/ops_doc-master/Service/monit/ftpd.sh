#!/bin/sh

prog=vsftpd
vsftpd=/sbin/vsftpd
pidfile=/var/run/vsftpd.pid
RETVAL=0
PID=0

start() {
    echo -n $"Starting $prog: "
    
    while true
    do
        vsftpd &
        #sleep 1
        if [ $? -eq 0 ] ; then
            echo $! > ${pidfile}
            break;
        fi

    done
}

stop() {
    echo -n $"Stopping $prog: "
    PID=`netstat -lnp | grep 21 | awk '{print $7}' | awk -F '/' '{print $1}'`
    kill ${PID}
}

restart() {
    stop
    start
}



case "$1" in
  start)
        start
        ;;
  stop)
        stop
        ;;
  status)
        PID=`netstat -lnp | grep 21 | awk '{print $7}' | awk -F '/' '{print $1}'`
        echo ${PID}
        ;;
  *)
        echo $"Usage: $prog {start|stop|restart|status}"
        RETVAL=2
esac

exit $RETVAL