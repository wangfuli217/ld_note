#! /bin/sh
### ShellCheck (http://www.shellcheck.net/)
#  In POSIX sh, 'local' is undefined.
#   shellcheck disable=SC3043
# Not following: /lib/functions/network.sh was not specified as input (see shellcheck -x)
#   shellcheck disable=SC1091
### debug
# sdx65_dial_unittest.sh -- test_netup_v10 test_netup_v4 test_netup_v6
# sdx65_dial_unittest.sh -- test_apn_3gpp_custom_7 test_apn_3gpp_reserved_1to6

oneTimeSetUp() {
  :
}

oneTimeTearDown() {
  sleep 3 # wait 3s for 3s timer
}


netdown(){
  local ip_family="$1";
  [ -z "$ip_family" ] && ip_family=10;
  ubus call sdk_service.wm set_netdown "{ \"ip_family\":\"10\",\"iface_id\":\"0\" }"
}

netup(){
  local ip_family="$1";
  [ -z "$ip_family" ] && ip_family=10;
  ubus call sdk_service.wm set_netup "{ \"ip_family\":\"${ip_family}\",\"iface_id\":\"0\" }"
}

netconf(){
  ubus call sdk_service.wm get_network_conf "{ \"iface_id\":\"0\" }"
}

netstatus(){
  ubus call sdk_service.wm get_network_status "{ \"iface_id\":\"0\" }" 
}

get_default_apn(){
  ubus call sdk_service.wm get_default_apn
}

# ubus call sdk_service.wm set_default_apn "{\"apn_name\":\"3GNET\"}"
set_default_apn(){
  local apn_name="$1";
  [ -z "$apn_name" ] && apn_name="3GNET";
  ubus call sdk_service.wm set_default_apn "{\"apn_name\":\"${apn_name}\"}"
}

# ubus call sdk_service.wm set_apn_3gpp '{"profile_id":"7","ip_family":"4","user_id":"user_id-t7","apn_name":"apn_name-t7","auth_type":"0","auth_password":"auth_password-t7"}'
set_apn_3gpp(){
  PROFILE_ID=${1:-7}
  IP_FAMILY=${2:-4}
  USER_ID=${3:-user_id-t7}
  APN_NAME=${4:-apn_name-t7}
  AUTH_TYPE=${5:-0}
  AUTH_PASSWORD=${6:-auth_password-t7}
  ubus call sdk_service.wm set_apn_3gpp "{\"profile_id\":\"${PROFILE_ID}\",\"ip_family\":\"${IP_FAMILY}\",\"user_id\":\"${USER_ID}\",\"apn_name\":\"${APN_NAME}\",\"auth_type\":\"${AUTH_TYPE}\",\"auth_password\":\"${AUTH_PASSWORD}\"}"
}

# ubus call sdk_service.wm del_apn_profile_id '{ "profile_id":"7" }'
del_apn_profile_id(){
  PROFILE_ID=${1:-7}
  ubus call sdk_service.wm del_apn_profile_id "{\"profile_id\":\"${PROFILE_ID}\"}"
}



get_apn_info(){
  ubus call sdk_service.wm get_apn_info
}

