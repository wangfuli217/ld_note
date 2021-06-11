//双向线性链表容器,迭代器及泛型算法
#include<iostream>
#include<cstring>
#include<stdexcept>
using namespace std;

//双向线性链表类模板容器
template<typename T>
class List
{
	public:
		//构造,析构函数,拷贝构造,拷贝赋值
		List(void):m_head(NULL),m_tail(NULL){}
		~List(void){
			clear();
		}
		List(List const& that):m_head(NULL),m_tail(NULL){
			for(Node *node=that.m_head;node!=NULL;node=node->m_next)
				push_back(node->m_data);
		}
		List& operator=(List const& rhs){
			if(&rhs!=this)
			{
				List list=rhs;
				swap(m_head,list.m_head);
				swap(m_tail,list.m_tail);
			}
			return *this;
		}
		//获取首元素
		T& front(void){
			if(empty())
				throw underflow_error("链表下溢!");
			return m_head->m_data;
		}
		T const& front(void) const{
			return const_cast<List*>(this)->front();
		}
		//向首部压入
		void push_front(T const& data){
			m_head=new Node(data,NULL,m_head);
			if(m_head->m_next!=NULL)
				m_head->m_next->m_prev=m_head;
			else
				m_tail=m_head;
		}
		//从首部弹出
		void pop_front(void){
			if(empty())
				throw underflow_error("链表下溢!");
			Node *next=m_head->m_next;
			delete m_head;
			m_head=next;
			if(m_head!=NULL)
				m_head->m_prev=NULL;
			else
				m_tail=NULL;
		}
		//获取尾元素
		T& back(void){
			if(empty())
				throw underflow_error("链表下溢!");
			return m_tail->m_data;
		}
		T const& back(void) const{
			return const_cast<List*>(this)->back();
		}
		//向尾部压入
		void push_back(T const& data){
			m_tail=new Node(data,m_tail);
			if(m_tail->m_prev!=NULL)
				m_tail->m_prev->m_next=m_tail;
			else
				m_head=m_tail;
		}
		//从尾部弹出
		void pop_back(void){
			if(empty())
				throw underflow_error("链表下溢!");
			Node *prev=m_tail->m_prev;
			delete m_tail;
			m_tail=prev;
			if(m_tail!=NULL)
				m_tail->m_next=NULL;
			else
				m_head=NULL;
		}
		//删除所有匹配元素
		void remove(T const& data){
			for(Node *node=m_head,*next;node!=NULL;node=next)
			{
				next=node->m_next;
				if(equal(node->m_data,data))
				{
					if(node->m_prev!=NULL)
						node->m_prev->m_next=node->m_next;
					else
						m_head=node->m_next;
					if(node->m_next!=NULL)
						node->m_next->m_prev=node->m_prev;
					else
						m_tail=node->m_prev;
					delete node;
				}
			}
		}
		//清空
		void clear(void){
			while(!empty())
				pop_back();
		}
		//判断是否为空
		bool empty(void) const{
			return !m_head&&!m_tail;
		}
		//获取容器大小
		size_t size(void) const{
			size_t nodes=0;
			for(Node* node=m_head;node!=NULL;node=node->m_next)
				++nodes;
			return nodes;
		}
		//随机访问
		T& operator[](size_t i){
			for(Node* node=m_head;node!=NULL;node=node->m_next)
				if(i--==0)
					return node->m_data;
			throw out_of_range("下标越界!");
		}
		T const& operator[](size_t i) const
		{
			return const_cast<List&>(*this).operator[](i);
		}
		//插入输出流
		friend ostream& operator<<(ostream &os,List const& list){
			for(Node* node=list.m_head;node!=NULL;node=node->m_next)
				os<<*node;
			return os;
		}
	private:
		//节点
		class Node
		{
			public:
				Node(T const& data,Node* prev=NULL,Node* next=NULL):m_data(data),m_prev(prev),m_next(next){}
				friend ostream& operator<<(ostream &os,Node const& node)
				{
					return os<<'['<<node.m_data<<']';
				}
				T m_data;			//数据
				Node* m_prev;		//前指针
				Node* m_next;		//后指针
		};
		//判等函数的通用版本
		bool equal(T const &a,T const &b) const
		{
			return a==b;
		}
		Node *m_head;				//头指针
		Node *m_tail;				//尾指针
	public:
		//正向迭代器
		class Iterator
		{
			public:
				Iterator(Node *head=NULL,Node* tail=NULL,Node* node=NULL):m_head(head),m_tail(tail),m_node(node){}
				bool operator==(Iterator const& rhs) const{
					return m_node==rhs.m_node;
				}
				bool operator!=(Iterator const& rhs) const{
					return !(*this==rhs);
				}
				Iterator &operator++(void){
					if(m_node!=NULL)
					    m_node=m_node->m_next;
					else
						m_node=m_head;
					return *this;
				}
				Iterator const operator++(int){
					Iterator old=*this;
					++*this;
					return old;
				}
				Iterator &operator--(void){
					if(m_node!=NULL)
						m_node=m_node->m_prev;
					else
						m_node=m_tail;
					return *this;
				}
				Iterator const operator--(int){
					Iterator old=*this;
					--*this;
					return old;
				}
				T& operator*(void) const{
					return m_node->m_data;
				}
				T* operator->(void) const{
					return &**this;
				}
			private:
				Node* m_head;
				Node* m_tail;
				Node* m_node;
				friend class List;
		};
		//获取起始正向迭代器,指向容器的首元素
		Iterator begin(void)
		{
			return Iterator(m_head,m_tail,m_head);
		}
		//获取终止正向迭代器,指定容器的尾元素之后
		Iterator end(void)
		{
			return Iterator(m_head,m_tail);
		}
		//在正向迭代器之前插入
		Iterator insert(Iterator loc,T const& data)
		{
			if(loc==end())
			{
				push_back(data);
				return Iterator(m_head,m_tail,m_tail);
			}
			else
			{
				Node* node=new Node(data,loc.m_node->m_prev,loc.m_node);
				if(node->m_prev)
					node->m_prev->m_next=node;
				else
					m_head=node;
				node->m_next->m_prev=node;
				return Iterator(m_head,m_tail,node);
			}
		}
};
//判等函数针对char const*类型的特化版本
template<>
bool List<char const*>::equal(char const* const &a,char const* const &b) const
{
	return !strcmp(a,b);
}
//测试用例
void test1(void)
{
	List<int> l1;
	l1.push_front(50);
	l1.push_front(40);
	l1.push_front(30);
	l1.push_front(20);
	l1.push_front(10);
	cout<<l1<<endl;
	l1.pop_front();
	cout<<l1<<endl;
	l1.push_back(60);
	l1.push_back(70);
	l1.push_back(80);
	l1.push_back(90);
	cout<<l1<<endl;
	l1.pop_back();
	cout<<l1<<endl;
	l1.back()-=5;
	cout<<l1<<endl;
	List<int> const* cp=&l1;
//	cp->back()--;
	cout<<cp->back()<<endl;
	l1.push_front(50);
	l1.push_front(50);
	l1.push_back(50);
	l1.push_back(50);
	cout<<l1<<endl;
	l1.remove(50);
	cout<<l1<<endl;
	cout<<l1.size()<<' '<<boolalpha<<l1.empty()<<endl;
	l1.clear();
	cout<<l1.size()<<' '<<boolalpha<<l1.empty()<<endl;
	l1.push_back(10);
	l1.push_back(20);
	l1.push_back(30);
	l1.push_back(40);
	l1.push_back(50);
	cout<<l1<<endl;
	List<int> l2=l1;
	cout<<l1<<endl;
	l1.push_back(10);
	++l1.front();
	--l2.back();
	cout<<l1<<endl;
	cout<<l2<<endl;
	l1=l2;
	cout<<l1<<endl;
	cout<<l2<<endl;
	l1.pop_front();
	l2.pop_back();
	cout<<l1<<endl;
	cout<<l2<<endl;
}
void test2(void)
{
	char sa[][256]={"北京","天津","北京","上海","浙江"};
	List<char const*> ls;
	for(size_t i=0;i<sizeof(sa)/sizeof(sa[0]);++i)
		ls.push_back(sa[i]);
	cout<<ls<<endl;
	ls.remove("北京");
	cout<<ls<<endl;
}
void test3(void)
{
	List<int> l1;
	for(int i=0;i<10;i++)
		l1.push_back((i+1)*10);
	cout<<l1<<endl;
	l1[4]/=10;
	cout<<l1<<endl;
	l1[4]=l1[1]+l1[8];
	cout<<l1<<endl;
	List<int> const l2=l1;
	cout<<l2<<endl;
	cout<<l2[4]<<endl;
	List<int>::Iterator it=l1.begin();
	*(++++++++it)=987;
	cout<<l1<<endl;
}
void test4(void)
{
	List<int> l1;
	l1.insert(l1.end(),10);
	l1.insert(l1.end(),50);
	cout<<l1<<endl;
}
void test5(void)
{
	int array[]={13,29,17,36,35};
}
int main(void)
{
//	test1();
//	test2();
//	test3();
	test4();
//	test5();
}
