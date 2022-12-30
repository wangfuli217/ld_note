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
# set_status/get_status

1. 手机测试: 测试前确保/etc/init.d/wpad stop; 最好disable掉更好
/var/dhcp.leases
46440 28:02:d8:03:3f:c8 192.168.225.126 * 01:28:02:d8:03:3f:c8 # ping 192.168.225.126正常
TW506C_5G_001117  5G有密码登录,输入正确密码登录正常
TW506C_2G0_001117 2.4G有密码登录,输入正确密码登录正常
TW506C_2G1_001117 2.4G有密码登录,输入正确密码登录正常


ubus call sdk_service.wlan set_status '{"wlan":"0","count":"0","status":"0"}'
ubus call sdk_service.wlan set_status '{"wlan":"1","count":"0","status":"0"}'
ubus call sdk_service.wlan set_status '{"wlan":"2","count":"0","status":"0"}'
ubus call sdk_service.wlan commit
ubus call sdk_service.wlan get_status '{"wlan":"0","count":"0"}'
ubus call sdk_service.wlan get_status '{"wlan":"1","count":"0"}'
ubus call sdk_service.wlan get_status '{"wlan":"2","count":"0"}'
ubus call sdk_service.wlan commit
sleep 1
pidof hostapd

ubus call sdk_service.wlan set_status '{"wlan":"0","count":"0","status":"1"}'
ubus call sdk_service.wlan set_status '{"wlan":"1","count":"0","status":"1"}'
ubus call sdk_service.wlan set_status '{"wlan":"2","count":"0","status":"1"}'
ubus call sdk_service.wlan commit
ubus call sdk_service.wlan get_status '{"wlan":"0","count":"0"}'
ubus call sdk_service.wlan get_status '{"wlan":"1","count":"0"}'
ubus call sdk_service.wlan get_status '{"wlan":"2","count":"0"}'
ubus call sdk_service.wlan commit
sleep 1
pidof hostapd


# set_ssid/get_ssid
ubus call sdk_service.wlan get_ssid '{"wlan":"0","count":"0"}' | jsonfilter -e "$.ssid"
ubus call sdk_service.wlan get_ssid '{"wlan":"1","count":"0"}' | jsonfilter -e "$.ssid"
ubus call sdk_service.wlan get_ssid '{"wlan":"2","count":"0"}' | jsonfilter -e "$.ssid"

ubus call sdk_service.wlan set_ssid '{"wlan":"0","count":"0","ssid":"ssid-TW506C_5G_001119"}'
ubus call sdk_service.wlan set_ssid '{"wlan":"1","count":"0","ssid":"ssid-TW506C_2G0_001117"}'
ubus call sdk_service.wlan set_ssid '{"wlan":"2","count":"0","ssid":"ssid-TW506C_2G1_001117"}'
ubus call sdk_service.wlan commit
ubus call sdk_service.wlan get_ssid '{"wlan":"0","count":"0"}' | jsonfilter -e "$.ssid"
ubus call sdk_service.wlan get_ssid '{"wlan":"1","count":"0"}' | jsonfilter -e "$.ssid"
ubus call sdk_service.wlan get_ssid '{"wlan":"2","count":"0"}' | jsonfilter -e "$.ssid"
sleep 1
hostapd_cli -i wlan2 status | grep '^ssid'
hostapd_cli -i wlan0 status | grep '^ssid'
hostapd_cli -i wlan1 status | grep '^ssid'

