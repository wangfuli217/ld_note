#include <schead.h>
#include <sclog.h>
#include <cjson.h>

// 测试 cjson 函数
int main(int argc, char* argv[])
{
	//注册等待函数
	INIT_PAUSE();

	//启动日志记录功能
	sl_start();

	// 第二个 测试 json 串的解析
	puts("测试 cjson 是否可用");
	char text1[] = "{\n\"name\": \"Jack (\\\"Bee\\\") Nimble\", \n\"format\": {\"type\":       \"rect\", \n\"width\":      1920, \n\"height\":     1080, \n\"interlace\":  false,\"frame rate\": 24\n}\n}";

	cjson_t js = cjson_parse(text1);

	cjson_t name = cjson_getobject(js, "name");
	printf("name => %s\n", name->vs);

	cjson_t format = cjson_getobject(js, "format");
	printf("len(format) => %d\n", cjson_getlen(format));

	cjson_t interlace = cjson_getobject(format, "interlace");
	printf("interlace => %d\n", cjson_getint(interlace));

	cjson_delete(&js);

	//进行第三组测试

	puts(" 测试 数组的读取");
	char text2[] = "[\"Sunday\", \"Monday\", \"Tuesday\", \"Wednesday\", \"Thursday\", \"Friday\", \"Saturday\"]";
	js = cjson_parse(text2);
	int len = cjson_getlen(js);
	int i;
	for (i = 0; i < len; ++i) {
		cjson_t item = cjson_getarray(js,i);
		printf("%d => %s.\n", i, item->vs);
	}
	cjson_delete(&js);


	puts("第三组测试");
	char text3[] = "[\n    [0, -1, 0],\n    [1, 0, 0],\n    [0, 0, 1]\n	]\n";
	js = cjson_parse(text3);
	len = cjson_getlen(js);
	for (i = 0; i < len; ++i) {
		cjson_t item = cjson_getarray(js, i);
		printf("%d => %d.\n", i, cjson_getlen(item));
	}

	cjson_delete(&js);

	return 0;
}
