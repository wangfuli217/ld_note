/*
精英板的itop4412的CAN 驱动需要 SPI 总线支持。
CAN总线是一种在汽车上广泛采用的总线协议，被设计作为汽车环境中的微控制器通讯。
LZ理论知识有限，网上抄一句介绍的吧。如下：CAN(Controller Area Network)总线，即控制器局域网总线，
是一种有效支持分布式控制或实时控制的串行通信网络。由于其高性能、高可靠性、及独特的设计和适宜的
价格而广泛应用于工业现场控制、智能楼宇、医疗器械、交通工具以及传感器等领域，并已被公认为几种最
有前途的现场总线之一。CAN总线规范已经被国际标准化组织制订为国际标准ISO11898，
并得到了众多半导体器件厂商的支持。
电路相关的资料不在这里介绍了，可以查看博客等资料。
Socket CAN的设计克服了将CAN设备驱动实现为字符设备驱动带来的局限性，因为字符设备驱动直接操作控制器
硬件进行帧的收发、帧的排队以及一些高层传输协议只能在应用层实现。另外，字符设备驱动只能单进程进行
访问，不支持多进程同时操作。
SocketCAN的设计基于新的协议族PF_CAN.协议族PF_CAN一方面向应用程序提供Socket接口，另一方面它构建在Linux
网络体系结构中的网络层之上，从而可以更有效利用Linux网络子系统中的各种排队策略。CAN控制器被注册成一个
网络设备，这样的控制器收到的帧就可以传送给网络层，进而传送到CAN协议族部分（帧发送的过程的传递方向
与此相反）。同时，协议族模块提供传输层协议动态加载和卸载接口函数，更好地支持使用各种CAN传输层协议
（目前协议族中只包括两种CAN协议：CAN_RAW和CAN_BCM）。此外协议族还支持各种CAN帧的订阅，支持多个进程
同时进行SOCKET CAN通信，每个进程可以同时使用不同协议进行各种帧的收发。
CAN子系统：
can子系统实现协议族PF_CAN，主要包括三个C文件：af_can.c、raw.c和bcm.c。其中af_can.c是整个子系统的
核心管理文件，raw.c和bcm.c分别是raw和bcm协议的实现文件。CAN子系统与其他模块的关系如图：
						BSD Socket Layer
								|
						CAN子系统
			CAN_RAW        CAN_BCM
								|
				  Network	Layer		
				  			|
				  	CAN设备驱动
				  	
		af_can.c是Socket CAN的核心管理模块。can_creat()创建CAN通信所需的socket。当应用程序调用socket（）
创建socket时，就会简介调用此函数：can_proto_register(struct can_proto *)和can_proto_unregister(
struct can_proto *)可被用来动态加载和卸载CAN传输协议，传输协议在此用struct can_proto表示。
CAN_RAW和CAN_BCM协议分别定义如下：
	static const struct can_proto raw_can_proto = {
	.type       = SOCK_RAW,
	.protocol   = CAN_RAW,
	.ops        = &raw_ops,
	.prot       = &raw_proto,
};
static const struct can_proto bcm_can_proto = {
	.type       = SOCK_DGRAM,
	.protocol   = CAN_BCM,
	.ops        = &bcm_ops,
	.prot       = &bcm_proto,
};
can_rcv()是网络层用来接收包的操作函数，与包对应的操作函数通过定义struct packet_type来指明：
 *
 * af_can module init/exit functions
 *
static struct packet_type can_packet __read_mostly = {
	.type = cpu_to_be16(ETH_P_CAN),
	.dev  = NULL,
	.func = can_rcv,
};
	can_rcv()中调用can_rcv_filter()对收到的CAN帧进行过滤处理，只接收用户通过can_rx_register()订阅的
CAN帧；与can_rx_register()对应的函数can_rx_unregister（）用来取消用户订阅的CAN帧。
	raw.c和bcm.c分别是协议族里用来实现raw.socket和bcm.socket通信所需的文件。利用CAN_RAW和CAN_BCM协议
均能实现帧ID的订阅，并且利用CAN_BCM协议还能进行帧内容的过滤。
	其中，raw_rcv()和bcm_send_to_user()是传输层用来接收CAN帧的操作函数，当can_rcv()接收到用户订阅的帧
时，就会调用这两函数将帧放到接收队列中，然后raw_recvmsg()或bcm_recvmsg()就会通过调用
skb_recv_datagram()来从接收队列中取出帧，从而把帧进一步传送到上层；
	raw_sendmsg()和bcm_sendmsg()通过调用can_send()进行帧的发送，而can_send()会调用dev_queue_xmit()来
向CAN设备传输一个CAN帧，然后dev_queue_xmit()会间接调用CAN设备驱动hard_start_xmit()来真正实现帧的
发送。
Socket CAN驱动程序设计
	Linux驱动程序是Linux内核主要组成部分，其功能主要是操作硬件设备，为用户屏蔽设备的工作细节，并向
用户提供透明访问硬件设备的机制。Linux驱动程序支持3种类型的设备：字符设备、块设备和网络设备。
	独立的CAN控制器MCP2515实现CAN协议的物理层与数据链路层，本文的应用中将其作为网络设备处理。同时,
MCP2515通过SPI接口连接到主控器，其也被视为SPI从设备。因此，驱动程序不仅要操作CAN控制器，而且要能
很好地与Linux CAN子系统、网络子系统、Linux SPI核心进行交互。
CAN网络设备操作函数的定义如下：
	static const struct net_device_ops mcp251x_netdev_ops = {
	.ndo_open = mcp251x_open,
	.ndo_stop = mcp251x_stop,
	.ndo_start_xmit = mcp251x_hard_start_xmit,
};
结构体中部分成员的功能描述如下：
	mcp251x_open（）负责对CAN控制器进行复位初始化，并且调用netif_wake_queue()通知上层启动新的传输。
	mcp251x_stop（）使控制器停止工作并让其睡眠。
	mcp251x_hard_start_xmit（）负责将帧数据写到控制器的相应寄存器和发送缓存区中，并进行发送。
	
SPI从设备信息定义如下：
	#ifdef CONFIG_CAN_MCP251X
	{
		.modalias = "mcp2515",
		.platform_data = &mcp251x_info,
		
	#if defined(CONFIG_CPU_TYPE_SCP_ELITE) || defined(CONFIG_CPU_TYPE_POP_ELITE) || defined(CONFIG_CPU_TYPE_POP2G_ELITE) //add by dg 2015 08 10
         	.irq = IRQ_EINT(1),
	#elif defined(CONFIG_CPU_TYPE_SCP_SUPPER) || defined(CONFIG_CPU_TYPE_POP_SUPPER) || defined(CONFIG_CPU_TYPE_POP2G_SUPPER)
             .irq = IRQ_EINT(0),
	#endif
	
		.max_speed_hz = 10*1000*1000,
		.bus_num = 2,
		.chip_select = 0,
		.mode = SPI_MODE_0,
		.controller_data = &spi2_csi[0],
	}
	#endif
	
	static struct mcp251x_platform_data mcp251x_info = {
	.oscillator_frequency = 8000000,
	.board_specific_setup = mcp251x_ioSetup,
	};
	另外，驱动中还涉及几个比较重要函数。
	
*/
/*
	主机驱动与外设驱动分离的设计思想
12.4.1　主机驱动与外设驱动分离
Linux中SPI、I2C、USB等子系统都利用典型的把主机驱动和外设驱动分离的想法，主机端只负责产生总
线上的传输波形，而外设端通过标准的API让主机端以适当的波形访问自身。
这里涉及4个软件模块：
1）主机端的驱动。根据具体的I2C、SPI、USB等控制器的硬件手册，操作具体的I2C、SPI、USB等控制器，
产生总线的各种波形。
2）连接主机和外设的纽带。外设不直接调用主机端的驱动来产生波形，而是调一个标准的API。由这个标
准的API把这个波形的传输请求间接“转发”给了具体的主机端驱动。在这里，最好把关于波形的描述也以
某种数据结构标准化。
3）外设端的驱动。外设接在I2C、SPI、USB总线上，但外设本身可以是触摸屏、网卡、声卡或任意一种类
型的设备。在相关的i2c_driver、spi_driver、usb_driver这种xxx_driver的probe（）函数中去注册它
具体的类型。当这些外设要求I2C、SPI、USB等去访问它的时候，它调用“连接主机和外设的纽带”模块的
标准API。
4）板级逻辑。板级逻辑用来描述主机和外设是如何互联的。假设板子上有多个SPI控制器和多个SPI外设，
究竟谁接在谁上面管理互联关系，既不是主机端的责任，也不是外设端的责任，这属于板级逻辑的责任。
通常出现在arch/arm/mach-xxx下面或者arch/arm/boot/dts下面。
SPI在linux中分为3层分别为主机控制器驱动、核心层驱动和外设驱动：
在我们这个板级驱动架构是：
			主机控制器驱动：spi_s3c64xx.c--------------这个文件将s3c6410的硬件spi控制器驱动。
     
     	核心层驱动 ：spi.c---------------------------这个文件是实现了spi的注册和注销的函数等，连接
     		了主机控制器和外设驱动，起到了桥梁的作用。
     
      外设驱动  ：mcp251x.c----------------------内核中的一个CAN外设控制器。
      
 	spi_s3c24xx.c本身并没有生成设备节点，mcp251x.c的任务就是为了在user space或kernel space访问spi设
备而设，就是通过它来进行spi设备的读写。
*/
////需要添加lcd的平台设备信息
/*file:mach-itop4412.c*/
static void __init smdk4x12_machine_init(void)
{
	//#ifndef CONFIG_CAN_MCP251X 如果使用了CAN，那么我们不可以使能同管脚的i2c 6接口
	#if !defined(CONFIG_CAN_MCP251X) && !defined(CONFIG_SPI_RC522)
	s3c_i2c6_set_platdata(NULL);
	i2c_register_board_info(6, i2c_devs6, ARRAY_SIZE(i2c_devs6));
	#endif
	
	//外设驱动设备信息注册，跟外设驱动相关的，外设驱动：mcp251x.c
	#ifdef CONFIG_S3C64XX_DEV_SPI
	sclk = clk_get(spi2_dev, "dout_spi2");
	if (IS_ERR(sclk))
		dev_err(spi2_dev, "failed to get sclk for SPI-2\n");
	prnt = clk_get(spi2_dev, "mout_mpll_user");
	if (IS_ERR(prnt))
		dev_err(spi2_dev, "failed to get prnt\n");
	if (clk_set_parent(sclk, prnt))
		printk(KERN_ERR "Unable to set parent %s of clock %s.\n",
				prnt->name, sclk->name);

	clk_set_rate(sclk, 800 * 1000 * 1000);
	clk_put(sclk);
	clk_put(prnt);

	if (!gpio_request(EXYNOS4_GPC1(2), "SPI_CS2")) {
		gpio_direction_output(EXYNOS4_GPC1(2), 1);
		s3c_gpio_cfgpin(EXYNOS4_GPC1(2), S3C_GPIO_SFN(1));
		s3c_gpio_setpull(EXYNOS4_GPC1(2), S3C_GPIO_PULL_UP);
		exynos_spi_set_info(2, EXYNOS_SPI_SRCCLK_SCLK,
			ARRAY_SIZE(spi2_csi));
	}

	for (gpio = EXYNOS4_GPC1(1); gpio < EXYNOS4_GPC1(5); gpio++)
		s5p_gpio_set_drvstr(gpio, S5P_GPIO_DRVSTR_LV3);

	spi_register_board_info(spi2_board_info, ARRAY_SIZE(spi2_board_info));
	#endif
	
	//平台设备注册
	platform_add_devices(smdk4x12_devices, ARRAY_SIZE(smdk4x12_devices));
}	

