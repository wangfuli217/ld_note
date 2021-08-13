/******************************************************************
 *  Created on: 2011-4-26
 *      Author: yewang@taobao.com clm971910@gmail.com
 *
 *      Desc  : 提供uint32的  varint 压缩和解压功能
 *              提供group varint的高效实现
 *
 ******************************************************************/
 
#ifndef VARINT_H_
#define VARINT_H_
 
 
#include <stdint.h>
#include <stddef.h>
#include <limits.h>
 
 
#ifndef UNLIKELY
#define UNLIKELY(x) __builtin_expect((x), 1)
#define LIKELY(x) __builtin_expect((x), 0)
#endif

#define UINT24_MAX	0xFFFFFF
#define UINT8_MAX	0xFF
#define UINT16_MAX  0xFFFF
 
 
#pragma pack(1)
typedef struct {
    uint32_t value : 24;
} UINT24_T;
 
 
#pragma pack()
 
/**
 * group varint 的索引表，  单位：(byte)
 *
 * 第0列： 第2整数 和  当前索引单元第一个字节的距离
 * 第1列： 第3整数 和  当前索引单元第一个字节的距离
 * 第2列： 第4整数 和  当前索引单元第一个字节的距离
 * 第3列： 第1整数 占用的字节数
 * 第4列： 第2整数 占用的字节数
 * 第5列： 第3整数 占用的字节数
 * 第6列： 第4整数 占用的字节数
 * 第7列： 下一个索引单元（4个整数） 和 当前索引单元第一个字节的距离
 *
 * 第一个整数和 索引单元的距离总是 1
 */
