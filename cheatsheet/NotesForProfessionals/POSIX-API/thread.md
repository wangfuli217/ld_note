---
title: 线程
comments: true
---

# 使用线程好处

* 为每种事件类型分配单独的处理线程，可以简化异步处理事件代码。每个线程进行事件处理时可以采用同步编程模式。
* 相对于多进程，可以更好的共享资源，比如共享内存和文件描述符
* 有些问题可以提高系统吞吐量
* 交互程序可以使用多线程改善响应时间

线程运行所需信息：
线程ID
一组寄存器值
栈
调度优先级和策略
信号屏蔽字
errno变量
线程私有数据

同一个进程所有线程共享代码，全局内存，堆内存和文件描述符

任意线程调用exit, _Exit, _exit，那么整个进程终止，任意线程收到信号，如果信号的动作是终止进程，将导致进程终止。

线程退出方式：

1. 从启动例程返回，返回值是线程的退出码
2. 线程被同一进程中其它线程取消
3. 线程调用pthread_exit

# 线程ID比较， pthread_equal

    #include <pthread.h>
    int pthread_equal(pthread_t tid1, pthread_t tid2);
    相同返回非0值，否则返回0

# 获取线程自身ID， pthread_self
pthread_t pthread_self(void);

<!--more-->

# 线程属性

    int pthread_attr_init(pthread_attr_t *attr);
    int pthread_attr_destroy(pthread_attr_t *attr);
    int pthread_getattr_np(pthread_t thread, pthread_attr_t *attr);
    获取本进程内其它线程的堆栈信息

    int pthread_getattr_default_np(pthread_attr_t *attr);
    int pthread_setattr_default_np(pthread_attr_t *attr);

    int pthread_attr_getdetachstate(const pthread_attr_t *restrict attr, int *detachstate);
    int pthread_attr_setdetachstate(pthread_attr_t *attr, int detachstate);
    detachstate:
    PTHREAD_CREATE_DETACHED
    PTHREAD_CREATE_JOINABLE

    int pthread_attr_setaffinity_np(pthread_attr_t *attr, size_t cpusetsize, const cpu_set_t *cpuset);
    int pthread_attr_getaffinity_np(const pthread_attr_t *attr, size_t cpusetsize, cpu_set_t *cpuset);

    int pthread_attr_setaffinity_np(pthread_attr_t *attr, size_t cpusetsize, const cpu_set_t *cpuset);
    int pthread_attr_getaffinity_np(const pthread_attr_t *attr, size_t cpusetsize, cpu_set_t *cpuset);

    int pthread_attr_setguardsize(pthread_attr_t *attr, size_t guardsize);
    int pthread_attr_getguardsize(const pthread_attr_t *attr, size_t *guardsize);

    int pthread_attr_setinheritsched(pthread_attr_t *attr, int inheritsched);
    int pthread_attr_getinheritsched(const pthread_attr_t *attr, int *inheritsched);

    int pthread_attr_setschedparam(pthread_attr_t *attr, const struct sched_param *param);
    int pthread_attr_getschedparam(const pthread_attr_t *attr, struct sched_param *param);

    int pthread_setschedparam(pthread_t thread, int policy, const struct sched_param *param);
    int pthread_getschedparam(pthread_t thread, int *policy, struct sched_param *param);
    int pthread_setschedprio(pthread_t thread, int prio);

    int pthread_attr_setschedpolicy(pthread_attr_t *attr, int policy);
    int pthread_attr_getschedpolicy(const pthread_attr_t *attr, int *policy);

    int pthread_attr_setschedpolicy(pthread_attr_t *attr, int policy);
    int pthread_attr_getschedpolicy(const pthread_attr_t *attr, int *policy);

    int pthread_setaffinity_np(pthread_t thread, size_t cpusetsize, const cpu_set_t *cpuset);
    int pthread_getaffinity_np(pthread_t thread, size_t cpusetsize, cpu_set_t *cpuset);

    int pthread_attr_setscope(pthread_attr_t *attr, int scope);
    int pthread_attr_getscope(const pthread_attr_t *attr, int *scope);

    int pthread_attr_setstack(pthread_attr_t *attr, void *stackaddr, size_t stacksize);
    int pthread_attr_getstack(const pthread_attr_t *attr, void **stackaddr, size_t *stacksize);

    int pthread_attr_setstackaddr(pthread_attr_t *attr, void *stackaddr);
    int pthread_attr_getstackaddr(const pthread_attr_t *attr, void **stackaddr);

    int pthread_attr_setstacksize(pthread_attr_t *attr, size_t stacksize);
    int pthread_attr_getstacksize(const pthread_attr_t *attr, size_t *stacksize);

    int pthread_getattr_np(pthread_t thread, pthread_attr_t *attr);

# 获取设置线程参数

## 获取线程运行CPU，pthread_getcpuclockid

    int pthread_getcpuclockid(pthread_t thread, clockid_t *clock_id);

## 获取调度参数

    int pthread_getschedparam(pthread_t thread, int *restrict policy, struct sched_param *restrict param);
    int pthread_setschedparam(pthread_t thread, int policy, const struct sched_param *param);
    int pthread_setschedprio(pthread_t thread, int prio);

## 设置线程名字

    int pthread_setname_np(pthread_t thread, const char *name);
    int pthread_getname_np(pthread_t thread, char *name, size_t len);

## 设置并发级别

    int pthread_getconcurrency(void);
    int pthread_setconcurrency(int new_level);

## 获取创建的线程参数

    int pthread_getattr_np(pthread_t thread, pthread_attr_t *attr);

## 设置创建线程的默认参数

    int pthread_getattr_default_np(pthread_attr_t *attr);
    int pthread_setattr_default_np(pthread_attr_t *attr);

## 设置线程CPU亲和性

    int pthread_setaffinity_np(pthread_t thread, size_t cpusetsize, const cpu_set_t *cpuset);
    int pthread_getaffinity_np(pthread_t thread, size_t cpusetsize, cpu_set_t *cpuset);

# pthread_once

    int pthread_once(pthread_once_t *once_control, void (*init_routine)(void));
    pthread_once_t once_control = PTHREAD_ONCE_INIT;

让函数只执行一次

    #include<iostream>
    #include<pthread.h>
    using namespace std;

    pthread_once_t once = PTHREAD_ONCE_INIT;

    void once_run(void)
    {
    	cout << "once_run in thread " << (unsigned int)pthread_self() << endl;
    }

    void * child1(void * arg)
    {
    	pthread_t tid = pthread_self();
    	cout << "thread " << (unsigned int)tid << " enter" << endl;
    	pthread_once(&once, once_run);
    	cout << "thread " << tid << " return" << endl;
    }


    void * child2(void * arg)
    {
    	pthread_t tid = pthread_self();
    	cout << "thread " << (unsigned int)tid << " enter" << endl;
    	pthread_once(&once, once_run);
    	cout << "thread " << tid << " return" << endl;
    }

    int main(void)
    {
    	pthread_t tid1, tid2;
    	cout << "hello" << endl;
    	pthread_create(&tid1, NULL, child1, NULL);
    	pthread_create(&tid2, NULL, child2, NULL);
    	sleep(10);
    	cout << "main thread exit" << endl;
    	return 0;

    }

