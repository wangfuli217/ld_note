ENTRY(main)
SECTIONS
{
    . = 0x20008000;
    _vect_start = .; /*自定义标签和对应地址*/
    .text :
    {
        vector.o(.text) /*异常向量表放在这*/
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
