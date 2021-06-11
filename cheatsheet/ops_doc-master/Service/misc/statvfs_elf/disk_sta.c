#include <stdio.h>
#include <sys/statfs.h>
#include <sys/vfs.h>
#include <errno.h>
void show()
{
	struct statfs diskInfo;
	statfs("/", &diskInfo);
	unsigned long long totalBlocks = diskInfo.f_bsize;
	unsigned long long totalSize = totalBlocks * diskInfo.f_blocks;
	size_t mbTotalsize = totalSize>>20;
	unsigned long long freeDisk = diskInfo.f_bfree*totalBlocks;
	size_t mbFreedisk = freeDisk>>20;
	printf ("/  total=%dMB, free=%dMB\n", mbTotalsize, mbFreedisk);

	statfs("/boot", &diskInfo);
	totalBlocks = diskInfo.f_bsize;
	totalSize = totalBlocks * diskInfo.f_blocks;
	mbTotalsize = totalSize>>20;
	freeDisk = diskInfo.f_bfree*totalBlocks;
	mbFreedisk = freeDisk>>20;
	printf ("/boot  total=%dMB, free=%dMB\n", mbTotalsize, mbFreedisk);

	statfs("/dev/mmcblk0", &diskInfo);
	totalBlocks = diskInfo.f_bsize;
	totalSize = totalBlocks * diskInfo.f_blocks;
	mbTotalsize = totalSize>>20;
	freeDisk = diskInfo.f_bfree*totalBlocks;
	mbFreedisk = freeDisk>>20;
	printf ("/dev/mmcblk0  total=%dMB, free=%dMB\n", mbTotalsize, mbFreedisk);

}
int main(int argc, char *argv[])
{
    struct statfs disk_info;
    char *path = "/home/";
    int ret = 0;
    if (argc == 2)
    {
    	path = argv[1];
    }
    if (ret == statfs(path, &disk_info) == -1)
    {
    	fprintf(stderr,"Failed to get file disk infomation,errno:%u, reason:%s\n",errno,strerror(errno));
    	return -1;
    }
    long long total_size = disk_info.f_blocks * disk_info.f_bsize;
    long long available_size = disk_info.f_bavail * disk_info.f_bsize;
    long long free_size = disk_info.f_bfree * disk_info.f_bsize;
    //输出每个块的长度，linux下内存块为4KB
    printf("block size: %ld bytes\n", disk_info.f_bsize);
    //输出块个数
    printf("total data blocks: %ld \n", disk_info.f_blocks);
    //输出path所在磁盘的大小
    printf("total file disk size: %d MB\n",total_size >> 20);
    //输出非root用户可以用的磁盘空间大小
    printf("avaiable size: %d MB\n",available_size >> 20);
    //输出硬盘的所有剩余空间
    printf("free size: %d MB\n",free_size >> 20);
    //输出磁盘上文件节点个数
    printf("total file nodes: %ld\n", disk_info.f_files);
    //输出可用文件节点个数
    printf("free file nodes: %ld\n", disk_info.f_ffree);
    //输出文件名最大长度
    printf("maxinum length of file name: %ld\n", disk_info.f_namelen);

    show();
    return 0;
}
