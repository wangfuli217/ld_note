#shell script : copy all git changed files between two commits with directory structure 

#!/bin/bash
echo "usage: ./knife.sh hash1 hash2 destfolder"
TARGETDIR=$3
echo "Coping to $TARGETDIR"
for i in $(git diff --name-only $1 $2)
    do       
        mkdir -p "$TARGETDIR/$(dirname $i)"       
        cp "$i" "$TARGETDIR/$i"
    done
echo "begin create knife.zip";
cd $TARGETDIR;
zip -r knife.zip *;
echo "Done";

#example: ./knife.sh  hashId1  hashId2   ../knife; 
