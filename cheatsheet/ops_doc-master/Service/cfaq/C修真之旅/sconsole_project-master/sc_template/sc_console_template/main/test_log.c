#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

//�򵥲��� pthread�߳̿�
static void* __run(void* arg)
{
	puts("���!");

	return NULL;
}

int main_pthread_test(int argc, char* argv[])
{
	pthread_t tid;

	//��ʼ������
	pthread_create(&tid, NULL, __run, NULL);

	//�ȴ�����
	pthread_join(tid, NULL);

	system("pause");
	return 0;
}

// -------------------------������� sclog.h �ӿڹ���
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
		SLEEPMS(1); //�ȴ�1s
	}
	SL_TRACE("test_one log test end!");
	return NULL;
}

// �̶߳����Ժ���
static void* test_two(void* arg)
{
	//�̷߳���,�Ի���
	pthread_detach(pthread_self());
	sl_pecific_init("test_two", "8.8.8.8");
	SL_TRACE("test_two log test start!");
	for (int i = 0; i < 3; ++i) {
		SL_FATAL("pthread test two fatal is at %d, It's %s.", i, "OK");
		SL_WARNING("pthread test two warning is at %d, It's %s.", i, "OK");
		SL_INFO("pthread test two info is at %d, It's %s.", i, "OK");
		SL_DEBUG("pthread test two debug is at %d, It's %s.", i, "OK");
		SLEEPMS(2); //�ȴ�1s
	}
	SL_TRACE("test_two SL_TRACE test end!");
	return NULL;
}

int main_log(int argc, char* argv[])
{
	pthread_t tone, ttwo;

	//ע��ȴ�����
	INIT_PAUSE();

	sl_start();
	SL_NOTICE("main log test start!");

	pthread_create(&tone, NULL, test_one, NULL);
	pthread_create(&ttwo, NULL, test_two, NULL);

	pthread_join(tone, NULL);

	SL_NOTICE("main log test end!");

	return 0;
}
