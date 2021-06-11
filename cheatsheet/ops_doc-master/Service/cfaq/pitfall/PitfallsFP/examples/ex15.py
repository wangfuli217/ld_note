# Example 15: Exact floating point comparison. This is often not a good
# way to compare floating point numbers.

from math import sqrt

def equal_exact(a, b):
    return a == b

print "1.0 + 2.0 == 3 is: %s" % equal_exact(1.0+2.0, 3.0)

print "sqrt(2.0)**2.0 == 2 is %s" % equal_exact(2.0, sqrt(2.0)**2.0)

print "sqrt(2.0)**2.0 is %18.16f" % sqrt(2.0)**2

