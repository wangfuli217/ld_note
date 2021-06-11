#include<stdio.h>
//----线性查找----
int find(int arr[],int size,int data){
    int i=0;
    for(i=0;i<size;i++){
        if(data==arr[i]){
            //返回对应的下标
            return i;
        }
    }
    return -1;//下标不可能是负数
}
//----二分法查找----
int find_binary(int arr[],int left,int right,int data){
    if(left<=right){    //当数组中只有一个元素时left==right
    int middle=(left+right)/2;
        if(arr[middle]==data){
            return middle;
        }else if(arr[middle]<data){
            return find_binary(arr,middle+1,right,data);
        }else{
            return find_binary(arr,middle-1,left,data);
        }
    }
    return -1;  //表示查找失败
}

int main(){
    int arr[9]={10,20,30,40,50,60,70,80,90};
//  int res=find(arr,9,900);
    int res=find_binary(arr,0,8,90);
    if(-1!=res){    
        printf("查找成功,该元素下标是:%d\n",res);
    }else{
        printf("查找失败,该元素不存在\n");
    }
    return 0;
}