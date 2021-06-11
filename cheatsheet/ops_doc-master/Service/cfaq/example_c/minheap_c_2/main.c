#include "heap.h"

#include <stdlib.h>
#include <stdio.h>

int heap_node_compar(const void *a, const void *b)
{
        heap_node_t *s, *t;
        s = a;
        t = b;
        if (s->data > t->data)
                return 1;
        else
        if (s->data == t->data)
                return 0;
        else
                return -1;
}

int test()
{
        heap_t heap;
        heap_node_t hn[10000];
        int list[10000];
        int pl;
        heap_init(&heap, 10000, &heap_node_compar);
        int i,j;
        int x;
        int pl_max = 9999;
        int pl_min = 0;
        pl = pl_max;
        //srand(3000);
        for (i=0; i<10000; i++)
        {
                list[i] = i;
                hn[i].data = i;
        }
        for (;pl>= 0 && pl <= 9999;)
        {
                x = rand();
                x = 2 *(double)(x/(RAND_MAX+1.0));
                if (pl == pl_min && x == 0)
                        continue;
                else
                if (pl == pl_max && x == 1)
                        continue;
                printf("x=%d pl=%d\n", x, pl);
                if (x == 0)
                {
                        i = (pl+1) * (double)(rand()/(RAND_MAX + 1.0));
                        j = list[i];
                        printf("i = %d j = %d\n", i, j);
                        list[i] = list[pl];
                        list[pl] = j;
                        pl--;
                        printf("insert %d\n", j);
                        if (heap_insert(&heap, &hn[j]) != 0)
                        {
                                perror("heap_insert");
                                exit(1);
                        }
                } else
                {
                        i = (pl_max-pl) * (double)(rand()/(RAND_MAX + 1.0));
                        i += pl+1;
                        j = list[i];
                        printf("i = %d j = %d\n", i, j);
                        list[i] = list[pl+1];
                        list[pl+1] = j;
                        pl++;
                        printf("delete %d\n", j);
                        if (heap_delete(&heap, &hn[j]) != 0)
                        {
                                perror("heap_delete");
                                exit(1);
                        }
                }

        }
        for (i=0; i<10; i++)
        {
                printf("%d %d\n", heap.heap[i]->index, heap.heap[i]->data);
        }
        printf("%d\n", heap.last_index);
}

int main()
{
        int nworkers  = 2;
        int i;

        pthread_t* tinfo = (pthread_t*)malloc(sizeof(pthread_t) * nworkers);

        for (i=0; i<nworkers; i++)
        {
                pthread_create(&tinfo[i], NULL, (void *)&test, NULL);
        }
        for (i=0; i<nworkers; i++)
        {
                void *ret;
                pthread_join(tinfo[i], &ret);
        }
	
	system("pause");
	
	return 0;
}
