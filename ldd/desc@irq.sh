http://www.cnblogs.com/langlang/archive/2012/04/18/2456020.html


重要的数据结构
struct irq_desc {
    irq_flow_handler_t    handle_irq; /*当前中断处理函数入口*/
    struct irq_chip        *chip;        /*底层的硬件访问*/
    struct irqaction①    *action;    /*用户提供的中断处理函数链表 */
    unsigned int        status;        /* IRQ status */
    const char        *name;  /*中断名称*/
} ____cacheline_internodealigned_in_smp;

struct irqaction ①{
    irq_handler_t handler;    //中断处理函数
    unsigned long flags;    /*中断标志：是否共享中断，电平触发，边缘触发。。。*/
    const char *name;        /*/pro/interrupts 下显示*/
    void *dev_id;
    struct irqaction *next;  /*链表  指向下一个*/
    int irq;                /*中断号*/
    struct proc_dir_entry *dir;
    irq_handler_t thread_fn;
    struct task_struct *thread;
    unsigned long thread_flags;
};


void __init start_kernel(void)//linux c语言入口
{
    setup_arch(char **cmdline_p);
    init_IRQ();
    {
        //初始化状态
        for (irq = 0; irq < NR_IRQS; irq++)
            irq_desc[irq].status |= IRQ_NOREQUEST | IRQ_NOPROBE;

        init_arch_irq();
        {
            1.ask:    不同架构的处理器中断初始化函数是不一样的，该函数中怎么去处理?
            1.answer: 在arch\arm\kernel\Setup.c中
            struct machine_desc * mdesc = setup_machine(machine_arch_type);
            init_arch_irq = mdesc->init_irq;
            mdesc->init_irq在哪里定义？
            架构相关: arch\arm\mach-s3c2440\mach-smdk2440.c
            MACHINE_START(TCT_HAMMER, "TCT_HAMMER")
                .phys_io    = S3C2410_PA_UART,
                .io_pg_offst    = (((u32)S3C24XX_VA_UART) >> 18) & 0xfffc,
                .boot_params    = S3C2410_SDRAM_PA + 0x100,
                .map_io        = tct_hammer_map_io,
                .init_irq    = s3c24xx_init_irq,//★
                .init_machine    = tct_hammer_init,
                .timer        = &s3c24xx_timer,
            MACHINE_END
            2.ask:    s3c24xx_init_irq 做了什么处理？
            2.answer: arch\arm\plat-s3c24xx\Irq.c
            for (irqno = IRQ_EINT4t7; irqno <= IRQ_ADCPARENT; irqno++) {
                //(1)设置芯片 
                set_irq_chip(irqno, &s3c_irq_chip);
                {
                    struct irq_desc *desc = irq_to_desc(irq);
                    desc->chip = chip;//填充chip
                }
                //(2)设置处理函数
                set_irq_handler(irqno, handle_edge_irq);
                {
                    __set_irq_handler(irq, handle, 0, NULL);
                    __set_irq_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
                                                const char *name)
                    {
                        desc->handle_irq = handle;  //处理函数
                        desc->name = name; //NULL
                    }
                }
                //(3)IRQF_VALID表示可以使用它们了
                set_irq_flags(irqno, IRQF_VALID); 
            }
            set_irq_chained_handler(IRQ_EINT4t7, s3c_irq_demux_extint4t7);
            {
                __set_irq_handler(irq, handle, 1, NULL);
            }
            set_irq_chained_handler(IRQ_EINT8t23, s3c_irq_demux_extint8);

            set_irq_chained_handler(IRQ_UART0, s3c_irq_demux_uart0);
            set_irq_chained_handler(IRQ_UART1, s3c_irq_demux_uart1);
            set_irq_chained_handler(IRQ_UART2, s3c_irq_demux_uart2);
            set_irq_chained_handler(IRQ_ADCPARENT, s3c_irq_demux_adc);
        }
    }
}

用户注册中断过程分析
include\linux\Interrupt.h
static inline int __must_check
request_irq(unsigned int irq, irq_handler_t handler, unsigned long flags,
        const char *name, void *dev)
{
    return request_threaded_irq(irq, handler, NULL, flags, name, dev);
}
request_threaded_irq 分析
kernel\irq\Manage.c
/**
 *    request_threaded_irq - allocate an interrupt line
 *    @irq: Interrupt line to allocate
 *    @handler: Function to be called when the IRQ occurs.
 *          Primary handler for threaded interrupts
 *          If NULL and thread_fn != NULL the default
 *          primary handler is installed
 *    @thread_fn: Function called from the irq handler thread
 *            If NULL, no irq thread is created
 *    @irqflags: Interrupt type flags
 *    @devname: An ascii name for the claiming device
 *    @dev_id: A cookie passed back to the handler function
 */
int request_threaded_irq(unsigned int irq, irq_handler_t handler,
             irq_handler_t thread_fn, unsigned long irqflags,
             const char *devname, void *dev_id)
{
    struct irqaction *action;     //中断处理程序
    struct irq_desc *desc;        //中断描述数组
    action = kzalloc(sizeof(struct irqaction), GFP_KERNEL);

    action->handler = handler;//中断处理程序
    action->thread_fn = thread_fn;
    action->flags = irqflags;
    action->name = devname;
    action->dev_id = dev_id;
    desc = irq_to_desc(irq);//获取到相应的中断描述
    __setup_irq(irq, desc, action);
    __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
    {
        old_ptr = &desc->action;
        old = *old_ptr;
        do {
            old_ptr = &old->next;
            old = *old_ptr;
        } while (old); //找到用户中断处理函数的最后一个
        *old_ptr = new;
        
        irq_chip_set_defaults(desc->chip);
        //设置触发方式
        __irq_set_trigger(desc, irq,new->flags & IRQF_TRIGGER_MASK);
        new->irq = irq;
        //启动中断
        desc->chip->startup(irq);
    }
}



当IRQ中断发生时：C语言入口函数asm_do_IRQ
void __exception asm_do_IRQ(unsigned int irq, struct pt_regs *regs)
{
    generic_handle_irq(irq);
    {
        generic_handle_irq_desc(irq, irq_to_desc(irq));
        {
            //irq 中断号 , irq_to_desc(irq)中断描述
            desc->handle_irq(irq, desc);
            1.ask 这是怎么处理的？
            2.answer 例子： desc初始化的时候
            set_irq_handler(irqno, handle_edge_irq); //执行的是handle_edge_irq
            void handle_edge_irq(unsigned int irq, struct irq_desc *desc)
            {
                do {
                    struct irqaction *action = desc->action;
                    handle_IRQ_event(irq, action);
                    {
                        do {
                            //★ 逐个调用用户在action链表中注册的处理函数
                            ret = action->handler(irq, action->dev_id);
                            action = action->next;
                        }while (action);
                    }
                }while ((desc->status & (IRQ_PENDING | IRQ_DISABLED)) == IRQ_PENDING);
            }
        }
    }