http://wdxtub.com/2015/12/20/code-complete-note/

http://wdxtub.com/2014/09/11/empiror-death-clip/

https://github.com/PegasusWang/booknotes/tree/e0bda2cc337ff40221b1cfceea75d1df0aade6c6

fengyun(把主要精力集中于构建活动，可以大大提高程序员的生产率){
1. 软件开发中，架构师吃掉需求，设计师吃掉架构，程序员，软件食物链的最后一环，消化掉设计。
   如果一开始就被污染了，我们就不要指望程序员快乐了。整个软件都会具有放射性，周身都是缺陷，
   绝对导致程序员脾气暴躁、营养失调。在我们规模不大的团队里，一个人身兼数职，伤害更大。
   所以，项目一开始就决定了它能否成功。
}
fengyun(源代码 -- 往往是对软件的唯一精确描述){
其实我们不必为没有精确的文档沮丧，不是吗？
}
fengyun(2章：常见的软件隐喻){
    好的隐喻可以让我们思考更多的问题，并走上正确的道路。
    隐喻通过把软件开发和熟知的事情联系在一起，从而使你对其有更深刻的理解。
}
cc(3章：软件创建的先决条件){
1. 求助于逻辑推理、类比、数据 立刻开始编码的程序员往往比先做计划、后编码的程序员花费更多时间。
2. 问题定义的先决条件：你要解决的问题是什么 需求分析先决条件：描述一个软件系统需要解决的问题结构设计先决条件：
   典型结构要素：
  2.x 程序的组织形式(设计理由对于维护性来说，与设计本身同等重要)。定义主要模块，每个模块做什么应该明确定义，每个模块之间的交界面也应该明确定义，结构设计应该规定可以直接调用那些模块，不能调用哪些模块。结构设计也应该定义模块传送和从其他模块接受的数据。
  2.x 主要的数据结构，结构设计应该给出主要文件、表和数据结构。
  2.x 关键算法。
  2.x 主要对象，每个对象的责任和相互作用
  2.x 通用功能
  2.x 用户界面
  2.x 输入、输出
  2.x 错误处理
  2.x 鲁棒性。冗余设计、断言、容错性
  2.x 性能（速度和内存）
3. 编程约定
}
cc(4章：建立子程序的步骤){
1. 结构设计至少指出以下问题：
  1.x 要隐含的信息
  1.x 输入、输出、受影响的全局变量
  1.x 子程序如何处理错误
2. 先写PDL注释，再在注释下填充代码
3. 确定质量标准：
  3.x 接口。确认所有输入和输出数据做了解释、并且使用了所有参数
  3.x 设计质量
  3.x 数据
  3.x 控制结构
  3.x 设计（表达式、参数、逻辑结构）
迷信还是理解
}
fengyun(避免使用错误的方法制造正确的产品){
往往我们在软件开发中会很强调测试。的确、测试是质量的保证。但是测试只保证有质量的代码，却不保证有质量的设计。
}
fengyun(需求的 checklist){

# 是否详细定义了系统的全部输入，包括来源、精度、取值范围、出现频率。
# 是否详细定义了系统全部输出，包括目的，精度，取值范围、出现频率，格式？
# 是否定义了机器内存和剩余磁盘空间的最小值？
# 是否详细定义了系统的可维护性，包括适应特定功能的变更、操作环境的变更、与其他软件的接口的变更能力？ 
    书中列的远比我这里列出的多，非常值得一读。
}
fengyun(数据设计){
1. 我曾经很迷惑项目文档到底要写什么？这里列举的一些东西解开了我一些疑惑。
   如果你选择使用一个顺序访问的列表表示一组数据，就应该说明为什么顺序访问比随机访问更好。
2. 在构建期间，这些信息让你能洞察架构师的思想。在维护阶段，这种洞察力是无价之宝。
####################################### 故事
Beth 想做丈夫 Adbul 家祖传的炖肉。Adbul 说，先撒上胡椒和盐，然后去头去尾，最后放在锅里盖上盖子炖就好了。
Beth 就问了，“为什么要去头去尾呢？” 
Abdul 回答说，我不知道，我一直这么做，这要问我妈。
他打电话回家一问，母亲也说不知道，她一直这么做，这个问题要问奶奶。
母亲就打了个电话给奶奶，奶奶回答说，“我不知道你为什么要去头去尾，我这么做是因为我的锅太小了装不下”:
####################################### 故事
# 架构应该描述所有主要决策的动机。
}
fengyun(国际化和本地化){
    国际化常常被称为 i18n 是因为 Internationalization 这个单词太长了，I 和n 之间有 18 个字母。 同理，
通常本地化简写为 l10n 。这个工作一定要在构架期想好啊，到底我们需不需要 i18n 或者支持 l10n 就够了，
到底用 UTF-16 还是 UTF-8 还是 ascii 串就可以。
}
fengyun(选择编程语言){
    我曾经也觉得 C++ 是万能的，这种想法很多 C++ 程序员也有。但是无可否认，每种语言的表达力是不同的。
书在这页有一张表，如果 C 的表达能力是 1 的话，
                       C++ 和 Java 就是 2.5 。而 
                       perl 和 python 却有 6 。
这就是我们选择游戏逻辑脚本编写的原因之一。另外对语言的熟悉程度是很影响程序员的效率的，所以我们不能独立的
看语言本身的表达能力。
}
fengyun(Programming into a Language){
? 一个 singleton 到底什么时候创建出来，什么是否析构，相信很多 C++ 程序员在构建大系统的时候都头痛过。
    这次我做了一个约定，禁止任何模块的代码构造静态对象，也就是说，任何在 main 函数前自动的对象构造过程
和 main 函数之后的自动析构过程都是不允许的。然后我们有一整套管理单件的方法供使用，这个问题被很好的解决了。
我们再也没有为某个单件什么时候构造出来的，或是为什么他提前析构了的问题烦恼过。
}
fengyun(开发人员不把原型代码当作可以抛弃的代码){
    # 这个问题很严重，我多次看到过了。做原型真的是一个好方法，但一定要明白，有些代码写出来就是为了以后扔掉的。
}
fengyun(不要让 ADT 依赖于储存介质){
    这点早就意识的到，类里面最好不要有 readfromfile ， writetofile 这样的方法。但是为了方便，往往又会加上
这些方法。最终的结果是，依赖文件带来的不便总是比便利要多。同理，依赖文件名也是不恰当的。可悲的是，有些错误
犯一次往往不够。意识到这样做的不好是很容易的，真正杜绝它是另一件事。
}
fengyun(确认留在代码中的错误消息是友好的){
}
fengyun(隐式变量声明对于任何一种语言来说都是最具危险性的特性之一){
}
fengyun(尽可能缩短变量的存活时间){
}
fengyun(绑定时间){
一般说来，变量的绑定时间越晚，灵活性越好。这里的关于绑定时间的总结很不错。分别为：
    编码时绑定 (使用 magic number)
    编译时绑定 (使用命名常量)
    加载时绑定 (读注册表，配置文件等)
    对象实例化时绑定 (创建对象时读入)
    即时 (每次操作时读入)
绑定越晚，在增加灵活性的同时，也增加了耦合度。
}
fengyun(把 enum 的第一个元素留做非法值){
    这是这本书读到现在碰到的第一个以前没想过的技巧。一直我都是把非法值定义成最后一个 enum 值，或者定义成一个
很大的特殊数字。书这里的道理很充分，因为一些没有合理初始化的变量往往是 0 ，把 0 作为非法值更容易捕捉到错误。
}
fengyun(在 while 循环更适用的时候，不要使用 for 循环){}
fengyun(一个循环只做一件事情){}
fengyun(避免出现依赖循环下标最终取值的代码){}
fengyun(如果为我工作的程序员用递归去计算阶乘，那么我宁愿换人){}
fengyun( 让代码不包含 goto 并不是目的，而只是结果，把目标集中在消除 goto 上面是于事无益的){
p408 还有一句，如果程序员知道存在替换方案，并且也愿意为使用 goto 辩解，那么用 goto 也无妨。
}
fengyun(在等于表达式中的常数写在前面以避免把 == 错误的敲成 = 的问题){
这项建议与按造数轴排列的建议相冲突。我个人偏向于使用数轴排序法，让编译器来告诉我有没有无意写出的赋值语句。 
我也不希望把常数写在前面，但老说不清楚原因。
}

