#include "exynos_4412.h"

/*****ͨ����ѯ��ʽ��ⰴ��*****/
#if 0
void main(void)
{
	/*��GPX1_1���ó����빦��*/
	GPX1.CON = GPX1.CON & (~(0xF << 4));
	/*��GPX2_7�ܽ����ó��������*/
	GPX2.CON = GPX2.CON & (~(0xf << 28)) | (1 << 28);

	while(1)
	{
		/*GPX1_1����Ϊ�ߵ�ƽ*/
		if(GPX1.DAT & (1 << 1))
			/*LED��*/
			GPX2.DAT = GPX2.DAT | (1 << 7);
		/*GPX1_1����Ϊ�͵�ƽ*/
		else
			/*LED��*/
			GPX2.DAT = GPX2.DAT & (~(1 << 7));
	}
}
#endif

/*****ͨ���жϷ�ʽ��ⰴ��*****/

//ʹ���ж���Ҫ�����������
//1.�����Σ��������ε��жϹ���ʹ�ж��ܹ������жϹ�����
//2.GIC��Σ��������ȼ���Ŀ��CPU���������״̬��
//3.CPU���,�ж����ȼ����εȹ���

//�жϹ�������ͳһ�����ж���Ҫ�漰�ж����ȼ����жϹ����жϽ����ĸ�CPUȥ���������

/*****1.ʵ��Ŀ�ģ�ͨ���жϷ�ʽ��ⰴ���Ƿ��²����жϷ�������д������*****/

/*****2.ʵ�鲽�裺���ҵ�·ͼ�ҳ������봦�������ĸ��ܽ�����*****/

unsigned int Num;

void do_irq(void)
{
	unsigned int irq_num;

	/*ȥGIC�ж�ȡ��ǰ�жϵ��жϺ�,ͬʱGIC�н���Ӧ���жϱ�Ϊ����ִ�е�״̬*/
	irq_num = CPU0.ICCIAR & 0x3FF;

	/*�ж����ĸ��ж�Ȼ�������Ӧ���жϷ���*/
	switch(irq_num)
	{
		case 57:
			Num ++;
			if(Num % 2)
				GPX2.DAT = GPX2.DAT | (1 << 7);
			else
				GPX2.DAT = GPX2.DAT & (~(1 << 7));

			/*�������ε��жϹ����־λ���  д1��0*/
			EXT_INT41_PEND = 0x2;
			/*��GIC�����57���жϵ��жϹ����־λ����  д1��0*/
			ICDICPR.ICDICPR1 = 0x2000000;
			break;
		case 58:
			break;
		case 59:
			break;
		default:
			break;
	}
	/*���жϺ�д�ص�GIC֪ͨGIC���Խ��µ��ж����뵽������*/
	CPU0.ICCEOIR = CPU0.ICCEOIR & (~(0X3FF << 0)) | irq_num;
}

void main(void)
{
	/*****������*****/
	/*1.��GPX1_1�ܽ����ó��жϹ���*/
	GPX1.CON = GPX1.CON | (0xF << 4);
	/*2.����GPX1_1�ܽ��жϴ�����ʽΪ�½��ش���*/
	EXT_INT41_CON = EXT_INT41_CON & (~(0x7 << 4)) | (0x2 << 4);
	/*3.ʹ��GPX1_1�ܽŵ��ж�ʹ���ܹ�˳������GIC�жϿ�����*/
	EXT_INT41_MASK =  EXT_INT41_MASK & (~(1 << 1));

	/*****CPU���*****/
	/*4.ȫ��ʹ���ж��ź��ܹ�ͨ����Ӧ��CPU�ӿڵ�����Ӧ�Ĵ�����ICCICR_CPU0��ÿ��CPU��Ӧһ����Ӧ�ļĴ���*/
	CPU0.ICCICR = CPU0.ICCICR | 1;
	/*5.�����ж����ȼ����μĴ���ICCPMR_CPU0��ʹ���е��ж϶���ͨ��CUP�ӿڵ��ﴦ����*/
	CPU0.ICCPMR = CPU0.ICCPMR | 0xFF;

	/*****GIC���*****/
	/*6.ȫ��ʹ��GICʹGIC���ź��ܵ���CPU�ӿ� ICDDCR*/
	ICDDCR = ICDDCR | 1;
	/*7.���жϹ������д���Ӧ��λʹ��GPX1_1�ܽŵ��жϣ�57��ICDISER*/
	ICDISER.ICDISER1 = ICDISER.ICDISER1 | (1 << 25);
	/*8.��57���ж�ָ������Ӧ�Ĵ�����ȥ����ICDIPTR*/
	ICDIPTR.ICDIPTR14 = ICDIPTR.ICDIPTR14 & (~(0xFF << 8)) | (0x1 << 8);

	/*��GPX2_7�ܽ����ó��������*/
	GPX2.CON = GPX2.CON & (~(0xf << 28)) | (1 << 28);

	while(1)
	{

	}
}
