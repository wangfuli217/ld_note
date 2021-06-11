#!/usr/bin/env bats
#
# depend on https://github.com/sstephenson/bats
#

load test_helper

@test "no arguments connectting to localhost" {
  run hostd
  [ $status -eq 255 ]
  [ $( echo $output | grep failure -c ) -ne 0 ]
}

@test "-v and --version print version number" {
  run hostd -v
  [ $status -eq 0 ]
  [ $( echo $output | grep "hostd version" -c ) -ne 0 ]
}

@test "hostd_config - get hostd default config" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" hostd_config
  [ $status -eq 0 ]
  [ $( echo $output | grep "hostd version" -c ) -ne 0 ]
}

@test "otdr_param - get hostd suggestion otdr param" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" otdr_param
  [ $status -eq 0 ]
  [ $( echo $output | grep "suggestion" -c ) -ne 0 ]
}

@test "rtu_conf - get rtu slot card information" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" rtu_conf
  [ $status -eq 0 ]
}

@test "rtu_leds - get rtu slot card led status" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" rtu_leds
  [ $status -eq 0 ]
}

@test "mem_get - get mcu memory information" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" mem_get
  [ $status -eq 0 ]
}

@test "ols_cfg_set - slotid=$OSL_SLOT port=1 enable=0" {
    if [ "x$OSL_SLOT" = "x" ]; then
        skip "ols slot noexist"
    fi
    run hostd -h "$RTU_HOST" -p "$RTU_PORT" ols_cfg_set $OSL_SLOT 1 0
    [ $status -eq 0 ]
    [ $( echo $output | grep "enable:0" -c ) -ne 0 ]
}

@test "ols_cfg_set - slotid=$OSL_SLOT port=1 enable=1" {
    if [ "x$OSL_SLOT" = "x" ]; then
        skip "ols slot noexist"
    fi
    run hostd -h "$RTU_HOST" -p "$RTU_PORT" ols_cfg_set $OSL_SLOT 1 1
    [ $status -eq 0 ]
    [ $( echo $output | grep "enable:1" -c ) -ne 0 ]
}

@test "ols_cfg_set - <-invalid->slotid=$[OSL_SLOT+1] port=1 enable=0" {
    if [ "x$OSL_SLOT" = "x" ]; then
        skip "ols slot noexist"
    fi
    run hostd -h "$RTU_HOST" -p "$RTU_PORT" ols_cfg_set $[OSL_SLOT+1] 1 0
    [ $status -eq 255 ]
    [ $( echo $output | grep "slotid invalid" -c ) -ne 0 ]
}

@test "ols_cfg_set - slotid=$OSL_SLOT <-invalid->port=0 enable=0" {
    if [ "x$OSL_SLOT" = "x" ]; then
        skip "ols slot noexist"
    fi
    run hostd -h "$RTU_HOST" -p "$RTU_PORT" ols_cfg_set $OSL_SLOT 0 0
    [ $status -eq 255 ]
    [ $( echo $output | grep "port invalid" -c ) -ne 0 ]
}

@test "ols_cfg_set - slotid=$OSL_SLOT <-invalid->port=$[OSL_PORTS+1] enable=0" {
    if [ "x$OSL_SLOT" = "x" ]; then
        skip "ols slot noexist"
    fi
    run hostd -h "$RTU_HOST" -p "$RTU_PORT" ols_cfg_set $OSL_SLOT $[OSL_PORTS+1] 0
    [ $status -eq 255 ]
    [ $( echo $output | grep "port invalid" -c ) -ne 0 ]
}

@test "ols_cfg_get - slotid=$OSL_SLOT" {
    if [ "x$OSL_SLOT" = "x" ]; then
        skip "ols slot noexist"
    fi
    run hostd -h "$RTU_HOST" -p "$RTU_PORT" ols_cfg_get $OSL_SLOT
    [ $status -eq 0 ]
    [ $( echo $output | grep "enable" -c ) -ne 0 ]
}

@test "ols_cfg_get - get all slotid" {
    if [ "x$OSL_SLOT" = "x" ]; then
        skip "ols slot noexist"
    fi
    run hostd -h "$RTU_HOST" -p "$RTU_PORT" ols_cfg_get
    [ $status -eq 0 ]
    [ $( echo $output | grep "enable" -c ) -ne 0 ]
}

