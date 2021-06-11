#!/bin/bash

function usage {
 echo -e "Usage: change_mac [OPTION]"
 echo -e "Script continues to change MAC adress for the particular interface after passing defined time interval\n"
 echo -e "-i       define interface name"
 echo -e "-t       set the time period in seconds after the MAC address is changed\n"
}

function readarg {
 while getopts i:t:h option
    do
         case "${option}"
            in
                 i) iface=${OPTARG};;
                 t) time=${OPTARG};;
                 h) usage
                    exit;;
            esac
    done
 clear
}

function checkarg {
 [ "$UID" != 0 ] && echo "Script requires root privilleges, exiting" && exit 1
 [ -z "$iface" ] && echo "You must enter name of interface, exiting" && usage && exit 1 
 ifconfig "$iface" &>/dev/null
 [ "$?" != 0 ] && echo "Interface '$iface' doesn't exist, exiting" && exit 1
 [ -z "$time" ] && echo "You must enter time interval for MAC changing, exiting" && usage && exit 1

 type -P iwconfig &>/dev/null
 [ "$?" != 0 ] && echo "Utility 'iwconfig' not found, exiting" && exit 1
}

readarg $@
checkarg

new_mac=00
count_mac=0

#Check if interface is wireless, if YES wifi=IEEE
wifi="$(iwconfig $iface 2> /dev/null | grep ESSID | awk '/ESSID/ {print $2}')"

#Get default gw address
defgw="$(/sbin/route -n | grep "$iface" | awk '/UG/ {print $2}')"
echo "Found IP address of default gateway: $defgw"

while [ true ]; do
 while [ "$i" != 5 ]; do
  #Generate random number in range 0-255
  dec_num=$(shuf -i 0-255 -n1)

  #Convert decimal to hexa decimal
  hex_digits=$(printf "%x\n" $dec_num)

  #Get number of digit, if number=1, then add leading zero to the hex digit
  hex_digits_numb=${#hex_digits}
  if [ "$hex_digits_numb" == 1 ]; then
   hex_digits=0$hex_digits_numb
  fi

  #Add two hexa digits to MAC
  new_mac+=:$hex_digits
  i=$(( $i + 1))
 done

 old_mac="$(/sbin/ifconfig $iface | awk '/ether/ {print $2}')"
 
 if [ "$wifi" == "IEEE" ]; then
    ifconfig "$iface" down &>/dev/null
    ifconfig "$iface" hw ether "$new_mac" &>/dev/null
    [ "$?" != 0 ] && echo "Can't assign MAC address '$new_mac', exiting" && exit 1
    ifconfig "$iface" up &>/dev/null
    /sbin/route add default gw "$defgw" &>/dev/null
  else
    /sbin/ifconfig "$iface" hw ether "$new_mac"
    [ "$?" != 0 ] && echo "Can't assign MAC address '$new_mac', exiting" && exit 1
 fi

 count_mac=$(($count_mac +1));
 echo -e "MAC address: $old_mac was changed to: $new_mac total number of changed MAC addresses is: $count_mac"
 /bin/sleep "$time";
 i=0
 new_mac=00
done



