#! /bin/sh
### ShellCheck (http://www.shellcheck.net/)
#  Not following: ./test_helper was not specified as input (see shellcheck -x)
#   shellcheck disable=SC1091
# Double quote to prevent globbing and word splitting
#   shellcheck disable=SC2086
### debug
# dial_ubus.sh -- test_netup_v10 test_netup_v4 test_netup_v6

setUp() {
ubusd_pid=$(pidof ubusd)
[ -z "$ubusd_pid" ] &&  start-stop-daemon -S -b -a /usr/local/sbin/ubusd --pidfile /run/ubusd.pid 

netifd_pid=$(pidof netifd)
[ -z "$netifd_pid" ] &&  start-stop-daemon -S -b -a /usr/local/sbin/netifd --pidfile /run/netifd.pid 

procd_pid=$(pidof procd)
[ -z "$procd_pid" ] &&  start-stop-daemon -S -b -a /usr/local/sbin/procd --pidfile /run/procd.pid 

cd /mnt/mdm9607_qmi/sdk_ubus_dial
if  [ ! -e test ]; then
    bash /mnt/mdm9607_qmi/sdk_ubus_dial/build.sh
fi

# sdk_pid=$(pidof sdk_ubus_mgmt)
# [ -z "$sdk_pid" ] &&  {  export  DS_TARGET=DS_TARGET_MSM; /mnt/mdm9607_qmi/sdk_ubus_dial/sdk_ubus_mgmt  2>&1 > sdk_ubus_mgmt.log &  }
}

tearDown() {
netifd_pid=$(pidof netifd)
# [ -n "$netifd_pid" ] && start-stop-daemon -K -n netifd

ubusd_pid=$(pidof ubusd)
# [ -n "$ubusd_pid" ] &&  start-stop-daemon -K -n ubusd

procd_pid=$(pidof procd)
# [ -n "$procd_pid" ] &&  start-stop-daemon -K -n procd

sdk_pid=$(pidof sdk_ubus_mgmt)
# [ -n "$sdk_pid" ] && start-stop-daemon -K -n sdk_ubus_mgmt
}

oneTimeSetUp() {
sdk_pid=$(pidof sdk_ubus_mgmt)
# [ -z "$sdk_pid" ] &&  {  export  DS_TARGET=DS_TARGET_MSM; /mnt/mdm9607_qmi/sdk_ubus_dial/sdk_ubus_mgmt  2>&1 > sdk_ubus_mgmt.log &  }
}

oneTimeTearDown() {
/bin/sleep 5
}

test_netup_v10() {

# prepare
/sbin/ip -4 address flush dev usb0
echo "test_netup_v10 prepare"
output="$(bash /usr/local/bin/wm_set_netup_v10 2>&1)"
status=$?
assertTrue "/usr/local/bin/wm_set_netup_v10 @ret:${status} @output:${output}" "${status}"
assertContains "/usr/local/bin/wm_set_netup_v10 @output:${output}" "${output}" "ok"

# dhcp release
echo "test_netup_v10 dhcp release"
/sbin/dhclient -4 -r -w usb0 
ipv4addr="$(ifconfig usb0 | sed -n '/inet addr/p' | awk '{ print $2 }' | awk -F ':' '{ print $2 }' 2>&1)"
status=$?
assertTrue "ifconfig usb0 @ret:${status} @output:${ipv4addr}" "${status}"
assertNull "ifconfig usb0 @ret:${status} @output:${ipv4addr}" "${ipv4addr}"

/bin/sleep 5
output="$(/usr/local/bin/wm_get_network_conf 2>&1)"
status=$?
assertTrue "/usr/local/bin/wm_get_network_conf @ret:${status} @output:${output}" "${status}"
assertContains "/usr/local/bin/wm_get_network_conf  @output:${output}" "${output}" '0.0.0.0'

# dhcp discover && dhcp request
echo "test_netup_v10 dhcp discover + request"
output="$(/sbin/dhclient -4 -v -w usb0 2>&1)"
status=$?
assertTrue "/sbin/dhclient -4 -v -w usb0 @ret:${status} @output:${output}" "${status}"
assertContains "dhclient -4 -v -w usb0 @output:${output}" "${output}" "DHCPREQUEST"
assertContains "dhclient -4 -v -w usb0 @output:${output}" "${output}" "DHCPACK"

echo "test_netup_v10 ping 114.114.114.114 assert"
output="$(/bin/ping 114.114.114.114  -c 2 2>&1)"
status=$?
assertTrue "/bin/ping 114.114.114.114  -c 2 @ret:${status} @output:${output}" "${status}"

echo "test_netup_v10 wm_get_network_conf v4 assert"
ipv4addr="$(ifconfig usb0 | sed -n '/inet addr/p' | awk '{ print $2 }' | awk -F ':' '{ print $2 }' 2>&1)"
status=$?
assertTrue "ifconfig usb0 @ret:${status} @output:${ipv4addr}" "${status}"
output="$(/usr/local/bin/wm_get_network_conf 2>&1)"
status=$?
assertTrue "/usr/local/bin/wm_get_network_conf @ret:${status} @output:${output}" "${status}"
assertContains "/usr/local/bin/wm_get_network_conf  @output:${output}" "${output}" "$ipv4addr"

echo "test_netup_v10 wm_get_network_conf v6 assert"
output="$(/usr/local/bin/wm_get_network_conf 2>&1)"
status=$?
assertTrue "/usr/local/bin/wm_get_network_conf @ret:${status} @output:${output}" "${status}"
assertContains "/usr/local/bin/wm_get_network_conf  @output:${output}" "${output}" "2409:8070:2000:f110::1"
assertContains "/usr/local/bin/wm_get_network_conf  @output:${output}" "${output}" "2409:8070:2000:f010::1"

echo "test_netup_v10 wm_get_network_status assert"
output="$(/usr/local/bin/wm_get_network_status 2>&1)"
status=$?
assertTrue "/usr/local/bin/wm_get_network_status @ret:${status} @output:${output}" "${status}"
output=$(echo $output | sed '/network_status/p')
assertContains "/usr/local/bin/wm_get_network_status  @output:${output}" "${output}" "1"

# clean
echo "test_netup_v10 clean"
output="$(bash /usr/local/bin/wm_set_netdown 2>&1)"
status=$?
assertTrue "/usr/local/bin/wm_set_netdown @ret:${status} @output:${output}" "${status}"
assertContains "/usr/local/bin/wm_set_netdown @output:${output}" "${output}" "ok"

output="$(/bin/ping 114.114.114.114  -c 2 -W 1 2>&1)"
status=$?
assertFalse "/bin/ping 114.114.114.114  -c 2 @ret:${status} @output:${output}" "${status}"
/bin/sleep 10
}

