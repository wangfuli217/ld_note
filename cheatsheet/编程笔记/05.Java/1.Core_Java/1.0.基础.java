
必须养成优秀程序员的编写习惯：缩进(用空格)、注释、命名约定。
大小写敏感。
单独的“；”代表一条空语句。
main函数是我们整个程序的执行入口所以必须是静态公开的。
       必须写成这样：  public static void main(String[]args){...}

生成jar包：
    在eclipse里，选中要打包的几个文件，右键-Export-写文件名-Next-Next-选main方法的class-finish
    在jar包的同一文件夹下，新建一个空文档，写“java -jar ./文件名.jar”，再把这文档改成“文件名.sh”
    把这sh的属性－权限 改成“允许以程序执行文件”。以后双击这个sh即可运行

文本注释 Comments：
    注释必须写上，以便其它人阅读、引用和维护。
    单行注释  //...
    多行注释  /* ....*/
    文档注释  /** ... */
    文档注释，可以使用JDK的javadoc工具从原文件中抽取这种注释形成程序的帮助文档。
    使用javadoc命令建立HTML格式的程序文档:
     javadoc[options][packagenames][sourcefiles][@files]

标示符：
    用来给一个类、变量或方法命名的符号
  标示符命名规则：
    1. 以字母，“_”和“$”开头。可以包含字母、数字、“_”和“$”。
       在实际应用中，应避免定义“$”开头的变量，因为这是表示特殊类型的。
    2. 大小写敏感
    3. 不能与保留关键字冲突
    4. 没有长度限制(暗示使用长的标示符，以便阅读。长名字可使用工具输入)
    5. 建议使用JavaBeans规则命名，并根据方法的目的，以 set、get、is、add 或 remove 开头。
  标示符命名约定：
    1. 类名、接口名：每个单词的首字母应该大写，尤其第一个单词的首字母应该大写。(驼峰规则)
        class  MyFirstClass
        interface  Weapon
    2. 字段、方法以及对象：第一个单词首字母应小写，其它单词首字母大写。(以便跟上面的有所区别)
        boolean isWoman
        void setName(String name)
    3. 常量：全部用大写字母表示。如果由几个单词组成，则由下画线连接。
        public final int  GREEN
        public final int  HEAD_ COUNT
    4. Java包(Package)：全部用小写字母。
        package  java.awt.event


java.lang.System.gc();  /  java.lang.Runtime.gc();
    垃圾回收的建议语句,只能建议而不能强制回收
    注意： System.gc(); 是静态方法，可直接调用。
          java.lang.Runtime.gc(); 不是静态方法，不能直接在main方法里调用

package 包
    目的：命名冲突，便于管理类
    运行时，先找到包所在目录，再执行“ 包名.类名”
import 导入。导入包内的类
    定义包之后，执行时：javac  -d 包的路径  类名.java
                    java  包名.类名
    import java.util.*; //表示导入java.util里面的所有类；但 import java.*; 则什么类都导不进
    用“*”表示导入当前包的类，不包括子包的类(可把包看作目录)。

声明规则
    ＊ 一个源代码文件最多只能有一个公共(public)类。
    ＊ 如果源文件包含公共类，则该文件名称应该与公共类名称相同。
    ＊ 一个文件只能有一个包语句，但是，可以有多个导入语句。
    ＊ 包语句（如果有的话）必须位于源文件的第一行。
    ＊ 导入语句（如果有的话）必须位于包之后，并且在类声明之前。
    ＊ 如果没有包语句，则导入语句必须是源文件最前面的语句。
    ＊ 包和导入语句应用于该文件中的所有类。
    ＊ 一个文件能够拥有多个非公共类。
    ＊ 没有公共类的文件没有任何命名限制。


输入：使用 Scanner 获取输入
    在J2SE 5.0中，可以使用java.util.Scanner类别取得使用者的输入
    可以使用这个工具的 next() 功能，来获取用户的输入
     import java.util.Scanner;
     Scanner s = new Scanner(System.in);
     System.out.println("请输入文字");
     System.out.printf("您输入了字符：  %s \r\n",  s.next());
     System.out.println("请输入数字");
     System.out.printf("您输入了数字： %d \r\n",  s.nextInt());

输入：使用 BufferedReader 取得输入  // 5.0之前的读取键盘的方法
    BufferedReader建构时接受java.io.Reader物件
    可使用java.io.InputStreamReader
    例: import java.io.InputStreamReader;
        import java.io.BufferedReader;
    class test{
    public static void main(String[] args){
       System.out.println("请输入一列文字");
       BufferedReader s = new BufferedReader(new InputStreamReader(System.in));
       String next;
       try{ next = s.readLine();  // 此语句会抛异常，需处理
          System.out.println("您输入了文字：" + next);
       }catch(Exception e){}
    }}


