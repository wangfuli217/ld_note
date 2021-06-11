#!/usr/bin/env bats
#
# depend on https://github.com/sstephenson/bats
#

load test_helper

@test "hostd - 没有参数连接localhost测试,连接失败" {
  run hostd
  [ $status -eq 255 ]
  [ $( echo $output | grep failure -c ) -ne 0 ]
}

@test "hostd - 输出自身的版本信息测试" {
  run hostd -v
  [ $status -eq 0 ]
  [ $( echo $output | grep "hostd version" -c ) -ne 0 ]
}

@test "hostd_config - 获取hostd和rtud程序连接的默认配置" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" hostd_config
  [ $status -eq 0 ]
  [ $( echo $output | grep "hostd version" -c ) -ne 0 ]
}

@test "otdr_param - 获得hostd建议进行otdr测试的参数匹配原则" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" otdr_param
  [ $status -eq 0 ]
  [ $( echo $output | grep "suggestion" -c ) -ne 0 ]
}

@test "rtu_conf - 获取rtu设备内部所有板卡配置信息测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" rtu_conf
  [ $status -eq 0 ]
}

@test "rtu_leds - 获取rtu设备内部所有板卡灯状态信息测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" rtu_leds
  [ $status -eq 0 ]
}

@test "mem_get - 获取mcu当前内存状态信息测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" mem_get
  [ $status -eq 0 ]
}

@test "ols_cfg_set - 配置[OLS-${OSL_SLOT}接口=1,不输出光]-测试" {
    if [ "x$OSL_SLOT" = "x" ]; then
        skip "OLS板卡不存在"
    fi
    run hostd -h "$RTU_HOST" -p "$RTU_PORT" ols_cfg_set $OSL_SLOT 1 0
    [ $status -eq 0 ]
    [ $( echo $output | grep "enable:0" -c ) -ne 0 ]
}

@test "ols_cfg_set - 配置[OLS-${OSL_SLOT}接口=1,输出光]-测试" {
    if [ "x$OSL_SLOT" = "x" ]; then
        skip "OLS板卡不存在"
    fi
    run hostd -h "$RTU_HOST" -p "$RTU_PORT" ols_cfg_set $OSL_SLOT 1 1
    [ $status -eq 0 ]
    [ $( echo $output | grep "enable:1" -c ) -ne 0 ]
}

@test "ols_cfg_set - 配置[OLS-$[OSL_SLOT+1]接口=1,不输出光测试]-槽位$[OSL_SLOT+1]异常测试" {
    if [ "x$OSL_SLOT" = "x" ]; then
        skip "OLS板卡不存在"
    fi
    run hostd -h "$RTU_HOST" -p "$RTU_PORT" ols_cfg_set $[OSL_SLOT+1] 1 0
    [ $status -eq 255 ]
    [ $( echo $output | grep "slotid invalid" -c ) -ne 0 ]
}

@test "ols_cfg_set - 配置[OLS-${OSL_SLOT}接口=0,不输出光测试]-接口0异常测试" {
    if [ "x$OSL_SLOT" = "x" ]; then
        skip "OLS板卡不存在"
    fi
    run hostd -h "$RTU_HOST" -p "$RTU_PORT" ols_cfg_set $OSL_SLOT 0 0
    [ $status -eq 255 ]
    [ $( echo $output | grep "port invalid" -c ) -ne 0 ]
}

@test "ols_cfg_set - 配置[OLS-${OSL_SLOT}接口=$[OSL_PORTS+1],不输出光测试]-接口$[OSL_PORTS+1]异常测试" {
    if [ "x$OSL_SLOT" = "x" ]; then
        skip "OLS板卡不存在"
    fi
    run hostd -h "$RTU_HOST" -p "$RTU_PORT" ols_cfg_set $OSL_SLOT $[OSL_PORTS+1] 0
    [ $status -eq 255 ]
    [ $( echo $output | grep "port invalid" -c ) -ne 0 ]
}

@test "ols_cfg_get - 获取[OLS-${OSL_SLOT}接口=${OSL_SLOT},状态]-测试" {
    if [ "x$OSL_SLOT" = "x" ]; then
        skip "OLS板卡不存在"
    fi
    run hostd -h "$RTU_HOST" -p "$RTU_PORT" ols_cfg_get $OSL_SLOT
    [ $status -eq 0 ]
    [ $( echo $output | grep "enable" -c ) -ne 0 ]
}

