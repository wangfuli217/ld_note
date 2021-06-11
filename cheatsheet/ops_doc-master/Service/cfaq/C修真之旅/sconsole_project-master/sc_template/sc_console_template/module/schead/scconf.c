#include <scconf.h>
#include <scatom.h>
#include <tree.h>
#include <tstring.h>
#include <sclog.h>

//简单二叉树结构
struct dict {
	_TREE_HEAD;
	char* key;
	char* value;
};

// 函数创建函数, kv 是 [ abc\012345 ]这样的结构
static void* __dict_new(tstring tstr)
{
	char* ptr; //临时用的变量
	struct dict* nd = malloc(sizeof(struct dict) + sizeof(char)*(tstr->len+1));
	if (NULL == nd) {
		SL_NOTICE("malloc struct dict is error!");
		exit(EXIT_FAILURE);
	}

	nd->__tn.lc = NULL;
	nd->__tn.rc = NULL;
	// 多读书, 剩下的就是伤感, 1% ,不是我,
	nd->key = ptr = (char*)nd + sizeof(struct dict);
	memcpy(ptr, tstr->str, tstr->len + 1);
	while (*ptr++)
		;
	nd->value = ptr;

	return nd;
}

// 开始添加
static inline int __dict_acmp(tstring tstr, struct dict* rnode)
{
	return strcmp(tstr->str, rnode->key);
}
//查找和删除
static inline int __dict_gdcmp(const char* lstr, struct dict* rnode)
{
	return strcmp(lstr, rnode->key);
}

//删除方法
static inline void __dict_del(void* arg)
{
	free(arg);
}

//前戏太长,还没有结束, 人生前戏太长了,最后 ...
static tree_t __tds; //保存字典 默认值为NULL
//默认的 __tds 销毁函数
static inline void __tds_destroy(void)
{
	tree_destroy(&__tds);
}

static int __lock; //加锁用的,默认值为 0 

static void __analysis_start(FILE* txt, tree_t* proot)
{
	char c, n;
	TSTRING_CREATE(tstr);

	//这里处理读取问题
	while ((c = fgetc(txt)) != EOF) {
		//1.0 先跳过空白字符
		while (c != EOF && isspace(c))
			c = fgetc(txt);
		//2.0 如果遇到第一个字符不是 '$'
		if (c != '$') { //将这一行读取完毕
			while (c != EOF && c != '\n')
				c = fgetc(txt);
			continue;
		}
		//2.1 第一个字符是 $ 合法字符, 开头不能是空格,否则也读取完毕
		if ((c = fgetc(txt)) != EOF && isspace(c)) {
			while (c != EOF && c != '\n')
				c = fgetc(txt);
			continue;
		}
		//开始记录了
		tstr.len = 0;

		//3.0 找到第一个等号 
		while (c != EOF && c != '=') {
			if(!isspace(c))
				tstring_append(&tstr, c);
			c = fgetc(txt);
		}
		if (c != '=') //无效的解析直接结束
			break;

		c = '\0';
		//4.0 找到 第一个 "
		while (c != EOF && c != '\"') {
			if (!isspace(c))
				tstring_append(&tstr, c);
			c = fgetc(txt);
		}
		if (c != '\"') //无效的解析直接结束
			break;

		//4.1 寻找第二个等号
		for (n = c; (c = fgetc(txt)) != EOF; n = c) {
			if (c == '\"' && n != '\\')
				break;
			tstring_append(&tstr, c);
		}
		if (c != '\"') //无效的解析直接结束
			break;

		//这里就是合法字符了,开始检测 了, 
		tree_add(proot, &tstr);

		//最后读取到行末尾
		while (c != EOF && c != '\n')
			c = fgetc(txt);
		if (c != '\n')
			break;
	}

	TSTRING_DESTROY(tstr);
}

/*
* 启动这个配置读取功能,或者重启也行
*/
void 
sc_start(void)
{
	FILE* txt = fopen(_STR_SCCONF_PATH, "r");
	if (NULL == txt) {
		SL_NOTICE("fopen " _STR_SCCONF_PATH " r is error!");
		return;
	}

	ATOM_LOCK(__lock);
	//先释放 这个 __tds, 这个__tds内存同程序周期
	__tds_destroy();
	//这个底层库,内存不足是直接退出的
	__tds = tree_create(__dict_new, __dict_acmp, __dict_gdcmp, __dict_del);

	//下面是解析读取内容了
	__analysis_start(txt, &__tds);

	ATOM_UNLOCK(__lock);

	fclose(txt);
}

/*
* 获取配置相应键的值,通过key
* key		: 配置中名字
*			: 返回对应的键值,如果没有返回NULL,并打印日志
*/
inline const char* 
sc_get(const char* key)
{
	struct dict* kv;
	if ((!key) || (!*key) || !(kv = tree_get(__tds, key, NULL)))
		return NULL;

	return kv->value;
}