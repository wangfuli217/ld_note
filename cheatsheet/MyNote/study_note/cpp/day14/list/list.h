#ifndef _LIST_H
#define _LIST_H
template<typename T>
class Node
{
	public:
		Node(T data);
		Node *p_next;
		Node *p_pri;
		T m_data;
	private:
};
template<typename T>
class List
{
	public:
		List(void);								//构造函数
		~List(void);							//析构函数
		void push_front(T const &data);			//压入首元素
		void push_back(T const &data);			//压入尾元素
		T &front(void);							//获取首元素
		T &back(void);							//获取尾元素
		T pop_front(void);						//弹出首元素
		T  pop_back(void);						//弹出尾元素
		bool empty(void);						//判断是否为空
		void clear(void);						//清空
		int size(void)							//获取大小
		{
			return m_size;
		}
	private:
		Node<T> *p_head;
	    Node<T> *p_tail;
		int m_size;
};
#include "list.cpp"
#endif
