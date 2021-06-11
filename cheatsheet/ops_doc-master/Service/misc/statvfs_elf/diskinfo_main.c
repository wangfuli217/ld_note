/*************************************************************************
	> File Name: filetype_main.c
	> Author: suchao.wang
	> Mail: suchao.wang@advantech.com.cn 
	> Created Time: Fri 28 Nov 2014 06:40:08 PM CST
 ************************************************************************/

#include<stdio.h>
#include<stdlib.h>
#include <elf.h>
#include <unistd.h>
#include <fcntl.h>
#include <ctype.h>
#include <string.h>

#include "diskinfo.h"

int read_disk(const char *name)
{
	//pasre file header
	Elf32_Ehdr hdr;
	int fd = open(name, O_RDONLY);
	if (fd == -1)
	{
		perror(name);
		return 0;
	}
	read(fd, (void *) &hdr, sizeof(hdr));
	printf("\nfile:%s\n",name);
	printf("e_ident:");
	int i;
	for(i=0;i<EI_NIDENT;i++)
	{
		printf("%02x ", hdr.e_ident[i]);
	}
	printf("\n");
	for(i=0;i<EI_NIDENT;i++)
	{
		char c = hdr.e_ident[i];
		if(isalpha(c)||isdigit(c))
			printf("%c ", hdr.e_ident[i]);
	}
	printf("\n");
	printf("e_type:%u\n", hdr.e_type);
	printf("e_machine:%u\n", hdr.e_machine);
	printf("e_version:%u\n", hdr.e_version);
	printf("e_entry:0x%x\n", hdr.e_entry);
	printf("e_phoff:%u\n", hdr.e_phoff);
	printf("e_shoff:%u\n", hdr.e_shoff);
	printf("e_flags:%u\n", hdr.e_flags);
	printf("e_ehsize:%u\n", hdr.e_ehsize);
	printf("e_phentsize:%u\n", hdr.e_phentsize);
	printf("e_phnum:%u\n", hdr.e_phnum);
	printf("e_shentsize:%u\n", hdr.e_shentsize);
	printf("e_shnum:%u\n", hdr.e_shnum);
	printf("e_shstrndx:%u\n", hdr.e_shstrndx);

	//get section header string table
	Elf32_Shdr shdr;
	lseek(fd,hdr.e_shoff+hdr.e_shstrndx*hdr.e_shentsize,SEEK_SET);
	read(fd, (void *) &shdr, sizeof(shdr));
	lseek(fd,shdr.sh_offset,SEEK_SET);
	char *buf = (char *)malloc(shdr.sh_size);
	read(fd,buf,shdr.sh_size);

	//get section header table
	lseek(fd,hdr.e_shoff,SEEK_SET);

	size_t offset = 0,size = 0;
	size_t str_offset = 0,str_size = 0;
	//traversal section header
	for(i = 0;i<hdr.e_shnum;i++)
	{
		printf("\nseciotn:%d ",i);
		read(fd, (void *) &shdr, sizeof(shdr));
		printf("sh_name:%u ", shdr.sh_name);
		printf("name:%s\n", buf+shdr.sh_name);
		if(strcmp(buf+shdr.sh_name,"version_number") == 0)
		{
			offset = shdr.sh_offset;
			size = shdr.sh_size;
		}else if(strcmp(buf+shdr.sh_name,".strtab") == 0)
		{
			str_offset = shdr.sh_offset;
			str_size = shdr.sh_size;
		}
		printf("sh_type:%u ", shdr.sh_type);
		printf("sh_flags:%u ", shdr.sh_flags);
		printf("sh_addr:0x%x ", shdr.sh_addr);
		printf("sh_offset:0x%x ", shdr.sh_offset);
		printf("sh_size:%u ", shdr.sh_size);
		printf("sh_link:%u ", shdr.sh_link);
		printf("sh_info:%u ", shdr.sh_info);
		printf("sh_addralign:%u ", shdr.sh_addralign);
		printf("sh_entsize:%u\n", shdr.sh_entsize);
	}

	if(offset != 0)
	{
		lseek(fd, offset, SEEK_SET);
		char *buf1 = (char *) malloc(size);
		read(fd, buf1, size);
		printf("%s\n",buf1);
		free(buf1);
	}

	if (str_offset != 0)
	{
		int idx = 0;
		lseek(fd, str_offset, SEEK_SET);
		char *buf1 = (char *) malloc(str_size);
		read(fd, buf1, str_size);
		for(idx = 0;idx<str_size;idx += (strlen(buf1 + idx) +1))
			printf("%s\n", buf1 + idx);
		free(buf1);
	}


	free(buf);

	return 0;
}

int main(int argc,char *argv[])
{
	int i;

	//pasre all files
	for (i = 1; i < argc; i++)
	{
		read_disk(argv[i]);
	}
	return 0;
}