@test "ols_cfg_get - <-invalid->slotid=$[OSL_SLOT+1]" {
    if [ "x$OSL_SLOT" = "x" ]; then
        skip "ols slot noexist"
    fi
    run hostd -h "$RTU_HOST" -p "$RTU_PORT" ols_cfg_get $[OSL_SLOT+1]
    [ $status -eq 255 ]
    [ $( echo $output | grep "slotid invalid" -c ) -ne 0 ]
}

@test "fib_osw_set - fiber=1 slot=$OSW_SLOT port=1 distance=500 pluse=5 wave=1625 avg=100 ior=1.476" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT"  fib_osw_set 1 1 $OSW_SLOT 1 500 5 1625 100 1.476000
  [ $status -eq 0 ]
}

@test "fib_osw_set - fiber=2 slot=$OSW_SLOT port=2 distance=15000 pluse=275 wave=1625 avg=100 ior=1.476" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_osw_set 2 1 $OSW_SLOT 2 15000 275 1625 100 1.476000
  [ $status -eq 0 ]
}

@test "fib_osw_set - <-invalid-> fiber=0 slot=$OSW_SLOT port=1 distance=500 pluse=5 wave=1625 avg=100 ior=1.476 " {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_osw_set 0 1 $OSW_SLOT 1 500 5 1625 100 1.476000
  [ $status -eq 255 ]
  [ $( echo $output | grep "fibreid invalid" -c ) -ne 0 ]
}

@test "fib_osw_set - <-invalid-> fiber=65 slot=$OSW_SLOT port=1 distance=500 pluse=5 wave=1625 avg=100 ior=1.476 " {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_osw_set 65 1 $OSW_SLOT 1 500 5 1625 100 1.476000
  [ $status -eq 255 ]
  [ $( echo $output | grep "fibreid invalid" -c ) -ne 0 ]
}

@test "fib_osw_set - fiber=1 <-invalid-> slot=$[OSW_SLOT+1] port=1 distance=500 pluse=5 wave=1625 avg=100 ior=1.476 " {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_osw_set 1 1 $[OSW_SLOT+1] 1 500 5 1625 100 1.476000
  [ $status -eq 255 ]
  [ $( echo $output | grep "slotid invalid" -c ) -ne 0 ]
}

@test "fib_osw_set - fiber=1 slot=$OSW_SLOT <-invalid-> port=0 distance=500 pluse=5 wave=1625 avg=100 ior=1.476 " {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_osw_set 1 1 $OSW_SLOT 0 500 5 1625 100 1.476000
  [ $status -eq 255 ]
  [ $( echo $output | grep "port invalid" -c ) -ne 0 ]
}

@test "fib_osw_set - fiber=1 slot=$OSW_SLOT <-invalid-> port=$[OSW_PORTS+1] distance=500 pluse=5 wave=1625 avg=100 ior=1.476 " {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_osw_set 1 1 $OSW_SLOT $[OSW_PORTS+1] 500 5 1625 100 1.476000
  [ $status -eq 255 ]
  [ $( echo $output | grep "port invalid" -c ) -ne 0 ]
}

@test "fib_osw_set - fiber=1 slot=$OSW_SLOT port=1 <-invalid-> distance=100 pluse=5 wave=1625 avg=100 ior=1.476 " {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_osw_set 1 1 $OSW_SLOT 1 100 5 1625 100 1.476000
  [ $status -eq 255 ]
  [ $( echo $output | grep "argument invalid" -c ) -ne 0 ]
}

@test "fib_osw_set - fiber=1 slot=$OSW_SLOT port=1 distance=500 <-invalid-> pluse=7 wave=1625 avg=100 ior=1.476 " {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_osw_set 1 1 $OSW_SLOT 1 500 7 1625 100 1.476000
  [ $status -eq 255 ]
  [ $( echo $output | grep "argument invalid" -c ) -ne 0 ]
}

@test "fib_osw_set - fiber=1 slot=$OSW_SLOT port=1 distance=500 pluse=5 <-invalid-> wave=1350 avg=100 ior=1.476 " {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_osw_set 1 1 $OSW_SLOT 1 500 5 1350 100 1.476000
  [ $status -eq 255 ]
  [ $( echo $output | grep "argument invalid" -c ) -ne 0 ]
}

@test "fib_osw_set - fiber=1 slot=$OSW_SLOT port=1 distance=500 pluse=5 wave=1625 <-invalid-> avg=10000 ior=1.476 " {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_osw_set 1 1 $OSW_SLOT 1 500 5 1625 10000 1.476000
  [ $status -eq 255 ]
  [ $( echo $output | grep "argument invalid" -c ) -ne 0 ]
}

