1.qdisc 队列
2.pfifo_fast (先进先出)有3个频道
  priomap:
3.（1）令牌桶过滤器 （tbf）
 数据流＝令牌流 无延迟的通过队列
 数据流<令牌流 消耗一部分令牌 剩下的在桶里积累，直到桶被填满，剩下的会在令牌>数据的时候消耗掉
 数据流>令牌流 导致tbf中断一断时间 发生丢包现象
 （2）使用
 limit/latency 最多有多少数据在队列中等待可用的令牌／确定了一个包在tbf中等待传输的最长等待时间
 burst／buffer／maxburst 桶的大小 （字节） 10M bit/s的速率－－－10k字节
 mpu 令牌的最低消耗 （0长度的包需要消耗64字节的带宽）
 rate 速度操纵
4.实验
 tc qdisc add dev eth0 root tbf rate 220kbit latency 50ms burst 1540
 将网卡设备eth0加入队列中，以root为根的令牌桶，数据不超过220k速率通过，当数据包等待50ms没有拿到令牌则丢弃，定义桶的大小为1540字节
5.随机公平队列 （sfq）
 解释：将流量分为相当多的FIFO队列中 每个队列对应一个会话数据按照简单轮转方式发送，每个会话都按顺序得到发送机会
 解决问题：网络阻塞
 参数：1.perturb 多少秒重新配置一次散列算法，一般为10m
       2.quantum 一个流要传输多少字节后才切换到下个队列 一般设为一个包的最大长度
6.tc qdisc add dev ppp0 root sfq perturb 10
7.队列的选取
  降低出口速率 令牌桶过滤器
  链路已经塞满，想保证不会有某一个会话独占出口带宽， 使用随机公平队列
  有一个很大的骨干带宽， 随机丢包
  希望对入口流量整形 入口流量整形
8.分类的队列规定 cbq

tc(tc交通控制)
{
OBJECT:
1 qdisc:队列规则；队列的优先级依次排列，前面比后面的高［0.1.2共计16个，不同的位标记为不同的队列：一般服务排在中间队列。］。
2 class：
3 filter：
4 action：
5 monitor：
tc qd 显示当前所有队列规则：
qdisc pfifo_fast 0: dev eth0 bands 3 priomap 1 2 2 2 1 2 0 0 1 1 1 1 1 1 1 1
0000：1 0001：20010：2 0011：2这个队列规则为pfifo_fast
man tc 
两大类：
不可分类;CLASSLESS QDISCS
1 [p|b]fifo
2 pfifo_fast
3 red随机优先
4 sfq完全公平
5 tbf没有所谓的队列，相当只有一个队列，令牌总队列。
每一个会话连接称为：session 完全公平
默认是tc qd 
tc qd add dev eth0 root sfq 修改默认队列规则
tc qd del dev etho root sfq 删除队列规则
tc qd add dev eth0 root pfifo 添加规则
tc qd add dev eth0 root tbf rate 256kbit （limit 10 ＜burst 10令牌总的参数＞） 附属参数［添加规则时必须加参数，不然会报错］
8015：此外为编号，可指定加
tc qd add dev eth0 root handle 1: (不加数字，默认为0）tbf rate 256kbit limit 10 burst 10
网卡上行限速 tbf
分分类队列规则：
CBQ：在高端应用广，软件上做即时限速是不准确的。软件上不适用。
HTB：分层令牌总
PRIO:
tc qd add dev eth0 root prio区别是分类了
tc class ls dev eth0 查验，默认产生3个类，还是以tos值分。8016：1、2、3，各有不同的优先级，类下可再加队列规则：要指定具体父类
tc qd add dev eth0 parent 8016:1 tbf rate 10kbit limit 5k burst 5k
tc qd add dev eth0 parent 8016:2 sfq 
tc qd add dev eth0 parent 8016:3 sfq
－－－－－－－－－－－－－－－－
人为方式指定，而不是tos值。
tc qd del dev etho root
tc qd add dev eth0 root handle 1:prio
tc cl ls dev eth0查看
tc qd add dev eth0 parent 1:1 tbf rate 256kbit burst 200k(字节）limit 10k 
tc qd add dev eth0 parent 1:2 tbf rate 5mbit burst 3m limit 10k
tc qd add dev eth0 parent 1:3 tbf rate 1mbit burst 1mlimit 10k
tc qd add dev eth0 parent 1:protocol ip prio 1001 (优先级）u32(过滤器类型） match ip(报头）dst 192.168.0.120 flowid 1:1
tc qd add dev eth0 parent 1:protocol ip prio 1001 (优先级）u32(过滤器类型） match ip(报头）dst 192.168.0.128 flowid 1:2
tc qd add dev eth0 parent 1:protocol ip prio 1001 (优先级）u32(过滤器类型） match ip(报头）dst 192.168.0.0／24 flowid 1:3
其他人共享1m带宽｛这就是分组处理｝这是ip限制。
}