test_netup_v10() {
  local output result;
  
  output=$(netdown 10);
  status=$?
  assertTrue "netup 10(netdown) @ret:${status} @output:${output}" "${status}"
  assertContains "netup 10(netdown) @output:${output}" "${output}" "ok"
  result=$(echo "$output" | jsonfilter -e "$.result")
  assertEquals "netup 10(netdown) @output:${output}" "${result}" "ok"
  
  output=$(netup 10);
  status=$?
  assertTrue "netup 10(netup) @ret:${status} @output:${output}" "${status}"
  assertContains "netup 10(netup) @output:${output}" "${output}" "ok"
  result=$(echo "$output" | jsonfilter -e "$.result")
  assertEquals "netup 10(netdown) @output:${output}" "${result}" "ok"

  while true; do
    output=$(netstatus);
    status=$?
    assertTrue "netup 10(netstatus) @ret:${status} @output:${output}" "${status}"
    assertContains "netup 10(netstatus/iface_id) @output:${output}" "${output}" "iface_id"
    assertContains "netup 10(netstatus/network_status) @output:${output}" "${output}" "network_status"
    assertContains "netup 10(netstatus/ip_family) @output:${output}" "${output}" "ip_family"
    local iface_id network_status ip_family
    iface_id=$(echo "$output" | jsonfilter -e "$.iface_id")
    network_status=$(echo "$output" | jsonfilter -e "$.network_status")
    ip_family=$(echo "$output" | jsonfilter -e "$.ip_family")
    
    assertEquals "netup 10(netstatus/iface_id)  @output:${output}" "0" "$iface_id"
    assertEquals "netup 10(netstatus/ip_family) @output:${output}" "10" "$ip_family"
    if [ "$network_status" = "1" ]; then
      sleep 1
      break
    fi
  done

  while true; do
    output=$(netconf);
    status=$?
    assertTrue "netup 10(netconf) @ret:${status} @output:${output}" "${status}"
    if echo "$output" | grep -q 'IPV4' > /dev/null ; then
      break;
    fi
  done

  assertContains "netup 10(netconf/IPV4) @output:${output}" "${output}" "IPV4"
  assertContains "netup 10(netconf/IPV6) @output:${output}" "${output}" "IPV6"

  local public_ip     public_ip6
  local sub_net_mask  sub_net_mask6
  local gw_addr       gw_addr6
  local pri_dns_addr  pri_dns_addr6
  local sec_dns_addr  sec_dns_addr6
  public_ip=$(echo "$output" | jsonfilter -e "$.IPV4.public_ip")
  sub_net_mask=$(echo "$output" | jsonfilter -e "$.IPV4.sub_net_mask")
  gw_addr=$(echo "$output" | jsonfilter -e "$.IPV4.gw_addr")
  pri_dns_addr=$(echo "$output" | jsonfilter -e "$.IPV4.pri_dns_addr")
  sec_dns_addr=$(echo "$output" | jsonfilter -e "$.IPV4.sec_dns_addr")
  public_ip6=$(echo "$output" | jsonfilter -e "$.IPV6.public_ip")
  sub_net_mask6=$(echo "$output" | jsonfilter -e "$.IPV6.sub_net_mask")
  gw_addr6=$(echo "$output" | jsonfilter -e "$.IPV6.gw_addr")
  pri_dns_addr6=$(echo "$output" | jsonfilter -e "$.IPV6.pri_dns_addr")
  sec_dns_addr6=$(echo "$output" | jsonfilter -e "$.IPV6.sec_dns_addr")
  
  assertNotEquals "netup 10(netconf/public_ip) @output:${output}" "0.0.0.0" "$public_ip"
  assertNotEquals "netup 10(netconf/sub_net_mask) @output:${output}" "0" "$sub_net_mask"
  assertNotEquals "netup 10(netconf/gw_addr) @output:${output}" "0.0.0.0" "$gw_addr"
  assertNotEquals "netup 10(netconf/pri_dns_addr) @output:${output}" "0.0.0.0" "$pri_dns_addr"
  assertNotEquals "netup 10(netconf/sec_dns_addr) @output:${output}" "0.0.0.0" "$sec_dns_addr"
  
  assertNotEquals "netup 10(netconf/public_ip6) @output:${output}" "::" "$public_ip6"
  assertNotEquals "netup 10(netconf/sub_net_mask6) @output:${output}" "0" "$sub_net_mask6"
  assertNotEquals "netup 10(netconf/gw_addr6) @output:${output}" "::" "$gw_addr6"
  assertNotEquals "netup 10(netconf/pri_dns_addr6) @output:${output}" "::" "$pri_dns_addr6"
  assertNotEquals "netup 10(netconf/sec_dns_addr6) @output:${output}" "::" "$sec_dns_addr6"

  sleep 3 # trigger event on 3s timer
  sleep 1 # assert uptime !=0

  . /lib/functions/network.sh
  network_flush_cache
  network_find_wan NET_IF
  assertEquals "netup 10(network_find_wan/NET_IF) @output:${NET_IF}" "wwan" "$NET_IF"
  
  network_get_device NET_L3D "${NET_IF}"
  assertEquals "netup 10(network_find_wan/NET_L3D) @output:${NET_L3D}" "rmnet_data0" "$NET_L3D"
  
  network_get_ipaddr NET_ADDR "${NET_IF}"
  network_get_ipaddr6 NET_ADDR6 "${NET_IF}"
  assertEquals "netup 10(network_find_wan/NET_ADDR) @output:${NET_ADDR}"  "$public_ip"  "$NET_ADDR"
  assertEquals "netup 10(network_find_wan/NET_ADDR6) @output:${NET_ADDR}" "$public_ip6" "$NET_ADDR6"
  
  network_get_ipaddrs NET_ADDRS "${NET_IF}"
  network_get_ipaddrs6 NET_ADDRS6 "${NET_IF}"
  network_get_ipaddrs_all NET_ADDRS64 "${NET_IF}" 
  assertContains "netup 10(network_get_ipaddrs/NET_ADDRS)  @output:${NET_ADDRS}"        "${NET_ADDRS}"   "$public_ip"  
  assertContains "netup 10(network_get_ipaddrs6/NET_ADDRS6) @output:${NET_ADDRS6}"      "${NET_ADDRS6}"  "$public_ip6" 
  assertContains "netup 10(network_get_ipaddrs_all/NET_ADDRS64) @output:${NET_ADDRS64}" "${NET_ADDRS64}" "$public_ip"  
  assertContains "netup 10(network_get_ipaddrs_all/NET_ADDRS64) @output:${NET_ADDRS64}" "${NET_ADDRS64}" "$public_ip6" 
  
  network_get_subnet NET_MASK "${NET_IF}"
  network_get_subnet6 NET_MASK6 "${NET_IF}"
  assertContains "netup 10(network_get_subnet/NET_MASK)  @output:${NET_MASK}"   "${NET_MASK}"  "$sub_net_mask"  
  assertContains "netup 10(network_get_subnet6/NET_MASK6) @output:${NET_MASK6}" "${NET_MASK6}" "$sub_net_mask6" 
  
  network_get_subnets NET_MASKS "${NET_IF}"      
  network_get_subnets6 NET_MASKS6 "${NET_IF}"   
  assertContains "netup 10(network_get_subnets/NET_MASKS)  @output:${NET_MASKS}"   "${NET_MASKS}"  "$sub_net_mask" 
  assertContains "netup 10(network_get_subnets6/NET_MASKS6) @output:${NET_MASKS6}" "${NET_MASKS6}" "$sub_net_mask6"
  
  network_get_gateway NET_GW "${NET_IF}"         
  network_get_gateway6 NET_GW6 "${NET_IF}"      
  assertEquals "netup 10(network_get_gateway/NET_GW)  @output:${gw_addr}"  "${gw_addr}" "$NET_GW"
  # assertEquals "netup 10(netconf/NET_GW6) @output:${gw_addr6}"  "${gw_addr6}" "$NET_GW6"  why not equal??
  
  network_get_dnsserver DNSSRV "${NET_IF}"
  assertContains "netup 10(network_get_dnsserver/DNSSRV)  @output:${DNSSRV}" "${DNSSRV}" "$pri_dns_addr"  
  assertContains "netup 10(network_get_dnsserver/DNSSRV) @output:${DNSSRV}"  "${DNSSRV}" "$sec_dns_addr"  
  assertContains "netup 10(network_get_dnsserver/DNSSRV)  @output:${DNSSRV}" "${DNSSRV}" "$pri_dns_addr6" 
  assertContains "netup 10(network_get_dnsserver/DNSSRV) @output:${DNSSRV}"  "${DNSSRV}" "$sec_dns_addr6" 

  network_get_protocol PROTO "${NET_IF}"
  assertEquals "netup 10(network_get_protocol/PROTO) @output:${PROTO}"  "rmnet" "$PROTO"
  
  network_get_uptime UPTIME "${NET_IF}"
  assertNotEquals "netup 10(network_get_uptime/UPTIME) @output:${UPTIME}" "0" "$UPTIME"
  network_is_up "${NET_IF}"
  status=$?
  assertTrue "netup 10(netconf) @ret:${status}" "${status}"
  true;
}

