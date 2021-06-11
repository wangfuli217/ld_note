关键字：结构体 typedef 结构体指针做形参 结构体指针做返回值  对齐 补齐

/*结构体*/
C语言里可以在一个存储区里存放多个相关数字
	这种存储区的类型叫做结构体，这种类型需要在程序中创建
结构体存储区里可以包含多个子存储区，每个子存储区可以用来记录一个数字
	不同子存储区的类型可以不同，子存储区也可以是结构体类型的
结构体声明语句用来创建结构体类型
结构体声明语句中需要使用 struct 关键字

结构体声明中的变量声明语句不会分配内存（可以写在头文件里）
	它们只是表示结构体内部的所有子存储区类型 
结构体类型可以用来声明结构体变量，
	结构体变量真正分配了内存，可以用来存放数字
struct 关键字和结构体类型名称合起来才可以作为类型名称使用
	struct info prn; //结构体变量声明

typedef 关键字可以用来给现有类型名称起别名
	别名可以代替原有类型名称使用	 typedef struct info person;
					person 代替 struct info	

可以把结构体声明语句和起别名的语句合并成一条语句
	这个时候可以省略结构体本身的名称
C语言里不允许结构体内部包含函数

结构体变量也应该初始化，采用数组初始化的语法进行初始化
	person prn1={20,1.73f,"abc"};

结构体变量通常不会作为整体使用，一次通常只使用其中某个子存储区
可以在结构体变量名称后加.再加子变量名称的方法表示结构体内部的某个子存储区

#include<stdio.h>
/*struct info{
    int age;
    float height;
    char name[10];
};
typedef struct info person;  */

