$ clang++ tmp/init-order/example/a.cc tmp/init-order/example/b.cc && ./a.out 
1
$ clang++ tmp/init-order/example/b.cc tmp/init-order/example/a.cc && ./a.out 
43
##############################################################################
 Loose init-order checking
##############################################################################
$ clang++ -fsanitize=address -g tmp/init-order/example/a.cc tmp/init-order/example/b.cc
$ ASAN_OPTIONS=check_initialization_order=true ./a.out
=================================================================
==26772==ERROR: AddressSanitizer: initialization-order-fiasco on address 0x000001068820 at pc 0x427e74 bp 0x7ffff8295010 sp 0x7ffff8295008
READ of size 4 at 0x000001068820 thread T0
    #0 0x427e73 in read_extern_global() tmp/init-order/example/a.cc:4
    #1 0x42806c in __cxx_global_var_init tmp/init-order/example/a.cc:7
    #2 0x4280d5 in global constructors keyed to a tmp/init-order/example/a.cc:10
    #3 0x42823c in __libc_csu_init (a.out+0x42823c)
    #4 0x7f9afdbdb6ff (/lib/x86_64-linux-gnu/libc.so.6+0x216ff)
    #5 0x427d64 (a.out+0x427d64)
0x000001068820 is located 0 bytes inside of global variable 'extern_global' from 'tmp/init-order/example/b.cc' (0x1068820) of size 4
SUMMARY: AddressSanitizer: initialization-order-fiasco tmp/init-order/example/a.cc:4 read_extern_global()
<...>

$ clang++ -fsanitize=address -g tmp/init-order/example/b.cc tmp/init-order/example/a.cc
$ ASAN_OPTIONS=check_initialization_order=true ./a.out
43


##############################################################################
 Strict init-order checking
##############################################################################
$ clang++ -fsanitize=address -g tmp/init-order/example/b.cc tmp/init-order/example/a.cc
$ ASAN_OPTIONS=check_initialization_order=true:strict_init_order=true ./a.out
=================================================================
==27853==ERROR: AddressSanitizer: initialization-order-fiasco on address 0x0000010687e0 at pc 0x427f74 bp 0x7fff3d076ba0 sp 0x7fff3d076b98
READ of size 4 at 0x0000010687e0 thread T0
    #0 0x427f73 in read_extern_global() tmp/init-order/example/a.cc:4
<...>

