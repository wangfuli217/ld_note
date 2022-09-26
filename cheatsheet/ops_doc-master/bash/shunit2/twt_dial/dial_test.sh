#! /bin/sh
### ShellCheck (http://www.shellcheck.net/)
#  Not following: ./test_helper was not specified as input (see shellcheck -x)
#   shellcheck disable=SC1091
# Double quote to prevent globbing and word splitting
#   shellcheck disable=SC2086
### debug
# dial_test.sh -- test_netup_v10 test_netup_v4 test_netup_v6
# dial_test.sh -- test_apn_3gpp_custom_7 test_apn_3gpp_reserved_1to6 test_apn_3gpp2 test_del_apn
# dial_test.sh -- _test_twt_dial_apn_test _test_twt_dial_test
#
### environment
# 1. process and kernel driver
# ubusd netifd procd and gobinet driver && /sbin/usb/compositions/9025 && /dev/qcqmi0
# 2. wrapper script
# wm_del_apn_profile_id  wm_get_apn_info  wm_get_network_conf  wm_get_network_status
# wm_set_apn_3gpp  wm_set_netdown  wm_set_netup_v10  wm_set_netup_v4  wm_set_netup_v6
#

setUp() {
  ubusd_pid=$(pidof ubusd || true)
  [ -z "$ubusd_pid" ] && start-stop-daemon -S -b -a /usr/local/sbin/ubusd --pidfile /run/ubusd.pid

  netifd_pid=$(pidof netifd || true)
  [ -z "$netifd_pid" ] && start-stop-daemon -S -b -a /usr/local/sbin/netifd --pidfile /run/netifd.pid

  procd_pid=$(pidof procd || true)
  [ -z "$procd_pid" ] && start-stop-daemon -S -b -a /usr/local/sbin/procd --pidfile /run/procd.pid

  true
  #  cd /mnt/mdm9607_qmi/sdk_ubus_dial
  #  if [ ! -e test ]; then
  #    bash /mnt/mdm9607_qmi/sdk_ubus_dial/build.sh
  #  fi
  #
  #  sdk_pid=$(pidof sdk_ubus_mgmt || true)
  #  [ -z "$sdk_pid" ] && {
  #    export DS_TARGET=DS_TARGET_MSM
  #    /mnt/mdm9607_qmi/sdk_ubus_dial/sdk_ubus_mgmt >sdk_ubus_mgmt.log 2>&1 &
  #  }
}

tearDown() {
  netifd_pid=$(pidof netifd || true)
  # [ -n "$netifd_pid" ] && start-stop-daemon -K -n netifd

  ubusd_pid=$(pidof ubusd || true)
  # [ -n "$ubusd_pid" ] &&  start-stop-daemon -K -n ubusd

  procd_pid=$(pidof procd || true)
  # [ -n "$procd_pid" ] &&  start-stop-daemon -K -n procd

  sdk_pid=$(pidof sdk_ubus_mgmt || true)
  # [ -n "$sdk_pid" ] && start-stop-daemon -K -n sdk_ubus_mgmt
}

oneTimeSetUp() {
  sdk_pid=$(pidof sdk_ubus_mgmt || true)
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
  output="$(/bin/ping 114.114.114.114 -c 2 2>&1)"
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
  #   shellcheck disable=SC2086
  output=$(echo $output | sed '/network_status/p')
  assertContains "/usr/local/bin/wm_get_network_status  @output:${output}" "${output}" "1"

  # clean
  echo "test_netup_v10 clean"
  output="$(bash /usr/local/bin/wm_set_netdown 2>&1)"
  status=$?
  assertTrue "/usr/local/bin/wm_set_netdown @ret:${status} @output:${output}" "${status}"
  assertContains "/usr/local/bin/wm_set_netdown @output:${output}" "${output}" "ok"

  startSkipping
  output="$(/bin/ping 114.114.114.114 -c 2 -W 1 2>&1)"
  status=$?
  assertFalse "/bin/ping 114.114.114.114  -c 2 @ret:${status} @output:${output}" "${status}"
  endSkipping

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
  echo "test_netup_v4 dhcp discover request"
  output="$(/sbin/dhclient -4 -v -w usb0 2>&1)"
  status=$?
  assertTrue "/sbin/dhclient -4 -v -w usb0 @ret:${status} @output:${output}" "${status}"
  assertContains "dhclient -4 -v -w usb0 @output:${output}" "${output}" "DHCPREQUEST"
  assertContains "dhclient -4 -v -w usb0 @output:${output}" "${output}" "DHCPACK"

  output="$(/bin/ping 114.114.114.114 -c 2 2>&1)"
  status=$?
  assertTrue "/bin/ping 114.114.114.114  -c 2 @ret:${status} @output:${output}" "${status}"

  ipv4addr="$(ifconfig usb0 | sed -n '/inet addr/p' | awk '{ print $2 }' | awk -F ':' '{ print $2 }' 2>&1)"
  status=$?
  assertTrue "ifconfig usb0 @ret:${status} @output:${ipv4addr}" "${status}"
  output="$(/usr/local/bin/wm_get_network_conf 2>&1)"
  status=$?
  assertTrue "/usr/local/bin/wm_get_network_conf @ret:${status} @output:${output}" "${status}"
  assertContains "/usr/local/bin/wm_get_network_conf  @output:${output}" "${output}" "$ipv4addr"

  echo "test_netup_v4wm_get_network_conf v6 assert"
  output="$(/usr/local/bin/wm_get_network_conf 2>&1)"
  status=$?
  assertTrue "/usr/local/bin/wm_get_network_conf @ret:${status} @output:${output}" "${status}"
  assertContains "/usr/local/bin/wm_get_network_conf  @output:${output}" "${output}" "::"

  # clean
  output="$(bash /usr/local/bin/wm_set_netdown 2>&1)"
  status=$?
  assertTrue "/usr/local/bin/wm_set_netdown @ret:${status} @output:${output}" "${status}"
  assertContains "/usr/local/bin/wm_set_netdown @output:${output}" "${output}" "ok"

  startSkipping
  output="$(/bin/ping 114.114.114.114 -c 2 -W 1 2>&1)"
  status=$?
  assertFalse "/bin/ping 114.114.114.114  -c 2 @ret:${status} @output:${output}" "${status}"
  endSkipping

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
  #   shellcheck disable=SC2086
  output=$(echo $output | sed '/network_status/p')
  assertContains "/usr/local/bin/wm_get_network_conf  @output:${output}" "${output}" "1"

  # clean
  output="$(bash /usr/local/bin/wm_set_netdown 2>&1)"
  status=$?
  assertTrue "/usr/local/bin/wm_set_netdown @ret:${status} @output:${output}" "${status}"
  assertContains "/usr/local/bin/wm_set_netdown @output:${output}" "${output}" "ok"
  /bin/sleep 10
}

