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

  if [ -n "${SLOTD_DEBUG}" ]; then
    SLOTD="slotd -r 2000 -d 1 "
  else
    SLOTD="slotd -r 2000 "
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

: <<!
#comment
!

# require shunit2 version >= 2.1.7pre
# assertEquals [message] expected actual
# assertNotNull [message] value
# require shunit2 version >= 2.1.8pre
# assertContains [message] container content
# assertNotContains [message] container content

####  slotd test for self     ####
test_slotd_version() {
  output="$($SLOTD -v)"
  status=$?
  assertTrue "$SLOTD -v @ret:${status} @output:${output}" "${status}"
  assertContains "$SLOTD -v @output:${output}" "${output}" "xianleidi"
}

test_slotd_config() {
  output="$($SLOTD config)"
  status=$?
  assertTrue "$SLOTD config @ret:${status} @output:${output}" "${status}"
  assertContains "$SLOTD config @output:${output}" "${output}" "xianleidi"
}

test_slotd_config() {
  output="$($SLOTD debug 1)"
  status=$?
  assertTrue "$SLOTD debug 1 @ret:${status} @output:${output}" "${status}"
  assertContains "$SLOTD debug 1 @output:${output}" "${output}" "enable"

  output="$($SLOTD debug 0)"
  status=$?
  assertTrue "$SLOTD debug 0 @ret:${status} @output:${output}" "${status}"
  assertContains "$SLOTD debug 0 @output:${output}" "${output}" "disable"
}

test_slotd_command() {
  while read -r cmd content; do
    output="$($SLOTD command "${cmd}")"
    status=$?
    assertTrue "$SLOTD command ${cmd} @ret:${status} @output:${output}" "${status}"
    assertContains "$SLOTD command ${cmd} @output:${output}" "${output}" "${content}"
  done <<EOF
error               error
serial              PROTO_SLOT_VERSION
version             PROTO_SLOT_SERIAL
leds                PROTO_SLOT_LEDS
setserial           PROTO_SLOT_SETSERIAL
reboot              PROTO_SLOT_REBOOT
ilm-info-set        PROTO_SLOT_ILM_STATION_INFO_SET
ilm-e-info-set      PROTO_SLOT_ILM_STATION_INFO_SET
ilm-info-get        PROTO_SLOT_ILM_STATION_INFO_GET
ilm-e-info-get      PROTO_SLOT_ILM_STATION_INFO_GET
ilm-test            PROTO_SLOT_ILM_INSULATE_TEST
ilm-e-test          PROTO_SLOT_ILM_INSULATE_TEST
ilm-result-set      PROTO_SLOT_ILM_INSULATE_RES_SET
ilm-e-result-set    PROTO_SLOT_ILM_INSULATE_RES_SET
ilm-result-get      PROTO_SLOT_ILM_INSULATE_RES_GET
ilm-e-result-get    PROTO_SLOT_ILM_INSULATE_RES_GET
ilm-status-get      PROTO_SLOT_ILM_INSULATE_STATUS
ilm-e-status-get    PROTO_SLOT_ILM_INSULATE_STATUS
ilm-advt-tpwu       PROTO_SLOT_ILM_ADVERT_TPWU_POS
ilm-e-advt-tpwu     PROTO_SLOT_ILM_ADVERT_TPWU_POS
ilm-conf-get        PROTO_SLOT_ILM_CONFIG_GET
ilm-e-conf-get      PROTO_SLOT_ILM_CONFIG_GET
gdm-test            PROTO_SLOT_GDM_RSST_TEST
gdm-revision-set    PROTO_SLOT_GDM_RSST_REVISON_SET
gdm-revision-get    PROTO_SLOT_GDM_RSST_REVISON_GET
tpwu-250v-set       PROTO_SLOT_TPWU_250V_SET
tpwu-250v-status    PROTO_SLOT_TPWU_250V_STATUS
EOF
}

test_slotd_script() {
  echo "serial" >script
  output="$($SLOTD -f script)"
  status=$?
  assertTrue "$SLOTD script @ret:${status} @output:${output}" "${status}"
  assertContains "$SLOTD script @output:${output}" "${output}" "@mcu@"
  rm script
}

