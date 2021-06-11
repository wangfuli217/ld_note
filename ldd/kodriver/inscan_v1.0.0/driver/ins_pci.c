
/* Kvaser PCICan-4HS specific stuff
 * 
 * (c) 2006-2010 oe@port.de
 */

#include <linux/pci.h>
#include "defs.h"

#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 39)
#include <linux/delay.h>
#endif

# ifndef CONFIG_PCI
#   error "trying to compile a PCI driver for a kernel without CONFIG_PCI"
# endif

#define INVOLUSER_VANDORID 0x13FE
/* used for storing the global pci register address */
/* one element more than needed for marking the end */
struct	pci_dev *Can_pcidev[MAX_CHANNELS + 1] = { 0 };

//reset the CAN device
void reset_ADV_PCI(int dev)
{
   unsigned char temp;

#ifdef CAN_DEBUG
   printk("Enter can_reset, device = %d\n", dev);
#endif
   if (dev < 0 || dev>= MAX_CHANNELS )
   {
#ifdef CAN_DEBUG
      printk( "in can_get_reg function the device=%d is error!\n", dev);
#endif
      return;
   }

   temp = CANin(dev, canmode );
   CANout(dev, canmode, temp|0x01 );
   udelay(10000);
}

static struct pci_device_id can_board_table[] = {
   {0x10b5, 0x9030, 0x0154, 0xca60, 0, 0, PCI_ANY_ID},
   {0,}			
};

static int can_init_one(struct pci_dev *pdev, const struct pci_device_id *id);
static void __exit can_remove_one(struct pci_dev *dev);

static struct pci_driver can_driver = {
	name:		"inscan_pci",
	id_table:	can_board_table,
	probe:		can_init_one,
	remove:		can_remove_one,
};

static int can_init_one(struct pci_dev *pdev, const struct pci_device_id *id ) 
{
   unsigned int address,portNum = 2,i;
   unsigned int idxbar=0,barBase,barNum = 1,offset;
   unsigned int RegShift,j,len = 128;
   unsigned int isIO = 1;

   Can_pcidev[numdevs] = pdev;
   if (pci_enable_device (pdev))
   {
      return -EIO;
   }

   if( pdev->revision == 0x01)
   {
		isIO = 1;
		portNum = 2;
		barBase = 2;
		barNum = 3;
		offset = 128;
		RegShift = 0;

   }else if( pdev->revision == 0x02)
   {
		isIO = 0;
		portNum = 6;
		barBase = 2;
		barNum = 1;
		offset = 0x100;
		RegShift = 0;
   }

   printk("Firmware revision:%d\n",pdev->revision );
   printk("bar number = %d,port number per bar = %d\n",barNum,portNum);
   printk("Involuser PCI CAN devie %x found( %x CAN port)\n",
         pdev->device,portNum );
#ifdef CONFIG_PCI_MSI
   //printk("To Enable MSI.\n");
   pci_enable_msi(pdev);
   /*
   if (!pci_enable_msi(pdev))
   {
      printk("MSI Enable.\n");
   }
   */
#endif
   for(idxbar = 0;idxbar<barNum;idxbar++)
{
   for ( i = 0; i < portNum; i++)
   {
      address = pci_resource_start(pdev, barBase+idxbar)+ offset * i ;
      Base[numdevs] = address;
      addlen[numdevs] = len;
      //printk("addlen=%d\n", addlen[numdevs]);
      //printk("Base=0x%x\n", Base[numdevs]);


      IRQ[numdevs] = pdev->irq;
      slot[numdevs] = pdev->devfn;

      if ( isIO == 0 )
      {   
        if(NULL == request_mem_region(Base[numdevs],  addlen[numdevs], "inscan"))
        {
            printk ("Device %d Memroy %lX is not free.\n", numdevs, 
               (long)Base[numdevs]);
            goto error_out;
        }
	//printk("===========numdevs = %d, %c\n",numdevs,IOModel[numdevs]);
 	can_base[numdevs] = ioremap(Base[numdevs], addlen[numdevs]);
        for ( j = 0; j < 32; j++)
        {
 	    Reg[numdevs][j] = can_base[numdevs] + (j << RegShift);

        }
         IOModel[numdevs] = 'M';
         advCanout[ numdevs ] = canout_mem;
         advCanin[ numdevs ] = canin_mem;
         advCanset[ numdevs ] = canset_mem;
         advCanreset[ numdevs ] = canreset_mem;
         advCantest[ numdevs ] = cantest_mem;   
      }
      else
      {
         if ( request_region(Base[numdevs], addlen[numdevs], "inscan") == NULL )
         {
            printk ("Device %d I/O %lX is not free.\n", numdevs, 
               (long)Base[numdevs]);
            goto error_out;
         }
         for ( j = 0; j < 32; j++)
         {
            Reg[numdevs][j] = (void *)(Base[numdevs] + (j << RegShift));
         }
		  
         IOModel[numdevs] = 'p';
         //printk("--------numdevs = %d, %c\n",numdevs,IOModel[numdevs]);
         advCanout[ numdevs ] = canout_io;
         advCanin[ numdevs ] = canin_io;
         advCanset[ numdevs ] = canset_io;
         advCanreset[ numdevs ] = canreset_io;
         advCantest[ numdevs ] = cantest_io;
      }
      printk("Port %d ( Addr[%s] = 0x%x, Irq = 0x%x )\n",numdevs,isIO?"IO":"MEM",Base[numdevs],IRQ[numdevs]);
      reset_ADV_PCI(numdevs);
      numdevs++;
   }
}//for bar++

   return 0;
error_out:
   if (  isIO == 0 )
   {
      release_mem_region(Base[i], addlen[i]);
   }
   else
   {
      release_region((int)Base[i], addlen[i]);
   }
   return -EIO;
}

