#include "list.h"
#include <stdio.h>

#define DATA_TABLE_SIZE 64

struct data {
	int val;
	struct hlist_node node;
};

int main(void) {
	struct hlist_head head = HLIST_HEAD_INIT;
	HLIST_HEAD(head1);
	struct hlist_head head2;
	INIT_HLIST_HEAD(&head2);

	struct hlist_node node;
	INIT_HLIST_NODE(&node);
	
	printf("hlist_unhashed: %d\n", hlist_unhashed(&node));	
	printf("head hlist_empty: %d\n", hlist_empty(&head));
	printf("head1 hlist_empty: %d\n", hlist_empty(&head1));
	printf("head2 hlist_empty: %d\n", hlist_empty(&head2));
	printf("\n");
	
	struct data d1;
	d1.val = 1;
	INIT_HLIST_NODE(&d1.node);

	hlist_add_head(&d1.node, &head);

	struct data *temp1 = hlist_entry(&d1.node, struct data, node);	
	printf("hlist_unhashed: %d\n", hlist_unhashed(&d1.node));	
	printf("head hlist_empty: %d\n", hlist_empty(&head));
	printf("head1 hlist_empty: %d\n", hlist_empty(&head1));
	printf("head2 hlist_empty: %d\n", hlist_empty(&head2));
	printf("data d1 val: %d\n", temp1->val);
	printf("\n");

	struct data d2;
	d2.val = 2;
	INIT_HLIST_NODE(&d2.node);
	
	hlist_add_before(&d2.node, &d1.node);
	
	struct data *temp2 = hlist_entry(&d2.node, struct data, node);	
	printf("hlist_unhashed: %d\n", hlist_unhashed(&d1.node));	
	printf("hlist_unhashed: %d\n", hlist_unhashed(&d2.node));	
	printf("head hlist_empty: %d\n", hlist_empty(&head));
	printf("head1 hlist_empty: %d\n", hlist_empty(&head1));
	printf("head2 hlist_empty: %d\n", hlist_empty(&head2));
	printf("data d2 val: %d\n", temp2->val);
    
	printf("\n");

	struct data d3;
	d3.val = 3;
	INIT_HLIST_NODE(&d3.node);
	
	hlist_add_after(&d1.node, &d3.node);
	
	struct data *temp3 = hlist_entry(&d3.node, struct data, node);	
	printf("hlist_unhashed: %d\n", hlist_unhashed(&d1.node));	
	printf("hlist_unhashed: %d\n", hlist_unhashed(&d2.node));	
	printf("hlist_unhashed: %d\n", hlist_unhashed(&d3.node));	
	printf("head hlist_empty: %d\n", hlist_empty(&head));
	printf("head1 hlist_empty: %d\n", hlist_empty(&head1));
	printf("head2 hlist_empty: %d\n", hlist_empty(&head2));
	printf("data d3 val: %d\n", temp3->val);
	printf("\n");

	hlist_move_list(&head, &head1);
	printf("hlist_unhashed: %d\n", hlist_unhashed(&d1.node));	
	printf("hlist_unhashed: %d\n", hlist_unhashed(&d2.node));	
	printf("hlist_unhashed: %d\n", hlist_unhashed(&d3.node));	
	printf("head hlsit_empty: %d\n", hlist_empty(&head));
	printf("head1 hlsit_empty: %d\n", hlist_empty(&head1));
	printf("head2 hlsit_empty: %d\n", hlist_empty(&head2));
	printf("\n");

	struct hlist_node *hn;
	printf("head1 hlist:");
	hlist_for_each(hn, &head1) {
		temp3 = hlist_entry(hn, struct data, node);
		printf("%d -->", temp3->val);
	}
	printf("NULL\n");

	struct hlist_node *hn1;
	struct hlist_node *tmp1;
	printf("head1 hlist:");
	hlist_for_each_safe(hn, tmp1, &head1) {
		temp3 = hlist_entry(hn, struct data, node);
		printf(" %d --> ", temp3->val);
	}
	printf("NULL\n");


	struct data* dtmp1;
	struct data* dtmp;
	printf("head1 hlist:");
	hlist_for_each_entry(dtmp, hn1, &head1, node) {
		printf(" %d --> ", dtmp->val);	
	}
	printf("NULL\n");
#if 0
	struct data* dtmp2 = &d2;
	printf("head1 hlist:");
	hlist_for_each_entry_continue(dtmp2, hn1, node) {
		printf(" %d --> ", dtmp2->val);	
	}
	printf("NULL\n");

	struct data* dtmp3 = &d1;
	printf("head1 hlist:");
	hlist_for_each_entry_from(dtmp3, hn1, node) {
		printf(" %d --> ", dtmp3->val);	
	}
	printf("NULL\n");

	struct data* dtmp4;
	struct hlist_node *hntmp;
	printf("head1 hlist:");
	hlist_for_each_entry_safe(dtmp4, hntmp, hn1, &head1, node) {
		printf(" %d --> ", dtmp4->val);	
	}
	printf("NULL\n");
#endif
	return 0;
}
