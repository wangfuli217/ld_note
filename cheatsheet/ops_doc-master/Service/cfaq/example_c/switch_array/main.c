#include <stdio.h>
#include <stdlib.h>

int 
main(int argc, char **argv)
{
	/* 使用字符作为数组的索引值 字符的ascii值 0 ~ 255 
	
	 * 这种方式可以替代switch方式*/
	char switch_array[256] = {0};
	
	char index_char = 'c';
	
	switch_array[index_char] = 'c';
	
	printf("switch_array[%c]: %c\n", index_char, switch_array[index_char]);
	
	int i = 100;
	
	switch (i) {
		case 100: { /* switch case 必须使用{} 才能定义local var */
			int j = 0;
			printf("j: %d\n", j); 
			break;
		}
		case 0: {
			int j = 1;
			printf("j: %d\n", j);
			break;
		}
		default:
			break;
	}
	
	
	system("pause");
	
	
	return 0;
}
