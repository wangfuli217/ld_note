#!/bin/bash  
echo "PID for bash.sh: $$"  
echo "bash.sh get \$A=$A from bash.sh"  
A=C  
export A  
echo "bash.sh: \$A is $A"