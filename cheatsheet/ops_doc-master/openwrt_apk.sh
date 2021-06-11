执行make时，若无任何目标指定，则默认目标是world
执行make时，无参数指定，则会进入第一个逻辑。如果执行命令make OPENWRT_BUILD=1，则直接进入第二个逻辑。

# make clean 
# dirclean 
# prereq 
# prepare 
# world 
# package/symlinks 
# package/symlinks-install 
# package/symlinks-clean
# mkfs-$(1)                                                          -> image.mk
# download compile image_prepare mkfs_prepare kernel_prepare install -> image.mk
apk(Creating packages){
package/Makefile
package/patches
package/files
package/src 
}

env(){
TOPDIR:=${CURDIR} # 根目录
LC_ALL:=C
LANG:=C 
PATH:=$(TOPDIR)/staging_dir/host/bin:$(PATH) # 交叉编译工具路径

OPENWRT_BUILD=1
GREP_OPTIONS=
---------tmp/.host.mk 对应 include host.mk
# HOST_OS:=Linux
# HOST_ARCH:=x86_64
# GNU_HOST_NAME:=x86_64-linux-gnu
# FIND_L=find -L $(1)
try-run          # 函数
host-cc-option   # 函数
---------对应 include debug.mk
# d: show subdirectory tree
# t: show added targets
# l: show legacy targets
# r: show autorebuild messages
# v: verbose (no .SILENCE for common targets)
debug      # 函数
warn       # 函数
debug_eval # 函数
warn_eval  # 函数
---------对应 include toplevel.mk
export RELEASE          # Designated Driver
export REVISION         # r49395
export OPENWRTVERSION   # 
export LD_LIBRARY_PATH:=$(subst ::,:,$(if $(LD_LIBRARY_PATH),$(LD_LIBRARY_PATH):)$(TOPDIR)/staging_dir/host/lib)
export DYLD_LIBRARY_PATH:=$(subst ::,:,$(if $(DYLD_LIBRARY_PATH),$(DYLD_LIBRARY_PATH):)$(TOPDIR)/staging_dir/host/lib)
export GIT_CONFIG_PARAMETERS='core.autocrlf=false'
export MAKE_JOBSERVER=$(filter --jobserver%,$(MAKEFLAGS))
export CFLAGS=
export SCAN_COOKIE
---------对应 include package.mk  # 这里定义一系列的 PKG_XX 

$(eval $(call BuildPackage,包名)) # 定义各种 Package, Build 宏


BUILD_DIR           # 
STAGING_DIR         # 
BIN_DIR             # 
BUILD_LOG_DIR       # 
STAGING_DIR_HOST    # /home/ubuntu/x86/x86/openwrt/staging_dir/host
TOOLCHAIN_DIR       # 
BUILD_DIR_HOST      # 
BUILD_DIR_TOOLCHAIN # 
TMP_DIR             # /home/ubuntu/x86/x86/openwrt/tmp
}