suite_slotd_self() {
  echo "serial" >script
  while read -r content argument; do
    output="$($SLOTD ${argument})"
    status=$?
    assertTrue "$SLOTD ${argument} @ret:${status} @output:${output}" "${status}"
    assertContains "$SLOTD ${argument} @output:${output}" "${output}" "${content}"
  done <<EOF
xianleidi  -v
xianleidi  config
enable     debug 1
disable    debug 0
@mcu@      -f script
EOF
  rm script
}

#### hostd test for protocol ####
######## protocol [ilm]     ########
test_slotd_serial_all_slots() {
  output="$($SLOTD serial)"
  status=$?
  assertTrue "$SLOTD serial @ret:${status} @output:${output}" "${status}"
  assertContains "$SLOTD serial @output:${output}" "${output}" "serial"
  assertContains "$SLOTD serial @output:${output}" "${output}" "status"
}

test_slotd_serial_ilm_slot() {
  [ -z "${ILM_SLOT:-}" ] && startSkipping
  output="$($SLOTD serial "${ILM_SLOT}")"
  status=$?
  assertTrue "$SLOTD serial ${ILM_SLOT} @ret:${status} @output:${output}" "${status}"
  assertContains "$SLOTD serial ${ILM_SLOT} @output:${output}" "${output}" "serial"
  assertContains "$SLOTD serial ${ILM_SLOT} @output:${output}" "${output}" "ilm"
}

test_slotd_serial_ilm_e_slot() {
  [ -z "${ILM_E_SLOT:-}" ] && startSkipping
  output="$($SLOTD serial "${ILM_E_SLOT}")"
  status=$?
  assertTrue "$SLOTD serial ${ILM_E_SLOT} @ret:${status} @output:${output}" "${status}"
  assertContains "$SLOTD serial ${ILM_E_SLOT} @output:${output}" "${output}" "serial"
  assertContains "$SLOTD serial ${ILM_E_SLOT} @output:${output}" "${output}" "ilm"
}

test_slotd_version_all_slots() {
  output="$($SLOTD version)"
  status=$?
  assertTrue "$SLOTD version @ret:${status} @output:${output}" "${status}"
  assertContains "$SLOTD version @output:${output}" "${output}" "hardware"
  assertContains "$SLOTD version @output:${output}" "${output}" "software"
}

test_slotd_version_ilm_slots() {
  [ -z "${ILM_SLOT:-}" ] && startSkipping
  output="$($SLOTD version "${ILM_SLOT}")"
  status=$?
  assertTrue "$SLOTD version ${ILM_SLOT} @ret:${status} @output:${output}" "${status}"
  assertContains "$SLOTD version ${ILM_SLOT} @output:${output}" "${output}" "hardware"
  assertContains "$SLOTD version ${ILM_SLOT} @output:${output}" "${output}" "ilm"
}

test_slotd_version_ilm_e_slots() {
  [ -z "${ILM_E_SLOT:-}" ] && startSkipping
  output="$($SLOTD version "${ILM_E_SLOT}")"
  status=$?
  assertTrue "$SLOTD version ${ILM_E_SLOT} @ret:${status} @output:${output}" "${status}"
  assertContains "$SLOTD version ${ILM_E_SLOT} @output:${output}" "${output}" "hardware"
  assertContains "$SLOTD version ${ILM_E_SLOT} @output:${output}" "${output}" "ilm"
}

test_slotd_leds_all_slots() {
  output="$($SLOTD leds)"
  status=$?
  assertTrue "$SLOTD leds @ret:${status} @output:${output}" "${status}"
  assertContains "$SLOTD leds @output:${output}" "${output}" "count"
  assertContains "$SLOTD leds @output:${output}" "${output}" "leds"
}

test_slotd_leds_ilm_slots() {
  [ -z "${ILM_SLOT:-}" ] && startSkipping
  output="$($SLOTD leds "${ILM_SLOT}")"
  status=$?
  assertEquals "$SLOTD leds ${ILM_SLOT} @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$SLOTD leds ${ILM_SLOT} @output:${output}" "${output}" "ilm"
  assertContains "$SLOTD leds ${ILM_SLOT} @output:${output}" "${output}" "leds"
}