# 创建线程pthread_create

int pthread_create(pthread_t *restrict tidp, const pthread_attr_t *restrict attr, void *(*start_rtn)(void *), void *restrict arg);


线程运行后，tidp返回运行的线程id，attr指定了线程属性，线程从start_rtn指定的地址运行

    #include "apue.h"
    #include <pthread.h>

    pthread_t ntid;

    void
    printids(const char *s)
    {
    	pid_t		pid;
    	pthread_t	tid;

    	pid = getpid();
    	tid = pthread_self();
    	printf("%s pid %lu tid %lu (0x%lx)\n", s, (unsigned long)pid,
    	  (unsigned long)tid, (unsigned long)tid);
    }

    void *
    thr_fn(void *arg)
    {
    	printids("new thread: ");
    	return((void *)0);
    }

    int
    main(void)
    {
    	int		err;

    	err = pthread_create(&ntid, NULL, thr_fn, NULL);
    	if (err != 0)
    		err_exit(err, "can't create thread");
    	printids("main thread:");
    	sleep(1);
    	exit(0);
    }
1. 主线程必须休眠，避免主线程先运行，新线程尚未被调度进程就终止了
2. 新线程不能用ntid这个全局变量来获取自己的线程ID，避免新线程先运行，ntid尚未初始化

## 线程退出 pthread_exit

    void pthread_exit(void *rval_ptr);

进程中其它线程可以调用pthread_join访问这个指针，必须保证线程退出后，rval_ptr所指向的内存依然是有效的，因此不能在rval_ptr不能指向栈


## 等待指定线程， pthread_join

    int pthread_join(pthread_t thread, void **rval_ptr);
    int pthread_tryjoin_np(pthread_t thread, void **retval);
    不会阻塞线程
    int pthread_timedjoin_np(pthread_t thread, void **retval, const struct timespec *abstime);

调用线程阻塞，直到指定线程调用pthread_exit，、从启动例程返回，此时rval_ptr包含返回码，或者被取消，rval_ptr设置为PTHREAD_CANCELED

pthread_join自动把线程置于分离状态，这样资源可以恢复。如果线程已经处于分离状态，调用失败，返回EINVAL。

    #include "apue.h"
    #include <pthread.h>

    void *
    thr_fn1(void *arg)
    {
    	printf("thread 1 returning\n");
    	return((void *)1);
    }

    void *
    thr_fn2(void *arg)
    {
    	printf("thread 2 exiting\n");
    	pthread_exit((void *)2);
    }

    int
    main(void)
    {
    	int			err;
    	pthread_t	tid1, tid2;
    	void		*tret;

    	err = pthread_create(&tid1, NULL, thr_fn1, NULL);
    	if (err != 0)
    		err_exit(err, "can't create thread 1");
    	err = pthread_create(&tid2, NULL, thr_fn2, NULL);
    	if (err != 0)
    		err_exit(err, "can't create thread 2");
    	err = pthread_join(tid1, &tret);
    	if (err != 0)
    		err_exit(err, "can't join with thread 1");
    	printf("thread 1 exit code %ld\n", (long)tret);
    	err = pthread_join(tid2, &tret);
    	if (err != 0)
    		err_exit(err, "can't join with thread 2");
    	printf("thread 2 exit code %ld\n", (long)tret);
    	exit(0);
    }

## 取消其它线程 pthread_cancel、pthread_kill_other_threads_np

    int pthread_cancel(pthread_t tid);
    void pthread_kill_other_threads_np(void);终止其它所有线程

    state：
    PTHREAD_CANCEL_ENABLE
    PTHREAD_CANCEL_DISABLE
    int pthread_setcanceltype(int type, int *oldtype);

    PTHREADCANCEL_DEFERRED 到取消点取消
    PTHREAD_CANCEL_ASYNCHRONOUS 可以在任意时间取消

    int pthread_setcancelstate(int state, int *oldstate);
    int pthread_setcanceltype(int type, int *oldtype);
    void pthread_testcancel(void);//手动设置取消点

调用此函数，会使得tid标识的线程行为表现为tid线程调用了参数为PTHREAD_CANCELED的pthread_exit函数。tid可以忽略或者控制如何被取消。

对于可取消属性为PTHREAD_CANCEL_ENABLE时，假如A线程请求B线程取消，则B线程运行到一个可取消点，就退出。为PTHREAD_CANCEL_DISABLE时，A的取消请求被阻塞，直到取消状态被设置为PTHREAD_CANCEL_ENABLE后，B将在下一个取消点退出。

 |     |            |             |
-|-----|------------|-------------|
accept |mq_timedsend |pthread_join |sendto
aio_suspend |msgrcv| pthread_testcancel |sigsuspend
clock_nanosleep |msgsnd |pwrite |sigtimedwait
close| msync| read| sigwait
connect| nanosleep |readv |sigwaitinfo
creat |open |recv| sleep
fcntl |openat| recvfrom |system
fdatasync |pause| recvmsg |tcdrain
fsync| poll| select |wait
lockf| pread| sem_timedwait| waitid
mq_receive| pselect| sem_wait| waitpid
mq_send |pthread_cond_timedwait| send |write
mq_timedreceive |pthread_cond_wait |sendmsg |writev

## 线程清理处理程序

    void pthread_cleanup_push(void (*rtn)(void *), void *arg);
    void pthread_cleanup_pop(int execute);
    void pthread_cleanup_push_defer_np(void (*routine)(void *), void *arg);
    void pthread_cleanup_pop_restore_np(int execute);

pthread_cleanup_push加入的线程清理函数只有在

* 调用pthread_exit
* 响应取消请求时
* 用非零 execute 参数调用pthread_cleanup_pop时。

