http://blog.csdn.net/junllee/article/details/8900372
http://blog.csdn.net/yimu13/article/details/6783464 //ext
http://blog.chinaunix.net/uid-21977330-id-3754268.html //ext

一 概述
  Linux内核中gpio是最简单，最常用的资源(和 interrupt ,dma,timer一样)驱动程序，应用程序都能够通过相应的接口使用gpio，gpio使用0～MAX_INT之间的整数标识，不能使用负数,gpio与硬件体系密切相关的,不过linux有一个框架处理gpio，能够使用统一的接口来操作gpio.在讲gpio核心(gpiolib.c)之前先来看看gpio是怎么使用的
二 内核中gpio的使用
     1 测试gpio端口是否合法 int gpio_is_valid(int number); 
     2 申请某个gpio端口当然在申请之前需要显示的配置该gpio端口的pinmux
        int gpio_request(unsigned gpio, const char *label)
     3 标记gpio的使用方向包括输入还是输出
       /*成功返回零失败返回负的错误值*/ 
       int gpio_direction_input(unsigned gpio); 
       int gpio_direction_output(unsigned gpio, int value); 
     4 获得gpio引脚的值和设置gpio引脚的值(对于输出)
        int gpio_get_value(unsigned gpio);
        void gpio_set_value(unsigned gpio, int value); 
     5 gpio当作中断口使用
        int gpio_to_irq(unsigned gpio); 
        返回的值即中断编号可以传给request_irq()和free_irq()
        内核通过调用该函数将gpio端口转换为中断，在用户空间也有类似方法
     6 导出gpio端口到用户空间
        int gpio_export(unsigned gpio, bool direction_may_change); 
        内核可以对已经被gpio_request()申请的gpio端口的导出进行明确的管理，
        参数direction_may_change表示用户程序是否允许修改gpio的方向，假如可以
        则参数direction_may_change为真
        /* 撤销GPIO的导出 */ 
        void gpio_unexport(); 
      7 设置单一io的上拉电阻
        int s3c_gpio_setpull(unsigned int pin, s3c_gpio_pull_t pull); 
        设置单个io为不同的上拉模式，模式分别为
        S3C_GPIO_PULL_NONE
        S3C_GPIO_PULL_DOWN
        S3C_GPIO_PULL_UP
        
三 用户空间gpio的调用 
          用户空间访问gpio，即通过sysfs接口访问gpio，下面是/sys/class/gpio目录下的三种文件： 
            --export/unexport文件
            --gpioN指代具体的gpio引脚
            --gpio_chipN指代gpio控制器
            必须知道以上接口没有标准device文件和它们的链接。 
(1) export/unexport文件接口：
               /sys/class/gpio/export，该接口只能写不能读
               用户程序通过写入gpio的编号来向内核申请将某个gpio的控制权导出到用户空间当然前提是没有内核代码申请这个gpio端口
               比如  echo 19 > export 
               上述操作会为19号gpio创建一个节点gpio19，此时/sys/class/gpio目录下边生成一个gpio19的目录
               /sys/class/gpio/unexport和导出的效果相反。 
               比如 echo 19 > unexport
               上述操作将会移除gpio19这个节点。 
(2) /sys/class/gpio/gpioN
       指代某个具体的gpio端口,里边有如下属性文件
      direction 表示gpio端口的方向，读取结果是in或out。该文件也可以写，写入out 时该gpio设为输出同时电平默认为低。写入low或high则不仅可以
                      设置为输出 还可以设置输出的电平。 当然如果内核不支持或者内核代码不愿意，将不会存在这个属性,比如内核调用了gpio_export(N,0)就
                       表示内核不愿意修改gpio端口方向属性 
      value      表示gpio引脚的电平,0(低电平)1（高电平）,如果gpio被配置为输出，这个值是可写的，记住任何非零的值都将输出高电平, 如果某个引脚
                      能并且已经被配置为中断，则可以调用poll(2)函数监听该中断，中断触发后poll(2)函数就会返回。
      edge      表示中断的触发方式，edge文件有如下四个值："none", "rising", "falling"，"both"。
           none表示引脚为输入，不是中断引脚
           rising表示引脚为中断输入，上升沿触发
           falling表示引脚为中断输入，下降沿触发
           both表示引脚为中断输入，边沿触发
                      这个文件节点只有在引脚被配置为输入引脚的时候才存在。 当值是none时可以通过如下方法将变为中断引脚
                      echo "both" > edge;对于是both,falling还是rising依赖具体硬件的中断的触发方式。此方法即用户态gpio转换为中断引脚的方式
      active_low 不怎么明白，也木有用过                                                                
