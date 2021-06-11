//映射的建立和删除
#include<stdio.h>
#include<sys/mman.h>
#include<stdlib.h>

int main(void)
{
	//使用mmap建立到物理内存的映射
	void *p=mmap(NULL,4,PROT_READ|PROT_WRITE,MAP_PRIVATE|MAP_ANONYMOUS,0,0);
	if(p==MAP_FAILED)
		perror("mmap"),exit(-1);
	//使用映射的内存地址
	*(int *)p=5;
	printf("%d\n",*(int *)p);
	//删除映射
	int res=munmap(p,4);
	if(res==-1)
		perror("munmap"),exit(-1);
	printf("解除映射成功\n");
	return 0;
}
