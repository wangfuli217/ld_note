#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
#include <string.h>
#include <queue>
using namespace std;

#define MAX_NODES 100
#define NO_EDGE -1
#define NO_PARE -1
/*邻接矩阵*/

queue<int> assist_print;

typedef struct node{
	int source;
	int num;/*元素的个数*/
	int size;
	int nodenum[MAX_NODES];
	int nodedist[MAX_NODES];
	int adj[MAX_NODES][MAX_NODES];/*不能为负数,所有用-1表示不相邻的两个点*/
	int pare[MAX_NODES];
	
	node()
	{
		int i,j;
		for(i=0;i<MAX_NODES;i++)
		for(j=0;j<MAX_NODES;j++)
		adj[i][j] = NO_EDGE;
		for(i =0;i<MAX_NODES;i++)
		pare[i] = NO_PARE;
		//memset(node->pare,sizeof(node->pare),NO_PARE);
	}
	
	 int build_heap();
	 int getMindistAndUpdateHeap();
	 int updateHeap(int);
	 int max_hepify(int i);
	 void printDist();
private:
	void printPath(int v);
}Nodes;

int Nodes::max_hepify(int i)
{
	int l,r,least = i;
	l = 2*i + 1;
	r = 2*i + 2;
	
	if(l < num && nodedist[nodenum[l]] < nodedist[nodenum[least]])/*有左节点*/
		least = l;
		
	if(r < num && nodedist[nodenum[r]] < nodedist[nodenum[least]])
		least = r;
		
	if(least!=i)
	{
		int t;
		t = nodenum[least];
		nodenum[least] = nodenum[i];
		nodenum[i] = t;
		max_hepify(least);
	}
	
	return 0;
}
int Nodes::getMindistAndUpdateHeap()
{
	if(num > 0)
	{
		return nodenum[0];
	}
	else
		return -1;/*返回-1表示Nodes中没有元素了*/
}
int Nodes::build_heap()
{
	int n = num/2 ,i;
	for(i = n-1;i>=0;i--)
	{
		max_hepify(i);
	}
	return 0;
}
/*根据v节点，来更新堆中数据*/
int Nodes::updateHeap(int v)
{
	int i,t,j;
	for(i =0;i<num;i++)
	{
		t = nodenum[i];
		if(adj[v][t] != NO_EDGE)/*t是v的邻居节点*/
		{
			if(nodedist[t] > nodedist[v] + adj[v][t])
			{
				nodedist[t] = nodedist[v] + adj[v][t];
				/*节点t对应的那个位置发生了变化，需要调整最大堆（但是根不需要调整
				  根节点的调整在本函数的下面部分
				*/
				for(j = i;j>0;j--)
				 max_hepify(j);
				pare[t] = v;
			}
		}
	}
	
	num--;
	nodenum[0] = nodenum[num];
	max_hepify(0);
	return 0;
}
void Nodes::printPath(int v)
{
	if(pare[v] == NO_PARE)
	{
		assist_print.push(v);
		return;
	}
	
	printPath(pare[v]);
	assist_print.push(v);
}
void Nodes::printDist()
{
 int i;
 for(i = 1;i<size;i++)
 {
  if(nodedist[i]!=INT_MAX)
  {
   printPath(i);
   while(!assist_print.empty())
   {
    printf("%d-",assist_print.front());
    assist_print.pop();
   }
   printf("\b \n");
  }
  else
   printf("Not reachable from node %d\n",source);
 }
}
void Initialize_SingleDistance(Nodes*node)
{
 int i;
 
 for(i = 0;i<node->num;i++)
 {
  node->nodedist[i] = INT_MAX;
 }
 node->nodedist[node->source] = 0;
}
int di(Nodes*node)
{
 int nodenum;
 Initialize_SingleDistance(node);
 node->build_heap();
 while(node->num>0)
 {
  nodenum = node->getMindistAndUpdateHeap();
  node->updateHeap(nodenum);
 }
 return 0;
}
int test()
{
	int i = 0;
	Nodes node;
	node.num = 6;
	node.size = 6;
	for(i =0;i<6;i++)
	node.nodenum[i] = i;
	/*顶点1的邻接矩阵*/
	node.adj[0][1] = 50;
	node.adj[0][2] = 10;

	/*顶点2的邻接矩阵*/
	node.adj[1][2] = 15;
	node.adj[1][4] = 50;

	/*顶点3的邻接矩阵*/
	node.adj[2][0] = 20;
	node.adj[2][3] = 15;
	/*顶点4的邻接矩阵*/
	node.adj[3][1] = 20;
	node.adj[3][4] = 35;

	node.adj[4][3] = 30;

	node.adj[5][3] = 3;
	node.source = 0;
	di(&node);
	node.printDist();
	return 0;
}

int main()
{
 test();
 
 system("pause");
 
 return 0;
}