ubus call sdk_service.wlan set_ssid '{"wlan":"0","count":"0","ssid":"TW506C_5G_001119"}'
ubus call sdk_service.wlan set_ssid '{"wlan":"1","count":"0","ssid":"TW506C_2G0_001117"}'
ubus call sdk_service.wlan set_ssid '{"wlan":"2","count":"0","ssid":"TW506C_2G1_001117"}'
ubus call sdk_service.wlan commit
ubus call sdk_service.wlan get_ssid '{"wlan":"0","count":"0"}' | jsonfilter -e "$.ssid"
ubus call sdk_service.wlan get_ssid '{"wlan":"1","count":"0"}' | jsonfilter -e "$.ssid"
ubus call sdk_service.wlan get_ssid '{"wlan":"2","count":"0"}' | jsonfilter -e "$.ssid"
sleep 1
hostapd_cli -i wlan2 status | grep '^ssid'
hostapd_cli -i wlan0 status | grep '^ssid'
hostapd_cli -i wlan1 status | grep '^ssid'

# set_passwd/get_passwd
ubus call sdk_service.wlan get_passwd '{"wlan":"0","count":"0"}' | jsonfilter -e "$.passwd"
ubus call sdk_service.wlan get_passwd '{"wlan":"1","count":"0"}' | jsonfilter -e "$.passwd"
ubus call sdk_service.wlan get_passwd '{"wlan":"2","count":"0"}' | jsonfilter -e "$.passwd"
ubus call sdk_service.wlan set_passwd '{"wlan":"0","count":"0","passwd":"60b1da8860"}'
ubus call sdk_service.wlan set_passwd '{"wlan":"1","count":"0","passwd":"60b1da8861"}'
ubus call sdk_service.wlan set_passwd '{"wlan":"2","count":"0","passwd":"60b1da8862"}'
ubus call sdk_service.wlan commit

ubus call sdk_service.wlan get_passwd '{"wlan":"0","count":"0"}' | jsonfilter -e "$.passwd"
ubus call sdk_service.wlan get_passwd '{"wlan":"1","count":"0"}' | jsonfilter -e "$.passwd"
ubus call sdk_service.wlan get_passwd '{"wlan":"2","count":"0"}' | jsonfilter -e "$.passwd"
ubus call sdk_service.wlan set_passwd '{"wlan":"0","count":"0","passwd":"60b1da88690"}'
ubus call sdk_service.wlan set_passwd '{"wlan":"1","count":"0","passwd":"60b1da88691"}'
ubus call sdk_service.wlan set_passwd '{"wlan":"2","count":"0","passwd":"60b1da88692"}'
ubus call sdk_service.wlan commit
ubus call sdk_service.wlan get_passwd '{"wlan":"0","count":"0"}' | jsonfilter -e "$.passwd"
ubus call sdk_service.wlan get_passwd '{"wlan":"1","count":"0"}' | jsonfilter -e "$.passwd"
ubus call sdk_service.wlan get_passwd '{"wlan":"2","count":"0"}' | jsonfilter -e "$.passwd"


# set_beacon/get_beacon
ubus call sdk_service.wlan set_beacon '{"wlan":"0","beacon":"10"}' 
ubus call sdk_service.wlan set_beacon '{"wlan":"1","beacon":"11"}' 
ubus call sdk_service.wlan set_beacon '{"wlan":"2","beacon":"12"}' 
ubus call sdk_service.wlan commit
ubus call sdk_service.wlan get_beacon '{"wlan":"0"}' 
ubus call sdk_service.wlan get_beacon '{"wlan":"1"}' 
ubus call sdk_service.wlan get_beacon '{"wlan":"2"}' 

ubus call sdk_service.wlan set_beacon '{"wlan":"0","beacon":"20"}' 
ubus call sdk_service.wlan set_beacon '{"wlan":"1","beacon":"21"}' 
ubus call sdk_service.wlan set_beacon '{"wlan":"2","beacon":"22"}' 
ubus call sdk_service.wlan commit
ubus call sdk_service.wlan get_beacon '{"wlan":"0"}' 
ubus call sdk_service.wlan get_beacon '{"wlan":"1"}' 
ubus call sdk_service.wlan get_beacon '{"wlan":"2"}' 

# set_ssidmix/get_ssidmix
ubus call sdk_service.wlan get_ssidmix
ubus call sdk_service.wlan set_ssidmix '{"ssidmix":"1"}' 
ubus call sdk_service.wlan commit
ubus call sdk_service.wlan get_ssidmix

