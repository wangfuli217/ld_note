
枚举 enum
    1、定义: 枚举是一个具有特定值的类型，对用户来说只能任取其一。
       对于面向对象来说时一个类的对象已经创建好，用户不能新生枚举对象，只能选择一个已经生成的对象。
    2、枚举本质上也是一个类。枚举值之间用逗号分开，以分号结束(如果后面没有其它语句，分号可不写)。
    3、枚举分为两种: 类型安全的枚举模式和类型不安全的枚举模式
    4、枚举的超类(父类)是: Java.lang.Enum 。枚举是 final 类所以不能继承或被继承。但可以实现接口。
       枚举中可以写构造方法，但构造方法必需是私有的，而且默认也是 私有的 private
    5、一个枚举值实际上是一个公开静态的常量，也是这个类的一个对象。
    6、枚举中可以定义抽象方法，但实现在各个枚举值中(匿名内部类的方式隐含继承)
       由于枚举默认是 final 型，不能被继承，所以不能直接用抽象方法(抽象方法必须被继承)
       在枚举中定义抽象方法后，需要在自己的每个枚举值中实现抽象方法。

    枚举是编译期语法，编译后生成类型安全的普通类
    values()静态方法，返回枚举的元素数组
    name方法

/************** 旧版本时自定义枚举 *************************/
final class Season1{    //用 final 不让人继承
   private Season1(){}  //用 private 构造方法，不让人 new 出来
   public static final Season1 SPRING=new Season1("春");
   public static final Season1 SUMMER=new Season1("夏");
   public static final Season1 AUTUMN=new Season1("秋");
   public static final Season1 WINTER=new Season1("冬");
   String name; //将"春夏秋冬"设为本类型，而不是24种基本类型，为防止值被更改
   private Season1(String name){
      this.name=name;
    }
   public String getName(){
      return this.name;
}}
/************** 旧版本时自定义枚举 end *************************/

/************** 新版本的枚举 *************************/
enum Season2{
   SPRING("春"), SUMMER("夏"),  AUTUMN("秋"),  WINTER("冬");
   final String name;
   Season2(String name){ this.name=name; }
   public String getName(){return this.name;}
}
//注意: 枚举类是有序的；如: Season2.SPRING.ordinal(),从0开始
enum Season3{
   SPRING, SUMMER,  AUTUMN,  WINTER;
}
/************** 新版本的枚举 end *************************/


/**********************************************************/
/*******关于枚举的例子****************************************/
import static java.lang.System.*;
public class TestTeacher {
    public static void main(String[] args) {
        for(TarenaTeacher t:TarenaTeacher.values()){
            t.teach();
}}}
enum TarenaTeacher{
    LIUCY("liuchunyang"){void teach(){out.println(name+" teach UC");}},
    CHENZQ("chenzongquan"){void teach(){out.println(name+" teach C++");}},
    HAIGE("wanghaige"){void teach(){out.println(name+" teach OOAD");}};
    String name;
    TarenaTeacher(String name){this.name=name;}
    abstract void teach();
}
/**********************************************************/
enum Animals {
    DOG ("WangWang") ,  CAT("meow") ,  FISH("burble");
    String  sound;
    Animals ( String s ) { sound = s; }
}
    class TestEnum {
    static  Animals  a;
        public static void main ( String[] args ) {
            System.out.println ( a.DOG.sound + " " + a.FISH.sound );
}}
/**********************************************************/