(3)/sys/class/gpio/gpiochipN
      gpiochipN表示的就是一个gpio_chip,用来管理和控制一组gpio端口的控制器，该目录下存在一下属性文件： 
      base   和N相同，表示控制器管理的最小的端口编号。 
      lable   诊断使用的标志（并不总是唯一的） 
      ngpio  表示控制器管理的gpio端口数量（端口范围是：N ~ N+ngpio-1）
      
      
############ 首先需要将该gpio配置为中断

echo  "rising" > /sys/class/gpio/gpio12/edge       
以下是伪代码
int gpio_id;
struct pollfd fds[1];
gpio_fd = open("/sys/class/gpio/gpio12/value",O_RDONLY);
if( gpio_fd == -1 )
   err_print("gpio open");
fds[0].fd = gpio_fd;
fds[0].events  = POLLPRI;
ret = read(gpio_fd,buff,10);
if( ret == -1 )
    err_print("read");
while(1){
     ret = poll(fds,1,-1);
     if( ret == -1 )
         err_print("poll");
       if( fds[0].revents & POLLPRI){
           ret = lseek(gpio_fd,0,SEEK_SET);
           if( ret == -1 )
               err_print("lseek");
           ret = read(gpio_fd,buff,10);
           if( ret == -1 )
               err_print("read");
            /*此时表示已经监听到中断触发了，该干事了*/
            ...............
    }
}
记住使用poll()函数，设置事件监听类型为POLLPRI和POLLERR在poll()返回后，使用lseek()移动到文件开头读取新的值或者关闭它再重新打开读取新值。必须这样做否则poll函数会总是返回。
      
      
############################# 用户态使用gpio控制LED
example code:
#include <stdio.h>
#include <unistd.h>
#include <sys/stat.h>
#include <linux/fs.h>
#include <fcntl.h>
#include <string.h>
#include <termios.h>
#include <sys/ioctl.h>


void tdelay(int d)
{
    volatile int j;
    for(j=0;j<d*1000000;j++);
}
//int main(int argc,char **argv)
int main(void)
{
    int gpio_fd = -1;
    int ret;
    // Led D5 connected to GPIO_JTAG_TDI,pin number is 242
    char gpio[]="242";
    char dir[]="out";
    gpio_fd = open("/sys/class/gpio/export",O_WRONLY);
    if(gpio_fd < 0){
        printf("open gpio/export failed\n");
        return -1;
    }
    ret = write(gpio_fd,gpio,strlen(gpio));
    if(ret < 0){
        printf("write to gpio/export failed\n");
        return -1;
    }
    close(gpio_fd);

    gpio_fd = open("/sys/class/gpio/gpio242/direction",O_RDWR);
    if(gpio_fd < 0){
        printf("open gpio242/direction failed\n");
        return -1;
    }

    ret = write(gpio_fd,dir,strlen(dir));
    if(ret < 0){
        printf("write to gpio242/direction failed\n");
        return -1;
    }
    close(gpio_fd);

    gpio_fd = open("/sys/class/gpio/gpio242/value",O_RDWR);
    if(gpio_fd < 0){
        printf("open gpio242/value failed\n");
        return -1;
    }

    int i;
    char off[]="1";
    char on[] = "0";
    for(i=0;i < 10;i++){
        printf("led off\n");
        ret = write(gpio_fd,off,strlen(off));
        if(ret < 0){
            printf("write to gpio242/value failed\n");
            return -1;
        }
        tdelay(10);
        printf("led on\n");
        ret = write(gpio_fd,on,strlen(on));
        if(ret < 0){

            printf("write to gpio242/value failed\n");
            return -1;
        }
        tdelay(10);
    }
    close(gpio_fd);

    gpio_fd = open("/sys/class/gpio/unexport",O_WRONLY);
    if(gpio_fd < 0){
        printf("open gpio/unexport failed\n");
        return -1;
    }
    ret = write(gpio_fd,gpio,strlen(gpio));
    if(ret < 0){
        printf("write to gpio/unexport failed\n");
        return -1;
    }
    close(gpio_fd);

    printf("test gpio led ok\n");

    return 0;
}


