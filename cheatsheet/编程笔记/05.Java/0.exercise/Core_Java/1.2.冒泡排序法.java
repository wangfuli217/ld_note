
冒泡排序法：
//按从大到小的排序
int tmp = a[0];
for (int i=0; i < a.length; i++){
    for (int j=0; j < a.length - i -1; j++){
        if (a[j] < a[j+1]) {
            tmp = a[j];
            a[j] = a[j+1];
            a[j+1] = tmp;
        }
    }
}







