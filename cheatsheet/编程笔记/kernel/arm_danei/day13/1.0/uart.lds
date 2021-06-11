ENTRY(main)
SECTIONS
{
    . = 0x20004000;
    __vect_start = .;   /*自定义标签和对应的地址*/

    .text :
    {
        vector.o(.text) /*让异常向量表从20004000开始*/
        main.o(.text)
        *(.text)
    }

    .data :
    {
        *(.data)
    }
    
    .bss : 
    {
        *(.bss)
    }
}




