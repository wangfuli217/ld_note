#ifndef __NAND_H
#define __NAND_H

extern void nand_init(void);
extern void nand_read_id(void);

//buf:存储Nand数据的内存缓冲区
//addr:Nand的某个起始地址
extern void nand_read_page(unsigned char *buf, 
                            unsigned int addr);
#endif
