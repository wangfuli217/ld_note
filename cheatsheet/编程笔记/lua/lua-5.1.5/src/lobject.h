/*
** $Id: lobject.h,v 2.20.1.2 2008/08/06 13:29:48 roberto Exp $
** Type definitions for Lua objects
** See Copyright Notice in lua.h
*/


#ifndef lobject_h
#define lobject_h


#include <stdarg.h>


#include "llimits.h"
#include "lua.h"


/* tags for values visible from Lua */
#define LAST_TAG	LUA_TTHREAD

#define NUM_TAGS	(LAST_TAG+1)


/*
** Extra tags for non-values
*/
#define LUA_TPROTO	(LAST_TAG+1)
#define LUA_TUPVAL	(LAST_TAG+2)
#define LUA_TDEADKEY	(LAST_TAG+3)


/*
** Union of all collectable objects
*/
typedef union GCObject GCObject;


/*
** Common Header for all collectable objects (in macro form, to be
** included in other objects)
*/
/// 需要gc的数据类型,都会有一个CommonHeader的成员,并且这个成员在结构体定义的最开始部分
#define CommonHeader	GCObject *next; lu_byte tt; lu_byte marked
//next(指向下一个gc对象),
//tt 表示类型，
//marked用来标记这个对象的使用。

/*
** Common header in struct form
*/
/// 在Lua中就使用了一个GCObject的union将所有可gc类型囊括了进来:
typedef struct GCheader {
  CommonHeader;
} GCheader;


/*
** Union of all Lua values
*/
typedef union {
  GCObject *gc;   //  gc用于表示需要垃圾回收的一些值，比如string，table等等。
  void *p;        //  p用于表示 light userdata它是不会被gc的
  lua_Number n;   //  n表示double
  int b;          //  b表示boolean
} Value;


/*
** Tagged Values
*/
// 其中tt表示类型，value也就是lua中对象的表示。
#define TValuefields	Value value; int tt
/*
堆栈中可以根据情况分为一下几种类型：
1、双精度浮点数：double d__;
2、复合类型，通过tt__来表示类型；
3、复合类型中分为两种：可回收类型和不可回收类型；
4、可回收类型可以是：TString、Udata、Closure、Table、Proto、UpVal、lua_State
5、不可回收类型可以是：light userdata、booleans、light C functions
*/

// 堆栈中的元素
typedef struct lua_TValue {
  TValuefields;  
} TValue;

/* 类型判断相关的宏如下 */
/* Macros to test type */
#define ttisnil(o)	(ttype(o) == LUA_TNIL)
#define ttisnumber(o)	(ttype(o) == LUA_TNUMBER)
#define ttisstring(o)	(ttype(o) == LUA_TSTRING)
#define ttistable(o)	(ttype(o) == LUA_TTABLE)
#define ttisfunction(o)	(ttype(o) == LUA_TFUNCTION)
#define ttisboolean(o)	(ttype(o) == LUA_TBOOLEAN)
#define ttisuserdata(o)	(ttype(o) == LUA_TUSERDATA)
#define ttisthread(o)	(ttype(o) == LUA_TTHREAD)
#define ttislightuserdata(o)	(ttype(o) == LUA_TLIGHTUSERDATA)

/* version 5.2.3
1、0～3未表示类型；
2、4～5用来 表示类型的变体，例如：字符串LUA_TSTRING有两种变体（短字符串：LUA_TSHRSTR和长字符串：LUA_TLNGSTR）
3、6未用来表示是否是垃圾回收类型，其中短字符串不是可回收（#define LUA_TSHRSTR (LUA_TSTRING | (0 << 4)) ），
而长字符串为可回收类型（#define LUA_TLNGSTR (LUA_TSTRING | (1 << 4)) ）。
*/

