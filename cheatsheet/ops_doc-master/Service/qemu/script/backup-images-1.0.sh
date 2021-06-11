#!/bin/bash

function usage
 {
  echo -e "Usage: $0 [OPTIONS]"
  echo "OPTIONS: "
  echo -e "   -c     convert downloaded disks to one of format recognized by 'qemu-img' utility: vmdk, vdi, qcow2 etc."
  echo -e "   -d     name of disk that is copied, e.g /dev/sda, /dev/hda"
  echo -e "   -f     path to a file that contains IP addresses of Linux machines that are copied"
  echo -e "   -u     name of user used for ssh connection to copied Linux OSs - if user definied with '-u' parameter"
  echo -e "          has no privileges to issue 'dd' command, you must use parameter '-u' together with '-r' parameter"
  echo -e "   -p     password of user used for ssh connection to Linux machine"
  echo -e "   -r     password of user 'root' - use option '-r' only if user defined with parameter '-u' has no rights"
  echo -e "          to issue 'dd' command or in case user 'root' is NOT allowed to connect via ssh on backuped OSs"
  echo -e "   -t     time interval for displaying logs to standard output"
  echo -e "   -v     display version"
  echo -e "   -h     display help\n"
  echo -e "\nNOTE:     If user 'root' is used for ssh connection (option -u), make sure that 'root' account is allowed"
  echo -e "          to connect via ssh. To do so, check whether parameter 'PermitRootLogin yes' is configured in file" 
  echo -e "          /etc/ssh/sshd_config for all backuped machines. Be aware that parameter is very likely set to 'no'" 
  echo -e "          for security reason.\n"
 }

function version
 {
  echo "backup_images.sh 1.0"
  echo "Copyright (C) 2015 Radovan Brezula 'brezular' "
  echo "License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>."
  echo "This is free software: you are free to change and redistribute it."
  echo "There is NO WARRANTY, to the extent permitted by law."
  exit
 }


function read_arguments
 {
  while getopts "c:d:f:u:p:r:t:vh" arg; do
    case "$arg" in
     c) disk_form="$OPTARG";; 
     d) disk="$OPTARG";;
     f) ipfile="$OPTARG";;
     u) user="$OPTARG";;
     p) userpass="$OPTARG";;
     r) rootpass="$OPTARG";;
     t) times="$OPTARG";;
     v) version;;
     h) usage
        exit;;
    esac
   done
 }


function check_arguments
 {
  [ ! -f "$ipfile" ] &&  echo "Can't find file with list of IP addresses of Linux systems, use $0 -h" && exit 
  [ -z "$user" ] && echo "You didn't enter name of user used for ssh connection to Linux system, use $0 -h" && exit
  [ -z "$userpass" ] && echo "You didn't enter password for user on Linux system, use $0 -h" && exit
 
  if [ -z "$disk" ]; then                                                                        # Check if good disk name is entered
     echo "You didn't enter name of disk, use $0 -h" && exit

  elif ( [[ "$disk" != /dev/[hs]d[a-z] ]] && [[ "$disk" != /dev/[hs]d[a-z]/ ]] ); then
     echo "You entered wrong disk name, use $0 -h" && exit
  fi

  [ -z "$rootpass" ] && echo "Note! You didn't enter password for user 'root', user '$user' will be used for ssh connection and to issue 'dd' command"

  if ( [ ! -z "$rootpass" ] && [ ! "$(type -p expect)" ] ); then                                    # If pass for user root is not null and expect is not found 
     echo "You entered password for user 'root' but utility 'expect' is not found, install it"
     exit
  fi 
  
  if [ -z "$times" ]; then
     times=5
  
  elif [[  "$times" != [[:digit:]] ]]; then
     echo "Time interval must be single digit, exiting"
     exit
  fi

  [ ! "$(type -p sshpass)" ] && echo "Utility 'sshpass' not found, install it" && exit                              # Check if sshpass is installed
  [ ! "$(type -p pidof)" ] && echo "Utility 'pidof' not found, install it" && exit                                  # Check if pidof is installed
  [ ! "$(type -p gawk)" ] && echo "Utility 'gawk' not found, install it" && exit                                    # Check if gawk is installed  
  
  if [ ! -z "$disk_form" ]; then                                                                                    # If we want to convert raw disk to antoher format
     qemu_path=$(type -p qemu-img); qemu_path_inst=$?                                                               # but 'qemu-img' is not found  
     [ "$qemu_path_inst" != 0 ] && echo "To convert 'raw' disks to '$disk_form' format  utility 'qemu-img' is needed but it isn't found, install Qemu" && exit

     [ ! "$(type -p gzip)" ] && echo "To convert 'raw' disks to '$disk_form' format 'gzip' is needed but it isn't found" && exit    # We need 'gzip' to extract zipped
                                                                                                                                    # raw images1
     $qemu_path --help | grep -o "$disk_form" &>/dev/null; disk_form_inst=$?
     [ "$disk_form_inst" != 0 ] && echo "Disk format '$disk_form' is not supported by 'qemu-img', exiting" && exit                  # Check if disk format
  fi                                                                                                                                # is recognized by qemu-img
 }


