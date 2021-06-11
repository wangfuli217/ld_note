S3C2440的时钟控制逻辑既可以外接晶振，然后通过内部电路产生时钟源，也可以通过直接使用外部提供的时钟源，
它们可以通过引脚的设置来选择。时钟控制逻辑给整个芯片提供3种时钟：
FCLK用于CPU核；
HCLK用于AHB总线上设备，比如CPU核、存储器控制器、中断控制器、LCD控制器、DMA和USB主机模块等；
PCLK用于APB总线上的设备，比如WATCHDOG、IIS、I2C、PWM定时器、ADC、UART、GPIO、RTC和SPI。


AHB(Advanced High performance Bus)总线主要用于高性能模块（如CPU、DMA和DSP等）之间的连接；
APB(Advanced Pheripheral Bus)总线主要用于低带宽的周边外设之间的连接，例如UART、I2C等。
看门狗定时器的WDTCNT寄存器根据其频率减1计数，当达到0时，可以产生中断信号，也可以输出复位信号。