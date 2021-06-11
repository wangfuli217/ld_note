====== Trap signals ======

This shows how to trap signals sent to a script:

<file bash fhj.sh>
#!/usr/bin/env bash

function sigint () {
  echo "INT(2) signal received"
}

function sigquit () {
  echo "QUIT(3) signal received"
  exit 0
}

function sigterm () {
  echo "TERM(15) signal received"
  exit 0
}

#
# sleep waiting for a signal
#
echo "Script $(basename $0) started with PID of $$"
while true ; do
  sleep 30
done

:
</file>

Here is an example of it running:

<file bash>
$ nice ./fhj.sh &
[1] 1566
Script fhj.sh started with PID of 1566

$ kill -2 1566
$ kill 1566
$ INT(2) signal received
$ TERM(15) signal received

[1]+  Done                    nice ./fhj.sh
</file>

{{tag>bash signal trap kill}}