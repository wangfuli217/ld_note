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

static struct timer_list timer;
static struct input_dev * input;
extern struct proc_dir_entry proc_root;

static struct wake_lock s_wakelock;
enum  {
	BUTTON_BACK = 0,
	BUTTON_MENU,
	BUTTON_HOME,
	BUTTON_VOLUMEUP,
	BUTTON_VOLUMEDOWN,
	BUTTON_UP,
	BUTTON_DOWN,
	BUTTON_LEFT,
	BUTTONE_MAX
};

struct st_s3c_key{
	int key_code;
	uint key_pin;
	int key_history_flg;
};

#define MAX_BUTTON_CNT 		(BUTTONE_MAX)


static struct proc_dir_entry *root_entry;
static struct proc_dir_entry *entry;
extern struct proc_dir_entry proc_root;



static int s3c_Keycode[MAX_BUTTON_CNT] = {
    KEY_BACK
	KEY_MENU, 
	KEY_HOME, 
	KEY_VOLUMEUP, 
	KEY_VOLUMEDOWN,
	KEY_UP, 
	KEY_DOWN,
	KEY_LEFT
};

static struct st_s3c_key s3c_key_para[MAX_BUTTON_CNT] = {
  		{ KEY_BACK, EXYNOS4_GPX0(1), 0},  // ---EINT1  
		{ KEY_MENU, EXYNOS4_GPX3(2), 0},  //---EINT26
		{ KEY_HOME, EXYNOS4_GPX2(1), 0},  //---EINT17
		{ KEY_VOLUMEUP, EXYNOS4_GPX2(6), 0},  //---EINT22
		{ KEY_VOLUMEDOWN, EXYNOS4_GPX2(7), 0},	//---EINT23
		{ KEY_UP, EXYNOS4_GPX2(4), 0}, //---EINT20
		{ KEY_DOWN, EXYNOS4_GPX2(5), 0},  //---EINT21
		{ KEY_LEFT, EXYNOS4_GPX2(0), 0}, //---EINT16
};

static void s3cbutton_timer_handler(unsigned long data)
{
	int flag;
	int i;
	for(i=0; i<MAX_BUTTON_CNT; i++) 
	{
		flag = gpio_get_value(s3c_key_para[i].key_pin);
		if(flag != s3c_key_para[i].key_history_flg) 
		{
			if(flag) 
			{
				input_report_key(input, s3c_key_para[i].key_code, 0);
				printk("s3c-button back key up!\n");
 			}  
			else  
			{
				input_report_key(input, s3c_key_para[i].key_code, 1);
				printk("s3c-button back key down!!\n");
			}
			s3c_key_para[i].key_history_flg= flag;

			input_sync(input);
		}
	}

	/* Kernel Timer restart */
	mod_timer(&timer,jiffies + HZ/20);
}


#define LED_GPIO_1	EXYNOS4_GPX1(6) //eint 14
#define LED_GPIO_2	EXYNOS4_GPX1(3) //eint 11
#define LED_GPIO_3	EXYNOS4_GPX1(4) //eint 12


static int button_proc_write(struct file *file, const char *buffer, 
                           unsigned long count, void *data) 
{
	int value; 
	value = 0; 
	sscanf(buffer, "%d", &value);
	printk("value = %d\n",value);

	if (value == 1)
    {
        gpio_direction_output(LED_GPIO_1, 0);
    }
	else if (value == 2)
    {
        gpio_direction_output(LED_GPIO_1, 1);
    }
	else if (value == 3)
    {
        gpio_direction_output(LED_GPIO_2, 0);
    }
	else if (value == 4)
    {
        gpio_direction_output(LED_GPIO_2, 1);
    }
	else if (value == 5)
    {
        gpio_direction_output(LED_GPIO_3, 0);
    }
	else if (value == 6)
    {
        gpio_direction_output(LED_GPIO_3, 1);
    }
	else if (value == 7) 
    {
    }
    return count; 
}

