C语言程序测试框架； 好的很！ 

plan(8);        # 计划开始 ->指定计划个数
done_testing(); # 测试开始 ->进行单元测试

#define ok(...)          ok_at_loc(__FILE__, __LINE__, __VA_ARGS__, NULL)  # ok(1, "quux");   # 值为非零表示通过
#define pass(...)        ok(1, "" __VA_ARGS__)                                                # 直接通过
#define fail(...)        ok(0, "" __VA_ARGS__)                                                # 直接报错

# 字符串非模式比较
#define is(...)          is_at_loc(__FILE__, __LINE__, __VA_ARGS__, NULL)  # is("this", "that", "this is that"); 
#define isnt(...)        isnt_at_loc(__FILE__, __LINE__, __VA_ARGS__, NULL)# isnt("this", "that", "this isnt that");

## 进程会非法退出
#define dies_ok(...)     dies_ok_common(1, __VA_ARGS__)                    # dies_ok({int x = 0; x = x/x;}, "can't divide by zero");
#define lives_ok(...)    dies_ok_common(0, __VA_ARGS__)                    # lives_ok({int x = 3; x = x/7;}, "this is a perfectly fine statement");

int diag (const char *fmt, ...)                                            # diag("diag no new line");

#define cmp_mem(...)     cmp_mem_at_loc(__FILE__, __LINE__, __VA_ARGS__, NULL) # 内存地址相等
cmp_mem(half, half_2, 4, "Same array different address");                      # 内存地址有为NULL
cmp_mem(all_0, all_0, 4, "Array must be equal to itself");                     # 内存地址包含值相等
cmp_mem(all_0, all_255, 4, "Arrays with different contents");
cmp_mem(all_0, half, 4, "Arrays differ, but start the same");
cmp_mem(all_0, all_255, 0, "Comparing 0 bytes of different arrays");
cmp_mem(NULL, all_0, 4, "got == NULL");
cmp_mem(all_0, NULL, 4, "expected == NULL");
cmp_mem(NULL, NULL, 4, "got == expected == NULL");

#define cmp_ok(...)      cmp_ok_at_loc(__FILE__, __LINE__, __VA_ARGS__, NULL)
cmp_ok(420, ">", 666);                                                          # 
cmp_ok(23, "==", 55, "the number 23 is definitely 55");                         # 有  || &&   与或
cmp_ok(23, "==", 55);                                                           # 有  |  ^  &  位运算
cmp_ok(23, "!=", 55);                                                           # 有  == != < > <= >= << >> 整数比较
cmp_ok(23, "frob", 55);                                                         # 有  + - * / % 四则运算
cmp_ok(23, "<=", 55);                                                           #
cmp_ok(55, "+", -55);                                                           #
cmp_ok(23, "%", 5);                                                             #
cmp_ok(55, "%", 5);                                                             #

#define like(...)        like_at_loc(1, __FILE__, __LINE__, __VA_ARGS__, NULL)    # 模式匹配和模式不匹配
like("strange", "range", "strange ~~ /range/");                                   # 
like("stranger", "^s.(r).*$", "matches the regex");                               # 
unlike("strange", "anger", "strange !~~ /anger/");                                # 
#define unlike(...)      like_at_loc(0, __FILE__, __LINE__, __VA_ARGS__, NULL)    # 


#define skip(test, ...)  do {if (test) {tap_skip(__VA_ARGS__, NULL); break;}   # 忽略
#define end_skip         } while (0)                                           # 

#define todo(...)        tap_todo(0, "" __VA_ARGS__, NULL)                     # 将来进行
#define end_todo         tap_end_todo()                                        # 