cat - <<'EOF'
[构建过程及构建工具]
configure.scan = autoscan(你的源文件)
configure.in   = edit(configure.scan)
aclocal.m4     = aclocal(configure.ac)
config.h.in    = autoheader([acconfig.h], configure.in:AC_CONFIG_HEADER, aclocal.m4) + [config.h.top, config.h.bot]
configure      = autoconf(configure.in) + [aclocal.m4, acsite.m4]
Makefile.in    = automake(Makefile.am, aclocal.m4, configure)

{Makefile,config.h,config.status,config.cache,config.log} = configure(Makefile.in) + config.h.in
{Makefile,config.h,config.log} = config.status(Makefile.in)+ config.h.in

{configure,config.h.in,Makefile.in} = autoreconf(configure.ac, Makefile.am)
                                      autoreconf --install

m4 -P example.m4
configure 探测系统所需的函数、库和工具。生成一个包含所有#define的config.h文件 + 以及构建包的Makefiles

[构建过程依赖文件]
autocreate: configure.scan   
edit: configure.scan         autotools_t_monit_configure
      config.h.in            
      configure.in           
      Makefile.am            autotools_t_am
      
‘autoconf’ Create configure from configure.ac.  # autoconf on Top of M4
‘autoheader’ Create config.h.in from configure.ac.
‘autoreconf’ Run all tools in the right order.
‘autoscan’ Scan sources for common portability problems, and related macros missing from configure.ac.  
‘autoupdate’ Update obsolete macros in configure.ac.
‘ifnames’ Gather identifiers from all #if/#ifdef/... directives.
‘autom4te’ The heart of Autoconf. It drives M4 and implements the features used by most of the above tools. Useful for creating more than just configure files.

‘automake’ Create Makefile.ins from Makefile.ams and configure.ac.
‘aclocal’ Scan configure.ac for uses of third-party macros, and gather definitions in aclocal.m4.

[重新构建]
autoreconf -i -s

[amhello] 
autotools-test/deep, deeper, flat, shallow
monit                            是静态库+单可执行文件
moosefs                          多可执行文件
# /root/rtu/otdr/rtu/rtu/rtu     单可执行文件

autoconf, autoheader, autom4te, autoreconf, autoscan, autoupdate 和 ifnames
EOF
autotools_p_idea(){ cat - <<'EOF'
为使用automake，在包目录放置：
    一个autoconf文件configure.ac或configure.in
    一个automake文件Makefile.am 然后对automake文件运行automake将生成模板Makefile.in。

为使用autoconf，在包目录放置：
    一个autoconf文件configure.ac或configure.in
    一个makefile模板Makefile.in
    可选择提供m4宏文件aclocal.m4和acsite.m4，其中定义包特定的宏 然后对autoconf文件运行autoconf将生成跨平台的脚本configure。

利用autoreconf通过反复运行autoconf、autoheader、aclocal、automake、libtoolize和autopoint，一步到位地生成或更新包的构建系统。
configure脚本通常生成如下文件：
    一个或多个makefile，通常是每个子目录一个
    一个可选的头文件
    一个config.statusshell脚本，运行它会重新生成上述文件
    一个日志文件config.log
EOF
}


autotools_p_autoconf(){ cat - <<'EOF'
1. 用于准备发行软件包的文件
     your source files --> [autoscan*] --> [configure.scan] --> configure.ac

     configure.ac --.
                    |   .------> autoconf* -----> configure
     [aclocal.m4] --+---+
                    |   .-----> [autoheader*] --> [config.h.in]
     [acsite.m4] ---.

     Makefile.in -------------------------------> Makefile.in

2. 用于配置软件包的文件
                            .-------------> [config.cache]
     configure* ------------+-------------> config.log
                            |
     [config.h.in] -.       v            .-> [config.h] -.
                    +--> config.status* -+               +--> make*
     Makefile.in ---.                    .-> Makefile ---.
     
    autoconf的一个重要用途是为定义C/C++宏，ifnames程序用于列出一个C/C++文件中#if、#elif、#ifdef'、
#ifndef等等用到的标识符，这对编写configure.ac`是有用的。
EOF
}

autotools_l_link(){ cat - <<'EOF'
https://github.com/vincentbernat/bootstrap.c
https://github.com/chungkwong/chungkwong.github.io/blob/57a1315ba22a44ec84854d8932c8101cac59b55e/_posts/2017-05-08-makefile.md
https://github.com/chungkwong/chungkwong.github.io
EOF
}

autotools_i_m4(){ cat - <<'EOF'
example.m4
m4_define(NAME1, ‘Harry, Jr.’)
m4_define(NAME2, Sally)
m4_define(MET, $1 met $2)
MET(NAME1, NAME2)
EOF
}
autotools_t_monit_configure(){ cat - <<'EOF'
# Programs  
# Libtool
# Build options
# Libraries 
# Header files
# Types
# Functions 
# Architecture/OS
# Compiler 
# IPv6 Support
# Outputs

# zlib Code
# PAM Code
# SSL Code
# Build options
vim ${BASHRC_PATH}/cheatsheet/ops_doc-master/Service/monit/monit-5.25.2/configure.ac
EOF
}

autotools_t_monit_Makefile_am(){ cat - <<'EOF'
automake_OPTIONS = foreign no-dependencies subdir-objects
ACLOCAL_AMFLAGS  = -I m4

EXTRA_DIST  = README COPYING CONTRIBUTORS bootstrap doc src config monitrc system libmonit monit.1

SUBDIRS     = libmonit

CC      = @CC@
FLEX        = @FLEX@
FLEXFLAGS   = -i
YACC        = @YACC@
YACCFLAGS   = -dvt
POD2MAN     = @POD2MAN@
POD2MANFLAGS    = @POD2MANFLAGS@

AM_CPPFLAGS = $(CPPFLAGS) $(EXTCPPFLAGS) -D@ARCH@ -DSYSCONFDIR="\"@sysconfdir@\"" -I./src -I./src/device -I./src/http -I./src/notification -I./src/process -I./src/protocols -I./src/ssl -I./src/terminal -I./libmonit/src
AM_LDFLAGS  = $(LDFLAGS) $(EXTLDFLAGS) -L./lib/

bin_PROGRAMS    = monit
monit_SOURCES   = src/y.tab.c \
monit_LDADD     = libmonit/libmonit.la
monit_LDFLAGS   = -static $(EXTLDFLAGS)

vim ${BASHRC_PATH}/cheatsheet/ops_doc-master/Service/monit/monit-5.25.2/Makefile.am
EOF
}

autotools_t_libmonit_configure(){ cat - <<'EOF'
vim ${BASHRC_PATH}/cheatsheet/ops_doc-master/Service/monit/monit-5.25.2/libmonit/configure.ac
EOF
}

autotools_t_libmonit_Makefile_am(){ cat - <<'EOF'
vim ${BASHRC_PATH}/cheatsheet/ops_doc-master/Service/monit/monit-5.25.2/libmonit/Makefile.am
EOF
}

autotools_t_Makefile_am(){ cat - <<'EOF'
# 声明源文件
bin_PROGRAMS = foo run-me
foo_SOURCES = foo.c foo.h print.c print.h
run_me_SOURCES = run.c run.h print.c

#(静态)库
lib_LIBRARIES = libfoo.a libbar.a
libfoo_a_SOURCES = foo.c privfoo.h
libbar_a_SOURCES = bar.c privbar.h
include_HEADERS = foo.h bar.h
EOF
}

autotools_p_autoreconf(){ cat - <<'EOF'
autoreconf -i -s

autoconf 仅仅是一个基于M4开发的库，提供了一套宏语言，用于检测库、程序等是否存在。

因为M4过于低等且autoconf目的在于生成Bourne shell脚本，因此其高于M4。将autoconf代码扩展为Bourne shell脚本很简单，
可以使用"autom4te --language=autoconf"，也可以直接使用"autoconf"命令。

autoconf是一个用于生成可以自动地配置软件源代码包以适应多种Unix类系统的 shell脚本的工具。

    对于每个使用了autoconf的软件包，autoconf从一个列举了该软件包需要的，或者可以使用的系统特征的
列表的模板文件中生成配置脚本。在shell代码识别并响应了一个被列出的系统特征之后，autoconf允许多个
可能使用(或者需要)该特征的软件包共享该特征。 如果后来因为某些原因需要调整shell代码，就只要在
一个地方进行修改； 所有的配置脚本都将被自动地重新生成以使用更新了的代码。
EOF
}


autotools_i_config_h_in(){ cat - <<'EOF'
编译环境配置头文件模板config.h.in文件是手动编辑的，实际上它可以很容易地由'configure.ac'文件导出，
这通过检索所有已定义的预处理符号，并在其前冠以'#undef'，然后再自动粘贴相应的标准注释，最后输出'config.h.in'。
用于完成这一过程的工具是 autoheader:
EOF
}

autotools_i_config_status(){ cat - <<'EOF'
可能你会纳闷configure脚本运行时生成了一个config.status文件，这是个什么东东呢？事实上，configure仅仅是一个检查器：
它本身不执行任何配置行为，它所创建的config.status会进行配置工作
EOF
}
autotools_i_automake(){ cat - <<'EOF'
automake是一个从文件'Makefile.am'自动生成'Makefile.in' 的工具。
    典型的automake输入文件是一系列简单的宏定义。处理所有这样的文件以创建 'Makefile.in'。在一个项目
(project)的每个目录中通常包含一个 'Makefile.am'。automake在几个方面对一个项目做了限制；例如它
假定项目使用autoconf并且对'configure.in'的内容施加了某些限制。

    典型的automake输入文件是一系列简单的宏定义。处理所有这样的文件以创建 'Makefile.in'。
在一个项目(project)的每个目录中通常包含一个 'Makefile.am'。
    为生成Makefile.in，automake需要perl。 但是由automake创建的发布完全服从GNU标准，并且在创建中不需要perl。

    类似地，在'Makefile.am'中定义的变量将覆盖任何通常由automake 创建的变量定义。该功能比覆盖
目标定义的功能要常用得多。需要警告的是许多由 automake生成的变量都被认为是内部使用的，
并且它们的名字可能在未来 的版本中改变。

    在检验变量定义的时候，automake将递归地检验定义中的变量引用。例如，如果automake 
在如下片断中搜索'foo_SOURCES'的内容。
xs = a.c b.c
foo_SOURCES = c.c $(xs)
它将把文件'a.c'、 'b.c'和 'c.c'作为'foo_SOURCES' 的内容。
automake还允许给出不被复制到输出中的注释；所有以'##'开头的行 将被automake彻底忽略。
作为惯例，'Makefile.am'的第一行是：
## Process this file with automake to produce Makefile.in
EOF
}

autotools_i_flat_shallow_deep(){ cat - <<'EOF'
automake支持三种目录层次： "flat"、"shallow"和"deep"。
1. 一个flat(平)包指的是所有文件都在一个目录中的包。为这类包提供的'Makefile.am' 缺少宏SUBDIRS。
这类包的一个例子是termutils。
2. 一个deep(深)包指的是所有的源代码都被储存在子目录中的包；顶层 目录主要包含配置信息。GNU cpio 
是这类包的一个很好的例子，GNU tar也是。deep包的顶层'Makefile.am'将包括 宏SUBDIRS，但没有其它
定义需要创建的对象的宏。
3. 一个shallow(浅)包指的是主要的源代码储存在顶层目录中，而各个部分(典型的是库)则储存在子目录中的包。
# automake本身就是这类包(GNU make也是如此，它现在已经不使用automake)。
EOF
cd autotools-test
}

autotools_i_configure_automake_options(){ cat - <<'EOF'
按照这个目标，automake 支持三级严格性---严格性指的是automake 将如何检查包所服从的标准。

可用的严格性级别有：

'foreign'(外来)
    automake将仅仅检查那些为保证正确操作所必需的事项。例如，尽管GNU标准指出文件'NEWS'必须存在，
在本方式下，并不需要它。该模式名来自于automake 是被设计成用于GNU程序的事实的；它放松了标准模式的操作规则。 

'gnu'
    automake将尽可能地检查包是否服从GNU标准。这是缺省设置。 
'gnits'
    automake将按照还没有完成的Gnits标准进行检查。它们是基于GNU标准的，但更加详尽。
除非你是Gnits标准的参与奉献者，我们建议您在Gnits标准正式出版之前 不要使用这一选项。

AM_INIT_AUTOMAKE([-Wall -Werror foreign subdir-objects])   # moosefs configure
AUTOMAKE_OPTIONS = foreign no-dependencies subdir-objects  # monit   Makefile.am
EOF
}


autotools_i_automake_Makefile_am(){ cat - <<'EOF'
    automake变量通常服从统一的命名机制，以易于确定如何创建和安装程序(和其它派生对象)。 
这个机制还支持在运行configure的时候确定应该创建那些对象。

    在运行make时，某些变量被用于确定应该创建那些对象。 这些变量被称为主(primary)变量。
例如，主变量PROGRAMS 保存了需要被编译和连接的程序的列表。

    另一组变量用于确定应该把创建了的对象安装在哪里。这些变量在主变量之后命名， 
但是含有一个前缀以指出那个标准目录将作为安装目录。标准目录名在GNU标准中给出 
(参见GNU编码标准中的'为Directory Variables'节)。 automake用pkglibdir、pkgincludedir
和 pkgdatadir扩展了这个列表；除了把'@PACKAGE@'附加 其后之外，与非'pkg'版本是相同的。 
例如，pkglibdir被定义为$(datadir)/@PACKAGE@.

    对于每个主变量，还有一个附加的变量，它的名字是在主变量名之前加一个'EXTRA_'。 
该变量用于储存根据configure的运行结果，可能创建、也可能不创建 的对象列表。
引入该变量是因为automake必须静态地知道需要创建的对象的完整列表 以创建在所有情况下都能够工作的'Makefile.in'。

例如，在配置时刻cpio确定创建哪些程序。一部分程序被安装在bindir， 还有一部分程序被安装在sbindir：
EXTRA_PROGRAMS = mt rmt
bin_PROGRAMS = cpio pax
sbin_PROGRAMS = @PROGRAMS@
    定义没有前缀的主变量(比如说PROGRAMS)是错误的。
    在构造变量名的时候，通常省略后缀'dir'；因此我们使用 'bin_PROGRAMS'而不是'bindir_PROGRAMS'.
    不是每种对象都可以安装在任何目录中。automake将记录它们以试图找出 错误。automake还将诊断目录名中明显的拼写错误。
    有时标准目录--即使在automake扩展之后---是不够的。特别在有些时候，为了清晰 起见，
把对象安装到预定义目录的子目录中是十分有用的。为此，automake允许你 扩展可能的安装目录列表。
如果定义了一个添加了后缀'dir'的变量 (比如说'zardir')，则给定的前缀(比如'zar') 就是合法的。

例如，在HTML支持成为automake的一部分之前，你可以使用它安装原始的HTML文档。
htmldir = $(prefix)/html
html_DATA = automake.html
特殊前缀'noinst'表示根本不会安装这些有问题的对象。
特殊前缀'check'表示仅仅在运行make check 命令的时候才创建这些有问题的对象。
可能的主变量名有'PROGRAMS'、'LIBRARIES'、 'LISP'、'SCRIPTS'、'DATA'、 'HEADERS'、'MANS'和'TEXINFOS'。
EOF
}
autotools_t_moosefs_bin_PROGRAMS(){
# PROGRAMS
./beansdb/Makefile.am:bin_PROGRAMS = beansdb
./beansdb/tools/Makefile.am:bin_PROGRAMS = convert

./moosefs-3.0.104/mfsmetatools/Makefile.am:sbin_PROGRAMS=mfsmetadump mfsmetadirinfo                                                
./moosefs-3.0.104/mfsmaster/Makefile.am:sbin_PROGRAMS=mfsmaster mfsstatsdump                                                       
./moosefs-3.0.104/mfsnetdump/Makefile.am:sbin_PROGRAMS=mfsnetdump
./moosefs-3.0.104/mfsclient/Makefile.am:bin_PROGRAMS=mfstools
./moosefs-3.0.104/mfsclient/Makefile.am:bin_PROGRAMS += mfsmount
./moosefs-3.0.104/mfsclient/Makefile.am:sbin_PROGRAMS = mfsbdev
./moosefs-3.0.104/mfsmetalogger/Makefile.am:sbin_PROGRAMS=mfsmetalogger                                                            
./moosefs-3.0.104/mfschunkserver/Makefile.am:sbin_PROGRAMS=mfschunkserver mfschunktool mfscsstatsdump

# html
./moosefs-3.0.104/mfsscripts/Makefile.am:       index.html \
./moosefs-3.0.104/mfsscripts/Makefile.am:EXTRA_DIST = mfscli.py.in chart.cgi.in mfscgiserv.py.in index.html.in err.gif logomini.png
favicon.ico acidtab.js mfs.css
./moosefs-3.0.104/mfsmanpages/Makefile.am:man-html: $(all_mans)
./moosefs-3.0.104/mfsmanpages/Makefile.am:      $(MKDIR_P) html
./moosefs-3.0.104/mfsmanpages/Makefile.am:              man2html -r $$f | tail -n +3 > html/$${f}.html ; \          

# LTLIBRARIES
./moosefs-3.0.104/mfsclient/Makefile.am:lib_LTLIBRARIES=libmfsio.la                                                                
./beansdb-master/third-party/zlog-1.2/Makefile.am:noinst_LIBRARIES = libzlog.a                                                     
./kvspool-master/src/Makefile.am:lib_LIBRARIES = libkvspool.a
./tpl-master/src/Makefile.am:lib_LTLIBRARIES = libtpl.la
./tpl-master/src/win/Makefile.am:noinst_LTLIBRARIES = libwinmmap.la 

# SCRIPTS
./moosefs-3.0.104/mfsmaster/Makefile.am:EXTRA_DIST = $(sbin_SCRIPTS)                                                               
./moosefs-3.0.104/mfsmaster/Makefile.am:sbin_SCRIPTS=\
./moosefs-3.0.104/Makefile.am:if BUILD_SCRIPTS
./moosefs-3.0.104/Makefile.am:SCRIPTSDIR=mfsscripts
./moosefs-3.0.104/Makefile.am:SCRIPTSDIR=
./moosefs-3.0.104/Makefile.am:SUBDIRS=mfstests mfsdata mfsmanpages $(MASTERDIR) $(METALOGGERDIR) $(SUPERVISORDIR) $(CHUNKSERVERDIR)
$(CLIENTDIR) $(SCRIPTSDIR) $(NETDUMPDIR) $(SYSTEMDDIR)
./moosefs-3.0.104/mfsscripts/Makefile.am:nodist_cgibin_SCRIPTS = \                                                                 
./moosefs-3.0.104/mfsscripts/Makefile.am:nodist_bin_SCRIPTS = \
./moosefs-3.0.104/mfsscripts/Makefile.am:nodist_cgiserv_SCRIPTS = \                                                                
./libusual-master/mk/Makefile.am:dist_pkgdata_SCRIPTS = antimake.mk std-autogen.sh 

# DATA
./moosefs-3.0.104/systemd/Makefile.am:systemdunit_DATA =
./moosefs-3.0.104/systemd/Makefile.am:systemdunit_DATA += moosefs-cgiserv.service                                                  
./moosefs-3.0.104/systemd/Makefile.am:systemdunit_DATA += moosefs-chunkserver.service                                              
./moosefs-3.0.104/systemd/Makefile.am:systemdunit_DATA += moosefs-chunkserver@.service                                             
./moosefs-3.0.104/systemd/Makefile.am:systemdunit_DATA += moosefs-master.service                                                   
./moosefs-3.0.104/systemd/Makefile.am:systemdunit_DATA += moosefs-master@.service                                                  
./moosefs-3.0.104/systemd/Makefile.am:systemdunit_DATA += moosefs-metalogger.service                                               
./moosefs-3.0.104/systemd/Makefile.am:systemdunit_DATA += moosefs-metalogger@.service                                              
./moosefs-3.0.104/mfsdata/Makefile.am:if CREATE_DATA_DIR
./moosefs-3.0.104/mfsdata/Makefile.am:  if [ ! -d $(DESTDIR)$(DATA_PATH) ]; then \                                                 
./moosefs-3.0.104/mfsdata/Makefile.am:          $(MKDIR_P) $(DESTDIR)$(DATA_PATH) ; \                                              
./moosefs-3.0.104/mfsdata/Makefile.am:                                  chown $(DEFAULT_USER):$(DEFAULT_GROUP) $(DESTDIR)$(DATA_PATH) ; \
./moosefs-3.0.104/mfsdata/Makefile.am:  $(INSTALL_DATA) $(builddir)/mfschunkserver.cfg $(DESTDIR)$(sysconfdir)/mfs/mfschunkserver.cfg.sample
./moosefs-3.0.104/mfsdata/Makefile.am:  $(INSTALL_DATA) $(srcdir)/mfshdd.cfg $(DESTDIR)$(sysconfdir)/mfs/mfshdd.cfg.sample         
./moosefs-3.0.104/mfsdata/Makefile.am:  $(INSTALL_DATA) $(builddir)/mfsmaster.cfg $(DESTDIR)$(sysconfdir)/mfs/mfsmaster.cfg.sample 
./moosefs-3.0.104/mfsdata/Makefile.am:  $(INSTALL_DATA) $(builddir)/mfsexports.cfg $(DESTDIR)$(sysconfdir)/mfs/mfsexports.cfg.sample
./moosefs-3.0.104/mfsdata/Makefile.am:  $(INSTALL_DATA) $(builddir)/mfstopology.cfg $(DESTDIR)$(sysconfdir)/mfs/mfstopology.cfg.sample
./moosefs-3.0.104/mfsdata/Makefile.am:  $(INSTALL_DATA) $(srcdir)/metadata.mfs $(DESTDIR)$(DATA_PATH)/metadata.mfs.empty           
./moosefs-3.0.104/mfsdata/Makefile.am:                          chown $(DEFAULT_USER):$(DEFAULT_GROUP) $(DESTDIR)$(DATA_PATH)/metadata.mfs.empty ; \
./moosefs-3.0.104/mfsdata/Makefile.am:  $(INSTALL_DATA) $(builddir)/mfsmount.cfg $(DESTDIR)$(sysconfdir)/mfs/mfsmount.cfg.sample   
./moosefs-3.0.104/mfsdata/Makefile.am:  $(INSTALL_DATA) $(builddir)/mfsmetalogger.cfg $(DESTDIR)$(sysconfdir)/mfs/mfsmetalogger.cfg.sample
./moosefs-3.0.104/mfsscripts/Makefile.am:cgidata_DATA = \
./moosefs-3.0.104/mfsscripts/Makefile.am:       @sed -e "s#\%\%""CGIDIR""\%\%#$(CGIDIR)#" -e "s#\%\%""DATAPATH""\%\%#$(DATA_PATH)#"
< mfscgiserv.py > mfscgiserv
./libusual-master/mk/Makefile.am:pkgconfig_DATA = libusual.pc

# HEADERS
./moosefs-3.0.104/mfsclient/Makefile.am:include_HEADERS=mfsio.h
./kvspool-master/src/Makefile.am:include_HEADERS = ../include/kvspool.h ../include/uthash.h                                        
./tpl-master/src/Makefile.am:include_HEADERS = tpl.h
./tpl-master/src/win/Makefile.am:noinst_HEADERS = mman.h

# MANS
./beansdb/doc/Makefile.am:man_MANS = beansdb.1
./moosefs-3.0.104/mfsmanpages/Makefile.am:man_MANS=
./moosefs-3.0.104/mfsmanpages/Makefile.am:man_MANS+=$(master_mans)                                                                 
./moosefs-3.0.104/mfsmanpages/Makefile.am:man_MANS+=$(chunkserver_mans)                                                            
./moosefs-3.0.104/mfsmanpages/Makefile.am:man_MANS+=$(tools_mans)
./moosefs-3.0.104/mfsmanpages/Makefile.am:man_MANS+=$(mount_mans)
./moosefs-3.0.104/mfsmanpages/Makefile.am:man_MANS+=$(mount_extra_man)                                                             
./moosefs-3.0.104/mfsmanpages/Makefile.am:man_MANS+=$(bdev_mans)
./moosefs-3.0.104/mfsmanpages/Makefile.am:man_MANS+=$(metalogger_mans)                                                             
./moosefs-3.0.104/mfsmanpages/Makefile.am:man_MANS+=$(netdump_mans)                                                                
./moosefs-3.0.104/mfsmanpages/Makefile.am:man_MANS+=$(supervisor_mans)                                                             
./moosefs-3.0.104/mfsmanpages/Makefile.am:man_MANS+=$(cgiserv_mans)                                                                
./moosefs-3.0.104/mfsmanpages/Makefile.am:man_MANS+=$(cli_mans)
./beansdb-master/doc/Makefile.am:man_MANS = beansdb.1
}

