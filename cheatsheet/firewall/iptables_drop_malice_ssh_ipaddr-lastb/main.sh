#!/bin/bash

workDir="/root"
whiteList=`cat ${workDir}/iptables_drop_malice_ssh_ipaddr/neglect_ssh_list.txt | sort | uniq`
blackList=`cat ${workDir}/iptables_drop_malice_ssh_ipaddr/malice_ssh_list.txt | sort | uniq`
IPS="/sbin/ipset"
IPSET_NAME="drop_ssh_black"
IPSET_NAME_WHITE="drop_ssh_white"


if [ "$1" == "start" ]; then
	# check ipset rules
	isIPSET_RULE=`ipset list | grep "^${IPSET_NAME}$" | wc -l`
	if [[ $isIPSET_RULE != 1 ]]; then
		$IPS create ${IPSET_NAME} hash:ip
	fi

	isIPSET_RULE=`ipset list | grep "^${IPSET_NAME_WHITE}$" | wc -l`
	if [[ $isIPSET_RULE != 1 ]]; then
		$IPS create ${IPSET_NAME_WHITE} hash:ip
	fi

	# check iptable rules black
	isIPTABLE_RULE=`iptables -t filter -nvL |grep "^${IPSET_NAME_WHITE}$" | wc -l`
	if [[ $isIPTABLE_RULE != 1 ]]; then
		iptables -I INPUT -m set --match-set ${IPSET_NAME_WHITE} src -j ACCEPT
	fi 
	for j in ${whiteList}; do $IPS add ${IPSET_NAME_WHITE} $j;done

	# check iptable rules black
	isIPTABLE_RULE=`iptables -t filter -nvL |grep "^${IPSET_NAME}$" | wc -l`
	if [[ $isIPTABLE_RULE != 1 ]]; then
		iptables -I INPUT -m set --match-set ${IPSET_NAME} src -j DROP
	fi 
	for i in ${blackList}; do $IPS add ${IPSET_NAME} $i;done
fi

if [ "$1" == "stop" ]; then
	# delete iptable rules
	iptables -D INPUT -m set --match-set ${IPSET_NAME_WHITE} src -j ACCEPT
	iptables -D INPUT -m set --match-set ${IPSET_NAME} src -j DROP
	
	# delete ipset rules objects
	ipset flush ${IPSET_NAME}
	ipset flush ${IPSET_NAME_WHITE}

	# delete ipset rules
	ipset destroy ${IPSET_NAME}
	ipset destroy ${IPSET_NAME_WHITE}
fi

[[ `echo $?` == "0" ]] && echo $1 Configure IPSet!
