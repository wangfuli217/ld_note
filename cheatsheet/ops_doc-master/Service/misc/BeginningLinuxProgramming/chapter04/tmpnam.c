#include <stdio.h>

//------------�д�ѧϰ	-------------------------//
int main(void)
{
    char tmpname[L_tmpnam];
    char *filename; 
    FILE *tmpfp;
	int icnt;
	int 	tmp;

	//����һ����һ�޶�����ʱ�ļ�
    tmp = mkstemp(tmpname);
	

	for(icnt=0;icnt<L_tmpnam;icnt++)
	{
		printf("%02x",tmpname[icnt]);
	}
    printf("Temporary file name is: %d\n", tmp);

    tmpfp = tmpfile();
    if(tmpfp)
        printf("Opened a temporary file OK\n");
    else
        perror("tmpfile");
    exit(0);
}