function check_ssh
 {
  grep -w -o "[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}" $ipfile > /tmp/ip_list_extracted; ip_inst=$?                  # Check if we can grep some IP
  if [ "$ip_inst" != 0 ]; then                                                                                                      # ip address from file with IP
     echo "No IP addresses found in '$ipfile', exiting"                                                                             # if no, exit
     rm /tmp/ip_list_extacted
     exit
  fi

 echo -e "\nChecking if we can connect to IP addresses in /tmp/ip_list_extracted: "
 
 for ip in $(cat /tmp/ip_list_extracted); do                                                                            # Connect to each IP from /tmp/ip_list_extracted
    echo -n "SSH connection to '$ip'"                                                                                   # 
    sshpass -p $userpass ssh $user@$ip -o "stricthostkeychecking no" -o ConnectTimeout=3 "exit" &>/dev/null; ip_inst=$? # try to connect max 3 second 
    if [ "$ip_inst" != 0 ]; then                                                                                        # if returen value isn't equal 0, then
       echo " -> NOT SUCCESSFUL"                                                                                        # connection isn't successful
    elif [ "$ip_inst" == 0 ]; then                                                                                      # 
       echo " -> SUCCESSFUL"                                                                                            # Put reachable IP addresses to file
       echo $ip >> /tmp/ip_list_reachable                                                                               # /tmp/ip_list_reachable 
    fi
 done
 
 rm /tmp/ip_list_extracted 

 if [ -s /tmp/ip_list_reachable ]; then                                                                                 # If file /tmp/ip_list_reachable is not zero
    echo -e "\nBackup will be done for following IP addresses: "                                                        # size
    cat /tmp/ip_list_reachable                                                                                          # show IPs that will be copied
 else 
    echo -e "\nI can't reach any IP address from '$ipfile', check network connection, login credentials etc., exiting" && exit # if file is zero zi
 fi  
 }

function manage_sudo
 {
  # Function add/remove user and dd command to/from /etc/sudoers so no password is required once sudo dd command is issued
  
  echo ""
  for ip in $(cat /tmp/ip_list_reachable); do
     if [ "$first_run" == 0 ]; then
        change_dd_sudo="cp /etc/sudoers /etc/sudoers.bak; echo '$user ALL=(ALL) NOPASSWD: /bin/dd if=$disk' >> /etc/sudoers"
        echo -e "Adding command 'dd' to /etc/sudoers on $ip for user '$user'" 
        call_expect &>/dev/null

     elif [ "$first_run" == 1 ]; then
        change_dd_sudo="mv -f /etc/sudoers.bak /etc/sudoers"
        echo -e "Restoring /etc/sudoers from /etc/sudoers.bak on $ip "
        call_expect &>/dev/null
     fi
  done
 }

