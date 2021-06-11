#include<iostream>
using namespace std;

template<typename T>
Node<T>::Node(T data):m_data(data){}

template<typename T>
List<T>::List(void):p_head(NULL),p_tail(NULL),m_size(0){}

template<typename T>
List<T>::~List(void)
{
	clear();
}

template<typename T>
void List<T>::clear(void)
{
	while(m_size!=0)
	{
		Node<T> *p_temp=p_head;
		p_head=p_head->p_next;
		delete p_temp;
		m_size--;
	}
	p_head=p_tail=NULL;
	m_size=0;
}

template<typename T>
void List<T>::push_front(T const &data)
{
	Node<T> *p_temp=new Node<T>(data);
	if(p_head==NULL)
		p_head=p_tail=p_temp;
	else
	{
		p_head->p_pri=p_temp;
		p_temp->p_next=p_head;
		p_head=p_temp;
	}
	m_size++;
}

template<typename T>
void List<T>::push_back(T const &data)
{
	Node<T> *p_temp=new Node<T>(data);
	if(p_head==NULL)
		p_head=p_tail=p_temp;
	else
	{
		p_tail->p_next=p_temp;
		p_temp->p_pri=p_tail;
		p_tail=p_temp;
	}
	m_size++;
}

template<typename T>
T &List<T>::front(void)
{
	return p_head->m_data;
}

template<typename T>
T &List<T>::back(void)
{
	return p_tail->m_data;
}

template<typename T>
T List<T>::pop_front(void)
{
	if(m_size==0)
		cout<<"容器是空的"<<endl;
	else
	{
		Node<T> *p_temp=p_head;
		T temp=p_temp->m_data;
		if(p_head!=p_tail)
			p_head->p_next->p_pri=NULL;
		p_head=p_head->p_next;
		delete p_temp;
		m_size--;
		return  temp; 
	}
}

template<typename T>
T List<T>::pop_back(void)
{
	if(m_size==0)
		cout<<"容器是空的"<<endl;
	else
	{
		Node<T> *p_temp=p_tail;
		T temp=p_temp->m_data;
		if(p_head!=p_tail)
			p_tail->p_pri->p_next=NULL;
		p_tail=p_tail->p_pri;
		delete p_temp;
		m_size--;
		return  temp; 
	}
}

template<typename T>
bool List<T>::empty(void)
{
	if(m_size==0)
		return true;
	return false;
}

