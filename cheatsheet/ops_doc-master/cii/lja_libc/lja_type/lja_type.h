/**
 * @file ljatype.h
 * @brief ljac中使用的数据类型
 * @author LJA
 * @version 0.0.1
 * @date 2012-11-13
 */
#ifndef LJA_TYPE_H
#define LJA_TYPE_H

#define LJA_WORD_SIZE 32
#define LJA_BIG_ENDIAN 0
#define LJA_LITTLE_ENDIAN 1
typedef unsigned char u_char;
typedef unsigned char u_int8;
typedef unsigned short int u_int16;
typedef unsigned int u_int32;
#if LJA_WORD_SIZE == 64
typedef unsigned long int u_int64;
#else
typedef unsigned long long int u_int64;
#endif

//signed char 依然是char
typedef signed char int8;
typedef signed short int int16;
typedef signed int int32;
#if LJA_WORD_SIZE == 64
typedef signed long int int64;
#else
typedef signed long long int int64;
#endif

#endif 
