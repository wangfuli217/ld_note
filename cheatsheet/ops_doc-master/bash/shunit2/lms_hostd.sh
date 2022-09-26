

# data-driven-test
test_hostd_self(){
  echo "serial" >script
  while read -r want argument; do
    output="$($RTUCLIENT $argument 2>&1)"
    assertTrue      "$RTUCLIENT $argument @ret:${status} @output:${output}" "${status}"
    assertContains  "$RTUCLIENT $argument @output:${output}" "${output}" "${want}"
  done <<'EOF'
xianleidi  -v
xianleidi  config
serial     -f script
info       conn-info
enable     debug 1
disable    debug 0
1000       test-timeout
value      cfg-default
EOF
rm script
}


# data-driven-test
test_hostd_mcu(){
  while read -r want argument; do
    output="$($RTUCLIENT $argument 2>&1)"
    assertTrue      "$RTUCLIENT $argument @ret:${status} @output:${output}" "${status}"
    assertContains  "$RTUCLIENT $argument @output:${output}" "${output}" "${want}"
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

test_ILM_station_info_set_slot_valid_table() {
  [ -z "${ILM_SLOT:-}" ] && startSkipping
  
  while read -r direct stations station_array; do
    output="$($RTUCLIENT ilm-info-set "${ILM_SLOT}" "${direct}" "${stations}" "${station_array}" 2>&1)"
    status=$?
    assertTrue     "$RTUCLIENT ilm-info-set $ILM_SLOT ${direct} ${stations} ${station_array} @ret:${status} @output:${output}" "${status}"
    # or
    assertEquals   "$RTUCLIENT ilm-info-set $ILM_SLOT ${direct} ${stations} ${station_array} @ret:${status} @output:${output}" 0 "${status}"
    assertContains "$RTUCLIENT ilm-info-set $ILM_SLOT ${direct} ${stations} ${station_array} @output:${output}" "${output}" "ilm-info-set"
  done <<EOF
1  5  ${ILM_INFO15}
2  6  ${ILM_INFO26}
3  7  ${ILM_INFO37}
4  8  ${ILM_INFO48}
EOF
}

test_ILM_E_station_info_set_slot_valid_table() {
  [ -z "${ILM_E_SLOT:-}" ] && startSkipping
  while read -r direct stations station_array; do
    output="$($RTUCLIENT ilm-info-set "${ILM_SLOT}" "${direct}" "${stations}" "${station_array}" 2>&1)"
    status=$?
    assertTrue      "$RTUCLIENT ilm-info-set $ILM_SLOT ${direct} ${stations} ${station_array} @ret:${status} @output:${output}" "${status}"
    # or
    assertEquals    "$RTUCLIENT ilm-info-set $ILM_SLOT ${direct} ${stations} ${station_array} @ret:${status} @output:${output}" 0 "${status}"
    assertContains  "$RTUCLIENT ilm-info-set $ILM_SLOT ${direct} ${stations} ${station_array} @output:${output}" "${output}" "ilm-info-set"
  done <<EOF
5  5  ${ILM_INFO15}
6  6  ${ILM_INFO26}
7  7  ${ILM_INFO37}
8  8  ${ILM_INFO48}
EOF
}

