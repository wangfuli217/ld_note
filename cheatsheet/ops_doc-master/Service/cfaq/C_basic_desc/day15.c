关键字：calloc  文件操作 fopen fclose fread fwrite fprintf 
	文件的位置指针 SEEK_SET ftell rewind fseek
		      SEEK_CUR
		      SEEK_END	
/* calloc */
calloc函数也可以动态分配内存
	它可以把所有动态分配存储区的内容设置成0
为了使用这个函数也需要包含stdlib.h头文件
它的返回值和malloc函数的返回值一样
它需要两个参数，第一个参数表示要分配的存储区的个数
	第二个参数表示单个存储区的大小
void *calloc(size_t nmemb, size_t size);

realloc函数调整动态分配内存的大小
尽量少使用这个函数
void *realloc(void *ptr, size_t size);

/* 文件操作 */
文件里一定采用二进制方式记录数字
如果文件里所有字节都是字符的ASCII码这种文件
	叫做文本文件
文本文件以外的文件叫做二进制文件

所有文件都可以采用二进制方式操作

文件操作步骤
1. 打开文件(fopen)
2. 操作文件(fread/fwrite)
3. 关闭文件(fclose)

fopen函数需要两个参数
1. 代表要打开的文件路径
2. 代表打开方式(决定程序中可以怎么使用文件)

FILE *fopen(const char *path, const char *mode);

打开方式有如下选择
"r"	只能查看文件内容而且只能从文件头开始
	要求文件已经存在，如果不存在就打开失败
"r+"	比"r"多了修改功能
"w"	只能修改文件内容而且只能从文件头开始修改
	如果文件还不存在就创建文件
	如果文件已经存在就删除文件内容
"w+"	比"w"多了查看功能
"a"	修改文件 只能在文件末尾追加新内容 	/*append*/
	如果文件不存在就创建文件
	如果文件存在就保留原有内容
"a+"	比"a"多了查看功能

"b"也是一种打开方式
	它可以和上面任何一种打开方式混合使用
	它表示以二进制方式操作文件

fopen函数的返回值是文件指针，
	只有文件指针才可以在程序中代表文件
fopen函数有可能失败，如果失败返回值是 NULL

一旦完成对文件的操作后必须使用fclose函数关闭文件
fclose函数需要文件指针作为参数
文件关闭后文件指针成为野指针，必须恢复成空指针


/* 文件操作框架 */
#include<stdio.h>
int main()
{      //把返回的文件指针放在 FILE结构体指针里
    FILE *p_file=fopen("a.txt","w");// 文件路径，文件操作方式
    if(p_file)                   			//需要检验是否打开成功
    {   
        //文件打开成功，操作文件
        fclose(p_file); //关闭文件
        p_file=NULL;
    }   
    return 0;
}


文件操作分成两种
1. 把内存中一组连续存储区的内容拷贝到文件里(写文件)
2. 从文件中把一组连续存储区的内容拷贝到内存里(读文件)

fread函数可以以二进制的方式对文件进行读操作
fwrite函数可以以二进制的方式对文件进行写操作

size_t fread(void *ptr, size_t size, size_t nmemb, FILE *stream);

size_t fwrite(const void *ptr, size_t size, size_t nmemb, FILE *stream);


这两个函数都需要四个参数
1. 内存里第一个存储区的地址
2. 内存里单个存储区的大小
3. 希望操作的存储区的个数
4. 文件指针

**它们的返回值表示实际操作的存储区个数

/*写数据到文件 是二进制文件*/
#include<stdio.h>
int main()
{
    int arr[]={1,2,3,4,5},size=0;
    FILE *p_file = fopen("a.bin","wb");
    if(p_file)
    {   
        size=fwrite(arr,sizeof(int),5,p_file);
        printf("size is %d\n",size);
        fclose(p_file);
        p_file=NULL;
    }   
    return 0;
}
结果： size is 5
/*从文件读数据 是二进制文件*/
#include<stdio.h>
int main()
{
    FILE *p_file=fopen("a.bin","rb");
    if(p_file)
    {   
        int arr[5]={0},i=0;
        fread(arr,sizeof(int),5,p_file);
        for(i=0;i<=4;i++)
            printf("%d ",arr[i]);
        printf("\n");
        fclose(p_file);
        p_file=NULL;
    }   
    return 0;
}

