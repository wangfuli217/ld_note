.text
.code 32
.global reset @让vector.s调用
.extern main  @调用main.c的main主函数

@当发生reset异常,reset调用
@当go 20004000,reset调用
reset:

    @修改异常向量表的起始地址为0x20004000
    @首先进入SVC管理模式,权限最高
    msr cpsr_c, #0xd3 @修改cpsr的c域bit[0:7]
   
    @__vect_start地址就是0x20004000
    ldr r1, =__vect_start @将__vetc_start的地址给r1

    @将ARM寄存器r1的值p15协处理器传递c12,c0 
    @修改异常向量表的起始地址为0x20004000
    mcr p15, 0, r1, c12, c0, 0 
    
    ldr pc, start_armboot  @让CPU到main继续运行

start_armboot:
    .word  main

.end









