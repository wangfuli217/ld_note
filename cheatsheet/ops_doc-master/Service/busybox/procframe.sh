进程管理类型：

init(Toybox busybox sysvinit monit)
{
配置进程类型；     SYSINIT，WAIT，ONCE，RESPAWN，ASKFIRST，CTRLALTDEL，SHUTDOWN，RESTART
配置进程管理列表； action_list_seed；next pid action terminal_name command
配置信号管理函数： SIGUSR1,SIGUSR2,SIGTERM,SIGTERM,SIGQUIT,SIGTSTP,SIGINT。
配置环境变量：     putenv("HOME=/");getenv("CONSOLE");
配置终端：         initialize_console(); reset_term(0);

核心函数：         
1. fork(); vfork()
2. execvp(command, final_command);
3. waitforpid(pid); wait(NULL);
4. pid_t pid = waitpid(-1, NULL, suspected_WNOHANG);


}  

网络连接管理类型
moosefs(redis libevent libuv zeromq dnsmasq)
{
poll, epoll, select.  多路阻塞 # read write 阻塞、非阻塞。信号中断EINTER， 
pcqueue               消息队列
pthread               线程
}


任务管理类型
fkapp(任务管理)
{

}

