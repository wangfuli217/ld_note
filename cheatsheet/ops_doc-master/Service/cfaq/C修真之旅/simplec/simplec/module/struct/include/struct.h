﻿#ifndef _H_SIMPLEC_STRUCT
#define _H_SIMPLEC_STRUCT

//
// 数据结构从此头文件开始
// 构建统一的标识, 注册函数, 基础头文件
//
// author : wz
//

#include <math.h>
#include <stdio.h>
#include <ctype.h>
#include <float.h>
#include <errno.h>
#include <limits.h>
#include <stdlib.h>
#include <assert.h>
#include <stddef.h>
#include <string.h>
#include <stdarg.h>
#include <stdbool.h>
#include <inttypes.h>

//
// CERR - 打印错误信息
// EXIT - 打印错误信息, 并 exit
// IF   - 条件判断异常退出的辅助宏
//
#define CERR(fmt, ...)                                                   \
fprintf(stderr, "[%s:%s:%d][%d:%s]" fmt "\n",                            \
    __FILE__, __func__, __LINE__, errno, strerror(errno), ##__VA_ARGS__)

#define EXIT(fmt, ...)                                                   \
do {                                                                     \
    CERR(fmt, ##__VA_ARGS__);                                            \
    exit(EXIT_FAILURE);                                                  \
} while(0)

#define IF(cond)                                                         \
if ((cond)) EXIT(#cond)

//
// RETURN - 打印错误信息, 并 return 返回指定结果
// val      : return的东西, 当需要 return void; 时候填 ',' 就过 or NIL
// fmt      : 双引号包裹的格式化字符串
// ...      : fmt中对应的参数
// return   : val
// 
#define RETURN(val, fmt, ...)                                           \
do {                                                                    \
    CERR(fmt, ##__VA_ARGS__);                                           \
    return val;                                                         \
} while(0)

#define NIL
#define RETNIL(fmt, ...)                                                \
RETURN(NIL , fmt, ##__VA_ARGS__)

#define RETNUL(fmt, ...)                                                \
RETURN(NULL, fmt, ##__VA_ARGS__)
/*
 * 这里是一个 在 DEBUG 模式下的测试宏
 *
 * 用法 :
 * DEBUG_CODE({
 *      puts("debug start...");
 * });
 */
#ifndef DEBUG_CODE
# ifdef _DEBUG
#   define DEBUG_CODE(code) \
        do code while(0)
# else
#   define DEBUG_CODE(code) 
# endif //  ! _DEBUG
#endif  //  ! DEBUG_CODE

#ifndef _ENUM_FLAG
//
// int - 函数返回值全局状态码
// >= 0 标识 Success状态, < 0 标识 Error状态
//
enum flag {
    ErrParse    = -8, //协议解析错误
    ErrClose    = -7, //句柄打开失败, 读取完毕也返回这个
    ErrEmpty    = -6, //返回数据为空
    ErrTout     = -5, //操作超时错误
    ErrFd       = -4, //文件打开失败
    ErrAlloc    = -3, //内存分配错误
    ErrParam    = -2, //输入参数错误
    ErrBase     = -1, //错误基础类型, 所有位置错误都可用它

    SufBase     = +0, //基础正确类型
};

//
// 定义一些通用的函数指针帮助, 主要用于基库的封装.
// 有构造函数, 析构函数, 比较函数, 轮询函数 ... 
// cmp_f   - int icmp(const void * ln, const void * rn); 标准结构
// each_f   - int <-> int, each循环操作, arg 外部参数, node 内部节点
// start_f  - pthread 线程启动的辅助函数宏, 方便优化
//
typedef int     (* cmp_f )( );
typedef void *  (* vnew_f )( );
typedef void    (* node_f )(void * node);
typedef int     (* each_f )(void * node, void * arg);
typedef void *  (* start_f)(void * arg);

#define _ENUM_FLAG
#endif // !_ENUM_FLAG

#endif // !_H_SIMPLEC_STRUCT
