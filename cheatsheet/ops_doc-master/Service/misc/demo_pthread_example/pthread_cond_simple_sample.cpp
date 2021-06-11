#include <iostream>
#include <queue>
#include <cstdlib>

#include <unistd.h>
#include <pthread.h>

using namespace std;

//把共享数据和它们的同步变量集合到一个结构中，这往往是一个较好的编程技巧。
struct{
    pthread_mutex_t mutex;
    pthread_cond_t cond;
    queue<int> product;
}sharedData = {PTHREAD_MUTEX_INITIALIZER, PTHREAD_COND_INITIALIZER};

void * produce(void *ptr)
{
    for (int i = 0; i < 10; ++i)
    {
        printf("producei[%d]\n", i);
        pthread_mutex_lock(&sharedData.mutex);

        sharedData.product.push(i);

        pthread_mutex_unlock(&sharedData.mutex);

        if (sharedData.product.size() == 1)
            pthread_cond_signal(&sharedData.cond);

        sleep(10);
    }
}

void * consume(void *ptr)
{
    for (int i = 0; i < 10;)
    {
        pthread_mutex_lock(&sharedData.mutex);

        while(sharedData.product.empty()) {

            printf("pthread_cond_wait before i[%d]\n", i);
            /*在调用pthread_cond_wait()函数之前,mutex的状态必须的 locked
             *
             * 暂时的unlock sharedData.mutex, 且阻塞等待sharedData.cond 条件成立(有其他线程调用pthread_cond_signal()函数)
             * 成功返回后 mutex 状态变为原来的 locked 状态
             * */
            pthread_cond_wait(&sharedData.cond, &sharedData.mutex);
            printf("pthread_cond_wait after i[%d]\n", i);
        }

        ++i;
        cout<<"consume:"<<sharedData.product.front()<<endl;
        sharedData.product.pop();

        pthread_mutex_unlock(&sharedData.mutex);

        //sleep(1);
    }
}

int main()
{
    pthread_t tid1, tid2;

    pthread_create(&tid1, NULL, consume, NULL);
    pthread_create(&tid2, NULL, produce, NULL);

    void *retVal;

    pthread_join(tid1, &retVal);
    pthread_join(tid2, &retVal);

    return 0;
}