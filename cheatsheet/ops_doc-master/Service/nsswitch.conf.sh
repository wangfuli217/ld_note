nsswitch(系统数据库及名字服务开关配置文件){
    C 程序库里很多函数都需要配置以便能在本地环境正常工作, 习惯上是使用文件(例如"/etc/passwd") 来完成这一任务. 
但别的名字服务, 如网络信息服务NIS, 还有域名服务DNS等, 逐渐通用起来, 并且被加入了C 程序库里, 而它们使用的是固定
的搜索顺序.

    在有NYS 支持的Linux libc5以及GNU C Library 2.x (libc.so.6)里, 依靠一个更清晰完整的方案来解决该问题. 该方案
模仿了Sun Microsystems公司在Solaris 2 的C 程序库里的方法, 也沿袭了它们的命名, 称为 "名字服务开关(NSS)". 所用
 "数据库" 及其查找顺序在文件 /etc/nsswitch.conf 里指明.
NSS 中可用数据库如下:

[信息]
automount:                                                                   自动挂载（/etc/auto.master和/etc/auto.misc）
bootparams:                                                                  无盘引导选项和其他引导选项（参见bootparam的手册页）
aliases:    邮件别名, sendmail(8) 使用该文件.                                 
ethers:     以太网号.                                                        MAC地址 
group:      用户组, getgrent(3) 函数使用该文件.                              用户所在组（/etc/group） 
hosts:      主机名和主机号, gethostbyname(3) 以及类似的函数使用了该文件.     系统信息（/etc/hosts）
netgroup:   网络内主机及其用户的列表, 访问规则使用该文件.                    
network:    网络名及网络号, getnetent(3) 函数使用该文件.                     网络信息（/etc/networks） 
passwd:     用户口令, getpwent(3) 函数使用该文件.                            用户信息（/etc/passwd） 
protocols:  网络协议, getprotoent(3) 函数使用该文件.                         协议信息（/etc/protocols） 
publickey:  NIS+及NFS 所使用的secure_rpc的公开密匙.                          用于安全模式下运行的NFS 
rpc:        远程过程调用名及调用号, getrpcbyname(3) 及类似函数使用该文件.    RPC名称和编号（/etc/rpc） 
services:   网络服务, getservent(3) 函数使用该文件.                          服务信息（/etc/services） 
shadow:     shadow用户口令, getspnam(3) 函数使用该文件.                      映射口令信息（/etc/shadow）  

[方法]
files       搜索本地文件，如/etc/passwd和/etc/hosts
nis         搜索NIS数据库，nis还有一个别名，即yp
dns         查询DNS（只查询主机）
compat      passwd、group和shadow文件中的±语法（参见本节后面的相关内容）

1. nisplus (or nis+): 使用 NIS+ (NIS version 3) 服务
2, nis (or yp): 使用 NIS (NIS version 2) 服务 (也叫 YP, YellowPage)
3. dns: 使用 DNS (Domain Name Service) 服务
4. files: 使用一般的档案读取服务
5. db: 使用 database (.db) 档案读取服务
6. compat: 使用 NIS compat mode 服务
7. hesiod: 使用 Hesiod 服务做 user lookups

[动作项]
[[!]STATUS=action]

STATUS的取值如下。
l    NOTFOUND——方法已经执行，但是并没有找到待搜索的值。默认的动作是continue。
l    SUCCESS——方法已经执行，并且已经找到待搜索的值，没有返回错误。默认动作是return。
l    UNAVAIL——方法失败，原因是永久不可用。举例来说，所需的文件不可访问或者所需的服务器可能停机。默认的动作是continue。
l    TRYAGAIN——方法失败，原因是临时不可用。举例来说，某个文件被锁定，或者某台服务器超载。默认动作是continue。

action
 action的取值如下：
l    return——返回到调用例程，带有返回值，或者不带返回值。
l    continue——继续执行下一个方法。任何返回值都会被下一个方法找到的值覆盖。

    文件/etc/nsswitch.conf（name service switch configuration，名字服务切换配置）规定通过哪些途径以及按照什么顺序通过
这些途径来查找特定类型的信息。还可以指定若某个方法奏效抑或失效系统将采取什么动作。
格式文件nsswitch.conf中的每一行配置都指明了如何搜索信息，比如用户的口令。nsswitch.conf每行配置的格式如下：
info:         method [[action]] [method [[action]]...]
    其中，info指定该行所描述的信息的类型，method为用来查找该信息的方法，action是对前面的method的返回状态的响应。
action要放在方括号里面。
nsswitch.conf的工作原理

    当需要提供nsswitch.conf文件所描述的信息的时候，系统将检查含有适当info字段的配置行。它按照从左向右的顺序开始执行配置
行中指定的方法。 在默认情况下，如果找到期望的信息，系统将停止搜索。如果没有指定action，那么当某个方法未能返回结果时，
系统就会尝试下一个动作。有可能搜索结束都没有找到想要的信息。

[libso]
/lib/libnss_compat.so.1 为GNU C Library 2.x实现"compat"
/lib/libnss_db.so.1 为GNU C Library 2.x实现"db"
/lib/libnss_dns.so.1 为GNU C Library 2.x实现"dns"
/lib/libnss_files.so.1 为GNU C Library 2.x实现"files"
/lib/libnss_hesoid.so.1 为GNU C Library 2.x实现"hesoid"
/lib/libnss_nis.so.1 为GNU C Library 2.x实现"nis"
/lib/libnss_nisplus.so.1 为GNU C Library 2.x实现"nisplus"
/lib/libnss_ldap.so.2
/lib/libnss_winbind.so.2
/lib/libnss_wins.so.2

5. compat方法：passwd、group和shadow文件中的"±"
    可以在/etc/passwd、/etc/group和/etc/shadow文件中放入一些特殊的代码，（如果在nsswitch.conf文件中指定compat方法的话）
让系统将本地文件和NIS映射表中的项进行合并和修改。
    在这些文件中，如果在行首出现加号（+），就表示添加NIS信息；如果出现减号（-），就表示删除信息。举例来说，要想使用
passwd文件中的这些代码，可以在nsswitch.conf文件中指定passwd: compat。然后系统就会按照顺序搜寻passwd文件，当它遇到以
+或者-开头的行时，就会添加或者删除适当的NIS项。
    虽然可以在passwd文件的末尾放置加号，在nsswitch.conf文件中指定passwd: compat，以搜索本地的passwd文件，然后再搜寻NIS
映射表，但是更高效的一种方法是在nsswitch.conf文件中添加passwd: file nis而不修改passwd文件。

如果这还不够, NSS的"compat" 服务提供了完全的+/-语法. 我们可以对伪数据库 passwd_compat, group_compat 及 shadow_compat 
指明'nisplus'服务来覆盖缺省服务'nis', 但请注意只在GNU C Library里可以使用伪数据库.

}