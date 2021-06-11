关键字：string.h sprintf atoi  fgets()
		指针数组 
		main函数形参
		 sscanf   atof

/* string.h */
不可以使用操作符操作字符串，应该使用一组标准函数
为了使用这些标准函数需要包含string.h头文件
strlen()	统计字符串里有效字符个数（有效字符 不包括'\0'）
		和sizeof关键字不同 sizeof包括'\0'
		size_t strlen(const char *s);
	       （typedef unsigned int size_t ）

strcat()	合并两个字符串
		有可能修改不属于数组的存储区，这会造成严重后果
		char *strcat(char *dest, const char *src);
		dest 目的对象, src 源对象

strncat()	功能和strcat类似，但是可以避免修改不属于数组的存储区
		char *strncat(char *dest, const char *src, size_t n);

strcmp()	比较两个字符串的大小  不同时比较ASCII码中大的为大
		返回值是 1 表示前一个字符串大，返回值是 -1 表示后一个字符串大
		返回值是 0 表示一样大
		int strcmp(const char *s1, const char *s2);

strncmp()	只能比较两个字符串中的前n个字符
		int strncmp(const char *s1, const char *s2, size_t n);

strcpy()	把字符串复制到字符数组里
		这个函数也可能修改不属于数组的存储区，这可能导致严重错误
		char *strcpy(char *dest, const char *src);

strncpy()	可以只拷贝字符串里的前n个字符
		char *strncpy(char *dest, const char *src, size_t n);

memset()	把字符数组里前n个存储区都设置成同一个字符
		void *memset(void *s, int ch, size_t n);
		函数解释：将s中前n个字节 （typedef unsigned int size_t ）
			 用 ch 替换并返回 s 。

strstr()	在一个大字符串里查找某个小字符串的位置
		返回值是小字符串中首字符的地址
		如果没有找到 返回的是空地址 NULL
		char *strstr(const char *haystack, const char *needle);
					   大字符串              小字符串

#include<stdio.h>
#include<string.h>
int main()
{
    char str[10]="xyz";

    int len =strlen(str);
    printf("长度是%d\n",len);
    printf("sizeof(str)is %d\n",sizeof(str));

    printf("%s\n",strcat(str,"abc"));
    printf("%s\n",str);

    printf("比较结果是%d\n",strcmp("abc","abd"));

    printf("%s\n",strcpy(str,"123456"));
    printf("%s\n",str);

    memset(str,'h',10);
    printf("%s\n",str);

    printf("%s\n",strstr("abcdefghijklmn","def"));
    //把返回值地址打印%s
    //打印%s 打印的是小字符串中首字符到最后的字符
    
    printf("%p\n",strstr("abcdefghikj","def"));
    return 0;
}

结果：	长度是3
	sizeof(str)is 10
	xyzabc
	xyzabc
	比较结果是-1
	123456
	123456
	hhhhhhhhhh
	defghijklmn
	0x80485a2

/*其他字符串相关函数 这些函数不包含在string.h 在stdio.h中 */
sprintf()	按格式把多个数字或字符打印到字符数组里形成字符串   数字或字符=>字符串
	  原型：int sprintf( char *buffer, const char *format, [ argument] … );
	  参数：buffer：char型指针，指向将要写入的字符串的缓冲区。
	      	format：格式化字符串。
	      	[argument]...：可选参数，可以是任何类型的数据。
		把argument里的字符按照format的格式存到buffer中
		返回写入buffer 的字符数，出错则返回-1. 如果 buffer 或 format 是空指针,
		且不出错而继续，函数将返回-1，并且 errno 会被设置为 EINVAL。

sscanf()	按格式从字符串里得到多个数字或字符并记录到存储区里  字符串=>数字或字符
	  原型：int sscanf(const char *buffer,const char *format,[argument ]...);
		buffer：存储的数据
		format：格式控制字符串
		argument：选择性设定字符串
		scanf会从buffer里读进数据，依照format的格式将数据写入到argument里。

#include<stdio.h>
int main()
{
    char str[20] = {0};
    printf("%d %g %c\n",34,5.4f,'u');
    sprintf(str,"%d%g%c\n",34,5.4f,'u');
    printf("%s",str);

    int num=0;
    float fnum=0.0f;
    char ch=0;
    sscanf("5.4 p 67","%g %c %d",&fnum,&ch,&num);
    printf("%c %d %g\n",ch,num,fnum);
    return 0;
}	

结果：	34 5.4 u
      	345.4u
	p 67 5.4


