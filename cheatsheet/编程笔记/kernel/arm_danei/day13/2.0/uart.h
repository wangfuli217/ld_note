#ifndef __UART_H
#define __UART_H

//函数声明
//初始化串口
extern void uart_init(void);
//TPAD发送一个字符
extern void uart_putc(char c);
//TPAD发送字符串
extern void uart_puts(char *s);
//TPAD接收字符
extern char uart_getc(void);
//TPAD接收字符串
extern void uart_gets(char *buf, int len);
#endif
