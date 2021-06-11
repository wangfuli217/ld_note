#include "ae_select.c"  #很有意思呀

redis(redis)
{
default: all

.DEFAULT:
        cd src && $(MAKE) $@

install:
        cd src && $(MAKE) $@

.PHONY: install
# 整体转到src
}

redis(redis/src)
{

# 可执行程序
make redis-server
make redis-sentinel
make redis-cli
make redis-benchmark
make redis-check-dump
make redis-check-aof

# make 其他执行
make clean
make distclean
make test
make test-sentinel
make check
make lcov
make gcov
make noopt
make valgrind
make install
make dep

# make 选项
make v=1 USE_TCMALLOC=yes | USE_TCMALLOC_MINIMAL=yes |USE_JEMALLOC=yes

}

redis(redis/dep/hiredis)
{
# 可执行程序
make hiredis-example-ae  #需要指定AE_DIR = ../../src/
make hiredis-example-libevent
make hiredis-example-libev

# make 其他执行
make clean
make distclean
make test
make check
make dep
make lcov
make gcov
make gprof
make noopt
make install

# dynamic static
make dynamic
make static

}

redis(redis/dep/lua)
{
ranlib #
}

redis(redis/dep/jemalloc)
{
configure
}

redis(redis/dep/noiseline)
{
make linenoise_example
make clean
}