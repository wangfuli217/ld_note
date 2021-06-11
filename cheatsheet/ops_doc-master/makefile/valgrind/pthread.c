#include <stdlib.h> 
#include <pthread.h> 
#include <unistd.h> 

pthread_mutex_t lock_A = PTHREAD_MUTEX_INITIALIZER; 
pthread_mutex_t lock_B = PTHREAD_MUTEX_INITIALIZER; 

void *run1(void *args) 
{
  pthread_mutex_lock(&lock_A);
  sleep(1);
  pthread_mutex_lock(&lock_B);
  pthread_mutex_unlock(&lock_B);
  pthread_mutex_unlock(&lock_A); 
}

void *run2(void *args)
{
  pthread_mutex_lock(&lock_B);
  sleep(1);
  pthread_mutex_lock(&lock_A);
  pthread_mutex_unlock(&lock_A);
  pthread_mutex_unlock(&lock_B);                                                                                                             
} 

void main()
{
  pthread_t tid[2];

  if (pthread_create(&tid[0], NULL, &run1, NULL) != 0)
  {
    exit(1);
  }
  if (pthread_create(&tid[1], NULL, &run2, NULL) != 0)
  {
    exit(1);
  }

  pthread_join(tid[0], NULL);
  pthread_join(tid[1], NULL);

  pthread_mutex_destroy(&lock_A);
  pthread_mutex_destroy(&lock_B);
}

// gcc pthread.c -o pthread -g -lpthread
// valgrind --tool=helgrind ./pthread