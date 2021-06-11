#include <stdio.h>
#include <uv.h>
/*
	声明barrier
*/
uv_barrier_t blocker;
/*
	声明读写锁
*/
uv_rwlock_t numlock;
int shared_num;

void reader(void *n)
{
    int num = *(int *)n;
    int i;
    for (i = 0; i < 20; i++) {
        uv_rwlock_rdlock(&numlock); // 对numlock加读取锁
        printf("Reader %d: acquired lock\n", num); // - 在这期间，其他的写操作被禁止，读操作允许
        printf("Reader %d: shared num = %d\n", num, shared_num);// -
        uv_rwlock_rdunlock(&numlock); // 解开读取锁
        printf("Reader %d: released lock\n", num);
    }
    i = uv_barrier_wait(&blocker); // 栅栏等待
	printf("%d barrier %d\n", num, i);

}

void writer(void *n)
{
    int num = *(int *)n;
    int i;
    for (i = 0; i < 20; i++) {
        uv_rwlock_wrlock(&numlock); // 加numlock写锁
        printf("Writer %d: acquired lock\n", num); // - 在这期间， 其他所有的读写操作都被禁止
        shared_num++;
        printf("Writer %d: incremented shared num = %d\n", num, shared_num);
        uv_rwlock_wrunlock(&numlock); // 解写锁
        printf("Writer %d: released lock\n", num);
    }
    i = uv_barrier_wait(&blocker);
	printf("%d barrier %d\n", num, i);
}

int main()
{	
	/*
		初始化barrier锁
		要求5个线程(包括主线程)都在uv_barrier_wait等待其它线程,
		直到所有的线程都到达等待点,所有的线程才恢复执行.
	*/
    uv_barrier_init(&blocker, 5);
	
    shared_num = 0;
	/*
		初始化读写锁
	*/
    uv_rwlock_init(&numlock);

    uv_thread_t threads[4];

    int thread_nums[] = {1, 2, 1, 2};
    uv_thread_create(&threads[0], reader, &thread_nums[0]);
    uv_thread_create(&threads[1], reader, &thread_nums[1]);

    uv_thread_create(&threads[2], writer, &thread_nums[2]);
	uv_thread_create(&threads[3], writer, &thread_nums[3]);
	/*
		阻塞
		等待其它线程
		函数返回0代表等待,
		函数返回1代表恢复执行
	*/
    int i = uv_barrier_wait(&blocker);
	printf("main barrier %d\n", i);
	/*
		销毁barrier锁
	*/
    uv_barrier_destroy(&blocker);
	/*
		销毁读写锁
	*/
    uv_rwlock_destroy(&numlock);
    return 0;
}