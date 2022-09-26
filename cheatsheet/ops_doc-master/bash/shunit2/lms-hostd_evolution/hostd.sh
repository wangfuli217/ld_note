#!/bin/bash
### ShellCheck (http://www.shellcheck.net/)
#  Not following: ./test_helper was not specified as input (see shellcheck -x)
#   shellcheck disable=SC1091
# Double quote to prevent globbing and word splitting
#   shellcheck disable=SC2086


oneTimeSetUp() {
  . "./test_helper"
  status=""
  output=""
  if [ -n "${HOSTD_DEBUG}" ]; then
    RTUCLIENT="hostd -q -d 1 -H ${RTU_HOST} -p ${RTU_PORT}"
  else
    RTUCLIENT="hostd -q -H ${RTU_HOST} -p ${RTU_PORT}"
  fi

  if [ -z "${ILM_INFO15}" ]; then
    ILM_INFO15="3 4 5 3 4 5"
  fi
  if [ -z "${ILM_INFO26}" ]; then
    ILM_INFO26="3 4 5 3 4 5 6"
  fi
  if [ -z "${ILM_INFO37}" ]; then
    ILM_INFO37="3 4 5 3 4 5 1 5"
  fi
  if [ -z "${ILM_INFO48}" ]; then
    ILM_INFO48="3 4 5 3 4 5 1 3 5"
  fi

  if [ -z "${ILM_RES16}" ]; then
    ILM_RES16="4.220 5.230 6.120 4.220 5.230 6.120"
  fi
  if [ -z "${ILM_RES27}" ]; then
    ILM_RES27="4.220 5.230 6.120 4.220 5.230 6.120 7.120"
  fi
  if [ -z "${ILM_RES38}" ]; then
    ILM_RES38="4.220 5.230 6.120 4.220 5.230 6.120 7.120 7.120"
  fi
  if [ -z "${ILM_RES49}" ]; then
    ILM_RES49="4.220 5.230 6.120 4.220 5.230 6.120 7.120 7.120 7.120"
  fi

}

oneTimeTearDown() {
  :
}

setUp() {
  :
}

tearDown() {
  :
}

: <<EOF
#comment
EOF

# require shunit2 version >= 2.1.7pre
# assertEquals [message] expected actual
# assertNotNull [message] value
# require shunit2 version >= 2.1.8pre
# assertContains [message] container content
# assertNotContains [message] container content

####  hostd test for self     ####
test_hostd_version() {
  output="$($RTUCLIENT -v 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT -v @ret:${status} @output:${output}" 0 "${status}"
  assertTrue "$RTUCLIENT -v @ret:${status} @output:${output}" "${status}"
  assertContains "$RTUCLIENT -v @output:${output}" "${output}" "xianleidi"
}

test_hostd_config() {
  output="$($RTUCLIENT config 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT config @ret:${status} @output:${output}" 0 "${status}"
  assertTrue "$RTUCLIENT config @ret:${status} @output:${output}" "${status}"
  assertContains "$RTUCLIENT config @output:${output}" "${output}" "QT(client)"
}

test_hostd_script() {
  echo "serial" >script
  output="$($RTUCLIENT -f script 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT -f script @ret:${status} @output:${output}" 0 "${status}"
  assertTrue "$RTUCLIENT -f script @ret:${status} @output:${output}" "${status}"
  assertContains "$RTUCLIENT -f script @output:${output}" "${output}" "serial"
  rm script
}

test_hostd_conn_info() {
  output="$($RTUCLIENT conn-info 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT conn-info @ret:${status} @output:${output}" 0 "${status}"
  assertTrue "$RTUCLIENT conn-info @ret:${status} @output:${output}" "${status}"
  assertContains "$RTUCLIENT conn-info @output:${output}" "${output}" "info"
}

test_hostd_debug() {
  output="$($RTUCLIENT debug 0 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT debug 0 @ret:${status} @output:${output}" 0 "${status}"
  assertTrue "$RTUCLIENT debug 0 @ret:${status} @output:${output}" "${status}"
  assertContains "$RTUCLIENT debug 0 @output:${output}" "${output}" "disable"

  output="$($RTUCLIENT debug 1 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT debug 1 @ret:${status} @output:${output}" 0 "${status}"
  assertTrue "$RTUCLIENT debug 1 @ret:${status} @output:${output}" "${status}"
  assertContains "$RTUCLIENT debug 1 @output:${output}" "${output}" "enable"
}

test_hostd_timeout() {
  output="$($RTUCLIENT test-timeout 1000 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT test-timeout 1000 @ret:${status} @output:${output}" 0 "${status}"
  assertTrue "$RTUCLIENT test-timeout 1000 @ret:${status} @output:${output}" "${status}"
  assertContains "$RTUCLIENT test-timeout 1000 @output:${output}" "${output}" "1000"

  output="$($RTUCLIENT test-timeout 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT test-timeout @ret:${status} @output:${output}" 0 "${status}"
  assertTrue "$RTUCLIENT test-timeout @ret:${status} @output:${output}" "${status}"
}

test_hostd_cfg_default() {
  output="$($RTUCLIENT cfg-default 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT cfg-default @ret:${status} @output:${output}" 0 "${status}"
  assertTrue "$RTUCLIENT cfg-default @ret:${status} @output:${output}" "${status}"
  assertContains "$RTUCLIENT cfg-default @output:${output}" "${output}" "default value"
}

test_hostd_command() {
  while read -r want argument; do
    output="$($RTUCLIENT command ${argument} 2>&1)"
    status=$?
    assertTrue "$RTUCLIENT $argument @ret:${status} @output:${output}" "${status}"
    assertContains "$RTUCLIENT $argument @output:${output}" "${output}" "${want}"
  done <<'EOF'
PROTO_HOST_ERR_FLAG             error
PROTO_HOST_ILM_STATION_INFO_SET ilm-info-set
PROTO_HOST_ILM_STATION_INFO_GET ilm-info-get
PROTO_HOST_ILM_INSULATE_TEST    ilm-test
PROTO_HOST_ILM_INSULATE_RES_SET ilm-result-set
PROTO_HOST_ILM_INSULATE_RES_GET ilm-result-get
PROTO_HOST_ILM_CONFIG_GET       ilm-config-get
PROTO_HOST_ILM_INSULATE_STATUS  ilm-status-get
PROTO_HOST_SLOT_SERIAL_VERSION  serial
PROTO_HOST_SLOT_LEDS_STATUS     leds
PROTO_HOST_MCU_REBOOT           mcu-reboot
PROTO_HOST_MCU_DATETIME_SET     mcu-date-set
PROTO_HOST_MCU_ADDRESS_SET      mcu-addr-set
PROTO_HOST_MCU_SOFRWARE_UPGRADE mcu-upgrade
PROTO_HOST_MCU_SOFRWARE_VERSION mcu-version
PROTO_HOST_SLOT_SETSERIAL       setserial
PROTO_HOST_MCU_HOST_ADDR        mcu-host-addr
PROTO_HOST_TPWU_250V_SET        tpwu-250v-set
PROTO_HOST_TPWU_250V_STATUS     tpwu-250v-status
PROTO_HOST_GDM_RSST_TEST        gdm-test
PROTO_HOST_GDM_RSST_REVISON_SET gdm-revison-set
PROTO_HOST_GDM_RSST_REVISON_GET gdm-revison-get
PROTO_HOST_LMS_ACIVTE           lms-active
PROTO_HOST_ILM_TEST_LOG_GET     ilm-test-log
PROTO_HOST_GDM_TEST_LOG_GET     gdm-test-log
PROTO_HOST_BELL_SET             bell-set
PROTO_HOST_BELL_GET             bell-get
PROTO_HOST_BELL_ENABLE          bell-enable
PROTO_HOST_BELL_DISABLE         bell-disable
PROTO_HOST_FAN_SET              fan-set
PROTO_HOST_FAN_GET              fan-get
EOF
}

test_hostd_self_table() {
  echo "serial" >script
  while read -r want argument; do
    output="$($RTUCLIENT ${argument} 2>&1)"
    status=$?
    assertTrue "$RTUCLIENT $argument @ret:${status} @output:${output}" "${status}"
    assertContains "$RTUCLIENT $argument @output:${output}" "${output}" "${want}"
  done <<'EOF'
xianleidi  -v
xianleidi  config
info       conn-info
enable     debug 1
disable    debug 0
1000       test-timeout 1000
value      cfg-default
EOF
  rm script
}

#### hostd test for protocol ####
######## protocol [MCU]     ########
test_hostd_serial() {
  output="$($RTUCLIENT serial 2>&1)"
  status=$?
  assertTrue "$RTUCLIENT serial @ret:${status} @output:${output}" "${status}"
  assertContains "$RTUCLIENT serial @output:${output}" "${output}" "serial"
}

test_hostd_leds() {
  output="$($RTUCLIENT leds 2>&1)"
  status=$?
  assertTrue "$RTUCLIENT leds @ret:${status} @output:${output}" "${status}"
  assertContains "$RTUCLIENT leds @output:${output}" "${output}" "leds"
}

test_hostd_MCU_version() {
  output="$($RTUCLIENT mcu-version 2>&1)"
  status=$?
  assertTrue "$RTUCLIENT mcu-version @ret:${status} @output:${output}" "${status}"
  assertContains "$RTUCLIENT mcu-version @output:${output}" "${output}" "mcu-version"
}

test_hostd_MCU_date_set() {
  output="$($RTUCLIENT mcu-date-set 2>&1)"
  status=$?
  assertTrue "$RTUCLIENT mcu-date-set @ret:${status} @output:${output}" "${status}"
  assertContains "$RTUCLIENT mcu-date-set @output:${output}" "${output}" "mcu-date-set"

  output="$($RTUCLIENT mcu-date-set 2020:01:10-17:22:33-5 2>&1)"
  status=$?
  assertTrue "$RTUCLIENT mcu-date-set 2020:01:10-17:22:33-5 @ret:${status} @output:${output}" "${status}"
  assertContains "$RTUCLIENT mcu-date-set 2020:01:10-17:22:33-5 @output:${output}" "${output}" "mcu-date-set"
}

test_hostd_MCU_addr_set() {
  #                                 ip-address    network-nask gateway
  output="$($RTUCLIENT mcu-addr-set 192.168.27.171 255.255.0.0 192.168.27.1 2>&1)"
  status=$?
  assertTrue "$RTUCLIENT mcu-addr-set 192.168.27.171 255.255.0.0 192.168.27.1 @ret:${status} @output:${output}" "${status}"
  assertContains "$RTUCLIENT mcu-addr-set 192.168.27.171 255.255.0.0 192.168.27.1 @output:${output}" "${output}" "mcu-addr-set"
}

test_hostd_MCU_bell() {
  output="$($RTUCLIENT bell-set 1 2>&1)"
  status=$?
  assertTrue "$RTUCLIENT bell-set 1 @ret:${status} @output:${output}" "${status}"
  assertContains "$RTUCLIENT bell-set 1 @output:${output}" "${output}" "bell-set"

  output="$($RTUCLIENT bell-get 2>&1)"
  status=$?
  assertTrue "$RTUCLIENT bell-get @ret:${status} @output:${output}" "${status}"
  assertContains "$RTUCLIENT bell-get @output:${output}" "${output}" "enable"

  output="$($RTUCLIENT bell-set 0 2>&1)"
  status=$?
  assertTrue "$RTUCLIENT bell-set 0 @ret:${status} @output:${output}" "${status}"
  assertContains "$RTUCLIENT bell-set 0 @output:${output}" "${output}" "bell-set"

  output="$($RTUCLIENT bell-get 2>&1)"
  status=$?
  assertTrue "$RTUCLIENT bell-get @ret:${status} @output:${output}" "${status}"
  assertContains "$RTUCLIENT bell-get @output:${output}" "${output}" "disable"

  output="$($RTUCLIENT bell-enable 2>&1)"
  status=$?
  assertTrue "$RTUCLIENT bell-enable @ret:${status} @output:${output}" "${status}"
  assertContains "$RTUCLIENT bell-enable @output:${output}" "${output}" "bell-enable"

  output="$($RTUCLIENT bell-disable 2>&1)"
  status=$?
  assertTrue "$RTUCLIENT bell-disable @ret:${status} @output:${output}" "${status}"
  assertContains "$RTUCLIENT bell-disable @output:${output}" "${output}" "bell-disable"
}

test_hostd_MCU_fan() {
  output="$($RTUCLIENT fan-set 45 50 2>&1)"
  status=$?
  assertTrue "$RTUCLIENT fan-set 45 50 @ret:${status} @output:${output}" "${status}"
  assertContains "$RTUCLIENT fan-set 45 50 @output:${output}" "${output}" "fan-set"

  output="$($RTUCLIENT fan-get 2>&1)"
  status=$?
  assertTrue "$RTUCLIENT fan-get @ret:${status} @output:${output}" "${status}"
  assertContains "$RTUCLIENT fan-get @output:${output}" "${output}" "fan-get"
}

# data-driven-test
test_hostd_MCU_table() {
  while read -r want argument; do
    output="$($RTUCLIENT ${argument} 2>&1)"
    status=$?
    assertTrue "$RTUCLIENT $argument @ret:${status} @output:${output}" "${status}"
    assertContains "$RTUCLIENT $argument @output:${output}" "${output}" "${want}"
  done <<'EOF'
serial          serial
leds            leds
mcu-version     mcu-version
mcu-date-set    mcu-date-set
mcu-date-set    mcu-date-set 2020:01:10-17:22:33-5
mcu-addr-set    mcu-addr-set 192.168.27.171 255.255.0.0 192.168.27.1
bell-set        bell-set 1
enable          bell-get
bell-set        bell-set 0
disable         bell-get
bell-enable     bell-enable
bell-disable    bell-disable
fan-set         fan-set 45 50
fan-get         fan-get
EOF
}

