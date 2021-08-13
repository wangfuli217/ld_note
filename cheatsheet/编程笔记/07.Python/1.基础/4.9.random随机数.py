#随机数
import random

# 生成0至1之间的随机浮点数，结果大于等于0.0，小于1.0
print( random.random() )
# 生成1至10之间的随机浮点数
print( random.uniform(1, 10) )

# 产生随机整数
print( random.randint(1, 5) ) # 生成1至5之间的随机整数，结果大于等于1，小于等于5，前一个参数必须小于等于第二个参数
for i in xrange(5):
    print(i, random.randint(10, 90) ) # 产生 10~90 的随机整数(结果包含 10 和 90)

# 随机选取0到100间的偶数(第二个参数是选取间隔,如果从1开始,就是选取基数)
print( random.randrange(0, 101, 2) )

# 在指定范围内随机选一个值
print( random.choice(range(50)) ) # 这的选值范围是0~49
print( random.choice(['a', 2, 'c']) ) # 从列表中随机挑选一个数，也可以是元组、字符串
print( random.choice('abcdefg') ) # 可从字符串中随机选一个字符
# 在指定范围内随机选多个值(返回一个 list, 第二个参数是要选取的数量)
print( random.sample('abcdefghij',3) )
print( random.sample(['a', 2, 'c', 5, 0, 'ii'],2) )

# 洗牌,让列表里面的值乱序
items = [1, 2, 3, 4, 5, 6]
random.shuffle(items) # 这句改变列表里面的值,返回:None
print( items ) # 输出乱序后的列表


import os
a = os.urandom(16) # 生成16个随机unicode值
print([ord(i) for i in a]) # 打印出来，直接 print a 是无法阅读的

函数
    随机挑选和排序
        random.choice(seq) # 从序列seq的元素中随机挑选一个元素
        random.sample(seq,k) # 从序列seq的元素中随机挑选k个元素
        random.shuffle(seq) # 将序列seq的所有元素随机排序
    随机生成实验
        生成的实数符合均匀分布(uniform distribution)，意味着某个范围内每个数字出现的概率相等
        random.random() # 随机生成下一个实数，在[0,1)范围内
        random.uniform(a,b) # 随机生成下一个实数，在[a,b]范围内
        生成的实数符合其他分布，需要参考统计相关书籍
        random.gauss(mu,sigma) # 随机生成符合高斯分布的随机数，mu、sigma为高斯分布的两个参数
        random.expovariate(lambd) # 随机生成符合指数分布的随机数，lambd的指数分布的参数
        此外还有对数分布、正态分布、Pareto分布、Weibull分布
