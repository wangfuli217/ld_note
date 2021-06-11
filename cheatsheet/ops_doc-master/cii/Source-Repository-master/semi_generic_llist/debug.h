#ifndef __MACRO_TEST_H__
#define __MACRO_TEST_H__
#include<stdio.h>

#ifdef DEBUG
	#define debug(arg...)	 fprintf(stderr,"--DEBUG--:%s:%s:%d\n",__FILE__,__func__,__LINE__);\
							fprintf(stderr,"\t"arg)

#else
	#define debug(arg...) 

#define err(arg...) do{						\
						perror(arg);		\
						exit(-1)			\
						}while(0)

#endif	//DEBUG
#endif	//__MACRO_TEST_H__
