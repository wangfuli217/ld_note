Suffix  Type            Examples
none    double          3.1415926 -3E6
f, F    float           3.1415926f 2.1E-6F
l, L    long double     3.1415926L 1E126L

preﬁx   base type   encoding
none    char        platform dependent
L       wchar_t     platform dependent
u8      char        UTF-8
u       char16_t    usually UTF-16
U       char32_t    usually UTF-32

Base        Preﬁx   Example
Decimal     None      5
Octal       0         0345
Hexadecimal 0x or   0X0x12AB, 0X12AB, 0x12ab, 0x12Ab

Suffix  Explanation
L, l    long int
LL, ll  (since C99) long long int
U, u    unsigned