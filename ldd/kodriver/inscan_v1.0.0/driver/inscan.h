/************************************************************************/
/* hardware access functions or macros */
/* for Involuser CAN device using SJA1000 */
/************************************************************************/
#define CANout(bd,adr,v)	\
(*advCanout[bd])(Reg[bd][sja1000reg.adr],v)
  
#define CANin(bd,adr)	\
(*advCanin[bd])(Reg[bd][sja1000reg.adr])

#define CANset(bd,adr,m) \
(*advCanset[bd])(Reg[bd][sja1000reg.adr],m)
		
#define CANreset(bd,adr,m) \
(*advCanreset[bd])(Reg[bd][sja1000reg.adr],m)

#define CANtest(bd,adr,m) \
(*advCantest[bd])(Reg[bd][sja1000reg.adr],m)

extern void board_clear_interrupts(int minor);
extern void exit_ins_pci(void);
extern int numdevs;
extern int addlen[];
extern int slot[];
extern int init_ins_pci(void);

extern void canout_io(void * adr,unsigned char v);
extern unsigned canin_io(void * adr);
extern void canset_io(void * adr,int m);
extern void canreset_io(void * adr,int m);
extern unsigned cantest_io(void * adr,unsigned m);

extern void canout_mem(void * adr,unsigned char v);
extern unsigned canin_mem(void * adr);
extern void canset_mem(void * adr,int m);
extern void canreset_mem(void * adr,int m);
extern unsigned cantest_mem(void * adr, unsigned m);
extern int CAN_VendorInit_isa (int minor);
extern int CAN_VendorInit_pci (int minor);




