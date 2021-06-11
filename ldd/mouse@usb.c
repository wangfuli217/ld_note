// 1、usbmouse的定义：usb鼠标既包含usb设备(usb_device)的属性也包含input输入设备(input_dev)的属性
struct usb_mouse {
char name[128];///USB鼠标设备名称
char phys[64];///路径
struct usb_device *usbdev;///USB设备
struct input_dev *dev;///Input 设备
struct urb *irq; ///urb结构体
signed char *data;///数据传输缓冲区指针
dma_addr_t data_dma;///
};

// 2、usbmouse的加载：
module_usb_driver(usb_mouse_driver);///系统启动时注册usb_mouse_driver

// 3、usbmouse的初始化：
static int usb_mouse_probe(struct usb_interface *intf, const struct usb_device_id *id)
{
    struct usb_device *dev = interface_to_usbdev(intf);///通过 USB 接口来获得 usb 设备
    struct usb_host_interface *interface;
    struct usb_endpoint_descriptor *endpoint;
    struct usb_mouse *mouse;
    struct input_dev *input_dev;
    int pipe, maxp;
    int error = -ENOMEM;

    interface = intf->cur_altsetting;///获取 usb_host_interface

    if (interface->desc.bNumEndpoints != 1)/// usb鼠标端点有且只有一个控制端点，否则返回 ENODEV 
        return -ENODEV;

    endpoint = &interface->endpoint[0].desc; ///usb鼠标只有一个端点，获取端点描述符
    if (!usb_endpoint_is_int_in(endpoint))///检查端点是不是中断类型的输入端点
        return -ENODEV;

    pipe = usb_rcvintpipe(dev, endpoint->bEndpointAddress);////获取 pipe()，根据端点地址bEndpointAddress，中断方式，IN端点就可以得到一个pipe，然后主机就知道跟谁去通信，该如何通信
    maxp = usb_maxpacket(dev, pipe, usb_pipeout(pipe));///获取主机和设备一次通讯的最大字节数

    mouse = kzalloc(sizeof(struct usb_mouse), GFP_KERNEL);///分配一个usb_mouse
    input_dev = input_allocate_device();///初始化 input 设备
    if (!mouse || !input_dev)
        goto fail1;

    mouse->data = usb_alloc_coherent(dev, 8, GFP_ATOMIC, &mouse->data_dma);///为usbmouse的data 分配8个字节的空间
    if (!mouse->data)
        goto fail1;

    mouse->irq = usb_alloc_urb(0, GFP_KERNEL);///申请分配 urb ，赋值给 usb_mouse 的 urb
    if (!mouse->irq)
        goto fail2;

    mouse->usbdev = dev; //设置usb鼠标设备的usb设备对象
    mouse->dev = input_dev;//设备usb鼠标设备的input设备对象

    if (dev->manufacturer)///枚举时候有获取到有效的厂商名
        strlcpy(mouse->name, dev->manufacturer, sizeof(mouse->name));///复制厂商名到 name 

    if (dev->product) { //枚举时候有获取到有效的产品名
        if (dev->manufacturer) //如果也有厂商名
            strlcat(mouse->name, " ", sizeof(mouse->name));     //则用空格将厂商名和产品名隔开
        strlcat(mouse->name, dev->product, sizeof(mouse->name));//追加产品名到name
    }

    if (!strlen(mouse->name)) //如果厂商和产品名都没有
        snprintf(mouse->name, sizeof(mouse->name), //则直接根据厂商id和产品id给name赋值
             "USB HIDBP Mouse %04x:%04x",
             le16_to_cpu(dev->descriptor.idVendor),
             le16_to_cpu(dev->descriptor.idProduct));

    usb_make_path(dev, mouse->phys, sizeof(mouse->phys)); //设置设备路径名
    strlcat(mouse->phys, "/input0", sizeof(mouse->phys)); //追加/input0

    input_dev->name = mouse->name; //输入设备的名字设置成usb鼠标的名字
    input_dev->phys = mouse->phys; //输入设备的路径设置成usb鼠标的路径
    usb_to_input_id(dev, &input_dev->id); //设置输入设备的bustype,vendor,product,version
    input_dev->dev.parent = &intf->dev; //usb接口设备为输入设备的父设备

    ////evbit 关于设备支持事件类型的 bitmap 
    input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REL);　///BIT_MASK 找到参数值所在的 bit位,输入事件按键类型 + 相对位移
    input_dev->keybit[BIT_WORD(BTN_MOUSE)] = BIT_MASK(BTN_LEFT) | ///鼠标支持左键、右键、中键三个按键
        BIT_MASK(BTN_RIGHT) | BIT_MASK(BTN_MIDDLE);
    input_dev->relbit[0] = BIT_MASK(REL_X) | BIT_MASK(REL_Y); ///REL_X REL_Y 表示鼠标的位置信息 x \ Y 
    input_dev->keybit[BIT_WORD(BTN_MOUSE)] |= BIT_MASK(BTN_SIDE) | ///在已有按键的基础上加上一个边键和一个而外的键
        BIT_MASK(BTN_EXTRA);
    input_dev->relbit[0] |= BIT_MASK(REL_WHEEL);///给相对事件加上滚轮的事件

    input_set_drvdata(input_dev, mouse);///usb鼠标驱动文件作为输入设备的设备文件的驱动数据 " input_dev -> dev->driver_data = mouse "

    input_dev->open = usb_mouse_open; //设置输入事件的打开方法
    input_dev->close = usb_mouse_close; //设置输入事件的关闭方法

    usb_fill_int_urb(mouse->irq, dev, pipe, mouse->data, ///初始化 urb (中断传输方式),并指定 urb 的回调函数是 usb_mouse_irq
             (maxp > 8 ? 8 : maxp),
             usb_mouse_irq, mouse, endpoint->bInterval);//// usb_mouse_irq --回调函数，上下文信息 -- mouse
    mouse->irq->transfer_dma = mouse->data_dma;//dma数据缓冲区指向usb鼠标设备的data_dma成员
    mouse->irq->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;///没有 DMA 映射 

    error = input_register_device(mouse->dev);///注册设备驱动 mouse->dev
    if (error)
        goto fail3;

    usb_set_intfdata(intf, mouse);///usb 鼠标驱动文件作为 usb 接口设备的设备文件的驱动数据 ；intf->dev->driver_data = mouse ;
    return 0;

