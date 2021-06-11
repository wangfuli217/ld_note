/**
 * Structure declaration
 * A struct is a type consisting of a sequence of members whose storage is
 * allocated in an order sequence (as opposed to union, which is a type
 * consisting of a sequence of members whose storage overlaps).
 * The {type specifier} for struct is identical to the union type specifier
 * except for the keyword used:
 * Syntax:
 *      struct name(optional) { struct-declaration-list }   (1)
 *      struct name                                         (2)
 *        1) Struct definition: introduces the new type struce name and defines
 *           its meaning
 *        2) If used on line of its own, as in struct <name>;, declares but
 *           doesn't define the struct name (see forward declaration below). In
 *           other contexts, names the previously-declared struct.
 *                         name - the name of the struct that's being defined
 *      struct-declaration-list - any number of variable declarations, {bit
 *                                field} declarations, and static assert 
 *                                declarations. Members of incomplete type and 
 *                                members of function type are not allowed 
 *                                (except for the flexible array member 
 *                                described below)
 * Explalnation:
 *      Within a struct object, addresses of its elements (and the addresses of
 *      the bit field allocation units) increase in order in which the members
 *      were defined. A pointer to a struct can be cast to a pointer to its
 *      first member (or, if the member is a bit field, to its allocation unit).
 *      Likewise, a pointer to the first member of a struct can be cast to a
 *      pointer to the enclosing struct. There may be unnamed padding between
 *      any two members of a struct or after the last member, but not before the
 *      first member. The size of a struct is at least as large as the sum of
 *      the sizes of its members.
 *      If a struct defines at least one named member, it is allowed to
 *      additionally declare its last member with incomplete array type. When an
 *      element of the flexible array member is accessed (in an expression that
 *      uses operator . or -> with the flexible array member's name as the
 *      right-hand-side operand), then the struct behaves as if the array member
 *      had the longest size fitting in the memory allocated for this object. If
 *      no additional storage was allocated, it behaves as if an array with 1
 *      element, except that the behavior is undefined if that element is
 *      accessed or a pointer one past that element is produced. Initialization,
 *      sizeof, and the assignment operator ignore the flexible array member.
 *      Structures with flexible array members (or unions whose last member is
 *      a structure with flexible array member) cannot appear as array elements
 *      or as members of other structures.
 *      Similar to union, an unnamed member of a struct whose type is a struct
 *      without name is known as anonymous struct. Every member of an anonumous
 *      struct is considered to be a member of the enclosing struct or union.
 *      This applies recursively if the enclosing struct or union is also
 *      anonymous.
 *      Similar to union, the behavior of the program is undefined if struct is
 *      defined without any named members (including those obtained via
 *      anonymous nested structs or unions)
 * Forward declaration:
 *      A declaration of the following form
 *      struct name;
 *      hides any previously declared meaning for the name <name> in the tag
 *      name space and declares name as a new struct name in current scope,
 *      which will be defined later. Until the definition appears, this struct
 *      name has incomplete type.
 *      This allows structs that refer to each other.
 *      Note that a new struct name may also be introduced just by using a
 *      struct tag within another declaration, but if a previously declared
 *      struct with the same name exists in the tag {name space}, the tag would
 *      refer to that name.
 * Note:
 *      See { struct initialization } for the rules of regarding the
 *      initializers for structs.
 *      Because members of incomplete type are not allowed, and a struct type is
 *      not complete until the end of the definition, a struct cannot have a
 *      member of its own type. A pointer to its own type is allowed, and is
 *      commonly used to implement nodes in linked list or trees.
 *      Because a struct declaration does not establish scope, nested types,
 *      enumerations and enumerators is introduced by declarations within
 *      <struct-declaration-list> are visible in the surrounding scope where the
 *      struct is defined.
 */

// flexible array member
void f()
{
    struct s { int n; double d[]; }; // s.d is a flexible array member

    struct s t1 = { 0 };         // ok, d is as if double d[1], but UB to access
    struct s t2 = { 1, { 4.2} }; // error: initialization ignores flexible array

    // if sizeof (double) == 8
    struct s *s1 = malloc(sizeof (struct s) + 64); // as if d was double d[8]
    struct s *s2 = malloc(sizeof (struct s) + 46); // as if d was double d[5]

    s1 = malloc(sizeof (struct s) + 10); // now as if d was double[1]
    s2 = malloc(sizeof (struct s) + 6);  // same but UB to access
    double *dp = &(s1->d[0]);   // ok
    *dp = 42;                   // ok
    dp = &(s2->d[0]);           // ok
    *dp = 42;                   // undefined

    *s1 = *s2; // only copies s.n, not any element of s.d
               // except those caught in sizeof (struct s)
} 

// anonymous struct
void g()
{
    struct v {
        union { // anonymous union
            struct { int i, j; };   // anonymous struct
            struct { long k, l; } w;
        };
        int m;
    } v1;

    v1.i = 2;   // valid
    v1.k = 3;   // invalid: inner structure is not anonymous
    v1.w.k = 5; // valid
}

// forward declaration
void h()
{
    struct y;
    struct x { struct y *p; /* ... */ };
    struct y { struct x *p; /* ... */ };

    struct s* p = null; // tag naming an unknown struct declares it
    struct s { int a; }; // definition for the struct pointed by p
    {
        struct s; // forward declaration of a new, local struct s
                  // this hides outer scope struct s until the end of this block
        struct s* p; // pointer to local struct s
                     // without the forward declaration above,
                     // this would point at the outer-scope s
        struct s { char *p; }; // definitions of the local struct s
    }
}

int main()
{
    struct car { char *make; char *model; int year; }; // declares the struct type
    // declares and initializes an object of a previously-declared struct type
    struct car c = {.year = 1923, .make="Nash", .model="48 Sports Touring Car"};

    // declares a struct type, an object of that type, and a pointer to it
    struct spaceship { char *make; char *model; char *year; }
        ship = {"Incom Corporation", "T-65 X-wing starfighter", "128 ABY"},
        *pship = &ship;

    // A pointer to a struct can be cast to a pointer to its first member,
    // and vice versa
    char* pmake = (char *) &ship;
    pship = (struct spaceship*) pmake;
}