数值保存方式：
    正数＝  二进制
    负数＝  补码
    补码＝  反码 +1     正数＝负数的补码(反码+1)
    反码＝  非(二进制数)

八进制数，零开头        011(八进制)＝9(十进制)
十六进制数，零x开头    0x55(十六进制)＝5*16+5(十进制)

类型：数据都必须有类型
    boolean (8bit,不定的)只有true和false两个值
    char    16bit,   0~2^16-1     (2^16=6万6)
    byte    8bit,   -2^7~2^7-1    (2^7=128； 注意：两个 byte 数相加，变 int 型)
    short   16bit,  -2^15~2^15-1  (2^15=32768)
    int     32bit,  -2^31~2^31-1  (2147483648,20亿,10位有效数字)
    long    64bit,  -2^63~2^63-1  (900亿亿,20位有效数字)
    float   32bit,  9位有效数字，含小数(四舍五入)(小数点算一位，正负号不算)
    double  64bit,  18位有效数字(最大: 1.7e308)
             注：float 和 double 的小数部分不可能精确，只能近似。
                比较小数时，用 double i=0.01; if ( i - 0.01 < 1E-6) ...
                不能直接 if (i==0.01)...

默认，整数是int类型，小数是double类型
long类型值，需跟L或l在数据后；float类型要跟f或F；或强制类型转换
科学计数法：12.5E3

    类型转换默认序列：
    byte  >  short   > int  >  long   >  float  >  double
                   char 」
    注意：默认类型转换(自动类型提升)会丢失精度，但只有三种情况：
    int>float; long>float; long>double.   看一下他们的有效位就明白。
    二进制是无法精确的表示 0.1 的。
    进行高精度运算可以用java.math包中BigDecimal类中的方法。
    自动类型提升又称作隐式类型转换。

    强制类型转换：int ti;  (byte) ti ;
    强制转换，丢弃高位

    宣告变量名称的同时，加上“final”关键词来限定，这个变量一但指定了值，就不可以再改变它的值
    如：final int n1= 10;   n1=20;  这就会报错


输出命令：
   System.out.println()  会自动换行的打印
   System.out.print()    直接打印，不会自动换行
   System.out.printf()   可插入带 % 的输入类型,前两种只可以插入转义符, 不能插入 % 的数据或字符串
   在 printf 里面,输出有5个部分  %[argument_index$][flags][width][.precision]conversion
         以“％”开头，[第几个数值$][flags][宽度][.精确度][格式]
   printf()的引入是为了照顾c语言程序员的感情需要
         格式化输出 Formatter；格式化输入 Scanner；正则表达式

输出格式控制：
   转义符 (Escape Sequence)：
   \ddd     1到3位8进制数指定Unicode字符输出(ddd)
   \uxxxx   1到4位16进制数指定Unicode字符输出(xxxx)
   \\       \
   \'       '
   \"       "
   \b       退格(光标向左走一格)
   \f       走纸转页,换页
   \n       换行
   \r       光标回到行首，不换行
   \t       跳格

   %%       %
   %d       输出10进制整数，只能输出Byte、Short、 Integer、Long、或BigInteger类型。(输出其它类型会抛异常)
   %f       以10进制输出浮点数，提供的数必须是Float、Double或 BigDecimal (输出Integer类型也抛异常)
   %e,%E    以10进制输出浮点数，并使用科学记号，提供的数必须是Float、 Double或BigDecimal
   %a,%A    用科学记号输出浮点数,以16进制输出整数部份,以10进制输出指数部份,数据类型要求同上。
   %o       (字母o)以8进制整数方式输出，限数据类型:Byte,Short,Integer,Long或BigInteger
   %x,%X    将浮点数以16进制方式输出，数据类型要求同上
   %s,%S    将字符串格式化输出(可输出任何类型)
   %c,%C    以字符方式输出，提供的数必须是Byte、Short、Character或 Integer
   %b,%B    输出"true"或"false"(%B输出"TRUE"或"FALSE");另外,非空值输出true,空值输出 false
   %t,%T    输出日期/时间的前置，详请看API文档

/******** 找出各字符的 Unicode 值 *******************/
class Test {
	public static void main(String[] args) {
		String s = "" + 0 + 'a'; // 0=48,9=57
		// A=65,Z=90;a=97,z=122;空格=32
		int i = s.codePointAt(0);
		int j = s.codePointAt(1);
		// 利用这codePointAt(int index)方法
		System.out.printf("%d %d", i, j);
	}
}
/**********************************************/



