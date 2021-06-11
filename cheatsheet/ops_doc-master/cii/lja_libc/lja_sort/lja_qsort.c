#include  "lja_qsort.h"

void lja_qsort_arry(void *arry, int step, int begin, int end,\
		int (*cmp)(void *a, void * b), void (*swap)(void *a, void *b))
{
	assert(NULL != arry);
	assert(step > 0);
	assert(begin >= 0);
	assert(end >= 0);
	assert(NULL != cmp);
	assert(NULL != swap);

	int q;
	while (begin < end){
		q = lja_qsort_part_arry(arry, step, begin, end, cmp, swap);
		if(q-1 > begin){
			lja_qsort_arry(arry, step, begin, q-1, cmp, swap);
		}
		begin = q + 1;  /*消除尾递归*/
	}
}

int lja_qsort_part_arry(void *arry, int step, int begin, int end,\
		int (*cmp)(void *a, void *b), void (*swap)(void *a, void *b))
{
	assert(NULL != arry);
	assert(step > 0);
	assert(begin >= 0);
	assert(end > 0);
	assert(NULL != cmp);
	assert(NULL != swap);
	
	int rad = begin + random()%(end - begin);
	void *key = arry + step * end;  //分划值
	swap(arry + rad * step, key);

	int r1 = begin;   //第一个位于分划值右边的元素
	int cur = begin;
	void *pcur;
	void *pr1;  //分划值右边的第一个元素

	if(begin == end){
		return begin;
	}
	//把小于分划值的成员放置到数组的开始处
	for(cur = begin; cur < end; cur++){
		pcur = arry + cur * step;
		if(-1 == cmp(pcur, key)){
			if(cur != r1){
				pr1 = arry + step * r1;
				swap(pcur,pr1);
			}
			r1++;
		} 
	}
	if(r1 != end){
		pr1 = arry + step * r1;
		swap(pr1,key);
	}
	return r1;   //分划值的位置
}
