#!/bin/bash
 
trap 'echo $BASH_COMMAND return err' ERR
 
echo this is a normal test