//Mcp2515有标准的驱动，可以从网上找到下载，linux的内核里边也有默认的驱动。
//所以只要配置好内核，添加设备端的配置信息就好了。以下是我的配置信息：
static struct spi_board_info spi2_board_info[] __initdata = {
#ifdef CONFIG_CAN_MCP251X
	{
		.modalias = "mcp2515",//与mcp251x.c中mcp251x_id_table相匹配
		.platform_data = &mcp251x_info,
		
#if defined(CONFIG_CPU_TYPE_SCP_ELITE) || defined(CONFIG_CPU_TYPE_POP_ELITE) || defined(CONFIG_CPU_TYPE_POP2G_ELITE) //add by dg 2015 08 10

         	.irq = IRQ_EINT(1),
#elif defined(CONFIG_CPU_TYPE_SCP_SUPPER) || defined(CONFIG_CPU_TYPE_POP_SUPPER) || defined(CONFIG_CPU_TYPE_POP2G_SUPPER)
             .irq = IRQ_EINT(0),
#endif
	
		.max_speed_hz = 10*1000*1000,
		.bus_num = 2,
		.chip_select = 0,
		.mode = SPI_MODE_0,
		.controller_data = &spi2_csi[0],
	}
#endif
};

static struct mcp251x_platform_data mcp251x_info = {
	.oscillator_frequency = 8000000,
	.board_specific_setup = mcp251x_ioSetup,
};
static struct s3c64xx_spi_csinfo spi2_csi[] = {
	[0] = {
		.line = EXYNOS4_GPC1(2),
		.set_level = gpio_set_value,
		.fb_delay = 0x2,
	},
};
	
