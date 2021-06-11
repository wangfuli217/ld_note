#!/bin/bash
#monitor available disk space
SPACE='df | sed -n '/ \ / $ / p' | gawk '{print $5}' | sed  's/%//'
if [ $SPACE -ge 90 ]
then
fty89@163.com
fi