## 例子

    #include "apue.h"
    #include <pthread.h>

    void
    cleanup(void *arg)
    {
    	printf("cleanup: %s\n", (char *)arg);
    }

    void *
    thr_fn1(void *arg)
    {
    	printf("thread 1 start\n");
    	pthread_cleanup_push(cleanup, "thread 1 first handler");
    	pthread_cleanup_push(cleanup, "thread 1 second handler");
    	printf("thread 1 push complete\n");
    	if (arg)
    		return((void *)1);//==============================
    	pthread_cleanup_pop(0);
    	pthread_cleanup_pop(0);
    	return((void *)1);
    }

    void *
    thr_fn2(void *arg)
    {
    	printf("thread 2 start\n");
    	pthread_cleanup_push(cleanup, "thread 2 first handler");
    	pthread_cleanup_push(cleanup, "thread 2 second handler");
    	printf("thread 2 push complete\n");
    	if (arg)
    		pthread_exit((void *)2);//==============================
    	pthread_cleanup_pop(0);
    	pthread_cleanup_pop(0);
    	pthread_exit((void *)2);
    }

    int
    main(void)
    {
    	int			err;
    	pthread_t	tid1, tid2;
    	void		*tret;

    	err = pthread_create(&tid1, NULL, thr_fn1, (void *)1);
    	if (err != 0)
    		err_exit(err, "can't create thread 1");
    	err = pthread_create(&tid2, NULL, thr_fn2, (void *)1);
    	if (err != 0)
    		err_exit(err, "can't create thread 2");
    	err = pthread_join(tid1, &tret);
    	if (err != 0)
    		err_exit(err, "can't join with thread 1");
    	printf("thread 1 exit code %ld\n", (long)tret);
    	err = pthread_join(tid2, &tret);
    	if (err != 0)
    		err_exit(err, "can't join with thread 2");
    	printf("thread 2 exit code %ld\n", (long)tret);
    	exit(0);
    }

## 分离线程 pthread_detach

    int pthread_detach(pthread_t tid);

默认情况下，线程的终止状态会保存直到对该线程调用pthread_join。如果线程被分离，则线程底层存储资源立即被回收，此时调用pthread_join会出错

# 线程间同步

## 互斥量

### 互斥量操作

    int pthread_mutex_init(pthread_mutex_t *restrict mutex, const pthread_mutexattr_t *restrict attr);
    pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
    int pthread_mutex_destroy(pthread_mutexattr_t *attr);

    int pthread_mutex_lock(pthread_mutex_t *mutex);
    int pthread_mutex_trylock(pthread_mutex_t *mutex);
    int pthread_mutex_unlock(pthread_mutex_t *mutex);
    int pthread_mutex_timedlock(pthread_mutex_t *restrict mutex, const struct timespec *restrict abstime);


### 设置互斥量优先级上限

    int pthread_mutex_getprioceiling(const pthread_mutex_t *restrict mutex, int *restrict prioceiling);
    int pthread_mutex_setprioceiling(pthread_mutex_t *restrict mutex, int prioceiling, int *restrict old_ceiling);

### 互斥量锁属性

    int pthread_mutexattr_destroy(pthread_mutexattr_t *attr);
    int pthread_mutexattr_init(pthread_mutexattr_t *attr);

    int pthread_mutexattr_getpshared(const pthread_mutexattr_t *restrict attr, int *restrict pshared);
    int pthread_mutexattr_setpshared(pthread_mutexattr_t *attr, int pshared);

    int pthread_mutexattr_getprotocol(const pthread_mutexattr_t *restrict attr, int *restrict protocol);
    int pthread_mutexattr_setprotocol(pthread_mutexattr_t *attr, int protocol);

    int pthread_mutexattr_getprioceiling(const pthread_mutexattr_t *restrict attr, int *restrict prioceiling);
    int pthread_mutexattr_setprioceiling(pthread_mutexattr_t *attr, int prioceiling);

pshared可以设置为

>PTHREAD_PROCESS_SHARED 允许互斥量在进程间共享
>
>PTHREAD_PROCESS_PRIVATE

    int pthread_mutexattr_getrobust(const pthread_mutexattr_t *attr, int *robustness);
    int pthread_mutexattr_setrobust(const pthread_mutexattr_t *attr, int robustness);

多进程间共享互斥量时，当持有互斥量的进程终止时，并且互斥量处于锁住状态，需要恢复为未锁定，否则其它进程会一直阻塞下去。
robustness：

>PTHREAD_MUTEX_STALLED 持有互斥量的进程终止时不需要采取特别动作
>
>PTHREAD_MUTEX_ROBUST  当持有锁的线程终止时并且没有释放锁，其它线程在pthread_mutex_lock时返回EOWNERDEAD而不是0。

    int pthread_mutex_consistent(pthread_mutex_t * mutex);

如果应用状态无法恢复，线程对互斥量解锁后，互斥量将处于永久不可用状态。此时调用pthread_mutex_consistent。
如果线程没有先调用pthread_mutex_consistent就对互斥量进行解锁，其它试图获取该互斥量的阻塞线程就会得到错误码ENOTRECOVERABLE。此时互斥量不可再用。


int pthread_mutexattr_gettype(const pthread_mutexattr_t *restrict attr, int *restrict type);
int pthread_mutexattr_settype(pthread_mutexattr_t *attr, int type);

互斥量锁定类型：

* PTHREAD_MUTEX_NORMAL 不做特殊错误检查和死锁检测，没有解锁时加锁会死锁，不占用时解锁或已解锁时解锁未定义
* PTHREAD_MUTEX_ERRORCHECK 提供错误检查，没有解锁时重新加锁返回错误，不占用或已解锁时解锁返回错误
* PTHREAD_MUTEX_RECURSIVE 此互斥量允许同一线程在互斥量解锁前对该互斥量多次加锁。需要同样的解锁次数才能解锁。不占用或已解锁时解锁返回错误
* PTHREAD_MUTEX_DEFAULT 没有解锁时重新加锁，不占用时解锁，已解锁时解锁都是未定义行为

### 互斥量例子

