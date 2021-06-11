#!/bin/bash  
A=B  
echo "PID for source_exec.sh before exec/source/fork:$$"  
export A  
echo "source_exec.sh: \$A is $A"  
case $1 in  
        exec)  
                echo "using exec..."  
                exec ./bash.sh ;;  
        source)  
                echo "using source..."  
                . ./bash.sh ;;  
        *)  
                echo "using fork by default..."  
                ./bash.sh ;;  
esac  
echo "PID for source_exec.sh after exec/source/fork:$$"  
echo "source_exec.sh: \$A is $A"