#include "stdafx.h"
#include "MultiThreadTest.h"
#include <stdint.h>
#include <iostream>
#include <thread>
#include <mutex>
#include <future>
#include <chrono>
#include <atomic>

/*
 * ���̱߳����ص�ͷ�ļ���
 * atomic��������atomic��atomic_flag���Լ�C����ԭ�����ͺ�ԭ�Ӳ�������
 * thread��thread�࣬this_thread�����ռ�
 * mutex�������������mutex��lock_guard��unique_lock
 * condition_variable������������أ�condition_variable��condition_variable_any
 * future��Provider��promise��package_task��future��future��shared_future
 */

using std::cout;
using std::endl;
using std::thread;
using std::mutex;
using std::timed_mutex;
using std::lock_guard;
using std::unique_lock;
using std::future;
using std::promise;
using std::packaged_task;
using std::condition_variable;
using std::async;
using std::this_thread::sleep_for;
using std::this_thread::get_id;
using std::this_thread::yield;
using std::chrono::microseconds;
using std::chrono::milliseconds;
using std::chrono::seconds;
using std::atomic_flag;
using std::atomic;

MultiThreadTest::MultiThreadTest()
{
}


MultiThreadTest::~MultiThreadTest()
{
}

void threadParValue(uint32_t runTimes)
{
  for (uint32_t i = 0; i != runTimes; i++)
  {
    cout << "Thread(uint) " << get_id() << " running: " << i << endl;
    sleep_for(milliseconds(10));
  }
}

void threadParRef(uint32_t &runTimes)
{
  for (uint32_t i = 0; i != runTimes; i++)
  {
    cout << "Thread(&uint) " << get_id() << " running: " << i << endl;
    sleep_for(milliseconds(10));
  }
}

void threadTest(void)
{
  // Ĭ�Ϲ��캯�������յ�thread����
  // �������캯����Ϊdeleted
  // ֧���ƶ����캯��
  // ��ʼ�����캯������joinable��������֮ǰ���뱻���߳�join����Ϊdetached
  // ֧���ƶ�����������joinable�Ķ�����ֵ����
  // ������������Ϊdeleted
  //
  // ������Ա������
  // get_id/joinable/join/detach/swap/native_handle/hardware_concurrency[static]

  cout << endl << "====threadTest====" << endl;

  uint32_t runTimes = 2;
  thread threadConsDefault; // �޷�����
  thread threadConsValue(threadParValue, runTimes); // �߳�������������ֵ
  thread threadConsRef(threadParRef, std::ref(runTimes)); // �߳�����������������
  thread threadConsMove(std::move(threadConsRef)); // �ƶ����캯��
  thread threadCopy = thread(threadParValue, runTimes);

  threadConsValue.join();
  threadConsMove.join();
  threadCopy.join();
}

void threadMutex(uint32_t runTimes, mutex &mtx)
{
  for (uint32_t i = 0; i != runTimes; i++)
  {
    mtx.lock();
    cout << "threadMutex " << get_id() << " running: " << i << endl;
    mtx.unlock();
    sleep_for(milliseconds(i));
  }
}

void threadTimeMutex(char waitCh, timed_mutex &tmd_mtx)
{
  // Block waiting for 100ms and print
  while (!tmd_mtx.try_lock_for(milliseconds(100)))
  {
    cout << waitCh;
  }

  // Get lock and print !
  cout << "threadTimeMutex " << get_id() << " done!" << endl;

  // Wait 1000ms before unlock
  sleep_for(milliseconds(10000));

  tmd_mtx.unlock();
}

void threadMutexLockGuard(mutex &mtx)
{
  try
  {
    // Change to #if 0 to be blocked forever after exception
#if 1
    lock_guard<mutex> lockGuard(mtx);
    throw (std::logic_error("ERROR"));
#else
    mtx.lock();
    throw (std::logic_error("ERROR"));
    mtx.unlock();
#endif
  }
  catch (std::logic_error &)
  {
    cout << "threadMutex " << get_id() << " excepted." << endl;
  }
}

