#include "exynos_4412.h"
#include "debug.h"
int main()
{
	/* 使能rtc */
	RTCCON|=(0x1);
	detobin(RTCCON);
	RTC.BCDYEAR=(0x016);
	RTC.BCDMON=(0x11);
	RTC.BCDDAY=(0x22);
	RTC.BCDHOUR=(0x15);
	RTC.BCDMIN=(0x06);
	RTC.BCDSEC=(0x0);
	
	volatile unsigned int orgSec=RTC.BCDSEC;
	while(1){
		volatile unsigned int sec=RTC.BCDSEC;
		if(orgSec!=sec){
			printf("2%03x-%02x-%02x %02x:%02x:%02x\n",RTC.BCDYEAR,RTC.BCDMON,RTC.BCDDAY,RTC.BCDHOUR,RTC.BCDMIN,RTC.BCDSEC);
			orgSec=sec;
		}
	}
	return 0;
}
