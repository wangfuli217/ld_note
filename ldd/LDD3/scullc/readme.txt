------ 工作队列的初始化（INIT_WORK的参数问题） ------
在编写工作队列的小例子时，遇到
error: macro "INIT_WORK" passed 3 arguments, but takes just 2

从2.6.20的内核开始,INIT_WORK宏做了改变,

原来是三个参数,后来改成了两个参数
 
from http://blog.csdn.net/fudan_abc/archive/2007/08/20/1751565.aspx

于是就让我们来仔细看看INIT_WORK和INIT_DELAYED_WORK.其实前者是后者的一个特例,它们涉及到的就是传说中的工作队列.这两个宏都定义于include/linux/workqueue.h中:

#define INIT_WORK(_work, _func)                                         /
        do {                                                            /
                (_work)->data = (atomic_long_t) WORK_DATA_INIT();       /
                INIT_LIST_HEAD(&(_work)->entry);                        /
                PREPARE_WORK((_work), (_func));                         /
        } while (0)

#define INIT_DELAYED_WORK(_work, _func)                         /
        do {                                                    /
                INIT_WORK(&(_work)->work, (_func));             /
                init_timer(&(_work)->timer);                    /
        } while (0)

http://blog.csdn.net/laichao1112/article/details/6313175