void threadMutexUniqueLock(mutex &mtx)
{
  try
  {
    unique_lock<mutex> uniqueLock(mtx);
    //uniqueLock.lock(); // ����ͬʱִ��lock
    throw (std::logic_error("ERROR"));
    uniqueLock.unlock();
  }
  catch (std::logic_error &)
  {
    cout << "threadMutexUniqueLock " << get_id() << " excepted." << endl;
  }
}

void mutexTest(void)
{
  cout << endl << "====mutexTest====" << endl;

  // Mutex
  // std::mutex                 ����mutex
  // std::recursive_mutex       �ݹ�mutex��ͬһ���߳̿��Զ�ζ�ͬһ��mutex���������������ͬ����
  // std::time_mutex            ��ʱmutex����ָ��ʱ�������̣߳���ʱ����false
  // std::recursive_timed_mutex ��ʱ�ݹ�mutex

  // �մ�����mutexδunlocked״̬
  cout << endl << "----MUTEX----" << endl;

  mutex mtx;
  thread threadMutex1(threadMutex, 3, std::ref(mtx));
  thread threadMutex2(threadMutex, 3, std::ref(mtx));
  threadMutex1.join();
  threadMutex2.join();

  cout << endl << "----TIME MUTEX----" << endl;
  timed_mutex tmd_mtx;
  thread threadMutex3(threadTimeMutex, '3', std::ref(tmd_mtx));
  thread threadMutex4(threadTimeMutex, '4', std::ref(tmd_mtx));
  thread threadMutex5(threadTimeMutex, '5', std::ref(tmd_mtx));
  threadMutex3.join();
  threadMutex4.join();
  threadMutex5.join();

  // Lock
  // std::lock_guard    ʵ��mutex�������ڵ�Mutex RAII��ֻ�й��캯��
  // std::unique_lock   ͬ�ϣ��ṩ���õ������ͽ������ƺ������������ڹ���ʱ��lock���ֶ�lock��unlock����ʵ����move
  // �������Ҫunique_lock�ṩ�Ķ��⹦�ܣ���ѡ��lock_guard��
  // RAII: Resource Acquisition Is Initialization
  // ����Ĺ��캯���з�����Դ���������������ͷ���Դ��
  // ��һ�����󴴽���ʱ�򣬹��캯�����Զ��ر����ã�
  // ������������ͷŵ�ʱ����������Ҳ�ᱻ�Զ����á�
  // ��ʹ�쳣��������ԴҲ�������ͷ�

  cout << endl << "----MUTEX LOCK GUARD----" << endl;
  thread threadMutex6(threadMutexLockGuard, std::ref(mtx));
  sleep_for(milliseconds(20));
  thread threadMutex7(threadMutexLockGuard, std::ref(mtx));
  threadMutex6.join();
  threadMutex7.join();

  cout << endl << "----MUTEX UNIQUE LOCK----" << endl;
  thread threadMutex8(threadMutexUniqueLock, std::ref(mtx));
  sleep_for(milliseconds(20));
  thread threadMutex9(threadMutexUniqueLock, std::ref(mtx));
  threadMutex8.join();
  threadMutex9.join();

  // std::once_flag
  // std::adopt_lock_t
  // std::defer_lock_t
  // std::try_to_lock_t

  // std::try_lock    ����ͬʱ�Զ��mutex����
  // std::lock        ͬʱ�Զ��mutex����
  // std::call_once   ���̶߳�ĳ������ֻ����һ��

}

void threadPromise(future<int> & refFuture)
{
  cout << "threadPromise " << get_id() << " wating..." << endl;
  cout << "threadPromise " << get_id() << " get: " << refFuture.get() << endl;
}

void threadPackagedTask(void)
{
  for (int i = 0; i != 5; i++)
  {
    cout << "threadPackagedTask " << get_id() << " working: " << i << endl;
    sleep_for(seconds(1));
  }
}

void asyncMain(int runTimes)
{
  for (int i = 0; i != runTimes; i++)
  {
    cout << "asyncMain " << get_id() << " working: " << i << endl;
    sleep_for(seconds(1));
  }
}

