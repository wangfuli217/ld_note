.text
.code 32
.global vector_start
.global vector_end
.extern reset

@异常向量表的入口地址(0x20008000)
@一旦异常发生,CPU就到0x20008000找入口
@链接脚本指定入口地址
vector_start:
    ldr pc, _reset @每次复位,CPU就执行
                   @这跳语句
    ldr pc, _undef_hdl
    ldr pc, _swi_hdl
    ldr pc, _pabt_hdl
    ldr pc, _dabt_hdl
    b .
    ldr pc, _irq_hdl
    ldr pc, _fiq_hdl

@定义复位的入口
_reset:
    .word reset @pc=reset，复位执行reset函数
   
_undef_hdl:
    .word _undef_handler

_swi_hdl:
    .word _swi_handler

_pabt_hdl:
    .word _pabt_handler

_dabt_hdl:
    .word _dabt_handler

    .word 0

_irq_hdl:
    .word _irq_handler

_fiq_hdl:
    .word _fiq_handler

vector_end:

.extern c_undef_handler
_undef_handler:
    b c_undef_handler @调用C的函数
    b .@死循环

.extern c_pabt_handler
_pabt_handler:
    b c_pabt_handler
    b .

.extern c_dabt_handler
_dabt_handler:
    b c_dabt_handler
    b .

.extern c_swi_handler
_swi_handler:
    b c_swi_handler
    b .

@irq中断处理函数的处理
.extern c_irq_handler
_irq_handler:
    @计算返回地址
    sub lr, lr, #4
    @保护现场
    stmfd sp!, {r0-r12, lr}
    @调用中断处理子函数
    bl c_irq_handler
    @恢复现场
    ldmfd sp!, {r0-r12, pc}^ @恢复到原先被打断的地方                                继续执行

@fiq中断处理函数的处理
.extern c_fiq_handler
_fiq_handler:
    @计算返回地址
    sub lr, lr, #4
    @保护现场
    stmfd sp!, {r0-r12, lr}
    @调用中断处理子函数
    bl c_fiq_handler
    @恢复现场
    ldmfd sp!, {r0-r12, pc}^ @恢复到原先被打断的地方                                继续执行

