/*以下两个函数可以把字符串里的数字转换成数字类型*/
为了使用这两个函数需要包含stdlib.h头文件
atoi		可以把字符串里的整数转换成整数类型
		只转换字符串头几个整数，如果字符串中首字符不是整数，
		后面的整数也不会转换

atof		可以把字符串里的浮点数转换成双精度浮点类型
		只转换字符串里头几个浮点数，如果字符串中首字符不是浮点数，
		后面的浮点数也不会转换

#include<stdio.h>
#include<stdlib.h>
int main()
{
    int num = atoi("34ad8sgsd9");
    printf("num is %d\n",num);

    double dnum= atof("23.67dsgj8.4");
    printf("dnum is %lg\n",dnum);
    return 0;
}

结果：	num is 34
	dnum is 23.67

*********************************************************************

/*综合输入5个考试成绩 按字符串打印*/
#include<stdio.h>
#include<string.h>
int main()
{
    char temp[10]={0},grades[30]={0};
    int grade=0,num=0;
    for(num=1;num<=5;num++)
    {   
        printf("输入一个考试成绩：");
        scanf("%d",&grade);		//输入的数字
        sprintf(temp,"%d,",grade);	//把数字变成字符串存在temp字符数组中
        strcat(grades,temp);
    }   
    grades[strlen(grades)-1]=0;   //去掉最后一个 ，
    printf("结果是%s\n",grades);
    return 0;
}

***********************************************************************
/* fgets() */
fgets()函数可以从键盘得到一个字符串并记录到一个数组里
	这个函数可以避免出现scanf函数的问题 
	scanf必须把对应的都输入上，要不然会卡在输入缓冲区里
char *fgets(char *s, int size, FILE *stream);
这个函数需要三个参数
	1. 数组名称  (存字符的数组)
	2. 数组里存储区个数
	3. 用 stdin 表示键盘
#include<stdio.h>
int main()
{
    char str[10]={0};
    printf("输入一个字符串：");
    fgets(str,10,stdin);
    printf("%s\n",str);
    return 0;
}

如果用户输入的内容不足以充满数组
	则计算机把用户最后输入的回车字符也记录到数组里
如果输入内容超过数组容量就把后面的内容留在输入缓冲区里等待下次读取

每次使用完fgets函数后都需要清理输入缓冲区里可能存在的多余数据
	只有确保有多余数据的时候才应该清理
 	scanf("%*[^\n]");
        scanf("%*c");

#include<stdio.h>
#include<string.h>
int main()
{
    char str[10]={0};
    printf("输入一个字符串：");
    fgets(str,10,stdin);
    printf("%s\n",str);
    if(strlen(str)==9 && str[8]!='\n')    //strlen记录有效字符个数
    {   //可能输入8个字符和一个enter str[8]判断是不是回车（回车+‘\0’ 没有超过10个 不用清）
        scanf("%*[^\n]");
        scanf("%*c");
    }   
    printf("再输入一个字符串：");
    fgets(str,10,stdin);
    printf("%s\n",str);
    return 0;
}


/* 指针数组 */ 数组中的每个元素都是一个指针
指针数组中每个存储区是一个指针类型存储区
字符指针数组里包含多个字符类型指针
	每个指针可以用来代表一个字符串
字符指针数组就可以用来代表多个相关字符串

#include<stdio.h>
int main()
{
    char *strs[] = {"abc","def","ghi","jkl","mno"};
    int num=0;
    for(num=0;num<=4;num++)
    {   
        printf("%s\n",strs[num]);
    }   
    return 0;
}


/* main函数的形参 */
主函数的第二参数就是一个字符指针数组

#include<stdio.h>
int main(int argc,char *argv[])// 整数 字符指针数组
{
    int num =0; 
    for(num=0;num<=argc-1;num++)
    {   
        printf("%s\n",argv[num]);
    }   
    return 0;
}

~$./.a.out abcd cdab
./a.out
abcd
cdab

预习：	宏 
	条件编译
	多文件编程
作业：编写程序把考试成绩字符串中所有考试成绩的和计算出来并打印在屏幕上

/* 自己写的 */
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
int main()
{   
    char *exam[6]={"90","100","100","100","100"};
    int num=0,sum=0;
    for(num=0;num<5;num++)
    {
        sum+=atoi(exam[num]);
    }
    printf("%d\n",sum);
    return 0;
}



/* 老师写的 */
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
int main()
{   
    int sum=0;
    char grades[]="10,20,30,40,50,60";
    char *p_grade = grades;
    while(1)
    {   
        sum+=atoi(p_grade);
        p_grade=strstr(p_grade,",");
        if(!p_grade)
            break;
        p_grade++;
    }   
    printf("求和结果：%d\n",sum);
    return 0;
}







