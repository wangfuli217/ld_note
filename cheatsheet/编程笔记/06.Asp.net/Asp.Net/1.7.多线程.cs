
多线程

1.Thread 类
    Thread 类有几个至关重要的方法，描述如下：
        Start():    启动线程；
        Sleep(int): 静态方法，暂停当前线程指定的毫秒数；
        Abort():    通常使用该方法来终止一个线程；
        Suspend():  该方法并不终止未完成的线程，它仅仅挂起线程，以后还可恢复；
        Resume():   恢复被Suspend()方法挂起的线程的执行；

    Thread.ThreadState 属性
        这个属性代表了线程运行时状态，在不同的情况下有不同的值，我们有时候可以通过对该值的判断来设计程序流程。
        ThreadState 属性的取值如下：
        Aborted：线程已停止；
        AbortRequested：线程的Thread.Abort()方法已被调用，但是线程还未停止；
        Background：线程在后台执行，与属性Thread.IsBackground有关；
        Running：线程正在正常运行；
        Stopped：线程已经被停止；
        StopRequested：线程正在被要求停止；
        Suspended：线程已经被挂起（此状态下，可以通过调用Resume()方法重新运行）；
        SuspendRequested：线程正在要求被挂起，但是未来得及响应；
        Unstarted：未调用Thread.Start()开始线程的运行；
        WaitSleepJoin：线程因为调用了Wait(),Sleep()或Join()等方法处于封锁状态；

    上面提到了Background状态表示该线程在后台运行，那么后台运行的线程有什么特别的地方呢？其实后台线程跟前台线程只有一个区别，那就是后台线程不妨碍程序的终止。一旦一个进程所有的前台线程都终止后，CLR（通用语言运行环境）将通过调用任意一个存活中的后台进程的Abort()方法来彻底终止进程。


2. 调用已经有的函数(无参数)
    using System.Threading;
    // 多线程调用,参数 DownloadHotRepost 是被调用的函数
    new Thread(new ThreadStart(DownloadHotRepost)).Start();
    // 被多线程调用的函数
    private void DownloadHotRepost()
    {
       //........
    }

3. 发起带参数的多线程(其实是调用匿名函数)
    ThreadPool.QueueUserWorkItem(new WaitCallback(delegate { AddLog(log); }));

4. 调用匿名函数
    // 可以直接写个匿名函数，参数和返回都还可以保证
    var arrayList = new ArrayList();
    Thread thread = new Thread(new ThreadStart(delegate
    {
        Console.WriteLine(Thread.CurrentThread.Name + "启动了");
        for (var j = 0; j < 10; j++)
        {
            Monitor.Enter(arrayList);//锁定，保持同步
            arrayList.Add(j);
            Console.WriteLine(Thread.CurrentThread.Name + "添加了" + j);
            Monitor.Exit(arrayList);//取消锁定
        }
        Console.WriteLine(Thread.CurrentThread.Name + "结束了");
    }));
    thread.Name = "线程" + i;
    thread.Start(); // 启动线程


5. 让程序暂停 1 秒
    System.Threading.Thread.Sleep(1000);


