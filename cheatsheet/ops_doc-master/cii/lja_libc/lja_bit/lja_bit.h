#ifndef  LJA_BIT_H
#define  LJA_BIT_H

#include  <string.h>
#include  <stdlib.h>
#include  <assert.h>
#include  "lja_type.h"

/**
 * @brief bit结构体
 */
typedef struct lja_Bit{
	u_int32 size;  //!操作的位的总数
	u_char ptr[0]; //!位的内存起始位置
}lja_Bit;

/**
 * @brief 获取一个bit。根据size的值分配适当的内存，不再使用后需要调用lja_bit_free释放相应内存。
 *
 * @param size 分配的位的总数
 *
 * @retval 非NULL 分配到的lja_Bit
 * @retval NULL 分配失败
 */
lja_Bit *lja_bit_new(u_int32 size);

/**
 * @brief 设置指定的位。
 *
 * @param bit bit
 * @param pos 要设置的位。pos超出范围将触发断言。
 *
 */
void lja_bit_set(lja_Bit *bit, u_int32 pos);

/**
 * @brief 获取指定的位的值。
 *
 * @param bit bit
 * @param pos 要获取的位。pos超出范围将触发断言。
 *
 * @retval
 */
u_int8 lja_bit_get(lja_Bit *bit, u_int32 pos);

/**
 * @brief 清除指定的位。
 *
 * @param bit bit
 * @param pos 要清除的位。pos超出范围将触发断言。
 */
void lja_bit_reset(lja_Bit *bit, u_int32 pos);

/**
 * @brief 清楚所有的位
 *
 * @param bit
 */
void lja_bit_clean(lja_Bit *bit);

/**
 * @brief 释放bit。不再使用bit时需要调用这个函数进行释放。
 *
 * @param bit bit
 */
void lja_bit_free(lja_Bit *bit);

#endif  /*LJA_BITS_H*/