test_netup_v4() {
  local output result;

  output=$(netdown 10);
  status=$?
  assertTrue "netup 4(netdown) @ret:${status} @output:${output}" "${status}"
  assertContains "netup 4(netdown) @output:${output}" "${output}" "ok"
  result=$(echo "$output" | jsonfilter -e "$.result")
  assertEquals "netup 4(netdown) @output:${output}" "${result}" "ok"

  output=$(netup 4);
  status=$?
  assertTrue "netup 4(netup) @ret:${status} @output:${output}" "${status}"
  assertContains "netup 4(netup) @output:${output}" "${output}" "ok"
  result=$(echo "$output" | jsonfilter -e "$.result")
  assertEquals "netup 4(netdown) @output:${output}" "${result}" "ok"

  while true; do
    output=$(netstatus);
    status=$?
    assertTrue "netup 4(netstatus) @ret:${status} @output:${output}" "${status}"
    assertContains "netup 4(netstatus/iface_id) @output:${output}" "${output}" "iface_id"
    assertContains "netup 4(netstatus/network_status) @output:${output}" "${output}" "network_status"
    assertContains "netup 4(netstatus/ip_family) @output:${output}" "${output}" "ip_family"
    local iface_id network_status ip_family
    iface_id=$(echo "$output" | jsonfilter -e "$.iface_id")
    network_status=$(echo "$output" | jsonfilter -e "$.network_status")
    ip_family=$(echo "$output" | jsonfilter -e "$.ip_family")
    
    assertEquals "netup 4(netstatus/iface_id)  @output:${output}" "0" "$iface_id"
    assertEquals "netup 4(netstatus/ip_family) @output:${output}" "4" "$ip_family"
    if [ "$network_status" = "1" ]; then
      sleep 1
      break;
    fi
  done

  while true; do
    output=$(netconf);
    status=$?
    assertTrue "netup 10(netconf) @ret:${status} @output:${output}" "${status}"
    if echo "$output" | grep -q 'IPV4' > /dev/null ; then
      break;
    fi
  done
  assertContains "netup 4(netconf/IPV4) @output:${output}" "${output}" "IPV4"
  assertContains "netup 4(netconf/IPV6) @output:${output}" "${output}" "IPV6"

  local public_ip     public_ip6
  local sub_net_mask  sub_net_mask6
  local gw_addr       gw_addr6
  local pri_dns_addr  pri_dns_addr6
  local sec_dns_addr  sec_dns_addr6
  public_ip=$(echo "$output" | jsonfilter -e "$.IPV4.public_ip")
  sub_net_mask=$(echo "$output" | jsonfilter -e "$.IPV4.sub_net_mask")
  gw_addr=$(echo "$output" | jsonfilter -e "$.IPV4.gw_addr")
  pri_dns_addr=$(echo "$output" | jsonfilter -e "$.IPV4.pri_dns_addr")
  sec_dns_addr=$(echo "$output" | jsonfilter -e "$.IPV4.sec_dns_addr")
  public_ip6=$(echo "$output" | jsonfilter -e "$.IPV6.public_ip")
  sub_net_mask6=$(echo "$output" | jsonfilter -e "$.IPV6.sub_net_mask")
  gw_addr6=$(echo "$output" | jsonfilter -e "$.IPV6.gw_addr")
  pri_dns_addr6=$(echo "$output" | jsonfilter -e "$.IPV6.pri_dns_addr")
  sec_dns_addr6=$(echo "$output" | jsonfilter -e "$.IPV6.sec_dns_addr")
  
  assertNotEquals "netup 4(netconf/public_ip) @output:${output}" "0.0.0.0" "$public_ip"
  assertNotEquals "netup 4(netconf/sub_net_mask) @output:${output}" "0" "$sub_net_mask"
  assertNotEquals "netup 4(netconf/gw_addr) @output:${output}" "0.0.0.0" "$gw_addr"
  assertNotEquals "netup 4(netconf/pri_dns_addr) @output:${output}" "0.0.0.0" "$pri_dns_addr"
  assertNotEquals "netup 4(netconf/sec_dns_addr) @output:${output}" "0.0.0.0" "$sec_dns_addr"
  
  assertEquals "netup 4(netconf/public_ip6) @output:${output}" "::" "$public_ip6"
  assertEquals "netup 4(netconf/sub_net_mask6) @output:${output}" "0" "$sub_net_mask6"
  assertEquals "netup 4(netconf/gw_addr6) @output:${output}" "::" "$gw_addr6"
  assertEquals "netup 4(netconf/pri_dns_addr6) @output:${output}" "::" "$pri_dns_addr6"
  assertEquals "netup 4(netconf/sec_dns_addr6) @output:${output}" "::" "$sec_dns_addr6"

  sleep 3 # trigger event on 3s timer
  sleep 1 # assert uptime !=0

  . /lib/functions/network.sh
  network_flush_cache
  network_find_wan NET_IF
  assertEquals "netup 4(network_find_wan/NET_IF) @output:${NET_IF}" "$NET_IF" "wwan"
  
  network_get_device NET_L3D "${NET_IF}"
  assertEquals "netup 4(network_find_wan/NET_L3D) @output:${NET_L3D}" "$NET_L3D" "rmnet_data0"
  
  network_get_ipaddr NET_ADDR "${NET_IF}"
  network_get_ipaddr6 NET_ADDR6 "${NET_IF}"
  assertEquals "netup 4(network_find_wan/NET_ADDR) @output:${NET_ADDR}" "$NET_ADDR" "$public_ip"

  
  network_get_ipaddrs NET_ADDRS "${NET_IF}"
  network_get_ipaddrs6 NET_ADDRS6 "${NET_IF}"
  network_get_ipaddrs_all NET_ADDRS64 "${NET_IF}" 
  assertContains "netup 4(network_get_ipaddrs/NET_ADDRS)  @output:${NET_ADDRS}"  "${NET_ADDRS}" "$public_ip"
  assertContains "netup 4(network_get_ipaddrs_all/NET_ADDRS64) @output:${NET_ADDRS64}" "${NET_ADDRS64}" "$public_ip"

  network_get_subnet NET_MASK "${NET_IF}"
  assertContains "netup 4(network_get_subnet/NET_MASK)  @output:${NET_MASK}"  "${NET_MASK}" "$sub_net_mask"
  
  network_get_subnets NET_MASKS "${NET_IF}"
  assertContains "netup 4(network_get_subnets/NET_MASKS)  @output:${NET_MASKS}"  "${NET_MASKS}" "$sub_net_mask"

  network_get_gateway NET_GW "${NET_IF}"
  assertEquals "netup 4(network_get_gateway/NET_GW)  @output:${gw_addr}"  "${gw_addr}" "$NET_GW"

  network_get_dnsserver DNSSRV "${NET_IF}"
  assertContains "netup 4(network_get_dnsserver/DNSSRV)  @output:${DNSSRV}"  "${DNSSRV}" "$pri_dns_addr"
  assertContains "netup 4(network_get_dnsserver/DNSSRV) @output:${DNSSRV}"  "${DNSSRV}" "$sec_dns_addr"

  network_get_protocol PROTO "${NET_IF}"
  assertEquals "netup 4(network_get_protocol/PROTO) @output:${PROTO}"  "rmnet" "$PROTO"
  
  network_get_uptime UPTIME "${NET_IF}"
  assertNotEquals "netup 4(network_get_uptime/UPTIME) @output:${UPTIME}" "0" "$UPTIME"
  network_is_up "${NET_IF}"
  status=$?
  assertTrue "netup 4(netconf) @ret:${status}" "${status}"
  
  output=$(ping -4 www.mi.com -c 3)
  status=$?
  assertTrue "netup 4(ping4/mi) @ret:${status} @output:${output}" "${status}"
}

