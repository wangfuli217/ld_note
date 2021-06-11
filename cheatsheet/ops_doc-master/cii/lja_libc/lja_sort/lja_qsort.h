#ifndef LJA_QSORT_H
#define LJA_QSORT_H

#include  <assert.h>
#include  <stdio.h>
#include  <stdlib.h>

/**
 * @brief 对arry[begin]~arry[end]进行快排。
 *
 * @param arry  待排序的数组
 * @param step  数组元素的大小
 * @param begin 开始下标
 * @param end   结束下标
 * @param cmp   cmp(a,b) a>b返回1;a=b返回0;a<b返回-1
 * @param swap  swap(a,b) 交换a和b所指位置的值
 */
void lja_qsort_arry(void *arry, int step, int begin, int end,\
		int (*cmp)(void *a, void * b), void (*swap)(void *a, void *b));

/**
 * @brief 对arry[begin]~arry[end]进行分划，以arry[end]为分划值
 *
 * @param arry  待排序的数组
 * @param step  数组元素的大小
 * @param begin 开始下标
 * @param end   结束下标
 * @param cmp   cmp(a,b) a>b返回1;a=b返回0;a<b返回-1
 * @param swap  swap(a,b) 交换a和b所指位置的值
 *
 * @retval 返回分划值的位置
 */
int lja_qsort_part_arry(void *arry, int step, int begin, int end,\
		int (*cmp)(void *a, void *b), void (*swap)(void *a, void *b));

#endif //LJA_QSORT_H