使用两个互斥量来避免死锁

    #include <stdlib.h>
    #include <pthread.h>

    #define NHASH 29
    #define HASH(id) (((unsigned long)id)%NHASH)

    struct foo *fh[NHASH];

    pthread_mutex_t hashlock = PTHREAD_MUTEX_INITIALIZER;

    struct foo {
    	int             f_count;
    	pthread_mutex_t f_lock;
    	int             f_id;
    	struct foo     *f_next; /* protected by hashlock */
    	/* ... more stuff here ... */
    };

    struct foo *
    foo_alloc(int id) /* allocate the object */
    {
    	struct foo	*fp;
    	int			idx;

    	if ((fp = malloc(sizeof(struct foo))) != NULL) {
    		fp->f_count = 1;
    		fp->f_id = id;
    		if (pthread_mutex_init(&fp->f_lock, NULL) != 0) {
    			free(fp);
    			return(NULL);
    		}
    		idx = HASH(id);
    		pthread_mutex_lock(&hashlock);
    		fp->f_next = fh[idx];
    		fh[idx] = fp;
    		pthread_mutex_lock(&fp->f_lock);
    		pthread_mutex_unlock(&hashlock);
    		/* ... continue initialization ... */
    		pthread_mutex_unlock(&fp->f_lock);
    	}
    	return(fp);
    }

    void
    foo_hold(struct foo *fp) /* add a reference to the object */
    {
    	pthread_mutex_lock(&fp->f_lock);
    	fp->f_count++;
    	pthread_mutex_unlock(&fp->f_lock);
    }

    struct foo *
    foo_find(int id) /* find an existing object */
    {
    	struct foo	*fp;

    	pthread_mutex_lock(&hashlock);
    	for (fp = fh[HASH(id)]; fp != NULL; fp = fp->f_next) {
    		if (fp->f_id == id) {
    			foo_hold(fp);
    			break;
    		}
    	}
    	pthread_mutex_unlock(&hashlock);
    	return(fp);
    }

    void
    foo_rele(struct foo *fp) /* release a reference to the object */
    {
    	struct foo	*tfp;
    	int			idx;

    	pthread_mutex_lock(&fp->f_lock);
    	if (fp->f_count == 1) { /* last reference */
    		pthread_mutex_unlock(&fp->f_lock);
    		pthread_mutex_lock(&hashlock);
    		pthread_mutex_lock(&fp->f_lock);
    		/* need to recheck the condition */
    		if (fp->f_count != 1) {
    			fp->f_count--;
    			pthread_mutex_unlock(&fp->f_lock);
    			pthread_mutex_unlock(&hashlock);
    			return;
    		}
    		/* remove from list */
    		idx = HASH(fp->f_id);
    		tfp = fh[idx];
    		if (tfp == fp) {
    			fh[idx] = fp->f_next;
    		} else {
    			while (tfp->f_next != fp)
    				tfp = tfp->f_next;
    			tfp->f_next = fp->f_next;
    		}
    		pthread_mutex_unlock(&hashlock);
    		pthread_mutex_unlock(&fp->f_lock);
    		pthread_mutex_destroy(&fp->f_lock);
    		free(fp);
    	} else {
    		fp->f_count--;
    		pthread_mutex_unlock(&fp->f_lock);
    	}
    }

    #include <stdlib.h>
    #include <pthread.h>

    #define NHASH 29
    #define HASH(id) (((unsigned long)id)%NHASH)

    struct foo *fh[NHASH];
    pthread_mutex_t hashlock = PTHREAD_MUTEX_INITIALIZER;

    struct foo {
    	int             f_count; /* protected by hashlock */
    	pthread_mutex_t f_lock;
    	int             f_id;
    	struct foo     *f_next; /* protected by hashlock */
    	/* ... more stuff here ... */
    };

    struct foo *
    foo_alloc(int id) /* allocate the object */
    {
    	struct foo	*fp;
    	int			idx;

    	if ((fp = malloc(sizeof(struct foo))) != NULL) {
    		fp->f_count = 1;
    		fp->f_id = id;
    		if (pthread_mutex_init(&fp->f_lock, NULL) != 0) {
    			free(fp);
    			return(NULL);
    		}
    		idx = HASH(id);
    		pthread_mutex_lock(&hashlock);
    		fp->f_next = fh[idx];
    		fh[idx] = fp;
    		pthread_mutex_lock(&fp->f_lock);
    		pthread_mutex_unlock(&hashlock);
    		/* ... continue initialization ... */
    		pthread_mutex_unlock(&fp->f_lock);
    	}
    	return(fp);
    }

    void
    foo_hold(struct foo *fp) /* add a reference to the object */
    {
    	pthread_mutex_lock(&hashlock);
    	fp->f_count++;
    	pthread_mutex_unlock(&hashlock);
    }

    struct foo *
    foo_find(int id) /* find an existing object */
    {
    	struct foo	*fp;

    	pthread_mutex_lock(&hashlock);
    	for (fp = fh[HASH(id)]; fp != NULL; fp = fp->f_next) {
    		if (fp->f_id == id) {
    			fp->f_count++;
    			break;
    		}
    	}
    	pthread_mutex_unlock(&hashlock);
    	return(fp);
    }

    void
    foo_rele(struct foo *fp) /* release a reference to the object */
    {
    	struct foo	*tfp;
    	int			idx;

    	pthread_mutex_lock(&hashlock);
    	if (--fp->f_count == 0) { /* last reference, remove from list */
    		idx = HASH(fp->f_id);
    		tfp = fh[idx];
    		if (tfp == fp) {
    			fh[idx] = fp->f_next;
    		} else {
    			while (tfp->f_next != fp)
    				tfp = tfp->f_next;
    			tfp->f_next = fp->f_next;
    		}
    		pthread_mutex_unlock(&hashlock);
    		pthread_mutex_destroy(&fp->f_lock);
    		free(fp);
    	} else {
    		pthread_mutex_unlock(&hashlock);
    	}
    }

## 读写锁

### 读写锁属性

    #include <pthread.h>
    int pthread_rwlockattr_init(pthread_rwlockattr_t *attr);
    int pthread_rwlockattr_destroy(pthread_rwlockattr_t *attr);

    int pthread_rwlockattr_setkind_np(pthread_rwlockattr_t *attr, int pref);
    int pthread_rwlockattr_getkind_np(const pthread_rwlockattr_t *attr, int *pref);

    int pthread_rwlockattr_getpshared(const pthread_rwlockattr_t *restrict attr, int *restrict pshared);
    int pthread_rwlockattr_setpshared(pthread_rwlockattr_t *attr, int pshared);

### 读写锁操作

    int pthread_rwlock_init(pthread_rwlock_t *restrict rwlock, const pthread_rwlockattr_t *restrict attr);
    pthread_rwlock_t rwlock = PTHREAD_RWLOCK_INITIALIZER;
    int pthread_rwlock_destroy(pthread_rwlock_t *rwlock);
    int pthread_rwlock_rdlock(pthread_rwlock_t *rwlock);
    int pthread_rwlock_wrlock(pthread_rwlock_t *rwlock);
    int pthread_rwlock_unlock(pthread_rwlock_t *rwlock);
    int pthread_rwlock_tryrdlock(pthread_rwlock_t *rwlock);
    int pthread_rwlock_trywrlock(pthread_rwlock_t *rwlock);
    int pthread_rwlock_timedrdlock(pthread_rwlock_t *restrict rwlock, const struct timespec *restrict tsptr);
    int pthread_rwlock_timedwrlock(pthread_rwlock_t *restrict rwlock, const struct timespec *restrict tsptr);

正常返回0， 否则返回错误编号

