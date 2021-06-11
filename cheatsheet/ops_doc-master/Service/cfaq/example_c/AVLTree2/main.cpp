#include <iostream>
#include <cstdlib>

using namespace std;

typedef int Type;

struct Node{
    Type key;
    int  height;
    Node* lchild, *rchild;
    Node(){}
    Node( int k, int h, Node* l, Node* r ):
        key(k), height(h), lchild(l), rchild(r) {}
};

class AVLTree{
    private:
        Node* _null;    //   规定的空结点
        Node* root;     //   根结点 
        
        void left_single_rotate( Node*& r );     //  左单旋转 
        void left_double_rotate( Node*& r );     //  左双旋转 
        void right_single_rotate( Node*& r );    //  右单旋转 
        void right_double_rotate( Node*& r );    //  右双旋转 
        
        void erase_rotate_help( Node*& r );      //  删除操作中的旋转 
        
        void travel( int, Node* root );          //  遍历树 
        
        void insert_help( Node*& r, Type key );  //  插入 
        void erase_help ( Node*& r, Type key );  //  删除 
    
    public:
        AVLTree(){ _null= new Node( 0, 0, NULL, NULL ); root= _null; }
        
        void travel();                           //  遍历树 
        void insert( Type key );                 //  插入数据 
        void erase ( Type key );                 //  删除数据 
};


//   左单旋转实现 
void AVLTree::left_single_rotate( Node*& r ){
    Node* tmp= r->rchild;
    r->rchild= tmp->lchild; 
    r->height= max( r->lchild->height, r->rchild->height )+ 1;
    
    tmp->lchild= r; r= tmp;
    r->height= max( r->lchild->height, r->rchild->height )+ 1;
}

//  右单旋转实现 
void AVLTree::right_single_rotate( Node*& r ){
    Node* tmp= r->lchild;
    r->lchild= tmp->rchild;
    r->height= max( r->lchild->height, r->rchild->height )+ 1;
    
    tmp->rchild= r; r= tmp;
    r->height= max( r->lchild->height, r->rchild->height )+ 1;
}

//  左双旋转实现
void AVLTree::left_double_rotate( Node*& r ){
    right_single_rotate( r->rchild );
    left_single_rotate( r );
}

//  右双旋转实现
void AVLTree::right_double_rotate( Node*& r ){
    left_single_rotate( r->lchild );
    right_single_rotate( r );
}

void AVLTree::travel( int parent, Node* r ){
    if( r!= _null ){
        travel( r->key, r->lchild );
        cout << parent << ' ' << r->key << ' ' << r->height << endl;
        travel( r->key, r->rchild ); }
}

void AVLTree::travel(){
    travel( -1, root ); }

void AVLTree::insert_help( Node*& r, Type key ){
    if( r== _null ){
        r= new Node( key, 1, _null, _null ); 
        return;  }
        
    if( key< r->key )  insert_help( r->lchild, key );
    else               insert_help( r->rchild, key );
    
    //  这上面一部分同二叉查找树的代码 ,AVL树只是在其基础上
    //  增加了旋转保持平衡的操作 
    
    
    //  调整根结点的高度，因为增加结点后，高度可能增加 
    r->height= max( r->lchild->height, r->rchild->height )+ 1;
    
    //  如果右子树不为空 
    if( r->rchild!= _null ){
        // 左子树的高度加上1等于右子树的右子树的高度，则左单旋转
        if( r->lchild->height+ 1== r->rchild->rchild->height )
        left_single_rotate( r );
        // 左子树的高度加上1等于右子树的左子树的高度，则左双旋转
        else if( r->lchild->height+ 1== r->rchild->lchild->height )
        left_double_rotate( r );
    }
    //  如果左子树不为空 
    if( r->lchild!= _null ){
        // 右子树的高度加上1等于左子树的左子树的高度，则右单旋转
        if( r->rchild->height+ 1== r->lchild->lchild->height )
        right_single_rotate( r );
        // 右子树的高度加上1等于左子树的右子树的高度，则右双旋转
        else if( r->rchild->height+ 1== r->lchild->rchild->height )
        right_double_rotate( r );
    }
}

void AVLTree::insert( Type key ){
    insert_help( root, key ); }
    
void AVLTree::erase_rotate_help( Node*& r ){
    //  右子树高度比左子树高度大2
    if( r->rchild->height- r->lchild->height== 2  ){
        // 如果右子树的左子树的高度不大于右子树的右子树的高度则对根左单旋转
        if(    r->rchild->lchild->height<= r->rchild->rchild->height )
        left_single_rotate( r );
        // 如果右子树的左子树的高度大于右子树的右子树的高度则对根左双旋转
        else 
        left_double_rotate( r );
    }
    //  左子树高度比右子树高度大2 
    else if( r->lchild->height- r->rchild->height== 2  ){
        //  如果左子树的右子树的高度不大于左子树的左子树的高度则对根右单旋转
        if( r->lchild->rchild->height<= r->lchild->lchild->height )
        right_single_rotate( r );
        //  如果左子树的右子树的高度大于左子树的左子树的高度则对根右双旋转
        else 
        right_double_rotate( r );
    }
}
    
void AVLTree::erase_help( Node*& r, Type key ){
    if( r== _null ) return;  //  没有找到要删除的结点则直接退出 
    
    if( r->key== key ){
        if( r->rchild== _null ){
            Node* tmp= r;
            r= r->lchild; delete tmp;
        }
        else {
            Node* tmp= r->rchild;
            while( tmp->lchild!= _null ) tmp= tmp->lchild;
            
            r->key= tmp->key;
            erase_help( r->rchild, tmp->key );
            r->height= max( r->lchild->height, r->rchild->height )+ 1;
        }
        return ;  }
    
    if( key< r->key ) erase_help( r->lchild, key );
    else              erase_help( r->rchild, key );

    //  同样，这上面一部分同二叉查找树的代码 ,AVL树只是在其基础上
    //  增加了旋转保持平衡的操作 
    
    //  调整高度 
    r->height= max( r->lchild->height, r->rchild->height )+ 1;
    
    //  有可能在左子树中把结点删除导致左子树不平衡
    //  故先检测左子树是否已经平衡，否 则调整 
    if( r->lchild!= _null ) erase_rotate_help( r->lchild );
    
    //  同样右子树中也有可能不平衡，检测右子树并调整 
    if( r->rchild!= _null ) erase_rotate_help( r->rchild );
    
    //  检测根并调整 
    erase_rotate_help( r );
}

void AVLTree::erase( Type key ){
    erase_help( root, key ); }

int main(){
    AVLTree test;
    //freopen("a.txt","w",stdout);
    for( int i= 0; i< 100; ++i )
    if( i& 1 ) test.insert( rand() % 100 );
    else       test.erase ( rand() & 100 );
    
    test.travel();
	
	system("pause");

    return 0;
}