######## protocol [ILM]     ########
#### ilm-info-set slot direct count distances ...
test_ILM_station_info_set_slot_valid() {
  [ -z "${ILM_SLOT:-}" ] && startSkipping
  #                                 slot     direct count distances
  #   shellcheck disable=SC2086
  output="$($RTUCLIENT ilm-info-set "${ILM_SLOT}" 1 5 ${ILM_INFO15} 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-info-set $ILM_SLOT 1 5 ${ILM_INFO15} @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-info-set $ILM_SLOT 1 5 ${ILM_INFO15} @output:${output}" "${output}" "ilm-info-set"

  # direct 2
  #   shellcheck disable=SC2086
  output="$($RTUCLIENT ilm-info-set "${ILM_SLOT}" 2 6 ${ILM_INFO26} 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-info-set $ILM_SLOT 2 6 ${ILM_INFO26} @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-info-set $ILM_SLOT 2 6 ${ILM_INFO26} @output:${output}" "${output}" "ilm-info-set"

  # direct 3
  #   shellcheck disable=SC2086
  output="$($RTUCLIENT ilm-info-set "${ILM_SLOT}" 3 7 ${ILM_INFO37} 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-info-set $ILM_SLOT 3 7 ${ILM_INFO37} @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-info-set $ILM_SLOT 3 7 ${ILM_INFO37} @output:${output}" "${output}" "ilm-info-set"

  # direct 4
  #   shellcheck disable=SC2086
  output="$($RTUCLIENT ilm-info-set "${ILM_SLOT}" 4 8 ${ILM_INFO48} 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-info-set $ILM_SLOT 4 8 ${ILM_INFO48} @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-info-set $ILM_SLOT 4 8 ${ILM_INFO48} @output:${output}" "${output}" "ilm-info-set"
}

# table driven test
test_ILM_station_info_set_slot_valid_table() {
  [ -z "${ILM_SLOT:-}" ] && startSkipping

  while read -r direct stations station_array; do
    output="$($RTUCLIENT ilm-info-set "${ILM_SLOT}" "${direct}" "${stations}" ${station_array} 2>&1)"
    status=$?
    assertTrue "$RTUCLIENT ilm-info-set $ILM_SLOT ${direct} ${stations} ${station_array} @ret:${status} @output:${output}" "${status}"
    # or
    assertEquals "$RTUCLIENT ilm-info-set $ILM_SLOT ${direct} ${stations} ${station_array} @ret:${status} @output:${output}" 0 "${status}"
    assertContains "$RTUCLIENT ilm-info-set $ILM_SLOT ${direct} ${stations} ${station_array} @output:${output}" "${output}" "ilm-info-set"
  done <<EOF
1  5  ${ILM_INFO15}
2  6  ${ILM_INFO26}
3  7  ${ILM_INFO37}
4  8  ${ILM_INFO48}
EOF
}

test_ILM_E_station_info_set_slot_valid() {
  [ -z "${ILM_E_SLOT:-}" ] && startSkipping
  #                                 slot     direct count distances
  #   shellcheck disable=SC2086
  output="$($RTUCLIENT ilm-info-set "${ILM_E_SLOT}" 5 5 ${ILM_INFO15} 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-info-set $ILM_E_SLOT 5 5 ${ILM_INFO15} @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-info-set $ILM_E_SLOT 5 5 ${ILM_INFO15} @output:${output}" "${output}" "ilm-info-set"

  # direct 6
  #   shellcheck disable=SC2086
  output="$($RTUCLIENT ilm-info-set "${ILM_E_SLOT}" 6 6 ${ILM_INFO26} 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-info-set $ILM_E_SLOT 6 6 ${ILM_INFO26} @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-info-set $ILM_E_SLOT 6 6 ${ILM_INFO26} @output:${output}" "${output}" "ilm-info-set"

  # direct 7
  #   shellcheck disable=SC2086
  output="$($RTUCLIENT ilm-info-set "${ILM_E_SLOT}" 7 7 ${ILM_INFO37} 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-info-set $ILM_E_SLOT 7 7 ${ILM_INFO37} @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-info-set $ILM_E_SLOT 7 7 ${ILM_INFO37} @output:${output}" "${output}" "ilm-info-set"

  # direct 8
  #   shellcheck disable=SC2086
  output="$($RTUCLIENT ilm-info-set "${ILM_E_SLOT}" 8 8 ${ILM_INFO48} 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-info-set $ILM_E_SLOT 8 8 ${ILM_INFO48} @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-info-set $ILM_E_SLOT 8 8 ${ILM_INFO48} @output:${output}" "${output}" "ilm-info-set"
}

test_ILM_E_station_info_set_slot_valid_table() {
  [ -z "${ILM_E_SLOT:-}" ] && startSkipping
  while read -r direct stations station_array; do
    output="$($RTUCLIENT ilm-info-set "${ILM_E_SLOT}" "${direct}" "${stations}" ${station_array} 2>&1)"
    status=$?
    assertTrue "$RTUCLIENT ilm-info-set $ILM_E_SLOT ${direct} ${stations} ${station_array} @ret:${status} @output:${output}" "${status}"
    # or
    assertEquals "$RTUCLIENT ilm-info-set $ILM_E_SLOT ${direct} ${stations} ${station_array} @ret:${status} @output:${output}" 0 "${status}"
    assertContains "$RTUCLIENT ilm-info-set $ILM_E_SLOT ${direct} ${stations} ${station_array} @output:${output}" "${output}" "ilm-info-set"
  done <<EOF
5  5  ${ILM_INFO15}
6  6  ${ILM_INFO26}
7  7  ${ILM_INFO37}
8  8  ${ILM_INFO48}
EOF
}

test_ILM_station_info_set_slot_255() {
  [ -z "${ILM_SLOT:-}" ] && startSkipping
  #                                 slot     direct count distances
  #   shellcheck disable=SC2086
  output="$($RTUCLIENT ilm-info-set 255 1 5 ${ILM_INFO15} 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-info-set 255 1 5 ${ILM_INFO15} @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-info-set 255 1 5 ${ILM_INFO15} @output:${output}" "${output}" "ilm-info-set"

  # direct 2
  #   shellcheck disable=SC2086
  output="$($RTUCLIENT ilm-info-set 255 2 6 ${ILM_INFO26} 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-info-set 255 2 6 ${ILM_INFO26} @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-info-set 255 2 6 ${ILM_INFO26} @output:${output}" "${output}" "ilm-info-set"

  # direct 3
  #   shellcheck disable=SC2086
  output="$($RTUCLIENT ilm-info-set 255 3 7 ${ILM_INFO37} 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-info-set 255 3 7 ${ILM_INFO37} @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-info-set 255 3 7 ${ILM_INFO37} @output:${output}" "${output}" "ilm-info-set"

  # direct 4
  #   shellcheck disable=SC2086
  output="$($RTUCLIENT ilm-info-set 255 4 8 ${ILM_INFO48} 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-info-set 255 4 8 ${ILM_INFO48} @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-info-set 255 4 8 ${ILM_INFO48} @output:${output}" "${output}" "ilm-info-set"
}

# table driven test
test_ILM_station_info_set_slot_255_table() {
  [ -z "${ILM_SLOT:-}" ] && startSkipping

  while read -r direct stations station_array; do
    output="$($RTUCLIENT ilm-info-set 255 "${direct}" "${stations}" ${station_array} 2>&1)"
    status=$?
    assertTrue "$RTUCLIENT ilm-info-set 255 ${direct} ${stations} ${station_array} @ret:${status} @output:${output}" "${status}"
    # or
    assertEquals "$RTUCLIENT ilm-info-set 255 ${direct} ${stations} ${station_array} @ret:${status} @output:${output}" 0 "${status}"
    assertContains "$RTUCLIENT ilm-info-set 255 ${direct} ${stations} ${station_array} @output:${output}" "${output}" "ilm-info-set"
  done <<EOF
1  5  ${ILM_INFO15}
2  6  ${ILM_INFO26}
3  7  ${ILM_INFO37}
4  8  ${ILM_INFO48}
EOF
}

test_ILM_E_station_info_set_slot_255() {
  [ -z "${ILM_E_SLOT:-}" ] && startSkipping
  #                                 slot     direct count distances
  #   shellcheck disable=SC2086
  output="$($RTUCLIENT ilm-info-set 255 5 5 ${ILM_INFO15} 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-info-set 255 5 5 ${ILM_INFO15} @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-info-set 255 5 5 ${ILM_INFO15} @output:${output}" "${output}" "ilm-info-set"

  # direct 6
  #   shellcheck disable=SC2086
  output="$($RTUCLIENT ilm-info-set 255 6 6 ${ILM_INFO26} 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-info-set 255 6 6 ${ILM_INFO26} @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-info-set 255 6 6 ${ILM_INFO26} @output:${output}" "${output}" "ilm-info-set"

  # direct 7
  #   shellcheck disable=SC2086
  output="$($RTUCLIENT ilm-info-set 255 7 7 ${ILM_INFO37} 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-info-set 255 7 7 ${ILM_INFO37} @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-info-set 255 7 7 ${ILM_INFO37} @output:${output}" "${output}" "ilm-info-set"

  # direct 8
  #   shellcheck disable=SC2086
  output="$($RTUCLIENT ilm-info-set 255 8 8 ${ILM_INFO48} 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-info-set 255 8 8 ${ILM_INFO48} @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-info-set 255 8 8 ${ILM_INFO48} @output:${output}" "${output}" "ilm-info-set"
}

test_ILM_E_station_info_set_slot_255_table() {
  [ -z "${ILM_E_SLOT:-}" ] && startSkipping
  while read -r direct stations station_array; do
    output="$($RTUCLIENT ilm-info-set 255 "${direct}" "${stations}" ${station_array} 2>&1)"
    status=$?
    assertTrue "$RTUCLIENT ilm-info-set 255 ${direct} ${stations} ${station_array} @ret:${status} @output:${output}" "${status}"
    # or
    assertEquals "$RTUCLIENT ilm-info-set 255 ${direct} ${stations} ${station_array} @ret:${status} @output:${output}" 0 "${status}"
    assertContains "$RTUCLIENT ilm-info-set 255 ${direct} ${stations} ${station_array} @output:${output}" "${output}" "ilm-info-set"
  done <<EOF
5  5  ${ILM_INFO15}
6  6  ${ILM_INFO26}
7  7  ${ILM_INFO37}
8  8  ${ILM_INFO48}
EOF
}

test_ILM_station_info_set_slot_invalid() {
  [ -z "${ILM_SLOT:-}" ] && startSkipping
  # direct 1
  local slot=$((ILM_SLOT + 1))
  output="$($RTUCLIENT ilm-info-set ${slot} 1 5 3 4 5 3 4 5 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-info-set ${slot} 1 5 3 4 5 3 4 5 @ret:${status} @output:${output}" 255 "${status}"
  assertContains "$RTUCLIENT ilm-info-set ${slot} 1 5 3 4 5 3 4 5 @output:${output}" "${output}" "slot"
  assertContains "$RTUCLIENT ilm-info-set ${slot} 1 5 3 4 5 3 4 5 @output:${output}" "${output}" "error"
}

test_ILM_E_station_info_set_slot_invalid() {
  [ -z "${ILM_E_SLOT:-}" ] && startSkipping
  # direct 5
  local slot=$((ILM_E_SLOT + 1))
  output="$($RTUCLIENT ilm-info-set ${slot} 5 5 3 4 5 3 4 5 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-info-set ${slot} 5 5 3 4 5 3 4 5 @ret:${status} @output:${output}" 255 "${status}"
  assertContains "$RTUCLIENT ilm-info-set ${slot} 5 5 3 4 5 3 4 5 @output:${output}" "${output}" "slot"
  assertContains "$RTUCLIENT ilm-info-set ${slot} 5 5 3 4 5 3 4 5 @output:${output}" "${output}" "error"
}

test_ILM_station_info_set_slot_greater() {
  [ -z "${ILM_SLOT:-}" ] && startSkipping
  local slot=254
  output="$($RTUCLIENT ilm-info-set ${slot} 1 5 3 4 5 3 4 5 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-info-set ${slot} 1 5 3 4 5 3 4 5 @ret:${status} @output:${output}" 255 "${status}"
  assertContains "$RTUCLIENT ilm-info-set ${slot} 1 5 3 4 5 3 4 5 @output:${output}" "${output}" "slot"
  assertContains "$RTUCLIENT ilm-info-set ${slot} 1 5 3 4 5 3 4 5 @output:${output}" "${output}" "error"
}

test_ILM_E_station_info_set_slot_greater() {
  [ -z "${ILM_E_SLOT:-}" ] && startSkipping
  local slot=254
  output="$($RTUCLIENT ilm-info-set ${slot} 1 5 3 4 5 3 4 5 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-info-set ${slot} 1 5 3 4 5 3 4 5 @ret:${status} @output:${output}" 255 "${status}"
  assertContains "$RTUCLIENT ilm-info-set ${slot} 1 5 3 4 5 3 4 5 @output:${output}" "${output}" "slot"
  assertContains "$RTUCLIENT ilm-info-set ${slot} 1 5 3 4 5 3 4 5 @output:${output}" "${output}" "error"
}

test_ILM_station_info_set_direct_zero() {
  [ -z "${ILM_SLOT:-}" ] && startSkipping
  output="$($RTUCLIENT ilm-info-set "${ILM_SLOT}" 0 5 3 4 5 3 4 5 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-info-set ${ILM_SLOT} 0 5 3 4 5 3 4 5 @ret:${status} @output:${output}" 255 "${status}"
  assertContains "$RTUCLIENT ilm-info-set ${ILM_SLOT} 0 5 3 4 5 3 4 5 @output:${output}" "${output}" "port"
  assertContains "$RTUCLIENT ilm-info-set ${ILM_SLOT} 0 5 3 4 5 3 4 5 @output:${output}" "${output}" "error"
}

test_ILM_E_station_info_set_direct_zero() {
  [ -z "${ILM_E_SLOT:-}" ] && startSkipping
  output="$($RTUCLIENT ilm-info-set "${ILM_E_SLOT}" 0 5 3 4 5 3 4 5 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-info-set ${ILM_E_SLOT} 0 5 3 4 5 3 4 5 @ret:${status} @output:${output}" 255 "${status}"
  assertContains "$RTUCLIENT ilm-info-set ${ILM_E_SLOT} 0 5 3 4 5 3 4 5 @output:${output}" "${output}" "port"
  assertContains "$RTUCLIENT ilm-info-set ${ILM_E_SLOT} 0 5 3 4 5 3 4 5 @output:${output}" "${output}" "error"
}

test_ILM_station_info_set_direct_greater() {
  [ -z "${ILM_SLOT:-}" ] && startSkipping
  output="$($RTUCLIENT ilm-info-set "${ILM_SLOT}" 9 5 3 4 5 3 4 5 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-info-set ${ILM_SLOT} 9 5 3 4 5 3 4 5 @ret:${status} @output:${output}" 255 "${status}"
  assertContains "$RTUCLIENT ilm-info-set ${ILM_SLOT} 9 5 3 4 5 3 4 5 @output:${output}" "${output}" "port"
  assertContains "$RTUCLIENT ilm-info-set ${ILM_SLOT} 9 5 3 4 5 3 4 5 @output:${output}" "${output}" "error"
}