### 读写锁例子

    #include <stdlib.h>
    #include <pthread.h>

    struct job {
    	struct job *j_next;
    	struct job *j_prev;
    	pthread_t   j_id;   /* tells which thread handles this job */
    	/* ... more stuff here ... */
    };

    struct queue {
    	struct job      *q_head;
    	struct job      *q_tail;
    	pthread_rwlock_t q_lock;
    };

    /*
     * Initialize a queue.
     */
    int
    queue_init(struct queue *qp)
    {
    	int err;

    	qp->q_head = NULL;
    	qp->q_tail = NULL;
    	err = pthread_rwlock_init(&qp->q_lock, NULL);
    	if (err != 0)
    		return(err);
    	/* ... continue initialization ... */
    	return(0);
    }

    /*
     * Insert a job at the head of the queue.
     */
    void
    job_insert(struct queue *qp, struct job *jp)
    {
    	pthread_rwlock_wrlock(&qp->q_lock);
    	jp->j_next = qp->q_head;
    	jp->j_prev = NULL;
    	if (qp->q_head != NULL)
    		qp->q_head->j_prev = jp;
    	else
    		qp->q_tail = jp;	/* list was empty */
    	qp->q_head = jp;
    	pthread_rwlock_unlock(&qp->q_lock);
    }

    /*
     * Append a job on the tail of the queue.
     */
    void
    job_append(struct queue *qp, struct job *jp)
    {
    	pthread_rwlock_wrlock(&qp->q_lock);
    	jp->j_next = NULL;
    	jp->j_prev = qp->q_tail;
    	if (qp->q_tail != NULL)
    		qp->q_tail->j_next = jp;
    	else
    		qp->q_head = jp;	/* list was empty */
    	qp->q_tail = jp;
    	pthread_rwlock_unlock(&qp->q_lock);
    }

    /*
     * Remove the given job from a queue.
     */
    void
    job_remove(struct queue *qp, struct job *jp)
    {
    	pthread_rwlock_wrlock(&qp->q_lock);
    	if (jp == qp->q_head) {
    		qp->q_head = jp->j_next;
    		if (qp->q_tail == jp)
    			qp->q_tail = NULL;
    		else
    			jp->j_next->j_prev = jp->j_prev;
    	} else if (jp == qp->q_tail) {
    		qp->q_tail = jp->j_prev;
    		jp->j_prev->j_next = jp->j_next;
    	} else {
    		jp->j_prev->j_next = jp->j_next;
    		jp->j_next->j_prev = jp->j_prev;
    	}
    	pthread_rwlock_unlock(&qp->q_lock);
    }

    /*
     * Find a job for the given thread ID.
     */
    struct job *
    job_find(struct queue *qp, pthread_t id)
    {
    	struct job *jp;

    	if (pthread_rwlock_rdlock(&qp->q_lock) != 0)
    		return(NULL);

    	for (jp = qp->q_head; jp != NULL; jp = jp->j_next)
    		if (pthread_equal(jp->j_id, id))
    			break;

    	pthread_rwlock_unlock(&qp->q_lock);
    	return(jp);
    }

## 递归锁

    #include "apue.h"
    #include <pthread.h>
    #include <time.h>
    #include <sys/time.h>

    extern int makethread(void *(*)(void *), void *);

    struct to_info {
    	void	      (*to_fn)(void *);	/* function */
    	void           *to_arg;			/* argument */
    	struct timespec to_wait;		/* time to wait */
    };

    #define SECTONSEC  1000000000	/* seconds to nanoseconds */

    #if !defined(CLOCK_REALTIME) || defined(BSD)
    #define clock_nanosleep(ID, FL, REQ, REM)	nanosleep((REQ), (REM))
    #endif

    #ifndef CLOCK_REALTIME
    #define CLOCK_REALTIME 0
    #define USECTONSEC 1000		/* microseconds to nanoseconds */

    void
    clock_gettime(int id, struct timespec *tsp)
    {
    	struct timeval tv;

    	gettimeofday(&tv, NULL);
    	tsp->tv_sec = tv.tv_sec;
    	tsp->tv_nsec = tv.tv_usec * USECTONSEC;
    }
    #endif

    void *
    timeout_helper(void *arg)
    {
    	struct to_info	*tip;

    	tip = (struct to_info *)arg;
    	clock_nanosleep(CLOCK_REALTIME, 0, &tip->to_wait, NULL);
    	(*tip->to_fn)(tip->to_arg);
    	free(arg);
    	return(0);
    }

    void
    timeout(const struct timespec *when, void (*func)(void *), void *arg)
    {
    	struct timespec	now;
    	struct to_info	*tip;
    	int				err;

    	clock_gettime(CLOCK_REALTIME, &now);
    	if ((when->tv_sec > now.tv_sec) ||
    	  (when->tv_sec == now.tv_sec && when->tv_nsec > now.tv_nsec)) {
    		tip = malloc(sizeof(struct to_info));
    		if (tip != NULL) {
    			tip->to_fn = func;
    			tip->to_arg = arg;
    			tip->to_wait.tv_sec = when->tv_sec - now.tv_sec;
    			if (when->tv_nsec >= now.tv_nsec) {
    				tip->to_wait.tv_nsec = when->tv_nsec - now.tv_nsec;
    			} else {
    				tip->to_wait.tv_sec--;
    				tip->to_wait.tv_nsec = SECTONSEC - now.tv_nsec +
    				  when->tv_nsec;
    			}
    			err = makethread(timeout_helper, (void *)tip);
    			if (err == 0)
    				return;
    			else
    				free(tip);
    		}
    	}

    	/*
    	 * We get here if (a) when <= now, or (b) malloc fails, or
    	 * (c) we can't make a thread, so we just call the function now.
    	 */
    	(*func)(arg);
    }

    pthread_mutexattr_t attr;
    pthread_mutex_t mutex;

    void
    retry(void *arg)
    {
    	pthread_mutex_lock(&mutex);

    	/* perform retry steps ... */

    	pthread_mutex_unlock(&mutex);
    }

    int
    main(void)
    {
    	int				err, condition, arg;
    	struct timespec	when;

    	if ((err = pthread_mutexattr_init(&attr)) != 0)
    		err_exit(err, "pthread_mutexattr_init failed");
    	if ((err = pthread_mutexattr_settype(&attr,
    	  PTHREAD_MUTEX_RECURSIVE)) != 0)
    		err_exit(err, "can't set recursive type");
    	if ((err = pthread_mutex_init(&mutex, &attr)) != 0)
    		err_exit(err, "can't create recursive mutex");

    	/* continue processing ... */

    	pthread_mutex_lock(&mutex);

    	/*
    	 * Check the condition under the protection of a lock to
    	 * make the check and the call to timeout atomic.
    	 */
    	if (condition) {
    		/*
    		 * Calculate the absolute time when we want to retry.
    		 */
    		clock_gettime(CLOCK_REALTIME, &when);
    		when.tv_sec += 10;	/* 10 seconds from now */
    		timeout(&when, retry, (void *)((unsigned long)arg));
    	}
    	pthread_mutex_unlock(&mutex);

    	/* continue processing ... */

    	exit(0);
    }

