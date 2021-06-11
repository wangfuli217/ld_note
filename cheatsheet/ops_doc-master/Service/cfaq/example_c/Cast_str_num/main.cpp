#include <stdio.h>
#include <string>
#include <iostream>
#include <sstream>
#include <stdlib.h>
#include <time.h>
#include <sys/time.h>

using namespace std;

string num2str(double i)
{
        stringstream ss;
        ss<<i;
        return ss.str();
}

int str2num(string s)
 {   
        int num;
        stringstream ss(s);
        ss>>num;
        return num;
}

int str2num_2()
{
	char    str[] = "15.455";
    int     i;
    float     fp;
    sscanf( str, "%d", &i );         // 将字符串转换成整数   i = 15
    sscanf( str, "%f", &fp );      // 将字符串转换成浮点数 fp = 15.455000
    //打印
    printf( "Integer: = %d ",  i+1 );
    printf( "Real: = %f\n",  fp+1 ); 
}

string num2str_2()
{
	int H, M, S;
	time_t seconds = time(NULL);
	H=seconds/3600;
	M=(seconds%3600)/60;
	S=(seconds%3600)%60;
	char ctime[10];
	sprintf(ctime, "%d:%d:%d", H, M, S);             // 将整数转换成字符串
	return ctime;                        
}

int
main()
{
	string str = "123456";
	int i = 99;
	
	printf("1:%s\n", num2str(99).c_str());
	printf("2:%d\n", str2num(str));
	
	str2num_2();
	
	printf("3:%s\n", num2str_2().c_str());
	
	system("pause");	
}