static int button_proc_read(char *page, char **start, off_t off, 
			  int count, int *eof, void *data) 
{
	int value;
	int i;
	int len = 0;

//	len = sprintf(page, "\n%s = \n", __func__);

	value = gpio_get_value(LED_GPIO_1);
	len = sprintf(page+len, " %d,", value);
	
	value = gpio_get_value(LED_GPIO_2);
	len += sprintf(page+len, " %d,", value);
	
	value = gpio_get_value(LED_GPIO_3);
	len += sprintf(page+len, " %d,", value);
	
	return len;
	
}


static int RS485_proc_write(struct file *file, const char *buffer, 
                           unsigned long count, void *data) 
{
	int value; 
	value = 0; 
	sscanf(buffer, "%d", &value);
	printk("value = %d\n",value);
	if (value == 0)//485 1 rx
    {
        gpio_direction_output(EXYNOS4_GPX1(4), 0);
    }
	else if (value == 1) //485 1 tx
    {
        gpio_direction_output(EXYNOS4_GPX1(4), 1);
    }
	else if (value == 2)//485 2 rx
    {
        gpio_direction_output(EXYNOS4_GPX1(6), 0);
    }
	else if (value == 3)//485 2 tx
    {
        gpio_direction_output(EXYNOS4_GPX1(6), 1);
    }
    return count; 
}
static int s3c_button_probe(struct platform_device *pdev)
{
	int i;

	for(i=0; i<MAX_BUTTON_CNT; i++)  {
		gpio_request(s3c_key_para[i].key_pin, "s3c-button");
		s3c_gpio_setpull(s3c_key_para[i].key_pin, S3C_GPIO_PULL_UP);
		gpio_direction_input(s3c_key_para[i].key_pin);
	}

	input = input_allocate_device();
	if(!input) 
		return -ENOMEM;

	set_bit(EV_KEY, input->evbit);
	//set_bit(EV_REP, input->evbit);	/* Repeat Key */

	for(i = 0; i < MAX_BUTTON_CNT; i++)
		set_bit(s3c_key_para[i].key_code, input->keybit);

	input->name = "s3c-button";
	input->phys = "s3c-button/input0";

	input->id.bustype = BUS_HOST;
	input->id.vendor = 0x0001;
	input->id.product = 0x0001;
	input->id.version = 0x0100;

	input->keycode = s3c_Keycode;
	input->keycodemax  = ARRAY_SIZE(s3c_Keycode);
	input->keycodesize = sizeof(s3c_Keycode[0]);

	if(input_register_device(input) != 0)
	{
		printk("s3c-button input register device fail!!\n");

		input_free_device(input);
		return -ENODEV;
	}

	/* Scan timer init */
/*	
	init_timer(&timer);
	timer.function = s3cbutton_timer_handler;

	timer.expires = jiffies + (HZ/20);
	add_timer(&timer);
*/	

	
	root_entry = proc_mkdir("rp_button", &proc_root);
	if(root_entry)
	{
		entry = create_proc_entry("button_ctrl" ,0666, root_entry);
		if(entry)
		{
			entry->write_proc = button_proc_write;
			entry->read_proc =  button_proc_read;
			entry->data = (void*)0;	
		}
/*		
		entry = create_proc_entry("485_ctrl" ,0666, root_entry);
		if(entry)
		{
			entry->write_proc = RS485_proc_write;
			entry->read_proc =  NULL;
			entry->data = (void*)0;	
		}
*/
	}
	printk("s3c button Initialized!!\n");

	return 0;
}

static int s3c_button_remove(struct platform_device *pdev)
{
	int i;

	input_unregister_device(input);
	del_timer(&timer);
	for(i=0; i<MAX_BUTTON_CNT; i++)  {
		gpio_free(s3c_key_para[i].key_pin);
	}
	return  0;
}


#ifdef CONFIG_PM
static int s3c_button_suspend(struct platform_device *pdev, pm_message_t state)
{
       printk("s3c_button_suspend!!\n");
	return 0;
}

static int s3c_button_resume(struct platform_device *pdev)
{
	printk("s3c_button_resume!!\n");
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
