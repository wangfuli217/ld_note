
Reflection 反射
  1、反射主要用于工具的开发。所有的重要Java技术底层都会用到反射。反射是一个底层技术。
     是在运行时动态分析或使用一个类的工具(是一个能够分析类能力的程序)
  2、反射使我们能够在运行时决定对象的生成和对象的调用。
  3、Class
    (1)定义: 在程序运行期间，Java运行时系统始终为所有的对象维护一个被称为运行时的类型标识。
            虚拟机利用类型标识选用相应的方法执行。
            可以通过专门的类访问这些信息。保存这些信息的类被称为Class(类类)
    (2)类对象(类类:用于存储和一个类有关的所有信息),用来描述一个类的类。
        类信息通过流读到虚拟机中并以类对象的方式保存。
        一个类的类对象在堆里只有一个。
        注: 简单类型也有类对象。
        在反射中凡是有类型的东西，全部用类对象来表示。
  4. 获得类对象的3种方式:
    (1)通过类名获得类对象 Class c1 = String.class; //类.Class;
    (2)通过对象获得类对象 Class c2 = s.getClass(); //类对象.getClass();
    (3)通过Class.forName(“类的全名”)来获得类对象    //Class.forName(包名.类名);
        Class c3 = Class.forName(“Java.lang.String”);//这会强行加载类到内存里，前两种不加载
        注: 第三种方式是最常用最灵活的方式。第三种方式又叫强制类加载。
  5. java.lang.reflect.Field       对象，描述属性信息。
  6. java.lang.reflect.Constructor 描述构造方法信息。
  7. java.lang.reflect.Method      描述方法信息。
  8. 在反射中用什么来表示参数表？
     Class[] cs2 = {StringBuffer.class};//表示一个参数表
     Constructor c = c1.getConstructor(cs2);//返回一个唯一确定的构造方法。
     Class[] cs2 = {String.class,int.class}
     Method m = c1.getMethod(methodName,cs3);
  9. 可以通过类对象来生成一个类的对象。
     Object o = c.newInstance();
  10、反射是一个运行时的概念。反射可以大大提高程序的通用性。
一个关于反射的例子:
/*********************************************************/
import java.lang.reflect.*;
public class TestClass2 {
    public static void main(String[] args) throws Exception {
        //0.获得在命令行输入的类的类对象
        Class  c=Class.forName(args[0]);//需处理异常(ClassNotFoundException),输入类的全名(如: com.Student)
        //Object o=c.newInstance();//空参构造方法
        //1.得到构造方法对象
        Class[] cs1={String.class};
        Constructor con=c.getConstructor(cs1);
        //2.通过构造方法对象去构造对象
        Object[] os1={args[1]};//输入构造方法
        Object o=con.newInstance(os1);
        //3.得到方法对象
        String methodName=args[2];//输入方法名(如: study)
        Class[] cs2={String.class, int.class};//列表里对应各参数的类型
        Method m=c.getMethod(methodName,cs2);
        //4.调用方法
        Object[] os2={args[3], args[4]};//输入方法的各个参数(如: CoreJava,5)
        m.invoke(o,os2);

        /* 以上相当于知道类的情况时，这样直接用
         Student s=new Student("Liucy");
         s.study("CoreJava", 5); */
    }
}
/**********************************************************/

    下面是用反射调用私有方法的一个例子:
    /**********************************************************/
import java.lang.reflect.Method;
public class TestClass2 {
    public static void main(String[] args) throws Exception {
        Class c = Class.forName("test.AA");// 字符串为类的全名,如 com.my.AA
        Method[] m = c.getDeclaredMethods();// 读取它的全部方法
        //逐个的读取私有方法,由于是私有方法无法以名称读取
        for (int i=0; i<m.length; i++) {
            Method m1 = m[i];// 拿其中的第i个方法
            if ( !"print".equals(m1.getName()) ) continue;//相当于按名称来取
            m1.setAccessible(true);// 把private的属性设成可访问，否则不能访问
            Class[] cs2 = {String.class, int.class};// 列表里对应各参数的类型
            Object[] os2 = {"test", 5};// 输入方法的各个参数
            m1.invoke(c.newInstance(), os2);
        }
    }
}

class AA {
    private void print(String name, int i) {
        System.out.println("name:" + name + "  i:" + i);
    }
}
     /**********************************************************/
        //反射某类
        Class c = Class.forName("test.AA");// 字符串为类的全名,如 com.my.AA
        java.lang.reflect.Method[] m = c.getDeclaredMethods();// 读取它的全部方法
        //读取方法
        for (int i=0; i<m.length; i++) {
            java.lang.reflect.Method m1 = m[i];// 拿其中的第i个方法
            System.out.println("方法: " + m1.toGenericString());
        }
        //反射出所有的成员
        java.lang.reflect.Field[] f = c.getFields();
        for (int i=0; i<f.length; i++) {
            java.lang.reflect.Field f1 = f[i];// 拿其中的第i个方法
            System.out.println("属性: " + f1.getName() + " : " + f1.get(f1.getName()) + "<br/>");
        }
     /**********************************************************/


要求学会的内容:
    概念: 类类，类对象，类的对象，对象类(Object 类)
         类对象: Class, 指向类的对象。
         类对象包括: 属性对象 Feild，方法对象Method，构造方法对象 Constructor 。
    类对象能做什么: 探查类定义的所有信息: 父类，实现的接口，所有属性及方法，以及构造方法。
                 类的修饰符，属性以及方法的修饰符，方法的返回类型，方法的
                 ...
                 构造一个类的对象(类对象.newInstance())
                 强制修改和访问一个对象的所有属性(包括私有属性)
                 调用一个对象的方法(普通方法，静态方法)
                   Method.invoke(方法所在的对象(类对象, null),给方法传参数
                 ...
                 构造数组的另一种用法(动态构造数组，不定长度)