test_ILM_E_station_info_set_direct_greater() {
  [ -z "${ILM_E_SLOT:-}" ] && startSkipping
  output="$($RTUCLIENT ilm-info-set "${ILM_E_SLOT}" 9 5 3 4 5 3 4 5 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-info-set ${ILM_E_SLOT} 9 5 3 4 5 3 4 5 @ret:${status} @output:${output}" 255 "${status}"
  assertContains "$RTUCLIENT ilm-info-set ${ILM_E_SLOT} 9 5 3 4 5 3 4 5 @output:${output}" "${output}" "port"
  assertContains "$RTUCLIENT ilm-info-set ${ILM_E_SLOT} 9 5 3 4 5 3 4 5 @output:${output}" "${output}" "error"
}

test_ILM_station_info_set_stations_greater() {
  [ -z "${ILM_SLOT:-}" ] && startSkipping
  #54                                    92
  output="$($RTUCLIENT ilm-info-set "${ILM_SLOT}" 1 19 3 4 5 3 4 5 3 4 5 3 4 5 3 4 5 3 4 5 3 3 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-info-set ${ILM_SLOT} 1 19 3 4 5 3 4 5 3 4 5 3 4 5 3 4 5 3 4 5 3 3 @ret:${status} @output:${output}" 255 "${status}"
  assertContains "$RTUCLIENT ilm-info-set ${ILM_SLOT} 1 19 3 4 5 3 4 5 3 4 5 3 4 5 3 4 5 3 4 5 3 3 @output:${output}" "${output}" "argument"
  assertContains "$RTUCLIENT ilm-info-set ${ILM_SLOT} 1 19 3 4 5 3 4 5 3 4 5 3 4 5 3 4 5 3 4 5 3 3 @output:${output}" "${output}" "error"
}

test_ILM_E_station_info_set_stations_greater() {
  [ -z "${ILM_E_SLOT:-}" ] && startSkipping
  #54                                    92
  output="$($RTUCLIENT ilm-info-set "${ILM_E_SLOT}" 5 19 3 4 5 3 4 5 3 4 5 3 4 5 3 4 5 3 4 5 3 3 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-info-set ${ILM_E_SLOT} 5 19 3 4 5 3 4 5 3 4 5 3 4 5 3 4 5 3 4 5 3 3 @ret:${status} @output:${output}" 255 "${status}"
  assertContains "$RTUCLIENT ilm-info-set ${ILM_E_SLOT} 5 19 3 4 5 3 4 5 3 4 5 3 4 5 3 4 5 3 4 5 3 3 @output:${output}" "${output}" "argument"
  assertContains "$RTUCLIENT ilm-info-set ${ILM_E_SLOT} 5 19 3 4 5 3 4 5 3 4 5 3 4 5 3 4 5 3 4 5 3 3 @output:${output}" "${output}" "error"
}

test_ILM_station_info_set_station_distance_greater() {
  [ -z "${ILM_SLOT:-}" ] && startSkipping
  output="$($RTUCLIENT ilm-info-set "${ILM_SLOT}" 1 5 10 4 5 3 4 5 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-info-set ${ILM_SLOT} 1 5 10 4 5 3 4 5 @ret:${status} @output:${output}" 255 "${status}"
  assertContains "$RTUCLIENT ilm-info-set ${ILM_SLOT} 1 5 10 4 5 3 4 5 @output:${output}" "${output}" "argument"
  assertContains "$RTUCLIENT ilm-info-set ${ILM_SLOT} 1 5 10 4 5 3 4 5 @output:${output}" "${output}" "error"
}

test_ILM_E_station_info_set_station_distance_greater() {
  [ -z "${ILM_E_SLOT:-}" ] && startSkipping
  output="$($RTUCLIENT ilm-info-set "${ILM_E_SLOT}" 5 5 10 4 5 3 4 5 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-info-set ${ILM_E_SLOT} 5 5 10 4 5 3 4 5 @ret:${status} @output:${output}" 255 "${status}"
  assertContains "$RTUCLIENT ilm-info-set ${ILM_E_SLOT} 5 5 10 4 5 3 4 5 @output:${output}" "${output}" "argument"
  assertContains "$RTUCLIENT ilm-info-set ${ILM_E_SLOT} 5 5 10 4 5 3 4 5 @output:${output}" "${output}" "error"
}

#### ilm-info-get slot direct
test_ILM_station_info_get_slot_valid() {
  [ -z "${ILM_SLOT:-}" ] && startSkipping
  # direct 1
  output="$($RTUCLIENT ilm-info-get "${ILM_SLOT}" 1 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-info-get $ILM_SLOT 1 @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-info-get $ILM_SLOT 1 @output:${output}" "${output}" "distances"
  assertContains "$RTUCLIENT ilm-info-get $ILM_SLOT 1 @output:${output}" "${output}" "${ILM_INFO15}"
  assertNotContains "$RTUCLIENT ilm-info-get $ILM_SLOT 1 @output:${output}" "${output}" "error"

  # direct 2
  output="$($RTUCLIENT ilm-info-get "${ILM_SLOT}" 2 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-info-get $ILM_SLOT 2 @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-info-get $ILM_SLOT 2 @output:${output}" "${output}" "distances"
  assertContains "$RTUCLIENT ilm-info-get $ILM_SLOT 2 @output:${output}" "${output}" "${ILM_INFO26}"
  assertNotContains "$RTUCLIENT ilm-info-get $ILM_SLOT 2 @output:${output}" "${output}" "error"

  # direct 3
  output="$($RTUCLIENT ilm-info-get "${ILM_SLOT}" 3 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-info-get $ILM_SLOT 3 @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-info-get $ILM_SLOT 3 @output:${output}" "${output}" "distances"
  assertContains "$RTUCLIENT ilm-info-get $ILM_SLOT 3 @output:${output}" "${output}" "${ILM_INFO37}"
  assertNotContains "$RTUCLIENT ilm-info-get $ILM_SLOT 3 @output:${output}" "${output}" "error"

  # direct 4
  output="$($RTUCLIENT ilm-info-get "${ILM_SLOT}" 4 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-info-get $ILM_SLOT 4 @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-info-get $ILM_SLOT 4 @output:${output}" "${output}" "distances"
  assertContains "$RTUCLIENT ilm-info-get $ILM_SLOT 4 @output:${output}" "${output}" "${ILM_INFO48}"
  assertNotContains "$RTUCLIENT ilm-info-get $ILM_SLOT 4 @output:${output}" "${output}" "error"
}

test_ILM_station_info_get_slot_valid_table() {
  [ -z "${ILM_SLOT:-}" ] && startSkipping
  while read -r direct station_array; do
    output="$($RTUCLIENT ilm-info-get "${ILM_SLOT}" "${direct}" 2>&1)"
    status=$?
    assertEquals "$RTUCLIENT ilm-info-get $ILM_SLOT ${direct} @ret:${status} @output:${output}" 0 "${status}"
    assertContains "$RTUCLIENT ilm-info-get $ILM_SLOT ${direct} @output:${output}" "${output}" "distances"
    assertContains "$RTUCLIENT ilm-info-get $ILM_SLOT ${direct} @output:${output}" "${output}" "${station_array}"
    assertNotContains "$RTUCLIENT ilm-info-get $ILM_SLOT ${direct} @output:${output}" "${output}" "error"
  done <<EOF
1  ${ILM_INFO15}
2  ${ILM_INFO26}
3  ${ILM_INFO37}
4  ${ILM_INFO48}
EOF
}

test_ILM_E_station_info_get_slot_valid() {
  [ -z "${ILM_E_SLOT:-}" ] && startSkipping
  # direct 1
  output="$($RTUCLIENT ilm-info-get "${ILM_E_SLOT}" 5 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-info-get $ILM_E_SLOT 5 @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-info-get $ILM_E_SLOT 5 @output:${output}" "${output}" "distances"
  assertContains "$RTUCLIENT ilm-info-get $ILM_E_SLOT 5 @output:${output}" "${output}" "${ILM_INFO15}"
  assertNotContains "$RTUCLIENT ilm-info-get $ILM_E_SLOT 5 @output:${output}" "${output}" "error"

  # direct 2
  output="$($RTUCLIENT ilm-info-get "${ILM_E_SLOT}" 6 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-info-get $ILM_E_SLOT 6 @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-info-get $ILM_E_SLOT 6 @output:${output}" "${output}" "distances"
  assertContains "$RTUCLIENT ilm-info-get $ILM_E_SLOT 6 @output:${output}" "${output}" "${ILM_INFO26}"
  assertNotContains "$RTUCLIENT ilm-info-get $ILM_E_SLOT 6 @output:${output}" "${output}" "error"

  # direct 3
  output="$($RTUCLIENT ilm-info-get "${ILM_E_SLOT}" 7 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-info-get $ILM_E_SLOT 7 @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-info-get $ILM_E_SLOT 7 @output:${output}" "${output}" "distances"
  assertContains "$RTUCLIENT ilm-info-get $ILM_E_SLOT 7 @output:${output}" "${output}" "${ILM_INFO37}"
  assertNotContains "$RTUCLIENT ilm-info-get $ILM_E_SLOT 7 @output:${output}" "${output}" "error"

  # direct 4
  output="$($RTUCLIENT ilm-info-get "${ILM_E_SLOT}" 8 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-info-get $ILM_E_SLOT 8 @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-info-get $ILM_E_SLOT 8 @output:${output}" "${output}" "distances"
  assertContains "$RTUCLIENT ilm-info-get $ILM_E_SLOT 8 @output:${output}" "${output}" "${ILM_INFO48}"
  assertNotContains "$RTUCLIENT ilm-info-get $ILM_E_SLOT 8 @output:${output}" "${output}" "error"
}

test_ILM_E_station_info_get_slot_valid_table() {
  [ -z "${ILM_E_SLOT:-}" ] && startSkipping
  while read -r direct station_array; do
    output="$($RTUCLIENT ilm-info-get "${ILM_E_SLOT}" "${direct}" 2>&1)"
    status=$?
    assertEquals "$RTUCLIENT ilm-info-get $ILM_E_SLOT ${direct} @ret:${status} @output:${output}" 0 "${status}"
    assertContains "$RTUCLIENT ilm-info-get $ILM_E_SLOT ${direct} @output:${output}" "${output}" "distances"
    assertContains "$RTUCLIENT ilm-info-get $ILM_E_SLOT ${direct} @output:${output}" "${output}" "${station_array}"
    assertNotContains "$RTUCLIENT ilm-info-get $ILM_E_SLOT ${direct} @output:${output}" "${output}" "error"
  done <<EOF
5  ${ILM_INFO15}
6  ${ILM_INFO26}
7  ${ILM_INFO37}
8  ${ILM_INFO48}
EOF
}

test_ILM_station_info_get_slot_255() {
  [ -z "${ILM_SLOT:-}" ] && startSkipping
  # direct 1
  output="$($RTUCLIENT ilm-info-get 255 1 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-info-get 255 1 @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-info-get 255 1 @output:${output}" "${output}" "distances"
  assertContains "$RTUCLIENT ilm-info-get 255 1 @output:${output}" "${output}" "${ILM_INFO15}"
  assertNotContains "$RTUCLIENT ilm-info-get 255 1 @output:${output}" "${output}" "error"

  # direct 2
  output="$($RTUCLIENT ilm-info-get 255 2 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-info-get 255 2 @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-info-get 255 2 @output:${output}" "${output}" "distances"
  assertContains "$RTUCLIENT ilm-info-get 255 2 @output:${output}" "${output}" "${ILM_INFO26}"
  assertNotContains "$RTUCLIENT ilm-info-get 255 2 @output:${output}" "${output}" "error"

  # direct 3
  output="$($RTUCLIENT ilm-info-get 255 3 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-info-get 255 3 @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-info-get 255 3 @output:${output}" "${output}" "distances"
  assertContains "$RTUCLIENT ilm-info-get 255 3 @output:${output}" "${output}" "${ILM_INFO37}"
  assertNotContains "$RTUCLIENT ilm-info-get 255 3 @output:${output}" "${output}" "error"

  # direct 4
  output="$($RTUCLIENT ilm-info-get 255 4 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-info-get 255 4 @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-info-get 255 4 @output:${output}" "${output}" "distances"
  assertContains "$RTUCLIENT ilm-info-get 255 4 @output:${output}" "${output}" "${ILM_INFO48}"
  assertNotContains "$RTUCLIENT ilm-info-get 255 4 @output:${output}" "${output}" "error"
}

test_ILM_station_info_get_slot_255_table() {
  [ -z "${ILM_SLOT:-}" ] && startSkipping
  while read -r direct station_array; do
    output="$($RTUCLIENT ilm-info-get 255 "${direct}" 2>&1)"
    status=$?
    assertEquals "$RTUCLIENT ilm-info-get 255 ${direct} @ret:${status} @output:${output}" 0 "${status}"
    assertContains "$RTUCLIENT ilm-info-get 255 ${direct} @output:${output}" "${output}" "distances"
    assertContains "$RTUCLIENT ilm-info-get 255 ${direct} @output:${output}" "${output}" "${station_array}"
    assertNotContains "$RTUCLIENT ilm-info-get 255 ${direct} @output:${output}" "${output}" "error"
  done <<EOF
1  ${ILM_INFO15}
2  ${ILM_INFO26}
3  ${ILM_INFO37}
4  ${ILM_INFO48}
EOF
}

test_ILM_E_station_info_get_slot_255() {
  [ -z "${ILM_E_SLOT:-}" ] && startSkipping
  # direct 1
  output="$($RTUCLIENT ilm-info-get 255 5 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-info-get 255 5 @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-info-get 255 5 @output:${output}" "${output}" "distances"
  assertContains "$RTUCLIENT ilm-info-get 255 5 @output:${output}" "${output}" "${ILM_INFO15}"
  assertNotContains "$RTUCLIENT ilm-info-get 255 5 @output:${output}" "${output}" "error"

  # direct 2
  output="$($RTUCLIENT ilm-info-get 255 6 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-info-get 255 6 @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-info-get 255 6 @output:${output}" "${output}" "distances"
  assertContains "$RTUCLIENT ilm-info-get 255 6 @output:${output}" "${output}" "${ILM_INFO26}"
  assertNotContains "$RTUCLIENT ilm-info-get 255 6 @output:${output}" "${output}" "error"

  # direct 3
  output="$($RTUCLIENT ilm-info-get 255 7 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-info-get 255 7 @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-info-get 255 7 @output:${output}" "${output}" "distances"
  assertContains "$RTUCLIENT ilm-info-get 255 7 @output:${output}" "${output}" "${ILM_INFO37}"
  assertNotContains "$RTUCLIENT ilm-info-get 255 7 @output:${output}" "${output}" "error"

  # direct 4
  output="$($RTUCLIENT ilm-info-get 255 8 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-info-get 255 8 @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-info-get 255 8 @output:${output}" "${output}" "distances"
  assertContains "$RTUCLIENT ilm-info-get 255 8 @output:${output}" "${output}" "${ILM_INFO48}"
  assertNotContains "$RTUCLIENT ilm-info-get 255 8 @output:${output}" "${output}" "error"
}

