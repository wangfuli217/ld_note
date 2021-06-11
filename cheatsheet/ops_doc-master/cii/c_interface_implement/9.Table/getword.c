#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>
#include "getword.h"


//fist = isalpha
//rest = isalpha || c == '_' 
int getword(FILE *fp, char *buf, int size, 
			int (*first)(int c), int (*rest)(int c))
{
	int i = 0,c;
	
	assert(fp && buf && size > 1 && first && rest);	
	c = getc(fp);
	for (;c != EOF; c = getc(fp))
	{
		//�ַ����㿪ʼ����,��ʼ�洢�ַ� 
		if(first(c))
		{
			if (i < size - 1)
			{
				buf[i] = c;
				i++;
			}
			c = getc(fp);
			break;		
		}
	}
	//�ַ����������� 
	for (; c != EOF && rest(c); c = getc(fp))
	{
		if (i < size - 1)
		{
			buf[i] = c;
			i++;
		}
		//i >= size���ַ�����fp����ȡ�£���δ���档
		//��abbcc��size̫С��Ϊabb����֤word��������ȫȥ������֤��һ��word��ȷ 
	}
	if (i < size)
		buf[i] = '\0';
	else
		buf[size - 1] = '\0'; 
	if ( c != EOF)
		ungetc(c,fp);	//������rest���ϣ��黹���ļ��� 
	return i; //�ɼ������ַ����� 

}
