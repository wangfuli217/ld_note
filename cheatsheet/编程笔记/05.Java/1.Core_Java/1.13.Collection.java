
《集合框架》 Collection FrameWork
     (Iterator 接口  ←－  Iterable 接口 ) ← Collection 接口
                                                 ↑
          ┌--------------------------------┬---------------┐
       Set 接口                          List 接口        Queue 接口
          ↑                                ↑                ↑
     ┌----------┐            ┌-----------+---------┐ ┌-----------┐
  HashSet   SortedSet 接口   Vector    ArrayList   LinkedList   PriorityQueue
                 ↑
               TreeSet

        Map 接口
          ↑
     ┌----------┐
   HashMap  SortedMap 接口
                 ↑
              TreeMap


各接口的主要方法:
   Iterable:     +iterator()
   Iterator:     +hasNext()    +next()        +remove()
   Collection:   +add()        +remove()      +clear()           +isEmpty() +size()  +contains()
   List:         +get()        +set()         +remove()
   Queue:        +element()    +offer()       +peek()            +poll()
   Set:
     SortedSet:  +comparator() +first()       +last()            +headSet() +tailSet()

   Map:          +clear()      +containsKey() +containsValue()   +get()     +keySet()
                 +isEmpty()    +remove()      +put()会替换重复键 +size()    +values()
     SortedMap:  +comparator() +firstKey()    +lastKey()         +headMap() +tailMap()


一、集合(容器，持有对象): 是一个用于管理其它多个对象的对象，且只能保存对象的引用，不是放对象。
   1. Collection:    集合中每一个元素为一个对象，这个接口将这些对象组织在一起，形成一维结构。
   2. List:          有序、可重复。
      ArrayList:     数组。查询快，增删慢。(List是链表)
      Vector:        线程安全，但效率很差(现实中基本不用)
   3. Set:           无序，且不可重复(不是意义上的重复)。(正好与List 对应)
      HashSet:       用 hashCode() 加 equals() 比较是否重复
      SortedSet:     会按照数字将元素排列，为“可排序集合”默认升序。
      TreeSet:       按二叉树排序(效率非常高)； 按Comparable接口的 compareTo() 比较是否重复
   4. Map:           其中每一个元素都是一个键值对( Key-Value)。键不能重复。可有一个空键。
      SortedMap:     根据 key 值排序的 Map。
      HashMap:       用 hashCode() 加 equals() 比较是否重复
   5. Queue:          队列: 先进先出。
      PriorityQueue:    优先队列: 元素按照其自然顺序进行排序，或者根据构造队列时提供的 Comparator 进行排序

    注意: 在“集合框架”中, Map 和 Collection 没有任何亲缘关系。
        Map 的典型应用是访问按关键字存储的值。它支持一系列集合操作，但操作的是键-值对，而不是独立的元素
        因此 Map 需要支持 get() 和 put() 的基本操作，而 Set 不需要。


    《常用集合列表》
    '         存放元素  存放顺序     元素可否重复      遍历方式   排序方式       各自实现类
    List      Object    有序         可                迭代       (2)            ArrayList, TreeSet
    Set       Object    无序         不可              迭代       SortedSet      HashSet
    SortedSet Object    无序         不可              迭代       已排序         TreeSet
    Map       (1)       Key无序      Key不可,value可   对Key迭代  SortedMap      HashMap
    SortedMap (1)       无序,有排序  Key不可,value可   对Key迭代  已对键值排序   TreeMap
         (1)Object(key) & Object(value);
         (2)Collections.sort();


    注: 以上有序的意思是指输出的顺序与输入元素的顺序一致
        HashSet,HashMap 通过 hashCode(),equals() 来判断重复元素
        在java中指定排序规则的方式只有两种:
            1、实现 java.util 包下的 Comparator 接口
            2、实现 java.lang 包下的 Comparable 接口


二、迭代器: Iterator
    1. 使用 Iterator 接口方法，您可以从头至尾遍历集合，并安全的从底层 Collection 中除去元素
    2. remove() 由底层集合有选择的支持。底层集合支持并调用该方法时，最近一次 next() 返回的元素将被删
    3. Collection 接口的 iterator() 方法返回一个 Iterator
    4. Iterator 中的hasNext()用于判断元素右边是否有数据，返回 true 则有。然后就可以调用next()动作。
    5. Iterator 中的next()方法会将游标移到下一个元素，并返回它所跨过的元素。(通常这样遍历集合)
    6. 用于常规 Collection 的 Iterator 接口代码如下:

    注: 工具类是指所有的方法都是公开静态方法的类。
        Java.util.collections 就是一个工具类；


    /******* Iterator 迭代遍历 *****/
        List l = new ArrayList();
        Iterator it = l.iterator();
        while(it.hasNext()){
            Object obj = it.next();
            System.out.println(obj);
        }
        //遍历Vector
        Vector v = new Vector();
        for(int index=0; index<v.size(); index++) {
            String str = (String) v.elementAt(index); //需知道Vector里包含的类型，否则强转出错
            System.out.println(str);
        }
    /******* Iterator 迭代遍历 end *****/


