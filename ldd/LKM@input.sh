在linux 系统上 /dev/input这个路径下可以看到已经注册好的input设备节点，input设备的主设备号都是13，其中 
按键设备的次设备号从64~95,鼠标设备的次设备号从32~63。

/sys/class/input
/proc/bus/input

input(){
    图形界面和应用程序，通过监听设备节点，获取用户相应的输入事件，根据输入事件来做出相应的反应；
eventX (X从0开始)表示 按键事件，mice 表示鼠标事件
Input core  ---  input 核心
Input event drivers --- input事件驱动（mousedev 、 evdev、keyboard）
Input device drivers --- input设备驱动（触摸屏、键盘、鼠标）
}

input(input_dev:代表input设备){
struct input_dev {  ///代表 input 设备 
    const char *name; /// 设备名称
    const char *phys; ////设备在系统结构中的物理路径
    const char *uniq; ///设备的唯一标识符
    struct input_id id; ///描述硬件设备属性的 ID

    unsigned long propbit[BITS_TO_LONGS(INPUT_PROP_CNT)];/// INPUT_PROP_CNT--0x20 ，一个long包含32bit，所以 propbit[1]

    unsigned long evbit[BITS_TO_LONGS(EV_CNT)];  ///设备支持的事件类型
    unsigned long keybit[BITS_TO_LONGS(KEY_CNT)];
    unsigned long relbit[BITS_TO_LONGS(REL_CNT)];
    unsigned long absbit[BITS_TO_LONGS(ABS_CNT)];
    unsigned long mscbit[BITS_TO_LONGS(MSC_CNT)];
    unsigned long ledbit[BITS_TO_LONGS(LED_CNT)];
    unsigned long sndbit[BITS_TO_LONGS(SND_CNT)];
    unsigned long ffbit[BITS_TO_LONGS(FF_CNT)];
    unsigned long swbit[BITS_TO_LONGS(SW_CNT)];

    unsigned int hint_events_per_packet;

    unsigned int keycodemax;
    unsigned int keycodesize;
    void *keycode;

    int (*setkeycode)(struct input_dev *dev,
              const struct input_keymap_entry *ke,
              unsigned int *old_keycode);
    int (*getkeycode)(struct input_dev *dev,
              struct input_keymap_entry *ke);

    struct ff_device *ff;

    unsigned int repeat_key;
    struct timer_list timer;

    int rep[REP_CNT];

    struct input_mt *mt;

    struct input_absinfo *absinfo;

    unsigned long key[BITS_TO_LONGS(KEY_CNT)];
    unsigned long led[BITS_TO_LONGS(LED_CNT)];
    unsigned long snd[BITS_TO_LONGS(SND_CNT)];
    unsigned long sw[BITS_TO_LONGS(SW_CNT)];

    int (*open)(struct input_dev *dev);///打开设备
    void (*close)(struct input_dev *dev);
    int (*flush)(struct input_dev *dev, struct file *file);
    int (*event)(struct input_dev *dev, unsigned int type, unsigned int code, int value);

    struct input_handle __rcu *grab;

    spinlock_t event_lock;
    struct mutex mutex;

    unsigned int users;
    bool going_away;

    struct device dev;///每个设备的基类 

    struct list_head    h_list;
    struct list_head    node;

    unsigned int num_vals;
    unsigned int max_vals;
    struct input_value *vals;

    bool devres_managed;
};
}

input(input_handler：代表输入设备的处理方法){
struct input_handler {///代表输入设备的处理方法
    void *private;
    void (*event)(struct input_handle *handle, unsigned int type, unsigned int code, int value);
    void (*events)(struct input_handle *handle,
               const struct input_value *vals, unsigned int count);
    bool (*filter)(struct input_handle *handle, unsigned int type, unsigned int code, int value);///
    bool (*match)(struct input_handler *handler, struct input_dev *dev);
    int (*connect)(struct input_handler *handler, struct input_dev *dev, const struct input_device_id *id);
    void (*disconnect)(struct input_handle *handle);
    void (*start)(struct input_handle *handle);

    bool legacy_minors; ///是否遗留次设备号
    int minor;///次设备号
    const char *name;///名称

    const struct input_device_id *id_table;/// input_device 和 input_handle 通过id_table 进行匹配

    struct list_head    h_list;
    struct list_head    node;
};

Match ：在设备id 和handler 的id_table 匹配成功的时候调用；
Connect ： 当一个handle 匹配到一个device 的时候执行
Start ：当input 核心执行完 connect 以后调用
}


