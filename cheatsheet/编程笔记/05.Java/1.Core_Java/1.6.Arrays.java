
数组:
    数组也是对象
    数组中保存着多个相同类型的元素
    数组中的每一个元素都是变量
        可以创建数组对象，但数组里只能放对象的引用，不能直接放对象进去


数组的创建:
    1. 声明一个int数组变量，数组变量是数组对象的遥控器
       int[] nums; //这数组不可以赋值，因为还没为它分配空间。
       注意:  int[] nums = new nums[]{}; 这种创建方法创出来的数组也不可以赋值。因为它的长度为零。
       上面两种方法创建的数组，使用时都需要分配空间:  nums = new int[]{1,25,4};或 nums=new int[4]再赋值。
    2. 创建大小为7的数组，并将它赋值给变量nums
       nums = new int[7];
    3. 赋于int数组每一个元素一个int值
       nums[0] = 6;  nums[1] = 34;  nums[2] = 23;  nums[3] = 4;


多维数组:
    1.  定义方式: type 维数　arrayName；
        如:   int[][]  b = new int [2] [1];
    2.  分配内存空间,有两种方法:
        直接为每一维分配空间:   int[][] a = new int[2][3]；
        分别为每一维分配空间    int[][] a = new int[2][ ]； //列数可以没有，行数则一定要有
            a[0] = new int[3];   a[1] = new int[5];    //a[][]  看成一维数组
         可以为每行设置为空间大小不同的数组。
    3. 初始化,有两种方式:
        先定义数组，分配空间，然后直接对每个元素进行赋值(一个个写，或用for函数)
        在定义数组的同时进行初始化。
              如: int a[][] = {{2,3}, {1,5}, {3,4}};
    java实质上把多维数组看作一维数组，但数组里的元素也是一个数组，即数组的数组
    多维数组的长度 ＝ 行数；  (a.length=行数； a[0].length=列数)


创建数组对象的另外几种方式:
    int[] nums = {6,34,23,4,15,0, 57}; (java 形式)
        这方法只能在初始化定义的时候可以，以后再想定义nums={...}就不行了

    int[] nums = new int[] {6,34,23,4,15,0, 57};
        这句的后一个 int[] 内不能填数字，怕人弄错数目；
        这句可以先 int[] nums;以后再另外定义 nums = new int[]{...}

    []可以换换位置，如:
      int nums[]; (C 和 C++ 形式)
   注意:  short  [] z [] []; //这是合法的，定义一个三维数组
        声明数组时，不能定义其大小；只有 new 数组时可以定大小。


数组元素的默认值:
    byte    short   int   long  为 0
    float   double 为 0.0
    char    为 '\0'
    boolean  为 false
    引用类型为 null


数组的 length 属性:
    表示数组的长度，是指这个数组最多能保存的元素个数
     length属性只能被读取，不能被修改
     java.lang.ArrayIndexOutOfBoundsException:  (这是数组下标越界的报错)


排序:
    import java.util.Arrays;
    Arrays.sort(数组)


数组的拷贝:
    1. 用 for 语句，将数组的元素逐个赋值。直接如果直接将数组 a = 数组b;则是将b的指针赋给a
    2. 用 System.arraycopy();
     arraycopy(Object src, int srcPos, Object dest, int destPos, int length)
       src - 源数组。
       srcPos - 源数组中的起始位置。
       dest - 目标数组。
       destPos - 目标数据中的起始位置。
       length - 要复制的数组元素的数量。
    如: System.arraycopy(a, 0, b, 0, a.length);  //把数组 a 全部复制到数组 b 中

