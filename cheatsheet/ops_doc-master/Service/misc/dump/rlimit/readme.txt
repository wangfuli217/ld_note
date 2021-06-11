打开 core dump功能
    在终端中输入命令ulimit -c,如果输出结果为0，说明默认是关闭core dump的，即当程序异常终止时，也不会生出core dump文件
    我们可以使用命令ulmit -c unlimited 来开启core dump功能，并且不限制core dump的大小，如果限制文件的大小，将unlimited改成你想生成core  文件的大小，注意单位为KB
    用上面的命令只会对当前的终端有效，如果想永久生效，可以修改/etc/security/limits.conf文件，关于此文件的设置
# /etc/security/limits.conf
* soft core unlimited

修改core文件保存的路径
    默认生成的core文件保存在可执行文件所在的目录下，文件名就为core
    通过修改/proc/sys/kernel/core_uses_pid文件可以让生成的core文件名是否自动加上pid号
    还可以通过修改/proc/sys/kernel/core_pattern来控制生产core文件保存的位置以及文件名格式   
    例如可以用 echo "/tmp/corefile-%e-%p-%t" > /proc/sys/kernel/core_pattern设置生成的core文件保存在"/tmp/corefile"目录下，
    文件名格式为 "core-命令名-pid-时间戳"
    

GDB调试core文件，查看程序挂在位置。
当core dump 之后，使用命令 gdb program core 来查看 core 文件，其中 program 为可执行程序名，core 为生成的 core 文件名。

p $pc # 返回正在执行指令