test_slotd_leds_ilm_e_slots() {
  [ -z "${ILM_E_SLOT:-}" ] && startSkipping
  output="$($SLOTD leds "${ILM_E_SLOT}")"
  status=$?
  assertEquals "$SLOTD leds ${ILM_E_SLOT} @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$SLOTD leds ${ILM_E_SLOT} @output:${output}" "${output}" "ilm"
  assertContains "$SLOTD leds ${ILM_E_SLOT} @output:${output}" "${output}" "leds"
}

suite_common_table() {
  while read -r content1 content2 argument; do
    output="$($SLOTD ${argument})"
    status=$?
    assertTrue "$SLOTD ${argument} @ret:${status} @output:${output}" "${status}"
    assertContains "$SLOTD ${argument} @output:${output}" "${output}" "${content1}"
    assertContains "$SLOTD ${argument} @output:${output}" "${output}" "${content2}"
  done <<EOF
serial      ilm         serial
hardware    ilm         version
ilm         leds        leds
EOF
}

suite_common_ilm_table() {
  [ -z "${ILM_SLOT:-}" ] && startSkipping
  while read -r content1 content2 argument; do
    output="$($SLOTD ${argument} ${ILM_SLOT})"
    status=$?
    assertTrue "$SLOTD ${argument} ${ILM_SLOT} @ret:${status} @output:${output}" "${status}"
    assertContains "$SLOTD ${argument} ${ILM_SLOT} @output:${output}" "${output}" "${content1}"
    assertContains "$SLOTD ${argument} ${ILM_SLOT} @output:${output}" "${output}" "${content2}"
  done <<EOF
serial      status      serial
hardware    software    version
count       leds        leds
EOF
}

suite_common_ilm_e_table() {
  [ -z "${ILM_E_SLOT:-}" ] && startSkipping
  while read -r content1 content2 argument; do
    output="$($SLOTD ${argument} ${ILM_E_SLOT})"
    status=$?
    assertTrue "$SLOTD ${argument} ${ILM_E_SLOT} @ret:${status} @output:${output}" "${status}"
    assertContains "$SLOTD ${argument} ${ILM_E_SLOT} @output:${output}" "${output}" "${content1}"
    assertContains "$SLOTD ${argument} ${ILM_E_SLOT} @output:${output}" "${output}" "${content2}"
  done <<EOF
serial      status      serial
hardware    software    version
count       leds        leds
EOF
}

######## protocol [ilm]     ########
#### ilm-info-set slot direct count distances ...
test_slotd_ILM_info_set() {
  [ -z "${ILM_SLOT:-}" ] && startSkipping
  # direct 1
  output="$($SLOTD ilm-info-set "${ILM_SLOT}" 1 6 3 4 5 3 4 5)"
  status=$?

  assertTrue "$SLOTD ilm-info-set ${ILM_SLOT} 1 6 3 4 5 3 4 5 @ret:${status} @output:${output}" "${status}"
  assertContains "$SLOTD ilm-info-set ${ILM_SLOT} 1 6 3 4 5 3 4 5 @output:${output}" "${output}" "ilm"
  assertContains "$SLOTD ilm-info-set ${ILM_SLOT} 1 6 3 4 5 3 4 5 @output:${output}" "${output}" "direct"

  # direct 2
  output="$($SLOTD ilm-info-set "${ILM_SLOT}" 2 6 3 4 5 3 4 5)"
  status=$?

  assertTrue "$SLOTD ilm-info-set ${ILM_SLOT} 2 6 3 4 5 3 4 5 @ret:${status} @output:${output}" "${status}"
  assertContains "$SLOTD ilm-info-set ${ILM_SLOT} 2 6 3 4 5 3 4 5 @output:${output}" "${output}" "ilm"
  assertContains "$SLOTD ilm-info-set ${ILM_SLOT} 2 6 3 4 5 3 4 5 @output:${output}" "${output}" "direct"

  # direct 3
  output="$($SLOTD ilm-info-set "${ILM_SLOT}" 3 6 3 4 5 3 4 5)"
  status=$?

  assertTrue "$SLOTD ilm-info-set ${ILM_SLOT} 3 6 3 4 5 3 4 5 @ret:${status} @output:${output}" "${status}"
  assertContains "$SLOTD ilm-info-set ${ILM_SLOT} 3 6 3 4 5 3 4 5 @output:${output}" "${output}" "ilm"
  assertContains "$SLOTD ilm-info-set ${ILM_SLOT} 3 6 3 4 5 3 4 5 @output:${output}" "${output}" "direct"

  # direct 4
  output="$($SLOTD ilm-info-set "${ILM_SLOT}" 4 6 3 4 5 3 4 5)"
  status=$?

  assertTrue "$SLOTD ilm-info-set ${ILM_SLOT} 4 6 3 4 5 3 4 5 @ret:${status} @output:${output}" "${status}"
  assertContains "$SLOTD ilm-info-set ${ILM_SLOT} 4 6 3 4 5 3 4 5 @output:${output}" "${output}" "ilm"
  assertContains "$SLOTD ilm-info-set ${ILM_SLOT} 4 6 3 4 5 3 4 5 @output:${output}" "${output}" "direct"
}

