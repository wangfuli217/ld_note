void f(void *p)
{
    assert(p != NULL);
    /* more code */
    // Assertion failed: p != NULL, ﬁle main.c, line 5
}

void f(void *p)
{
    assert(p != NULL && "function f: p cannot be NULL");
    // Assertion failed: p != NULL && "function f: p cannot be NULL", ﬁle main.c, line 5
    /* more code */
}

// Assertion of Unreachable Code
switch (color) {
    case COLOR_RED:
    case COLOR_GREEN:
    case COLOR_BLUE:
        break;
    default:
        assert(0);
}

if (color == COLOR_RED || color == COLOR_GREEN) {
   ...
} else if (color == COLOR_BLUE) {
   ...
} else {
   assert(0), abort();
}