
字符串的拼接：
    字符串+数值＝字符串
    数值+字符串＝字符串
    如：str+10+20 ＝＝str1020   而 10+20+str ＝＝30str
    str1 = str1.concat(str2);   与这语句同效： str1 = str1 + str2;
    "+" 和 "+=" 都被重载了，具有合并字符串的能力，相当于 String 类里的 concat()；

字符串的长度：length()方法获取

StringBuffer 字符串：
    注：位置从0开始
    1) charAt方法 可取字符串中的一个元素。  // char charAt(int index)
    2) setCharAt方法 可更改字符串中的某个元素。 // char setCharAt(int index,char c)
      例： StringBuffer sb = new StringBuffer("abcd");
      sb.setCharAt(2,'j'); //把'c'改成'j'
    3) length方法，取得长度。 //int length()
    4) setLength方法，更改长度。//void setLength(int newLength)
       当增加字符串长度时，会在原字符串后加上null；缩短时则删除多出部分
    5) capacity方法，取得字符串占用空间的大小。一般比length方法大一些，用法一样。 // int capacity()
    6) append方法，在后面加入字符，如果加入其它类型会自动转换成字符串。加入后，缓冲区的长度会增加。
       // StringBuffer append(String str)
    7) insert方法，在指定位置插入字符串，原位置的元素往后移。
       //StringBuffer insert(int offset, String str)
       //StringBuffer insert(int offset, char c)
    8) delete方法，删除指定字符。
       //StringBuffer delete(int start,int end); 从start开始删除到end-1位置
    9) replace方法，代替指定位置的字符串。若指定位置不存在，则加到后面；字符串会因代替的内容而改变长度。
       //StringBuffer replace(int start, int end, String str) 从start开始到end-1位置，替换为 str
       例： StringBuffer sb = new StringBuffer("abcd");
            sb.append("efg");  //用法跟 String的concat 不同，它不需返回
        sb.insert(3," java "); //结果：abc java defg
        sb.delete(6,10);  //结果：abc jaefg
    10) 小积累：
        在 String 中想加入双引号，可用单引号括起一个双引号，再加进去。如：str += '"'; // char 类型
        也可以用转义符，如: str += "dd\"dd";


String 与 StringBuffer 的转换：
   //String 转成 StringBuffer
   String s1 = "String1";
   StringBuffer sb1 = new StringBuffer(s1);

   //StringBuffer 转成 String
   StringBuffer sb2 = new StringBuffer("String2");
   String str2 = sb2.toString();


字符串拼接的效率:
     String str="1"+"2"+"3"＋"4";
    产生:   12    123    1234
    这在串池中产生多余对象，而我们真正需要的只有最后一个对象，这种方式在时间和空间上都造成相当大的浪费。
    所以我们应该使用 StringBuffer(线程安全的) 或者 StringBuilder(线程不安全的)来解决。
    StringBuffer 类(java.lang下的)。

    解决方案:
      StringBuffer sb = new StringBuffer("1");
      Sb.append("2");
      Sb.append("3");
      Sb.append("4");
      String str = sb.toString();
    解决后的方案比解决前在运行的时间上快2个数量级。


StringBuilder (1.5版本后出现的)
    线程不安全的，在多线程并发时会出现问题。但仍是字符串合并的首选。
    运行效率比 StringBuffer 快一倍。


分析字符串工具 java.util. StringTokenizer;
    1.string tokenizer 类允许应用程序将字符串分解为标记
    2.可以在创建时指定, 也可以根据每个标记来指定分隔符(分隔标记的字符)集合。
    3.StringTokenizer(s,":") 用“: ”隔开字符, s 为String对象。
/*********************************************************/
import java.util.StringTokenizer;
public class TestStringTokenizer {
    public static void main(String[] args) {
        String s = "Hello:Tarena:Chenzq";
        StringTokenizer st = new StringTokenizer(s,":");
        while(st.hasMoreTokens()){
            String str = st.nextToken();
            System.out.println(str);
        }
    }
}
/********************************************************/

