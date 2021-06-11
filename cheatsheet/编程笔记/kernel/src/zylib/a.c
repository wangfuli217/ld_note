# 1 "point.c"
# 1 "<built-in>"
# 1 "<命令行>"
# 1 "point.c"
# 20 "point.c"
# 1 "object.r" 1
# 31 "object.r"
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
# 21 "point.c" 2






# 1 "point.h" 1
# 22 "point.h"
# 1 "object.h" 1
# 23 "point.h" 2
# 32 "point.h"
extern void init_point(void);
extern void draw(const void *);
# 28 "point.c" 2
# 1 "point.r" 1
# 24 "point.r"
struct point{
 const struct object _;
 int x;
 int y;
};

struct class_point {
 const struct class _;
 void (* draw) (const void *);
};

extern void super_draw(const void *);
# 29 "point.c" 2

static void *class_point_ctor(void *, va_list *);
static void *point_ctor(void *, va_list *);
static void point_draw(const void *);

static void * class_point_ctor(void * _cls_pnt, va_list * arg)
{
 struct class_point * cls_pnt = super_ctor(class_point, _cls_pnt, arg);

 typedef void * (* funcp) ();
 funcp selector;
 while (selector = va_arg(ap, funcp)) {
  funcp method = va_arg(ap, funcp);
  switch (selector) {
  case draw:
   cla->draw = method;
   break;
  default:
   break;
  }
 }

 return cls_pnt;
}







void draw(const void * _obj)
{

 const struct class * cla = class_of(_obj);
 cla->draw(_obj);
}







void super_draw(const void * _obj)
{
 const struct class * cla = super_of(_obj);
 cla->draw(_obj);
}
# 86 "point.c"
static void * point_ctor(void * _pnt, va_list * arg)
{
 struct point * obj = super_of(_pnt);
 obj->x = va_arg(*arg, int);
 obj->y = va_arg(*arg, int);
 return obj;
}
# 101 "point.c"
static void point_draw(const void * _obj)
{
 const struct point * point = _obj;
 printf("x: %d, y: %d\n", point->x, point->y);
}

void init_point()
{
 if (! class_point) {
  void * class_point = new(class, class, "ClassPoint",
      sizeof(struct class_point),
      ctor, class_point_ctor, 0);
 }
 if (! point) {
  void * point = new(class_point, object "Point",
       sizeof(struct point),
       ctor, point_ctor
       draw, point_draw, 0);
 }
}
