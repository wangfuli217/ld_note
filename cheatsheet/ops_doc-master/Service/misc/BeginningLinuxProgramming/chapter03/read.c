#include <unistd.h>


//----------------------------------------------------
// ��ȡ��׼�����������Ϣ������Ϣ���
//���ɴ��������
//----------------------------------------------------
int main(void)
{
    char buffer[128];
    int nread;
		
	//��˾���ڽ���Ĵ�ӡ��Ϣ������ͨ����ȡ����ģ�Ȼ�󽫶�ȡ����Ϣ���͵�
	//����Ĵ����С�
    nread = read(0, buffer, 128);
    if (nread == -1)
        write(2, "A read error has occurred\n", 26);

	/*�����ǰ������ֵ����128���ֽڣ���ô�����Ժ���ֽ���Ϊ��������*/
    if ((write(1,buffer,nread)) != nread)
        write(2, "A write error has occurred\n",27);

    exit(0);
}

