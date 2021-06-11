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
	{ 0x3d987c41, "debugfs_create_bool" },
	{ 0x5a24b7a7, "debugfs_create_u32" },
	{ 0x14bb2460, "debugfs_create_u16" },
	{ 0xfdff190c, "debugfs_create_u8" },
	{ 0xea147363, "printk" },
	{ 0x3eba92, "debugfs_create_dir" },
	{ 0xe8049993, "debugfs_remove" },
	{ 0xb4390f9a, "mcount" },
};

static const char __module_depends[]
__used
__attribute__((section(".modinfo"))) =
"depends=";


MODULE_INFO(srcversion, "2AF0DDBDDEACF9ED09AB640");

static const struct rheldata _rheldata __used
__attribute__((section(".rheldata"))) = {
	.rhel_major = 6,
	.rhel_minor = 3,
};
