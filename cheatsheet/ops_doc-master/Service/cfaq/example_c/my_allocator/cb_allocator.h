#ifndef __CB_ALLOCATOR_H_
#define __CB_ALLOCATOR_H_

#include <memory>
#include <limits>

using namespace std;

template<typename T>
class cb_allocator {
public : 
    //    typedefs
    typedef T 					value_type;
    typedef value_type* 		pointer;
    typedef const value_type* 	const_pointer;
    typedef value_type& 		reference;
    typedef const value_type& 	const_reference;
    typedef std::size_t 		size_type;
    typedef std::ptrdiff_t 		difference_type;

public : 
    //    convert an cb_allocator<T> to cb_allocator<U>
    template<typename U>
    struct rebind {
        typedef cb_allocator<U> other;
    };

public : 
    inline cb_allocator() {}
    inline ~cb_allocator() {}
    inline cb_allocator(const cb_allocator&) {}
    template<typename U>
    inline cb_allocator(const cb_allocator<U>&) {}

    //    address
    inline pointer address(reference r) { return &r; }
    inline const_pointer address(const_reference r) { return &r; }

    //    memory allocation
    inline pointer allocate(size_type cnt, typename std::allocator<void>::const_pointer = 0) { 
		return reinterpret_cast<pointer>(::operator new(cnt * sizeof (T))); 
    }
    inline void deallocate(pointer p, size_type) { 
        ::operator delete(p); 
    }

    //    size
    inline size_type max_size() const { 
        return std::numeric_limits<size_type>::max() / sizeof(T);
	}

    //    construction/destruction
    inline void construct(pointer p, const T& t) { new(p) T(t); } // 创建对象的实例
    inline void destroy(pointer p) { p->~T(); } // 销毁对象实例

    inline bool operator==(cb_allocator const&) { return true; }
    inline bool operator!=(cb_allocator const& a) { return !operator==(a); }
};    //    end of class cb_allocator 

#endif