void futureTest(void)
{
  cout << endl << "====futureTest====" << endl;

  // future�������첽������ṩ��provider��������������״̬��future�����
  // �������߳���future������get����״̬���������״̬��־��Ϊready��������
  // provider���ù���״̬��ֵ��get�ͽ������
  // provider�����Ǻ��������ࣺ
  // - async����
  // - promise���get_future����
  // - packaged_task���get_future����
  //
  // shared_future��future���ƣ��ɹ���״̬�Ľ��
  // future_error�̳�logic_error��׼�쳣

  cout << endl << "----PROMISE----" << endl;
  promise<int> promiseInt;
  future<int> futureInt = promiseInt.get_future(); // ��ȡpromise������future
  thread threadFuture1(threadPromise, std::ref(futureInt));
  sleep_for(seconds(5));
  cout << "main worked for 5 seconds." << endl;
  promiseInt.set_value(123);
  threadFuture1.join();

  cout << endl << "----PACKAGED_TASK----" << endl;
  packaged_task<void(void)> pkgTask(threadPackagedTask); //�ɵ��ö��󴫸�packaged_task
  future<void> futureVoid = pkgTask.get_future(); // ��ȡpakcaged_task������future
  cout << "main waiting for packaged_task." << endl;
  thread threadFuture2(std::move(pkgTask)); // ��packaged_task�����߳�
  futureVoid.get();
  threadFuture2.join();

  cout << endl << "----ASYNC----" << endl;
  cout << "main waiting for async." << endl;
  future<void> futureAsync = async(asyncMain, 3);
  while (futureAsync.wait_for(milliseconds(100)) == std::future_status::timeout)
  {
    cout << ".";
  }
  futureAsync.get();
}

void threadWait(condition_variable &cv, mutex &mtx, bool &isReady)
{
  unique_lock<mutex> uniLock(mtx); // ����ʱ�Զ�lock
  cout << "threadWait " << get_id() << " warting." << endl;
  while (!isReady)
  {
    cv.wait(uniLock);
  } // wait���Զ�unlock��wait�����Զ��ٴ�lock
  cout << "threadWait " << get_id() << " done." << endl;
  uniLock.unlock();
}

void threadNotify(condition_variable &cv, mutex &mtx, bool &isReady)
{
  cout << "threadNotify " << get_id() << " notifying." << endl;
  unique_lock<mutex> uniLock(mtx); // ����ʱ�Զ�lock
  isReady = true;
  uniLock.unlock();
  cv.notify_one();
}

void conditionVariableTest(void)
{

  cout << endl << "====conditionVariableTest====" << endl;

  cout << endl << "----CV----" << endl;
  mutex mtx;
  condition_variable cv;
  bool isReady = false;

  thread threadWaiter(threadWait, std::ref(cv), std::ref(mtx), std::ref(isReady));
  sleep_for(seconds(1));
  thread threadNotifier(threadNotify, std::ref(cv), std::ref(mtx), std::ref(isReady));

  threadWaiter.join();
  threadNotifier.join();
}

void threadCheckAtomicFlag(atomic<bool> &atomicBool, atomic_flag &atomicFlag)
{
  while (!atomicBool)
  { yield(); }

  // test_and_set��RMW��Read-Modify_Write����ԭ�Ӳ���
  while (atomicFlag.test_and_set()) // ���test����δset����set������δset
  { ; }

  // û��λ
  cout << "threadCheckAtomicFlag " << get_id() << " sets atomic flag." << endl;
  // �����λ���������߳̿��Լ���
  atomicFlag.clear();
}

void atomicTest(void)
{
  atomic<bool> atomicBool(false);
  atomic_flag atomicFlagBool = ATOMIC_FLAG_INIT; // �ú��ʼ��״̬Ϊclear

  thread threadAtomic1(threadCheckAtomicFlag, std::ref(atomicBool), std::ref(atomicFlagBool));
  thread threadAtomic2(threadCheckAtomicFlag, std::ref(atomicBool), std::ref(atomicFlagBool));

  cout << "main sleep for 1 second and starts threads..." << endl;
  sleep_for(seconds(1));
  atomicBool = true;
  threadAtomic1.join();
  threadAtomic2.join();
}

void multiThreadTest(void)
{
  //threadTest();
  //mutexTest();
  //futureTest();
  //conditionVariableTest();
  atomicTest();
}