/* 复合类型的值获取相关宏定义 */
/* Macros to access values */
#define ttype(o)	((o)->tt)
#define gcvalue(o)	check_exp(iscollectable(o), (o)->value.gc)
#define pvalue(o)	check_exp(ttislightuserdata(o), (o)->value.p)
#define nvalue(o)	check_exp(ttisnumber(o), (o)->value.n)
#define rawtsvalue(o)	check_exp(ttisstring(o), &(o)->value.gc->ts)
#define tsvalue(o)	(&rawtsvalue(o)->tsv)
#define rawuvalue(o)	check_exp(ttisuserdata(o), &(o)->value.gc->u)
#define uvalue(o)	(&rawuvalue(o)->uv)
#define clvalue(o)	check_exp(ttisfunction(o), &(o)->value.gc->cl)
#define hvalue(o)	check_exp(ttistable(o), &(o)->value.gc->h)
#define bvalue(o)	check_exp(ttisboolean(o), (o)->value.b)
#define thvalue(o)	check_exp(ttisthread(o), &(o)->value.gc->th)

#define l_isfalse(o)	(ttisnil(o) || (ttisboolean(o) && bvalue(o) == 0))

/*
** for internal debug only
*/
#define checkconsistency(obj) \
  lua_assert(!iscollectable(obj) || (ttype(obj) == (obj)->value.gc->gch.tt))

#define checkliveness(g,obj) \
  lua_assert(!iscollectable(obj) || \
  ((ttype(obj) == (obj)->value.gc->gch.tt) && !isdead(g, (obj)->value.gc)))


/* Macros to set values */
/* 复合类型值设置相关宏定义 */
#define setnilvalue(obj) ((obj)->tt=LUA_TNIL)
// lua_Number转换为TValue的宏setnvalue代码如下
#define setnvalue(obj,x) \
  { TValue *i_o=(obj); i_o->value.n=(x); i_o->tt=LUA_TNUMBER; }

#define setpvalue(obj,x) \
  { TValue *i_o=(obj); i_o->value.p=(x); i_o->tt=LUA_TLIGHTUSERDATA; }

#define setbvalue(obj,x) \
  { TValue *i_o=(obj); i_o->value.b=(x); i_o->tt=LUA_TBOOLEAN; }

#define setsvalue(L,obj,x) \
  { TValue *i_o=(obj); \
    i_o->value.gc=cast(GCObject *, (x)); i_o->tt=LUA_TSTRING; \
    checkliveness(G(L),i_o); }

#define setuvalue(L,obj,x) \
  { TValue *i_o=(obj); \
    i_o->value.gc=cast(GCObject *, (x)); i_o->tt=LUA_TUSERDATA; \
    checkliveness(G(L),i_o); }

#define setthvalue(L,obj,x) \
  { TValue *i_o=(obj); \
    i_o->value.gc=cast(GCObject *, (x)); i_o->tt=LUA_TTHREAD; \
    checkliveness(G(L),i_o); }

#define setclvalue(L,obj,x) \
  { TValue *i_o=(obj); \
    i_o->value.gc=cast(GCObject *, (x)); i_o->tt=LUA_TFUNCTION; \
    checkliveness(G(L),i_o); }

#define sethvalue(L,obj,x) \
  { TValue *i_o=(obj); \
    i_o->value.gc=cast(GCObject *, (x)); i_o->tt=LUA_TTABLE; \
    checkliveness(G(L),i_o); }

#define setptvalue(L,obj,x) \
  { TValue *i_o=(obj); \
    i_o->value.gc=cast(GCObject *, (x)); i_o->tt=LUA_TPROTO; \
    checkliveness(G(L),i_o); }




#define setobj(L,obj1,obj2) \
  { const TValue *o2=(obj2); TValue *o1=(obj1); \
    o1->value = o2->value; o1->tt=o2->tt; \
    checkliveness(G(L),o1); }


/*
** different types of sets, according to destination
*/