test_ILM_E_station_info_get_slot_255_table() {
  [ -z "${ILM_E_SLOT:-}" ] && startSkipping
  while read -r direct station_array; do
    output="$($RTUCLIENT ilm-info-get 255 "${direct}" 2>&1)"
    status=$?
    assertEquals "$RTUCLIENT ilm-info-get 255 ${direct} @ret:${status} @output:${output}" 0 "${status}"
    assertContains "$RTUCLIENT ilm-info-get 255 ${direct} @output:${output}" "${output}" "distances"
    assertContains "$RTUCLIENT ilm-info-get 255 ${direct} @output:${output}" "${output}" "${station_array}"
    assertNotContains "$RTUCLIENT ilm-info-get 255 ${direct} @output:${output}" "${output}" "error"
  done <<EOF
5  ${ILM_INFO15}
6  ${ILM_INFO26}
7  ${ILM_INFO37}
8  ${ILM_INFO48}
EOF
}

test_ILM_station_info_get_slot_invalid() {
  [ -z "${ILM_SLOT:-}" ] && startSkipping
  # slot invalid "${ILM_SLOT}" + 1
  local slot=$((ILM_SLOT + 1))
  output="$($RTUCLIENT ilm-info-get ${slot} 1 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-info-get ${slot} 1 @ret:${status} @output:${output}" 255 "${status}"
  assertContains "$RTUCLIENT ilm-info-get ${slot} 1 @output:${output}" "${output}" "slot"
  assertContains "$RTUCLIENT ilm-info-get ${slot} 1 @output:${output}" "${output}" "error"
}

test_ILM_E_station_info_get_slot_invalid() {
  [ -z "${ILM_E_SLOT:-}" ] && startSkipping
  # slot invalid "${ILM_E_SLOT}" + 1
  local slot=$((ILM_E_SLOT + 1))
  output="$($RTUCLIENT ilm-info-get ${slot} 1 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-info-get ${slot} 1 @ret:${status} @output:${output}" 255 "${status}"
  assertContains "$RTUCLIENT ilm-info-get ${slot} 1 @output:${output}" "${output}" "slot"
  assertContains "$RTUCLIENT ilm-info-get ${slot} 1 @output:${output}" "${output}" "error"
}

test_ILM_station_info_get_slot_greater() {
  [ -z "${ILM_SLOT:-}" ] && startSkipping
  # slot invalid 254
  output="$($RTUCLIENT ilm-info-get 254 1 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-info-get 254 1 @ret:${status} @output:${output}" 255 "${status}"
  assertContains "$RTUCLIENT ilm-info-get 254 1 @output:${output}" "${output}" "slot"
  assertContains "$RTUCLIENT ilm-info-get 254 1 @output:${output}" "${output}" "error"
}

test_ILM_E_station_info_get_slot_greater() {
  [ -z "${ILM_E_SLOT:-}" ] && startSkipping
  # slot invalid 254
  output="$($RTUCLIENT ilm-info-get 254 5 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-info-get 254 5 @ret:${status} @output:${output}" 255 "${status}"
  assertContains "$RTUCLIENT ilm-info-get 254 5 @output:${output}" "${output}" "slot"
  assertContains "$RTUCLIENT ilm-info-get 254 5 @output:${output}" "${output}" "error"
}

test_ILM_station_info_get_direct_zero() {
  [ -z "${ILM_SLOT:-}" ] && startSkipping
  # direct invalid 0
  output="$($RTUCLIENT ilm-info-get "${ILM_SLOT}" 0 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-info-get $ILM_SLOT 0 @ret:${status} @output:${output}" 255 "${status}"
  assertContains "$RTUCLIENT ilm-info-get $ILM_SLOT 0 @output:${output}" "${output}" "port"
  assertContains "$RTUCLIENT ilm-info-get $ILM_SLOT 0 @output:${output}" "${output}" "error"
}

test_ILM_E_station_info_get_direct_zero() {
  [ -z "${ILM_E_SLOT:-}" ] && startSkipping
  # direct invalid 0
  output="$($RTUCLIENT ilm-info-get "${ILM_E_SLOT}" 0 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-info-get $ILM_E_SLOT 0 @ret:${status} @output:${output}" 255 "${status}"
  assertContains "$RTUCLIENT ilm-info-get $ILM_E_SLOT 0 @output:${output}" "${output}" "port"
  assertContains "$RTUCLIENT ilm-info-get $ILM_E_SLOT 0 @output:${output}" "${output}" "error"
}

test_ILM_station_info_get_direct_greater() {
  [ -z "${ILM_SLOT:-}" ] && startSkipping
  # direct invalid 9
  output="$($RTUCLIENT ilm-info-get "${ILM_SLOT}" 9 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-info-get $ILM_SLOT 9 @ret:${status} @output:${output}" 255 "${status}"
  assertContains "$RTUCLIENT ilm-info-get $ILM_SLOT 9 @output:${output}" "${output}" "port"
  assertContains "$RTUCLIENT ilm-info-get $ILM_SLOT 9 @output:${output}" "${output}" "error"
}

test_ILM_E_station_info_get_direct_greater() {
  [ -z "${ILM_E_SLOT:-}" ] && startSkipping
  # direct invalid 9
  output="$($RTUCLIENT ilm-info-get "${ILM_E_SLOT}" 9 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-info-get $ILM_E_SLOT 9 @ret:${status} @output:${output}" 255 "${status}"
  assertContains "$RTUCLIENT ilm-info-get $ILM_E_SLOT 9 @output:${output}" "${output}" "port"
  assertContains "$RTUCLIENT ilm-info-get $ILM_E_SLOT 9 @output:${output}" "${output}" "error"
}

#### ilm-result-set slot direct rssts ...
test_ILM_insulate_result_set_slot_valid() {
  [ -z "${ILM_SLOT:-}" ] && startSkipping
  # direct 1
  #   shellcheck disable=SC2086
  output="$($RTUCLIENT ilm-result-set "${ILM_SLOT}" 1 ${ILM_RES16} 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-set $ILM_SLOT 1 ${ILM_RES16} @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-result-set $ILM_SLOT 1 ${ILM_RES16} @output:${output}" "${output}" "direct"
  assertNotContains "$RTUCLIENT ilm-result-set $ILM_SLOT 1 ${ILM_RES16} @output:${output}" "${output}" "error"

  # direct 2
  #   shellcheck disable=SC2086
  output="$($RTUCLIENT ilm-result-set "${ILM_SLOT}" 2 ${ILM_RES27} 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-set $ILM_SLOT 2 ${ILM_RES27} @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-result-set $ILM_SLOT 2 ${ILM_RES27} @output:${output}" "${output}" "direct"
  assertNotContains "$RTUCLIENT ilm-result-set $ILM_SLOT 2 ${ILM_RES27} @output:${output}" "${output}" "error"

  # direct 3
  #   shellcheck disable=SC2086
  output="$($RTUCLIENT ilm-result-set "${ILM_SLOT}" 3 ${ILM_RES38} 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-set $ILM_SLOT 3 ${ILM_RES38} @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-result-set $ILM_SLOT 3 ${ILM_RES38} @output:${output}" "${output}" "direct"
  assertNotContains "$RTUCLIENT ilm-result-set $ILM_SLOT 3 ${ILM_RES38} @output:${output}" "${output}" "error"

  # direct 4
  #   shellcheck disable=SC2086
  output="$($RTUCLIENT ilm-result-set "${ILM_SLOT}" 4 ${ILM_RES49} 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-set $ILM_SLOT 4 ${ILM_RES49} @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-result-set $ILM_SLOT 4 ${ILM_RES49} @output:${output}" "${output}" "direct"
  assertNotContains "$RTUCLIENT ilm-result-set $ILM_SLOT 4 ${ILM_RES49} @output:${output}" "${output}" "error"
}

test_ILM_insulate_result_set_slot_valid_table() {
  [ -z "${ILM_SLOT:-}" ] && startSkipping

  while read -r direct rsst_array; do
    output="$($RTUCLIENT ilm-result-set "${ILM_SLOT}" "${direct}" ${rsst_array} 2>&1)"
    status=$?
    assertEquals "$RTUCLIENT ilm-result-set $ILM_SLOT ${direct} ${rsst_array} @ret:${status} @output:${output}" 0 "${status}"
    assertContains "$RTUCLIENT ilm-result-set $ILM_SLOT ${direct} ${rsst_array} @output:${output}" "${output}" "direct"
    assertNotContains "$RTUCLIENT ilm-result-set $ILM_SLOT ${direct} ${rsst_array} @output:${output}" "${output}" "error"
  done <<EOF
1   ${ILM_RES16}
2   ${ILM_RES27}
3   ${ILM_RES38}
4   ${ILM_RES49}
EOF
}

test_ILM_E_insulate_result_set_slot_valid() {
  [ -z "${ILM_E_SLOT:-}" ] && startSkipping
  # direct 5
  #   shellcheck disable=SC2086
  output="$($RTUCLIENT ilm-result-set "${ILM_E_SLOT}" 5 ${ILM_RES16} 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-set $ILM_E_SLOT 5 ${ILM_RES16} @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-result-set $ILM_E_SLOT 5 ${ILM_RES16} @output:${output}" "${output}" "direct"
  assertNotContains "$RTUCLIENT ilm-result-set $ILM_E_SLOT 5 ${ILM_RES16} @output:${output}" "${output}" "error"

  # direct 6
  #   shellcheck disable=SC2086
  output="$($RTUCLIENT ilm-result-set "${ILM_E_SLOT}" 6 ${ILM_RES27} 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-set $ILM_E_SLOT 6 ${ILM_RES27} @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-result-set $ILM_E_SLOT 6 ${ILM_RES27} @output:${output}" "${output}" "direct"
  assertNotContains "$RTUCLIENT ilm-result-set $ILM_E_SLOT 6 ${ILM_RES27} @output:${output}" "${output}" "error"

  # direct 7
  #   shellcheck disable=SC2086
  output="$($RTUCLIENT ilm-result-set "${ILM_E_SLOT}" 7 ${ILM_RES38} 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-set $ILM_E_SLOT 7 ${ILM_RES38} @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-result-set $ILM_E_SLOT 7 ${ILM_RES38} @output:${output}" "${output}" "direct"
  assertNotContains "$RTUCLIENT ilm-result-set $ILM_E_SLOT 7 ${ILM_RES38} @output:${output}" "${output}" "error"

  # direct 8
  #   shellcheck disable=SC2086
  output="$($RTUCLIENT ilm-result-set "${ILM_E_SLOT}" 8 ${ILM_RES49} 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-set $ILM_E_SLOT 8 ${ILM_RES49} @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-result-set $ILM_E_SLOT 8 ${ILM_RES49} @output:${output}" "${output}" "direct"
  assertNotContains "$RTUCLIENT ilm-result-set $ILM_E_SLOT 8 ${ILM_RES49} @output:${output}" "${output}" "error"
}

test_ILM_E_insulate_result_set_slot_valid_table() {
  [ -z "${ILM_E_SLOT:-}" ] && startSkipping

  while read -r direct rsst_array; do
    output="$($RTUCLIENT ilm-result-set "${ILM_E_SLOT}" "${direct}" ${rsst_array} 2>&1)"
    status=$?
    assertEquals "$RTUCLIENT ilm-result-set $ILM_E_SLOT ${direct} ${rsst_array} @ret:${status} @output:${output}" 0 "${status}"
    assertContains "$RTUCLIENT ilm-result-set $ILM_E_SLOT ${direct} ${rsst_array} @output:${output}" "${output}" "direct"
    assertNotContains "$RTUCLIENT ilm-result-set $ILM_E_SLOT ${direct} ${rsst_array} @output:${output}" "${output}" "error"
  done <<EOF
5   ${ILM_RES16}
6   ${ILM_RES27}
7   ${ILM_RES38}
8   ${ILM_RES49}
EOF
}

test_ILM_insulate_result_set_slot_255() {
  [ -z "${ILM_SLOT:-}" ] && startSkipping
  # direct 1
  #   shellcheck disable=SC2086
  output="$($RTUCLIENT ilm-result-set 255 1 ${ILM_RES16} 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-set 255 1 ${ILM_RES16} @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-result-set 255 1 ${ILM_RES16} @output:${output}" "${output}" "direct"
  assertNotContains "$RTUCLIENT ilm-result-set 255 1 ${ILM_RES16} @output:${output}" "${output}" "error"

  # direct 2
  #   shellcheck disable=SC2086
  output="$($RTUCLIENT ilm-result-set 255 2 ${ILM_RES27} 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-set 255 2 ${ILM_RES27} @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-result-set 255 2 ${ILM_RES27} @output:${output}" "${output}" "direct"
  assertNotContains "$RTUCLIENT ilm-result-set 255 2 ${ILM_RES27} @output:${output}" "${output}" "error"

  # direct 3
  #   shellcheck disable=SC2086
  output="$($RTUCLIENT ilm-result-set 255 3 ${ILM_RES38} 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-set 255 3 ${ILM_RES38} @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-result-set 255 3 ${ILM_RES38} @output:${output}" "${output}" "direct"
  assertNotContains "$RTUCLIENT ilm-result-set 255 3 ${ILM_RES38} @output:${output}" "${output}" "error"

  # direct 4
  #   shellcheck disable=SC2086
  output="$($RTUCLIENT ilm-result-set 255 4 ${ILM_RES49} 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-set 255 4 ${ILM_RES49} @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-result-set 255 4 ${ILM_RES49} @output:${output}" "${output}" "direct"
  assertNotContains "$RTUCLIENT ilm-result-set 255 4 ${ILM_RES49} @output:${output}" "${output}" "error"
}

