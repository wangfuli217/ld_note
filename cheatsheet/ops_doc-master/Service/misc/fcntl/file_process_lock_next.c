#include "lock_header.h"

//file_process_lock_next  
int main()  {  
    int fd = open(FILE_PATH, O_RDWR | O_CREAT, FILE_MODE);  

    cout<<"file_process_lock_next wait file_process_lock_prev..."<<endl; 
    writew_lock(fd);  
    cout<<"file_process_lock_next got writew_lock..."<<endl;  
    unlock(fd);  
  
    return 0;  
}  
/* ���ر��ļ�������ʱ������ļ��������йص��������ͷţ�ͬ��ͨ��dup�����õ����ļ�������Ҳ�ᵼ��������� */