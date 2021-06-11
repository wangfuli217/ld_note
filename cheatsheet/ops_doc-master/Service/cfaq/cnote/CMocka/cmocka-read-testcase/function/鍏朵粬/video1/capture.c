#include <stdio.h>
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

//#define CAPTURE_TWO_FILED
#define CAPTURE_TO_FILE
#define FRAME_CONUTS 30   //帧数
#define static 

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
struct buffer_t * buffers = NULL;
struct buffer_t * tmp_buffers = NULL;

unsigned int i;

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

/**
 *****************************************************************************
 * @brief:  close the device and free memory
 *
 * @param:  vip  struct vip pointer （参数）
 *
 * @return: 0 on success
 *****************************************************************************
*/
static int vip_close(struct vip *vip)
{
	for (i = 0; i < 6; i++)
		munmap(buffers[i].start, buffers[i].length);
	close(vip->fd);
	free(buffers);
	
	for (i = 0; i < 2; i++) {
		free(tmp_buffers[i].start);
	}
	free(tmp_buffers);
	fsync(fileno(vip->data_fd));
	fclose(vip->data_fd);
	free(vip);
	return 0;
}

/**
 *****************************************************************************
 * @brief:  Intialize the vip output by calling set_control, set_format,
 *	        refbuf ioctls
 *
 * @param:  vip  struct vip pointer
 *
 * @return: 0 on success
 *****************************************************************************
*/
static int vip_init(struct vip *vip,int num_buf)
{
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
	memset(&fmt, 0, sizeof fmt);
	fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
	if(!vip) {
		printf(" cheeck param\n");
		return (-1);
	}
	ret = ioctl(vip->fd, VIDIOC_G_FMT, &fmt);
	if (ret < 0) {
		printf( "vip: G_FMT failed: %s\n", strerror(errno));
		return (ret);
	}
	printf( "vip: G_FMT ok\n");
	fmt.fmt.pix.width = vip->dst.width;
	fmt.fmt.pix.height = vip->dst.height;
	fmt.fmt.pix.pixelformat = vip->dst.fourcc;

	ret = ioctl(vip->fd, VIDIOC_S_FMT, &fmt);
	if (ret < 0) {
		printf( "vip: S_FMT failed: %s\n", strerror(errno));
		return (ret);
	}
	printf( "vip: S_FMT ok\n");

	ret = ioctl(vip->fd, VIDIOC_G_FMT, &fmt);
	if (ret < 0) {
		printf( "vip: G_FMT after set format failed: %s\n", strerror(errno));
		return (ret);
	}
	printf( "vip: G_FMT ok\n");
	printf("vip: G_FMT(start): width = %u, height = %u, 4cc = %.4s\n",
			fmt.fmt.pix.width, fmt.fmt.pix.height,
			(char*)&fmt.fmt.pix.pixelformat);

	memset(&rqbufs, 0, sizeof(rqbufs));
	rqbufs.count = vip->dst.numbuf;
	rqbufs.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
	rqbufs.memory = V4L2_MEMORY_MMAP;

	ret = ioctl(vip->fd, VIDIOC_REQBUFS, &rqbufs);
	if (ret < 0) {
		printf( "vip: REQBUFS failed: %s\n", strerror(errno));
		return (ret);
	}
	printf( "vip: REQBUFS ok\n");
	if (rqbufs.count != 6) {
		/* You may need to free the buffers here. */
		printf("Not enough buffer memory\n");
		ret = -1;
		return ret;
	}
    
	//分配内存
	buffers = calloc(rqbufs.count, sizeof(*buffers));
	if(!buffers) {
		printf( "calloc failed\n");
		return (-1);
	}
	printf( "vip: calloc  buffers ok\n");

#ifdef 	CAPTURE_TWO_FILED
	tmp_buffers = calloc(2,sizeof(*tmp_buffers));
	if(!tmp_buffers) {
		printf( "tmp_buffers calloc failed\n");
		ret =-1;
		return (ret);
	}
	printf( "vip: calloc  tmp_buffers ok\n");
#endif

	for (i = 0; i < rqbufs.count; i++) {
		struct v4l2_buffer v4_buffer;

		memset(&v4_buffer, 0, sizeof(v4_buffer));
		v4_buffer.type = rqbufs.type;
		v4_buffer.memory = V4L2_MEMORY_MMAP;
		v4_buffer.index = i;
		ret = ioctl (vip->fd, VIDIOC_QUERYBUF, &v4_buffer);
		if (ret < 0 ) {
			printf("VIDIOC_QUERYBUF failed");
			return (ret);
		}

		buffers[i].length = v4_buffer.length; /* remember for munmap() */

		buffers[i].start = mmap(NULL, v4_buffer.length,
					PROT_READ | PROT_WRITE, /* recommended */
					MAP_SHARED,             /* recommended */
					vip->fd, v4_buffer.m.offset);

		if (MAP_FAILED == buffers[i].start) {
			/* If you do not exit here you should unmap() and free()
			   the buffers mapped so far. */
			ret =-1;
			printf("mmap fialed\n");
		}
	}

#ifdef 	CAPTURE_TWO_FILED
	for(i = 0;i < 2; i++) {
		tmp_buffers[i].start = malloc(buffers[i].length*sizeof(char));
		tmp_buffers[i].length = buffers[i].length;
		if(!tmp_buffers[i].start) {
			printf("alloc tmp buf failed\n");
			return (-1);
		}
	}
#endif

	printf("vip: allocated buffers = %d\n", rqbufs.count);
	return ret;

}