@test "ols_cfg_get - 获取所有OLS接口状态测试" {
    if [ "x$OSL_SLOT" = "x" ]; then
        skip "OLS板卡不存在"
    fi
    run hostd -h "$RTU_HOST" -p "$RTU_PORT" ols_cfg_get
    [ $status -eq 0 ]
    [ $( echo $output | grep "enable" -c ) -ne 0 ]
}

@test "ols_cfg_get - 获取[OLS-$[OSL_SLOT+1]接口=${OSL_SLOT},状态]-槽位$[OSL_SLOT+1]异常测试" {
    if [ "x$OSL_SLOT" = "x" ]; then
        skip "OLS板卡不存在"
    fi
    run hostd -h "$RTU_HOST" -p "$RTU_PORT" ols_cfg_get $[OSL_SLOT+1]
    [ $status -eq 255 ]
    [ $( echo $output | grep "slotid invalid" -c ) -ne 0 ]
}

@test "fib_osw_set - 配置光路[光纤序号=1 槽位=$OSW_SLOT 接口=1 范围=500 脉宽=5 波长=1625 平均次数=100 折射率=1.476]-测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT"  fib_osw_set 1 1 $OSW_SLOT 1 500 5 1625 100 1.476000
  [ $status -eq 0 ]
}

@test "fib_osw_set - 配置光路[光纤序号=2 槽位=$OSW_SLOT 接口=2 范围=15000 脉宽=275 波长=1625 平均次数=100 折射率=1.476]-测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_osw_set 2 1 $OSW_SLOT 2 15000 275 1625 100 1.476000
  [ $status -eq 0 ]
}

@test "fib_osw_set - 配置光路[光纤序号=0 槽位=$OSW_SLOT 接口=1 范围=500 脉宽=5 波长=1625 平均次数=100 折射率=1.476]-光纤序号0异常测试 " {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_osw_set 0 1 $OSW_SLOT 1 500 5 1625 100 1.476000
  [ $status -eq 255 ]
  [ $( echo $output | grep "fibreid invalid" -c ) -ne 0 ]
}

@test "fib_osw_set - 配置光路[光纤序号=65 槽位=$OSW_SLOT 接口=1 范围=500 脉宽=5 波长=1625 平均次数=100 折射率=1.476]-光纤序号65异常测试  " {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_osw_set 65 1 $OSW_SLOT 1 500 5 1625 100 1.476000
  [ $status -eq 255 ]
  [ $( echo $output | grep "fibreid invalid" -c ) -ne 0 ]
}

@test "fib_osw_set - 配置光路[光纤序号=1 槽位=$[OSW_SLOT+1] 接口=1 范围=500 脉宽=5 波长=1625 平均次数=100 折射率=1.476]-槽位$[OSW_SLOT+1]异常测试 " {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_osw_set 1 1 $[OSW_SLOT+1] 1 500 5 1625 100 1.476000
  [ $status -eq 255 ]
  [ $( echo $output | grep "slotid invalid" -c ) -ne 0 ]
}

@test "fib_osw_set - 配置光路[光纤序号=1 槽位=${OSW_SLOT} 接口=0 范围=500 脉宽=5 波长=1625 平均次数=100 折射率=1.476]-接口0异常测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_osw_set 1 1 $OSW_SLOT 0 500 5 1625 100 1.476000
  [ $status -eq 255 ]
  [ $( echo $output | grep "port invalid" -c ) -ne 0 ]
}

@test "fib_osw_set - 配置光路[光纤序号=1 槽位=${OSW_SLOT} 接口=$[OSW_PORTS+1] 范围=500 脉宽=5 波长=1625 平均次数=100 折射率=1.476]-接口$[OSW_PORTS+1]异常测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_osw_set 1 1 $OSW_SLOT $[OSW_PORTS+1] 500 5 1625 100 1.476000
  [ $status -eq 255 ]
  [ $( echo $output | grep "port invalid" -c ) -ne 0 ]
}