static const uint8_t GROUP_VARINT_IDX_ARR[256][8] = {
        /* 00 00 00 00 */ { 2, 3, 4, 1, 1, 1, 1, 5},
        /* 00 00 00 01 */ { 2, 3, 4, 1, 1, 1, 2, 6},
        /* 00 00 00 10 */ { 2, 3, 4, 1, 1, 1, 3, 7},
        /* 00 00 00 11 */ { 2, 3, 4, 1, 1, 1, 4, 8},
 
        /* 00 00 01 00 */ { 2, 3, 5, 1, 1, 2, 1, 6},
        /* 00 00 01 01 */ { 2, 3, 5, 1, 1, 2, 2, 7},
        /* 00 00 01 10 */ { 2, 3, 5, 1, 1, 2, 3, 8},
        /* 00 00 01 11 */ { 2, 3, 5, 1, 1, 2, 4, 9},
 
        /* 00 00 10 00 */ { 2, 3, 6, 1, 1, 3, 1, 7},
        /* 00 00 10 01 */ { 2, 3, 6, 1, 1, 3, 2, 8},
        /* 00 00 10 10 */ { 2, 3, 6, 1, 1, 3, 3, 9},
        /* 00 00 10 11 */ { 2, 3, 6, 1, 1, 3, 4, 10},
 
        /* 00 00 11 00 */ { 2, 3, 7, 1, 1, 4, 1, 8},
        /* 00 00 11 01 */ { 2, 3, 7, 1, 1, 4, 2, 9},
        /* 00 00 11 10 */ { 2, 3, 7, 1, 1, 4, 3, 10},
        /* 00 00 11 11 */ { 2, 3, 7, 1, 1, 4, 4, 11},
 
        /* 00 01 00 00 */ { 2, 4, 5, 1, 2, 1, 1, 6},
        /* 00 01 00 01 */ { 2, 4, 5, 1, 2, 1, 2, 7},
        /* 00 01 00 10 */ { 2, 4, 5, 1, 2, 1, 3, 8},
        /* 00 01 00 11 */ { 2, 4, 5, 1, 2, 1, 4, 9},
 
        /* 00 01 01 00 */ { 2, 4, 6, 1, 2, 2, 1, 7},
        /* 00 01 01 01 */ { 2, 4, 6, 1, 2, 2, 2, 8},
        /* 00 01 01 10 */ { 2, 4, 6, 1, 2, 2, 3, 9},
        /* 00 01 01 11 */ { 2, 4, 6, 1, 2, 2, 4, 10},
 
        /* 00 01 10 00 */ { 2, 4, 7, 1, 2, 3, 1, 8},
        /* 00 01 10 01 */ { 2, 4, 7, 1, 2, 3, 2, 9},
        /* 00 01 10 10 */ { 2, 4, 7, 1, 2, 3, 3, 10},
        /* 00 01 10 11 */ { 2, 4, 7, 1, 2, 3, 4, 11},
 
        /* 00 01 11 00 */ { 2, 4, 8, 1, 2, 4, 1, 9},
        /* 00 01 11 01 */ { 2, 4, 8, 1, 2, 4, 2, 10},
        /* 00 01 11 10 */ { 2, 4, 8, 1, 2, 4, 3, 11},
        /* 00 01 11 11 */ { 2, 4, 8, 1, 2, 4, 4, 12},
 
        /* 00 10 00 00 */ { 2, 5, 6, 1, 3, 1, 1, 7},
        /* 00 10 00 01 */ { 2, 5, 6, 1, 3, 1, 2, 8},
        /* 00 10 00 10 */ { 2, 5, 6, 1, 3, 1, 3, 9},
        /* 00 10 00 11 */ { 2, 5, 6, 1, 3, 1, 4, 10},
 
        /* 00 10 01 00 */ { 2, 5, 7, 1, 3, 2, 1, 8},
        /* 00 10 01 01 */ { 2, 5, 7, 1, 3, 2, 2, 9},
        /* 00 10 01 10 */ { 2, 5, 7, 1, 3, 2, 3, 10},
        /* 00 10 01 11 */ { 2, 5, 7, 1, 3, 2, 4, 11},
 
        /* 00 10 10 00 */ { 2, 5, 8, 1, 3, 3, 1, 9},
        /* 00 10 10 01 */ { 2, 5, 8, 1, 3, 3, 2, 10},
        /* 00 10 10 10 */ { 2, 5, 8, 1, 3, 3, 3, 11},
        /* 00 10 10 11 */ { 2, 5, 8, 1, 3, 3, 4, 12},
 
        /* 00 10 11 00 */ { 2, 5, 9, 1, 3, 4, 1, 10},
        /* 00 10 11 01 */ { 2, 5, 9, 1, 3, 4, 2, 11},
        /* 00 10 11 10 */ { 2, 5, 9, 1, 3, 4, 3, 12},
        /* 00 10 11 11 */ { 2, 5, 9, 1, 3, 4, 4, 13},
 
        /* 00 11 00 00 */ { 2, 6, 7, 1, 4, 1, 1, 8},
        /* 00 11 00 01 */ { 2, 6, 7, 1, 4, 1, 2, 9},
        /* 00 11 00 10 */ { 2, 6, 7, 1, 4, 1, 3, 10},
        /* 00 11 00 11 */ { 2, 6, 7, 1, 4, 1, 4, 11},
 
        /* 00 11 01 00 */ { 2, 6, 8, 1, 4, 2, 1, 9},
        /* 00 11 01 01 */ { 2, 6, 8, 1, 4, 2, 2, 10},
        /* 00 11 01 10 */ { 2, 6, 8, 1, 4, 2, 3, 11},
        /* 00 11 01 11 */ { 2, 6, 8, 1, 4, 2, 4, 12},
 
        /* 00 11 10 00 */ { 2, 6, 9, 1, 4, 3, 1, 10},
        /* 00 11 10 01 */ { 2, 6, 9, 1, 4, 3, 2, 11},
        /* 00 11 10 10 */ { 2, 6, 9, 1, 4, 3, 3, 12},
        /* 00 11 10 11 */ { 2, 6, 9, 1, 4, 3, 4, 13},
 
        /* 00 11 11 00 */ { 2, 6, 10 , 1, 4, 4, 1, 11},
        /* 00 11 11 01 */ { 2, 6, 10 , 1, 4, 4, 2, 12 },
        /* 00 11 11 10 */ { 2, 6, 10 , 1, 4, 4, 3, 13 },
        /* 00 11 11 11 */ { 2, 6, 10 , 1, 4, 4, 4, 14 },
 
        /* 01 00 00 00 */ { 3, 4, 5, 2, 1, 1, 1, 6},
        /* 01 00 00 01 */ { 3, 4, 5, 2, 1, 1, 2, 7},
        /* 01 00 00 10 */ { 3, 4, 5, 2, 1, 1, 3, 8},
        /* 01 00 00 11 */ { 3, 4, 5, 2, 1, 1, 4, 9},
 
        /* 01 00 01 00 */ { 3, 4, 6, 2, 1, 2, 1, 7},
        /* 01 00 01 01 */ { 3, 4, 6, 2, 1, 2, 2, 8},
        /* 01 00 01 10 */ { 3, 4, 6, 2, 1, 2, 3, 9},
        /* 01 00 01 11 */ { 3, 4, 6, 2, 1, 2, 4, 10},
 
        /* 01 00 10 00 */ { 3, 4, 7, 2, 1, 3, 1, 8},
        /* 01 00 10 01 */ { 3, 4, 7, 2, 1, 3, 2, 9},
        /* 01 00 10 10 */ { 3, 4, 7, 2, 1, 3, 3, 10},
        /* 01 00 10 11 */ { 3, 4, 7, 2, 1, 3, 4, 11},
 
        /* 01 00 11 00 */ { 3, 4, 8, 2, 1, 4, 1, 9},
        /* 01 00 11 01 */ { 3, 4, 8, 2, 1, 4, 2, 10},
        /* 01 00 11 10 */ { 3, 4, 8, 2, 1, 4, 3, 11},
        /* 01 00 11 11 */ { 3, 4, 8, 2, 1, 4, 4, 12},
 
        /* 01 01 00 00 */ { 3, 5, 6, 2, 2, 1, 1, 7},
        /* 01 01 00 01 */ { 3, 5, 6, 2, 2, 1, 2, 8},
        /* 01 01 00 10 */ { 3, 5, 6, 2, 2, 1, 3, 9},
        /* 01 01 00 11 */ { 3, 5, 6, 2, 2, 1, 4, 10},
 
        /* 01 01 01 00 */ { 3, 5, 7, 2, 2, 2, 1, 8},
        /* 01 01 01 01 */ { 3, 5, 7, 2, 2, 2, 2, 9},
        /* 01 01 01 10 */ { 3, 5, 7, 2, 2, 2, 3, 10},
        /* 01 01 01 11 */ { 3, 5, 7, 2, 2, 2, 4, 11},
 
        /* 01 01 10 00 */ { 3, 5, 8, 2, 2, 3, 1, 9},
        /* 01 01 10 01 */ { 3, 5, 8, 2, 2, 3, 2, 10},
        /* 01 01 10 10 */ { 3, 5, 8, 2, 2, 3, 3, 11},
        /* 01 01 10 11 */ { 3, 5, 8, 2, 2, 3, 4, 12},
 
        /* 01 01 11 00 */ { 3, 5, 9, 2, 2, 4, 1, 10},
        /* 01 01 11 01 */ { 3, 5, 9, 2, 2, 4, 2, 11},
        /* 01 01 11 10 */ { 3, 5, 9, 2, 2, 4, 3, 12},
        /* 01 01 11 11 */ { 3, 5, 9, 2, 2, 4, 4, 13},
 
        /* 01 10 00 00 */ { 3, 6, 7, 2, 3, 1, 1, 8},
        /* 01 10 00 01 */ { 3, 6, 7, 2, 3, 1, 2, 9},
        /* 01 10 00 10 */ { 3, 6, 7, 2, 3, 1, 3, 10},
        /* 01 10 00 11 */ { 3, 6, 7, 2, 3, 1, 4, 11},
 
        /* 01 10 01 00 */ { 3, 6, 8, 2, 3, 2, 1, 9},
        /* 01 10 01 01 */ { 3, 6, 8, 2, 3, 2, 2, 10},
        /* 01 10 01 10 */ { 3, 6, 8, 2, 3, 2, 3, 11},
        /* 01 10 01 11 */ { 3, 6, 8, 2, 3, 2, 4, 12},
 
        /* 01 10 10 00 */ { 3, 6, 9, 2, 3, 3, 1, 10},
        /* 01 10 10 01 */ { 3, 6, 9, 2, 3, 3, 2, 11},
        /* 01 10 10 10 */ { 3, 6, 9, 2, 3, 3, 3, 12},
        /* 01 10 10 11 */ { 3, 6, 9, 2, 3, 3, 4, 13},
 
        /* 01 10 11 00 */ { 3, 6, 10 , 2, 3, 4, 1 , 11},
        /* 01 10 11 01 */ { 3, 6, 10 , 2, 3, 4, 2 , 12},
        /* 01 10 11 10 */ { 3, 6, 10 , 2, 3, 4, 3 , 13},
        /* 01 10 11 11 */ { 3, 6, 10 , 2, 3, 4, 4 , 14},
 
        /* 01 11 00 00 */ { 3, 7, 8, 2, 4, 1, 1, 9},
        /* 01 11 00 01 */ { 3, 7, 8, 2, 4, 1, 2, 10},
        /* 01 11 00 10 */ { 3, 7, 8, 2, 4, 1, 3, 11},
        /* 01 11 00 11 */ { 3, 7, 8, 2, 4, 1, 4, 12},
 
        /* 01 11 01 00 */ { 3, 7, 9, 2, 4, 2, 1, 10},
        /* 01 11 01 01 */ { 3, 7, 9, 2, 4, 2, 2, 11},
        /* 01 11 01 10 */ { 3, 7, 9, 2, 4, 2, 3, 12},
        /* 01 11 01 11 */ { 3, 7, 9, 2, 4, 2, 4, 13},
 
        /* 01 11 10 00 */ { 3, 7, 10 , 2, 4, 3, 1 , 11},
        /* 01 11 10 01 */ { 3, 7, 10 , 2, 4, 3, 2 , 12},
        /* 01 11 10 10 */ { 3, 7, 10 , 2, 4, 3, 3 , 13},
        /* 01 11 10 11 */ { 3, 7, 10 , 2, 4, 3, 4 , 14},
 
        /* 01 11 11 00 */ { 3, 7, 11 , 2, 4, 4, 1 , 12},
        /* 01 11 11 01 */ { 3, 7, 11 , 2, 4, 4, 2 , 13},
        /* 01 11 11 10 */ { 3, 7, 11 , 2, 4, 4, 3 , 14},
        /* 01 11 11 11 */ { 3, 7, 11 , 2, 4, 4, 4 , 15},
 
        /* 10 00 00 00 */ { 4, 5, 6, 3, 1, 1, 1, 7},
        /* 10 00 00 01 */ { 4, 5, 6, 3, 1, 1, 2, 8},
        /* 10 00 00 10 */ { 4, 5, 6, 3, 1, 1, 3, 9},
        /* 10 00 00 11 */ { 4, 5, 6, 3, 1, 1, 4, 10},
 
        /* 10 00 01 00 */ { 4, 5, 7, 3, 1, 2, 1, 8},
        /* 10 00 01 01 */ { 4, 5, 7, 3, 1, 2, 2, 9},
        /* 10 00 01 10 */ { 4, 5, 7, 3, 1, 2, 3, 10},
        /* 10 00 01 11 */ { 4, 5, 7, 3, 1, 2, 4, 11},
 
        /* 10 00 10 00 */ { 4, 5, 8, 3, 1, 3, 1, 9},
        /* 10 00 10 01 */ { 4, 5, 8, 3, 1, 3, 2, 10},
        /* 10 00 10 10 */ { 4, 5, 8, 3, 1, 3, 3, 11},
        /* 10 00 10 11 */ { 4, 5, 8, 3, 1, 3, 4, 12},
 
        /* 10 00 11 00 */ { 4, 5, 9, 3, 1, 4, 1, 10},
        /* 10 00 11 01 */ { 4, 5, 9, 3, 1, 4, 2, 11},
        /* 10 00 11 10 */ { 4, 5, 9, 3, 1, 4, 3, 12},
        /* 10 00 11 11 */ { 4, 5, 9, 3, 1, 4, 4, 13},
 
        /* 10 01 00 00 */ { 4, 6, 7, 3, 2, 1, 1, 8},
        /* 10 01 00 01 */ { 4, 6, 7, 3, 2, 1, 2, 9},
        /* 10 01 00 10 */ { 4, 6, 7, 3, 2, 1, 3, 10},
        /* 10 01 00 11 */ { 4, 6, 7, 3, 2, 1, 4, 11},
 
        /* 10 01 01 00 */ { 4, 6, 8, 3, 2, 2, 1, 9},
        /* 10 01 01 01 */ { 4, 6, 8, 3, 2, 2, 2, 10},
        /* 10 01 01 10 */ { 4, 6, 8, 3, 2, 2, 3, 11},
        /* 10 01 01 11 */ { 4, 6, 8, 3, 2, 2, 4, 12},
 
        /* 10 01 10 00 */ { 4, 6, 9, 3, 2, 3, 1, 10},
        /* 10 01 10 01 */ { 4, 6, 9, 3, 2, 3, 2, 11},
        /* 10 01 10 10 */ { 4, 6, 9, 3, 2, 3, 3, 12},
        /* 10 01 10 11 */ { 4, 6, 9, 3, 2, 3, 4, 13},
 
        /* 10 01 11 00 */ { 4, 6, 10 , 3, 2, 4, 1, 11 },
        /* 10 01 11 01 */ { 4, 6, 10 , 3, 2, 4, 2, 12 },
        /* 10 01 11 10 */ { 4, 6, 10 , 3, 2, 4, 3, 13 },
        /* 10 01 11 11 */ { 4, 6, 10 , 3, 2, 4, 4, 14 },
 
        /* 10 10 00 00 */ { 4, 7, 8, 3, 3, 1, 1, 9},
        /* 10 10 00 01 */ { 4, 7, 8, 3, 3, 1, 2, 10},
        /* 10 10 00 10 */ { 4, 7, 8, 3, 3, 1, 3, 11},
        /* 10 10 00 11 */ { 4, 7, 8, 3, 3, 1, 4, 12},
 
        /* 10 10 01 00 */ { 4, 7, 9, 3, 3, 2, 1, 10},
        /* 10 10 01 01 */ { 4, 7, 9, 3, 3, 2, 2, 11},
        /* 10 10 01 10 */ { 4, 7, 9, 3, 3, 2, 3, 12},
        /* 10 10 01 11 */ { 4, 7, 9, 3, 3, 2, 4, 13},
 
        /* 10 10 10 00 */ { 4, 7, 10 , 3, 3, 3, 1, 11 },
        /* 10 10 10 01 */ { 4, 7, 10 , 3, 3, 3, 2, 12 },
        /* 10 10 10 10 */ { 4, 7, 10 , 3, 3, 3, 3, 13 },
        /* 10 10 10 11 */ { 4, 7, 10 , 3, 3, 3, 4, 14 },
 
        /* 10 10 11 00 */ { 4, 7, 11 , 3, 3, 4, 1, 12 },
        /* 10 10 11 01 */ { 4, 7, 11 , 3, 3, 4, 2, 13 },
        /* 10 10 11 10 */ { 4, 7, 11 , 3, 3, 4, 3, 14 },
        /* 10 10 11 11 */ { 4, 7, 11 , 3, 3, 4, 4, 15 },
 
        /* 10 11 00 00 */ { 4, 8, 9, 3, 4, 1, 1, 10},
        /* 10 11 00 01 */ { 4, 8, 9, 3, 4, 1, 2, 11},
        /* 10 11 00 10 */ { 4, 8, 9, 3, 4, 1, 3, 12},
        /* 10 11 00 11 */ { 4, 8, 9, 3, 4, 1, 4, 13},
 
        /* 10 11 01 00 */ { 4, 8, 10 , 3, 4, 2, 1, 11 },
        /* 10 11 01 01 */ { 4, 8, 10 , 3, 4, 2, 2, 12 },
        /* 10 11 01 10 */ { 4, 8, 10 , 3, 4, 2, 3, 13 },
        /* 10 11 01 11 */ { 4, 8, 10 , 3, 4, 2, 4, 14 },
 
        /* 10 11 10 00 */ { 4, 8, 11 , 3, 4, 3, 1, 12 },
        /* 10 11 10 01 */ { 4, 8, 11 , 3, 4, 3, 2, 13 },
        /* 10 11 10 10 */ { 4, 8, 11 , 3, 4, 3, 3, 14 },
        /* 10 11 10 11 */ { 4, 8, 11 , 3, 4, 3, 4, 15 },
 
        /* 10 11 11 00 */ { 4, 8, 12 , 3, 4, 4, 1, 13 },
        /* 10 11 11 01 */ { 4, 8, 12 , 3, 4, 4, 2, 14 },
        /* 10 11 11 10 */ { 4, 8, 12 , 3, 4, 4, 3, 15 },
        /* 10 11 11 11 */ { 4, 8, 12 , 3, 4, 4, 4, 16 },
 
        /* 11 00 00 00 */ { 5, 6, 7, 4, 1, 1, 1, 8},
        /* 11 00 00 01 */ { 5, 6, 7, 4, 1, 1, 2, 9},
        /* 11 00 00 10 */ { 5, 6, 7, 4, 1, 1, 3, 10},
        /* 11 00 00 11 */ { 5, 6, 7, 4, 1, 1, 4, 11},
 
        /* 11 00 01 00 */ { 5, 6, 8, 4, 1, 2, 1, 9},
        /* 11 00 01 01 */ { 5, 6, 8, 4, 1, 2, 2, 10},
        /* 11 00 01 10 */ { 5, 6, 8, 4, 1, 2, 3, 11},
        /* 11 00 01 11 */ { 5, 6, 8, 4, 1, 2, 4, 12},
 
        /* 11 00 10 00 */ { 5, 6, 9, 4, 1, 3, 1, 10},
        /* 11 00 10 01 */ { 5, 6, 9, 4, 1, 3, 2, 11},
        /* 11 00 10 10 */ { 5, 6, 9, 4, 1, 3, 3, 12},
        /* 11 00 10 11 */ { 5, 6, 9, 4, 1, 3, 4, 13},
 
        /* 11 00 11 00 */ { 5, 6, 10 , 4, 1, 4, 1, 11 },
        /* 11 00 11 01 */ { 5, 6, 10 , 4, 1, 4, 2, 12 },
        /* 11 00 11 10 */ { 5, 6, 10 , 4, 1, 4, 3, 13 },
        /* 11 00 11 11 */ { 5, 6, 10 , 4, 1, 4, 4, 14 },
 
        /* 11 01 00 00 */ { 5, 7, 8, 4, 2, 1, 1, 9},
        /* 11 01 00 01 */ { 5, 7, 8, 4, 2, 1, 2, 10},
        /* 11 01 00 10 */ { 5, 7, 8, 4, 2, 1, 3, 11},
        /* 11 01 00 11 */ { 5, 7, 8, 4, 2, 1, 4, 12},
 
        /* 11 01 01 00 */ { 5, 7, 9, 4, 2, 2, 1, 10},
        /* 11 01 01 01 */ { 5, 7, 9, 4, 2, 2, 2, 11},
        /* 11 01 01 10 */ { 5, 7, 9, 4, 2, 2, 3, 12},
        /* 11 01 01 11 */ { 5, 7, 9, 4, 2, 2, 4, 13},
 
        /* 11 01 10 00 */ { 5, 7, 10 , 4, 2, 3, 1 , 11},
        /* 11 01 10 01 */ { 5, 7, 10 , 4, 2, 3, 2 , 12},
        /* 11 01 10 10 */ { 5, 7, 10 , 4, 2, 3, 3 , 13},
        /* 11 01 10 11 */ { 5, 7, 10 , 4, 2, 3, 4 , 14},
 
        /* 11 01 11 00 */ { 5, 7, 11 , 4, 2, 4, 1 , 12},
        /* 11 01 11 01 */ { 5, 7, 11 , 4, 2, 4, 2 , 13},
        /* 11 01 11 10 */ { 5, 7, 11 , 4, 2, 4, 3 , 14},
        /* 11 01 11 11 */ { 5, 7, 11 , 4, 2, 4, 4 , 15},
 
        /* 11 10 00 00 */ { 5, 8, 9, 4, 3, 1, 1, 10},
        /* 11 10 00 01 */ { 5, 8, 9, 4, 3, 1, 2, 11},
        /* 11 10 00 10 */ { 5, 8, 9, 4, 3, 1, 3, 12},
        /* 11 10 00 11 */ { 5, 8, 9, 4, 3, 1, 4, 13},
 
        /* 11 10 01 00 */ { 5, 8, 10 , 4, 3, 2, 1 , 11},
        /* 11 10 01 01 */ { 5, 8, 10 , 4, 3, 2, 2 , 12},
        /* 11 10 01 10 */ { 5, 8, 10 , 4, 3, 2, 3 , 13},
        /* 11 10 01 11 */ { 5, 8, 10 , 4, 3, 2, 4 , 14},
 
        /* 11 10 10 00 */ { 5, 8, 11 , 4, 3, 3, 1 , 12},
        /* 11 10 10 01 */ { 5, 8, 11 , 4, 3, 3, 2 , 13},
        /* 11 10 10 10 */ { 5, 8, 11 , 4, 3, 3, 3 , 14},
        /* 11 10 10 11 */ { 5, 8, 11 , 4, 3, 3, 4 , 15},
 
        /* 11 10 11 00 */ { 5, 8, 12 , 4, 3, 4, 1, 13 },
        /* 11 10 11 01 */ { 5, 8, 12 , 4, 3, 4, 2, 14 },
        /* 11 10 11 10 */ { 5, 8, 12 , 4, 3, 4, 3, 15 },
        /* 11 10 11 11 */ { 5, 8, 12 , 4, 3, 4, 4, 16 },
 
        /* 11 11 00 00 */ { 5, 9, 10 , 4, 4, 1, 1, 11 },
        /* 11 11 00 01 */ { 5, 9, 10 , 4, 4, 1, 2, 12 },
        /* 11 11 00 10 */ { 5, 9, 10 , 4, 4, 1, 3, 13 },
        /* 11 11 00 11 */ { 5, 9, 10 , 4, 4, 1, 4, 14 },
 
        /* 11 11 01 00 */ { 5, 9, 11 , 4, 4, 2, 1, 12 },
        /* 11 11 01 01 */ { 5, 9, 11 , 4, 4, 2, 2, 13 },
        /* 11 11 01 10 */ { 5, 9, 11 , 4, 4, 2, 3, 14 },
        /* 11 11 01 11 */ { 5, 9, 11 , 4, 4, 2, 4, 15 },
 
        /* 11 11 10 00 */ { 5, 9, 12 , 4, 4, 3, 1, 13 },
        /* 11 11 10 01 */ { 5, 9, 12 , 4, 4, 3, 2, 14 },
        /* 11 11 10 10 */ { 5, 9, 12 , 4, 4, 3, 3, 15 },
        /* 11 11 10 11 */ { 5, 9, 12 , 4, 4, 3, 4, 16 },
 
        /* 11 11 11 00 */ { 5, 9, 13 , 4, 4, 4, 1, 14 },
        /* 11 11 11 01 */ { 5, 9, 13 , 4, 4, 4, 2, 15 },
        /* 11 11 11 10 */ { 5, 9, 13 , 4, 4, 4, 3, 16 },
        /* 11 11 11 11 */ { 5, 9, 13 , 4, 4, 4, 4, 17}
};
 
 
/**
 * 将一个uint32整数 做 varint 编码 输出到 buf中
 *
 * @param value       输出的值
 * @param target      输出的缓冲 , 需确保buf 空间是够用的
 *
 * @return  target中下一个可用的字节位置
 */
