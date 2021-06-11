#!/bin/sh

prog=telnetd
telnetd=/sbin/telnetd
pidfile=/var/run/telnetd.pid
RETVAL=0
PID=0

start() {
    echo -n $"Starting $prog: "
    
    while true
    do
        telnetd &
        #sleep 1
        if [ $? -eq 0 ] ; then
            PID=`netstat -lnp | grep 23 | awk '{print $7}' | awk -F '/' '{print $1}'`
            echo ${PID} > ${pidfile}
            break;
        fi

    done
}

stop() {
    echo -n $"Stopping $prog: "
    PID=`netstat -lnp | grep 23 | awk '{print $7}' | awk -F '/' '{print $1}'`
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
        PID=`netstat -lnp | grep 23 | awk '{print $7}' | awk -F '/' '{print $1}'`
        echo ${PID}
        ;;
  *)
        echo $"Usage: $prog {start|stop|restart|status}"
        RETVAL=2
esac

exit $RETVAL