test_slotd_ILM_e_info_set() {
  [ -z "${ILM_E_SLOT:-}" ] && startSkipping
  # direct 1
  while read -r direct stations station_array; do
    output="$($SLOTD ilm-e-info-set ${ILM_E_SLOT} ${direct} ${stations} ${station_array})"
    status=$?
    assertTrue "$SLOTD ilm-e-info-set ${ILM_E_SLOT} ${direct} ${stations} ${station_array} @ret:${status} @output:${output}" "${status}"
    assertContains "$SLOTD ilm-e-info-set ${ILM_E_SLOT} ${direct} ${stations} ${station_array}@output:${output}" "${output}" "ilm_e"
    assertContains "$SLOTD ilm-e-info-set ${ILM_E_SLOT} ${direct} ${stations} ${station_array}@output:${output}" "${output}" "direct"
  done <<EOF
1 6     3 4 5 3 4 5
2 6     3 4 5 3 4 5
3 6     3 4 5 3 4 5
4 6     3 4 5 3 4 5
EOF
}

test_slotd_ILM_info_get() {
  [ -z "${ILM_SLOT:-}" ] && startSkipping
  # direct 1
  output="$($SLOTD ilm-info-get "${ILM_SLOT}" 1)"
  status=$?

  assertEquals "$SLOTD ilm-info-get ${ILM_SLOT} 1 @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$SLOTD ilm-info-get ${ILM_SLOT} 1 @output:${output}" "${output}" "ilm"
  assertContains "$SLOTD ilm-info-get ${ILM_SLOT} 1 @output:${output}" "${output}" "distances"

  # direct 2
  output="$($SLOTD ilm-info-get "${ILM_SLOT}" 2)"
  status=$?

  assertEquals "$SLOTD ilm-info-get ${ILM_SLOT} 2 @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$SLOTD ilm-info-get ${ILM_SLOT} 2 @output:${output}" "${output}" "ilm"
  assertContains "$SLOTD ilm-info-get ${ILM_SLOT} 2 @output:${output}" "${output}" "distances"

  # direct 3
  output="$($SLOTD ilm-info-get "${ILM_SLOT}" 3)"
  status=$?

  assertEquals "$SLOTD ilm-info-get ${ILM_SLOT} 3 @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$SLOTD ilm-info-get ${ILM_SLOT} 3 @output:${output}" "${output}" "ilm"
  assertContains "$SLOTD ilm-info-get ${ILM_SLOT} 3 @output:${output}" "${output}" "distances"

  # direct 4
  output="$($SLOTD ilm-info-get "${ILM_SLOT}" 4)"
  status=$?

  assertEquals "$SLOTD ilm-info-get ${ILM_SLOT} 4 @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$SLOTD ilm-info-get ${ILM_SLOT} 4 @output:${output}" "${output}" "ilm"
  assertContains "$SLOTD ilm-info-get ${ILM_SLOT} 4 @output:${output}" "${output}" "distances"
}

