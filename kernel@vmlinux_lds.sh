Linux的链接器脚本文件在ARM中利用vmlinux.lds.S文件和vmlinux.lds.h文件构建，Linux的链接器脚本文件vmlinux.lds.S的定义如下：
.init 指定init节区在内核镜像中的位置
.text 指定要放置data节区的位置
.rodata 指定放置读取专用区域rodata节区的位置
.data 指放置data节区的位置
.bss 指放置bss节区的位置。



.text.head
.init
/DISCARD/
.text
.rodata
.rodata1
BUG_TABLE
.pci_fixup
.builtin_fw
.rio_route
.tracedata
.comment 0
.stab.indexstr 0
.stab.index 0
.stab.exclstr 0
.stabstr 0
.stab 0
.bss
.data
ARM.unwind_tab
ARM.unwind_idx
__param
__init_rodata

cat /proc/kallsym  | grep __ksymtab



led.lds(一个链接器脚本led.lds例子)
{
OUTPUT_ARCH(arm)                /*指定输出文件的平台体系是ARM*/  
ENTRY(_start)                             /*指定可执行映像文件的起始段的段名是_start*/  
SECTIONS { #设置起始链接地址
           #查看用上图的链接器脚本（左图）生成的elf文件的反汇编文件（右图），可以看到代码的起始地址是0x30008000
    . = 0x30008000;                  /*设置起始链接地址，改变这个值，会使编译中得到的汇编代码中首地址的值改变*/
    . = ALIGN(4);                      #对齐设置
    .text :      
    { #设置代码段首文件
    start.o (.text)                        /*代码段首文件*/ #指明start.o排在最前面，运行程序首先执行start.o，主要是CPU上电要完成初始化；
    *(.text)                                  /*代表所有文件的代码段*/
    }
    . = ALIGN(4);
    .data :
    {
    *(.data)                               /*代表所有文件的数据段*/
    }
    . = ALIGN(4);
    bss_start = .;                     /*变量，表示将当前地址赋值给bss_start*/ #使用变量
    .bss : 
    {
    *(.bss)                                /*代表所有文件的bss段*/
    }
    bss_end = .;                     /*变量，表示将当前地址赋值给bss_end*/
}

}

vmlinux(linux内核启动地址的确定)
{
内核编译链接过程是依靠vmlinux.lds文件，以arm为例vmlinux.lds文件位于kernel/arch/arm/vmlinux.lds，
vmlinux-armv.lds的生成过程在kernel/arch/arm/Makefile中

ifeq ($(CONFIG_CPU_32),y)
PROCESSOR     = armv
TEXTADDR     = 0xC0008000
LDSCRIPT     = arch/arm/vmlinux-armv.lds.in
endif

arch/arm/vmlinux.lds: $(LDSCRIPT) dummy
    @sed 's/TEXTADDR/$(TEXTADDR)/;s/DATAADDR/$(DATAADDR)/' $(LDSCRIPT) >$@

查看arch/arm/vmlinux.lds 中
OUTPUT_ARCH(arm)
ENTRY(stext)
SECTIONS
{
    . = 0xC0008000;
    .init : {            /* Init code and data        */
        _stext = .;
        __init_begin = .;
            *(.text.init)
        __proc_info_begin = .;
            *(.proc.info)
        __proc_info_end = .;
        __arch_info_begin = .;
            *(.arch.info)
        __arch_info_end = .;
        __tagtable_begin = .;
            *(.taglist)
        __tagtable_end = .;
            *(.data.init)
        . = ALIGN(16);
        __setup_start = .;
            *(.setup.init)
        __setup_end = .;
        __initcall_start = .;
            *(.initcall.init)
        __initcall_end = .;
        . = ALIGN(4096);
        __init_end = .;
    }

    /DISCARD/ : {            /* Exit code and data        */
        *(.text.exit)
        *(.data.exit)
        *(.exitcall.exit)
    }

    .text : {            /* Real text segment        */
        _text = .;        /* Text and read-only data    */
            *(.text)
            *(.fixup)
            *(.gnu.warning)
            *(.rodata)
            *(.rodata.*)
            *(.glue_7)
            *(.glue_7t)
        *(.got)            /* Global offset table        */

        _etext = .;        /* End of text section        */
    }

    .kstrtab : { *(.kstrtab) }

    . = ALIGN(16);
    __ex_table : {            /* Exception table        */
        __start___ex_table = .;
            *(__ex_table)
        __stop___ex_table = .;
    }

    __ksymtab : {            /* Kernel symbol table        */
        __start___ksymtab = .;
            *(__ksymtab)
        __stop___ksymtab = .;
    }

    . = ALIGN(8192);

    .data : {
        /*
         * first, the init task union, aligned
         * to an 8192 byte boundary.
         */
        *(.init.task)

        /*
         * then the cacheline aligned data
         */
        . = ALIGN(32);
        *(.data.cacheline_aligned)

        /*
         * and the usual data section
         */
        *(.data)
        CONSTRUCTORS

        _edata = .;
    }

    .bss : {
        __bss_start = .;    /* BSS                */
        *(.bss)
        *(COMMON)
        _end = . ;
    }
                    /* Stabs debugging sections.    */
    .stab 0 : { *(.stab) }
    .stabstr 0 : { *(.stabstr) }
    .stab.excl 0 : { *(.stab.excl) }
    .stab.exclstr 0 : { *(.stab.exclstr) }
    .stab.index 0 : { *(.stab.index) }
    .stab.indexstr 0 : { *(.stab.indexstr) }
    .comment 0 : { *(.comment) }
}




}