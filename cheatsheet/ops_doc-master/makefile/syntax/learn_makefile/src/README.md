#说明:
1. configure.in　这是最重要的文档，整个安装过程都靠它来主导。
2. Makefile.am　automake会根据它来生成Makefile.in，再由./configure 把Makefile.in变成最终的Makefile，一般来说在顶级目录和各个子目录都应该有一个Makefile.am
3. acconfig.h　autoheader会根据它来生成config.h.in，再由./configure 把config.h.in变成最终的config.h
4. tt.c qq.c qq.h　这是我们的源程序。