autoconf_i_macro(){

}

automake_i_macro(){
AM_CONDITIONAL (CONDITIONAL, CONDITION)                                 引入条件automake
AM_COND_IF (CONDITIONAL, [IF-TRUE], [IF-FALSE])                         条件
AM_GNU_GETTEXT                                                          确保包满足表gettext要求
AM_GNU_GETTEXT_INTL_SUBDIR                                              要求构建子目录intl/
AM_INIT_AUTOMAKE([OPTIONS])                                             初始化automake
AM_MAINTAINER_MODE([DEFAULT-MODE])                                      设置维护者模式
AM_MISSING_PROG(NAME, PROGRAM)                                          把指定程序位置写到指定环境变量
AM_PATH_LISPDIR                                                         设置lispdir
AM_PATH_PYTHON ([VERSION], [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND])    搜索Python
AM_PROG_AR([ACT-IF-FAIL])                                               指定处理非常规归档的命令
AM_PROG_AS                                                              设置CCAS和CCASFLAGS
AM_PROG_GCJ                                                             设置GCJ和GCJFLAGS
AM_PROG_LEX                                                         
AM_PROG_UPC([COMPILER-SEARCH-LIST])                                     设置UPC
AM_PROG_VALACAM_PROG_VALAC ([MINIMUM-VERSION], [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND]) 
AM_SILENT_RULES                                                         精简输出
AM_SUBST_NOTMAKE(VAR)                                                   防止定义变量
AM_WITH_DMALLOC                                                         支持Dmalloc

automake主要用变量的值决定做什么，虽然变量繁多，但有一些规则：
    一个变量有AM_前缀版本，这时AM_前缀的由开发者设置，没有的由用户设置
    一些前缀有特殊意义：
        no_base表示不压平目录结构
        dist表示指定要发布的文件
        no_dist表示指定不要发布的文件
        no_inst表示指定要发布但不安装的文件（通常因为只在安装时用到）
        其它前缀表示对应子目录
    后缀PROGRAMS、LIBRARIES、LTLIBRARIES、LISP、PYTHON、JAVA、SCRIPTS、DATA、HEADERS、MANS、TEXINFOS分别表示各类文件
}

automake_i_variable(){
_DATA        参考无前缀形式
_HEADERS     参考无前缀形式
_LIBRARIES     参考无前缀形式
_LISP     参考无前缀形式
_LOG_COMPILE     参考无前缀形式
_LOG_COMPILER     参考无前缀形式
_LOG_DRIVER     参考无前缀形式
_LOG_DRIVER_FLAGS     参考无前缀形式
_LOG_FLAGS     参考无前缀形式
_LTLIBRARIES     参考无前缀形式
_MANS     参考无前缀形式
_PROGRAMS     参考无前缀形式
_PYTHON     参考无前缀形式
_SCRIPTS     参考无前缀形式
_SOURCES     参考无前缀形式
_TEXINFOS     参考无前缀形式
AM_CCASFLAGS     汇编器选项
AM_CFLAGS     额外的C编译器选项
AM_COLOR_TESTS     结果是否用彩色表示
AM_CPPFLAGS     C预处理选项
AM_CXXFLAGS     C++编译器选项
AM_DEFAULT_SOURCE_EXT     源文件的默认后缀
AM_DISTCHECK_CONFIGURE_FLAGS     额外configure选项
AM_ETAGSFLAGS     etags选项
AM_EXT_LOG_DRIVER_FLAGS     测试驱动器选项
AM_EXT_LOG_FLAGS     测试运行器参数
AM_FCFLAGS     Fortran 9x编译器选项
AM_FFLAGS     Fortran77编译器选项
AM_GCJFLAGS     GCJ选项
AM_INSTALLCHECK_STD_OPTIONS_EXEMPT     不检查可运行性的程序
AM_JAVACFLAGS     Java编译器选项
AM_LDFLAGS     额外链接选项
AM_LFLAGS     lex选项
AM_LIBTOOLFLAGS     Libtool选项
AM_LOG_DRIVER_FLAGS     测试驱动器选项
AM_LOG_FLAGS     测试运行器参数
AM_MAKEFLAGS     make选项
AM_MAKEINFOFLAGS     makeinfo选项
AM_MAKEINFOHTMLFLAGS     makeinfo选项
AM_OBJCFLAGS     Objective C编译器选项
AM_OBJCXXFLAGS     Objective C++编译器选项
AM_RFLAGS     Ratfor编译器选项
AM_RUNTESTFLAGS     DejaGnu测试选项
AM_TESTS_ENVIRONMENT     测试前的预备代码
AM_TESTS_FD_REDIRECT     测试中文件重定向
AM_UPCFLAGS     统一并行C选项
AM_UPDATE_INFO_DIR     是否在安装info页时更新索引
AM_VALAFLAGS     vala选项
AM_V_at     用于安静模式下抑制输出的命令前缀
AM_V_GEN     用于安静模式下输出状态行的命令前缀
AM_YFLAGS     yacc选项
AR     ar命令
AUTOCONF     autoconf命令
AUTOM4TE     aclocal命令
AUTOMAKE_JOBS     最大并发的perl线程数
AUTOMAKE_OPTIONS     automake选项
bin_PROGRAMS     需要安装到bin目录的程序
bin_SCRIPTS     需要安装到bin目录的脚本
build_triplet     构建机类型
BUILT_SOURCES     放在指定地方的源文件
BZIP2     bzip2选项
CC     继承自autoconf
CCAS     汇编器
CCASFLAGS     汇编器选项
CFLAGS     继承自autoconf
check_LTLIBRARIES     放在指定地方的Libtool库
check_PROGRAMS     放在指定地方的程序
check_SCRIPTS     放在指定地方的脚本
CLASSPATH_ENV     用于设置CLASSPATH环境变量的shell表达式
CLEANFILES     目标clean应清除的文件
COMPILE     编译C源文件的命令
CONFIGURE_DEPENDENCIES     configure的依赖项
CONFIG_STATUS_DEPENDENCIES     config.status的依赖项
CPPFLAGS     继承自autoconf
CXX     C++编译器
CXXCOMPILE     编译C++的命令
CXXFLAGS     C++编译器选项
CXXLINK     链接C++程序的命令
DATA     数据文件
data_DATA     放到指定地方的数据文件
DEFS     继承自autoconf
DEJATOOL     给--tool的参数
DESTDIR     发布目录
DISABLE_HARD_ERRORS     把硬错误视为普通失败
DISTCHECK_CONFIGURE_FLAGS     额外configure选项
distcleancheck_listfiles     检查构建树已经清空的命令
DISTCLEANFILES     目标distclean应清除的文件
distdir     发布目录
distuninstallcheck_listfiles     检查安装树已经清空的命令
dist_lisp_LISP     要发布到指定处的Lisp程序
dist_noinst_LISP     要发布但不安装的Lisp程序
DIST_SUBDIRS     AM_CONDITIONAL中用的子目录
DVIPS     把dvi文件转换为ps文件的命令
EMACS     Emacs命令
ETAGSFLAGS     etags选项
ETAGS_ARGS     etags参数
EXPECT     
EXTRA_DIST     额外安装的文件
EXTRA_maude_DEPENDENCIES     由configure决定是否链接的依赖
EXTRA_maude_SOURCES     由configure决定是否编译的源文件
EXTRA_PROGRAMS     由configure决定是否编译和链接的程序
EXT_LOG_COMPILE     测试运行器
EXT_LOG_COMPILER     测试运行器
EXT_LOG_DRIVER     测试驱动器
EXT_LOG_DRIVER_FLAGS     测试驱动器选项
EXT_LOG_FLAGS     测试运行器参数
F77     Fortran77编译器
F77COMPILE     编译Fortran77源的命令
F77LINK     链接Fortran77程序的链接器
FC     Fortran 9x编译器
FCCOMPILE     Fortran 9x编译命令
FCFLAGS     Fortran 9x编译选项
FCLINK     Fortran 9x链接命令
FFLAGS     Fortran77编译器选项
FLIBS     Fortran77链接器额外选项
FLINK     Fortran77链接器命令
GCJ     GCJ命令
GCJFLAGS     GCJ选项
GCJLINK     GCJ链接命令
GTAGS_ARGS     gtags参数
GZIP_ENV     gzip选项
HEADERS     要安装的头文件
host_triplet     运行机类型
INCLUDES     AC_CPPFLAGS的旧名
include_HEADERS     要安装到指定地方的头文件
info_TEXINFOS     在指定地方的info页
JAVA     Java源文件
JAVAC     Java编译器，默认javac
JAVACFLAGS     Java编译器选项
JAVAROOT     作为Java编译器的-d选项，默认$(top_builddir)
LDADD     指定要链接的额外库
LDFLAGS     继承自autoconf
LFLAGS     lex选项
libexec_PROGRAMS     放到指定地方的程序
libexec_SCRIPTS     放到指定地方的脚本
LIBRARIES     要构建的库文件
LIBS     继承自autoconf
LIBTOOLFLAGS     Libtool选项
lib_LIBRARIES     要构建的库文件
lib_LTLIBRARIES     要构建的Libtool库
LINK     链接C程序的命令
LISP     要构建的Lisp源文件
lispdir     emacs位置
lisp_LISP     Lisp源文件
localstate_DATA     放到指定地方的数据文件
LOG_COMPILE     测试运行器
LOG_COMPILER     测试运行器
LOG_DRIVER     测试驱动器
LOG_DRIVER_FLAGS     测试驱动器选项
LOG_FLAGS     测试运行器参数
LTLIBRARIES     Libtool库
MAINTAINERCLEANFILES     目标maintainer-clean应清除的文件
MAKE     make命令
MAKEINFO     makeinfo命令
MAKEINFOFLAGS     makeinfo选项
MAKEINFOHTML     makeinfo选项
MANS     man文档页
man_MANS     man文档页
maude_AR     生成静态库的命令
maude_CCASFLAGS     目标特定的链接选项
maude_CFLAGS     目标特定的C编译选项
maude_CPPFLAGS     目标特定的预处理选项
maude_CXXFLAGS     目标特定的C++编译器选项
maude_DEPENDENCIES     不属于目标的依赖文件
maude_FFLAGS     目标特定的Fortran编译选项
maude_GCJFLAGS     目标特定的GCJ选项
maude_LDADD     加到库的额外对象或库
maude_LDFLAGS     程序或共享库的额外链接选项
maude_LFLAGS     目标特定的lex相关编译选项
maude_LIBADD     加到库的额外对象
maude_LIBTOOLFLAGS     libtool的额外选项
maude_LINK     程序特定的链接命令
maude_OBJCFLAGS     目标特定的Objective C编译选项
maude_OBJCXXFLAGS     目标特定的Objective C++编译选项
maude_RFLAGS     目标特定的Ratfor编译选项
maude_SHORTNAME     中间文件的短名
maude_SOURCES     构建程序所需的源文件
maude_UPCFLAGS     目标特定的统一并行C编译选项
maude_YFLAGS     目标特定的yacc相关编译选项
MOSTLYCLEANFILES     目标mostlyclean应清除的文件
noinst_HEADERS     构建但不安装的头文件
noinst_LIBRARIES     构建但不安装的库
noinst_LISP     构建但不安装的Lisp
noinst_LTLIBRARIES     构建但不安装的Libtool库
noinst_PROGRAMS     构建但不安装的程序
noinst_SCRIPTS     构建但不安装的脚本
notrans_     指定不用改名的man页
OBJC     Objective C编译器
OBJCCOMPILE     Objective C编译命令
OBJCFLAGS     Objective C编译器选项
OBJCLINK     Objective C链接命令
OBJCXX     Objective C++编译器
OBJCXXCOMPILE     Objective C++编译命令
OBJCXXFLAGS     Objective C++编译器选项
OBJCXXLINK     Objective C++链接命令
oldinclude_HEADERS     放到指定地方的头文件
PACKAGE     要构建的包名
pkgdatadir     数据文件的安装目录
pkgdata_DATA     放到指定地方的数据文件
pkgdata_SCRIPTS     放到指定地方的脚本
pkgincludedir     头文件的安装目录
pkginclude_HEADERS     放到指定地方的头文件
pkglibdir     库的安装目录
pkglibexecdir     可执行文件的安装目录
pkglibexec_PROGRAMS     放到指定地方的程序
pkglibexec_SCRIPTS     放到指定地方的脚本
pkglib_LIBRARIES     放到指定地方的库
pkglib_LTLIBRARIES     放到指定地方的Libtool库
pkgpyexecdir     Python扩展模块的安装目录
pkgpythondir     同$(pythondir)/$(PACKAGE)
PROGRAMS     需要编译和链接的程序
pyexecdir     同$(pyexecdir)/$(PACKAGE)
PYTHON     要构建的Python程序
pythondir     Python安装树的site-packages子目录
PYTHON_EXEC_PREFIX     同${exec_prefix}
PYTHON_PLATFORM     Python用的操作系统名
PYTHON_PREFIX     同${prefix}
PYTHON_VERSION     Python版本
RECHECK_LOGS     需要删除的删除日志文件
RFLAGS     Ratfor编译器选项
RUNTEST     
RUNTESTDEFAULTFLAGS     默认的--tool、--srcdir选项
RUNTESTFLAGS     测试选项
sbin_PROGRAMS     要安装到sbin目录的程序
sbin_SCRIPTS     要安装到sbin目录的脚本
SCRIPTS     脚本文件
sharedstate_DATA     放到指定地方的数据文件
SOURCES     源文件
SUBDIRS     需要构建的子目录
SUFFIXES     后缀转换列表
sysconf_DATA     放到指定地方的数据文件
TAGS_DEPENDENCIES     标签的依赖项
target_triplet     目标机类型
TESTS     测试脚本
TESTS_ENVIRONMENT     测试前的预备代码
TEST_EXTENSIONS     测试的后缀列表
TEST_LOGS     测试日志文件列表
TEST_SUITE_LOG     测试结果总结文件
TEXI2DVI     把texi文件转换为dvi文件的命令
TEXI2PDF     把texi文件转换为pdf文件的命令
TEXINFOS     texinfo文件
TEXINFO_TEX     texinfo.tex的位置
top_distdir     发布树的根
UPC     统一并行C编译器
UPCCOMPILE     统一并行C编译命令
UPCFLAGS     统一并行C编译选项
UPCLINK     统一并行C链接命令
V     详细级别
VALAC     vala编译器
VALAFLAGS     vala选项
VERBOSE     输出失败测试的输出
VERSION     要构建的包版本
WARNINGS     启用警告类别列表
WITH_DMALLOC     支持Dmalloc包
XFAIL_TESTS     预期失败的测试
XZ_OPT     xz选项
YACC     yacc命令
YFLAGS     yacc选项
}

autoconf_i_15Site_Configuration(){ cat - <<'EOF'
configure --help
  Optional Features:
    --enable-bar            include bar
  Optional Packages:
    --with-foo              use foo

    一个既不是'yes'也不是'no'的参数可以包含一个其他包的版本名称或编号，以便更精确地指定这个程序应该与哪个其他包一起工作。
如果没有给出参数，则默认为'yes'。--without-package等同于 --with-package=no。

[Working With External Software]
--with-package[=arg]
--without-package
//AC_ARG_WITH (package, help-string, [action-if-given], [action-if-not-given])

[Choosing Package Options]
--enable-feature[=arg]
--disable-feature
//AC_ARG_ENABLE (feature, help-string, [action-if-given], [action-if-not-given])

[Making Your Help Strings Look Pretty]
//AS_HELP_STRING (left-hand-side, right-hand-side [indent-column = ‘26’], [wrap-column = ‘79’])

[Controlling Checking of configure Options]
AC_DISABLE_OPTION_CHECKING     禁用对未声明选项的警告

[在安装的时候改变程序的名称]
AC_ARG_PROGRAM    转换包名的sed命令序列

[转换选项]
--program-prefix=prefix
    为名称添加前缀prefix； 
--program-suffix=suffix
    为名称添加后缀suffix； 
--program-transform-name=expression
    对名字作sed替换expression。
EOF
}