运算：
    算术运算：   加( +)   减(－)    乘( * )     除( / )     取余( ％ )
        ％ 取余运算： 2%3=2     100%3=1
    赋值运算符：
      =     +=    -=    *=     /=     %=
      (先运行完右边的，再跟左边的进行赋值运算；如 int i=10;i-=5-3;结果8)
      <<=     >>=
    比较、条件运算：
        大于>   不小于>=    小于<   不大于<=    等于==    不等于 !=
    逻辑运算：
        短路运算(且 &&    或 ||  )      非短路运算(&   |  )      反相 !
        短路运算：当前面一个表达式可以决定结果时，后面的语句不用再判断。非短路运算时，还照样判断后面的
    位运算：
      &(AND)    |(OR)    ^(XOR异或)       ~(补码)按位取反 ＝ 加1再取反(全 1 的补码是-1)
    移位运算：
     >>   <<    >>>

     >>右移:全部向右移动,移到右段的低位被舍弃,最高位则移入原来最高位的值。右移一位相当于除2取商。
     >>>同上，只是最高位移入0(不带符号)。因为最高位是符号位，所以负数跟 >> 有区别，正数没区别。
     12>>>33  为12>>(33%32) ＝ 12>>1  =6；因为int 型只有32位，认为全移走后就没意义
     1 <<32 为1
    “＝＝”双等于号，比较数值是否相等。还可以用于比较两个引用，看他们引用的地址是否相等。
    在 Object 类里 equals() 跟“＝＝”功能一样；但可以重载定义一个比较两者意义是否相等的方法。
    在java里可以把赋值语句连在一起写，如： x=y=z=5;   这样就x,y,z都得到同样的数值 5


关系运算符: instanceof
    用户判断某一个对象是否属于某一个类的实例。
    1、 boolean c = a instanceof B; //a是某类的实例，而B是一个类。
    2、 一般用在强制类型转换之前判断对象变量是否可以强制转换为指定类型。


两个数相运算时，默认是 int 类型。如果有更高级的，就按高级的那个类型
   if(其中一个是 double 型)double型；
   else if(其中一个是 float 型)float型；
   else if(其中一个是 long 型)long型；
   else int 型。
   即是说: byte, short 类型运算时会转成 int, 哪怕两个 byte 类型的数相加。


选择：
    if(...){...}else{...}
    if(...){...}else if(...){...}else{...}
    if(...){... if(...){...}else{...}}else{...}

    三重以上的选择，建议使用 switch
    switch(char c){
        case c1: ...; break;
        case c2: ...; break;
        ...
        default :...;
    }

    记忆方法: switch 的括号里只能用 枚举 和 int 类型，以及能隐式转换为 int 的类型。
        如: byte,short,char,Integer,Byte,Short,Character 等,可以隐式转换成 int 的类型。
        不能用 long 、小数类型(float,double) 和 String 。
        case 后的值必须是常量。而包装类变量(Integer,Character)不会被视作常量。


循环：
   for (初始表达式;  布尔表达式 ;  增量 ) { 循环语句; }
     跟C的 for 一样，for 的初始化条件、结束条件、增量都可以不写。
    但条件判断部分只能是boolean值，所以只能是一条条件判断语句。
     for 循环一般用在循环次数已知的情况。
   while (<boolean expr>) { ...; }
   do { ...; } while (<condition>);   注意：do 后最好用“{}”，while 后的分号不可忘。

