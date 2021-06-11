#ifndef __FN_H__
#define __FN_H__

#ifdef __cplusplus 
extern "C" {
#endif

extern int bbb; // g++编译器变量的导出声明已经要加extern，否则就是重复定义

void show_me();


#ifdef __cplusplus 
}
#endif

#endif