ubus call sdk_service.wlan get_ssidmix
ubus call sdk_service.wlan set_ssidmix '{"ssidmix":"0"}' 
ubus call sdk_service.wlan commit
ubus call sdk_service.wlan get_ssidmix

# set_auth/get_auth
# wpa=1
# key_mgmt=WPA-PSK
# group_cipher=TKIP
# wpa_pairwise_cipher=CCMP TKIP
ubus call sdk_service.wlan set_auth '{"wlan":"0","count":"0","auth":"1"}'
ubus call sdk_service.wlan set_auth '{"wlan":"1","count":"0","auth":"1"}'
ubus call sdk_service.wlan set_auth '{"wlan":"2","count":"0","auth":"1"}'
ubus call sdk_service.wlan commit
ubus call sdk_service.wlan get_auth '{"wlan":"0","count":"0"}' | jsonfilter -e "$.auth"
ubus call sdk_service.wlan get_auth '{"wlan":"1","count":"0"}' | jsonfilter -e "$.auth"
ubus call sdk_service.wlan get_auth '{"wlan":"2","count":"0"}' | jsonfilter -e "$.auth"
sleep 1
hostapd_cli -i wlan2 get_conf
hostapd_cli -i wlan0 get_conf
hostapd_cli -i wlan1 get_conf

# wpa=2
# key_mgmt=WPA-PSK
# group_cipher=TKIP
# rsn_pairwise_cipher=CCMP TKIP
ubus call sdk_service.wlan set_auth '{"wlan":"0","count":"0","auth":"2"}'
ubus call sdk_service.wlan set_auth '{"wlan":"1","count":"0","auth":"2"}'
ubus call sdk_service.wlan set_auth '{"wlan":"2","count":"0","auth":"2"}'
ubus call sdk_service.wlan get_auth '{"wlan":"0","count":"0"}' | jsonfilter -e "$.auth"
ubus call sdk_service.wlan get_auth '{"wlan":"1","count":"0"}' | jsonfilter -e "$.auth"
ubus call sdk_service.wlan get_auth '{"wlan":"2","count":"0"}' | jsonfilter -e "$.auth"
ubus call sdk_service.wlan commit
sleep 1
hostapd_cli -i wlan2 get_conf
hostapd_cli -i wlan0 get_conf
hostapd_cli -i wlan1 get_conf

# wpa=3
# key_mgmt=WPA-PSK
# group_cipher=TKIP
# rsn_pairwise_cipher=CCMP TKIP
# wpa_pairwise_cipher=CCMP TKIP
ubus call sdk_service.wlan set_auth '{"wlan":"0","count":"0","auth":"3"}'
ubus call sdk_service.wlan set_auth '{"wlan":"1","count":"0","auth":"3"}'
ubus call sdk_service.wlan set_auth '{"wlan":"2","count":"0","auth":"3"}'
ubus call sdk_service.wlan get_auth '{"wlan":"0","count":"0"}' | jsonfilter -e "$.auth"
ubus call sdk_service.wlan get_auth '{"wlan":"1","count":"0"}' | jsonfilter -e "$.auth"
ubus call sdk_service.wlan get_auth '{"wlan":"2","count":"0"}' | jsonfilter -e "$.auth"
ubus call sdk_service.wlan commit
sleep 1
hostapd_cli -i wlan2 get_conf
hostapd_cli -i wlan0 get_conf
hostapd_cli -i wlan1 get_conf