新型 for 循环 for-each, 用于追求数组与集合的遍历方式统一
    1、数组举例:
      int[]  ss  =  {1,2,3,4,5,6};
      for(int i=0; i<ss.length; i++){
         System.out.print(ss[i]);
      }  //以上是以前的 for 循环遍历，比较下面的for—each
      System.out.println();
      for(int i : ss){
          System.out.print(i);
    2、集合举例:
       List  ll  =  new ArrayList();
       for(Object  o : ll ){
          System.out.println(o);
        }
    注: 凡是实现了java.lang.Iterable接口的类就能用 for-each 遍历
    用 for each 时，不能用list.remove()删除，因为他内部的迭代器无法调用，造成多线程出错。
    这时只能用 for 配合迭代器使用。


break 和 continue
    break 退出当前的循环体，在嵌套循环中，只退出当前的一层循环。
    continue 结束当前本次循环，继续进行下一轮的循环。可以说，只是本次忽略循环内后面的语句。
    continue 只能在循环体内用。break 可以用在任意代码块中，表示退出当前程序块(配合标签使用，很好用)
    这两个相当于JAVA里的 goto 语句。

    注意：(个人归结的)
        循环体内申明的变量，在循环体结束后立即释放，循环体外无法使用。
        但在另外一个循环体内可以再次申明一个跟前面同名的变量，互相不影响。
            如for内定义的 i：  for(int i=0;i<10;i++){...}
            则在上式 for 循环结束后无法再调用 i 值，还会报错。
          for(int i=0;i<10;i++){...} 和后面的 for(int i=0;i<3;i++){...} 互不影响
        若想循环体外还可以调用 for 循环体内的值，应先在体外定义。
            如：  int i;   for (i=0; i<10; i++){...}   则for 循环后再调用 i 值，其值为10


关键字列表：
   abstract  boolean   break   byte     case    catch       char    class
   continue  default   do      double   else    extends     enum    false
   final     finally   float   for      if      implements  import  instanceof
   int       interface long    native   new     null        package private
   protected public    return  short    static  super       switch  synchronized
   this      throw     throws  transient true   try         void    volatile  while
Java 中 true,false 不是关键字,而是 boolean 类型的字面量。但也不能当作变量用。
所有的关键字都是小写, friendly, sizeof 不是java的关键字
保留字: const, goto. 这两个已经削去意义，但同样不能用作变量名。


对象序列化
    1. 定义: 把一个对象通过I/O流写到文件(持久性介质)上的过程叫做对象的序列化。
    2. 序列化接口: Serializable
        此接口没有任何的方法, 这样的接口称为标记接口。
    3. 不是所有对象都能序列化的, 只有实现了Serializable的类, 他的实例对象才是可序列化的。
    4. Java种定义了一套序列化规范, 对象的编码和解码方式都是已经定义好的。
    5. class ObjectOutputStream和ObjectInputStream也是带缓冲的过滤流, 使节点流直接获得输出对象
        可以用来向文件中写入八种基本数据类型和对象类型。
        最有用的方法:
        (1)writeObject(Object b)
        (2)readObject()返回读到的一个对象, 但是需要我们注意的是,该方法不会以返回null表示读到文件末尾。
            而是当读到文件末尾时会抛出一个IOException；
    6. 序列化一个对象并不一定会序列化该对象的父类对象
    7. 瞬间属性(临时属性)不参与序列化过程。
    8. 所有属性必须都是可序列化的, 特别是当有些属性本身也是对象的时候, 要尤其注意这一点。
       序列化的集合就要求集合中的每一个元素都是可序列化的。
    9. 用两次序列化把两个对象写到文件中(以追加的方式), 与用一次序列化把两个对象写进文件的大小是不同的。
       因为每次追加时都会在文件中加入开始标记和结束标记。所以对象的序列化不能以追加的方式写到文件中。


transient 关键字
    1. 用 transient 修饰的属性为临时属性。



《Java5.0新特性》
 四大点(枚举、泛型、注释、..)；5 小点(包装类、静态应用、可变长参数、for-each、..)
一、自动装箱 和 自动解箱技术
    装箱Autoboxing，也翻译作 封箱；解箱Unautoboxing(也译作 解封)
    1、自动装箱技术: 编译器会自动将简单类型转换成封装类型。
    2、编译器会自动将封装类型转换成简单类型
    3、注意: 自动装箱和自动解箱只会在必要的情况下执行。
       int 能隐式提升成 long; 但 Integer 不能隐式提升成 Long, 只能提升成 Number
       封装之后就成类，只能由子类转成父类；而 Integer 和 Long 是 Number 的不同子类。
       如:  int i; short s; Integer II; Short SS;
         可以 i=SS;   但不可以 II=s; //赋值时，右边的数先转成左边数的对应类型，再进行隐式类型提升

    说明: 实现了基本类型与外覆类之间的隐式转换。基本类型至外覆类的转换称为装箱，外覆类至基本类型的转换为解箱。
    这些类包括:
        Primitive Type Reference Type
        boolean Boolean
        byte Byte
        char Character
        short Short
        int Integer
        long Long
        float Float
        double Double


二、静态引用概念:
    用 import static 节省以后的书写。
        引入静态属性 import static java.lang.System.out;
        引入静态方法 import static java.lang.Math.random;
        import static 只能引入静态的方法或属性；不能只引入类或非静态的方法。
    如: import static java.lang.System.*;
     out.println(“a”);  //等于System.out.println("a"); 由于out是一个字段，所以不能更节省了
     如果 import static java.lang.System.gc; 则可以直接在程序中用 gc(); //等于System.gc();


三、可变长参数
    一个方法的参数列表中最多只能有一个可变长参数,而且这个变长参数必须是最后一个参数
    方法调用时只在必要时去匹配变长参数。
/**********变长参数的例子*************************************/
import static java.lang.System.*;//节省书写，System.out直接写out
public class TestVararg {
   public static void main(String... args) {
      m();
      m("Liucy");
      m("Liucy","Hiloo");
   }
   static void m(String... s){out.println("m(String...)");}
   //s可以看作是一个字符串数组String[] s
   static void m(){out.println("m()");}
   static void m(String s){out.println("m(String)");}
}  //m(String... s) 是最后匹配的
/**********************************************************/