三、对集合的排序
    1、我们可以用 Java.util.collections 中的sort(List l)方法对指定的List集合进行排序；
    但是如果 List 中存放的是自定义对象时，这个方法就行不通了，必须实现 Comparable 接口并且指定排序规则。
        这里我们再来看一下 sort(List l)方法的内部实现；
    /**********************************************************/
    class Collections2 {
        public static void sort(List l) {
            for (int i = 0; i < l.size() - 1; i++) {
                for (int j = i + 1; j < l.size(); j++) {
                    Object o1 = l.get(i);
                    Object o2 = l.get(j);
                    Comparable c1 = (Comparable) o1;
                    Comparable c2 = (Comparable) o2;
                    if (c1.compareTo(c2) > 0) {
                        Collections.swap(l, i, j);
                    }
                }
            }
        }
    } // 其实用的算法就是个冒泡排序。
    /******************************************************/

    2、实现Java.lang.Comparable接口，其实就是实现他的 public int compareTo(Object obj)方法；
       比较此对象与指定对象的顺序。如果该对象小于、等于或大于指定对象，则分别返回负整数、零或正整数。
          其规则是当前对象与obj 对象进行比较，其返回一个 int 值，系统根据此值来进行排序。
          如当前对象 > obj，则返回值>0；
          如当前对象 = obj，则返回值=0；
          如当前对象 < obj，则返回值<0。

    注意: String类型已经实现了这个接口，所以可以直接排序；
    /******************************************************/
    class Student implements Comparable {
        private String name;
        private int age;

        public Student(String name, int age) {
            this.name = name;
            this.age = age;
        }

        public int compareTo(Object obj) {
            Student s = (Student) obj;
            return s.age - this.age;
        }
    }
    /******************************************************/


四、 ArrayList 和 LinkedList 集合
    1. ArrayList 底层是object 数组，所以ArrayList 具有数组的查询速度快的优点以及增删速度慢的缺点。
       Vector 底层实现也是数组，但他是一个线程安全的重量级组件。
    2. 而在LinkedList 的底层是一种双向循环链表。
       在此链表上每一个数据节点都由三部分组成:
        前指针(指向前面的节点的位置).  数据、 后指针(指向后面的节点的位置)。
       最后一个节点的后指针指向第一个节点的前指针，形成一个循环。
    3. 双向循环链表的查询效率低但是增删效率高。所以LinkedList 具有查询效率低但增删效率高的特点。
    4. ArrayList 和LinkedList 在用法上没有区别，但是在功能上还是有区别的。
       LinkedList 经常用在增删操作较多而查询操作很少的情况下: 队列和堆栈。
       队列: 先进先出的数据结构。
       堆栈: 后进先出的数据结构。
       (堆栈就是一种只有增删没有查询的数据结构)
       注意: 使用堆栈的时候一定不能提供方法让不是最后一个元素的元素获得出栈的机会。

       LinkedList 提供以下方法: (ArrayList 无此类方法)
       addFirst(); +removeFirst(); +addLast(); +removeLast();
        在堆栈中，push 为入栈操作，pop 为出栈操作。
       Push 用addFirst()；pop 用removeFirst()，实现后进先出。
        用isEmpty()--其父类的方法，来判断栈是否为空。
        在队列中，put 为入队列操作，get 为出队列操作。
       Put 用addFirst()，get 用removeLast()实现队列。
       List 接口的实现类 Vector 与ArrayList 相似，区别是Vector 是重量级组件，消耗的资源较多。
        结论: 在考虑并发的情况下用Vector(保证线程的安全)。
        在不考虑并发的情况下用ArrayList(不能保证线程的安全)。

    5. 面试经验(知识点):
       java.util.stack(stack 即为堆栈)的父类为 Vector 。可是 stack 的父类是最不应该为 Vector 的。
       因为 Vector 的底层是数组,且 Vector 有get方法(意味着它可能访问任意位置的元素，很不安全)。
       对于堆栈和队列只能用push 类和get 类。(这是早期的某个java编写工程师的失误造成)
       Stack 类以后不要轻易使用。实现堆栈一定要用 LinkedList 。
        (在JAVA1.5 中, collection 有queue 来实现队列。)