test_slotd_ILM_e_info_get() {
  [ -z "${ILM_E_SLOT:-}" ] && startSkipping
  # direct 1
  while read -r direct stations station_array; do
    output="$($SLOTD ilm-e-info-get ${ILM_E_SLOT} ${direct})"
    status=$?
    assertTrue "$SLOTD ilm-e-info-get ${ILM_E_SLOT} ${direct}@ret:${status} @output:${output}" "${status}"
    assertContains "$SLOTD ilm-e-info-get ${ILM_E_SLOT} ${direct} @output:${output}" "${output}" "ilm_e"
    assertContains "$SLOTD ilm-e-info-get ${ILM_E_SLOT} ${direct} @output:${output}" "${output}" "direct"
    assertContains "$SLOTD ilm-e-info-get ${ILM_E_SLOT} ${direct} @output:${output}" "${output}" "${station_array}"
  done <<EOF
1 6     3 4 5 3 4 5
2 6     3 4 5 3 4 5
3 6     3 4 5 3 4 5
4 6     3 4 5 3 4 5
EOF
}

test_slotd_ILM_result_set() {
  [ -z "${ILM_SLOT:-}" ] && startSkipping
  startSkipping # implemented at mcu card
  # direct 1
  output="$($SLOTD ilm-result-set "${ILM_SLOT}" 1 6 4.22 5.23 6.12 4.22 5.23 6.12)"
  status=$?

  assertEquals "$SLOTD ilm-result-set ${ILM_SLOT} 1 6 4.22 5.23 6.12 4.22 5.23 6.12 @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$SLOTD ilm-result-set ${ILM_SLOT} 1 6 4.22 5.23 6.12 4.22 5.23 6.12 @output:${output}" "${output}" "ilm"
  assertContains "$SLOTD ilm-result-set ${ILM_SLOT} 1 6 4.22 5.23 6.12 4.22 5.23 6.12 @output:${output}" "${output}" "direct"

  # direct 2
  output="$($SLOTD ilm-result-set "${ILM_SLOT}" 2 6 4.22 5.23 6.12 4.22 5.23 6.12)"
  status=$?

  assertEquals "$SLOTD ilm-result-set ${ILM_SLOT} 2 6 4.22 5.23 6.12 4.22 5.23 6.12 @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$SLOTD ilm-result-set ${ILM_SLOT} 2 6 4.22 5.23 6.12 4.22 5.23 6.12 @output:${output}" "${output}" "ilm"
  assertContains "$SLOTD ilm-result-set ${ILM_SLOT} 2 6 4.22 5.23 6.12 4.22 5.23 6.12 @output:${output}" "${output}" "direct"

  # direct 3
  output="$($SLOTD ilm-result-set "${ILM_SLOT}" 3 6 4.22 5.23 6.12 4.22 5.23 6.12)"
  status=$?

  assertEquals "$SLOTD ilm-result-set ${ILM_SLOT} 3 6 4.22 5.23 6.12 4.22 5.23 6.12 @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$SLOTD ilm-result-set ${ILM_SLOT} 3 6 4.22 5.23 6.12 4.22 5.23 6.12 @output:${output}" "${output}" "ilm"
  assertContains "$SLOTD ilm-result-set ${ILM_SLOT} 3 6 4.22 5.23 6.12 4.22 5.23 6.12 @output:${output}" "${output}" "direct"

  # direct 4
  output="$($SLOTD ilm-result-set "${ILM_SLOT}" 4 6 4.22 5.23 6.12 4.22 5.23 6.12)"
  status=$?

  assertEquals "$SLOTD ilm-result-set ${ILM_SLOT} 4 6 4.22 5.23 6.12 4.22 5.23 6.12 @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$SLOTD ilm-result-set ${ILM_SLOT} 4 6 4.22 5.23 6.12 4.22 5.23 6.12 @output:${output}" "${output}" "ilm"
  assertContains "$SLOTD ilm-result-set ${ILM_SLOT} 4 6 4.22 5.23 6.12 4.22 5.23 6.12 @output:${output}" "${output}" "direct"
}