test_ILM_insulate_result_set_slot_255_table() {
  [ -z "${ILM_SLOT:-}" ] && startSkipping

  while read -r direct rsst_array; do
    output="$($RTUCLIENT ilm-result-set 255 "${direct}" ${rsst_array} 2>&1)"
    status=$?
    assertEquals "$RTUCLIENT ilm-result-set 255 ${direct} ${rsst_array} @ret:${status} @output:${output}" 0 "${status}"
    assertContains "$RTUCLIENT ilm-result-set 255 ${direct} ${rsst_array} @output:${output}" "${output}" "direct"
    assertNotContains "$RTUCLIENT ilm-result-set 255 ${direct} ${rsst_array} @output:${output}" "${output}" "error"
  done <<EOF
1   ${ILM_RES16}
2   ${ILM_RES27}
3   ${ILM_RES38}
4   ${ILM_RES49}
EOF
}

test_ILM_E_insulate_result_set_slot_255() {
  [ -z "${ILM_E_SLOT:-}" ] && startSkipping
  # direct 5
  #   shellcheck disable=SC2086
  output="$($RTUCLIENT ilm-result-set 255 5 ${ILM_RES16} 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-set 255 5 ${ILM_RES16} @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-result-set 255 5 ${ILM_RES16} @output:${output}" "${output}" "direct"
  assertNotContains "$RTUCLIENT ilm-result-set 255 5 ${ILM_RES16} @output:${output}" "${output}" "error"

  # direct 6
  #   shellcheck disable=SC2086
  output="$($RTUCLIENT ilm-result-set 255 6 ${ILM_RES27} 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-set 255 6 ${ILM_RES27} @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-result-set 255 6 ${ILM_RES27} @output:${output}" "${output}" "direct"
  assertNotContains "$RTUCLIENT ilm-result-set 255 6 ${ILM_RES27} @output:${output}" "${output}" "error"

  # direct 7
  #   shellcheck disable=SC2086
  output="$($RTUCLIENT ilm-result-set 255 7 ${ILM_RES38} 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-set 255 7 ${ILM_RES38} @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-result-set 255 7 ${ILM_RES38} @output:${output}" "${output}" "direct"
  assertNotContains "$RTUCLIENT ilm-result-set 255 7 ${ILM_RES38} @output:${output}" "${output}" "error"

  # direct 8
  #   shellcheck disable=SC2086
  output="$($RTUCLIENT ilm-result-set 255 8 ${ILM_RES49} 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-set 255 8 ${ILM_RES49} @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-result-set 255 8 ${ILM_RES49} @output:${output}" "${output}" "direct"
  assertNotContains "$RTUCLIENT ilm-result-set 255 8 ${ILM_RES49} @output:${output}" "${output}" "error"
}

test_ILM_E_insulate_result_set_slot_255_table() {
  [ -z "${ILM_E_SLOT:-}" ] && startSkipping

  while read -r direct rsst_array; do
    output="$($RTUCLIENT ilm-result-set 255 "${direct}" ${rsst_array} 2>&1)"
    status=$?
    assertEquals "$RTUCLIENT ilm-result-set 255 ${direct} ${rsst_array} @ret:${status} @output:${output}" 0 "${status}"
    assertContains "$RTUCLIENT ilm-result-set 255 ${direct} ${rsst_array} @output:${output}" "${output}" "direct"
    assertNotContains "$RTUCLIENT ilm-result-set 255 ${direct} ${rsst_array} @output:${output}" "${output}" "error"
  done <<EOF
5   ${ILM_RES16}
6   ${ILM_RES27}
7   ${ILM_RES38}
8   ${ILM_RES49}
EOF
}

test_ILM_insulate_result_set_slot_invalid() {
  [ -z "${ILM_SLOT:-}" ] && startSkipping
  # slot invalid "${ILM_SLOT}" + 1
  local slot=$((ILM_SLOT + 1))
  output="$($RTUCLIENT ilm-result-set ${slot} 1 4.22 5.23 6.12 4.22 5.23 6.12 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-set ${slot} 1 4.22 5.23 6.12 4.22 5.23 6.12 @ret:${status} @output:${output}" 255 "${status}"
  assertContains "$RTUCLIENT ilm-result-set ${slot} 1 4.22 5.23 6.12 4.22 5.23 6.12 @output:${output}" "${output}" "slot"
  assertContains "$RTUCLIENT ilm-result-set ${slot} 1 4.22 5.23 6.12 4.22 5.23 6.12 @output:${output}" "${output}" "error"
}

test_ILM_E_insulate_result_set_slot_invalid() {
  [ -z "${ILM_E_SLOT:-}" ] && startSkipping
  # slot invalid "${ILM_E_SLOT}" + 1
  local slot=$((ILM_E_SLOT + 1))
  output="$($RTUCLIENT ilm-result-set ${slot} 1 4.22 5.23 6.12 4.22 5.23 6.12 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-set ${slot} 1 4.22 5.23 6.12 4.22 5.23 6.12 @ret:${status} @output:${output}" 255 "${status}"
  assertContains "$RTUCLIENT ilm-result-set ${slot} 1 4.22 5.23 6.12 4.22 5.23 6.12 @output:${output}" "${output}" "slot"
  assertContains "$RTUCLIENT ilm-result-set ${slot} 1 4.22 5.23 6.12 4.22 5.23 6.12 @output:${output}" "${output}" "error"
}

test_ILM_insulate_result_set_slot_greater() {
  [ -z "${ILM_SLOT:-}" ] && startSkipping
  # slot invalid 254
  local slot=254
  output="$($RTUCLIENT ilm-result-set ${slot} 1 4.22 5.23 6.12 4.22 5.23 6.12 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-set ${slot} 1 4.22 5.23 6.12 4.22 5.23 6.12 @ret:${status} @output:${output}" 255 "${status}"
  assertContains "$RTUCLIENT ilm-result-set ${slot} 1 4.22 5.23 6.12 4.22 5.23 6.12 @output:${output}" "${output}" "slot"
  assertContains "$RTUCLIENT ilm-result-set ${slot} 1 4.22 5.23 6.12 4.22 5.23 6.12 @output:${output}" "${output}" "error"
}

test_ILM_E_insulate_result_set_slot_greater() {
  [ -z "${ILM_E_SLOT:-}" ] && startSkipping
  # slot invalid 254
  local slot=254
  output="$($RTUCLIENT ilm-result-set ${slot} 5 4.22 5.23 6.12 4.22 5.23 6.12 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-set ${slot} 5 4.22 5.23 6.12 4.22 5.23 6.12 @ret:${status} @output:${output}" 255 "${status}"
  assertContains "$RTUCLIENT ilm-result-set ${slot} 5 4.22 5.23 6.12 4.22 5.23 6.12 @output:${output}" "${output}" "slot"
  assertContains "$RTUCLIENT ilm-result-set ${slot} 5 4.22 5.23 6.12 4.22 5.23 6.12 @output:${output}" "${output}" "error"
}

test_ILM_insulate_result_set_direct_zero() {
  [ -z "${ILM_SLOT:-}" ] && startSkipping
  # direct invalid 0
  local slot="${ILM_SLOT}"
  output="$($RTUCLIENT ilm-result-set "${slot}" 0 4.22 5.23 6.12 4.22 5.23 6.12 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-set ${slot} 0 4.22 5.23 6.12 4.22 5.23 6.12 @ret:${status} @output:${output}" 255 "${status}"
  assertContains "$RTUCLIENT ilm-result-set ${slot} 0 4.22 5.23 6.12 4.22 5.23 6.12 @output:${output}" "${output}" "port"
  assertContains "$RTUCLIENT ilm-result-set ${slot} 0 4.22 5.23 6.12 4.22 5.23 6.12 @output:${output}" "${output}" "error"
}

test_ILM_E_insulate_result_set_direct_zero() {
  [ -z "${ILM_E_SLOT:-}" ] && startSkipping
  # direct invalid 0
  local slot="${ILM_E_SLOT}"
  output="$($RTUCLIENT ilm-result-set "${slot}" 0 4.22 5.23 6.12 4.22 5.23 6.12 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-set ${slot} 0 4.22 5.23 6.12 4.22 5.23 6.12 @ret:${status} @output:${output}" 255 "${status}"
  assertContains "$RTUCLIENT ilm-result-set ${slot} 0 4.22 5.23 6.12 4.22 5.23 6.12 @output:${output}" "${output}" "port"
  assertContains "$RTUCLIENT ilm-result-set ${slot} 0 4.22 5.23 6.12 4.22 5.23 6.12 @output:${output}" "${output}" "error"
}

test_ILM_insulate_result_set_direct_greater() {
  [ -z "${ILM_SLOT:-}" ] && startSkipping
  # direct invalid 9
  local slot="${ILM_SLOT}"
  output="$($RTUCLIENT ilm-result-set "${slot}" 9 4.22 5.23 6.12 4.22 5.23 6.12 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-set ${slot} 9 4.22 5.23 6.12 4.22 5.23 6.12 @ret:${status} @output:${output}" 255 "${status}"
  assertContains "$RTUCLIENT ilm-result-set ${slot} 9 4.22 5.23 6.12 4.22 5.23 6.12 @output:${output}" "${output}" "port"
  assertContains "$RTUCLIENT ilm-result-set ${slot} 9 4.22 5.23 6.12 4.22 5.23 6.12 @output:${output}" "${output}" "error"
}

test_ILM_E_insulate_result_set_direct_greater() {
  [ -z "${ILM_E_SLOT:-}" ] && startSkipping
  # direct invalid 9
  local slot="${ILM_E_SLOT}"
  output="$($RTUCLIENT ilm-result-set "${slot}" 9 4.22 5.23 6.12 4.22 5.23 6.12 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-set ${slot} 9 4.22 5.23 6.12 4.22 5.23 6.12 @ret:${status} @output:${output}" 255 "${status}"
  assertContains "$RTUCLIENT ilm-result-set ${slot} 9 4.22 5.23 6.12 4.22 5.23 6.12 @output:${output}" "${output}" "port"
  assertContains "$RTUCLIENT ilm-result-set ${slot} 9 4.22 5.23 6.12 4.22 5.23 6.12 @output:${output}" "${output}" "error"
}

#### ilm-result-get slot direct
test_ILM_insulate_result_get_slot_valid() {
  [ -z "${ILM_SLOT:-}" ] && startSkipping
  # direct 1
  output="$($RTUCLIENT ilm-result-get "${ILM_SLOT}" 1 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-get $ILM_SLOT 1 @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-result-get $ILM_SLOT 1 @output:${output}" "${output}" "rssts"
  assertContains "$RTUCLIENT ilm-result-get $ILM_SLOT 1 @output:${output}" "${output}" "${ILM_RES16}"
  assertNotContains "$RTUCLIENT ilm-result-get $ILM_SLOT 1 @output:${output}" "${output}" "error"

  # direct 2
  output="$($RTUCLIENT ilm-result-get "${ILM_SLOT}" 2 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-get $ILM_SLOT 2 @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-result-get $ILM_SLOT 2 @output:${output}" "${output}" "rssts"
  assertContains "$RTUCLIENT ilm-result-get $ILM_SLOT 2 @output:${output}" "${output}" "${ILM_RES27}"
  assertNotContains "$RTUCLIENT ilm-result-get $ILM_SLOT 2 @output:${output}" "${output}" "error"

  # direct 3
  output="$($RTUCLIENT ilm-result-get "${ILM_SLOT}" 3 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-get $ILM_SLOT 3 @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-result-get $ILM_SLOT 3 @output:${output}" "${output}" "rssts"
  assertContains "$RTUCLIENT ilm-result-get $ILM_SLOT 3 @output:${output}" "${output}" "${ILM_RES38}"
  assertNotContains "$RTUCLIENT ilm-result-get $ILM_SLOT 3 @output:${output}" "${output}" "error"

  # direct 4
  output="$($RTUCLIENT ilm-result-get "${ILM_SLOT}" 4 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-get $ILM_SLOT 4 @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-result-get $ILM_SLOT 4 @output:${output}" "${output}" "rssts"
  assertContains "$RTUCLIENT ilm-result-get $ILM_SLOT 4 @output:${output}" "${output}" "${ILM_RES49}"
  assertNotContains "$RTUCLIENT ilm-result-get $ILM_SLOT 4 @output:${output}" "${output}" "error"
}

test_ILM_insulate_result_get_slot_valid_table() {
  [ -z "${ILM_SLOT:-}" ] && startSkipping

  while read -r direct rsst_array; do
    output="$($RTUCLIENT ilm-result-get "${ILM_SLOT}" "${direct}" 2>&1)"
    status=$?
    assertEquals "$RTUCLIENT ilm-result-get $ILM_SLOT ${direct} @ret:${status} @output:${output}" 0 "${status}"
    assertContains "$RTUCLIENT ilm-result-get $ILM_SLOT ${direct} @output:${output}" "${output}" "rssts"
    assertContains "$RTUCLIENT ilm-result-get $ILM_SLOT ${direct} @output:${output}" "${output}" "${rsst_array}"
    assertNotContains "$RTUCLIENT ilm-result-get $ILM_SLOT ${direct} @output:${output}" "${output}" "error"
  done <<EOF
1   ${ILM_RES16}
2   ${ILM_RES27}
3   ${ILM_RES38}
4   ${ILM_RES49}
EOF
}

test_ILM_E_insulate_result_get_slot_valid() {
  [ -z "${ILM_E_SLOT:-}" ] && startSkipping
  # direct 1
  output="$($RTUCLIENT ilm-result-get "${ILM_E_SLOT}" 5 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-get $ILM_E_SLOT 5 @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-result-get $ILM_E_SLOT 5 @output:${output}" "${output}" "rssts"
  assertContains "$RTUCLIENT ilm-result-get $ILM_E_SLOT 5 @output:${output}" "${output}" "${ILM_RES16}"
  assertNotContains "$RTUCLIENT ilm-result-get $ILM_E_SLOT 5 @output:${output}" "${output}" "error"

  # direct 2
  output="$($RTUCLIENT ilm-result-get "${ILM_E_SLOT}" 6 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-get $ILM_E_SLOT 6 @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-result-get $ILM_E_SLOT 6 @output:${output}" "${output}" "rssts"
  assertContains "$RTUCLIENT ilm-result-get $ILM_E_SLOT 6 @output:${output}" "${output}" "${ILM_RES27}"
  assertNotContains "$RTUCLIENT ilm-result-get $ILM_E_SLOT 6 @output:${output}" "${output}" "error"

  # direct 3
  output="$($RTUCLIENT ilm-result-get "${ILM_E_SLOT}" 7 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-get $ILM_E_SLOT 7 @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-result-get $ILM_E_SLOT 7 @output:${output}" "${output}" "rssts"
  assertContains "$RTUCLIENT ilm-result-get $ILM_E_SLOT 7 @output:${output}" "${output}" "${ILM_RES38}"
  assertNotContains "$RTUCLIENT ilm-result-get $ILM_E_SLOT 7 @output:${output}" "${output}" "error"

  # direct 4
  output="$($RTUCLIENT ilm-result-get "${ILM_E_SLOT}" 8 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-get $ILM_E_SLOT 8 @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-result-get $ILM_E_SLOT 8 @output:${output}" "${output}" "rssts"
  assertContains "$RTUCLIENT ilm-result-get $ILM_E_SLOT 8 @output:${output}" "${output}" "${ILM_RES49}"
  assertNotContains "$RTUCLIENT ilm-result-get $ILM_E_SLOT 8 @output:${output}" "${output}" "error"
}

