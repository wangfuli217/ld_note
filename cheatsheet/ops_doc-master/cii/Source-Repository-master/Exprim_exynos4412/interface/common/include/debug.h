#ifndef __DEBUG_H__
#define __DEBUG_H__

#ifdef DEBUG

#define desymbol(arg) 		printf("--DEBUG--:%d\t%s\n",__LINE__,arg) 

#define deprint(arg...)	 	printf("--DEBUG--:%s:%s:%d\t",__FILE__,__func__,__LINE__);\
							printf(arg);\
							printf("\n")

#define detobin(arg) 		printf("--DEBUG--:%s:%s:%d\t",__FILE__,__func__,__LINE__);\
							printf(#arg"\t:");	\
							tobin(arg)

#define detohex(arg1,arg2) 	printf("--DEBUG--:%s:%s:%d\t",__FILE__,__func__,__LINE__);\
							tohex(arg1,arg2)

#else

#define detobin(arg)  

#define desymbol(arg) 	 

#define deprint(arg...)	

#define detohex(arg1,arg2) 

#define detobin(arg) 		

#endif //DEBUG

#endif //__DEBUG_H__