autoconf_i_AS_HELP_STRING(){ cat - <<'EOF'
[Making Your Help Strings Look Pretty]

AS_HELP_STRING([--option], [description of option])
AS_HELP_STRING (left-hand-side, right-hand-side [indent-column = '26'], [wrap-column = '79'])
宏扩展是对第一个参数进行的。
AS_HELP_STRING的第二个参数被视为一个要重新格式化的白空格分隔的文本列表，不受宏扩展的限制。

[moosefs]
DEFAULT_USER=nobody
DEFAULT_GROUP=
AC_ARG_WITH([default-user],
    [AS_HELP_STRING([--with-default-user=USER], [Choose default user to run daemons as])],
    [DEFAULT_USER=$withval])
AC_ARG_WITH([default-group],
    [AS_HELP_STRING([--with-default-group=GROUP], [Choose default group to run daemons as])],
    [DEFAULT_GROUP=$withval])
    
DEFAULT_PORTBASE=9400
DEFAULT_MASTERNAME=mfsmaster
AC_ARG_WITH([default-portbase],
    [AS_HELP_STRING([--with-default-portbase=NUMBER], [Default communiaction port base (default=9400, which means ports 9419,9420,etc.)])],
    [DEFAULT_PORTBASE=$withval])
AC_ARG_WITH([default-mastername],
    [AS_HELP_STRING([--with-default-mastername=MASTER_DNS_NAME], [Defines default DNS name pointing to all masters (default=mfsmaster)])],
    [DEFAULT_MASTERNAME=$withval])
    
AC_ARG_ENABLE([externalcflags], [AS_HELP_STRING([--enable-externalcflags], [Build with default CFLAGS])], [ enable_externalcflags=yes ])
AC_ARG_ENABLE([gperftools], [AS_HELP_STRING([--enable-gperftools], [Build with google perftools on (debug only)])], [ enable_gperftools=yes ])
AC_ARG_ENABLE([debug], [AS_HELP_STRING([--enable-debug], [Build version without optimizations])], [ enable_debug=yes ])

# https://www.gnu.org/software/autoconf/manual/autoconf-2.67/html_node/Pretty-Help-Strings.html
# configure --help
EOF
}
autoconf_i_AC_ARG_ENABLE(){ cat - <<'EOF' 
AC_ARG_ENABLE (feature, help-string, [action-if-given], [action-if-not-given])
                                     [enable_feature=yes], [enable_feature=no]
    如果用户以选项'--enable-feature'或者'--disable-feature'调用 configure，就运行shell命令action-if-given。
如果两个选项都没有给出，就运行shell命令 action-if-not-given。名称feature表示可选的用户级功能。
它应该仅仅由字母、数字和破折号(dashes)组成
     如果你愿意，可以使用变量enable_feature。help-string参数类似于 AC_ARG_WITH中相应的参数.
     
#debug options support
AC_ARG_ENABLE([debug],
    [AS_HELP_STRING([--enable-debug],[debug program(default is no)])],
    [CFLAGS="${CFLAGS} -g -O0"],
    [CFLAGS="-g -O2"])
其中，AC_ARG_ENABLE宏定义了一个输入选项"--enable-debug"。当定义时，CFLAGS采用 -g -o0。

[libevent] 默认定义bash变量值
AC_ARG_ENABLE(event-rtsig,
    AC_HELP_STRING([--enable-event-rtsig],
                   [enable support for real time signals (experimental)]))
if test "$enable_event_rtsig" = "yes"; then
    event_args="$event_args --enable-rtsig"
fi

[moosefs] 自定义bash变量值
AC_ARG_ENABLE([externalcflags], [AS_HELP_STRING([--enable-externalcflags], [Build with default CFLAGS])], [ enable_externalcflags=yes ])
AC_ARG_ENABLE([gperftools], [AS_HELP_STRING([--enable-gperftools], [Build with google perftools on (debug only)])], [ enable_gperftools=yes ])
AC_ARG_ENABLE([debug], [AS_HELP_STRING([--enable-debug], [Build version without optimizations])], [ enable_debug=yes ])

if [enable_gperftools=yes && enable_debug=yes]; then
  CFLAGS="-O0 -fno-omit-frame-pointer -g -DMFSDEBUG -std=c99 -Wall -Wextra -Wshadow -pedantic -fwrapv"
else
  CFLAGS="-O2 $CFLAGS -g -std=c99 -Wall -Wextra -Wshadow -pedantic -fwrapv"
fi

if [enable_gperftools=yes]; then
  CPPFLAGS="$CPPFLAGS -DGPERFTOOLS"
  LDFLAGS="$LDFLAGS -L/opt/local/lib -lprofiler"
fi

[moosefs] 默认定义bash变量值
# AC_ARG_ENABLE([mfsmaster],
#     [AS_HELP_STRING([--disable-mfsmaster], [Do not build mfsmaster])])
enable_mfsmaster
EOF
}
autoconf_i_AC_ARG_WITH(){ cat - <<'EOF'
AC_ARG_WITH (package, help-string, [action-if-given], [action-if-not-given])
                                   with_package=yes    with_package=no  
如果用户以选项'--with-package'或者'--without-package'调用 configure，就运行shell命令action-if-given。
如果两个选项都没有给出，就运行shell命令 action-if-not-given。
名字package给出了本程序应该与之协同工作的其它软件包。它应该仅仅由 字母、数字和破折号（dashes）组成。

shell命令action-if-given可以通过shell变量withval得到选项的参数，该变量的值实际上就是把 
shell变量with_package的值中的所有'-'字符替换为'_'而得的。 如果你愿意，可以使用变量with_package

AC_ARG_WITH([foo],
            [AS_HELP_STRING([--with-foo],
               [use foo (default is no)])],
            [use_foo=$withval],   # 指定参数
            [use_foo=no])         # 不指定参数
            
configure --help
--enable and --with options recognized:
--with-foo              use foo (default is no)

[moosefs]
AC_ARG_WITH([zlib],
    [AS_HELP_STRING([--without-zlib], [Do not use zlib for PNG compression])],
    [use_zlib=$withval],    # 指定zlib兼容接口
    [use_zlib=yes])         # zlib启动
    
AC_ARG_WITH([systemdsystemunitdir],
    [AS_HELP_STRING([--with-systemdsystemunitdir=PATH], [Path to install systemd units (no=omit)])],
    [systemdunitdir=$withval]) # 指定systemdunitdir路径
EOF
}

automake_i_AM_CONDITIONAL(){  cat - <<'EOF'
AM_CONDITIONAL (CONDITIONAL, CONDITION) # 引入条件automake

automake支持一种简单的条件。
在使用条件之前，你必须在configure.in文件中使用 AM_CONDITIONAL定义它。宏AM_CONDITIONAL 接受两个参数。
AM_CONDITIONAL的第一个参数是条件的名字。 它应该是一个以字母开头并且仅仅由字母、数字和下划线组成的简单字符串。
AM_CONDITIONAL的第二个参数是一个适用于shell的if语句的shell条件。 该条件将在运行configure的时候被求值。
条件典型地依赖于用户提供给configure脚本的选项。 下面是一个演示如果在用户使用了'--enable-debug'选项的情况下为真的条件的例子。

AC_ARG_ENABLE(debug,
[  --enable-debug    Turn on debugging],
[case "${enableval}" in
  yes) debug=true ;;
  no)  debug=false ;;
  *) AC_MSG_ERROR(bad value ${enableval} for --enable-debug) ;;
esac],[debug=false])
AM_CONDITIONAL(DEBUG, test x$debug = xtrue)

下面是一个如何在'Makefile.am'中使用条件的例子：
if DEBUG
DBG = debug
else
DBG =
endif
noinst_PROGRAMS = $(DBG)

[configure.ac] moosefs
AM_CONDITIONAL([WITH_MOUNT], [test "$fuse" != "no" -a "$enable_mfsmount" != "no"])
AM_CONDITIONAL([BUILD_CLIENT], [test \( "$fuse" != "no" -a "$enable_mfsmount" != "no" \) -o \( "$bdev" != "no" -a "$enable_mfsbdev" != "no" \)])
AM_CONDITIONAL([CREATE_ETC_MFS], [test "$enable_mfsmaster" != "no" -o "$enable_mfsmetalogger" != "no" -o "$enable_mfschunkserver" != "no" -o "$enable_mfsmount" != "no"])
AM_CONDITIONAL([CREATE_DATA_DIR], [test "$enable_mfsmaster" != "no" -o "$enable_mfsmetalogger" != "no" -o "$enable_mfschunkserver" != "no" -o "$enable_mfscgiserv" != "no"])

[Makefile.am] mfsclient
if WITH_MOUNT
bin_PROGRAMS += mfsmount
endif
if WITH_BDEV
sbin_PROGRAMS = mfsbdev
endif
EOF
}

autoconf(名词){
autoconf是一个产生可以自动配置源代码包，生成shell脚本的工具，以适应各种类UNIX系统的需要。
autoconf 产生的配置脚本在运行时独立于autoconf，因此使用这些脚本的用户不需要安装autoconf。

对于在C程序中的#ifdef中使用的宏的名字，autoconf施加了一些限制
    autoconf需要GNU m4以便于生成脚本。它使用了某些UNIX版本的m4 所不支持的特征。
它还会超出包括GNU m4 1.0在内的某些m4版本的内部 限制。你必须使用GNU m4的1.1版或者更新的版本。
使用1.3版或者更新的版本将比1.1 或1.2版快许多。
}
autoconf(创建configure脚本){
    由autoconf生成的配置脚本通常被称为configure。在运行的时候，configure 创建一些文件，
在这些文件中以适当的值替换配置参数。由configure创建的文件有：
    一个或者多个Makefile文件，在包的每个子目录中都有一个(参见 Makefile中的替换)；
    有时创建一个C头文件，它的名字可以被配置，该头文件包含一些#define命令 (参见配置头文件)；
    一个名为config.status的shell脚本，在运行时，它将重新创建上述文件。 (参见重新创建一个配置)；
    一个名为config.cache的shell脚本，它储存了许多测试的运行结果 (参见缓存文件)；
    一个名为config.log的文件，它包含了由编译器生成的许多消息，以便于在configure出现错误时进行调试。
为了使用autoconf创建一个configure脚本，你需要编写一个autoconf的输入文件configure.in并且对它运行autoconf。

configure.scan = autoscan(你的源文件)
configure.in = edit(configure.scan)
config.h.in = autoheader([acconfig.h], configure.in:AC_CONFIG_HEADER) + [config.h.top, config.h.bot]
configure = autoconf(configure.in) + [aclocal.m4, acsite.m4]
Makefile.in = automake(Makefile.am)
{Makefile,config.h,config.status,config.cache,config.log} = configure(Makefile.in) + config.h.in

acconfig.h -> config.h.in
如果你自行编写了特征测试以补充 autoconf所提供的测试，你可能还要编写一个名为aclocal.m4的文件和一个名为acsite.m4的文件。
如果你使用了包含#define指令的C头文件，你可能还要编写acconfig.h，并且你需要与软件包一同发布由autoconf生成的文件config.h.in。


1. 现有测试
2. 编写测试
3. 手工编写的shell命令

AC_INIT(file)
checks for programs
checks for libraries
checks for header files
checks for typedefs
checks for structures
checks for compiler characteristics
checks for library functions
checks for system services
AC_OUTPUT([file...])
最好让每个宏调用在configure.in中占据单独的一行。
在宏调用的同一行中设置shell变量通常是安全的。
在调用带参数的宏的时候，在宏名和左括号之间不能出现任何空格。
如果参数被m4 引用字符[和]所包含，参数就可以多于一行。
如果你有一个长行，比如说一个文件名列表，你通常可以在行的结尾使用反斜线以便在逻辑上把它与下一行进行连接。


有些宏处理两种情况：如果满足了某个给定的条件就做什么，如果没有满足某个给定的条件就做什么。
在有些地方，你可能希望在条件为真的情况下作些事，在为假时什么也不作。反之亦然。
为了忽略 为真的情况，把空值作为参数action-if-found传递给宏。
为了忽略为假的情况，可以 忽略包括前面的逗号在内的宏的参数action-if-not-found。

注释以m4预定义宏dnl开头，该宏丢弃在下一个新行之前的所有文本。
以 # 开头的行是注释。


所有configure脚本在作任何其他事情之前都必须调用AC_INIT。此外唯一必须调用的宏是 AC_OUTPUT

1. 寻找configure的输入文件
2. 创建输出文件
3. Makefiles中的替换
    为了创建Makefile，configure进行一个简单的变量替换：用configure 为@variable@选取的值，
在Makefile.in中对它们进行替换。 按照这种方式被替换到输出文件中的变量被称为输出变量。
在configure中，它们是普通 的shell变量。为了让configure把特殊的变量替换到输出文件中，
必须把那个变量的名字作为调用 AC_SUBST 的参数。其他变量的任何@variable@都保持不变。
    使用configure脚本的软件应该发布文件Makefile.in，而不是Makefile； 这样，
用户就可以在编译它之前正确地为本地系统进行配置了。
4. 创建目录
5. 自动地重新创建
6. 配置头文件(用autoheader创建config.h.in)
7. 在子目录中配置其它包
8. 缺省的前缀
    在缺省状态下，configure把它所安装的文件的前缀设置成/usr/local。 configure的用户可以通过选项
--prefix和--exec-prefix选择一个不同的前缀。 有两种方式修改缺省的行为：在创建configure时，和运行configure时。
9. configure中的版本号

10. 现有的测试
    对程序的选择
        对特定程序的检查
        对普通程序和文件的检查
    库文件
        对特定函数的检查
        对普通函数的检测
    头文件
        对特定头文件的检查
        对普通头文件的检查
    结构
    类型定义
        对特定类型定义的检查
        对普通类型定义的检查
    C编译器的特征
    系统服务
    UNIX变种
    
    检验声明
    检验语法
    检验运行时的特征
        运行测试程序
        AC_TRY_RUN(program, [action-if-true [, action-if-false [, action-if-cross-compiling]]])
    测试程序指南
    测试函数
    可移植的Shell编程
        测试值和文件
        
测试的结果
    一旦configure确定了某个特征是否存在，它将如何记录这一信息？这里有四种记录方式： 
    定义一个C预处理器符号、
    在输出文件中设置一个变量、
    为将来运行configure而把结果储存到一个缓存文件中， 
    以及打印一条消息以便让用户知道测试的结果。

        
}

ifnames(创建configure脚本){
    ifnames打印出包已经在C预处理条件中使用的标识符。如果包已经被设置得具备了某些可移植性，
该程序可以帮助你找到configure所需要进行的检查。它可能有助于补足由autoscan生成的configure.in中的某些缺陷。
    ifnames扫描所有在命令行中给出的C源代码文件(如果没有给出，就扫描标准输入)并且把排序后的、
由所有出现在这些文件中的#if、#elif、#ifdef或者#ifndef 命令中的标识符列表输出到标准输出中。
}

autoreconf(更新configure脚本){
如果你有大量由autoconf生成的configure脚本，程序autoreconf可以保留你的一些工作。
如果你安装了新版本的autoconf，你可以以选项--force调用autoreconf而重新创建 所有的文件。

如果你在调用autoreconf时给出选项--macrodir=dir或者--localdir=dir，它将把它们传递给autoconf和autoheader.
}

autoconf_i_AC_INIT(){ cat - <<'EOF'
AC_INIT (PACKAGE, VERSION, [BUG-REPORT], [TARNAME], [URL])
必须在产生输出的宏前调用，生成m4宏
AC_PACKAGE_NAME、        展开为PACKAGE_NAME
AC_PACKAGE_TARNAME、
AC_PACKAGE_VERSION、     展开为PACKAGE_VERSION
AC_PACKAGE_STRING、      展开为PACKAGE_STRING
AC_PACKAGE_BUGREPORT、   展开为PACKAGE_BUGREPORT
AC_PACKAGE_URL，         展开为PACKAGE_URL
同时定义预处理符号和输出变量(名字没有AC_前缀)


AC_INIT([zlog], [1.2])                               # beansdb-master/third-party/zlog-1.2/configure.ac
AC_INIT([kvspool], [1.0], [tdh@tkhanson.net])        # kvspool-master/configure.ac
AC_INIT([ltp], [LTP_VERSION], [ltp@lists.linux.it])  # ltp-full-20200120/configure.ac
AC_INIT([MFS], [3.0.104], [bugs@moosefs.com], [moosefs])
AC_INIT([beansdb], [0.7.1.4], [davies.liu@gmail.com])
    处理所有命令行参数并且寻找源代码目录。unique-file-in-source-dir是一些在包的源代码目录中文件； 
configure在目录中检查这些文件是否存在以确定该目录是否包含源代码。
    它扩展为许多可由其他configure脚本共享的模板文件代码。这些代码解析传到 configure中的命令行参数。
这个宏的一个参数是一个文件名，这个文件应该在源代码目录中，它用于健全性检查，以保证configure脚本
已正确定位源文件目录。
    
AC_INIT([MFS], [3.0.104], [bugs@moosefs.com], [moosefs])
PACKAGE_NAME='MFS'
PACKAGE_TARNAME='moosefs'
PACKAGE_VERSION='3.0.104'
PACKAGE_STRING='MFS 3.0.104'
PACKAGE_BUGREPORT='bugs@moosefs.com'
PACKAGE_URL=''

versmaj=$(echo $PACKAGE_VERSION | cut -d. -f1)
versmid=$(echo $PACKAGE_VERSION | cut -d. -f2)
versmin=$(echo $PACKAGE_VERSION | cut -d. -f3)
EOF
}

AC_CONFIG_AUX_DIR(寻找configure的输入文件){
AC_CONFIG_AUX_DIR([.])
AC_CONFIG_AUX_DIR([aux])
在目录dir中使用install-sh、config.sub、config.guess和 Cygnus configure配置脚本。
它们是配置中使用的辅助文件。dir既可以是绝对路径， 也可以是相对于srcdir的相对路径。
}
AC_OUTPUT(创建输出文件){
AC_OUTPUT([file... [, extra-cmds [, init-cmds]]])
AC_OUTPUT

创建输出文件。在configure.in的末尾调用本宏一次。参数file...是一个以空格分隔的输出文件 的列表；它可能为空。

一个典型的对AC_OUTPUT调用如下：
AC_OUTPUT(Makefile src/Makefile man/Makefile X/Imakefile)
你可以通过在file之后添加一个用冒号分隔的输入文件列表以自行设定输入文件名。例如：
AC_OUTPUT(Makefile:templates/top.mk lib/Makefile:templates/lib.mk)
AC_OUTPUT(Makefile:templates/vars.mk:Makefile.in:templates/rules.mk)
}
AC_OUTPUT_COMMANDS(创建输出文件){
AC_OUTPUT_COMMANDS(extra-cmds [, init-cmds])
    指定在config.status末尾运行的附加的shell命令，以及用于初始化来自于configure 的所有变量的shell命令。
本宏可以被调用多次。下面是一个不太实际的例子：
    fubar=27
    AC_OUTPUT_COMMANDS([echo this is extra $fubar, and so on.], fubar=$fubar)
    AC_OUTPUT_COMMANDS([echo this is another, extra, bit], [echo init bit])
}
AC_PROG_MAKE_SET(创建输出文件){
AC_PROG_MAKE_SET
    如果make预定义了变量MAKE，把输出变量SET_MAKE定义为空。否则，把 SET_MAKE定义成MAKE=make。为SET_MAKE调用AC_SUBST。 
为了使用这个宏，在每个其他的、运行MAKE的目录中的Makefile.in添加一行：
@SET_MAKE@
}


AC_SUBST(预定义输出变量){
bindir 用于安装由用户运行的可执行文件的目录。
configure_input 一个用于说明文件是由configure自动生成的，并且给出了输入文件名的注释。
datadir 用于安装只读的与结构无关的数据的目录。 
exec_prefix 与结构有关的文件的安装前缀。 
includedir 用于安装C头文件的目录。 
infodir 用于安装Info格式文档的目录。 
libdir 用于安装目标代码库的目录。 
libexecdir 用于安装由其他程序运行的可执行文件的目录。 
localstatedir 用于安装可以被修改的单机数据的目录。 
mandir 用于安装man格式的文档的顶层目录。 
oldincludedir 用于安装由非gcc编译器使用的C头文件的目录。 
prefix 与结构无关的文件的安装前缀。 
sbindir 用于安装由系统管理员运行的可执行文件的目录。 
sharedstatedir 用于安装可以修改的、与结构无关的数据的目录。 
srcdir 包含了由Makefile使用的源代码的目录。 
sysconfdir 用于安装只读的单机数据的目录。 
top_srcdir 包的顶层源代码目录。在目录的顶层，它与srcdir相同。
    
CFLAGS 为C编译器提供的调试和优化选项。
如果在运行configure时，没有在环境中设置它，就在你 调用AC_PROG_CC的时候设置它的缺省值(如果你没有调用AC_PROG_CC，它就为空)。 configure在编译程序以测试C的特征时，使用本变量。 

CPPFLAGS 为C预处理器和编译器提供头文件搜索目录选项(-Idir)以及其他各种选项。
如果在运行 configure时，在环境中没有设置本变量，缺省值就是空。configure在编译或者预处理 程序以测试C的特征时，使用本变量。 

CXXFLAGS 为C++编译器提供的调试和优化选项。
如果在运行configure时，没有在环境中设置本变量，那么 就在你调用AC_PROG_CXX时设置它的缺省值(如果你没有调用AC_PROG_CXX，它就为空)。 configure在编译程序以测试C++的特征时，使用本变量。 

DEFS 传递给C编译器的-D选项。
如果调用了AC_CONFIG_HEADER，configure就用 -DHAVE_CONFIG_H代替@DEFS@(参见配置头文件)。在configure进行它的测试时，本变量没有被定义，只有在创建输出文件时候才定义。关于如何检查从前的 测试结果，请参见设定输出变量。 

LDFLAGS 为连接器提供的Stripping(-s)选项和其他各种选项。如果在运行configure时， 在环境中没有设置本变量，它的缺省值就是空。 configure在连接程序以测试C的特征时使用本变量。 

LIBS 传递给连接器的-l和-L选项。
    
    
AC_SUBST([root_sbindir])
AC_SUBST([MATH_LIBS])
AC_SUBST([systemdunitdir])
AC_SUBST([CGIDIR])
AC_SUBST([CGISERVDIR])
AC_SUBST([PYTHON])
AC_SUBST([PCAP_LIBS])
AC_SUBST(FUSE_LIBS)
AC_SUBST([ZLIB_LIBS])
AC_SUBST([DATA_PATH])
AC_SUBST([ETC_PATH])
AC_SUBST([BIN_PATH])
AC_SUBST([SBIN_PATH])
AC_SUBST([RUN_PATH])
AC_SUBST([DEFAULT_USER])
AC_SUBST([DEFAULT_GROUP])
AC_SUBST([DEFAULT_PORTBASE])
AC_SUBST([DEFAULT_MASTER_CONTROL_PORT])
AC_SUBST([DEFAULT_MASTER_CS_PORT])
AC_SUBST([DEFAULT_MASTER_CLIENT_PORT])
AC_SUBST([DEFAULT_CS_DATA_PORT])
AC_SUBST([DEFAULT_CGISERV_HTTP_PORT])
AC_SUBST([DEFAULT_MASTERNAME])
AC_SUBST([PROTO_BASE])
AC_SUBST([LIGHT_MFS])
AC_SUBST([release])
}

AC_CONFIG_HEADER(配置头文件){
    通常输入文件被命名为header-to-create.in；然而，你可以通过在header-to-create 之后添加
由冒号分隔的输入文件列表来覆盖原输入文件名。 例：
AC_CONFIG_HEADER(defines.h:defines.hin)
AC_CONFIG_HEADER(defines.h:defs.pre:defines.h.in:defs.post)
AC_CONFIG_HEADER([config.h])

    使得AC_OUTPUT创建出现在以空格分隔的列表header-to-create中的文件， 以包含C预处理器#define语句，
并在生成的文件中用-DHAVE_CONFIG_H，而不是用DEFS的值，替换@DEFS@。常用在header-to-create 中的文件名是config.h。

你的发布版本应该包含一个如你所望的最终的头文件那样的模板文件，它包括注释、以及#define 语句的缺省值。
AC_CONFIG_HEADER(conf.h)
AC_CHECK_HEADERS(unistd.h)

那么你就应该在conf.h.in中包含下列代码。 在含有unistd.h的系统中，configure应该把0改成1。在其他系统中，这一行将保持不变。
/* Define as 1 if you have unistd.h.  */
#define HAVE_UNISTD_H 0

如果你的代码使用#ifdef而不是#if来测试配置选项，缺省值就可能是取消对一个变量 的定义而不是把它定义成一个值。
在含有unistd.h的系统中，configure将修改读入的第二行#define HAVE_UNISTD_H 1。在其他的系统中，
(在系统预定义了那个符号的情况下) configure将以注释的方式排除这一行。
/* Define if you have unistd.h.  */
#undef HAVE_UNISTD_H
}