test_apn_3gpp_custom_7() {

  # reserved default apn
  output="$(bash wm_get_default_apn)"
  status=$?
  assertTrue "/usr/local/bin/wm_get_default_apn @ret:${status} @output:${output}" "${status}"
  default_apn=$(echo "${output}" | awk '/default/{print $2}' | tr -d ',"')

  while read -r profile_id ip_family user_id apn_name auth_type auth_password; do
    output="$(bash /usr/local/bin/wm_set_apn_3gpp "${profile_id}" "${ip_family}" "${user_id}" "${apn_name}" "${auth_type}" "${auth_password}")"
    status=$?
    assertTrue "/usr/local/bin/wm_set_apn_3gpp @ret:${status} @output:${output}" "${status}"
    assertContains "/usr/local/bin/wm_set_apn_3gpp @output:${output}" "${output}" "ok"

    output="$(bash wm_get_apn_info)"
    assertTrue "/usr/local/bin/wm_get_apn_info @ret:${status} @output:${output}" "${status}"
    assertContains "/usr/local/bin/wm_get_apn_info @output:${output}" "${output}" "${user_id}"
    assertContains "/usr/local/bin/wm_get_apn_info @output:${output}" "${output}" "${apn_name}"
  done <<EOF
7 4    user_3gpp_custom_id74    apn_3gpp_custom_name74    0 auth_3gpp_custom_password74
7 4    user_3gpp_custom_id74    apn_3gpp_custom_name74    1 auth_3gpp_custom_password74
7 6    user_3gpp_custom_id76    apn_3gpp_custom_name76    1 auth_3gpp_custom_password76
7 6    user_3gpp_custom_id76    apn_3gpp_custom_name76    0 auth_3gpp_custom_password76
7 10   user_3gpp_custom_id710   apn_3gpp_custom_name710   1 auth_3gpp_custom_password710
7 10   user_3gpp_custom_id710   apn_3gpp_custom_name710   0 auth_3gpp_custom_password710
EOF

  # restore default apn
  output="$(bash wm_set_default_apn "${default_apn}")"
  status=$?
  assertTrue "/usr/local/bin/wm_get_default_apn @ret:${status} @output:${output}" "${status}"
}

