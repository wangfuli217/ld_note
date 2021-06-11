boot(启动条件)
{
一. 启动条件
通常从系统上电到执行到linux kenel这部分的任务是由boot loader来完成.
关于boot loader的内容,本文就不做过多介绍.
这里只讨论进入到linux kernel的时候的一些限制条件,这一般是boot loader在最后跳转到kernel之前要完成的:
1. CPU必须处于SVC(supervisor)模式,并且IRQ和FIQ中断都是禁止的;
2. MMU(内存管理单元)必须是关闭的, 此时虚拟地址对物理地址;
3. 数据cache(Data cache)必须是关闭的
4. 指令cache(Instruction cache)可以是打开的,也可以是关闭的,这个没有强制要求;
5. CPU 通用寄存器0 (r0)必须是 0;
6. CPU 通用寄存器1 (r1)必须是 ARM Linux machine type (关于machine type, 我们后面会有讲解)
7. CPU 通用寄存器2 (r2) 必须是 kernel parameter list 的物理地址(parameter list 是由boot loader传递给kernel,用来描述设备
   信息属性的列表,详细内容可参考"Booting ARM Linux"文档).
}

starting_kernel()
{
首先，我们先对几个重要的宏进行说明(我们针对有MMU的情况)：

- arm linux 从入口到start_kernel 代码分析

     宏                 位置                           默认值          说明
KERNEL_RAM_ADDR  arch/arm/kernel/head.S +26          0xc0008000      kernel在RAM中的的虚拟地址
PAGE_OFFSET      include/asm-arm/memeory.h +50       0xc0000000      内核空间的起始虚拟地址
TEXT_OFFSET      arch/arm/Makefile +137              0x00008000      内核相对于存储空间的偏移
TEXTADDR         arch/arm/kernel/head.S +49          0xc0008000      kernel的起始虚拟地址
PHYS_OFFSET      include/asm-arm/arch-xxx/memory.h   平台相关        RAM的起始物理地址


内核的入口是stext,这是在arch/arm/kernel/vmlinux.lds.S中定义的:
00011: ENTRY(stext)
对于vmlinux.lds.S,这是ld script文件,此文件的格式和汇编及C程序都不同,本文不对ld script作过多的介绍,只对内核中用到的内容进行讲解,关于ld的详细内容可以参考ld.info
这里的ENTRY(stext) 表示程序的入口是在符号stext.
而符号stext是在arch/arm/kernel/head.S中定义的:
下面我们将arm linux boot的主要代码列出来进行一个概括的介绍,然后,我们会逐个的进行详细的讲解.


}

headS(head.S)
{
在arch/arm/kernel/head.S中 72 - 94 行,是arm linux boot的主代码:

00072: ENTRY(stext)                                                      
00073:  msr cpsr_c, #PSR_F_BIT | PSR_I_BIT | SVC_MODE @ ensure svc mode
00074:       @ and irqs disabled      
00075:  mrc p15, 0, r9, c0, c0  @ get processor id       
00076:  bl __lookup_processor_type  @ r5=procinfo r9=cpuid   
00077:  movs r10, r5    @ invalid processor (r5=0)?
00078:  beq __error_p   @ yes, error 'p'         
00079:  bl __lookup_machine_type  @ r5=machinfo            
00080:  movs r8, r5    @ invalid machine (r5=0)?
00081:  beq __error_a   @ yes, error 'a'         
00082:  bl __create_page_tables                                     
00083:                                                                   
00084:                                                                
00091:  ldr r13, __switch_data  @ address to jump to after
00092:       @ mmu has been enabled   
00093:  adr lr, __enable_mmu  @ return (PIC) address   
00094:  add pc, r10, #PROCINFO_INITFUNC                              


其中,73行是确保kernel运行在SVC模式下,并且IRQ和FIRQ中断已经关闭,这样做是很谨慎的.

arm linux boot的主线可以概括为以下几个步骤:
1. 确定 processor type                    (75 - 78行)
2. 确定 machine type                      (79 - 81行)
3. 创建页表                               (82行)   
4. 调用平台特定的__cpu_flush函数          (在struct proc_info_list中) (94 行)                          
5. 开启mmu                                (93行)
6. 切换数据                               (91行)

最终跳转到start_kernel                 (在__switch_data的结束的时候,调用了 b start_kernel)

下面,我们按照这个主线,逐步的分析Code.

}