@test "fib_osw_set - 配置光路[光纤序号=1 槽位=${OSW_SLOT} 接口=1 范围=100 脉宽=5 波长=1625 平均次数=100 折射率=1.476]-范围参数100异常测试 " {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_osw_set 1 1 $OSW_SLOT 1 100 5 1625 100 1.476000
  [ $status -eq 255 ]
  [ $( echo $output | grep "argument invalid" -c ) -ne 0 ]
}

@test "fib_osw_set - 配置光路[光纤序号=1 槽位=${OSW_SLOT} 接口=1 范围=500 脉宽=7 波长=1625 平均次数=100 折射率=1.476]-脉宽参数7异常测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_osw_set 1 1 $OSW_SLOT 1 500 7 1625 100 1.476000
  [ $status -eq 255 ]
  [ $( echo $output | grep "argument invalid" -c ) -ne 0 ]
}

@test "fib_osw_set - 配置光路[光纤序号=1 槽位=${OSW_SLOT} 接口=1 范围=500 脉宽=5 波长=1350 平均次数=100 折射率=1.476]-波长参数1350异常测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_osw_set 1 1 $OSW_SLOT 1 500 5 1350 100 1.476000
  [ $status -eq 255 ]
  [ $( echo $output | grep "argument invalid" -c ) -ne 0 ]
}

@test "fib_osw_set - 配置光路[光纤序号=1 槽位=${OSW_SLOT} 接口=1 范围=500 脉宽=5 波长=1625 平均次数=10000 折射率=1.476]-平均次数参数10000异常测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_osw_set 1 1 $OSW_SLOT 1 500 5 1625 10000 1.476000
  [ $status -eq 255 ]
  [ $( echo $output | grep "argument invalid" -c ) -ne 0 ]
}

@test "fib_osw_get - 获取所有光路信息" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_osw_get
  [ $status -eq 0 ]
}

@test "fib_osw_get - 获取[纤芯序号=0光路信息]-纤芯序号0异常测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_osw_get 0
  [ $status -eq 255 ]
  [ $( echo $output | grep "request fibreid invalid" -c ) -ne 0 ]
}

@test "fib_osw_get - 获取[纤芯序号=65光路信息]-纤芯序号65异常测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_osw_get 65
  [ $status -eq 255 ]
  [ $( echo $output | grep "request fibreid invalid" -c ) -ne 0 ]
}

@test "fib_osw_get - 获取[纤芯序号=1配置]-测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_osw_get 1
  [ $status -eq 0 ]
  [ $( echo $output | grep "fiberid:1" -c ) -ne 0 ]
}

@test "fib_osw_get - 获取[纤芯序号=2配置]-测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_osw_get 2
  [ $status -eq 0 ]
  [ $( echo $output | grep "fiberid:2" -c ) -ne 0 ]
}

@test "opm_cfg_set - 配置OPM[槽位=$OPM_SLOT 接口=1 参考值=0 1级门限=67 2级门限=67 3级门限=67 无设备门限=-67 无光门限=-67 确认时间=100]-测试" {
  echo "opm_cfg_set $OPM_SLOT 1 0 67 67 67 -67 -67 100" > .opm_test
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" -s 3000 -r 10000 -f .opm_test
  [ $status -eq 0 ]
  [ $( echo $output | grep "threshold1" -c ) -ne 0 ]
}

@test "opm_cfg_set - 配置OPM[槽位=$OPM_SLOT 接口=2 参考值=0 1级门限=67 2级门限=67 3级门限=67 无设备门限=-67 无光门限=-67 确认时间=100]-测试" {
  echo "opm_cfg_set $OPM_SLOT 2 0 67 67 67 -67 -67 100" > .opm_test
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" -s 3000 -r 10000 -f .opm_test
  [ $status -eq 0 ]
  [ $( echo $output | grep "threshold1" -c ) -ne 0 ]
}

@test "opm_cfg_set - 配置OPM[槽位=$[OPM_SLOT+1] 接口=1 参考值=1.9 1级门限=3.0 2级门限=5.0 3级门限=15.0 无设备门限=-65 无光门限=-65 确认时间=100]-槽位$[OPM_SLOT+1]参数异常测试" {
  echo "opm_cfg_set $[OPM_SLOT+1] 1 1.9 3.0 5.0 15.0 -65 -65 100" > .opm_test
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" -f .opm_test
  [ $status -eq 255 ]
  [ $( echo $output | grep "slotid invalid" -c ) -ne 0 ]
}

