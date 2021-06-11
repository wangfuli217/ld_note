#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

//简单测试 pthread线程库
static void* __run(void* arg)
{
	puts("你好!");

	return NULL;
}

int main_pthread_test(int argc, char* argv[])
{
	pthread_t tid;

	//开始跑起来
	pthread_create(&tid, NULL, __run, NULL);

	//等待结束
	pthread_join(tid, NULL);

	system("pause");
	return 0;
}

// -------------------------下面测试 sclog.h 接口功能
#include <schead.h>
#include <sclog.h>

static void* test_one(void* arg)
{
	sl_pecific_init("test_one", "8.8.8.8");
	SL_TRACE("test_one log test start!");
	for (int i = 0; i < 100; ++i) {
		SL_FATAL("pthread test one fatal is at %d, It's %s.",i, "OK");
		SL_WARNING("pthread test one warning is at %d, It's %s.", i, "OK");
		SL_INFO("pthread test one info is at %d, It's %s.", i, "OK");
		SL_DEBUG("pthread test one debug is at %d, It's %s.", i, "OK");
		SLEEPMS(1); //等待1s
	}
	SL_TRACE("test_one log test end!");
	return NULL;
}

// 线程二测试函数
static void* test_two(void* arg)
{
	//线程分离,自回收
	pthread_detach(pthread_self());
	sl_pecific_init("test_two", "8.8.8.8");
	SL_TRACE("test_two log test start!");
	for (int i = 0; i < 3; ++i) {
		SL_FATAL("pthread test two fatal is at %d, It's %s.", i, "OK");
		SL_WARNING("pthread test two warning is at %d, It's %s.", i, "OK");
		SL_INFO("pthread test two info is at %d, It's %s.", i, "OK");
		SL_DEBUG("pthread test two debug is at %d, It's %s.", i, "OK");
		SLEEPMS(2); //等待1s
	}
	SL_TRACE("test_two SL_TRACE test end!");
	return NULL;
}

int main_log(int argc, char* argv[])
{
	pthread_t tone, ttwo;

	//注册等待函数
	INIT_PAUSE();

	sl_start();
	SL_NOTICE("main log test start!");

	pthread_create(&tone, NULL, test_one, NULL);
	pthread_create(&ttwo, NULL, test_two, NULL);

	pthread_join(tone, NULL);

	SL_NOTICE("main log test end!");

	return 0;
}
