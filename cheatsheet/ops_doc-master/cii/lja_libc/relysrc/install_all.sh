#!/bin/bash
DIRECTORY=`ls`

for i in $DIRECTORY
do
	echo $i
	if [ -d "$i" ];then

		cd $i;
		bash ./install.sh
		cd ..
	fi
done
