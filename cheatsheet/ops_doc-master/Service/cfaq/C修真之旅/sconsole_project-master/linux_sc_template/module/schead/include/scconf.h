#ifndef _H_SCCONF
#define _H_SCCONF

/**
 *  这里是配置文件读取接口,
 * 写配置,读取配置,需要配置开始的指向路径 _STR_SCPATH
 */
#define _STR_SCCONF_PATH "module/schead/config/config.ini"

/*
 * 启动这个配置读取功能,或者重启也行
 */
extern void sc_start(void);

/*
 * 获取配置相应键的值,通过key
 * key		: 配置中名字
 *			: 返回对应的键值,如果没有返回NULL,并打印日志
 */
extern const char* sc_get(const char* key);

#endif // !_H_SCCONF