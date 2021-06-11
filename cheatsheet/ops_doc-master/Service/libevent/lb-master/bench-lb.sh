#!/bin/sh
#
# bench-lb.sh: a shell script to compare how fast some benchmark tools are
#
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
#                          _ _
#                         | | |__
#                         | | '_ \
#                         | | |_) |
#                         |_|_.__/
#
# 'lb' is a Libevent-based benchmarking tool for HTTP servers
#
#                (C) Copyright 2009-2016
#  Rocco Carbone <rocco /at/ tecsiel /dot/ it>, Pisa, Italy
#
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# 1. Redistributions of source code must retain the above copyright
#   notice, this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright
#   notice, this list of conditions and the following disclaimer in the
#   documentation and/or other materials provided with the distribution.
#
# 3. Neither the name of the auhor nor the names of its contributors
#   may be used to endorse or promote products derived from this software
#   without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
#

#
# version 0.1.0 - 2009-07-08
# o First public version
#
# version 0.1.1 - 2009-07-16
#  o Added 'nb' to the benchmark tools to compare
#


# The default server/url under benchmark test
url=http://tar:1234/

#
# Benchmarking programs under evaluation
#

# This is 'lb' by Rocco Carbone <rocco@tecsiel.it>
lb=/usr/local/bin/lb

# This is 'cb' by Adrian Chadd <adrian@creative.net.au>
cb=/usr/local/bin/cb

# This is 'nb' by Nick Mathewson <nickm@freehaven.net>
nb=/usr/local/bin/nb

# This is 'ab' by Apache Software Foundation http://www.apache.org
ab=/usr/sbin/ab

# All the tools are here
tools="$lb $cb $nb $ab"
tools="$lb $cb $nb"

#
# Useful variables
#
progname=`echo "$0" | sed 's|^.*/||'`
version="0.1.1"
released="2016 Jul 11"

# default max number of tests/requests/concurrency per session
maxt=10
maxn=15000
maxc=40

# Log files
spool=$progname.$$
logfile=`echo "$progname" | sed 's|\([^.]*\).*|\1|'`.log

# Print a separator every 'banner' iterations
banner=6

# External programs
who=`who am i | awk '{print $1}'`

# Counters
totreqs=0
tothtml=0

# Local variables
t= n= c= u= l= b=

# Process command line argument
for arg do
  case "$arg" in
    -h) # --help
      cat <<EOF
A shell script able to run the same HTTP benchmarks using different tools and compare how fast they are.

Usage: $progname [option]
  -h,       - show this message and exit
  -v,       - show version and exit
  -t num,   - set the maximum # of tests (default $maxt)
  -n num,   - set the maximum # of requests per test (default $maxn)
  -c num,   - set the maximum # of concurrency per test (default $maxc)
  -u url    - set the url under test (default $url)
  -l file,  - set the logfile to file (default $logfile)
  -b banner - print header every # of tests (default $banner)
EOF
      exit 0
      ;;

    -v) # --version
      echo "$progname ver. $version rel. $released"
      echo "Released under the BSD license"
      exit 0
    ;;

    -t) # --tests
      t=t
    ;;

    -n) # --requests
      n=n
    ;;

    -c) # --concurrency
      c=c
    ;;

    -u) # --url
      u=u
    ;;

    -l) # --logfile
      l=l
    ;;

    -b) # --banner
      b=b
    ;;

    0* | 1* | 2* | 3* | 4* | 5* | 6* | 7* | 8* | 9*)
      if [ "x$t" != "x" ]; then
        maxt=`expr $arg`
        t=
      elif [ "x$n" != "x" ]; then
        maxn=`expr $arg`
        n=
      elif [ "x$c" != "x" ]; then
	maxc=`expr $arg`
	c=
      elif [ "x$b" != "x" ]; then
	banner=`expr $arg`
	b=
        if [ $banner -eq 0 ]; then
          echo "$progname: illegal banner value $arg"
          exit 0
        fi
      fi
    ;;

    *)
      if [ "x$l" = "x" -a "y$u" = "y" ]; then
        echo "$progname: unknown option $arg"
        exit 0
      elif [ "y$u" != "y" ]; then
        url=$arg
        u=
      elif [ "x$l" != "x" ]; then
        logfile=$arg
        l=
      fi
  esac
done

# Check for expected arguments
if [ "x$t" != "x" -o "y$n" != "y" -o "z$c" != "z" -o "w$u" != "w" -o "i$l" != "i" -o "j$b" != "j" ]; then
  echo "$progname: argument expected"
  exit 0
fi

#
# Announce
#
echo "$progname ver. $version rel. $released"
echo "started by $who at `date` on `hostname`.`head -1 /etc/resolv.conf | awk '{print $2}'`"
echo
if [ $maxt -eq 0 ]; then
  echo "Unlimited # of tests to $url with random # of request (up to $maxn) per test and random # of concurrency (up to $maxc)"
elif [ $maxt -eq 1 ]; then
  echo "Up to # $maxt test to $url with random # of request (up to $maxn) per test and random # of concurrency (up to $maxc)"
else
  echo "Up to # $maxt tests to $url with random # of request (up to $maxn) per test and random # of concurrency (up to $maxc) "
fi
echo

#
# Cleanup on interrupt
#
trap "echo; echo '$progname: interrupted at user will'; rm -f $spool; exit 1" 1 2 15 

