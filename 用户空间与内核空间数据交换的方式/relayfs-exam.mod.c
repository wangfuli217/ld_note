#include <linux/module.h>
#include <linux/vermagic.h>
#include <linux/compiler.h>

MODULE_INFO(vermagic, VERMAGIC_STRING);

struct module __this_module
__attribute__((section(".gnu.linkonce.this_module"))) = {
 .name = KBUILD_MODNAME,
 .init = init_module,
#ifdef CONFIG_MODULE_UNLOAD
 .exit = cleanup_module,
#endif
 .arch = MODULE_ARCH_INIT,
};

static const struct modversion_info ____versions[]
__used
__attribute__((section("__versions"))) = {
	{ 0x14522340, "module_layout" },
	{ 0x3c2c5af5, "sprintf" },
	{ 0x1151e376, "relay_switch_subbuf" },
	{ 0x7d11c268, "jiffies" },
	{ 0x9629486a, "per_cpu__cpu_number" },
	{ 0xe83fea1, "del_timer_sync" },
	{ 0x3d0951f7, "relay_close" },
	{ 0xea147363, "printk" },
	{ 0xb4390f9a, "mcount" },
	{ 0x46085e4f, "add_timer" },
	{ 0x99d2b25f, "relay_buf_full" },
	{ 0xfc6256b9, "boot_tvec_bases" },
	{ 0xd258dfc9, "init_task" },
	{ 0x78764f4e, "pv_irq_ops" },
	{ 0x236c8c64, "memcpy" },
	{ 0x4925d54e, "relay_open" },
};

static const char __module_depends[]
__used
__attribute__((section(".modinfo"))) =
"depends=";


MODULE_INFO(srcversion, "B729A9F5A33EF730C10D8EC");

static const struct rheldata _rheldata __used
__attribute__((section(".rheldata"))) = {
	.rhel_major = 6,
	.rhel_minor = 3,
};