inline uint8_t *
varint_encode_uint32 ( uint32_t value, uint8_t * target )
{
    if ( value >= (1 << 7) )
    {
        target[0] = (uint8_t)(value | 0x80);               // 取低7位， 前面补 1
 
        if ( value >= (1 << 14) )
        {
            target[1] = (uint8_t)( (value >> 7) | 0x80 );  // 取次低7位，前面补 1
 
            if ( value >= (1 << 21) )
            {
                // 取第3个 低7位，前面补 1
                target[2] = (uint8_t)( (value >> 14) | 0x80 );
 
                if ( value >= (1 << 28) )
                {
                    // 取第4个 低7位，前面补 1
                    target[3] = (uint8_t)((value >> 21) | 0x80);
 
                    // 剩余的高4位
                    target[4] = (uint8_t)(value >> 28);
 
                    return target + 5;
                }
                else
                {
                    target[3] = (uint8_t)( value >> 21 );
                    return target + 4;
                }
            }
            else
            {
                target[2] = (uint8_t)( value >> 14 );
                return target + 3;
            }
        }
        else
        {
            target[1] = (uint8_t)( value >> 7 );
            return target + 2;
        }
    }
    else
    {
        target[0] = (uint8_t) value;
        return target + 1;
    }
}
 
 
 
/**
 * 从buf中 将 varint压缩编码的值 还原读取出来
 * 需要确保输入的buf 从 输出的指针到结尾 超过  5个byte, 避免出现core
 * 函数内部不做边界检查
 *
 * @param buffer    输入的buf
 * @param value     输出的值
 *
 * @return  target中下一个可读的字节位置
 */
inline const uint8_t *
varint_decode_uint32( const uint8_t * buffer, uint32_t & value )
{
    register const uint8_t * ptr = buffer;
 
    // 低7位， 小于 128 的数字
    register uint8_t   b0  = ptr[ 0 ];
    register uint32_t  r0  = (b0 & 0x7F);
 
    if (UNLIKELY( !(b0 & 0x80) ))
    {
        value = r0;
        return ptr + 1;
    }
 
    // 低14位,  小于 16384 的数字
    register uint8_t   b1  = ptr[ 1 ];
    register uint32_t  r1  = (b1 & 0x7F) << 7;
 
    if (UNLIKELY( !(b1 & 0x80) ))
    {
        value = ( r1 | r0 );
        return ptr + 2;
    }
 
    // 低21位, 小于 2097152 的数字
    register uint8_t   b2  = ptr[ 2 ];
    register uint32_t  r2  = (b2 & 0x7F) << 14;
 
    if (UNLIKELY( !(b2 & 0x80) ))
    {
        value = ( r2 | r1 | r0 );
        return ptr + 3;
    }
 
    // 低28位, 小于 268435456 的数字
    register uint8_t   b3  = ptr[ 3 ];
    register uint32_t  r3  = (b3 & 0x7F) << 21;
 
    if ( !(b3 & 0x80) )
    {
        value = ( r3 | r2 | r1 | r0 );
        return ptr + 4;
    }
 
    // 完整的32位
    value = ( ((ptr[ 4 ]) << 28) | r3 | r2 | r1 | r0 );
 
    return ptr + 5;
}
 
 
 
