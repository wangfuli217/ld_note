#include <linux/module.h>
#include <linux/init.h>
#include <linux/fs.h>
#include <linux/interrupt.h>
#include <linux/irq.h>
#include <linux/sched.h>
#include <linux/pm.h>
#include <linux/sysctl.h>
#include <linux/proc_fs.h>
#include <linux/delay.h>
#include <linux/device.h>
#include <linux/types.h>
#include <linux/kernel.h>
#include <linux/platform_device.h>
#include <linux/input.h>
#include <asm/gpio.h>
#include <linux/gpio.h>
#include <mach/gpio.h>
#include <plat/gpio-cfg.h>
#include <linux/sysfs.h>
#include <linux/io.h>
#include <mach/regs-clock.h>

#include <linux/wakelock.h>

extern struct proc_dir_entry proc_root;

static struct proc_dir_entry *root_entry;
static struct proc_dir_entry *run_entry;
static struct proc_dir_entry *link_entry;
static struct proc_dir_entry *bell_entry;
static struct proc_dir_entry *mask_entry;
static struct proc_dir_entry *plug_entry;
static struct proc_dir_entry *opm_entry;
static struct proc_dir_entry *pwr1_entry;
static struct proc_dir_entry *pwr2_entry;

extern struct proc_dir_entry proc_root;

#define LED_GPIO_RUN	EXYNOS4_GPX1(6) //eint 14  RUN
#define LED_GPIO_LINK	EXYNOS4_GPX1(3) //eint 11  LINK
#define LED_GPIO_BELL	EXYNOS4_GPX1(4) //eint 12  BELL
#define LED_GPIO_MASK	EXYNOS4_GPX1(7) //eint 15  MASK
#define LED_GPIO_PLUG	EXYNOS4_GPX2(7) //eint 23  Plug-on
#define LED_GPIO_OPM	EXYNOS4_GPX2(4) //eint 20  OPM
#define LED_GPIO_PWR1	EXYNOS4_GPX3(0) //eint 24  Power1
#define LED_GPIO_PWR2	EXYNOS4_GPX3(1) //eint 25  Power2


static int run_proc_write(struct file *file, const char *buffer, 
                           unsigned long count, void *data) 
{
    int value; 
    value = 0; 
    sscanf(buffer, "%d", &value);
    printk(KERN_EMERG "value = %d \n",value);

    if (value == 0)
    {
        gpio_direction_output(LED_GPIO_RUN, 0);
    }
    else
    {
        gpio_direction_output(LED_GPIO_RUN, 1);
    }
    return count; 
}

static int run_proc_read(char *page, char **start, off_t off, 
			  int count, int *eof, void *data) 
{
    int value;
    int len = 0;

    value = gpio_get_value(LED_GPIO_RUN);
    len = sprintf(page+len, "%d", value);

    return len;
}


static int link_proc_write(struct file *file, const char *buffer, 
                           unsigned long count, void *data) 
{
    int value; 
    value = 0; 
    sscanf(buffer, "%d", &value);
    printk(KERN_EMERG "value = %d \n",value);

    if (value == 0)
    {
        gpio_direction_output(LED_GPIO_LINK, 0);
    }
    else
    {
        gpio_direction_output(LED_GPIO_LINK, 1);
    }
    return count; 
}

static int link_proc_read(char *page, char **start, off_t off, 
			  int count, int *eof, void *data) 
{
    int value;
    int len = 0;

    value = gpio_get_value(LED_GPIO_LINK);
    len = sprintf(page+len, "%d", value);

    return len;
}

static int bell_proc_write(struct file *file, const char *buffer, 
                           unsigned long count, void *data) 
{
    int value; 
    value = 0; 
    sscanf(buffer, "%d", &value);
    printk(KERN_EMERG "value = %d \n",value);

    if (value == 0)
    {
        gpio_direction_output(LED_GPIO_BELL, 0);
    }
    else
    {
        gpio_direction_output(LED_GPIO_BELL, 1);
    }
    return count; 
}

static int bell_proc_read(char *page, char **start, off_t off, 
			  int count, int *eof, void *data) 
{
    int value;
    int len = 0;

    value = gpio_get_value(LED_GPIO_BELL);
    len = sprintf(page+len, "%d", value);

    return len;
}


static int mask_proc_write(struct file *file, const char *buffer, 
                           unsigned long count, void *data) 
{
    int value; 
    value = 0; 
    sscanf(buffer, "%d", &value);
    printk(KERN_EMERG "value = %d \n",value);

    if (value == 0)
    {
        gpio_direction_output(LED_GPIO_MASK, 0);
    }
    else
    {
        gpio_direction_output(LED_GPIO_MASK, 1);
    }
    return count; 
}

