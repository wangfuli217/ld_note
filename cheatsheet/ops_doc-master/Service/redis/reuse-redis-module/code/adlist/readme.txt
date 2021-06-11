list *listCreate(void)
zmalloc分配list内存创建链表.此时没有listNode

void listRelease(list *list)
遍历list的listNode zfree释放,最后zfree list

list *listAddNodeHead(list *list, void *value)
zmalloc一个listNode空间,把value放入链表中.(链表中的value是个指针,需要注意)
新节点放在头,list.len++

list *listAddNodeTail(list *list, void *value)
类似上述,只是放在尾

list *listInsertNode(list *list, listNode *old_node, void *value, int after)
根据after看放在old_node的前面还是后面.
zmalloc一个listNOde
看情况改头指针
list.len++

void listDelNode(list *list, listNode *node)
删除一个节点.链表操作完成之后zfree node.
list.len--

listIter *listGetIterator(list *list, int direction)
获取一个迭代器
zmalloc申请listIter空间
如果方向是AL_START_HEAD(0),从头开始,listIter.next是list.head
如果方向不是,从尾开始,listIter.next是list.tail
listIter.direction记录方向
listReleaseIterator
zfree

void listRewind(list *list, listIter *li)
迭代器初始化,指向头 往尾

void listRewindTail(list *list, listIter *li)
迭代器初始化,指向尾 往头

listNode *listNext(listIter *iter)
返回迭代器的next指向的listNode,同时迭代器++(next=self.next)

list *listDup(list *orig)
复制一个链表
使用iterator,每个链表遍历,申请list和listNode
如果listNode.dup有设置,对value进行复制.
否则不复制,新旧list指向同一个value

listNode *listSearchKey(list *list, void *key)
使用iterator,如果有定义match方法,就使用match对比ite的value和key.没有就直接对比listnode.value是否等于key
返回结果前free ite

listNode *listIndex(list *list, long index)
如果index负数,从尾部开始;否则从头开始
找第index个listnode

void listRotate(list *list)
表尾节点放到表头