/**
 * 从buf中  指定的字节数中   将 varint压缩编码的值 还原读取出来
 * 指定的字节数  也许是 不足的， 比如： 截断掉了， 这样就返回NULL
 *
 * @param buffer    输入的buf
 * @param value     输出的值
 *
 * @return  target中下一个可读的字节位置, 如果buffer异常 返回NULL
 */
inline const uint8_t *
varint_decode_uint32( const uint8_t * buffer, uint32_t len, uint32_t & value )
{
    if ( len >= 5 )                                        // len == 0 就不考虑了
        return varint_decode_uint32( buffer, value );
 
    register const uint8_t * ptr = buffer;
 
    // 低7位， 小于 128 的数字
    register uint8_t   b0  = ptr[ 0 ];
    register uint32_t  r0  = (b0 & 0x7F);
 
    if (UNLIKELY( !(b0 & 0x80) ))
    {
        value = r0;
        return ptr + 1;
    }
 
    if (UNLIKELY( len < 2 ))  return NULL;
 
    // 低14位,  小于 16384 的数字
    register uint8_t   b1  = ptr[ 1 ];
    register uint32_t  r1  = (b1 & 0x7F) << 7;
 
    if (UNLIKELY( !(b1 & 0x80) ))
    {
        value = ( r1 | r0 );
        return ptr + 2;
    }
 
    if (UNLIKELY( len < 3 ))  return NULL;
 
    // 低21位, 小于 2097152 的数字
    register uint8_t   b2  = ptr[ 2 ];
    register uint32_t  r2  = (b2 & 0x7F) << 14;
 
    if (UNLIKELY( !(b2 & 0x80) ))
    {
        value = ( r2 | r1 | r0 );
        return ptr + 3;
    }
 
    if (UNLIKELY( len < 4 ))  return NULL;
 
    // 低28位, 小于 268435456 的数字
    register uint8_t   b3  = ptr[ 3 ];
    register uint32_t  r3  = (b3 & 0x7F) << 21;
 
    if ( !(b3 & 0x80) )
    {
        value = ( r3 | r2 | r1 | r0 );
        return ptr + 4;
    }
 
    if ( len < 5 )  return NULL;
 
    // 完整的32位
    value = ( ((ptr[ 4 ]) << 28) | r3 | r2 | r1 | r0 );
 
    return ptr + 5;
}
 
 
 
 
 
 
 
 
/** 解压时 并不把实际值取得， 只获取下一个可解压位置, 一次忽略 1个 uint32 */
inline const uint8_t *
varint_decode_uint32_skip( const uint8_t * buffer )
{
    if (UNLIKELY( !(buffer[ 0 ] & 0x80) ))   return buffer + 1;
    if (UNLIKELY( !(buffer[ 1 ] & 0x80) ))   return buffer + 2;
    if (UNLIKELY( !(buffer[ 2 ] & 0x80) ))   return buffer + 3;
    if (          !(buffer[ 3 ] & 0x80) )    return buffer + 4;
 
    return buffer + 5;
}
 
 
 
 
 
 
/**
 * 将一个uint64整数 做 varint 编码 输出到 buf中
 *
 * @param value       输出的值
 * @param target      输出的缓冲 , 需确保buf 空间是够用的
 *
 * @return  target中下一个可用的字节位置
 */
