#!/bin/bash

runthis(){
    ## print the command to the logfile
    echo "$@" 
    ## run the command and redirect it's error output
    ## to the logfile
    eval "$@" 
}

echo ""
echo "This experiment shows how to connect two namespaces through a router(Linux Kernel IP Forwarding)"
echo ""
echo "+------------------+     +------------------+"
echo "|                  |     |                  |"
echo "|                  |     |                  |"
echo "|                  |     |                  |"
echo "|       ns1        |     |       ns2        |"
echo "|                  |     |                  |"
echo "|                  |     |                  |"
echo "|                  |     |                  |"
echo "|  192.168.1.2/24  |     |  192.168.2.2/24  |  ns1 route: 192.168.2.0/24 via 192.168.1.1"
echo "+----(veth-ns1)----+     +----(veth-ns2)----+  ns2 route: 192.168.1.0/24 via 192.168.2.1"
echo "         +                          +"
echo "         |                          |"
echo "         |                          |"
echo "         +                          +"
echo "+--(veth-ns1-br)-------------(veth-ns2-br)--+"
echo "|   192.168.1.1               192.168.2.1   |"
echo "|                 ns-router                 |"
echo "|       (Linux Kernel IP Forwarding)        |"
echo "+-------------------------------------------+"
echo ""

read -p "Press [Enter] key to create networkspaces..."
runthis "ip netns add ns1"
runthis "ip netns add ns2"
runthis "ip netns add ns-router"
echo ""
runthis "ip netns"
echo ""

read -p "Press [Enter] key to link ns1 to the router..."
runthis "ip link add veth-ns1 type veth peer name veth-ns1-router"
runthis "ip link set veth-ns1 netns ns1"
runthis "ip link set veth-ns1-router netns ns-router"
echo ""

read -p "Press [Enter] key to link ns2 to router..."
runthis "ip link add veth-ns2 type veth peer name veth-ns2-router"
runthis "ip link set veth-ns2 netns ns2"
runthis "ip link set veth-ns2-router netns ns-router"
echo ""

read -p "Press [Enter] key to assign IP addresses to the devieces..."
runthis "ip netns exec ns1 ip addr add 192.168.1.2/24 dev veth-ns1"
runthis "ip netns exec ns2 ip addr add 192.168.2.2/24 dev veth-ns2"
runthis "ip netns exec ns-router ip addr add 192.168.1.1/24 dev veth-ns1-router"
runthis "ip netns exec ns-router ip addr add 192.168.2.1/24 dev veth-ns2-router"
echo ""

echo "Bring up the devieces..."
runthis "ip netns exec ns1 ip link set veth-ns1 up"
runthis "ip netns exec ns2 ip link set veth-ns2 up"
runthis "ip netns exec ns-router ip link set veth-ns1-router up"
runthis "ip netns exec ns-router ip link set veth-ns2-router up"
echo ""

read -p "Press [Enter] key to show ip addr..."
runthis "ip netns exec ns1 ip addr"
echo ""

read -p ""
runthis "ip netns exec ns2 ip addr"
echo ""

read -p ""
runthis "ip netns exec ns-router ip addr"
echo ""

read -p ""
read -p "Press [Enter] key to ping ns2 ns from ns1, ns1 can't reach ns2 because they're in different subnetworks..."
runthis "ip netns exec ns1 ping 192.168.2.2"
echo ""

read -p "Press [Enter] key to add routes..."
runthis "ip netns exec ns1 ip route add 192.168.2.0/24 via 192.168.1.1"
runthis "ip netns exec ns2 ip route add 192.168.1.0/24 via 192.168.2.1"

read -p "Now the two namespaces should be able to reach to each other through the 'router'(Linux OS itself)..."
runthis "ip netns exec ns1 ping 192.168.2.2"
runthis "ip netns exec ns2 ping 192.168.1.2"
echo ""

read -p "Press [Enter] key to clear up..."

runthis "ip netns delete ns1"
runthis "ip netns delete ns2"
runthis "ip netns delete ns-router"