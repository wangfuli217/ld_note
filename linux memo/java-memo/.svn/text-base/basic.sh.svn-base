String()
{
    compareTo (string) ，compareToIgnoreCase(String) 及 compareTo(object string) 来比较两个字符串，
并返回字符串中第一个字母ASCII的差值。

    字符串函数 strOrig.lastIndexOf(Stringname) 来查找子字符串 Stringname 在 strOrig 出现的位置：
    
    字符串函数 substring() 函数来删除字符串中的一个字符，我们将功能封装在 removeCharAt 函数中。
    String removeCharAt(String s, int pos)
        return s.substring(0, pos) + s.substring(pos + 1);
        
    String 类的 replace 方法来替换字符串中的字符：replace、replaceFirst、replaceAll
    
    Java 的反转函数 reverse() 将字符串反转：
    
    String 类的 indexOf() 方法在字符串中查找子字符串出现的位置，如过存在返回字符串出现的位置（第一位为0），如果不存在返回 -1：
    
    split(string) 方法通过指定分隔符将字符串分割为数组：
    
    String toUpperCase() 方法将字符串从小写转为大写：
    
    regionMatches() 方法测试两个字符串区域是否相等：
    
    long startTime1 = System.currentTimeMillis();
    
    format() 方法来格式化字符串，还可以指定地区来格式化：System.out.format
    
    通过 "+" 操作符和StringBuffer.append() 方法来连接字符串，
}

