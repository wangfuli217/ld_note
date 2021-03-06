# $(join LIST1,LIST2)
# 函数名称:单词连接函数——join。
# 函数功能:将字串“LIST1”和字串“LIST2”各单词进行对应连接。就是将“LIST2”中的第一个单词追加“LIST1”第一个单词字后合并为一个单词;将“LIST2”中的第二个单词追加到“LIST1”的第一个单词之后并合并为一个单词,......依次列推。
# 返回值:单空格分割的合并后的字(文件名)序列。
# 函数说明:如果“LIST1”和“LIST2”中的字数目不一致时,两者中多余部分将被作为返回序列的一部分。
# 示例 1:
# $(join a b , .c .o)
# 返回值为:“a.c b.o”。
# 示例 2:
# $(join a b c , .c .o)
# 返回值为:“a.c b.o c”。

all:
	@echo $(join a b , .c .o)
	@echo $(join a b c , .c .o)