@test "opm_cfg_set - 配置OPM[槽位=${OPM_SLOT} 接口=0 参考值=1.9 1级门限=3.0 2级门限=5.0 3级门限=15.0 无设备门限=-65 无光门限=-65 确认时间=100]-接口0参数异常测试" {
  echo "opm_cfg_set $OPM_SLOT 0 1.9 3.0 5.0 15.0 -65 -65 100" > .opm_test
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" -f .opm_test
  [ $status -eq 255 ]
  [ $( echo $output | grep "port invalid" -c ) -ne 0 ]
}

@test "opm_cfg_set - 配置OPM[槽位=${OPM_SLOT} 接口=$[OPM_PORTS+1] 参考值=1.9 1级门限=3.0 2级门限=5.0 3级门限=15.0 无设备门限=-65 无光门限=-65 确认时间=100]-接口$[OPM_PORTS+1]参数异常测试" {
  echo "opm_cfg_set $OPM_SLOT $[OPM_PORTS+1] 1.9 3.0 5.0 15.0 -65 -65 100" > .opm_test
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" -f .opm_test
  [ $status -eq 255 ]
  [ $( echo $output | grep "port invalid" -c ) -ne 0 ]
}

@test "opm_cfg_set - 配置OPM[槽位=${OPM_SLOT} 接口=1 参考值=-60 1级门限=3.0 2级门限=5.0 3级门限=15.0 无设备门限=-65 无光门限=-65 确认时间=100]-参考值(-60-15)<-67参数异常测试" {
  echo "opm_cfg_set $OPM_SLOT 1 -60 3.0 5.0 15.0 -65 -65 100" > .opm_test
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" -f .opm_test
  [ $status -eq 255 ]
  [ $( echo $output | grep "argument invalid" -c ) -ne 0 ]
}

@test "opm_cfg_set - 配置OPM[槽位=${OPM_SLOT} 接口=1 参考值=1.9 1级门限=3.0 2级门限=5.0 3级门限=15.0 无设备门限=-69 无光门限=-65 确认时间=100]-无设备门限-69<-67参数异常测试" {
  echo "opm_cfg_set $OPM_SLOT 1 1.9 3.0 5.0 15.0 -69 -65 100" > .opm_test
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" -f .opm_test
  [ $status -eq 255 ]
  [ $( echo $output | grep "argument invalid" -c ) -ne 0 ]
}

@test "opm_cfg_set - 配置OPM[槽位=${OPM_SLOT} 接口=1 参考值=1.9 1级门限=3.0 2级门限=5.0 3级门限=15.0 无设备门限=-65 无光门限=-69 确认时间=100]-无光门限-69<-67参数异常测试" {
  echo "opm_cfg_set $OPM_SLOT 1 1.9 3.0 5.0 15.0 -65 -69 100" > .opm_test
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" -f .opm_test
  [ $status -eq 255 ]
  [ $( echo $output | grep "argument invalid" -c ) -ne 0 ]
}

@test "opm_cfg_get - 获取所有OPM板卡的配置信息测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" opm_cfg_get
  [ $status -eq 0 ]
}

@test "opm_cfg_get - 获取[槽位=$OPM_SLOT 接口=1的配置信息]-测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" opm_cfg_get $OPM_SLOT 1
  [ $status -eq 0 ]
}

@test "opm_cfg_get - 获取[槽位=$OPM_SLOT 接口=2的配置信息]-测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" opm_cfg_get $OPM_SLOT 2
  [ $status -eq 0 ]
}

@test "opm_cfg_get - 获取[槽位=$[OPM_SLOT+1] 接口=1的配置信息]-指定槽位$[OPM_SLOT+1]异常测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" opm_cfg_get $[OPM_SLOT+1] 1
  [ $status -eq 255 ]
  [ $( echo $output | grep "slotid invalid" -c ) -ne 0 ]
}

