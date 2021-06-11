#ifndef  __IRQ_H__
#define  __IRQ_H__

#define EXINT0CON   (*(volatile unsigned int *)0xE0200E00)
#define EXINT0FLT   (*(volatile unsigned int *)0xE0200E80)
#define EXINT0MASK  (*(volatile unsigned int *)0xE0200F00)
#define EXINT0PEND  (*(volatile unsigned int *)0xE0200F40)
#define VIC0INTSELECT  (*(volatile unsigned int *)0xF200000C)
#define VIC0INTENABLE  (*(volatile unsigned int *)0xF2000010)
#define VIC0INTCLEAR   (*(volatile unsigned int *)0xF2000014)
#define VIC0VECTADDR0   (*(volatile unsigned int *)0xF2000100)
#define VIC0ADDRESS     (*(volatile unsigned int *)0xF2000F00)
#define GPH0CFG   (*((volatile unsigned int*)0xE0200C00))
#define GPH0DAT   (*((volatile unsigned int*)0xE0200C04))
#define GPH0PUD   (*((volatile unsigned int*)0xE0200C08))

void enable_irq(void);
void disable_irq(void);
void irq_init(void);

#endif  //__IRQ_H__

