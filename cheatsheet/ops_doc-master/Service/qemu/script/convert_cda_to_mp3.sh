#!/bin/bash

function usage
 {
  echo -e "Usage: $0 [OPTIONS]"
  echo "OPTIONS: "
  echo -e "   -d     path to directory where files will be placed"
  echo -e "   -n     name of source CD"
  echo -e "   -m     convertion wav to mp3"
  echo -e "   -w     convertion ccda to wav"
  echo -e "   -v     quality setting for VBR, default n=4"
  echo -e "          0=high quality,bigger files. 9=smaller files"
  echo -e "   -h     display this help"
 }

function read_arguments
 {
  while getopts "d:n:v:mwh" arg; do
    case "$arg" in
     d) dest_dir=$OPTARG;;
     n) name="$OPTARG";;
     m) m_flag=1;;
     w) w_flag=1;;
     h) usage
        exit;;
     v) quality=$OPTARG;;
    esac
   done
 }

function check_arguments
 {
  # We must check if user entered required parameters and paths exist

  [[ ! -d "$dest_dir" ]] &&  echo "Can't find directory where converted files will be placed, use $0 -h" && exit 
  
  if ( [ -z "$m_flag" ] && [ -z "$w_flag" ] ); then 
     echo "You must enter at least one of the parameters m or w"
     usage  
     exit 
  fi

  ext=$(type -P cdparanoia)
  [[ -z "$ext" ]] && echo "Utility cdparanoia wasn't found, exiting" && exit
  
  lam=$(type -P lame)
  [[ -z "$lam" ]] && echo "Utility lame wasn't found, exiting" && exit

  [[ -z "$quality" ]] && quality=4
 }  

function ccda_to_wav
{
 cd $dest_dir
 echo -e "\nConverting CCDA to WAV"
 $ext -B -w -q & 
 while [ ! -z  $(pidof cdparanoia) ]; do
    echo -n '.'
    sleep 1.5
 done
 echo -n Done!
 cd - &> /dev/null
}

function wav_to_mp3
{ 
 if [[ ! $(ls -A "$dest_dir") ]]; then
    echo "Directory $dest_dir is empty"
    exit
 fi
 echo -e "\nConverting WAV files to MP3"
 for i in "$dest_dir/"*; do
    if [[ -z "$name" ]]; then
       fullname=$(dirname $i)\/$(basename $i | cut -d "." -f1).mp3
       [[ "$i" == "$fullname" ]] && fullname=$fullname.mp3
    else
       fullname=$(dirname $i)\/$name\_$(basename $i | cut -d "." -f1).mp3
       [[ "$i" == "$fullname" ]] && fullname=$fullname.mp3
    fi
 $lam -V $quality --quiet $i $fullname && /usr/bin/rm $i &> /dev/null
 echo -n '.'
 done
 echo -n Done!
 echo ""
}   

###BODY

read_arguments $@
check_arguments
if [[ "$w_flag" -eq 1 ]]; then 
   ccda_to_wav
fi

if [[ "$m_flag" -eq 1 ]]; then 
   wav_to_mp3
fi
