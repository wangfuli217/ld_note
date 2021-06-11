/*互斥量的正确使用流程应该是：线程占用互斥量,然后访问共享资源,最后释放互斥量。(你占用互斥量的时候就应该是临界资源可用)
 * 而不应该是：线程占用互斥量，然后判断资源是否可用，如果不可用，释放互斥量，然后重复上述过程。这种行为称为轮转或轮询,是一种浪费CPU时间的行为。*/

#include <iostream>
#include <queue>
#include <cstdlib>

#include <unistd.h>
#include <pthread.h>

using namespace std;

pthread_mutex_t mutex;
queue<int> product;

void * produce(void *ptr)
{
    for (int i = 0; i < 10; ++i)
    {
        pthread_mutex_lock(&mutex);
        printf("produce : %d\n", i);
        product.push(i);
        pthread_mutex_unlock(&mutex);

        //sleep(1);
    }
}

void * consume(void *ptr)
{
    for (int i = 0; i < 10;)
    {
        pthread_mutex_lock(&mutex);

        if (product.empty())
        {
            pthread_mutex_unlock(&mutex);
            continue;
        }

        ++i;
        cout<<"consume:"<<product.front()<<endl;
        product.pop();
        pthread_mutex_unlock(&mutex);

        //sleep(1);
    }
}

int main()
{
    pthread_mutex_init(&mutex, NULL);

    pthread_t tid1, tid2;

    pthread_create(&tid1, NULL, consume, NULL);
    pthread_create(&tid2, NULL, produce, NULL);

    void *retVal;

    pthread_join(tid1, &retVal);
    pthread_join(tid2, &retVal);

    return 0;
}