input(input_handle：用来关联input_dev 和 input_handler){
struct input_handle { //// 用来关联input_dev 和 input_handler 

    void *private;///私有成员变量

    int open;
    const char *name;

    struct input_dev *dev;
    struct input_handler *handler;

    struct list_head    d_node;
    struct list_head    h_node;
};

}

input(Input 事件驱动){
（主要文件 ：drivers/input/evdev.c  、  drivers/input/input.h）基于kernel 4.0 
一、 关键函数调用顺序：
1、input_register_handler(&evdev_handler); ///注册 evdev_handler 这个input事件驱evdev.c   
2、input_attach_handler(dev, handler);////input 设备和 input 事件进行匹配   input.h
3、handler->connect(handler, dev, id);///调用evdev_handler 的 connect 函数（.connect = evdev_connect）
4、evdev_connect(struct input_handler *handler, struct input_dev *dev,
const struct input_device_id *id)
5、cdev_init(&evdev->cdev, &evdev_fops);//// 初始化一个 cdev
6、device_add(&evdev->dev);///把初始化好的 evdev 添加到内核

在系统启动时系统会注册input事件驱动 evdev_handler，通过遍历系统中已经存在input设备，并与之进行匹配，匹配成功即条用connect函数
创建evdev设备，即input设备节点，初始化完成之后，上层应用程序通过evdev_fops对输入设备节点进行open/write/read/ioctrl等一系列操作，
从而完成input输入子系统的整个功能实现；



}

input(Input 设备驱动){
操作硬件获取硬件寄存器中设备输入的数据，并把数据交给核心层；

一 、设备驱动的注册步骤：
1、分配一个struct  input_dev :
         struct      input_dev  *input_dev；
2、 初始化 input_dev 这个结构体 :
3、 注册这个input_dev 设备：
Input_register_device（dev）；
4、 在input设备发生输入操作时，提交所发生的事件及键值、坐标等信息：
Input_report_abs()///报告X，y的坐标值
Input_report_key()///报告触摸屏的状态，是否被按下
Input_sync () ///表示提交一个完整的报告，这样linux内核就知道哪几个数据组合起来代表一个事件
 

二、Linux 中输入事件的类型：
EV_SYN  0X00  同步事件
EV_KEY  0X01  按键事件
EV_REL  0X02  相对坐标
EV_ABS  0X03  绝对坐标
....

三、关键程序片段（以USB鼠标为例：drivers\hid\usbhid\usbmouse.c）
1、 module_usb_driver(usb_mouse_driver);///系统启动时注册usb_mouse_driver （在usb架构中实现）
2、 usb_mouse_probe （设备初始化，usbmouse 属于usb设备，匹配成功后注册input设备）
3、 input_register_device(mouse->dev); 注册设备驱动
4、 input_attach_handler(dev, handler);///遍历所有的input_handler，并与 dev 进行匹配
usbmouse除了可以和evdev_handler 匹配成功，还和mousedev_handler 匹配成功，所以会分别调用evdev_handler的connect 函数创建event 节点和 mousedev_handler 的connect创建mouse节点
5、 input_match_device(handler, dev);///---->handler 和 device 进行真正的匹配（通过id_table 进行匹配）
6、 handler->connect(handler, dev, id);///匹配成功调用handler的connect 函数
7、 evdev_connect（）///将创建 event（0、1、2…）节点
8、 mousedev_connect（）///将创建 mouse（0、1、2…）节点
9、 mousedev_create（）
10、cdev_init(&mousedev->cdev, &mousedev_fops);
11、usb_mouse_irq（）///最终的数据在中断里面获取到，并保存到mouse –>data 里面
12、input_report_key\ input_report_rel\ input_sync ///报告按键信息
13、input_event
14、input_handle_event(dev, type, code, value)
15、input_pass_values(dev, dev->vals, dev->num_vals);
16、input_to_handler(handle, vals, count);
17、handler->event(handle, v->type, v->code, v->value);

}


