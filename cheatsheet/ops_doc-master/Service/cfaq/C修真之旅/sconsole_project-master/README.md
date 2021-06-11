# sconsole_project
   这是个纯C简单的开发框架. 跨平台,提供了日志模块,配置解析模块,多线程模块,json或csv解析模块, 适合开发一些C的简易项目!
分析如下, 我是个菜鸟,一切从简单明了来.

第一部分 window上使用简略分析
   
  sc_template => 这是个 VS2015 window上的项目框架源码结构. 感兴趣的可以做成项目模板使用起来.
只要用VS2015 打开就可以使用.
  其中特殊的是 使用了 pthread线程库 在 sc_template / sc_console_template / module / pthread  目录下
  都已经配置好了, pthread线程库能够让多线程写起来更通用更方便.
  sconsole_project / sc_template / sc_console_template / readme / help.txt 是一个 帮助我们怎么在VS上配置项目一些宏和选项.


第二部分 Linux 上详细分析

  cd linux_sc_template  # 进入linux_sc_template  Linux文件夹
  
  cd main # 进入 main文件夹 会看见各种测试代码
  
  下面 挨个简单说明 这些测试代码作用 
  1. test_cjson_write.c => 测试cjson.c 写字符串功能
  2. test_csjon.c => 测试 cjson.c 读取解析功能
  3. test_csv.c => 测试 sccsv.c 解析功能
  4. test_json_read.c => 测试 cjson.c 处理json文件内容
  5. test_log.c => 测试 sclog.c 的多用户日志功能
  6. test_scconf.c => 测试配置文件读取能力 scconf.c
  7. test_tstring.c => 测试c简单字符串能力 tstring.c
  
  编译部分主要看 
  cd ../
  vi Makefile # 这个文件时所有编译构建过程, 比较多,但也比较容易,很直白,读起来的

  后面看 其它具体实现模块的 代码结构
  cd module/schead
  cd include # 这里是所有提供的控制台头的接口
   1. cjson.h => 提供json 串的解析,构建,输出能力
   2. scatom.h => 这里提供跨平台的原子操作, 例如效率更高的原子锁
   3. scconf.h => 提供配置读取能力, 配置在 ../config/ 下
   4. sccsv.h => 提供读取 csv 文件的能力
   5. schead.h => 提供跨平台的操作宏,各种简便操作的辅助宏
   6. sclog.h => 提供日志操作结构,安全的多线程,多用户的
  
  最后使用到的基础模块代码

  cd ../../struct
  cd include # 这里用到的数据结构接口
  
   1. list.h => 通用链表接口
   2. tree.h => 通用的二叉树接口, 原先采用红黑树实现,后面维护太复杂采用一个阉割版的查找树
   3. tstring.h => c写的一个简易字符串接口

  到这里 linux上使用的文件都解释一下. 主要看 main中 测试代码. 加深理解

第三部分

  这是个简易的纯C基础框架库, 容易理解,代码量也就在2000 - 5000行. 主要应用于开发跨平台的C简易项目用的.
后期,以后有机会再加上通用的网路库和图形库.
