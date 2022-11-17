#! /bin/sh
### ShellCheck (http://www.shellcheck.net/)
#  In POSIX sh, 'local' is undefined.
#   shellcheck disable=SC3043
# Not following: /lib/functions/network.sh was not specified as input (see shellcheck -x)
#   shellcheck disable=SC1091
# $/${} is unnecessary on arithmetic variables.
#   shellcheck disable=SC2004
### debug
# sdx65_dial_unittest.sh -- test_netup_v10 test_netup_v4 test_netup_v6
# sdx65_dial_unittest.sh -- test_apn_3gpp_custom_7 test_apn_3gpp_reserved_1to6

MAX_WAIT_DIAL_SUCCESS=10

oneTimeSetUp() {
  printf "at+cfun=0\r\n" >/dev/smd8
  sleep 2
  printf "at+cfun=1\r\n" >/dev/smd8
  sleep 3 # wait 3s for 3s timer
  printf "at+cfun=1\r\n" >/dev/smd8
}

oneTimeTearDown() {
  :
}

netdown() {
  local ip_family="$1"
  [ -z "$ip_family" ] && ip_family=10
  ubus call sdk_service.wm set_netdown "{ \"ip_family\":\"10\",\"iface_id\":\"0\" }"
}

netup() {
  local ip_family="$1"
  [ -z "$ip_family" ] && ip_family=10
  ubus call sdk_service.wm set_netup "{ \"ip_family\":\"${ip_family}\",\"iface_id\":\"0\" }"
}

netconf() {
  ubus call sdk_service.wm get_network_conf "{ \"iface_id\":\"0\" }"
}

netstatus() {
  ubus call sdk_service.wm get_network_status "{ \"iface_id\":\"0\" }"
}

