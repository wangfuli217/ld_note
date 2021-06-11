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
	{ 0x4f1939c7, "per_cpu__current_task" },
	{ 0xc8b57c27, "autoremove_wake_function" },
	{ 0x3457cb68, "param_set_long" },
	{ 0xeb1fabf6, "interruptible_sleep_on" },
	{ 0xa28e76e6, "schedule_work" },
	{ 0x1a6d6e4f, "remove_proc_entry" },
	{ 0x6a9f26c9, "init_timer_key" },
	{ 0x3c2c5af5, "sprintf" },
	{ 0x7d11c268, "jiffies" },
	{ 0x9629486a, "per_cpu__cpu_number" },
	{ 0xe83fea1, "del_timer_sync" },
	{ 0xf397b9aa, "__tasklet_schedule" },
	{ 0xb4390f9a, "mcount" },
	{ 0x6dcaeb88, "per_cpu__kernel_stack" },
	{ 0x46085e4f, "add_timer" },
	{ 0x8bd5b603, "param_get_long" },
	{ 0x340e0ae, "schedule_delayed_work" },
	{ 0x1000e51, "schedule" },
	{ 0x6d6b15ff, "create_proc_entry" },
	{ 0x642e54ac, "__wake_up" },
	{ 0x33d92f9a, "prepare_to_wait" },
	{ 0x9ccb2622, "finish_wait" },
};

static const char __module_depends[]
__used
__attribute__((section(".modinfo"))) =
"depends=";


MODULE_INFO(srcversion, "7D4626AA6AC947A37B87246");

static const struct rheldata _rheldata __used
__attribute__((section(".rheldata"))) = {
	.rhel_major = 6,
	.rhel_minor = 3,
};
