#include <stdio.h>
#include <time.h>

int
main ()
{
  // time_t 是 long 的typedef形式（有符号）
  time_t biggest = 0x7FFFFFFF;
  // ctime
  // 把时间转化为当地时间（含时区）
  printf ("biggest = %s \n", ctime (&biggest)); // gmtime
  // 获取对应的UTC时间，但返回的不是一个可打印的字符串，故使用asctime
  printf ("biggest = %s \n", asctime(gmtime (&biggest)));
  return 0;
}
