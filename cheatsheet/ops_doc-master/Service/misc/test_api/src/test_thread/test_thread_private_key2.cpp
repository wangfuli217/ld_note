// this is the test code for pthread_key
#include <stdio.h>
#include <pthread.h>
#include <unistd.h>
pthread_key_t key;  // ˽�����ݣ�ȫ�ֱ���

void echomsg(void *t)
{
    printf("[destructor] thread_id = %lu, param = %p\n", pthread_self(), t);
}

void *child1(void *arg)
{
    int i = 10;

    pthread_t tid = pthread_self(); //�̺߳�
    printf("\nset key value %d in thread %lu\n", i, tid);

    pthread_setspecific(key, &i); // ����˽������

    printf("thread one sleep 2 until thread two finish\n\n");
    sleep(2);
    printf("\nthread %lu returns %d, add is %p\n",
        tid, *((int *)pthread_getspecific(key)), pthread_getspecific(key) );
}

void *child2(void *arg)
{
    int temp = 20;

    pthread_t tid = pthread_self();  //�̺߳�
    printf("\nset key value %d in thread %lu\n", temp, tid);

    pthread_setspecific(key, &temp); //����˽������

    sleep(1);
    printf("thread %lu returns %d, add is %p\n",
        tid, *((int *)pthread_getspecific(key)), pthread_getspecific(key));
}

int main(void)
{
    pthread_t tid1,tid2;
    pthread_key_create(&key, echomsg); // ����

    pthread_create(&tid1, NULL, child1, NULL);
    pthread_create(&tid2, NULL, child2, NULL);
    pthread_join(tid1, NULL);
    pthread_join(tid2, NULL);

    pthread_key_delete(key); // ע��

    return 0;
}
