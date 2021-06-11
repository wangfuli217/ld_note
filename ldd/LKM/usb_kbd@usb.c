#include <linux/kernel.h>
#include <linux/slab.h>
#include <linux/module.h>
#include <linux/input.h>
#include <linux/init.h>
#include <linux/usb.h>
#include <linux/kbd_ll.h>
/*
 * Version Information
 */
#define DRIVER_VERSION ""
#define DRIVER_AUTHOR "TGE HOTKEY "
#define DRIVER_DESC "USB HID Tge hotkey driver"
#define USB_HOTKEY_VENDOR_ID 0x07e4
#define USB_HOTKEY_PRODUCT_ID 0x9473
//厂商和产品ID信息就是/proc/bus/usb/devices中看到的值
MODULE_AUTHOR( DRIVER_AUTHOR );
MODULE_DESCRIPTION( DRIVER_DESC );
struct usb_kbd {
  struct input_dev dev;
  struct usb_device *usbdev;
  unsigned char new[8];
  unsigned char old[8];
  struct urb irq, led;
//  devrequest dr;     
//这一行和下一行的区别在于kernel2.4.20版本对usb_kbd键盘结构定义发生了变化
      struct usb_ctrlrequest dr;
  unsigned char leds, newleds;
  char name[128];
  int open;
};
//此结构来自内核中drivers/usb/usbkbd..c
static void usb_kbd_irq(struct urb *urb)
{
  struct usb_kbd *kbd = urb->context;
        int *new;
        new = (int *) kbd->new;
  if(kbd->new[0] == (char)0x01)
  {
    if(((kbd->new[1]>>4)&0x0f)!=0x7)
    {
        handle_scancode(0xe0,1);
        handle_scancode(0x4b,1);
        handle_scancode(0xe0,0);
        handle_scancode(0x4b,0);
    }
    else
    {
        handle_scancode(0xe0,1);
        handle_scancode(0x4d,1);
        handle_scancode(0xe0,0);
        handle_scancode(0x4d,0);
    }
  }
  
  
  printk("new=%x %x %x %x %x %x %x %x",
    kbd->new[0],kbd->new[1],kbd->new[2],kbd->new[3],
    kbd->new[4],kbd->new[5],kbd->new[6],kbd->new[7]); 
    
}
static void *usb_kbd_probe(struct usb_device *dev, unsigned int ifnum,
                           const struct usb_device_id *id)
{
  struct usb_interface *iface;
        struct usb_interface_descriptor *interface;
  struct usb_endpoint_descriptor *endpoint;
        struct usb_kbd *kbd;
        int  pipe, maxp;
  iface = &dev->actconfig->interface[ifnum];
        interface = &iface->altsetting[iface->act_altsetting];
  if ((dev->descriptor.idVendor != USB_HOTKEY_VENDOR_ID) ||
    (dev->descriptor.idProduct != USB_HOTKEY_PRODUCT_ID) ||
    (ifnum != 1))
  {
    return NULL;
  }
  if (dev->actconfig->bNumInterfaces != 2)
  {
    return NULL;  
  }
  if (interface->bNumEndpoints != 1) return NULL;
        endpoint = interface->endpoint + 0;
        pipe = usb_rcvintpipe(dev, endpoint->bEndpointAddress);
        maxp = usb_maxpacket(dev, pipe, usb_pipeout(pipe));
        usb_set_protocol(dev, interface->bInterfaceNumber, 0);
        usb_set_idle(dev, interface->bInterfaceNumber, 0, 0);
  printk(KERN_INFO "GUO: Vid = %.4x, Pid = %.4x, Device = %.2x,ifnum = %.2x, bufCount = %.8x\\n",
    dev->descriptor.idVendor,dev->descriptor.idProduct,
                dev->descriptor.bcdDevice, ifnum, maxp);
        if (!(kbd = kmalloc(sizeof(struct usb_kbd), GFP_KERNEL))) return NULL;
        memset(kbd, 0, sizeof(struct usb_kbd));
        kbd->usbdev = dev;
        FILL_INT_URB(&kbd->irq, dev, pipe, kbd->new, maxp > 8 ? 8 : maxp,
    usb_kbd_irq, kbd, endpoint->bInterval);
  kbd->irq.dev = kbd->usbdev;
  if (dev->descriptor.iManufacturer)
                usb_string(dev, dev->descriptor.iManufacturer, kbd->name, 63);
  if (usb_submit_urb(&kbd->irq)) {
                kfree(kbd);
                return NULL;
        }
  
  printk(KERN_INFO "input%d: %s on usb%d:%d.%d\\n",
                 kbd->dev.number, kbd->name, dev->bus->busnum, 
                             dev->devnum, ifnum);
        return kbd;
}
static void usb_kbd_disconnect(struct usb_device *dev, void *ptr)
{
  struct usb_kbd *kbd = ptr;
        usb_unlink_urb(&kbd->irq);
        kfree(kbd);
}
static struct usb_device_id usb_kbd_id_table [] = {
  { USB_DEVICE(USB_HOTKEY_VENDOR_ID, USB_HOTKEY_PRODUCT_ID) },
  { }            /* Terminating entry */
};
MODULE_DEVICE_TABLE (usb, usb_kbd_id_table);
static struct usb_driver usb_kbd_driver = {
  name:    "Hotkey",
  probe:    usb_kbd_probe,
  disconnect:  usb_kbd_disconnect,
  id_table:  usb_kbd_id_table,
  NULL,
};
static int __init usb_kbd_init(void)
{
  usb_register(&usb_kbd_driver);
  info(DRIVER_VERSION ":" DRIVER_DESC);
  return 0;
}
static void __exit usb_kbd_exit(void)
{
  usb_deregister(&usb_kbd_driver);
}
module_init(usb_kbd_init);
module_exit(usb_kbd_exit);