inline uint8_t *
varint_encode_uint64 ( uint64_t value, uint8_t * target )
{
    // 拆分成高32位和低32位
    target = varint_encode_uint32( value >> 32, target );
 
    return varint_encode_uint32( value & 0xFFFFFFFF, target );
}
 
 
 
/**
 * 从buf中 将 varint压缩编码的值 还原读取出来
 * 需要确保输入的buf 从 输出的指针到结尾 超过  5个byte, 避免出现core
 * 函数内部不做边界检查
 *
 * @param buffer    输入的buf
 * @param value     输出的值
 *
 * @return  target中下一个可读的字节位置
 */
inline const uint8_t *
varint_decode_uint64(const uint8_t * buffer, uint64_t & value)
{
    uint32_t  high = 0;
    uint32_t  low  = 0;
 
    buffer = varint_decode_uint32( buffer, high );
    buffer = varint_decode_uint32( buffer, low  );
 
    value = ((uint64_t)high << 32) + low ;
 
    return buffer;
}
 
 
 
/** 解压时 并不把实际值取得， 只获取下一个可解压位置, 一次忽略  1个uint64 */
inline const uint8_t *
varint_decode_uint64_skip( const uint8_t * buffer )
{
    buffer = varint_decode_uint32_skip( buffer );
 
    return varint_decode_uint32_skip( buffer );
}
 
 
 
