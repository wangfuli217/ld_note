http://blog.csdn.net/junllee/article/details/8900372
http://blog.csdn.net/yimu13/article/details/6783464 //ext
http://blog.chinaunix.net/uid-21977330-id-3754268.html //ext

һ ����
  Linux�ں���gpio����򵥣���õ���Դ(�� interrupt ,dma,timerһ��)��������Ӧ�ó����ܹ�ͨ����Ӧ�Ľӿ�ʹ��gpio��gpioʹ��0��MAX_INT֮���������ʶ������ʹ�ø���,gpio��Ӳ����ϵ������ص�,����linux��һ����ܴ���gpio���ܹ�ʹ��ͳһ�Ľӿ�������gpio.�ڽ�gpio����(gpiolib.c)֮ǰ��������gpio����ôʹ�õ�
�� �ں���gpio��ʹ��
     1 ����gpio�˿��Ƿ�Ϸ� int gpio_is_valid(int number); 
     2 ����ĳ��gpio�˿ڵ�Ȼ������֮ǰ��Ҫ��ʾ�����ø�gpio�˿ڵ�pinmux
        int gpio_request(unsigned gpio, const char *label)
     3 ���gpio��ʹ�÷���������뻹�����
       /*�ɹ�������ʧ�ܷ��ظ��Ĵ���ֵ*/ 
       int gpio_direction_input(unsigned gpio); 
       int gpio_direction_output(unsigned gpio, int value); 
     4 ���gpio���ŵ�ֵ������gpio���ŵ�ֵ(�������)
        int gpio_get_value(unsigned gpio);
        void gpio_set_value(unsigned gpio, int value); 
     5 gpio�����жϿ�ʹ��
        int gpio_to_irq(unsigned gpio); 
        ���ص�ֵ���жϱ�ſ��Դ���request_irq()��free_irq()
        �ں�ͨ�����øú�����gpio�˿�ת��Ϊ�жϣ����û��ռ�Ҳ�����Ʒ���
     6 ����gpio�˿ڵ��û��ռ�
        int gpio_export(unsigned gpio, bool direction_may_change); 
        �ں˿��Զ��Ѿ���gpio_request()�����gpio�˿ڵĵ���������ȷ�Ĺ���
        ����direction_may_change��ʾ�û������Ƿ������޸�gpio�ķ��򣬼������
        �����direction_may_changeΪ��
        /* ����GPIO�ĵ��� */ 
        void gpio_unexport(); 
      7 ���õ�һio����������
        int s3c_gpio_setpull(unsigned int pin, s3c_gpio_pull_t pull); 
        ���õ���ioΪ��ͬ������ģʽ��ģʽ�ֱ�Ϊ
        S3C_GPIO_PULL_NONE
        S3C_GPIO_PULL_DOWN
        S3C_GPIO_PULL_UP
        
�� �û��ռ�gpio�ĵ��� 
          �û��ռ����gpio����ͨ��sysfs�ӿڷ���gpio��������/sys/class/gpioĿ¼�µ������ļ��� 
            --export/unexport�ļ�
            --gpioNָ�������gpio����
            --gpio_chipNָ��gpio������
            ����֪�����Ͻӿ�û�б�׼device�ļ������ǵ����ӡ� 
(1) export/unexport�ļ��ӿڣ�
               /sys/class/gpio/export���ýӿ�ֻ��д���ܶ�
               �û�����ͨ��д��gpio�ı�������ں����뽫ĳ��gpio�Ŀ���Ȩ�������û��ռ䵱Ȼǰ����û���ں˴����������gpio�˿�
               ����  echo 19 > export 
               ����������Ϊ19��gpio����һ���ڵ�gpio19����ʱ/sys/class/gpioĿ¼�±�����һ��gpio19��Ŀ¼
               /sys/class/gpio/unexport�͵�����Ч���෴�� 
               ���� echo 19 > unexport
               �������������Ƴ�gpio19����ڵ㡣 
(2) /sys/class/gpio/gpioN
       ָ��ĳ�������gpio�˿�,��������������ļ�
      direction ��ʾgpio�˿ڵķ��򣬶�ȡ�����in��out�����ļ�Ҳ����д��д��out ʱ��gpio��Ϊ���ͬʱ��ƽĬ��Ϊ�͡�д��low��high�򲻽�����
                      ����Ϊ��� ��������������ĵ�ƽ�� ��Ȼ����ں˲�֧�ֻ����ں˴��벻Ը�⣬����������������,�����ں˵�����gpio_export(N,0)��
                       ��ʾ�ں˲�Ը���޸�gpio�˿ڷ������� 
      value      ��ʾgpio���ŵĵ�ƽ,0(�͵�ƽ)1���ߵ�ƽ��,���gpio������Ϊ��������ֵ�ǿ�д�ģ���ס�κη����ֵ��������ߵ�ƽ, ���ĳ������
                      �ܲ����Ѿ�������Ϊ�жϣ�����Ե���poll(2)�����������жϣ��жϴ�����poll(2)�����ͻ᷵�ء�
      edge      ��ʾ�жϵĴ�����ʽ��edge�ļ��������ĸ�ֵ��"none", "rising", "falling"��"both"��
           none��ʾ����Ϊ���룬�����ж�����
           rising��ʾ����Ϊ�ж����룬�����ش���
           falling��ʾ����Ϊ�ж����룬�½��ش���
           both��ʾ����Ϊ�ж����룬���ش���
                      ����ļ��ڵ�ֻ�������ű�����Ϊ�������ŵ�ʱ��Ŵ��ڡ� ��ֵ��noneʱ����ͨ�����·�������Ϊ�ж�����
                      echo "both" > edge;������both,falling����rising��������Ӳ�����жϵĴ�����ʽ���˷������û�̬gpioת��Ϊ�ж����ŵķ�ʽ
      active_low ����ô���ף�Ҳľ���ù�                                                                
