#include<stdio.h>
#include<string.h>
int my_strcat(char* S1,char* S2){
	int i=0,j=0;
	while('\0'!=*(S1+i)){
		i++;
	}
	while('\0'!=*(S2+j)){
		*(S1+i)=*(S2+j);
		i++;
		j++;
	}
	*(S1+i)='\0';
}
int my_strlen(char* S){
	int i=0;
	while('\0'!=*(S+i)){
		i++;
	}
	return i;
}
const char* my_strstr(const char* S1,const char* S2){
	int i=0,flag=0;
//	char* p=S1;
	while('\0'!=*(S1+i)){
		if(*(S1+i)==*S2){
			flag=i;
			int j=0;
			while('\0'!=*(S2+j)&&*(S1+i)==*(S2+j)){
				i++;
				j++;
			}
			if('\0'==*(S2+j)){
				return S1+flag;
			}
		}else
			i++;
	}
	return NULL;
}
int main(int argc, const char *argv[])
{
	char S1[100]="123";
	char S2[10]="456";
	my_strcat(S1,S2);
	printf("%s\n",S1);
	printf("%d\n",my_strlen(S1));
	printf("%d\n",strlen(S1));
	printf("%s\n",strstr(S1,S2));
	printf("%s\n",my_strstr(S1,S2));
	return 0;
}