static struct platform_device *smdk4x12_devices[] __initdata = {
	#ifdef CONFIG_S3C64XX_DEV_SPI
	#if 0	//remove by cym 20130529
		&exynos_device_spi0,
	#ifndef CONFIG_FB_S5P_LMS501KF03
		&exynos_device_spi1,
	#endif
	#endif
		&exynos_device_spi2,
	#endif
};

//平台相关
/* file:dev_spi.c */
struct platform_device exynos_device_spi2 = {
	.name		  = "s3c64xx-spi",
	.id		  = 2,
	.num_resources	  = ARRAY_SIZE(exynos_spi2_resource),
	.resource	  = exynos_spi2_resource,
	.dev = {
		.dma_mask		= &spi_dmamask,
		.coherent_dma_mask	= DMA_BIT_MASK(32),
		.platform_data = &exynos_spi2_pdata,
	},
};

static struct resource exynos_spi2_resource[] = {
	[0] = {
		.start = EXYNOS_PA_SPI2,
		.end   = EXYNOS_PA_SPI2 + 0x100 - 1,
		.flags = IORESOURCE_MEM,
	},
	[1] = {
		.start = DMACH_SPI2_TX,
		.end   = DMACH_SPI2_TX,
		.flags = IORESOURCE_DMA,
	},
	[2] = {
		.start = DMACH_SPI2_RX,
		.end   = DMACH_SPI2_RX,
		.flags = IORESOURCE_DMA,
	},
	[3] = {
		.start = IRQ_SPI2,
		.end   = IRQ_SPI2,
		.flags = IORESOURCE_IRQ,
	},
};