test_apn_3gpp_reserved_1to6() {

  # reserved default apn
  output="$(bash wm_get_default_apn)"
  status=$?
  assertTrue "/usr/local/bin/wm_get_default_apn @ret:${status} @output:${output}" "${status}"
  default_apn=$(echo "${output}" | awk '/default/{print $2}' | tr -d ',"')

  while read -r profile_id ip_family user_id apn_name auth_type auth_password; do
    output="$(bash /usr/local/bin/wm_set_apn_3gpp "${profile_id}" "${ip_family}" "${user_id}" "${apn_name}" "${auth_type}" "${auth_password}")"
    status=$?
    assertTrue "/usr/local/bin/wm_set_apn_3gpp @ret:${status} @output:${output}" "${status}"
    assertContains "/usr/local/bin/wm_set_apn_3gpp @output:${output}" "${output}" "ok"

    output="$(bash wm_get_apn_info)"
    assertTrue "/usr/local/bin/wm_get_apn_info @ret:${status} @output:${output}" "${status}"
    assertNotContains "/usr/local/bin/wm_get_apn_info @output:${output}" "${output}" "${user_id}"
    assertNotContains "/usr/local/bin/wm_get_apn_info @output:${output}" "${output}" "${apn_name}"
  done <<EOF
1  4   user_3gpp_reserved_id41   apn_3gpp_reserved_name41   0 auth_3gpp_reserved_password41
2  4   user_3gpp_reserved_id42   apn_3gpp_reserved_name42   0 auth_3gpp_reserved_password42
3  4   user_3gpp_reserved_id43   apn_3gpp_reserved_name43   0 auth_3gpp_reserved_password43
4  4   user_3gpp_reserved_id44   apn_3gpp_reserved_name44   1 auth_3gpp_reserved_password44
5  4   user_3gpp_reserved_id45   apn_3gpp_reserved_name45   1 auth_3gpp_reserved_password45
6  4   user_3gpp_reserved_id46   apn_3gpp_reserved_name46   1 auth_3gpp_reserved_password46
1  6   user_3gpp_reserved_id61   apn_3gpp_reserved_name61   0 auth_3gpp_reserved_password61
2  6   user_3gpp_reserved_id62   apn_3gpp_reserved_name62   0 auth_3gpp_reserved_password62
3  6   user_3gpp_reserved_id63   apn_3gpp_reserved_name63   0 auth_3gpp_reserved_password63
4  6   user_3gpp_reserved_id64   apn_3gpp_reserved_name64   1 auth_3gpp_reserved_password64
5  6   user_3gpp_reserved_id65   apn_3gpp_reserved_name65   1 auth_3gpp_reserved_password65
6  6   user_3gpp_reserved_id66   apn_3gpp_reserved_name66   1 auth_3gpp_reserved_password66
1  10  user_3gpp_reserved_id101  apn_3gpp_reserved_name101  0 auth_3gpp_reserved_password101
2  10  user_3gpp_reserved_id102  apn_3gpp_reserved_name102  0 auth_3gpp_reserved_password102
3  10  user_3gpp_reserved_id103  apn_3gpp_reserved_name103  0 auth_3gpp_reserved_password103
4  10  user_3gpp_reserved_id104  apn_3gpp_reserved_name104  1 auth_3gpp_reserved_password104
5  10  user_3gpp_reserved_id105  apn_3gpp_reserved_name105  1 auth_3gpp_reserved_password105
6  10  user_3gpp_reserved_id106  apn_3gpp_reserved_name106  1 auth_3gpp_reserved_password106
EOF

  # restore default apn
  output="$(bash wm_set_default_apn "${default_apn}")"
  status=$?
  assertTrue "/usr/local/bin/wm_get_default_apn @ret:${status} @output:${output}" "${status}"
}

test_apn_3gpp2() {
  while read -r profile_id ip_family user_id apn_name auth_type auth_password; do
    output="$(bash /usr/local/bin/wm_set_apn_3gpp2 "${profile_id}" "${ip_family}" "${user_id}" "${apn_name}" "${auth_type}" "${auth_password}")"
    status=$?
    assertTrue "/usr/local/bin/wm_set_apn_3gpp2 @ret:${status} @output:${output}" "${status}"
    assertContains "/usr/local/bin/wm_set_apn_3gpp2 @output:${output}" "${output}" "ok"

    output="$(bash wm_get_apn_info)"
    assertTrue "/usr/local/bin/wm_get_apn_info @ret:${status} @output:${output}" "${status}"
    assertContains "/usr/local/bin/wm_get_apn_info @output:${output}" "${output}" "${user_id}"
    assertContains "/usr/local/bin/wm_get_apn_info @output:${output}" "${output}" "${apn_name}"
  done <<EOF
0 4    user_3gpp2_id04    apn_3gpp2_name04    0 auth_3gpp2_password04
0 4    user_3gpp2_id04    apn_3gpp2_name04    1 auth_3gpp2_password04
0 6    user_3gpp2_id06    apn_3gpp2_name06    1 auth_3gpp2_password06
0 6    user_3gpp2_id06    apn_3gpp2_name06    0 auth_3gpp2_password06
0 10   user_3gpp2_id010   apn_3gpp2_name010   1 auth_3gpp2_password010
0 10   user_3gpp2_id010   apn_3gpp2_name010   0 auth_3gpp2_password010
6 4    user_3gpp2_id64    apn_3gpp2_name64    0 auth_3gpp2_password64
6 6    user_3gpp2_id66    apn_3gpp2_name66    1 auth_3gpp2_password66
6 6    user_3gpp2_id66    apn_3gpp2_name66    0 auth_3gpp2_password66
6 10   user_3gpp2_id610   apn_3gpp2_name610   1 auth_3gpp2_password610
6 10   user_3gpp2_id610   apn_3gpp2_name610   0 auth_3gpp2_password610
EOF
}

