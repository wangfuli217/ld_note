/*
 * =====================================================================================
 *
 *       Filename:  object.r
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  19.03.10
 *       Revision:  
 *       Compiler:  GCC 4.4.3
 *
 *         Author:  Yang Zhang, imyeyeslove@gmail.com
 *        Company:  
 *
 * =====================================================================================
 */


#ifndef		OBJECT_R
#define		OBJECT_R

#ifndef		extern
#ifndef		OBJECT_IMPLEMENTATION
#define		extern		extern
#else
#define		extern
#endif
#endif

struct object {
	const struct class * class;
};

struct class {
	const struct object _;
	struct class * super;
	const char * name;
	size_t size;

	void * (* ctor) (void * self, va_list * app);
	void * (* dtor) (void * self);
};

extern const void *class_of(const void *);
extern const void *super_of(const void *);
extern size_t size_of(void *);
extern const char *name_of(void *);

extern void *ctor(void *, va_list *);
extern void *dtor(void *);
extern void *super_ctor(const void *, void *, va_list *);
extern void *super_dtor(void *);

#endif
