
#include "exynos_4412.h"
#include "uart.h"
#include "mpu_6050.h"

/**********************************************************************
 *函数功能：延时函数
 **********************************************************************/
void mydelay_ms(int time)
{
	while(time--)
	{
	int i, j;
		for (i = 0; i < 5; i++)
			for (j = 0; j < 514; j++);
	}
}


/**********************************************************************
 * 函数功能：I2C向特定地址写一个字节
 * 输入参数：
 * 		slave_addr： I2C从机地址
 * 			  addr： 芯片内部特定地址
 * 			  data：写入的数据
**********************************************************************/

void iic_write (unsigned char slave_addr, unsigned char addr, unsigned char data)
{

	I2C5.I2CCON = I2C5.I2CCON | (1<<6) | (1<<5);	//设置I2C时钟预分配512、使能I2C中断
	I2C5.I2CSTAT |= 0x1<<4; 						//使能I2C串口输出

	I2C5.I2CDS = slave_addr<<1 ;				    //MPU6050-I2C地址+写位0
	I2C5.I2CSTAT = 0xf0;						    //主机发送模式 、使能I2C的发送和接受、发出开始信号
	while(!(I2C5.I2CCON & (1<<4)));  				//等待ACK周期后，中断挂起

	I2C5.I2CDS = addr;								//数据写入地址（MPU6050芯片内部地址）
	I2C5.I2CCON = I2C5.I2CCON & (~(1<<4));			//清除中断标志位
	while(!(I2C5.I2CCON & (1<<4)));					//等待ACK周期后，中断挂起

	I2C5.I2CDS = data;								//要写入的数据
	I2C5.I2CCON = I2C5.I2CCON & (~(1<<4));			//清除中断标志位
	while(!(I2C5.I2CCON & (1<<4)));					//等待ACK周期后，中断挂起

	I2C5.I2CSTAT = 0xD0; 							//发出停止信号
	               //1101 0000
	I2C5.I2CCON = I2C5.I2CCON & (~(1<<4));			//清除中断标志位
	mydelay_ms(10);									//延时等待I2C停止信号生效
}


/**********************************************************************
 * 函数功能：I2C从特定地址读取1个字节的数据
 * 输入参数：	slave_addr： I2C从机地址
 * 			  		  addr： 芯片内部特定地址
 * 返回参数： unsigned char： 读取的数值
**********************************************************************/

unsigned char iic_read(unsigned char slave_addr, unsigned char addr)
{

	unsigned char data = 0;

	I2C5.I2CCON = I2C5.I2CCON | (1<<6) | (1<<5);	//设置I2C时钟预分配512、使能I2C中断
	I2C5.I2CSTAT |= 0x1<<4; 						//使能I2C串口输出

	I2C5.I2CDS = slave_addr<<1;						//MPU6050-I2C地址+写位0
	I2C5.I2CSTAT = 0xf0;						    //主机发送模式 、使能I2C的发送和接受、发出开始信号
	while(!(I2C5.I2CCON & (1<<4)));					//等待ACK周期后，中断挂起

	I2C5.I2CDS = addr;								//读取数据的地址（MPU6050芯片内部地址）
	I2C5.I2CCON = I2C5.I2CCON & (~(1<<4));			//清除中断标志位
	while(!(I2C5.I2CCON & (1<<4)));					//等待ACK周期后，中断挂起


	I2C5.I2CCON = I2C5.I2CCON & (~(1<<4));			//清除中断标志位

	I2C5.I2CDS = slave_addr << 1 | 0x01;			//MPU6050-I2C地址+读位1
	I2C5.I2CSTAT = 0xb0;						    //主机接受模式 、使能I2C的发送和接受、发出开始信号
	while(!(I2C5.I2CCON & (1<<4)));					//等待ACK周期后，中断挂起



	I2C5.I2CCON = I2C5.I2CCON & (~(1<<7))&(~(1<<4));//禁止ACK信号、清除中断标志位
	while(!(I2C5.I2CCON & (1<<4)));					//等待ACK周期后，中断挂起
	data = I2C5.I2CDS;								//读取数据


	I2C5.I2CSTAT = 0x90;							//发出停止信号
	I2C5.I2CCON = I2C5.I2CCON & (~(1<<4));			//清除中断标志位
	mydelay_ms(10);									//延时等待I2C停止信号生效

	return data;									//返回读取的数值

}


/**********************************************************************
 * 函数功能：MPU6050初始化
**********************************************************************/

void MPU6050_Init ()
{
	iic_write(SlaveAddress, PWR_MGMT_1, 0x00); 		//设置使用内部时钟8M
	iic_write(SlaveAddress, SMPLRT_DIV, 0x07);		//设置陀螺仪采样率
	iic_write(SlaveAddress, CONFIG, 0x06);			//设置数字低通滤波器
	iic_write(SlaveAddress, GYRO_CONFIG, 0x18);		//设置陀螺仪量程+-2000度/s
	iic_write(SlaveAddress, ACCEL_CONFIG, 0x0);		//设置加速度量程+-2g
}



/**********************************************************************
 * 函数功能：主函数
 **********************************************************************/

int main(void)
{

	unsigned char zvalue_h,zvalue_l;						//存储读取结果
	short int zvalue;

	/*设置GPB_2引脚和GPB_3引脚功能为I2C传输引脚*/
	GPB.CON = (GPB.CON & ~(0xF<<12)) | 0x3<<12;			 	//设置GPB_3引脚功能为I2C_5_SCL
	GPB.CON = (GPB.CON & ~(0xF<<8))  | 0x3<<8;				//设置GPB_2引脚功能为I2C_5_SDA

	uart_init(); 											//初始化串口
	MPU6050_Init();											//初始化MPU6050

	printf("\n********** I2C test!! ***********\n");
	while(1)
	{
		zvalue_h = iic_read(SlaveAddress, GYRO_ZOUT_H);		//获取MPU6050-Z轴角速度高字节
		zvalue_l = iic_read(SlaveAddress, GYRO_ZOUT_L);		//获取MPU6050-Z轴角速度低字节
		zvalue  =  (zvalue_h<<8)|zvalue_l;					//获取MPU6050-Z轴角速度

		printf(" GYRO--Z  :Hex: %d	\n", zvalue);			//打印MPU6050-Z轴角速度
		mydelay_ms(100);
	}
	return 0;
}