/**
 *****************************************************************************
 * @brief:  queue buffer to vip output
 *
 * @param:  vip  struct vpe pointer
 * @param:  index  buffer index to queue
 *
 * @return: 0 on success
 *****************************************************************************
*/
static int vip_qbuf(struct vip *vip, int index)
{
	int ret = 0;
	struct v4l2_buffer buf;
	printf("vip  buffer queue\n");
	memset(&buf, 0, sizeof buf);
	buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
	buf.memory = V4L2_MEMORY_MMAP;
	buf.index = index;
	ret = ioctl(vip->fd, VIDIOC_QBUF, &buf);
	if (ret < 0) {
			printf( "vip o/p: QBUF failed: %s, index = %d\n",
				strerror(errno), index);
			return (ret);
	}
	printf("vip i/p: QBUF index = %d.", buf.index);
	return (ret);
}

/**
 *****************************************************************************
 * @brief:  start stream
 *
 * @param:  fd  device fd
 * @param:  type  buffer type (CAPTURE or OUTPUT)
 *
 * @return: 0 on success
 *****************************************************************************
*/
static int stream_ON(int fd, int type)
{
	int ret = 0;

	ret = ioctl(fd, VIDIOC_STREAMON, &type);
	if (ret < 0) {
		printf("STREAM ON failed,  %d: %s\n", type, strerror(errno));
		return (ret);
	}

	printf("stream ON: done! fd = %d,  type = %d\n", fd, type);

	return (ret);
}

/**
 *****************************************************************************
 * @brief:  stop stream
 *
 * @param:  fd  device fd
 * @param:  type  buffer type (CAPTURE or OUTPUT)
 *
 * @return: 0 on success
 *****************************************************************************
*/
static int stream_OFF(int fd, int type){
	int ret = 0;

	ret = ioctl(fd, VIDIOC_STREAMOFF, &type);
	if (ret < 0) {
		printf("STREAMOFF failed, %d: %s\n", type, strerror(errno));
		return (ret);
	}

	printf("stream OFF: done! fd = %d,  type = %d\n", fd, type);

	return (ret);
}

