
arm(体系结构)
{
Cortex-A系列：application 专用配置文件
Cortex-R系列：real-time 专用配置文件
Cortex-M系列：microcontroller 专用配置文件

ARM[X][Y][Z][T][D][M][I][E][J][F][-S]
x  处理器族
y  MMU/MPU
z  缓存
T  Thumb 16位指令解码器
D  JTAG调试器
M  扩展高速称子
I  嵌入式ICE微极化池
E  DSP扩展指令
J Jazelle Java加速功能
F  浮点处理器装置
S  综合版本
}

arm(处理器工作模式)
{
ARM 7中工作模式

用户模式（usr）：ARM处理器正常的程序执行状态。
快速中断模式（fiq）：用于高速数据传输或通道处理。
外部中断模式（irq）：用于通常的中断处理。
管理模式（svc）：操作系统使用的保护模式。
数据访问终止模式（abt）：当数据或指令预取终止时进入该模式，可用于虚拟存储及 存储保护。
系统模式（sys）：运行具有特权的操作系统任务。
未定义指令中止模式（und）：当未定义的指令执行时进入该模式，可用于支持硬件协 处理器的软件仿真。
}

