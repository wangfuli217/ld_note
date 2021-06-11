#ifndef LJA_MACRO_H
#define LJA_MACRO_H

/**
 * @brief 《C语言接口与实现》第三章原子中使用的。计算数组x中元素的个数
 */
#define LJA_NELEMS(x) (sizeof((x)) / (sizeof((x)[0])))

#endif //LJA_MACRO_H

