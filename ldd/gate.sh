DPL 描述符中的权限位确定的权限
DPL：特权级，0为最高特权级，3为最低，表示访问该段时CPU所需处于的最低特权级


gate(中断门)
{
中断门(interruptgate) 
        包含段选择符和中断或异常处理程序的段内偏移量.当控制权转移到一个适当的段时，处理器 清IF标志，
    从而关闭将来会发生的可屏蔽中断.

[linux]  
用户态的进程不能访问的一个lntel中断门(门的DPL字段为0)。所有的Linux中断处理程序都通过中断门激活，并全部限制在内核态。

static inline void set_intr_gate(unsigned int n, void *addr)
//在IDT的第n个表项插入一个中断门.门中的段选择符设置成内核代码的段选择符，偏移量设置为中断处理程序的地址addr， 
//DPL字段设置为0。
}

gate(系统中断门)
{
[linux] 
系统中断门(system interrupt gate)
    能够被用户态进程访问的Intel中断门(门的DPL字段为3). 与向量3相关的异常处理程序是由系统中断门激活的，因此，
在用户态可以使用汇编语言指令int3.

static inline void set_system_intr_gate(unsigned int n, void *addr) 
//在IDT的第n个表项插入一个中断门。门中的段选择符设置成内核代码的段选择符，偏移量设置为异常处理程序的地址addr， 
//DPL字段设置为3.
}

gate(陷阱门)
{
    与中断门相似，只是控制权传递到一个适当的段时处理器不修改IF标志.
以上为Intel对中断描述符的分类。Linux采用了更细的分类方法

[linux]
    用户态的进程不能访问的一个Inte)陷阱门(f]的DPL字段为0). 大部分Linux异常处理程序都通过陷阱门来激活.
    
static inline void set_trap_gate(unsigned int n, void *addr) 
//与set_system_intr_gate类似，只不过DPL的字段设置成O.
}

gate(任务门)
{
任务门(task gate) ：当中断信号发生时，必须取代当前进程的那个进程的TSS选择符存放在任务门中。
[linux]
不能被用户态进程访问的Intel任务门(门的DPL字段为0).Linux对"Doublefault"异常的处理程序是由任务门激活的.

static inline void set_task_gate(unsigned int n, unsigned int gdt_entry) 
//在IDT的第n个表项中插入一个中断门.门中的段选择符中存放一个TSS的全局描述符表的指针，该TSS中包含要被激活的函数.
//偏移量设置为0，而DPL字段设置为3.
}


gate(系统门)
{
[linux]  
    用户态的进程可以访问的一个Intel陷阱门(门的DPL字段为到.通过系统门来激活三个Linux异常处理程序，它们的向量是4，5
及128，因此，在用户态下.可以发布into、 bound及int $Ox80三条汇编语言指令。

}