test_del_apn() {

  # danger test
  startSkipping
  while read -r profile_id ip_family user_id apn_name auth_type auth_password; do
    output="$(bash /usr/local/bin/wm_set_apn_3gpp "${profile_id}" "${ip_family}" "${user_id}" "${apn_name}" "${auth_type}" "${auth_password}")"
    status=$?
    assertTrue "/usr/local/bin/wm_set_apn_3gpp @ret:${status} @output:${output}" "${status}"
    assertContains "/usr/local/bin/wm_set_apn_3gpp @output:${output}" "${output}" "ok"

    output="$(bash wm_get_apn_info)"
    assertTrue "/usr/local/bin/wm_get_apn_info @ret:${status} @output:${output}" "${status}"
    assertContains "/usr/local/bin/wm_get_apn_info @output:${output}" "${output}" "${user_id}"
    assertContains "/usr/local/bin/wm_get_apn_info @output:${output}" "${output}" "${apn_name}"

    output="$(bash wm_del_apn_profile_id "${profile_id}")"
    status=$?
    assertTrue "/usr/local/bin/wm_del_apn_profile_id ${profile_id} @ret:${status} @output:${output}" "${status}"
    assertContains "/usr/local/bin/wm_del_apn_profile_id ${profile_id} @output:${output}" "${output}" "ok"

    output="$(bash wm_get_apn_info)"
    assertTrue "/usr/local/bin/wm_get_apn_info @ret:${status} @output:${output}" "${status}"
    assertNotContains "/usr/local/bin/wm_get_apn_info @output:${output}" "${output}" "${user_id}"
    assertNotContains "/usr/local/bin/wm_get_apn_info @output:${output}" "${output}" "${apn_name}"

    output="$(bash wm_del_apn_profile_id "${profile_id}")"
    status=$?
    assertTrue "/usr/local/bin/wm_del_apn_profile_id ${profile_id} @ret:${status} @output:${output}" "${status}"
    assertContains "/usr/local/bin/wm_del_apn_profile_id ${profile_id} @output:${output}" "${output}" "error"
  done <<EOF
7 4    user_3gpp_del_id74    apn_3gpp_del_name74    0 auth_3gpp_del_password74
7 4    user_3gpp_del_id74    apn_3gpp_del_name74    1 auth_3gpp_del_password74
7 6    user_3gpp_del_id76    apn_3gpp_del_name76    1 auth_3gpp_del_password76
7 6    user_3gpp_del_id76    apn_3gpp_del_name76    0 auth_3gpp_del_password76
7 10   user_3gpp_del_id710   apn_3gpp_del_name710   1 auth_3gpp_del_password710
7 10   user_3gpp_del_id710   apn_3gpp_del_name710   0 auth_3gpp_del_password710
EOF
  endSkipping

  while read -r profile_id ip_family user_id apn_name auth_type auth_password; do
    output="$(bash /usr/local/bin/wm_set_apn_3gpp2 "${profile_id}" "${ip_family}" "${user_id}" "${apn_name}" "${auth_type}" "${auth_password}")"
    status=$?
    assertTrue "/usr/local/bin/wm_set_apn_3gpp2 @ret:${status} @output:${output}" "${status}"
    assertContains "/usr/local/bin/wm_set_apn_3gpp2 @output:${output}" "${output}" "ok"

    output="$(bash wm_get_apn_info)"
    assertTrue "/usr/local/bin/wm_get_apn_info @ret:${status} @output:${output}" "${status}"
    assertContains "/usr/local/bin/wm_get_apn_info @output:${output}" "${output}" "${user_id}"
    assertContains "/usr/local/bin/wm_get_apn_info @output:${output}" "${output}" "${apn_name}"

    output="$(bash wm_del_apn_profile_id "${profile_id}")"
    status=$?
    assertTrue "/usr/local/bin/wm_del_apn_profile_id ${profile_id} @ret:${status} @output:${output}" "${status}"
    assertContains "/usr/local/bin/wm_del_apn_profile_id ${profile_id} @output:${output}" "${output}" "error"

    output="$(bash wm_get_apn_info)"
    status=$?
    assertTrue "/usr/local/bin/wm_get_apn_info @ret:${status} @output:${output}" "${status}"
    assertContains "/usr/local/bin/wm_get_apn_info @output:${output}" "${output}" "${user_id}"
    assertContains "/usr/local/bin/wm_get_apn_info @output:${output}" "${output}" "${apn_name}"

    output="$(bash wm_del_apn_profile_id "${profile_id}")"
    status=$?
    assertTrue "/usr/local/bin/wm_del_apn_profile_id ${profile_id} @ret:${status} @output:${output}" "${status}"
    assertContains "/usr/local/bin/wm_del_apn_profile_id ${profile_id} @output:${output}" "${output}" "error"
  done <<EOF
0 4    user_3gpp2_del_id04    apn_3gpp2_del_name04    0 auth_3gpp2_del_password04 
0 4    user_3gpp2_del_id04    apn_3gpp2_del_name04    1 auth_3gpp2_del_password04 
0 6    user_3gpp2_del_id06    apn_3gpp2_del_name06    1 auth_3gpp2_del_password06 
0 6    user_3gpp2_del_id06    apn_3gpp2_del_name06    0 auth_3gpp2_del_password06 
0 10   user_3gpp2_del_id010   apn_3gpp2_del_name010   1 auth_3gpp2_del_password010
0 10   user_3gpp2_del_id010   apn_3gpp2_del_name010   0 auth_3gpp2_del_password010
EOF

  startSkipping
  while read -r profile_id ip_family user_id apn_name auth_type auth_password; do
    output="$(bash /usr/local/bin/wm_set_apn_3gpp "${profile_id}" "${ip_family}" "${user_id}" "${apn_name}" "${auth_type}" "${auth_password}")"
    status=$?
    assertTrue "/usr/local/bin/wm_set_apn_3gpp @ret:${status} @output:${output}" "${status}"
    assertContains "/usr/local/bin/wm_set_apn_3gpp @output:${output}" "${output}" "ok"

    output="$(bash wm_del_apn_profile_id "${profile_id}")"
    status=$?
    assertTrue "/usr/local/bin/wm_del_apn_profile_id ${profile_id} @ret:${status} @output:${output}" "${status}"
  done <<EOF
5 4    user_del_id54    apn_del_name54    0 auth_del_password54 
6 4    user_del_id64    apn_del_name64    0 auth_del_password64 
EOF
  endSkipping
}