static void __exit can_remove_one( struct pci_dev *dev) //zdd modified
{
   int  i;
   for ( i = 0 ; i < MAX_CHANNELS; i++ ) 
   {
      if (slot[i]  == dev->devfn )
      {
         if (IRQ_requested[i] == 1)
         {
            //printk("Free IRQ %x\n",IRQ[i]);
            free_irq( IRQ[i], &Can_minors[i]);
#ifdef CONFIG_PCI_MSI
	    pci_disable_msi(dev); 
        //printk("disable msi\n");
#endif
         }
      	if ( dev->revision == 0x02 )
	{
    	 	iounmap(can_base[i]);
		release_mem_region(Base[i], addlen[i]);
	}
	else
	{
         release_region((int)Base[i], addlen[i]);
	}
      }
   }
}

int init_ins_pci(void)
{
   int ret;
   ret = 0;
   ret = pci_register_driver(&can_driver);
   if(ret < 0) 
   {
      printk("No PCI Board Found!\n");
      return -ENODEV;
   }
   return 0;
}

void exit_ins_pci(void)
{
   int dev = 0;
   pci_unregister_driver(&can_driver);
#ifdef CONFIG_PCI_MSI
   for (dev = 0; dev <= MAX_CHANNELS;dev++ )
   {
      if ( Can_pcidev[dev] != NULL)
      {
         pci_disable_msi(Can_pcidev[dev] );
      }
   }
#endif
}

void board_clear_interrupts(int minor)
{}

int Can_FreeIrq(int minor, int irq )
{
    	//DBGin("Can_FreeIrq");
    	IRQ_requested[minor] = 0;

	/* printk(" Free IRQ %d  minor %d\n", irq, minor);  */
    	free_irq(irq, &Can_minors[minor]);
    	DBGout();
    	return 0;
}

int Can_RequestIrq(int minor, int irq,
#if LINUX_VERSION_CODE > KERNEL_VERSION(2,6,18) 
    irqreturn_t (*handler)(int, void *))
#else
    irqreturn_t (*handler)(int, void *, struct pt_regs *))
#endif
{
int err = 0;

    DBGin();
    /*

    int request_irq(unsigned int irq,			// interrupt number  
              void (*handler)(int, void *, struct pt_regs *), // pointer to ISR
		              irq, dev_id, registers on stack
              unsigned long irqflags, const char *devname,
              void *dev_id);

       dev_id - The device ID of this handler (see below).       
       This parameter is usually set to NULL,
       but should be non-null if you wish to do  IRQ  sharing.
       This  doesn't  matter when hooking the
       interrupt, but is required so  that,  when  free_irq()  is
       called,  the  correct driver is unhooked.  Since this is a
       void *, it can point to anything (such  as  a  device-spe-
       cific  structure,  or even empty space), but make sure you
       pass the same pointer to free_irq().

    */

#if LINUX_VERSION_CODE > KERNEL_VERSION(2,6,18) 
    err = request_irq(irq, handler, IRQF_SHARED, "Can", &Can_minors[minor]);
#else
    err = request_irq(irq, handler, SA_SHIRQ, "Can", &Can_minors[minor]);
#endif


    if( !err ){
      DBGprint(DBG_BRANCH,("Requested IRQ: %d @ 0x%lx",
      				irq, (unsigned long)handler));
      IRQ_requested[minor] = 1;
    }
    DBGout(); return err;


}

int CAN_VendorInit_pci (int minor)
{
    DBGin();

    /* The Interrupt Line is alrady requestes by th PC CARD Services
     * (in case of CPC-Card: cpc-card_cs.c) 
    */ 

    /* printk("MAX_IRQNUMBER %d/IRQ %d\n", MAX_IRQNUMBER, IRQ[minor]); */
    if( IRQ[minor] > 0 && IRQ[minor] < MAX_IRQNUMBER ){
        if( Can_RequestIrq( minor, IRQ[minor] , CAN_Interrupt) ) {
	     printk("Can[%d]: Can't request IRQ %d \n", minor, IRQ[minor]);
	     DBGout(); return -EBUSY;
        }
    } else {
	/* Invalid IRQ number in /proc/.../IRQ */
	DBGout(); return -EINVAL;
    }
    DBGout(); 
   return 0;;
}
MODULE_DEVICE_TABLE(pci, can_board_table);



