
异常 Exception
1. 概念:  JAVA将所有的错误封装成为一个对象，其根本父类为Throwable。异常处理可以提高我们系统的容错性。
  Throwable 有两个子类: Error 和Exception。

  Error:一般是底层的不可恢复的错误。
           Object
             ↑
          Throwable
             ↑
        ┌---------┐
     Error      Exception
                   ↑                非RuntimeException
           ┌-----------------------┬---------------┐
        RuntimeException   InterruptedException  IOException
              ↑
        ┌----------------------┬-----------...
   NullpointerException  ArrayIndexOutOfBoundsException

2. Exception分类:
   Runtime exception(未检查异常)和 非Runtime exception(已检查异常)。
   未检查异常是因为程序员没有进行必要的检查,因为他的疏忽和错误而引起的异常。可避免。
    几个常见的未检查异常:
     ①java.lang.ArithmeticException           //如: 分母为0;
     ②java.lang.NullPointerException          //如: 空指针操作;
     ③java.lang.ArrayIndexoutofBoundsExceptio //如: 数组越界；数组没有这元素；
     ④java.lang.ClassCastException            //如: 类型转换异常;
    已检查异常是不可避免的，对于已检查异常必须处理。

3、异常对象的传递。
   当一个方法中出现了异常而又没做任何处理，则这个方法会返回该异常对象。
   异常依次向上层调用者传递，直到传到JVM，虚拟机退出。  (用一句话说就是沿着方法调用链反向传递)
   应该在合适的位置处理异常，不让它一直上抛到 main 方法，应遵循的规则:
      谁知情谁处理，谁负责谁处理，谁导致谁处理。

4、如何来处理异常(这里主要是针对已检查异常)
    【1】 throws 消极处理异常的方式。
        方法名(参数表)throws 后面接要往上层抛的异常。
        表示该方法对指定的异常不作任何处理，直接抛往上一层。
    【2】积极处理方式 try、catch
        try {可能出现错误的代码块} catch(exception e){进行处理的代码} ；
         一个异常捕获只会匹配一次 try,catch.
         一个异常一旦被捕获就不存在了。
        catch 中要求必须先捕获子类异常再捕获父类异常。 catch 要求有零到多个，但异常的名字不能重复。
    【3】 finally (紧接在 catch 代码块后面)
        finally 的代码块是无论如何都会被执行的(除非虚拟机退出)，所以里面一般写释放资源的代码。
        return 也无法阻止 finally,但System.exit(0):退出虚拟机则可以。

      有 finally 的 try/catch 流程
      如果 try 块失败了，抛出异常，程序马上转移到 catch 块，完成后执行 finally 块，再执行其后程序。
      如果 try 块成功，程序跳过 catch 块并去到 finally 块，finally 块完成后，继续执行其后程序。
      如果 try 或 catch 块有 return 语句, finally 还是会执行；程序会跳去执行 finally 块然后再回到 return 语句
/********** 使用try/catch的例子 ********************************************/
class MyException{
     void myException(){
        System.out.println("MyException");
//        if(1==1)return;   //测试没有异常时
        System.out.println(1/0);
    }
    public static void main(String[] args) {
        MyException me = new MyException();
        try{
            System.out.println("try");
//            if(1==1)return;
            me.myException();
        }catch(ArithmeticException ae){
            System.out.println("cath");
        }finally{
            System.out.println("finally");
        }
    }
}
/*************************************************************************/

5、自定义异常(与一般异常的用法没有区别)
class MyException extends Exception{
   public MyException(String message){ super(message);}
   public MyException(){}
}

6、如何控制 try 的范围
   根据操作的连动性和相关性，如果前面的程序代码块抛出的错误影响了后面程序代码的运行，
   那么这个我们就说这两个程序代码存在关联，应该放在同一个 try 中。

7、不允许子类比父类抛出更多的异常。

8、断言: 只能用于代码调试时用。
  一般没什么用，只在测试程序时用
    /********* 断言的列子 ******************************************************/
public class TestAssertion {
   public static void main(String[] args){
      int i = Integer.parseInt(args[0]);
      assert i==1:"ABCDEFG";   //格式:  assert (布尔表达式/布尔值) : String;
      /*断言语句: (表示断言该boolean语句返回值一定为真，如果断言结果为false就会报Error错误)
        “ : ”后面跟出现断言错误时要打印的断言信息。 */
      System.out.println(i);
   }
}

//javac -source 1.4 TestAssertion.java     //表示用1.4的新特性来编译该程序。
//java -ea TestAssertion 0                 //表示运行时要用到断言工具
    /*************************************************************************/