# 不支持
ubus call sdk_service.wlan set_auth '{"wlan":"0","count":"0","auth":"4"}'
ubus call sdk_service.wlan set_auth '{"wlan":"1","count":"0","auth":"4"}'
ubus call sdk_service.wlan set_auth '{"wlan":"2","count":"0","auth":"4"}'
ubus call sdk_service.wlan get_auth '{"wlan":"0","count":"0"}' | jsonfilter -e "$.auth"
ubus call sdk_service.wlan get_auth '{"wlan":"1","count":"0"}' | jsonfilter -e "$.auth"
ubus call sdk_service.wlan get_auth '{"wlan":"2","count":"0"}' | jsonfilter -e "$.auth"
ubus call sdk_service.wlan commit
sleep 2
hostapd_cli -i wlan2 get_conf
hostapd_cli -i wlan0 get_conf
hostapd_cli -i wlan1 get_conf

# bssid=02:03:7f:93:f7:3c
# ssid=TW506C_2G1_001117
# wps_state=disabled
ubus call sdk_service.wlan set_auth '{"wlan":"0","count":"0","auth":"0"}'
ubus call sdk_service.wlan set_auth '{"wlan":"1","count":"0","auth":"0"}'
ubus call sdk_service.wlan set_auth '{"wlan":"2","count":"0","auth":"0"}'
ubus call sdk_service.wlan get_auth '{"wlan":"0","count":"0"}' | jsonfilter -e "$.auth"
ubus call sdk_service.wlan get_auth '{"wlan":"1","count":"0"}' | jsonfilter -e "$.auth"
ubus call sdk_service.wlan get_auth '{"wlan":"2","count":"0"}' | jsonfilter -e "$.auth"
ubus call sdk_service.wlan commit
sleep 2
hostapd_cli -i wlan2 get_conf
hostapd_cli -i wlan0 get_conf
hostapd_cli -i wlan1 get_conf


ubus call sdk_service.wlan set_auth '{"wlan":"0","count":"0","auth":"3"}'
ubus call sdk_service.wlan set_auth '{"wlan":"1","count":"0","auth":"3"}'
ubus call sdk_service.wlan set_auth '{"wlan":"2","count":"0","auth":"3"}'
ubus call sdk_service.wlan commit


# set_channel/get_channel
ubus call iwinfo freqlist '{"device":"wlan0"}' | jsonfilter -e "$.results[*].channel" | xargs
ubus call iwinfo freqlist '{"device":"wlan1"}' | jsonfilter -e "$.results[*].channel" | xargs
ubus call iwinfo freqlist '{"device":"wlan2"}' | jsonfilter -e "$.results[*].channel" | xargs

ubus call iwinfo freqlist "{\"device\":\"wlan0\"}" | jsonfilter -e '$.results[*].channel' | xargs
ubus call iwinfo freqlist "{\"device\":\"wlan1\"}" | jsonfilter -e '$.results[*].channel' | xargs
ubus call iwinfo freqlist "{\"device\":\"wlan2\"}" | jsonfilter -e '$.results[*].channel' | xargs

iwinfo wlan0 frelist | awk -F '(' '{print $2}' | awk -F ')' '{print $1}' | awk -F ' ' '{print $2}' | xargs
iwinfo wlan1 frelist | awk -F '(' '{print $2}' | awk -F ')' '{print $1}' | awk -F ' ' '{print $2}' | xargs
iwinfo wlan2 frelist | awk -F '(' '{print $2}' | awk -F ')' '{print $1}' | awk -F ' ' '{print $2}' | xargs

iwinfo wlan0 frelist | awk '{print $4}' | tr ')\n' " " | tr -d '[[:alpha:]]('
iwinfo wlan1 frelist | awk '{print $4}' | tr ')\n' " " | tr -d '[[:alpha:]]('
iwinfo wlan2 frelist | awk '{print $4}' | tr ')\n' " " | tr -d '[[:alpha:]]('

ubus call sdk_service.wlan get_channel '{"wlan":"0"}' # 
ubus call sdk_service.wlan get_channel '{"wlan":"1"}' # 
ubus call sdk_service.wlan get_channel '{"wlan":"2"}' # 

