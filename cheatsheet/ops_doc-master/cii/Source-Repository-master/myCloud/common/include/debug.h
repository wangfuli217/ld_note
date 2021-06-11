#ifndef __DEBUG_H__
#define __DEBUG_H__
#include<stdio.h>

#ifdef DEBUG
#define desymbol(arg) fprintf(stderr,"--DEBUG--:%d\t%s\n",__LINE__,arg) 
#define deprint(arg...)	 	fprintf(stderr,"--DEBUG--:%s:%s:%d\t",__FILE__,__func__,__LINE__);\
							fprintf(stderr,arg);\
							putchar(10)
#define detohex(arg1,arg2) fprintf(stderr,"--DEBUG--:%s:%s:%d\t",__FILE__,__func__,__LINE__);\
							tohex(arg1,arg2)

#else
#define deprint(arg...)
#define detohex(arg1,arg2) 

#endif	//DEBUG


#define syserr(arg...) do{						\
						perror(arg);		\
						exit(-1);			\
						}while(0)

#endif	//__DEBUG_H__