@test "fib_osw_get - get all fiber configuration" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_osw_get
  [ $status -eq 0 ]
}

@test "fib_osw_get - <-invalid-> fiberid=0" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_osw_get 0
  [ $status -eq 255 ]
  [ $( echo $output | grep "request fibreid invalid" -c ) -ne 0 ]
}

@test "fib_osw_get - <-invalid-> fiberid=65" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_osw_get 65
  [ $status -eq 255 ]
  [ $( echo $output | grep "request fibreid invalid" -c ) -ne 0 ]
}

@test "fib_osw_get - get fiber=1 configuration" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_osw_get 1
  [ $status -eq 0 ]
  [ $( echo $output | grep "fiberid:1" -c ) -ne 0 ]
}

@test "fib_osw_get - get fiber=2 configuration" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_osw_get 2
  [ $status -eq 0 ]
  [ $( echo $output | grep "fiberid:2" -c ) -ne 0 ]
}

@test "opm_cfg_set - slotid=$OPM_SLOT port=1 ref=0 threshold1=67 threshold2=67 threshold3=67 nodev=-67 nolight=-67 confirm=100" {
  echo "opm_cfg_set $OPM_SLOT 1 0 67 67 67 -67 -67 100" > .opm_test
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" -s 3000 -r 10000 -f .opm_test
  [ $status -eq 0 ]
  [ $( echo $output | grep "threshold1" -c ) -ne 0 ]
}

@test "opm_cfg_set - slotid=$OPM_SLOT port=2 ref=0 threshold1=67 threshold2=67 threshold3=67 nodev=-67 nolight=-67 confirm=100" {
  echo "opm_cfg_set $OPM_SLOT 2 0 67 67 67 -67 -67 100" > .opm_test
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" -s 3000 -r 10000 -f .opm_test
  [ $status -eq 0 ]
  [ $( echo $output | grep "threshold1" -c ) -ne 0 ]
}

@test "opm_cfg_set - <-invalid-> slotid=$[OPM_SLOT+1] port=1 ref=1.9 threshold1=3.0 threshold2=5.0 threshold3=15.0 nodev=-65 nolight=-65 confirm=100" {
  echo "opm_cfg_set $[OPM_SLOT+1] 1 1.9 3.0 5.0 15.0 -65 -65 100" > .opm_test
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" -f .opm_test
  [ $status -eq 255 ]
  [ $( echo $output | grep "slotid invalid" -c ) -ne 0 ]
}

@test "opm_cfg_set - slotid=$OPM_SLOT <-invalid-> port=0 ref=1.9 threshold1=3.0 threshold2=5.0 threshold3=15.0 nodev=-65 nolight=-65 confirm=100" {
  echo "opm_cfg_set $OPM_SLOT 0 1.9 3.0 5.0 15.0 -65 -65 100" > .opm_test
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" -f .opm_test
  [ $status -eq 255 ]
  [ $( echo $output | grep "port invalid" -c ) -ne 0 ]
}

@test "opm_cfg_set - slotid=$OPM_SLOT <-invalid-> port=$[OPM_PORTS+1] ref=1.9 threshold1=3.0 threshold2=5.0 threshold3=15.0 nodev=-65 nolight=-65 confirm=100" {
  echo "opm_cfg_set $OPM_SLOT $[OPM_PORTS+1] 1.9 3.0 5.0 15.0 -65 -65 100" > .opm_test
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" -f .opm_test
  [ $status -eq 255 ]
  [ $( echo $output | grep "port invalid" -c ) -ne 0 ]
}

@test "opm_cfg_set - slotid=$OPM_SLOT port=1 <-invalid-> ref=-60 threshold1=3.0 threshold2=5.0 threshold3=15.0 nodev=-65 nolight=-65 confirm=100" {
  echo "opm_cfg_set $OPM_SLOT 1 -60 3.0 5.0 15.0 -65 -65 100" > .opm_test
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" -f .opm_test
  [ $status -eq 255 ]
  [ $( echo $output | grep "argument invalid" -c ) -ne 0 ]
}