test_slotd_ILM_result_get() {
  [ -z "${ILM_SLOT:-}" ] && startSkipping
  startSkipping # implemented at mcu card
  # direct 1
  output="$($SLOTD ilm-result-get "${ILM_SLOT}" 1)"
  status=$?

  assertEquals "$SLOTD ilm-result-get ${ILM_SLOT} 1 @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$SLOTD ilm-result-get ${ILM_SLOT} 1 @output:${output}" "${output}" "ilm"
  assertContains "$SLOTD ilm-result-get ${ILM_SLOT} 1 @output:${output}" "${output}" "rssts"

  # direct 2
  output="$($SLOTD ilm-result-get "${ILM_SLOT}" 2)"
  status=$?

  assertEquals "$SLOTD ilm-result-get ${ILM_SLOT} 2 @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$SLOTD ilm-result-get ${ILM_SLOT} 2 @output:${output}" "${output}" "ilm"
  assertContains "$SLOTD ilm-result-get ${ILM_SLOT} 2 @output:${output}" "${output}" "rssts"

  # direct 2
  output="$($SLOTD ilm-result-get "${ILM_SLOT}" 3)"
  status=$?

  assertEquals "$SLOTD ilm-result-get ${ILM_SLOT} 3 @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$SLOTD ilm-result-get ${ILM_SLOT} 3 @output:${output}" "${output}" "ilm"
  assertContains "$SLOTD ilm-result-get ${ILM_SLOT} 3 @output:${output}" "${output}" "rssts"

  # direct 2
  output="$($SLOTD ilm-result-get "${ILM_SLOT}" 4)"
  status=$?

  assertEquals "$SLOTD ilm-result-get ${ILM_SLOT} 4 @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$SLOTD ilm-result-get ${ILM_SLOT} 4 @output:${output}" "${output}" "ilm"
  assertContains "$SLOTD ilm-result-get ${ILM_SLOT} 4 @output:${output}" "${output}" "rssts"
}

test_slotd_ILM_advt_tpwu() {
  [ -z "${ILM_SLOT:-}" ] && startSkipping
  output="$($SLOTD ilm-advt-tpwu "${ILM_SLOT}" "${TPWU_SLOT}")"
  status=$?

  assertEquals "$SLOTD ilm-advt-tpwu ${ILM_SLOT} ${TPWU_SLOT} @ret:${status} @output:${output}" 0 "${status}"
  assertContains "$SLOTD ilm-advt-tpwu ${ILM_SLOT} ${TPWU_SLOT} @output:${output}" "${output}" "tpwu"
}

test_slotd_ILM_e_advt_tpwu() {
  [ -z "${ILM_E_SLOT:-}" ] && startSkipping
  output="$($SLOTD ilm-e-advt-tpwu "${ILM_E_SLOT}" "${TPWU_SLOT}")"
  status=$?

  assertTrue "$SLOTD ilm-e-advt-tpwu ${ILM_E_SLOT} ${TPWU_SLOT} @ret:${status} @output:${output}" "${status}"
  assertContains "$SLOTD ilm-e-advt-tpwu ${ILM_E_SLOT} ${TPWU_SLOT} @output:${output}" "${output}" "tpwu"
}

test_slotd_ILM_status_get() {
  [ -z "${ILM_SLOT:-}" ] && startSkipping
  output="$($SLOTD ilm-status-get "${ILM_SLOT}")"
  status=$?

  assertTrue "$SLOTD ilm-status-get ${ILM_SLOT} @ret:${status} @output:${output}" "${status}"
  assertContains "$SLOTD ilm-status-get ${ILM_SLOT} @output:${output}" "${output}" "ilm"
}

test_slotd_ILM_e_status_get() {
  [ -z "${ILM_E_SLOT:-}" ] && startSkipping
  output="$($SLOTD ilm-e-status-get "${ILM_E_SLOT}")"
  status=$?

  assertTrue "$SLOTD ilm-e-status-get ${ILM_E_SLOT} @ret:${status} @output:${output}" "${status}"
  assertContains "$SLOTD ilm-e-status-get ${ILM_E_SLOT} @output:${output}" "${output}" "ilm_e"
}