test_default_apn() {
  APN_TEST_CMD=$(which twt_dial_apn_test)
  [ -n "${APN_TEST_CMD}" ] && {

    while read -r profile_id apn_name ip_family user_id auth_password auth_type pdu_user_id pdu_auth_password pdu_auth_type; do
      output="$(twt_dial_apn_test -i "${profile_id}" get)"
      status=$?
      if [ "${status}" != "0" ]; then
        output="$(twt_dial_apn_test -i "${profile_id}" -n "${apn_name}" -f "${ip_family}" -u "${user_id}" -p "${auth_password}" -a "${auth_type}" -U "${pdu_user_id}" -P "${pdu_auth_password}" -A "${pdu_auth_type}" set)"
        status=$?
        assertTrue "twt_dial_apn_test set @ret:${status} @output:${output}" "${status}"
      fi
    done <<EOF
0 apn_twt_name_0t  ipv4v6  user_twt_id_t0  auth_twt_password_0t  chap      user_twt_id_t0  auth_twt_password_0t  chap
1 apn_twt_name_1t  ipv4    user_twt_id_t1  auth_twt_password_1t  chap      user_twt_id_t1  auth_twt_password_1t  chap
2 apn_twt_name_2t  ipv6    user_twt_id_t2  auth_twt_password_2t  chap      user_twt_id_t2  auth_twt_password_2t  chap
3 apn_twt_name_3t  ipv4v6  user_twt_id_t3  auth_twt_password_3t  pap       user_twt_id_t3  auth_twt_password_3t  pap 
4 apn_twt_name_4t  ipv4v6  user_twt_id_t4  auth_twt_password_4t  pap       user_twt_id_t4  auth_twt_password_4t  pap 
5 apn_twt_name_5t  ipv4v6  user_twt_id_t5  auth_twt_password_5t  pap+chap  user_twt_id_t5  auth_twt_password_5t  pap+chap
7 apn_twt_name_7t  ipv4v6  user_twt_id_t7  auth_twt_password_7t  pap+chap  user_twt_id_t7  auth_twt_password_7t  pap+chap
6 apn_twt_name_6t  ipv4v6  user_twt_id_t6  auth_twt_password_6t  pap+chap  user_twt_id_t6  auth_twt_password_6t  pap+chap
EOF
  }

  output="$(bash wm_get_apn_info)"
  status=$?
  assertTrue "/usr/local/bin/wm_get_apn_info @ret:${status} @output:${output}" "${status}"
  echo "${output}" | sed -n '3p' | tr -d ',"' >./.default_apn_name
  echo "${output}" | sed -n '10p' | tr -d ',"' >>./.default_apn_name
  echo "${output}" | sed -n '17p' | tr -d ',"' >>./.default_apn_name
  echo "${output}" | sed -n '24p' | tr -d ',"' >>./.default_apn_name
  echo "${output}" | sed -n '31p' | tr -d ',"' >>./.default_apn_name
  echo "${output}" | sed -n '38p' | tr -d ',"' >>./.default_apn_name
  echo "${output}" | sed -n '45p' | tr -d ',"' >>./.default_apn_name
  echo "${output}" | sed -n '52p' | tr -d ',"' >>./.default_apn_name

  output="$(bash wm_get_default_apn)"
  status=$?
  assertTrue "/usr/local/bin/wm_get_default_apn @ret:${status} @output:${output}" "${status}"
  default_apn=$(echo "${output}" | awk '/default/{print $2}' | tr -d ',"')

  while read apn_name; do
    echo "${apn_name}"
    output="$(bash wm_set_default_apn "${apn_name}")"
    status=$?
    assertTrue "/usr/local/bin/wm_set_default_apn @ret:${status} @output:${output}" "${status}"

    output="$(bash wm_get_default_apn)"
    status=$?
    assertTrue "/usr/local/bin/wm_get_default_apn @ret:${status} @output:${output}" "${status}"
    assertContains "/usr/local/bin/wm_get_default_apn @output:${output}" "${output}" "${apn_name}"
    sleep 2
  done <./.default_apn_name

  output="$(bash wm_set_default_apn "${default_apn}")"
  status=$?
  assertTrue "/usr/local/bin/wm_get_default_apn @ret:${status} @output:${output}" "${status}"

  output="$(bash wm_set_default_apn "unconfig_apn")"
  status=$?
  assertTrue "/usr/local/bin/wm_set_default_apn @ret:${status} @output:${output}" "${status}"
  assertContains "/usr/local/bin/wm_set_default_apn @output:${output}" "${output}" "error"

  [ -f .default_apn_name ] && { rm .default_apn_name; }
}

