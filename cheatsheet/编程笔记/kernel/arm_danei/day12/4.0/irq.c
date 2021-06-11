#include "uart.h"

void c_swi_handler(void)
{
    uart_puts("c_swi_handler\n");
    //FIXME:TODO
    while (1) {
        ;
    }
}

void c_undef_handler(void)
{
    uart_puts("c_undef_handler\n");
    //FIXME:TODO
    while(1) {
        ;
    }
} 
void c_pabt_handler(void)
{
    uart_puts("c_pabt_handler\n");
    while (1) {
        ;
    }
}

void c_dabt_handler(void)
{
    uart_puts("c_dabt_handler\n");
    while (1) {
        ;
    }
}

void c_irq_handler(void)
{
    uart_puts("c_irq_handler\n");
    /*区分外设按键,根据不同的按键做不同的事情*/
}

void c_fiq_handler(void)
{
    uart_puts("c_fiq_handler\n");
}