/*写数据到文件 是文本文件 文本文件写进去的必须是字符*/
#include<stdio.h>
#include<string.h>
int main()
{
    char str[]="1 2 3 4 5";
    FILE *p_file=fopen("a.txt","wb");
    if(p_file)
    {   
        fwrite(str,sizeof(char),strlen(str),p_file);
        fclose(p_file);
        p_file=NULL;
    }   
    return 0;
}

/* fprintf() */
fprintf函数按照格式把数据记录到文本文件里      //到文本里
	这个函数的第一个参数是一个文件指针，
	其他参数和printf函数一样

int fprintf(FILE *stream, const char *format, ...);

#include<stdio.h>
int main()
{
    int arr[]={1,2,3,4,5},i=0;
    FILE *p_file=fopen("b.txt","w");
    if(p_file)
    {   
        for(i=0;i<=4;i++)
            fprintf(p_file,"%d ",arr[i]);
        fclose(p_file);
        p_file=NULL;
    }   
    return 0;
}


/* fscanf */
fscanf函数可以按照格式从文本文件里获得数据并记录到存储区里   //从文本里出来
	这个函数的第一个参数是一个文件指针，
	其他参数和scanf函数一样

int fscanf(FILE *stream, const char *format, ...);

#include<stdio.h>
int main()
{
    int i=0,j=0;
    FILE *p_file=fopen("b.txt","r");
    if(p_file)
    {   
        for(i=0;i<=4;i++)
        {   
            fscanf(p_file,"%d",&j);
            printf("%d ",j);
        }   
        printf("\n");
        fclose(p_file);
        p_file=NULL;
    }   
    return 0;
}

/* 文件的位置指针 */
计算机里为每个打开的文件保留一个整数，
	这个整数表示下一次读写操作的开始位置
这个整数表示从文件头开始到这个位置为止中间包含的字节个数
这个整数叫做文件的位置指针
当从文件里获得n个字节或写入n个字节后这个整数会增加n


*ftell函数可以获得当前位置指针的数值

/**/
#include<stdio.h>
int main()
{
    char ch =0; 
    FILE *p_file= fopen("abc.txt","rb");
    if(p_file)
    {   
        printf("%ld\n",ftell(p_file));
        fread(&ch,sizeof(char),1,p_file);
        printf("%c\n",ch);
    
        printf("%ld\n",ftell(p_file));
        fread(&ch,sizeof(char),1,p_file);
        printf("%c\n",ch);
    
        printf("%ld\n",ftell(p_file));
        fread(&ch,sizeof(char),1,p_file);
        printf("%c\n",ch);
    
        fclose(p_file);
        p_file=NULL;
    }   
    return 0;
}
结果： 	0
	a
	1
	b
	2
	c


*rewind函数可以把位置指针的数值设置成 0


#include<stdio.h>
int main()
{
    char ch =0; 
    FILE *p_file= fopen("abc.txt","rb");
    if(p_file)
    {   
        rewind(p_file);
        printf("%ld\n",ftell(p_file));
        fread(&ch,sizeof(char),1,p_file);
        printf("%c\n",ch);
    
        rewind(p_file);
        printf("%ld\n",ftell(p_file));
        fread(&ch,sizeof(char),1,p_file);
        printf("%c\n",ch);
    
        rewind(p_file);
        printf("%ld\n",ftell(p_file));
        fread(&ch,sizeof(char),1,p_file);
        printf("%c\n",ch);
    
        fclose(p_file);
        p_file=NULL;
    }   
    return 0;
}

结果：	0
	a
	0
	a
	0
	a


fseek函数可以把位置指针设置成文件中的任何位置
	fseek函数使用时需要指定一个基准位置和目标位置到基准位置之间的距离
