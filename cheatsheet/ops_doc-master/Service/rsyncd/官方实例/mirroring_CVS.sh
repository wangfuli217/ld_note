#!/bin/bash
# The vger.rutgers.edu cvs tree is mirrored onto cvs.samba.org via
# anonymous rsync using the following script.


cd /var/www/cvs/vger/
PATH=/usr/local/bin:/usr/freeware/bin:/usr/bin:/bin

RUN=`lps x | grep rsync | grep -v grep | wc -l`
if [ "$RUN" -gt 0 ]; then
  echo already running
  exit 1
fi

rsync -az vger.rutgers.edu::cvs/CVSROOT/ChangeLog $HOME/ChangeLog

sum1=`sum $HOME/ChangeLog`
sum2=`sum /var/www/cvs/vger/CVSROOT/ChangeLog`

if [ "$sum1" = "$sum2" ]; then
  echo nothing to do
  exit 0
fi

rsync -az --delete --force vger.rutgers.edu::cvs/ /var/www/cvs/vger/
    exit 0