test_netup_v6() {
  local output result;
  
  output=$(netdown 4);
  status=$?
  assertTrue "netup 6(netdown) @ret:${status} @output:${output}" "${status}"
  assertContains "netup 6(netdown) @output:${output}" "${output}" "ok"
  result=$(echo "$output" | jsonfilter -e "$.result")
  assertEquals "netup 6(netdown) @output:${output}" "${result}" "ok"
  
  output=$(netup 6);
  status=$?
  assertTrue "netup 6(netup) @ret:${status} @output:${output}" "${status}"
  assertContains "netup 6(netup) @output:${output}" "${output}" "ok"
  result=$(echo "$output" | jsonfilter -e "$.result")
  assertEquals "netup 6(netdown) @output:${output}" "${result}" "ok"

  while true; do
    output=$(netstatus);
    status=$?
    assertTrue "netup 6(netstatus) @ret:${status} @output:${output}" "${status}"
    assertContains "netup 6(netstatus/iface_id) @output:${output}" "${output}" "iface_id"
    assertContains "netup 6(netstatus/network_status) @output:${output}" "${output}" "network_status"
    assertContains "netup 6(netstatus/ip_family) @output:${output}" "${output}" "ip_family"
    local iface_id network_status ip_family
    iface_id=$(echo "$output" | jsonfilter -e "$.iface_id")
    network_status=$(echo "$output" | jsonfilter -e "$.network_status")
    ip_family=$(echo "$output" | jsonfilter -e "$.ip_family")
    
    assertEquals "netup 6(netstatus/iface_id)  @output:${output}" "0" "$iface_id"
    assertEquals "netup 6(netstatus/ip_family) @output:${output}" "6" "$ip_family"
    if [ "$network_status" = "1" ]; then
      sleep 1
      break;
    fi
  done

  while true; do
    output=$(netconf);
    status=$?
    assertTrue "netup 10(netconf) @ret:${status} @output:${output}" "${status}"
    if echo "$output" | grep -q 'IPV6' > /dev/null ; then
      break;
    fi
  done
  assertContains "netup 6(netconf/IPV4) @output:${output}" "${output}" "IPV4"
  assertContains "netup 6(netconf/IPV6) @output:${output}" "${output}" "IPV6"

  local public_ip     public_ip6
  local sub_net_mask  sub_net_mask6
  local gw_addr       gw_addr6
  local pri_dns_addr  pri_dns_addr6
  local sec_dns_addr  sec_dns_addr6
  public_ip=$(echo "$output" | jsonfilter -e "$.IPV4.public_ip")
  sub_net_mask=$(echo "$output" | jsonfilter -e "$.IPV4.sub_net_mask")
  gw_addr=$(echo "$output" | jsonfilter -e "$.IPV4.gw_addr")
  pri_dns_addr=$(echo "$output" | jsonfilter -e "$.IPV4.pri_dns_addr")
  sec_dns_addr=$(echo "$output" | jsonfilter -e "$.IPV4.sec_dns_addr")
  public_ip6=$(echo "$output" | jsonfilter -e "$.IPV6.public_ip")
  sub_net_mask6=$(echo "$output" | jsonfilter -e "$.IPV6.sub_net_mask")
  gw_addr6=$(echo "$output" | jsonfilter -e "$.IPV6.gw_addr")
  pri_dns_addr6=$(echo "$output" | jsonfilter -e "$.IPV6.pri_dns_addr")
  sec_dns_addr6=$(echo "$output" | jsonfilter -e "$.IPV6.sec_dns_addr")
  
  assertEquals "netup 6(netconf/public_ip) @output:${output}" "0.0.0.0" "$public_ip"
  assertEquals "netup 6(netconf/sub_net_mask) @output:${output}" "0" "$sub_net_mask"
  assertEquals "netup 6(netconf/gw_addr) @output:${output}" "0.0.0.0" "$gw_addr"
  assertEquals "netup 6(netconf/pri_dns_addr) @output:${output}" "0.0.0.0" "$pri_dns_addr"
  assertEquals "netup 6(netconf/sec_dns_addr) @output:${output}" "0.0.0.0" "$sec_dns_addr"
  
  assertNotEquals "netup 6(netconf/public_ip6) @output:${output}" "::" "$public_ip6"
  assertNotEquals "netup 6(netconf/sub_net_mask6) @output:${output}" "0" "$sub_net_mask6"
  assertNotEquals "netup 6(netconf/gw_addr6) @output:${output}" "::" "$gw_addr6"
  assertNotEquals "netup 6(netconf/pri_dns_addr6) @output:${output}" "::" "$pri_dns_addr6"
  assertNotEquals "netup 6(netconf/sec_dns_addr6) @output:${output}" "::" "$sec_dns_addr6"

  sleep 3 # trigger event on 3s timer
  sleep 1 # assert uptime !=0

  . /lib/functions/network.sh
  network_flush_cache
  network_find_wan NET_IF
  assertEquals "netup 6(network_find_wan/NET_IF) @output:${NET_IF}" "$NET_IF" "wwan"
  
  network_get_device NET_L3D "${NET_IF}"
  assertEquals "netup 6(network_find_wan/NET_L3D) @output:${NET_L3D}" "$NET_L3D" "rmnet_data0"
  
  network_get_ipaddr NET_ADDR "${NET_IF}"
  network_get_ipaddr6 NET_ADDR6 "${NET_IF}"
  assertEquals "netup 6(network_find_wan/NET_ADDR6) @output:${NET_ADDR}" "$NET_ADDR6" "$public_ip6"
  
  network_get_ipaddrs NET_ADDRS "${NET_IF}"
  network_get_ipaddrs6 NET_ADDRS6 "${NET_IF}"
  network_get_ipaddrs_all NET_ADDRS64 "${NET_IF}" 
  assertContains "netup 6(network_get_ipaddrs6/NET_ADDRS6) @output:${NET_ADDRS6}"  "${NET_ADDRS6}" "$public_ip6"
  assertContains "netup 6(network_get_ipaddrs_all/NET_ADDRS64) @output:${NET_ADDRS64}" "${NET_ADDRS64}" "$public_ip6"

  network_get_subnet6 NET_MASK6 "${NET_IF}"
  assertContains "netup 6(network_get_subnet6/NET_MASK6) @output:${NET_MASK6}"  "${NET_MASK6}" "$sub_net_mask6"
  
  network_get_subnets6 NET_MASKS6 "${NET_IF}"
  assertContains "netup 6(network_get_subnets6/NET_MASKS6) @output:${NET_MASKS6}"  "${NET_MASKS6}" "$sub_net_mask6"
  
  network_get_gateway6 NET_GW6 "${NET_IF}"      
  # assertEquals "netup 6(netconf/NET_GW6) @output:${gw_addr6}"  "${gw_addr6}" "$NET_GW6"  why not equal??
  
  network_get_dnsserver DNSSRV "${NET_IF}"
  assertContains "netup 6(network_get_dnsserver/DNSSRV)  @output:${DNSSRV}"  "${DNSSRV}" "$pri_dns_addr6"
  assertContains "netup 6(network_get_dnsserver/DNSSRV) @output:${DNSSRV}"  "${DNSSRV}" "$sec_dns_addr6"

  network_get_protocol PROTO "${NET_IF}"
  assertEquals "netup 6(network_get_protocol/PROTO) @output:${PROTO}"  "rmnet" "$PROTO"
  
  network_get_uptime UPTIME "${NET_IF}"
  assertNotEquals "netup 6(network_get_uptime/UPTIME) @output:${UPTIME}" "0" "$UPTIME"
  network_is_up "${NET_IF}"
  status=$?
  assertTrue "netup 6(netconf) @ret:${status}" "${status}"
  
  output=$(ping -6 www.mi.com -c 3)
  status=$?
  assertTrue "netup 6(ping6/mi) @ret:${status} @output:${output}" "${status}"
}