static struct s3c64xx_spi_info exynos_spi2_pdata = {
	.cfg_gpio = exynos_spi_cfg_gpio,
	.fifo_lvl_mask = 0x7f,
	.rx_lvl_offset = 15,
	.high_speed = 1,
	.clk_from_cmu = true,
	.tx_st_done = 25,
};

//主机控制器相关
/*file:spi_s3c64xx.c */
static struct platform_driver s3c64xx_spi_driver = {
	.driver = {
		.name	= "s3c64xx-spi",//与exynos_device_spi2的name相匹配
		.owner = THIS_MODULE,
	},
	.remove = s3c64xx_spi_remove,
	.suspend = s3c64xx_spi_suspend,
	.resume = s3c64xx_spi_resume,
};
static int __init s3c64xx_spi_init(void)
{
	return platform_driver_probe(&s3c64xx_spi_driver, s3c64xx_spi_probe);
}

//外设驱动相关
/*file:mcp251x.c */
static const struct spi_device_id mcp251x_id_table[] = {
	{ "mcp2510",	CAN_MCP251X_MCP2510 },
	{ "mcp2515",	CAN_MCP251X_MCP2515 },
	{ },
};

MODULE_DEVICE_TABLE(spi, mcp251x_id_table);

static struct spi_driver mcp251x_can_driver = {
	.driver = {
		.name = DEVICE_NAME,
		.bus = &spi_bus_type,
		.owner = THIS_MODULE,
	},

	.id_table = mcp251x_id_table,
	.probe = mcp251x_can_probe,
	.remove = __devexit_p(mcp251x_can_remove),
	.suspend = mcp251x_can_suspend,
	.resume = mcp251x_can_resume,
};

