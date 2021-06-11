泛型 Generic

1、为了解决类型安全的集合问题引入了泛型。
    泛型是编译检查时的依据，也是编译期语法。
    (编译期语法: 编译期有效，编译后擦除，不存在于运行期)

2、简单的范型应用: 集合(ArrayList, Set, Map, Iterator, Comparable)
    List<String>  l  =  new  ArrayList<String>();
    <String>:表示该集合中只能存放String类型对象。

3、使用了泛型技术的集合在编译时会有类型检查，不再需要强制类型转换。
    String str  =  l.get(2);  //因为List<String>  l, 所以 Error
    注: 一个集合所允许的类型就是这个泛型的类型或这个泛型的子类型。

4、List<Number>  l  =  new  ArrayList<Integer>  //Error
    List<Integer> l = new ArrayList<Integer>  //Right
    必须类型一致，泛型没有多态

5、泛型的通配符<?>
    泛型的通配符表示该集合可以存放任意类型的对象。但只有访问，不可以修改。
    static void print( Cllection<?> c ){
        for( Object o : c )
        out.println(o);
    }

6、带范围的泛型通配符
    泛型的声明约定T表示类型，E表示元素
    (1)、上界通配符，向下匹配: <?  extends  Number>    表明“extends”或“implements”，认为是 final 的
         表示该集合元素可以为Number类型及其子类型(包括接口)，例如 Number,Integer,Double
         此时集合可以进行访问但不能修改。即不允许调用此对象的add,set等方法；但可以使用 for-each 或 get.
    (2)、下界通配符，向上匹配: <?  super  Number>
         表示该集合元素可以为Number类型及其父类型，直至 Object。
         可以使用 for-each,add,addAll,set,get等方法
    (3)、接口实现: <? extends Comparable>
         表示该集合元素可以为实现了Comparable接口的类

7、泛型方法
    在返回类型与修饰符之间可以定义一个泛型方法，令后面的泛型统一
    这里只能用 extends 定义，不能用 super ；后面可以跟类(但只能有一个，且要放在首位)其余是接口
    符号只有   &    //“＆”表示“与”；逗号表示后面的另一部分
    静态方法里面，不能使用类定义的泛型，只能用自己定义的；因为静态方法可以直接调用；
    所以普通方法可以使用类定义的及自己定义的泛型
        public static <T> void copy(T[] array,Stack<T> sta){……}
        public static <T,E extends T> void copy (T[] array,Stack<E> sta){…..}
        public static <T extends Number&Comparable> void copy(List<T> list,T[] t);

8、不能使用泛型的情况:
    (1)、带泛型的类不能成为 Throwable 类和 Exception 类的子类
        因为cathc()中不能出现泛型。
    (2)、不能用泛型来 new 一个对象
        如: T t = new T();
    (3)、静态方法不能使用类的泛型，因为静态方法中没有对象的概念。

9、在使用接口的时候指明泛型。
    class Student  implements  Comparable<Student>{…….}

10、泛型类
    /********************************************************************/
    class MyClass<T>{
        public void m1(T t){}
        public T m2(){
            return null;
        }
    }
    /********************************************************************/

