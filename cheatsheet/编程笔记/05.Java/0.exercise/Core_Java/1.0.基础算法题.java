

2，给定一个百分制的分数，输出相应的等级。
        90分以上        A级
        80~89          B级
        70~79          C级
        60~69          D级
        60分以下        E级

import java.util.Scanner;
class Mark{
    public static void main(String[] args){
        System.out.println("请输入一个分数");
        //定义输入的分数为“mark”，且分数会有小数
        double mark;
        Scanner scanner = new Scanner(System.in);
        mark = scanner.nextDouble();

        //判断是否有输入错误。
        if(mark<0||mark>100){
           System.out.println("输入有误！ ");
           System.exit(0);
        }
        /*判断分数的等级
        90分以上者A级， 80~89分者 B级，70~79分者 C级， 60~69者 D级，60分以下 E级 */
        if (mark>=90) System.out.println("this mark is grade \'A\' ");
        else if (mark>=80) System.out.println("this mark is grade \'B\' ");
        else if (mark>=70) System.out.println("this mark is grade \'C\' ");
        else if (mark>=60) System.out.println("this mark is grade \'D\' ");
        else  System.out.println("this mark is grade \'E\' ");
    }
}


3，编写程序求 1+3+5+7+……+99 的和值。

class he{
    public static void main(String[] args){
        int number = 1;  //初始值1，以后再+2递增上去
        int sum = 0;
        for ( ; number <100; number+=2 ){ sum += number; }
        System.out.println("1+3+5+7+……+99= " +sum);
    }
}


4、利用for循环打印 9*9  表?
1*1=1
1*2=2  2*2=4
1*3=3  2*3=6  3*3=9
1*4=4  2*4=8  3*4=12  4*4=16
1*5=5  2*5=10  3*5=15  4*5=20  5*5=25
1*6=6  2*6=12  3*6=18  4*6=24  5*6=30  6*6=36
1*7=7  2*7=14  3*7=21  4*7=28  5*7=35  6*7=42  7*7=49
1*8=8  2*8=16  3*8=24  4*8=32  5*8=40  6*8=48  7*8=56  8*8=64
1*9=9  2*9=18  3*9=27  4*9=36  5*9=45  6*9=54  7*9=63  8*9=72  9*9=81

//循环嵌套，打印九九表
public class NineNine{
    public static void main(String[]args){
    System.out.println();
    for (int j=1;j<10;j++){
        for(int k=1;k<10;k++) {   //老师的做法，判断语句里的 k<=j，省去下列的if语句。
            if (k>j) break;       //此处用 continue也可以，只是效率低一点
            System.out.print(" "+k+"X"+j+"="+j*k);
         }
        System.out.println();
        }
    }
}



6、输出所有的水仙花数，把谓水仙花数是指一个数3位数，其各各位数字立方和等于其本身，
   例如： 153 = 1*1*1 + 3*3*3 + 5*5*5

class DafodilNumber{
    public static void main(String[] args){
        System.out.println("以下是所有的水仙花数");
    int number = 100;     // 由于水仙花数是三位数，故由100开始算起

    int i, j, k;     // i  j  k  分别为number 的百位、十位、个位
    for (int sum; number<1000; number++){
        i=number/100;  j=(number-i*100)/10;  k=number-i*100-j*10;
        sum=i*i*i+j*j*j+k*k*k;
        if (sum==number) System.out.println(number+" is a dafodil number! ");
        }
    }
}


7、求  a+aa+aaa+.......+aaaaaaaaa=?
      其中a为1至9之中的一个数，项数也要可以指定。

import java.util.Scanner;
class Multinomial{
    public static void main(String[] args){
        int  a;      //定义输入的 a
        int  howMany;   //定义最后的一项有多少个数字
        Scanner scanner = new Scanner(System.in);
            System.out.println("请输入一个 1~9 的 a 值");
        a = scanner.nextInt();
            System.out.println("请问要相加多少项？");
        howMany = scanner.nextInt();
        int sum=0;
        int a1=a;  // 用来保存 a 的初始值
        for (int i=1; i<=howMany; i++){
            sum+= a;
            a = 10*a +a1;   // 这表示a 的下一项
        // 每次 a 的下一项都等于前一项*10，再加上刚输入时的 a ；注意，这时的 a 已经变化了。
            }
        System.out.println("sum="+sum);
    }
}


8、求 2/1+3/2+5/3+8/5+13/8.....前20项之和？