function call_expect {
expect <<- EOF
        spawn ssh -o "StrictHostKeyChecking no" $user@$ip
        set timeout 10
        expect "*:*"
        send "$userpass\r"
        sleep 2
        expect "*$*"
        send "su\r"
        expect "*assword:*"
        expect "*eslo:*"
        send "$rootpass\r"
        expect "*#*"
        send "$change_dd_sudo\r"
        expect "*#*"
        send "exit\r"
        expect "*$*"
        send "exit\r"

        expect eof
EOF
} 
  
function make_copy_dd
 {
  echo ""
  for ip in $(cat /tmp/ip_list_reachable); do
     echo "Copying system with IP '$ip' started" 
     if [ ! -z "$rootpass" ]; then
        sshpass -p $userpass ssh $user@$ip "sudo /bin/dd if=$disk | gzip -c" | dd of=$curdir/$ip-disk.raw.gz &>/dev/null & 

     elif [ -z "$rootpass" ]; then
        sshpass -p $userpass ssh $user@$ip "/bin/dd if=$disk | gzip -c" | dd of=$curdir/$ip-disk.raw.gz &>/dev/null &
     fi
  done

 sleep $times

 while [ "$(pidof -s dd)" ]; do
    echo -e "\nActual size of copied images on local disk:"
    ls -lh $curdir | gawk '/[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}-disk.raw.gz$/ {print $5,$9}'
    sleep $times
 done
 
 echo -e "\nCopying finished!"
 }

function unzip_disks
 {
 echo -e "\nFollowing files will be extracted:"
  ls -lh $curdir | gawk '/[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}-disk.raw.gz$/ {print $9,"size",$5}'

  echo -e "\nExtracting files with 'gzip' utility:"
  for file in $(ls $curdir | gawk '/[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}-disk.raw.gz$/ {print $1}'); do
     gzip -d $curdir/$file &>/dev/null &
  done

  while [ "$(pidof -s gzip)" ]; do
    echo -e "\nActual size of extracted 'raw' images on local disk:"
    ls -lh $curdir | gawk '/[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}-disk.raw$/ {print $5,$9}'
    sleep $times
  done

  echo -e "\nExtracting finished!"
 }

function change_format
 {  
  echo -e "\nConverting extracted 'raw' disks to '$disk_form' format with 'qemu-img' utility:"
  for filerw in $(ls $curdir | gawk '/[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}-disk.raw$/ {print $1}'); do
     conv_file=$(echo $filerw | cut -d '-' -f1)-disk.$disk_form    
     $qemu_path convert -f raw -O $disk_form $curdir/$filerw $curdir/$conv_file &
  done

  while [ "$(pidof -s qemu-img)" ]; do
    echo -e "\nActual size of converted '$disk_form' images on local disk:"
    ls -lh $curdir | gawk '/[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}-disk.'$disk_form'$/ {print $5,$9}'
    sleep $times
  done

  echo -e "\nConverting finished!"
 }

function del_raw
{

 if  [  "$(ls | grep '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}-disk.raw$')" ]; then
    echo -e "\nDeleting raw images:"
    ls $curdir | gawk '/[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}-disk.raw$/ {print $1}'
    rm $(ls $curdir | gawk '/[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}-disk.raw$/ {print $1}')
    [ ! "$(ls | grep '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}-disk.raw$')" ] && echo -e '\nRaw images deleted!'
 fi
} 

############## BODY ####################


 curdir="$(dirname $0)"

 read_arguments $@
 check_arguments
 check_ssh
 
 if [ ! -z "$rootpass" ]; then
    first_run=0
    manage_sudo
 fi

 make_copy_dd
 
 if [ ! -z "$rootpass" ]; then
    first_run=1
    manage_sudo
 fi
 
 [ -f /tmp/ip_list_reachable ] && rm /tmp/ip_list_reachable


 if [ ! -z "$disk_form" ]; then
    unzip_disks
    change_format
    del_raw
 fi