env(path){
CCACHE_DIR=/home/ubuntu/x86/x86/openwrt/staging_dir/target-x86_64_glibc-2.22/ccache
CFLAGS=-Os -pipe -fno-caller-saves -fno-plt -fhonour-copts -Wno-error=unused-but-set-variable -Wno-error=unused-result -iremap /home/ubuntu/x86/x86/openwrt/build_dir/target-x86_64_glibc-2.22/hello:hello -Wformat -Werror=format-security -D_FORTIFY_SOURCE=1 -Wl,-z,now -Wl,-z,relro  -I/home/ubuntu/x86/x86/openwrt/staging_dir/target-x86_64_glibc-2.22/usr/include -I/home/ubuntu/x86/x86/openwrt/staging_dir/target-x86_64_glibc-2.22/include -I/home/ubuntu/x86/x86/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/usr/include -I/home/ubuntu/x86/x86/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/include 
CONFIG_SITE=/home/ubuntu/x86/x86/openwrt/include/site/x86_64
CXXFLAGS=-Os -pipe -fno-caller-saves -fno-plt -fhonour-copts -Wno-error=unused-but-set-variable -Wno-error=unused-result -iremap /home/ubuntu/x86/x86/openwrt/build_dir/target-x86_64_glibc-2.22/hello:hello -Wformat -Werror=format-security -D_FORTIFY_SOURCE=1 -Wl,-z,now -Wl,-z,relro  -I/home/ubuntu/x86/x86/openwrt/staging_dir/target-x86_64_glibc-2.22/usr/include -I/home/ubuntu/x86/x86/openwrt/staging_dir/target-x86_64_glibc-2.22/include -I/home/ubuntu/x86/x86/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/usr/include -I/home/ubuntu/x86/x86/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/include 
AS=x86_64-openwrt-linux-gnu-gcc -c -Os -pipe -fno-caller-saves -fno-plt -fhonour-copts -Wno-error=unused-but-set-variable -Wno-error=unused-result -iremap /home/ubuntu/x86/x86/openwrt/build_dir/target-x86_64_glibc-2.22/hello:hello -Wformat -Werror=format-security -D_FORTIFY_SOURCE=1 -Wl,-z,now -Wl,-z,relro
PKG_CONFIG=/home/ubuntu/x86/x86/openwrt/staging_dir/host/bin/pkg-config
PATH=/home/ubuntu/x86/x86/openwrt/staging_dir/target-x86_64_glibc-2.22/host/bin:/home/ubuntu/x86/x86/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/bin:/home/ubuntu/x86/x86/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/bin:/home/ubuntu/x86/x86/openwrt/staging_dir/host/bin:/home/ubuntu/x86/x86/openwrt/staging_dir/host/bin:/usr/java/jdk1.6.0_29/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/java/jdk1.6.0_29/jre/bin
M4=/home/ubuntu/x86/x86/openwrt/staging_dir/host/bin/m4
ACLOCAL_INCLUDE=-I /home/ubuntu/x86/x86/openwrt/staging_dir/target-x86_64_glibc-2.22/usr/share/aclocal -I /home/ubuntu/x86/x86/openwrt/staging_dir/target-x86_64_glibc-2.22/host/share/aclocal
LDFLAGS=-L/home/ubuntu/x86/x86/openwrt/staging_dir/target-x86_64_glibc-2.22/usr/lib -L/home/ubuntu/x86/x86/openwrt/staging_dir/target-x86_64_glibc-2.22/lib -L/home/ubuntu/x86/x86/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/usr/lib -L/home/ubuntu/x86/x86/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/lib -znow -zrelro 
STAGING_DIR_HOST=/home/ubuntu/x86/x86/openwrt/staging_dir/host
PWD=/home/ubuntu/x86/x86/openwrt/package/helloworld
STAGING_PREFIX=/home/ubuntu/x86/x86/openwrt/staging_dir/target-x86_64_glibc-2.22/usr
SH_FUNC=. /home/ubuntu/x86/x86/openwrt/include/shell.sh;
STAGING_DIR=/home/ubuntu/x86/x86/openwrt/staging_dir/target-x86_64_glibc-2.22
TOPDIR=/home/ubuntu/x86/x86/openwrt
MAKEFLAGS=w -- ARCH=x86_64 CROSS=x86_64-openwrt-linux-gnu- SIZE=x86_64-openwrt-linux-gnu-size OBJDUMP=x86_64-openwrt-linux-gnu-objdump OBJCOPY=x86_64-openwrt-linux-gnu-objcopy STRIP=x86_64-openwrt-linux-gnu-strip RANLIB=x86_64-openwrt-linux-gnu-gcc-ranlib CXX=x86_64-openwrt-linux-gnu-g++ GCC=x86_64-openwrt-linux-gnu-gcc CC=x86_64-openwrt-linux-gnu-gcc NM=x86_64-openwrt-linux-gnu-gcc-nm LD=x86_64-openwrt-linux-gnu-ld AS=x86_64-openwrt-linux-gnu-gcc\ -c\ -Os\ -pipe\ -fno-caller-saves\ -fno-plt\ -fhonour-copts\ -Wno-error=unused-but-set-variable\ -Wno-error=unused-result\ -iremap\ /home/ubuntu/x86/x86/openwrt/build_dir/target-x86_64_glibc-2.22/hello:hello\ -Wformat\ -Werror=format-security\ -D_FORTIFY_SOURCE=1\ -Wl,-z,now\ -Wl,-z,relro AR=x86_64-openwrt-linux-gnu-gcc-ar
PKG_CONFIG_LIBDIR=/home/ubuntu/x86/x86/openwrt/staging_dir/target-x86_64_glibc-2.22/usr/lib/pkgconfig:/home/ubuntu/x86/x86/openwrt/staging_dir/target-x86_64_glibc-2.22/usr/share/pkgconfig
PKG_CONFIG_PATH=/home/ubuntu/x86/x86/openwrt/staging_dir/target-x86_64_glibc-2.22/usr/lib/pkgconfig:/home/ubuntu/x86/x86/openwrt/staging_dir/target-x86_64_glibc-2.22/usr/share/pkgconfig
BISON_PKGDATADIR=/home/ubuntu/x86/x86/openwrt/staging_dir/host/share/bison
TMP_DIR=/home/ubuntu/x86/x86/openwrt/tmp
}
env(variable){
REVISION=r49395
TARGET=/usr/local/arm/arm-2009q3/bin/arm-none-linux-gnueabi
OBJCOPY=x86_64-openwrt-linux-gnu-objcopy
V=s
TZ=UTC
_=/usr/bin/make
OPENWRT_BUILD=1
GCC=x86_64-openwrt-linux-gnu-gcc
GIT_CONFIG_PARAMETERS='core.autocrlf=false'
EXTRA_OPTIMIZATION=-fno-caller-saves
RELEASE=Designated Driver
SOURCE_DATE_EPOCH=1467265145
AR=x86_64-openwrt-linux-gnu-gcc-ar
MAKE_JOBSERVER=
SCAN_COOKIE=25959
SIZE=x86_64-openwrt-linux-gnu-size
HOSTCC_NOCACHE=gcc
GCC_HONOUR_COPTS=0
IS_TTY=1
HOSTCC_WRAPPER=cc
LD=x86_64-openwrt-linux-gnu-ld
RANLIB=x86_64-openwrt-linux-gnu-gcc-ranlib
BUILD_VARIANT=
TARGET_CC_NOCACHE=x86_64-openwrt-linux-gnu-gcc
SHLVL=3
NM=x86_64-openwrt-linux-gnu-gcc-nm
CC=x86_64-openwrt-linux-gnu-gcc
MAKEOVERRIDES=${-*-command-variables-*-}
CROSS=x86_64-openwrt-linux-gnu-
CONTROL=Package: hello
Version: 1
Depends: libc, libssp, librt, libpthread
Source: package/helloworld
Section: utils
Architecture: x86_64
Installed-Size: 0
LANGUAGE=zh_CN:zh
ARCH=x86_64
MFLAGS=-w
OBJDUMP=x86_64-openwrt-linux-gnu-objdump
STRIP=x86_64-openwrt-linux-gnu-strip
TARGET_CXX_NOCACHE=x86_64-openwrt-linux-gnu-g++
BUILD_SUBDIR=package/helloworld
CXX=x86_64-openwrt-linux-gnu-g++
LC_ALL=C
GREP_OPTIONS=
LANG=C
DESCRIPTION=    hello -- prints a snarky message
NO_TRACE_MAKE=make V=ss
MAKELEVEL=4
}
env(ld){
x86_64-openwrt-linux-gnu-gcc -v  -L/home/ubuntu/x86/x86/openwrt/staging_dir/target-x86_64_glibc-2.22/usr/lib -L/home/ubuntu/x86/x86/openwrt/staging_dir/target-x86_64_glibc-2.22/lib -L/home/ubuntu/x86/x86/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/usr/lib -L/home/ubuntu/x86/x86/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/lib -znow -zrelro  hello.o -o hello
Reading specs from /home/ubuntu/x86/x86/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/bin/../lib/gcc/x86_64-openwrt-linux-gnu/5.3.0/specs
COLLECT_GCC=x86_64-openwrt-linux-gnu-gcc
COLLECT_LTO_WRAPPER=/home/ubuntu/x86/x86/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/bin/../libexec/gcc/x86_64-openwrt-linux-gnu/5.3.0/lto-wrapper
Target: x86_64-openwrt-linux-gnu
Configured with: /home/ubuntu/openwrt/raspberry/openwrt/build_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/gcc-5.3.0/configure --with-bugurl=https://dev.openwrt.org/ --with-pkgversion='OpenWrt GCC 5.3.0 r49395' --prefix=/home/ubuntu/openwrt/raspberry/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22 --build=x86_64-linux-gnu --host=x86_64-linux-gnu --target=x86_64-openwrt-linux-gnu --with-gnu-ld --enable-target-optspace --disable-libgomp --disable-libmudflap --disable-multilib --disable-nls --without-isl --without-cloog --with-host-libstdcxx=-lstdc++ --with-gmp=/home/ubuntu/openwrt/raspberry/openwrt/staging_dir/host --with-mpfr=/home/ubuntu/openwrt/raspberry/openwrt/staging_dir/host --with-mpc=/home/ubuntu/openwrt/raspberry/openwrt/staging_dir/host --disable-decimal-float --with-diagnostics-color=auto-if-env --enable-libssp --enable-__cxa_atexit --with-headers=/home/ubuntu/openwrt/raspberry/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/include --disable-libsanitizer --enable-languages=c,c++ --enable-shared --enable-threads --with-slibdir=/home/ubuntu/openwrt/raspberry/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/lib --enable-lto --with-libelf=/home/ubuntu/openwrt/raspberry/openwrt/staging_dir/host
Thread model: posix
gcc version 5.3.0 (OpenWrt GCC 5.3.0 r49395) 
COMPILER_PATH=/home/ubuntu/x86/x86/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/bin/../libexec/gcc/x86_64-openwrt-linux-gnu/5.3.0/:/home/ubuntu/x86/x86/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/bin/../libexec/gcc/:/home/ubuntu/x86/x86/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/bin/../lib/gcc/x86_64-openwrt-linux-gnu/5.3.0/../../../../x86_64-openwrt-linux-gnu/bin/
LIBRARY_PATH=/home/ubuntu/x86/x86/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/bin/../lib/gcc/x86_64-openwrt-linux-gnu/5.3.0/:/home/ubuntu/x86/x86/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/bin/../lib/gcc/:/home/ubuntu/x86/x86/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/bin/../lib/gcc/x86_64-openwrt-linux-gnu/5.3.0/../../../../x86_64-openwrt-linux-gnu/lib/
COLLECT_GCC_OPTIONS='-v' '-L/home/ubuntu/x86/x86/openwrt/staging_dir/target-x86_64_glibc-2.22/usr/lib' '-L/home/ubuntu/x86/x86/openwrt/staging_dir/target-x86_64_glibc-2.22/lib' '-L/home/ubuntu/x86/x86/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/usr/lib' '-L/home/ubuntu/x86/x86/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/lib' '-z' 'now' '-z' 'relro' '-o' 'hello' '-mtune=generic' '-march=x86-64'
 /home/ubuntu/x86/x86/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/bin/../libexec/gcc/x86_64-openwrt-linux-gnu/5.3.0/collect2 -plugin /home/ubuntu/x86/x86/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/bin/../libexec/gcc/x86_64-openwrt-linux-gnu/5.3.0/liblto_plugin.so -plugin-opt=/home/ubuntu/x86/x86/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/bin/../libexec/gcc/x86_64-openwrt-linux-gnu/5.3.0/lto-wrapper -plugin-opt=-fresolution=/tmp/cci4y0MX.res -plugin-opt=-pass-through=-lgcc_s -plugin-opt=-pass-through=-lc -plugin-opt=-pass-through=-lgcc_s --eh-frame-hdr -m elf_x86_64 -dynamic-linker /lib64/ld-linux-x86-64.so.2 -o hello -z now -z relro /home/ubuntu/x86/x86/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/bin/../lib/gcc/x86_64-openwrt-linux-gnu/5.3.0/../../../../x86_64-openwrt-linux-gnu/lib/crt1.o /home/ubuntu/x86/x86/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/bin/../lib/gcc/x86_64-openwrt-linux-gnu/5.3.0/../../../../x86_64-openwrt-linux-gnu/lib/crti.o /home/ubuntu/x86/x86/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/bin/../lib/gcc/x86_64-openwrt-linux-gnu/5.3.0/crtbegin.o -L/home/ubuntu/x86/x86/openwrt/staging_dir/target-x86_64_glibc-2.22/usr/lib -L/home/ubuntu/x86/x86/openwrt/staging_dir/target-x86_64_glibc-2.22/lib -L/home/ubuntu/x86/x86/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/usr/lib -L/home/ubuntu/x86/x86/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/lib -L /home/ubuntu/x86/x86/openwrt/staging_dir/target-x86_64_glibc-2.22/usr/lib -rpath-link /home/ubuntu/x86/x86/openwrt/staging_dir/target-x86_64_glibc-2.22/usr/lib -L/home/ubuntu/x86/x86/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/bin/../lib/gcc/x86_64-openwrt-linux-gnu/5.3.0 -L/home/ubuntu/x86/x86/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/bin/../lib/gcc -L/home/ubuntu/x86/x86/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/bin/../lib/gcc/x86_64-openwrt-linux-gnu/5.3.0/../../../../x86_64-openwrt-linux-gnu/lib hello.o -lgcc_s -lc -lgcc_s /home/ubuntu/x86/x86/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/bin/../lib/gcc/x86_64-openwrt-linux-gnu/5.3.0/crtend.o /home/ubuntu/x86/x86/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/bin/../lib/gcc/x86_64-openwrt-linux-gnu/5.3.0/../../../../x86_64-openwrt-linux-gnu/lib/crtn.o
}
env(cc){
x86_64-openwrt-linux-gnu-gcc -v -Os -pipe -fno-caller-saves -fno-plt -fhonour-copts -Wno-error=unused-but-set-variable -Wno-error=unused-result -iremap /home/ubuntu/x86/x86/openwrt/build_dir/target-x86_64_glibc-2.22/hello:hello -Wformat -Werror=format-security -D_FORTIFY_SOURCE=1 -Wl,-z,now -Wl,-z,relro  -I/home/ubuntu/x86/x86/openwrt/staging_dir/target-x86_64_glibc-2.22/usr/include -I/home/ubuntu/x86/x86/openwrt/staging_dir/target-x86_64_glibc-2.22/include -I/home/ubuntu/x86/x86/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/usr/include -I/home/ubuntu/x86/x86/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/include  -c hello.c
Reading specs from /home/ubuntu/x86/x86/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/bin/../lib/gcc/x86_64-openwrt-linux-gnu/5.3.0/specs
COLLECT_GCC=x86_64-openwrt-linux-gnu-gcc
Target: x86_64-openwrt-linux-gnu
Configured with: /home/ubuntu/openwrt/raspberry/openwrt/build_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/gcc-5.3.0/configure --with-bugurl=https://dev.openwrt.org/ --with-pkgversion='OpenWrt GCC 5.3.0 r49395' --prefix=/home/ubuntu/openwrt/raspberry/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22 --build=x86_64-linux-gnu --host=x86_64-linux-gnu --target=x86_64-openwrt-linux-gnu --with-gnu-ld --enable-target-optspace --disable-libgomp --disable-libmudflap --disable-multilib --disable-nls --without-isl --without-cloog --with-host-libstdcxx=-lstdc++ --with-gmp=/home/ubuntu/openwrt/raspberry/openwrt/staging_dir/host --with-mpfr=/home/ubuntu/openwrt/raspberry/openwrt/staging_dir/host --with-mpc=/home/ubuntu/openwrt/raspberry/openwrt/staging_dir/host --disable-decimal-float --with-diagnostics-color=auto-if-env --enable-libssp --enable-__cxa_atexit --with-headers=/home/ubuntu/openwrt/raspberry/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/include --disable-libsanitizer --enable-languages=c,c++ --enable-shared --enable-threads --with-slibdir=/home/ubuntu/openwrt/raspberry/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/lib --enable-lto --with-libelf=/home/ubuntu/openwrt/raspberry/openwrt/staging_dir/host
Thread model: posix
gcc version 5.3.0 (OpenWrt GCC 5.3.0 r49395) 
COLLECT_GCC_OPTIONS='-v' '-Os' '-pipe' '-fno-caller-saves' '-fno-plt' '-fhonour-copts' '-Wno-error=unused-but-set-variable' '-Wno-error=unused-result' '-iremap' '/home/ubuntu/x86/x86/openwrt/build_dir/target-x86_64_glibc-2.22/hello:hello' '-Wformat=1' '-Werror=format-security' '-D' '_FORTIFY_SOURCE=1' '-I' '/home/ubuntu/x86/x86/openwrt/staging_dir/target-x86_64_glibc-2.22/usr/include' '-I' '/home/ubuntu/x86/x86/openwrt/staging_dir/target-x86_64_glibc-2.22/include' '-I' '/home/ubuntu/x86/x86/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/usr/include' '-I' '/home/ubuntu/x86/x86/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/include' '-c' '-mtune=generic' '-march=x86-64'
 /home/ubuntu/x86/x86/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/bin/../libexec/gcc/x86_64-openwrt-linux-gnu/5.3.0/cc1 -quiet -v -I /home/ubuntu/x86/x86/openwrt/staging_dir/target-x86_64_glibc-2.22/usr/include -I /home/ubuntu/x86/x86/openwrt/staging_dir/target-x86_64_glibc-2.22/include -I /home/ubuntu/x86/x86/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/usr/include -I /home/ubuntu/x86/x86/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/include -iprefix /home/ubuntu/x86/x86/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/bin/../lib/gcc/x86_64-openwrt-linux-gnu/5.3.0/ -idirafter /home/ubuntu/x86/x86/openwrt/staging_dir/target-x86_64_glibc-2.22/usr/include -D _FORTIFY_SOURCE=1 -iremap /home/ubuntu/x86/x86/openwrt/build_dir/target-x86_64_glibc-2.22/hello:hello hello.c -quiet -dumpbase hello.c -mtune=generic -march=x86-64 -auxbase hello -Os -Wno-error=unused-but-set-variable -Wno-error=unused-result -Wformat=1 -Werror=format-security -version -fno-caller-saves -fno-plt -fhonour-copts -o - |
 /home/ubuntu/x86/x86/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/bin/../lib/gcc/x86_64-openwrt-linux-gnu/5.3.0/../../../../x86_64-openwrt-linux-gnu/bin/as -v -I /home/ubuntu/x86/x86/openwrt/staging_dir/target-x86_64_glibc-2.22/usr/include -I /home/ubuntu/x86/x86/openwrt/staging_dir/target-x86_64_glibc-2.22/include -I /home/ubuntu/x86/x86/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/usr/include -I /home/ubuntu/x86/x86/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/include --64 -o hello.o
GNU assembler version 2.25.1 (x86_64-openwrt-linux-gnu) using BFD version (GNU Binutils) 2.25.1
GNU C11 (OpenWrt GCC 5.3.0 r49395) version 5.3.0 (x86_64-openwrt-linux-gnu)
        compiled by GNU C version 4.6.3, GMP version 6.1.0, MPFR version 3.1.4, MPC version 1.0.3
GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
ignoring duplicate directory "/home/ubuntu/x86/x86/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/bin/../lib/gcc/../../lib/gcc/x86_64-openwrt-linux-gnu/5.3.0/include"
ignoring duplicate directory "/home/ubuntu/x86/x86/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/bin/../lib/gcc/../../lib/gcc/x86_64-openwrt-linux-gnu/5.3.0/include-fixed"
ignoring duplicate directory "/home/ubuntu/x86/x86/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/bin/../lib/gcc/../../lib/gcc/x86_64-openwrt-linux-gnu/5.3.0/../../../../x86_64-openwrt-linux-gnu/sys-include"
ignoring duplicate directory "/home/ubuntu/x86/x86/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/bin/../lib/gcc/../../lib/gcc/x86_64-openwrt-linux-gnu/5.3.0/../../../../x86_64-openwrt-linux-gnu/include"
ignoring duplicate directory "/home/ubuntu/x86/x86/openwrt/staging_dir/target-x86_64_glibc-2.22/usr/include"
  as it is a non-system directory that duplicates a system directory
ignoring duplicate directory "/home/ubuntu/x86/x86/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/include"
  as it is a non-system directory that duplicates a system directory
#include "..." search starts here:
#include <...> search starts here:
 /home/ubuntu/x86/x86/openwrt/staging_dir/target-x86_64_glibc-2.22/include
 /home/ubuntu/x86/x86/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/usr/include
 /home/ubuntu/x86/x86/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/bin/../lib/gcc/x86_64-openwrt-linux-gnu/5.3.0/include
 /home/ubuntu/x86/x86/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/bin/../lib/gcc/x86_64-openwrt-linux-gnu/5.3.0/include-fixed
 /home/ubuntu/x86/x86/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/bin/../lib/gcc/x86_64-openwrt-linux-gnu/5.3.0/../../../../x86_64-openwrt-linux-gnu/sys-include
 /home/ubuntu/x86/x86/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/bin/../lib/gcc/x86_64-openwrt-linux-gnu/5.3.0/../../../../x86_64-openwrt-linux-gnu/include
 /home/ubuntu/x86/x86/openwrt/staging_dir/target-x86_64_glibc-2.22/usr/include
End of search list.
GNU C11 (OpenWrt GCC 5.3.0 r49395) version 5.3.0 (x86_64-openwrt-linux-gnu)
        compiled by GNU C version 4.6.3, GMP version 6.1.0, MPFR version 3.1.4, MPC version 1.0.3
GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
Compiler executable checksum: 2498fa49fe9a9468d35a6cf10769d776
COMPILER_PATH=/home/ubuntu/x86/x86/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/bin/../libexec/gcc/x86_64-openwrt-linux-gnu/5.3.0/:/home/ubuntu/x86/x86/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/bin/../libexec/gcc/:/home/ubuntu/x86/x86/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/bin/../lib/gcc/x86_64-openwrt-linux-gnu/5.3.0/../../../../x86_64-openwrt-linux-gnu/bin/
LIBRARY_PATH=/home/ubuntu/x86/x86/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/bin/../lib/gcc/x86_64-openwrt-linux-gnu/5.3.0/:/home/ubuntu/x86/x86/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/bin/../lib/gcc/:/home/ubuntu/x86/x86/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/bin/../lib/gcc/x86_64-openwrt-linux-gnu/5.3.0/../../../../x86_64-openwrt-linux-gnu/lib/
COLLECT_GCC_OPTIONS='-v' '-Os' '-pipe' '-fno-caller-saves' '-fno-plt' '-fhonour-copts' '-Wno-error=unused-but-set-variable' '-Wno-error=unused-result' '-iremap' '/home/ubuntu/x86/x86/openwrt/build_dir/target-x86_64_glibc-2.22/hello:hello' '-Wformat=1' '-Werror=format-security' '-D' '_FORTIFY_SOURCE=1' '-I' '/home/ubuntu/x86/x86/openwrt/staging_dir/target-x86_64_glibc-2.22/usr/include' '-I' '/home/ubuntu/x86/x86/openwrt/staging_dir/target-x86_64_glibc-2.22/include' '-I' '/home/ubuntu/x86/x86/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/usr/include' '-I' '/home/ubuntu/x86/x86/openwrt/staging_dir/toolchain-x86_64_gcc-5.3.0_glibc-2.22/include' '-c' '-mtune=generic' '-march=x86-64'
}