class Sum{
    public static void main(Sting[] args){
        double sum=0;
        double fenZi=2.0, fenMu=1.0;    //初始的分子 (fenZi)＝2，分母(fenMu)＝1
        for(int i=1; i<=20; i++){
            sum += fenZi / fenMu ;
            fenMu = fenZi;           //下一项的分母 ＝ 上一项的分子
            fenZi += fenMu;         //下一项的分子 ＝ 上一项的分子加分母
        }
        System.out.println("sum= "sum);
    }
}


9、利用程序输出如下图形:
   *
   * * *
   * * * * *
   * * * * * * *
   * * * * *
   * * *
   *

class Asterisk{
    public static void main(String[] args){
        for (int i=1; i<=13; i+=2){
            for(int j=1; j<=i && i+j<= 14; j++){System.out.print("* ");}
            System.out.println();  // 换行
        }
    }
}



12、输入一个数据n，计算斐波那契数列(Fibonacci)的第n个值
  1  1  2  3  5  8  13  21  34
  规律：一个数等于前两个数之和
//计算斐波那契数列(Fibonacci)的第n个值
public class Fibonacci{
    public static void main(String args[]){
        int n = Integer.parseInt(args[0]);
        int n1 = 1;//第一个数
        int n2 = 1;//第二个数
        int sum = 0;//和
        if(n<=0){
            System.out.println("参数错误!");
            return;
        }
        if(n<=2){
            sum = 1;
        }else{
            for(int i=3;i<=n;i++){
                sum = n1+n2;
                n1 = n2;
                n2 = sum;
            }
        }
        System.out.println(sum);
    }
}


//计算斐波那契数列(Fibonacci)的第n个值
//并把整个数列打印出来
public class FibonacciPrint{
    public static void main(String args[]){
        int n = Integer.parseInt(args[0]);
        FibonacciPrint t = new FibonacciPrint();
        for(int i=1;i<=n;i++){
            t.print(i);
        }
    }
    public void print(int n){
        int n1 = 1;//第一个数
        int n2 = 1;//第二个数
        int sum = 0;//和
        if(n<=0){
            System.out.println("参数错误!");
            return;
        }
        if(n<=2){
            sum = 1;
        }else{
            for(int i=3;i<=n;i++){
                sum = n1+n2;
                n1 = n2;
                n2 = sum;
            }
        }
        System.out.println(sum);
    }
}

13、求1-1/3+1/5-1/7+1/9......的值。
  a,求出前50项和值。
  b,求出最后一项绝对值小于1e-5的和值。



15、在屏幕上打印出n行的金字塔图案，如，若n=5,则图案如下：
        *
       ***
      *****
     *******
    *********

//打印金字塔图案
public class PrintStar{
    public static void main(String args[]){
        int col = Integer.parseInt(args[0]);
        for(int i=1;i<=col;i++){//i表示行数
            //打印空格
            for(int k=0;k<col-i;k++){
                System.out.print(" ");
            }
            //打印星星
            for(int m=0;m<2*i-1;m++){
                System.out.print("*");
            }
            System.out.println();
        }
    }
}

16、歌德巴赫猜想,任何一个大于六的偶数可以拆分成两个质数的和
  打印出所有的可能

//任何一个大于六的偶数可以拆分成两个质数的和
//打印出所有的可能
public class Gedebahe{
    public static void main(String args[]){
        int num = Integer.parseInt(args[0]);
        if(num<=6){
            System.out.println("参数错误!");
            return;
        }
        if(num%2!=0){
            System.out.println("参数错误!");
            return;
        }
        Gedebahe g = new Gedebahe();
        //1不是质数,2是偶数,因此从3开始循环
        for(int i=3;i<=num/2;i++){
            if(i%2==0){//如果为偶数,退出本次循环
                continue;
            }
            //当i与num-i都为质数时,满足条件,打印
            if(g.isPrime(i) && g.isPrime(num-i)){
                System.out.println(i+" + "+(num-i)+" = "+num);
            }
        }
    }

    //判断是否质数
    public boolean isPrime(int a){
        double top = Math.floor(Math.sqrt(a));
        for(int i = 2; (double)i < top; i++)
            if(a % i == 0)
                return false;
        return true;
    }
}



9,求一个3*3矩阵对角线元素之和


10,打印杨辉三角


11. 约梭芬杀人法
   把犯人围成一圈，每次从固定位置开始算起，杀掉第7个人，直到剩下最后一个。

11_2、用数组实现约瑟夫出圈问题。 n个人排成一圈，从第一个人开始报数，从1开始报，报到m的人出圈，剩下的人继续开始从1报数，直到所有的人都出圈为止。对于给定的n,m，求出所有人的出圈顺序。