_test_twt_dial_apn_test() {
  APN_TEST_CMD=$(which twt_dial_apn_test)

  [ -n "${APN_TEST_CMD}" ] && {
    echo "_test_twt_dial_apn_test testing ..."
    echo "_test_twt_dial_apn_test testing 3gpp set|get"
    while read -r profile_id apn_name ip_family user_id auth_password auth_type; do
      output="$(twt_dial_apn_test -i "${profile_id}" -n "${apn_name}" -f "${ip_family}" -u "${user_id}" -p "${auth_password}" -a "${auth_type}" set)"
      status=$?
      assertTrue "twt_dial_apn_test set @ret:${status} @output:${output}" "${status}"

      output="$(twt_dial_apn_test -i "${profile_id}" get)"
      status=$?
      assertTrue "twt_dial_apn_test ${profile_id} get  @ret:${status} @output:${output}" "${status}"
      assertContains "twt_dial_apn_test ${profile_id} get @output:${output}" "${output}" "3gpp"
      assertContains "twt_dial_apn_test ${profile_id} get @output:${output}" "${output}" "${apn_name}"
      assertContains "twt_dial_apn_test ${profile_id} get @output:${output}" "${output}" "${user_id}"
      assertContains "twt_dial_apn_test ${profile_id} get @output:${output}" "${output}" "${auth_password}"

      [ "${ip_family}" = "ipv4v6" ] && {
        assertContains "twt_dial_apn_test ${profile_id} get @output:${output}" "${output}" "IPv4"
        assertContains "twt_dial_apn_test ${profile_id} get @output:${output}" "${output}" "IPv6"
      }

      [ "${ip_family}" = "ipv4" ] && {
        assertContains "twt_dial_apn_test ${profile_id} get @output:${output}" "${output}" "IPv4"
        assertNotContains "twt_dial_apn_test ${profile_id} get @output:${output}" "${output}" "IPv6"
      }

      [ "${ip_family}" = "ipv6" ] && {
        assertNotContains "twt_dial_apn_test ${profile_id} get @output:${output}" "${output}" "IPv4"
        assertContains "twt_dial_apn_test ${profile_id} get @output:${output}" "${output}" "IPv6"
      }

      [ "${auth_type}" = "pap+chap" ] && {
        assertContains "twt_dial_apn_test ${profile_id} get @output:${output}" "${output}" "CHAP"
        assertContains "twt_dial_apn_test ${profile_id} get @output:${output}" "${output}" "PAP"
      }

      [ "${auth_type}" = "chap" ] && {
        assertContains "twt_dial_apn_test ${profile_id} get @output:${output}" "${output}" "CHAP"
        assertNotContains "twt_dial_apn_test ${profile_id} get @output:${output}" "${output}" "PAP"
      }

      [ "${auth_type}" = "pap" ] && {
        assertNotContains "twt_dial_apn_test ${profile_id} get @output:${output}" "${output}" "CHAP"
        assertContains "twt_dial_apn_test ${profile_id} get @output:${output}" "${output}" "PAP"
      }
    done <<EOF
4 apn_twt_name_4t  ipv4v6  user_twt_id_t4  auth_twt_password_4t  chap
5 apn_twt_name_5t  ipv4    user_twt_id_t5  auth_twt_password_5t  chap
6 apn_twt_name_6t  ipv6    user_twt_id_t6  auth_twt_password_6t  chap
6 apn_twt_name_6t  ipv4v6  user_twt_id_t6  auth_twt_password_6t  pap 
7 apn_twt_name_7t  ipv4v6  user_twt_id_t7  auth_twt_password_7t  pap 
8 apn_twt_name_8t  ipv4v6  user_twt_id_t8  auth_twt_password_8t  pap+chap
9 apn_twt_name_9t  ipv4v6  user_twt_id_t9  auth_twt_password_9t  pap+chap
EOF

    echo "_test_twt_dial_apn_test testing 3gpp2 set|get"
    while read -r profile_id apn_name ip_family user_id auth_password auth_type pdu_user_id pdu_auth_password pdu_auth_type; do
      output="$(twt_dial_apn_test -i "${profile_id}" -n "${apn_name}" -f "${ip_family}" -u "${user_id}" -p "${auth_password}" -a "${auth_type}" -U "${pdu_user_id}" -P "${pdu_auth_password}" -A "${pdu_auth_type}" set)"
      status=$?
      assertTrue "twt_dial_apn_test set @ret:${status} @output:${output}" "${status}"

      output="$(twt_dial_apn_test -i "${profile_id}" get)"
      status=$?
      assertTrue "twt_dial_apn_test ${profile_id} get  @ret:${status} @output:${output}" "${status}"
      assertContains "twt_dial_apn_test ${profile_id} get @output:${output}" "${output}" "3gpp2"
      assertContains "twt_dial_apn_test ${profile_id} get @output:${output}" "${output}" "${apn_name}"
      assertContains "twt_dial_apn_test ${profile_id} get @output:${output}" "${output}" "${pdu_user_id}"
      assertContains "twt_dial_apn_test ${profile_id} get @output:${output}" "${output}" "${pdu_auth_password}"

      [ "${ip_family}" = "ipv4v6" ] && {
        assertContains "twt_dial_apn_test ${profile_id} get @output:${output}" "${output}" "IPv4"
        assertContains "twt_dial_apn_test ${profile_id} get @output:${output}" "${output}" "IPv6"
      }

      [ "${ip_family}" = "ipv4" ] && {
        assertContains "twt_dial_apn_test ${profile_id} get @output:${output}" "${output}" "IPv4"
        assertNotContains "twt_dial_apn_test ${profile_id} get @output:${output}" "${output}" "IPv6"
      }

      [ "${ip_family}" = "ipv6" ] && {
        assertNotContains "twt_dial_apn_test ${profile_id} get @output:${output}" "${output}" "IPv4"
        assertContains "twt_dial_apn_test ${profile_id} get @output:${output}" "${output}" "IPv6"
      }

      [ "${pdu_auth_type}" = "pap+chap" ] && {
        assertContains "twt_dial_apn_test ${profile_id} get @output:${output}" "${output}" "CHAP"
        assertContains "twt_dial_apn_test ${profile_id} get @output:${output}" "${output}" "PAP"
      }

      [ "${pdu_auth_type}" = "chap" ] && {
        assertContains "twt_dial_apn_test ${profile_id} get @output:${output}" "${output}" "CHAP"
        assertNotContains "twt_dial_apn_test ${profile_id} get @output:${output}" "${output}" "PAP"
      }

      [ "${pdu_auth_type}" = "pap" ] && {
        assertNotContains "twt_dial_apn_test ${profile_id} get @output:${output}" "${output}" "CHAP"
        assertContains "twt_dial_apn_test ${profile_id} get @output:${output}" "${output}" "PAP"
      }
    done <<EOF
0 apn_twt_name_0t  ipv4v6  user_twt_id_0t  auth_twt_password_0t  chap      pdu_user_twt_id_0t  pdu_auth_twt_password_0t  chap
0 apn_twt_name_0t  ipv4    user_twt_id_0t  auth_twt_password_0t  chap      pdu_user_twt_id_0t  pdu_auth_twt_password_0t  chap
0 apn_twt_name_0t  ipv6    user_twt_id_0t  auth_twt_password_0t  chap      pdu_user_twt_id_0t  pdu_auth_twt_password_0t  chap
0 apn_twt_name_0t  ipv4v6  user_twt_id_0t  auth_twt_password_0t  pap       pdu_user_twt_id_0t  pdu_auth_twt_password_0t  pap 
0 apn_twt_name_0t  ipv4v6  user_twt_id_0t  auth_twt_password_0t  pap       pdu_user_twt_id_0t  pdu_auth_twt_password_0t  pap 
0 apn_twt_name_0t  ipv4v6  user_twt_id_0t  auth_twt_password_0t  pap+chap  pdu_user_twt_id_0t  pdu_auth_twt_password_0t  pap+chap
0 apn_twt_name_0t  ipv4v6  user_twt_id_0t  auth_twt_password_0t  pap+chap  pdu_user_twt_id_0t  pdu_auth_twt_password_0t  pap+chap
EOF

    echo "_test_twt_dial_apn_test testing 3gpp set|get|del"
    while read -r profile_id apn_name ip_family user_id auth_password auth_type; do
      output="$(twt_dial_apn_test -i "${profile_id}" -n "${apn_name}" -f "${ip_family}" -u "${user_id}" -p "${auth_password}" -a "${auth_type}" set)"
      status=$?
      assertTrue "twt_dial_apn_test set @ret:${status} @output:${output}" "${status}"

      output="$(twt_dial_apn_test -i "${profile_id}" get)"
      status=$?
      assertTrue "twt_dial_apn_test ${profile_id} get  @ret:${status} @output:${output}" "${status}"
      assertContains "twt_dial_apn_test ${profile_id} get @output:${output}" "${output}" "3gpp"
      assertContains "twt_dial_apn_test ${profile_id} get @output:${output}" "${output}" "${apn_name}"
      assertContains "twt_dial_apn_test ${profile_id} get @output:${output}" "${output}" "${user_id}"
      assertContains "twt_dial_apn_test ${profile_id} get @output:${output}" "${output}" "${auth_password}"

      [ "${ip_family}" = "ipv4v6" ] && {
        assertContains "twt_dial_apn_test ${profile_id} get @output:${output}" "${output}" "IPv4"
        assertContains "twt_dial_apn_test ${profile_id} get @output:${output}" "${output}" "IPv6"
      }

      [ "${ip_family}" = "ipv4" ] && {
        assertContains "twt_dial_apn_test ${profile_id} get @output:${output}" "${output}" "IPv4"
        assertNotContains "twt_dial_apn_test ${profile_id} get @output:${output}" "${output}" "IPv6"
      }

      [ "${ip_family}" = "ipv6" ] && {
        assertNotContains "twt_dial_apn_test ${profile_id} get @output:${output}" "${output}" "IPv4"
        assertContains "twt_dial_apn_test ${profile_id} get @output:${output}" "${output}" "IPv6"
      }

      [ "${auth_type}" = "pap+chap" ] && {
        assertContains "twt_dial_apn_test ${profile_id} get @output:${output}" "${output}" "CHAP"
        assertContains "twt_dial_apn_test ${profile_id} get @output:${output}" "${output}" "PAP"
      }

      [ "${auth_type}" = "chap" ] && {
        assertContains "twt_dial_apn_test ${profile_id} get @output:${output}" "${output}" "CHAP"
        assertNotContains "twt_dial_apn_test ${profile_id} get @output:${output}" "${output}" "PAP"
      }

      [ "${auth_type}" = "pap" ] && {
        assertNotContains "twt_dial_apn_test ${profile_id} get @output:${output}" "${output}" "CHAP"
        assertContains "twt_dial_apn_test ${profile_id} get @output:${output}" "${output}" "PAP"
      }

      output="$(twt_dial_apn_test -i "${profile_id}" del)"
      status=$?
      assertTrue "twt_dial_apn_test ${profile_id} del  @ret:${status} @output:${output}" "${status}"

      output="$(twt_dial_apn_test -i "${profile_id}" get)"
      status=$?
      assertFalse "twt_dial_apn_test ${profile_id} get  @ret:${status} @output:${output}" "${status}"
      assertContains "twt_dial_apn_test ${profile_id} get @output:${output}" "${output}" "failure"

      output="$(twt_dial_apn_test -i "${profile_id}" del)"
      status=$?
      assertFalse "twt_dial_apn_test ${profile_id} del  @ret:${status} @output:${output}" "${status}"
      assertContains "twt_dial_apn_test ${profile_id} del @output:${output}" "${output}" "failure"
    done <<EOF
8 apn_twt_name_8t  ipv4v6  user_twt_id_t8  auth_twt_password_8t  pap+chap
9 apn_twt_name_9t  ipv4v6  user_twt_id_t9  auth_twt_password_9t  pap+chap
EOF

    echo "_test_twt_dial_apn_test testing 3gpp2 set|get|del"
    while read -r profile_id apn_name ip_family user_id auth_password auth_type; do
      output="$(twt_dial_apn_test -i "${profile_id}" -n "${apn_name}" -f "${ip_family}" -u "${user_id}" -p "${auth_password}" -a "${auth_type}" set)"
      status=$?
      assertTrue "twt_dial_apn_test set @ret:${status} @output:${output}" "${status}"

      output="$(twt_dial_apn_test -i "${profile_id}" del)"
      status=$?
      assertFalse "twt_dial_apn_test ${profile_id} del  @ret:${status} @output:${output}" "${status}"
      assertContains "twt_dial_apn_test ${profile_id} del @output:${output}" "${output}" "failure"

      output="$(twt_dial_apn_test -i "${profile_id}" get)"
      status=$?
      assertTrue "twt_dial_apn_test ${profile_id} get  @ret:${status} @output:${output}" "${status}"
      assertContains "twt_dial_apn_test ${profile_id} get @output:${output}" "${output}" "3gpp2"
      assertContains "twt_dial_apn_test ${profile_id} get @output:${output}" "${output}" "${apn_name}"
      assertContains "twt_dial_apn_test ${profile_id} get @output:${output}" "${output}" "${pdu_user_id}"
      assertContains "twt_dial_apn_test ${profile_id} get @output:${output}" "${output}" "${pdu_auth_password}"
    done <<EOF
0 apn_twt_name_8t  ipv4v6  user_twt_id_t8  auth_twt_password_8t  pap+chap
0 apn_twt_name_9t  ipv4v6  user_twt_id_t9  auth_twt_password_9t  pap
EOF
  }

}

