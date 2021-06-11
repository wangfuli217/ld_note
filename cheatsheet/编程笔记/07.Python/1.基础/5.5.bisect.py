Python 中的bisect用于操作排序的数组，比如你可以在向一个数组插入数据的同时进行排序。下面的代码演示了如何进行操作：

bisect模块
    bisect模块提供了两个主要的函数:
        bisect: 用于对已经排序的序列进行二分搜索
        insort: 用于对已经排序的序列进行插入操作
    bisect_left(),insort_left()用于处理当元素相同时,新元素插入在list中相同元素的左边; 
    bisect_right(),insort_right()用于处理当元素相同时,新元素插入在list中相同元素的右边;
    
import bisect
 
list=[1,2,3,4,6,7,8,9]   #假定list已经排序
print bisect.bisect_left(list,5)  #返回5应该插入的索引位置
print bisect.bisect_right(list, 5)
print bisect.bisect(list,5)
 
bisect.insort_left(list, 5, 0, len(list))
print list
 
bisect.insort_right(list, 5)
print list

---------------------------------------

import bisect
import random
random.seed(1)
print('New pos contents')
print('-----------------')
l=[]
 
for i in range(1,15):
    r=random.randint(1,100)
    position=bisect.bisect(l,r)
    bisect.insort(l,r)
    print '%3d %3d'%(r,position),l

可以看到，在插入这些随机数的时候数组同时进行了排序。不过其中有一些重复的元素，比如上面的77,77。
你可以对这些重复元素的顺序进行设置，如果希望重复的元素出现在与他相同的元素左边就是用bisect_left，否则就是用bisect_right，
相应的使用insort_left和insort_right。

import bisect
import random
random.seed(1)
print('New pos contents')
print('-----------------')
l=[]
 
for i in range(1,15):
    r=random.randint(1,100)
    position=bisect.bisect_left(l,r)
    bisect.insort_left(l,r)
    print '%3d %3d'%(r,position),l
此函数bisect.bisect(list,key)
