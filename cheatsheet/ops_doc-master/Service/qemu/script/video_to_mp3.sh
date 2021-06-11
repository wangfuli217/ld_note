#!/bin/bash
# Convert  video to mp3
# v.01 by 'brezular'


function usage {
 echo -e "Usage: video_to_mp3 [OPTION]"
 echo -e "Script converts video to mp3\n"      
 echo -e "-i       path to directory with video files"
 echo -e "-l       maximum CPU load during converting <0-100>"
 echo -e "-o       path to directory where mp3 will be stored"
 echo -e "-h       display help"
 echo -e "-u       display license\n"
 exit
}

function license {
 echo -e "\nvideo_to_mp3.sh v0.1"
 echo -e "Copyright (C) 2016 Radovan Brezula 'brezular'"
 echo -e "License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>."
 echo -e "This is free software: you are free to change and redistribute it."
 echo -e "There is NO WARRANTY, to the extent permitted by law.\n"
 exit
}

function readarg {
 while getopts i:o:l:hu option
    do
         case "${option}"
            in
                 i) indir="${OPTARG}";;
                 l) cpuload="${OPTARG}";;
                 o) outdir="${OPTARG}";;
                 h) usage;;
                 u) license;;
            esac
    done
}

function checkarg {
 for dir in "$indir" "$outdir"; do
    [ -z "$dir" ] && echo -e "You must enter path to directory\n" && usage && exit 1
    [ ! -d "$dir" ] && echo "Directory '$dir' not found, exiting" && exit 1      
 done
 [ -z "$cpuload" ] && echo -e "You must enter maximum CPU load\n" && usage && exit 1
 [ "$cpuload" -lt 0 ] || [ "$cpuload" -gt 100 ]  && echo "CPU value must be in range <0-100>, exiting" && exit 1
}


function checkbins {
 for binary in ffmpeg; do
    echo -n "Checking if '$binary' is installed"
    type -P  "$binary" &>/dev/null
    if [ "$?" != 0 ]; then
      echo ": FAIL" && exit 1
    else 
       echo ": OK"
    fi
 done
}


function convertvideo {
 ffmpeg -i "$file" -y -af "volume=$volume" -loglevel quiet "$outdir"/"$name".mp3
 [ "$?" == 0 ] && echo "File '$file' was successfully converted to mp3" >> "$outdir"/mp3log.txt || echo "*** '$?' - Failing to convert '$file' to mp3 ***" >> "$outdir"/mp3log.txt
}


function createmp3 {
 echo -n "Enter multiple of volume gain <0-10>, e.g 1 for no change: "; read volume
 [ "$volume" -gt 10 ] || [ "$volume" -lt 0 ]  && echo "Volume must be in range <0-10>, exiting" && exit 1
 for file in "$indir"/*; do
    name="${file%.*}"; name="${name##*/}"                                                            # Extract pure name of file from path
    suffix="${file##*\.}"
    # Get CPU load
    usage="$(cat <(grep 'cpu ' /proc/stat) <(sleep 1 && grep 'cpu ' /proc/stat) | awk -v RS="" '{print ($13-$2+$15-$4)*100/($13-$2+$15-$4+$16-$5)}')"
    usage="${usage%\.*}"                                                                             # Convert CPU load to integer value
       while [ "$usage" -gt "$cpuload" ]; do                                                                 # Restrict CPU load
          echo "Excessive CPU load detected: "$usage" %"
          usage="$(cat <(grep 'cpu ' /proc/stat) <(sleep 1 && grep 'cpu ' /proc/stat) | awk -v RS="" '{print ($13-$2+$15-$4)*100/($13-$2+$15-$4+$16-$5)}')"
          usage="${usage%\.*}"
       done
    if [ "$suffix"  == wmv ] || [ "$suffix"  == mov ] || [ "$suffix"  == mp4 ] || [ "$suffix" == avi ]; then
        echo "Proccessing file: '$file'"
        convertvideo &
    else
        echo -e  "Warning: '$file' is not valid video file" 
    fi
 done
}


function monsign {
 trap 'pkill ffmpeg; echo "Program teminated."; exit 0' SIGHUP SIGTERM SIGQUIT                             # kill ffpmeg when script finishes or
 trap 'pkill ffmpeg; echo "Ctrl+C detected, start script again to convert video to mp3" | tee -i -a "$outdir"/mp3log.txt; exit 1' SIGINT    # it is interrupted / suspended
}


readarg $@
checkarg
checkbins
monsign
createmp3