typedef struct /*info*/{
    int age;
    float height;
    char name[10];
}person;
int main()
{
//  struct info prn; //结构体变量声明
    person prn1={20,1.73f,"abc"};
    person prn2={0};
    scanf("%d",&prn1.age);
    scanf("%g",&prn1.height);
    
    scanf("%*[^\n]");
    scanf("%*c");

//  scanf("%c",&prn1.name[0]);
//  scanf("%c",&prn1.name[1]);
//  scanf("%c",&prn1.name[2]); 可以这样赋值字符串：
//  scanf("%c",&prn1.name[3]);
    
    fgets(prn1.name,10,stdin);
    
    printf("age is %d\n",prn1.age);
    printf("height is %g\n",prn1.height);
    printf("name is %s\n",prn1.name);
    return 0;




同类型结构体变量之间可以直接赋值

结构体指针可以记录一个结构体存储区的地址
当结构体指针和结构体存储区捆绑以后
	可以在结构体指针后加->再加子存储区名称来表示这个子存储区

/***********************************************************************/
#include<stdio.h>
typedef struct{
    int age;
    float height;
    char name[10];
}person;
int main()
{
    person prn={19,1.17,"aada"};
    person *p_person = &prn;
    printf("%d\n",p_person->age);
    printf("%g\n",p_person->height);
    printf("%s\n",p_person->name);
    return 0;
}
/***************************************************************************/
/* 求两个点的中点 */
#include<stdio.h>
typedef struct{
    int row,col;
}pt;
typedef struct{
    pt pt1,pt2;
}rect;
int main()
{
    pt one={0,0};//指针和非指针公用
    pt two={0,0};//指针和非指针公用
    pt mid={0.0};//都要进行初始化 定结构体变量名
    /*scanf("%d",&one.row);
    scanf("%d",&one.col);
    scanf("%d",&two.row);
    scanf("%d",&two.col);
    mid.row=(one.row+two.row)/2;
    mid.col=(one.col+two.col)/2;
    printf("mid is %d,%d\n",mid.row,mid.col);*/
    pt *p_one=&one;
    pt *p_two=&two;
    pt *p_mid=&mid;
    scanf("%d%d",&(p_one->row),&(p_one->col));
    scanf("%d%d",&(p_two->row),&(p_two->col));
    p_mid->row=((p_one->row)+(p_two->row))/2;   //不用加* 
    p_mid->col=((p_one->col)+(p_two->col))/2;   //和指针数组加下标的效果一样
						//结构体取值 指 值的本身  不用再*取值
    printf("mid is %d %d\n",p_mid->row,p_mid->col);
    return 0;
}
/**********************************************************************************/


*结构体变量可以作为形式参数使用
采用结构体指针作为形式参数可以避免结构体做形式参数对时间和空间的浪费
结构体指针做形式参数时尽量加 const 关键字

#include<stdio.h>
typedef struct{
    int row,col;
}pt;
void print(const pt *p_pt)
{
    printf("(%d,%d)\n",p_pt->row,p_pt->col);
}
int main()
{
    pt pt1 ={4,7};
    print(&pt1);
    return 0;
}

可以把结构体变量的内容整个作为返回值使用，
	但这样也会造成时间和空间的浪费
可以用结构体存储区的地址作为返回值
	把结构体内容传递给调用函数，这样可以避免浪费
不可以把局部结构体变量的地址作为返回值使用

#include<stdio.h>
typedef struct{
    int row,col;
}pt;
void print(const pt *p_pt)
{
    printf("(%d,%d)\n",p_pt->row,p_pt->col);
}
pt* read(pt *p_pt)                            //需要修改捆绑存储区的内容 不能加const
{
    
    scanf("%d%d",&(p_pt->row),&(p_pt->col));
    return p_pt;
}
int main()
{
    pt pt1 ={0};
    pt *p_pt=NULL;
    p_pt=read(&pt1);
    print(p_pt);
    return 0;
}                                       //你要用什么就设什么
				   	//要用返回为int  就设置int类型的函数
					//要用返回为结构体指针 就设结构体指针的函数

/*计算长方形的面积*/
  1 #include<stdio.h>
  2 typedef struct{
  3     int row,col;
  4 }pt;
  5 typedef struct{
  6     pt pt1,pt2;
  7 }rect;

  8 int area(rect *p_rect)
  9 {
 10     int ret=(p_rect->pt1.row - p_rect->pt2.row) * (p_rect->pt1.col - p_rect->pt2.col);
 11     return ret >=0?ret:0-ret;
 12 }
 13 int main()
 14 {
 15     rect r={0};
 16     printf("输入长方形的位置：");
 17     scanf("%d%d%d%d",&(r.pt1.row),&(r.pt1.col),&(r.pt2.row),&(r.pt2.col));
 18     printf("%d\n",area(&r));
 19     return 0;
 20 }

/*计算两个点的中点 用调用函数的内存 并返回给调用函数*/
  1 #include<stdio.h>
  2 typedef struct{
  3     int row,col;
  4 }pt;

  5 pt *midd(const pt *p_d1,const pt *p_d2,pt *p_mid)
  6 {
  7     //static pt mid={0};
  8     //static pt *p_mid=NULL;
  9     p_mid->row=((p_d1->row)+(p_d2->row))/2;
 10     p_mid->col=((p_d1->col)+(p_d2->col))/2;
 11     return p_mid;
 12 }
 13 int main()
 14 {
 15     pt d1={0},d2={0},mid={0};
 16     pt *p_pt=NULL;
 17     printf("输入两个点");
 18     scanf("%d%d%d%d",&(d1.row),&(d1.col),&(d2.row),&(d2.co    l));
 19     p_pt=midd(&d1,&d2,&mid);
 20     printf("%d,%d\n",p_pt->row,p_pt->col);
 21     return 0;
 22 }

/*计算中点  用被调用函数的内存*/
  1 #include<stdio.h>
  2 typedef struct{
  3     int row,col;
  4 }pt;
  5 pt *midd(const pt *p_d1,const pt *p_d2)
  6 {
  7     static pt mid={0};
  8     static pt *p_mid=&mid;
  9     p_mid->row=((p_d1->row)+(p_d2->row))/2;
 10     p_mid->col=((p_d1->col)+(p_d2->col))/2;
 11     return p_mid;
 12 }
 13 int main()
 14 {
 15     pt d1={0},d2={0};
 16     pt *p_pt=NULL;
 17     printf("输入两个点");
 18     scanf("%d%d%d%d",&(d1.row),&(d1.col),&(d2.row),&(d2.col));
 19     p_pt=midd(&d1,&d2);
 20     printf("%d,%d\n",p_pt->row,p_pt->col);
 21     return 0;
 22 }


/*对齐 补齐*/   
了解这些 可以让结构体节省空间  
任何一个存储区的地址必须是它自身大小的整数倍
	（double 类型存储区的地址只需要是4的整数倍）
	这个规则叫做数据对齐
结构体内部子存储区通常也需要遵守数据对齐的规则
数据对齐会造成结构体内部各子存储区之间有空隙

结构体存储区的大小必须是它内部占地最大基本类型存储区大小的整数倍
	（如果占地最大基本类型是 double 类型则只需要是4的整数倍就可以了）
	这个规则叫做数据补齐
数据补齐会造成结构体后面有浪费的字节

预习：枚举 联合 二级指针 函数指针
	回调函数  动态内存分配
作业：编写函数从两个线段里挑出比较长的并返回给调用函数

/*自己写的*/
#include<stdio.h>
typedef struct{
    int a,b,a1,b1;
}cri;

int lg(const cri *y1,const cri *y2)
{
    int i=0,j=0;
    i=((y1->a)-(y1->a1))*((y1->a)-(y1->a1))+((y1->b)-(y1->b1))*((y1->b)-(y1->b1));
    j=((y2->a)-(y2->a1))*((y2->a)-(y2->a1))+((y2->b)-(y2->b1))*((y2->b)-(y2->b1));
    return i>j?1:2;
}

int main()
{
    cri y1={0},y2={0};
    int k=0;
    printf("输入线段坐标两点：");
    scanf("%d%d%d%d",&(y1.a),&(y1.b),&(y1.a1),&(y1.b1));
    printf("输入另一个线段坐标两点：");
    scanf("%d%d%d%d",&(y2.a),&(y2.b),&(y2.a1),&(y2.b1));
    k=lg(&y1,&y2);
    if(k==1)
        printf("第一线段长\n");
    else 
        printf("第二线段长\n");

    return 0;   
}

/*老师写的*/
#include <stdio.h>
typedef struct {
    int row, col;
} pt; 
typedef struct {
    pt pt1, pt2;
} line;
//计算线段长度平方的函数
int len2(const line *p_l) {
    return (p_l->pt1.row - p_l->pt2.row) * (p_l->pt1.row - p_l->pt2.row) + (p_l->pt1.col - p_l->pt2.col) * (p_l->pt1.col - p_l->pt2.col);
}
//挑出比较长线段的函数
const line *longer(const line *p_l1, const line *p_l2) {
    return len2(p_l1) > len2(p_l2) ? p_l1 : p_l2;
}
int main() {
    line l1 = {0}, l2 = {0};
    const line *p_l = NULL;
    printf("请输入一条线段的位置：");
    scanf("%d%d%d%d", &(l1.pt1.row), &(l1.pt1.col), &(l1.pt2.row), &(l1.pt2.col));
    printf("请输入另外一条线段的位置：");
    scanf("%d%d%d%d", &(l2.pt1.row), &(l2.pt1.col), &(l2.pt2.row), &(l2.pt2.col));
    p_l = longer(&l1, &l2);
    printf("结果是((%d, %d), (%d , %d))\n", p_l->pt1.row, p_l->pt1.col, p_l->pt2.row, p_l->pt2.col);
    return 0;
}


