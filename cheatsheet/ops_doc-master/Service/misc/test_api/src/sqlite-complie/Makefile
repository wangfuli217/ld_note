####################################################################
#
# all: 重新编译整个工程;
# 编译完成在当前目录下有个build目录
#
#####################################################################

CC = gcc
SOURCE_NAME = sqlite-autoconf-3150200
SOURCE_PATH = $(SOURCE_NAME)
CONFIG_PREFIX = $(shell pwd)/build
CONFIG_CFLAGS = -Os
CONFIG_OHTERS = --build=i386-linux \
				--enable-readline \
				--enable-threadsafe \
				--enable-dynamic-extensions
all: reset

reset: clean config building

#重新配置项目
config:
	cd $(SOURCE_PATH);./configure CC=$(CC) '--prefix=$(CONFIG_PREFIX)' $(CONFIG_OHTERS) CFLAGS='$(CONFIG_CFLAGS)';cd -

building: 
	cd $(SOURCE_PATH);make all;make install
	
clean:
	rm -rf $(CONFIG_PREFIX)
	rm -rf $(SOURCE_PATH)
	tar -xvf $(SOURCE_NAME).tar.gz
	chmod 777 -R $(SOURCE_PATH)
	