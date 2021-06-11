http://blog.csdn.net/astrotycoon/article/details/42917367

1. 静态型：遍历多，中间插入和中间删除少的，用简单单向链表
2. 队列型：从头删除，从尾增加，有遍历，基本不存在，用->head和->->tail
3. 动态性：双向循环链表或双向非循环链表，整体双向循环链表简单点。

指向指针的指针：
*kptr = eptr->next    # 链表发生了变化 - 删除或插入
kptr = &(eptr->next)  # 链表未发生变化 - 遍历

((eptr=*kptr))        # 赋值判断双操作

moosefs(有时候用while，有时候用for，有时候直接for1){
Singly(添加、遍历、全删除，没有插入){ 可以插入，删除某个节点到指定位置。
dehead,wehead,cehead,rlhead,inhead,kahead,pollhead,eloophead,chldhead,timehead 
for (pollit = pollhead ; pollit != NULL ; pollit = pollit->next)  # 遍历
for (de = dehead ; de ; de = den)                                 # 全删除
    den = de->next;
1. 删除某个节点的时候必然会引入一个临时变量，保存删除对象关联的下一个对象内容。
   删除某个节点的时候，需要引入指向指针的指针；引入指向指针的指针也可以删除整个链表的数据
   删除整个链表的时候，需要引入指向删除节点的临时指针。
2. 两个for循环主要差异在于：遍历过程中，后驱节点的赋值是直接赋值，还是通过临时变量中转一次。
   双向循环链表和双向不循环列表遍历方法与单链表遍历一样，只是双向循环链表结尾为ptr != head，而不是NULL
3. 想起单向链表删除某个节点的情况；           # TCPIP高效编程.sh
for ( tprev = &active, tcur = active;         # active为头指针，tprev为临时指针的指针，tcur为临时指针
    tcur && id != tcur->id;                   # id为链表的一个标识值
    tprev = &tcur->next, tcur = tcur->next )  # 一次遍历删除多个节点的时候，该赋值要通过临时变量放到循环内，while更好
    { ; }
    *tprev = tcur->next;

4. 单向链表的插入某个节点的过程               # 插入某个节点前
    for ( tprev = &active, tcur = active;
          tcur && !timercmp( &tp->tv, &tcur->tv, < ); # timercmp为比较函数
          tprev = &tcur->next, tcur = tcur->next )
    { ; }
    *tprev = tp;
    tp->next = tcur;
}

Singly(添加、遍历、指定删除，没有插入){
csserventry,masterconn,matoclserventry,matocsserventry,matomlserventry
    eptr = csservhead;                              # 全删除
   while ((eptr)) {
        eaptr = eptr;         
        eptr = eptr->next;
        free(eaptr);
    }
    for (eptr=csservhead ; eptr ; eptr=eptr->next)  # 遍历
    kptr = &csservhead; 
    while ((eptr=*kptr)) {                          # 选择删除
       if ((eptr->state == CLOSE)) {
            *kptr = eptr->next; # kptr变量自身存储的值未发生变化，csservhead链表中的节点发生了变化-删除
            free(eptr);
            }else{
            kptr = &(eptr->next);# kptr变量自身存储的值发生了变化，csservhead链表中的节点未发生变化-遍历
        }
    rp = &(rephash[hash]);
    while ((r=*rp)!=NULL){                          # 指定删除
        *rp = r->next;
        matocsserv_repdst_free(r);
    }
1. 删除某个对象必然引入一个指向指针的指针临时节点。
2. for常常用于遍历，也会用于删除某个节点，while常常用于删除多个节点，也会用于遍历整个链表
}

Singly(队列类型单向链表<从头删除从尾添加>){

# 学习数据驱动程序和队列链表之间的关系
in_packetstruct, out_packetstruct
eptr->inputhead = NULL;                            # 初始化
eptr->inputtail = &(eptr->inputhead);

while ((ipack = eptr->inputhead)!=NULL) {          # 首部获取，全删除
        eptr->inputhead = ipack->next;
        free(ipack);
        if ((eptr->inputhead==NULL)) {
            eptr->inputtail = &(eptr->inputhead);
        } 
    }

*(eptr->inputtail) = eptr->input_packet;        # 尾部插入
eptr->inputtail = &(eptr->input_packet->next);  # inputtail指向指针的指针，input_packet新建malloc的数据包

[out_packetstruct]
eptr->outputhead = NULL;
eptr->outputtail = &(eptr->outputhead);          # 初始化

opack = eptr->outputhead;                        # 首部获取，根据阻塞情况一次删除

if ((opack==NULL)) {return;}                       # 没有数据不调用write函数
i=write(eptr->sock,opack->startptr,opack->bytesleft); # 发送数据
if ((opack->bytesleft>0)) { return;}               # 内核缓冲区写满，

eptr->outputhead = opack->next;
if ((eptr->outputhead==NULL)) {
    eptr->outputtail = &(eptr->outputhead);
}

opptr = eptr->outputhead;                        # 首部获取，全删除
while ((opptr)) {
    opaptr = opptr;
    opptr = opptr->next;
    free(opaptr);
}

1. 初始化时建立outputhead和outputtail之间的关联；删除完所有节点之后重新建立
2. 相链表中添加数据的时候，只需要移动两次outputtail就行，一次为关联下个节点，一次为重新初始化自身
3. outputhead成为数据驱动poll的关键点，而startptr和bytesleft成为用户态缓冲区和内核态缓冲器数据一致性的关键字段。
}

}

redis(){
double(adlist.c:双向不循环链表){
list和listNode
list->head = list->tail = NULL; # 初始化

current = list->head;
while((len--)) {                # 全删除
        next = current->next;
        zfree(current);
        current = next;
    }
    
if ((list->len == 0)) {         # 头部添加
    list->head = list->tail = node;
    node->prev = node->next = NULL;
} else {
    node->prev = NULL;           # 双向不循环链表，第一个节点前驱指向NULL
    node->next = list->head;     # 添加节点时，总是先修改新增节点的指针
    list->head->prev = node;     # 添加节点时，总在修改完prev和next节点后，才会修改head或tail节点
    list->head = node;
}

if ((list->len == 0)) {           # 尾部添加
    list->head = list->tail = node;
    node->prev = node->next = NULL;
} else {
    node->prev = list->tail;
    node->next = NULL;
    list->tail->next = node;
    list->tail = node;
}

node->next = old_node;          # 插入
node->prev = old_node->prev;
if ((list->head == old_node)) { # 如果插入位置在头部，则更新头部指针
    list->head = node;
}
if ((node->prev != NULL)) {     # 如果前向指针不为空，更新前驱的后向指针
    node->prev->next = node;
}
if ((node->next != NULL)) {     # 如果后向指针不为空，更新后驱的前向指针
    node->next->prev = node;
}

if (node->prev)                 # 删除
    node->prev->next = node->next;
else
    list->head = node->next;

if (node->next)
    node->next->prev = node->prev;
else
    list->tail = node->prev;
}
1. 双向不循环列表，尾节点的next为NULL，首节点的prev为NULL；如果只有一个节点，则该节点prev和next都为NULL.
2. 添加节点时，需要确认新增节点是否为第一个节点，如果是->tail=->head=node; node->prev=node->next=NULL
3. 在某个节点前插入，更复杂，关系到head指针的指向是否需要更新；前驱不为空的情况；后去不为空的情况。
4. 删除某个节点，也很复杂，关系到前驱不为空的情况；关系到后驱不为空的情况。
}

linux(){
double(list.h双向循环链表){
list->next = list->prev = list;          #初始化

head->next->prev = node;                 #头部插入
node->next = head->next;
node->prev = head;
head->next = node;

head->prev = _new;                       #尾部插入
_new->next = head;
_new->prev = head->prev;
head->prev->next = _new;

entry->next->prev = entry->prev;         #删除
entry->prev->next = entry->next;

#define	list_for_each(p, head)						\
	for (p = (head)->next; p != (head); p = p->next)  #遍历节点需要一个临时指针
#define	list_for_each_safe(p, n, head)					\
	for (p = (head)->next, n = p->next; p != (head); p = n, n = p->next) #遍历节点，也进行删除时，需要多个临时指针
    

1. list_head既存在于头结点，也存在于数据节点。都通过一个数据结构表示。
2. 节点的删除很简单，节点的增加也很简单。不用判断tail和head这两个多于的变量。
3. 遍历过程中，链表的结尾不再是NULL，而是p != (head) 这样的判断。
}

Singly(list.h 单向链表,优点何在?){
hlist_head.first;
hlist_node *next, **pprev;

struct hlist_node *first = h->first;      # 头部添加
n->next = first;
if (first)
	first->pprev = &n->next;
h->first = n;
n->pprev = &h->first;

n->pprev = next->pprev;                    # 前插入
n->next = next;
next->pprev = &n->next;
*(n->pprev) = n;
    
next->next = n->next;                      # 后插入
n->next = next;
next->pprev = &n->next;

if(next->next)
    next->next->pprev  = &next->next;
    
struct hlist_node *next = n->next;         # 删除
struct hlist_node **pprev = n->pprev;
*pprev = next;
if (next)
    next->pprev = pprev;
}

klist(http://jarson.in/Kernel/%E5%86%85%E6%A0%B8%E6%95%B0%E6%8D%AE%E7%BB%93%E6%9E%84/klist/){
    klist是list的线程安全版本，它提供了整个链表的自旋锁，查找链表节点，对链表节点的插入和删除操作
都要获得这个自旋锁。klist的节点数据结构是klist_node，klist_node引入引用计数，只有当引用计数减到0时
才允许该node从链表中移除。当一个内核线程要移除一个node，必须要等待到node的引用计数释放，在此期间线程
处于休眠状态。为了方便线程等待，klist引入等待移除节点者结构体klist_waiter，klist_waiter组成
klist_remove_waiters（内核全局变量）链表，为保护klist_remove_waiters线程安全，引入klist_remove_lock
（内核全局变量）自旋锁。为方便遍历klist，引入了迭代器klist_iter。
}

kfifo(http://jarson.in/Kernel/%E5%86%85%E6%A0%B8%E6%95%B0%E6%8D%AE%E7%BB%93%E6%9E%84/kfifo/){
    kfifo是内核里面的一个First In First Out数据结构，它采用环形循环队列的数据结构来实现；
它提供一个无边界的字节流服务，最重要的一点是，它使用并行无锁编程技术，即当它用于只有一个
入队线程和一个出队线程的场情时，两个线程可以并发操作，而不需要任何加锁行为，就可以保证
kfifo的线程安全。
}
}

dnsmasq(){
double(cache){
static struct crec *cache_head = NULL, *cache_tail = NULL; #初始化

if (cache_tail)
    cache_tail->next = crecp;                              # cache_free:功能是将crecp添加到尾部
else                                                       # 如果尾部指针指向节点不为空，则添加到尾节点上，
    cache_head = crecp;                                    # 否则添加到头结点上。
crecp->prev = cache_tail;                                  # 建立与尾节点之间的关系
crecp->next = NULL;
cache_tail = crecp;

if (cache_head)                                            # cache_link:功能是将crecp添加到头部
    cache_head->prev = crecp;                              # 如果头部指针指向节点不为空，则添加到头节点上，
crecp->next = cache_head;
crecp->prev = NULL;
cache_head = crecp;                                        # 建立与头节点之间的关系
if (!cache_tail)                                           # 这个其实可以和cache_free中else掉
    cache_tail = crecp;
}
                                                           # 删除
if (crecp->prev)
  crecp->prev->next = crecp->next;
else
  cache_head = crecp->next;

if (crecp->next)
  crecp->next->prev = crecp->prev;
else
  cache_tail = crecp->prev;
1. 插入要判断是否插入到头部，插入到尾部和插入节点是否为第一个节点
2. 删除要判断该节点是否位于头部，位于尾部，还是既位于头部，又位于尾部。
}

Advantages(){
1. 动态数据结构，可以动态增加和缩减
2. 头尾插入和删除节点简单，可以中间插入和删除某个节点
3. 栈和队列可以使用链表实现
4. 不用定义初始大小
5. 链表回溯简单
}
Disadvantages(){
1. 使用更多的空间用于存储指针
2. 必须从头结点或尾节点顺序访问
3. 由于内存不连续，增加CPU
4. 反向遍历难度大
}

stack(){
Array
Linked list
}

queue(){
circular buffers
linked lists.
}

associative_arrays(){

}