@test "opm_cfg_get - 获取[槽位=${OPM_SLOT} 接口=0的配置信息]-指定接口0异常测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" opm_cfg_get $OPM_SLOT 0
  [ $status -eq 255 ]
  [ $( echo $output | grep "port invalid" -c ) -ne 0 ]
}

@test "opm_cfg_get - 获取[槽位=${OPM_SLOT} 接口=$[OPM_PORTS+1]的配置信息]-指定接口$[OPM_PORTS+1]异常测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" opm_cfg_get $OPM_SLOT $[OPM_PORTS+1]
  [ $status -eq 255 ]
  [ $( echo $output | grep "port invalid" -c ) -ne 0 ]
}

@test "opm_val_get - 获取[槽位=${OPM_SLOT} 接口=1的当前光功率值信息]-测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" -s 3000 -r 10000 opmval $OPM_SLOT 1
  [ $status -eq 0 ]
}

@test "opm_val_get - 获取[槽位=${OPM_SLOT} 接口=2的当前光功率值信息]-测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" -s 3000 -r 10000 opmval $OPM_SLOT 2
  [ $status -eq 0 ]
}

@test "opm_val_get - 获取[槽位=$[OPM_SLOT+1] 接口=2的当前光功率值信息]-指定槽位$[OPM_SLOT+1]异常测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" opm_val_get $[OPM_SLOT+1] 1
  [ $status -eq 255 ]
  [ $( echo $output | grep "slotid invalid" -c ) -ne 0 ]
}

@test "opm_val_get - 获取[槽位=${OPM_SLOT} 接口=0的当前光功率值信息]-指定接口0异常测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" opm_val_get $OPM_SLOT 0
  [ $status -eq 255 ]
  [ $( echo $output | grep "port invalid" -c ) -ne 0 ]
}

@test "opm_val_get - 获取[槽位=${OPM_SLOT} 接口=$[OPM_PORTS+1]]的当前光功率值信息-指定接口$[OPM_PORTS+1]异常测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" opm_val_get $OPM_SLOT $[OPM_PORTS+1]
  [ $status -eq 255 ]
  [ $( echo $output | grep "port invalid" -c ) -ne 0 ]
}

@test "fib_prd_set - 设置定期测试[光纤序号=1 起始时间=2017:05:06-11:12:30 测试周期=720]-测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_prd_set 1 2017:05:06-11:12:30 720
  [ $status -eq 0 ]
}

@test "fib_prd_set - 设置定期测试[光纤序号=2 起始时间=$(date "+%Y:%m:%d-%H:%M:%S")[now] 测试周期=720]-测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_prd_set 2 720
  [ $status -eq 0 ]
}

@test "fib_prd_set - 设置定期测试[光纤序号=0 起始时间=2017:05:06-11:12:30 测试周期=720]-光纤序号0异常测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_prd_set 0 2017:05:06-11:12:30 720
  [ $status -eq 255 ]
  [ $( echo $output | grep "fibreid invalid" -c ) -ne 0 ]
}

@test "fib_prd_set - 设置定期测试[光纤序号=0 起始时间=$(date "+%Y:%m:%d-%H:%M:%S")[now] 测试周期=720]-光纤序号0异常测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_prd_set 0 720
  [ $status -eq 255 ]
  [ $( echo $output | grep "fibreid invalid" -c ) -ne 0 ]
}

@test "fib_prd_set - 设置定期测试[光纤序号=65 起始时间=2017:05:06-11:12:30 测试周期=720]-光纤序号65异常测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_prd_set 65 2017:05:06-11:12:30 720
  [ $status -eq 255 ]
  [ $( echo $output | grep "fibreid invalid" -c ) -ne 0 ]
}

@test "fib_prd_set - 设置定期测试[光纤序号=65 起始时间=$(date "+%Y:%m:%d-%H:%M:%S")[now] 测试周期=720]-光纤序号65异常测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_prd_set 65 720
  [ $status -eq 255 ]
  [ $( echo $output | grep "fibreid invalid" -c ) -ne 0 ]
}

@test "fib_prd_get - 获取所有定期测试配置信息测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_prd_get
  [ $status -eq 0 ]
}

@test "fib_prd_get - 获取[光纤序号=1定期测试配置信息]-测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_prd_get 1
  [ $status -eq 0 ]
}

