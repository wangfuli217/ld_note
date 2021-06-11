#ifndef __CB_cb_allocator_H_
#define __CB_cb_allocator_H_

#include <memory>
#include <limits>

using namespace std;

template<typename T>
class cb_allocator {
public : 
    //    typedefs
    typedef T value_type;
    typedef value_type* pointer;
    typedef const value_type* const_pointer;
    typedef value_type& reference;
    typedef const value_type& const_reference;
    typedef std::size_t size_type;
    typedef std::ptrdiff_t difference_type;

public : 
    //    convert an cb_allocator<T> to cb_allocator<U>
    template<typename U>
    struct rebind {
        typedef cb_allocator<U> other;
    };

public : 
    inline explicit cb_allocator():data(malloc(8192)), idx(0) {}
    inline ~cb_allocator() {}
    inline explicit cb_allocator(cb_allocator const&) {}
    template<typename U>
    inline explicit cb_allocator(cb_allocator<U> const&) {}

    //    address
    inline pointer address(reference r) { return &r; }
    inline const_pointer address(const_reference r) { return &r; }

    //    memory allocation
    inline pointer allocate(size_type cnt, typename std::allocator<void>::const_pointer = 0) { 
		idx += cnt * sizeof(T);
		return reinterpret_cast<pointer>(data + idx); 
    }
    inline void deallocate(pointer p, size_type) { 
        
    }

    //    size
    inline size_type max_size() const { 
        return std::numeric_limits<size_type>::max() / sizeof(T);
	}

    //    construction/destruction
    inline void construct(pointer p, const T& t) { new(p) T(t); }
    inline void destroy(pointer p) { p->~T(); }

    inline bool operator==(cb_allocator const&) { return true; }
    inline bool operator!=(cb_allocator const& a) { return !operator==(a); }
	
private:
	void 			*data;
	unsigned int 	idx;
};    //    end of class cb_allocator 

#endif