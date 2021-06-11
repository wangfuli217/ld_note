#!/usr/bin/env bash

# Global variables
VERSION=0.1

# Option args
e_opt_val=


usage(){

	cat <<-EOF
		Usage: $0 [OPTION...] [ARGS]
		-h,				show help
		-V,				show version
		-e, --example	example option
		--example		example
	EOF
}

version(){
	echo "$0 $VERSION"
}

usage_error(){
	echo "usage error: $1"
	exit 0
}

check_arg(){

	# check if file
	#if [ ! $1 -f ];then
	#	usage_error "argument $1 is not a file"
	#fi

	# check if directory
	#if [ ! $1 -d ];then
	#	usage_error "argument $1 is not a directory"
	#fi

	# check with reg-ex
	if [[ ! $1 =~ ^[0-9]+ ]];then
		usage_error "argument $1 is not a number"
	fi
}


main(){

	# Getopts
	#----------------------------------
	while getopts Vhe: opt; do
    	    case $opt in
        	    h)  usage;;
            	V)  version;;
            	e)  check_arg "$OPTARG"
                	e_opt_val="$OPTARG"
                	echo "$e_opt_val"
                	;;
        	esac
    	done
	#-----------------------------------

}
main "$@"