ubus call sdk_service.wlan set_channel '{"wlan":"0", "channel":"10"}' # 
ubus call sdk_service.wlan set_channel '{"wlan":"1", "channel":"10"}' # 
ubus call sdk_service.wlan set_channel '{"wlan":"2", "channel":"10"}' # 

# set_bandwidth/get_bandwidth
ubus call sdk_service.wlan get_bandwidth '{"wlan":"0"}' # 
ubus call sdk_service.wlan get_bandwidth '{"wlan":"1"}' # 
ubus call sdk_service.wlan get_bandwidth '{"wlan":"2"}' # 

# set_bandwidth/get_bandwidth
ubus call sdk_service.wlan set_isolate '{"wlan":"0","count":"0","isolate":"1"}'
ubus call sdk_service.wlan set_isolate '{"wlan":"1","count":"0","isolate":"1"}'
ubus call sdk_service.wlan set_isolate '{"wlan":"2","count":"0","isolate":"1"}'
ubus call sdk_service.wlan commit
ubus call sdk_service.wlan get_isolate '{"wlan":"0"}' # 
ubus call sdk_service.wlan get_isolate '{"wlan":"1"}' # 
ubus call sdk_service.wlan get_isolate '{"wlan":"2"}' # 

ubus call sdk_service.wlan set_isolate '{"wlan":"0","count":"0","isolate":"0"}'
ubus call sdk_service.wlan set_isolate '{"wlan":"1","count":"0","isolate":"0"}'
ubus call sdk_service.wlan set_isolate '{"wlan":"2","count":"0","isolate":"0"}'
ubus call sdk_service.wlan commit
ubus call sdk_service.wlan get_isolate '{"wlan":"0"}' # 
ubus call sdk_service.wlan get_isolate '{"wlan":"1"}' # 
ubus call sdk_service.wlan get_isolate '{"wlan":"2"}' # 

# set_ssidhide/get_ssidhide
ubus call sdk_service.wlan set_ssidhide '{"wlan":"0","ssidhide":"1"}'
ubus call sdk_service.wlan set_ssidhide '{"wlan":"1","ssidhide":"1"}'
ubus call sdk_service.wlan set_ssidhide '{"wlan":"2","ssidhide":"1"}'
ubus call sdk_service.wlan commit
ubus call sdk_service.wlan get_ssidhide '{"wlan":"0"}' # 
ubus call sdk_service.wlan get_ssidhide '{"wlan":"1"}' # 
ubus call sdk_service.wlan get_ssidhide '{"wlan":"2"}' # 

ubus call sdk_service.wlan set_ssidhide '{"wlan":"0","ssidhide":"0"}'
ubus call sdk_service.wlan set_ssidhide '{"wlan":"1","ssidhide":"0"}'
ubus call sdk_service.wlan set_ssidhide '{"wlan":"2","ssidhide":"0"}'
ubus call sdk_service.wlan commit
ubus call sdk_service.wlan get_ssidhide '{"wlan":"0"}' # 
ubus call sdk_service.wlan get_ssidhide '{"wlan":"1"}' # 
ubus call sdk_service.wlan get_ssidhide '{"wlan":"2"}' # 


# get_onstalist/get_offstalist

ubus call sdk_service.wlan get_onstalist
ubus call sdk_service.wlan get_offstalist

# get_blacklist/add_blacklist/del_blacklist
ubus call sdk_service.wlan get_blacklist 
ubus call sdk_service.wlan add_blacklist '{"wlan":"0","count":"0","name":"192.168.1.100","mac":"11:22:33:44:55:66"}'
ubus call sdk_service.wlan add_blacklist '{"wlan":"0","count":"0","name":"192.168.1.11","mac":"11:22:33:44:55:11"}'
ubus call sdk_service.wlan add_blacklist '{"wlan":"0","count":"0","name":"192.168.1.12","mac":"11:22:33:44:55:12"}'
ubus call sdk_service.wlan add_blacklist '{"wlan":"0","count":"0","name":"192.168.1.13","mac":"11:22:33:44:55:13"}'
ubus call sdk_service.wlan commit
ubus call sdk_service.wlan get_blacklist 