/*-----------------------------------------------------------------------------------
samsung spi-s3c64xx.c主机控制器驱动probe函数分析
-----------------------------------------------------------------------------------*/
static int __init s3c64xx_spi_probe(struct platform_device *pdev)
{
	struct resource	*mem_res, *dmatx_res, *dmarx_res;
	struct s3c64xx_spi_driver_data *sdd;
	struct s3c64xx_spi_info *sci;
	struct spi_master *master;
	int ret;

	printk("%s(%d)\n", __FUNCTION__, __LINE__);

	if (pdev->id < 0) {
		dev_err(&pdev->dev,
				"Invalid platform device id-%d\n", pdev->id);
		return -ENODEV;
	}

	if (pdev->dev.platform_data == NULL) {
		dev_err(&pdev->dev, "platform_data missing!\n");
		return -ENODEV;
	}

	sci = pdev->dev.platform_data;//获取设备信息（从这里可看到没有设备树相关的判断，所以该驱动不适用设备树）
	if (!sci->src_clk_name) {
		dev_err(&pdev->dev,
			"Board init must call s3c64xx_spi_set_info()\n");
		return -EINVAL;
	}

	/* Check for availability of necessary resource */

	dmatx_res = platform_get_resource(pdev, IORESOURCE_DMA, 0);//得到平台驱动DMA tx资源
	if (dmatx_res == NULL) {
		dev_err(&pdev->dev, "Unable to get SPI-Tx dma resource\n");
		return -ENXIO;
	}

	dmarx_res = platform_get_resource(pdev, IORESOURCE_DMA, 1);//得到平台驱动DMA rx资源
	if (dmarx_res == NULL) {
		dev_err(&pdev->dev, "Unable to get SPI-Rx dma resource\n");
		return -ENXIO;
	}

	mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);//获取IO内存资源
	if (mem_res == NULL) {
		dev_err(&pdev->dev, "Unable to get SPI MEM resource\n");
		return -ENXIO;
	}

	//为结构体spi_master和结构体s3c64xx_spi_driver_data分配存储空间，并将s3c64xx_spi_driver_data设为spi_master的drvdata。
	master = spi_alloc_master(&pdev->dev,
				sizeof(struct s3c64xx_spi_driver_data));
	if (master == NULL) {
		dev_err(&pdev->dev, "Unable to allocate SPI Master\n");
		return -ENOMEM;
	}

	/** 
     * platform_set_drvdata 和 platform_get_drvdata 
     * probe函数中定义的局部变量，如果我想在其他地方使用它怎么办呢？ 
     * 这就需要把它保存起来。内核提供了这个方法， 
     * 使用函数platform_set_drvdata()可以将master保存成平台总线设备的私有数据。 
     * 以后再要使用它时只需调用platform_get_drvdata()就可以了。 
 */  
	platform_set_drvdata(pdev, master);

	//从master中获得s3c64xx_spi_driver_data，并初始化相关成员  
	sdd = spi_master_get_devdata(master);
	sdd->master = master;
	sdd->cntrlr_info = sci;
	sdd->pdev = pdev;
	sdd->sfr_start = mem_res->start;
	sdd->tx_dmach = dmatx_res->start;
	sdd->rx_dmach = dmarx_res->start;

	sdd->cur_bpw = 8;

	//master相关成员的初始化 
	master->bus_num = pdev->id;//总线号
	master->setup = s3c64xx_spi_setup;
	master->transfer = s3c64xx_spi_transfer;
	master->num_chipselect = sci->num_cs;//该总线上的设备数 
	master->dma_alignment = 8;
	/* the spi->mode bits understood by this driver: */
	master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_CS_HIGH;

	if (request_mem_region(mem_res->start,
			resource_size(mem_res), pdev->name) == NULL) {
		dev_err(&pdev->dev, "Req mem region failed\n");
		ret = -ENXIO;
		goto err0;
	}

	sdd->regs = ioremap(mem_res->start, resource_size(mem_res));//申请IO内存 
	if (sdd->regs == NULL) {
		dev_err(&pdev->dev, "Unable to remap IO\n");
		ret = -ENXIO;
		goto err1;
	}

	//SPI的IO管脚配置，将相应的IO管脚设置为SPI功能 
	if (sci->cfg_gpio == NULL || sci->cfg_gpio(pdev)) {
		dev_err(&pdev->dev, "Unable to config gpio\n");
		ret = -EBUSY;
		goto err2;
	}

	//使能时钟  
	/* Setup clocks */
	sdd->clk = clk_get(&pdev->dev, "spi");
	if (IS_ERR(sdd->clk)) {
		dev_err(&pdev->dev, "Unable to acquire clock 'spi'\n");
		ret = PTR_ERR(sdd->clk);
		goto err3;
	}

	if (clk_enable(sdd->clk)) {
		dev_err(&pdev->dev, "Couldn't enable clock 'spi'\n");
		ret = -EBUSY;
		goto err4;
	}

	sdd->src_clk = clk_get(&pdev->dev, sci->src_clk_name);
	if (IS_ERR(sdd->src_clk)) {
		dev_err(&pdev->dev,
			"Unable to acquire clock '%s'\n", sci->src_clk_name);
		ret = PTR_ERR(sdd->src_clk);
		goto err5;
	}

	if (clk_enable(sdd->src_clk)) {
		dev_err(&pdev->dev, "Couldn't enable clock '%s'\n",
							sci->src_clk_name);
		ret = -EBUSY;
		goto err6;
	}

	sdd->workqueue = create_singlethread_workqueue(
						dev_name(master->dev.parent));
	if (sdd->workqueue == NULL) {
		dev_err(&pdev->dev, "Unable to create workqueue\n");
		ret = -ENOMEM;
		goto err7;
	}
	printk("%s(%d)\n", __FUNCTION__, __LINE__);
	
	//硬件初始化，初始化设置寄存器，包括对SPIMOSI、SPIMISO、SPICLK引脚的设置 
	/* Setup Deufult Mode */
	s3c64xx_spi_hwinit(sdd, pdev->id);

	//锁、工作队列等初始化 
	spin_lock_init(&sdd->lock);
	init_completion(&sdd->xfer_completion);
	INIT_WORK(&sdd->work, s3c64xx_spi_work);
	INIT_LIST_HEAD(&sdd->queue);

	//注册spi_master到spi子系统中去
	if (spi_register_master(master)) {
		dev_err(&pdev->dev, "cannot register SPI master\n");
		ret = -EBUSY;
		goto err8;
	}

	dev_dbg(&pdev->dev, "Samsung SoC SPI Driver loaded for Bus SPI-%d "
					"with %d Slaves attached\n",
					pdev->id, master->num_chipselect);
	dev_dbg(&pdev->dev, "\tIOmem=[0x%x-0x%x]\tDMA=[Rx-%d, Tx-%d]\n",
					mem_res->end, mem_res->start,
					sdd->rx_dmach, sdd->tx_dmach);
	printk("%s(%d)\n", __FUNCTION__, __LINE__);
	return 0;

err8:
	destroy_workqueue(sdd->workqueue);
err7:
	clk_disable(sdd->src_clk);
err6:
	clk_put(sdd->src_clk);
err5:
	clk_disable(sdd->clk);
err4:
	clk_put(sdd->clk);
err3:
err2:
	iounmap((void *) sdd->regs);
err1:
	release_mem_region(mem_res->start, resource_size(mem_res));
err0:
	platform_set_drvdata(pdev, NULL);
	spi_master_put(master);

	return ret;
}

