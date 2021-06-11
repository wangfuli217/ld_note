1. 使用外部 toolchain 编译 openwrt
------------------------------------------------------------------------
默认编译 openwrt 时会先编译一套 toolchain. 这个步骤耗时较长. 使用外部 toolchain 可以多个 project 共用一套 
toolchain , 而且也不重再编译它了. 省时省力.
make menuconfig
[*] Advanced configuration options (for developers)  --->

 [*]   Use external toolchain  --->
  │ │         --- Use external toolchain                                                      │ │  
  │ │         [ ]   Use host s toolchain                                                      │ │  
  │ │         (mipsel-openwrt-linux-uclibc) Target name                                       │ │  
  │ │         (mipsel-openwrt-linux-uclibc-) Toolchain prefix                                 │ │  
  │ │         (/opt/toolchain-mipsel_24kec+dsp_gcc-4.8-linaro_uClibc-0.9.33.2) Toolchain root │ │  
  │ │         (uclibc) Toolchain libc                                                         │ │  
  │ │         (./usr/bin ./bin) Toolchain program path                                        │ │  
  │ │         (./usr/include ./include) Toolchain include path                                │ │  
  │ │         (./usr/lib ./lib) Toolchain library path   

编译完在 .config 下可以见到以下变量的定义:

CONFIG_EXTERNAL_TOOLCHAIN=y
# CONFIG_NATIVE_TOOLCHAIN is not set
CONFIG_TARGET_NAME="mipsel-openwrt-linux-uclibc"
CONFIG_TOOLCHAIN_PREFIX="mipsel-openwrt-linux-uclibc-"
CONFIG_TOOLCHAIN_ROOT="/opt/toolchain-mipsel_24kec+dsp_gcc-4.8-linaro_uClibc-0.9.33.2"
CONFIG_TOOLCHAIN_LIBC="uclibc"
CONFIG_TOOLCHAIN_BIN_PATH="./usr/bin ./bin"
CONFIG_TOOLCHAIN_INC_PATH="./usr/include ./include"
CONFIG_TOOLCHAIN_LIB_PATH="./usr/lib ./lib"

这些变量在 rules.mk 里起作用.

我使用主 trunk 的 openwrt, 编译 kenrel 时碰到了问题. 在 kernel 的 Makefile 里设置 KBUILD_VERBOSE = 1 看到是交叉编译器没有指定路径. 跟踪到是 rules.mk 里 TARGET_CROSS 只保留了交叉编译器前缀, 没加路径. 改了一下就可以完全编译过了.

diff --git a/rules.mk b/rules.mk
index 0822979..70f3afc 100644
--- a/rules.mk
+++ b/rules.mk
@@ -144,9 +144,9 @@ ifndef DUMP
     TARGET_PATH:=$(TOOLCHAIN_DIR)/bin:$(TARGET_PATH)
   else
     ifeq ($(CONFIG_NATIVE_TOOLCHAIN),)
-      TARGET_CROSS:=$(call qstrip,$(CONFIG_TOOLCHAIN_PREFIX))
       TOOLCHAIN_ROOT_DIR:=$(call qstrip,$(CONFIG_TOOLCHAIN_ROOT))
       TOOLCHAIN_BIN_DIRS:=$(patsubst ./%,$(TOOLCHAIN_ROOT_DIR)/%,$(call qstrip,$(CONFIG_TOOLCHAIN_BIN_PATH)))
+      TARGET_CROSS:=$(call qstrip,$(TOOLCHAIN_ROOT_DIR)/bin/$(CONFIG_TOOLCHAIN_PREFIX))
       TOOLCHAIN_INC_DIRS:=$(patsubst ./%,$(TOOLCHAIN_ROOT_DIR)/%,$(call qstrip,$(CONFIG_TOOLCHAIN_INC_PATH)))
       TOOLCHAIN_LIB_DIRS:=$(patsubst ./%,$(TOOLCHAIN_ROOT_DIR)/%,$(call qstrip,$(CONFIG_TOOLCHAIN_LIB_PATH)))
       ifneq ($(TOOLCHAIN_BIN_DIRS),)

