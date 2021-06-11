#ifndef _H_TSTRING
#define _H_TSTRING

#include <schead.h>

//------------------------------------------------简单字符串辅助操作----------------------------------

/*
 * 主要采用jshash 返回计算后的hash值
 * 不冲突率在 80% 左右还可以, 不要传入NULL
 */
extern unsigned str_hash(const char* str);

/*
 * 这是个不区分大小写的比较函数
 * ls		: 左边比较字符串
 * rs		: 右边比较字符串
 *			: 返回 ls>rs => >0 ; ls = rs => 0 ; ls<rs => <0
 */
extern int str_icmp(const char* ls, const char* rs);

/*
 * 这个代码是 对 strdup 的再实现, 调用之后需要free 
 * str		: 待复制的源码内容
 *			: 返回 复制后的串内容
 */
extern char* str_dup(const char* str);

//------------------------------------------------简单文本字符串辅助操作----------------------------------

#ifndef _STRUCT_TSTRING
#define _STRUCT_TSTRING
//简单字符串结构,并定义文本字符串类型tstring
struct tstring {
	char* str;		//字符串实际保存的内容
	int len;		//当前字符串大小
	int size;		//字符池大小
};
typedef struct  tstring* tstring;
#endif // !_STRUCT_TSTRING

//文本串栈上创建内容,不想用那些技巧了,就这样吧
#define TSTRING_CREATE(var) \
	struct tstring var = { NULL, 0, 0}
#define TSTRING_DESTROY(var) \
	free(var.str)

/*
 * tstring 的创建函数, 会根据str创建一个 tstring结构的字符串
 * 
 * str : 待创建的字符串
 * 
 * ret : 返回创建好的字符串,如果创建失败返回NULL
 */
extern tstring tstring_create(const char* str);

/*
 * tstring 完全销毁函数
 * tstr : 指向tsting字符串指针量的指针
 */
extern void tstring_destroy(tstring* tstr);

/*
 *  向简单文本字符串tstr中添加 一个字符c
 * tstr : 简单字符串对象
 * c : 待添加的字符
 * ret : 返回状态码 见 schead 中 _RT_EB 码等
 */
extern int tstring_append(tstring tstr, int c);

/*
 *  向简单文本串中添加只读字符串 
 * tstr : 文本串
 * str : 待添加的素材串
 * ret : 返回状态码主要是 _RT_EP _RT_EM
 */
extern int tstring_appends(tstring tstr, const char* str);

/*
 * 复制tstr中内容,得到char* 返回,需要自己free释放
 *假如你要清空tstring 字符串只需要 设置 len = 0.就可以了
 * tstr	: 待分配的字符串
 *		: 返回分配好的字符串首地址
 */
extern char* tstring_mallocstr(tstring tstr);

//------------------------------------------------简单文件辅助操作----------------------------------

/*
 * 简单的文件帮助类,会读取完毕这个文件内容返回,失败返回NULL.
 * 需要事后使用 tstring_destroy(&ret); 销毁这个字符串对象
 * path : 文件路径
 * ret : 返回创建好的字符串内容,返回NULL表示读取失败
 */
extern tstring file_malloc_readend(const char* path);

/*
 * 文件写入,没有好说的,会返回 _RT_EP _RT_EM _RT_OK
 * path : 文件路径
 * str : 待写入的字符串
 * ret : 返回写入的结果
 */
extern int file_writes(const char* path, const char* str);

/*
 * 文件追加内容, 添加str内同
 * path : 文件路径
 * str : 待追加的文件内同
 *     : 返回值,主要是 _RT_EP _RT_EM _RT_OK 这些状态
 */
extern int file_append(const char* path, const char* str);

#endif // !_H_TSTRING