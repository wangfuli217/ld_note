#include <unistd.h>

int main(void)
{
    if ((write(1, "Here is some data\n", 18)) != 18)
        write(2, "A write error has occurred on file descriptor 1\n",46);
	// ����ķ�����return 0�ĺ�����һ����
	//���ǣ�����Ϊ0��ʱ��return ����
	//exit �쳣
    exit(0);
}