test_ipv6() {
  output=$(netdown 10)
  status=$?
  assertTrue "netup 10 line -> ${LINENO:-}(netdown) @ret:${status} @output:${output}" "${status}"
  assertContains "netup 10 line -> ${LINENO:-}(netdown) @output:${output}" "${output}" "ok"
  result=$(echo "$output" | jsonfilter -e "$.result")
  assertEquals "netup 10 line -> ${LINENO:-}(netdown) @output:${output}" "${result}" "ok"

  output=$(netup 6)
  status=$?
  assertTrue "netup 6 line -> ${LINENO:-}(netup) @ret:${status} @output:${output}" "${status}"
  assertContains "netup 6 line -> ${LINENO:-}(netup) @output:${output}" "${output}" "ok"
  result=$(echo "$output" | jsonfilter -e "$.result")
  assertEquals "netup 6 line -> ${LINENO:-}(netdown) @output:${output}" "${result}" "ok"

  while true; do
    output=$(netstatus)
    status=$?
    assertTrue "netup 6 line -> ${LINENO:-}(netstatus) @ret:${status} @output:${output}" "${status}"
    local network_status ip_family
    network_status=$(echo "$output" | jsonfilter -e "$.network_status")
    ip_family=$(echo "$output" | jsonfilter -e "$.ip_family")

    printf "at+cfun?\r\n" >/dev/smd8
    if [ "$network_status" = "1" ]; then
      break
    fi
    sleep 1
  done

  local timeout=0
  while true; do
    output=$(netconf)
    status=$?
    assertTrue "netup 6 line ->> ${LINENO:-}(netconf) @ret:${status} @output:${output}" "${status}"
    public_ip6=$(echo "$output" | jsonfilter -e "$.IPV6.public_ip")
    if [ "$public_ip6" != "::" ]; then
      break
    fi
    [ "$MAX_WAIT_DIAL_SUCCESS" = "$timeout" ] && {
      echo "netup 6:wait dial failure by timeout:$timeout"
      exit 255
    }
    timeout=$(($timeout + 1))
    sleep 1
  done
  sleep 3 # trigger event on 3s timer
  sleep 1 # assert uptime !=0

  local netmask6
  netmask6=$(ip -6 r show dev bridge0 | awk '/240/{print $1}')
  netmask6=${netmask6%%::/*}

  . /lib/functions/network.sh
  network_flush_cache
  network_find_wan NET_IF
  network_get_subnet6 NET_MASK6 "${NET_IF}"
  assertContains "netup 6 line ->>> ${LINENO:-}(netup) @output:${NET_MASK6}/${netmask6}" "${NET_MASK6}" "${netmask6}"

  output=$(ping -6 www.mi.com -c 3)
  status=$?
  assertTrue "netup 10 line ->>>> ${LINENO:-}(ping6/mi) @ret:${status} @output:${output}" "${status}"
}

test_ipv4v6() {
  output=$(netdown 10)
  status=$?
  assertTrue "netup 10 line -> ${LINENO:-}(netdown) @ret:${status} @output:${output}" "${status}"
  assertContains "netup 10 line -> ${LINENO:-}(netdown) @output:${output}" "${output}" "ok"
  result=$(echo "$output" | jsonfilter -e "$.result")
  assertEquals "netup 10 line -> ${LINENO:-}(netdown) @output:${output}" "${result}" "ok"

  output=$(netup 10)
  status=$?
  assertTrue "netup 10 line -> ${LINENO:-}(netup) @ret:${status} @output:${output}" "${status}"
  assertContains "netup 10 line -> ${LINENO:-}(netup) @output:${output}" "${output}" "ok"
  result=$(echo "$output" | jsonfilter -e "$.result")
  assertEquals "netup 10 line -> ${LINENO:-}(netdown) @output:${output}" "${result}" "ok"

  while true; do
    output=$(netstatus)
    status=$?
    assertTrue "netup 10 line -> ${LINENO:-}(netstatus) @ret:${status} @output:${output}" "${status}"
    local network_status ip_family
    network_status=$(echo "$output" | jsonfilter -e "$.network_status")
    ip_family=$(echo "$output" | jsonfilter -e "$.ip_family")

    if [ "$network_status" = "1" ]; then
      break
    fi
    sleep 1
  done

  local timeout
  while true; do
    output=$(netconf)
    status=$?
    assertTrue "netup 10 line ->> ${LINENO:-}(netconf) @ret:${status} @output:${output}" "${status}"
    local v4addr v6addr
    v4addr=$(echo "$output" | jsonfilter -e "$.IPV4.public_ip")
    v6addr=$(echo "$output" | jsonfilter -e "$.IPV6.public_ip")
    if [ "$v6addr" != "::" -a "$v4addr" != "0.0.0.0" ]; then
      # if echo "$output" | grep -q 'IPV4' > /dev/null ; then
      break
    fi
    [ "$MAX_WAIT_DIAL_SUCCESS" = "$timeout" ] && {
      echo "netup 10:wait dial failure by timeout:$timeout"
      exit 255
    }
    timeout=$(($timeout + 1))
    sleep 1
  done
  sleep 3 # trigger event on 3s timer
  sleep 1 # assert uptime !=0

  local netmask6
  netmask6=$(ip -6 r show dev bridge0 | awk '/240/{print $1}')
  netmask6=${netmask6%%::/*}

  . /lib/functions/network.sh
  network_flush_cache
  network_find_wan NET_IF
  network_get_subnet6 NET_MASK6 "${NET_IF}"
  assertContains "netup 6 line ->>> ${LINENO:-}(netup) @output:${NET_MASK6}/${netmask6}" "${NET_MASK6}" "${netmask6}"

  output=$(ping -4 www.mi.com -c 3)
  status=$?
  assertTrue "netup 10 line ->>>> ${LINENO:-}(ping4/mi) @ret:${status} @output:${output}" "${status}"

  output=$(ping -6 www.mi.com -c 3)
  status=$?
  assertTrue "netup 10 line ->>>> ${LINENO:-}(ping6/mi) @ret:${status} @output:${output}" "${status}"

}

. shunit2