@test "fib_prd_get - 获取[光纤序号=2定期测试配置信息]-测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_prd_get 2
  [ $status -eq 0 ]
}

@test "fib_prd_get - 获取[光纤序号=0定期测试配置信息]-光纤序号0异常测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_prd_get 0
  [ $status -eq 255 ]
  [ $( echo $output | grep "fibreid invalid" -c ) -ne 0 ]
}

@test "fib_prd_get - 获取[光纤序号=65定期测试配置信息]-光纤序号65异常测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_prd_get 65
  [ $status -eq 255 ]
  [ $( echo $output | grep "fibreid invalid" -c ) -ne 0 ]
}

@test "rpt_adr_set - 配置上报服务器IP地址[ipaddr1=192.168.10.100]-测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" rpt_adr_set 192.168.10.100
  [ $status -eq 0 ]
}

@test "rpt_adr_set - 配置上报服务器IP地址[ipaddr1=192.168.10.100 ipaddr2=192.168.10.101]-测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" rpt_adr_set 192.168.10.100 192.168.10.101
  [ $status -eq 0 ]
}

@test "rpt_adr_set - 配置上报服务器IP地址[ipaddr1=192.168.10.100 ipaddr2=192.168.10.101 ipaddr3=192.168.10.102]-测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" rpt_adr_set 192.168.10.100 192.168.10.101 192.168.10.102
  [ $status -eq 0 ]
}

@test "rpt_adr_set - 配置上报服务器IP地址[ipaddr1=192.168.10.100 ipaddr2=192.168.10.101 ipaddr3=192.168.10.102 ipaddr4=192.168.10.109]-测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" rpt_adr_set 192.168.10.100 192.168.10.101 192.168.10.102 192.168.10.103
  [ $status -eq 0 ]
}

@test "rpt_adr_get - 获得上报服务器IP地址测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" rpt_adr_get
  [ $status -eq 0 ]
}

@test "fib_rut_set - 设置光路路由关系[槽位="$OPM_SLOT" 接口=1 光纤序号=1]-测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_rut_set "$OPM_SLOT" 1 1 
  [ $status -eq 0 ]
}

@test "fib_rut_set - 设置光路路由关系[槽位="$OPM_SLOT" 接口=2 光纤序号=2]-测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_rut_set "$OPM_SLOT" 2 2 
  [ $status -eq 0 ]
}

@test "fib_rut_set - 设置光路路由关系[槽位="$[OPM_SLOT+1]" 接口=2 光纤序号=2]-槽位$[OPM_SLOT+1]异常测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_rut_set "$[OPM_SLOT+1]" 1 1 
  [ $status -eq 255 ]
  [ $( echo $output | grep "slotid invalid" -c ) -ne 0 ]
}

@test "fib_rut_set - 设置光路路由关系[槽位="$OPM_SLOT" 接口=0 光纤序号=1]-接口0异常测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_rut_set "$OPM_SLOT" 0 1 
  [ $status -eq 255 ]
  [ $( echo $output | grep "port invalid" -c ) -ne 0 ]
}

@test "fib_rut_set - 设置光路路由关系[槽位="$OPM_SLOT" 接口=$[OPM_PORTS+1] 光纤序号=1]-接口$[OPM_PORTS+1]异常测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_rut_set "$OPM_SLOT" $[OPM_PORTS+1] 1 
  [ $status -eq 255 ]
  [ $( echo $output | grep "port invalid" -c ) -ne 0 ]
}

@test "fib_rut_set - 设置光路路由关系[槽位="$OPM_SLOT" 接口=1 光纤序号0]-光纤序号0异常测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_rut_set "$OPM_SLOT" 1 0
  [ $status -eq 255 ]
  [ $( echo $output | grep "fibreid invalid" -c ) -ne 0 ]
}

@test "fib_rut_set - 设置光路路由关系[槽位="$OPM_SLOT" 接口=1 光纤序号65]-光纤序号65异常测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_rut_set "$OPM_SLOT" 1 65
  [ $status -eq 255 ]
  [ $( echo $output | grep "fibreid invalid" -c ) -ne 0 ]
}

