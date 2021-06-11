fork,vfork,clone,都是系统调用，以前还以为是前面两个是clone的封装，实际上前三个都是系统调用，pthread_create是对clone的封装，kernel_thread用于创建内核线程

1. fork 在内核中调用
do_fork(SIGCHLD, regs.esp, &regs, 0, NULL, NULL)

2. vfork:
do_fork(CLONE_VFORK | CLONE_VM | SIGCHLD, regs.esp, &regs, 0, NULL, NULL)

3. clone:
do_fork(clone_flags, newsp, &regs, 0, parent_tidptr, child_tidptr)
其中
clone_flags = regs.ebx;
newsp = regs.ecx;
parent_tidptr = (int __user *)regs.edx;
child_tidptr = (int __user *)regs.edi;

4. pthread_create:
 pid = __clone(__pthread_manager_event,
(void **) __pthread_manager_thread_tos,
CLONE_VM | CLONE_FS | CLONE_FILES | CLONE_SIGHAND,
(void *)(long)manager_pipe[0]);   
kernel_thread:
do_fork(flags | CLONE_VM | CLONE_UNTRACED, 0, &regs, 0, NULL, NULL)

在执行这个函数之前，在栈中对regs作了初始化，把自己的参数塞进起，并设regs.eip=kernel_thread_helper,具体流程参见前一篇文章。
可见他们的不同主要在于flag的不同，为什么前两个都有SIGCHLD，把保护用户态寄存器的地址传递是为什么？进程的到底是怎么切换的？
先看do_fork,首先分配一个PID，调用copy_process()进行具体的拷贝，如果flag里有CLONE_VFORK,将父进程放入一个等待队列，所以子进程先运行。