autoheader(){
能够产生供configure脚本使用的C #define语句模板文件。

AC_CONFIG_HEADERS([config.h])
AC_CONFIG_HEADER([config.h])
---- 无参数
    如果configure.in调用了AC_CONFIG_HEADER(file)，autoheader就创建file.in；
如果给出了多文件参数，就使用第一个文件。否则，autoheader就创建config.h.in。
---- 有参数
    如果你为autoheader提供一个参数，它就使用给出的文件而不是configure.in，并且把头文件输出到标准输出中去，
而不是输出到config.h.in。如果你把'-'作为参数提供给autoheader ，它就从标准输入中，而不是从configure.in中读出，
并且把头文件输出到标准输出中去。
---- 
    autoheader扫描configure.in并且找出它可能要定义的C预处理器符号。它从一个名为acconfig.h
的文件中复制注释、#define和#undef语句，该文件与autoconf一同发布 并且一同安装。
如果当前目录中含有acconfig.h文件，它也会使用这个文件。
如果你用AC_DEFINE 定义了任何附加的符号，你必须在创建的那个acconfig.h文件中包含附加的符号。
对于由 AC_CHECK_HEADERS、AC_CHECK_FUNCS、AC_CHECK_SIZEOF或者 AC_CHECK_LIB定义的符号，
autoheader生成注释和#undef语句，而不是从一个 文件中复制它们，这是因为可能的符号是无限的。

autoheader创建的文件包含了大部分#define和#undef语句，以及相关的注释。
如果./acconfig.h包含了字符串@TOP@，autoheader就把在包含@TOP@ 的行之前的所有行复制到它生成的文件的开头。相似地，
如果./acconfig.h包含了字符串@BOTTOM@， autoheader就把那一行之后的所有行复制到它生成的文件的末尾。
这两个字符串的任何一个都可以被忽略， 也可以被同时忽略。
}

AC_CONFIG_SUBDIRS(在子目录中配置其它包){
    在大多数情况下，调用AC_OUTPUT足以在子目录中生成Makefile。然而，控制了多于一个独立包的configure脚本
可以使用AC_CONFIG_SUBDIRS来为每个子目录中的其他包运行 configure脚本。

AC_CONFIG_SUBDIRS([third-party/zlog-1.2])
AC_CONFIG_SUBDIRS([libmonit])

AC_CONFIG_SUBDIRS(dir ...)
    使得AC_OUTPUT在每个以空格分隔的列表中给出的子目录dir中运行configure。

        如果没有发现某个给出的dir，不会作为错误报告，所以一个configure脚本可以配置一个
大的源代码树中出现的任何一个部分。如果在给出的dir中包含了configure.in，但没有包含 configure，
就使用由AC_CONFIG_AUXDIR找到的Cygnus configure脚本。
}

AC_PREFIX_DEFAULT(缺省的前缀){
AC_PREFIX_DEFAULT(prefix)
    把缺省的安装前缀设置成prefix，而不是/usr/local。 
对于用户来说，让configure根据它们已经安装的相关程序的位置来猜测安装前缀，可能会带来方便。
如果你希望这样做，你可以调用AC_PREFIX_PROGRAM。 
}
AC_PREFIX_PROGRAM(缺省的前缀){
AC_PREFIX_PROGRAM(program)
    如果用户没有给出安装前缀(使用选项--prefix)，就按照shell的方式，在PATH中寻找 program，
从而猜出一个安装前缀。如果找到了program，就把前缀设置成包含program 的目录的父目录；否则，
就不改变在Makefile.in中给定的前缀。例如，如果program是 gcc，并且PATH包括了/usr/local/gnu/bin/gcc，
就把前缀设置为/usr/local/gnu。 
}

autoconf_i_AC_PREREQ(){ cat - << 'EOF'
AC_PREREQ (VERSION)  # 保证autoconf版本至少为什么，可在AC_INIT前用
AC_PREREQ(2.60)      # moosefs-3.0.104        -- configure.ac
AC_PREREQ(2.53)      # monit-5.25.2           -- configure.ac
AC_PREREQ(2.59)      # libevent-2.1.10-stable -- configure.ac
    确保使用的是足够新的autoconf版本。如果用于创建configure的autoconf的版本比version要早，
就在标准错误输出打印一条错误消息并不会创建configure。例如：
    AC_PREREQ(1.8)
    如果你的configure.in依赖于在不同autoconf版本中改变了的、不明显的行为，本宏就是有用的。 
如果它仅仅是需要近来增加的宏，那么AC_PREREQ就不太有用，这是因为程序autoconf已经告诉了用户
那些宏没有被找到。如果configure.in是由一个在提供AC_PREREQ之前的更旧的 autoconf版本处理的，也会发生同样的事
EOF
}

AC_REVISION(configure中的版本号){
AC_REVISION(revision-info)
    把删除了任何美元符或者双引号的修订标记(revision stamp)复制到configure脚本中。 
本宏使得你的从configure.in传递到configure的修订标记不会在你提交(check in)
configure的时候被RCS或者CVS修改。你可以容易地决定一个特定的configure 对应与configure.in的哪个修订版。
    
    把本宏放在AC_INIT之前是个好主意，它可以使修订号接近configure.in和configure 的开头。
为了支持你这样做，AC_REVISION就像configure通常作的那样，以#! /bin/sh开始它的输出。
    例如，在configure.in中这一行为：
    AC_REVISION($Revision: 1.1 $)dnl
    在configure中产生了：
    #! /bin/sh
    # From configure.in Revision: 1.30
}

autoconf_p_AC_PROG(){ cat - << 'EOF'
AC_PROG_AWK                             准备awk命令
AC_PROG_CC ([COMPILER-SEARCH-LIST])     准备C编译器
AC_PROG_CC_C89                          准备使用C89
AC_PROG_CC_C99                          准备使用C99
AC_PROG_CC_C_O                          若C编译器不支持同时-c -o选项，则定义NO_MINUS_C_MINUS_O
AC_PROG_CC_STDC                         准备使用ISO C
AC_PROG_CPP                             准备C预处理器
AC_PROG_CPP_WERROR 	                    准备C预处理器，使警告成为错误
AC_PROG_CXX ([COMPILER-SEARCH-LIST])    准备C++编译器
AC_PROG_CXXCPP                          准备C++预处理器
AC_PROG_CXX_C_O                         若C++编译器不支持同时-c -o选项，则定义CXX_NO_MINUS_C_MINUS_O
AC_PROG_EGREP                           准备egrep命令.
AC_PROG_F77 ([COMPILER-SEARCH-LIST])    准备Fortran77编译器
AC_PROG_F77_C_O                         若Fortran 77编译器不支持同时-c -o选项，则定义F77_NO_MINUS_C_MINUS_O
AC_PROG_FC ([COMPILER-SEARCH-LIST], [DIALECT])  准备Fortran编译器
AC_PROG_FC_C_O 	                        若Fortran编译器不支持同时-c -o选项，则定义FC_NO_MINUS_C_MINUS_O
AC_PROG_FGREP                           准备fgrep命令
AC_PROG_GREP                            准备grep命令
AC_PROG_INSTALL                         准备install命令.
AC_PROG_LEX                             准备lex命令
AC_PROG_LN_S                            准备ln -s命令
AC_PROG_MAKE_SET                        Output.
AC_PROG_MKDIR_P                         准备mkdir -p命令
AC_PROG_OBJC ([COMPILER-SEARCH-LIST])   准备Objective C编译器命令
AC_PROG_OBJCPP                          准备Objective C预处理器命令
AC_PROG_OBJCXX ([COMPILER-SEARCH-LIST]) 准备Objective C++编译器命令
AC_PROG_OBJCXXCPP                       准备Objective C预处理器命令
AC_PROG_RANLIB                          准备ranlib命令
AC_PROG_SED                             准备sed命令
AC_PROG_YACC                            准备yacc命令
EOF
}

autoconf_i_AC_PROG(){ cat - << 'EOF'
对特定程序的检查
AC_DECL_YYTEXT
    如果yytext的类型是char * 而不是char []，就定义YYTEXT_POINTER。 本宏还把输出变量LEX_OUTPUT_ROOT
 设置由lex生成的文件名的基文件名；通常是lex.yy， 但有时是其他的东西。它的结果依使用lex还是使用flex而定。 

宏： AC_PROG_AWK
    按顺序查找mawk、gawk、nawk和awk，并且把输出变量AWK 的值设置成第一个找到的程序名。
首先寻找mawk是因为据说它是最快的实现。 

AC_PROG_CC(mycc gcc llvm-gcc clang)
AC_PROG_CC
宏： AC_PROG_CC
    确定C的编译器。如果在环境中没有设定CC，就查找gcc，如果没有找到，就使用cc。
把输出变量CC设置为找到的编译器的名字。
    如果要使用GNU C编译器，把shell变量GCC设置为yes，否则就设置成空。如果还没有设置输出变量 
CFLAGS，就为GNU C编译器把CFLAGS设置成 -g -O2(在GCC不接受-g 的系统中就设置成-O2)，为其他编译器把CFLAGS设置成-g。
    如果被使用的C编译器并不生成可以在configure运行的系统上运行的可执行文件，就把shell变量
cross_compiling设置成yes，否则设置成no。换句话说，它检查创建系统类型 是否与主机系统类型不同
(目标系统与本测试无关)。关于对交叉编译的支持，参见手工配置。 

AM_PROG_CC_C_O
宏： AC_PROG_CC_C_O
    对于不能同时接受-c和-o选项的C编译器，定义NO_MINUS_C_MINUS_O。 

宏： AC_PROG_CPP
    把输出变量CPP设置成运行C预处理器的命令。如果$CC -E不能工作，就使用/lib/cpp。 
只有对以.c为扩展名的文件运行CPP才是可以移植的(portable)。
    如果当前语言是C(参见对语言的选择)，许多特定的测试宏通过调用AC_TRY_CPP、 
AC_CHECK_HEADER、AC_EGREP_HEADER或者AC_EGREP_CPP，间接地使用了CPP的值。 

宏： AC_PROG_CXX
    确定C++编译器。检查环境变量CXX或者CCC(按照这个顺序)是否被设置了；如果设置了，
就把输出变量 CXX设置成它的值。否则就搜索类似名称(c++、g++、gcc、CC、 cxx和cc++)的C++编译器。
如果上述测试都失败了，最后的办法就是把CXX设置成 gcc。
    如果使用GNU C++编译器，就把shell变量GXX设置成yes，否则就设置成空。 如果还没有设置输出变量CXXFLAGS，
就为GNU C++编译器把CXXFLAGS设置成-g -O2 (在G++不接受-g的系统上设置成-O2)，或者为其他编译器把CXXFLAGS设置成-g。 .
    如果使用的C++编译器并不生成在configure运行的系统上运行的可执行文件，就把shell变量cross_compiling 
设置成yes，否则就设置成no。换句话说，它检查创建系统类型是否与主机系统类型不同 (目标系统类型与本测试无关)。
关于对交叉编译的支持，参见手工配置。 

宏： AC_PROG_CXXCPP
    把输出变量CXXCPP设置成运行C++预处理器的命令。如果$CXX -E不能工作，使用/lib/cpp。 只有对以.c、.C或者.cc
为扩展名的文件运行CPP才是可以移植的(portable)。
    如果当前语言是C++(参见对语言的选择)，许多特定的测试宏通过调用 AC_TRY_CPP、AC_CHECK_HEADER、
AC_EGREP_HEADER或者AC_EGREP_CPP， 间接地使用了CXXCPP的值。 


宏： AC_PROG_GCC_TRADITIONAL
    如果在没有给出-traditional的情况下，用GNU C和ioctl不能正确地工作，就把 -traditional添加到输出变量CC中。
这通常发生在旧系统上没有安装修正了的头文件 的时候。因为新版本的GNU C编译器在安装的时候自动地修正了头文件，
它就不是一个普遍的问题了。 

AC_PROG_INSTALL
宏： AC_PROG_INSTALL
    如果在当前PATH中找到了一个与BSD兼容的install程序，就把输出变量INSTALL设置 成到该程序的路径。
否则，就把INSTALL设置成dir/install-sh -c，检查由 AC_CONFIG_AUX_DIR指明的目录(或者它的缺省目录)
以确定dir(参见 创建输出文件)。本宏还把变量INSTALL_PROGRAM和INSTALL_SCRIPT 设置成${INSTALL}，
并且把INSTALL_DATA设置成${INSTALL} -m 644。

宏： AC_PROG_LEX
    如果找到了flex，就把输出变量LEX设置成flex，并且在flex库在标准位置的时候， 把LEXLIB设置成-lfl。
否则，就把LEX设置成lex并且把 LEXLIB设置成-ll。 

宏： AC_PROG_LN_S
    如果ln -s能够在当前文件系统中工作(操作系统和文件系统支持符号连接)，就把输出变量 LN_S设置成ln -s，
否则就把它设置成ln。
  
宏： AC_PROG_RANLIB
    如果找到了ranlib，就把输出变量RANLIB设置成ranlib，否则就设置成 :(什么也不作)。 

宏： AC_PROG_YACC
    如果找到了bison，就把输出变量YACC设置成bison -y。 否则，如果找到了byacc。就把YACC设置成byacc。
否则， 就把YACC设置成yacc。
EOF
}