## 条件变量

    int pthread_condattr_init(pthread_condattr_t *attr);
    int pthread_condattr_destroy(pthread_condattr_t *attr);

    int pthread_condattr_getpshared(const pthread_condattr_t *restrict attr, int *restrict pshared);
    int pthread_condattr_setpshared(pthread_condattr_t *attr, int pshared);

    int pthread_condattr_getclock(const pthread_condattr_t *restrict attr, clockid_t *restrict clock_id);
    int pthread_condattr_setclock(pthread_condattr_t *attr, clockid_t clock_id);
    只适用pthread_cond_timedwait,clock_id可以是CLOCK_REALTIME, CLOCK_MONOTONIC, CLOCK_PROCESS_CPUTIME_ID, CLOCK_THREAD_CPUTIME_ID

    int pthread_cond_init(pthread_cond_t *restrict cond, const pthread_condattr_t *restrict attr);
    int pthread_cond_destroy(pthread_cond_t *cond);

    int pthread_cond_wait(pthread_cond_t *restrict cond, pthread_mutex_t *restrict mutex);
    先锁住mutex，然后将线程放到等待列表，然后解锁mutex，直到被pthread_cond_signal或pthread_cond_broadcast唤醒
    int pthread_cond_timedwait(pthread_cond_t *restrict cond, pthread_mutex_t *restrict mutex, const struct timespec *restrict tsptr);

    int pthread_cond_signal(pthread_cond_t *cond);
    int pthread_cond_broadcast(pthread_cond_t *cond);

条件变量不应该使用递归锁，如果递归互斥量多次加锁，然后用在调用pthread_cond_wait函数中，条件永远不会被满足，pthread_cond_wait所做的解锁操作不能释放互斥量。

### 条件变量例子

    #include "apue.h"
    #include <pthread.h>

    void
    cleanup(void *arg)
    {
    	printf("cleanup: %s\n", (char *)arg);
    }

    void *
    thr_fn1(void *arg)
    {
    	printf("thread 1 start\n");
    	pthread_cleanup_push(cleanup, "thread 1 first handler");
    	pthread_cleanup_push(cleanup, "thread 1 second handler");
    	printf("thread 1 push complete\n");
    	if (arg)
    		return((void *)1);
    	pthread_cleanup_pop(0);
    	pthread_cleanup_pop(0);
    	return((void *)1);
    }

    void *
    thr_fn2(void *arg)
    {
    	printf("thread 2 start\n");
    	pthread_cleanup_push(cleanup, "thread 2 first handler");
    	pthread_cleanup_push(cleanup, "thread 2 second handler");
    	printf("thread 2 push complete\n");
    	if (arg)
    		pthread_exit((void *)2);
    	pthread_cleanup_pop(0);
    	pthread_cleanup_pop(0);
    	pthread_exit((void *)2);
    }

    int
    main(void)
    {
    	int			err;
    	pthread_t	tid1, tid2;
    	void		*tret;

    	err = pthread_create(&tid1, NULL, thr_fn1, (void *)1);
    	if (err != 0)
    		err_exit(err, "can't create thread 1");
    	err = pthread_create(&tid2, NULL, thr_fn2, (void *)1);
    	if (err != 0)
    		err_exit(err, "can't create thread 2");
    	err = pthread_join(tid1, &tret);
    	if (err != 0)
    		err_exit(err, "can't join with thread 1");
    	printf("thread 1 exit code %ld\n", (long)tret);
    	err = pthread_join(tid2, &tret);
    	if (err != 0)
    		err_exit(err, "can't join with thread 2");
    	printf("thread 2 exit code %ld\n", (long)tret);
    	exit(0);
    }

## 自旋锁

自旋锁在获取锁之前会处于忙等，而不是通过休眠使进程阻塞。自旋锁可以阻塞中断，因为自旋锁底层由原子级汇编指令swap和test_and_set实现，因为中断只能发生在指令之间，所以自旋锁会屏蔽中断。在抢占式系统中，如果线程时间片到了，如果线程持有自旋锁，会导致其它需要这把锁的线程自旋时间更久。自旋锁可以设置自旋计数，达到一定计数后出错返回。

    int pthread_spin_init(pthread_spinlock_t *lock, int pshared);

pshared

>PTHREAD_PROCESS_SHARED，则可以由有访问自旋锁底层内存的线程所获取，即使该线程属于不同进程
>
>PTHREAD_PROCESS_PRIVATE，自旋锁只能被初始化该锁的进程内部线程所访问

    int pthread_spin_destroy(pthread_spinlock_t *lock);
    int pthread_spin_lock(pthread_spinlock_t *lock);
    int pthread_spin_trylock(pthread_spinlock_t *lock);
    不能获取锁立即返回EBUSY错误，不能自旋
    int pthread_spin_unlock(pthread_spinlock_t *lock);

## 屏障

    int pthread_barrierattr_init(pthread_barrierattr_t *attr);
    int pthread_barrierattr_destroy(pthread_barrierattr_t *attr);
    int pthread_barrierattr_getpshared(const pthread_barrierattr_t *restrict attr, int *restrict pshared);
    int pthread_barrierattr_setpshared(pthread_barrierattr_t *attr,int pshared);

    int pthread_barrier_init(pthread_barrier_t *restrict barrier, const pthread_barrierattr_t *restrict attr, unsigned int count);
    int pthread_barrier_destroy(pthread_barrier_t *barrier);
    int pthread_barrier_wait(pthread_barrier_t *barrier);

一旦达到屏障计数值，线程处于非阻塞状态，屏障就可以重用，但是除非调用pthread_barrier_destroy后又pthread_barrier_init，否则屏障计数不会改变。

