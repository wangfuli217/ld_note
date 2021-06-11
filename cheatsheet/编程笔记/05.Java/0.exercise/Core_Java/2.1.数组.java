

第4章 数组
1. 定义一个int型的一维数组，包含10个元素，分别赋一些随机整数，然后求出所有元素的最大值，
最小值，平均值，和值，并输出出来。

class ArrayNumber{
    public static void main(String[] args){
        int[] arrayNumber;
        arrayNumber = new int[10];
    System.out.println("以下是随机的10个整数：");
        // 填入随机的 10个整数
        for (int i =0; i<arrayNumber.length; i++){
            arrayNumber[i] = (int)(100*Math.random());
            System.out.print(arrayNumber[i]+" ");
            }
        System.out.println();
        int max = arrayNumber[0];
        int min = arrayNumber[0];
        int sum = 0;
        for (int i =0; i<arrayNumber.length; i++){
            if(max < arrayNumber[i])
                max = arrayNumber[i];  //求最大值
            if(min > arrayNumber[i])
                min = arrayNumber[i];   //求最小值
            sum += arrayNumber[i];
            }
    System.out.println("其中 Max="+max+",Min="+min+",Sum="+sum+",Avg="+sum/10.0);
    }
}


2.定义一个int型的一维数组，包含10个元素，分别赋值为1~10， 然后将数组中的元素都向前移一个位置，
即，a[0]=a[1],a[1]=a[2],…最后一个元素的值是原来第一个元素的值，然后输出这个数组。

3. 定义一个int型的一维数组，包含40个元素，用来存储每个学员的成绩，循环产生40个0~100之间的随机整数，
将它们存储到一维数组中，然后统计成绩低于平均分的学员的人数，并输出出来。

4. （选做）承上题，将这40个成绩按照从高到低的顺序输出出来。

5,（选做）编写程序，将一个数组中的元素倒排过来。例如原数组为1，2，3，4，5；则倒排后数组中的值
为5，4，3，2，1。

6,要求定义一个int型数组a,包含100个元素,保存100个随机的4位数。再定义一个
   int型数组b，包含10个元素。统计a数组中的元素对10求余等于0的个数，保存
   到b[0]中；对10求余等于1的个数，保存到b[1]中，……依此类推。

class Remain{
    public  static void main( String[] args){
        int[] a = new int[100];

        //保存100个随机4位数到 a 中
        for (int i = 0;  i < a.length;  i++){
            a[i] = (int) (1000*Math.random());
        }

        //统计 a 数组中的元素对 10 求余的各个的数目
        int[] b = new int[10];
        int k,sum;
        for (int j = 0;  j < b.length;  j++){
            for (k=0,sum=0;  k < a.length;  k++){
                if ((a[k]%10)==j) sum++;
            }
            b[j] = sum;
            System.out.printf("b[%d]=%d\n",j,b[j]);
        }
    }
}


7,定义一个20*5的二维数组，用来存储某班级20位学员的5门课的成绩；这5门课
   按存储顺序依次为：core C++，coreJava，Servlet，JSP和EJB。
   （1）循环给二维数组的每一个元素赋0~100之间的随机整数。
   （2）按照列表的方式输出这些学员的每门课程的成绩。
   （3）要求编写程序求每个学员的总分，将其保留在另外一个一维数组中。
   （4）要求编写程序求所有学员的某门课程的平均分。

class Student{
    public static void main(String[] args ){
        int[][] mark = new int[20][5];
        // 给学生赋分数值，随机生成
        for ( int i = 0;  )
    }
}//未完成


 8,完成九宫格程序
    在井字形的格局中(只能是奇数格局)，放入数字(数字由)，使每行每列以及斜角线的和都相等

    经验规则：从 1 开始按顺序逐个填写； 1  放在第一行的中间位置；下一个数往右上角45度处填写；
        如果单边越界则按头尾相接地填；如果有填写冲突，则填到刚才位置的底下一格；
        如果有两边越界，则填到刚才位置的底下一格。

    个人认为，可以先把最中间的数填到九宫格的最中间位置；再按上面的规则逐个填写，而且
        填的时候还可以把头尾对应的数填到对应的格子中。(第 n 个值跟倒数第 n 个值对应，格局上以最中
        间格为轴心对应)
        这样就可以同时填两个数，效率比之前更高；其正确性有待数学论证(但多次实验之后都没发现有错)。
    九宫格的 1 至少还可以填在另外的三个位置，只是接下来的填写顺序需要相应改变；
    再根据九宫格的对称性，至少可以有8种不同的填写方式

import java.util.Scanner;
class NinePalace{
    public static void main(String[] args){
        // 定义 N 为九宫格的行列数，需要输入
        System.out.println("请输入九宫格的行列规模(只能是奇数的)");
        Scanner n = new Scanner(System.in);
        int N;

        //判断格局是否奇数 （可判断出偶数、负数 及小数）
        double d;
        while (true){
            d = n.nextDouble();
            N = (int)d;
            if ((d-N)>1.0E-4||N%2==0||N<0)
                {System.out.println("输入出错,格局只能是正奇数。请重新输入");}
            else break;
        }

        //老师的九宫格填写方法
        int[][] result = new int[N][N];   //定义保存九宫格的数组
        int row = 0; //行 初始位置
        int col = N/2; //列 初始位置,因为列由0开始，故N/2是中间位置
        for (int i=1;  i<=N*N; i++){
            result [row][col] = i;
            row--;
            col++;
            if (row<0&&col>=N){col--;row+=2;} //行列都越界
            else if (row<0){ row = N-1;}   //行越界
            else if (col>=N){col = 0;}  //列越界
            else if (result[row][col] != 0){col--;row+=2;}  //有冲突
        }

        //打印出九宫格
        for (int i=0;  i<N;  i++){
            for(int j=0;  j<N; j++){System.out.print(result[i][j]+"\t");}
            System.out.println();
        }

        //我个人的填格方式
        int[][] result2 = new int[N][N];  //为免冲突，重新 new 一个数组
        result2[N/2][N/2] = (N*N+1)/2;  //先把中间值赋予中间位置
        row = 0;   //定义行及列的初始赋值位置。之前赋值的for对两个值有影响，故需重新定位
        col = N/2;
        for (int i=1; i<=N*N/2; i++){
            result2[row][col] = i;
            //下面这句是把跟 i 对应的值放到格局对应的位置上
            result2[N-row-1][N-col-1] = N*N+1-i;
            row--;
            col++;
            if (row<0){ row = N-1;}   //行越界
            else if (col>=N){col = 0;}  //列越界
            else if (result2[row][col] != 0){col--;row+=2;}  //有冲突
            //这方法不可能出现行列两边都越界的情况,详情需要数学论证
        }

        System.out.println();
        //再次打印出九宫格，以对比验证
        for (int i=0;  i<N;  i++){
            for(int j=0;  j<N; j++){System.out.print(result2[i][j]+"\t");}
            System.out.println();
        }

    }
}