test_ILM_E_insulate_result_get_slot_valid_table() {
  [ -z "${ILM_E_SLOT:-}" ] && startSkipping

  while read -r direct rsst_array; do
    output="$($RTUCLIENT ilm-result-get "${ILM_E_SLOT}" "${direct}" 2>&1)"
    status=$?
    assertEquals "$RTUCLIENT ilm-result-get $ILM_E_SLOT ${direct} @ret:${status} @output:${output}" 0 "${status}"
    assertContains "$RTUCLIENT ilm-result-get $ILM_E_SLOT ${direct} @output:${output}" "${output}" "rssts"
    assertContains "$RTUCLIENT ilm-result-get $ILM_E_SLOT ${direct} @output:${output}" "${output}" "${rsst_array}"
    assertNotContains "$RTUCLIENT ilm-result-get $ILM_E_SLOT ${direct} @output:${output}" "${output}" "error"
  done <<EOF
5   ${ILM_RES16}
6   ${ILM_RES27}
7   ${ILM_RES38}
8   ${ILM_RES49}
EOF
}

test_ILM_insulate_result_get_slot_255() {
  [ -z "${ILM_SLOT:-}" ] && startSkipping
  # direct 1
  output="$($RTUCLIENT ilm-result-get 255 1 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-get 255 1 @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-result-get 255 1 @output:${output}" "${output}" "rssts"
  assertContains "$RTUCLIENT ilm-result-get 255 1 @output:${output}" "${output}" "${ILM_RES16}"
  assertNotContains "$RTUCLIENT ilm-result-get 255 1 @output:${output}" "${output}" "error"

  # direct 2
  output="$($RTUCLIENT ilm-result-get 255 2 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-get 255 2 @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-result-get 255 2 @output:${output}" "${output}" "rssts"
  assertContains "$RTUCLIENT ilm-result-get 255 2 @output:${output}" "${output}" "${ILM_RES27}"
  assertNotContains "$RTUCLIENT ilm-result-get 255 2 @output:${output}" "${output}" "error"

  # direct 3
  output="$($RTUCLIENT ilm-result-get 255 3 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-get 255 3 @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-result-get 255 3 @output:${output}" "${output}" "rssts"
  assertContains "$RTUCLIENT ilm-result-get 255 3 @output:${output}" "${output}" "${ILM_RES38}"
  assertNotContains "$RTUCLIENT ilm-result-get 255 3 @output:${output}" "${output}" "error"

  # direct 4
  output="$($RTUCLIENT ilm-result-get 255 4 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-get 255 4 @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-result-get 255 4 @output:${output}" "${output}" "rssts"
  assertContains "$RTUCLIENT ilm-result-get 255 4 @output:${output}" "${output}" "${ILM_RES49}"
  assertNotContains "$RTUCLIENT ilm-result-get 255 4 @output:${output}" "${output}" "error"
}

test_ILM_insulate_result_get_slot_255_table() {
  [ -z "${ILM_SLOT:-}" ] && startSkipping

  while read -r direct rsst_array; do
    output="$($RTUCLIENT ilm-result-get 255 "${direct}" 2>&1)"
    status=$?
    assertEquals "$RTUCLIENT ilm-result-get 255 ${direct} @ret:${status} @output:${output}" 0 "${status}"
    assertContains "$RTUCLIENT ilm-result-get 255 ${direct} @output:${output}" "${output}" "rssts"
    assertContains "$RTUCLIENT ilm-result-get 255 ${direct} @output:${output}" "${output}" "${rsst_array}"
    assertNotContains "$RTUCLIENT ilm-result-get 255 ${direct} @output:${output}" "${output}" "error"
  done <<EOF
1   ${ILM_RES16}
2   ${ILM_RES27}
3   ${ILM_RES38}
4   ${ILM_RES49}
EOF
}

test_ILM_E_insulate_result_get_slot_255() {
  [ -z "${ILM_E_SLOT:-}" ] && startSkipping
  # direct 1
  output="$($RTUCLIENT ilm-result-get 255 5 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-get 255 5 @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-result-get 255 5 @output:${output}" "${output}" "rssts"
  assertContains "$RTUCLIENT ilm-result-get 255 5 @output:${output}" "${output}" "${ILM_RES16}"
  assertNotContains "$RTUCLIENT ilm-result-get 255 5 @output:${output}" "${output}" "error"

  # direct 2
  output="$($RTUCLIENT ilm-result-get 255 6 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-get 255 6 @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-result-get 255 6 @output:${output}" "${output}" "rssts"
  assertContains "$RTUCLIENT ilm-result-get 255 6 @output:${output}" "${output}" "${ILM_RES27}"
  assertNotContains "$RTUCLIENT ilm-result-get 255 6 @output:${output}" "${output}" "error"

  # direct 3
  output="$($RTUCLIENT ilm-result-get 255 7 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-get 255 7 @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-result-get 255 7 @output:${output}" "${output}" "rssts"
  assertContains "$RTUCLIENT ilm-result-get 255 7 @output:${output}" "${output}" "${ILM_RES38}"
  assertNotContains "$RTUCLIENT ilm-result-get 255 7 @output:${output}" "${output}" "error"

  # direct 4
  output="$($RTUCLIENT ilm-result-get 255 8 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-get 255 8 @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-result-get 255 8 @output:${output}" "${output}" "rssts"
  assertContains "$RTUCLIENT ilm-result-get 255 8 @output:${output}" "${output}" "${ILM_RES49}"
  assertNotContains "$RTUCLIENT ilm-result-get 255 8 @output:${output}" "${output}" "error"
}

test_ILM_E_insulate_result_get_slot_255_table() {
  [ -z "${ILM_E_SLOT:-}" ] && startSkipping

  while read -r direct rsst_array; do
    output="$($RTUCLIENT ilm-result-get 255 "${direct}" 2>&1)"
    status=$?
    assertEquals "$RTUCLIENT ilm-result-get 255 ${direct} @ret:${status} @output:${output}" 0 "${status}"
    assertContains "$RTUCLIENT ilm-result-get 255 ${direct} @output:${output}" "${output}" "rssts"
    assertContains "$RTUCLIENT ilm-result-get 255 ${direct} @output:${output}" "${output}" "${rsst_array}"
    assertNotContains "$RTUCLIENT ilm-result-get 255 ${direct} @output:${output}" "${output}" "error"
  done <<EOF
5   ${ILM_RES16}
6   ${ILM_RES27}
7   ${ILM_RES38}
8   ${ILM_RES49}
EOF
}

test_ILM_insulate_result_get_slot_invalid() {
  [ -z "${ILM_SLOT:-}" ] && startSkipping
  # slot invalid "${ILM_SLOT}" + 1
  local slot=$((ILM_SLOT + 1))
  output="$($RTUCLIENT ilm-result-get ${slot} 1 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-get ${slot} 1 @ret:${status} @output:${output}" 255 "${status}"
  assertContains "$RTUCLIENT ilm-result-get ${slot} 1 @output:${output}" "${output}" "slot"
  assertContains "$RTUCLIENT ilm-result-get ${slot} 1 @output:${output}" "${output}" "error"
}

test_ILM_E_insulate_result_get_slot_invalid() {
  [ -z "${ILM_E_SLOT:-}" ] && startSkipping
  # slot invalid "${ILM_E_SLOT}" + 1
  local slot=$((ILM_E_SLOT + 1))
  output="$($RTUCLIENT ilm-result-get ${slot} 5 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-get ${slot} 5 @ret:${status} @output:${output}" 255 "${status}"
  assertContains "$RTUCLIENT ilm-result-get ${slot} 5 @output:${output}" "${output}" "slot"
  assertContains "$RTUCLIENT ilm-result-get ${slot} 5 @output:${output}" "${output}" "error"
}

test_ILM_insulate_result_get_slot_greater() {
  [ -z "${ILM_SLOT:-}" ] && startSkipping
  # slot invalid 254
  local slot=254
  output="$($RTUCLIENT ilm-result-get ${slot} 1 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-get ${slot} 1 @ret:${status} @output:${output}" 255 "${status}"
  assertContains "$RTUCLIENT ilm-result-get ${slot} 1 @output:${output}" "${output}" "slot"
  assertContains "$RTUCLIENT ilm-result-get ${slot} 1 @output:${output}" "${output}" "error"
}

test_ILM_E_insulate_result_get_slot_greater() {
  [ -z "${ILM_E_SLOT:-}" ] && startSkipping
  # slot invalid 254
  local slot=254
  output="$($RTUCLIENT ilm-result-get ${slot} 5 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-get ${slot} 5 @ret:${status} @output:${output}" 255 "${status}"
  assertContains "$RTUCLIENT ilm-result-get ${slot} 5 @output:${output}" "${output}" "slot"
  assertContains "$RTUCLIENT ilm-result-get ${slot} 5 @output:${output}" "${output}" "error"
}

test_ILM_insulate_result_get_direct_zero() {
  [ -z "${ILM_SLOT:-}" ] && startSkipping
  # direct invalid 0
  output="$($RTUCLIENT ilm-result-get "${ILM_SLOT}" 0 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-get $ILM_SLOT 0 @ret:${status} @output:${output}" 255 "${status}"
  assertContains "$RTUCLIENT ilm-result-get $ILM_SLOT 0 @output:${output}" "${output}" "port"
  assertContains "$RTUCLIENT ilm-result-get $ILM_SLOT 0 @output:${output}" "${output}" "error"
}

test_ILM_E_insulate_result_get_direct_zero() {
  [ -z "${ILM_E_SLOT:-}" ] && startSkipping
  # direct invalid 0
  output="$($RTUCLIENT ilm-result-get "${ILM_E_SLOT}" 0 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-get $ILM_E_SLOT 0 @ret:${status} @output:${output}" 255 "${status}"
  assertContains "$RTUCLIENT ilm-result-get $ILM_E_SLOT 0 @output:${output}" "${output}" "port"
  assertContains "$RTUCLIENT ilm-result-get $ILM_E_SLOT 0 @output:${output}" "${output}" "error"
}

test_ILM_insulate_result_get_direct_greater() {
  [ -z "${ILM_SLOT:-}" ] && startSkipping
  # direct invalid 9
  output="$($RTUCLIENT ilm-result-get "${ILM_SLOT}" 9 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-get $ILM_SLOT 9 @ret:${status} @output:${output}" 255 "${status}"
  assertContains "$RTUCLIENT ilm-result-get $ILM_SLOT 9 @output:${output}" "${output}" "port"
  assertContains "$RTUCLIENT ilm-result-get $ILM_SLOT 9 @output:${output}" "${output}" "error"
}

test_ILM_E_insulate_result_get_direct_greater() {
  [ -z "${ILM_E_SLOT:-}" ] && startSkipping
  # direct invalid 9
  output="$($RTUCLIENT ilm-result-get "${ILM_E_SLOT}" 9 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-get $ILM_E_SLOT 9 @ret:${status} @output:${output}" 255 "${status}"
  assertContains "$RTUCLIENT ilm-result-get $ILM_E_SLOT 9 @output:${output}" "${output}" "port"
  assertContains "$RTUCLIENT ilm-result-get $ILM_E_SLOT 9 @output:${output}" "${output}" "error"
}

test_ILM_insulate_result_get_direct_greater() {
  [ -z "${ILM_SLOT:-}" ] && startSkipping
  # direct invalid 9
  output="$($RTUCLIENT ilm-result-get "${ILM_SLOT}" 9 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-get $ILM_SLOT 9 @ret:${status} @output:${output}" 255 "${status}"
  assertContains "$RTUCLIENT ilm-result-get $ILM_SLOT 9 @output:${output}" "${output}" "port"
  assertContains "$RTUCLIENT ilm-result-get $ILM_SLOT 9 @output:${output}" "${output}" "error"
}

test_ILM_E_insulate_result_get_direct_greater() {
  [ -z "${ILM_E_SLOT:-}" ] && startSkipping
  # direct invalid 9
  output="$($RTUCLIENT ilm-result-get "${ILM_E_SLOT}" 9 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-get $ILM_E_SLOT 9 @ret:${status} @output:${output}" 255 "${status}"
  assertContains "$RTUCLIENT ilm-result-get $ILM_E_SLOT 9 @output:${output}" "${output}" "port"
  assertContains "$RTUCLIENT ilm-result-get $ILM_E_SLOT 9 @output:${output}" "${output}" "error"
}

test_ILM_insulate_result_set_slot_clear() {
  [ -z "${ILM_SLOT:-}" ] && startSkipping
  # direct 1
  #   shellcheck disable=SC2086
  output="$($RTUCLIENT ilm-result-set "${ILM_SLOT}" 1 0 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-set $ILM_SLOT 1 0 @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-result-set $ILM_SLOT 1 0 @output:${output}" "${output}" "direct"
  assertNotContains "$RTUCLIENT ilm-result-set $ILM_SLOT 1 0 @output:${output}" "${output}" "error"

  # direct 2
  #   shellcheck disable=SC2086
  output="$($RTUCLIENT ilm-result-set "${ILM_SLOT}" 2 0 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-set $ILM_SLOT 2 0 @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-result-set $ILM_SLOT 2 0 @output:${output}" "${output}" "direct"
  assertNotContains "$RTUCLIENT ilm-result-set $ILM_SLOT 2 0 @output:${output}" "${output}" "error"

  # direct 3
  #   shellcheck disable=SC2086
  output="$($RTUCLIENT ilm-result-set "${ILM_SLOT}" 3 0 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-set $ILM_SLOT 3 0 @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-result-set $ILM_SLOT 3 0 @output:${output}" "${output}" "direct"
  assertNotContains "$RTUCLIENT ilm-result-set $ILM_SLOT 3 0 @output:${output}" "${output}" "error"

  # direct 4
  #   shellcheck disable=SC2086
  output="$($RTUCLIENT ilm-result-set "${ILM_SLOT}" 4 0 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-set $ILM_SLOT 4 0 @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-result-set $ILM_SLOT 4 0 @output:${output}" "${output}" "direct"
  assertNotContains "$RTUCLIENT ilm-result-set $ILM_SLOT 4 0 @output:${output}" "${output}" "error"
}