/*-----------------------------------------------------------------------------------
mcp251x.c外设驱动probe函数分析
-----------------------------------------------------------------------------------*/
//我们先来看一下设备初始化函数
static struct spi_driver mcp251x_can_driver = {
	.driver = {
		.name = DEVICE_NAME,
		.bus = &spi_bus_type,
		.owner = THIS_MODULE,
	},

	.id_table = mcp251x_id_table,
	.probe = mcp251x_can_probe,
	.remove = __devexit_p(mcp251x_can_remove),
	.suspend = mcp251x_can_suspend,
	.resume = mcp251x_can_resume,
};

static int __init mcp251x_can_init(void)
{
	return spi_register_driver(&mcp251x_can_driver);
}
//这是一个非常重要的结构体，在probe函数中被注册
static const struct net_device_ops mcp251x_netdev_ops = {
	.ndo_open = mcp251x_open,
	.ndo_stop = mcp251x_stop,
	.ndo_start_xmit = mcp251x_hard_start_xmit,
};

static int __devinit mcp251x_can_probe(struct spi_device *spi)
{
	struct net_device *net;
	struct mcp251x_priv *priv;
	struct mcp251x_platform_data *pdata = spi->dev.platform_data;//获取SPI设备信息
	int ret = -ENODEV;

	if (!pdata)
		/* Platform data is required for osc freq */
		goto error_out;

	//分配和设置CAN网络设备的空间
	/* Allocate can/net device */
	net = alloc_candev(sizeof(struct mcp251x_priv), TX_ECHO_SKB_MAX);
	if (!net) {
		ret = -ENOMEM;
		goto error_alloc;
	}

	net->netdev_ops = &mcp251x_netdev_ops;
	net->flags |= IFF_ECHO;

	//通过指针偏移获得私有数据的首地址
	priv = netdev_priv(net);

	//设置CAN的私有数据
	/* add by cym 20131018 */
	priv->can.bittiming.bitrate = 250000;//波特率
	/* end add */
	
	priv->can.bittiming_const = &mcp251x_bittiming_const;
	priv->can.do_set_mode = mcp251x_do_set_mode;
	priv->can.clock.freq = pdata->oscillator_frequency / 2;
	priv->can.ctrlmode_supported = CAN_CTRLMODE_3_SAMPLES |
		CAN_CTRLMODE_LOOPBACK | CAN_CTRLMODE_LISTENONLY;
	priv->model = spi_get_device_id(spi)->driver_data;//获取芯片型号
	priv->net = net;//指向网络设备
	dev_set_drvdata(&spi->dev, priv);

	priv->spi = spi;//指向SPI设备
	mutex_init(&priv->mcp_lock);

	/* If requested, allocate DMA buffers */
	if (mcp251x_enable_dma) {
		spi->dev.coherent_dma_mask = ~0;

		/*
		 * Minimum coherent DMA allocation is PAGE_SIZE, so allocate
		 * that much and share it between Tx and Rx DMA buffers.
		 */
		priv->spi_tx_buf = dma_alloc_coherent(&spi->dev,
						      PAGE_SIZE,
						      &priv->spi_tx_dma,
						      GFP_DMA);

		if (priv->spi_tx_buf) {
			priv->spi_rx_buf = (u8 *)(priv->spi_tx_buf +
						  (PAGE_SIZE / 2));
			priv->spi_rx_dma = (dma_addr_t)(priv->spi_tx_dma +
							(PAGE_SIZE / 2));
		} else {
			/* Fall back to non-DMA */
			mcp251x_enable_dma = 0;
		}
	}

	/* Allocate non-DMA buffers */
	if (!mcp251x_enable_dma) {
		priv->spi_tx_buf = kmalloc(SPI_TRANSFER_BUF_LEN, GFP_KERNEL);
		if (!priv->spi_tx_buf) {
			ret = -ENOMEM;
			goto error_tx_buf;
		}
		priv->spi_rx_buf = kmalloc(SPI_TRANSFER_BUF_LEN, GFP_KERNEL);
		if (!priv->spi_rx_buf) {
			ret = -ENOMEM;
			goto error_rx_buf;
		}
	}

	if (pdata->power_enable)
		pdata->power_enable(1);

	/* Call out to platform specific setup */
	if (pdata->board_specific_setup)
		pdata->board_specific_setup(spi);

	SET_NETDEV_DEV(net, &spi->dev);

	/* Configure the SPI bus */
	spi->mode = SPI_MODE_0;
	spi->bits_per_word = 8;
	spi_setup(spi);

	/* Here is OK to not lock the MCP, no one knows about it yet */
	if (!mcp251x_hw_probe(spi)) {
		dev_info(&spi->dev, "Probe failed\n");
		goto error_probe;
	}
	mcp251x_hw_sleep(spi);

	if (pdata->transceiver_enable)
		pdata->transceiver_enable(0);

	//注册net_device
	ret = register_candev(net);
	if (!ret) {
		dev_info(&spi->dev, "probed\n");
		return ret;
	}
error_probe:
	if (!mcp251x_enable_dma)
		kfree(priv->spi_rx_buf);
error_rx_buf:
	if (!mcp251x_enable_dma)
		kfree(priv->spi_tx_buf);
error_tx_buf:
	free_candev(net);
	if (mcp251x_enable_dma)
		dma_free_coherent(&spi->dev, PAGE_SIZE,
				  priv->spi_tx_buf, priv->spi_tx_dma);
error_alloc:
	if (pdata->power_enable)
		pdata->power_enable(0);
	dev_err(&spi->dev, "probe failed\n");
error_out:
	return ret;
}