test_apn_3gpp_custom_7() {
  output="$(get_default_apn)"      # reserved default apn
  status=$?
  assertTrue "get_default_apn @ret:${status} @output:${output}" "${status}"
  default_apn=$(echo "$output" | jsonfilter -e "$.default_apn")

  while read -r profile_id ip_family user_id apn_name auth_type auth_password; do
    output="$(set_apn_3gpp "${profile_id}" "${ip_family}" "${user_id}" "${apn_name}" "${auth_type}" "${auth_password}")"
    status=$?
    assertTrue "set_apn_3gpp @ret:${status} @output:${output}" "${status}"
    assertContains "set_apn_3gpp @output:${output}" "${output}" "ok"

    output="$(get_apn_info)"
    assertTrue "get_apn_info @ret:${status} @output:${output}" "${status}"
    assertContains "get_apn_info @output:${output}" "${output}" "${user_id}"
    assertContains "get_apn_info @output:${output}" "${output}" "${apn_name}"
  done <<EOF
7 4    user_3gpp_custom_id74    apn_3gpp_custom_name74    0 auth_3gpp_custom_password74
7 4    user_3gpp_custom_id74    apn_3gpp_custom_name74    1 auth_3gpp_custom_password74
7 6    user_3gpp_custom_id76    apn_3gpp_custom_name76    1 auth_3gpp_custom_password76
7 6    user_3gpp_custom_id76    apn_3gpp_custom_name76    0 auth_3gpp_custom_password76
7 10   user_3gpp_custom_id710   apn_3gpp_custom_name710   1 auth_3gpp_custom_password710
7 10   user_3gpp_custom_id710   apn_3gpp_custom_name710   0 auth_3gpp_custom_password710
EOF

  # restore default apn
  output="$(set_default_apn "${default_apn}")"
  status=$?
  echo "set_default_apn ${default_apn}"
  assertTrue "set_default_apn @ret:${status} @output:${output}" "${status}"
}

