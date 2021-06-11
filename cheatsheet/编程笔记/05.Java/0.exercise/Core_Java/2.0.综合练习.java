


作业：
1. 写一个数组类（放对象）：
     功能包括：添加(添加不限制多少项)、修改、插入、删除、查询
 class MyArray{
         private Object[] os = new Object[10];
         public void add(Object o);
         public void set(int index, Object o);
         public void insert(int index, Objecto);
         public void remove(int index);
         public void remove(Object o);
         public Object get(int index);

 }

 public class TestMyArray{
     public static void main(String[]args){
         MyArray ma = new MyArray();
         ma.add("aaa");
         ma.add("bbb");
         ma.add("ccc");
         Object o = ma.get(1);
         Iterator it = ma.iterator();
         while(it.hasNext()){
             Object o1 = it.next();
             System.out.println(o1);
         }
     }
 }




作业 10-08
1. 随机产生 20 个整数(10以内的)，放入一个ArrayList中， 用迭代器遍历这个ArrayList
2. 并删除其中为 5 的数
3. 再产生 3 个整数，插入到位置 4 处
4. 把所有值为 1 的数都变成 10

import java.util.ArrayList;
class ArrayList{
         private Object[] os = new Object[20];

}

 public class TestArray{
     public static void main(String[]args){
         ArrayList a = new ArrayList();

         ma.add("aaa");
         ma.add("bbb");
         ma.add("ccc");
         Object o = ma.get(1);
         Iterator it = ma.iterator();
         while(it.hasNext()){
             Object o1 = it.next();
             System.out.println(o1);
         }
     }
 }


1. 产生 3000 个 10 以内的数，放入 hashSet
2. 遍历它，打印每一个值
import java.util.HashSet;
import java.util.Iterator;
import java.util.Random;
public class TestHashSet {
    public static void main(String[] args) {
        Random r = new Random();
        HashSet hs1 = new HashSet();
        for(int i=0; i<3000; i++){
            hs1.add(r.nextInt(10));
        }
        Iterator it1 = hs1.iterator();
        while(it1.hasNext()){
            System.out.print(it1.next()+" ");
        }
    }
}
//由于 HashSet 不能重复，所以只有10个数在里面，按哈希排序
2 4 9 8 6 1 3 7 5 0







/*
 * 测试TreeSet 的比较器，
 * 在有自己的比较器的情况下，如何实现Comparable接口
 */

import java.util.*;
class Teacher{
    int id;
    String name;
    int age;
    public Teacher() {}
    public Teacher(int id, String name, int age) {
        this.id = id;
        this.name = name;
        this.age = age;
    }
    public int getId() {    return id;    }
    public void setId(int id) {this.id = id;    }
    public String getName() {    return name;}
    public void setName(String name) {    this.name = name;}
    public int getAge() {return age;}
    public void setAge(int age) {this.age = age;}

    public int TeacherComparator(Object o){
        Teacher t1 = (Teacher) o;
        if(t1.getId() > id){return 1;}
        else if (t1.getId() < id){return -1;}
        return 0;
    }
}
class TreeSet{

}

class Test {
    public static void main(String[] args) {
        String s1 = new String("aaa");
        String s2 = new String("bbb");
        String s3 = new String("aaa");
        System.out.println(s1==s3);
        System.out.println(s1.equals(s3));

        HashSet hs = new HashSet();
        hs.add(s1);
        hs.add(s2);
        hs.add(s3);
        Iterator it = hs.iterator();
        while(it.hasNext()){
            System.out.println(it.next());
        }
        System.out.printf("%x\n",s1.hashCode());
        System.out.printf("%x\n",s2.hashCode());
        System.out.printf("%x\n",s3.hashCode());
    }
}



1. 在Map中，以name作Key，以Student类 作Velue，写一个HashMap
import java.util.*;
class Student{
    int id;
    String name;
    int age;
    public Student() {}
    public Student( int id, String name, int age) {
        this.id = id;
        this.name = name;
        this.age = age;
    }
    public int getId() {return id;}
    public void setId(int id) {this.id = id;}
    public String getName() {return name;}
    public void setName(String name) {this.name = name;}
    public int getAge() {return age;}
    public void setAge(int age) {this.age = age;}
}

class TestHashMap{
    public static void main(String[] args) {
        HashMap hm = new HashMap();
        Student s1 = new Student(1,"jacky",19);
        hm.put("jacky",s1);
        hm.put("tom",new Student(2,"tom",21));
        hm.put("kitty",new Student(3,"kitty",17));

        Iterator it = hm.keySet().iterator();
        while(it.hasNext()){
            Object key =  it.next();
            Student value = (Student) hm.get(key);
            System.out.println(key+":id="+value.id+",age="+value.age);
        }
        System.out.println("=============================");

        //比较 KeySet() 和 entrySet() 两种迭代方式
        for(Iterator i1 = hm.entrySet().iterator(); i1.hasNext(); )
        { Map.Entry me = (Map.Entry) i1.next();
       Student s = (Student) me.getValue();
            System.out.println(me.getKey()+": id="+s.id+" age="+s.age);
        }
    }
}




day13 homework
1.
/**********************************************************************************
自己写一个栈:     ( 先进后出 )
     建议底层用LinkedList实现
参照 java.util.Stack
方法:  boolean empty()  测试堆栈是否为空。
    E  peek()        查看栈顶对象而不移除它。
    E  pop()         移除栈顶对象并作为此函数的值返回该对象。
    E  push(E item)  把项压入栈顶。
    int     search(Object o)     返回对象在栈中的位置，以 1 为基数。
***************************************************************************************/
//不能用继承，因为它破坏封装。只需调用即可
import java.util.LinkedList;
class MyStack<E>{
    private LinkedList<E> list = new LinkedList<E>();
    public  boolean empty()     {return list.isEmpty();}
    public  E peek()            {return list.peek();   }
    public  E pop()             {return list.poll();   }
    public  void push(E o)      {list.addFirst(o);     }

    //int    indexOf(Object o) 返回此列表中首次出现的指定元素的索引，如果此列表中不包含该元素，则返回 -1。
    public  int search(Object o){return list.indexOf(o);}
}



2.
/***************************************************************************************
定义以下类，完成后面的问题，并验证。
Exam类   考试类
属性： 若干学生  一张考卷
提示：学生采用HashSet存放

Paper类   考卷类
属性：若干试题
提示：试题采用HashMap存放，key为String，表示题号，value为试题对象

Student类     学生类
属性：姓名   一张答卷   一张考卷  考试成绩

Question类    试题类
属性：题号 题目描述    若干选项    正确答案
提示：若干选项用ArrayList

AnswerSheet类    答卷类
属性：每道题的答案
提示：答卷中每道题的答案用HashMap存放，key为String，表示题号，value为学生的答案

问题：为Exam类添加一个方法，用来为所有学生判卷，并打印成绩排名（名次、姓名、成绩）
***************************************************************************************/

















3.
/***************************************************************************************
项目：商品管理系统
功能：增删改查 （可按各种属性查）
商品属性：名称、价格（两位小数）、种类
***************************************************************************************/










