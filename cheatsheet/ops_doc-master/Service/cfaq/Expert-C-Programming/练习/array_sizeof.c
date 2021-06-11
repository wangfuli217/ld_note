#include <stdio.h> 

// 数组大小
void array_size(void){
	int a[5]={1,2,3,4,5};
	int i=sizeof(&a);       //20 这是一个地址，但为什么是20个字节的长度呢
	int j=sizeof(a);        //20 a作为一个首地址，为什么是20个字节的长度呢
	int k=sizeof(&a[0]);    //4
	int l=sizeof(&a[5]);    //4  及便这个元素不存在
    printf("sizeof &a=%d a=%d &a[0]=%d &a[5]=%d\n", i, j, k, l);
}
// 可以将它们的地址分别取出来看看

// 首地址
void array_header(void){
	int a[5]={1,2,3,4,5};
	int *ptr=(int *)(&a+1); // 一次性跳数组长度的字符个数
	printf("%d,%d\n",*(a+1),*(ptr-1)); // 2,5 
	printf("%x,%x,%x,%x,%x\n",a,&a,a+1,&a+1,ptr-1); //e08830e0,e08830e0,e08830e4,e08830f4,e08830f0
}
/*
对指针进行加1操作，得到的是连续内存中下一个元素的地址
一个类型为T的指针的移动，是以sizeof(T)为移动单位的
&a 与 a 的值是一样的，但是意思不一样
&a 是数组(结构体/构造体)的首地址
a 是数组首元素的首地址
&a+1，取数组a的首地址，该地址的值加上sizeof(a)的值，即&a+5*sizeof(int)
可以将a理解为结构体名，同时其值为&a[0]
a+1，是数组下一元素的首地址，即 a[1]的首地址
*/

void ptr_array(){
	char a[5]={'a','b','c','d','e'};
	char (*p1)[3]=&a;
	char (*p2)[3]=a;
	char (*p3)[10]=&a;
	char (*p4)[10]=a;
	printf("%x,%x,%x,%x,%x\n",a,p1+1,p2+1,p3+1,p4+1); //e08830d0,e08830d3,e08830d3,e08830da,e08830da
}
// 数组指针，是一个指针 ，但是它每次加一后，跳过的内存字节数为 n*sizeof(type)


// 地址的强制转换
void cast_type(){
	int a[4]={1,2,3,4};
	int *ptr1 =(int *)(&a+1);
	int *ptr2=(int *)((int)a+1);
	printf("%x,%x\n",ptr1[-1],*ptr2); // 4,2000000
}

// 二维数组
void array_2dis(){
	int a[3][2]={(0,1),(2,3),(4,5)};
	int *p;
	p=a[0];
	printf("%d\n",p[0]); //1
    printf("%d\n",p[1]); //3
    printf("%d %d %d %d\n", a[0][0], a[0][1], a[1][0], a[1][1]); //3
    printf("%x,%x,%x\n",a,a[0],&a[0][0]); 
    printf("%x,%x\n",p,p+1); 
}
// 这里千万要看清楚小括号里逗号分隔的表达式

void array_2dis_ref(){
	int a[5][5];
	int (*p)[4];
	p=a;
	printf("a_ptr=%#p,p_ptr=%#p\n",&a[4][2],&p[4][2]); // a_ptr=0X0018FF3C,p_ptr=0X0018FF2C
	printf("%p,%d\n",&p[4][2]-&a[4][2],&p[4][2]-&a[4][2]); //FFFFFFFC,-4
}
/*
&a[4][2] 表示 &a[0][0]+4*5*sizeof(int)+2*sizeof(int)
&p[4][2] 表示 &a[0][0]+4*4*sizeof(int)+2*sizeof(int)
所以差 4*sizeof(int) ，而地址相减获得的是此类型数据占用内存的单位数，所以，虽然相差16个字节，但是相差4个单位，一个int占4字节
*/

int main(void){
    array_size();
    array_header();
    ptr_array();
    //cast_type();
    array_2dis();
    array_2dis_ref();
    return 0;
}