
《多线程》
一. 线程:线程是一个并发执行的顺序流,一个进程包括多个顺序执行流程,这执行流程称为线程。
    线程是一个操作系统创建并维护的一个资源,对操作系统来说JVM就是一个进程。
    对于单个CPU系统来说, 某一个时刻只可能由一个线程在运行。
       一个Thread对象就表示一个线程。
    线程由三部分组成:
     (1).CPU分配给线程的时间片
     (2).线程代码(写在run方法中)
     (3).线程数据
   进程是独立的数据空间,线程是共享的数据空间.
   线程对象存在于虚拟机进程空间的一块连续的地址空间(静态)
   //main()也是一个线程。

   注意:
   1.线程是动态的,与线程对象是两回事.
   2.线程对象与其它对象不同的是线程对象能够到底层去申请管理一个线程资源。
   3.只有对线程对象调用start()方法才是到底层去申请管理一个线程资源。
   4.任务并发执行是一个宏观概念, 微观上是串行的。

二.进程的调度
    进程的调度由OS负责(有的系统为独占式(Windows), 有的系统为共享式(Unix), 根据重要性, 进程有优先级)
    由OS 将时间分为若干个时间片。JAVA 在语言级支持多线程。分配时间的仍然是OS。

三.线程有两种实现方式:
    第一种方式:
    class MyThread extends Thread {
        public void run() {
            //...需要进行执行的代码, 如循环。
        }
    }
    class TestThread {
        public static void main(String[]args) {
            Thread t1=new MyThread();
            t1.start();
        }
    }
    只有等到所有的线程全部结束之后, 进程才退出。

    第二种方式: 通过接口实现继承
    class MyThread implements Runnable {
        public void run(){
            //...需要进行执行的代码, 如循环。
        }
    }
    class TestThread {
        public static void main(String[]args) {
            Runnable target=new MyThread();
            Thread t3=new Thread(target);
            t3.start();//启动线程, 这种方式跟前者一样, 只是可以继承
        }
    }

/******************多线程事例*******************************/
class TestThread {
    public static void main(String[] args) {
        System.out.println("Main Thread Start!");
        //Thread t = new MyThread();
        Runnable r = new MyRunnable();
        Thread t1 = new Thread(r);//启动另一个带任务的线程
        Thread t = new MyThread(t1);//这个线程需要join(t1), 否则用上面没参的一句
        t.start();//启动一个线程
        t1.setPriority(10);//设置优先级
        t1.start();
        System.out.println("Main Thread End!");
    }
}
class MyThread extends Thread {
    private Thread t;
    public MyThread (){}
    public MyThread (Thread t){this.t = t;}
    public void run() {
        for(int i=0; i<100; i++){
            System.out.println(i+" $$$$");
            if(i==65){  //join()加入其它线程, 等其运行完后再运行
                try{t.join();}
                catch(Exception e){e.printStackTrace();}
            }
            //当i=50时, 放弃CPU占用, 让其它程序或线程使用
            if(i==50){Thread.yield();}//没有sleep睡眠方法时, 此句才可看出效果
            //阻塞, 睡眠5毫秒, 中途会被打断而抛异常
            try{Thread.sleep(5);} catch(Exception e){}
        }
    }
}
class MyRunnable implements Runnable{
    //Runnable是线程任务接口, 让你可以继承其它类；Thread是类, 不能继承
    public void run(){
        for(int i=0; i<100; i++){
            System.out.println(i+" ****");
            try{Thread.sleep(5);} catch(Exception e){}
        }
    }
}
/*********************************************************/


四. 线程中的7 种非常重要的状态:  初始New、可运行Runnable、运行Running、阻塞Blocked、
                            锁池lock_pool、等待队列wait_pool、结束Dead
    有的书上认为只有五种状态: 将“锁池”和“等待队列”都看成是“阻塞”状态的特殊情况: 这种认识也是正确的。
    将“锁池”和“等待队列”单独分离出来有利于对程序的理解。

                 ┌--------------------< 阻塞
                 ↓                    (1)(2)(3)        结束
                ①②③        OS调度        ↑             ↑
    初始-------> 可运行 ↹---------------↹ 运行 >-----------┤
    t.start()启动↑                        ↓              ↓o.wait()
                 └-----< 锁池 ←---------<┘←-------< 等待队列
                  获得锁标志   synchronized(o)

注意: 图中标记依次为
    ①输入完毕；    ②wake up    ③t1 退出
    ⑴等待输入(输入设备进行处理, 而CUP 不处理), 则放入阻塞, 直到输入完毕。
    ⑵线程休眠sleep()
    ⑶t1.join()将t1 加入运行队列, 直到t1 退出, 当前线程才继续。
        特别注意: ①②③与⑴⑵⑶是一一对应的。
    进程的休眠: Thread.sleep(1000);//括号中以毫秒为单位
    当线程运行完毕, 即使在结束时时间片还没有用完, CPU 也放弃此时间片, 继续运行其它程序。
    T1.join 实际上是把并发的线程编成并行运行。

