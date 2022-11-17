#! /bin/sh
### ShellCheck (http://www.shellcheck.net/)
#  In POSIX sh, 'local' is undefined.
#   shellcheck disable=SC3043
# Not following: /lib/functions/network.sh was not specified as input (see shellcheck -x)
#   shellcheck disable=SC1091
# $/${} is unnecessary on arithmetic variables.
#   shellcheck disable=SC2004
# Note that A && B || C is not if-then-else. C may run when A is true
#   shellcheck disable=SC2015
### debug
# sdx65_dial_unittest.sh -- test_get_use_data_flow

month_end_day() {
  mon=${NOW_DATE%-*}
  mon=${mon#*-}
  local idx=1
  month="31 29 31 30 31 30 31 31 30 31 30 31"
  for days in $month; do
    [ "$idx" -eq "$mon" ] && {
      echo "$days"
      return
    }
    idx=$(($idx + 1))
  done
}

month_finish() {
  year=${NOW_DATE%%-*}
  mon=${NOW_DATE%-*}
  mon=${mon#*-}
  days=$(month_end_day)
  date +%F -s "${year}-${mon}-${days}" >/dev/null
  date +%T -s "23:59:56" >/dev/null
  sleep 5
}

NOW_DATE=$(date '+%F')
NOW_TIME=$(date '+%T')

setUp() {
  date +%F -s "$NOW_DATE" >/dev/null
  date +%T -s "$NOW_TIME" >/dev/null
}

oneTimeSetUp() {
  :
}

oneTimeTearDown() {
  :
}

# FILENAME='openwrt-21.02.0-rc3-x86-64-rootfs.tar.gz'
# WGET_SIZE=3969493

FILENAME='openwrt-21.02.0-rc3-x86-64-rootfs.tar.gz'
WGET_SIZE=3969493

# FILENAME='openwrt-21.02.0-rc3-x86-64.manifest'
# WGET_SIZE=3566
wget_ipv4() {
  sleep 3
  while true; do
    wget -4 https://mirrors.tuna.tsinghua.edu.cn/openwrt/releases/21.02.0-rc3/targets/x86/64/$FILENAME -O - >/dev/null 2>&1 && break
    [ "$1" = "0" ] && break
  done
  sleep 2 # wait 4 seconds for a timer in 3 seconds
}

wget_ipv6() {
  sleep 3
  while true; do
    wget -6 https://mirrors.tuna.tsinghua.edu.cn/openwrt/releases/21.02.0-rc3/targets/x86/64/$FILENAME -O - >/dev/null 2>&1 && break
    [ "$1" = "0" ] && break
  done
  sleep 2 # wait 4 seconds for a timer in 3 seconds
}

netdown() {
  local ip_family="$1"
  [ -z "$ip_family" ] && ip_family=10
  ubus call sdk_service.wm set_netdown "{ \"ip_family\":\"10\",\"iface_id\":\"0\" }" >/dev/null
}

netup() {
  local ip_family="$1"
  [ -z "$ip_family" ] && ip_family=10
  ubus call sdk_service.wm set_netup "{ \"ip_family\":\"${ip_family}\",\"iface_id\":\"0\" }" >/dev/null
}

netconf() {
  ubus call sdk_service.wm get_network_conf "{ \"iface_id\":\"0\" }"
}

netstatus() {
  ubus call sdk_service.wm get_network_status "{ \"iface_id\":\"0\" }"
}

MAX_WAIT_DIAL_SUCCESS=10

wait_netup() {
  local output status

  while true; do
    output=$(netstatus)
    status=$?
    network_status=$(echo "$output" | jsonfilter -e "$.network_status")
    if [ "$network_status" = "1" ]; then
      break
    fi
    sleep 1
  done
}

netup_v4() {
  local output status

  output=$(netdown 10)
  sleep 2
  output=$(netup 4)

  wait_netup
  # sleep 3
  while true; do
    output=$(netconf)
    status=$?
    local v4addr
    v4addr=$(echo "$output" | jsonfilter -e "$.IPV4.public_ip")
    if [ "$v4addr" != "0.0.0.0" ]; then
      ping -c 1 -4 www.mi.com >/dev/null 2>&1 && break || continue
      ping -c 1 -4 www.mi.com >/dev/null 2>&1 && break || continue
      ping -c 1 -4 www.mi.com >/dev/null 2>&1 && break || continue
      ping -c 1 -4 www.mi.com >/dev/null 2>&1 && break || continue
      ping -c 1 -4 www.mi.com >/dev/null 2>&1 && break || continue
      ping -c 1 -4 www.mi.com >/dev/null 2>&1 && break || continue
    fi
    [ "$MAX_WAIT_DIAL_SUCCESS" = "$timeout" ] && {
      echo "netup 4:wait dial failure by timeout:$timeout $(date)"
      return 1
    }
    timeout=$(($timeout + 1))
    sleep 1
  done

  sleep 3 # trigger event on 3s timer
  sleep 1 # assert uptime !=0
  return 0
}
wait_netup_v4() {
  while true; do
    netup_v4 && { break; }
  done
}

netup_v6() {
  local output status

  output=$(netdown 10)
  sleep 2
  output=$(netup 6)

  wait_netup
  #  sleep 3
  while true; do
    output=$(netconf)
    status=$?
    local v6addr
    v6addr=$(echo "$output" | jsonfilter -e "$.IPV6.public_ip")
    if [ "$v6addr" != "::" ]; then
      ping -c 1 -6 www.mi.com >/dev/null 2>&1 && break || continue
      ping -c 1 -6 www.mi.com >/dev/null 2>&1 && break || continue
      ping -c 1 -6 www.mi.com >/dev/null 2>&1 && break || continue
      ping -c 1 -6 www.mi.com >/dev/null 2>&1 && break || continue
      ping -c 1 -6 www.mi.com >/dev/null 2>&1 && break || continue
    fi
    [ "$MAX_WAIT_DIAL_SUCCESS" = "$timeout" ] && {
      echo "netup 6:wait dial failure by timeout:$timeout $(date)"
      return 1
    }
    timeout=$(($timeout + 1))
    sleep 1
  done

  sleep 3 # trigger event on 3s timer
  sleep 1 # assert uptime !=0
  return 0
}
wait_netup_v6() {
  while true; do
    netup_v6 && { break; }
  done
}

netup_v4v6() {
  local output status

  output=$(netdown 10)
  sleep 2
  output=$(netup 10)

  wait_netup
  # sleep 3
  while true; do
    output=$(netconf)
    status=$?
    local v4addr v6addr
    v4addr=$(echo "$output" | jsonfilter -e "$.IPV4.public_ip")
    v6addr=$(echo "$output" | jsonfilter -e "$.IPV6.public_ip")
    if [ "$v6addr" != "::" -a "$v4addr" != "0.0.0.0" ]; then
      ping -c 1 -4 www.mi.com >/dev/null 2>&1 && break || continue
      ping -c 1 -4 www.mi.com >/dev/null 2>&1 && break || continue
      ping -c 1 -4 www.mi.com >/dev/null 2>&1 && break || continue
      ping -c 1 -4 www.mi.com >/dev/null 2>&1 && break || continue
      ping -c 1 -4 www.mi.com >/dev/null 2>&1 && break || continue
      ping -c 1 -4 www.mi.com >/dev/null 2>&1 && break || continue
    fi
    [ "$MAX_WAIT_DIAL_SUCCESS" = "$timeout" ] && {
      echo "netup 10:wait dial failure by timeout:$timeout $(date)"
      return 1
    }
    timeout=$(($timeout + 1))
    sleep 1
  done

  sleep 3 # trigger event on 3s timer
  sleep 1 # assert uptime !=0
  return 0
}

wait_netup_v4v6() {
  while true; do
    netup_v4v6 && { break; }
  done
}

# ubus call sdk_service.rm "get_use_data"
# {
#         "flow_once_use": "916443",   --> IPv4 + IPv6 本次拨号统计byte
#         "flow_month_use": "916443",  --> IPv4 + IPv6 月度统计byte
#         "flow_sum_use": "916443",    --> IPv4 + IPv6 总共统计byte
#         "time_once_use": "1402",     --> IPv4 or IPv6 都会累计时间 (本次累计时长)
#         "time_month_use": "3490",    --> IPv4 or IPv6 都会累计时间 (月度累计时长)
#         "time_sum_use": "3490"       --> IPv4 or IPv6 都会累计时间 (总共累计时长)
# }
test_get_use_data_flow() {
  local status
  local output

  local flow_once_use_now flow_month_use_now flow_sum_use_now
  local time_once_use_now time_month_use_now time_sum_use_now

  local flow_once_use_old flow_month_use_old flow_sum_use_old
  local time_once_use_old time_month_use_old time_sum_use_old

  local flow_once_use_diff flow_month_use_diff flow_sum_use_diff
  local time_once_use_diff time_month_use_diff time_sum_use_diff

  # count download and ipv4/ipv6/ipv4v6 stack
  for cmd in wait_netup_v4 wait_netup_v6 wait_netup_v4v6; do
    $cmd

    output=$(ubus call sdk_service.rm "get_use_data") # echo "$output"
    status=$?
    assertTrue "get_use_data($cmd) @ret:${status} @output:${output}" "${status}"
    flow_once_use_old=$(echo "$output" | jsonfilter -e "$.flow_once_use")
    flow_month_use_old=$(echo "$output" | jsonfilter -e "$.flow_month_use")
    flow_sum_use_old=$(echo "$output" | jsonfilter -e "$.flow_sum_use")
    time_once_use_old=$(echo "$output" | jsonfilter -e "$.time_once_use")
    time_month_use_old=$(echo "$output" | jsonfilter -e "$.time_month_use")
    time_sum_use_old=$(echo "$output" | jsonfilter -e "$.time_sum_use")

    [ "$cmd" = "wait_netup_v4" ] && wget_ipv4 "$cmd"
    [ "$cmd" = "wait_netup_v6" ] && wget_ipv6 "$cmd"
    [ "$cmd" = "wait_netup_v4v6" ] && wget_ipv4 "$cmd"
    sleep 6

    output=$(ubus call sdk_service.rm "get_use_data") # echo "$output"
    status=$?
    assertTrue "get_use_data($cmd) @ret:${status} @output:${output}" "${status}"
    flow_once_use_now=$(echo "$output" | jsonfilter -e "$.flow_once_use")
    flow_month_use_now=$(echo "$output" | jsonfilter -e "$.flow_month_use")
    flow_sum_use_now=$(echo "$output" | jsonfilter -e "$.flow_sum_use")
    time_once_use_now=$(echo "$output" | jsonfilter -e "$.time_once_use")
    time_month_use_now=$(echo "$output" | jsonfilter -e "$.time_month_use")
    time_sum_use_now=$(echo "$output" | jsonfilter -e "$.time_sum_use")

    flow_once_use_diff=$(($flow_once_use_now - $flow_once_use_old))
    # flow_once_use_diff=$(( $flow_once_use_diff * 8 ))
    flow_month_use_diff=$(($flow_month_use_now - $flow_month_use_old))
    # flow_month_use_diff=$(( $flow_month_use_diff * 8 ))
    flow_sum_use_diff=$(($flow_sum_use_now - $flow_sum_use_old))
    # flow_sum_use_diff=$(( $flow_sum_use_diff * 8 ))

    assertTrue "flow_once_use_diff=$flow_once_use_diff >= WGET_SIZE=$WGET_SIZE" "[ $flow_once_use_diff -ge $WGET_SIZE ]"
    assertTrue "flow_month_use_diff=$flow_month_use_diff >= WGET_SIZE=$WGET_SIZE" "[ $flow_month_use_diff -ge $WGET_SIZE ]"
    assertTrue "flow_sum_use_diff=$flow_sum_use_diff >= WGET_SIZE=$WGET_SIZE" "[ $flow_sum_use_diff -ge $WGET_SIZE ]"

    assertTrue "flow_once_use_diff=$flow_once_use_diff == flow_month_use_diff=$flow_month_use_diff" "[ $flow_month_use_diff -eq $flow_month_use_diff ]"
    assertTrue "flow_once_use_diff=$flow_once_use_diff == flow_sum_use_diff=$flow_sum_use_diff" "[ $flow_month_use_diff -eq $flow_sum_use_diff ]"

    time_once_use_diff=$(($time_once_use_now - $time_once_use_old))
    time_month_use_diff=$(($time_month_use_now - $time_month_use_old))
    time_sum_use_diff=$(($time_sum_use_now - $time_sum_use_old))

    local diff_month_once=$((time_month_use_diff - time_once_use_diff))
    diff_month_once=${diff_month_once##*-}
    assertTrue "time_once_use_diff=$time_once_use_diff == time_month_use_diff=$time_month_use_diff" "[ $diff_month_once -le 6 ]"
    local diff_sum_once=$((time_sum_use_diff - time_once_use_diff))
    diff_sum_once=${diff_month_once##*-}
    assertTrue "time_once_use_diff=$time_once_use_diff == time_sum_use_diff=$time_sum_use_diff" "[ $diff_sum_once -le 6 ]"
  done
}

test_get_use_data_clean() {
  local status
  local output
  local flow_once_use flow_month_use flow_sum_use
  local time_once_use time_month_use time_sum_use

  local flow_once_use_now flow_month_use_now flow_sum_use_now
  local time_once_use_now time_month_use_now time_sum_use_now

  for cmd in wait_netup_v4 wait_netup_v6 wait_netup_v4v6; do
    $cmd
    output=$(ubus call sdk_service.rm "clean_use_data") # clean_use_data
    status=$?
    assertTrue "clean_use_data($cmd) @ret:${status} @output:${output}" "${status}"

    [ "$cmd" = "wait_netup_v4" ] && wget_ipv4 "wait_netup_v4"
    [ "$cmd" = "wait_netup_v6" ] && wget_ipv6 "wait_netup_v6"
    [ "$cmd" = "wait_netup_v4v6" ] && wget_ipv4 "wait_netup_v4v6"
    sleep 6

    output=$(ubus call sdk_service.rm "get_use_data")
    status=$?
    assertTrue "get_use_data($cmd) @ret:${status} @output:${output}" "${status}"
    flow_once_use=$(echo "$output" | jsonfilter -e "$.flow_once_use")
    flow_month_use=$(echo "$output" | jsonfilter -e "$.flow_month_use")
    flow_sum_use=$(echo "$output" | jsonfilter -e "$.flow_sum_use")
    time_once_use=$(echo "$output" | jsonfilter -e "$.time_once_use")
    time_month_use=$(echo "$output" | jsonfilter -e "$.time_month_use")
    time_sum_use=$(echo "$output" | jsonfilter -e "$.time_sum_use")

    assertTrue "flow_once_use=$flow_once_use = flow_month_use=$flow_month_use" "[ $flow_once_use -eq $flow_month_use ]"
    assertTrue "flow_once_use=$flow_once_use = flow_sum_use=$flow_sum_use" "[ $flow_once_use -eq $flow_sum_use ]"
    local diff_month_once=$((time_month_use - time_once_use))
    diff_month_once=${diff_month_once##*-}
    assertTrue "time_once_use=$time_once_use = time_month_use=$time_month_use" "[ $diff_month_once -le 6 ]"
    local diff_sum_once=$((time_sum_use - time_once_use))
    diff_sum_once=${diff_sum_once##*-}
    assertTrue "time_once_use=$time_once_use = time_sum_use=$time_sum_use" "[ $diff_sum_once -le 6 ]"

    $cmd
    [ "$cmd" = "wait_netup_v4" ] && wget_ipv4 "$cmd"
    [ "$cmd" = "wait_netup_v6" ] && wget_ipv6 "$cmd"
    [ "$cmd" = "wait_netup_v4v6" ] && wget_ipv4 "$cmd"
    sleep 6

    output=$(ubus call sdk_service.rm "get_use_data")
    status=$?
    assertTrue "get_use_data($cmd) @ret:${status} @output:${output}" "${status}"
    flow_once_use_now=$(echo "$output" | jsonfilter -e "$.flow_once_use")
    flow_month_use_now=$(echo "$output" | jsonfilter -e "$.flow_month_use")
    flow_sum_use_now=$(echo "$output" | jsonfilter -e "$.flow_sum_use")
    time_once_use_now=$(echo "$output" | jsonfilter -e "$.time_once_use")
    time_month_use_now=$(echo "$output" | jsonfilter -e "$.time_month_use")
    time_sum_use_now=$(echo "$output" | jsonfilter -e "$.time_sum_use")
    assertTrue "flow_once_use=$flow_once_use_now <= flow_month_use=$flow_month_use_now" "[ $flow_once_use_now -le $flow_month_use_now ]"
    assertTrue "flow_once_use=$flow_once_use_now <= flow_sum_use=$flow_sum_use_now" "[ $flow_once_use_now -le $flow_sum_use_now ]"
    assertTrue "flow_month_use=$flow_month_use_now = flow_sum_use=$flow_sum_use_now" "[ $flow_month_use_now -eq $flow_sum_use_now ]"

    assertTrue "time_once_use=$time_once_use_now <= time_month_use=$time_month_use_now" "[ $time_once_use_now -le $time_month_use_now ]"
    assertTrue "time_once_use=$time_once_use_now <= time_sum_use=$time_sum_use_now" "[ $time_once_use_now -le $time_sum_use_now ]"
    assertTrue "time_month_use=$time_month_use_now = time_sum_use=$time_sum_use_now" "[ $time_month_use_now -eq $time_sum_use_now ]"
  done
}

test_get_use_data_month() {
  local status
  local output

  local flow_once_use_now flow_month_use_now flow_sum_use_now
  local time_once_use_now time_month_use_now time_sum_use_now

  local flow_once_use_old flow_month_use_old flow_sum_use_old
  local time_once_use_old time_month_use_old time_sum_use_old

  NOW_DATE=$(date '+%F')
  NOW_TIME=$(date '+%T')

  for cmd in wait_netup_v4 wait_netup_v6 wait_netup_v4v6; do
    $cmd

    date +%F -s "$NOW_DATE" >/dev/null 2>&1
    date +%T -s "$NOW_TIME" >/dev/null 2>&1
    cfg set time_last_clear 1667232015 >/dev/null 2>&1

    [ "$cmd" = "wait_netup_v4" ] && wget_ipv4 "wait_netup_v4"
    [ "$cmd" = "wait_netup_v6" ] && wget_ipv6 "wait_netup_v6"
    [ "$cmd" = "wait_netup_v4v6" ] && wget_ipv4 "wait_netup_v4v6"
    sleep 10

    output=$(ubus call sdk_service.rm "get_use_data")
    status=$?
    assertTrue "get_use_data($cmd) @ret:${status} @output:${output}" "${status}"
    flow_once_use_old=$(echo "$output" | jsonfilter -e "$.flow_once_use")
    flow_month_use_old=$(echo "$output" | jsonfilter -e "$.flow_month_use")
    flow_sum_use_old=$(echo "$output" | jsonfilter -e "$.flow_sum_use")
    time_once_use_old=$(echo "$output" | jsonfilter -e "$.time_once_use")
    time_month_use_old=$(echo "$output" | jsonfilter -e "$.time_month_use")
    time_sum_use_old=$(echo "$output" | jsonfilter -e "$.time_sum_use")

    month_finish
    sleep 5

    output=$(ubus call sdk_service.rm "get_use_data")
    status=$?
    assertTrue "get_use_data($cmd) @ret:${status} @output:${output}" "${status}"
    flow_once_use_now=$(echo "$output" | jsonfilter -e "$.flow_once_use")
    flow_month_use_now=$(echo "$output" | jsonfilter -e "$.flow_month_use")
    flow_sum_use_now=$(echo "$output" | jsonfilter -e "$.flow_sum_use")
    time_once_use_now=$(echo "$output" | jsonfilter -e "$.time_once_use")
    time_month_use_now=$(echo "$output" | jsonfilter -e "$.time_month_use")
    time_sum_use_now=$(echo "$output" | jsonfilter -e "$.time_sum_use")

    assertTrue "flow_once_use_old=$flow_once_use_old <= flow_once_use_now=$flow_once_use_now" "[ $flow_once_use_old -le $flow_once_use_now ]"
    assertTrue "flow_sum_use_old=$flow_sum_use_old <= flow_sum_use_now=$flow_sum_use_now" "[ $flow_sum_use_old -le $flow_sum_use_now ]"
    assertTrue "flow_month_use_old=$flow_month_use_old >= flow_month_use_now=$flow_month_use_now" "[ $flow_month_use_old -gt $flow_month_use_now ]"

    assertTrue "time_once_use_old=$time_once_use_old <= time_once_use_now=$time_once_use_now" "[ $time_once_use_old -le $time_once_use_now ]"
    assertTrue "time_sum_use_old=$time_sum_use_old <= time_sum_use_now=$time_sum_use_now" "[ $time_sum_use_old -le $time_sum_use_now ]"
    assertTrue "time_sum_use_old=$time_sum_use_old >= time_month_use_now=$time_month_use_now" "[ $time_sum_use_old -gt $time_month_use_now ]"
  done
}

#  ubus call sdk_service.rm "get_use_rx_tx"
# {
#         "flow_once_use_rx": "755815",    devstatus rmnet_data0 | jsonfilter -e "$.statistics.rx_bytes"
#         "flow_once_use_tx": "161589",    devstatus rmnet_data0 | jsonfilter -e "$.statistics.tx_bytes"
#         "flow_month_use_rx": "755815",   月度累计rx
#         "flow_month_use_tx": "161589",   月度累计tx
#         "flow_sum_use_rx": "755815",     总共累计rx
#         "flow_sum_use_tx": "161589"      总共累计tx
# }
test_get_use_rx_tx() {
  local status
  local output
  local flow_once_use_rx_old flow_once_use_tx_old flow_month_use_rx_old flow_month_use_tx_old flow_sum_use_rx_old flow_sum_use_tx_old
  local flow_once_use_rx_now flow_once_use_tx_now flow_month_use_rx_now flow_month_use_tx_now flow_sum_use_rx_now flow_sum_use_tx_now
  local flow_once_use_rx_diff flow_once_use_tx_diff flow_month_use_rx_diff flow_month_use_tx_diff flow_sum_use_rx_diff flow_sum_use_tx_diff

  for cmd in wait_netup_v4 wait_netup_v6 wait_netup_v4v6; do
    $cmd
    output=$(ubus call sdk_service.rm "get_use_rx_tx")
    status=$?
    assertTrue "get_use_rx_tx($cmd) @ret:${status} @output:${output}" "${status}"
    flow_once_use_rx_old=$(echo "$output" | jsonfilter -e "$.flow_once_use_rx")
    flow_once_use_tx_old=$(echo "$output" | jsonfilter -e "$.flow_once_use_tx")
    flow_month_use_rx_old=$(echo "$output" | jsonfilter -e "$.flow_month_use_rx")
    flow_month_use_tx_old=$(echo "$output" | jsonfilter -e "$.flow_month_use_tx")
    flow_sum_use_rx_old=$(echo "$output" | jsonfilter -e "$.flow_sum_use_rx")
    flow_sum_use_tx_old=$(echo "$output" | jsonfilter -e "$.flow_sum_use_tx")

    [ "$cmd" = "wait_netup_v4" ] && wget_ipv4 "$cmd" && sleep 2
    [ "$cmd" = "wait_netup_v6" ] && wget_ipv6 "$cmd" && sleep 2
    [ "$cmd" = "wait_netup_v4v6" ] && wget_ipv4 "$cmd" && sleep 2

    output=$(ubus call sdk_service.rm "get_use_rx_tx")
    status=$?
    assertTrue "get_use_rx_tx($cmd) @ret:${status} @output:${output}" "${status}"
    flow_once_use_rx_now=$(echo "$output" | jsonfilter -e "$.flow_once_use_rx")
    flow_once_use_tx_now=$(echo "$output" | jsonfilter -e "$.flow_once_use_tx")
    flow_month_use_rx_now=$(echo "$output" | jsonfilter -e "$.flow_month_use_rx")
    flow_month_use_tx_now=$(echo "$output" | jsonfilter -e "$.flow_month_use_tx")
    flow_sum_use_rx_now=$(echo "$output" | jsonfilter -e "$.flow_sum_use_rx")
    flow_sum_use_tx_now=$(echo "$output" | jsonfilter -e "$.flow_sum_use_tx")

    flow_once_use_rx_diff=$(($flow_once_use_rx_now - $flow_once_use_rx_old))
    #    flow_once_use_rx_diff=$(( $flow_once_use_rx_diff * 8))
    flow_once_use_tx_diff=$(($flow_once_use_tx_now - $flow_once_use_tx_old))
    flow_month_use_rx_diff=$(($flow_month_use_rx_now - $flow_month_use_rx_old))
    #    flow_month_use_rx_diff=$(( $flow_month_use_rx_diff * 8))
    flow_month_use_tx_diff=$(($flow_month_use_tx_now - $flow_month_use_tx_old))
    flow_sum_use_rx_diff=$(($flow_sum_use_rx_now - $flow_sum_use_rx_old))
    #    flow_sum_use_rx_diff=$(( $flow_sum_use_rx_diff * 8))
    flow_sum_use_tx_diff=$(($flow_sum_use_tx_now - $flow_sum_use_tx_old))

    assertTrue "flow_once_use_tx_diff=$flow_once_use_tx_diff > 0" "[ $flow_once_use_tx_diff -gt 0 ]"
    assertTrue "flow_month_use_tx_diff=$flow_month_use_tx_diff > 0" "[ $flow_month_use_tx_diff -gt 0 ]"
    assertTrue "flow_sum_use_tx_diff=$flow_sum_use_tx_diff  > 0" "[ $flow_sum_use_tx_diff -gt 0 ]"

    assertTrue "flow_once_use_tx_diff=$flow_once_use_tx_diff = flow_month_use_tx_diff=$flow_month_use_tx_diff" "[ $flow_once_use_tx_diff -eq $flow_month_use_tx_diff ]"
    assertTrue "flow_once_use_tx_diff=$flow_once_use_tx_diff = flow_sum_use_tx_diff=$flow_sum_use_tx_diff" "[ $flow_once_use_tx_diff -eq $flow_sum_use_tx_diff ]"

    assertTrue "flow_once_use_rx_diff=$flow_once_use_rx_diff >= WGET_SIZE=$WGET_SIZE" "[ $flow_once_use_rx_diff -ge $WGET_SIZE ]"
    assertTrue "flow_month_use_rx_diff=$flow_month_use_rx_diff >= WGET_SIZE=$WGET_SIZE" "[ $flow_month_use_rx_diff -ge $WGET_SIZE ]"
    assertTrue "flow_sum_use_rx_diff=$flow_sum_use_rx_diff  >= WGET_SIZE=$WGET_SIZE" "[ $flow_sum_use_rx_diff -ge $WGET_SIZE ]"

    assertTrue "flow_once_use_rx_diff=$flow_once_use_rx_diff = flow_month_use_rx_diff=$flow_month_use_rx_diff" "[ $flow_once_use_rx_diff -eq $flow_month_use_rx_diff ]"
    assertTrue "flow_once_use_rx_diff=$flow_once_use_rx_diff = flow_sum_use_rx_diff=$flow_sum_use_rx_diff" "[ $flow_once_use_rx_diff -eq $flow_sum_use_rx_diff ]"
  done
}

# ubus call sdk_service.rm "get_rx_tx_rate"
# {
#         "flow_rx_rate": "0.0000",  # IPv4+IPv6 3秒平均值
#         "flow_tx_rate": "0.0000"   # IPv4+IPv6 3秒平均值
# }
test_get_rx_tx_rate() {
  local status
  local output
  local flow_rx_rate_old flow_rx_rate_now
  local flow_tx_rate_old flow_tx_rate_now

  for cmd in wait_netup_v4 wait_netup_v6 wait_netup_v4v6; do
    $cmd
    sleep 5

    output=$(ubus call sdk_service.rm "get_rx_tx_rate")
    status=$?
    assertTrue "get_rx_tx_rate($cmd) @ret:${status} @output:${output}" "${status}"
    flow_rx_rate_old=$(echo "$output" | jsonfilter -e "$.flow_rx_rate")
    flow_tx_rate_old=$(echo "$output" | jsonfilter -e "$.flow_tx_rate")
    flow_rx_rate_old=${flow_rx_rate_old%%.*}
    flow_tx_rate_old=${flow_tx_rate_old%%.*}
    [ "$cmd" = "wait_netup_v4" ] && wget_ipv4 "$cmd"
    [ "$cmd" = "wait_netup_v6" ] && wget_ipv6 "$cmd"
    [ "$cmd" = "wait_netup_v4v6" ] && wget_ipv4 "$cmd"

    output=$(ubus call sdk_service.rm "get_rx_tx_rate")
    status=$?
    assertTrue "get_rx_tx_rate($cmd) @ret:${status} @output:${output}" "${status}"
    flow_rx_rate_now=$(echo "$output" | jsonfilter -e "$.flow_rx_rate")
    flow_tx_rate_now=$(echo "$output" | jsonfilter -e "$.flow_tx_rate")
    flow_rx_rate_now=${flow_rx_rate_now%%.*}
    flow_tx_rate_now=${flow_tx_rate_now%%.*}
    assertTrue "flow_rx_rate_now=$flow_rx_rate_now >= flow_rx_rate_old=$flow_rx_rate_old" "[ $flow_rx_rate_now -ge $flow_rx_rate_old ]"
    assertTrue "flow_tx_rate_now=$flow_tx_rate_now >= flow_tx_rate_old=$flow_tx_rate_old" "[ $flow_tx_rate_now -ge $flow_tx_rate_old ]"
  done
  output=$(ubus call sdk_service.rm "get_rx_tx_rate")
  output=$(ubus call sdk_service.rm "get_rx_tx_rate")
  flow_rx_rate_now=$(echo "$output" | jsonfilter -e "$.flow_rx_rate")
  flow_tx_rate_now=$(echo "$output" | jsonfilter -e "$.flow_tx_rate")
  flow_rx_rate_now=${flow_rx_rate_now%%.*}
  flow_tx_rate_now=${flow_tx_rate_now%%.*}
  assertTrue "flow_rx_rate_now=$flow_rx_rate_now == 0" "[ $flow_rx_rate_now -ge 0 ]"
  assertTrue "flow_tx_rate_now=$flow_tx_rate_now == 0" "[ $flow_rx_rate_now -ge 0 ]"
  true
}

# ubus call sdk_service.rm "set_statistics_cfg_data" {"enable":"String","time":"String","max_data":"String","threshold":"String"}
# ubus call sdk_service.rm "set_statistics_cfg_data" '{"enable":"1","time":"1000","max_data":"354718609","threshold":"334718609"}' # 设置流量限值(会主动停止拨号)
# ubus call sdk_service.rm "set_statistics_cfg_data" '{"enable":"0","time":"1000","max_data":"354718609","threshold":"334718609"}' # 修改后,不会主动进行拨号
# ubus call sdk_service.rm "get_flow_mon_info"
# {
#         "month_flow_enable": "0",     # 后续值是否有效
#         "month_max_flow": "0",        # 最大值
#         "threshold_flow": "90",       # 阈值
#         "statistics_start_time": "1"  # 统计时间(没有使用)
# }
test_get_flow_mon_info() {
  local status
  local output
  local result

  local max_data=3547186090
  local threshold=90
  output=$(ubus call sdk_service.rm "set_statistics_cfg_data" "{\"enable\":\"1\",\"time\":\"1000\",\"max_data\":\"${max_data}\",\"threshold\":\"${threshold}\"}")
  status=$?
  assertTrue "set_statistics_cfg_data(1) @ret:${status} @output:${output}" "${status}"
  result=$(echo "$output" | jsonfilter -e "$.result")
  assertEquals "set_statistics_cfg_data(1)" "ok" "$result"

  output=$(ubus call sdk_service.rm "get_flow_mon_info")
  assertTrue "get_flow_mon_info(1) @ret:${status} @output:${output}" "${status}"
  status=$?

  local month_flow_enable month_max_flow threshold_flow statistics_start_time
  month_flow_enable=$(echo "$output" | jsonfilter -e "$.month_flow_enable")
  month_max_flow=$(echo "$output" | jsonfilter -e "$.month_max_flow")
  threshold_flow=$(echo "$output" | jsonfilter -e "$.threshold_flow")
  statistics_start_time=$(echo "$output" | jsonfilter -e "$.statistics_start_time")
  assertEquals "get_flow_mon_info(1)" "1" "$month_flow_enable"
  assertEquals "get_flow_mon_info(1)" "1000" "$statistics_start_time"
  assertEquals "get_flow_mon_info(1)" "$max_data" "$month_max_flow"
  assertEquals "get_flow_mon_info(1)" "$threshold" "$threshold_flow"

  max_data=3547186091
  threshold=90
  output=$(ubus call sdk_service.rm "set_statistics_cfg_data" "{\"enable\":\"0\",\"time\":\"9999\",\"max_data\":\"${max_data}\",\"threshold\":\"${threshold}\"}")
  status=$?
  assertTrue "set_statistics_cfg_data(0) @ret:${status} @output:${output}" "${status}"
  result=$(echo "$output" | jsonfilter -e "$.result")
  assertEquals "set_statistics_cfg_data(0)" "ok" "$result"

  output=$(ubus call sdk_service.rm "get_flow_mon_info")
  assertTrue "get_flow_mon_info(0) @ret:${status} @output:${output}" "${status}"
  status=$?
  month_flow_enable=$(echo "$output" | jsonfilter -e "$.month_flow_enable")
  month_max_flow=$(echo "$output" | jsonfilter -e "$.month_max_flow")
  threshold_flow=$(echo "$output" | jsonfilter -e "$.threshold_flow")
  statistics_start_time=$(echo "$output" | jsonfilter -e "$.statistics_start_time")
  assertEquals "get_flow_mon_info(0)" "0" "$month_flow_enable"
  assertEquals "get_flow_mon_info(0)" "9999" "$statistics_start_time"
  assertEquals "get_flow_mon_info(0)" "$max_data" "$month_max_flow"
  assertEquals "get_flow_mon_info(0)" "$threshold" "$threshold_flow"
}

test_set_flow_mon_info_dial() {
  local status
  local output
  local result

  local max_data=$(($WGET_SIZE + $WGET_SIZE))
  local threshold=90
  for cmd in wait_netup_v4 wait_netup_v6 wait_netup_v4v6; do
    output=$(ubus call sdk_service.rm "set_statistics_cfg_data" "{\"enable\":\"0\",\"time\":\"1000\",\"max_data\":\"${max_data}\",\"threshold\":\"${threshold}\"}")
    status=$?

    $cmd

    output=$(ubus call sdk_service.rm "clean_use_data") # clean_use_data
    status=$?
    assertTrue "clean_use_data($cmd) @ret:${status} @output:${output}" "${status}"

    output=$(ubus call sdk_service.rm "set_statistics_cfg_data" "{\"enable\":\"1\",\"time\":\"1000\",\"max_data\":\"${max_data}\",\"threshold\":\"${threshold}\"}")
    status=$?
    assertTrue "set_statistics_cfg_data(1) @ret:${status} @output:${output}" "${status}"
    result=$(echo "$output" | jsonfilter -e "$.result")
    assertEquals "set_statistics_cfg_data(1)" "ok" "$result"

    output=$(ubus call sdk_service.rm "get_flow_mon_info")
    assertTrue "get_flow_mon_info(1) @ret:${status} @output:${output}" "${status}"
    status=$?

    local month_flow_enable month_max_flow threshold_flow statistics_start_time
    month_flow_enable=$(echo "$output" | jsonfilter -e "$.month_flow_enable")
    month_max_flow=$(echo "$output" | jsonfilter -e "$.month_max_flow")
    threshold_flow=$(echo "$output" | jsonfilter -e "$.threshold_flow")
    statistics_start_time=$(echo "$output" | jsonfilter -e "$.statistics_start_time")
    assertEquals "get_flow_mon_info(1)" "1" "$month_flow_enable"
    assertEquals "get_flow_mon_info(1)" "1000" "$statistics_start_time"
    assertEquals "get_flow_mon_info(1)" "$max_data" "$month_max_flow"
    assertEquals "get_flow_mon_info(1)" "$threshold" "$threshold_flow"

    [ "$cmd" = "wait_netup_v4" ] && wget_ipv4 "0" && ping -c 2 -4 www.mi.com >/dev/null 2>&1
    [ "$cmd" = "wait_netup_v6" ] && wget_ipv6 "0" && ping -c 2 -6 www.mi.com >/dev/null 2>&1
    [ "$cmd" = "wait_netup_v4v6" ] && wget_ipv4 "0" && ping -c 2 -4 www.mi.com >/dev/null 2>&1
    sleep 6

    local flow_once_use_now flow_month_use_now flow_sum_use_now
    local time_once_use_now time_month_use_now time_sum_use_now
    output=$(ubus call sdk_service.rm "get_use_data") # echo "$output"
    status=$?
    assertTrue "get_use_data($cmd) @ret:${status} @output:${output}" "${status}"
    flow_once_use_now=$(echo "$output" | jsonfilter -e "$.flow_once_use")
    flow_month_use_now=$(echo "$output" | jsonfilter -e "$.flow_month_use")
    flow_sum_use_now=$(echo "$output" | jsonfilter -e "$.flow_sum_use")

    assertTrue "flow_once_use=$flow_once_use_now <= month_max_flow=$month_max_flow" "[ $flow_once_use_now -le $month_max_flow ]"
    assertTrue "flow_month_use=$flow_month_use_now <= month_max_flow=$month_max_flow" "[ $flow_month_use_now -le $month_max_flow ]"
    assertTrue "flow_sum_use=$flow_sum_use_now <= month_max_flow=$month_max_flow" "[ $flow_sum_use_now -le $month_max_flow ]"

    output=$(netconf)
    status=$?
    assertTrue "netconf ($cmd) @ret:${status} @output:${output}" "${status}"
    [ "$cmd" = "wait_netup_v4" ] && assertContains "netup 4(netconf/IPV4) @output:${output}" "${output}" "IPV4"
    [ "$cmd" = "wait_netup_v6" ] && assertContains "netup 4(netconf/IPV6) @output:${output}" "${output}" "IPV6"
    [ "$cmd" = "wait_netup_v4v6" ] && assertContains "netup 4(netconf/IPV4) @output:${output}" "${output}" "IPV4"
    [ "$cmd" = "wait_netup_v4v6" ] && assertContains "netup 4(netconf/IPV6) @output:${output}" "${output}" "IPV6"

    output=$(netstatus)
    status=$?
    assertTrue "netstatus ($cmd) @ret:${status} @output:${output}" "${status}"
    local network_status
    network_status=$(echo "$output" | jsonfilter -e "$.network_status")
    assertEquals "netstatus ($cmd) @output:${output}" "1" "$network_status"

    [ "$cmd" = "wait_netup_v4" ] && wget_ipv4 "0" && ping -c 2 -4 www.mi.com >/dev/null 2>&1
    [ "$cmd" = "wait_netup_v6" ] && wget_ipv6 "0" && ping -c 2 -6 www.mi.com >/dev/null 2>&1
    [ "$cmd" = "wait_netup_v4v6" ] && wget_ipv4 "0" && ping -c 2 -4 www.mi.com >/dev/null 2>&1
    sleep 6

    output=$(ubus call sdk_service.rm "get_use_data") # echo "$output"
    status=$?
    assertTrue "get_use_data($cmd) @ret:${status} @output:${output}" "${status}"
    flow_once_use_now=$(echo "$output" | jsonfilter -e "$.flow_once_use")
    flow_month_use_now=$(echo "$output" | jsonfilter -e "$.flow_month_use")
    flow_sum_use_now=$(echo "$output" | jsonfilter -e "$.flow_sum_use")

    assertTrue "flow_once_use=$flow_once_use_now >= month_max_flow=$month_max_flow" "[ $flow_once_use_now -lt $month_max_flow ]"
    assertTrue "flow_month_use=$flow_month_use_now <= month_max_flow=$month_max_flow" "[ $flow_month_use_now -ge $month_max_flow ]"
    assertTrue "flow_sum_use=$flow_sum_use_now <= month_max_flow=$month_max_flow" "[ $flow_sum_use_now -ge $month_max_flow ]"

    output=$(netconf)
    status=$?
    assertTrue "netconf ($cmd) @ret:${status} @output:${output}" "${status}"
    assertContains "netup 4(netconf/IPV4) @output:${output}" "${output}" "error"

    output=$(netstatus)
    status=$?
    assertTrue "netstatus ($cmd) @ret:${status} @output:${output}" "${status}"
    local network_status
    network_status=$(echo "$output" | jsonfilter -e "$.network_status")
    assertEquals "netstatus ($cmd) @output:${output}" "2" "$network_status"
  done
  ubus call sdk_service.rm "set_statistics_cfg_data" "{\"enable\":\"0\",\"time\":\"1000\",\"max_data\":\"${max_data}\",\"threshold\":\"${threshold}\"}"
}

# ubus call sdk_service.rm "set_flow_mon_alert":{"isAlert":"String"}
# ubus call sdk_service.rm "get_flow_mon_alert"
test_flow_mon_alert() {
  local status
  local output
  local result

  output=$(ubus call sdk_service.rm "set_flow_mon_alert" '{"isAlert":"0"}')
  status=$?
  assertTrue "set_flow_mon_alert(0) @ret:${status} @output:${output}" "${status}"
  result=$(echo "$output" | jsonfilter -e "$.result")
  assertEquals "set_flow_mon_alert(0)" "ok" "$result"

  output=$(ubus call sdk_service.rm "get_flow_mon_alert")
  status=$?
  assertTrue "get_flow_mon_alert(0) @ret:${status} @output:${output}" "${status}"
  isAlert=$(echo "$output" | jsonfilter -e "$.isAlert")
  assertEquals "get_flow_mon_alert(0)" "0" "$isAlert"

  output=$(ubus call sdk_service.rm "set_flow_mon_alert" '{"isAlert":"1"}')
  status=$?
  assertTrue "set_flow_mon_alert(1) @ret:${status} @output:${output}" "${status}"
  result=$(echo "$output" | jsonfilter -e "$.result")
  assertEquals "set_flow_mon_alert(1)" "ok" "$result"

  output=$(ubus call sdk_service.rm "get_flow_mon_alert")
  status=$?
  assertTrue "get_flow_mon_alert(1) @ret:${status} @output:${output}" "${status}"
  isAlert=$(echo "$output" | jsonfilter -e "$.isAlert")
  assertEquals "get_flow_mon_alert(1)" "1" "$isAlert"
}

# ubus call sdk_service.rm "clean_use_data"
# test_get_use_data 和 get_use_rx_tx 相关值都会被清除
test_clean_use_data() {
  local output status result
  output=$(ubus call sdk_service.rm "clean_use_data") # clean_use_data
  status=$?
  assertTrue "clean_use_data @ret:${status} @output:${output}" "${status}"
  result=$(echo "$output" | jsonfilter -e "$.result")
  assertEquals "clean_use_data" "ok" "$result"

  local flow_once_use_now flow_month_use_now flow_sum_use_now
  local time_once_use_now time_month_use_now time_sum_use_now
  output=$(ubus call sdk_service.rm "get_use_data") # echo "$output"
  status=$?
  assertTrue "get_use_data @ret:${status} @output:${output}" "${status}"
  flow_once_use_now=$(echo "$output" | jsonfilter -e "$.flow_once_use")
  flow_month_use_now=$(echo "$output" | jsonfilter -e "$.flow_month_use")
  flow_sum_use_now=$(echo "$output" | jsonfilter -e "$.flow_sum_use")
  time_once_use_now=$(echo "$output" | jsonfilter -e "$.time_once_use")
  time_month_use_now=$(echo "$output" | jsonfilter -e "$.time_month_use")
  time_sum_use_now=$(echo "$output" | jsonfilter -e "$.time_sum_use")

  assertEquals "get_use_data(flow_once_use)" "0" "$time_sum_use_now"
  assertEquals "get_use_data(flow_month_use)" "0" "$time_sum_use_now"
  assertEquals "get_use_data(flow_sum_use)" "0" "$time_sum_use_now"
  assertEquals "get_use_data(time_once_use)" "0" "$time_sum_use_now"
  assertEquals "get_use_data(time_month_use)" "0" "$time_sum_use_now"
  assertEquals "get_use_data(time_sum_use)" "0" "$time_sum_use_now"

  local flow_once_use_rx_now flow_once_use_tx_now flow_month_use_rx_now flow_month_use_tx_now flow_sum_use_rx_now flow_sum_use_tx_now
  output=$(ubus call sdk_service.rm "get_use_rx_tx")
  status=$?
  assertTrue "get_use_rx_tx($cmd) @ret:${status} @output:${output}" "${status}"
  flow_once_use_rx_now=$(echo "$output" | jsonfilter -e "$.flow_once_use_rx")
  flow_once_use_tx_now=$(echo "$output" | jsonfilter -e "$.flow_once_use_tx")
  flow_month_use_rx_now=$(echo "$output" | jsonfilter -e "$.flow_month_use_rx")
  flow_month_use_tx_now=$(echo "$output" | jsonfilter -e "$.flow_month_use_tx")
  flow_sum_use_rx_now=$(echo "$output" | jsonfilter -e "$.flow_sum_use_rx")
  flow_sum_use_tx_now=$(echo "$output" | jsonfilter -e "$.flow_sum_use_tx")

  assertEquals "get_use_rx_tx(flow_once_use_rx)" "0" "$flow_once_use_rx_now"
  assertEquals "get_use_rx_tx(flow_once_use_tx)" "0" "$flow_once_use_tx_now"
  assertEquals "get_use_rx_tx(flow_month_use_rx)" "0" "$flow_month_use_rx_now"
  assertEquals "get_use_rx_tx(flow_month_use_tx)" "0" "$flow_month_use_tx_now"
  assertEquals "get_use_rx_tx(flow_sum_use_rx)" "0" "$flow_sum_use_rx_now"
  assertEquals "get_use_rx_tx(flow_sum_use_tx)" "0" "$flow_sum_use_tx_now"
}

. shunit2