/**
 * 对整数数组进行 group varint编码, 一次处理 4个整数
 *
 * @param valueArr   无符号整数的数组  元素个数， 必须是4的倍数。 多余不处理
 * @param target     用于输出的buf . 需要确够大 ，  4个整数最多用 17个byte
 *
 * @return  target下一个可写byte
 */
inline uint8_t *
group_varint_encode_uint32( const uint32_t * valueArr, uint8_t * target)
{
    register uint8_t len1;                  // 第  1 个数字用的 字节数
    register uint8_t len2;                  // 第  2 个数字用的 字节数
    register uint8_t len3;                  // 第  3 个数字用的 字节数
    register uint8_t len4;                  // 第 4 个数字用的 字节数
 
    register uint32_t  val1 = valueArr[0];
    register uint32_t  val2 = valueArr[1];
    register uint32_t  val3 = valueArr[2];
    register uint32_t  val4 = valueArr[3];
 
    register uint8_t * buf = target + 1;
 
    if ( val1 > UINT24_MAX )
    {
        len1 = 4;
        ((uint32_t *)(buf))[0] = val1;
    }
    else if ( val1 > UINT16_MAX )
    {
        len1 = 3;
        ((uint32_t *)(buf))[0] = val1;
    }
    else if ( val1 > UINT8_MAX )
    {
        len1 = 2;
        ((uint16_t *)(buf))[0] = (uint16_t) val1;
    }
    else
    {
        len1   = 1;
        buf[0] = (uint8_t) val1;
    }
 
    register uint8_t len = len1;                 // 4个数字总共用的 字节数
 
    /*  处理第二个数字   */
    if (UNLIKELY( val2 > UINT24_MAX ))
    {
        len2 = 4;
        ((uint32_t *)(buf + len))[0] = val2;
    }
    else if ( val2 > UINT16_MAX )
    {
        len2 = 3;
        ((uint32_t *)(buf + len))[0] = val2;
    }
    else if ( val2 > UINT8_MAX )
    {
        len2 = 2;
        ((uint16_t *)(buf + len))[0] = (uint16_t) val2;
    }
    else
    {
        len2 = 1;
        buf[len] = (uint8_t) val2;
    }
 
    len += len2;
 
    /*  处理第3个数字   */
    if (UNLIKELY( val3 > UINT24_MAX ))
    {
        len3 = 4;
        ((uint32_t *)(buf + len))[0] = val3;
    }
    else if ( val3 > UINT16_MAX )
    {
        len3 = 3;
        ((uint32_t *)(buf + len))[0] = val3;
    }
    else if ( val3 > UINT8_MAX )
    {
        len3 = 2;
        ((uint16_t *)(buf + len))[0] = (uint16_t) val3;
    }
    else
    {
        len3 = 1;
        buf[len] = (uint8_t) val3;
    }
 
    len += len3;
 
    /*  处理第4个数字   */
    if (UNLIKELY( val4 > UINT24_MAX ))
    {
        len4 = 4;
        ((uint32_t *)(buf + len))[0] = val4;
    }
    else if ( val4 > UINT16_MAX )
    {
        len4 = 3;
        ((uint32_t *)(buf + len))[0] = val4;
    }
    else if ( val4 > UINT8_MAX )
    {
        len4 = 2;
        ((uint16_t *)(buf + len))[0] = (uint16_t) val4;
    }
    else
    {
        len4 = 1;
        buf[len] = (uint8_t) val4;
    }
 
    len += len4;
 
    /* 处理第一个索引字节 */
    target[0] = ((len1 - 1) << 6) | ((len2 - 1) << 4) | ((len3 - 1) << 2) | (len4 - 1);
 
    return buf + len;
}
 
 
 
 
 
 
 
 
/**
 * 对输入的buf进行解压， 每次一定解压出4个整数
 *
 * @param buf         输入的buf
 * @param valueArr    输出的数组，  需要预先开辟为4个整数的数组
 *
 * @return target下一个可读byte
 */