/* from stack to (same) stack */
#define setobjs2s	setobj
/* to stack (not from same stack) */
#define setobj2s	setobj
#define setsvalue2s	setsvalue
#define sethvalue2s	sethvalue
#define setptvalue2s	setptvalue
/* from table to same table */
#define setobjt2t	setobj
/* to table */
#define setobj2t	setobj
/* to new object */
#define setobj2n	setobj
#define setsvalue2n	setsvalue

#define setttype(obj, tt) (ttype(obj) = (tt))

// 哪些数据类型需要进行gc操作的:
// 可以看到,LUA_TSTRING(包括LUA_TSTRING)之后的数据类型,都需要进行gc操作.
#define iscollectable(o)	(ttype(o) >= LUA_TSTRING)


// 堆栈中的元素
typedef TValue *StkId;  /* index to stack elements */


/*
** String headers for string table
*/
// 将字符串通过一定的算法计算出散列值，并保存这个散列值到hash域中，然后以后的操作，
// 都是通过这个散列值来进行操作。
typedef union TString {
// 为了进行字节对齐，中间插入了L_Umaxalign，按照union的定义
// union的大小，必须是单个结构大小的整数倍，按照目前的定义，应该是double大小的整数倍。
  L_Umaxalign dummy;  /* ensures maximum alignment for strings */
  struct {
    CommonHeader;
    lu_byte reserved; // 这个变量用于标识这个字符串是否是lua虚拟机中的保留字符串。如果这个值为1，那么将不会在GC阶段 被回收，而是一直保留在系统中。只有Lua语言中的关键字才会是保留字符串。
    unsigned int hash;// 该字符串的散列值。Lua的字符串比较并不会像一般的做法那样进行逐位比较而是仅比较字符串的散列值
    size_t len;       // len为字符串的长度。
  } tsv;
} TString;


#define getstr(ts)	cast(const char *, (ts) + 1)
#define svalue(o)       getstr(rawtsvalue(o))



typedef union Udata {
  L_Umaxalign dummy;  /* ensures maximum alignment for `local' udata */
  struct {
    CommonHeader;
    struct Table *metatable;
    struct Table *env;
    size_t len;
  } uv;
} Udata;




/*
** Function Prototypes
*/
typedef struct Proto {
  CommonHeader;
  TValue *k;  /* constants used by the function */
  Instruction *code;
  struct Proto **p;  /* functions defined inside the function */
  int *lineinfo;  /* map from opcodes to source lines */
  struct LocVar *locvars;  /* information about local variables */
  TString **upvalues;  /* upvalue names */
  TString  *source;
  int sizeupvalues;
  int sizek;  /* size of `k' */
  int sizecode;
  int sizelineinfo;
  int sizep;  /* size of `p' */
  int sizelocvars;
  int linedefined;
  int lastlinedefined;
  GCObject *gclist;
  lu_byte nups;  /* number of upvalues */
  lu_byte numparams;
  lu_byte is_vararg;
  lu_byte maxstacksize;
} Proto;


/* masks for new-style vararg */
#define VARARG_HASARG		1
#define VARARG_ISVARARG		2
#define VARARG_NEEDSARG		4


typedef struct LocVar {
  TString *varname;
  int startpc;  /* first point where variable is active */
  int endpc;    /* first point where variable is dead */
} LocVar;



/*
** Upvalues
*/

typedef struct UpVal {
  CommonHeader;
  TValue *v;  /* points to stack or to its own value */
  union {
    TValue value;  /* the value (when closed) */
    struct {  /* double linked list (when open) */
      struct UpVal *prev;
      struct UpVal *next;
    } l;
  } u;
} UpVal;


/*
** Closures
*/

#define ClosureHeader \
	CommonHeader; lu_byte isC; lu_byte nupvalues; GCObject *gclist; \
	struct Table *env

typedef struct CClosure {
  ClosureHeader;
  lua_CFunction f;
  TValue upvalue[1];
} CClosure;