(3)/sys/class/gpio/gpiochipN
      gpiochipN��ʾ�ľ���һ��gpio_chip,��������Ϳ���һ��gpio�˿ڵĿ���������Ŀ¼�´���һ�������ļ��� 
      base   ��N��ͬ����ʾ�������������С�Ķ˿ڱ�š� 
      lable   ���ʹ�õı�־����������Ψһ�ģ� 
      ngpio  ��ʾ�����������gpio�˿��������˿ڷ�Χ�ǣ�N ~ N+ngpio-1��
      
      
############ ������Ҫ����gpio����Ϊ�ж�

echo  "rising" > /sys/class/gpio/gpio12/edge       
������α����
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
            /*��ʱ��ʾ�Ѿ��������жϴ����ˣ��ø�����*/
            ...............
    }
}
��סʹ��poll()�����������¼���������ΪPOLLPRI��POLLERR��poll()���غ�ʹ��lseek()�ƶ����ļ���ͷ��ȡ�µ�ֵ���߹ر��������´򿪶�ȡ��ֵ����������������poll���������Ƿ��ء�
      
      
############################# �û�̬ʹ��gpio����LED
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
S3C6410��GPIO���������˵�Ƚ϶࣬���Ҵ󲿷����Ŷ����ж��ظ��ù��ܣ������linux����
��򵥵ķ�ʽ������GPIO����Ҫ���Ǻú��о�һ�µײ�Ĵ����ˣ���ʵ�����кܶ��֣�������
����ϵͳ�˿���GPIO��������ƴ�ͳ�ĵ�Ƭ��������

�����ҽ��ἰһ�ַ��������������ַ���Ҳ�������񿴵���򵥵ķ���
�������Ǵ�linux-3.0.1\arch\arm\plat-samsung\include\plat��gpio-cfg.h���ͷ�ļ���
��ϸ������֣����ǿ���ʹ�õĺ�����

1.���õ�һio��
int s3c_gpio_cfgpin(unsigned int pin, unsigned int to);
������������������һ��pin��ѡ���ĸ����ţ��ڶ������������ֶ���
���ó����ģʽ  #define S3C_GPIO_INPUT (S3C_GPIO_SPECIAL(0))
���ó�����ģʽ  #define S3C_GPIO_OUTPUT (S3C_GPIO_SPECIAL(1))
���ù���ѡ��    #define S3C_GPIO_SFN(x) (S3C_GPIO_SPECIAL(x))


1.��ȡio�ڵ�����
unsigned s3c_gpio_getcfg(unsigned int pin);������������潲���ĸպ��෴���Ƕ�ȡ
��ǰһ��io�ڵ����ã�pin������Ҫ��õ��������ã������᷵��һ����Ӧ��ֵ

2.����һ��io
int s3c_gpio_cfgpin_range(unsigned int start, unsigned int nr, unsigned int cfg); 
��һ������start�ǿ�ʼ�����ţ��ڶ���nr�Ǵ�start��ʼ����һ����ע�����õ�io������ͬһ���io��������cfg������״̬

3.���õ�һio����������
int s3c_gpio_setpull(unsigned int pin, s3c_gpio_pull_t pull); 
���õ���ioΪ��ͬ������ģʽ��ģʽ�ֱ�Ϊ
S3C_GPIO_PULL_NONE
S3C_GPIO_PULL_DOWN
S3C_GPIO_PULL_UP

5.��ȡio�ڵ�������������
s3c_gpio_pull_t s3c_gpio_getpull(unsigned int pin);
��ȡ����io����������״̬���᷵��һ������ģʽ


6.����һ��io(������������)
int s3c_gpio_cfgall_range(unsigned int start, unsigned int nr, unsigned int cfg, s3c_gpio_pull_t pull);
������ô�࿴�����һ����������ҲӦ���ܿ�����������������˰�
������ô��io�ڵ����÷������������������������ĵ�ƽ״̬��
��linux-3.0.1\include\linux�µ�gpio.h��ͷ�ļ������������кö�����ź�����������Ҫ��Ҳ����ô����

1.����һ�����ŵĵ�ƽ״̬
static inline void gpio_set_value(unsigned gpio, int value)
��һ������gpioΪָ�������ţ��ڶ�������valueΪҪ���õĸߵ͵�ƽ
2.���һ�����ŵĵ�ƽ״̬
static inline int gpio_get_value(unsigned gpio)
��һ������ΪgpioΪָ�������ţ��᷵��һ����ƽ״̬
����������Щ���ǻ����ܿ���һ��io�ˣ��������ڽ���һ�ַ��������ַ���ֻ�ܽ��������������ܽ���io�ĸ�������
1.io���
static inline int gpio_direction_output(unsigned gpio, int value)
��һ������gpioΪָ�������ţ��ڶ�������Ϊ��ƽ״̬
2.io����
static inline int gpio_direction_input(unsigned gpio)
��һ������gpioΪָ�������ţ��᷵��һ����ƽ״̬
�������淽�������ǻ�����ֱ�Ӷ�gpio�ĵ�ַ���ʣ�linux�Ѿ�Ϊ����׼���������Ľӿں���

#define __raw_readl(a) (__chk_io_ptr(a), *(volatile unsigned int __force *)(a))
#define __raw_writel(v,a) (__chk_io_ptr(a), *(volatile unsigned int __force *)(a) = (v))
���е�aֵΪ
S3C64XX_GPMCON
S3C64XX_GPMPUD
S3C64XX_GPMDAT
��reg-gpio.h���Ѿ��������ϵĶ���

VΪ�������ֵ��