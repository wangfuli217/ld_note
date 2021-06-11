void typedef_st(void){
	typedef struct student{
		int age;
		char sex;
	} Stu_st,*Stu_pst; 
	struct student stu1={23,'f'};
	Stu_st stu2={24,'m'}; //与 stu1 的定义形式等价
	struct student *stu3=&stu1;
	Stu_pst stu4=&stu2; //与 stu3 的定义形式等价
}
// 虽然看起来很奇怪，但是只要将 struct student { ... } 和 struct student { ... } * 看作成一个整体，
// 对整体进行命名就容易理解了


// typedef 与 const
void typedef_const_st(void){
	typedef struct student{
		int age;
		char sex;
	} *Stu_pst; 
	struct student stutmp1={23,'f'},stutmp2={24,'m'};
	const Stu_pst stu1=&stutmp1; //const 在前的定义 , 参考之前的const使用方法，如果将 Stu_pst 与 typedef struct student { ... } * 进行简单替换，理论上const 修饰的是 *stu1 从而限定的是 stu1 指的对象，即stu1指的对象不能改变，stu1本身应该可以改变值  
	Stu_pst const stu2=&stutmp2; //const 在后的定义 , 参考之前的const使用方法，如果将 Stu_pst 与 typedef struct student { ... } * 进行简单替换，理论上const 修饰的是 stu2 从而限定的是 stu2 本身，即stu2本身不能改变，stu2指的对象应该可以改变值
	stu1->age=12; 
	stu1->sex='m'; //结果stu1所指的对象可以接受修改
	stu2->age=13;
	stu2->sex='f'; 
	//stu1=&stutmp2; //error C2166: l-value specifies const object //stu1 本身不能修改，stu1所指的对象反而可以接受修改，说明了const修饰的其实是指针变量本身，与stu2的一样
	//stu2=&stutmp1; //error C2166: l-value specifies const object 
}
// 这个实验结果与我们之前的理解有些出入，原因是 typedef struct student { ... } * 被编译器当作了一个整体，
// 解释的过程中，Stu_pst 是一个类型名，被忽略掉，从而直接修饰了指针本身

// typedef 与 #define
#if 0
#define INT32 int
unsigned INT32 i=10;
typedef int int32;
//unsigned int32 k=10; //error C2061: syntax error : identifier 'k'
				//error C2059: syntax error : ';'
				//error C2513: '/*global*/ ' : no variable declared before '='
typedef static int intx; //error C2159: more than one storage class specified
int32 j=10;
intx l=11;
#endif

#include <stdio.h>

int main(void){
    typedef_st();
    typedef_const_st();
    return 0;
}

