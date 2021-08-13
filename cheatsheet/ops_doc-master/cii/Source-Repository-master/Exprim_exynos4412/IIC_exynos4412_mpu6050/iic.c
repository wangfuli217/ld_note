
#include "exynos_4412.h"
#include "uart.h"
#include "mpu_6050.h"

/**********************************************************************
 *�������ܣ���ʱ����
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
 * �������ܣ�I2C���ض���ַдһ���ֽ�
 * ���������
 * 		slave_addr�� I2C�ӻ���ַ
 * 			  addr�� оƬ�ڲ��ض���ַ
 * 			  data��д�������
**********************************************************************/

void iic_write (unsigned char slave_addr, unsigned char addr, unsigned char data)
{

	I2C5.I2CCON = I2C5.I2CCON | (1<<6) | (1<<5);	//����I2Cʱ��Ԥ����512��ʹ��I2C�ж�
	I2C5.I2CSTAT |= 0x1<<4; 						//ʹ��I2C�������

	I2C5.I2CDS = slave_addr<<1 ;				    //MPU6050-I2C��ַ+дλ0
	I2C5.I2CSTAT = 0xf0;						    //��������ģʽ ��ʹ��I2C�ķ��ͺͽ��ܡ�������ʼ�ź�
	while(!(I2C5.I2CCON & (1<<4)));  				//�ȴ�ACK���ں��жϹ���

	I2C5.I2CDS = addr;								//����д���ַ��MPU6050оƬ�ڲ���ַ��
	I2C5.I2CCON = I2C5.I2CCON & (~(1<<4));			//����жϱ�־λ
	while(!(I2C5.I2CCON & (1<<4)));					//�ȴ�ACK���ں��жϹ���

	I2C5.I2CDS = data;								//Ҫд�������
	I2C5.I2CCON = I2C5.I2CCON & (~(1<<4));			//����жϱ�־λ
	while(!(I2C5.I2CCON & (1<<4)));					//�ȴ�ACK���ں��жϹ���

	I2C5.I2CSTAT = 0xD0; 							//����ֹͣ�ź�
	               //1101 0000
	I2C5.I2CCON = I2C5.I2CCON & (~(1<<4));			//����жϱ�־λ
	mydelay_ms(10);									//��ʱ�ȴ�I2Cֹͣ�ź���Ч
}


/**********************************************************************
 * �������ܣ�I2C���ض���ַ��ȡ1���ֽڵ�����
 * ���������	slave_addr�� I2C�ӻ���ַ
 * 			  		  addr�� оƬ�ڲ��ض���ַ
 * ���ز����� unsigned char�� ��ȡ����ֵ
**********************************************************************/

unsigned char iic_read(unsigned char slave_addr, unsigned char addr)
{

	unsigned char data = 0;

	I2C5.I2CCON = I2C5.I2CCON | (1<<6) | (1<<5);	//����I2Cʱ��Ԥ����512��ʹ��I2C�ж�
	I2C5.I2CSTAT |= 0x1<<4; 						//ʹ��I2C�������

	I2C5.I2CDS = slave_addr<<1;						//MPU6050-I2C��ַ+дλ0
	I2C5.I2CSTAT = 0xf0;						    //��������ģʽ ��ʹ��I2C�ķ��ͺͽ��ܡ�������ʼ�ź�
	while(!(I2C5.I2CCON & (1<<4)));					//�ȴ�ACK���ں��жϹ���

	I2C5.I2CDS = addr;								//��ȡ���ݵĵ�ַ��MPU6050оƬ�ڲ���ַ��
	I2C5.I2CCON = I2C5.I2CCON & (~(1<<4));			//����жϱ�־λ
	while(!(I2C5.I2CCON & (1<<4)));					//�ȴ�ACK���ں��жϹ���


	I2C5.I2CCON = I2C5.I2CCON & (~(1<<4));			//����жϱ�־λ

	I2C5.I2CDS = slave_addr << 1 | 0x01;			//MPU6050-I2C��ַ+��λ1
	I2C5.I2CSTAT = 0xb0;						    //��������ģʽ ��ʹ��I2C�ķ��ͺͽ��ܡ�������ʼ�ź�
	while(!(I2C5.I2CCON & (1<<4)));					//�ȴ�ACK���ں��жϹ���



	I2C5.I2CCON = I2C5.I2CCON & (~(1<<7))&(~(1<<4));//��ֹACK�źš�����жϱ�־λ
	while(!(I2C5.I2CCON & (1<<4)));					//�ȴ�ACK���ں��жϹ���
	data = I2C5.I2CDS;								//��ȡ����


	I2C5.I2CSTAT = 0x90;							//����ֹͣ�ź�
	I2C5.I2CCON = I2C5.I2CCON & (~(1<<4));			//����жϱ�־λ
	mydelay_ms(10);									//��ʱ�ȴ�I2Cֹͣ�ź���Ч

	return data;									//���ض�ȡ����ֵ

}


/**********************************************************************
 * �������ܣ�MPU6050��ʼ��
**********************************************************************/

void MPU6050_Init ()
{
	iic_write(SlaveAddress, PWR_MGMT_1, 0x00); 		//����ʹ���ڲ�ʱ��8M
	iic_write(SlaveAddress, SMPLRT_DIV, 0x07);		//���������ǲ�����
	iic_write(SlaveAddress, CONFIG, 0x06);			//�������ֵ�ͨ�˲���
	iic_write(SlaveAddress, GYRO_CONFIG, 0x18);		//��������������+-2000��/s
	iic_write(SlaveAddress, ACCEL_CONFIG, 0x0);		//���ü��ٶ�����+-2g
}



/**********************************************************************
 * �������ܣ�������
 **********************************************************************/

int main(void)
{

	unsigned char zvalue_h,zvalue_l;						//�洢��ȡ���
	short int zvalue;

	/*����GPB_2���ź�GPB_3���Ź���ΪI2C��������*/
	GPB.CON = (GPB.CON & ~(0xF<<12)) | 0x3<<12;			 	//����GPB_3���Ź���ΪI2C_5_SCL
	GPB.CON = (GPB.CON & ~(0xF<<8))  | 0x3<<8;				//����GPB_2���Ź���ΪI2C_5_SDA

	uart_init(); 											//��ʼ������
	MPU6050_Init();											//��ʼ��MPU6050

	printf("\n********** I2C test!! ***********\n");
	while(1)
	{
		zvalue_h = iic_read(SlaveAddress, GYRO_ZOUT_H);		//��ȡMPU6050-Z����ٶȸ��ֽ�
		zvalue_l = iic_read(SlaveAddress, GYRO_ZOUT_L);		//��ȡMPU6050-Z����ٶȵ��ֽ�
		zvalue  =  (zvalue_h<<8)|zvalue_l;					//��ȡMPU6050-Z����ٶ�

		printf(" GYRO--Z  :Hex: %d	\n", zvalue);			//��ӡMPU6050-Z����ٶ�
		mydelay_ms(100);
	}
	return 0;
}
