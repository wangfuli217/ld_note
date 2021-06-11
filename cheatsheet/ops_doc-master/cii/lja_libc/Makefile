export BUILD_BASE = $(shell pwd)
MAKE= make -w

#按照次序执行
SRC_PATH += $(BUILD_BASE)/lja_type
SRC_PATH += $(BUILD_BASE)/lja_bit
SRC_PATH += $(BUILD_BASE)/lja_hash_func
SRC_PATH += $(BUILD_BASE)/lja_list
SRC_PATH += $(BUILD_BASE)/lja_macro
SRC_PATH += $(BUILD_BASE)/lja_mem
SRC_PATH += $(BUILD_BASE)/lja_pcap
SRC_PATH += $(BUILD_BASE)/lja_pkt
SRC_PATH += $(BUILD_BASE)/lja_print
SRC_PATH += $(BUILD_BASE)/lja_shmhash
SRC_PATH += $(BUILD_BASE)/lja_sort
SRC_PATH += $(BUILD_BASE)/lja_time
SRC_PATH += $(BUILD_BASE)/lja_utils
SRC_PATH += $(BUILD_BASE)/lja_pkt_cache

all:
	sed  -i -e "s#ROOT_PATH=.*#ROOT_PATH=${CURDIR}#" Makefile.pub
	@for SRC in $(SRC_PATH); do cd $${SRC} && $(MAKE); done

release: 
	sed  -i -e "s#ROOT_PATH=.*#ROOT_PATH=${CURDIR}#" Makefile.pub
	make clean
	@for SRC in $(SRC_PATH); do cd $${SRC} && $(MAKE); done
	tar -czvf out.tar.gz out

clean:
	sed  -i -e "s#ROOT_PATH=.*#ROOT_PATH=${CURDIR}#" Makefile.pub
	@for SRC in $(SRC_PATH); do cd $${SRC} && $(MAKE) clean; done
	rm -f out/bin/*
	rm -f out/include/*
	rm -f out/lib/*
