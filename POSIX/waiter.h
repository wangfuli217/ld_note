#include <boost/noncopyable.hpp>
#include <pthread.h>
#include <stdlib.h>

// a superfluous check for pedantic people
inline void CHECK_SUCCESS(int ret)
{
  if (ret != 0)
  {
    abort();
  }
}

// Implementaion base for init-destroy mutex_ and cond_
class WaiterBase : boost::noncopyable
{
 protected:
  WaiterBase()
  {
    CHECK_SUCCESS(pthread_mutex_init(&mutex_, NULL));
    CHECK_SUCCESS(pthread_cond_init(&cond_, NULL));
  }

  ~WaiterBase()
  {
    CHECK_SUCCESS(pthread_mutex_destroy(&mutex_));
    CHECK_SUCCESS(pthread_cond_destroy(&cond_));
  }

  pthread_mutex_t mutex_;
  pthread_cond_t cond_;
};

// Version 1: orininal from the book, NOT MY BOOK
// Incorrect, could lose signal
class Waiter1 : private WaiterBase
{
 public:
  void wait()
  {
    CHECK_SUCCESS(pthread_mutex_lock(&mutex_));
    CHECK_SUCCESS(pthread_cond_wait(&cond_, &mutex_));
    CHECK_SUCCESS(pthread_mutex_unlock(&mutex_));
  }

  void signal()
  {
    CHECK_SUCCESS(pthread_cond_signal(&cond_));
  }
};

// Version 2: signal in lock
// Incorrect, could lose signal
class Waiter2 : private WaiterBase
{
 public:
  void wait()
  {
    CHECK_SUCCESS(pthread_mutex_lock(&mutex_));
    CHECK_SUCCESS(pthread_cond_wait(&cond_, &mutex_));
    CHECK_SUCCESS(pthread_mutex_unlock(&mutex_));
  }

  void signal()
  {
    CHECK_SUCCESS(pthread_mutex_lock(&mutex_));
    CHECK_SUCCESS(pthread_cond_signal(&cond_));
    CHECK_SUCCESS(pthread_mutex_unlock(&mutex_));
  }
};

// Version 3: add a boolean member
// Incorrect, spurious wakeup
class Waiter3 : private WaiterBase
{
 public:
  void wait()
  {
    CHECK_SUCCESS(pthread_mutex_lock(&mutex_));
    if (!signaled_)
    {
      CHECK_SUCCESS(pthread_cond_wait(&cond_, &mutex_));
    }
    CHECK_SUCCESS(pthread_mutex_unlock(&mutex_));
  }

  void signal()
  {
    CHECK_SUCCESS(pthread_mutex_lock(&mutex_));
    signaled_ = true;
    CHECK_SUCCESS(pthread_cond_signal(&cond_));
    CHECK_SUCCESS(pthread_mutex_unlock(&mutex_));
  }

 private:
  bool signaled_ = false;
};

// Version 4: wait in while-loop
// Correct, signal before unlock
class Waiter4 : private WaiterBase
{
 public:
  void wait()
  {
    CHECK_SUCCESS(pthread_mutex_lock(&mutex_));
    while (!signaled_)
    {
      CHECK_SUCCESS(pthread_cond_wait(&cond_, &mutex_));
    }
    CHECK_SUCCESS(pthread_mutex_unlock(&mutex_));
  }

  void signal()
  {
    CHECK_SUCCESS(pthread_mutex_lock(&mutex_));
    signaled_ = true;
    CHECK_SUCCESS(pthread_cond_signal(&cond_));
    CHECK_SUCCESS(pthread_mutex_unlock(&mutex_));
  }

 private:
  bool signaled_ = false;
};

// Version 5: wait in while-loop
// Correct, signal after unlock
class Waiter5 : private WaiterBase
{
 public:
  void wait()
  {
    CHECK_SUCCESS(pthread_mutex_lock(&mutex_));
    while (!signaled_)
    {
      CHECK_SUCCESS(pthread_cond_wait(&cond_, &mutex_));
    }
    CHECK_SUCCESS(pthread_mutex_unlock(&mutex_));
  }

  void signal()
  {
    CHECK_SUCCESS(pthread_mutex_lock(&mutex_));
    signaled_ = true;
    CHECK_SUCCESS(pthread_mutex_unlock(&mutex_));

    CHECK_SUCCESS(pthread_cond_signal(&cond_));
  }

 private:
  bool signaled_ = false;
};

// Note: version 4 is as efficient as version 5 because of "wait morphing"

// Version 6: signal before set boolean flag
// Correct or not?
class Waiter6 : private WaiterBase
{
 public:
  void wait()
  {
    CHECK_SUCCESS(pthread_mutex_lock(&mutex_));
    while (!signaled_)
    {
      CHECK_SUCCESS(pthread_cond_wait(&cond_, &mutex_));
    }
    CHECK_SUCCESS(pthread_mutex_unlock(&mutex_));
  }

  void signal()
  {
    CHECK_SUCCESS(pthread_mutex_lock(&mutex_));
    CHECK_SUCCESS(pthread_cond_signal(&cond_));
    signaled_ = true;
    CHECK_SUCCESS(pthread_mutex_unlock(&mutex_));
  }

 private:
  bool signaled_ = false;
};

// Version 7: broadcast to wakeup multiple waiting threads
// Probably the best version among above.
class Waiter7 : private WaiterBase
{
 public:
  void wait()
  {
    CHECK_SUCCESS(pthread_mutex_lock(&mutex_));
    while (!signaled_)
    {
      CHECK_SUCCESS(pthread_cond_wait(&cond_, &mutex_));
    }
    CHECK_SUCCESS(pthread_mutex_unlock(&mutex_));
  }

  void broadcast()
  {
    CHECK_SUCCESS(pthread_mutex_lock(&mutex_));
    signaled_ = true;
    CHECK_SUCCESS(pthread_cond_broadcast(&cond_));
    CHECK_SUCCESS(pthread_mutex_unlock(&mutex_));
  }

 private:
  bool signaled_ = false;
};

// Version 8: modify signaled_ without lock
// Incorrect, data-race and could lose signal
class Waiter8 : private WaiterBase
{
 public:
  void wait()
  {
    CHECK_SUCCESS(pthread_mutex_lock(&mutex_));
    while (!signaled_)
    {
      CHECK_SUCCESS(pthread_cond_wait(&cond_, &mutex_));
    }
    CHECK_SUCCESS(pthread_mutex_unlock(&mutex_));
  }

  void signal()
  {
    signaled_ = true;
    CHECK_SUCCESS(pthread_cond_signal(&cond_));
  }

 private:
  bool signaled_ = false;
};