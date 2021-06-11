#include <limits.h>		/* for CHAR_BIT */

#define BITMASK(b) (1 << ((b) % CHAR_BIT))
#define BITSLOT(b) ((b) / CHAR_BIT)
#define BITSET(a, b) ((a)[BITSLOT(b)] |= BITMASK(b))
#define BITCLEAR(a, b) ((a)[BITSLOT(b)] &= ~BITMASK(b))
#define BITTEST(a, b) ((a)[BITSLOT(b)] & BITMASK(b))
#define BITNSLOTS(nb) ((nb + CHAR_BIT - 1) / CHAR_BIT)

声明一个47位的"数组"
char bitarray[BITNSLOTS(47)];

置第23位
BITSET(bitarray, 23);

测试第35位
if(BITTEST(bitarray, 35)) ...

计算两个位数组的并，再将结果放入另一个数组
for(i = 0; i < BITNSLOTS(47); i++)
		array3[i] = array1[i] | array2[i];
要计算交集使用 &。

for(i = 0; i < BITNSLOTS(nb); i++)
	set3[i] = set1[i] | set2[i];

// 筛选法计算素数的快速实现
#include <stdio.h>
#include <string.h>

#define MAX 10000

int main()
{
	char bitarray[BITNSLOTS(MAX)];
	int i, j;

	memset(bitarray, 0, BITNSLOTS(MAX));

	for(i = 2; i < MAX; i++) {
		if(!BITTEST(bitarray, i)) {
			printf("%d\n", i);
			for(j = i + i; j < MAX; j += i)
				BITSET(bitarray, j);
		}
	}
	return 0;
}
