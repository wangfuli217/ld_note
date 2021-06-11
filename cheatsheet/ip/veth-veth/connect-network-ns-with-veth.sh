#!/bin/bash

runthis(){
    ## print the command to the logfile
    echo "$@" 
    ## run the command and redirect it's error output
    ## to the logfile
    eval "$@" 
}

echo ""
echo "This experiment shows how to connect two namespaces with a virtual link (veth pair)"
echo ""
echo "+------------------+              +------------------+"
echo "|        ns1       |              |      ns2         |"
echo "|                  |  veth pair   |                  |"
echo "|                +-+              +-+                |"
echo "| 192.168.1.1/24 | +--------------+ | 192.168.1.2/24 |"
echo "|   (veth-ns1)   +-+              +-+   (veth-ns2)   |"
echo "|                  |              |                  |"
echo "|                  |              |                  |"
echo "|                  |              |                  |"
echo "+------------------+              +------------------+"
echo ""

read -p "Press [Enter] key to create networkspaces..."
runthis "ip netns add ns1"
runthis "ip netns add ns2"
echo ""
runthis "ip netns"
echo ""

read -p "Press [Enter] key to link ns1 ns and ns2 with veth pair virtual link..."
runthis "ip link add veth-ns1 type veth peer name veth-ns2"
runthis "ip link set veth-ns1 netns ns1"
runthis "ip link set veth-ns2 netns ns2"
echo ""

read -p "Press [Enter] key to assign IP addresses to the veth inside ns1 and ns2..."
runthis "ip netns exec ns1 ip addr add 10.1.1.1/24 dev veth-ns1"
runthis "ip netns exec ns2 ip addr add 10.1.1.2/24 dev veth-ns2"
runthis "ip netns exec ns1 ip link set veth-ns1 up"
runthis "ip netns exec ns2 ip link set veth-ns2 up"
echo ""

read -p "Press [Enter] key to show ip addr in ns1..."
runthis "ip netns exec ns1 ip addr"
echo ""

read -p "Press [Enter] key to show ip addr in ns2..."
runthis "ip netns exec ns2 ip  addr"
echo ""

read -p "Press [Enter] key to ping ns2 ns from ns1..."
runthis "ip netns exec ns1 ping 10.1.1.2"
echo ""

read -p "Press [Enter] key to clear up..."

runthis "ip netns delete ns1"
runthis "ip netns delete ns2"