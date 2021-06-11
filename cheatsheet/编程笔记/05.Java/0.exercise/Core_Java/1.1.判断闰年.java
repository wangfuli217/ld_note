
1，编写程序，判断给定的某个年份是否是闰年。
      闰年的判断规则如下：
      （1）若某个年份能被4整除但不能被100整除，则是闰年。
      （2）若某个年份能被400整除，则也是闰年。

import java.util.Scanner;
class Bissextile{
    public static void main(String[] arge){
        System.out.print("请输入年份");
    int year;    //定义输入的年份名字为“year”
    Scanner scanner = new Scanner(System.in);
    year = scanner.nextInt();
    if (year<0||year>3000){
        System.out.println("年份有误，程序退出！");
        System.exit(0);
        }
    if ((year%4==0)&&(year%100!=0)||(year%400==0))
        System.out.println(year+" is bissextile");
    else
        System.out.println(year+" is not bissextile ");
    }
}







