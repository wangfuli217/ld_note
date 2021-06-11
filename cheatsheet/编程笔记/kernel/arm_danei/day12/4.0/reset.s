.text
.code 32
.global reset
.extern main

reset:
    @配置异常向量表的入口地址从0x00改为0x20008000
    @必须首先切换到SVC管理模式
    msr cpsr_c, #0xd3
    ldr r1, =_vect_start @通过链接脚本指定_vect_start=0x20008000
    mcr p15,0,r1,c12,c0,0 @配置协处理器,将异常
                          @向量表的入口改为
                          @0x20008000

    ldr pc, start_armboot

start_armboot:
    .word main @复位最后执行main函数

.end
