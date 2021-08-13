/*
  
  该结论是自己在测试期间发现的问题，并不一定是正确的。
  
*/

#include <stdio.h>
#include <stdarg.h>
#include <stddef.h>
#include <setjmp.h>
#include <cmocka.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <getopt.h>
#include <fcntl.h>
#include <unistd.h>
#include <errno.h>
#include <malloc.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/time.h>
#include <sys/mman.h>
#include <sys/ioctl.h>

#include <asm/types.h>
#include <linux/videodev2.h>
#include <linux/v4l2-controls.h>

struct image_params {
	int width;
	int height;
	int fourcc;
	int size;
	int size_uv;
	int coplanar;
	enum v4l2_colorspace colorspace;
	int numbuf;
};

struct vip {
	int fd;
	FILE *data_fd;
	int field;
	int count;
	struct image_params dst;
	int (*vip_init)(struct vip *vip, int num_buf);
};

/*
有两点需要说明：

1.这里传递了两个参数，虽然会有警告，但是不影响结果。

2.其中一个参数是结构体指针,对于指针vip来说，struct vip *vip只是定义但是没有初始化;
  而后 vip->dst.width 等处就直接使用了vip，这种情况一定会出现“断错误”提示。
  然而测试的结果却没有出现段错误--passed.
  
  因为有cmocka_unit_test()是用test函数来初始化CMUnitTest结构体的。
  在这个过程中，它把test()的参数也进行了初始化，究竟怎么初始化的不得而知。
  但是从测试结果来看一定是进行了初始化，否则肯定会出现段错误。

*/

static void vip_init_test(void **state)
//static void vip_init_test(struct vip *vip,int num_buf)
{    
	struct vip *vip;
	int num_buf;
	
    int ret = 0;
	struct v4l2_format fmt;
	struct v4l2_requestbuffers rqbufs;
	
	#if 1
	vip->dst.width = 720;
	vip->dst.height = 240;
	#else
	vip->dst.width = 1280;
	vip->dst.height = 720;
	#endif
	
	vip->dst.fourcc = V4L2_PIX_FMT_YUYV;
	vip->dst.numbuf = num_buf;

}

int main()
{
	const struct CMUnitTest tests[]={
	cmocka_unit_test(test),
    };
	
	 return cmocka_run_group_tests(tests, NULL, NULL);
	
}