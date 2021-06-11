/*
 * =====================================================================================
 *
 *       Filename:  teststrstr.c
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  10/22/2008 12:27:45 PM
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Zhenghua Dai (Zhenghua Dai), djx.zhenghua@gamil.com
 *        Company:  dzh
 *
 * =====================================================================================
 */
#ifndef MAIN_C
#define MAIN_C
#include <stdio.h>
#include <stdlib.h>
#include "rdtsc.h"
size_t strlen_d(const char *str) ;
size_t strlen_l(const char *str); 
size_t rb_strlen(const char *str); 
char *strstrBerg (const char* phaystack, const char* pneedle);
char *strstrToy (const char* phaystack, const char* pneedle);
char *lstrstr (const char* , const char* );
char *lstrstrsse (const char* , const char* );
char *lstrstr5 (const char* , const char* );
char* strstra(const char *str,char c);
void printstr(char* s)
{
	int i =0;
	printf(":");
	for(i=0;i<10;i++){
		if(s[i] ==0) goto ret;
		printf("%c",s[i]);
	}
	ret:
	printf("\n");

}
#define LOOPS 1
void test1(int argc,char** argv)
{
	FILE* fp;
	char* text;
	char* textm;
	int len = 1024*1024;
	char pattern[64];
	int testlen[20];
	int i;
	int textlen;
	int patlen;
	double t3;
	char* findp;
	textm = (char*) malloc(len+ 64);
	text = (char*)(((unsigned long long) textm ) & ~63)  +2;
	fp = fopen(argv[1],"r");
	if(fp ==NULL) exit(0);
	textlen=	fread(text,1,1024*1024,fp);
	text[textlen] = 0;
	fclose(fp);
	for(i=0;i<20;i++) testlen[i] =i;
	srand(clock());
	for(patlen = 1;patlen < 20; patlen++){
		int randloops = 0;
		int k;
		printf("*************************************\n");
		printf("%the pattern len is %d \n",patlen);
		randloops = rand() % 5 + 1;
		for(k =0;k < randloops;k++){
			int tmpstart = rand()% textlen;	
			while((tmpstart < textlen )&&(text[tmpstart] != ' ') )
				tmpstart ++;
				tmpstart ++;
				if(tmpstart >= textlen) continue;
			for(i=0; i< patlen; i++)
				pattern[i] = text[tmpstart + i];
			pattern[i] =0;
			printf("the pattern is :%s\n",pattern);

			mdtime(0);
			for(i=0;i<LOOPS;i++)
				findp = lstrstrsse(text,pattern);
			t3=	mdtime(1);
			printf("lstrsse   time:%15f :%d", t3,findp - text);
			printstr(findp);

			mdtime(0);
			for(i=0;i<LOOPS;i++)
				findp = strstr(text,pattern);
			t3=	mdtime(1);
			printf("strstr    time:%15f :%d", t3,findp - text);
			printstr(findp);
			printf("\n");
		}
	}

}

int test2( int argc, char** argv)
{
#include "defaultText.h"
	char text0[] = TEXT; 
	char* patterns[] = {"vulture","emente", "MArs","dog","Z","ABG","do","AGB"};				 
	char* pattern=patterns[0];
	//char* pattern="dog";
	//char* pattern="Z";
	//char* pattern = "emente";
	//char* pattern = "MArs";
	char* findp;
	char* textm;
	char* text;
	double t3;
	int i;
	int len = 1024*1024;//strlen(text0);
	//int len = strlen(text0);
	textm = (char*) malloc(len+ 64);
	text = (char*)(((unsigned long long) textm ) & ~63)  ;
	for(i=0;i<34;i++) 
	{
		int j=0;
		for(j=0;j<i;j++) text[i] = 'a';
		strcpy(text+i,text0);
		mdtime(0);
		findp = lstrstrsse(text,pattern);
		t3=	mdtime(1);
		printf("lstrsse   time:%15f :%d", t3,findp - text);
		printstr(findp);

	}
	strcpy(text,text0);
	//text = text0 ;
	//for(i=0;i<len;i++){text[i] ='a';}
	//text[i] =0;

	printf("\n");
	findp = lstrstr(text,pattern);
	mdtime(0);
	for(i=0;i<LOOPS;i++)
		findp = lstrstr(text,pattern);
	t3=	mdtime(1);
	printf("lstrstr   time:%15f :%d", t3,findp - text);
	printstr(findp);

	findp = lstrstrsse(text,pattern);
	mdtime(0);
	for(i=0;i<LOOPS;i++)
		findp = lstrstrsse(text,pattern);
	t3=	mdtime(1);
	printf("lstrsse   time:%15f :%d", t3,findp - text);
	printstr(findp);

	findp = strstr(text,pattern);
	mdtime(0);
	for(i=0;i<LOOPS;i++)
		findp = strstr(text,pattern);
	t3=	mdtime(1);
	printf("strstr    time:%15f :%d", t3,findp - text);
	printstr(findp);

	findp = strstrBerg(text,pattern);
	mdtime(0);
	for(i=0;i<LOOPS;i++)
		findp = strstrBerg(text,pattern);
	t3=	mdtime(1);
	printf("Bstrstr   time:%15f :%d", t3,findp - text);
	printstr(findp);

	findp = strstrToy(text,pattern);
	mdtime(0);
	for(i=0;i<LOOPS;i++)
		findp = strstrToy(text,pattern);
	t3=	mdtime(1);
	printf("strstrToy time:%15f :%d", t3,findp - text);
	printstr(findp);


	mdtime(0);
	for(i=0;i<LOOPS;i++)
		len = strlen_d(text);
	t3=	mdtime(1);
	printf("strlend time:%f :%d\n", t3,len);

	mdtime(0);
	for(i=0;i<LOOPS;i++)
		len = strlen(text);
	t3=	mdtime(1);
	printf("strlen  time:%f :%d\n", t3,len);

	mdtime(0);
	for(i=0;i<LOOPS;i++)
		len = strlen_l(text);
	t3=	mdtime(1);
	printf("strlenl time:%f :%d\n", t3,len);

	mdtime(0);
	for(i=0;i<LOOPS;i++)
		len = rb_strlen(text);
	t3=	mdtime(1);
	printf("strlenx time:%f :%d\n", t3,len);
}
int main( int argc, char** argv)
{
	test2(argc,argv);
	test1(argc,argv);
	return 1;
}
#endif