/**
 *****************************************************************************
 * @brief:  dequeue vpe input buffer
 *
 * @param:  vpe  struct vpe pointer
 *
 * @return: buf.index index of dequeued buffer
 *****************************************************************************
*/
static int vip_dqbuf(struct vip *vip)
{
	int ret = 0;
	struct v4l2_buffer buf;
	printf("vip output dequeue buffer.");

	memset(&buf, 0, sizeof buf);
	buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
	buf.memory = V4L2_MEMORY_MMAP;
	ret = ioctl(vip->fd, VIDIOC_DQBUF, &buf);
	if (ret < 0) {
		printf("vip i/p: DQBUF failed: %s.", strerror(errno));
		return (ret);
	}

	printf("vip i/p: DQBUF index = %d.", buf.index);

	return buf.index;
}

/**
 *****************************************************************************
 * @brief:  start stream
 *
 * @param:  fd  device fd
 * @param:  type  buffer type (CAPTURE or OUTPUT)
 *
 * @return: 0 on success
 *****************************************************************************
*/
static int vip_set_ctrl(int fd, struct v4l2_control * ctrl)
{
	int ret = 0;
	struct v4l2_control *control = ctrl;
	if(control == NULL) {
		ret = -1;
		return (ret);
	}

	if(control->value < 0) {
			control->value = 0;
	}

	if (control->value > 127) {
			control->value = 127;
	}

	ret = ioctl(fd, VIDIOC_S_CTRL, control);
	if (ret < 0) {
		printf("set contrast printf.");
		return (ret);
	}

	return (ret);
}

static int vip_get_ctrl(int fd, struct v4l2_control * ctrl)
{
	int ret = 0;
	struct v4l2_control *control = ctrl;
	if(control == NULL) {
		ret = -1;
		return (ret);
	}

	ret = ioctl(fd, VIDIOC_G_CTRL, control);
	if (ret < 0) {
		printf("get ctrl: printf.");
		return (ret);
	}

	if((control->value < 0) || (control->value > 127)) {
		printf("get ctrl value out of the limits.");
		ret = -1;
		return (-1);
	}
	return (ret);
}

/**
 *****************************************************************************
 * @brief:  open the device
 *
 * @return: vip  struct vip pointer
 *****************************************************************************
*/
struct vip *vip_open(struct image_params *src)
{
	//char devname[20] = "/dev/video1";
	char devname[200] = "/mnt/hgfs/share/test/dev/a.txt";
	struct vip *vip;

	vip = calloc(1, sizeof(*vip));  //对指针vip进行初始化
	if(!vip) {
			printf("calloc vip failed!!!\n");
			return vip;
	}
	vip->fd =  open(devname, O_RDWR);
    if(vip->fd < 0) {
        printf("Can't open %s\n", devname);
        free (vip);
        vip = NULL;
        return (vip);
	}

    printf("vip:%s open success!!!\n", devname);

#ifdef CAPTURE_TO_FILE
	vip->data_fd = fopen("yuv422.yuv","w");
	if(vip->data_fd == NULL) {
		printf ("fopen err\n");
		close(vip->fd);
		free (vip);
        vip = NULL;
        return (vip);
	}
	printf ("fopen ok\n");
#endif

#ifdef CAPTURE_TWO_FILED
	vip->data_fd = fopen("filee_yuv422.yuv","w");
	if(vip->data_fd == NULL) {
		printf ("fopen err\n");
		close(vip->fd);
		free (vip);
        vip = NULL;
        return (vip);
	}
	printf ("fopen ok\n");
#endif 

	vip->vip_close = vip_close;
	vip->vip_init = vip_init;
	vip->vip_qbuf = vip_qbuf;
	vip->vip_dqbuf = vip_dqbuf;
	vip->stream_ON = stream_ON;
	vip->stream_OFF = stream_OFF;
	vip->vip_get_ctrl = vip_get_ctrl;
	vip->vip_set_ctrl = vip_set_ctrl;
	return vip;
}