五、 HashSet 集合
   1. HashSet是无序的，没有下标这个概念。HashSet集合中元素不可重复(元素的内容不可重复)；
   2. HashSet 底层用的也是数组。
   3. HashSet 如何保证元素不重复？ Hash 算法和 equals 方法。
      当向数组中利用add(Object obj)添加对象的时候，系统先找对象的hashCode:
      int hc=obj.hashCode(); 返回的hashCode 为整数值。
      int I=hc%n;(n 为数组的长度)，取得余数后，利用余数向数组中相应的位置添加数据，以n 为6 为例，
      如果I=0则放在数组a[0]位置，如果I=1则放在数组a[1]位置。
      如果equals()返回true，则说明数据重复。如果equals()返回 false, 则再找其它的位置进行比较。
      这样的机制就导致两个相同的对象有可能重复地添加到数组中，因为他们的hashCode 不同。
      如果我们能够使两个相同的对象具有相同hashcode，才能在equals()返回为真。

      在实例中，定义student 对象时覆盖它的hashcode。
      因为String类会自动覆盖，所以比较String 类的对象时，不会出现相同的string 对象的情况。
      现在，在大部分的JDK 中，都已经要求覆盖了hashCode。

   结论: 如将自定义类用hashSet 来添加对象，一定要覆盖hashcode()和equals()，
      覆盖的原则是保证当两个对象hashcode 返回相同的整数，而且equals()返回值为True。
      如果偷懒，直接将hashCode方法的返回值设为常量；虽然结果相同，但会多次地调用equals()，影响效率。
      我们要保证相同对象的返回的hashCode 一定相同，也要保证不相同的对象的hashCode 尽可能不同
      (因为数组的边界性，hashCode 还是有极微几率相同的)。


六、 TreeSet 集合
    1. TreeSet 是 SortedSet 的实现类 TreeSet 通过实现 Comparable 接口的 compareTo 来实现元素不重复。
    2. TreeSet 由于每次插入元素时都会进行一次排序，因此效率不高。
    3. java.lang.ClassCastException 是类型转换异常。
    4. 在我们给一个类用 CompareTo() 实现排序规则时
    5. 从集合中以有序的方式抽取元素时，可用 TreeSet, 添加到 TreeSet 的元素必须是可排序的。
      “集合框架”添加对 Comparable 元素的支持。
      一般说来，先把元素添加到 HashSet, 再把集合转换为 TreeSet 来进行有序遍历会更快。

七、 Map
   1. HashMap 集合
     (1)HashMap就是用hash算法来实现的Map
     (2)在实际开发中一般不会用自定义的类型作为Map的Key。做Key的无非是八中封装类。
     (3)HashMap的三组操作:
       【1】改变操作，允许从映射中添加和除去键-值对。键和值都可以为null。
           不能把Map作为一个键或值添加给自身。
         –Object put(Object key, Object value)
         –Object remove(Object key)
         –void clear()
       【2】查询操作允许您检查映射内容:
         –Object get(Object key)
         –intsize()
         –boolean isEmpty()
       【3】最后一组方法允许您把键或值的组作为集合来处理。
         –public Set KeySet();
         –public Collection values()
    (4)HashMap和HashTable的区别等同于ArrayList和Vector的区别。
       只不过HashTable中的Key和Value不能为空，而HashMap可以。
    (5)HashMap底层也是用数组，HashSet底层实际上也是HashMap，HashSet类中有HashMap属性(查API)。
       HashSet 实际上为(key.null)类型的HashMap。有key 值而没有value 值。

   2. HashMap 类和 TreeMap 类
     •集合框架提供两种常规Map 实现: HashMap和TreeMap。
     •在Map 中插入、删除和定位元素，HashMap 是最好选择。
     •如果要按顺序遍历键，那么TreeMap 会更好。
     •根据集合大小，先把元素添加到HashMap，再把这种映射转换成一个用于有序键遍历的TreeMap 可能更快。
     •使用HashMap 要求添加的键类明确定义了hashCode() 实现。
     •有了TreeMap 实现，添加到映像的元素一定是可排序的
     •HashMap和TreeMap 都实现Cloneable 接口。

/******* 遍历hashMap **********/
Map map = new HashMap();
//方法一:  (会比方法二快一倍)
for (Iterator iter = map.entrySet().iterator(); iter.hasNext();) {
    Map.Entry entry = (Map.Entry) iter.next();
    Object key = entry.getKey();
    Object val = entry.getValue();
}
//方法一,指定类型的写法
for (Iterator<Map.Entry<String, String>> iter = map.entrySet().iterator(); iter.hasNext();) {
    Map.Entry<String, String> entry = iter.next();
    String key = entry.getKey();
    String val = entry.getValue();
}

//方法二:
Iterator  it  =  map.keySet().iterator();
while(it.hasNext())
{
    Object  key  =it.next();
    Object  value  =map.get(key);
}
/*********** 结束 *****************/