autoconf_t_AC_PATH_PROG(){ cat - << 'EOF'
AC_PATH_PROG([FLEX], [flex], [no], [$PATH:/usr/local/bin:/usr/bin])
if test "x$FLEX" = "xno"; then
  # Require flex unless lex.yy.c already is built
  if test ! -f src/lex.yy.c; then
    AC_MSG_ERROR([flex is required. Download from http://www.gnu.org/software/flex/])
  fi
fi
AC_PATH_PROG([POD2MAN], [pod2man], [no], [$PATH:/usr/local/bin:/usr/bin])
if test "x$POD2MAN" = "xno"; then
  # Require pod2man unless monit.1 already is built
  if test ! -f monit.1; then
    AC_MSG_ERROR([pod2man is required to build the monit.1 man file.])
  fi
else
  POD2MANFLAGS="--center 'User Commands' --release AC_PACKAGE_VERSION --date='www.mmonit.com' --lax"
  AC_SUBST([POD2MANFLAGS])
fi
EOF
}


autoconf_t_AC_CHECK_PROGS(){ cat - << 'EOF'
AC_CHECK_PROGS([KILL], [kill])
AC_CHECK_PROGS([YACC], ['bison -y' byacc yacc], [no], [$PATH:/usr/local/bin:/usr/bin])
if test "x$YACC" = "xno"; then
  # Require bison unless y.tab.c already is built
  if test ! -f src/y.tab.c; then
    AC_MSG_ERROR([Monit require bison, byacc or yacc. Download bison from http://www.gnu.org/software/bison/])         
  fi
fi

ifdef([AC_PROG_SED], [AC_PROG_SED], [
AC_CHECK_PROGS(SED, [gsed sed])
])
EOF
}

autoconf_p_AC_SUBST(){ cat - << 'EOF'
设置输出变量
AC_SUBST (VARIABLE, [VALUE]) 	由shell变量创建相同值的输出变量，可选择赋值
AC_SUBST_FILE (VARIABLE) 	    由shell变量创建值为它指定文件内容的输出变量

AC_SUBST([root_sbindir])

@root_sbindir@
EOF
}


autoconf_p_CHECK_FILE_PROG(){ cat - << 'EOF'
AC_CHECK_FILE (FILE, [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND])      按文件是否存在做不同工作
AC_CHECK_FILES (FILES, [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND])    按各文件是否存在做不同工作，定义各HAVE_FILE为1或0

AC_CHECK_PROG (VARIABLE, PROG-TO-CHECK-FOR, VALUE-IF-FOUND, [VALUE-IF-NOT-FOUND], [PATH = '$PATH'], [REJECT]) 	
按PROG-TO-CHECK-FOR在PATH是否存在把VARIABLE设置为VALUE-IF-FOUND或VALUE-IF-NOT-FOUND

AC_CHECK_PROGS (VARIABLE, PROGS-TO-CHECK-FOR, [VALUE-IF-NOT-FOUND], [PATH = '$PATH']) 	
按PROG-TO-CHECK-FOR在PATH中首个存在的设置VARIABLE设置，没有则VALUE-IF-NOT-FOUND或不变

AC_CHECK_TOOL (VARIABLE, PROG-TO-CHECK-FOR, [VALUE-IF-NOT-FOUND], [PATH = '$PATH']) 	
与AC_CHECK_PROG类似，但在程序前加运行机类型和-前缀
AC_CHECK_TOOLS (VARIABLE, PROGS-TO-CHECK-FOR, [VALUE-IF-NOT-FOUND], [PATH = '$PATH']) 	
与AC_CHECK_PROGS类似，但在程序前加运行机类型和-前缀

AC_CHECK_TARGET_TOOL (VARIABLE, PROG-TO-CHECK-FOR, [VALUE-IF-NOT-FOUND], [PATH = '$PATH']) 	
与AC_CHECK_PROG类似，但在程序前加目标类型和-前缀（与构建机类型同也接受不加）
AC_CHECK_TARGET_TOOLS (VARIABLE, PROGS-TO-CHECK-FOR, [VALUE-IF-NOT-FOUND], [PATH = '$PATH']) 	
与AC_CHECK_PROGS类似，但在程序前加目标类型和-前缀（与构建机类型同也接受不加）

EOF
}
autoconf_i_CHECK_FILE_PROG(){ cat - << 'EOF'
宏： AC_CHECK_FILE(file [, action-if-found [, action-if-not-found]])
    检查文件file是否出现在本地系统中。如果找到了，就执行action-if-found。否则，
就在给出了 action-if-not-found的时候执行action-if-not-found。 

宏： AC_CHECK_FILES(files[, action-if-found [, action-if-not-found]])
    为每个在files中给出的文件运行AC_CHECK_FILE。并且为每个找到的文件定义 HAVEfile，定义成1。

宏： AC_CHECK_PROG(variable, prog-to-check-for, value-if-found [, value-if-not-found [, path, [ reject ]]])
    检查程序prog-to-check-for是否存在于PATH之中。如果找到了，就把变量variable设置成value-if-found，
否则就在给出了value-if-not-found的时候把variable设置成它。即使首先在搜索路径中找到reject(一个绝对文件名)，
本宏也会忽略它； 在那种情况下，用找到的prog-to-check-for，不同于reject的绝对文件名来设置variable。 
如果variable已经被设置了，就什么也不作。为variable调用AC_SUBST。 

宏： AC_CHECK_PROGS(variable, progs-to-check-for [, value-if-not-found [, path]])
    在PATH中寻找每个出现在以空格分隔的列表progs-to-check-for中的程序。 如果找到了，
就把variable设置成那个程序的名字。否则，继续寻找列表中的下一个程序。如果列表中的任何一个程序都没有被找到，
就把variable设置成value-if-not-found；如果没有给出value-if-not-found，variable的值就不会被改变。
为variable调用 AC_SUBST。 

AC_CHECK_TOOL(READELF, readelf, false)
AC_CHECK_TOOL(NM, nm, false)
AC_DEFUN([AC_PROG_AR], [AC_CHECK_TOOL(AR, ar, :)])  
宏： AC_CHECK_TOOL(variable, prog-to-check-for [, value-if-not-found [, path]])
    除了把AC_CANONICAL_HOST确定的主机类型和破折号作为前缀之外，类似于AC_CHECK_PROG， 寻找prog-to-check-for
(参见获取规范的系统类型)。 例如，如果用户运行configure --host=i386-gnu，那么下列调用：
    AC_CHECK_TOOL(RANLIB, ranlib, :)
    当i386-gnu-ranlib在PATH中存在的时候，就把RANLIB设置成i386-gnu-ranlib， 或者当ranlib在PATH中存在的时候，
就把RANLIB设置成ranlib， 或者在上述两个程序都不存在的时候，把RANLIB设置成:。 

AC_PATH_PROG(BASH_SHELL, bash, no)
AC_PATH_PROG(PERL, perl, no)
AC_PATH_PROG(INSTALL_INFO, install-info, no,
宏： AC_PATH_PROG(variable, prog-to-check-for [, value-if-not-found [, path]])
    类似于AC_CHECK_PROG，但在找到prog-to-check-for的时候，把variable设置 成prog-to-check-for的完整路径。 

宏： AC_PATH_PROGS(variable, progs-to-check-for [, value-if-not-found [, path]])
    类似于AC_CHECK_PROGS，但在找到任何一个progs-to-check-for的时候，把variable 设置成找到的程序的完整路径。
EOF
}

autoconf_t_AC_CHECK_MEMBERS(){ cat - << 'EOF'
AC_CHECK_MEMBER (AGGREGATE.MEMBER, [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND], [INCLUDES = 'AC_INCLUDES_DEFAULT']) 	
按是否有指定成员做不同事情
AC_CHECK_MEMBERS (MEMBERS, [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND], [INCLUDES = 'AC_INCLUDES_DEFAULT']) 	
按是否有指定成员做不同事情，定义HAVE_AGGREGATE_MEMBER为0或1

AC_CHECK_MEMBERS([struct stat.st_rdev])
AC_CHECK_MEMBERS([struct stat.st_birthtime])
AC_CHECK_MEMBERS([struct stat.st_blksize])
AC_CHECK_MEMBERS([struct stat.st_flags])
AC_CHECK_MEMBER([struct sockaddr_in.sin_len], [ AC_DEFINE(HAVE_SOCKADDR_SIN_LEN, 1, [Do we have sockaddr.sin_len?]) ], [], [
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
])

AC_CHECK_MEMBERS([struct tm.tm_gmtoff],,, [
#ifdef TM_IN_SYS_TIME
#  include <sys/time.h>
#else
#  include <time.h>
#endif
])
EOF
}

autoconf_t_AC_CHECK_FUNC(){ cat - << 'EOF'
AC_CHECK_FUNC (FUNCTION, [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND])      按C函数是否已声明做不同工作
AC_CHECK_FUNCS (FUNCTIONS, [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND])    按各函数（用空白分隔）是否已声明做不同工作，定义各HAVE_FUNCTION为1或0
AC_CHECK_FUNCS_ONCE (FUNCTIONS) 	                                    定义各HAVE_FUNCTION为1或0

[AC_CHECK_FUNCS]
AC_CHECK_FUNCS([malloc realloc reallocf])

# required functions
AC_CHECK_FUNCS([atexit bzero ftruncate getaddrinfo getpass gettimeofday memmove memset mkdir realpath poll socket strchr strdup strtol strtoul ftello fseeko],, [AC_MSG_ERROR([One of required functions was not found])])

# optional temporary file function
AC_CHECK_FUNCS([mkstemp mktemp])

# optional error conversion functions
AC_CHECK_FUNCS([strerror perror])

# optional system functions
AC_CHECK_FUNCS([dup2 mlockall getcwd setproctitle])


[AC_CHECK_LIB+AC_CHECK_FUNCS]
AC_CHECK_HEADERS([sys/mman.h], [AC_CHECK_FUNCS([mmap])])
AC_CHECK_HEADERS([poll.h], [AC_CHECK_FUNCS([poll])])
AC_CHECK_HEADERS([mach/mach.h mach/mach_time.h], [AC_CHECK_FUNCS([mach_absolute_time mach_timebase_info])])
EOF
}

autoconf_t_AC_CHECK_HEADERS(){ cat - << 'EOF'
AC_CHECK_HEADERS(HEADER-FILES, [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND], [INCLUDES])    按系统头文件能否编译做不同事，定义HAVE_HEADER-FILE为0或1
AC_CHECK_HEADERS_ONCE (HEADER-FILES)                    定义HAVE_HEADER-FILE为0或1

AC_CHECK_HEADERS([linux/nbd.h linux/fs.h],,[bdev=no])


[AC_CHECK_HEADERS]
AC_CHECK_HEADERS([arpa/inet.h fcntl.h inttypes.h limits.h netdb.h netinet/in.h stddef.h stdlib.h string.h sys/socket.h sys/statvfs.h sys/time.h syslog.h unistd.h],, [AC_MSG_ERROR([One of required headers was not found])])
AC_CHECK_HEADERS([attr/xattr.h])
AC_CHECK_HEADERS([sys/xattr.h])

[AC_CHECK_HEADERS+AC_CHECK_FUNCS]
AC_CHECK_HEADERS([sys/mman.h], [AC_CHECK_FUNCS([mmap])])
AC_CHECK_HEADERS([poll.h], [AC_CHECK_FUNCS([poll])])

[AC_CHECK_LIB+AC_CHECK_HEADERS]
AC_CHECK_LIB(z, zlibVersion, [ AC_CHECK_HEADERS(zlib.h,[zlib=yes]) ])
EOF
}

autoconf_t_AC_CHECK_LIB(){ cat - << 'EOF'
AC_CHECK_LIB (LIBRARY, FUNCTION, [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND], [OTHER-LIBRARIES])
按是否存在库函数做不同事情

mathlib=no
AC_CHECK_LIB([m],[round],[ AC_CHECK_HEADERS([math.h],[mathlib=yes]) ])

pcap=no
AC_CHECK_LIB([pcap],[pcap_lib_version],[ AC_CHECK_HEADERS([pcap.h],[pcap=yes]) ])

AC_CHECK_LIB(fuse, fuse_version, [AC_DEFINE([HAVE_FUSE_VERSION],[1],[libfuse has function fuse_version])])

zlib=no
AC_CHECK_LIB(z, zlibVersion, [ AC_CHECK_HEADERS(zlib.h,[zlib=yes]) ])
EOF
}

autoconf_t_AC_SEARCH_LIBS(){ cat - << 'EOF'
AC_SEARCH_LIBS (FUNCTION, SEARCH-LIBS, [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND], [OTHER-LIBRARIES])
寻找有指定函数的库并前置到LIBS

EOF
}

autoconf_i_AC_CHECK_LIB(){ 
宏： AC_CHECK_LIB(library, function [, action-if-found [, action-if-not-found [, other-libraries]]])
依赖于当前的语言(参见对语言的选择)，试图通过检查一个测试程序是否可以和 库library进行连接以获取
action-if-found是一个在与库成功地进行了连接的时候运行的shell命令列表； 
action-if-not-found是一个在与库的连接失败的时候运行的shell命令列表。 
如果没有给出action-if-found，缺省的动作就是把-llibrary添加到 LIBS中，并且定义HAVE_LIBlibrary(全部使用大写字母)。
如果与library的连接导致了未定义符号错误(unresolved symbols)，而这些错误可以通过与其他库的连接来解决，
 就把这些库用空格分隔，并作为other-libraries参数给出：-lXt -lX11。否则，本宏 对library是否存在的检测将会失败，
 这是因为对测试程序的连接将总是因为含有未定义符号错误而失败。 

宏： AC_HAVE_LIBRARY(library, [, action-if-found [, action-if-not-found [, other-libraries]]])
本宏等价于function参数为main的，对AC_CHECK_LIB的调用。 此外，library可以写作foo、-lfoo或者libfoo.a。 
对于以上任一种形式，编译器都使用-lfoo。但是，library不能是一个shell变量； 它必须是一个文字名literal name。
本宏是一个过时的宏。 

宏： AC_SEARCH_LIBS(function, search-libs [, action-if-found [, action-if-not-found [, other-libraries]]])
如果function还不可用，就寻找一个定义了function的库。这等同于首先不带库调用 AC_TRY_LINK_FUNC，
而后为每个在search-libs中列举的库调用AC_TRY_LINK_FUNC。
如果找到了函数，就运行action-if-found。否则运行action-if-not-found。
如果与库library的连接导致了未定义符号错误，而这些错误可以通过与附加的库进行连接来解决，
}

CHECK(对特定函数检测){
宏： AC_FUNC_ALLOCA
     HAVE_ALLOCA_H

宏： AC_FUNC_CLOSEDIR_VOID
    CLOSEDIR_VOID
    如果函数closedir不返回有意义的值，就定义CLOSEDIR_VOID。否则，调用者就应该 把它的返回值作为错误指示器来进行检查。 

宏： AC_FUNC_FNMATCH
    HAVE_FNMATCH
    如果可以使用fnmatch函数，并且能够工作(不象SunOS 5.4中的fnmatch那样)， 就定义HAVE_FNMATCH。 

宏： AC_FUNC_GETLOADAVG
    HAVE_GETLOADAVG
    检查如何才能获得系统平均负载。如果系统含有getloadavg函数，本宏就定义HAVE_GETLOADAVG， 并且把为了获得该函数而需要的库添加到LIBS中。

宏： AC_FUNC_GETMNTENT
    HAVE_GETMNTENT
    为Irix 4、PTX和Unixware在库sun、seq和gen中分别查找getmntent函数。 那么，如果可以使用getmntent，就定义HAVE_GETMNTENT。 

宏： AC_FUNC_GETPGRP
    GETPGRP_VOID
    如果getpgrp不接受参数(POSIX.1版)，就定义GETPGRP_VOID。否则，它就是一个把 进程ID作为参数的BSD版本。本宏根本不检查getpgrp是否存在；如果你需要检查它的存在性，就首先为 getpgrp函数调用AC_CHECK_FUNC。 

宏： AC_FUNC_MEMCMP
    如果不能使用memcmp函数，或者不能处理8位数据(就像SunOS 4.1.3中的那样)，就把memcmp.o 添加到输出变量LIBOBJS中去。 

宏： AC_FUNC_MMAP
    HAVE_MMAP
    如果函数mmap存在并且能够正确地工作，就定义HAVE_MMAP。只检查已经映射(already-mapped) 的内存的私有固定映射(private fixed mapping)。 

宏： AC_FUNC_SELECT_ARGTYPES
    SELECT_TYPE_ARG1、 SELECT_TYPE_ARG234和SELECT_TYPE_ARG5。SELECT_TYPE_ARG1
    确定函数select的每个参数的正确类型，并且把这些类型分别定义成SELECT_TYPE_ARG1、 SELECT_TYPE_ARG234和SELECT_TYPE_ARG5。SELECT_TYPE_ARG1的缺省值
    是int，SELECT_TYPE_ARG234的缺省值是int *， SELECT_TYPE_ARG5的缺省值是struct timeval *。 

宏： AC_FUNC_SETPGRP
    SETPGRP_VOID
    如果setpgrp不接受参数(POSIX.1版)，就定义SETPGRP_VOID。否则，该函数就是一个 把两个进程ID作为参数的BSD版本。本宏并不检查函数setpgrp是否存在；如果你需要检查该函数的存在 性，就首先为setpgrp调用AC_CHECK_FUNC。 

宏： AC_FUNC_SETVBUF_REVERSED
    SETVBUF_REVERSED
    如果函数setvbuf的第二个参数是缓冲区的类型并且第三个参数是缓冲区指针，而不是其他形式， 就定义SETVBUF_REVERSED。这是在System V第3版以前的情况。 

宏： AC_FUNC_STRCOLL
    HAVE_STRCOLL
    如果函数strcoll存在并且可以正确地工作，就定义HAVE_STRCOLL。 由于有些系统包含了错误定义的strcoll，
    这时就不应该使用strcoll， 因此本宏要比AC_CHECK_FUNCS(strcoll)多作一些检查。 

宏： AC_FUNC_STRFTIME
    HAVE_STRFTIME
    对于SCO UNIX，在库intl中查找strftime。而后，如果可以使用strftime， 就定义HAVE_STRFTIME。 

宏： AC_FUNC_UTIME_NULL
    HAVE_UTIME_NULL。
    如果utime(file, NULL)把file的时间标记设置成现在，就定义 HAVE_UTIME_NULL。 

宏： AC_FUNC_VFORK
    HAVE_VFORK_H
    如果找到了vfork.h，就定义HAVE_VFORK_H。如果找不到可以工作的vfork， 就把vfork定义成fork。
    本宏检查一些已知的vfork实现中的错误 并且认为如果vfork的实现含有任何一个错误，系统就不含有可以工作的vfork。
    由于子进程很少改变它们的信号句柄(signal handler)，所以如果子进程的signal调用(invocation) 
    修改了父进程的信号句柄，将不会被当作实现的错误。 

宏： AC_FUNC_VPRINTF
    HAVE_VPRINTF
    如果找到了vprintf，就定义HAVE_VPRINTF。否则，如果找到了_doprnt， 就定义HAVE_DOPRNT。(如果可以使用vprintf，你就可以假定也可以使用vfprintf 和vsprintf。) 

宏： AC_FUNC_WAIT3
    HAVE_WAIT3
    如果找到了wait3并且该函数填充它的第三个参数的内容(struct rusage *)
    就定义HAVE_WAIT3。在HP-UX中，该函数并不这样做。
}

CHECK(对普通函数的检查){
    这些宏被用于寻找没有包括在特定函数测试宏中的函数。如果函数可能出现在除了缺省C库以外的库中，
就要首先为这些库调用AC_CHECK_LIB。如果你除了需要检查函数是否存在之外，还要检查函数 的行为，
你就不得不为此而编写你自己的测试(参见编写测试)。

AC_CHECK_FUNC(daemon,AC_DEFINE([HAVE_DAEMON],,[Define this if you have daemon()]),[AC_LIBOBJ(daemon)])
AC_CHECK_FUNCS([malloc realloc reallocf])
AC_CHECK_FUNCS([atexit bzero ftruncate getaddrinfo getpass gettimeofday memmove memset mkdir realpath poll socket strchr strdup strtol strtoul ftello fseeko],, [AC_MSG_ERROR([One of required functions was not found])])              
AC_CHECK_FUNCS([mkstemp mktemp])
AC_CHECK_FUNCS([strerror perror])
AC_CHECK_FUNCS([dup2 mlockall getcwd setproctitle])
AC_CHECK_HEADERS([sys/mman.h], [AC_CHECK_FUNCS([mmap])])
AC_CHECK_HEADERS([poll.h], [AC_CHECK_FUNCS([poll])])
AC_CHECK_FUNCS([pread pwrite readv writev posix_fadvise])
AC_CHECK_FUNCS([nanosleep])
AC_CHECK_FUNCS([getrusage setitimer])
AC_CHECK_HEADERS([mach/mach.h mach/mach_time.h], [AC_CHECK_FUNCS([mach_absolute_time mach_timebase_info])])
AC_CHECK_FUNCS([clock_gettime])
AC_CHECK_FUNCS([mallopt])
AC_CHECK_HEADERS([sys/prctl.h], [AC_CHECK_FUNCS([prctl])])

宏： AC_CHECK_FUNC(function, [action-if-found [, action-if-not-found]])
    如果可以使用C函数function，就运行shell命令action-if-found，否则运行 action-if-not-found。
    如果你只希望在函数可用的时候定义一个符号，就考虑使用 AC_CHECK_FUNCS。由于C++比C更加标准化，
    即使在调用了AC_LANG_CPLUSPLUS 的时候，本宏仍然用C的连接方式对函数进行检查。
    (关于为测试选择语言的详情，请参见 对语言的选择) 

宏： AC_CHECK_FUNCS(function... [, action-if-found [, action-if-not-found]])
    对于每个在以空格分隔的函数列表function中出现的函数，如果可用，就定义HAVE_function (全部大写)。如果给出了action-if-found，它就是在找到一个函数的时候执行的附加的shell代码。你可以给出 
    break以便在找到第一个匹配的时候跳出循环。如果给出了action-if-not-found，它就在找不到 某个函数的时候执行。 

宏： AC_REPLACE_FUNCS(function...)
    本宏的功能就类似于以将function.o添加到输出变量LIBOBJS的shell 代码为参数action-if-not-found，
    调用AC_CHECK_FUNCS。你可以通过用 #ifndef HAVE_function包围你为函数提供的替代版本的原型来声明函数。
    如果系统含有该函数，它可能在一个你应该引入的头文件中进行声明，所以你不应该重新声明它，以避免声明冲突。
}
CHECK(对特定头文件的检查){
宏： AC_DECL_SYS_SIGLIST
    如果在系统头文件，'signal.h'或者'unistd.h'，中定义了变量sys_siglist， 就定义SYS_SIGLIST_DECLARED。 
宏： AC_DIR_HEADER
    类似于调用AC_HEADER_DIRENT和AC_FUNC_CLOSEDIR_VOID，但为了指明找到了 哪个头文件而定义了不同的一组C预处理器宏。本宏和它定义的名字是过时的。它定义的名字是：
    'dirent.h'
        DIRENT 
    'sys/ndir.h'
        SYSNDIR 
    'sys/dir.h'
        SYSDIR 
    'ndir.h'
        NDIR 
    此外，如果closedir不能返回一个有意义的值，就定义VOID_CLOSEDIR。 
宏： AC_HEADER_DIRENT
    对下列头文件进行检查，并且为第一个找到的头文件定义'DIR'，以及列出的C预处理器宏：
    'dirent.h'
        HAVE_DIRENT_H 
    'sys/ndir.h'
        HAVE_SYS_NDIR_H 
    'sys/dir.h'
        HAVE_SYS_DIR_H 
    'ndir.h'
        HAVE_NDIR_H 
    源代码中的目录库声明应该以类似于下面的方式给出：

    #if HAVE_DIRENT_H
    # include <dirent.h>
    # define NAMLEN(dirent) strlen((dirent)->d_name)
    #else
    # define dirent direct
    # define NAMLEN(dirent)(dirent)->d_namlen
    # if HAVE_SYS_NDIR_H
    #  include <sys/ndir.h>
    # endif
    # if HAVE_SYS_DIR_H
    #  include <sys/dir.h>
    # endif
    # if HAVE_NDIR_H
    #  include <ndir.h>
    # endif
    #endif

    使用上述声明，程序应该把变量定义成类型struct dirent，而不是struct direct，并且应该 通过把指向struct direct的指针传递给宏NAMLEN来获得目录项的名称的长度。
    本宏还为SCO Xenix检查库'dir'和'x'。 
宏： AC_HEADER_MAJOR
    如果'sys/types.h'没有定义major、minor和makedev， 但'sys/mkdev.h'定义了它们，就定义MAJOR_IN_MKDEV； 否则，如果'sys/sysmacros.h'定义了它们，就定义MAJOR_IN_SYSMACROS。 

宏： AC_HEADER_STDC
    如果含有标准C(ANSI C)头文件，就定义STDC_HEADERS。 特别地，本宏检查'stdlib.h'、'stdarg.h'、'string.h'和'float.h'； 如果系统含有这些头文件，它可能也含有其他的标准C头文件。本宏还检查'string.h'是否定义了memchr (并据此对其他mem函数做出假定)，'stdlib.h'是否定义了free(并据此 对malloc和其他相关函数做出假定)，以及'ctype.h'宏是否按照标准C的要求而可以 用于被设置了高位的字符。

    因为许多含有GCC的系统并不含有标准C头文件，所以用STDC_HEADERS而不是__STDC__ 来决定系统是否含有服从标准(ANSI-compliant)的头文件(以及可能的C库函数)。

    在没有标准C头文件的系统上，变种太多，以至于可能没有简单的方式对你所使用的函数进行定义以 使得它们与系统头文件声明的函数完全相同。某些系统包含了ANSI和BSD函数的混合；某些基本上是标准(ANSI) 的，但缺少'memmove'；有些系统在'string.h'或者'strings.h'中以宏的方式 定义了BSD函数；有些系统除了含有'string.h'之外，只含有BSD函数；某些系统在'memory.h' 中定义内存函数，有些在'string.h'中定义；等等。对于一个字符串函数和一个内存函数的检查可能 就够了；如果库含有这些函数的标准版，那么它就可能含有其他大部分函数。如果你在'configure.in' 中安放了如下代码：

    AC_HEADER_STDC
    AC_CHECK_FUNCS(strchr memcpy)

    那么，在你的代码中，你就可以像下面那样放置声明：

    #if STDC_HEADERS
    # include <string.h>
    #else
    # ifndef HAVE_STRCHR
    #  define strchr index
    #  define strrchr rindex
    # endif
    char *strchr(), *strrchr();
    # ifndef HAVE_MEMCPY
    #  define memcpy(d, s, n) bcopy((s),(d),(n))
    #  define memmove(d, s, n) bcopy((s),(d),(n))
    # endif
    #endif

    如果你使用没有等价的BSD版的函数，诸如memchr、memset、strtok 或者strspn，那么仅仅使用宏就不够了；你必须为每个函数提供一个实现。以memchr为例， 一种仅仅在需要的时候(因为系统C库中的函数可能经过了手工优化)与你的实现协作的简单方式是把实现放入 'memchr.c'并且使用'AC_REPLACE_FUNCS(memchr)'。 

宏： AC_HEADER_SYS_WAIT
    如果'sys/wait.h'存在并且它和POSIX.1相兼容，就定义HAVE_SYS_WAIT_H。 如果'sys/wait.h'不存在，或者如果它使用老式BSD union wait，而不是 int来储存状态值，就可能出现不兼容。如果'sys/wait.h'不与POSIX.1兼容， 那就不是引入该头文件，而是按照它们的常见解释定义POSIX.1宏。下面是一个例子：

    #include <sys/types.h>
    #if HAVE_SYS_WAIT_H
    # include <sys/wait.h>
    #endif
    #ifndef WEXITSTATUS
    # define WEXITSTATUS(stat_val)((unsigned)(stat_val) >> 8)
    #endif
    #ifndef WIFEXITED
    # define WIFEXITED(stat_val)(((stat_val) & 255) == 0)
    #endif

宏： AC_MEMORY_H
    在'string.h'中，如果没有定义memcpy, memcmp等函数，并且'memory.h' 存在，就定义NEED_MEMORY_H。本宏已经过时；可以用AC_CHECK_HEADERS(memory.h)来代替。 参见为AC_HEADER_STDC提供的例子。 

宏： AC_UNISTD_H
    如果系统含有'unistd.h'，就定义HAVE_UNISTD_H。本宏已经过时；可以用 'AC_CHECK_HEADERS(unistd.h)'来代替。

    检查系统是否支持POSIX.1的方式是：

    #if HAVE_UNISTD_H
    # include <sys/types.h>
    # include <unistd.h>
    #endif

    #ifdef _POSIX_VERSION
    /* Code for POSIX.1 systems.  */
    #endif

    在POSIX.1系统中包含了'unistd.h'的时候定义_POSIX_VERSION。 如果系统中没有'unistd.h'，那么该系统就一定不是POSIX.1系统。但是，有些非POSIX.1(non-POSIX.1) 系统也含有'unistd.h'。 

宏： AC_USG
    如果系统并不含有'strings.h'、rindex、bzero等头文件或函数，就定义USG。 定义USG就隐含地表明了系统含有'string.h'、strrchr、memset等头文件或函数。

    符号USG已经过时了。作为本宏的替代，参见为AC_HEADER_STDC提供的例子。
}

CHECK(对普通头文件的检查){
这些宏被用于寻找没有包括在特定测试宏中的系统头文件。如果你除了检查头文件是否存在之外还要检查它的内容， 
你就不得不为此而编写你自己的测试(参见编写测试)。

AC_CHECK_HEADER(malloc.h, AC_DEFINE(HAVE_MALLOC_H,,[do we have malloc.h?]))                                 
AC_CHECK_LIB([m],[round],[ AC_CHECK_HEADERS([math.h],[mathlib=yes]) ])                              
AC_CHECK_HEADERS([arpa/inet.h fcntl.h inttypes.h limits.h netdb.h netinet/in.h stddef.h stdlib.h string.h sys/socket.h sys/statvfs.h sys/time.h syslog.h unistd.h],, [AC_MSG_ERROR([One of required headers was not found])])           
AC_CHECK_HEADERS([sys/mman.h], [AC_CHECK_FUNCS([mmap])])                                            
dnl AC_CHECK_HEADERS([sys/mman.h])
AC_CHECK_HEADERS([attr/xattr.h])
AC_CHECK_HEADERS([sys/xattr.h])
AC_CHECK_HEADERS([sys/file.h])
AC_CHECK_HEADERS([poll.h], [AC_CHECK_FUNCS([poll])])                                                
AC_CHECK_HEADERS([sys/rusage.h sys/resource.h])                                                     
AC_CHECK_HEADERS([mach/mach.h mach/mach_time.h], [AC_CHECK_FUNCS([mach_absolute_time mach_timebase_info])])
AC_CHECK_HEADERS([sys/sysctl.h])
AC_CHECK_HEADERS([linux/oom.h])
AC_CHECK_HEADERS([malloc.h])
AC_CHECK_HEADERS([sys/prctl.h], [AC_CHECK_FUNCS([prctl])])                                          
AC_CHECK_LIB([pcap],[pcap_lib_version],[ AC_CHECK_HEADERS([pcap.h],[pcap=yes]) ])                   
AC_CHECK_HEADERS([linux/nbd.h linux/fs.h],,[bdev=no])                                              
AC_CHECK_LIB(z, zlibVersion, [ AC_CHECK_HEADERS(zlib.h,[zlib=yes]) ])                              
AC_CHECK_HEADER([sys/epoll.h], AC_DEFINE([HAVE_EPOLL], , [for epoll support]))                       
AC_CHECK_HEADER([sys/event.h], AC_DEFINE([HAVE_KQUEUE], , [for kqueue support]))                     
AC_CHECK_HEADER(malloc.h, AC_DEFINE(HAVE_MALLOC_H,,[do we have malloc.h?]))                          
AC_CHECK_HEADERS([fcntl.h limits.h stdint.h stdlib.h string.h strings.h sys/time.h syslog.h unistd.h])
宏： AC_CHECK_HEADER(header-file, [action-if-found [, action-if-not-found]])
    如果系统头文件header-file存在，就执行shell命令action-if-found， 否则执行action-if-not-found。
如果你只需要在可以使用头文件的时候定义一个符号，就考虑使用 AC_CHECK_HEADERS。 

宏： AC_CHECK_HEADERS(header-file... [, action-if-found [, action-if-not-found]])
    对于每个在以空格分隔的参数列表header-file出现的头文件，如果存在，就定义 HAVE_header-file(全部大写)。
如果给出了action-if-found， 它就是在找到一个头文件的时候执行的附加shell代码。你可以把'break'作为它的值 
以便在第一次匹配的时候跳出循环。如果给出了action-if-not-found，它就在找不到 某个头文件的时候被执行。
}

CHECK(结构){
以下的宏检查某些结构或者某些结构成员。为了检查没有在此给出的结构，使用AC_EGREP_CPP (参见检验声明)或者使用AC_TRY_COMPILE (参见检验语法)。

宏： AC_HEADER_STAT
    如果在'sys/stat.h'中定义的S_ISDIR、S_ISREG等宏不能正确 地工作(返回错误的正数)，就定义STAT_MACROS_BROKEN。这种情况出现在Tektronix UTekV、 Amdahl UTS和Motorola System V/88上。 

宏： AC_HEADER_TIME
    如果程序可能要同时引入'time.h'和'sys/time.h'，就定义TIME_WITH_SYS_TIME。 在一些老式系统中，'sys/time.h'引入了'time.h'，但'time.h'没有用多个包含保护 起来，所以程序不应该显式地同时包含这两个文件。例如，本宏在既使用struct timeval或 struct timezone，又使用struct tm程序中有用。它最好和 HAVE_SYS_TIME_H一起使用，该宏可以通过调用AC_CHECK_HEADERS(sys/time.h)来检查。

    #if TIME_WITH_SYS_TIME
    # include <sys/time.h>
    # include <time.h>
    #else
    # if HAVE_SYS_TIME_H
    #  include <sys/time.h>
    # else
    #  include <time.h>
    # endif
    #endif

宏： AC_STRUCT_ST_BLKSIZE
    如果struct stat包含一个st_blksize成员，就定义HAVE_ST_BLKSIZE。 

宏： AC_STRUCT_ST_BLOCKS
    如果struct stat包含一个st_blocks成员，就定义HAVE_ST_BLOCKS。 否则，就把'fileblocks.o'添加到输出变量LIBOBJS中。 

宏： AC_STRUCT_ST_RDEV
    如果struct stat包含一个st_rdev成员，就定义HAVE_ST_RDEV。 

宏： AC_STRUCT_TM
    如果'time.h'没有定义struct tm，就定义TM_IN_SYS_TIME，它意味着 引入'sys/time.h'将得到一个定义得更好的struct tm。 

宏： AC_STRUCT_TIMEZONE
    确定如何获取当前的时区。如果struct tm有tm_zone成员，就定义HAVE_TM_ZONE。 否则，如果找到了外部数组tzname，就定义HAVE_TZNAME。
}

CHECK(类型){
以下的宏检查C typedefs。如果没有为你需要检查的typedef定义特定的宏，并且你不需要检查该类型 的任何特殊的特征，那么你可以使用一个普通的typedef检查宏。
对特定类型定义的检查

这些宏检查在'sys/types.h'和'stdlib.h'(如果它存在)中定义的特定的C typedef。

宏： AC_TYPE_GETGROUPS
    把GETGROUPS_T定义成getgroups的数组参数的基类型gid_t或者int。 

宏： AC_TYPE_MODE_T
    如果没有定义mode_t，就把mode_t定义成int。 

宏： AC_TYPE_OFF_T
    如果没有定义off_t，就把off_t定义成long。 

宏： AC_TYPE_PID_T
    如果没有定义pid_t，就把pid_t定义成int。 

宏： AC_TYPE_SIGNAL
    如果'signal.h'把signal声明成一个指向返回值为void的函数的指针， 就把RETSIGTYPE定义成void；否则，就把它定义成int。

    把信号处理器(signal handler)的返回值类型定义为RETSIGTYPE：

    RETSIGTYPE
    hup_handler()
    {
    ...
    }

宏： AC_TYPE_SIZE_T
    如果没有定义size_t，就把size_t定义成unsigned。 

宏： AC_TYPE_UID_T
    如果没有定义uid_t，就把uid_t定义成int并且把 gid_t定义成int。 
}
CHECK(对普通类型定义的检查){
本宏用于检查没有包括在特定类型测试宏中的typedef。
宏： AC_CHECK_TYPE(type, default)
    如果'sys/types.h'或者'stdlib.h'或者'stddef.h'存在，而类型 type没有在它们之中被定义，就把type定义成C(或者C++)预定义类型 default；例如，'short'或者'unsigned'。

}

CHECK(C编译器的特征){
下列宏检查C编译器或者机器结构的特征。为了检查没有在此列出的特征，使用AC_TRY_COMPILE (参见检验语法)或者AC_TRY_RUN (参见检查运行时的特征)
宏： AC_C_BIGENDIAN
    如果字(word)按照最高位在前的方式储存(比如Motorola和SPARC，但不包括Intel和VAX，CPUS)，就定义 WORDS_BIGENDIAN。 

宏： AC_C_CONST
    如果C编译器不能完全支持关键字const，就把const定义成空。有些编译器并不定义 __STDC__，但支持const；有些编译器定义__STDC__，但不能完全支持 const。程序可以假定所有C编译器都支持const，并直接使用它；对于那些不能完全 支持const的编译器，'Makefile'或者配置头文件将把const定义为空。 

宏： AC_C_INLINE
    如果C编译器支持关键字inline，就什么也不作。如果C编译器可以接受__inline__或者__inline，就把inline定义成可接受的关键字，否则就把inline定义为空。 

宏： AC_C_CHAR_UNSIGNED
    除非C编译器预定义了__CHAR_UNSIGNED__，如果C类型char是无符号的，就定义 __CHAR_UNSIGNED__。 

宏： AC_C_LONG_DOUBLE
    如果C编译器支持long double类型，就定义HAVE_LONG_DOUBLE。 有些C编译器并不定义__STDC__但支持long double类型；有些编译器定义 __STDC__但不支持long double。 

宏： AC_C_STRINGIZE
    如果C预处理器支持字符串化操作符(stringizing operator)，就定义HAVE_STRINGIZE。字符串化操作符是 '#'并且它在宏定义中以如下方式出现：

    #define x(y) #y

宏： AC_CHECK_SIZEOF(type [, cross-size])
    把SIZEOF_uctype定义为C(或C++)预定义类型type的，以字节为单位的大小， 例如'int' or 'char *'。如果编译器不能识别'type'，它就被定义为0。 uctype就是把type中所有小写字母转化为大写字母，空格转化成下划线，星号转化成'P' 而得到的名字。在交叉编译中，如果给出了cross-size，就使用它，否则configure就 生成一个错误并且退出。

    例如，调用

    AC_CHECK_SIZEOF(int *)

    在DEC Alpha AXP系统中，把SIZEOF_INT_P定义为8。 

宏： AC_INT_16_BITS
    如果C类型int是16为宽，就定义INT_16_BITS。本宏已经过时；更常见的方式是用 'AC_CHECK_SIZEOF(int)'来代替。 

宏： AC_LONG_64_BITS
    如果C类型long int是64位宽，就定义LONG_64_BITS。 本宏已经过时；更常见的方式是用'AC_CHECK_SIZEOF(long)'来代替。
}

CHECK(检验声明){

}
CHECK(检验语法){
    AC_DEFUN([AC_C_SOCKLEN_T],
    [AC_CACHE_CHECK(for socklen_t, ac_cv_c_socklen_t,
    [
      AC_TRY_COMPILE([
        #include <sys/types.h>
        #include <sys/socket.h>
      ],[
        socklen_t foo;
      ],[
        ac_cv_c_socklen_t=yes
      ],[
        ac_cv_c_socklen_t=no
      ])
    ])
    
    AC_TRY_COMPILE(includes, function-body, [action-if-found [, action-if-not-found]])
    创建一个C、C++或者Fortran 77测试程序(依赖于当前语言，参见对语言的选择)， 来察看由function-body组成的函数是否可以被编译。
}

AC_CACHE_CHECK([for libevent directory], ac_cv_libevent_dir, [
  saved_LIBS="$LIBS"
  saved_LDFLAGS="$LDFLAGS"
  saved_CPPFLAGS="$CPPFLAGS"
  le_found=no
  for ledir in $trylibeventdir "" $prefix /usr/local ; do
    LDFLAGS="$saved_LDFLAGS"
    LIBS="$saved_LIBS -levent"

    # Skip the directory if it isn't there.
    if test ! -z "$ledir" -a ! -d "$ledir" ; then
       continue;
    fi
    if test ! -z "$ledir" ; then
      if test -d "$ledir/lib" ; then
        LDFLAGS="-L$ledir/lib $LDFLAGS"
      else
        LDFLAGS="-L$ledir $LDFLAGS"
      fi
      if test -d "$ledir/include" ; then
        CPPFLAGS="-I$ledir/include $CPPFLAGS"
      else
        CPPFLAGS="-I$ledir $CPPFLAGS"
      fi
    fi
    # Can I compile and link it?
    AC_TRY_LINK([#include <sys/time.h>
#include <sys/types.h>
#include <event.h>], [ event_init(); ],
       [ libevent_linked=yes ], [ libevent_linked=no ])
    if test $libevent_linked = yes; then
       if test ! -z "$ledir" ; then
               CPPFLAGS="-I$ledir/include $CPPFLAGS"
      else
        CPPFLAGS="-I$ledir $CPPFLAGS"
      fi
    fi
    # Can I compile and link it?
    AC_TRY_LINK([#include <sys/time.h>
#include <sys/types.h>
#include <event.h>], [ event_init(); ],
       [ libevent_linked=yes ], [ libevent_linked=no ])
    if test $libevent_linked = yes; then
       if test ! -z "$ledir" ; then
         ac_cv_libevent_dir=$ledir
       else
         ac_cv_libevent_dir="(system)"
       fi
       le_found=yes
       break
    fi
  done
  LIBS="$saved_LIBS"
  LDFLAGS="$saved_LDFLAGS"
  CPPFLAGS="$saved_CPPFLAGS"
  if test $le_found = no ; then
    AC_MSG_ERROR([libevent is required.  You can get it from $LIBEVENT_URL

      If it is already installed, specify its path using --with-libevent=/dir/
])
  fi
])

CHECK(测试程序){
    测试程序不应该向标准输出输出任何信息。如果测试成功，它们应该返回0，否则返回非0，
以便于把成功的执行 从core dump或者其它失败中区分出来；段冲突(segmentation violations)
和其它失败产生一个非0的退出状态。 测试程序应该从main中exit，而不是return，这是因为在某些系统中 
(至少在老式的Sun上)，main的return的参数将被忽略。
    测试程序可以使用#if或者#ifdef来检查由已经执行了的测试定义的预处理器宏的值。 
例如，如果你调用AC_HEADER_STDC，那么在'configure.in'的随后部分，你可以使用一个有 条件地引入标准C头文件的测试程序：

#if STDC_HEADERS
# include <stdlib.h>
#endif
如果测试程序需要使用或者创建数据文件，其文件名应该以'conftest'开头，例如'conftestdata'。 
在运行测试程序之后或者脚本被中断时，configure将通过运行'rm -rf conftest*'来清除数据文件。
}

CHECK(测试函数){

在测试程序中的函数声明应该条件地含有为C++提供的原型。虽然实际上测试程序很少需要带参数的函数。

#ifdef __cplusplus
foo(int i)
#else
foo(i) int i;
#endif

测试程序声明的函数也应该有条件地含有为C++提供的，需要'extern "C"'的原型。要确保不要引入 任何包含冲突原型的头文件。

#ifdef __cplusplus
extern "C" void *malloc(size_t);
#else
char *malloc();
#endif

如果测试程序以非法的参数调用函数(仅仅看它是否存在)，就组织程序以确保它从不调用这个函数。你可以 在另一个从不调用的函数中调用它。你不能把它放在对exit的调用之后，这是因为GCC第2版知道 exit永远不会返回，并且把同一块中该调用之后的所有代码都优化掉。

如果你引入了任何头文件，确保使用正确数量的参数调用与它们相关的函数，即使它们不带参数也是如此， 以避免原型造成的编译错误。GCC第2版为有些它自动嵌入(inline)的函数设置了内置原型；例如， memcpy。为了在检查它们时避免错误，既可以给它们正确数量的参数，也可以以不同的返回 类型(例如char)重新声明它们。
}


CHECK(测试值和文件){
configure脚本需要测试许多文件和字符串的属性。下面是在进行这些测试的时候需要提防的一些移植性问题。
    程序est是进行许多文件和字符串测试的方式。人们使用替代(alternate)名'['来调用它， 但因为'['是一个m4的引用字符，
在autoconf代码中使用'['将带来麻烦。
    如果你需要通过test创建多个检查，就用shell操作符'&&'和'||' 把它们组合起来，而不是使用test操作符'-a'和'-o'。
在System V中， '-a'和'-o'相对于unary操作符的优先级是错误的；为此，POSIX并未给出它们，所以使用它们是不可移植的。
如果你在同一个语句中组合使用了'&&'和'||'，要记住它们的 优先级是相同的。
    为了使得configure脚本可以支持交叉编译，它们不能作任何测试主系统而不是测试目标系统的事。但你偶尔 可以发现有
必要检查某些特定(arbitrary)文件的存在。为此，使用'test -f'或者'test -r'。 不要使用'test -x'，因为4.3BSD不支持它。

另一个不可移植的shell编程结构是
var=${var:-value}
    它的目的是仅仅在没有设定var的值的情况下，把var设置成value， 但如果var已经含有值，即使是空字符串，
也不修改var。老式BSD shell，包括 Ultrix sh，不接受这个冒号，并且给出错误并停止。一个可以移植的等价方式是
: ${var=value}
}


CHECK(多种情况){
    有些操作是以几种可能的方式完成的，它依赖于UNIX的变种。检查它们通常需要一个"case 语句"。
autoconf不能直接提供该语句； 然而，通过用一个shell变量来记录是否采用了操作的某种已知的方式，可以容易地模拟该语句。

下面是用shell变量fstype记录是否还有需要检查的情况的例子。

AC_MSG_CHECKING(how to get filesystem type) 
fstype=no # The order of these tests is important.
  AC_TRY_CPP([#include <sys/statvfs.h> #include <sys/fstyp.h>], AC_DEFINE(FSTYPE_STATVFS) fstype=SVR4)
if test $fstype = no; then
  AC_TRY_CPP([#include <sys/statfs.h> #include <sys/fstyp.h>], AC_DEFINE(FSTYPE_USG_STATFS) fstype=SVR3)
fi
if test $fstype = no; then
  AC_TRY_CPP([#include <sys/statfs.h> #include <sys/vmount.h>], AC_DEFINE(FSTYPE_AIX_STATFS) fstype=AIX)
fi
#(more cases omitted here)
AC_MSG_RESULT($fstype)
}

autoconf_i_AM_PROG_AR(){ cat - <<'EOF'
AM_PROG_AR([ACT-IF-FAIL]) 	指定处理非常规归档的命令
EOF
}
autoconf_i_AC_DEFINE(){ cat - <<'EOF'
AC_DEFINE (VARIABLE, VALUE, [DESCRIPTION]) 	            定义C宏
AC_DEFINE (VARIABLE) 	                                定义C宏，值为1
AC_DEFINE_UNQUOTED (VARIABLE, VALUE, [DESCRIPTION]) 	定义C宏（键值进行shell的变量、反引号和反斜杠替换）
AC_DEFINE_UNQUOTED (VARIABLE) 	                        定义C宏（键进行shell的变量、反引号和反斜杠替换），值为1

    对一个特征的检测的常见回应是定义一个表示测试结果的C预处理器符号。这是通过调用AC_DEFINE 
或者AC_DEFINE_UNQUOTED来完成的。

    在缺省状态下，AC_OUTPUT把由这些宏定义的符号放置到输出变量DEFS中，该变量为每个定义了
的符号添加一个选项-Dsymbol=value。与autoconf第1版不同，在运行时不定义DEFS变量。为了检查
autoconf宏是否已经定义了某个C预处理器符号，就检查适当的缓存变量的值， 例子如下：

宏： AC_DEFINE(variable [, value [, description]])
    定义C预处理器变量variable。如果给出了value，就把variable设置成那个值(不加任何改变)， 
否则的话就设置为1。value不应该含有新行，同时如果你没有使用AC_CONFIG_HEADER，它就不应该含有任何
'#'字符，这是因为make将删除它们。为了使用shell变量(你需要使用该变量定义一个包含了 m4引用字符
'['或者']'的值)，就使用AC_DEFINE_UNQUOTED。只有在你使用AC_CONFIG_HEADER的时候，description才有用。
在这种情况下，description被作为注释放置到生成的 config.h.in 的宏定义之前；不必在 acconfig.h中提及该宏。
下面的例子把 C预处理器变量EQUATION的值定义成常量字符串 "$a > $b"：
    AC_DEFINE(EQUATION, "$a > $b")
    
    
宏： AC_DEFINE_UNQUOTED(variable [, value [, description]])
    类似于AC_DEFINE，但还要对variable和value进行三种shell替换(每种替换只进行一次)： 
变量扩展，命令替换，以及反斜线传义符。值中的单引号和双引号 没有特殊的意义。在variable或者
value是一个shell变量的时候用本宏代替AC_DEFINE。例如：
    AC_DEFINE_UNQUOTED(config_machfile, "${machfile}")
    AC_DEFINE_UNQUOTED(GETGROUPS_T, $ac_cv_type_getgroups)
    AC_DEFINE_UNQUOTED(${ac_tr_hdr})

# AC_DEFINE
AC_CHECK_HEADER([sys/epoll.h], AC_DEFINE([HAVE_EPOLL], , [for epoll support]))
AC_CHECK_HEADER([sys/event.h], AC_DEFINE([HAVE_KQUEUE], , [for kqueue support]))
AC_CHECK_HEADER(malloc.h, AC_DEFINE(HAVE_MALLOC_H,,[do we have malloc.h?])) 

[libevent]
AC_DEFINE(HAVE_STRUCT_MALLINFO,,[do we have stuct mallinfo?])
AC_DEFINE(socklen_t, int, [define to int if socklen_t not available])

[moosefs]
versmaj=$(echo $PACKAGE_VERSION | cut -d. -f1)
versmid=$(echo $PACKAGE_VERSION | cut -d. -f2)
versmin=$(echo $PACKAGE_VERSION | cut -d. -f3)
AC_DEFINE_UNQUOTED([VERSMAJ], [$versmaj], [Major MFS version])
AC_DEFINE_UNQUOTED([VERSMID], [$versmid], [Middle MFS version])
AC_DEFINE_UNQUOTED([VERSMIN], [($versmin)*2], [Minor MFS version])
AC_DEFINE_UNQUOTED([VERSHEX], [(($versmaj)*0x10000+($versmid)*0x100+($versmin)*2)], [Full MFS version as a hex number])

[moosefs]
AC_DEFINE_UNQUOTED([VERSSTR], ["${PACKAGE_VERSION}-${release}"], [MFS version - string])
AC_DEFINE_UNQUOTED([BSWAP16(x)], [__builtin_bswap16(x)], [bswap16])
AC_DEFINE_UNQUOTED([BSWAP16(x)], [((((x)<<8)&0xFF00) |(((x)>>8)&0xFF))], [bswap16])
AC_DEFINE_UNQUOTED([BSWAP32(x)], [__builtin_bswap32(x)], [bswap32])
AC_DEFINE_UNQUOTED([BSWAP32(x)], [((((x)<<24)&0xFF000000) |(((x)<<8)&0xFF0000) |(((x)>>8)&0xFF00)|(((x)>>24)&0xFF))], [bswap32])
AC_DEFINE_UNQUOTED([BSWAP64(x)], [__builtin_bswap64(x)], [bswap64])
AC_DEFINE_UNQUOTED([BSWAP64(x)], [((((x)<<56)&0xFF00000000000000) |(((x)<<40)&0xFF000000000000) |(((x)<<24)&0xFF0000000000) |(((x)<<8)&0xFF00000000) |(((x)>>8)&0xFF000000) |(((x)>>24)&0xFF0000) |(((x)>>40)&0xFF00) |(((x)>>56)&0xFF))], [bswap64])
AC_DEFINE_UNQUOTED([PREFIX], ["${prefix}"], [Installation prefix])
AC_DEFINE_UNQUOTED([ETC_PATH], ["$ETC_PATH"], [Configuration directory])
AC_DEFINE_UNQUOTED([DATA_PATH], ["$DATA_PATH"], [Data directory])
AC_DEFINE_UNQUOTED([RUN_PATH], ["$RUN_PATH"], [PID file directory])
AC_DEFINE_UNQUOTED([DEFAULT_USER], ["$DEFAULT_USER"], [Default working user])
AC_DEFINE_UNQUOTED([DEFAULT_GROUP], ["$DEFAULT_GROUP"], [Default working group])
AC_DEFINE_UNQUOTED([DEFAULT_PORTBASE], [$DEFAULT_PORTBASE], [Default port base])
AC_DEFINE_UNQUOTED([DEFAULT_MASTER_CONTROL_PORT], ["$DEFAULT_MASTER_CONTROL_PORT"], [Default master command port])
AC_DEFINE_UNQUOTED([DEFAULT_MASTER_CS_PORT], ["$DEFAULT_MASTER_CS_PORT"], [Default master chunkserver port])
AC_DEFINE_UNQUOTED([DEFAULT_MASTER_CLIENT_PORT], ["$DEFAULT_MASTER_CLIENT_PORT"], [Default master client port])
AC_DEFINE_UNQUOTED([DEFAULT_CS_DATA_PORT], ["$DEFAULT_CS_DATA_PORT"], [Default chunkserver data port])
AC_DEFINE_UNQUOTED([DEFAULT_CGISERV_HTTP_PORT], ["$DEFAULT_CGISERV_HTTP_PORT"], [Default cgiserver http port])
EOF
}

autoconf_i_AC_SUBST(){ cat - <<'EOF'
    记录测试结果的一种方式是设置输出变量，该变量是shell变量，它的值将被替换到configure输出的文件中。 
下面的两个宏创建新的输出变量。关于总是可用的输出变量的列表，参见预定义输出变量。

宏： AC_SUBST(variable)
    从一个shell变量创建一个输出变量。让AC_OUTPUT把变量variable替换到输出文件中(通常是一个或多个 'Makefile')。
这意味着AC_OUTPUT将把输入文件中的'@variable@'实例替换成调用AC_OUTPUT时shell变量variable的值。
variable的值不能包含新行。 

宏： AC_SUBST_FILE(variable)
    另一种从shell变量创建输出变量的方式。让AC_OUTPUT把由shell变量variable给出的文件名的文件的内容 
(不进行替换)插入到输出文件中。这意味着AC_OUTPUT将在输出文件中(比如'Makefile.in')把输入文件中 
的'@variable@'实例替换为调用AC_OUTPUT时shell变量variable的值指明的文件 的内容。如果没有文件可以插入，
就把变量设置成'/dev/null'。

    本宏用于把包含特殊依赖性或者为特殊主机或目标机准备的其它make指令的'Makefile'片断插入 'Makefile'。
例如，'configure.in'可以包含：
    AC_SUBST_FILE(host_frag)dnl
    host_frag=$srcdir/conf/sun4.mh
    那么'Makefile.in'就应该包含：
    @host_frag@

AC_SUBST([WITH_OPEN_POSIX_TESTSUITE],["yes"])
AC_SUBST([WITH_OPEN_POSIX_TESTSUITE],["no"])
AC_SUBST([WITH_REALTIME_TESTSUITE],["yes"])
AC_SUBST([WITH_REALTIME_TESTSUITE],["no"])


ARCH="SOLARIS"
ARCH="LINUX"
ARCH="OPENBSD"
ARCH="OPENBSD"
ARCH="AIX"

AC_SUBST(sslincldir)
AC_SUBST(ssllibdir)
AC_SUBST(ARCH)

AC_SUBST([DATA_PATH])
AC_SUBST([ETC_PATH])
AC_SUBST([BIN_PATH])
AC_SUBST([SBIN_PATH])
AC_SUBST([RUN_PATH])
AC_DEFINE_UNQUOTED([PREFIX], ["${prefix}"], [Installation prefix])
AC_DEFINE_UNQUOTED([ETC_PATH], ["$ETC_PATH"], [Configuration directory])
AC_DEFINE_UNQUOTED([DATA_PATH], ["$DATA_PATH"], [Data directory])
AC_DEFINE_UNQUOTED([RUN_PATH], ["$RUN_PATH"], [PID file directory])
EOF
}

OUTPUT(打印消息){
    configure脚本需要为运行它们的用户提供几种信息。下列的宏为每种信息以适当的方式打印消息。 
所有宏的参数都应该由shell双引号括起来，以便shell可以对它们进行变量替换和反引号替换。
你可以把消息用 m4引用字符括起来以打印包含括号的消息：
AC_MSG_RESULT([never mind, I found the BASIC compiler])
这些宏都是对shell命令echo的封装。configure应该很少需要直接运行echo来为 用户打印消息。
使用这些宏使得修改每种消息如何打印及何时打印变得容易了；这些修改只需要对宏的定义进行就行了， 
而所有的调用都将自动地改变。

AC_MSG_CHECKING(for kernel header at least $minimum_kernel)
AC_MSG_CHECKING([for symlinks in ${ac_prefix}/include])
宏： AC_MSG_CHECKING(feature-description)
    告知用户configure正在检查特定的特征。本宏打印一条以'checking '开头，以'...' 结尾，
而且不带新行的消息。它必须跟随一条对AC_MSG_RESULT的调用以打印检查的结果和新行。
feature-description应该是类似于 'whether the Fortran compiler accepts C++ comments'或者'for c89'的东西。
    如果运行configure给出了选项'--quiet'或者选项'--silent'，本宏什么也不打印。 

AC_MSG_RESULT(yes)
AC_MSG_RESULT(no)
AC_MSG_RESULT(yes)
AC_MSG_RESULT(no)
AC_MSG_RESULT(yes)
AC_MSG_RESULT(no)
AC_MSG_RESULT($ac_have_working_poll)                                                                
AC_MSG_RESULT($ac_have___sync_op_and_fetch)                                                         
AC_MSG_RESULT($ac_have___sync_fetch_and_op)                                                         
AC_MSG_RESULT($ac_have_working_attribute_fallthrough)
宏： AC_MSG_RESULT(result-description)
    告知用户测试的结果。result-description几乎总是检查的缓存变量的值，典型的值是'yes'、 'no'或者文件名。
本宏应该在AC_MSG_CHECKING之后调用，并且result-description 应该完成由AC_MSG_CHECKING所打印的消息。
    如果运行configure给出了选项'--quiet'或者选项'--silent'，本宏什么也不打印。 
AC_MSG_CHECKING(for va_copy)
AC_TRY_LINK([
    #include <stdarg.h>
], [
    va_list ap;
    va_list ap_copy;
    va_copy(ap, ap_copy);
], [
    AC_MSG_RESULT(yes)
    AC_DEFINE([HAVE_VA_COPY], [1], [Define to 1 if VA_COPY is defined.])
], [
    AC_MSG_RESULT(no)
])

if test "$use_pam" = "1"; then
        AC_CHECK_LIB([pam], [pam_start], [], [AC_MSG_ERROR([PAM enabled but headers or library not found, install the PAM development support or run configure --without-pam])])
fi
宏： AC_MSG_ERROR(error-description)
    告知用户一条使configure不能完成的错误。本宏在标准错误输出中打印一条错误消息并且以非零状态退出 
configure。error-description应该是类似于'invalid value $HOME for \$HOME'的东西。 

architecture='uname'
if test "$architecture" = "SunOS"
then
   ARCH="SOLARIS"
   CFLAGS="$CFLAGS -D _REENTRANT -D_POSIX_PTHREAD_SEMANTICS -D__EXTENSIONS__ -m64"
   LDFLAGS="$LDFLAGS -m64"
   AC_CHECK_LIB([zfs], [libzfs_init])
   AC_CHECK_LIB([nvpair], [nvlist_free])
   AC_CHECK_LIB([kstat], [kstat_open])
   AC_DEFINE([HAVE_CPU_WAIT], [1], [Define to 1 if CPU wait information is available.])
   if test 'uname -m' = "i86pc"
   then
      if test "x$GCC" = "xyes"
      then
            CFLAGS="$CFLAGS -mtune=opteron"
            LDFLAGS="$LDFLAGS -mtune=opteron"
      else
            CFLAGS="$CFLAGS -xarch=sse2"
            LDFLAGS="$LDFLAGS -xarch=sse2"
      fi
   else
      if test "x$GCC" = "xyes"
      then
            CFLAGS="$CFLAGS -mtune=v9"
            LDFLAGS="$LDFLAGS -mtune=v9"
      else
            CFLAGS="$CFLAGS -xarch=sparc"
            LDFLAGS="$LDFLAGS -xarch=sparc"
      fi
   fi
elif test "$architecture" = "Linux"
then
   ARCH="LINUX"
   CFLAGS="$CFLAGS -D _REENTRANT"
   LDFLAGS="$LDFLAGS -rdynamic"
   if test 'uname -r | awk -F '.' '{print$1$2}'' -ge "26"
   then
    AC_DEFINE([HAVE_CPU_WAIT], [1], [Define to 1 if CPU wait information is available.])
       fi
elif test "$architecture" = "OpenBSD"
then
   ARCH="OPENBSD"
   CFLAGS="$CFLAGS -D _REENTRANT"
   AC_CHECK_LIB([kvm], [kvm_open])
   use_pam=0 # No PAM on OpenBSD(supports BSD Auth API instead of PAM)
elif test "$architecture" = "FreeBSD"
then
   ARCH="FREEBSD"
   CFLAGS="$CFLAGS -D _REENTRANT"
   AC_CHECK_LIB([devstat], [devstat_getnumdevs])
   AC_CHECK_LIB([kvm], [kvm_open])
elif test "$architecture" = "GNU/kFreeBSD"
then
   ARCH="FREEBSD"
   CFLAGS="$CFLAGS -D _REENTRANT"
   AC_CHECK_LIB([devstat], [devstat_getnumdevs])
   AC_CHECK_LIB([kvm], [kvm_open])
elif test "$architecture" = "NetBSD"
then
   ARCH="NETBSD"
   CFLAGS="$CFLAGS -D _REENTRANT -Wno-char-subscripts"
   AC_CHECK_LIB([kvm], [kvm_open])
elif test "$architecture" = "DragonFly"
then
   ARCH="DRAGONFLY"
   CFLAGS="$CFLAGS -D _REENTRANT"
   AC_CHECK_LIB([kvm], [kvm_open])
   AC_CHECK_LIB([devstat], [getnumdevs])
elif test "$architecture" = "Darwin"
then
   ARCH="DARWIN"
   CFLAGS="$CFLAGS -DREENTRANT -no-cpp-precomp -DNEED_SOCKLEN_T_DEFINED"
   LDFLAGS="$LDFLAGS -Wl,-search_paths_first"
   AC_CHECK_LIB([kvm], [kvm_open])
   LIBS="$LIBS -framework System -framework CoreFoundation -framework DiskArbitration -framework IOKit -multiply_defined suppress"
elif test "$architecture" = "AIX"
then
   ARCH="DRAGONFLY"
   CFLAGS="$CFLAGS -D _REENTRANT"
   AC_CHECK_LIB([kvm], [kvm_open])
   AC_CHECK_LIB([devstat], [getnumdevs])
elif test "$architecture" = "Darwin"
then
   ARCH="DARWIN"
   CFLAGS="$CFLAGS -DREENTRANT -no-cpp-precomp -DNEED_SOCKLEN_T_DEFINED"
   LDFLAGS="$LDFLAGS -Wl,-search_paths_first"
   AC_CHECK_LIB([kvm], [kvm_open])
   LIBS="$LIBS -framework System -framework CoreFoundation -framework DiskArbitration -framework IOKit -multiply_defined suppress"
elif test "$architecture" = "AIX"
then
   ARCH="AIX"
   CFLAGS='echo $CFLAGS|sed 's/-g//g''
   CFLAGS="$CFLAGS -D_THREAD_SAFE -D_REENTRANT"
   LIBS="$LIBS -lodm -lperfstat -lm"
   AC_DEFINE([HAVE_CPU_WAIT], [1], [Define to 1 if CPU wait information is available.])
else
   AC_MSG_WARN([Architecture not supported: ${architecture}])
   CFLAGS="$CFLAGS -D _REENTRANT"
   ARCH="UNKNOWN"
fi

宏： AC_MSG_WARN(problem-description)
    告知configure的使用者可能出现的问题。本宏在标准错误输出中打印消息；configure继续向后运行， 
所以调用AC_MSG_WARN的宏应该为它们所警告的情况提供一个缺省的(备份)行为。 problem-description
应该是类似于'ln -s seems to make hard links'的东西。 
}

autom4te(名词){
autom4te对文件执行 GNU M4。
}
autoreconf(名词){
autoreconf，如果有多个autoconf产生的配置文件，autoreconf可以保存一些工作，它通过重复运行autoconf(以及在合适的地方运行autoheader)
以重新产生autoconf配置脚本和配置头模板，这些文件保存在以当前目录为根的目录树中。
}
autoscan(创建configure脚本){
autoscan程序可以用来为软件包创建configure.in文件。autoscan在以命令行参数中指定的目录为根(如果未给定参数，
则以当前目录为根)的目录树中检查源文件。它为通常的轻便问题搜索源文件，并且为那个包创建一个configure.scan文件，
这个文件就是configure.in的前身。

    autoscan偶尔会按照相对于其他宏的错误的顺序输出宏，为此autoconf将给出警告；你需要 手工地移动这些宏。
还有，如果你希望包使用一个配置头文件，你必须添加一个对AC_CONFIG_HEADER的调用。
    可能你还必须在你的程序中修改或者添加一些#if 指令以使得程序可以与autoconf合作。
    
以 # 开头的行是注释。
}

MACRO(宏定义){
    当你编写了一个可以用于多个软件包的特征测试时，最好用一个新宏把它封装起来。
下面是一些关于编写 autoconf宏的要求(instructions)和指导(guidelines)。

AC_DEFUN([AC_C_SOCKLEN_T],
[AC_CACHE_CHECK(for socklen_t, ac_cv_c_socklen_t,
[
  AC_TRY_COMPILE([
    #include <sys/types.h>
    #include <sys/socket.h>
  ],[
    socklen_t foo;
  ],[
    ac_cv_c_socklen_t=yes
  ],[
    ac_cv_c_socklen_t=no
  ])
])


AC_C_SOCKLEN_T
#### 宏定义
    autoconf宏是用宏AC_DEFUN定义的，该宏与m4的内置define宏相似。 除了定义一个宏，
AC_DEFUN把某些用于限制宏调用顺序的代码添加到其中。 (参见首要的宏)。
一个autoconf宏像下面那样定义：
AC_DEFUN(macro-name, [macro-body])
    这里的方括号并不表示可选的文本：它们应当原样出现在宏定义中，以避免宏扩展问题 
(参见引用)。你可以使用'$1'、'$2'等等来访问 传递给宏的任何参数。

    为使用m4注释，使用m4内置的dnl； 它使m4放弃本行中其后的所有文本。因为在调用AC_INIT之前，
所有的输出都被取消， 所以在'acsite.m4'和'aclocal.m4'中的宏定义之间不需要它。
关于编写m4宏的更完整的信息，参见GNU m4中的'如何定义新宏'。

#### 宏名
    所有autoconf宏都以'AC_'起头以防止偶然地与其它文本发生冲突。所有它们用于内部目的的shell变量 
几乎全部是由小写字母组成的，并且以'ac_'开头的名字。为了确保你的宏不会与现在的或者将来的autoconf宏冲突， 
你应该给你自己的宏名和任何它们因为某些原因而需要使用的shell变量添加前缀。它可能是你名字的开头字符，
或者 你的组织或软件包名称的缩写。

    大部分autoconf宏的名字服从一个表明特征检查的种类命名惯例。宏名由几个单词组成，
由下划线分隔，可以是最常见的， 也可以是最特殊的。它们的缓存变量名服从相同的惯例。
(关于它们的详细信息， 参见缓存变量名)。

'AC_'之后的第一个单词通常给出被测试特征的类别。下面是autoconf为特殊测试宏使用的类别， 
它们是你很可能要编写的宏。它们的全小写形式还用于缓存变量。在可能的地方使用它们；
如果不能，就发明一个你自己的类别。
C
    C语言内置特征。 
DECL
    在头文件中对C变量的声明。 
FUNC
    库中的函数。 
GROUP
    文件的UNIX组拥有者(group owner)。 
HEADER
    头文件。 
LIB
    C库。 
PATH
    包括程序在内的，到文件的全路径名。 
PROG
    程序的基本名(base name)。 
STRUCT
    头文件中对C结构的定义。 
SYS
    操作系统特征。 
TYPE
    C内置或者声明类型。 
VAR
    库中的C变量。 

    在类别之后就是特定的被测试特征的名称。宏名中所有的其它单词指明了特征的特殊方面。 
例如，AC_FUNC_UTIME_NULL检查用NULL指针调用utime函数时该函数的行为。

    一个作为另一个宏的内部子程序的宏的名字应该以使用它的宏的名字开头，而后是说明内部
宏作了什么的一个或多个单词。 例如，AC_PATH_X有内部宏AC_PATH_X_XMKMF和AC_PATH_X_DIRECT。

#### 引用
    由其他的宏调用的宏将被m4进行几次求值；每次求值都可能需要一层引号以防止对宏或者m4 
内置宏的不必要扩展，例如说'define'和'$1'。引号还需要出现在含有逗号的宏参数中， 
这是因为逗号把参数与参数分隔开来。还有，把所有含有新行和调用其它宏的宏参数引起来是一个好主意。

autoconf把m4的引用字符从缺省的'''和'''改为'['和']'， 这是因为许多宏使用'''和'''，这不方便。
然而，在少数情况下，宏需要使用方括号(通常在C程序文本 或者常规表达式中)。在这些情况下，
它们使用m4内置命令changequote暂时地把引用字符改为 '<<'和'>>'。 (有时，如果它们不需要
引用任何东西，它们就通过把引用字符设置成空字符串以完全关闭引用。)下面是一个例子：

AC_TRY_LINK(
# changequote(<<, >>)dnl
<<#include <time.h>
#ifndef tzname /* For SGI.  */
extern char *tzname[]; /* RS6000 and others reject char **tzname.  */
#endif>>,
changequote([, ])dnl
[atoi(*tzname);], ac_cv_var_tzname=yes, ac_cv_var_tzname=no)

宏： AC_REQUIRE(macro-name)
    如果还没有调用m4宏macro-name，就调用它(不带任何参数)。确保macro-name 用方括号引起来了。
macro-name必须已经用AC_DEFUN定义了，或者包含一个对AC_PROVIDE 的调用以指明它已经被调用了。 
一个替代AC_DEFUN的方法是使用define并且调用AC_PROVIDE。 因为这个技术并不防止出现嵌套的消息，它已经是过时的了。

宏： AC_PROVIDE(this-macro-name)
    记录this-macro-name已经被调用了的事实。this-macro-name应该是调用AC_PROVIDE的宏的名字。 
一个获取它的简单方式是从m4内置变量$0中获得，就像：
    AC_PROVIDE([$0])
    
#### 建议的顺序

有些宏在都被调用的时候，一个宏就需要在另一个宏之前运行，但是它们并不要求调用另一个宏。
例如，应该在任何运行C编译器的宏 之前调用修改了C编译器行为的宏。在文档中给出了许多这样的依赖性。

    当'configure.in'文件中的宏违背了这类依赖性，autoconf就提供宏AC_BEFORE以警告用户。
警告出现在从'configure.in'创建configure的时候，而不是在运行configure的时候。 
例如，AC_PROG_CPP检查C编译器是否可以在给出'-E'的情况下运行C预处理器。因而应该在任何 
 改变将要使用的C编译器的宏之后调用它 。所以AC_PROG_CC包含：
AC_BEFORE([$0], [AC_PROG_CPP])dnl
}

SYSTEM(){
    用户可以通过给configure传递命令行参数而指定系统类型。在交叉编译时必须这样作。 
在大多数交叉编译的复杂情况下，要涉及到三种系统类型。用于指定它们的选项是：

--build=build-type
    对包进行配置和编译的系统类型(很少用到)； 
--host=host-type
    包将运行的系统类型； 
--target=target-type
    包中任何编译器工具将生成的代码的系统类型。
    
CC=m68k-coff-gcc configure --target=m68k-coff

宏： AC_CANONICAL_SYSTEM
    检测系统类型并把输出变量设置成规范的系统类型。关于该宏设置变量的细节，参见系统类型变量。 
    
宏： AC_CANONICAL_HOST
    只执行AC_CANONICAL_SYSTEM中关于主机类型功能的子集。 对于不是编译工具链(compiler toolchain)一部分的程序，这就是所需要的全部功能。 

宏： AC_VALIDATE_CACHED_SYSTEM_TUPLE(cmd)
    如果缓存文件与当前主机、目标和创建系统类型不一致，就执行cmd或者打印一个缺省的错误消息。 

#### 系统类型变量
    在调用了AC_CANONICAL_SYSTEM之后，下列输出变量包含了系统类型信息。
在调用了AC_CANONICAL_HOST 之后，只设置了下列host变量。

build, host, target
    规范系统名称； 
build_alias, host_alias, target_alias
    如果使用了config.guess，就是用户指定的名称或者规范名称； 
build_cpu, build_vendor, build_os
host_cpu, host_vendor, host_os
target_cpu, target_vendor, target_os
    为方便而提供的规范名称的独立部分。

case "$target" in
i386-*-mach* | i386-*-gnu*) obj_format=aout emulation=mach bfd_gas=yes ;;
i960-*-bout) obj_format=bout ;;
esac

宏： AC_LINK_FILES(source..., dest...)
    使得AC_OUTPUT把每个存在文件的source连接到对应连接名dest。 如果可能，创建一个符号连接，
否则就创建硬连接。dest和source应该是相对于顶层源代码目录或者 创建目录的相对路径。可以多次调用本宏。
    
    例如，下列调用：
    AC_LINK_FILES(config/${machine}.h config/${obj_format}.h, host.h object.h)
    在当前目录中创建'host.h'，它是一个到'srcdir/config/${machine}.h'的连接， 并且创建'object.h'，
它是一个到'srcdir/config/${obj_format}.h'的连接。 
你还可以使用主机系统类型以寻找交叉编译工具。关于完成该任务的宏AC_CHECK_TOOL的信息， 参见对普通程序和文件的检查。

}


autoupdate(名词)
{
autoupdate程序将一个调用autoconf 宏的旧名称的configure.in文件中的宏更新为新的名称。
}
automake(名词)
{
acinstall是用来安装aclocal-style M4文件的脚本.
aclocal 根据configure.in文件的内容，自动生成aclocal.m4文件。
automake根据Makefile.am文件的内容，自动生成Makefile.in文件。要为一个包建立所有的Makefile.in文件，
        通过在目录的顶层以没有参数的形式运行automake程序。automake会自动找到每一个合适的Makefile.am
       (通过扫描configure.in)并且产生相应的Makefile.in。
        
compile 是编译器的包装脚本。
config.guess是用来为特定的编译、主机或目标架构来尝试猜测标准的系统名称的脚本。
config.sub 是配置验证子脚本。
depcomp在编译程序同时产生其依赖信息的脚本。
elisp-comp 能按字节编译 Emacs Lisp 代码。
install-sh 是能安装程序, 脚本或者数据文件的脚本。
mdate-sh 打印程序和目录更改时间的脚本.
missing 是一个用来填充在安装过程检查出的缺失的GNU程序空位的脚本.
mkinstalldirs产生目录树结构的脚本.
py-compile 编译 Python 程序。
symlink-tree 为整个目录创建符号链接的脚本。
ylwrap 是lex或yacc的包装脚本。

}

libtool()
{
    https://www.ibm.com/developerworks/cn/aix/library/1007_wuxh_libtool/
    创建 Libtool 对象文件 ;
    gcc -c compress.c
    libtool --mode=compile gcc -c foo.c
# mkdir .libs 
# gcc -c compress.c  -fPIC -DPIC -o .libs/compress.o 
# gcc -c compress.c -o compress.o >/dev/null 2>&1  
    创建 Libtool 库；
    libtool --mode=link gcc -o libcompress.la compress.lo -rpath /tmp -lz
# gcc -shared  .libs/compress.o  -lz  -Wl,-soname -Wl,libcompress.so.0 
#                                        -o .libs/libcompress.so.0.0.0 
# (cd .libs && rm -f libcompress.so.0 && 
#  ln -s libcompress.so.0.0.0 libcompress.so.0) 
# (cd .libs && rm -f libcompress.so && 
#  ln -s libcompress.so.0.0.0 libcompress.so) 
#  ar cru .libs/libcompress.a  compress.o 
#  ranlib .libs/libcompress.a 
#  creating libcompress.la 
# (cd .libs && rm -f libcompress.la && 
#  ln -s ../libcompress.la libcompress.la) 
    
    安装 Libtool 库 ;
    libtool --mode=install install -c libcompress.la /tmp
#   install .libs/libcompress.so.0.0.0 /tmp/libcompress.so.0.0.0 
#(cd /tmp && { ln -s -f libcompress.so.0.0.0 libcompress.so.0 || 
#{ rm -f libcompress.so.0 && 
#ln -s libcompress.so.0.0.0 libcompress.so.0; }; }) 
#(cd /tmp && { ln -s -f libcompress.so.0.0.0 libcompress.so || 
#{ rm -f libcompress.so && ln -s libcompress.so.0.0.0 libcompress.so; }; }) 
#install .libs/libcompress.lai /tmp/libcompress.la 
#install .libs/libcompress.a /tmp/libcompress.a 
#chmod 644 /tmp/libcompress.a 
# ranlib /tmp/libcompress.a 
# ...
    libtool -n --mode=finish /tmp

    使用 Libtool 库 ;
    libtool --mode=compile gcc -c main.c
    libtool --mode=link gcc -o main main.lo /tmp/libcompress.la                        # 动态链接
    libtool --mode=link gcc -o main main.lo /tmp/libcompress.la -static-libtool-libs   # 静态链接
    
    libtool --mode=link gcc -o main main.lo ./libcompress.la                           # 本地链接
    libtool --mode=execute gdb main                                                    # 本地调试
    卸载 Libtool 库 ;
    libtool --mode=uninstall rm /tmp/libcompress.la
}

libtool(创建可动态加载模块)
{
libtool --mode=link gcc -o compress.la compress.lo -rpath /tmp -lz -module -avoid-version
这里添加了额外的两个参数，-module告诉 Libtool 建立一个可动态加载的模块，-avoid-version告诉 Libtool 不要添加版本号。

在实际应用中，可动态加载模块通常会使用主程序提供的一些函数，为了满足动态模块的需求，在编译主程序时，需要添加 -export-dynamic选项。
}

libtool(禁止创建动态或者静态链接库)
{
大部分情况下，Libtool 都配置成同时创建动态链接库和静态链接库。可以通过下面的命令查看 Libtool 的当前配置 :
libtool –features
# host: x86_64-unknown-linux-gnu
# enable shared libraries
# enable static libraries

libtool自身是一个安装在 /usr/bin
禁止创建动态链接库
  52 # Whether or not to build shared libraries. 
  53 build_libtool_libs=yes # yes ->no
  
禁止创建静态链接库
  55 # Whether or not to build static libraries. 
  56 build_old_libs=yes     # yes ->no

}

libtool(命令模式)
{
     编译模式 ;
     libtool --mode=compile gcc -c src.c
    连接模式 ;
    libtool --mode=link gcc -o library.la src.lo -rpath /usr/local/lib
    安装模式 ;
    libtool --mode=install install -c library.la /usr/local/lib
    完成模式 ;
    libtool --mode=finish /usr/local/lib
    卸载模式 ;
    libtool --mode=uninstall rm /usr/local/lib/library.la
    执行模式 ;
    libtool --mode=execute gdb program
    清除模式 ;
    libtool --mode=clean rm library.la
}
libtool(库版本信息)
{
1. Libtool 库版本号
每个系统的库版本机制并不一样，Libtool 通过一种抽象的版本机制，最终在创建库时映射到具体的系统版本机制。

Libtool 的版本号分为 3 个部分 :

    current: 表示当前库输出的接口的数量 ;
    revision: 表示当前库输出接口的修改次数 ;
    age: 表示当前库支持先前的库接口的数量，例如 age为 2，表示它可以和支持当前库接口的执行文件，或者支持前面两个库接口的执行文件进行链接。所以 age应该总是小于或者等于 current。

Libtool 的库版本通过参数 -version-infocurrent:revision:age指定，例如下面的例子 :

 $ libtool --mode=link gcc -l libcompress.la -version-info 0:1:0

如果没有指定，默认版本是 0.0.0。

注意，应该尽可能少的更新库版本号，尤其是不能强行将库版本号和软件发行号保持一致，下面是更新库版本号的几个策略 :

    如果修改了库的源代码，那么应该增加 revision。这是当前接口的新的修订版本。
    如果改变了接口，应该增加 current，将 revision重置为 0。这是接口的新版本。
    如果新接口是前面接口的超集( 前面的接口还是可用 )，那么应该增加 age。这是一个向后兼容的版本。
    如果新接口删除了前面接口的元素，那么应该将 age重置为 0。这是一个新的，但是不向后兼容的版本。
    
2. 避免版本信息  
 libtool --mode=link gcc -o libcompress.la compress.lo -rpath /tmp -avoid-version 
}

libtool(结合 autoconf 和 automake 使用 Libtool)
{
1. 建立 configure.ac
使用下面的命令建立一个 configure.ac 模板 :
 $ autoscan
这将生成一个 configure.scan 文件，将它改名为 configure.ac。
在 AC_INIT() 之后加入下面几行 :
 # 初始话 automake 
 AM_INIT_automake([-Wall]) 
 # 这是在 autoconf 中使用 Libtool 唯一必须的宏
 AC_PROG_LIBTOOL
在 AC_OUTPUT 之前加入几行 :
 # 告诉 autoconf 通过 Makefile.in 自动生成 Makefile 
 AC_CONFIG_FILES([Makefile])
 
2. 建立 Makefile.am
建立一个 Makefile.am 文件，内容如下 :
 # _LTLIBRARIES 是 automake 支持 Libtool 的原语
 lib_LTLIBRARIES = libcompress.la 
 libcompress_la_SOURCES = compress.c 
 # 可以通过 _LDFLAGS 传递选项给 Libtool 
 libcompress_la_LDFLAGS = 
 # 通过 _LIBADD 可以指定库依赖关系
 libcompress_la_LIBADD  = -lz
注意上面用 lib_LTLIBRARIES，而不是 lib_LIBRARIES，这告诉 automake 使用 Libtool 创建 Libtool 库。

3. 建立 configure 和 Makefile
用下面的命令建立几个空文件 :
 $ touch NEWS README AUTHORS ChangeLog
然后运行 :
 $ autoreconf -i -s 
这将建立 configure 脚本，运行它将得到 Makefile: 
 $ ./configure
同时，configure 也建立了 libtool 脚本，后续 automake 将使用这个 libtool 脚本，而不是系统的那个。

4. 建立 Libtool 库
现在已经有了 Makefile，我们只需要简单的输入 :
 $ make
便可以创建 libcompress 了，这比手动调用 Libtool 要方便很多。
注意 automake 自动为 Libtool 选择了 -rpath 的路径，这是跟随 UNIX 系统习惯定义的，库文件安装到 $prefix/lib 
目录中，头文件安装到 $prefix/include 目录中。我们可以通过 configure 脚本的 --prefix选项改变上面的 $prefix，
也可以使用 configure 脚本的 --libdir明确的指定库文件的安装目录。

4.1 静态库和动态库
前面在 configure.ac 中的 AC_PROG_LIBTOOL 宏为 configure 脚本添加了两个选项 :
    --enable-static
    --enable-shared
这两个选项可以控制是否建立动态或者静态链接库，例如，如果只想建立动态链接库，可以这样运行 configure:
 $ ./configure --enable-shared – disable-static
在开发过程中，禁止创建动态链接库有几个优势 :
    编译速度提高了，这可以节省时间 ;
    调试更加容易，因为不用处理任何动态链接库引入的复杂性 ;
    你可以了解 Libtool 在只支持静态链接库的平台的行为 ;
为了避免在 configure 时忘记 --disable-shared选项，你可以在 configure.ac 中 AC_PROG_LIBTOOL 之前加入一行 :
 AC_DISABLE_SHARED
4.2 可动态加载模块
Libtool 的 链接模式支持 -module选项，它用来建立一个可动态加载模块，可以通过 automake 将这个选项传递给 Libtool。
只需要选项添加到 Makefile.am 中的 libcompress_la_LDFLAGS变量即可，所以，要建立可动态加载模块，我们需要修改 
Makefile.am:
 libcompress_la_LDFLAGS = -module -avoid-version

修改 Makefile.am 之后，需要运行 automake:

 $ automake

这将重新生成 Makefile.in 文件，以至于 Makefile。

4.3 安装 Libtool 库

安装 Libtool 库非常的简单，只需要运行 :

 $ make install

4.3 卸载 Libtool 库
和安装 Libtool 库同样简单 :
 $ make uninstall

5. 建立执行程序

通过 automake 使用 Libtool 库也非常容易，我们需要在 Makefile.am 中加入下面的几行 :

 bin_PROGRAMS = main 
 main_SOURCES = main.c 
 main_LDFLAGS = 
 main_LDADD   = libcompress.la

注意在建立 libcompress.la 是，我们通过 _LIBADD 指定依赖库，而建立执行文件 main 时，我们通过 _LDADD 指定依赖库，要记住这点区别。

也记得把前面为测试可动态加载模块时修改的 libcompress_la_LDFLAGS 变量改回来 :

 libcompress_la_LDFLAGS =
修改 Makefile.am 之后，需要运行 automake 更新 Makefile.in:
 $ automake
然后运行
 $ make

就可以建立可执行程序 main。
6. 调试执行程序

在结合 autoconf 和 automake 使用 Libtool 时，我们几乎永远都不会直接调用 Libtool，除了一个例外，那就是 Libtool
的执行模式。
例如我们在开发时要调试执行程序，可以使用下面的命令 :
 $ libtool --mode=execute gdb main
如果直接使用 :
 $ gdb main
gdb 会抱怨 main 的格式不可接受，因为使用 Libtool 建立的 main 只是一个封装脚本，它最终启动的是 .lib/lt-main。

}

foreign()
{
设置为foreign 时，automake会改用一般软件的标准来检查。如果不加这句的话，需要在autoconf之前，
先执行touch NEWS README AUTHORSChangeLog 来生成'NEWS'、'AUTHOR'、 'ChangeLog' 等文件用automake生成动态链接库。
}

dynamic()
{

# configure.in
添加AC_INIT_automake一行；
添加AC_PROG_LIBTOOL一行
添加AC_PROG_RAMLIB一行

# top dir
automake_OPTIONS=foreign
SUBDIRS=head src

# 动态库编译
需要在Makefile.am中指定：
automake_OPTIONS=foreign
lib_LTLIBRARIES=libhello.la
libhello_la_SOURCES=mytest.h mytest.c
在根目录下的configure.in中加AC_PROG_LIBTOOL

# 引用动态库
automake_OPTIONS=foreign
INCLUDES=-I../fun/
bin_PROGRAMS=test
test_SOURCES=mymain.c
test_LDADD=-L ../fun/ -lhello
}

static()
{
# top dir
automake_OPTIONS=foreign
SUBDIRS=head src

# 静态库编译
automake_OPTIONS=foreign
noinst_LIBRARIES=libmytest.a
libmytest_a_SOURCES=mytest.h mytest.c

# 引用静态库
bin_PROGRAMS=hello
hello_SOURCES=mymain.c
hello_LDADD=../head/libmytest.a
}

autoconf_i_AC_CONFIG_SRCDIR(){ cat - <<'EOF'
AC_CONFIG_SRCDIR (unique-file-in-source-dir)  # 查找configure输入
    unique-file-in-source-dir是指包的源码目录中的一些文件；configure检查这个文件的存在，
以确保被告知包含源码的目录事实上是存在的。有时人们会不小心用--srcdir指定错误的目录，
这是一种安全检查。

AC_CONFIG_SRCDIR用于检测源代码目录下的config.h文件。AC_CONFIG_HEADER表示你想要使用一个配置头文件。

AC_CONFIG_SRCDIR([src/monit.c])  # monit
AC_CONFIG_SUBDIRS([libmonit])    # monit

AC_CONFIG_SRCDIR(event.c)        # libevent
EOF
}
autoconf_i_AC_CONFIG_AUX_DIR(){ cat - <<'EOF'
AC_CONFIG_AUX_DIR (DIR) 	设置辅助构建工具目录
AC_CONFIG_AUX_DIR(config)   # monit
EOF
}

autoconf_i_AC_CONFIG_MACRO_DIR(){ cat - <<'EOF'
AC_CONFIG_MACRO_DIR (DIR)   局部autoconf宏目录
AC_CONFIG_MACRO_DIR([m4])   # monit
AC_CONFIG_MACRO_DIRS([m4])  # moosefs
EOF
}

autoconf_i_AC_CONFIG_COMMANDS(){ cat - <<'EOF'
AC_CONFIG_COMMANDS (TAG..., [CMDS], [INIT-CMDS])    在config.status最后运行标记的命令
AC_CONFIG_COMMANDS_POST (CMDS) 	                    在即将创建config.status前运行指定命令
AC_CONFIG_COMMANDS_PRE (CMDS) 	                    在刚创建config.status后运行指定命令

[monit]
AC_CONFIG_COMMANDS([libtool_patch],[test `uname` = "OpenBSD" && perl -p -i -e "s/deplibs_check_method=.*/deplibs_check_method=pass_all/g" libtool])
AC_CONFIG_COMMANDS([monitrc], [chmod 600 monitrc])

EOF
}

automake_i_AM_INIT_AUTOMAKE(){ cat - <<'EOF'
AM_INIT_AUTOMAKE(@PACKAGE_NAME@, @PACKAGE_VERSION@)  初始化automake
AM_INIT_AUTOMAKE([OPTIONS]) 	初始化automake

AM_INIT_AUTOMAKE                                         # libevent
AM_INIT_AUTOMAKE([-Wall -Werror foreign])                # 
AM_INIT_AUTOMAKE([-Wall -Werror foreign subdir-objects]) # moosefs
EOF
}

automake_i_AM_SILENT_RULES(){ cat - <<'EOF'
AM_SILENT_RULES 	精简输出

AM_SILENT_RULES([yes])  # moosefs

EOF
}

INSTALL(){
安装描述。你可以从其他基于automake的应用中拷贝一个标准的INSTALL文件，然后添加一些针对你的应用的信息。
}
README(){
用户应该知道的一些关于本应用的信息。最好在文件的开始处简单描述一些这个应用的目的
}
AUTHORS(){
作者列表。
}
NEWS(){
关于本应用的最新的新闻
}
ChangLog(){
本应用的修订历史
}


autotools_i_std_Makefile_target(){ cat - <<'EOF'
'make all' Build programs, libraries, documentation, etc.(Same as 'make'.)
'make install' Install what needs to be installed.
'make install-strip' Same as 'make install', then strip debugging symbols.
'make uninstall' The opposite of 'make install'.
'make clean' Erase what has been built(the opposite of 'make all').
'make distclean' Additionally erase anything './configure' created.
'make check' Run the test suite, if any.
'make installcheck' Check the installed programs or libraries, if supported.
'make dist' Create PACKAGE-VERSION.tar.gz.

make check
make install
make installcheck
EOF
}

autotools_i_std_Filesystem_variable(){ cat - <<'EOF'
Directory       variable
Default         value
prefix          /usr/local
exec-prefix     prefix
bindir          exec-prefix/bin
libdir          exec-prefix/lib
...             
includedir      prefix/include
datarootdir     prefix/share
datadir         datarootdir
mandir          datarootdir/man
infodir         datarootdir/info

./configure --prefix ~/usr
EOF
}

autotools_i_std_GCC_variable(){ cat - <<'EOF'
CC              C compiler command
CFLAGS          C compiler flags
CXX             C++ compiler command
CXXFLAGS        C++ compiler flags
LDFLAGS         linker flags
CPPFLAGS        C/C++ preprocessor flags

./configure --help
./configure --prefix ~/usr CC=gcc-3 CPPFLAGS=-I$HOME/usr/include LDFLAGS=-L$HOME/usr/lib
EOF
}

autotools_i_std_configure(){ cat - <<'EOF'
1. [Parallel Build Trees]
mkdir build && cd build
../configure
make
Sources files are in ../amhello-1.0/,
built files are all in ../amhello-1.0/build/

2. [Parallel Build Trees for Multiple Architectures]
2.1 Have the source on a (possibly read-only) shared directory
~ % cd /nfs/src
/nfs/src % tar zxf ~/amhello-1.0.tar.gz

2.2 Compilation on first host
~ % mkdir /tmp/amh && cd /tmp/amh
/tmp/amh % /nfs/src/amhello-1.0/configure
/tmp/amh % make && sudo make install

2.3 Compilation on second host
~ % mkdir /tmp/amh && cd /tmp/amh
/tmp/amh % /nfs/src/amhello-1.0/configure
/tmp/amh % make && sudo make install

‘make install’ = ‘make install-exec’ + ‘make install-data’

3. [Cross-compilation]
./configure
./configure --build i686-pc-linux-gnu --host i586-mingw32msvc

‘--build=BUILD’ The system on which the package is built.
‘--host=HOST’ The system where built programs & libraries will
run.
‘--target=TARGET’ Only when building compiler tools: the system for
which the tools will create output.
For simple cross-compilation, only ‘--host=HOST’ is needed.


4. [Renaming Programs at Install Time]
‘--program-prefix=PREFIX’
prepend PREFIX to installed program names,
‘--program-suffix=SUFFIX’
append SUFFIX to installed program names,
‘--program-transform-name=PROGRAM’
run ‘sed PROGRAM’ on installed program names.
./configure --program-prefix test-
EOF
}

autotools_i_std_DESTDIR(){ cat - <<'EOF'
[DESTDIR]
./configure --prefix /usr
make DESTDIR=$HOME/inst install
EOF
}


