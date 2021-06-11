int main(void){
	const int a=1;
	int const b=2; //前面两种方式相同
	const int c; //如果在定义时不赋初值，后面将没有机会，因为它是只读的
	int const array[5]={1,2,3,4,5};
	const int brray[5]={1,2,3,4,5};
	int x=1,y=2,z=3,u=4;
	const int *p1=&x; //p1可变，*p1只读
	int const *p2=&y; //p2可变，*p2只读
	int *const p3=&z; //p3只读，*p3可变
	const int *const p4=&u; //p4只读，*p4只读
	//a=3; //error C2166: l-value specifies const object
	//b=4; //error C2166: l-value specifies const object
	//c=5; //error C2166: l-value specifies const object
	//array[0]=6; //error C2166: l-value specifies const object
	//brray[0]=6; //error C2166: l-value specifies const object
	x=7; 
	//*p1=7; //error C2166: l-value specifies const object
	p1=&y;
	y=8;
	//*p2=8; //error C2166: l-value specifies const object
	p2=&x;
	z=9;
	*p3=10;
	//p3=&x; //error C2166: l-value specifies const object
	u=11;
	//*p4=12; //error C2166: l-value specifies const object
	//p4=&x; //error C2166: l-value specifies const object
    return 0;
}
/*
看起来有点混乱，不过这里有一个记忆和理解的方法：
先忽略类型名(编译器解析的时候也是忽略类型名)，我们看const离哪个近。”近水楼台先得月”，离谁近就修饰谁
判断时忽略括号中的类型
    const (int) *p; //const修饰*p，*p是指针指向的对象，不可变
    (int) const *p； //const修饰*p，*p是指针指向的对象，不可变
    (int)*const p; //const修饰p，p不可变，p指向的对象可变
    const (int) *const p; //前一个const修饰*p，后一个const修饰p，指针p和p指向的对象都不可变
*/