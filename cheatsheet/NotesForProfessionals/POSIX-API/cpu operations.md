---
title: CPU操作
comments: true
---

# 获取当前线程CPU编号，getcpu

    #include <linux/getcpu.h>
    int getcpu(unsigned *cpu, unsigned *node, struct getcpu_cache *tcache);
    int sched_getcpu(void);获取线程所处CPU，等同于getcpu

获取当前进程（线程）正在运行的CPU编号

<!--more-->

# 设定线程CPU亲和性

CPU 亲和性（affinity） 就是进程要在某个给定的 CPU 上尽量长时间地运行而不被迁移到其他处理器的倾向性

    #include <sched.h>
    int sched_setaffinity(pid_t pid, size_t cpusetsize, const cpu_set_t *mask);
    int sched_getaffinity(pid_t pid, size_t cpusetsize, cpu_set_t *mask);
    //设置进程运行在哪个内核上
    #include <pthread.h>
    int pthread_setaffinity_np(pthread_t thread, size_t cpusetsize, const cpu_set_t *cpuset);
    int pthread_getaffinity_np(pthread_t thread, size_t cpusetsize, cpu_set_t *cpuset);

# 设定进程调度属性和参数

    int sched_setparam(pid_t pid, const struct sched_param *param);
    int sched_getparam(pid_t pid, struct sched_param *param);
    int sched_setattr(pid_t pid, struct sched_attr *attr, unsigned int flags);
    int sched_getattr(pid_t pid, struct sched_attr *attr, unsigned int size, unsigned int flags);
    int sched_get_priority_max(int policy);
    int sched_get_priority_min(int policy);

# 设定线程调度属性和参数

    int pthread_setschedparam(pthread_t thread, int policy, const struct sched_param *param);
    int pthread_getschedparam(pthread_t thread, int *policy, struct sched_param *param);
    int pthread_setschedprio(pthread_t thread, int prio);

# 设定RR间隔

    int sched_rr_get_interval(pid_t pid, struct timespec *tp);

# 获取调度器

    int sched_setscheduler(pid_t pid, int policy, const struct sched_param *param);
    int sched_getscheduler(pid_t pid);

# 放弃CPU

    int sched_yield(void);

线程放弃CPU，运行另一个线程

# 优先级

    #include <sys/time.h>
    #include <sys/resource.h>
    int getpriority(int which, id_t who);
    int setpriority(int which, id_t who, int prio);

# CPU个数

    #include <sys/sysinfo.h>
    int get_nprocs(void);
    int get_nprocs_conf(void);

获取CPU个数

    void CPU_ZERO(cpu_set_t *set);
    void CPU_SET(int cpu, cpu_set_t *set);
    void CPU_CLR(int cpu, cpu_set_t *set);
    int  CPU_ISSET(int cpu, cpu_set_t *set);
    int  CPU_COUNT(cpu_set_t *set);
    void CPU_AND(cpu_set_t *destset, cpu_set_t *srcset1, cpu_set_t *srcset2);
    void CPU_OR(cpu_set_t *destset, cpu_set_t *srcset1, cpu_set_t *srcset2);
    void CPU_XOR(cpu_set_t *destset, cpu_set_t *srcset1, cpu_set_t *srcset2);
    int  CPU_EQUAL(cpu_set_t *set1, cpu_set_t *set2);
    cpu_set_t *CPU_ALLOC(int num_cpus);
    void CPU_FREE(cpu_set_t *set);
    size_t CPU_ALLOC_SIZE(int num_cpus);
    void CPU_ZERO_S(size_t setsize, cpu_set_t *set);
    void CPU_SET_S(int cpu, size_t setsize, cpu_set_t *set);
    void CPU_CLR_S(int cpu, size_t setsize, cpu_set_t *set);
    int  CPU_ISSET_S(int cpu, size_t setsize, cpu_set_t *set);
    int  CPU_COUNT_S(size_t setsize, cpu_set_t *set);
    void CPU_AND_S(size_t setsize, cpu_set_t *destset, cpu_set_t *srcset1, cpu_set_t *srcset2);
    void CPU_OR_S(size_t setsize, cpu_set_t *destset, cpu_set_t *srcset1, cpu_set_t *srcset2);
    void CPU_XOR_S(size_t setsize, cpu_set_t *destset, cpu_set_t *srcset1, cpu_set_t *srcset2);
    int  CPU_EQUAL_S(size_t setsize, cpu_set_t *set1, cpu_set_t *set2);
