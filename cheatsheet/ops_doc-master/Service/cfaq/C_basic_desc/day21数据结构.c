�ؼ��֣������� Binary Tree

/*������ Binary Tree*/
�������������߼��ṹ�е����νṹ
	
	����ָÿ���ڵ����ֻ�������ӽڵ�����νṹ��
	Ҳ�������ֻ�������ֲ�����νṹ��

	�������νṹ�е���ʼ�ڵ�������ڵ㣬
	���˸��ڵ�֮�⣬����ÿ���ڵ�����ֻ��һ�����ڵ㣬������������ֻ��һ�����ڵ㣻
	
	û���κ��ӽڵ�Ľڵ����Ҷ�ӽڵ㣬Ҷ�ӽڵ��и��ڵ㵫û���ӽڵ㣻

	���˸��ڵ��Ҷ�ӽڵ�֮�⣬ʣ�µ����нڵ㶼����֦�ڵ㣬֦�ڵ��и��ڵ�Ҳ���ӽڵ�;

	����ö�������ÿ��ڵ�������ﵽ�����ֵ��
	��������֦�ڵ㶼�������ӽڵ㣬�����Ķ�������������������

	����ö������г���������һ��֮�⣬����ÿ��ڵ�������ﵽ�����ֵ��
	����������һ������нڵ㶼������������࣬�����Ķ������ͽ�����ȫ��������

��������������
	���������еݹ�Ƕ��ʽ�Ŀռ�ṹ��������˲��õݹ�ķ���ȥ������������⣬
	��ʹ�ô����㷨���Ӽ�࣬������ķ�ʽ���£�

	������������
	{
		if(������Ϊ��)ֱ�Ӵ���
		else
		{
			�����������������ӽڵ�Ϊ���ڵ��С������ �ݹ飩��
			�����������������ӽڵ�Ϊ���ڵ��С������ �ݹ飩��
			������ڵ㣻
		}
	}

�������Ĵ洢�ṹ
	1. ˳��洢��һ����˵�����ϵ��£����������δ�Ÿ����ڵ㣬
		    ���ڷ���ȫ��������Ҫʹ����ڵ㲹����ȫ��������

	2. ��ʽ�洢��һ����˵��ÿ���ڵ�������������ݣ�
		    һ����¼����Ԫ�ر��� �� �����ֱ�ָ�������ӽڵ��ַ��ָ�룻

		typedef struct node{
			int data;		//��¼����Ԫ�ر���
			struct node *left;	//��¼���ӽڵ��ַ
			struct node *right;	//��¼���ӽڵ��ַ
		}Node;

��������������
	������binary_tree_create��
	���٣�binary_tree_destroy��
	������Ԫ�أ�binary_tree_insert��
	����������������Ԫ�أ�binary_tree_travel��
	ɾ��Ԫ�أ�binary_tree_delete��
`	����Ԫ�أ�binary_tree_find��
	*�޸�Ԫ�أ�binary_tree_modify��	
	*�ж��Ƿ�Ϊ�գ�binary_tree_empty��
	*�ж��Ƿ�Ϊ����binary_tree_full��
	*�鿴�������и��ڵ�Ԫ��ֵ��binary_tree_root��
	*�������������ЧԪ�ظ�����binary_tree_size��
	*��ն�������binary_tree_clear��

������������ʽ
	1. ���������DLR => data left right��
		�ȱ������ڵ㣬�ٱ��������������������������ֽ����ȸ�������
	2. ���������LDR => left data right��
		�ȱ������������ٱ������ڵ㣬���������������ֽ����и�������
	3. ���������LRD => left right data��
		�ȱ������������ٱ��������������������ڵ㣬�ֽ������������
		
			30
	20  		35 
15		25			40


30 20 15 25 35 40
15 20 25 30 35 40
15 25 20 40 35 30

���������
	�����������������ķǿն������ͽ������������
	1. �����������Ϊ�գ��������������нڵ��Ԫ��ֵ��С�ڵ��ڸ��ڵ�Ԫ��ֵ��
	2. �����������Ϊ�գ��������������нڵ��Ԫ��ֵ�����ڵ��ڸ��ڵ�Ԫ��ֵ��
	3. ���������ڲ���Ȼ������������
ʵ��Ӧ��
	��Ҫ������Ҫ���в��Һ�����ĳ����У��ֽ��������������

��ϰ:
	ʹ���������ݺϳ������������ʹ�����ַ�������
	50 �����ڵ㣩 70 20 60 40 30 10 90 80

			50
	    20      70
	 10   40  60   90	
         30       80

	50 20 10 40 30 70 60 90 80 �������
	10 20 30 40 50 60 70 80 90 �������
	10 30 40 20 60 80 90 70 50 �������

���ʵ������������ı���

//���ʵ������������Ļ�������
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

//����ڵ����������
typedef struct node
{
	int data;//��¼����Ԫ�ر���
	struct node* left;//��¼���ӽڵ�ĵ�ַ
	struct node* right;//��¼���ӽڵ�ĵ�ַ
}Node;

//�����������������������
typedef struct
{
	Node* root;//��¼���ڵ�ĵ�ַ
	int cnt;//��¼��ЧԪ�صĸ���
}Binary_tree;

//ʵ������������Ĵ���
Binary_tree* binary_tree_create(void);
//ʵ�����������������
void binary_tree_destroy(Binary_tree* pbt);
//ʵ�ֲ���Ԫ�ص������������
void binary_tree_insert(Binary_tree* pbt,int data);
//ʵ�ֲ���Ԫ�صĵݹ麯��
void insert(Node** pRoot,Node* pn);
//ʵ�ֱ�����������������нڵ�Ԫ��
void binary_tree_travel(Binary_tree* pbt);
//ʵ�ֱ����ĵݹ麯��
void travel(Node* root);
//ʵ�ֲ���ָ��Ԫ��
Node** binary_tree_find(Binary_tree* pbt,int data);
//ʵ�ֲ���ָ��Ԫ�صĵݹ麯��
Node** find(Node** pRoot,int data);
//ʵ��ɾ��ָ��Ԫ�����ڵĽڵ�
int binary_tree_delete(Binary_tree* pbt,int data);
//ʵ���ж�����������Ƿ�Ϊ��
bool binary_tree_empty(Binary_tree* pbt);
//ʵ���ж�����������Ƿ�Ϊ��
bool binary_tree_full(Binary_tree* pbt);
//ʵ�ּ����������������Ч�ڵ�ĸ���
int binary_tree_size(Binary_tree* pbt);
//ʵ�ֲ鿴���ڵ�Ԫ��ֵ
int binary_tree_root(Binary_tree* pbt);
//ʵ���޸�ָ��Ԫ��ֵ
void binary_tree_modify(Binary_tree* pbt,int old_data,int new_data);
//ʵ��������������
void binary_tree_clear(Binary_tree* pbt);
//ʵ����յĵݹ麯��
void clear(Node** pRoot);

int main(void)
{
	//���������������ʹ��binary_tree_create����
	Binary_tree* pbt = binary_tree_create();

	binary_tree_insert(pbt,50);
	binary_tree_travel(pbt);// 50
	binary_tree_insert(pbt,70);
	binary_tree_travel(pbt);// 50 70
	binary_tree_insert(pbt,20);
	binary_tree_travel(pbt);// 20 50 70
	binary_tree_insert(pbt,60);
	binary_tree_travel(pbt);// 20 50 60 70

	printf("---------------------------------\n");
	binary_tree_delete(pbt,50);
	binary_tree_travel(pbt);// 20 60 70

	printf("---------------------------------\n");
	printf("%s\n",binary_tree_empty(pbt)?"����������Ѿ�����":"���������û�п�");//���������û�п�
	printf("%s\n",binary_tree_full(pbt)?"����������Ѿ�����":"���������û����");//���������û����
	printf("�������������ЧԪ�صĸ����ǣ�%d\n",binary_tree_size(pbt));// 3
	printf("����������и��ڵ�Ԫ���ǣ�%d\n",binary_tree_root(pbt)); // 70

	printf("---------------------------------\n");
	binary_tree_modify(pbt,20,200);
	binary_tree_travel(pbt); // 60 70 200 

	printf("---------------------------------\n");
	binary_tree_clear(pbt);
	binary_tree_travel(pbt); // ɶҲû��

	//���������������ʹ��binary_tree_destroy����
	binary_tree_destroy(pbt);
	pbt = NULL;
	return 0;
}

//ʵ����յĵݹ麯��
void clear(Node** pRoot)
{
	if(*pRoot != NULL)
	{
		//1.������������ݹ�
		clear(&(*pRoot)->left);
		//2.������������ݹ�
		clear(&(*pRoot)->right);
		//3.��ո��ڵ�
		free(*pRoot);
		*pRoot = NULL;
	}
}

//ʵ���޸�ָ��Ԫ��ֵ
void binary_tree_modify(Binary_tree* pbt,int old_data,int new_data)
{
	//1.ɾ����Ԫ��
	int res = binary_tree_delete(pbt,old_data);
	if(-1 == res)
	{
		printf("Ŀ��Ԫ�ز����ڣ��޸�ʧ��\n");
		return;//������ǰ����
	}
	//2.������Ԫ��
	binary_tree_insert(pbt,new_data);
}

//ʵ��������������
void binary_tree_clear(Binary_tree* pbt)
{
	//1.���õݹ麯��ʵ�����������
	clear(&pbt->root);
	//2.�ڵ������� 0
	pbt->cnt = 0;
}

//ʵ���ж�����������Ƿ�Ϊ��
bool binary_tree_empty(Binary_tree* pbt)
{
	return NULL == pbt->root;
}

//ʵ���ж�����������Ƿ�Ϊ��
bool binary_tree_full(Binary_tree* pbt)
{
	return false;
}

//ʵ�ּ����������������Ч�ڵ�ĸ���
int binary_tree_size(Binary_tree* pbt)
{
	return pbt->cnt;
}

//ʵ�ֲ鿴���ڵ�Ԫ��ֵ
int binary_tree_root(Binary_tree* pbt)
{
	//�ж�����������Ƿ�Ϊ��
	if(binary_tree_empty(pbt))
	{
		return -1;//��ʾ�鿴ʧ��
	}
	return pbt->root->data;
}

//ʵ��ɾ��ָ��Ԫ�����ڵĽڵ�
int binary_tree_delete(Binary_tree* pbt,int data)
{
	//1.����Ŀ��Ԫ�����ڵĵ�ַ
	Node** ppt = binary_tree_find(pbt,data);
	if(NULL == *ppt)
	{
		return -1;//��ʾ����ʧ��
	}
	//2.���ýڵ���������ϲ�����������
	if((*ppt)->left != NULL)
	{
		insert(&(*ppt)->right,(*ppt)->left);
	}
	//3.ʹ����ʱָ���¼Ҫɾ���Ľڵ��ַ
	Node* pt = *ppt;
	//4.��ԭ��ָ��Ҫɾ���ڵ��ַ��ָ��ָ�����ӽڵ�
	*ppt = (*ppt)->right;
	//5.ɾ��Ŀ��Ԫ�����ڵĽڵ�
	free(pt);
	pt = NULL;
	//6.�ڵ�Ԫ�صĸ��� ��1
	pbt->cnt--;
	//7.����ɾ���ɹ�
	return 0;
}

//ʵ�ֲ���ָ��Ԫ�صĵݹ麯��
Node** find(Node** pRoot,int data)
{
	//1.������������Ϊ�գ��򷵻ز���ʧ��
	if(NULL == *pRoot)
	{
		return pRoot; //�������ʧ��
	}
	//2.���Ŀ��Ԫ�ص��ڸ��ڵ�Ԫ�أ��򷵻ز��ҳɹ�
	if(data == (*pRoot)->data)
	{
		return pRoot; //������ҳɹ�
	}
	//3.���Ŀ��Ԫ��С�ڸ��ڵ�Ԫ�أ������������
	else if(data < (*pRoot)->data)
	{
		return find(&(*pRoot)->left,data);
	}
	//4.���Ŀ��Ԫ�ش��ڸ��ڵ�Ԫ�أ������������
	else
	{
		return find(&(*pRoot)->right,data);
	}
}

//ʵ�ֲ���ָ��Ԫ��
//ʵ�ʷ��ص���ָ��Ŀ��Ԫ�����ڽڵ��ָ��ĵ�ַ 
Node** binary_tree_find(Binary_tree* pbt,int data)
{
	//���õݹ麯�����в���
	return find(&pbt->root,data);
}

//ʵ�ֱ����ĵݹ麯��
void travel(Node* root)
{
	// ��ʾ�������������������һ�����ڵ�
	if(root != NULL)
	{
		//1.������������ʹ�õݹ�
		travel(root->left);
		//2.�������ڵ�
		printf("%d ",root->data);
		//3.������������ʹ�õݹ�
		travel(root->right);
	}
}

//ʵ�ֱ�����������������нڵ�Ԫ��
void binary_tree_travel(Binary_tree* pbt)
{
	//1.�������������ʽ���б��������õݹ麯��
    travel(pbt->root);
	//2.��ӡ����
	printf("\n");
}

//ʵ�ֲ���Ԫ�صĵݹ麯��
void insert(Node** pRoot,Node* pn)
{
	//1.������������Ϊ�գ���ֱ�Ӳ���
	// Node** pRoot = &pbt->root;
	// pRoot = &pbt->root;
	// *pRoot = *(&pbt->root) = pbt->root;
	if(NULL == *pRoot)
	{
		*pRoot = pn;
		return;//������ǰ����
	}
	//2.��������������Ϊ�գ��͸��ڵ�Ԫ�رȽ�
	//2.1 ������ڵ�Ԫ�ش�����Ԫ�أ��������������
	if((*pRoot)->data > pn->data)
	{
		insert(&(*pRoot)->left,pn);
	}
	//2.2 ������ڵ�Ԫ��С�ڵ�����Ԫ�أ�����������
	else
	{
		insert(&(*pRoot)->right,pn);
	}
}

//ʵ�ֲ���Ԫ�ص������������
void binary_tree_insert(Binary_tree* pbt,int data)
{
	//1.�����½ڵ㣬�����г�ʼ��
	Node* pn = (Node*)malloc(sizeof(Node));
	if(NULL == pn)
	{
		printf("�����½ڵ�ʧ�ܣ���������\n");
		return;
	}
	pn->data = data;
	pn->left = NULL;
	pn->right = NULL;
	//2.�����½ڵ㵽���ʵ�λ���ϣ����õݹ麯��
	insert(&pbt->root,pn);
	//3.�ڵ�Ԫ�صĸ��� ��1
	pbt->cnt++;
}

//ʵ������������Ĵ���
Binary_tree* binary_tree_create(void)
{
	//1.�������������
	Binary_tree* pbt = (Binary_tree*)malloc(sizeof(Binary_tree));
	if(NULL == pbt)
	{
		printf("�������������ʧ�ܣ��������\n");
		exit(-1);
	}
	//2.��ʼ����Ա
	pbt->root = NULL;
	pbt->cnt = 0;
	//3.����������������׵�ַ
	return pbt;
}

//ʵ�����������������
void binary_tree_destroy(Binary_tree* pbt)
{
	free(pbt);
	pbt = NULL;
}



��ҵ�����ʵ�������������������������

Ԥϰ���㷨�ĸ��� ����
	���õĲ����㷨
	���õ������㷨