static int mask_proc_read(char *page, char **start, off_t off, 
			  int count, int *eof, void *data) 
{
    int value;
    int len = 0;

    value = gpio_get_value(LED_GPIO_MASK);
    len = sprintf(page+len, "%d", value);

    return len;
}

static int plug_proc_write(struct file *file, const char *buffer, 
                           unsigned long count, void *data) 
{
    int value; 
    value = 0; 
    sscanf(buffer, "%d", &value);
    printk(KERN_EMERG "value = %d \n",value);

    if (value == 0)
    {
        gpio_direction_output(LED_GPIO_PLUG, 0);
    }
    else
    {
        gpio_direction_output(LED_GPIO_PLUG, 1);
    }
    return count; 
}

static int plug_proc_read(char *page, char **start, off_t off, 
			  int count, int *eof, void *data) 
{
    int value;
    int len = 0;

    value = gpio_get_value(LED_GPIO_PLUG);
    len = sprintf(page+len, "%d", value);

    return len;
}

static int opm_proc_write(struct file *file, const char *buffer, 
                           unsigned long count, void *data) 
{
    int value; 
    value = 0; 
    sscanf(buffer, "%d", &value);
    printk(KERN_EMERG "value = %d \n",value);

    if (value == 0)
    {
        gpio_direction_output(LED_GPIO_OPM, 0);
    }
    else
    {
        gpio_direction_output(LED_GPIO_OPM, 1);
    }
    return count; 
}

static int opm_proc_read(char *page, char **start, off_t off, 
			  int count, int *eof, void *data) 
{
    int value;
    int len = 0;

    value = gpio_get_value(LED_GPIO_OPM);
    len = sprintf(page+len, "%d", value);

    return len;
}

static int pwr1_proc_write(struct file *file, const char *buffer, 
                           unsigned long count, void *data) 
{
    int value; 
    value = 0; 
    sscanf(buffer, "%d", &value);
    printk(KERN_EMERG "value = %d \n",value);

    if (value == 0)
    {
        gpio_direction_output(LED_GPIO_PWR1, 0);
    }
    else
    {
        gpio_direction_output(LED_GPIO_PWR1, 1);
    }
    return count; 
}

static int pwr1_proc_read(char *page, char **start, off_t off, 
			  int count, int *eof, void *data) 
{
    int value;
    int len = 0;

    value = gpio_get_value(LED_GPIO_PWR1);
    len = sprintf(page+len, "%d", value);

    return len;
}


static int pwr2_proc_write(struct file *file, const char *buffer, 
                           unsigned long count, void *data) 
{
    int value; 
    value = 0; 
    sscanf(buffer, "%d", &value);
    printk(KERN_EMERG "value = %d \n",value);

    if (value == 0)
    {
        gpio_direction_output(LED_GPIO_PWR2, 0);
    }
    else
    {
        gpio_direction_output(LED_GPIO_PWR2, 1);
    }
    return count; 
}

static int pwr2_proc_read(char *page, char **start, off_t off, 
			  int count, int *eof, void *data) 
{
    int value;
    int len = 0;

    value = gpio_get_value(LED_GPIO_PWR2);
    len = sprintf(page+len, "%d", value);

    return len;
}