processor_type(processor type)
{
1. 确定 processor type

    arch/arm/kernel/head.S中:
00075:  mrc p15, 0, r9, c0, c0  @ get processor id       
00076:  bl __lookup_processor_type  @ r5=procinfo r9=cpuid   
00077:  movs r10, r5    @ invalid processor (r5=0)?
00078:  beq __error_p   @ yes, error 'p'         

75行: 通过cp15协处理器的c0寄存器来获得processor id的指令. 关于cp15的详细内容可参考相关的arm手册

76行: 跳转到__lookup_processor_type.在__lookup_processor_type中,会把processor type 存储在r5中
77,78行: 判断r5中的processor type是否是0,如果是0,说明是无效的processor type,跳转到__error_p(出错)

__lookup_processor_type 函数主要是根据从cpu中获得的processor id和系统中的proc_info进行匹配,将匹配到的proc_info_list的基地址存到r5中, 0表示没有找到对应的processor type.

下面我们分析__lookup_processor_type函数
arch/arm/kernel/head-common.S中:

00145:  .type __lookup_processor_type, %function
00146: __lookup_processor_type:
00147:  adr r3, 3f
00148:  ldmda r3, {r5 - r7}
00149:  sub r3, r3, r7   @ get offset between virt&phys
00150:  add r5, r5, r3   @ convert virt addresses to
00151:  add r6, r6, r3   @ physical address space
00152: 1: ldmia r5, {r3, r4}   @ value, mask
00153:  and r4, r4, r9   @ mask wanted bits
00154:  teq r3, r4
00155:  beq 2f
00156:  add r5, r5, #PROC_INFO_SZ  @ sizeof(proc_info_list)
00157:  cmp r5, r6
00158:  blo 1b
00159:  mov r5, #0    @ unknown processor
00160: 2: mov pc, lr
00161:
00162:
00165: ENTRY(lookup_processor_type)
00166:  stmfd sp!, {r4 - r7, r9, lr}
00167:  mov r9, r0
00168:  bl __lookup_processor_type
00169:  mov r0, r5
00170:  ldmfd sp!, {r4 - r7, r9, pc}
00171:
00172:
00176:  .long __proc_info_begin
00177:  .long __proc_info_end
00178: 3: .long .
00179:  .long __arch_info_begin
00180:  .long __arch_info_end

  
145, 146行是函数定义
147行: 取地址指令,这里的3f是向前symbol名称是3的位置,即第178行,将该地址存入r3.
        这里需要注意的是,adr指令取址,获得的是基于pc的一个地址,要格外注意,这个地址是3f处的"运行时地址",由于此时MMU还没有打开,也可以理解成物理地址(实地址).(详细内容可参考arm指令手册)
      
148行: 因为r3中的地址是178行的位置的地址,因而执行完后:
        r5存的是176行符号 __proc_info_begin的地址;
        r6存的是177行符号 __proc_info_end的地址;
        r7存的是3f处的地址.
        这里需要注意链接地址和运行时地址的区别. r3存储的是运行时地址(物理地址),而r7中存储的是链接地址(虚拟地址).
      
         __proc_info_begin和__proc_info_end是在arch/arm/kernel/vmlinux.lds.S中:
        00031:  __proc_info_begin = .;
        00032:   *(.proc.info.init)
        00033:  __proc_info_end = .;

        这里是声明了两个变量:__proc_info_begin 和 __proc_info_end,其中等号后面的"."是location counter(详细内容请参考ld.info)
        这三行的意思是: __proc_info_begin 的位置上,放置所有文件中的 ".proc.info.init" 段的内容,然后紧接着是 __proc_info_end 的位置.

        kernel 使用struct proc_info_list来描述processor type.
         在 include/asm-arm/procinfo.h 中:
        00029: struct proc_info_list {
        00030:  unsigned int  cpu_val;
        00031:  unsigned int  cpu_mask;
        00032:  unsigned long  __cpu_mm_mmu_flags;
        00033:  unsigned long  __cpu_io_mmu_flags;
        00034:  unsigned long  __cpu_flush; 
        00035:  const char  *arch_name;
        00036:  const char  *elf_name;
        00037:  unsigned int  elf_hwcap;
        00038:  const char  *cpu_name;
        00039:  struct processor *proc;
        00040:  struct cpu_tlb_fns *tlb;
        00041:  struct cpu_user_fns *user;
        00042:  struct cpu_cache_fns *cache;
        00043: };
      
        我们当前以at91为例,其processor是926的.
                在arch/arm/mm/proc-arm926.S 中:
        00464:  .section ".proc.info.init", #alloc, #execinstr
        00465:
        00466:  .type __arm926_proc_info,#object
        00467: __arm926_proc_info:
        00468:  .long 0x41069260   @ ARM926EJ-S (v5TEJ)
        00469:  .long 0xff0ffff0
        00470:  .long   PMD_TYPE_SECT | \
        00471:   PMD_SECT_BUFFERABLE | \
        00472:   PMD_SECT_CACHEABLE | \
        00473:   PMD_BIT4 | \
        00474:   PMD_SECT_AP_WRITE | \
        00475:   PMD_SECT_AP_READ
        00476:  .long   PMD_TYPE_SECT | \
        00477:   PMD_BIT4 | \
        00478:   PMD_SECT_AP_WRITE | \
        00479:   PMD_SECT_AP_READ
        00480:  b __arm926_setup
        00481:  .long cpu_arch_name
        00482:  .long cpu_elf_name
        00483:  .long HWCAP_SWP|HWCAP_HALF|HWCAP_THUMB|HWCAP_FAST_MULT|HWCAP_VFP|HWCAP_EDSP|HWCAP_JAVA
        00484:  .long cpu_arm926_name
        00485:  .long arm926_processor_functions
        00486:  .long v4wbi_tlb_fns
        00487:  .long v4wb_user_fns
        00488:  .long arm926_cache_fns
        00489:  .size __arm926_proc_info, . - __arm926_proc_info
      
        从464行,我们可以看到 __arm926_proc_info 被放到了".proc.info.init"段中.
        对照struct proc_info_list,我们可以看到 __cpu_flush的定义是在480行,即__arm926_setup.(我们将在"4. 调用平台特定的__cpu_flush函数"一节中详细分析这部分的内容.)
      
从以上的内容我们可以看出: r5中的__proc_info_begin是proc_info_list的起始地址, r6中的__proc_info_end是proc_info_list的结束地址.

149行: 从上面的分析我们可以知道r3中存储的是3f处的物理地址,而r7存储的是3f处的虚拟地址,这一行是计算当前程序运行的物理地址和虚拟地址的差值,将其保存到r3中.

150行: 将r5存储的虚拟地址(__proc_info_begin)转换成物理地址
151行: 将r6存储的虚拟地址(__proc_info_end)转换成物理地址
152行: 对照struct proc_info_list,可以得知,这句是将当前proc_info的cpu_val和cpu_mask分别存r3, r4中
153行: r9中存储了processor id(arch/arm/kernel/head.S中的75行),与r4的cpu_mask进行逻辑与操作,得到我们需要的值
154行: 将153行中得到的值与r3中的cpu_val进行比较
155行: 如果相等,说明我们找到了对应的processor type,跳到160行,返回
156行: (如果不相等) , 将r5指向下一个proc_info,
157行: 和r6比较,检查是否到了__proc_info_end.
158行: 如果没有到__proc_info_end,表明还有proc_info配置,返回152行继续查找
159行: 执行到这里,说明所有的proc_info都匹配过了,但是没有找到匹配的,将r5设置成0(unknown processor)
160行: 返回

}

