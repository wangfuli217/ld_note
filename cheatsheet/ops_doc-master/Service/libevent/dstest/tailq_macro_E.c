//队列中的元素结构体。它有一个值，并且有前向指针和后向指针
//通过前后像指针，把队列中的节点连接起来
struct queue_entry_t
{
    int value;
 
    struct
    {
        struct queue_entry_t *tqe_next;
        struct queue_entry_t **tqe_prev;
    }entry;
};
 
//就像有头节点的链表那样，这个是队列头。它有两个指针，分别指向队列的头和尾
struct queue_head_t
{
    struct queue_entry_t *tqh_first;
    struct queue_entry_t **tqh_last;
};
 
int main(int argc, char **argv)
{
    struct queue_head_t queue_head;
    struct queue_entry_t *q, *p, *s, *new_item;
    int i;
 
    //TAILQ_INIT(&queue_head);
    do
    {
        (&queue_head)->tqh_first = 0;
        //tqh_last是二级指针，这里指向一级指针
        (&queue_head)->tqh_last = &(&queue_head)->tqh_first;
    }while(0);
 
    for(i = 0; i < 3; ++i)
    {
        p = (struct queue_entry_t*)malloc(sizeof(struct queue_entry_t));
        p->value = i;
 
        //TAILQ_INSERT_TAIL(&queue_head, p, entry);在队尾插入数据
        do
        {
            (p)->entry.tqe_next = 0;
            //tqh_last存储的是最后一个元素(队列节点)tqe_next成员
            //的地址。所以，tqe_prev指向了tqe_next。
            (p)->entry.tqe_prev = (&queue_head)->tqh_last;
 
            //tqh_last存储的是最后一个元素(队列节点)tqe_next成员
            //的地址，所以*(&queue_head)->tqh_last修改的是最后一个
            //元素的tqe_next成员的值，使得tqe_next指向*p(新的队列
            //节点)。
            *(&queue_head)->tqh_last = (p);
            //队头结构体（queue_head）的tqh_last成员保存新队列节点的
            //tqe_next成员的地址值。即让tqh_last指向tqe_next。
            (&queue_head)->tqh_last = &(p)->entry.tqe_next;
        }while(0);
    }
 
    q = (struct queue_entry_t*)malloc(sizeof(struct queue_entry_t));
    q->value = 10;
 
    //TAILQ_INSERT_HEAD(&queue_head, q, entry);在队头插入数据
    do {
        //queue_head队列中已经有节点(元素了)。要对第一个元素进行修改
        if(((q)->entry.tqe_next = (&queue_head)->tqh_first) != 0)
            (&queue_head)->tqh_first->entry.tqe_prev = &(q)->entry.tqe_next;
        else//queue_head队列目前是空的，还没有任何节点（元素）。修改queue_head即可
            (&queue_head)->tqh_last = &(q)->entry.tqe_next;
 
        //queue_head的first指针指向要插入的节点*q
        (&queue_head)->tqh_first = (q);
        (q)->entry.tqe_prev = &(&queue_head)->tqh_first;
    }while(0);
 
    //现在q指向队头元素、p指向队尾元素
 
    s = (struct queue_entry_t*)malloc(sizeof(struct queue_entry_t));
    s->value = 20;
 
    //TAILQ_INSERT_AFTER(&queue_head, q, s, entry);在队头元素q的后面插入元素
    do
    {
        //q不是最后队列中最后一个节点。要对q后面的元素进行修改
        if (((s)->entry.tqe_next = (q)->entry.tqe_next) != 0)
            (s)->entry.tqe_next->entry.tqe_prev = &(s)->entry.tqe_next;
        else//q是最后一个元素。对queue_head修改即可
            (&queue_head)->tqh_last = &(s)->entry.tqe_next;
 
        (q)->entry.tqe_next = (s);
        (s)->entry.tqe_prev = &(q)->entry.tqe_next;
    }while(0);
 
 
 
    s = (struct queue_entry_t*)malloc(sizeof(struct queue_entry_t));
    s->value = 30;
 
    //TAILQ_INSERT_BEFORE(p, s, entry); 在队尾元素p的前面插入元素
    do
    {
        //无需判断节点p前面是否还有元素。因为即使没有元素，queue_head的两个
        //指针从功能上也相当于一个元素。这点是采用二级指针的一大好处。
        (s)->entry.tqe_prev = (p)->entry.tqe_prev;
        (s)->entry.tqe_next = (p);
        *(p)->entry.tqe_prev = (s);
        (p)->entry.tqe_prev = &(s)->entry.tqe_next;
    }while(0);
 
 
    //现在进行输出
 
    // s = TAILQ_FIRST(&queue_head);
    s = ((&queue_head)->tqh_first);
    printf("the first entry is %d\n", s->value);
 
    // s = TAILQ_NEXT(s, entry);
    s = ((s)->entry.tqe_next);
    printf("the second entry is %d\n\n", s->value);
 
    //删除第二个元素, 但并没有释放s指向元素的内存
    //TAILQ_REMOVE(&queue_head, s, entry);
    do
    {
        if (((s)->entry.tqe_next) != 0)
            (s)->entry.tqe_next->entry.tqe_prev = (s)->entry.tqe_prev;
        else (&queue_head)->tqh_last = (s)->entry.tqe_prev;
 
        *(s)->entry.tqe_prev = (s)->entry.tqe_next;
    }while(0);
 
    free(s);
 
 
    new_item = (struct queue_entry_t*)malloc(sizeof(struct queue_entry_t));
    new_item->value = 100;
 
    //s = TAILQ_FIRST(&queue_head);
    s = ((&queue_head)->tqh_first);
 
    //用new_iten替换第一个元素
    //TAILQ_REPLACE(&queue_head, s, new_item, entry);
    do
    {
        if (((new_item)->entry.tqe_next = (s)->entry.tqe_next) != 0)
            (new_item)->entry.tqe_next->entry.tqe_prev = &(new_item)->entry.tqe_next;
        else
            (&queue_head)->tqh_last = &(new_item)->entry.tqe_next;
 
        (new_item)->entry.tqe_prev = (s)->entry.tqe_prev;
        *(new_item)->entry.tqe_prev = (new_item);
    }while(0);
 
 
    printf("now, print again\n");
    i = 0;
    //TAILQ_FOREACH(p, &queue_head, entry)//用foreach遍历所有元素
    for((p) = ((&queue_head)->tqh_first); (p) != 0;
        (p) = ((p)->entry.tqe_next))
    {
        printf("the %dth entry is %d\n", i, p->value);
    }
 
    //p = TAILQ_LAST(&queue_head, queue_head_t);
    p = (*(((struct queue_head_t *)((&queue_head)->tqh_last))->tqh_last));
    printf("last is %d\n", p->value);
 
 
    //p = TAILQ_PREV(p, queue_head_t, entry);
    p = (*(((struct queue_head_t *)((p)->entry.tqe_prev))->tqh_last));
    printf("the entry before last is %d\n", p->value);
}
--------------------- 
作者：luotuo44 
来源：CSDN 
原文：https://blog.csdn.net/luotuo44/article/details/38374009 
版权声明：本文为博主原创文章，转载请附上博文链接！