///////////////////////////////////////////////////////////////////////////////
S3C6410的GPIO引脚相对来说比较多，而且大部分引脚都具有多重复用功能，如何在linux上用
最简单的方式来控制GPIO这需要我们好好研究一下底层的代码了，其实方法有很多种，鉴于在
操作系统端控制GPIO并不像控制传统的单片机那样。

这里我将提及一种方法来讲述，这种方法也是我至今看到最简单的方法
首先我们打开linux-3.0.1\arch\arm\plat-samsung\include\plat下gpio-cfg.h这个头文件，
仔细浏览后发现，我们可以使用的函数：

1.设置单一io口
int s3c_gpio_cfgpin(unsigned int pin, unsigned int to);
里面有两个参数，第一个pin是选择哪个引脚，第二个参数有三种定义
设置成输出模式  #define S3C_GPIO_INPUT (S3C_GPIO_SPECIAL(0))
设置成输入模式  #define S3C_GPIO_OUTPUT (S3C_GPIO_SPECIAL(1))
复用功能选择    #define S3C_GPIO_SFN(x) (S3C_GPIO_SPECIAL(x))


1.获取io口的配置
unsigned s3c_gpio_getcfg(unsigned int pin);这个函数跟上面讲到的刚好相反，是读取
当前一个io口的配置，pin参数是要获得的引脚配置，函数会返回一个相应的值

2.设置一组io
int s3c_gpio_cfgpin_range(unsigned int start, unsigned int nr, unsigned int cfg); 
第一个参数start是开始的引脚，第二个nr是从start开始到第一个，注意配置的io必须是同一组的io，第三个cfg是配置状态

3.设置单一io的上拉电阻
int s3c_gpio_setpull(unsigned int pin, s3c_gpio_pull_t pull); 
设置单个io为不同的上拉模式，模式分别为
S3C_GPIO_PULL_NONE
S3C_GPIO_PULL_DOWN
S3C_GPIO_PULL_UP

5.获取io口的上拉电阻配置
s3c_gpio_pull_t s3c_gpio_getpull(unsigned int pin);
获取单个io的上拉配置状态，会返回一个配置模式


6.设置一组io(包括上拉电阻)
int s3c_gpio_cfgall_range(unsigned int start, unsigned int nr, unsigned int cfg, s3c_gpio_pull_t pull);
讲了这么多看到最后一个函数不讲也应该能看出到底是如何配置了吧
讲了这么多io口的配置方法，来看看如何来配置输出的电平状态。
打开linux-3.0.1\include\linux下的gpio.h的头文件，发现里面有好多的引脚函数其中最重要的也就这么几句

1.设置一个引脚的电平状态
static inline void gpio_set_value(unsigned gpio, int value)
第一个参数gpio为指定的引脚，第二个参数value为要设置的高低电平
2.获得一个引脚的电平状态
static inline int gpio_get_value(unsigned gpio)
第一个参数为gpio为指定的引脚，会返回一个电平状态
讲了上面这些我们基本能控制一个io了，现在我在介绍一种方法，这种方法只能进行输入和输出不能进行io的复用配置
1.io输出
static inline int gpio_direction_output(unsigned gpio, int value)
第一个参数gpio为指定的引脚，第二个参数为电平状态
2.io输入
static inline int gpio_direction_input(unsigned gpio)
第一个参数gpio为指定的引脚，会返回一个电平状态
出了上面方法外我们还可以直接对gpio的地址访问，linux已经为我们准备了这样的接口函数

#define __raw_readl(a) (__chk_io_ptr(a), *(volatile unsigned int __force *)(a))
#define __raw_writel(v,a) (__chk_io_ptr(a), *(volatile unsigned int __force *)(a) = (v))
其中的a值为
S3C64XX_GPMCON
S3C64XX_GPMPUD
S3C64XX_GPMDAT
在reg-gpio.h中已经有了以上的定义

V为具体的数值。