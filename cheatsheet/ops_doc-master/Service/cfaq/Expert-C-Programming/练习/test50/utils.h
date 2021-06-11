#ifndef UTILS_H_INCLUEDE
#  define UTILS_H_INCLUEDE

#  ifndef REDUCE_CACHE
#     define REDUCE_CACHE int
#  endif

#  ifndef REDUCE_ELEM
#     define REDUCE_ELEM int
#  endif

#  ifndef MAP_SRC_ELEM
#     define MAP_SRC_ELEM int
#  endif

#  ifndef MAP_DEST_ELEM
#     define MAP_DEST_ELEM int
#  endif

#  ifndef EACH_ELEM
#     define EACH_ELEM int
#  endif

#  ifndef FILTER_ELEM
#     define FILTER_ELEM int
#  endif

#  ifndef TAKE_ELEM
#     define TAKE_ELEM int
#  endif

#  ifndef Q_SORT_ELEM
#     define Q_SORT_ELEM int
#  endif

// reduce
REDUCE_CACHE reduce(REDUCE_CACHE(*callback)(REDUCE_CACHE, REDUCE_ELEM, int),
                    REDUCE_ELEM *arr, int size, REDUCE_CACHE init){
    int i;
    REDUCE_CACHE acc = init;
    for(i = 0; i < size; i++){
        acc = callback(acc, arr[i], i);
    }
    return acc;
}

// map
MAP_DEST_ELEM* map(MAP_DEST_ELEM(*callback)(MAP_SRC_ELEM, int),
                   MAP_SRC_ELEM *arr, int size){
    int i;
    MAP_DEST_ELEM* ret_arr = malloc(sizeof(MAP_DEST_ELEM) * size);
    assert(ret_arr != NULL);
    for(i = 0; i < size; i++){
        ret_arr[i] = callback(arr[i], i);
    }
    return ret_arr;
}

// each
void each(void(*callback)(EACH_ELEM*, int), EACH_ELEM *arr, int size){
    int i;
    for(i = 0; i < size; i++){
        callback(&arr[i], i);
    }
}

// filter
int filter(int(*predicate)(FILTER_ELEM, int), FILTER_ELEM *arr, int size){
    int i, new_size = 0;
    FILTER_ELEM temp;
    for(i = 0; i < size; i++){
        if(predicate(arr[i], i)){
            temp = arr[i];
            arr[new_size] = temp;
            new_size++;
        }
    }
    return new_size;
}

// take_while
TAKE_ELEM take_while(TAKE_ELEM(*predicate)(TAKE_ELEM, int),
                     TAKE_ELEM(*move_next)(TAKE_ELEM, int), TAKE_ELEM init){
    TAKE_ELEM data = init;
    int i = 0;
    while(!(predicate(data, i))){
        data = move_next(data, i);
        i++;
    }
    return data;
}

// range
int range(int start, int end, int step, int* arr){
    if(step == 0) return 0;
    if(step > 0 && end < start) return 0;
    if(step < 0 && start < end) return 0;
    int new_size = 0;
    while(1){
        if(step > 0 && start >= end) break;
        if(step < 0 && start <= end) break;
        arr[new_size++] = start;
        start += step;
    }
    return new_size;
}

// q_sort
    void swap(Q_SORT_ELEM *a, Q_SORT_ELEM *b){
        Q_SORT_ELEM temp = *a;
        *a = *b;
        *b = temp;
    }

    int partition(int(*cmp)(Q_SORT_ELEM, Q_SORT_ELEM),
                  Q_SORT_ELEM *arr, int size, int pivoit_idx){
        int i, left_idx = 0;
        Q_SORT_ELEM pivot = arr[pivoit_idx];
        swap(&arr[pivoit_idx], &arr[size - 1]);
        for(i = 0; i < size; i++){
            if(cmp(arr[i], pivot) == -1){
                swap(&arr[i], &arr[left_idx]);
                left_idx++;
            }
        }
        swap(&arr[size - 1], &arr[left_idx]);
        return left_idx;
    }

void q_sort(int(*cmp)(Q_SORT_ELEM, Q_SORT_ELEM), Q_SORT_ELEM *arr, int size){
    if(size <=1 ) return;
    int left_idx = partition(cmp, arr, size, 0);
    q_sort(cmp, arr, left_idx);
    q_sort(cmp, &arr[left_idx+1], size - left_idx -1);
}

// print_arr
void print_arr(FILE *fp, int *arr, int size){
    fprintf(fp, "[ ");
    int i = 0;
    while(i < size){
        fprintf(fp, "%6d ", arr[i++]);
        if(i == size){
            fprintf(fp, " ]\n");
            return;
        }
        if(i%10 == 0) fprintf(fp, "\n");
    }
}

// my_strcmp
int my_strcmp(const char *str1, const char *str2){
    const char *p1 = str1, *p2 = str2;
    while(*p1 != '\0' && *p2 != '\0' && *p1 == *p2){
        p1++; p2++;
    }
    if(*p1 == '\0' && *p2 == '\0') return 0;
    return *p1 > *p2 ? 1 : -1;
}

// my_strlen
int my_strlen(const char *str){
    const char *p = str;
    while(*p != '\0') p++;
    return p - str;
}

// my_strcat
char* my_strcat(char *str1, const char *str2){
    char* p = str1, *q = str2;
    while(*p != '\0') p++;
    while(*q != '\0'){
        *p = *q;
        p++;
        q++;
    }
    *p = '\0';
    return str1;
}

#endif /*UTILS_H_INCLUEDE*/