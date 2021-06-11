#include <stdio.h>
#include <config.h>
void sayHello(void){
	printf("hello word!!\n");
	printf("PACKAGE:%s\n",PACKAGE);
	printf("PACKAGE_BUGREPORT:%s\n",PACKAGE_BUGREPORT);
	printf("PACKAGE_NAME:%s\n",PACKAGE_NAME);
	printf("PACKAGE_STRING:%s\n",PACKAGE_STRING);
	printf("PACKAGE_TARNAME:%s\n",PACKAGE_TARNAME);
	printf("PACKAGE_URL:%s\n",PACKAGE_URL);
	printf("PACKAGE_VERSION:%s\n",PACKAGE_VERSION);
	printf("VERSION:%s\n",VERSION);
}
