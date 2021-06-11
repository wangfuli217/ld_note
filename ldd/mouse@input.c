
static struct input_handler evdev_handler = { 
    .event        = evdev_event,
    .events        = evdev_events,
    .connect    = evdev_connect,
    .disconnect    = evdev_disconnect,
    .legacy_minors    = true,
    .minor        = EVDEV_MINOR_BASE,///次设备号从64开始
    .name        = "evdev",
    .id_table    = evdev_ids,
};

static int __init evdev_init(void)
{
    return input_register_handler(&evdev_handler); ///注册 evdev_handler 这个input事件驱动
}

int input_register_handler(struct input_handler *handler)///把input 事件驱动注册到内核
{
    struct input_dev *dev;
    int error;

    error = mutex_lock_interruptible(&input_mutex);
    if (error)
        return error;

    INIT_LIST_HEAD(&handler->h_list);///初始化链表头，把链表的前和后都指向它自己

    list_add_tail(&handler->node, &input_handler_list);///把 handler的 node 加到 input_handler_list这个双向链表，之后就可以通过这个链表访问所有的input_handler

    list_for_each_entry(dev, &input_dev_list, node)  
        input_attach_handler(dev, handler);////inout 设备和 input 事件进行匹配

    input_wakeup_procfs_readers();

    mutex_unlock(&input_mutex);
    return 0;
}


static int input_attach_handler(struct input_dev *dev, struct input_handler *handler)
{
    const struct input_device_id *id;
    int error;

    id = input_match_device(handler, dev);///input_dev 和 input_handler 通过id_table进行匹配
    if (!id)
        return -ENODEV;

    error = handler->connect(handler, dev, id);///如果返回id不为空就执行handler 的 connect  ---> 调用 evdev.c 的 connect 函数
    if (error && error != -ENODEV)
        pr_err("failed to attach handler %s to device %s, error: %d\n",
               handler->name, kobject_name(&dev->dev.kobj), error);

    return error;
}


/*
 * Create new evdev device. Note that input core serializes calls
 * to connect and disconnect.
 */
static int evdev_connect(struct input_handler *handler, struct input_dev *dev,
             const struct input_device_id *id)
{
    struct evdev *evdev;
    int minor;
    int dev_no;
    int error;

    minor = input_get_new_minor(EVDEV_MINOR_BASE, EVDEV_MINORS, true);//动态分配一个新的设备号minor
    if (minor < 0) {
        error = minor;
        pr_err("failed to reserve new minor: %d\n", error);
        return error;
    }

    evdev = kzalloc(sizeof(struct evdev), GFP_KERNEL);///初始化evdev ，为evdev分配空间
    if (!evdev) {
        error = -ENOMEM;
        goto err_free_minor;
    }

    INIT_LIST_HEAD(&evdev->client_list);///初始化队列
    spin_lock_init(&evdev->client_lock);
    mutex_init(&evdev->mutex);
    init_waitqueue_head(&evdev->wait);///初始化等待队列
    evdev->exist = true;

    dev_no = minor;
    /* Normalize device number if it falls into legacy range */
    if (dev_no < EVDEV_MINOR_BASE + EVDEV_MINORS)
        dev_no -= EVDEV_MINOR_BASE;
    dev_set_name(&evdev->dev, "event%d", dev_no);///给设备设置名字(event0、event1、...)

    evdev->handle.dev = input_get_device(dev);
    evdev->handle.name = dev_name(&evdev->dev);
    evdev->handle.handler = handler;
    evdev->handle.private = evdev;

    evdev->dev.devt = MKDEV(INPUT_MAJOR, minor);////根据主设备号(主设备号都是13)和次设备号生成一个设备号(次设备号从64开始)
    evdev->dev.class = &input_class;
    evdev->dev.parent = &dev->dev;
    evdev->dev.release = evdev_free;
    device_initialize(&evdev->dev);///对设备进行初始化

    error = input_register_handle(&evdev->handle);///注册 handle，handle 用来关联 input_dev 和 input_handler
    if (error)
        goto err_free_evdev;

    cdev_init(&evdev->cdev, &evdev_fops);//// 初始化一个 cdev
    evdev->cdev.kobj.parent = &evdev->dev.kobj;
    error = cdev_add(&evdev->cdev, evdev->dev.devt, 1);
    if (error)
        goto err_unregister_handle;

    error = device_add(&evdev->dev);///把初始化好的 evdev 添加到内核
    if (error)
        goto err_cleanup_evdev;

    return 0;

 err_cleanup_evdev:
    evdev_cleanup(evdev);
 err_unregister_handle:
    input_unregister_handle(&evdev->handle);
 err_free_evdev:
    put_device(&evdev->dev);
 err_free_minor:
    input_free_minor(minor);
    return error;
}