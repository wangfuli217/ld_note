/*
  基本上进行的都是函数的接口测试；

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

#define CAPTURE_TO_FILE
#define FRAME_CONUTS 30 

unsigned int i;

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

struct buffer_t{
	void *start;
	size_t length;
};

struct vip {
	int fd;
	FILE *data_fd;
	int field;
	int count;
	struct image_params dst;
	struct vip * (*vip_open)(struct image_params *src);
	int (*vip_close)(struct vip *vip);
	int (*vip_init)(struct vip *vip, int num_buf);
	int (*vip_qbuf)(struct vip *vip, int index);
	int (*vip_dqbuf)(struct vip *vip);
	int (*stream_ON)(int fd, int type);
	int (*stream_OFF)(int fd, int type);
	int (*vip_get_ctrl)(int fd, struct v4l2_control * ctrl);
	int (*vip_set_ctrl)(int fd, struct v4l2_control * ctrl);
};

extern int vip_close(struct vip *vip);
extern int vip_init(struct vip *vip,int num_buf);
extern int vip_qbuf(struct vip *vip, int index);
extern int stream_ON(int fd, int type);
extern int stream_OFF(int fd, int type);
extern int vip_dqbuf(struct vip *vip);
extern struct vip *vip_open(struct image_params *src);
extern int vip_set_ctrl(int fd, struct v4l2_control * ctrl);
extern int vip_get_ctrl(int fd, struct v4l2_control * ctrl);
extern int read_frame (struct vip *vip);
extern struct buffer_t * buffers;
extern struct buffer_t * tmp_buffers;

#if 1
static void vip_open_test(void **state)
{

	char devname[20] = "/dev/video1";
	struct vip *p;
	
	p=test_calloc(6,4);
	assert_non_null(p);

	p->fd= open(devname, O_RDWR);		
	if((p->fd) < 0) 
	{
        printf("Can't open %s \n", devname);
	}

	else 
	{	
       printf("vip_open success!!!");     
	}

#ifdef CAPTURE_TO_FILE
    p->data_fd = fopen("yuv422.yuv","w");
	if(p->data_fd == NULL) 
	{
		printf ("fopen err\n");
		fclose(p->data_fd);	
		test_free(p);
        p = NULL;
	}
	else
	{ 
      printf ("fopen ok\n");
	  test_free(p);
      
	}
#endif
 
	p->vip_close = vip_close;
	p->vip_init = vip_init;
	p->vip_qbuf = vip_qbuf;
	p->vip_dqbuf = vip_dqbuf;
	p->stream_ON = stream_ON;
	p->stream_OFF = stream_OFF;
	p->vip_get_ctrl = vip_get_ctrl;
	p->vip_set_ctrl = vip_set_ctrl;
	printf("vip_open success!!! \n");

}
#endif

#if 1
static void vip_init_test(void **state)
{
	int ret = 0;
	struct vip * vip_p = vip_open(NULL); 
	if(!vip_p)
	{
		printf ("vip_open err \n");
	}
	else
		printf ("vip_open ok \n");

	ret = vip_p->vip_init(vip_p,6);   //调用原函数中的vip_init()函数,成功返回0；
	if(ret) 
	{
		printf ("vip_init err\n");
	}
	else
		printf ("vip_init ok\n");   
 	
}
#endif 

#if 1
static void vip_dqbuf_test(void **state)
{
	int ret = 0;
	struct vip * vip_p = vip_open(NULL); 
	if(!vip_p)
	{
		printf ("vip_open err \n");
	}
	else
		printf ("vip_open ok \n");

   for(i=0;i< 6;i++)
   {
		ret = vip_p->vip_qbuf(vip_p,i);
		if(ret) 
		{
			printf ("vip_qbuf err\n");
		}
	}
	printf ("vip_qbuf ok\n");	 
	
}
#endif 

#if 1
static void stream_ON_test(void **state)
{
	int ret = 0;
	struct vip * vip_p = vip_open(NULL); 
	if(!vip_p)
	{
		printf ("vip_open err \n");
	}
	else
		printf ("vip_open ok \n");
	
	ret = vip_p->stream_ON(vip_p->fd,V4L2_BUF_TYPE_VIDEO_CAPTURE);
	if(ret)
	{
		printf ("vip_init err\n");
	}
	
}
#endif 

#if 1
static void stream_OFF_test(void **state)
{
	int ret = 0;
	struct vip * vip_p = vip_open(NULL); 
	if(!vip_p)
	{
		printf ("vip_open err \n");
	}
	else
		printf ("vip_open ok \n");
	
	vip_p->stream_OFF(vip_p->fd,V4L2_BUF_TYPE_VIDEO_CAPTURE);
}
#endif

#if 1
static void read_frame_test(void **state)
{
	int count = 0;
	int ret = 0;
	
	struct vip * vip_p = vip_open(NULL);
	if(!vip_p) {
		printf ("vip_open err\n");
	}
	printf ("vip_open ok\n");
	
#ifdef CAPTURE_TO_FILE
	if (count < FRAME_CONUTS) {//如果可读，执行read_frame ()函数
		ret = read_frame (vip_p);
		count++;
	 } 
	 
#else	
	ret = read_frame (vip_p);
	if(ret < 0) {
		printf("capture failed.\n");
	}
#endif 
	
}
#endif

int main()
{
	const struct CMUnitTest tests[]={
    cmocka_unit_test(vip_open_test),
	cmocka_unit_test(vip_init_test),
	cmocka_unit_test(vip_dqbuf_test),
	cmocka_unit_test(stream_ON_test),
	cmocka_unit_test(stream_OFF_test),
	cmocka_unit_test(read_frame_test),

    };
	
	 return cmocka_run_group_tests(tests, NULL, NULL);
	
}