fseek(文件指针，距离，基准位置)

int fseek(FILE *stream, long offset, int whence);

/**/
SEEK_SET	0	把文件头作为基准位置
SEEK_CUR	1	把当前位置作为基准位置
SEER_END	2	把文件尾作为基准位置

如果目标位置在基准位置后则距离是正数
如果目标位置在基准位置前则距离是负数

距离的数字代表两个位置之间包含的字节个数

/*abc.txt a-z 文件尾里还有一个文件结束符*/
#include<stdio.h>
int main()
{
    char ch =0; 
    FILE *p_file= fopen("abc.txt","rb");
    if(p_file)
    {   
        fseek(p_file,2,SEEK_SET);
        printf("%ld\n",ftell(p_file));
        fread(&ch,sizeof(char),1,p_file);
        printf("%c\n",ch);
    
        fseek(p_file,4,SEEK_CUR);
        printf("%ld\n",ftell(p_file));
        fread(&ch,sizeof(char),1,p_file);
        printf("%c\n",ch);
    
        fseek(p_file,-16,SEEK_END);
        printf("%ld\n",ftell(p_file));
        fread(&ch,sizeof(char),1,p_file);
        printf("%c\n",ch);
    
        fclose(p_file);
        p_file=NULL;
    }   
    return 0;
}

结果：	2
	c
	7
	h
	11
	l


/*	编写一个模拟人员信息管理系统，
	系统可以把多个人员信息以二进制方式记录到文件里，
每个人员信息包含整数类型ID float类型的salary和最多9个字符的姓名 */
#include<stdio.h>
typedef struct{
	int id;
	float salary;
	char name[10];
}p_info;
int main()
{
	p_info A={0};
	int choice;
	FILE *p_file=fopen("info.bin","ab");
	if(p_file)
	{	
		while(1)
		{
			printf("请输入id：");
			scanf("%d",&(A.id));

			printf("请输入工资：");
			scanf("%g",&(A.salary));
			scanf("%*[^\n]");
			scanf("%*c");
			
			printf("请输入姓名：");
			fgets(A.name,10,stdin);
			//fwrite(&A,sizeof(p_info),18,p_file);
			fwrite(&A,sizeof(p_info),1,p_file); 
			//sizeof结构体是整个结构体大小

			printf("是否需要输入下一个人员信息？0表示不需要，1表示需要");
			scanf("%d",&choice);
			if(!choice)
				break;

		}
		fclose(p_file);
		p_file=NULL;
	}
	return 0;
}



作业：编写程序从person.bin文件里得到所有人员id
	    并把它们打印在屏幕上

/* 自己写的 */
#include<stdio.h>
int main()
{
    char i=0;
    int j=0;
    int arr[100]={};
    FILE *p_file=fopen("person.bin","rb");
    if(p_file)
    {   

        for(i=0,j=0;;i+=20,j++)
        {   
        fseek(p_file,i,SEEK_SET);
        fread(&arr[j],sizeof(int),1,p_file);  //读了一个int 4个字节
        if(arr[j]==0)
            break;
        printf("%d",arr[j]);
        printf("\n");
        }   

/*      fseek(p_file,0,SEEK_SET);
        fread(&arr[0],sizeof(int),1,p_file);
        printf("%d",arr[0]);
        printf("\n");
        printf("%ld\n",ftell(p_file));  */  //指针指向4
    
        fclose(p_file);
        p_file=NULL;
    }   
    return 0;
}


/*老师写的 good*/
#include<stdio.h>
typedef struct{
    int id; 
    float salary;
    char name[10];
}person;
int main()
{
    int id=0;
    FILE *p_file=fopen("person.bin","rb");
    if(p_file)
    {   
        while(1)
        {   
            if(!fread(&id,sizeof(int),1,p_file))// fread返回值表示实际操作存储区的个数
                break;
            printf("id is %d\n",id);
            fseek(p_file,sizeof(person)-sizeof(int),SEEK_CUR);
        }   
        fclose(p_file);
        p_file=NULL;
    }   
    return 0;
}

