#ifndef _H_SCCSV
#define _H_SCCSV

/*
 *  这里是一个解析 csv 文件的 简单解析器.
 * 它能够帮助我们切分文件内容,保存在数组中.
 */
struct sccsv {		//内存只能在堆上
	int rlen;		//数据行数,索引[0, rlen)
	int clen;		//数据列数,索引[0, clen)
	const char* data[];	//保存数据一维数组,希望他是二维的 rlen*clen
};

typedef struct sccsv* sccsv_t;

/*
 * 从文件中构建csv对象, 最后需要调用 sccsv_die 释放
 * path		: csv文件内容
 *			: 返回构建好的 sccsv_t 对象
 */
extern sccsv_t sccsv_new(const char* path);

/*
 * 释放由sccsv_new构建的对象
 * pcsv		: 由sccsv_new 返回对象
 */
extern void sccsv_die(sccsv_t* pcsv);

/*
 * 获取某个位置的对象内容,这个函数 推荐声明为内联的, window上不支持
 * csv		: sccsv_t 对象, new返回的
 * ri		: 查找的行索引 [0, csv->rlen)
 * ci		: 查找的列索引 [0, csv->clen)
 *			: 返回这一项中内容,后面可以用 atoi, atof, str_dup 等处理了...
 */
extern inline const char* sccsv_get(sccsv_t csv, int ri, int ci);

#endif // !_H_SCCSV