ubus call sdk_service.wlan del_blacklist '{"wlan":"0","count":"0","name":"192.168.1.100","mac":"11:22:33:44:55:66"}'
ubus call sdk_service.wlan del_blacklist '{"wlan":"0","count":"0","name":"192.168.1.11","mac":"11:22:33:44:55:11"}'
ubus call sdk_service.wlan del_blacklist '{"wlan":"0","count":"0","name":"192.168.1.12","mac":"11:22:33:44:55:12"}'
ubus call sdk_service.wlan del_blacklist '{"wlan":"0","count":"0","name":"192.168.1.13","mac":"11:22:33:44:55:13"}'
ubus call sdk_service.wlan commit
ubus call sdk_service.wlan get_blacklist 

# get_whitelist/add_whitelist/del_whitelist
ubus call sdk_service.wlan get_whitelist 
ubus call sdk_service.wlan add_whitelist '{"wlan":"0","count":"0","name":"192.168.1.100","mac":"11:22:33:44:55:66"}'
ubus call sdk_service.wlan add_whitelist '{"wlan":"0","count":"0","name":"192.168.1.11","mac":"11:22:33:44:55:11"}'
ubus call sdk_service.wlan add_whitelist '{"wlan":"0","count":"0","name":"192.168.1.12","mac":"11:22:33:44:55:12"}'
ubus call sdk_service.wlan add_whitelist '{"wlan":"0","count":"0","name":"192.168.1.13","mac":"11:22:33:44:55:13"}'
ubus call sdk_service.wlan commit
ubus call sdk_service.wlan get_whitelist 

ubus call sdk_service.wlan del_whitelist '{"wlan":"0","count":"0","name":"192.168.1.100","mac":"11:22:33:44:55:66"}'
ubus call sdk_service.wlan del_whitelist '{"wlan":"0","count":"0","name":"192.168.1.11","mac":"11:22:33:44:55:11"}'
ubus call sdk_service.wlan del_whitelist '{"wlan":"0","count":"0","name":"192.168.1.12","mac":"11:22:33:44:55:12"}'
ubus call sdk_service.wlan del_whitelist '{"wlan":"0","count":"0","name":"192.168.1.13","mac":"11:22:33:44:55:13"}'
ubus call sdk_service.wlan commit
ubus call sdk_service.wlan get_whitelist 

# set_macfilter/get_macfilter
ubus call sdk_service.wlan  set_macfilter '{"wlan":"0","count":"0","macfilter":"deny"}'
ubus call sdk_service.wlan commit
ubus call sdk_service.wlan  get_macfilter '{"wlan":"0","count":"0"}'

ubus call sdk_service.wlan  set_macfilter '{"wlan":"0","count":"0","macfilter":"allow"}'
ubus call sdk_service.wlan commit
ubus call sdk_service.wlan  get_macfilter '{"wlan":"0","count":"0"}'

ubus call sdk_service.wlan  set_macfilter '{"wlan":"0","count":"0","macfilter":"none"}'
ubus call sdk_service.wlan commit
ubus call sdk_service.wlan  get_macfilter '{"wlan":"0","count":"0"}'

# get_connect_status/get_extend_status/get_scan_info/get_network_info
ubus call sdk_service.wlan get_connect_status
ubus call sdk_service.wlan get_extend_status
ubus call sdk_service.wlan get_scan_info  '{"wlan":"0"}'
ubus call sdk_service.wlan get_network_info

# set_noscan/get_noscan
ubus call sdk_service.wlan set_noscan '{"noscan":"1"}'
ubus call sdk_service.wlan commit
ubus call sdk_service.wlan get_noscan

ubus call sdk_service.wlan set_noscan '{"noscan":"0"}'
ubus call sdk_service.wlan commit
ubus call sdk_service.wlan get_noscan


. shunit2
