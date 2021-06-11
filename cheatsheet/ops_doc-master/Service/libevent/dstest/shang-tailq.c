#include <stdio.h>
#include <stdlib.h>
#include <sys/queue.h>

//libevent中使用的尾队列
/*
  定义一个结构体，它只是尾队列的一个元素
  它必须包含一个TAILQ_ENTRY来指向上一个和下一个元素
*/
struct tailq_entry {
	int value;
	TAILQ_ENTRY(tailq_entry) entries;
};

//定义队列的头部
//定义结构体 struct tailq_head
TAILQ_HEAD(tailq_head, tailq_entry) my_tailq_head;

int main(int argc, char  *argv[])
{
	//定义一个结构体指针
	struct tailq_entry *item;
	//定义另外一个指针
	struct tailq_entry *tmp_item;
	
	//初始化队列
	TAILQ_INIT(&my_tailq_head);

	int i;
	//在队列里添加10个元素
	for(i=0; i<10; i++) {
		//申请内存空间
		item = malloc(sizeof(*item));
		if (item == NULL) {
			perror("malloc failed");
			exit(-1);
		}
		//设置值
		item->value = i;

		/*
		   将元素加到队列尾部
		   参数1：指向队列头的指针
		   参数2：要添加的元素
		   参数3：结构体的变量名
		*/
		TAILQ_INSERT_TAIL(&my_tailq_head, item, entries);
	}

	//遍历队列
	printf("Forward traversal: ");
	TAILQ_FOREACH(item, &my_tailq_head, entries) {
		printf("%d ",item->value);
	}
	printf("\n");

	//添加一个新的元素
	printf("Adding new item after 5: ");
	TAILQ_FOREACH(item, &my_tailq_head, entries) {
		if (item->value == 5) {
			struct tailq_entry *new_item = malloc(sizeof(*new_item));
			if (new_item == NULL) {
				perror("malloc failed");
				exit(EXIT_FAILURE);
			}
			new_item->value = 10;
			//插入一个元素
			TAILQ_INSERT_AFTER(&my_tailq_head, item, new_item, entries);
			break;
		}
	}
	TAILQ_FOREACH(item, &my_tailq_head, entries) {
		printf("%d ", item->value);
	}
	printf("\n");

	//TAILQ_PREV
	TAILQ_FOREACH(item, &my_tailq_head, entries) {
		if (item->value == 5) {
			item  = TAILQ_PREV(item, tailq_head, entries);
			printf("the entry before 5 last is %d\n", item->value);
			break;
		}
	}

	//TIALQ_LAST
	item = TAILQ_LAST(&my_tailq_head, tailq_head);
	if (item != NULL) {
		printf("the last is:%d\n",item->value);
	}

	//另外一种TAILQ_LAST的方法
	struct  tailq_entry **pp = (&my_tailq_head)->tqh_last;  
	pp += 1; //加1个指针的偏移量，在32位的系统中，就等于+4  
	//因为这里得到的是二级指针的地址值，所以按理来说，得到的是一个  
	////三级指针。故要用强制转换成三级指针。  
	struct queue_entry_t ***ppp = (struct queue_entry_t ***)pp;  
	struct tailq_entry *s = (struct tailq_entry *)**ppp;  
	printf("the last is %d\n", s->value);  
	//该代码虽然能得到正确的结果，但总感觉直接加上一个偏移量的方式太粗暴了。
	//有一点要提出，+1那里并不会因为在64位的系统就不能运行，一样能正确运行的。
	//因为1不是表示一个字节，而是一个指针的偏移量。
	//在64位的系统上一个指针的偏移量为8字节。
	//这种”指针 + 数值”，实际其增加的值为:数值 + sizeof(*指针)。
	//不信的话，可以试一下char指针、int指针、结构体指针(结构体要有多个成员)。
	

	//删除一个元素
	printf("Deleting item with value 3: ");
	for(item = TAILQ_FIRST(&my_tailq_head); item != NULL; item = tmp_item) {
		if (item->value == 3) {
			//删除一个元素
			TAILQ_REMOVE(&my_tailq_head, item, entries);
			//释放不需要的内存单元
			free(item);
			break;
		}
		tmp_item = TAILQ_NEXT(item, entries);
	}

	TAILQ_FOREACH(item, &my_tailq_head, entries) {
		printf("%d ", item->value);
	}
	printf("\n");

	printf("Deleting item with value 8: ");
	for(item = TAILQ_FIRST(&my_tailq_head); item != NULL;  item = TAILQ_NEXT(item, entries)) {
		if (item->value == 8) {
			//删除一个元素
			TAILQ_REMOVE(&my_tailq_head, item, entries);
			//释放不需要的内存单元
			free(item);
			break;
		}
	}
	TAILQ_FOREACH(item, &my_tailq_head, entries) {
		printf("%d ", item->value);
	}
	printf("\n");

	while (item = TAILQ_FIRST(&my_tailq_head)) {
		TAILQ_REMOVE(&my_tailq_head, item, entries);
		free(item);
	}

	//查看是否为空
	if (!TAILQ_EMPTY(&my_tailq_head)) {
		printf("tail queue is  NOT empty!\n");
	}

	return 0;
}
