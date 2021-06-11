#include <stdio.h>
#include <stdlib.h>

#include "../src/list.h"

typedef struct {
    int num;
    list_t numbers;
} Number;

void list_print(list_t *head) {
    list_t *pos;
    list_for_each(pos, head) {
        printf("%d ", list_entry(pos, Number, numbers)->num);
    }
    putchar('\n');
}

void list_free(list_t *head) {
    list_t *pos, *p;
    list_for_each_safe(pos, p, head) {
        list_del(pos);
        free(list_entry(pos, Number, numbers));
    }
}

int main() {
    printf("list test\n");

    /* init */
    LIST_HEAD(head);
    Number *num;
    for (int i = 0; i != 10; ++i) {
        num = malloc(sizeof(Number));
        list_insert(&num->numbers, &head);
        num->num = i;
    }
    list_print(&head);

    /* half */
    list_t *half = list_half(&head);
    LIST_HEAD(new_head);
    list_slice(&head, half, &new_head);
    list_print(&head); list_print(&new_head);

    /* join */
    list_join(&head, &new_head);
    list_print(&head);

    /* swap 1 */
    list_swap(head.next, head.next);
    list_print(&head);

    /* swap 2 */
    list_swap(head.next, head.next->next);
    list_print(&head);

    /* swap 3 */
    list_swap(head.next, head.prev);
    list_print(&head);

    /* del */
    list_free(&head);
    return 0;
}
