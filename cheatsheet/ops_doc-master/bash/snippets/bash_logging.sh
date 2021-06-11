#! /bin/bash -eu

info()    { echo -e "\e[32m[INFO]\e[39m    $*" ; }
warning() { echo -e "\e[33m[WARNING]\e[39m $*" ; }
error()   { echo -e "\e[31m[ERROR]\e[39m   $*" 1>&2 ; }
fatal() { echo -e "\e[35m[FATAL]\e[39m   $*" 1>&2 ; exit 1 ; }