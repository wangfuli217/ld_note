#include "stdafx.h"
#include "Item18.h"

struct DayType
{
  explicit DayType(int d)  :
  val(d)
  {}

  int val;
};

class MonthType
{
public:
  static MonthType Jan() { return MonthType(1); }
  static MonthType Dec() { return MonthType(12); }

private:
  explicit MonthType(int m) :
    val(m)
  {}

  int val;
};

struct YearType
{
  explicit YearType(int y) :
    val(y)
  {}

  int val;
};

class DateClass {

public:

  // 不做任何限制的构造函数如下，使用者可能传入的月份太大，负数的日期，等等
  //DateClass(int month, int day, int year) {}

  // 用结构包装年、月、日，减少错误使用的机会，尽量在编译期即可发现
  DateClass(YearType y, MonthType m, DayType d) {}

};


void Item18::ItemEntry()
{
  //// Item 18: Make interfaces easy to use correctly and hard to use incorrectly
  // 比如处理年月日的接口，如果想要让接口的使用者尽量减少错误使用的机会，可以定义结构封装

  //DateClass(1, 2, 3); // 由于explicit构造函数，所以不能用int隐式转换
  //DateClass(MonthType(1), DayType(1), YearType(1970)); // 参数类型顺序错误也能在编译期发现
  DateClass(YearType(1970), MonthType::Jan(), DayType(1)); // 增强MonthType，避免出现非法月份

}
