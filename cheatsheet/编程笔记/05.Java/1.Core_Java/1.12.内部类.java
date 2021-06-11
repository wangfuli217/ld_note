
内部类(nested classes)

1.  定义: 定义在其它类中的类，叫内部类(内置类)。
    内部类是一种编译时的语法,编译后生成的两个类是独立的两个类。
    内部类配合接口使用,来强制做到弱耦合(局部内部类，或私有成员内部类)。

2.  内部类存在的意义在于可以自由的访问外部类的任何成员(包括私有成员),但外部类不能直接访问内部类的成员。
    所有使用内部类的地方都可以不使用内部类;
    使用内部类可以使程序更加的简洁(但牺牲可读性),便于命名规范和划分层次结构。

3. 内部类和外部类在编译时是不同的两个类，内部类对外部类没有任何依赖。

4. 内部类可用 static,protected 和 private 修饰。(而外部类只能使用 public 和 default)。

5. 内部类的分类: 成员内部类、局部内部类、静态内部类、匿名内部类。
      (注意: 前三种内部类与变量类似，可以对照参考变量)
    ① 成员内部类(实例内部类): 作为外部类的一个成员存在，与外部类的属性、方法并列。
        成员内部类可看作外部类的实例变量。
        在内部类中访问实例变量: this.属性
        在内部类访问外部类的实例变量: 外部类名.this.属性。
        对于一个名为 outer 的外部类和其内部定义的名为 inner 的内部类。
            编译完成后出现 outer.class 和 outer$inner.class 两类。
        不可以有静态属性和方法(final 的除外),因为 static 在加载类的时候创建,这时内部类还没被创建
        如果在外部类的外部访问内部类，使用out.inner.***
    建立内部类对象时应注意:
        在创建成员内部类的实例时，外部类的实例必须存在:
        在外部类的内部可以直接使用inner s=new inner();  因为外部类知道 inner 是哪个类。
        而在外部类的外部，要生成一个内部类对象，需要通过外部类对象生成。
            Outer.Inner in = new Outer().new Inner();
            相当于: Outer out = new Outer(); Outer.Inner in = out.new Inner();
        错误的定义方式: Outer.Inner in=new Outer.Inner()。

    ② 局部内部类: 在方法中定义的内部类称为局部内部类。
        类似局部变量，不可加修饰符 public、protected 和 private，其范围为定义它的代码块。
        可以访问外部类的所有成员，此外，还可以访问所在方法中的 final 类型的参数和变量。
        在类外不可直接生成局部内部类(保证局部内部类对外是不可见的)。
        要想使用局部内部类时需要生成对象，对象调用方法，在方法中才能调用其局部内部类。
        局部内部类不能声明接口和枚举。

    ③ 静态内部类: (也叫嵌套类)
        静态内部类定义在类中，在任何方法外，用 static 定义。
        静态内部类能直接访问外部类的静态成员；
        不能直接访问外部类的实例成员,但可通过外部类的实例(new 对象)来访问。
        静态内部类里面可以定义静态成员(其它内部类不可以)。
        生成(new)一个静态内部类不需要外部类成员，这是静态内部类和成员内部类的区别。
            静态内部类的对象可以直接生成:  Outer.Inner in=new Outer.Inner()；
            对比成员内部类: Outer.Inner in = Outer.new Inner();
            而不需要通过生成外部类对象来生成。这样实际上使静态内部类成为了一个顶级类。
        静态内部类不可用 private 来进行定义。例子:

对于两个类，拥有相同的方法:
/*************************************************************************/
   /*class People{void run();}
   interface Machine{void run();}
       此时有一个robot类:
   class Robot extends People implement Machine.
       此时run()不可直接实现。*/

interface Machine {
    void run();
}
class Person {
    void run(){System.out.println("run");}
}

class Robot extends Person {
    private class MachineHeart implements Machine {
        public void run(){System.out.println("heart run");}
    }
    public void run(){System.out.println("Robot run");}
    Machine getMachine(){return new MachineHeart();}
}

class Test{
    public static void main(String[] args){
        Robot robot=new Robot();
        Machine m=robot.getMachine();
        m.run();
        robot.run();
    }
}
/*************************************************************************/

        注意: 当类与接口(或者是接口与接口)发生方法命名冲突的时候，此时必须使用内部类来实现。
        这是唯一一种必须使用内部类的情况。
        用接口不能完全地实现多继承，用接口配合内部类才能实现真正的多继承。

    ④ 匿名内部类:
         【1】匿名内部类是一种特殊的局部内部类，它是通过匿名类实现接口。
         【2】不同的是他是用一种隐含的方式实现一个接口或继承一个类，而且他只需要一个对象
         【3】在继承这个类时，根本就没有打算添加任何方法。
         【4】匿名内部类大部分情况都是为了实现接口的回调。
    注: 匿名内部类一定是在 new 的后面
       其隐含实现一个接口或实现一个类,没有类名,根据多态,我们使用其父类名。
        因其为局部内部类，那么局部内部类的所有限制都对其生效。
        匿名内部类是唯一一种无构造方法类。
        注: 这是因为构造器的名字必须和类名相同，而匿名内部类没有类名。
        匿名内部类在编译的时候由系统自动起名Out$1.class。
        因匿名内部类无构造方法，所以其使用范围非常的有限。
        结尾需加上分号。

匿名内部类的例子:
    /*************************************************************************/
public class test{
    public static void main(String[] args){
        B.print(new A() {
            public void getConnection(){ System.out.println("Connection....");}
        });
    }
}

interface A {
    void getConnection();
}
class B {
    public static void print(A a){ a.getConnection();}
}
    /*************************************************************************/

    枚举和接口可以在类的内部定义，但不能在方法内部定义。
    接口里面还可以定义多重接口和类。
    类放在什么位置，就相当于什么成员。


内部类的用途:
    封装类型: 把标准公开，把标准的实现者作为内部类隐藏起来，
            强制要求使用者通过标准访问标准的实现者，从而强制做到弱耦合!
    直接访问外部类的成员
    配合接口，实现多继承，当父类和接口方法定义发生冲突的时候，就必须借助内部类来区分
    模板回调


从内部类继承:
    由于直接构造实例内部类时，JVM会自动使内部类实例引用它的外部类实例。
    但如果下面Sample类通过以下方式构造对象时: Sample s = new Sample()；
    JVM无法决定Sample实例引用哪个Outer实例，为了避免这种错误的发生，在编译阶段，java编译器会要求Sample类的构造方法必须通过参数传递一个Outer实例的引用，然后在构造方法中调用super语句来建立Sample实例与Outer实例的关联关系。
/*************************************************************************/
public class Sample extends Outer.Inner{
    //public Sample(){} //编译错误
    public Sample(Outer o){  o.super();  }
    public static void main(String args[]){
        Outer outer1=new Outer(1);
        Outer outer2=new Outer(2);
        Outer.Inner in=outer1.new Inner();
        in.print();
        Sample s1=new Sample(outer1);
        Sample s2=new Sample(outer2);
        s1.print();  //打印a=1
        s2.print();  //打印a=2
    }
}
/*************************************************************************/

内部接口:
    在一个类中也可以定义内部接口
    在接口中可以定义静态内部类，此时静态内部类位于接口的命名空间中。
    在接口中还可以定义接口，这种接口默认也是 public static 的，如Map.Entry就是这种接口