test_netup_v4() {

# prepare
/sbin/ip -4 address flush dev usb0
echo "test_netup_v4 prepare"
output="$(bash /usr/local/bin/wm_set_netup_v4 2>&1)"
status=$?
assertTrue "/usr/local/bin/wm_set_netup_v4 @ret:${status} @output:${output}" "${status}"
assertContains "/usr/local/bin/wm_set_netup_v4 @output:${output}" "${output}" "ok"

# dhcp release
echo "test_netup_v4 dhcp release"
/sbin/dhclient -4 -r -w  usb0
ipv4addr="$(ifconfig usb0 | sed -n '/inet addr/p' | awk '{ print $2 }' | awk -F ':' '{ print $2 }' 2>&1)"
status=$?
assertTrue "ifconfig usb0 @ret:${status} @output:${ipv4addr}" "${status}"
assertNull "ifconfig usb0 @ret:${status} @output:${ipv4addr}" "${ipv4addr}"

/bin/sleep 5
output="$(/usr/local/bin/wm_get_network_conf 2>&1)"
status=$?
assertTrue "/usr/local/bin/wm_get_network_conf @ret:${status} @output:${output}" "${status}"
assertContains "/usr/local/bin/wm_get_network_conf  @output:${output}" "${output}" '0.0.0.0'

# dhcp discover && dhcp request
echo "test_netup_v4 dhcp discover request"
output="$(/sbin/dhclient -4 -v -w usb0 2>&1)"
status=$?
assertTrue "/sbin/dhclient -4 -v -w usb0 @ret:${status} @output:${output}" "${status}"
assertContains "dhclient -4 -v -w usb0 @output:${output}" "${output}" "DHCPREQUEST"
assertContains "dhclient -4 -v -w usb0 @output:${output}" "${output}" "DHCPACK"

output="$(/bin/ping 114.114.114.114  -c 2 2>&1)"
status=$?
assertTrue "/bin/ping 114.114.114.114  -c 2 @ret:${status} @output:${output}" "${status}"

ipv4addr="$(ifconfig usb0 | sed -n '/inet addr/p' | awk '{ print $2 }' | awk -F ':' '{ print $2 }' 2>&1)"
status=$?
assertTrue "ifconfig usb0 @ret:${status} @output:${ipv4addr}" "${status}"
output="$(/usr/local/bin/wm_get_network_conf 2>&1)"
status=$?
assertTrue "/usr/local/bin/wm_get_network_conf @ret:${status} @output:${output}" "${status}"
assertContains "/usr/local/bin/wm_get_network_conf  @output:${output}" "${output}" "$ipv4addr"

# clean
output="$(bash /usr/local/bin/wm_set_netdown 2>&1)"
status=$?
assertTrue "/usr/local/bin/wm_set_netdown @ret:${status} @output:${output}" "${status}"
assertContains "/usr/local/bin/wm_set_netdown @output:${output}" "${output}" "ok"

output="$(/bin/ping 114.114.114.114  -c 2 -W 1 2>&1)"
status=$?
assertFalse "/bin/ping 114.114.114.114  -c 2 @ret:${status} @output:${output}" "${status}"
/bin/sleep 10
}

test_netup_v6() {

# prepare
output="$(bash /usr/local/bin/wm_set_netup_v6 2>&1)"
status=$?
assertTrue "/usr/local/bin/wm_set_netup_v6 @ret:${status} @output:${output}" "${status}"
assertContains "/usr/local/bin/wm_set_netup_v6 @output:${output}" "${output}" "ok"

/bin/sleep 10
output="$(/usr/local/bin/wm_get_network_conf 2>&1)"
status=$?
assertTrue "/usr/local/bin/wm_get_network_conf @ret:${status} @output:${output}" "${status}"
assertContains "/usr/local/bin/wm_get_network_conf  @output:${output}" "${output}" "2409:8070:2000:f110::1"
assertContains "/usr/local/bin/wm_get_network_conf  @output:${output}" "${output}" "2409:8070:2000:f010::1"

output="$(/usr/local/bin/wm_get_network_status 2>&1)"
status=$?
assertTrue "/usr/local/bin/wm_get_network_status @ret:${status} @output:${output}" "${status}"
output=$(echo $output | sed '/network_status/p')
assertContains "/usr/local/bin/wm_get_network_conf  @output:${output}" "${output}" "1"

# clean
output="$(bash /usr/local/bin/wm_set_netdown 2>&1)"
status=$?
assertTrue "/usr/local/bin/wm_set_netdown @ret:${status} @output:${output}" "${status}"
assertContains "/usr/local/bin/wm_set_netdown @output:${output}" "${output}" "ok"
/bin/sleep 10
}



#Load and run shUnit2.
. ./shunit2