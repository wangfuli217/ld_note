#!/bin/bash
# 0.2
# Script downloads latest VyOS ISO
# qemu-img create -f qcow2 vyos.qcow2 1G
# /usr/libexec/qemu-kvm -boot c -cdrom vyos-1.1.7-amd64.iso -hda vyos.qcow2 -m 1G -enable-kvm -serial telnet:192.168.10.109:3355,server,nowait -vnc 192.168.10.109:2 -vga cirrus


function check_binaries {
 for binary in qemu-system-x86_64 expect python bc; do
    type -P "$binary" &>/dev/null
    [ "$?" != 0 ] && echo -e "\n'$binary' required but not found, exiting!\n" && exit 1
 done
}

function get_names {
 version=$(wget http://vyos.net/wiki/Main_Page -q -O - | grep 'Current stable' | grep -o 'release_notes#[0-9].[0-9].[0-9]' | cut -d "#" -f2)
 iso="vyos-$version-amd64.iso"
 image="vyos-$version-amd64.vmdk"
 sha1sum_web="$(wget http://0.us.mirrors.vyos.net/vyos/iso/release/$version/sha1sums -q -O - | grep $iso | cut -d " " -f1)"
 size="$(wget http://0.us.mirrors.vyos.net/vyos/iso/release/$version -q -O - | grep  "$iso</a>" | awk '{print $5}')"
 size="${size::-1}" # remove '\r' from end
 dir=$(dirname $0)
}

function download_iso {
 wget http://0.us.mirrors.vyos.net/vyos/iso/release/$version/$iso -q -P $dir &
 wget_pid=$!
 sleep 5
 while [[ $(ps -p $wget_pid | grep wget) ]]; do
   sizeact="$(ls -l "$iso" | awk '{print $5}')"
   perc=$(echo "$sizeact/$size*100" | bc -l); 
   perc=$(python -c "print (round($perc,2))") 2>/dev/null
   echo -en "Downloading file $iso: $perc%\r"
   sleep 0.5
 done
 echo -e "Done!"
 sha1sum_computed=$(echo $(sha1sum $iso) | cut -d " " -f1)
 if [[ "$sha1sum_web" != "$sha1sum_computed" ]]; then
    echo -e "\nDownloaded file $iso is corrupted, exiting now\n"
    exit
 fi
}

function start_image {
 /usr/local/bin/qemu-img create -f vmdk $dir/$image 1G
 [[ $(/usr/local/bin/qemu-system-x86_64 -boot c -cdrom $dir/$iso -hda $dir/$image -m 1G -enable-kvm -serial telnet:127.0.0.1:3355,server,nowait 2>/dev/null &) ]] && echo "Qemu succesfully started" || echo "Qemu can't be started, exiting now"; exit
}

check_binaries
get_names
download_iso
start_image