Array()
{
    使用sort()方法对Java数组进行排序，及如何使用 binarySearch() 方法来查找数组中的元素,
    
    如何使用sort()方法对Java数组进行排序，及如何使用 insertElement () 方法向数组插入元素
    
    数组的属性 length 来获取数组的长度。
    
    ArrayList arrayList = new ArrayList();
    使用 Collections.reverse(ArrayList) 将数组进行反转：
    
    通过 Collection 类的 Collection.max() 和 Collection.min() 方法来查找数组中的最大和最小值：
    int min = (int) Collections.min(Arrays.asList(numbers));
    int max = (int) Collections.max(Arrays.asList(numbers));
    
    通过 List 类的 Arrays.toString () 方法和 List 类的 list.Addall(array1.asList(array2) 方法将两个数组合并为一个数组：
    String a[] = { "A", "E", "I" };
    String b[] = { "O", "U" };
    List list = new ArrayList(Arrays.asList(a));
    list.addAll(Arrays.asList(b));
    Object[] c = list.toArray();
    System.out.println(Arrays.toString(c));

    Java Util 类的 Array.fill(arrayname,value) 方法和 Array.fill(arrayname ,starting index ,ending index ,value) 方法向数组中填充元素：

    使用 sort () 和 binarySearch () 方法来对数组进行排序及查找数组中的元素，我们定义了 printArray() 输出结果：
    
    使用 remove () 方法来删除数组元素：
    
    使用 removeAll () 方法来计算两个数组的差集：
    
    使用 retainAll () 方法来计算两个数组的交集：
    
    使用 union ()方法来计算两个数组的并集：
    
    如何使用 contains () 方法来查找数组中的指定元素：
    
    使用 equals ()方法来判断数组是否相等：
    
    
}

time()
{
    使用 SimpleDateFormat 类的 format(date) 方法来格式化时间
    Date date = new Date();
    String strDateFormat = "yyyy-MM-dd HH:mm:ss";
    SimpleDateFormat sdf = new SimpleDateFormat(strDateFormat);
    System.out.println(sdf.format(date));
    
    Date 类及 SimpleDateFormat 类的 format(date) 方法来输出当前时间：
    SimpleDateFormat sdf = new SimpleDateFormat();// 格式化时间 
    sdf.applyPattern("yyyy-MM-dd HH:mm:ss a");// a为am/pm的标记  
    Date date = new Date();// 获取当前时间 
    System.out.println("现在时间：" + sdf.format(date)); // 输出已经格式化的现在时间（24小时制）
    
    使用 Calendar 类来输出年份、月份等：
    Calendar cal = Calendar.getInstance();
    int day = cal.get(Calendar.DATE);
    int month = cal.get(Calendar.MONTH) + 1;
    int year = cal.get(Calendar.YEAR);
    int dow = cal.get(Calendar.DAY_OF_WEEK);
    int dom = cal.get(Calendar.DAY_OF_MONTH);
    int doy = cal.get(Calendar.DAY_OF_YEAR);
    
    使用 SimpleDateFormat 类的 format() 方法将时间戳转换成时间：
    Long timeStamp = System.currentTimeMillis();  //获取当前时间戳
    SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
    String sd = sdf.format(new Date(Long.parseLong(String.valueOf(timeStamp))));   // 时间戳转换成时间
    
}

Thread()
{
tt.isAlive()
tt.getName()
tt.setName()

http://www.runoob.com/java/thread-monitor.html 
# synchronized void startWait() {
#       try {
#          while(!ready) wait();
#       }
#       catch(InterruptedException exc) {
#          System.out.println("wait() interrupted");
#       }
#    }
# synchronized void notice() {
#       ready = true;
#       notify();
#    }

Thread.MAX_PRIORITY
Thread.MIN_PRIORITY


同步器
四个类可协助实现常见的专用同步语句。 
Semaphore 是一个经典的并发工具。 
CountDownLatch 是一个极其简单但又极其常用的实用工具，用于在保持给定数目的信号、事件或条件前阻塞执行。 
CyclicBarrier 是一个可重置的多路同步点，在某些并行编程风格中很有用。 
Exchanger 允许两个线程在 collection 点交换对象，它在多流水线设计中是有用的。

thread.start(); 
thread.interrupt(); 
thread.join();
}


synchronized()
{
Java语言的关键字，当它用来修饰一个方法或者一个代码块的时候，能够保证在同一时刻最多只有一个线程执行该段代码。
     一、当两个并发线程访问同一个对象object中的这个synchronized(this)同步代码块时，一个时间内只能有一个线程得到执行。
         另一个线程必须等待当前线程执行完这个代码块以后才能执行该代码块。

     二、然而，当一个线程访问object的一个synchronized(this)同步代码块时，另一个线程仍然可以访问该object中的
         非synchronized(this)同步代码块。

     三、尤其关键的是，当一个线程访问object的一个synchronized(this)同步代码块时，其他线程对object中所有其它
         synchronized(this)同步代码块的访问将被阻塞。

     四、第三个例子同样适用其它同步代码块。也就是说，当一个线程访问object的一个synchronized(this)同步代码块时，
         它就获得了这个object的对象锁。结果，其它线程对该object对象所有同步代码部分的访问都被暂时阻塞。

     五、以上规则对其它对象锁同样适用.

synchronized 关键字，它包括两种用法：synchronized 方法和 synchronized 块。 
1. synchronized 方法：通过在方法声明中加入 synchronized关键字来声明 synchronized 方法。如： 
public synchronized void accessVal(int newVal); 

synchronized 方法控制对类成员变量的访问：每个类实例对应一把锁，每个 synchronized 方法都必须获得调用该方法的类实例的锁方能
执行，否则所属线程阻塞，方法一旦执行，就独占该锁，直到从该方法返回时才将锁释放，此后被阻塞的线程方能获得该锁，重新进入可执行
状态。这种机制确保了同一时刻对于每一个类实例，其所有声明为 synchronized 的成员函数中至多只有一个处于可执行状态（因为至多只有
一个能够获得该类实例对应的锁），从而有效避免了类成员变量的访问冲突（只要所有可能访问类成员变量的方法均被声明为 synchronized）

2. synchronized 块：通过 synchronized关键字来声明synchronized 块。语法如下： 
synchronized(syncObject) { 
//允许访问控制的代码 
} 
synchronized 块是这样一个代码块，其中的代码必须获得对象 syncObject （如前所述，可以是类实例或类）的锁方能执行，具体机
制同前所述。由于可以针对任意代码块，且可任意指定上锁的对象，故灵活性较高。



}