typedef struct LClosure {
  ClosureHeader;
  struct Proto *p;
  UpVal *upvals[1];
} LClosure;


typedef union Closure {
  CClosure c;
  LClosure l;
} Closure;


#define iscfunction(o)	(ttype(o) == LUA_TFUNCTION && clvalue(o)->c.isC)
#define isLfunction(o)	(ttype(o) == LUA_TFUNCTION && !clvalue(o)->c.isC)


/*
** Tables
*/
//  TKey结构是一个链表结构，用来存储hash相同的所有key，value对结构。
typedef union TKey {
  struct {
    TValuefields; // key值
    struct Node *next;  /* for chaining */ // 指向像一个相同hash值的key值；
  } nk;
  TValue tvk; // 尾部的key值；
} TKey;

// (key，value）对结构，通过key计算获得的相同hash的Node保存在一个链表中；
typedef struct Node {
/// 一个表示结点的value
  TValue i_val;
/// 一个表示结点的key
  TKey i_key;
} Node;


typedef struct Table {
  CommonHeader;
/// 这是一个byte类型的数据,用于表示在这个表中提供了哪些meta method
/// 在最开始,这个flags是空的,也就是为0,当查找了一次之后
/// 如果该表中存在某个meta method,那么将该meta method对应的flag bit置为1,
/// 这样下一次查找时只需要比较这个bit就可以知道了.每个meta method对应的bit定义在ltm.h文件中:
  lu_byte flags;  /* 1<<p means tagmethod(p) is not present */ 
/// 该Lua表Hash桶大小的log2值,同时有此可知,Hash桶数组大小一定是2的次方,
/// 即如果Hash桶数组要扩展的话,也是以每次在原大小基础上乘以2的形式扩展.
  lu_byte lsizenode;  /* log2 of size of `node' array */ // // Node数量 = 2^lsizenode 个Node结构
/// 存放该Lua表的meta表,这在后面再做讲解.
  struct Table *metatable;
/// 指向该Lua表的数组部分起始位置的指针.
  TValue *array;  /* array part */ // // 数组方式存储的Node结构
/// 指向该Lua表的Hash桶数组起始位置的指针.
  Node *node; // // Node数组，数组的索引通过Key计算hash获取
/// 指向该Lua表Hash桶数组的最后位置的指针.
  Node *lastfree;  /* any free position is before this position */ // 指向Node数组中的最后一个空闲Node，初始化为Node数组的最后一个值
/// GC相关的链表,在后面GC部分再回过头来讲解相关的内存.
  GCObject *gclist;
/// Lua表数组部分的大小.
  int sizearray;  /* size of `array' array */ // 数组方式储存的Node结构数量，即数组大小
} Table;



/*
** `module' operation for hashing (size is always a power of 2)
*/
#define lmod(s,size) \
	(check_exp((size&(size-1))==0, (cast(int, (s) & ((size)-1)))))


#define twoto(x)	(1<<(x))
#define sizenode(t)	(twoto((t)->lsizenode))


#define luaO_nilobject		(&luaO_nilobject_)

LUAI_DATA const TValue luaO_nilobject_;

#define ceillog2(x)	(luaO_log2((x)-1) + 1)

LUAI_FUNC int luaO_log2 (unsigned int x);
LUAI_FUNC int luaO_int2fb (unsigned int x);
LUAI_FUNC int luaO_fb2int (int x);
LUAI_FUNC int luaO_rawequalObj (const TValue *t1, const TValue *t2);
LUAI_FUNC int luaO_str2d (const char *s, lua_Number *result);
LUAI_FUNC const char *luaO_pushvfstring (lua_State *L, const char *fmt,
                                                       va_list argp);
LUAI_FUNC const char *luaO_pushfstring (lua_State *L, const char *fmt, ...);
LUAI_FUNC void luaO_chunkid (char *out, const char *source, size_t len);


#endif

