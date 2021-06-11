#include <tstring.h>
#include <sclog.h>

/*
* 主要采用jshash 返回计算后的hash值
* 不冲突率在 80% 左右还可以, 不要传入NULL
*/
unsigned 
str_hash(const char* str)
{
	unsigned i, h = (unsigned)strlen(str), sp = (h >> 5) + 1;
	unsigned char* ptr = (unsigned char*)str;

	for (i = h; i >= sp; i -= sp)
		h ^= ((h<<5) + (h>>2) + ptr[i-1]);

	return h ? h : 1;
}

/*
 * 这是个不区分大小写的比较函数
 * ls		: 左边比较字符串
 * rs		: 右边比较字符串
 *			: 返回 ls>rs => >0 ; ls = rs => 0 ; ls<rs => <0
 */
int 
str_icmp(const char* ls, const char* rs)
{
	int l, r;
	if(!ls || !rs)
		return (int)(ls - rs);
	
	do {
		if((l=*ls++)>='a' && l<='z')
			l -= 'a' - 'A';
		if((r=*rs++)>='a' && r<='z')
			r -= 'a' - 'A';
	} while(l && l==r);
	
	return l-r;
}

/*
* 这个代码是 对 strdup 的再实现, 调用之后需要free
* str		: 待复制的源码内容
*			: 返回 复制后的串内容
*/
char* 
str_dup(const char* str)
{
	size_t len; 
	char* nstr;
	DEBUG_CODE({
		if (NULL == str) {
			SL_WARNING("check is NULL == str!!");
			return NULL;
		}
	});

	len = sizeof(char) * (strlen(str) + 1);
	if (!(nstr = malloc(len))) {
		SL_FATAL("malloc is error! len = %d.", len);
		return NULL;
	}
	// 返回最后结果
	return memcpy(nstr, str, len);
}

//------------------------------------------------简单文本字符串辅助操作----------------------------------

/*
* tstring 的创建函数, 会根据str创建一个 tstring结构的字符串
*
* str : 待创建的字符串
*
* ret : 返回创建好的字符串,如果创建失败返回NULL
*/
tstring 
tstring_create(const char* str)
{
	tstring tstr = calloc(1, sizeof(struct tstring));
	if (NULL == tstr) {
		SL_NOTICE("calloc is sizeof struct tstring error!");
		return NULL;
	}
	tstring_appends(tstr, str);

	return tstr;
}

/*
* tstring 完全销毁函数
* tstr : 指向tsting字符串指针量的指针
*/
void tstring_destroy(tstring* tstr)
{
	if (tstr && *tstr) { //展现内容
		free((*tstr)->str);
		free(*tstr);
		*tstr = NULL;
	}
}

//文本字符串创建的度量值
#define _INT_TSTRING (32)

//简单分配函数,智力一定会分配内存的, len > size的时候调用这个函数
static int __tstring_realloc(tstring tstr, int len)
{
	int size = tstr->size;
	for (size = size < _INT_TSTRING ? _INT_TSTRING : size; size < len; size <<= 1)
		;
	//分配内存
	char *nstr = realloc(tstr->str, size);
	if (NULL == nstr) {
		SL_NOTICE("realloc(tstr->str:0x%p, size:%d) is error!", tstr->str, size);
		return _RT_EM;
	}
	tstr->str = nstr;
	tstr->size = size;
	return _RT_OK;
}

/*
*  向简单文本字符串tstr中添加 一个字符c
* tstr : 简单字符串对象
* c : 待添加的字符
* ret : 返回状态码 见 schead 中 _RT_EM 码等
*/
int tstring_append(tstring tstr, int c)
{
	//不做安全检查
	int len = tstr->len + 2; // c + '\0' 而len只指向 字符串strlen长度

	//需要进行内存分配,唯一损失
	if ((len > tstr->size) && (_RT_EM == __tstring_realloc(tstr, len)))
			return _RT_EM;

	tstr->len = --len;
	tstr->str[len - 1] = c;
	tstr->str[len] = '\0';

	return _RT_OK;
}