test_ILM_insulate_result_set_slot_clear_table() {
  [ -z "${ILM_SLOT:-}" ] && startSkipping

  while read -r direct; do
    output="$($RTUCLIENT ilm-result-set "${ILM_SLOT}" "${direct}" 0 2>&1)"
    status=$?
    assertEquals "$RTUCLIENT ilm-result-set $ILM_SLOT ${direct} 0 @ret:${status} @output:${output}" 0 "${status}"
    assertContains "$RTUCLIENT ilm-result-set $ILM_SLOT ${direct} 0 @output:${output}" "${output}" "direct"
    assertNotContains "$RTUCLIENT ilm-result-set $ILM_SLOT ${direct} 0 @output:${output}" "${output}" "error"
  done <<EOF
1
2
3
4
EOF
}

test_ILM_E_insulate_result_set_slot_clear() {
  [ -z "${ILM_E_SLOT:-}" ] && startSkipping
  # direct 1
  #   shellcheck disable=SC2086
  output="$($RTUCLIENT ilm-result-set "${ILM_E_SLOT}" 5 0 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-set $ILM_E_SLOT 5 0 @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-result-set $ILM_E_SLOT 5 0 @output:${output}" "${output}" "direct"
  assertNotContains "$RTUCLIENT ilm-result-set $ILM_E_SLOT 5 0 @output:${output}" "${output}" "error"

  # direct 2
  #   shellcheck disable=SC2086
  output="$($RTUCLIENT ilm-result-set "${ILM_E_SLOT}" 6 0 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-set $ILM_E_SLOT 6 0 @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-result-set $ILM_E_SLOT 6 0 @output:${output}" "${output}" "direct"
  assertNotContains "$RTUCLIENT ilm-result-set $ILM_E_SLOT 6 0 @output:${output}" "${output}" "error"

  # direct 3
  #   shellcheck disable=SC2086
  output="$($RTUCLIENT ilm-result-set "${ILM_E_SLOT}" 7 0 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-set $ILM_E_SLOT 7 0 @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-result-set $ILM_E_SLOT 7 0 @output:${output}" "${output}" "direct"
  assertNotContains "$RTUCLIENT ilm-result-set $ILM_E_SLOT 7 0 @output:${output}" "${output}" "error"

  # direct 4
  #   shellcheck disable=SC2086
  output="$($RTUCLIENT ilm-result-set "${ILM_E_SLOT}" 8 0 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-set $ILM_E_SLOT 8 0 @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-result-set $ILM_E_SLOT 8 0 @output:${output}" "${output}" "direct"
  assertNotContains "$RTUCLIENT ilm-result-set $ILM_E_SLOT 8 0 @output:${output}" "${output}" "error"
}

test_ILM_E_insulate_result_set_slot_clear_table() {
  [ -z "${ILM_E_SLOT:-}" ] && startSkipping

  while read -r direct; do
    output="$($RTUCLIENT ilm-result-set "${ILM_E_SLOT}" "${direct}" 0 2>&1)"
    status=$?
    assertEquals "$RTUCLIENT ilm-result-set $ILM_E_SLOT ${direct} 0 @ret:${status} @output:${output}" 0 "${status}"
    assertContains "$RTUCLIENT ilm-result-set $ILM_E_SLOT ${direct} 0 @output:${output}" "${output}" "direct"
    assertNotContains "$RTUCLIENT ilm-result-set $ILM_E_SLOT ${direct} 0 @output:${output}" "${output}" "error"
  done <<EOF
5
6
7
8
EOF
}

test_ILM_insulate_result_get_slot_direct_notexist() {
  [ -z "${ILM_SLOT:-}" ] && startSkipping
  # direct 1
  #   shellcheck disable=SC2086
  output="$($RTUCLIENT ilm-result-get "${ILM_SLOT}" 1 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-get $ILM_SLOT 1 @ret:${status} @output:${output}" 255 "${status}"
  assertContains "$RTUCLIENT ilm-result-get $ILM_SLOT 1 @output:${output}" "${output}" "direct"
  assertContains "$RTUCLIENT ilm-result-get $ILM_SLOT 1 @output:${output}" "${output}" "error"

  # direct 2
  #   shellcheck disable=SC2086
  output="$($RTUCLIENT ilm-result-get "${ILM_SLOT}" 2 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-get $ILM_SLOT 2 @ret:${status} @output:${output}" 255 "${status}"
  assertContains "$RTUCLIENT ilm-result-get $ILM_SLOT 2 @output:${output}" "${output}" "direct"
  assertContains "$RTUCLIENT ilm-result-get $ILM_SLOT 2 @output:${output}" "${output}" "error"

  # direct 3
  #   shellcheck disable=SC2086
  output="$($RTUCLIENT ilm-result-get "${ILM_SLOT}" 3 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-get $ILM_SLOT 3 @ret:${status} @output:${output}" 255 "${status}"
  assertContains "$RTUCLIENT ilm-result-get $ILM_SLOT 3 @output:${output}" "${output}" "direct"
  assertContains "$RTUCLIENT ilm-result-get $ILM_SLOT 3 @output:${output}" "${output}" "error"

  # direct 4
  #   shellcheck disable=SC2086
  output="$($RTUCLIENT ilm-result-get "${ILM_SLOT}" 4 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-get $ILM_SLOT 4 @ret:${status} @output:${output}" 255 "${status}"
  assertContains "$RTUCLIENT ilm-result-get $ILM_SLOT 4 @output:${output}" "${output}" "direct"
  assertContains "$RTUCLIENT ilm-result-get $ILM_SLOT 4 @output:${output}" "${output}" "error"
}

test_ILM_insulate_result_get_slot_direct_notexist_table() {
  [ -z "${ILM_SLOT:-}" ] && startSkipping

  while read -r direct; do
    output="$($RTUCLIENT ilm-result-get "${ILM_SLOT}" "${direct}" 2>&1)"
    status=$?
    assertEquals "$RTUCLIENT ilm-result-get $ILM_SLOT ${direct} @ret:${status} @output:${output}" 255 "${status}"
    assertContains "$RTUCLIENT ilm-result-get $ILM_SLOT ${direct} @output:${output}" "${output}" "direct"
    assertContains "$RTUCLIENT ilm-result-get $ILM_SLOT ${direct} @output:${output}" "${output}" "error"
  done <<EOF
1
2
3
4
EOF
}

test_ILM_E_insulate_result_get_slot_direct_notexist() {
  [ -z "${ILM_E_SLOT:-}" ] && startSkipping
  # direct 1
  #   shellcheck disable=SC2086
  output="$($RTUCLIENT ilm-result-get "${ILM_E_SLOT}" 5 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-get $ILM_E_SLOT 5 @ret:${status} @output:${output}" 255 "${status}"
  assertContains "$RTUCLIENT ilm-result-get $ILM_E_SLOT 5 @output:${output}" "${output}" "direct"
  assertContains "$RTUCLIENT ilm-result-get $ILM_E_SLOT 5 @output:${output}" "${output}" "error"

  # direct 2
  #   shellcheck disable=SC2086
  output="$($RTUCLIENT ilm-result-get "${ILM_E_SLOT}" 6 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-get $ILM_E_SLOT 6 @ret:${status} @output:${output}" 255 "${status}"
  assertContains "$RTUCLIENT ilm-result-get $ILM_E_SLOT 6 @output:${output}" "${output}" "direct"
  assertContains "$RTUCLIENT ilm-result-get $ILM_E_SLOT 6 @output:${output}" "${output}" "error"

  # direct 3
  #   shellcheck disable=SC2086
  output="$($RTUCLIENT ilm-result-get "${ILM_E_SLOT}" 7 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-get $ILM_E_SLOT 7 @ret:${status} @output:${output}" 255 "${status}"
  assertContains "$RTUCLIENT ilm-result-get $ILM_E_SLOT 7 @output:${output}" "${output}" "direct"
  assertContains "$RTUCLIENT ilm-result-get $ILM_E_SLOT 7 @output:${output}" "${output}" "error"

  # direct 4
  #   shellcheck disable=SC2086
  output="$($RTUCLIENT ilm-result-get "${ILM_E_SLOT}" 8 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-result-get $ILM_E_SLOT 8 @ret:${status} @output:${output}" 255 "${status}"
  assertContains "$RTUCLIENT ilm-result-get $ILM_E_SLOT 8 @output:${output}" "${output}" "direct"
  assertContains "$RTUCLIENT ilm-result-get $ILM_E_SLOT 8 @output:${output}" "${output}" "error"
}

test_ILM_E_insulate_result_get_slot_direct_notexist_table() {
  [ -z "${ILM_E_SLOT:-}" ] && startSkipping

  while read -r direct; do
    output="$($RTUCLIENT ilm-result-get "${ILM_E_SLOT}" "${direct}" 2>&1)"
    status=$?
    assertEquals "$RTUCLIENT ilm-result-get $ILM_E_SLOT ${direct} @ret:${status} @output:${output}" 255 "${status}"
    assertContains "$RTUCLIENT ilm-result-get $ILM_E_SLOT ${direct} @output:${output}" "${output}" "direct"
    assertContains "$RTUCLIENT ilm-result-get $ILM_E_SLOT ${direct} @output:${output}" "${output}" "error"
  done <<EOF
5
6
7
8
EOF
}

#### ilm-config-get slot
test_ILM_config_get_slot_valid() {
  [ -z "${ILM_SLOT:-}" ] && startSkipping
  output="$($RTUCLIENT ilm-config-get "${ILM_SLOT}" 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-config-get $ILM_SLOT @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-config-get $ILM_SLOT @output:${output}" "${output}" "direct"
  assertNotContains "$RTUCLIENT ilm-config-get $ILM_SLOT @output:${output}" "${output}" "error"
}

test_ILM_E_config_get_slot_valid() {
  [ -z "${ILM_E_SLOT:-}" ] && startSkipping
  output="$($RTUCLIENT ilm-config-get "${ILM_E_SLOT}" 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-config-get $ILM_E_SLOT @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-config-get $ILM_E_SLOT @output:${output}" "${output}" "direct"
  assertNotContains "$RTUCLIENT ilm-config-get $ILM_E_SLOT @output:${output}" "${output}" "error"
}

test_ILM_config_get_slot_255() {
  [ -z "${ILM_SLOT:-}" ] && startSkipping
  output="$($RTUCLIENT ilm-config-get 255 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-config-get 255 @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-config-get 255 @output:${output}" "${output}" "direct"
  assertNotContains "$RTUCLIENT ilm-config-get 255 @output:${output}" "${output}" "error"
}

test_ILM_config_get_slot_invalid() {
  [ -z "${ILM_SLOT:-}" ] && startSkipping
  # slot invalid "${ILM_SLOT}" + 1
  local slot=$((ILM_SLOT + 1))
  output="$($RTUCLIENT ilm-config-get ${slot} 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-config-get ${slot} @ret:${status} @output:${output}" 255 "${status}"
  assertContains "$RTUCLIENT ilm-config-get ${slot} @output:${output}" "${output}" "slot"
  assertContains "$RTUCLIENT ilm-config-get ${slot} @output:${output}" "${output}" "error"
}

test_ILM_E_config_get_slot_invalid() {
  [ -z "${ILM_E_SLOT:-}" ] && startSkipping
  # slot invalid "${ILM_E_SLOT}" + 1
  local slot=$((ILM_E_SLOT + 1))
  output="$($RTUCLIENT ilm-config-get ${slot} 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-config-get ${slot} @ret:${status} @output:${output}" 255 "${status}"
  assertContains "$RTUCLIENT ilm-config-get ${slot} @output:${output}" "${output}" "slot"
  assertContains "$RTUCLIENT ilm-config-get ${slot} @output:${output}" "${output}" "error"
}

test_ILM_config_get_slot_greater() {
  [ -z "${ILM_SLOT:-}" ] && startSkipping
  # slot invalid 254
  local slot=254
  output="$($RTUCLIENT ilm-config-get ${slot} 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-config-get ${slot} @ret:${status} @output:${output}" 255 "${status}"
  assertContains "$RTUCLIENT ilm-config-get ${slot} @output:${output}" "${output}" "slot"
  assertContains "$RTUCLIENT ilm-config-get ${slot} @output:${output}" "${output}" "error"
}

#### ilm-status-get slot
test_ILM_insulate_status_slot_valid() {
  [ -z "${ILM_SLOT:-}" ] && startSkipping
  output="$($RTUCLIENT ilm-status-get "${ILM_SLOT}" 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-status-get $ILM_SLOT @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-status-get $ILM_SLOT @output:${output}" "${output}" "slot"
  assertNotContains "$RTUCLIENT ilm-status-get $ILM_SLOT @output:${output}" "${output}" "error"
}

test_ILM_E_insulate_status_slot_valid() {
  [ -z "${ILM_E_SLOT:-}" ] && startSkipping
  output="$($RTUCLIENT ilm-status-get "${ILM_E_SLOT}" 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-status-get $ILM_E_SLOT @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-status-get $ILM_E_SLOT @output:${output}" "${output}" "slot"
  assertNotContains "$RTUCLIENT ilm-status-get $ILM_E_SLOT @output:${output}" "${output}" "error"
}

test_ILM_insulate_status_slot_255() {
  [ -z "${ILM_SLOT:-}" ] && startSkipping
  output="$($RTUCLIENT ilm-status-get 255 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-status-get 255 @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT ilm-status-get 255 @output:${output}" "${output}" "slot"
  assertNotContains "$RTUCLIENT ilm-status-get 255 @output:${output}" "${output}" "error"
}

test_ILM_insulate_status_slot_invalid() {
  [ -z "${ILM_SLOT:-}" ] && startSkipping
  # slot invalid "${ILM_SLOT}" + 1
  local slot=$((ILM_SLOT + 1))
  output="$($RTUCLIENT ilm-status-get ${slot} 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-status-get ${slot} @ret:${status} @output:${output}" 255 "${status}"
  assertContains "$RTUCLIENT ilm-status-get ${slot} @output:${output}" "${output}" "slot"
  assertContains "$RTUCLIENT ilm-status-get ${slot} @output:${output}" "${output}" "error"
}