//接下来分析Socket CAN发送数据流程

/*当我们在用户层通过socket进行CAN数据的发送时，需要进行以下操作：
    （1） 创建一个套接字socket，采用AF_CAN协议；
    （2）将创建的套接字返回描述符sockfd，绑定到本地的地址；
    （3）通过sendto系统调用函数进行发送；
   int sendto(int sockfd, const void *msg, intlen,unsigned intflags, const struct sockaddr *to, int tolen);
         主要参数说明如下：
         sockfd:通过socket函数生成的套接字描述符；
         msg:该指针指向需要发送数据的缓冲区；
         len:是发送数据的长度；
         to:目标主机的IP地址及端口号信息； 
         
	 sendto的系统调用会发送一帧数据报到指定的地址，在CAN协议调用之前把该地址移到内核空间
和检查用户空间数据域是否可读。在net/socket.c源文件中，sendto函数的系统调用如下代码：    
*/
SYSCALL_DEFINE6(sendto, int, fd, void __user *, buff, size_t, len,
		unsigned, flags, struct sockaddr __user *, addr,
		int, addr_len)
{
		...
	
	 /*把用户空间的地址移动到内核空间中*/
		if (addr) {
		err = move_addr_to_kernel(addr, addr_len, (struct sockaddr *)&address);
		if (err < 0)
			goto out_put;
		msg.msg_name = (struct sockaddr *)&address;
		msg.msg_namelen = addr_len;
	}
	err = sock_sendmsg(sock, &msg, len);
	/*调用函数->__sock_sendmsg(&iocb, sock, msg, size);
								-> __sock_sendmsg_nosec(iocb, sock, msg, size) 
									 在__sock_sendmsg_nosec()函数中会返回一个sendmsg函数指针。
										->sock->ops->sendmsg(iocb, sock, msg, size);
											在/net/can/raw.c源文件中，将raw_sendmsg函数地址赋给sendmsg函数指针，
											即在函数__sock_sendmsg_nosec()中return sock->ops->sendmsg(iocb,sock, msg, size)，
											返回的函数指针将指向raw_sendmsg()函数。
											static const struct proto_ops raw_ops = {
												...
												.poll          = datagram_poll,
												.ioctl         = can_ioctl,	  //use can_ioctl() from af_can.c 
												...
												.sendmsg       = raw_sendmsg,//指向这个函数
												.recvmsg       = raw_recvmsg,
												.mmap          = sock_no_mmap,
												.sendpage      = sock_no_sendpage,
											};
											
											raw_sendmsg(struct kiocb *iocb, struct socket *sock,struct msghdr *msg, size_t size)
													->can_send(skb, ro->loopback);
														 在net/can/af_can.c源文件中，can_send函数负责CAN协议层的数据传输，
														 即传输一帧CAN报文（可选本地回环）。参数skb指针指向套接字缓冲区和
														 在数据段的CAN帧。loop参数是在本地CAN套接字上为监听者提供回环。
														 ->dev_queue_xmit(skb);
														 		->dev_hard_start_xmit(skb, dev, txq);
														 			->rc = ops->ndo_start_xmit(nskb, dev);
														 				 以下开始进行到CAN的底层驱动代码了，由于CAN驱动是编译进内核中，
														 				 所以在系统启动时会注册CAN驱动，注册CAN驱动过程中会初始化
														 				 mcp251x_netdev_ops结构体变量。在这个过程中，mcp251x_netdev_ops
														 				 结构体变量定义了3个函数指针，其中(*ndo_start_xmit)函数
														 				 指针指向mcp251x_hard_start_xmit函数的入口地址。
														 				 ->调用queue_work(priv->wq, &priv->tx_work);中tx指向的函数。在
														 				 		之前mcp251x_open中实现INIT_WORK(&priv->tx_work,
														 				 		mcp251x_tx_work_handler)，然后调用该函数准备消息报文进行传输
	以上即是本人对Socket CAN进行数据发送的理解。
	*/
	
}
//接下来分析Socket CAN接收数据流程

