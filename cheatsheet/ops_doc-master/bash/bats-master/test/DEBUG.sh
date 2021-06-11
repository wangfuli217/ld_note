#!/bin/bash
 
trap '(read -p "[$0 : $LINENO] $BASH_COMMAND ?")' DEBUG
 
echo this is a test
 
i=0
while [ true ]
do
    echo $i
    ((i++))
done