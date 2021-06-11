#include "stdafx.h"
#include "ChronoTest.h"
#include <iostream>
#include <string>
#include <chrono>
#include <ctime>
#include <iomanip>

using std::cout;
using std::endl;
using std::chrono::duration;
using std::chrono::seconds;
using std::chrono::microseconds;
using std::chrono::minutes;
using std::chrono::hours;
using std::chrono::duration_cast;
using std::chrono::system_clock;
using std::chrono::steady_clock;

ChronoTest::ChronoTest()
{
}


ChronoTest::~ChronoTest()
{
}

void durationTest(void)
{
  // 从duration模板创建特定类型的类
  using shakes = duration<int, std::ratio<1, 100000000>>;
  using jiffies = duration<int, std::centi>;
  using microfortnights = duration<float, std::ratio<12096, 10000>>;
  using nanocenturies = duration<float, std::ratio<3155, 1000>>;

  cout << endl << "==== Duration Test ====" << endl;

  seconds sec(1);

  cout << "1 second is:" << endl;

  // 无类型转换，无精度损失的整形缩放。
  // 直接把一种duration作为另一种duration的参数构造。
  cout << microseconds(sec).count() << " microseconds." << endl
    << shakes(sec).count() << " shakes." << endl
    << jiffies(sec).count() << " jiffies." << endl;

  // 显式类型转换，有精度损失。
  cout << duration_cast<minutes>(sec).count() << " minutes." << endl;

  // 无类型转换的浮点缩放
  cout << microfortnights(sec).count() << " microfortnights." << endl
    << nanocenturies(sec).count() << " nanocenturies." << endl;

  // Windows的精度到100ns。Linux的精度到ns。
  // 使用如下语句打印默认精度，对比windows和linux位数。
  cout << std::chrono::system_clock::now().time_since_epoch().count() << endl;
}

void clockTimepointTest(void)
{
  /*
   * system_clock：system-wide real time wall clock. 不一定是monotonic。
   *    没有指定系统时钟从哪个纪元开始，但一般都是
   *    00:00:00 UTC Thursday 1 January 1970
   * steady_clock：不是wall clock，而是类似从系统启动开始到现在为止的时间间隔。monotonic。
   * high_resolution_clock：使用最小tick间隔的clock。
   *    可能等同于system_clock，或steady_clock，或某独立的clock
  */

  cout << endl << "==== Clock and Timepoint Test ====" << endl;
  system_clock::time_point now = system_clock::now();
  std::time_t ctimeNow = system_clock::to_time_t(now - hours(24));
  cout << "24 hours ago, the time was: "
    << std::put_time(std::localtime(&ctimeNow), "%F %T") << endl;

  steady_clock::time_point start = steady_clock::now();
  cout << "Hello, Chrono." << endl;
  steady_clock::time_point end = steady_clock::now();
  cout << "Print hello takes: "
    << duration_cast<microseconds>(end - start).count()
    << " us." << endl;
}

void chronoTest(void)
{
  /*
   * 三种主要类型:
   * - Duration：某种时间单位表示的时间段，如42秒用duration表示为42个1秒时间单元的tick
   * - Clock：由起始纪元（epoch）和tick rate组成。如起始于1970年1月1日，tick为秒
   * - Time point：时间点
   */
  durationTest();
  clockTimepointTest();
}