@test "opm_cfg_set - slotid=$OPM_SLOT port=1 ref=1.9 threshold1=3.0 threshold2=5.0 threshold3=15.0 <-invalid-> nodev=-69 nolight=-65 confirm=100" {
  echo "opm_cfg_set $OPM_SLOT 1 1.9 3.0 5.0 15.0 -69 -65 100" > .opm_test
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" -f .opm_test
  [ $status -eq 255 ]
  [ $( echo $output | grep "argument invalid" -c ) -ne 0 ]
}

@test "opm_cfg_set - slotid=$OPM_SLOT port=1 ref=1.9 threshold1=3.0 threshold2=5.0 threshold3=15.0 nodev=-65 <-invalid-> nolight=-69 confirm=100" {
  echo "opm_cfg_set $OPM_SLOT 1 1.9 3.0 5.0 15.0 -65 -69 100" > .opm_test
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" -f .opm_test
  [ $status -eq 255 ]
  [ $( echo $output | grep "argument invalid" -c ) -ne 0 ]
}

@test "opm_cfg_get - get all opm configuration" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" opm_cfg_get
  [ $status -eq 0 ]
}

@test "opm_cfg_get - slotid=$OPM_SLOT port=1" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" opm_cfg_get $OPM_SLOT 1
  [ $status -eq 0 ]
}

@test "opm_cfg_get - slotid=$OPM_SLOT port=2" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" opm_cfg_get $OPM_SLOT 2
  [ $status -eq 0 ]
}

@test "opm_cfg_get - <-invalid->slotid=$[OPM_SLOT+1] port=1" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" opm_cfg_get $[OPM_SLOT+1] 1
  [ $status -eq 255 ]
  [ $( echo $output | grep "slotid invalid" -c ) -ne 0 ]
}

@test "opm_cfg_get - slotid=$OPM_SLOT <-invalid->port=0" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" opm_cfg_get $OPM_SLOT 0
  [ $status -eq 255 ]
  [ $( echo $output | grep "port invalid" -c ) -ne 0 ]
}

@test "opm_cfg_get - slotid=$OPM_SLOT <-invalid->port=$[OPM_PORTS+1]" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" opm_cfg_get $OPM_SLOT $[OPM_PORTS+1]
  [ $status -eq 255 ]
  [ $( echo $output | grep "port invalid" -c ) -ne 0 ]
}

@test "opm_val_get - slotid=$OPM_SLOT port=1" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" -s 3000 -r 10000 opm_val_get $OPM_SLOT 1
  [ $status -eq 0 ]
}

@test "opm_val_get - slotid=$OPM_SLOT port=2" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" -s 3000 -r 10000 opm_val_get $OPM_SLOT 2
  [ $status -eq 0 ]
}

@test "opm_val_get - <-invalid->slotid=$[OPM_SLOT+1] port=1" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" opm_val_get $[OPM_SLOT+1] 1
  [ $status -eq 255 ]
  [ $( echo $output | grep "slotid invalid" -c ) -ne 0 ]
}

@test "opm_val_get - slotid=$OPM_SLOT <-invalid->port=0" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" opm_val_get $OPM_SLOT 0
  [ $status -eq 255 ]
  [ $( echo $output | grep "port invalid" -c ) -ne 0 ]
}

@test "opm_val_get - slotid=$OPM_SLOT <-invalid->port=$[OPM_PORTS+1]" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" opm_val_get $OPM_SLOT $[OPM_PORTS+1]
  [ $status -eq 255 ]
  [ $( echo $output | grep "port invalid" -c ) -ne 0 ]
}

@test "fib_prd_set - fiberid=1 datetime=2017:05:06-11:12:30 period=720 " {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_prd_set 1 2017:05:06-11:12:30 720
  [ $status -eq 0 ]
}

@test "fib_prd_set - fiberid=2 datetime=$(date "+%Y:%m:%d-%H:%M:%S")[now] period=720 " {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_prd_set 2 720
  [ $status -eq 0 ]
}

@test "fib_prd_set - <-invalid->fiberid=0 datetime=2017:05:06-11:12:30 period=720 " {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_prd_set 0 2017:05:06-11:12:30 720
  [ $status -eq 255 ]
  [ $( echo $output | grep "fibreid invalid" -c ) -ne 0 ]
}

@test "fib_prd_set - <-invalid->fiberid=0 datetime=$(date "+%Y:%m:%d-%H:%M:%S")[now] period=720 " {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_prd_set 0 720
  [ $status -eq 255 ]
  [ $( echo $output | grep "fibreid invalid" -c ) -ne 0 ]
}

