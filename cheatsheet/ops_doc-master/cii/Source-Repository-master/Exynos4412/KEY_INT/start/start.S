.text
.global _start
_start:
		@ 异常向量表  偏移地址顺序不能改变
		b		reset
		ldr		pc,_undefined_instruction
		ldr		pc,_software_interrupt
		ldr		pc,_prefetch_abort
		ldr		pc,_data_abort
		@ 保留的向量表也要填充一条指令，否则后面的向量表地址会出现偏移
		ldr		pc,_not_used
		ldr		pc,_irq
		ldr		pc,_fiq

@ 将各个异常处理函数的入口地址保存在当前位置
_undefined_instruction: .word  _undefined_instruction
_software_interrupt:	.word  _software_interrupt
_prefetch_abort:		.word  _prefetch_abort
_data_abort:			.word  _data_abort
_not_used:			    .word  _not_used
_irq:				    .word  irq_handler
_fiq:				    .word  _fiq


reset:
	@ 设置异常向量表重新定位在0x40008000地址处存放
	ldr	r0,=0x40008000
	mcr	p15,0,r0,c12,c0,0		@ Vector Base Address Register

	@ 初始化其他硬件接口
		mrs  	r0,cpsr
		bic		r0,r0,#0x1f
		orr		r0,r0,#0xd3
		msr		cpsr,r0         @ Enable svc mode of cpu

    	mov	r0, #0xfffffff
      	mcr	p15, 0, r0, c1, c0, 2  	@ Defines access permissions for each coprocessor
									@ Privileged and User mode access

	/*
	 * Invalidate L1 I/D
	 */
	mov	r0, #0			@ set up for MCR
	mcr	p15, 0, r0, c8, c7, 0	@ invalidate TLBs
	mcr	p15, 0, r0, c7, c5, 0	@ invalidate icache


	@Set the FPEXC EN bit to enable the FPU:
	MOV r3, #0x40000000
	fmxr FPEXC, r3

	/*
	 * disable MMU stuff and caches
	 */
	mrc	p15, 0, r0, c1, c0, 0
	bic	r0, r0, #0x00002000	@ clear bits 13 (--V-)
	bic	r0, r0, #0x00000007	@ clear bits 2:0 (-CAM)
	orr	r0, r0, #0x00001000	@ set bit 12 (---I) Icache
	orr	r0, r0, #0x00000002	@ set bit 1  (--A-) Align
	orr	r0, r0, #0x00000800	@ set bit 11 (Z---) BTB
	mcr	p15, 0, r0, c1, c0, 0

/* LED Test Code */

	ldr r0, =0x114001E0
	ldr r1, [r0]
	bic r1, r1, #0xf0000
	orr r1, r1, #0x10000
	str r1, [r0]

	ldr r0, =0x114001E8
	ldr r1, [r0]
	bic r1, r1, #0x300
	str r1, [r0]

	ldr r0, =0x114001E4
	ldr r1, [r0]
	orr r1, r1, #0x10
	str r1, [r0]

@ 初始化各个模式的栈空间
init_stack:
		@ 将整个栈空间的栈顶赋值给R0
		ldr		r0,stacktop         /*get stack top pointer*/

	/********svc mode stack********/
		@ 初始化SVC模式下的栈
		mov		sp,r0
		@ 栈顶下降512字节
		sub		r0,#128*4          /*512 byte  for irq mode of stack*/
	/****irq mode stack**/
		@ 切换模式到IRQ模式
		msr		cpsr,#0xd2
		@ 初始化IRQ模式下的栈顶
		mov		sp,r0
		@ 栈顶下降512字节
		sub		r0,#128*4          /*512 byte  for irq mode of stack*/
	/***fiq mode stack***/
		msr 	cpsr,#0xd1
		mov		sp,r0
		sub		r0,#0
	/***abort mode stack***/
		msr		cpsr,#0xd7
		mov		sp,r0
		sub		r0,#0
	/***undefine mode stack***/
		msr		cpsr,#0xdb
		mov		sp,r0
		sub		r0,#0
   /*** sys mode and usr mode stack ***/
		msr		cpsr,#0x10
		mov		sp,r0             /*1024 byte  for user mode of stack*/

		@ 跳转到main函数
		b		main

	.align	4

	/****  swi_interrupt handler  ****/


/****  irq_handler  ****/
@ 中断处理函数
irq_handler:
	@ 返回地址修正
	sub  lr,lr,#4
	@ 进一步保存现场  将R0-R12寄存器中的值保存到栈空间   同时把返回地址也压栈
	stmfd sp!,{r0-r12,lr}
	@ 伪操作  do_irq函数没定义是编译时不报错
	.weak do_irq
	@ 跳转到中断处理函数  保存返回地址到LR中
	bl	do_irq
	@ 出栈恢复现场  同时将LR赋值给PC实现程序的返回  ^表示出栈的同时恢复CPSR
	ldmfd sp!,{r0-r12,pc}^

@ 栈顶初始化在了栈空间的最高地址处  因为使用的栈是满减栈
stacktop:    .word 		stack+4*512

@ 将栈空间初始化在数据段内
.data
@ 在当前位置申请了4*512个字节的空间作为栈空间
stack:	 .space  4*512
