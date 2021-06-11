#!/bin/sh
    
# I use rsync to backup my wifes home directory across a modem link each
# night. The cron job looks like this
cd ~susan
{
echo
date
dest=~/backup/`date +%A`
mkdir $dest.new
find . -xdev -type f \( -mtime 0 -or -mtime 1 \) -exec cp -aPv "{}"
$dest.new \;
cnt=`find $dest.new -type f | wc -l`
if [ $cnt -gt 0 ]; then
  rm -rf $dest
  mv $dest.new $dest
fi
rm -rf $dest.new
rsync -Cavze ssh . samba:backup
} >> ~/backup/backup.log 2>&1
