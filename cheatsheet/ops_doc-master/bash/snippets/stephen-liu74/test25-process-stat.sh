#!/bin/sh
### 统计当前系统中不同运行状态的进程数量 ###

#1. 初始化计数器变量，分别对应于运行时、睡眠、停止和僵尸。
running=0
sleeping=0
stopped=0
zombie=0
#2. 在/proc目录下，包含很多以数字作为目录名的子目录，其含义为，每个数字对应于一个当前正在运行进程的pid，该子目录下包含一些文件用于描述与该pid进程相关的信息。如1表示init进程的pid。那么其子目录下的stat文件将包含和该进程运行状态相关的信息。
#3. cat /proc/1/stat，通过该方式可以查看init进程的运行状态，同时也可以了解该文件的格式，其中第三个字段为进程的运行状态字段。
#4. 通过let表达式累加各个计数器。
for pid in /proc/[1-9]*; do
  ((procs=procs+1))
  stat=$(awk '{print $3}' $pid/stat)
  case $stat in
    R) ((running=runing+1));;
    S) ((sleeping=sleeping+1));;
    T) ((stopped=stopped+1));;
    Z) ((zombie=zombie+1));
  esac
done
echo -n "Process Count: "
echo -e "Running = $running\tSleeping = $sleeping\tStopped = $stopped\tZombie = $zombie."