static int s3c_button_probe(struct platform_device *pdev)
{
    gpio_request(LED_GPIO_RUN, "s3c-run");
    s3c_gpio_setpull(LED_GPIO_RUN, S3C_GPIO_PULL_DOWN);
    gpio_direction_input(LED_GPIO_RUN);

    gpio_request(LED_GPIO_LINK, "s3c-link");
    s3c_gpio_setpull(LED_GPIO_LINK, S3C_GPIO_PULL_DOWN);
    gpio_direction_input(LED_GPIO_LINK);

    gpio_request(LED_GPIO_BELL, "s3c-bell");
    s3c_gpio_setpull(LED_GPIO_BELL, S3C_GPIO_PULL_DOWN);
    gpio_direction_input(LED_GPIO_BELL);

    gpio_request(LED_GPIO_MASK, "s3c-mask");
    s3c_gpio_setpull(LED_GPIO_MASK, S3C_GPIO_PULL_UP);
    gpio_direction_input(LED_GPIO_MASK);

    gpio_request(LED_GPIO_PLUG, "s3c-plug");
    s3c_gpio_setpull(LED_GPIO_PLUG, S3C_GPIO_PULL_UP);
    gpio_direction_input(LED_GPIO_PLUG);

    gpio_request(LED_GPIO_OPM, "s3c-opm");
    s3c_gpio_setpull(LED_GPIO_OPM, S3C_GPIO_PULL_UP);
    gpio_direction_input(LED_GPIO_OPM);

    gpio_request(LED_GPIO_PWR1, "s3c-power1");
    s3c_gpio_setpull(LED_GPIO_PWR1, S3C_GPIO_PULL_UP);
    gpio_direction_input(LED_GPIO_PWR1);

    gpio_request(LED_GPIO_PWR2, "s3c-power2");
    s3c_gpio_setpull(LED_GPIO_PWR2, S3C_GPIO_PULL_UP);
    gpio_direction_input(LED_GPIO_PWR2);
	
	root_entry = proc_mkdir("rtu_status", &proc_root);
	if(root_entry)
	{
		run_entry = create_proc_entry("run" ,0666, root_entry);
		if(run_entry)
		{
			run_entry->write_proc = run_proc_write;
			run_entry->read_proc =  run_proc_read;
			run_entry->data = (void*)0;	
		}
        
               link_entry = create_proc_entry("link" ,0666, root_entry);
		if(link_entry)
		{
			link_entry->write_proc = link_proc_write;
			link_entry->read_proc =  link_proc_read;
			link_entry->data = (void*)0;	
		}
        
                bell_entry = create_proc_entry("bell" ,0666, root_entry);
		if(bell_entry)
		{
			bell_entry->write_proc = bell_proc_write;
			bell_entry->read_proc =  bell_proc_read;
			bell_entry->data = (void*)0;	
		}
        
                mask_entry = create_proc_entry("mask" ,0666, root_entry);
		if(mask_entry)
		{
			mask_entry->write_proc = mask_proc_write;
			mask_entry->read_proc =  mask_proc_read;
			mask_entry->data = (void*)0;	
		}
             plug_entry = create_proc_entry("plug" ,0666, root_entry);
		if(plug_entry)
		{
			plug_entry->write_proc = plug_proc_write;
			plug_entry->read_proc =  plug_proc_read;
			plug_entry->data = (void*)0;	
		}
             opm_entry = create_proc_entry("opm" ,0666, root_entry);
		if(opm_entry)
		{
			opm_entry->write_proc = opm_proc_write;
			opm_entry->read_proc =  opm_proc_read;
			opm_entry->data = (void*)0;	
		}
            pwr1_entry = create_proc_entry("power1" ,0666, root_entry);
		if(pwr1_entry)
		{
			pwr1_entry->write_proc = pwr1_proc_write;
			pwr1_entry->read_proc =  pwr1_proc_read;
			pwr1_entry->data = (void*)0;	
		}
            pwr2_entry = create_proc_entry("power2" ,0666, root_entry);
		if(pwr2_entry)
		{
			pwr2_entry->write_proc = pwr2_proc_write;
			pwr2_entry->read_proc =  pwr2_proc_read;
			pwr2_entry->data = (void*)0;	
		}
        
	}
	printk(KERN_EMERG "s3c button Initialized!!\n");

	return 0;
}

static int s3c_button_remove(struct platform_device *pdev)
{

    
    gpio_free(LED_GPIO_RUN);
    gpio_free(LED_GPIO_LINK);
    gpio_free(LED_GPIO_BELL);
    gpio_free(LED_GPIO_MASK);
    gpio_free(LED_GPIO_PLUG);
    gpio_free(LED_GPIO_OPM);
    gpio_free(LED_GPIO_PWR1);
    gpio_free(LED_GPIO_PWR2);

    return  0;
}


#ifdef CONFIG_PM
static int s3c_button_suspend(struct platform_device *pdev, pm_message_t state)
{
       printk(KERN_EMERG "s3c_button_suspend!!\n");
	return 0;
}

static int s3c_button_resume(struct platform_device *pdev)
{
	printk(KERN_EMERG "s3c_button_resume!!\n");
	return 0;
}
#else
#define s3c_button_suspend	NULL
#define s3c_button_resume	NULL
#endif

static struct platform_driver s3c_button_device_driver = {
	.probe		= s3c_button_probe,
	.remove		= s3c_button_remove,
	.suspend	= s3c_button_suspend,
	.resume		= s3c_button_resume,
	.driver		= {
		.name	= "s3c-button",
		.owner	= THIS_MODULE,
	}
};


static struct platform_device s3c_device_button = {
	.name	= "s3c-button",
	.id		= -1,
};

static int __init s3c_button_init(void)
{
	platform_device_register(&s3c_device_button);
	return platform_driver_register(&s3c_button_device_driver);
}

static void __exit s3c_button_exit(void)
{
	platform_driver_unregister(&s3c_button_device_driver);
	platform_device_unregister(&s3c_device_button);
}

module_init(s3c_button_init);
module_exit(s3c_button_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("rongpin");
MODULE_DESCRIPTION("Keyboard driver for s3c button.");
MODULE_ALIAS("platform:s3c-button");
