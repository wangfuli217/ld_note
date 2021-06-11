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
	{ 0xdbc2a508, "kobject_put" },
	{ 0x565a0d93, "kset_create_and_add" },
	{ 0xfa2e111f, "slab_buffer_size" },
	{ 0xd691cba2, "malloc_sizes" },
	{ 0xb0ae17, "kobject_uevent" },
	{ 0x105e2727, "__tracepoint_kmalloc" },
	{ 0x3c2c5af5, "sprintf" },
	{ 0xf85ccdae, "kmem_cache_alloc_notrace" },
	{ 0x42224298, "sscanf" },
	{ 0xb281519, "kobject_init_and_add" },
	{ 0xb4390f9a, "mcount" },
	{ 0xcd04ab0b, "kernel_kobj" },
	{ 0xce9d5dd7, "kset_unregister" },
	{ 0x37a0cba, "kfree" },
};

static const char __module_depends[]
__used
__attribute__((section(".modinfo"))) =
"depends=";


MODULE_INFO(srcversion, "E49E327277261F3D6266171");

static const struct rheldata _rheldata __used
__attribute__((section(".rheldata"))) = {
	.rhel_major = 6,
	.rhel_minor = 3,
};