五. 线程的优先级:
    设置线程优先级: setPriority(Thread. MAX_PRIORITY);
    setPriority(10); //设置优先级, 独占式的操作系统按优先级分配CPU, 共享式操作系统按等待时长分配
    JAVA的优先级可以是 1~10,默认是5, 数据越大, 优先级越高。//windows只有6个优先级, 会自动转换来分配
    为了跨平台, 最好不要使用优先级决定线程的执行顺序。
    //跨平台性的含义: 除了程序能够正常运行, 还必须保证运行的结果。
    线程对象调用yield()时会马上交出执行权, 交由一个高优先级的线程进入可运行状态；自己等待再次调用。
    程序员需要关注的线程同步和互斥的问题。
    多线程的并发一般不是程序员决定, 而是由容器决定。

六. 多线程出现故障的原因:
    (1).多个线程同时访问一个数据资源(该资源称为临界资源), 形成数据发生不一致和不完整。
    (2).数据的不一致往往是因为一个线程中的多个关联的操作(这几个操作合成原子操作)未全部完成。
    避免以上的问题可采用对数据进行加锁的方法, 如下

七. 对象锁 Synchronized
    防止打断原子操作, 解决并发访问的故障。
    //原子操作: 不可分割的几个操作, 要么一起不做, 要么不能被干扰地完成。
    1. 互斥锁标记:每个对象除了属性和方法, 都有一个monitor(互斥锁标记),
       用来将这个对象交给一个线程, 只有拿到monitor 的线程才能够访问这个对象。
    2. Synchronized:这个修饰词可以用来修饰方法和代码块
       Object obj;    Obj.setValue(123);
       Synchronized用来修饰代码块时, 该代码块成为同步代码块。
       Synchronized 用来修饰方法, 表示当某个线程调用这个方法之后, 其它的事件不能再调用这个方法。
            只有拿到obj 标记的线程才能够执行代码块。
注意:
    (1)Synchronized 一定使用在一个方法中。
    (2)锁标记是对象的概念, 加锁是对对象加锁, 目的是在线程之间进行协调。
    (3)当用Synchronized 修饰某个方法的时候, 表示该方法都对当前对象加锁。
    (4)给方法加Synchronized 和用Synchronized 修饰对象的效果是一致的。
    (5)一个线程可以拿到多个锁标记, 一个对象最多只能将monitor 给一个线程。
    (6)构造方法和抽象方法不能加synchronized；
    (7)一般方法和静态方法可以加synchronized同步。//静态方法把类看作对象时可加锁
    (8)Synchronized 是以牺牲程序运行的效率为代价的, 因此应该尽量控制互斥代码块的范围。
    (9)方法的Synchronized 特性本身不会被继承, 只能覆盖。

八. 锁池
    1. 定义: 线程因为未拿到锁标记而发生的阻塞不同于前面五个基本状态中的阻塞, 称为锁池。
    2. 每个对象都有自己的锁池的空间, 用于放置等待运行的线程。这些线程中哪个线程拿到锁标记由系统决定。
    3. 死锁: 线程互相等待其它线程释放锁标记, 而又不释放自己的；造成无休止地等待。
       死锁的问题可通过线程间的通信解决。

九. 线程间通信:
    1.  线程间通信机制实际上也就是协调机制。
        线程间通信使用的空间称之为对象的等待队列, 这个队列也属于对象的空间。
        注: 现在, 我们已经知道一个对象除了由属性和方法之外还有互斥锁标记、锁池空间和等待队列空间。
    2.  wait()
        在运行状态中, 线程调用wait(), 表示这线程将释放自己所有的锁标记, 同时进入这个对象的等待队列。
        等待队列的状态也是阻塞状态, 只不过线程释放自己的锁标记。
        用notify()方法叫出之后, 紧跟着刚才wait();的位置往下执行。
    3.  Notify()
        如果一个线程调用对象的notify(), 就是通知对象等待队列的一个线程出列。进入锁池。
        如果使用notifyall()则通知等待队列中所有的线程出列。
    注意: 只能对加锁的资源(Synchronized方法里)进行wait()和notify()。
         我们应该用notifyall取代notify, 因为我们用notify释放出的一个线程是不确定的, 由OS决定。
         释放锁标记只有在Synchronized 代码结束或者调用wait()。
         锁标记是自己不会自动释放, 必须有通知。
    注意: 在程序中判定一个条件是否成立时要注意使用WHILE 要比使用IF 更严密。
         //WHILE 循环会再次回来判断, 避免造成越界异常。
    4.   补充知识:
        suspend()将运行状态推到阻塞状态(注意不释放锁标记)。恢复状态用resume()。Stop()释放全部。
        这几个方法上都有Deprecated 标志, 说明这个方法不推荐使用。
        一般来说, 主方法main()结束的时候线程结束, 可是也可能出现需要中断线程的情况。
        对于多线程一般每个线程都是一个循环, 如果中断线程我们必须想办法使其退出。
        如果想结束阻塞中的线程(如sleep 或wait), 可以由其它线程对其对象调用interrupt()。
        用于对阻塞(或锁池)会抛出例外Interrupted。
    5. Exception。
        这个例外会使线程中断并执行catch 中代码。

