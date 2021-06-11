#include<iostream>
#include<cstdio>
using namespace std;

template<typename T>
class bittree
{
private:
	class Node
	{
	public:
		Node(T const& data,Node *pl=NULL,Node *pr=NULL):_data(data),_pLeft(pl),_pRight(pr){}
		~Node(void)
		{
			_pLeft=_pRight=NULL;
		}
	private:
		friend class bittree;
		T _data;
		Node *_pLeft;
		Node *_pRight;
	};
	Node *_pRoot;
public:
	bittree(void):_pRoot(NULL){}
	~bittree(void)
	{
		clear();
	}
	void insert_into(T const& data,Node *pTemp)
	{
		if(data<=pTemp->_data)
			if(pTemp->_pLeft==NULL)
				pTemp->_pLeft=new Node(data);
			else
				insert_into(data,pTemp->_pLeft);
		else
			if(pTemp->_pRight==NULL)
				pTemp->_pRight=new Node(data);
			else
				insert_into(data,pTemp->_pRight);
	}
	void insert_pointer(Node *&pDes,Node *pSour)
	{	
		if(pDes==NULL)
		{
			pDes=pSour;
			return;
		}
		if(pSour->_data<=pDes->_data)
			insert_pointer(pDes->_pLeft,pSour);
		else
			insert_pointer(pDes->_pRight,pSour);
	}
	void order(Node const* pRoot) const   //前序遍历
	{
		if(pRoot!=NULL)
		{
			cout<<pRoot->_data<<endl;
			order(pRoot->_pLeft);
			order(pRoot->_pRight);
		}
	}
	void order_print(void)	const		//前序遍历
	{
		cout<<"前序遍历"<<endl;
		order(_pRoot);
	}
	void inorder(Node const *pRoot) const		  //中序遍历
	{
		if(pRoot!=NULL)
		{
			inorder(pRoot->_pLeft);
			cout<<pRoot->_data<<endl;
			inorder(pRoot->_pRight);
		}
	}
	void inorder_print(void) const    //中序遍历
	{
		cout<<"中序遍历"<<endl;
		inorder(_pRoot);
	}
	void insert(T const &data)
	{
		if(_pRoot==NULL)
			_pRoot=new Node(data);
		else
		{
			insert_into(data,_pRoot);
		}
	}
	void clear_all(Node const* pRoot)
	{
		if(pRoot!=NULL)
		{
			clear_all(pRoot->_pLeft);
			clear_all(pRoot->_pRight);
			delete pRoot;
		}
	}
	void DelAt(T const& data,Node*& pRoot)		
	{
		if(pRoot!=NULL)
		{
			DelAt(data,pRoot->_pLeft);
			DelAt(data,pRoot->_pRight);
			/*if(pRoot->_data==data)
			{
				if(pRoot->_pLeft!=NULL)
					insert_pointer(pRoot->_pRight,pRoot->_pLeft);
				Node *pTemp=pRoot;
				pRoot=pRoot->_pRight;
				delete pTemp;
			}*/
			if(pRoot->_data==data)
			{
				if(pRoot->_pLeft!=NULL)
				{
					Node *pTemp=pRoot->_pLeft;
					Node *pTemp1=pTemp;
					while(pTemp->_pRight!=NULL)
					{
						pTemp1=pTemp;
						pTemp=pTemp->_pRight;
					}
					pRoot->_data=pTemp->_data;
					pTemp1->_pRight=NULL;
					if(pTemp1==pTemp)
						pRoot->_pLeft=pTemp->_pLeft;
					delete pTemp;
				}
				else
				{
					Node *pTemp=pRoot;
					pRoot=pRoot->_pRight;
					delete pTemp;
				}
					
			}
		}
	}
	void Del(T const& data)
	{
		cout<<"删除"<<data<<"后";
		DelAt(data,_pRoot);
	}
	void clear(void)
	{
		clear_all(_pRoot);	
		_pRoot=NULL;
	}
};
bittree<int> bi;
bittree<int> b1;
void test1(void)
{
	bi.insert(100);
	bi.insert(101);
	bi.insert(102);
	bi.insert(1);
	bi.insert(99);
	bi.insert(8);
	bi.insert(8);
	bi.insert(8);
	bi.insert(-1);
	bi.inorder_print();
	bi.Del(1);
	bi.inorder_print();
	bi.Del(101);
	bi.inorder_print();
	bi.Del(99);
	bi.inorder_print();
	bi.Del(100);
	bi.inorder_print();
	bi.Del(102);
	bi.inorder_print();
}
int main(void)
{
	test1();
	return 0;
}
