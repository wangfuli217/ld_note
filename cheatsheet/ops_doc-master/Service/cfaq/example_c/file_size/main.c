#include <stdio.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>
#include <stdlib.h>

#define file_name "function.js"


int getfilesize()
{
    int iresult;
    struct stat buf;
    iresult = stat(file_name,&buf);
    if(iresult == 0)
    {
        return buf.st_size;
    }
    return NULL;
}

int getfilesize02()
{
    int fp;
    
	fp = open(file_name, O_RDONLY);
    
	if(fp==-1) return 0;
	
    return lseek(fp,0,SEEK_END);
}

int getfilesize04()
{
    FILE *fp;
    if((fp=fopen(file_name,"r"))==NULL)
        return 0;
    fseek(fp,0,SEEK_END);
    return ftell(fp);    //return NULL;
}

int getfilesize05()
{
    FILE *fp;
    char str;
    if((fp = fopen(file_name,"r")) == NULL)
        return 0;

	int i;
	for (int i = 0; !feof(fp); i++) { /* 这里minigw实现有问题 */
        fread(&str, 1, 1, fp);
    }
	
//	while(str != EOF) {
//		str = fgetc(fp);
//		i++;
//	}
	
	fclose(fp);
	
    return i - 1;    //return NULL;
}

int main(int argc, char* argv[])
{
    
    printf("getfilesize()=%d\n",getfilesize());
    printf("getfilesize02()=%d\n",getfilesize02());
    printf("getfilesize04()=%d\n",getfilesize04());
    printf("getfilesize05()=%d\n",getfilesize05());
	
	system("pause");
    return 0;
}