十. 5.0的新方法:
//参看 java.util.concurrent.*;包下的Callable,ExecutorService,Executors;
    1.  ExecutorService 代替 Thread, 它不会销毁线程, 效率更高, 用空间换时间, 适用于服务器。
        ExecutorService exec = Executors.newFixedThreadPool(3);//创建3个等待调用的线程
        Callable<String> c1 = new Task();//用Callable的Task子类实现任务, 其call()代替run()
        Future<String> f1 = exec.submit(c1);//Futrue获得运行线程后的结果, 这线程与主程序分开
            String s1 = f1.get();//Futrue的获得结果的方法, 会返回异常
    2.  用 Callable 接口代替 Runnable
        因为 Runnable 不能抛异常, 且没有返回值。
    3.  Lock 对象 替代 synchronized 标志符, 获得的更广泛的锁定操作, 允许更灵活的结构。
        还有 tryLock() 尝试加锁。
        解锁用 unLock(); 可以主动控制解锁, 方便复杂的方法调用。
        //下列方法参考 java.util.concurrent.locks
        在这里wait()用await()替代；Notify(),notifyall()用signal(),signalAll()替代。
        ReadWriteLock读写锁:
            writeLock()写锁, 排他的, 一旦加上, 其它任何人都不能来读写。
            readLock()读锁, 共享的, 加上之后, 别人可以读而不能写。可以加多个读锁。


重点:  实现多线程的两种方式,  Synchronized, 生产者和消费者问题
练习: ① 存车位的停开车的次序输出问题。
     ② 写两个线程, 一个线程打印 1~52, 另一个线程打印字母A-Z。打印顺序为12A34B56C……5152Z。要求用线程间的通信。
       注: 分别给两个对象构造一个对象o, 数字每打印两个或字母每打印一个就执行o.wait()。
       在o.wait()之前不要忘了写o.notify()。
补充: 通过Synchronized, 可知Vector与ArrayList的区别就是Vector几乎所有的方法都有Synchronized。
     所以Vector 更为安全, 但效率非常低下。 同样: Hashtable 与HashMap 比较也是如此。
/****************多线程间的锁及通信**************************/
//生产者－消费者问题, 见P272
public class TestProducerAndConsumer {
    public static void main(String[] args) {
        MyStack ms = new MyStack();
        Thread producer = new ProducerThread(ms);
        Thread consumer = new ConsumerThread(ms);
        producer.start();
        consumer.start();
        Thread producer2 = new ProducerThread(ms);
        producer2.start();//用第2个生产者, 说明while循环判断比if更严密
    }
}
class MyStack{ //工厂
    private char[] cs = new char[6];//仓库只能容6个产品
    private int index = 0;
    public synchronized void push(char c){
        //用while来循环判断, 避免多个push进程时的下标越界异常。如果用if, 只能在一个push进程时能正常
        while(index==6){try{wait();}catch(Exception e){}}
        cs[index] = c;
        System.out.println(cs[index]+ " pushed!");
        index++;
    }
    public synchronized void pop(){
        while(index==0){try{wait();}catch(Exception e){}}
        index--;
        System.out.println(cs[index]+" poped!");
        notify();
        cs[index] = '\0';
    }
    public void print(){
        for(int i=0; i<index; i++){System.out.print(cs[i]+"\t");}
        System.out.println();
    }
}
class ProducerThread extends Thread{ //生产者
    private MyStack s;
    public ProducerThread(MyStack s){this.s = s;}
    public void run(){
        for(char c='A'; c<='Z'; c++){
            s.push(c);
            try{Thread.sleep(20);}
            catch(Exception e){e.printStackTrace();}
            s.print();
        }
    }
}
class ConsumerThread extends Thread{ //消费者
    private MyStack s;
    public ConsumerThread(MyStack s){
        this.s = s;
    }
    public void run(){
        for(int i=0; i<26*2; i++){
            s.pop();

            try{Thread.sleep(40);}
            catch(Exception e){e.printStackTrace();}
            s.print();
        }
    }
}
/*********************************************************/

Daemon Threads(daemon 线程)
    是服务线程, 当其它线程全部结束, 只剩下daemon线程时, 虚拟机会立即退出。
    Thread t = new DaemonThread();
    t.setDaemon(true);//setDaemon(true)把线程标志为daemon, 其它的都跟一般线程一样
    t.start();//一定要先setDaemon(true), 再启动线程
    在daemon线程内启动的线程, 都定为daemon线程
Thread.currentThread()  //取得执行中当前线程的信息。
Thread t;  t.isAlive();  //boolean isAlive() 判断线程是否存活。如果线程正在执行则true。