pthread_barrier_wait返回值PTHREAD_BARRIER_SERIAL_THREAD

    #include "apue.h"
    #include <pthread.h>
    #include <limits.h>
    #include <sys/time.h>

    #define NTHR   8				/* number of threads */
    #define NUMNUM 8000000L			/* number of numbers to sort */
    #define TNUM   (NUMNUM/NTHR)	/* number to sort per thread */

    long nums[NUMNUM];
    long snums[NUMNUM];

    pthread_barrier_t b;

    #ifdef SOLARIS
    #define heapsort qsort
    #else
    extern int heapsort(void *, size_t, size_t,
                        int (*)(const void *, const void *));
    #endif

    /*
     * Compare two long integers (helper function for heapsort)
     */
    int
    complong(const void *arg1, const void *arg2)
    {
    	long l1 = *(long *)arg1;
    	long l2 = *(long *)arg2;

    	if (l1 == l2)
    		return 0;
    	else if (l1 < l2)
    		return -1;
    	else
    		return 1;
    }

    /*
     * Worker thread to sort a portion of the set of numbers.
     */
    void *
    thr_fn(void *arg)
    {
    	long	idx = (long)arg;

    	heapsort(&nums[idx], TNUM, sizeof(long), complong);
    	pthread_barrier_wait(&b);

    	/*
    	 * Go off and perform more work ...
    	 */
    	return((void *)0);
    }

    /*
     * Merge the results of the individual sorted ranges.
     */
    void
    merge()
    {
    	long	idx[NTHR];
    	long	i, minidx, sidx, num;

    	for (i = 0; i < NTHR; i++)
    		idx[i] = i * TNUM;
    	for (sidx = 0; sidx < NUMNUM; sidx++) {
    		num = LONG_MAX;
    		for (i = 0; i < NTHR; i++) {
    			if ((idx[i] < (i+1)*TNUM) && (nums[idx[i]] < num)) {
    				num = nums[idx[i]];
    				minidx = i;
    			}
    		}
    		snums[sidx] = nums[idx[minidx]];
    		idx[minidx]++;
    	}
    }

    int
    main()
    {
    	unsigned long	i;
    	struct timeval	start, end;
    	long long		startusec, endusec;
    	double			elapsed;
    	int				err;
    	pthread_t		tid;

    	/*
    	 * Create the initial set of numbers to sort.
    	 */
    	srandom(1);
    	for (i = 0; i < NUMNUM; i++)
    		nums[i] = random();

    	/*
    	 * Create 8 threads to sort the numbers.
    	 */
    	gettimeofday(&start, NULL);
    	pthread_barrier_init(&b, NULL, NTHR+1);
    	for (i = 0; i < NTHR; i++) {
    		err = pthread_create(&tid, NULL, thr_fn, (void *)(i * TNUM));
    		if (err != 0)
    			err_exit(err, "can't create thread");
    	}
    	pthread_barrier_wait(&b);
    	merge();
    	gettimeofday(&end, NULL);

    	/*
    	 * Print the sorted list.
    	 */
    	startusec = start.tv_sec * 1000000 + start.tv_usec;
    	endusec = end.tv_sec * 1000000 + end.tv_usec;
    	elapsed = (double)(endusec - startusec) / 1000000.0;
    	printf("sort took %.4f seconds\n", elapsed);
    	for (i = 0; i < NUMNUM; i++)
    		printf("%ld\n", snums[i]);
    	exit(0);
    }

# 不能保证线程安全的函数

 | |  |
----|-----|------|------|-----
basename| getchar_unlocked| getservent| putc_unlocked
catgets |getdate |getutxent |putchar_unlocked
crypt| getenv| getutxid| putenv
dbm_clearerr| getgrent |getutxline| pututxline
dbm_close |getgrgid |gmtime| rand
dbm_delete| getgrnam |hcreate |readdir
dbm_error| gethostent |hdestroy |setenv
dbm_fetch |getlogin |hsearch |setgrent
dbm_firstkey |getnetbyaddr |inet_ntoa s|etkey
dbm_nextkey |getnetbyname |l64a |setpwent
dbm_open| getnetent |lgamma |setutxent
dbm_store |getopt |lgammaf |strerror
dirname |getprotobyname |lgammal |strsignal
dlerror |getprotobynumber |localeconv |strtok
drand48 |getprotoent |localtime |system
encrypt |getpwent |lrand48 |ttyname
endgrent| getpwnam |mrand48| unsetenv
endpwent |getpwuid |nftw| wcstombs
endutxent |getservbyname| nl_langinfo| wctomb
getc_unlocked| getservbyport |ptsname|

线程安全版本

 |
---|---
getgrgid_r| localtime_r
getgrnam_r| readdir_r
getlogin_r |strerror_r
getpwnam_r| strtok_r
getpwuid_r| ttyname_r
gmtime_r| flockfile
funlockfile  | ftrylockfile

线程安全不意味对信号处理函数也是可重入的

# 线程特定数据

    int pthread_key_create(pthread_key_t *keyp, void (*destructor)(void *));
    int pthread_key_delete(pthread_key_t key);//取消键与特定数据关联，不会激活析构函数
    void *pthread_getspecific(pthread_key_t key);//如果没有关联数据，返回空指针
    int pthread_setspecific(pthread_key_t key, const void *value);

keyp关联的地址如果置为非空值，则当线程正常退出时，即pthread_exit或线程执行返回，在清理处理程序调用完成后，会调用destructor析构函数。如果调用exit、_exit、_Exit或abort或其它非正常退出时（信号），不会调用析构函数。

## getenv_r

    #include <string.h>
    #include <errno.h>
    #include <pthread.h>
    #include <stdlib.h>

    extern char **environ;

    pthread_mutex_t env_mutex;

    static pthread_once_t init_done = PTHREAD_ONCE_INIT;

    static void
    thread_init(void)
    {
    	pthread_mutexattr_t attr;

    	pthread_mutexattr_init(&attr);
    	pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
    	pthread_mutex_init(&env_mutex, &attr);
    	pthread_mutexattr_destroy(&attr);
    }

    int
    getenv_r(const char *name, char *buf, int buflen)
    {
    	int i, len, olen;

    	pthread_once(&init_done, thread_init);
    	len = strlen(name);
    	pthread_mutex_lock(&env_mutex);
    	for (i = 0; environ[i] != NULL; i++) {
    		if ((strncmp(name, environ[i], len) == 0) &&
    		  (environ[i][len] == '=')) {
    			olen = strlen(&environ[i][len+1]);
    			if (olen >= buflen) {
    				pthread_mutex_unlock(&env_mutex);
    				return(ENOSPC);
    			}
    			strcpy(buf, &environ[i][len+1]);
    			pthread_mutex_unlock(&env_mutex);
    			return(0);
    		}
    	}
    	pthread_mutex_unlock(&env_mutex);
    	return(ENOENT);
    }

# getenv

    #include <limits.h>
    #include <string.h>
    #include <pthread.h>
    #include <stdlib.h>

    #define MAXSTRINGSZ	4096

    static pthread_key_t key;
    static pthread_once_t init_done = PTHREAD_ONCE_INIT;
    pthread_mutex_t env_mutex = PTHREAD_MUTEX_INITIALIZER;

    extern char **environ;

    static void
    thread_init(void)
    {
    	pthread_key_create(&key, free);
    }

    char *
    getenv(const char *name)
    {
    	int		i, len;
    	char	*envbuf;

    	pthread_once(&init_done, thread_init);
    	pthread_mutex_lock(&env_mutex);
    	envbuf = (char *)pthread_getspecific(key);
    	if (envbuf == NULL) {
    		envbuf = malloc(MAXSTRINGSZ);
    		if (envbuf == NULL) {
    			pthread_mutex_unlock(&env_mutex);
    			return(NULL);
    		}
    		pthread_setspecific(key, envbuf);
    	}
    	len = strlen(name);
    	for (i = 0; environ[i] != NULL; i++) {
    		if ((strncmp(name, environ[i], len) == 0) &&
    		  (environ[i][len] == '=')) {
    			strncpy(envbuf, &environ[i][len+1], MAXSTRINGSZ-1);
    			pthread_mutex_unlock(&env_mutex);
    			return(envbuf);
    		}
    	}
    	pthread_mutex_unlock(&env_mutex);
    	return(NULL);
    }

这个版本的getenv是可重入，即线程安全的，但是不是信号安全的，因为调用了malloc

