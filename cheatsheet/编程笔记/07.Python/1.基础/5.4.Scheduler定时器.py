
Scheduler 定时器
    Python 的 Scheduler 框架是模仿Java的Quartz框架写的，用起来还是比较不错的，这里向大家强烈推荐下。

    使用说明: http://pythonhosted.org/APScheduler/index.html
    相关API: http://packages.python.org/APScheduler/genindex.html
    下载地址: https://pypi.python.org/pypi/APScheduler/

    使用 easy_install 安装:
        easy_install apscheduler


1. 指定特定时间运行某一任务，可以通过如下方式：

    from datetime import datetime
    from apscheduler.scheduler import Scheduler

    sched = Scheduler()
    sched.daemonic = False # daemonic参数，表示执行线程是非守护的，在Schduler的文档中推荐使用非守护线程
    # 上面两行,也可以简写为：  sched = Scheduler(daemonic = False)

    def job_function(text):
        print text

    # 指定时间运行，且只运行一次
    job = sched.add_date_job(job_function, datetime(2013, 10, 30, 17, 13, 59), ['Hello World'])
    sched.start()


2. 有些时候，我们需要每隔一定时间运行一下任务 Interval-based scheduling 的方式，如下：

    from apscheduler.scheduler import Scheduler

    sched = Scheduler()
    sched.daemonic = False

    def job_function():
        print "Hello World"

    # 指定每隔多久执行一次,可以用 weeks,days, hours, minutes, seconds 来指定间隔时间(如果所有值都设为0,则默认每个1秒执行一次; 秒允许使用小数,0.1秒也生效)
    sched.add_interval_job(job_function, seconds=1)
    # 指定每隔多久执行一次，且指定开始执行时间
    sched.add_interval_job(job_function, hours=2, start_date='2013-10-30 17:50:59')

    sched.start()


  除此之外，也可以使用 Decorator 的方式，如下：

    from apscheduler.scheduler import Scheduler

    sched = Scheduler()
    sched.daemonic = False
    sched.start()

    @sched.interval_schedule(hours=2, start_date='2012-04-12 09:54:59')
    def job_function():
        print "Hello World"

  如果想解除 Decorator 功能方法，可以通过如下方式：

    sched.unschedule_job(job_function.job)


3. 如果我们想实现类似Linux下的 crontab 功能，可以通过 Cron-style scheduling 方式来实现，如下：

    from apscheduler.scheduler import Scheduler

    sched = Scheduler()
    sched.daemonic = False

    def job_function():
        print "Hello World"

    # Schedules job_function 将会在六七八月、十一月、十二月的第三个星期五的0至3点执行
    sched.add_cron_job(job_function, month='6-8,11-12', day='3rd fri', hour='0-3')

    # Schedules job_function 将会凌晨的 2点32分54秒 执行
    sched.add_cron_job(job_function, hour=2, minute=32, second=54)

    # Schedules job_function 将会每隔5秒执行一次(当秒数是5的倍数时执行)
    sched.add_cron_job(job_function, second='*/5')

    sched.start()


  同样，也可以通过 Decorator 方式来实现，如下：

    from apscheduler.scheduler import Scheduler

    sched = Scheduler()
    sched.daemonic = False
    sched.start()

    @sched.cron_schedule(day='last sun')
    def some_decorated_task():
        print "I am printed at 00:00:00 on the last Sunday of every month!"


apscheduler 会创建一个线程，这个线程默认是 daemon=True, 也就是默认的是线程守护的，这里设置为 False 只是为了方便看到效果。
除此之外 apscheduler 也提供其他的选项，如threadpool和jobstores等功能，大家可以自己进行相关的探索学习。


4.  带参数的定时器
    from apscheduler.scheduler import Scheduler
    sched = Scheduler()

    sched.add_interval_job(函数名, args=('参数1','参数2',), kwargs=**{'参数名1':'参数1'}, seconds=1)
    sched.add_cron_job(函数名2, args=('参数1','参数2',), kwargs=**{'参数名1':'参数1'}, hour=3)

    sched.start()


5.  延迟
    如果你指定某程序每隔 1 秒执行一次，但这程序在 1 秒内未能执行完，它在 1 秒后是另起线程执行还是怎样？
    事实上，它会等程序执行完之后再计算下次执行的时间，而不是在程序启动时就计算好下次执行的时间。
    比如说，下面程序，设置每隔 1 秒执行一次，但每次需要 2 秒才执行完。所以它实际上是每隔 3 秒触发一次：

        import time
        from apscheduler.scheduler import Scheduler

        sched = Scheduler()
        sched.daemonic = False

        def job_function():
            print(time.strftime('%Y-%m-%d %H:%M:%S'))
            time.sleep(2)

        # 指定每隔 1 秒执行一次,可以用 weeks,days, hours, minutes, seconds 来指定间隔时间
        sched.add_interval_job(job_function, seconds=1)

        sched.start()


6.修改配置
        from apscheduler.scheduler import Scheduler
        # 创建定时任务的配置和对象
        sched_config = {
            'apscheduler.daemonic': False,
            'apscheduler.threadpool.max_threads': 45 # 最大线程数限制(默认20个)
            'apscheduler.misfire_grace_time': 10 # 延迟最大秒数(默认1秒)
        }
        sched = Scheduler(sched_config)

