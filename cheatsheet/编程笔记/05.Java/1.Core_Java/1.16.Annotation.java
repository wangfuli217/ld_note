
注释 Annotation
1、定义: Annotation描述代码的代码(给机器看的)。
     区别: 描述代码的文字，给人看的，英语里叫Comments。
     任何地方都可以使用Annotation注释，它相当于一段代码，可用来作自动检测。
     一个注释其实是一种类型(类class，接口interface，枚举enum，注释Annotation)，注释本质上是接口。
     定义注释 public @interface Test{}，注释都是Annotation接口的子接口

2、注释的分类:
  (1)、标记注释: 没有任何属性的注释。@注释名
  (2)、单值注释: 只有一个属性的注释。@注释名(value="***")
       在单值注释中如果只有一个属性且属性名就是value，则"value＝"可以省略。
  (3)、多值注释: 有多个属性的注释。多值注释又叫普通注释。
       @注释名(多个属性附值，中间用逗号隔开)

3、内置注释(java.lang):
  (1)、@Override(只能用来注释方法)
       表示一个方法声明打算重写超类中的另一个方法声明。
       如果方法利用此注释类型进行注解但没有重写超类方法，则编译器会生成一条错误消息。
  (2)、@Deprecated
       有 @Deprecated 注释的程序元素，不鼓励程序员使用，通常是因为它很危险或存在更好的选择。
       在使用不被赞成的程序元素或在不被赞成的代码中执行重写时，编译器会发出警告。
  (3)、@SuppressWarnings(抑制警告，该注释效果与版本相关)
        指示应该在注释元素(以及包含在该注释元素中的所有程序元素)中取消显示指定的编译器警告。

4、自定义注释
  (1)、定义注释类型
        自定义注释默认就是java.lang.annotation.Annotation接口的子接口。注释本质上就是一个接口。
        public @interface TestAnnotation {}
  (2)、为注释添加注释
        import java.lang.annotation.*;
        @Documented //能在帮助文档里出现
        @Inherited  //能否被继承下去
        @Retention(value = {RetentionPolicy.RUNTIME}) //注释该注释运行时仍然保留
         //@Retention默认是CLASS(保留到编译期)，最短期是SOURCE(原代码级，编译时丢弃)
        @Target(value={ElementType.METHOD,ElementType.FIELD})
        /*用来注释该注释能用来注释方法和属性，还可以定义它用来注释其它的，如类、注释、构造方法等等*/
        /*如果不写Target，默认是可以注释任何东西*/
        public @interface TestAnnotation {...}
  (3)、为注释添加属性方法
        import java.lang.annotation.*;
        @Target(value={ElementType.TYPE})
        public @interface TestAnnotation {
            //如果一个注释不是标记注释，则还要定义属性；这属性同时也是方法，但不可能有参数，只可以有默认值
            String parameter() default "liucy";
            //给属性方法parameter添加一个默认值"liucy"
            //parameter()括号里不能写其它东西，类型只能是24种基本类型之一
            //24种类型:8种基本数据类型、String、枚举、注释、Class、以及它们的一维数组
        }

        @TestAnnotation("haha")
        public class MyClass{...}

5、注释的注释: (元注释 meta annotation)
   都在 java.lang. annotation 包中
  (1)、Target: 指示注释类型所适用的程序元素的种类。
        一个注释只能出现在其该出现的位置，Target是给注释定位的。
        例: @Target(value = {ElementType.METHOD}); //说明该注释用来修饰方法。
  (2)、Retention: 指示注释类型的注释要保留多久。
        如果注释类型声明中不存在 Retention 注释，则保留策略默认为 RetentionPolicy.CLASS。
        例: Retention(value = {RetentionPolicy.xxx})
        当x为CLASS表示保留到类文件中，运行时抛弃。
        当x为RUNTIME表示运行时仍保留(最常用)
        当x为SOURCE时表示编译后丢弃。
  (3)、Documented: 指示某一类型的注释将通过 javadoc 和类似的默认工具进行文档化。
        应使用此类型来注释这些类型的声明: 其注释会影响由其客户端注释的元素的使用。
  (4)、Inherited: 指示注释类型被自动继承。
        如果在注释类型声明中存在 Inherited 元注释，并且用户在某一类声明中查询该注释类型，
        同时该类声明中没有此类型的注释，则将在该类的超类中自动查询该注释类型。
   注: 在注释中，一个属性既是属性又是方法。


使用注释
/*********************************************/
Class c = Class.forName(args[0]);
Object o = c.newInstance();
Method[] ms = c.getMethods();
    for(Method m:ms) {
    //判断m方法上有没有Test注释
    if (m.isAnnotationPresent(Test.class)){
        //得到m之上Test注释parameter属性值
        Test t=m.getAnnotation(Test.class);
        String parameter=t.parameter();
        m.invoke(o,parameter);
    }
}
/*********************************************/

