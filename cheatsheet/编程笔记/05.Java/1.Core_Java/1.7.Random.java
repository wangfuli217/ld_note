
随机数:
   Math.random();  // (java.lang.Math)可以产生随机的0~1 的小数,不需导包
   java.util.Random;  // 可以产生更加多种的随机数

0~100的一个随机整数(包括0，但不包括100):
   Double d = 100*Math.random(); int r = d.intValue();  //方法一
   import java.util.Random; Random r = new Random();   int num = r.nextInt(100); //方法二
   可以直接在程序中写这句，而临时导入  int i = new java.util.Random().nextInt(100);



产生 Min - Max 之间的数字(int 或者 long 类型)
    实现原理： Math.round(Math.random()*(Max-Min)+Min)

	/**
	 * @param args
	 */
	public static void main(String[] args) {
        int min = 1000;
        int max = 9999;

        long temp = Math.round(Math.random()*(max-min)+min);
        System.out.println(temp);
	}