machine_type(machine type)
{
2. 确定 machine type

arch/arm/kernel/head.S中:
00079: bl __lookup_machine_type @ r5=machinfo
00080: movs r8, r5 @ invalid machine (r5=0)?
00081: beq __error_a @ yes, error 'a'

79行: 跳转到__lookup_machine_type函数,在__lookup_machine_type中,会把struct machine_desc的基地址(machine type)存储在r5中
80,81行: 将r5中的 machine_desc的基地址存储到r8中,并判断r5是否是0,如果是0,说明是无效的machine type,跳转到__error_a(出错)

__lookup_machine_type 函数
下面我们分析__lookup_machine_type 函数:

arch/arm/kernel/head-common.S中:

00176: .long __proc_info_begin
00177: .long __proc_info_end
00178: 3: .long .
00179: .long __arch_info_begin
00180: .long __arch_info_end
00181:
00182:
00193: .type __lookup_machine_type, %function
00194: __lookup_machine_type:
00195: adr r3, 3b
00196: ldmia r3, {r4, r5, r6}
00197: sub r3, r3, r4 @ get offset between virt&phys
00198: add r5, r5, r3 @ convert virt addresses to
00199: add r6, r6, r3 @ physical address space
00200: 1: ldr r3, [r5, #MACHINFO_TYPE] @ get machine type
00201: teq r3, r1 @ matches loader number?
00202: beq 2f @ found
00203: add r5, r5, #SIZEOF_MACHINE_DESC @ next machine_desc
00204: cmp r5, r6
00205: blo 1b
00206: mov r5, #0 @ unknown machine
00207: 2: mov pc, lr

193, 194行: 函数声明
195行: 取地址指令,这里的3b是向后symbol名称是3的位置,即第178行,将该地址存入r3.
和上面我们对__lookup_processor_type 函数的分析相同,r3中存放的是3b处物理地址.
196行: r3是3b处的地址,因而执行完后:
r4存的是 3b处的地址
r5存的是__arch_info_begin 的地址
r6存的是__arch_info_end 的地址

arm linux 从入口到start_kernel 代码分析
__arch_info_begin 和 __arch_info_end是在 arch/arm/kernel/vmlinux.lds.S中:

00034: __arch_info_begin = .;
00035: *(.arch.info.init)
00036: __arch_info_end = .;


这里是声明了两个变量:__arch_info_begin 和 __arch_info_end,其中等号后面的"."是location counter(详细内容请参考ld.info)
这三行的意思是: __arch_info_begin 的位置上,放置所有文件中的 ".arch.info.init" 段的内容,然后紧接着是 __arch_info_end 的位置.

kernel 使用struct machine_desc 来描述 machine type.
在 include/asm-arm/mach/arch.h 中:

00017: struct machine_desc {
00018:
00022: unsigned int nr;
00023: unsigned int phys_io;
00024: unsigned int io_pg_offst;
00026:
00027: const char *name;
00028: unsigned long boot_params;
00029:
00030: unsigned int video_start;
00031: unsigned int video_end;
00032:
00033: unsigned int reserve_lp0 :1;
00034: unsigned int reserve_lp1 :1;
00035: unsigned int reserve_lp2 :1;
00036: unsigned int soft_reboot :1;
00037: void (*fixup)(struct machine_desc *,
00038: struct tag *, char **,
00039: struct meminfo *);
00040: void (*map_io)(void);
00041: void (*init_irq)(void);
00042: struct sys_timer *timer;
00043: void (*init_machine)(void);
00044: };
00045:
00046:
00050: #define MACHINE_START(_type,_name) \
00051: static const struct machine_desc __mach_desc_##_type \
00052: __attribute_used__ \
00053: __attribute__((__section__(".arch.info.init"))) = { \
00054: .nr = MACH_TYPE_##_type, \
00055: .name = _name,
00056:
00057: #define MACHINE_END \
00058: };

内核中,一般使用宏MACHINE_START来定义machine type.
对于at91, 在 arch/arm/mach-at91rm9200/board-ek.c 中:
00137: MACHINE_START(AT91RM9200EK, "Atmel AT91RM9200-EK")
00138:
00139: .phys_io = AT91_BASE_SYS,
00140: .io_pg_offst = (AT91_VA_BASE_SYS >> 18) & 0xfffc,
00141: .boot_params = AT91_SDRAM_BASE + 0x100,
00142: .timer = &at91rm9200_timer,
00143: .map_io = ek_map_io,
00144: .init_irq = ek_init_irq,
00145: .init_machine = ek_board_init,
00146: MACHINE_END


197行: r3中存储的是3b处的物理地址,而r4中存储的是3b处的虚拟地址,这里计算处物理地址和虚拟地址的差值,保存到r3中
198行: 将r5存储的虚拟地址(__arch_info_begin)转换成物理地址
199行: 将r6存储的虚拟地址(__arch_info_end)转换成物理地址
200行: MACHINFO_TYPE 在 arch/arm/kernel/asm-offset.c 101行定义, 这里是取 struct machine_desc中的nr(architecture number) 到r3中
201行: 将r3中取到的machine type 和 r1中的 machine type(见前面的"启动条件")进行比较
202行: 如果相同,说明找到了对应的machine type,跳转到207行的2f处,此时r5中存储了对应的struct machine_desc的基地址
203行: (不相同), 取下一个machine_desc的地址
204行: 和r6进行比较,检查是否到了__arch_info_end.
205行: 如果不相同,说明还有machine_desc,返回200行继续查找.
206行: 执行到这里,说明所有的machind_desc都查找完了,并且没有找到匹配的, 将r5设置成0(unknown machine).
207行: 返回

}

__create_page_tables()
{
3. 创建页表

通过前面的两步,我们已经确定了processor type 和 machine type.
此时,一些特定寄存器的值如下所示:
r8 = machine info       (struct machine_desc的基地址)
r9 = cpu id             (通过cp15协处理器获得的cpu id)
r10 = procinfo          (struct proc_info_list的基地址)

创建页表是通过函数 __create_page_tables 来实现的.
这里,我们使用的是arm的L1主页表,L1主页表也称为段页表(section page table)
L1 主页表将4 GB 的地址空间分成若干个1 MB的段(section),因此L1页表包含4096个页表项(section entry). 每个页表项是32 bits(4 bytes)
因而L1主页表占用 4096 *4 = 16k的内存空间.

        对于ARM926,其L1 section entry的格式为:(可参考arm926EJS TRM):
                                                                                    
                                                                            
    31                          20 19        12 11 10 9 8      5 4 3 2 1 0  
   +------------------------------+------------+-----+-+--------+-+-+-+-+-+ 
   |                              |            |     | |        | | | | | | 
   |       Base Address           |    SBZ     | AP  |0| Domain |1|C|B|1|0| 
   |                              |            |     | |        | | | | | | 
   +------------------------------+------------+-----+-+--------+-+-+-+-+-+ 
                                                                            
                                                                            
   B - Write Buffer Bit                                                     
                                                                            
   C - Cache Bit                                                            
                                                                            
                                                                            
                   +---------------------------------------------------+    
                   |                  Data Cache                       |    
                   +-----------+------------+--------------------------+    
                   | Cache Bit | Buffer Bit |     Page attribute       |    
                   +-----------+------------+--------------------------+    
                   |    0      |     0      | not cached, not buffered |    
                   +-----------+------------+--------------------------+    
                   |    0      |     1      | not cached, buffered     |    
                   +-----------+------------+--------------------------+    
                   |    1      |     0      | cached, writethrough     |    
                   +-----------+------------+--------------------------+    
                   |    1      |     1      | cached, writeback        |    
                   +-----------+------------+--------------------------+    
                                                                            

下面我们来分析 __create_page_tables 函数:

         在 arch/arm/kernel/head.S 中:

- arm linux 从入口到start_kernel 代码分析 -
00206:  .type __create_page_tables, %function
00207: __create_page_tables:
00208:  pgtbl r4    @ page table address
00209:
00210: 
00213:  mov r0, r4
00214:  mov r3, #0
00215:  add r6, r0, #0x4000
00216: 1: str r3, [r0], #4
00217:  str r3, [r0], #4
00218:  str r3, [r0], #4
00219:  str r3, [r0], #4
00220:  teq r0, r6
00221:  bne 1b
00222:
00223:  ldr r7, [r10, #PROCINFO_MM_MMUFLAGS] @ mm_mmuflags
00224:
00225: 
00231:  mov r6, pc, lsr #20   @ start of kernel section
00232:  orr r3, r7, r6, lsl #20  @ flags + kernel base
00233:  str r3, [r4, r6, lsl #2]  @ identity mapping
00234:
00235: 
00239:  add r0, r4,  #(TEXTADDR & 0xff000000) >> 18 @ start of kernel
00240:  str r3, [r0, #(TEXTADDR & 0x00f00000) >> 18]!
00241:
00242:  ldr r6, =(_end - PAGE_OFFSET - 1) @ r6 = number of sections
00243:  mov r6, r6, lsr #20   @ needed for kernel minus 1
00244:
00245: 1: add r3, r3, #1 << 20
00246:  str r3, [r0, #4]!
00247:  subs r6, r6, #1
00248:  bgt 1b
00249:
00250: 
00253:  add r0, r4, #PAGE_OFFSET >> 18
00254:  orr r6, r7, #PHYS_OFFSET
00255:  str r6, [r0]
      
        ...
      
00314: mov pc, lr
00315: .ltorg       

206, 207行: 函数声明
208行: 通过宏 pgtbl 将r4设置成页表的基地址(物理地址)
        宏pgtbl 在 arch/arm/kernel/head.S 中:
      
        00042: .macro pgtbl, rd
        00043: ldr \rd, =(__virt_to_phys(KERNEL_RAM_ADDR - 0x4000))
        00044: .endm

        可以看到,页表是位于 KERNEL_RAM_ADDR 下面 16k 的位置
        宏 __virt_to_phys 是在incude/asm-arm/memory.h 中:
      
        00125: #ifndef __virt_to_phys
        00126: #define __virt_to_phys(x) ((x) - PAGE_OFFSET + PHYS_OFFSET)
        00127: #define __phys_to_virt(x) ((x) - PHYS_OFFSET + PAGE_OFFSET)
        00128: #endif      
      
      
下面从213行 - 221行, 是将这16k 的页表清0.
213行: r0 = r4, 将页表基地址存在r0中
214行: 将 r3 置成0
215行: r6  = 页表基地址 + 16k, 可以看到这是页表的尾地址
216 - 221 行: 循环,从 r0 到 r6 将这16k页表用0填充.
    
223行: 获得proc_info_list的__cpu_mm_mmu_flags的值,并存储到 r7中. (宏PROCINFO_MM_MMUFLAGS是在arch/arm/kernel/asm-offset.c中定义)


231行: 通过pc值的高12位(右移20位),得到kernel的section,并存储到r6中.因为当前是通过运行时地址得到的kernel的section,因而是物理地址.
232行: r3 = r7 | (r6 << 20); flags + kernel base,得到页表中需要设置的值.
233行: 设置页表: mem[r4 + r6 * 4] = r3
        这里,因为页表的每一项是32 bits(4 bytes),所以要乘以4(<<2).
上面这三行,设置了kernel的第一个section(物理地址所在的page entry)的页表项

239, 240行: TEXTADDR是内核的起始虚拟地址(0xc0008000), 这两行是设置kernel起始虚拟地址的页表项(注意,这里设置的页表项和上面的231 - 233行设置的页表项是不同的 )
        执行完后,r0指向kernel的第2个section的虚拟地址所在的页表项.
                 
      
242行: 这一行计算kernel镜像的大小(bytes).
        _end 是在vmlinux.lds.S中162行定义的,标记kernel的结束位置(虚拟地址):
        00158         .bss : {
        00159  __bss_start = .;
        00160  *(.bss)
        00161  *(COMMON)
        00162  _end = .;
        00163 }

        kernel的size =  _end - PAGE_OFFSET -1, 这里 减1的原因是因为 _end 是 location counter,它的地址是kernel镜像后面的一个byte的地址.

243行: 地址右移20位,计算出kernel有多少sections,并将结果存到r6中

245 - 248行: 这几行用来填充kernel所有section虚拟地址对应的页表项.

253行: 将r0设置为RAM第一兆虚拟地址的页表项地址(page entry)
254行: r7中存储的是mmu flags, 逻辑或上RAM的起始物理地址,得到RAM第一个MB页表项的值.
255行:　设置RAM的第一个MB虚拟地址的页表.
上面这三行是用来设置RAM中第一兆虚拟地址的页表. 之所以要设置这个页表项的原因是RAM的第一兆内存中可能存储着boot params.

这样,kernel所需要的基本的页表我们都设置完了, 如下图所示:
                                     
                        _,,_                          _,,_                   
                      -`    `'-.,,.                 -`    `'-.,,.            
                      |           |                 |           |            
                      |           |                 |           |            
                      |           |                 |           |            
                      |           |                 |           |            
                      |           |                 |           |            
                      |           |                 |           |            
                      |           |                 |           |            
                      |           |                 |           |            
                      +-----------+                 |           |            
                      |           |                 |           |            
                      |           |-------------\   |           |            
                      |           |             |   |           |            
                      |  KERNEL   |             |   |           |            
                      |           |             |   |           |            
                      |           |             |   |           |            
                      |           |             |   |           |            
                      |           |             |   |           |            
            +0x8000 ->+-----------+--------\    |   |           |            
                      |           |        |    |   |           |            
                      |    L1     |        |    |   |           |             
                      | Page Table|        |    |   |           |             
                      |           |        |    |   |           |             
            +0x4000 ->+-----------+        |    |   |           |             
                      |           |        |    |   +-----------+             
                      |   Boot    |        |    |   |           |             
                      |  Params   |        |    |   |           |             
                      |           |        |    |   |           |             
    PAGE_OFFSET(3G) ->+-----------+---\    |    |   |           |             
                      |           |   |    |    |   |           |             
                      |           |   |    |    |   |           |             
                      |           |   |    |    |   |           |             
                      |           |   |    |    |   |           |             
                      |           |   |    |    |   |           |             
                      |           |   |    |    |   |           |             
                      |           |   |    |    |   +-----------+             
                      |           |   |    |    |   |           |             
                      |           |   |    |    \-->|           |             
                      |           |   |    |        |           |             
                      |           |   |    |        |  KERNEL   |             
                      |           |   |    |        |           |             
                      |           |   |    |        |           |             
                      +- - - - - -+   |    |        |           |             
                      |   1MB     |   |    |        |           |             
PHYS_OFFSET+0x8000 ->+- - - - - -+--------+------->'-----------+<- +0x8000   
                      |           |   |             |           |             
                      |           |   |             |    L1     |             
                      |           |   |             | Page Table|             
                      |           |   |             |           |             
                      |           |   |             +-----------+<- +0x4000   
                      |           |   |             |           |             
                      |           |   |             |   Boot    |             
                      |           |   |             |  Params   |             
                      |           |   |             |           |             
                      |           |   \------------>+-----------+<- PHYS_OFFSET
                      |           |                 |           |             
                      |           |                 | _,,_      |             
                      |           |                 -`    `'-.,,.             
                  0 --+-----------+                                           
                                                                              
                       VIRT Address                  PHYS Address


}

__cpu_flush()
{
4. 调用平台特定的 __cpu_flush 函数

当 __create_page_tables 返回之后

此时,一些特定寄存器的值如下所示:
r4 = pgtbl (page table 的物理基地址)
r8 = machine info (struct machine_desc的基地址)
r9 = cpu id (通过cp15协处理器获得的cpu id)
r10 = procinfo (struct proc_info_list的基地址)


在我们需要在开启mmu之前,做一些必须的工作:清除ICache, 清除 DCache, 清除 Writebuffer, 清除TLB等.
这些一般是通过cp15协处理器来实现的,并且是平台相关的. 这就是 __cpu_flush 需要做的工作.

在 arch/arm/kernel/head.S中
00091: ldr r13, __switch_data @ address to jump to after
00092: @ mmu has been enabled
00093: adr lr, __enable_mmu @ return (PIC) address
00094: add pc, r10, #PROCINFO_INITFUNC

第91行: 将r13设置为 __switch_data 的地址
第92行: 将lr设置为 __enable_mmu 的地址
第93行: r10存储的是procinfo的基地址, PROCINFO_INITFUNC是在 arch/arm/kernel/asm-offset.c 中107行定义.
则该行将pc设为 proc_info_list的 __cpu_flush 函数的地址, 即下面跳转到该函数.
在分析 __lookup_processor_type 的时候,我们已经知道,对于 ARM926EJS 来说,其__cpu_flush指向的是函数 __arm926_setup


下面我们来分析函数 __arm926_setup

在 arch/arm/mm/proc-arm926.S 中:
00391: .type __arm926_setup, #function
00392: __arm926_setup:
00393: mov r0, #0
00394: mcr p15, 0, r0, c7, c7 @ invalidate I,D caches on v4
00395: mcr p15, 0, r0, c7, c10, 4 @ drain write buffer on v4
00396: #ifdef CONFIG_MMU
00397: mcr p15, 0, r0, c8, c7 @ invalidate I,D TLBs on v4
00398: #endif
00399:
00400:
00401: #ifdef CONFIG_CPU_DCACHE_WRITETHROUGH
00402: mov r0, #4 @ disable write-back on caches explicitly
00403: mcr p15, 7, r0, c15, c0, 0
00404: #endif
00405:
00406: adr r5, arm926_crval
00407: ldmia r5, {r5, r6}
00408: mrc p15, 0, r0, c1, c0 @ get control register v4
00409: bic r0, r0, r5
00410: orr r0, r0, r6
00411: #ifdef CONFIG_CPU_CACHE_ROUND_ROBIN
00412: orr r0, r0, #0x4000 @ .1.. .... .... ....
00413: #endif
00414: mov pc, lr
00415: .size __arm926_setup, . - __arm926_setup
00416:
00417:
00423: .type arm926_crval, #object
00424: arm926_crval:
00425: crval clear=0x00007f3f, mmuset=0x00003135, ucset=0x00001134
}

mmu()
{
5. 开启mmu
        开启mmu是又函数 __enable_mmu 实现的.
      
        在进入 __enable_mmu 的时候, r0中已经存放了控制寄存器c1的一些配置(在上一步中进行的设置), 但是并没有真正的打开mmu,
        在 __enable_mmu 中,我们将打开mmu.
      
        此时,一些特定寄存器的值如下所示:
r0 = c1 parameters      (用来配置控制寄存器的参数)      
r4 = pgtbl              (page table 的物理基地址)
r8 = machine info       (struct machine_desc的基地址)
r9 = cpu id             (通过cp15协处理器获得的cpu id)
r10 = procinfo          (struct proc_info_list的基地址)
      
        在 arch/arm/kernel/head.S 中:

00146:  .type __enable_mmu, %function
00147: __enable_mmu:
00148: #ifdef CONFIG_ALIGNMENT_TRAP
00149:  orr r0, r0, #CR_A
00150: #else
00151:  bic r0, r0, #CR_A
00152: #endif
00153: #ifdef CONFIG_CPU_DCACHE_DISABLE
00154:  bic r0, r0, #CR_C
00155: #endif
00156: #ifdef CONFIG_CPU_BPREDICT_DISABLE
00157:  bic r0, r0, #CR_Z
00158: #endif
00159: #ifdef CONFIG_CPU_ICACHE_DISABLE
00160:  bic r0, r0, #CR_I
00161: #endif
00162:  mov r5, #(domain_val(DOMAIN_USER, DOMAIN_MANAGER) | \
00163:         domain_val(DOMAIN_KERNEL, DOMAIN_MANAGER) | \
00164:         domain_val(DOMAIN_TABLE, DOMAIN_MANAGER) | \
00165:         domain_val(DOMAIN_IO, DOMAIN_CLIENT))
00166:  mcr p15, 0, r5, c3, c0, 0  @ load domain access register
00167:  mcr p15, 0, r4, c2, c0, 0  @ load page table pointer
00168:  b __turn_mmu_on
00169:
00170:
00181:  .align 5
00182:  .type __turn_mmu_on, %function
00183: __turn_mmu_on:
00184:  mov r0, r0
00185:  mcr p15, 0, r0, c1, c0, 0  @ write control reg
00186:  mrc p15, 0, r3, c0, c0, 0  @ read id reg
00187:  mov r3, r3
00188:  mov r3, r3
00189:  mov pc, r13
      
第146, 147行: 函数声明
第148 - 161行:  根据相应的配置,设置r0中的相应的Bit. (r0 将用来配置控制寄存器c1)
第162 - 165行: 设置 domain 参数r5.(r5 将用来配置domain)
第166行: 配置 domain (详细信息清参考arm相关手册)
第167行: 配置页表在存储器中的位置(set ttb).这里页表的基地址是r4, 通过写cp15的c2寄存器来设置页表基地址.

arm linux 从入口到start_kernel 代码分析
第168行: 跳转到 __turn_mmu_on. 从名称我们可以猜到,下面是要真正打开mmu了.
        (继续向下看,我们会发现,__turn_mmu_on就下当前代码的下方,为什么要跳转一下呢? 这是有原因的. go on)
第169 - 180行: 空行和注释. 这里的注释我们可以看到, r0是cp15控制寄存器的内容, r13存储了完成后需要跳转的虚拟地址(因为完成后mmu已经打开了,都是虚拟地址了).

第181行: .algin 5 这句是cache line对齐. 我们可以看到下面一行就是 __turn_mmu_on, 之所以
第182 - 183行:  __turn_mmu_on 的函数声明. 这里我们可以看到, __turn_mmu_on 是紧接着上面第168行的跳转指令的,只是中间在第181行多了一个cache line对齐.
        这么做的原因是: 下面我们要进行真正的打开mmu操作了, 我们要把打开mmu的操作放到一个单独的cache line上. 而在之前的"启动条件"一节我们说了,I Cache是可以打开也可以关闭的,这里这么做的原因是要保证在I Cache打开的时候,打开mmu的操作也能正常执行.
第184行: 这是一个空操作,相当于nop. 在arm中,nop操作经常用指令 mov rd, rd 来实现.
        注意: 为什么这里要有一个nop,我思考了很长时间,这里是我的猜测,可能不是正确的:
        因为之前设置了页表基地址(set ttb),到下一行(185行)打开mmu操作,中间的指令序列是这样的:
        set ttb(第167行)
        branch(第168行)
        nop(第184行)
        enable mmu(第185行)
        对于arm的五级流水线: fetch - decode - execute - memory - write
      
        他们执行的情况如下图所示:
      
            +------------+---+---+---+---+---+---+---+---+      
            |  set ttb   | F | D | E | M | W |   |   |   |      
            +------------+---+---+---+---+---+---+---+---+      
            |  branch    |   | F | D | E |   |   |   |   |      
            +------------+---+---+---+---+---+---+---+---+      
            |   nop      |   |   |   |   | F | D |   |   |      
            +------------+---+---+---+---+---+---+---+---+      
            | enable mmu |   |   |   |   |   | F |   |   |      
            +------------+---+---+---+---+---+---+---+---+      
                                                                
                                                                
             F - fetch                                          
             D - Decode                                         
             E - Execute                                        
             M - Memory                                         
             W - Write Register                                 
                                                                
        这里需要说明的是,branch操作会在3个cycle中完成,并且会导致重新取指.
      
        从这个图我们可以看出来,在enable mmu操作取指的时候, set ttb操作刚好完成.
   
      
第185行: 写cp15的控制寄存器c1, 这里是打开mmu的操作,同时会打开cache等(根据r0相应的配置)
第186行: 读取id寄存器.
第187 - 188行: 两个nop.
第189行: 取r13到pc中,我们前面已经看到了, r13中存储的是 __switch_data (在 arch/arm/kernel/head.S 91行),下面会跳到 __switch_data.

第187,188行的两个nop是非常重要的,因为在185行打开mmu操作之后,要等到3个cycle之后才会生效,这和arm的流水线有关系.
因而,在打开mmu操作之后的加了两个nop操作.
}

start_kernel()
{
arm linux 从入口到start_kernel 代码详细分析7
6. 切换数据

在 arch/arm/kernel/head-common.S 中:

00014: .type __switch_data, %object
00015: __switch_data:
00016: .long __mmap_switched
00017: .long __data_loc @ r4
00018: .long __data_start @ r5
00019: .long __bss_start @ r6
00020: .long _end @ r7
00021: .long processor_id @ r4
00022: .long __machine_arch_type @ r5
00023: .long cr_alignment @ r6
00024: .long init_thread_union + THREAD_START_SP @ sp
00025:
00026:
00034: .type __mmap_switched, %function
00035: __mmap_switched:
00036: adr r3, __switch_data + 4
00037:
00038: ldmia r3!, {r4, r5, r6, r7}
00039: cmp r4, r5 @ Copy data segment if needed
00040: 1: cmpne r5, r6
00041: ldrne fp, [r4], #4
00042: strne fp, [r5], #4
00043: bne 1b
00044:
00045: mov fp, #0 @ Clear BSS (and zero fp)
00046: 1: cmp r6, r7
00047: strcc fp, [r6],#4
00048: bcc 1b
00049:
00050: ldmia r3, {r4, r5, r6, sp}
00051: str r9, [r4] @ Save processor ID
00052: str r1, [r5] @ Save machine type
00053: bic r4, r0, #CR_A @ Clear 'A' bit
00054: stmia r6, {r0, r4} @ Save control register values
00055: b start_kernel

第14, 15行: 函数声明
第16 - 24行: 定义了一些地址,例如第16行存储的是 __mmap_switched 的地址, 第17行存储的是 __data_loc 的地址 ......
第34, 35行: 函数 __mmap_switched
第36行: 取 __switch_data + 4的地址到r3. 从上文可以看到这个地址就是第17行的地址.
第37行:　依次取出从第17行到第20行的地址,存储到r4, r5, r6, r7 中. 并且累加r3的值.当执行完后, r3指向了第21行的位置.
对照上文,我们可以得知:
r4 - __data_loc
r5 - __data_start
r6 - __bss_start
r7 - _end
这几个符号都是在 arch/arm/kernel/vmlinux.lds.S 中定义的变量:

- arm linux 从入口到start_kernel 代码分析 -
00102: #ifdef CONFIG_XIP_KERNEL
00103: __data_loc = ALIGN(4);
00104: . = PAGE_OFFSET + TEXT_OFFSET;
00105: #else
00106: . = ALIGN(THREAD_SIZE);
00107: __data_loc = .;
00108: #endif
00109:
00110: .data : AT(__data_loc) {
00111: __data_start = .;
00112:
00113:
00117: *(.init.task)

......

00158: .bss : {
00159: __bss_start = .;
00160: *(.bss)
00161: *(COMMON)
00162: _end = .;
00163: }

对于这四个变量,我们简单的介绍一下:
__data_loc 是数据存放的位置
__data_start 是数据开始的位置

__bss_start 是bss开始的位置
_end 是bss结束的位置, 也是内核结束的位置

其中对第110行的指令讲解一下: 这里定义了.data 段,后面的AT(__data_loc) 的意思是这部分的内容是在__data_loc中存储的(要注意,储存的位置和链接的位置是可以不相同的).
关于 AT 详细的信息请参考 ld.info

 


第38行: 比较 __data_loc 和 __data_start
第39 - 43行: 这几行是判断数据存储的位置和数据的开始的位置是否相等,如果不相等,则需要搬运数据,从 __data_loc 将数据搬到 __data_start.
其中 __bss_start 是bss的开始的位置,也标志了 data 结束的位置,因而用其作为判断数据是否搬运完成.

第45 - 48行:　是清除 bss 段的内容,将其都置成0. 这里使用 _end 来判断 bss 的结束位置.
第50行: 因为在第38行的时候,r3被更新到指向第21行的位置.因而这里取得r4, r5, r6, sp的值分别是:
r4 - processor_id
r5 - __machine_arch_type
r6 - cr_alignment
sp - init_thread_union + THREAD_START_SP

processor_id 和 __machine_arch_type 这两个变量是在 arch/arm/kernel/setup.c 中 第62, 63行中定义的.
cr_alignment 是在 arch/arm/kernel/entry-armv.S 中定义的:

00182: .globl cr_alignment
00183: .globl cr_no_alignment
00184: cr_alignment:
00185: .space 4
00186: cr_no_alignment:
00187: .space 4

init_thread_union 是 init进程的基地址. 在 arch/arm/kernel/init_task.c 中:

00033: union thread_union init_thread_union
00034: __attribute__((__section__(".init.task"))) =
00035: { INIT_THREAD_INFO(init_task) };

对照 vmlnux.lds.S 中的 的117行,我们可以知道init task是存放在 .data 段的开始8k, 并且是THREAD_SIZE(8k)对齐的
第51行: 将r9中存放的 processor id (在arch/arm/kernel/head.S 75行) 赋值给变量 processor_id
第52行: 将r1中存放的 machine id (见"启动条件"一节)赋值给变量　__machine_arch_type
第53行: 清除r0中的 CR_A 位并将值存到r4中. CR_A 是在 include/asm-arm/system.h 21行定义, 是cp15控制寄存器c1的Bit[1](alignment fault enable/disable)
第54行: 这一行是存储控制寄存器的值.
从上面 arch/arm/kernel/entry-armv.S 的代码我们可以得知.
这一句是将r0存储到了 cr_alignment 中,将r4存储到了 cr_no_alignment 中.
第55行: 最终跳转到start_kernel

}