@test "fib_prd_set - <-invalid->fiberid=65 datetime=2017:05:06-11:12:30 period=720 " {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_prd_set 65 2017:05:06-11:12:30 720
  [ $status -eq 255 ]
  [ $( echo $output | grep "fibreid invalid" -c ) -ne 0 ]
}

@test "fib_prd_set - <-invalid->fiberid=65 datetime=$(date "+%Y:%m:%d-%H:%M:%S")[now] period=720 " {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_prd_set 65 720
  [ $status -eq 255 ]
  [ $( echo $output | grep "fibreid invalid" -c ) -ne 0 ]
}

@test "fib_prd_get - get all fiber period configuration" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_prd_get
  [ $status -eq 0 ]
}

@test "fib_prd_get - fiberid=1" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_prd_get 1
  [ $status -eq 0 ]
}

@test "fib_prd_get - fiberid=2" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_prd_get 2
  [ $status -eq 0 ]
}

@test "fib_prd_get - <-invalid->fiberid=0" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_prd_get 0
  [ $status -eq 255 ]
  [ $( echo $output | grep "fibreid invalid" -c ) -ne 0 ]
}

@test "fib_prd_get - <-invalid->fiberid=65" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_prd_get 65
  [ $status -eq 255 ]
  [ $( echo $output | grep "fibreid invalid" -c ) -ne 0 ]
}

@test "rpt_adr_set - ipaddr1=192.168.10.100" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" rpt_adr_set 192.168.10.100
  [ $status -eq 0 ]
}

@test "rpt_adr_set - ipaddr1=192.168.10.100 ipaddr2=192.168.10.101 " {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" rpt_adr_set 192.168.10.100 192.168.10.101
  [ $status -eq 0 ]
}

@test "rpt_adr_set - ipaddr1=192.168.10.100 ipaddr2=192.168.10.101 ipaddr3=192.168.10.102" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" rpt_adr_set 192.168.10.100 192.168.10.101 192.168.10.102
  [ $status -eq 0 ]
}

@test "rpt_adr_set - ipaddr1=192.168.10.100 ipaddr2=192.168.10.101 ipaddr3=192.168.10.102 ipaddr4=192.168.10.103" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" rpt_adr_set 192.168.10.100 192.168.10.101 192.168.10.102 192.168.10.103
  [ $status -eq 0 ]
}

@test "rpt_adr_get - get report address" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" rpt_adr_get
  [ $status -eq 0 ]
}

@test "fib_rut_set - slotid="$OPM_SLOT" port=1 fiberid=1" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_rut_set "$OPM_SLOT" 1 1 
  [ $status -eq 0 ]
}

@test "fib_rut_set - slotid="$OPM_SLOT" port=2 fiberid=2" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_rut_set "$OPM_SLOT" 2 2 
  [ $status -eq 0 ]
}

@test "fib_rut_set - <-invalid->slotid="$[OPM_SLOT+1]" port=1 fiberid=1" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_rut_set "$[OPM_SLOT+1]" 1 1 
  [ $status -eq 255 ]
  [ $( echo $output | grep "slotid invalid" -c ) -ne 0 ]
}

@test "fib_rut_set - slotid="$OPM_SLOT" <-invalid->port=0 fiberid=1" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_rut_set "$OPM_SLOT" 0 1 
  [ $status -eq 255 ]
  [ $( echo $output | grep "port invalid" -c ) -ne 0 ]
}

@test "fib_rut_set - slotid="$OPM_SLOT" <-invalid->port=$[OPM_PORTS+1] fiberid=1" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_rut_set "$OPM_SLOT" $[OPM_PORTS+1] 1 
  [ $status -eq 255 ]
  [ $( echo $output | grep "port invalid" -c ) -ne 0 ]
}

@test "fib_rut_set - slotid="$OPM_SLOT" port=1 <-invalid-> fiberid=0" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_rut_set "$OPM_SLOT" 1 0
  [ $status -eq 255 ]
  [ $( echo $output | grep "fibreid invalid" -c ) -ne 0 ]
}

@test "fib_rut_set - slotid="$OPM_SLOT" port=1 <-invalid-> fiberid=65" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_rut_set "$OPM_SLOT" 1 65
  [ $status -eq 255 ]
  [ $( echo $output | grep "fibreid invalid" -c ) -ne 0 ]
}

@test "fib_rut_get - slotid="$OPM_SLOT" port=1" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_rut_get "$OPM_SLOT" 1 
  [ $status -eq 0 ]
}

