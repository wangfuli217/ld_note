/**
 * Compound literals.  ( since C99 )
 * Constructs an unnamed object of specified type in-place, used when a variable
 * of array, struct, or union type would be needed only once.
 * Syntax:
 *      ( type ) { initializer-list }
 *      where
 *                  type - a type name specifying any complete object type or an
 *                         array of unkown size, but not a VLA
 *      initializer-list - list of initializers suitable for initialization of
 *                         an object of <type>
 * Explanation:
 *      The compound literal expression constructs an unnamed object of the type
 *      specified by <type> and initializes it as specified by
 *      <initializer-list>.
 *      The type of the compound literal is <type> (except when <type> is an
 *      array of unknown size; its size is deduced from the <initializer-list>
 *      as in {array initialization}).
 *      The value category of a compound literal is lvalue (its address can be
 *      taken).
 *      The unnamed object to which the compound literal evaluates has static
 *      {storage duration} if the compound literal occurs at file scope and
 *      automatic {storage duration} if the compound literal occurs at block
 *      scope (in which case the object's {lifetime} ends in the enclosing
 *      blcok).
 * Notes:
 *      Compound literals of const-qualified or wide character array types may
 *      share storage with string literals.
 *      Each compound literal creates only a single objects in its scope
 *      Because compound literals are unnamed, a compound literal cannot
 *      reference itself (a named struct can include a pointer to itself).
 *      Although the syntax of a compound literal is similar to a {cast}, the
 *      important distinction is that a cast is a non-lvalue expression while a
 *      compound literal is an lvalue.
 * Compilation:
 * 	gcc compound_literals -std=c99 (Won't compiled!)
 * Created@:
 * 	2015-07-30
 * Last-modified:
 */



int f(void)
{
    struct s {int i;} *p = 0, *q;
    int j = 0;
again:
    q = p, p = &((struct s) { j++});
    if (j < 2) goto again;  // note; if a loop were used, it would end scope here,
                            // which would terminate the lifetime of the
                            // compound literal leaving p as a dangling pointer
    return p == q && q->i == 1; // always returns 1
}

int *p = (int[]){1, 4}; // creates an unnamed static array of type int[2]
                        // initializes the array to the values {2, 4}
                        // creates pointer p to point at the first element of
                        // the array
const float *pc = (const float[]){1e0, 1e1, 1e2}; // read-only compound literals

int main(void)
{
    (const char[]){"abc"} == "abc"; // might be 1 or 0, implementation-defined

    int n = 2, *p = &n;
    p = (int [2]){*p};  // creates an unnamed automatic array of type int[2]
                        // initializes the first element to the value formerly
                        // held in *p. initializes the second element to zero
                        // stores the address of the first element in p
    struct point { double x, y; };
    void drawline1(struct point from, struct point to);
    void drawline2(struct point *from, struct point *to);
    drawline1((struct point){.x=1, .y=1},  // creates two structs with block scope
              (struct point){.x=3, .y=4}); // and calls drawline1, passing them by value
    drawline2(&(struct point){.x=1, .y=1}, // creates two structs with block scope
              &(struct point){.x=3, .y=4});// and calls drawline2, passing their address
}