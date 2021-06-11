#include<stdio.h>
int ish(int arr[][9])
{
	int row=0,col=0,i=0;
	for(row=0;row<9;row++)
		for(col=0;col<9;col++)
			for(i=col+1;i<9;i++)
			{
				if(arr[row][i]==arr[row][col]) return 0;
			}
	return 1;
}
int iss(int arr[][9])
{
	int row=0,col=0,i=0;
	for(col=0;col<9;col++)
		for(row=0;row<9;row++)
			for(i=row+1;i<9;i++)
			{
				if(arr[i][col]==arr[row][col])  return 0;
			}
	return 1;
}
int isj(int arr[][9])
{
	int row=0,col=0,i=0,j=0;
	int del[9][2]={-1,-1,-1,0,-1,1,0,-1,0,0,0,1,1,-1,1,0,1,1};
	for(row=1;row<9;row+=3)
		for(col=1;col<9;col+=3)
			for(i=0;i<9;i++)
				for(j=i+1;j<9;j++)
					if(arr[row+del[i][0]][col+del[i][1]]==arr[row+del[j][0]][col+del[j][1]])  
						return 0;
	return 1;
}
int main()
{
    int arr[9][9]={0};
	int row=0,col=0,val=0;
	while(1) {
		scanf("%d",&row);
		if(row<0)
			break;
		scanf("%d%d",&col,&val);
		scanf("%*[^\n]");
		scanf("%*c");
		arr[row-1][col-1]=val;
	}
	
	if(ish(arr)&&iss(arr)&&isj(arr))
		for(row=0;row<9;row++) 
		{
			for(col=0;col<9;col++) 
				printf("%d ",arr[row][col]);
			printf("\n");
		}
	return 0;
}
