#include<stdio.h>
#include<stdlib.h>
int GetNumPos(int num,int pos)
{
	int p=1;
	while(pos-1)
		{
			pos--;
			p*=10;
		}
	return num/p%10;
}
void shellsort(int *p_arr,int size)    //希尔排序
{
	int gap=0;
	int i=0;
	int j=0,temp=0;
	for(gap=size/2;gap>0;gap/=2)	//gap为增量，不断地缩小再用直接插入法排序
		for(i=gap;i<size;i+=gap)
			if(p_arr[i]<p_arr[i-gap])
			{
				temp=p_arr[i];
				j=i-gap;
				while(j>=0&&temp<p_arr[j])
				{
					p_arr[j+gap]=p_arr[j];
					j-=gap;
				}
				p_arr[j+gap]=temp;
			}
}
void radixsort(int *p_arr,int size)  //基数排序
{
	int *p_index[10]={};
	int i=0,j=0;
	int index=0;
	int temp=0,temp1=0;
	for(i=0;i<10;i++)
		p_index[i]=(int *)calloc(sizeof(int),size+1);	//分配sizeof(int)个连续的长度为size+1的内存空间
	for(i=1;i<11;i++)
	{
		for(j=0;j<size;j++)
		{
			index=GetNumPos(*(p_arr+j),i);
			temp=++p_index[index][0];
			p_index[index][temp]=*(p_arr+j);
		}
		temp1=0;
		for(j=0;j<10;j++)
		{
			for(temp=1;temp<=p_index[j][0];temp++)
				p_arr[temp1++]=p_index[j][temp];
			p_index[j][0]=0;
		}
	}
	for(i=0;i<10;i++)
	{
		free(p_index[i]);
		p_index[i]=NULL;
	}
}
void quicksort(int *p_arr,int l,int r)	//快速排序
{
	int i=l,j=r;
	int temp=p_arr[i];
	while(i<j)
	{
		while(i<j&&p_arr[j]>temp)
				j--;
		if(i<j)
			p_arr[i++]=p_arr[j];
		while(i<j&&p_arr[i]<=temp)
			i++;
		if(i<j)
			p_arr[j--]=p_arr[i];
	}
	p_arr[i]=temp;
	if(l<i-1)
		quicksort(p_arr,l,i-1);
	if(i+1<r)
		quicksort(p_arr,i+1,r);
}
void mercp(int *p_arr,int begin,int mid,int end)
{
	int *p_temp=(int *)calloc(sizeof(int),end-begin+1);
	int i=begin,j=end,m=mid+1;
	int k=0;
	while(i<=mid&&m<=j)
		if(p_arr[i]>p_arr[m])
			p_temp[k++]=p_arr[m++];
		else
			p_temp[k++]=p_arr[i++];
	while(i<=mid)
		p_temp[k++]=p_arr[i++];
	while(m<=j)
		p_temp[k++]=p_arr[m++];
	k=0;
	for(i=begin;i<=end;i++)
		p_arr[i]=p_temp[k++];
	free(p_temp);
	p_temp=NULL;
}
void mrgesort(int *p_arr,int begin,int end)	//归并排序
{
	if(begin<end)
	{
		int mid=(begin+end)/2;
		mrgesort(p_arr,begin,mid);
		mrgesort(p_arr,mid+1,end);
		mercp(p_arr,begin,mid,end);
	}
}
void countsort(int *p_arr,int size,int max)		//计数排序
{
	int *p_temp=(int *)calloc(sizeof(int),size);
	int *p_count=(int *)calloc(sizeof(int),max+1);
	int i=0;
	for(i=0;i<size;i++)
		p_count[p_arr[i]]++;
	for(i=1;i<=max;i++)
		p_count[i]+=p_count[i-1];
	for(i=0;i<size;i++)
	{
		int value=p_arr[i];
		p_temp[--p_count[value]]=value;
	}
	for(i=0;i<size;i++)
		p_arr[i]=p_temp[i];
	free(p_count);
	p_count=NULL;
	free(p_temp);
	p_temp=NULL;
}
void insesort(int *p_arr,int size)		//插入排序
{
	int i=0,temp=0,j=0;
	for(i=1;i<size;i++)  
			if(p_arr[i]<p_arr[i-1])
			{
				temp=p_arr[i];
				j=i-1;
				while(temp<p_arr[j])
				{
					p_arr[j+1]=p_arr[j];
					j--;
					if(j<0) break;
				}
				p_arr[j+1]=temp;
			}
}
void bubblesort(int *p_arr,int size)	//冒泡排序
{
	int i=0,j=0,temp=0,f=0;
	for(i=0;i<size-1;i++)
	{
		f=0;
		for(j=0;j<size-i-1;j++)
			if(p_arr[j]>p_arr[j+1])
			{
				temp=p_arr[j];
				p_arr[j]=p_arr[j+1];
				p_arr[j+1]=temp;
				f=1;
			}
		if(!f)
			break;
	}
}
void chosort(int *p_arr,int size)		//选择排序
{
	int i=0,j=0,temp=0;
	for(i=0;i<size-1;i++)
		for(j=i+1;j<size;j++)
			if(p_arr[j]<p_arr[i])
			{
				temp=p_arr[i];
				p_arr[i]=p_arr[j];
				p_arr[j]=temp;
			}
}
void heapAdjust(int *arr,int i,int len)
{
    int nChild;
    for(;i<=(len/2-1);i=nChild)
    {
        nChild=2*i+1;
        if(nChild<len-1&&arr[nChild+1]>arr[nChild]) nChild++;
        if(arr[nChild]>arr[i])
        {
			arr[nChild]^=arr[i];
			arr[i]^=arr[nChild];
            arr[nChild]^=arr[i];
        }
        else
            break;
    }
}
void heapSort(int *arr,int len)		//堆排序
{
	int i;
    for(i=len/2-1;i>=0;--i)
        heapAdjust(arr,i,len);
    for(i=len-1;i>0;--i)
    {
        arr[0]^=arr[i];
		arr[i]^=arr[0];
		arr[0]^=arr[i];
        heapAdjust(arr,0,i);
    }
}
int main()
{
	int arr[]={1,10,2,9,3,8,5,7,4,6};
	int i=0;
//	chosort(arr,10);		//选择排序	每一轮比对当前位置的数与后面数相比,将比当前位置数小的数放入当前位置,不稳定排序
//	bubblesort(arr,10);		//冒泡排序	每一轮比对相邻两个数,将较大的数往后移,就像冒泡一样,稳定排序
//	insesort(arr,10);		//插入排序	从第二个数开始与之前面的数相比,若较小,则继续向前比较,找到自己的位置后插入,稳定排序
//	quicksort(arr,0,9);		//快速排序	选取一个基数,大于基数的值放入右边,小于基数的值放入左边,找到基数值应在的位置,将基数插入对应位置,即分割这个序列,然后分别对左边和右边递归,不稳定排序
//	radixsort(arr,10);		//基数排序	对每个数取个位放入在堆上申请对应的数组中,然后按顺序获取数组中的元素,再获取十位,百位...只适用于整数,稳定排序
//	shellsort(arr,10);		//希尔排序	是插入排序的一种,也称缩小增量排序,上面的插入排序的增量是1,通过不断地缩小增量,当增量为1时,整个文件被分为一组,排序结束,不稳定排序
//	mrgesort(arr,0,9);		//归并排序,将已有序的子序列排序,得到完全有充的序列,采用分治法,将2个子序列合并成一个完整序列,递归且会在堆上申请空间,稳定排序
	//countsort(arr,10,10);	//计数排序,要知道整个序列的最大值,在堆上申请空间,将每个值作为下标,累加小于这个下标的所有值,利用元素的值来确定他们在实际输出中的位置稳定排序
	heapSort(arr,10);		//堆排序,不稳定排序,先建立一个堆,如大顶堆,不停地交换根部与底部再调整堆即可获得排序的数组
	for(i=0;i<10;i++)
		printf("%d ",arr[i]);
	printf("\n");
	return 0;
}
//假定在待排序的记录序列中，存在多个具有相同的关键字的记录，若经过排序，这些记录的相对次序保持不变，即在原序列中，ri=rj，且ri在rj之前，而在排序后的序列中，ri仍在rj之前，则称这种排序算法是稳定的；否则称为不稳定的。