static int read_frame(struct vip *vip)
{
	int ret = 0;
	ret = vip->vip_dqbuf(vip);
	if(ret< 0 || ret > 6) {
		printf("dqbuf error\n");
		return -1;
	}

#ifdef CAPTURE_TO_FILE
	printf("%s buffers[ret].length = %d\n",__FUNCTION__,buffers[ret].length);
	fwrite(buffers[ret].start, buffers[ret].length, 1, vip->data_fd); //将其写入文件中
	fsync(fileno(vip->data_fd));
#endif /*CAPTURE_TO_FILE*/

#ifdef CAPTURE_TWO_FILED
	if(vip->count < 2) {
		memcpy(tmp_buffers[vip->count].start,buffers[ret].start,tmp_buffers[vip->count].length);
	}
	if(vip->count > 2) {
		if(vip->count % 2) {
			fwrite(tmp_buffers[0].start, tmp_buffers[0].length, 1, vip->data_fd); //将其写入文件中
			fsync(fileno(vip->data_fd));
		} else {
			fwrite(tmp_buffers[1].start, tmp_buffers[1].length, 1, vip->data_fd); //将其写入文件中
			fsync(fileno(vip->data_fd));
		}
	}
	vip->count++;
#endif 

	ret = vip->vip_qbuf(vip,ret);
	if(ret< 0) {
		printf("qbuf error\n");
		return -1;
	}
	return 1;
}

int main1(int argc,char *argv[])
{
	int ret = 0;
	int count = 0;
	fd_set fds;
	struct timeval tv;
	int r;
	struct vip * vip_p = vip_open(NULL);
	if(!vip_p) {
		printf ("vip_open err\n");
		return -1;
	}
	printf ("vip_open ok\n");

	ret = vip_p->vip_init(vip_p,6);
	if(ret) {
		printf ("vip_init err\n");
		return ret;
	}
	printf ("vip_init ok\n");
	for(i=0;i< 6;i++) {
		ret = vip_p->vip_qbuf(vip_p,i);
		if(ret) {
			printf ("vip_qbuf err\n");
			return ret;
		}
	}
	printf ("vip_qbuf ok\n");
	ret = vip_p->stream_ON(vip_p->fd,V4L2_BUF_TYPE_VIDEO_CAPTURE);
	if(ret) {
		printf ("vip_init err\n");
		return ret;
	}
	for (;;) {/*这一段涉及到异步IO*/
	FD_ZERO (&fds);           //将指定的文件描述符集清空
	FD_SET (vip_p->fd, &fds); //在文件描述符集合中增加一个新的文件描述符
	
	/* Timeout */
	tv.tv_sec = 2;
	tv.tv_usec = 0;

	r = select (vip_p->fd + 1, &fds, NULL, NULL, &tv);//判断是否可读（即摄像头是否准备好），tv是定时
	if (-1 == r) {
		if (EINTR == errno)
		 continue;
		printf ("select err\n");
	}
	if (0 == r) {
		fprintf (stderr, "select timeout\n");
		exit (EXIT_FAILURE);
	}
	
	/*缺少FD_ISSET(vip_p, &fds) 判断是否可读 */
#ifdef CAPTURE_TO_FILE
	if (count < FRAME_CONUTS) {//如果可读，执行read_frame ()函数
		ret = read_frame (vip_p);
		count++;
	 } else {
	   break;
	}
#else	
#ifdef CAPTURE_TWO_FILED
	if (count < FRAME_CONUTS) {//如果可读，执行read_frame ()函数
		ret = read_frame (vip_p);
		count++;
	 } else {
	   break;
	}
#else
	ret = read_frame (vip_p);
	if(ret < 0) {
		printf("capture failed.\n");
		break;
	}
#endif 

#endif
	}
	vip_p->stream_OFF(vip_p->fd,V4L2_BUF_TYPE_VIDEO_CAPTURE);
	vip_p->vip_close(vip_p);
	return 0;
}