@test "fib_rut_get - 获取光路路由关系[槽位="$OPM_SLOT" 接口=1]-测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_rut_get "$OPM_SLOT" 1 
  [ $status -eq 0 ]
}

@test "fib_rut_get - 获取光路路由关系[槽位="$OPM_SLOT" 接口=2]-测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_rut_get "$OPM_SLOT" 2 
  [ $status -eq 0 ]
}

@test "fib_rut_get - 获取光路路由关系[槽位="$[OPM_SLOT+1]" 接口=1]-槽位$[OPM_SLOT+1]异常测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_rut_get "$[OPM_SLOT+1]" 1 
  [ $status -eq 255 ]
  [ $( echo $output | grep "slotid invalid" -c ) -ne 0 ]
}

@test "fib_rut_get - 获取光路路由关系[槽位="$OPM_SLOT" 接口=0]-接口0异常测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_rut_get "$OPM_SLOT" 0
  [ $status -eq 255 ]
  [ $( echo $output | grep "port invalid" -c ) -ne 0 ]
}

@test "fib_rut_get - 获取光路路由关系[槽位="$OPM_SLOT" 接口=$[OPM_PORTS+1]]-接口$[OPM_PORTS+1]异常测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_rut_get "$OPM_SLOT" $[OPM_PORTS+1]
  [ $status -eq 255 ]
  [ $( echo $output | grep "port invalid" -c ) -ne 0 ]
}

@test "rtu_alm_set - 设置[蜂鸣器使能鸣叫]-测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" rtu_alm_set 1
  [ $status -eq 0 ]
  [ $( echo $output | grep "success" -c ) -ne 0 ]
}

@test "rtu_alm_set - 设置[蜂鸣器不鸣叫]-测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" rtu_alm_set 0
  [ $status -eq 0 ]
  [ $( echo $output | grep "success" -c ) -ne 0 ]
}

@test "rtu_alm_get - 获取[蜂鸣器状态]-测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" rtu_alm_get 
  [ $status -eq 0 ]
  [ $( echo $output | grep "success" -c ) -ne 0 ]
}

@test "rtu_alm_dsb - 设置[蜂鸣器停止鸣叫]-测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" rtu_alm_dsb 
  [ $status -eq 0 ]
  [ $( echo $output | grep "success" -c ) -ne 0 ]
}

@test "rtu_date_set - 配置[rtu当前时间=2016:07:08-11:22:22]-测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" rtu_date_set "2016:07:08-11:22:22"
  [ $status -eq 0 ]
}

@test "rtu_date_set - 配置[rtu当前时间=2016:07:08-11:22:22=$(date "+%Y:%m:%d-%H:%M:%S")[now]]-测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" rtu_date_set
  [ $status -eq 0 ]
}

@test "rtu_date_get - 获取[rtu当前时间]-测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" rtu_date_get
  [ $status -eq 0 ]
}

@test "named - 点名测试[$[OSW_SLOT+1] 1 500 5 1625 100 1.476]-osw槽位$[OSW_SLOT+1]异常测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" named $[OSW_SLOT+1] 1 500 5 1625 100 1.476
  [ $( echo $output | grep "slotid invalid" -c ) -ne 0 ]
}

@test "named - 点名测试[$OSW_SLOT 0 500 5 1625 100 1.476]-osw接口0异常测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" named $OSW_SLOT 0 500 5 1625 100 1.476
  [ $( echo $output | grep "port invalid" -c ) -ne 0 ]
}

@test "named - 点名测试[$OSW_SLOT $[OSW_PORTS+1] 500 5 1625 100 1.476]-osw接口$[OSW_PORTS+1]异常测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" named $OSW_SLOT $[OSW_PORTS+1] 500 5 1625 100 1.476
  [ $( echo $output | grep "port invalid" -c ) -ne 0 ]
}

@test "named - 点名测试[$OSW_SLOT 1 100 5 1625 100 1.476]-范围参数100异常测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" named $OSW_SLOT 1 100 5 1625 100 1.476
  [ $( echo $output | grep "argument invalid" -c ) -ne 0 ]
}

