#ifndef __F1_H__
#define __F1_H__

extern unsigned int aaa; // cpp中变量需要导出的，最好是添加extern关键字，否则多个引用变量或者函数的文件就引发重复定义错误
                         // cpp中变量声明如果不加extern 就认为这是一个定义而不是声明

#endif