inline const uint8_t *
group_varint_decode_uint32 ( const uint8_t * buf, uint32_t * valueArr)
{
    register uint8_t   idx   = buf[ 0 ];
    const    uint8_t * star1 = buf + 1;
    const    uint8_t * star2 = buf + GROUP_VARINT_IDX_ARR[idx][0];
    const    uint8_t * star3 = buf + GROUP_VARINT_IDX_ARR[idx][1];
    const    uint8_t * star4 = buf + GROUP_VARINT_IDX_ARR[idx][2];
 
    switch ( GROUP_VARINT_IDX_ARR[idx][3] )
    {
        case 1 : valueArr[ 0 ] = *(uint8_t *)  star1;   break;
        case 2 : valueArr[ 0 ] = *(uint16_t *) star1;   break;
        case 3 : valueArr[ 0 ] = (*(UINT24_T *)star1).value ; break;
        default:
            valueArr[ 0 ] = *(uint32_t *) star1;
    }
 
    switch ( GROUP_VARINT_IDX_ARR[idx][4] )
    {
        case 1 : valueArr[ 1 ] = *(uint8_t *)  star2;   break;
        case 2 : valueArr[ 1 ] = *(uint16_t *) star2;   break;
        case 3 : valueArr[ 1 ] = (*(UINT24_T *)star2).value; break;
        default:
            valueArr[ 1 ] = *(uint32_t *) star2;
    }
 
    switch ( GROUP_VARINT_IDX_ARR[idx][5] )
    {
        case 1 : valueArr[ 2 ] = *(uint8_t *)  star3;   break;
        case 2 : valueArr[ 2 ] = *(uint16_t *) star3;   break;
        case 3 : valueArr[ 2 ] = (*(UINT24_T *)star3).value; break;
        default:
            valueArr[ 2 ] = *(uint32_t *) star3;
    }
 
    switch ( GROUP_VARINT_IDX_ARR[idx][6] )
    {
        case 1 : valueArr[ 3 ] = *(uint8_t *)  star4;   break;
        case 2 : valueArr[ 3 ] = *(uint16_t *) star4;   break;
        case 3 : valueArr[ 3 ] = (*(UINT24_T *)star4).value; break;
        default:
            valueArr[ 3 ] = *(uint32_t *) star4;
    }
 
    return buf + GROUP_VARINT_IDX_ARR[ idx ][ 7 ];
}
 
 
 
/** 解压时 并不把实际值取得， 只获取下一个可解压位置, 一次忽略 4个uint32 */
inline const uint8_t *
group_varint_decode_uint32_skip ( const uint8_t * buf )
{
    return buf + GROUP_VARINT_IDX_ARR[ buf[ 0 ] ][ 7 ];
}
 
 
 
 
 
/**
 * 对整数数组进行 group varint编码, 一次处理  2个  uint64整数
 *
 * @param valueArr   无符号整数的数组  元素个数， 必须是2的倍数。 多余不处理
 * @param target     用于输出的buf . 需要确够大 ，  2个uint64整数最多用 17个byte
 *
 * @return  target下一个可写byte
 */
inline uint8_t *
group_varint_encode_uint64 ( const uint64_t * valueArr, uint8_t * target)
{
    uint32_t arr[ 4 ] = { valueArr[0] >> 32,
                          (valueArr[0] << 32) >> 32,
                          valueArr[1] >> 32,
                          (valueArr[1] << 32) >> 32 };
 
    return group_varint_encode_uint32( arr, target);
 
}
 
 
inline uint8_t *
group_varint_encode_uint32 ( uint32_t v1,uint32_t v2, uint32_t v3, uint32_t v4, uint8_t * target)
{
    uint32_t valueArr[ 4 ] = {v1, v2 ,v3 ,v4};
 
    return group_varint_encode_uint32( valueArr, target);
}
 
 
inline uint8_t *
group_varint_encode_uint64 ( uint64_t v1, uint64_t v2, uint8_t * target)
{
    uint32_t valueArr[ 4 ] = { v1 >> 32, (v1 << 32) >> 32, v2 >> 32, (v2 << 32) >> 32 };
 
    return group_varint_encode_uint32( valueArr, target);
}
 
 
/**
 * 对输入的buf进行解压， 每次一定解压出2个uint64整数
 *
 * @param buf         输入的buf
 * @param valueArr    输出的数组，  需要预先开辟为2个uint64整数的数组
 *
 * @return buf 下一个可读byte
 */
inline const uint8_t *
group_varint_decode_uint64 ( const uint8_t * buf, uint64_t * valueArr )
{
    uint32_t int_arr[ 4 ] = {0};
 
    buf = group_varint_decode_uint32 ( buf, int_arr );
 
    valueArr[ 0 ] = (((uint64_t)(int_arr[0])) << 32) + int_arr[1];
    valueArr[ 1 ] = (((uint64_t)(int_arr[2])) << 32) + int_arr[3];
 
    return buf;
}
 
 
/** 解压时 并不把实际值取得， 只获取下一个可解压位置 , 一次忽略2个  uint64 */
inline const uint8_t *
group_varint_decode_uint64_skip( const uint8_t * buf )
{
    return group_varint_decode_uint32_skip ( buf );
}
 
 
 
/**
 * 对整数进行 zigZag编码，  有符号数 转换为 无符号数
 *
 * @param n  有符号数
 *
 * @return   无符号数
 */
inline uint32_t zigZag_encode32(int32_t  n) { return (n << 1) ^ (n >> 31); }
inline uint64_t zigZag_encode64(int64_t  n) { return (n << 1) ^ (n >> 63); }
 
 
/**
 * 对整数进行 zigZag 解码，  无符号数 转换为 有符号数
 *
 * @param n  无符号数
 *
 * @return   有符号数
 */
inline int32_t  zigZag_decode32(uint32_t n) { return (n >> 1) ^ -(int32_t)(n & 1); }
inline int64_t  zigZag_decode64(uint64_t n) { return (n >> 1) ^ -(int64_t)(n & 1); }
 

#endif /* VARINT_H_ */