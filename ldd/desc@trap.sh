http://www.cnblogs.com/langlang/archive/2012/04/18/2456016.html

void __init start_kernel(void)//linux c语言入口
{
    
    setup_arch(char **cmdline_p)
    {
        early_trap_init();//设置各种异常的处理向量
        {
            unsigned long vectors = CONFIG_VECTORS_BASE;
            memcpy((void *)vectors, __vectors_start, __vectors_end - __vectors_start);
            memcpy((void *)vectors + 0x200, __stubs_start, __stubs_end - __stubs_start);
            memcpy((void *)vectors + 0x1000 - kuser_sz, __kuser_helper_start, kuser_sz);
            
            1. ask:    CONFIG_VECTORS_BASE在哪里定义，值是多少？
            1. answer: make menuconfig配置内核之后产生的.config文件中保护了CONFIG_VECTORS_BASE的定义：
            CONFIG_VECTORS_BASE=0xffff0000， 也就是说异常向量表会被复制到0xffff0000处。
            2. ask:    __vectors_start，__vectors_end，__stubs_start，__stubs_end 在哪里定义，值是多少？
            2. answer: arch\arm\kernel\entry-armv.S
            __stubs_end:
                .equ    stubs_offset, __vectors_start + 0x200 - __stubs_start
            .globl    __vectors_start
            __vectors_start:
            ARM(    swi    SYS_ERROR0    )    //复位时，CPU执行这一条指令
            THUMB(    svc    #0        )    
            THUMB(    nop            )
                W(b)    vector_und + stubs_offset  //未定义异常,CPU将跳到这一条指令
                W(ldr)    pc, .LCvswi + stubs_offset //swi异常
                W(b)    vector_pabt + stubs_offset //指令预取异常
                W(b)    vector_dabt + stubs_offset //数据访问异常
                W(b)    vector_addrexcptn + stubs_offset //
                W(b)    vector_irq + stubs_offset      //irq异常
                W(b)    vector_fiq + stubs_offset      //fiq异常
            3. ask: 怎么跳到C语言的函数?
            3. answer: vector_stub宏的功能：
            (1). 计算处理异常后的返回地址
            (2). 进入管理模式
            (3). 跳到某个分支
                vector_stub    irq, IRQ_MODE, 4
                .long    __irq_usr            @  0  (USR_26 / USR_32)
                .long    __irq_invalid            @  1  (FIQ_26 / FIQ_32)
                .long    __irq_invalid            @  2  (IRQ_26 / IRQ_32)
                .long    __irq_svc            @  3  (SVC_26 / SVC_32)
            例：跳到__irq_usr
            __irq_usr:
                irq_handler //宏
                {
                    .macro    irq_handler
                    ........
                    bne    asm_do_IRQ  //asm_do_IRQ C语言入口函数
                }
        }  
    }       
    

    init_IRQ();