---
title: Linux登录流程
comments: true
---

# 登录过程和伪终端

                    fork      exec        打开终端，获取usrername，exec
      系统自--->init----->init----->getty------------------------------>login：禁止回显，获取密码，认证

2.认证成功

    2.1 更改chdir
    2.2 调用chown更改终端所有权
    2.3 改变终端权限
    2.4 调用setgid和initgroups设置进程组ID
    2.5 获取环境变量
    2.6 setuid，并调用登录shell
        execl("/bin/sh", "-sh", (char *)0);
    "-sh"中的-表示调用登录shell，shell会改变启动方式

setuid改变实际用户ID，有效用户ID，保存的用户ID

对于网络登录，系统自举后，运行init进程，接下来运行一个inetd进程，每来一个登录请求，就fork一个新进程，接下来exec对应的服务进程(如sshd, telnetd)，接下来运行登录shell，然后打开伪终端设备