@test "named - 点名测试[$OSW_SLOT 1 500 7 1625 100 1.476]-脉宽参数7异常测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" named $OSW_SLOT 1 500 7 1625 100 1.476
  [ $( echo $output | grep "argument invalid" -c ) -ne 0 ]
}

@test "named - 点名测试[$OSW_SLOT 1 500 5 1350 100 1.476]-波长参数1350异常测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" named $OSW_SLOT 1 500 5 1350 100 1.476
  [ $( echo $output | grep "argument invalid" -c ) -ne 0 ]
}

@test "named - 点名测试[$OSW_SLOT 1 500 5 1625 10000 1.476]-平均次数参数10000异常测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" named $OSW_SLOT 1 500 5 1625 10000 1.476
  [ $( echo $output | grep "argument invalid" -c ) -ne 0 ]
}

@test "named - 点名测试[$OSW_SLOT 1 500 5 1625 100 1.476]-测试:请等待2分钟" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" named $OSW_SLOT 1 500 5 1625 100 1.476
  [ $( echo $output | grep "refuse named" -c ) -ne 0 -o $( echo $output | grep "curvedata" -c ) -ne 0 ]
}

@test "named - 点名测试[$OSW_SLOT 2 500 5 1625 100 1.476]-测试:请等待2分钟" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" named $OSW_SLOT 2 500 5 1625 100 1.476
   [ $( echo $output | grep "refuse named" -c ) -ne 0 -o $( echo $output | grep "curvedata" -c ) -ne 0 ]
}

@test "warnd - 告警测试[纤芯序号1]-测试:请等待2分钟" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" rpt_adr_set $IPADDRESS
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" warnd 1 
  [ $( echo $output | grep "refuse named" -c ) -ne 0 -o $( echo $output | grep "curvedata" -c ) -ne 0 ]
}

@test "warnd - 告警测试[纤芯序号2]-测试:请等待2分钟" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" rpt_adr_set $$IPADDRESS
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" warnd 2
  [ $( echo $output | grep "refuse named" -c ) -ne 0 -o $( echo $output | grep "curvedata" -c ) -ne 0 ]
}

@test "opm_cfg_set - 恢复OPM${OPM_SLOT}接口1初始值[槽位=${OPM_SLOT} 接口=1 参考值=0 1级门限=0 2级门限=0 3级门限=0 无设备门限=0 无光门限=0 确认时间=100]-测试" {
  echo "opm_cfg_set $OPM_SLOT 3 0 0 0 0 0 0 0" > .opm_test
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" -s 3000 -r 10000 -f .opm_test
  [ $status -eq 0 ]
  [ $( echo $output | grep "threshold1" -c ) -ne 0 ]
}

@test "opm_cfg_set - 恢复OPM${OPM_SLOT}槽位初始值[槽位=$OPM_SLOT 接口=0 参考值=0 1级门限=0 2级门限=0 3级门限=0 无设备门限=0 无光门限=0 确认时间=100]-测试" {
  echo "opm_cfg_set $OPM_SLOT 0 0 0 0 0 0 0 0" > .opm_test
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" -s 3000 -r 10000 -f .opm_test
  [ $status -eq 0 ]
  [ $( echo $output | grep "threshold1" -c ) -ne 0 ]
}

@test "fib_osw_set - 删除已下装纤芯配置1" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_osw_set 1 1 $OSW_SLOT 1 0 0 0 0 0
  [ $status -eq 0 ]
}

@test "fib_osw_set - 删除已下装纤芯配置2" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" fib_osw_set 2 1 $OSW_SLOT 2 0 0 0 0 0
  [ $status -eq 0 ]
}

@test "activate - 激活RTU测试" {
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" rtu_activate "$RTU_SERIAL"
  [ $( echo $output | grep "activate success" -c ) -ne 0 ]
}

@test "hostd  - 自动化脚本测试" {
  echo "rtu_conf" > .hostd_script
  echo "rtu_leds" >> .hostd_script
  echo "mem_get" >> .hostd_script
  echo "rtu_date_get" >> .hostd_script
  echo "rtu_alm_get" >> .hostd_script
  run hostd -h "$RTU_HOST" -p "$RTU_PORT" -f .hostd_script 
  [ $status -eq 0 ]
}

@test "hostd - 自动化脚本点名测试--请等待20分钟" {
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