key(关键词){
arithmetic and logic unit, ALU: 算数逻辑单元
control processing unit, CPU: 中央处理单元，中央处理器
computer architecture: 计算机体系结构，计算机系统结构
computer organization: 计算机组成，计算机组织
control unit: 控制器，控制单元
main memory: 主存
processor: 处理器
registers: 寄存器
system bus: 系统总线
accumulator AC: 累加器
Amdahl’s law
benchmark: 基准程序
chip: 芯片
data channel: 数据通道
embedded system: 嵌入式系统
execute cycle: 执行周期
fetch cycle: 取指周期
instruction buffer register IBR: 指令缓冲寄存器
instruction register IR: 指令寄存器
instruction set: 指令集
integrated circuit IC: 集成电路
memory address register MAR: 存储器地址寄存器
memory buffer register MBR: 存储器缓冲寄存器
microprocessor: 微处理器
multicore: 多核
multiplexor: 多路选择器
opcode: 操作码
original equipment manufacturer OEM: 原始设备制造商
program control unit: 程序控制器，程序控制单元
program counter PC: 程序计数器
SPEC: 系统性能评估公司
stored program computer: 存储程序式计算机
upward compatible: 向上兼容
wafer: 晶片
word: 字
address bus: 地址总线
asynchronous timing: 异步时序
bus arbitration: 总线仲裁
bus width: 总线宽度
centralized arbitration: 集中式仲裁
data bus: 数据总线
disable interrupt: 禁止中断
distributed arbitration: 分布式仲裁
instruction cycle: 指令周期
instruction execute: 指令执行
instruction fetch: 取指令
interrupt: 中断
interrupt handler: 中断处理
interrupt service routine: 中断服务程序
peripheral component interconnect PCI: 外设部件互连
synchronous timing: 同步时序
system bus: 系统总线
associative mapping: 全相联映射
high-performance computing, HPC: 高性能计算
spatial locality: 空间局部性
temporal locality: 时间局部性
write back: 写回
write through: 写直达
error-correcting code, ECC: 纠错码
Hamming code: 汉明码
nonvolatile memory: 非易失性存储器
single-error-correcting(SEC) code: 单纠错码
single-error-correcting, double-error-detecting(SEC-DED) code: 单纠错双坚错码
soft error: 软差错
syndrome: 故障，综合故障
volatile memory: 易失性存储器
floppy disk: 软磁盘
magnetoresistive: 磁阻
multiple zoned recording: 多重区域记录
optical memory: 光存储器
pit: 凹坑
platter: 盘片
rotational delay: 旋转延迟
sector: 扇区
serpentine recording: 蛇形记录
striped data: 条带数据
substrate: 衬底
cycle stealing: 周期窃取
FireWire: 高速串行连接总线标准
InfiniBand: 高端宽带 I/O 标准
isolated I/O: 分离式 I/O
memory-mapped I/O: 存储器映射式 I/O
multiplexor channel: 多路转换通道
parallel I/O: 并行 I/O
peripheral device: 外围设备
selector channel: 选择通道
batch system: 批处理系统
demand paging: 请求分页
job control language, JCL: 作业控制语言
process control block: 进程控制块
resident monitor: 驻留的监控程序
segmentation: 分段
thrashing: 抖动
time-sharing system: 分时系统
arithmetic shift: 算术移位
biased representation: 移码表示法
denormalized number: 非规格化数
dividend: 被除数
divisor: 除数
exponent overflow: 阶值上溢
exponent underflow: 阶值下溢
guard bits: 保护位
mantissa: 尾数（有效值）
minuend: 被减数
multiplicand: 被乘数
negative overflow: 负上溢
negative underflow: 负下溢
quotient: 商
radix point: 小数点
sign bit: 符号位
sign-magnitude representation: 符号-幅值表示法
subtrahend: 减数
accumulator: 累加器
operand: 操作数
operation: 操作，运算
packed decimal: 压缩的十进制数
procedure call: 过程调用
procedure return: 过程返回
reentrant procedure: 可重入过程
skip: 跳步
autoindexing: 自动变址
base-register addressing: 基值寄存器寻址
displacement addressing: 偏移寻址
effective address: 有效地址
immediate addressing: 立即寻址
indexing: 变址
indirect addressing: 间接寻址
instruction format: 指令格式
postindexing: 后变址
preindexing: 前变址
register addressing: 寄存器寻址
register indirect addressing: 寄存器间接寻址
relative addressing: 相对寻址
branch prediction: 分支预测
condition code: 条件码
delayed branch: 延迟分支
instruction cycle: 指令周期
instruction pipeline: 指令流水线
instruction prefetch: 指令预取
program status word: 程序状态字
high-level language: 高级语言
register file: 寄存器组
register windows: 寄存器窗口
SPARC: 可扩展处理器体系结构
flow dependency: 流相关性
in-order issue: 按序发射
in-order completion: 按序完成
micro-operations: 微操作
out-of-order completion: 乱序完成
out-of-order issue: 乱序发射
output dependency: 输出相关性
procedural dependency: 读写相关性
retire: 回收
superpipelined: 超级流水线式
write-read dependency: 写读相关性
write-write dependency: 写写相关性
hardwired implementation: 硬布线实现
simultaneous multithreading, SMT: 并发多线程
superscalar: 超标量
}