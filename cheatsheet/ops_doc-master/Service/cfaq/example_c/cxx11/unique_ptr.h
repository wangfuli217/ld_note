#ifndef __UNIQUE_PTR_H_
#define __UNIQUE_PTR_H_

#include "shared_ptr.h"
#include <memory>
#include <iostream>
#include <utility>

using namespace std;

class DeleterU {
public:
	DeleterU(Deleter& d) { __CONSOLE__("is refenec %s\n", __func__); }
	DeleterU(const Deleter& d) { __CONSOLE__("is const refenec %s\n", __func__); }
	DeleterU(Deleter&& d) { __CONSOLE__("is moved %s\n", __func__); }
	DeleterU() {}
	~DeleterU() {}
	
	void operator() (A* pa) { __CONSOLE__("destory A\n"); delete pa; }
};


static void
__unique_ptr()
{
	A *pa = new A(100);
	DeleterU du;
	
	unique_ptr<A> up(pa);
	unique_ptr<A> up2(std::move(up)); //不能直接通过copy 构造, 通过std::move ok
	unique_ptr<A, DeleterU> up3(new A(200), DeleterU());
	unique_ptr<A, DeleterU> up4(new A(200), du);
	unique_ptr<A, DeleterU> up5(std::move(up4));
}


static void
__unique_ptr_2()
{

	struct Foo { // object to manage
		Foo() { std::cout << "Foo ctor\n"; }
		Foo(const Foo&) { std::cout << "Foo copy ctor\n"; }
		Foo(Foo&&) { std::cout << "Foo move ctor\n"; }
		~Foo() { std::cout << "~Foo dtor\n"; }
	};
	 
	struct D { // deleter
		D() {};
		D(const D&) { std::cout << "D copy ctor\n"; }
		D(D&) { std::cout << "D non-const copy ctor\n";}
		D(D&&) { std::cout << "D move ctor \n"; }
		void operator()(Foo* p) const {
			std::cout << "D is deleting a Foo\n";
			delete p;
		};
	};
 
    std::cout << "Example constructor(1)...\n";
    std::unique_ptr<Foo> up1;  // up1 is empty
    std::unique_ptr<Foo> up1b(nullptr);  // up1b is empty
 
    std::cout << "Example constructor(2)...\n";
    {
        std::unique_ptr<Foo> up2(new Foo); //up2 now owns a Foo
    } // Foo deleted
 
    std::cout << "Example constructor(3)...\n";
    D d;
    {  // deleter type is not a reference
       std::unique_ptr<Foo, D> up3(new Foo, d); // deleter copied
    }
    {  // deleter type is a reference 
       std::unique_ptr<Foo, D&> up3b(new Foo, d); // up3b holds a reference to d
    }
 
    std::cout << "Example constructor(4)...\n";
    {  // deleter is not a reference 
       std::unique_ptr<Foo, D> up4(new Foo, D()); // deleter moved
    }
 
    std::cout << "Example constructor(5)...\n";
    {
       std::unique_ptr<Foo> up5a(new Foo);
       std::unique_ptr<Foo> up5b(std::move(up5a)); // ownership transfer
    }
 
    std::cout << "Example constructor(6)...\n";
    {
        std::unique_ptr<Foo, D> up6a(new Foo, d); // D is copied
        std::unique_ptr<Foo, D> up6b(std::move(up6a)); // D is moved
 
        std::unique_ptr<Foo, D&> up6c(new Foo, d); // D is a reference
        std::unique_ptr<Foo, D> up6d(std::move(up6c)); // D is copied
    }
 
    std::cout << "Example constructor(7)...\n";
    {
        std::auto_ptr<Foo> up7a(new Foo);
        std::unique_ptr<Foo> up7b(std::move(up7a)); // ownership transfer
    }
}

#endif
