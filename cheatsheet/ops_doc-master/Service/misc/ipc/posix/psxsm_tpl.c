//信号量的初始化  
get = 0;//表示可读资源的数目  
put = 1;//表示可写资源的数目  
  
//生产者进程                               //消费者进程  
for(; ;){                                    for(; ;){  
Sem_wait(put);                                 Sem_wait(get);  
写共享缓冲区；                               读共享缓冲区；  
Sem_post(get);                                 Sem_post(put);  
}                                           }  

当生产者和消费者开始都运行时，生产者获取put信号量，此时put为1表示有资源可用，生产者进入共享缓冲区，进行修改。
而消费者获取get信号量，而此时get为0，表示没有资源可读，于是消费者进入等待序列，直到生产者生产出一个数据，
然后生产者通过挂出get信号量来通知等待的消费者，有数据可以读。