test_ILM_insulate_status_slot_greater() {
  [ -z "${ILM_SLOT:-}" ] && startSkipping
  # slot invalid 254
  local slot=254
  output="$($RTUCLIENT ilm-status-get ${slot} 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT ilm-status-get ${slot} @ret:${status} @output:${output}" 255 "${status}"
  assertContains "$RTUCLIENT ilm-status-get ${slot} @output:${output}" "${output}" "slot"
  assertContains "$RTUCLIENT ilm-status-get ${slot} @output:${output}" "${output}" "error"
}

######## protocol [GDM]     ########
#### gdm-test slot
test_GDM_RSST_test_slot_valid() {
  [ -z "${GDM_SLOT:-}" ] && startSkipping
  output="$($RTUCLIENT gdm-test "${GDM_SLOT}" 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT gdm-test ${GDM_SLOT} @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT gdm-test ${GDM_SLOT} @output:${output}" "${output}" "rsst"
  assertNotContains "$RTUCLIENT gdm-test ${GDM_SLOT} @output:${output}" "${output}" "error"
}

test_GDM_RSST_test_slot_255() {
  [ -z "${GDM_SLOT:-}" ] && startSkipping
  output="$($RTUCLIENT gdm-test 255 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT gdm-test 255 @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT gdm-test 255 @output:${output}" "${output}" "rsst"
  assertNotContains "$RTUCLIENT gdm-test 255 @output:${output}" "${output}" "error"
}

test_GDM_RSST_test_slot_invalid() {
  [ -z "${GDM_SLOT:-}" ] && startSkipping
  local slot=$((GDM_SLOT + 1))
  output="$($RTUCLIENT gdm-test ${slot} 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT gdm-test ${slot} @ret:${status} @output:${output}" 255 "${status}"
  assertContains "$RTUCLIENT gdm-test ${slot} @output:${output}" "${output}" "slot"
  assertContains "$RTUCLIENT gdm-test ${slot} @output:${output}" "${output}" "error"
}

test_GDM_RSST_test_slot_greater() {
  [ -z "${GDM_SLOT:-}" ] && startSkipping
  local slot=254
  output="$($RTUCLIENT gdm-test ${slot} 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT gdm-test ${slot} @ret:${status} @output:${output}" 255 "${status}"
  assertContains "$RTUCLIENT gdm-test ${slot} @output:${output}" "${output}" "slot"
  assertContains "$RTUCLIENT gdm-test ${slot} @output:${output}" "${output}" "error"
}

#### gdm-revison-set slot rsst
test_GDM_RSST_revison_set_slot_valid() {
  [ -z "${GDM_SLOT:-}" ] && startSkipping
  output="$($RTUCLIENT gdm-revison-set "${GDM_SLOT}" 0.23 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT gdm-revison-set ${GDM_SLOT} 0.23 @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT gdm-revison-set ${GDM_SLOT} 0.23 @output:${output}" "${output}" "gdm-revison-set"
  assertNotContains "$RTUCLIENT gdm-revison-set ${GDM_SLOT} 0.23 @output:${output}" "${output}" "error"
}

test_GDM_RSST_revison_set_slot_255() {
  [ -z "${GDM_SLOT:-}" ] && startSkipping
  output="$($RTUCLIENT gdm-revison-set 255 0.23 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT gdm-revison-set 255 0.23 @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT gdm-revison-set 255 0.23 @output:${output}" "gdm-revison-set"
  assertNotContains "$RTUCLIENT gdm-revison-set 255 0.23 @output:${output}" "${output}" "error"
}

test_GDM_RSST_revison_set_slot_invalid() {
  [ -z "${GDM_SLOT:-}" ] && startSkipping
  local slot=$((GDM_SLOT + 1))
  output="$($RTUCLIENT gdm-revison-set ${slot} 0.23 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT gdm-revison-set ${slot} 0.23 @ret:${status} @output:${output}" 255 "${status}"
  assertContains "$RTUCLIENT gdm-revison-set ${slot} 0.23 @output:${output}" "${output}" "slot"
  assertContains "$RTUCLIENT gdm-revison-set ${slot} 0.23 @output:${output}" "${output}" "error"
}

test_GDM_RSST_revison_set_slot_greater() {
  [ -z "${GDM_SLOT:-}" ] && startSkipping
  local slot=254
  output="$($RTUCLIENT gdm-revison-set 254 0.23 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT gdm-revison-set 254 0.23 @ret:${status} @output:${output}" 255 "${status}"
  assertContains "$RTUCLIENT gdm-revison-set ${slot} 0.23 @output:${output}" "${output}" "slot"
  assertContains "$RTUCLIENT gdm-revison-set ${slot} 0.23 @output:${output}" "${output}" "error"
}

#### gdm-revison-get slot
test_GDM_RSST_revison_get_slot_valid() {
  [ -z "${GDM_SLOT:-}" ] && startSkipping
  output="$($RTUCLIENT gdm-revison-get "${GDM_SLOT}" 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT gdm-revison-get ${GDM_SLOT} @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT gdm-revison-get ${GDM_SLOT} @output:${output}" "${output}" "rsst"
  assertNotContains "$RTUCLIENT gdm-revison-get ${GDM_SLOT} @output:${output}" "${output}" "error"
}

test_GDM_RSST_revison_get_slot_255() {
  [ -z "${GDM_SLOT:-}" ] && startSkipping
  output="$($RTUCLIENT gdm-revison-get 255 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT gdm-revison-get 255 @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT gdm-revison-get 255 @output:${output}" "${output}" "rsst"
  assertNotContains "$RTUCLIENT gdm-revison-get 255 @output:${output}" "${output}" "error"
}

test_GDM_RSST_revison_get_slot_invalid() {
  [ -z "${GDM_SLOT:-}" ] && startSkipping
  local slot=$((GDM_SLOT + 1))
  output="$($RTUCLIENT gdm-revison-get ${slot} 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT gdm-revison-get ${slot} @ret:${status} @output:${output}" 255 "${status}"
  assertContains "$RTUCLIENT gdm-revison-get ${slot} @output:${output}" "${output}" "slot"
  assertContains "$RTUCLIENT gdm-revison-get ${slot} @output:${output}" "${output}" "error"
}

test_GDM_RSST_revison_get_slot_greater() {
  [ -z "${GDM_SLOT:-}" ] && startSkipping
  local slot=254
  output="$($RTUCLIENT gdm-revison-get ${slot} 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT gdm-revison-get ${slot} @ret:${status} @output:${output}" 255 "${status}"
  assertContains "$RTUCLIENT gdm-revison-get ${slot} @output:${output}" "${output}" "slot"
  assertContains "$RTUCLIENT gdm-revison-get ${slot} @output:${output}" "${output}" "error"
}

######## protocol [TPWU]     ########
#### tpwu-250v-set slot [0|1]
test_TPWU_250V_set_slot_valid() {
  [ -z "${TPWU_SLOT:-}" ] && startSkipping
  output="$($RTUCLIENT tpwu-250v-set "${TPWU_SLOT}" 1 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT tpwu-250v-set ${TPWU_SLOT} 1 @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT tpwu-250v-set ${TPWU_SLOT} 1 @output:${output}" "${output}" "tpwu-250v-set"
  assertNotContains "$RTUCLIENT tpwu-250v-set ${TPWU_SLOT} 1 @output:${output}" "${output}" "error"

  # enable 0
  output="$($RTUCLIENT tpwu-250v-set "${TPWU_SLOT}" 0 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT tpwu-250v-set ${TPWU_SLOT} 0 @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT tpwu-250v-set ${TPWU_SLOT} 0 @output:${output}" "${output}" "tpwu-250v-set"
  assertNotContains "$RTUCLIENT tpwu-250v-set ${TPWU_SLOT} 0 @output:${output}" "${output}" "error"

}

test_TPWU_250V_set_slot_255() {
  [ -z "${TPWU_SLOT:-}" ] && startSkipping
  output="$($RTUCLIENT tpwu-250v-set 255 1 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT tpwu-250v-set 255 1 @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT tpwu-250v-set 255 1 @output:${output}" "${output}" "tpwu-250v-set"
  assertNotContains "$RTUCLIENT tpwu-250v-set 255 1 @output:${output}" "${output}" "error"

  #enabke 0
  output="$($RTUCLIENT tpwu-250v-set 255 0 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT tpwu-250v-set 255 0 @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT tpwu-250v-set 255 0 @output:${output}" "${output}" "tpwu-250v-set"
  assertNotContains "$RTUCLIENT tpwu-250v-set 255 0 @output:${output}" "${output}" "error"
}

test_TPWU_250V_set_slot_invalid() {
  [ -z "${TPWU_SLOT:-}" ] && startSkipping
  local slot=$((TPWU_SLOT + 1))
  output="$($RTUCLIENT tpwu-250v-set ${slot} 0 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT tpwu-250v-set ${slot} 0 @ret:${status} @output:${output}" 255 "${status}"
  assertContains "$RTUCLIENT tpwu-250v-set ${slot} 0 @output:${output}" "${output}" "slot"
  assertContains "$RTUCLIENT tpwu-250v-set ${slot} 0 @output:${output}" "${output}" "error"
}

test_TPWU_250V_set_slot_greater() {
  [ -z "${TPWU_SLOT:-}" ] && startSkipping
  local slot=254
  output="$($RTUCLIENT tpwu-250v-set ${slot} 0 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT tpwu-250v-set ${slot} 0 @ret:${status} @output:${output}" 255 "${status}"
  assertContains "$RTUCLIENT tpwu-250v-set ${slot} 0 @output:${output}" "${output}" "slot"
  assertContains "$RTUCLIENT tpwu-250v-set ${slot} 0 @output:${output}" "${output}" "error"
}

#### tpwu-250v-status slot
test_TPWU_250V_status_slot_valid() {
  [ -z "${TPWU_SLOT:-}" ] && startSkipping
  output="$($RTUCLIENT tpwu-250v-status "${TPWU_SLOT}" 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT tpwu-250v-status $TPWU_SLOT @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT tpwu-250v-status $TPWU_SLOT @output:${output}" "${output}" "status"
  assertNotContains "$RTUCLIENT tpwu-250v-status $TPWU_SLOT @output:${output}" "${output}" "error"
}

test_TPWU_250V_status_slot_255() {
  [ -z "${TPWU_SLOT:-}" ] && startSkipping
  output="$($RTUCLIENT tpwu-250v-status 255 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT tpwu-250v-status 255 @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$RTUCLIENT tpwu-250v-status 255 @output:${output}" "${output}" "status"
  assertNotContains "$RTUCLIENT tpwu-250v-status 255 @output:${output}" "${output}" "error"
}

test_TPWU_250V_status_slot_invalid() {
  [ -z "${TPWU_SLOT:-}" ] && startSkipping
  local slot=$((TPWU_SLOT + 1))
  output="$($RTUCLIENT tpwu-250v-status ${slot} 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT tpwu-250v-status ${slot} @ret:${status} @output:${output}" 255 "${status}"
  assertContains "$RTUCLIENT tpwu-250v-status ${slot} @output:${output}" "${output}" "slot"
  assertContains "$RTUCLIENT tpwu-250v-status ${slot} @output:${output}" "${output}" "error"
}

test_TPWU_250V_status_slot_greater() {
  [ -z "${TPWU_SLOT:-}" ] && startSkipping
  local slot=254
  output="$($RTUCLIENT tpwu-250v-status ${slot} 2>&1)"
  status=$?
  assertEquals "$RTUCLIENT tpwu-250v-status ${slot} @ret:${status} @output:${output}" 255 "${status}"
  assertContains "$RTUCLIENT tpwu-250v-status ${slot} @output:${output}" "${output}" "slot"
  assertContains "$RTUCLIENT tpwu-250v-status ${slot} @output:${output}" "${output}" "error"
}

suite_test_table() {
  test_hostd_self_table && echo "[passed] test_hostd_self_table"
  test_hostd_MCU_table && echo "[passed] test_hostd_MCU_table"

  test_ILM_station_info_set_slot_valid_table && echo "[passed] test_ILM_station_info_set_slot_valid_table"
  test_ILM_E_station_info_set_slot_valid_table && echo "[passed] test_ILM_E_station_info_set_slot_valid_table"

  test_ILM_station_info_set_slot_255_table && echo "[passed] test_ILM_station_info_set_slot_255_table"
  test_ILM_E_station_info_set_slot_255_table && echo "[passed] test_ILM_E_station_info_set_slot_255_table"

  test_ILM_station_info_get_slot_valid_table && echo "[passed] test_ILM_station_info_get_slot_valid_table"
  test_ILM_E_station_info_get_slot_valid_table && echo "[passed] test_ILM_E_station_info_get_slot_valid_table"

  test_ILM_station_info_get_slot_255_table && echo "[passed] test_ILM_station_info_get_slot_255_table"
  test_ILM_E_station_info_get_slot_255_table && echo "[passed] test_ILM_E_station_info_get_slot_255_table"

  test_ILM_insulate_result_set_slot_valid_table && echo "[passed] test_ILM_insulate_result_set_slot_valid_table"
  test_ILM_E_insulate_result_set_slot_valid_table && echo "[passed] test_ILM_E_insulate_result_set_slot_valid_table"

  test_ILM_insulate_result_set_slot_255_table && echo "[passed] test_ILM_insulate_result_set_slot_255_table"
  test_ILM_E_insulate_result_set_slot_255_table && echo "[passed] test_ILM_E_insulate_result_set_slot_255_table"

  test_ILM_insulate_result_get_slot_valid_table && echo "[passed] test_ILM_insulate_result_get_slot_valid_table"
  test_ILM_E_insulate_result_get_slot_valid_table && echo "[passed] test_ILM_E_insulate_result_get_slot_valid_table"

  test_ILM_insulate_result_get_slot_255_table && echo "[passed] test_ILM_insulate_result_get_slot_255_table"
  test_ILM_E_insulate_result_get_slot_255_table && echo "[passed] test_ILM_E_insulate_result_get_slot_255_table"

  test_ILM_insulate_result_set_slot_clear_table && echo "[passed] test_ILM_insulate_result_set_slot_clear_table"
  test_ILM_E_insulate_result_set_slot_clear_table && echo "[passed] test_ILM_E_insulate_result_set_slot_clear_table"

  test_ILM_insulate_result_get_slot_direct_notexist && echo "[passed] test_ILM_insulate_result_get_slot_direct_notexist"
  test_ILM_E_insulate_result_get_slot_direct_notexist && echo "[passed] test_ILM_E_insulate_result_get_slot_direct_notexist"
}

suite() {
  : suite_addTest suite_test_table
}
. ./shunit2
