
so(版本号){
动态库的名字一般为libxxxx.so.major.minor，xxxx是该lib的名称，major是主版本号， minor是副版本号.
}

LIBRARY_PATH是gcc编译时刻，是gcc的环境变量；LD_LIBRARY_PATH是程序运行时刻.
so(种类){
1. 操作系统级别的共享库和基础的系统工具库: 
   这些系统库放在/lib和/usr/lib目录下。
2. 应用程序级别的系统共享库 : 
   并非操作系统自带，但是可能被很多应用程序所共享的库，一般会被放在/usr/local/lib和/usr/local/lib64这两个目录下面。
3. 应用程序独享的动态共享库 : 
   有很多共享库只被特定的应用程序使用，那么就没有必要加入系统库路径，以免应用程序的共享库之间发生版本冲突。
   因此Linux还可以通过设置环境变量LD_LIBRARY_PATH来临时指定应用程序的共享库搜索路径。
   可以在应用程序的启动脚本里面预先设置LD_LIBRARY_PATH，指定本应用程序附加的共享库搜索路径，从而让应用程序找到它。
}



http://blog.chinaunix.net/uid-24907956-id-3979339.html

http://www.pchou.info/linux/2016/07/17/linux-libraries.html