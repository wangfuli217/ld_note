cpu(内核){
    系统板卡上的CPU插槽称之为socket，一颗物理CPU芯片可以称之为processor。现在CPU早已经进入
多核时代，一颗CPU processor可以包含多个core，而一个core又可以包含多个hardware thread。每个
hardware thread在操作系统看来，就是一个logic CPU，即一个可以被调度的CPU实例（instance）。
举个例子，如果一颗CPU processor包含4个core，而每个core又包含2个hardware thread，则从操作系统
角度看来，一共有8个可以使用的"CPU"（1*4*2 = 8）。
以lscpu输出为例：
Architecture:          x86_64
CPU op-mode(s):        32-bit, 64-bit
Byte Order:            Little Endian
CPU(s):                4
On-line CPU(s) list:   0-3
Thread(s) per core:    1
Core(s) per socket:    4
CPU socket(s):         1
NUMA node(s):          1
Vendor ID:             GenuineIntel
CPU family:            6
Model:                 45
Stepping:              7
CPU MHz:               1200.000
BogoMIPS:              4389.67
Virtualization:        VT-x
L1d cache:             32K
L1i cache:             32K
L2 cache:              256K
L3 cache:              10240K
NUMA node0 CPU(s):     0-3

4 = 1 * 4 * 1, 即CPU(s) = Thread(s) per core * Core(s) per socket * Socket(s)。

}

cpu(cache){
为了改善内存访问性能，CPU processor提供了寄存器3级cache。整个存储模型如下所示（从上往下，容量越小，CPU访问越快）：
* register（寄存器）
* L1 cache
* L2 cache
* L3 cache
* Main memory（主存储器）
* Storage Device（外接存储器）
}

cpu(时钟){
时钟（clock）是驱动所有CPU处理器逻辑的数字信号。
    CPU的速率可以用时钟周期（clock cycle）来衡量。举个例子，5 GHz CPU每秒可以产生50亿的时钟周期。
每条CPU指令的执行都会占用一个或多个时钟周期。
    CPU的速率是衡量CPU性能的一个重要参数。但是更快的CPU速率并不一定能带来性能的改善，而是要看这些
CPU时钟周期都用在做什么。举个例子，如果都用在等待访问内存的结果，那么提高CPU的速率就不会带来
真正性能的提升。
}

cpu(流水线){
CPU执行一条指令包含下面5个步骤，其中每个步骤都会由CPU的一个专门的功能单元（function unit）来完成：
（1）取指令；
（2）解码；
（3）执行指令；
（4）内存访问；
（5）写回寄存器。
    最后两个步骤是可选的，因为很多指令只会访问寄存器，不会访问内存。上面的每个步骤至少要花费一个
时钟周期（clock cycle）去完成。内存访问通常是最慢的，要占用多个时钟周期。 

    指令流水线（Instruction Pipeline）：是一种可以并行执行多条指令的CPU结构（architecture），也即
同时执行不同指令的不同部分。假设上面提到的执行指令5个步骤每个步骤都占1个时钟周期，那么完成一个指令
需要5个时钟周期（假设步骤4和5都要经历）。在执行这条指令的过程，每个步骤只有CPU的一个功能单元是工作的，
其它的都在空闲中。采用指令流水线以后，多个功能单元可以同时活跃，举个例子：在解码一条指令时，可以同时
取下一条指令。这样可以大大提高效率。理想情况下，执行每条指令仅需要1个时钟周期。

    更进一步，如果CPU内执行特定功能的功能单元有多个的话，那么每个时钟周期可以完成更多的指令。这种CPU
结构称之为“超标量（superscalar）”。指令宽度（Instruction Width）描述了可以并行处理的指令的数量。
现代CPU一般是3-wide或4-wide,即每个时钟周期可处理3~4条指令。

    Cycles per instruction（CPI）是描述CPU在哪里耗费时钟周期和理解CPU利用率的一个重要度量参数。这个参数
也可以表示为instructions per cycle（IPC）。CPI表达了指令处理的效率，并不是指令本身的效率。
}

cpu(utilization){
    CPU利用率（utilization）是指CPU在一段时间内用于做“有用功”的时间和整个这段时间的百分比值。
所谓的“有用功”即CPU没有运行内核（kernel）IDLE线程，而是运行用户级（user-level）应用程序线程，
或是其它的内核（kernel）线程，或是处理中断。
    
    CPU用来执行用户级（user-level）应用程序的时间称之为user-time，而运行内核级（kernel-level）
程序的时间称之为kernel-time。
    
    计算密集型（computation-intensive）程序也许会把几乎所有的时间用来执行用户级（user-level）
程序代码。而I/O密集型（I/O-intensive）程序有相当多的时间用来执行系统调用（system call），这些
系统调用将会执行内核代码产生I/O。
    
    当一个CPU利用率达到100％时，称之为饱和（saturated）。在这种情况下，线程在等待获得CPU时，
将会面临调度延迟（scheduler latency）的问题。
}


gpu(){
    GPU（Graphics Processing Unit）的core数量比CPU的多，它是显卡（video card）的CPU。
由于它的指令集不如CPU强大，但是core数量多，所以适合做一些相对简单的，计算密集性的运算：
比如图像处理等等。GPGPU（General Purpose Graphics Processing Unit）则不仅仅只做图像处理
    简单地讲，CPU会把要显示的图像和指令存到显卡（video card）的register中，然后通知GPU
（显卡上的CPU）去执行画图命令。 此外，wiki百科上的这张图形象地描述了整个过程：的相关运算，
也会做一些一般性的运算。
https://en.wikipedia.org/wiki/File:CUDA_processing_flow_(En).PNG
}