#
# Main loop
#
cp /dev/null $logfile

# Global counters
totreqs=0 tothtml=0
lbrun=0 cbrun=0 nbrun=0 abrun=0
lbsum=0 cbsum=0 nbsum=0 absum=0
current=0
RANDOM=`date '+%s'`

#
# Main loop
#
while [ $maxt -eq 0 -o $current -lt $maxt ]; do

  #
  # Evaluate randmonly values for the # of requests and concurrency for this test
  #
  n=$[($RANDOM % $maxn) + 1]
  # do not allow 'c' to to greater than 'n'
  if [ $maxc -gt $n ]; then
    c=$[($RANDOM % $n) + 1]
  else
    c=$[($RANDOM % $maxc) + 1]
  fi

  # Print a separator every 'banner' iterations
  if [ `expr $current \% $banner` -eq 0 ]; then

    # Evalaute # of blanks for better table rendering
    if [ $maxt -eq 0 ]; then
      echo $current `basename $lb` $n $c $url | awk '{printf "test # %-6d running -- %s -n %-4d -c %-3d %s => ", $1, $2, $3, $4, $5}' | wc -c > blanks.tmp
    else
      echo $current $maxt `basename $lb` $n $c $url | awk '{printf "test # %-3d of %-3d running -- %s -n %-4d -c %-3d %s => ", $1, $2, $3, $4, $5, $6}' | wc -c > blanks.tmp
    fi
    blanks=`cat blanks.tmp`
    rm -f blanks.tmp
    echo $blanks $blanks | awk '{printf "%*.*s", $1, $1, " "}'
    echo "" | awk '{printf "#/sec  Tot HTML\n"}'
  fi

  current=`expr $current + 1`
  echo "test #$current" >> $logfile

  #
  # Start execution foreach benchmark tool in use
  #
  for prog in $tools; do

    bin=`basename $prog`

    # Check for program and run the test
    if [ ! -x $prog ]; then
      echo "$progname: Error - $prog: command not found."
      exit 0
    else
      if [ $maxt -eq 0 ]; then
         echo $current $bin $n $c $url | awk '{printf "test # %-6d running -- %s -n %-4d -c %-3d %s => ", $1, $2, $3, $4, $5}'
      else
        echo $current $maxt $bin $n $c $url | awk '{printf "test # %-3d of %-3d running -- %s -n %-4d -c %-3d %s => ", $1, $2, $3, $4, $5, $6}'
      fi

      # Run the program now !!!
      $prog -q -n $n -c $c $url 2> /dev/null > $spool
    fi

    # Evaluate interesting counters per test
    rps= recv= html=
    if [ -f $spool ]; then

      rps=`cat $spool | grep 'Requests per second:' | awk '{printf $4}' | sed 's|\([^.]*\).*|\1|'`
      html=`cat $spool | grep 'HTML transferred:' | awk '{printf $3}'`

      if [ "$rps" != "" ]; then

        # Update the logfile
        echo "$bin: $rps [#/sec]" >> $logfile
  
        # Update the global counters too
        totreqs=`expr $totreqs + $n`
        tothtml=`expr $tothtml + $html`

        # Update reqs/sec for each tool
        if [ $bin = "lb" ]; then
          lbsum=`expr $rps + $lbsum`
          lbrun=`expr $lbrun + 1`
        elif [ $bin = "cb" ]; then
          cbsum=`expr $rps + $cbsum`
          cbrun=`expr $cbrun + 1`
        elif [ $bin = "nb" ]; then
          nbsum=`expr $rps + $nbsum`
          nbrun=`expr $nbrun + 1`
        elif [ $bin = "ab" ]; then
          absum=`expr $rps + $absum`
          abrun=`expr $abrun + 1`
        fi

        # Print out useful information
        echo $rps $html | awk '{printf "%-6d %-10d\n", $1, $2}'

      else
        echo
        echo "$progname: warning - execution of $prog did not produced a valid file $spool"
        # echo
        # echo "Check the reason in:"
        # echo "===================="
        # cat $spool
        rm -f $spool
        echo
        # exit 0
      fi
      rm -f $spool
    else
      echo "progname: execution of $prog -q -n $n -c $c $url failed!"
      exit 0
    fi

  done

  #
  # Print out average at the end of each test foreach tools
  #
  echo
  echo "*** Req/sec average at the end of test #$current ***"
  for prog in $tools; do
    bin=`basename $prog`
    if [ $bin = "lb" ]; then
      echo $bin $lbsum $lbrun | awk '{printf " %s - %.1f [#/sec] in %d tests |", $1, $2 / $3, $3}'
    elif [ $bin = "cb" ]; then
      echo $bin $cbsum $cbrun | awk '{printf " %s - %.1f [#/sec] in %d tests |", $1, $2 / $3, $3}'
    elif [ $bin = "nb" ]; then
      echo $bin $nbsum $nbrun | awk '{printf " %s - %.1f [#/sec] in %d tests |", $1, $2 / $3, $3}'
    elif [ $bin = "ab" ]; then
      echo $bin $absum $abrun | awk '{printf " %s - %.1f [#/sec] in %d tests", $1, $2 / $3, $3}'
    fi
  done
  echo

  if [ `echo $tools | wc -w` -gt 1 ]; then
    echo
  fi

done

echo "Bye bye from Dubai"
