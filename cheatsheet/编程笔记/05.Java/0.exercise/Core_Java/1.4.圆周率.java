
11、计算圆周率
  PI＝4－4/3+4/5-4/7.......
  打印出第一个大于 3.1415小于 3.1416的值

class Pi {
    public static void main(String[] args){
        double pi =0;  //定义初始值
        double fenZi = 4;    //分子为4
        double fenMu = 1;  //第一个4，可看作分母为1 的分式，以后的分母每次递增2
        for (int i = 0; i < 1000000000; i++){ //运行老久，减少循环次数会快很多，只是精确度小些
            pi += (fenZi/fenMu) ;
            fenZi *= -1.0;    //每项分子的变化是+4，－4，+4，－4 ....
            fenMu += 2.0;    //分母的变化是1，3，5，7， ....   每项递加2
            }
        System.out.println(pi);
    }
}
输出结果为pi = 3.1415926525880504，应该不精确