_test_twt_dial_test() {
  DIAL_TEST_CMD=$(which twt_dial_test)

  [ -n "${DIAL_TEST_CMD}" ] && {
    cat >./twt_dial_script_v4 <<'twt_dial_script_EOF'
start
sleep 10
exec dhclient -4 usb0
rx_tx 0
qmi_rx_tx 0
status 0
nw_conf 0
stop 0
bye
twt_dial_script_EOF

    cat >./twt_dial_script_v6 <<'twt_dial_script_EOF'
start
sleep 10
rx_tx 0
qmi_rx_tx 0
status 0
nw_conf 0
stop 0
bye
twt_dial_script_EOF

    echo "_test_twt_dial_test 1 dial(ipv4|ipv6|ipv4v6)"
    while read -r ip_family; do
      [ "${ip_family}" = ipv6 ] && {
        echo "twt_dial_test -I 0 -f ${ip_family} -m 10 -s twt_dial_script_v6"
        #   shellcheck disable=SC2030 disable=SC2031
        output="$(export DS_TARGET=DS_TARGET_MSM && twt_dial_test -I 0 -f "${ip_family}" -m 10 -s twt_dial_script_v6 2>&1)"
        status=$?
      }

      [ "${ip_family}" = ipv4 ] && {
        echo "twt_dial_test -I 0 -f ${ip_family} -m 10 -s twt_dial_script_v4"
        #   shellcheck disable=SC2030 disable=SC2031
        output="$(export DS_TARGET=DS_TARGET_MSM && twt_dial_test -I 0 -f "${ip_family}" -m 10 -s twt_dial_script_v4 2>&1)"
        status=$?
      }

      [ "${ip_family}" = ipv4v6 ] && {
        echo "twt_dial_test -I 0 -f ${ip_family} -m 10 -s twt_dial_script_v4"
        #   shellcheck disable=SC2030 disable=SC2031
        output="$(export DS_TARGET=DS_TARGET_MSM && twt_dial_test -I 0 -f "${ip_family}" -m 10 -s twt_dial_script_v4 2>&1)"
        status=$?
      }
      assertTrue "twt_dial_test -I 0 -f ${ip_family} -m 10 -s twt_dial_script" "${status}"
      assertContains "twt_dial_test -I 0 -f ${ip_family} -m 10 -s twt_dial_script" "${output}" "rx:0"
      assertContains "twt_dial_test -I 0 -f ${ip_family} -m 10 -s twt_dial_script" "${output}" "tx:0"
      assertContains "twt_dial_test -I 0 -f ${ip_family} -m 10 -s twt_dial_script" "${output}" "connstatus:connected"
      assertContains "twt_dial_test -I 0 -f ${ip_family} -m 10 -s twt_dial_script" "${output}" "ipv4 network information"
      assertContains "twt_dial_test -I 0 -f ${ip_family} -m 10 -s twt_dial_script" "${output}" "ipv6 network information"
      sleep 10
    done <<EOF
ipv4
ipv6
ipv4v6
EOF
    echo "_test_twt_dial_test 2 dial(ipv4|ipv6|ipv4v6) todo"
  }

}

#Load and run shUnit2.
. ./shunit2
