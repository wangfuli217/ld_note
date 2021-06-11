#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>


#define FLAG_LIST(_)                   \
	_(InWorklist)                      \
    _(EmittedAtUses)                   \
    _(LoopInvariant)                   \
    _(Commutative)                     \
    _(Movable)                         \
    _(Lowered)                         \
    _(Guard)

#define DEFINE_FLAG(flag) flag,
   enum Flag {
       None = 0,
       FLAG_LIST(DEFINE_FLAG)
       Total
   };
#undef DEFINE_FLAG

#define FLAG_ACCESSOR(flag) \
bool is##flag() const {\
    return hasFlags(1 << flag);\
}\
void set##flag() {\
    JS_ASSERT(!hasFlags(1 << flag));\
    setFlags(1 << flag);\
}\
void setNot##flag() {\
    JS_ASSERT(hasFlags(1 << flag));\
    removeFlags(1 << flag);\
}
 
FLAG_LIST(FLAG_ACCESSOR)
#undef FLAG_ACCESSOR

int main(int argc, char **argv)
{
	printf("hello world 中文\n");
	return 0;
}