@test "fib_rut_get - slotid="$OPM_SLOT" port=2" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_rut_get "$OPM_SLOT" 2 
  [ $status -eq 0 ]
}

@test "fib_rut_get - <-invalid->slotid="$[OPM_SLOT+1]" port=1" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_rut_get "$[OPM_SLOT+1]" 1 
  [ $status -eq 255 ]
  [ $( echo $output | grep "slotid invalid" -c ) -ne 0 ]
}

@test "fib_rut_get - slotid="$OPM_SLOT" <-invalid->port=0" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_rut_get "$OPM_SLOT" 0
  [ $status -eq 255 ]
  [ $( echo $output | grep "port invalid" -c ) -ne 0 ]
}

@test "fib_rut_get - slotid="$OPM_SLOT" <-invalid->port=$[OPM_PORTS+1]" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_rut_get "$OPM_SLOT" $[OPM_PORTS+1]
  [ $status -eq 255 ]
  [ $( echo $output | grep "port invalid" -c ) -ne 0 ]
}

@test "rtu_alm_set - status=1" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" rtu_alm_set 1
  [ $status -eq 0 ]
  [ $( echo $output | grep "success" -c ) -ne 0 ]
}

@test "rtu_alm_set - status=0" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" rtu_alm_set 0
  [ $status -eq 0 ]
  [ $( echo $output | grep "success" -c ) -ne 0 ]
}

@test "rtu_alm_get - get rtu alarm status" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" rtu_alm_get 
  [ $status -eq 0 ]
  [ $( echo $output | grep "success" -c ) -ne 0 ]
}

@test "rtu_alm_dsb - set rtu alarm disable" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" rtu_alm_dsb 
  [ $status -eq 0 ]
  [ $( echo $output | grep "success" -c ) -ne 0 ]
}

@test "rtu_date_set - datetime=2016:07:08-11:22:22" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" rtu_date_set "2016:07:08-11:22:22"
  [ $status -eq 0 ]
}

@test "rtu_date_set - datetime=$(date "+%Y:%m:%d-%H:%M:%S")[now]" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" rtu_date_set
  [ $status -eq 0 ]
}

@test "rtu_date_get - get rtu datetime" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" rtu_date_get
  [ $status -eq 0 ]
}

@test "named - <-invalid->$[OSW_SLOT+1] 1 500 5 1625 100 1.476" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" named $[OSW_SLOT+1] 1 500 5 1625 100 1.476
  [ $( echo $output | grep "slotid invalid" -c ) -ne 0 ]
}

@test "named - $OSW_SLOT <-invalid->0 500 5 1625 100 1.476" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" named $OSW_SLOT 0 500 5 1625 100 1.476
  [ $( echo $output | grep "port invalid" -c ) -ne 0 ]
}

@test "named - $OSW_SLOT <-invalid->$[OSW_PORTS+1] 500 5 1625 100 1.476" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" named $OSW_SLOT $[OSW_PORTS+1] 500 5 1625 100 1.476
  [ $( echo $output | grep "port invalid" -c ) -ne 0 ]
}

@test "named - $OSW_SLOT 1 <-invalid->100 5 1625 100 1.476" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" named $OSW_SLOT 1 100 5 1625 100 1.476
  [ $( echo $output | grep "argument invalid" -c ) -ne 0 ]
}

@test "named - $OSW_SLOT 1 500 <-invalid->7 1625 100 1.476" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" named $OSW_SLOT 1 500 7 1625 100 1.476
  [ $( echo $output | grep "argument invalid" -c ) -ne 0 ]
}

@test "named - $OSW_SLOT 1 500 5 <-invalid->1350 100 1.476" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" named $OSW_SLOT 1 500 5 1350 100 1.476
  [ $( echo $output | grep "argument invalid" -c ) -ne 0 ]
}

@test "named - $OSW_SLOT 1 500 5 1625 <-invalid->10000 1.476" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" named $OSW_SLOT 1 500 5 1625 10000 1.476
  [ $( echo $output | grep "argument invalid" -c ) -ne 0 ]
}

@test "named - $OSW_SLOT 1 500 5 1625 100 1.476 , wait for 2 minute" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" named $OSW_SLOT 1 500 5 1625 100 1.476
  [ $( echo $output | grep "refuse named" -c ) -ne 0 -o $( echo $output | grep "curvedata" -c ) -ne 0 ]
}

