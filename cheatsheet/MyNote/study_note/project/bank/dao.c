#include "dao.h"
int generator_id(void)			//生成账号ID
{
	int id=100000;
	int fd=-1;
	if(!access("./dao/id.dat",F_OK))
	{
		fd=open("./dao/id.dat",O_RDWR);
		if(fd==-1)
			perror("open"),exit(-1);
	}
	else
	{
		fd=open("./dao/id.dat",O_RDWR|O_CREAT|O_EXCL,0644);
		if(-1==fd)
			perror("open"),exit(-1);
		write(fd,&id,sizeof(int));
		return id;
	}
	ftruncate(fd,sizeof(int));
	void *pm=mmap(NULL,sizeof(int),PROT_READ|PROT_WRITE,MAP_SHARED,fd,SEEK_SET);
	int *pt=(int *)pm;
	*pt+=1;
	id=*pt;
	munmap(pm,sizeof(int));
	close(fd);
	return id;
}
int re_write_to_acc(Account *pa,int flag)	//将账户信息重新写入账户文件中
{
	int fd=open("./dao/account.dat",O_RDWR);
	if(fd==-1)
	{
		perror("open1");
		return -1;
	}
	struct stat st={};
	fstat(fd,&st);
	void *pm=mmap(NULL,st.st_size,PROT_READ|PROT_WRITE,MAP_SHARED,fd,SEEK_SET);
	if(pm==MAP_FAILED)
	{
		perror("MAP_FAILED");
		return -1;
	}
	int f=0;
	Account *ps=(Account *)pm;
	Account *po=(Account *)pm;
	for(;(void *)ps-pm<st.st_size;ps++)
	{
		if(ps->id==pa->id)
		{
			switch(flag)
			{
				case STAT_LOGOUT:
					ps->stat=STAT_LOGOUT;
					break;
				case M_SAVE:
					ps->balance=pa->balance;
					break;
				case M_TAKE:
					ps->balance=pa->balance;
					break;
				case M_TRAN:
					for(;(void*)po-pm<st.st_size;po++)
					{
						if(po->id==pa->id1)
						{
							f=1;
							po->balance+=ps->balance-pa->balance;
							break;
						}
					}
					if(f==0)
						return -1;
					ps->balance=pa->balance;
					return 0;
				default:break;
			}
			munmap(pm,st.st_size);
			close(fd);
			return 0;
		}
	}
}
int write_to_acc(Account *pm)	//将账户信息写入账户文件中
{
	int fd=-1;
	if(!access("./dao/account.dat",F_OK))
	{
		fd=open("./dao/account.dat",O_RDWR);
		if(-1==fd)
			perror("open"),exit(-1);
	}
	else
	{
		fd=open("./dao/account.dat",O_RDWR|O_CREAT,0644);
		if(-1==fd)
			perror("open"),exit(-1);
	}
	lseek(fd,0,SEEK_END);
	int res=write(fd,pm,sizeof(Account));
	close(fd);
	if(-1==res)
		return -1;
	return 0;
}
int find(Account *pa)				//寻找指定的账号
{
	int fd=open("./dao/account.dat",O_RDONLY);
	if(fd==-1)
	{
		perror("open1");
		return -1;
	}
	struct stat st={};
	fstat(fd,&st);
	void *pm=mmap(NULL,st.st_size,PROT_READ,MAP_SHARED,fd,SEEK_SET);
	if(pm==MAP_FAILED)
	{
		perror("MAP_FAILED");
		return -1;
	}
	Account *ps=(Account *)pm;
	for(;(void *)ps-pm<st.st_size;ps++)
	{
		if(ps->id==pa->id)
		{
			if(!strcmp(pa->passwd,ps->passwd)&&ps->stat!=STAT_LOGOUT)
			{
				*pa=*ps;
				munmap(pm,st.st_size);
				close(fd);
				return 0;
			}
			else
			{
				munmap(pm,st.st_size);
				close(fd);
				return -1;
			}
		}
	}
	munmap(pm,st.st_size);
	close(fd);
	return -1;
}