# 线程和信号

    int pthread_sigmask(int how, const sigset_t *restrict set, sigset_t *restrict oset);
    SIG_BLOCK
    SIG_SETMASK
    SIG_UNBLOCK
    int sigwait(const sigset_t *restrict set, int *restrict signop);

正常返回0，失败返回错误编号


* 每个线程都有自己的信号屏蔽字，但是共享信号处理函数。进程中的信号递送到单个线程。如果信号和信号相关，该信号会被发送到引起该事件的线程中去，其它信号发送到任意线程。
* 多个线程在sigwait阻塞，收到信号时，只有一个线程会返回。
* 如果一个信号被一个线程捕捉，两个线程使用sigwait等待，则可以sigwait返回或者进入信号处理函数，两者只会发生一个。

## pthread_kill

    int pthread_kill(pthread_t thread, int signo);
    int tkill(int tid, int sig);
    int tgkill(int tgid, int tid, int sig);
    int pthread_sigqueue(pthread_t thread, int sig, const union sigval value);

signo为0可以检查线程是否存在。如果信号默认动作是终止进程，当信号传递给某个线程时会杀死整个进程。

## 接收信号的文件描述符

    struct signalfd_siginfo {
    	uint32_t ssi_signo;    /* Signal number */
    	int32_t  ssi_errno;    /* Error number (unused) */
    	int32_t  ssi_code;     /* Signal code */
    	uint32_t ssi_pid;      /* PID of sender */
    	uint32_t ssi_uid;      /* Real UID of sender */
    	int32_t  ssi_fd;       /* File descriptor (SIGIO) */
    	uint32_t ssi_tid;      /* Kernel timer ID (POSIX timers)
    						   uint32_t ssi_band;     /* Band event (SIGIO) */
    	uint32_t ssi_overrun;  /* POSIX timer overrun count */
    	uint32_t ssi_trapno;   /* Trap number that caused signal */
    	int32_t  ssi_status;   /* Exit status or signal (SIGCHLD) */
    	int32_t  ssi_int;      /* Integer sent by sigqueue(3) */
    	uint64_t ssi_ptr;      /* Pointer sent by sigqueue(3) */
    	uint64_t ssi_utime;    /* User CPU time consumed (SIGCHLD) */
    	uint64_t ssi_stime;    /* System CPU time consumed
    						   (SIGCHLD) */
    	uint64_t ssi_addr;     /* Address that generated signal
    						   (for hardware-generated signals) */
    	uint16_t ssi_addr_lsb; /* Least significant bit of address
    						   (SIGBUS; since Linux 2.6.37)
    						   uint8_t  pad[X];       /* Pad size to 128 bytes (allow for
    						   additional fields in the future) */
    };

    int signalfd(int fd, const sigset_t *mask, int flags);

创建一个接受信号的文件描述符

## 闹钟由进程内所有线程共享

    #include "apue.h"
    #include <pthread.h>

    int			quitflag;	/* set nonzero by thread */
    sigset_t	mask;

    pthread_mutex_t lock = PTHREAD_MUTEX_INITIALIZER;
    pthread_cond_t waitloc = PTHREAD_COND_INITIALIZER;

    void *
    thr_fn(void *arg)
    {
    	int err, signo;

    	for (;;) {
    		err = sigwait(&mask, &signo);
    		if (err != 0)
    			err_exit(err, "sigwait failed");
    		switch (signo) {
    		case SIGINT:
    			printf("\ninterrupt\n");
    			break;

    		case SIGQUIT:
    			pthread_mutex_lock(&lock);
    			quitflag = 1;
    			pthread_mutex_unlock(&lock);
    			pthread_cond_signal(&waitloc);
    			return(0);

    		default:
    			printf("unexpected signal %d\n", signo);
    			exit(1);
    		}
    	}
    }

    int
    main(void)
    {
    	int			err;
    	sigset_t	oldmask;
    	pthread_t	tid;

    	sigemptyset(&mask);
    	sigaddset(&mask, SIGINT);
    	sigaddset(&mask, SIGQUIT);
    	if ((err = pthread_sigmask(SIG_BLOCK, &mask, &oldmask)) != 0)
    		err_exit(err, "SIG_BLOCK error");

    	err = pthread_create(&tid, NULL, thr_fn, 0);
    	if (err != 0)
    		err_exit(err, "can't create thread");

    	pthread_mutex_lock(&lock);
    	while (quitflag == 0)
    		pthread_cond_wait(&waitloc, &lock);
    	pthread_mutex_unlock(&lock);

    	/* SIGQUIT has been caught and is now blocked; do whatever */
    	quitflag = 0;

    	/* reset signal mask which unblocks SIGQUIT */
    	if (sigprocmask(SIG_SETMASK, &oldmask, NULL) < 0)
    		err_sys("SIG_SETMASK error");
    	exit(0);
    }


# 线程和fork

父进程有多个线程，子进程只有一个线程，即父进程调用fork的线程副本。子进程进程父进程中锁，但是因为子进程可能并不包含父进程占有锁线程的副本，所以子进程不知道它占有了哪些锁，需要释放哪些锁。多线程进程中，为了避免锁不一致状态问题，fork返回和子进程调用exec函数之间，子进程只能使用异步信号安全的函数。

    int pthread_atfork(void (*prepare)(void), void (*parent)(void), void (*child)(void));

prepare父进程在fork子进程前调用，获取父进程定义的所有锁。parent是在fork函数返回前，在父进程上下文中调用，对prepare获取的所有锁解锁，child在fork返回之前子进程上下文中调用，是否prepare获取的所有锁。

存在多个fokr，pthread_atfork设置多套fork处理程序时，parent和child以注册时顺序进行调用，prepare调用顺序与注册时顺序相反。

pthread_atfork缺陷：

* 不能处理复杂同步对象，如对条件变量和屏障进行状态重新初始化
* 某些错误检查的互斥量实现在child调用对被父进程加锁的互斥量进行解锁时会产生错误
* 递归互斥量不能在child中被清理，因为没有办法确定该互斥量被加锁的次数
* 如果子进程只允许调用异步信号安全函数，则child不能清理同步对象，因为用户操作清理的所有函数都不是信号安全的。同步对象（锁）在某个线程调用fork时可能处于中间状态，除非同步对象处于一致状态，否则无法被清理
* 信号处理函数中调用了fork（fork是信号安全的，因此是合法的），pthread_atfork注册的fork处理程序只能调用异步信号安全的函数，否则结果是未定义的。


# 线程和IO

应该使用pread和pwrite

# 放弃CPU

    int sched_yield(void);
    int pthread_yield(void);

线程放弃CPU，运行另一个线程

# 线程重新关联某个namespace，setns

    int setns(int fd, int nstype);

让线程重新关联某个namespace

# 进程所有线程退出，exit_group

    #include <linux/unistd.h>
    void exit_group(int status);

让进程中所有线程退出

# 设置线程ID地址

    long set_tid_address(int *tidptr);
