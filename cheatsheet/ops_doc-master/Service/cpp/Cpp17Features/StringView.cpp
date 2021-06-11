#include "StringView.h"
#include <string>
#include <string_view>
#include <iostream>
#include <ctime>

using std::cout;
using std::endl;
using std::string_view;
using std::string;
using std::time_t;

void StringViewTest(void)
{
  // The class template basic_string_view describes an object that can refer
  // to a constant contiguous sequence of char-like objects with the first 
  // element of the sequence at position zero.
  // A typical implementation holds only two members: a pointer to constant CharT and a size.
  // 是char数据的视图或引用，为了避免拷贝所以不拥有数据。
  // 针对字符串常量可用作性能优化，替代const char和const string。

  // Type               Definition
  // std::string_view     std::basic_string_view<char>
  // std::wstring_view    std::basic_string_view<wchar_t>
  // std::u16string_view  std::basic_string_view<char16_t>
  // std::u32string_view  std::basic_string_view<char32_t>

  // 使用char*和长度来构造
  const char* pCharStr = "This is a const char* string.";
  string_view svPCharStr(pCharStr, 20); // 指定的长度不一定要是字符串的长度
  cout << "string view on const char*: [" << svPCharStr << "]" << endl;
  const string stringStr = "This is a const std::string string.";
  string_view svStringStr(&stringStr[0], 27); // 用string的首地址来构造
  cout << "string view on const string: [" << svStringStr << "]" << endl;

  // 使用sv的字符串字面量来构造
  using namespace std::literals;
  constexpr string_view svNativeLiteral = "Performance test"sv;
  // 普通字符串string
  const string stdString = "Performance test";
  // 测试运行时间来比较性能
  double begin = (double)clock() / CLK_TCK;
  for (int i = 0; i < 1000000; ++i) {
    constexpr auto subStr = svNativeLiteral.substr(3);
  }
  double end = (double)clock() / CLK_TCK;
  cout << "On svNativeLiteral: " << end - begin << endl;
  begin = (double)clock() / CLK_TCK;
  for (int i = 0; i < 1000000; ++i) {
    auto subStr = stdString.substr(3);
  }
  end = (double)clock() / CLK_TCK;
  cout << "On stdString: " << end - begin << endl;

  // 注意string_view不关系被指向的字符串声明周期，不要用临时变量构造string_view
  string_view dangerStrView;
  {
    string localStr = "This is dangerous.";
    dangerStrView = localStr;
    cout << "In local scope:" << dangerStrView << endl;
  }
  cout << "Out of local scope:" << dangerStrView << endl; // 指向的内容失效

  constexpr string constexprStr = "test";
}
