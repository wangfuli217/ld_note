#include<stdio.h>
#include<stdlib.h>

#define max 100000

//函数声明
void Print(int heap[]);
void Choose(int choice,int heap[]);
void HeapSort(int heap[],int length);
void CreateHeap(int heap[],int length);
void sift(int heap[],int k,int m);
void PrintHeap(int heap[],int length);

//主函数
int main()
{
    int heap[max];
	system("color a");
	Print(heap);
	while(true)
	{
	   printf("Press enter to continue.........");
	   getchar();
	   getchar();
	   system("cls");
	   Print(heap);
	}
	return 0;
}

///////////////////////////////////////////////////////////////////////////////
//菜单函数
void Print(int heap[])
{
	int choice;
	printf("Made By 杨梅树的盔甲~O(∩_∩)O~\n");
	printf("---------------------\n");
	printf("使用说明:本程序可实现堆排序算法.\n");
	printf("---------------------\n");
	printf("1.输入一个新序列并进行最大堆排序.\n");
	printf("2.输出当前堆的序列（顺序、逆序）.\n");
	printf("3.按其它任意键退出.\n");
	printf("---------------------\n");

	printf("请选择你要的操作:");
	scanf("%d",&choice);
	Choose(choice,heap);
}
///////////////////////////////////////////////////////////////////////////////
//功能函数
void Choose(int choice,int heap[])
{
    int n,i;
	switch(choice)
	{
		case 1:
				printf("请输入序列的个数:");
				scanf("%d",&n);
				printf("请依次输入将要进行堆排序排序的序列的元素:\n");
				for(i=1;i<=n;i++)
					scanf("%d",&heap[i]);
				heap[0]=n;
				HeapSort(heap,n);
		   break;
		case 2:
				printf("从小到大排序:\n");
		   PrintHeap(heap,heap[0]);
		   break;
		default:
		   exit(0);
	}
}
///////////////////////////////////////////////////////////////////////////////
//输入一个新序列并进行最大堆排序函数
void HeapSort(int heap[],int length)
//对heap[1...n]进行堆排序，执行本算法后，heap中记录按关键字由小到大有序排列
{
    int temp;
    int i,n;
    CreateHeap(heap,length);
    n=length;
    for(i=n;i>=2;--i)
    {
        temp=heap[1];//将堆顶记录和堆中的最后一个记录互换
        heap[1]=heap[i];
        heap[i]=temp;
        sift(heap,1,i-1);//进行调整，使heap[1...i-1]变成堆
    }
}

void CreateHeap(int heap[],int length)
//对记录数组heap建堆，length为数组长度，length==heap[0]
{
    int i;
    int n;
    n=length;
    for(i=n/2;i>=1;--i)
        sift(heap,i,n);
}

void sift(int heap[],int k,int m)
//假设heap[k...m]是以heap[k]为根的完全二叉树且分别以heap[2k]和heap[2k+1]为根的
//左、右子树为大根堆，调整heap[k]，使整个序列heap[k...m]满足堆的性质
{
    int i,j,finished;
    int temp;
    temp=heap[k];//暂存“根”记录heap[k]
    i=k;
    j=2*i;
    finished=false;
    while(j<=m&&!finished)
    {
        if(j<m&&heap[j]<heap[j+1]) j=j+1;
        //若存在右子树，且右子树根的关键字大，则沿右分支“筛选”
        if(temp>=heap[j])finished=true;//筛选完毕
        else
        {
            heap[i]=heap[j];
            i=j;
            j=2*i;
        }//继续筛选
    }
    heap[i]=temp;//填入到恰当位置
}

void PrintHeap(int heap[],int length)
{
    int i;
    for(i=1;i<=length;i++)
        printf("%d ",heap[i]);
    printf("\n");
}