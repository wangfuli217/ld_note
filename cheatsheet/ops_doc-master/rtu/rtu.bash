cat - <<'EOF'
  rtu_i_upgrade: 使用 MFGTools 升级配置说明 
  rtu_i_upgrade_MFGTools: MFGTools 配置文件详细说明
  
  rtu_i_disk : sfdisk 初始化分区
  rtu_i_rtud : lms 工程构建 rtud slotd hostd 等
  rtu_i_hostd: 上层协议测试工具，shunit2+hostd
  rtu_i_slotd: 下层协议测试工具，shunit2+slotd
  rtu_i_gpio : gpio部分实现
  
  rtu_i_rootfs: 文件系统构建     -> 升级 lms_i_upgrade
  rtu_i_build_uboot: uboot构建   -> 升级 lms_i_upgrade
  rtu_i_build_kernel:内核构建    -> 升级 lms_i_upgrade
EOF


rtu_help(){
  echo "rtu_rootfs"
  echo "rtu_upgrade"
  echo "rtu_rtud"
}


