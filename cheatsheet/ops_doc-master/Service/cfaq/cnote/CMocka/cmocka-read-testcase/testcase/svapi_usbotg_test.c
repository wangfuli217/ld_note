/*
 * @file  svapi_usb_otg.c
 * @brief provide API to get/set usb mode
 */

#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <string.h>
#include <stdlib.h>
#include <stdarg.h>
#include <stddef.h>
#include <setjmp.h>
#include <cmocka.h>


#define BUF_SIZE 16
static int fd_otg = -1;

/*文件在g6s板上的路径*/
static char *usb0_otg_mode = "/sys/devices/platform/soc/ee080200.usb-phy/role";

static int svapi_otg_set_mode(const char *port, const char *mode)
{
	int ret = -1;
        int count=0;
	int value = -1;
	char buf[BUF_SIZE] = {0};
	char *path_otg_mode;

	/*Pass parameters */
	if (strcmp(port, "usb0") == 0) {
		path_otg_mode = usb0_otg_mode;
		printf("success\n");
	} else {
		printf("please select usb otg port usb0\n");
		return -1;
	}

    	fd_otg = open(path_otg_mode, O_WRONLY);
        printf("fd_otg=%d\n",fd_otg);
	if (fd_otg < 0)
		return -1;
    
	/*Pass parameters */
	if (strcmp(mode, "host") != 0 && strcmp(mode, "peripheral") != 0) {
		printf("set usb mode (host or peripheral) failed\n");
	}
	printf("mode = %s \n", mode);

	snprintf(buf, BUF_SIZE, "%s", mode);
        printf("buf = %s \n", buf);
	count = strlen(buf);
        printf("count = %d \n", count);
	ret = write(fd_otg, buf, count);           
        printf("ret = %d \n", ret);
        if(ret==-1)
           perror("Write the reason for the failure ");
	if (ret == count && count != 0) 
        {
		printf("write success\n");
                close(fd_otg);
		return 0;
	}

	close(fd_otg);

	return -1;
}

//static int svapi_otg_get_mode(const char *port, char *mode)
static int svapi_otg_get_mode(const char *port)
{
	check_expected_ptr(port);
 
        char *mode=malloc(20);
        int ret = -1;
	char buf[BUF_SIZE] = {0};
	char *path_otg_mode;             //uninitialized 

	if (strcmp(port, "usb0") == 0) {
		path_otg_mode = usb0_otg_mode;
                printf("success\n");
	} else {
		printf("please select usb otg port usb0 \n");
		return -1;
	}

	fd_otg = open(path_otg_mode, O_RDWR);
        printf("fd_otg=%d\n",fd_otg);
	if (fd_otg < 0)
		return -1;
        

	ret = read(fd_otg, buf, BUF_SIZE);
        printf("ret=%d\n",ret);
	if (ret < 0)
		 perror("read the reason for the failure ");


	//buf[BUF_SIZE-1] = '\0';
	snprintf(mode, BUF_SIZE, "%s", buf);  // It's easy to Segmentation fault
	close(fd_otg);

	return 0;

	close(fd_otg);

}

static void svapi_otg_set_test(void **state){

   /*Pass the correct parameters */	
    //svapi_otg_set_mode("usb0","host");
    svapi_otg_set_mode("usb0","peripheral");
	
   /*Pass the wrong parameters */   	
   // svapi_otg_set_mode("usb0","OS");
   // svapi_otg_set_mode("usb","OS");
    
#if 0 
     expect_string(svapi_otg_get_mode,port,"usb0");
     expect_string(svapi_otg_get_mode,mode,NULL);   
     svapi_otg_get_mode("usb0",NULL);
#endif
     expect_string(svapi_otg_get_mode,port,"usb0");
     svapi_otg_get_mode("usb0");
}


int main(void){
	
const struct CMUnitTest tests[]={
	
	cmocka_unit_test(svapi_otg_set_test),
};
	return cmocka_run_group_tests(tests,NULL,NULL); 
}