fail3:    
    usb_free_urb(mouse->irq);
fail2:    
    usb_free_coherent(dev, 8, mouse->data, mouse->data_dma);
fail1:    
    input_free_device(input_dev);
    kfree(mouse);
    return error;
}

// 经过probe过程,注册了输入设备则会在/dev/input/目录下会产生对应的鼠标设备节点,应用程序可以打开该节点来控制usb鼠标设备
// 关键函数调用顺序：
// .open   =   evdev_open,///上层应用程序通过系统调用open 打开设备
// static int evdev_open(struct inode *inode, struct file *file);
// evdev_open_device(evdev);
// input_open_device(&evdev->handle);
// dev->open(dev);////---->调用usbmouse_open()
// input_dev->open = usb_mouse_open; //设置输入事件的打开方法
// usb_submit_urb(mouse->irq, GFP_KERNEL)
// usb_mouse_irq(struct urb *urb)
// input_report_key\input_report_rel\input_sync ///提交鼠标数据给input 子系统
// usb_submit_urb (urb, GFP_ATOMIC);///usb设备提交urb，主机再次轮询usb设备

static int usb_mouse_open(struct input_dev *dev)
{
    struct usb_mouse *mouse = input_get_drvdata(dev); //通过输入设备获取usb鼠标设备

    mouse->irq->dev = mouse->usbdev; //设置urb设备对应的usb设备
    if (usb_submit_urb(mouse->irq, GFP_KERNEL))///提交 urb ，只有打开设备的时候，才会把 urb 发送出去
        return -EIO;

    return 0;
}

static void usb_mouse_irq(struct urb *urb)
{
    struct usb_mouse *mouse = urb->context; ///获取 usb 鼠标设备
    signed char *data = mouse->data; ///数据传输缓冲区指针
    struct input_dev *dev = mouse->dev;//输入设备
    int status;

    switch (urb->status) {///判断 urb 传输的状态
    case 0:            /* success */ ///传输成功跳出 switch
        break;
    case -ECONNRESET:    /* unlink */
    case -ENOENT:
    case -ESHUTDOWN:
        return;
    /* -EPIPE:  should clear the halt */
    default:        /* error */
        goto resubmit;
    }

    input_report_key(dev, BTN_LEFT,   data[0] & 0x01);////提交按键信息，data[0] 的第 0 位为 1，表示左键按下
    input_report_key(dev, BTN_RIGHT,  data[0] & 0x02);////提交按键信息，data[0] 的第 1 位为 1，表示右键按下
    input_report_key(dev, BTN_MIDDLE, data[0] & 0x04);////提交按键信息，data[0] 的第 2 位为 1，表示中键按下
    input_report_key(dev, BTN_SIDE,   data[0] & 0x08);////提交按键信息，data[0] 的第 3 位为 1，表示边键按下
    input_report_key(dev, BTN_EXTRA,  data[0] & 0x10);////提交按键信息，data[0] 的第 4 位为 1，表示而外键按下

    input_report_rel(dev, REL_X,     data[1]);///提交鼠标相对坐标值，data[1] 为 X 坐标
    input_report_rel(dev, REL_Y,     data[2]);///提交鼠标相对坐标值，data[2] 为 Y 坐标
    input_report_rel(dev, REL_WHEEL, data[3]);///提交鼠标滚轮相对值，data[3] 为 滚轮相对值

    input_sync(dev);///同步信息，表示上面的信息作为完整一帧传递给上层系统
resubmit:
    status = usb_submit_urb (urb, GFP_ATOMIC);///usb设备提交urb，主机再次轮询usb设备
    if (status)
        dev_err(&mouse->usbdev->dev,
            "can't resubmit intr, %s-%s/input0, status %d\n",
            mouse->usbdev->bus->bus_name,
            mouse->usbdev->devpath, status);
}