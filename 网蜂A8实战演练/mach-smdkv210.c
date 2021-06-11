//arch/arm/mach-s5pv210/mach-smdkv210.c
static struct platform_device *smdkv210_devices[] __initdata = {
&s3c_device_nand,
&s3c_device_adc,
&s3c_device_cfcon,
&s3c_device_fb,
&s3c_device_hsmmc0,
&s3c_device_hsmmc1,
&s3c_device_hsmmc2,
&s3c_device_hsmmc3,
&s3c_device_i2c0,
&s3c_device_i2c1,
&s3c_device_i2c2,
&s3c_device_rtc,
&s3c_device_ts,
&s3c_device_usb_hsotg,
&s3c_device_wdt,
&s5p_device_fimc0,
&s5p_device_fimc1,
&s5p_device_fimc2,
&s5p_device_fimc_md,
&s5p_device_jpeg,
&s5p_device_mfc,
&s5p_device_mfc_l,
&s5p_device_mfc_r,
&s5pv210_device_ac97,
&s5pv210_device_iis0,
&s5pv210_device_spdif,
&samsung_asoc_idma,
&samsung_device_keypad,
&smdkv210_dm9000,
&smdkv210_lcd_lte480wv,
&webee210_button_device,
/* Add by Webee
*/
};

// Ȼ���ڶ��� smdkv210_devices �ṹ��ָ�������ǰ��,����������Щ���롣
/***********************Add by Webee********************************/
#include <linux/gpio_keys.h> /* Add by Webee */
static struct gpio_keys_button webee210_buttons[] = {
{
.gpio= S5PV210_GPH2(0),
/* S1 */
.code= KEY_A,
.desc= "Button 1",
.active_low = 1,
},
{
.gpio= S5PV210_GPH2(1),
/* S2 */
.code= KEY_B,
.desc= "Button 2",
.active_low = 1,
},
{
.gpio = S5PV210_GPH2(2), /* S3 */
.code = KEY_C,
.desc = "Button 3",
.active_low = 1,

},

{

.gpio = S5PV210_GPH2(3), /* S4 */
.code = KEY_L,
.desc = "Button 4",
.active_low = 1,

},

{

.gpio = S5PV210_GPH3(0), /* S5 */
.code = KEY_S,
.desc = "Button 5",
.active_low = 1,

},

{

.gpio = S5PV210_GPH3(1), /* S6 */
.code = KEY_ENTER,
.desc = "Button 6",
.active_low = 1,

},

{

.gpio = S5PV210_GPH3(2), /* S7 */
.code = KEY_LEFTSHIFT,
.desc = "Button 7",
.active_low = 1,

},

{

.gpio = S5PV210_GPH3(3), /* S8 */
.code = KEY_DELETE,
.desc = "Button 8",
.active_low = 1,
},
};

static struct gpio_keys_platform_data webee210_button_data = {
.buttons= webee210_buttons,
.nbuttons = ARRAY_SIZE(webee210_buttons),
};

/* �豸��ص���Ϣ�ᱣ���� pdev->dev.platform_data �� */
static struct platform_device webee210_button_device = {
.name= "gpio-keys",
.id= -1,
.dev={
.platform_data = &webee210_button_data,
}
};
/***********************Add by Webee********************************/
//�������������Ӻú�,ͨ�� make meuconfig,�� gpio_keys.c ������,�Ϳ���ʹ����� GPIO �����ˡ�

