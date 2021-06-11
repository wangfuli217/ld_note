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
	{ 0x6bc3fbc0, "__unregister_chrdev" },
	{ 0x5a34a45c, "__kmalloc" },
	{ 0x6980fe91, "param_get_int" },
	{ 0xfa0d49c7, "__register_chrdev" },
	{ 0xff964b25, "param_set_int" },
	{ 0xf10de535, "ioread8" },
	{ 0x5252f304, "__memcpy_toio" },
	{ 0xea147363, "printk" },
	{ 0x85f8a266, "copy_to_user" },
	{ 0xb4390f9a, "mcount" },
	{ 0x7dceceac, "capable" },
	{ 0x42c8de35, "ioremap_nocache" },
	{ 0x727c4f3, "iowrite8" },
	{ 0xf666cbb3, "__memcpy_fromio" },
	{ 0x37a0cba, "kfree" },
	{ 0xedc03953, "iounmap" },
	{ 0xc5534d64, "ioread16" },
	{ 0x3302b500, "copy_from_user" },
	{ 0xe484e35f, "ioread32" },
};

static const char __module_depends[]
__used
__attribute__((section(".modinfo"))) =
"depends=";


MODULE_INFO(srcversion, "128783BB606195AC0D6F863");

static const struct rheldata _rheldata __used
__attribute__((section(".rheldata"))) = {
	.rhel_major = 6,
	.rhel_minor = 3,
};
