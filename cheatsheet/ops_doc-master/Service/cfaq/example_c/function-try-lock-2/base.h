class C {
public:
	C(int x);
private:
	int _x;
};


class A {
public:
	A(int x);
private:
	int _x;
};

class B : public A {
public:
	B(int x);
private:
	C c;
};


