#include<stdio.h>
void bubble(int *arr,int len){
    int i=0,j=0,tmp=0,flag=1;
    for(i=0;i<len-1;i++){
        for(j=0;j<len-1-i;j++){
            if(*(arr+j)>*(arr+j+1)){
                tmp=*(arr+j);
                *(arr+j)=*(arr+j+1);
                *(arr+j+1)=tmp;
                flag=0;
            }
        }
        if(1==flag) break;
    }
}
void insert(int *arr,int len){
    int i=0,j=0,tmp=0;
    for(i=1;i<len;i++){
        tmp=*(arr+i);
        for(j=i;*(arr+j-1)>tmp&&j>=1;j--){
            *(arr+j)=*(arr+j-1);
        }
        if(j!=i) *(arr+j)=tmp;
    }
}
void select(int *arr,int len){
    int i=0,j=0,tmp=0,min=0;
    for(i=0;i<len-1;i++){
        min=i;
        for(j=i;j<len;j++){
            if(*(arr+min)>*(arr+j)){
                min=j;
            }
        }
        if(min!=i){
            tmp=*(arr+i);
            *(arr+i)=*(arr+min);
            *(arr+min)=tmp;
        }
    }

}
void quick(int* left,int* right){
    if(left>=right)
        return;
    int* i=left;
    int* j=right;
    int key=*i;
    while(i<j){
        if(key<=*j){
            j--;
        }
        *i=*j;
        if(key>=*i){
            i++;
        }
        *j=*i;
    }
    *i=key;
    quick(left,i-1);
    quick(i+1,right);
}
int main(){
    int iData_a[9]={30,5,20,10,15,20,8,25,12},i=0;
//  bubble(iData_a,9);
//  insert(iData_a,9);
//  select(iData_a,9);
    quick(iData_a,iData_a+9);
    printf("排序后的元素依次是：\n");
    for(i=0;i<9;i++){
        printf("%d ",*(iData_a+i));
    }
    printf("\n");
}