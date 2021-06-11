C = gcc
DEBUG = -g -Wall -D_DEBUG
#指定pthread线程库
LIB = -lpthread -lm
#指定一些目录
DIR = -I./module/schead/include -I./module/struct/include
#具体运行函数
RUN = $(CC) $(DEBUG) -o $@ $^ $(LIB) $(DIR)
RUNO = $(CC) $(DEBUG) -c -o $@ $^ $(DIR)

# 主要生成的产品
all:test_cjson_write.out test_csjon.out test_csv.out test_json_read.out test_log.out\
 test_scconf.out test_tstring.out

#挨个生产的产品
test_cjson_write.out:test_cjson_write.o schead.o sclog.o tstring.o cjson.o
	$(RUN)
test_csjon.out:test_csjon.o schead.o sclog.o tstring.o cjson.o
	$(RUN)
test_csv.out:test_csv.o schead.o sclog.o sccsv.o tstring.o
	$(RUN)
test_json_read.out:test_json_read.o schead.o sclog.o sccsv.o tstring.o cjson.o
	$(RUN)
test_log.out:test_log.o schead.o sclog.o
	$(RUN)
test_scconf.out:test_scconf.o schead.o scconf.o tree.o tstring.o sclog.o
	$(RUN)
test_tstring.out:test_tstring.o tstring.o sclog.o schead.o
	$(RUN)

#产品主要的待链接文件
test_cjson_write.o:./main/test_cjson_write.c
	$(RUNO)
test_csjon.o:./main/test_csjon.c
	$(RUNO)
test_csv.o:./main/test_csv.c
	$(RUNO)
test_json_read.o:./main/test_json_read.c
	$(RUNO)
test_log.o:./main/test_log.c 
	$(RUNO) -std=c99
test_scconf.o:./main/test_scconf.c
	$(RUNO)
test_tstring.o:./main/test_tstring.c
	$(RUNO)

#工具集机械码,待别人链接
schead.o:./module/schead/schead.c
	$(RUNO)
sclog.o:./module/schead/sclog.c
	$(RUNO)
sccsv.o:./module/schead/sccsv.c
	$(RUNO)
tstring.o:./module/struct/tstring.c
	$(RUNO)
cjson.o:./module/schead/cjson.c
	$(RUNO)
scconf.o:./module/schead/scconf.c
	$(RUNO)
tree.o:./module/struct/tree.c
	$(RUNO)

#删除命令
clean:
	rm -rf *.i *.s *.o *.out __* log ; ls -hl
.PHONY:clean
