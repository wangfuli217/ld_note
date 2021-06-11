

经典算法：
1. 某学校为学生分配宿舍,每y个人一间房(不考虑性别差异),总人数x,问需要多少房？
答案：  int r = (x+y-1)/y;
注意理解int类型数值。在分页的时候有用。

2. 让数值在 0～9 之间循环。
public class test{
    public static void main(String[] args){
        int i=0;
        while(true){
            i = (i+1)%10;
            System.out.println(i);
        }
    }
}