test_slotd_ILM_conf_get() {
  [ -z "${ILM_SLOT:-}" ] && startSkipping
  output="$($SLOTD ilm-conf-get "${ILM_SLOT}")"
  status=$?

  assertTrue "$SLOTD ilm-conf-get ${ILM_SLOT} @ret:${status} @output:${output}" "${status}"
  assertContains "$SLOTD ilm-conf-get ${ILM_SLOT} @output:${output}" "${output}" "direct"
}

test_slotd_ILM_e_conf_get() {
  [ -z "${ILM_E_SLOT:-}" ] && startSkipping
  output="$($SLOTD ilm-e-conf-get "${ILM_E_SLOT}")"
  status=$?

  assertTrue "$SLOTD ilm-e-conf-get ${ILM_E_SLOT} @ret:${status} @output:${output}" "${status}"
  assertContains "$SLOTD ilm-e-conf-get ${ILM_E_SLOT} @output:${output}" "${output}" "direct"
}

######## protocol [GDM]     ########
test_slotd_GDM_test() {
  [ -z "${GDM_SLOT:-}" ] && startSkipping
  output="$($SLOTD gdm-test "${GDM_SLOT}")"
  status=$?

  assertTrue "$SLOTD gdm-test ${GDM_SLOT} @ret:${status} @output:${output}" "${status}"
  assertContains "$SLOTD gdm-test ${GDM_SLOT} @ret:${status} @output:${output}" 0 "rsst"
}

test_slotd_GDM_revision_set() {
  [ -z "${GDM_SLOT:-}" ] && startSkipping
  output="$($SLOTD gdm-revision-set "${GDM_SLOT}" 0.15)"
  status=$?

  assertTrue "$SLOTD gdm-revision-set ${GDM_SLOT} 0.15 @ret:${status} @output:${output}" "${status}"
  assertContains "$SLOTD gdm-revision-set ${GDM_SLOT} 0.15 @output:${output}" "${output}" "rsst"
}

test_slotd_GDM_revision_get() {
  [ -z "${GDM_SLOT:-}" ] && startSkipping
  output="$($SLOTD gdm-revision-get "${GDM_SLOT}")"
  status=$?

  assertTrue "$SLOTD gdm-revision-get ${GDM_SLOT} @ret:${status} @output:${output}" "${status}"
  assertContains "$SLOTD gdm-revision-get ${GDM_SLOT} @output:${output}" "${output}" "rsst"
}

######## protocol [TPWU]     ########
test_slotd_TPWU_250v_set() {
  [ -z "${TPWU_SLOT:-}" ] && startSkipping
  output="$($SLOTD tpwu-250v-set "${TPWU_SLOT}" 1)"
  status=$?

  assertTrue "$SLOTD tpwu-250v-set ${TPWU_SLOT} 1 @ret:${status} @output:${output}" "${status}"
  assertContains "$SLOTD tpwu-250v-set ${TPWU_SLOT} 1 @output:${output}" "${output}" "enable"

  output="$($SLOTD tpwu-250v-set "${TPWU_SLOT}" 0)"
  status=$?

  assertTrue "$SLOTD tpwu-250v-set ${TPWU_SLOT} 0 @ret:${status} @output:${output}" "${status}"
  assertContains "$SLOTD tpwu-250v-set ${TPWU_SLOT} 0 @output:${output}" "${output}" "enable"
}

test_slotd_TPWU_250v_status() {
  [ -z "${TPWU_SLOT:-}" ] && startSkipping
  output="$($SLOTD tpwu-250v-status "${TPWU_SLOT}")"
  status=$?

  assertTrue "$SLOTD tpwu-250v-status ${TPWU_SLOT} @ret:${status} @output:${output}" "${status}"
  assertContains "$SLOTD tpwu-250v-status ${TPWU_SLOT} @output:${output}" "${output}" "enable"
}

suite() {
  : suite_addTest suite_slotd_self
  : suite_addTest suite_common_table
  : suite_addTest suite_common_ilm_table
  : suite_addTest suite_common_ilm_e_table
}

. ./shunit2
