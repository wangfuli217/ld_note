ENTRY(main)
SECTIONS
{
    . = 0x20008000;

    .text :
    {
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