/*
	对于网络设备，数据接收大体上采用中断+NAPI机制进行数据的接收。但是我们这里没有采用这样的方法，但是大
体上的流程比较相似。 
	当用户态用ifconfig配置网卡IP地址或者启动网卡时调用ndo_open函数。网卡硬件的初始化是在ndo_open中进行
的。
*/
/*
mcp251x_open(struct net_device *net)
	->ret = request_threaded_irq(spi->irq, NULL, mcp251x_can_ist,
		  pdata->irq_flags ? pdata->irq_flags : IRQF_TRIGGER_FALLING,
		  DEVICE_NAME, priv);
		注册中断处理函数mcp251x_can_ist函数；当中断产生时，会调用该函数。
		mcp251x_can_ist(int irq, void *dev_id)
			->mcp251x_hw_rx(struct spi_device *spi, int buf_idx)
				->mcp251x_hw_rx_frame(struct spi_device *spi, u8 *buf,int buf_idx)
					->mcp251x_read_reg
						然后从CAN模块的接收寄存器中接收数据
*/

//附外解决方法：（参考）
//1、在配置Linux 编译选项
Networking support --->
	CAN bus subsystem support --->
		CAN Device Drivers --->
			Platform CAN drivers with Netlink support
			CAN bit-timing calculation
//2.驱动文件mcp251x.c mcp251x.h can.h
//文件mcp251x.c放在目录drivers/net/can/下；
//文件mcp251x.h放在目录include/linux/can/platform/下；
//文件can.h放在目录include/linux/can/下

//3.添加配置文件drivers/net/can/Kconfig
//在文件中添加
config CAN_MCP251X
tristate "Microchip 251x series SPI CAN Controller"
depends on CAN && SPI
default N
---help---
  Say Y here if you want support for the Microchip 251x series of
  SPI based CAN controllers.

//4.在drivers/net/can/Makefile文件中添加编译文件
obj-$(CONFIG_CAN_MCP251X) += mcp251x.o


//Linux-c CAN模块测试程序：

/*client*/
#include <string.h>
#include <sys/ioctl.h>
#include <net/if.h>
#include <linux/can.h>

#ifndef PF_CAN
#define PF_CAN 29
#endif

#ifndef AF_CAN
#define AF_CAN PF_CAN
#endif

int main()
{
	int s;
	unsigned long nbytes;
	struct sockaddr_can addr;
	struct ifreq ifr;
	struct can_frame frame;


	s = socket(PF_CAN,SOCK_RAW,CAN_RAW);

	strcpy((char *)(ifr.ifr_name),"can0");
	ioctl(s,SIOCGIFINDEX,&ifr);
	printf("can0 can_ifindex = %x\n",ifr.ifr_ifindex);


	addr.can_family = AF_CAN;
	addr.can_ifindex = ifr.ifr_ifindex;
	bind(s,(struct sockaddr*)&addr,sizeof(addr));


	frame.can_id = 0x123;
	strcpy((char *)frame.data,"hello");
	frame.can_dlc = strlen(frame.data);

	printf("Send a CAN frame from interface %s\n",ifr.ifr_name);

	nbytes = sendto(s,&frame,sizeof(struct can_frame),0,(struct sockaddr*)&addr,sizeof(addr));
	
	return 0;
}


/*server*/
#include <string.h>
#include <sys/ioctl.h>
#include <net/if.h>
#include <linux/can.h>

#ifndef PF_CAN
#define PF_CAN 29
#endif

#ifndef AF_CAN
#define AF_CAN PF_CAN
#endif

int main()
{
	int s;
	unsigned long nbytes,len;
	struct sockaddr_can addr;
	struct ifreq ifr;
	struct can_frame frame;


	s = socket(PF_CAN,SOCK_RAW,CAN_RAW);

	strcpy(ifr.ifr_name,"can0");
	ioctl(s,SIOCGIFINDEX,&ifr);
	printf("can0 can_ifindex = %x\n",ifr.ifr_ifindex);

	//bind to all enabled can interface
	addr.can_family = AF_CAN;
	addr.can_ifindex =0;
	bind(s,(struct sockaddr*)&addr,sizeof(addr));

	nbytes = recvfrom(s,&frame,sizeof(struct can_frame),0,(struct sockaddr *)&addr,&len);
	
	/*get interface name of the received CAN frame*/
	ifr.ifr_ifindex = addr.can_ifindex;
	ioctl(s,SIOCGIFNAME,&ifr);
	printf("Received a CAN frame from interface %s\n",ifr.ifr_name);
	printf("frame message\n"
		"--can_id = %x\n"
		"--can_dlc = %x\n"
		"--data = %s\n",frame.can_id,frame.can_dlc,frame.data);

	return 0;
}

/*参考文献*/
//1、CAN/GPRS车载网关设计与应用 张立国等
//2、对Socket CAN的理解（3）——【Socket CAN发送数据流程】 yuzeze
//3、对Socket CAN的理解（4）——【Socket CAN接收数据流程】 yuzeze