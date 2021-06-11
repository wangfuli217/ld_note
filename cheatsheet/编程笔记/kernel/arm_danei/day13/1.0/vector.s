.text
.code 32
.global vector_start
.global vector_end

.extern reset  @外部调用声明

@异常向量表的入口地址 (0x20004000)
vector_start:      @编译链接时将地址链接到0x00或者别的地址(重                     @新定义)
    ldr pc, _reset @发生复位异常,就执行这条指令
                   @就是让CPU到reset函数中去执行
    ldr pc, _und_hdl @hdl=handle
    ldr pc, _swi_hdl
    ldr pc, _pabt_hdl
    ldr pc, _dabt_hdl
    b .
    ldr pc, _irq_hdl @外设给CPU发生中断信号,CPU就执行这个指令
    ldr pc, _fiq_hdl

@定义异常向量表的入口函数
_reset:
    .word reset

_und_hdl:
    .word _und_handler

_swi_hdl:
    .word _swi_handler

_pabt_hdl:
    .word _pabt_handler

_dabt_hdl:
    .word _dabt_handler

    .word 0  @保留

_irq_hdl:
    .word _irq_handler

_fiq_hdl:
    .word _fiq_handler

vector_end:

@编写异常入口的入口函数
@reset入口函数单独放在reset.s中实现
@其余放在vector.s中实现

.extern c_und_handler
_und_handler: @未定义入口函数
    b c_und_handler @不带返回跳转到C语言实现的一个函数
    b . @死循环
    
.extern c_pabt_handler
_pabt_handler: @预取入口函数
    b c_pabt_handler
    b .

.extern c_dabt_handler
_dabt_handler: @数据入口函数
    b c_dabt_handler
    b .

.extern c_swi_handler
_swi_handler: @软中断
    b c_swi_handler
    b .

_irq_handler:
    sub lr, lr, #4
    @保护被打断事务的现场,压栈
    stmfd sp!, {r0-r12, lr}
    @调用自己编写中断处理函数
    bl c_irq_handler  @调用C语言实现的中断处理函数
    @恢复被打断事务的现场
    ldmfd sp!, {r0-r12, pc}^ 

_fiq_handler:
    sub lr, lr, #4
    @保护被打断事务的现场,压栈
    stmfd sp!, {r0-r12,lr}
    @调用自己编写中断处理函数
    bl c_fiq_handler  @调用C语言实现的中断处理函数
    @恢复被打断事务的现场
    ldmfd sp!, {r0-r12,pc}^ 

    .global enable_irq
enable_irq: @开启IRQ的总中断
    mrs r0, cpsr
    bic r0, r0, #0x80
    msr cpsr, r0
    mov pc, lr

    .global disable_irq
disable_irq: @关闭IRQ的总中断
    mov pc, lr
.end




























