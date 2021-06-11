#include "exynos_4412.h"

void Delay_ms(unsigned int Time)
{
	unsigned int i,j;

	for(i=0;i<Time;i++)
		for(j=0;j<3000;j++);
}

int main(void)
{
	GPX2.CON = GPX2.CON & (~(0xF << 28)) | (0x1 << 28);  
	GPX2.PUD = GPX2.PUD & (~(0x3 << 14)) | (0x3 << 14); 

	GPX1.CON = GPX1.CON & (~(0xF << 0)) | (0x1 << 0);
	GPX1.PUD = GPX1.PUD & (~(0x3 << 0)) | (0x3 << 0);

	GPF3.CON = GPF3.CON & (~(0xF << 16)) | (0x1 << 16);
	GPF3.PUD = GPF3.PUD & (~(0x3 << 8)) | (0x3 << 8);

	GPF3.CON = GPF3.CON & (~(0xF << 20)) | (0x1 << 20);
	GPF3.PUD = GPF3.PUD & (~(0x3 << 10)) | (0x3 << 10);

	while(1)
	{
		GPX2.DAT = GPX2.DAT & (~(0x1 << 7 )) | (0x1 << 7 ); 
		GPX1.DAT = GPX1.DAT & (~(0x1 << 0 )) | (0x0 << 0 );
		GPF3.DAT = GPF3.DAT & (~(0x1 << 4 )) | (0x0 << 4 );
		GPF3.DAT = GPF3.DAT & (~(0x1 << 5 )) | (0x0 << 5 );
		Delay_ms(100);

		GPX2.DAT = GPX2.DAT & (~(0x1 << 7 )) | (0x0 << 7 );  
		GPX1.DAT = GPX1.DAT & (~(0x1 << 0 )) | (0x1 << 0 );
		GPF3.DAT = GPF3.DAT & (~(0x1 << 4 )) | (0x0 << 4 );
		GPF3.DAT = GPF3.DAT & (~(0x1 << 5 )) | (0x0 << 5 );
		Delay_ms(100);

		GPX2.DAT = GPX2.DAT & (~(0x1 << 7 )) | (0x0 << 7 );  
		GPX1.DAT = GPX1.DAT & (~(0x1 << 0 )) | (0x0 << 0 );
		GPF3.DAT = GPF3.DAT & (~(0x1 << 4 )) | (0x1 << 4 );
		GPF3.DAT = GPF3.DAT & (~(0x1 << 5 )) | (0x0 << 5 );
		Delay_ms(100);

		GPX2.DAT = GPX2.DAT & (~(0x1 << 7 )) | (0x0 << 7 );  
		GPX1.DAT = GPX1.DAT & (~(0x1 << 0 )) | (0x0 << 0 );
		GPF3.DAT = GPF3.DAT & (~(0x1 << 4 )) | (0x0 << 4 );
		GPF3.DAT = GPF3.DAT & (~(0x1 << 5 )) | (0x1 << 5 );
		Delay_ms(100);

		GPX2.DAT = GPX2.DAT & (~(0x1 << 7 )) | (0x0 << 7 );  
		GPX1.DAT = GPX1.DAT & (~(0x1 << 0 )) | (0x0 << 0 );
		GPF3.DAT = GPF3.DAT & (~(0x1 << 4 )) | (0x1 << 4 );
		GPF3.DAT = GPF3.DAT & (~(0x1 << 5 )) | (0x0 << 5 );
		Delay_ms(100);

		GPX2.DAT = GPX2.DAT & (~(0x1 << 7 )) | (0x0 << 7 );  
		GPX1.DAT = GPX1.DAT & (~(0x1 << 0 )) | (0x1 << 0 );
		GPF3.DAT = GPF3.DAT & (~(0x1 << 4 )) | (0x0 << 4 );
		GPF3.DAT = GPF3.DAT & (~(0x1 << 5 )) | (0x0 << 5 );
		Delay_ms(100);
	}
	return 0;
}
