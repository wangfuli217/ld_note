#include<list>
#include<iostream>
using namespace std;

template<typename T>
class List
{
public:
	List():_pHead(NULL){}
	void push_back(T const &data)
	{
		if(_pHead==NULL)
			_pHead=new Node(data);
		else
		{
			Node *pTemp=_pHead;
			while(pTemp->_pNext!=NULL)
				pTemp=pTemp->_pNext;
			pTemp->_pNext=new Node(data);
		}
	}
	void print(void) const
	{
		Node *pTemp=_pHead;
		while(pTemp!=NULL)
		{
			cout<<pTemp->_data<<endl;
			pTemp=pTemp->_pNext;
		}
	}
	void back(void)
	{
		Node *p1=_pHead;
		Node *p2=_pHead->_pNext;
		Node *p3=NULL;
		while(p2!=NULL)
		{
			p3=p2->_pNext;
			p2->_pNext=p1;
			p1=p2;
			p2=p3;
		}
		_pHead->_pNext=NULL;
		_pHead=p1;
	}
	void back_print(void) const
	{
		static Node *pTemp=_pHead;
		if(pTemp!=NULL)
		{
			Node *p1=pTemp;
			pTemp=pTemp->_pNext;
			back_print();
			cout<<p1->_data<<endl;
		}
	}
private:
	class Node
	{
	public:
		Node(T data=T()):_data(data),_pNext(NULL){}
	private:
		T _data;
		Node *_pNext;
		friend class List;
	};
	Node *_pHead;
};
int main(void)
{
	List<int> li;
	li.push_back(3);
	li.push_back(4);
	li.push_back(5);
	li.push_back(6);
	li.push_back(7);
	li.print();
	cout<<"反"<<endl;
	li.back();
	li.print();
	cout<<"反"<<endl;
	li.back_print();
	return 0;
}