@test "named - $OSW_SLOT 2 500 5 1625 100 1.476 , wait for 2 minute" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" named $OSW_SLOT 2 500 5 1625 100 1.476
   [ $( echo $output | grep "refuse named" -c ) -ne 0 -o $( echo $output | grep "curvedata" -c ) -ne 0 ]
}

@test "warnd - fiber=1" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" rpt_adr_set $IPADDRESS
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" warnd 1 
  [ $( echo $output | grep "refuse named" -c ) -ne 0 -o $( echo $output | grep "curvedata" -c ) -ne 0 ]
}

@test "warnd - fiber=2" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" rpt_adr_set $IPADDRESS
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" warnd 2
  [ $( echo $output | grep "refuse named" -c ) -ne 0 -o $( echo $output | grep "curvedata" -c ) -ne 0 ]
}

@test "opm_cfg_set - slotid=$OPM_SLOT port=3 ref=0 threshold1=0 threshold2=0 threshold3=0 nodev=0 nolight=0 confirm=100" {
  echo "opm_cfg_set $OPM_SLOT 3 0 0 0 0 0 0 0" > .opm_test
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" -s 3000 -r 10000 -f .opm_test
  [ $status -eq 0 ]
  [ $( echo $output | grep "threshold1" -c ) -ne 0 ]
}

@test "opm_cfg_set - slotid=$OPM_SLOT port=0 ref=0 threshold1=0 threshold2=0 threshold3=0 nodev=0 nolight=0 confirm=100" {
  echo "opm_cfg_set $OPM_SLOT 0 0 0 0 0 0 0 0" > .opm_test
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" -s 3000 -r 10000 -f .opm_test
  [ $status -eq 0 ]
  [ $( echo $output | grep "threshold1" -c ) -ne 0 ]
}

@test "fib_osw_set - delete fiber 1" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_osw_set 1 1 $OSW_SLOT 1 0 0 0 0 0
  [ $status -eq 0 ]
}

@test "fib_osw_set - delete fiber 2" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_osw_set 2 1 $OSW_SLOT 2 0 0 0 0 0
  [ $status -eq 0 ]
}

@test "activate - rtud" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" rtu_activate "$RTU_SERIAL"
  [ $( echo $output | grep "activate success" -c ) -ne 0 ]
}

@test "hostd run for simple script" {
  echo "rtu_conf" > .hostd_script
  echo "rtu_leds" >> .hostd_script
  echo "mem_get" >> .hostd_script
  echo "rtu_date_get" >> .hostd_script
  echo "rtu_alm_get" >> .hostd_script
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" -f .hostd_script 
  [ $status -eq 0 ]
}

@test "hostd run for named script, wait for 20 minute" {
  skip 
  echo "named $OSW_SLOT 1 500 5 1625 100 1.476" > .hostd_script
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" -c curvedata -f .hostd_script 
  [ $status -eq 0 ]
  echo "named $OSW_SLOT 1 2500 30 1625 100 1.476" > .hostd_script
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" -c curvedata -f .hostd_script 
  [ $status -eq 0 ]
  echo "named $OSW_SLOT 1 5000 50 1625 100 1.476" > .hostd_script
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" -c curvedata -f .hostd_script 
  [ $status -eq 0 ]
  echo "named $OSW_SLOT 1 15000 27  5 1625 100 1.476" > .hostd_script
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" -c curvedata -f .hostd_script 
  [ $status -eq 0 ]
  
  echo "named $OSW_SLOT 1 40000 500 1625 100 1.476" > .hostd_script
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" -c curvedata -f .hostd_script 
  [ $status -eq 0 ]
  echo "named $OSW_SLOT 1 80000 1000 1625 100 1.476" > .hostd_script
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" -c curvedata -f .hostd_script 
  [ $status -eq 0 ]
  echo "named $OSW_SLOT 1 120000 5000 1625 100 1.476" > .hostd_script
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" -c curvedata -f .hostd_script 
  [ $status -eq 0 ]
  echo "named $OSW_SLOT 1 160000 10000 1625 100 1.476" > .hostd_script
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" -c curvedata -f .hostd_script 
  [ $status -eq 0 ]
  echo "named $OSW_SLOT 1 200000 20000 1625 100 1.476" > .hostd_script
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" -c curvedata -f .hostd_script 
  [ $status -eq 0 ]

  [ -d curvedata ]
}

