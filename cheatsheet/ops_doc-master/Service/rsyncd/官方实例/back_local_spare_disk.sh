#!/bin/sh
    
# I do local backups on several of my machines using rsync. I have an
# extra disk installed that can hold all the contents of the main
# disk. I then have a nightly cron job that backs up the main disk to
# the backup. This is the script I use on one of those machines.
export PATH=/usr/local/bin:/usr/bin:/bin

LIST="rootfs usr data data2"

for d in $LIST; do
  mount /backup/$d
  rsync -ax --exclude fstab --delete /$d/ /backup/$d/
  umount /backup/$d
done

DAY=`date "+%A"`

rsync -a --delete /usr/local/apache /data2/backups/$DAY
rsync -a --delete /data/solid /data2/backups/$DAY

   

The first part does the backup on the spare disk. The second part
backs up the critical parts to daily directories.  I also backup the
critical parts using a rsync over ssh to a remote machine.