_test_apn_3gpp_reserved_1to6() {

  # reserved default apn
  output="$(get_default_apn)"
  status=$?
  assertTrue "get_default_apn @ret:${status} @output:${output}" "${status}"
  default_apn=$(echo "${output}" | awk '/default/{print $2}' | tr -d ',"')

  while read -r profile_id ip_family user_id apn_name auth_type auth_password; do
    output="$(set_apn_3gpp "${profile_id}" "${ip_family}" "${user_id}" "${apn_name}" "${auth_type}" "${auth_password}")"
    status=$?
    assertTrue "set_apn_3gpp @ret:${status} @output:${output}" "${status}"
    assertContains "set_apn_3gpp @output:${output}" "${output}" "ok"

    output="$(get_apn_info)"
    assertTrue "get_apn_info @ret:${status} @output:${output}" "${status}"
    assertContains "get_apn_info @output:${output}" "${output}" "${user_id}"
    assertContains "get_apn_info @output:${output}" "${output}" "${apn_name}"
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
  output="$(set_default_apn "${default_apn}")"
  status=$?
  assertTrue "get_default_apn @ret:${status} @output:${output}" "${status}"
}

_test_del_apn() {

  # danger test
  startSkipping
  while read -r profile_id ip_family user_id apn_name auth_type auth_password; do
    output="$(set_apn_3gpp "${profile_id}" "${ip_family}" "${user_id}" "${apn_name}" "${auth_type}" "${auth_password}")"
    status=$?
    assertTrue "set_apn_3gpp @ret:${status} @output:${output}" "${status}"
    assertContains "set_apn_3gpp @output:${output}" "${output}" "ok"

    output="$(get_apn_info)"
    assertTrue "get_apn_info @ret:${status} @output:${output}" "${status}"
    assertContains "get_apn_info @output:${output}" "${output}" "${user_id}"
    assertContains "get_apn_info @output:${output}" "${output}" "${apn_name}"

    output="$(del_apn_profile_id "${profile_id}")"
    status=$?
    assertTrue "del_apn_profile_id ${profile_id} @ret:${status} @output:${output}" "${status}"
    assertContains "del_apn_profile_id ${profile_id} @output:${output}" "${output}" "ok"

    output="$(get_apn_info)"
    assertTrue "get_apn_info @ret:${status} @output:${output}" "${status}"
    assertNotContains "get_apn_info @output:${output}" "${output}" "${user_id}"
    assertNotContains "get_apn_info @output:${output}" "${output}" "${apn_name}"

    output="$(del_apn_profile_id "${profile_id}")"
    status=$?
    assertTrue "del_apn_profile_id ${profile_id} @ret:${status} @output:${output}" "${status}"
    assertContains "del_apn_profile_id ${profile_id} @output:${output}" "${output}" "error"
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
    output="$(set_apn_3gpp2 "${profile_id}" "${ip_family}" "${user_id}" "${apn_name}" "${auth_type}" "${auth_password}")"
    status=$?
    assertTrue "set_apn_3gpp2 @ret:${status} @output:${output}" "${status}"
    assertContains "set_apn_3gpp2 @output:${output}" "${output}" "ok"

    output="$(get_apn_info)"
    assertTrue "get_apn_info @ret:${status} @output:${output}" "${status}"
    assertContains "get_apn_info @output:${output}" "${output}" "${user_id}"
    assertContains "get_apn_info @output:${output}" "${output}" "${apn_name}"

    output="$(del_apn_profile_id "${profile_id}")"
    status=$?
    assertTrue "del_apn_profile_id ${profile_id} @ret:${status} @output:${output}" "${status}"
    assertContains "del_apn_profile_id ${profile_id} @output:${output}" "${output}" "error"

    output="$(get_apn_info)"
    status=$?
    assertTrue "get_apn_info @ret:${status} @output:${output}" "${status}"
    assertContains "get_apn_info @output:${output}" "${output}" "${user_id}"
    assertContains "get_apn_info @output:${output}" "${output}" "${apn_name}"

    output="$(del_apn_profile_id "${profile_id}")"
    status=$?
    assertTrue "del_apn_profile_id ${profile_id} @ret:${status} @output:${output}" "${status}"
    assertContains "del_apn_profile_id ${profile_id} @output:${output}" "${output}" "error"
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
    output="$(set_apn_3gpp "${profile_id}" "${ip_family}" "${user_id}" "${apn_name}" "${auth_type}" "${auth_password}")"
    status=$?
    assertTrue "set_apn_3gpp @ret:${status} @output:${output}" "${status}"
    assertContains "set_apn_3gpp @output:${output}" "${output}" "ok"

    output="$(del_apn_profile_id "${profile_id}")"
    status=$?
    assertTrue "del_apn_profile_id ${profile_id} @ret:${status} @output:${output}" "${status}"
  done <<EOF
5 4    user_del_id54    apn_del_name54    0 auth_del_password54 
6 4    user_del_id64    apn_del_name64    0 auth_del_password64 
EOF
  endSkipping
}

. shunit2