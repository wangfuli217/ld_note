#!/bin/bash

function myfunc()
 {
 local  __resultvar=$1
 local  myresult='some value' 
 echo "myfunc:$0"
 echo "myfunc:$1"
 if [[ "$__resultvar" ]]; then
 eval $__resultvar="'$myresult'" 
 else 
 echo "$myresult"
 fi 
}

myfunc result
echo $result
result2=$(myfunc)
echo $result2

trap "echo this is a exit echo" EXIT