/*
*  向简单文本串中添加只读字符串
* tstr : 文本串
* str : 待添加的素材串
* ret : 返回状态码主要是 _RT_EP _RT_EM
*/
int tstring_appends(tstring tstr, const char* str)
{
	int len;
	if (!tstr || !str || !*str) {
		SL_NOTICE("check param '!tstr || !str || !*str'");
		return _RT_EP;
	}

	len = tstr->len + (int)strlen(str) + 1;
	if ((len > tstr->size) && (_RT_EM == __tstring_realloc(tstr, len)))
		return _RT_EM;

	//这里复制内容
	strcpy(tstr->str + tstr->len, str);
	tstr->len = len - 1;

	return _RT_OK;
}

//------------------------------------------------简单文件辅助操作----------------------------------

/*
* 简单的文件帮助类,会读取完毕这个文件内容返回,失败返回NULL.
* 需要事后使用 tstring_destroy(&ret); 销毁这个字符串对象
* path : 文件路径
* ret : 返回创建好的字符串内容,返回NULL表示读取失败
*/
tstring file_malloc_readend(const char* path)
{
	int c;
	tstring tstr;
	FILE* txt = fopen(path, "r");
	if (NULL == txt) {
		SL_NOTICE("fopen r path = '%s' error!", path);
		return NULL;
	}

	//这里创建文件对象,创建失败直接返回
	if ((tstr = tstring_create(NULL)) == NULL) {
		fclose(txt);
		return NULL;
	}

	//这里读取文本内容
	while ((c = fgetc(txt))!=EOF)
		if (_RT_OK != tstring_append(tstr, c)){ //出错了就直接销毁已经存在的内容
			tstring_destroy(&tstr);
			break;
		}

	fclose(txt);//很重要创建了就要释放,否则会出现隐藏的句柄bug
	return tstr;
}

/*
* 文件写入,没有好说的,会返回 _RT_EP _RT_EM _RT_OK
* path : 文件路径
* str : 待写入的字符串
* ret : 返回写入的结果
*/
int file_writes(const char* path, const char* str)
{
	FILE* txt;
	//检查参数问题
	if (!path || !str) {
		SL_NOTICE("check is '!path || !str'");
		return _RT_EP;
	}

	if ((txt = fopen(path, "w")) == NULL) {
		SL_NOTICE("fopen w path = '%s' error!", path);
		return _RT_EF;
	}

	//这里写入信息
	fputs(str, txt);

	fclose(txt);
	return _RT_OK;
}

/*
* 文件追加内容, 添加str内同
* path : 文件路径
* str : 待追加的文件内同
*     : 返回值,主要是 _RT_EP _RT_EM _RT_OK 这些状态
*/
int 
file_append(const char* path, const char* str)
{
	FILE* txt;
	//检查参数问题
	if (!path || !str) {
		SL_NOTICE("check is '!path || !str'");
		return _RT_EP;
	}
	if ((txt = fopen(path, "a")) == NULL) {
		SL_NOTICE("fopen a path = '%s' error!", path);
		return _RT_EF;
	}
	//这里写入信息
	fputs(str, txt);

	fclose(txt);
	return _RT_OK;
}

/*
* 复制tstr中内容,得到char* 返回,需要自己free释放
* tstr	: 待分配的字符串
*		: 返回分配好的字符串首地址
*/
char* 
tstring_mallocstr(tstring tstr)
{
	char* str;
	if (!tstr || tstr->len <= 0) {
		SL_NOTICE("params is check '!tstr || tstr->len <= 0' error!");
		return NULL;
	}
	if ((str = malloc(tstr->len + 1)) == NULL){
		SL_NOTICE("malloc %d+1 run is error!",tstr->len);
		return NULL;
	}

	
	//下面就可以复制了,采用最快的一种方式
	return memcpy(str, tstr->str, tstr->len + 1);
}
